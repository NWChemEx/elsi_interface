! Copyright (c) 2015-2018, the ELSI team.
! All rights reserved.
!
! This file is part of ELSI and is distributed under the BSD 3-clause license,
! which may be found in the LICENSE file in the ELSI root directory.

!>
!! This module performs parallel matrix IO.
!!
module ELSI_MAT_IO

   use, intrinsic :: ISO_C_BINDING
   use ELSI_CONSTANTS,  only: HEADER_SIZE,BLACS_DENSE,PEXSI_CSC,WRITE_FILE,&
                              REAL_DATA,CMPLX_DATA,FILE_VERSION,PEXSI_SOLVER,&
                              SIPS_SOLVER,MULTI_PROC,SINGLE_PROC,UNSET
   use ELSI_DATATYPE,   only: elsi_handle,elsi_rw_handle
   use ELSI_IO,         only: elsi_say
   use ELSI_MALLOC,     only: elsi_allocate,elsi_deallocate
   use ELSI_MAT_REDIST, only: elsi_sips_to_blacs_dm_real,&
                              elsi_sips_to_blacs_dm_cmplx,&
                              elsi_blacs_to_sips_hs_real,&
                              elsi_blacs_to_sips_hs_cmplx
   use ELSI_MPI,        only: mpi_sum,mpi_real8,mpi_complex16,mpi_integer4,&
                              mpi_mode_rdonly,mpi_mode_wronly,mpi_mode_create,&
                              mpi_info_null,mpi_status_ignore
   use ELSI_PRECISION,  only: r8,i4,i8
   use ELSI_SETUP,      only: elsi_init,elsi_set_mpi,elsi_set_blacs,&
                              elsi_set_csc,elsi_cleanup
   use ELSI_TIMINGS,    only: elsi_get_time
   use ELSI_UTILS,      only: elsi_get_local_nnz_real,elsi_get_local_nnz_cmplx

   implicit none

   private

   public :: elsi_init_rw
   public :: elsi_finalize_rw
   public :: elsi_set_rw_mpi
   public :: elsi_set_rw_blacs
   public :: elsi_set_rw_csc
   public :: elsi_set_rw_output
   public :: elsi_set_rw_write_unit
   public :: elsi_set_rw_zero_def
   public :: elsi_set_rw_header
   public :: elsi_get_rw_header
   public :: elsi_read_mat_dim
   public :: elsi_read_mat_dim_sparse
   public :: elsi_read_mat_real
   public :: elsi_read_mat_real_sparse
   public :: elsi_read_mat_complex
   public :: elsi_read_mat_complex_sparse
   public :: elsi_write_mat_real
   public :: elsi_write_mat_real_sparse
   public :: elsi_write_mat_complex
   public :: elsi_write_mat_complex_sparse

contains

!>
!! This routine initializes a handle for reading and writing matrices.
!!
subroutine elsi_init_rw(rw_h,task,parallel_mode,n_basis,n_electron)

   implicit none

   type(elsi_rw_handle), intent(out) :: rw_h          !< Handle
   integer(kind=i4),     intent(in)  :: task          !< READ_MAT,WRITE_MAT
   integer(kind=i4),     intent(in)  :: parallel_mode !< SINGLE_PROC,MULTI_PROC
   integer(kind=i4),     intent(in)  :: n_basis       !< Number of basis functions
   real(kind=r8),        intent(in)  :: n_electron    !< Number of electrons

   character(len=40), parameter :: caller = "elsi_init_rw"

   ! For safety
   call elsi_reset_rw_handle(rw_h)

   rw_h%handle_init   = .true.
   rw_h%rw_task       = task
   rw_h%parallel_mode = parallel_mode
   rw_h%n_basis       = n_basis
   rw_h%n_electrons   = n_electron

   if(parallel_mode == SINGLE_PROC) then
      rw_h%n_lrow  = n_basis
      rw_h%n_lcol  = n_basis
      rw_h%myid    = 0
      rw_h%n_procs = 1
   endif

end subroutine

!>
!! This routine finalizes a handle.
!!
subroutine elsi_finalize_rw(rw_h)

   implicit none

   type(elsi_rw_handle), intent(inout) :: rw_h !< Handle

   character(len=40), parameter :: caller = "elsi_finalize_rw"

   call elsi_check_rw_handle(rw_h,caller)
   call elsi_reset_rw_handle(rw_h)

end subroutine

!>
!! This routine sets the MPI communicator.
!!
subroutine elsi_set_rw_mpi(rw_h,mpi_comm)

   implicit none

   type(elsi_rw_handle), intent(inout) :: rw_h     !< Handle
   integer(kind=i4),     intent(in)    :: mpi_comm !< Communicator

   integer(kind=i4) :: ierr

   character(len=40), parameter :: caller = "elsi_set_rw_mpi"

   call elsi_check_rw_handle(rw_h,caller)

   if(rw_h%parallel_mode == MULTI_PROC) then
      rw_h%mpi_comm = mpi_comm

      call MPI_Comm_rank(mpi_comm,rw_h%myid,ierr)
      call MPI_Comm_size(mpi_comm,rw_h%n_procs,ierr)

      rw_h%mpi_ready = .true.
   endif

end subroutine

!>
!! This routine sets the BLACS context and the block size.
!!
subroutine elsi_set_rw_blacs(rw_h,blacs_ctxt,block_size)

   implicit none

   type(elsi_rw_handle), intent(inout) :: rw_h       !< Handle
   integer(kind=i4),     intent(in)    :: blacs_ctxt !< BLACS context
   integer(kind=i4),     intent(in)    :: block_size !< Block size

   integer(kind=i4) :: n_prow
   integer(kind=i4) :: n_pcol
   integer(kind=i4) :: my_prow
   integer(kind=i4) :: my_pcol

   integer(kind=i4), external :: numroc

   character(len=40), parameter :: caller = "elsi_set_rw_blacs"

   call elsi_check_rw_handle(rw_h,caller)

   if(rw_h%parallel_mode == MULTI_PROC) then
      rw_h%blacs_ctxt = blacs_ctxt
      rw_h%blk        = block_size

      if(rw_h%rw_task == WRITE_FILE) then
         ! Get processor grid information
         call BLACS_Gridinfo(rw_h%blacs_ctxt,n_prow,n_pcol,my_prow,my_pcol)

         ! Get local size of matrix
         rw_h%n_lrow = numroc(rw_h%n_basis,rw_h%blk,my_prow,0,n_prow)
         rw_h%n_lcol = numroc(rw_h%n_basis,rw_h%blk,my_pcol,0,n_pcol)
      endif

      rw_h%blacs_ready = .true.
   endif

end subroutine

!>
!! This routine sets the sparsity pattern.
!!
subroutine elsi_set_rw_csc(rw_h,nnz_g,nnz_l_sp,n_lcol_sp)

   implicit none

   type(elsi_rw_handle), intent(inout) :: rw_h      !< Handle
   integer(kind=i4),     intent(in)    :: nnz_g     !< Global number of nonzeros
   integer(kind=i4),     intent(in)    :: nnz_l_sp  !< Local number of nonzeros
   integer(kind=i4),     intent(in)    :: n_lcol_sp !< Local number of columns

   character(len=40), parameter :: caller = "elsi_set_rw_csc"

   call elsi_check_rw_handle(rw_h,caller)

   rw_h%nnz_g     = nnz_g
   rw_h%nnz_l_sp  = nnz_l_sp
   rw_h%n_lcol_sp = n_lcol_sp

end subroutine

!>
!! This routine sets ELSI output level.
!!
subroutine elsi_set_rw_output(rw_h,out_level)

   implicit none

   type(elsi_rw_handle), intent(inout) :: rw_h      !< Handle
   integer(kind=i4),     intent(in)    :: out_level !< Output level

   character(len=40), parameter :: caller = "elsi_set_rw_output"

   call elsi_check_rw_handle(rw_h,caller)

   if(out_level <= 0) then
      rw_h%print_info = .false.
      rw_h%print_mem  = .false.
   elseif(out_level == 1) then
      rw_h%print_info = .true.
      rw_h%print_mem  = .false.
   elseif(out_level == 2) then
      rw_h%print_info = .true.
      rw_h%print_mem  = .false.
   else
      rw_h%print_info = .true.
      rw_h%print_mem  = .true.
   endif

end subroutine

!>
!! This routine sets the unit to be used by ELSI output.
!!
subroutine elsi_set_rw_write_unit(rw_h,write_unit)

   implicit none

   type(elsi_rw_handle), intent(inout) :: rw_h       !< Handle
   integer(kind=i4),     intent(in)    :: write_unit !< Unit

   character(len=40), parameter :: caller = "elsi_set_rw_write_unit"

   call elsi_check_rw_handle(rw_h,caller)

   rw_h%print_unit = write_unit

end subroutine

!>
!! This routine sets the threshold to define "zero".
!!
subroutine elsi_set_rw_zero_def(rw_h,zero_def)

   implicit none

   type(elsi_rw_handle), intent(inout) :: rw_h     !< Handle
   real(kind=r8),        intent(in)    :: zero_def !< Zero tolerance

   character(len=40), parameter :: caller = "elsi_set_rw_zero_def"

   call elsi_check_rw_handle(rw_h,caller)

   rw_h%zero_def = zero_def

end subroutine

!>
!! This routine sets a matrix file header.
!!
subroutine elsi_set_rw_header(rw_h,header_user)

   implicit none

   type(elsi_rw_handle), intent(inout) :: rw_h           !< Handle
   integer(kind=i4),     intent(in)    :: header_user(8) !< User's header

   character(len=40), parameter :: caller = "elsi_set_rw_header"

   call elsi_check_rw_handle(rw_h,caller)

   rw_h%header_user = header_user

end subroutine

!>
!! This routine gets a matrix file header.
!!
subroutine elsi_get_rw_header(rw_h,header_user)

   implicit none

   type(elsi_rw_handle), intent(in)  :: rw_h           !< Handle
   integer(kind=i4),     intent(out) :: header_user(8) !< User's header

   character(len=40), parameter :: caller = "elsi_get_rw_header"

   call elsi_check_rw_handle(rw_h,caller)

   header_user = rw_h%header_user

end subroutine

!>
!! This routine checks whether a handle has been properly initialized for
!! reading and writing matrices.
!!
subroutine elsi_check_rw_handle(rw_h,caller)

   implicit none

   type(elsi_rw_handle), intent(in) :: rw_h   !< Handle
   character(len=*),     intent(in) :: caller !< Caller

   if(.not. rw_h%handle_init) then
      call elsi_rw_stop(" Invalid handle! Not initialized.",rw_h,caller)
   endif

end subroutine

!>
!! This routine resets a handle.
!!
subroutine elsi_reset_rw_handle(rw_h)

   implicit none

   type(elsi_rw_handle), intent(inout) :: rw_h !< Handle

   character(len=40), parameter :: caller = "elsi_reset_rw_handle"

   rw_h%handle_init    = .false.
   rw_h%rw_task        = UNSET
   rw_h%parallel_mode  = UNSET
   rw_h%print_info     = .false.
   rw_h%print_mem      = .false.
   rw_h%print_unit     = 6
   rw_h%myid           = UNSET
   rw_h%n_procs        = UNSET
   rw_h%mpi_comm       = UNSET
   rw_h%mpi_ready      = .false.
   rw_h%blacs_ctxt     = UNSET
   rw_h%blk            = UNSET
   rw_h%n_lrow         = UNSET
   rw_h%n_lcol         = UNSET
   rw_h%blacs_ready    = .false.
   rw_h%nnz_g          = UNSET
   rw_h%nnz_l_sp       = UNSET
   rw_h%n_lcol_sp      = UNSET
   rw_h%zero_def       = 1.0e-15_r8
   rw_h%n_electrons    = 0.0_r8
   rw_h%n_basis        = UNSET
   rw_h%header_user    = UNSET

end subroutine

!>
!! Clean shutdown in case of errors.
!!
subroutine elsi_rw_stop(info,rw_h,caller)

   implicit none

   character(len=*),     intent(in) :: info   !< Error message
   type(elsi_rw_handle), intent(in) :: rw_h   !< Handle
   character(len=*),     intent(in) :: caller !< Caller

   character(len=200) :: info_str
   integer(kind=i4)   :: ierr

   if(rw_h%mpi_ready) then
      write(info_str,"(A,I7,5A)") "**Error! MPI task ",rw_h%myid," in ",&
         trim(caller),": ",trim(info)," Exiting..."
      write(rw_h%print_unit,"(A)") trim(info_str)

      if(rw_h%n_procs > 1) then
         call MPI_Abort(rw_h%mpi_comm,0,ierr)
      endif
   else
      write(info_str,"(5A)") "**Error! ",trim(caller),": ",trim(info),&
         " Exiting..."
      write(rw_h%print_unit,"(A)") trim(info_str)
   endif

   stop

end subroutine

!>
!! This routine reads the dimensions of a 2D block-cyclic dense matrix from
!! file.
!!
subroutine elsi_read_mat_dim(rw_h,f_name,n_electron,n_basis,n_lrow,n_lcol)

   implicit none

   type(elsi_rw_handle), intent(inout) :: rw_h       !< Handle
   character(*),         intent(in)    :: f_name     !< File name
   real(kind=r8),        intent(out)   :: n_electron !< Number of electrons
   integer(kind=i4),     intent(out)   :: n_basis    !< Matrix size
   integer(kind=i4),     intent(out)   :: n_lrow     !< Local number of rows
   integer(kind=i4),     intent(out)   :: n_lcol     !< Local number of columns

   character(len=40), parameter :: caller = "elsi_read_mat_dim"

   if(rw_h%parallel_mode == MULTI_PROC) then
      call elsi_read_mat_dim_mp(rw_h,f_name,n_electron,n_basis,n_lrow,n_lcol)
   else
      call elsi_read_mat_dim_sp(rw_h,f_name,n_electron,n_basis,n_lrow,n_lcol)
   endif

end subroutine

!>
!! This routine reads a 2D block-cyclic dense matrix from file.
!!
subroutine elsi_read_mat_real(rw_h,f_name,mat)

   implicit none

   type(elsi_rw_handle), intent(inout) :: rw_h                         !< Handle
   character(*),         intent(in)    :: f_name                       !< File name
   real(kind=r8),        intent(out)   :: mat(rw_h%n_lrow,rw_h%n_lcol) !< Matrix

   character(len=40), parameter :: caller = "elsi_read_mat_real"

   if(rw_h%parallel_mode == MULTI_PROC) then
      call elsi_read_mat_real_mp(rw_h,f_name,mat)
   else
      call elsi_read_mat_real_sp(rw_h,f_name,mat)
   endif

end subroutine

!>
!! This routine writes a 2D block-cyclic dense matrix to file.
!!
subroutine elsi_write_mat_real(rw_h,f_name,mat)

   implicit none

   type(elsi_rw_handle), intent(in) :: rw_h                         !< Handle
   character(*),         intent(in) :: f_name                       !< File name
   real(kind=r8),        intent(in) :: mat(rw_h%n_lrow,rw_h%n_lcol) !< Matrix

   character(len=40), parameter :: caller = "elsi_write_mat_real"

   if(rw_h%parallel_mode == MULTI_PROC) then
      call elsi_write_mat_real_mp(rw_h,f_name,mat)
   else
      call elsi_write_mat_real_sp(rw_h,f_name,mat)
   endif

end subroutine

!>
!! This routine reads a 2D block-cyclic dense matrix from file.
!!
subroutine elsi_read_mat_complex(rw_h,f_name,mat)

   implicit none

   type(elsi_rw_handle), intent(inout) :: rw_h                         !< Handle
   character(*),         intent(in)    :: f_name                       !< File name
   complex(kind=r8),     intent(out)   :: mat(rw_h%n_lrow,rw_h%n_lcol) !< Matrix

   character(len=40), parameter :: caller = "elsi_read_mat_complex"

   if(rw_h%parallel_mode == MULTI_PROC) then
      call elsi_read_mat_complex_mp(rw_h,f_name,mat)
   else
      call elsi_read_mat_complex_sp(rw_h,f_name,mat)
   endif

end subroutine

!>
!! This routine writes a 2D block-cyclic dense matrix to file.
!!
subroutine elsi_write_mat_complex(rw_h,f_name,mat)

   implicit none

   type(elsi_rw_handle), intent(in) :: rw_h                         !< Handle
   character(*),         intent(in) :: f_name                       !< File name
   complex(kind=r8),     intent(in) :: mat(rw_h%n_lrow,rw_h%n_lcol) !< Matrix

   character(len=40), parameter :: caller = "elsi_write_mat_complex"

   if(rw_h%parallel_mode == MULTI_PROC) then
      call elsi_write_mat_complex_mp(rw_h,f_name,mat)
   else
      call elsi_write_mat_complex_sp(rw_h,f_name,mat)
   endif

end subroutine

!>
!! This routine reads the dimensions of a 2D block-cyclic dense matrix from
!! file.
!!
subroutine elsi_read_mat_dim_mp(rw_h,f_name,n_electron,n_basis,n_lrow,n_lcol)

   implicit none

   type(elsi_rw_handle), intent(inout) :: rw_h       !< Handle
   character(*),         intent(in)    :: f_name     !< File name
   real(kind=r8),        intent(out)   :: n_electron !< Number of electrons
   integer(kind=i4),     intent(out)   :: n_basis    !< Matrix size
   integer(kind=i4),     intent(out)   :: n_lrow     !< Local number of rows
   integer(kind=i4),     intent(out)   :: n_lcol     !< Local number of columns

   integer(kind=i4) :: ierr
   integer(kind=i4) :: f_handle
   integer(kind=i4) :: f_mode
   integer(kind=i4) :: header(HEADER_SIZE)
   integer(kind=i4) :: n_prow
   integer(kind=i4) :: n_pcol
   integer(kind=i4) :: my_prow
   integer(kind=i4) :: my_pcol
   integer(kind=i8) :: offset
   logical          :: file_ok

   integer(kind=i4), external :: numroc

   character(len=40), parameter :: caller = "elsi_read_mat_dim_mp"

   inquire(file=f_name,exist=file_ok)

   if(.not. file_ok) then
      call elsi_rw_stop(" File does not exist.",rw_h,caller)
   endif

   ! Open file
   f_mode = mpi_mode_rdonly

   call MPI_File_open(rw_h%mpi_comm,f_name,f_mode,mpi_info_null,f_handle,ierr)

   ! Read header
   if(rw_h%myid == 0) then
      offset = 0

      call MPI_File_read_at(f_handle,offset,header,HEADER_SIZE,mpi_integer4,&
              mpi_status_ignore,ierr)
   endif

   ! Close file
   call MPI_File_close(f_handle,ierr)

   ! Broadcast header
   call MPI_Bcast(header,HEADER_SIZE,mpi_integer4,0,rw_h%mpi_comm,ierr)

   n_basis    = header(4)
   n_electron = real(header(5),kind=r8)

   ! Get processor grid information
   call BLACS_Gridinfo(rw_h%blacs_ctxt,n_prow,n_pcol,my_prow,my_pcol)

   ! Get local size of matrix
   n_lrow = numroc(n_basis,rw_h%blk,my_prow,0,n_prow)
   n_lcol = numroc(n_basis,rw_h%blk,my_pcol,0,n_pcol)

   rw_h%n_basis     = n_basis
   rw_h%n_electrons = n_electron
   rw_h%n_lrow      = n_lrow
   rw_h%n_lcol      = n_lcol
   rw_h%nnz_g       = header(6)

end subroutine

!>
!! This routine reads the dimensions of a 1D block CSC matrix from file.
!!
subroutine elsi_read_mat_dim_sparse(rw_h,f_name,n_electron,n_basis,nnz_g,&
              nnz_l_sp,n_lcol_sp)

   implicit none

   type(elsi_rw_handle), intent(inout) :: rw_h       !< Handle
   character(*),         intent(in)    :: f_name     !< File name
   real(kind=r8),        intent(out)   :: n_electron !< Number of electrons
   integer(kind=i4),     intent(out)   :: n_basis    !< Matrix size
   integer(kind=i4),     intent(out)   :: nnz_g      !< Global number of nonzeros
   integer(kind=i4),     intent(out)   :: nnz_l_sp   !< Local number of nonzeros
   integer(kind=i4),     intent(out)   :: n_lcol_sp  !< Local number of columns

   integer(kind=i4) :: ierr
   integer(kind=i4) :: f_handle
   integer(kind=i4) :: f_mode
   integer(kind=i4) :: header(HEADER_SIZE)
   integer(kind=i4) :: n_lcol0
   integer(kind=i4) :: prev_nnz
   integer(kind=i8) :: offset
   logical          :: file_ok

   integer(kind=i4), allocatable :: col_ptr(:)

   character(len=40), parameter :: caller = "elsi_read_mat_dim_sparse"

   inquire(file=f_name,exist=file_ok)

   if(.not. file_ok) then
      call elsi_rw_stop(" File does not exist.",rw_h,caller)
   endif

   ! Open file
   f_mode = mpi_mode_rdonly

   call MPI_File_open(rw_h%mpi_comm,f_name,f_mode,mpi_info_null,f_handle,ierr)

   ! Read header
   if(rw_h%myid == 0) then
      offset = 0

      call MPI_File_read_at(f_handle,offset,header,HEADER_SIZE,mpi_integer4,&
              mpi_status_ignore,ierr)
   endif

   ! Broadcast header
   call MPI_Bcast(header,HEADER_SIZE,mpi_integer4,0,rw_h%mpi_comm,ierr)

   n_basis    = header(4)
   n_electron = real(header(5),kind=r8)
   nnz_g      = header(6)

   ! Compute n_lcol
   n_lcol_sp = n_basis/rw_h%n_procs
   n_lcol0   = n_lcol_sp
   if(rw_h%myid == rw_h%n_procs-1) then
      n_lcol_sp = n_basis-(rw_h%n_procs-1)*n_lcol0
   endif

   allocate(col_ptr(n_lcol_sp+1))

   ! Read column pointer
   offset = int(HEADER_SIZE,kind=i8)*4+rw_h%myid*n_lcol0*4

   call MPI_File_read_at_all(f_handle,offset,col_ptr,n_lcol_sp+1,mpi_integer4,&
           mpi_status_ignore,ierr)

   ! Close file
   call MPI_File_close(f_handle,ierr)

   if(rw_h%myid == rw_h%n_procs-1) then
      col_ptr(n_lcol_sp+1) = nnz_g+1
   endif

   ! Shift column pointer
   prev_nnz = col_ptr(1)-1
   col_ptr  = col_ptr-prev_nnz

   ! Compute nnz_l_sp
   nnz_l_sp = col_ptr(n_lcol_sp+1)-col_ptr(1)

   deallocate(col_ptr)

   rw_h%n_basis     = n_basis
   rw_h%n_electrons = n_electron
   rw_h%nnz_g       = nnz_g
   rw_h%nnz_l_sp    = nnz_l_sp
   rw_h%n_lcol_sp   = n_lcol_sp

end subroutine

!>
!! This routine reads a 2D block-cyclic dense matrix from file.
!!
subroutine elsi_read_mat_real_mp(rw_h,f_name,mat)

   implicit none

   type(elsi_rw_handle), intent(inout) :: rw_h                         !< Handle
   character(*),         intent(in)    :: f_name                       !< File name
   real(kind=r8),        intent(out)   :: mat(rw_h%n_lrow,rw_h%n_lcol) !< Matrix

   integer(kind=i4)   :: ierr
   integer(kind=i4)   :: f_handle
   integer(kind=i4)   :: f_mode
   integer(kind=i4)   :: n_lcol0
   integer(kind=i4)   :: prev_nnz
   integer(kind=i8)   :: offset
   logical            :: file_ok
   real(kind=r8)      :: t0
   real(kind=r8)      :: t1
   character(len=200) :: info_str

   integer(kind=i4), allocatable :: row_ind(:)
   integer(kind=i4), allocatable :: col_ptr(:)
   real(kind=r8),    allocatable :: nnz_val(:)

   type(elsi_handle) :: aux_h

   character(len=40), parameter :: caller = "elsi_read_mat_real_mp"

   inquire(file=f_name,exist=file_ok)

   if(.not. file_ok) then
      call elsi_rw_stop(" File does not exist.",rw_h,caller)
   endif

   call elsi_init(aux_h,PEXSI_SOLVER,MULTI_PROC,BLACS_DENSE,rw_h%n_basis,&
           rw_h%n_electrons,0)
   call elsi_set_mpi(aux_h,rw_h%mpi_comm)
   call elsi_set_blacs(aux_h,rw_h%blacs_ctxt,rw_h%blk)

   ! Output
   aux_h%output_timings   = .false.
   aux_h%myid_all         = rw_h%myid
   aux_h%stdio%print_info = rw_h%print_info
   aux_h%print_mem        = rw_h%print_mem
   aux_h%stdio%print_unit = rw_h%print_unit

   call elsi_get_time(t0)

   ! Open file
   f_mode = mpi_mode_rdonly

   call MPI_File_open(rw_h%mpi_comm,f_name,f_mode,mpi_info_null,f_handle,ierr)

   ! Compute n_lcol_sp
   rw_h%n_lcol_sp = rw_h%n_basis/rw_h%n_procs
   n_lcol0        = rw_h%n_lcol_sp
   if(rw_h%myid == rw_h%n_procs-1) then
      rw_h%n_lcol_sp = rw_h%n_basis-(rw_h%n_procs-1)*n_lcol0
   endif

   call elsi_allocate(aux_h,col_ptr,rw_h%n_lcol_sp+1,"col_ptr",caller)

   ! Read column pointer
   offset = int(HEADER_SIZE,kind=i8)*4+rw_h%myid*n_lcol0*4

   call MPI_File_read_at_all(f_handle,offset,col_ptr,rw_h%n_lcol_sp+1,&
           mpi_integer4,mpi_status_ignore,ierr)

   if(rw_h%myid == rw_h%n_procs-1) then
      col_ptr(rw_h%n_lcol_sp+1) = rw_h%nnz_g+1
   endif

   ! Shift column pointer
   prev_nnz = col_ptr(1)-1
   col_ptr  = col_ptr-prev_nnz

   ! Compute nnz_l_sp
   rw_h%nnz_l_sp = col_ptr(rw_h%n_lcol_sp+1)-col_ptr(1)

   call elsi_allocate(aux_h,row_ind,rw_h%nnz_l_sp,"row_ind",caller)

   ! Read row index
   offset = int(HEADER_SIZE,kind=i8)*4+rw_h%n_basis*4+prev_nnz*4

   call MPI_File_read_at_all(f_handle,offset,row_ind,rw_h%nnz_l_sp,&
           mpi_integer4,mpi_status_ignore,ierr)

   ! Read non-zero value
   offset = int(HEADER_SIZE,kind=i8)*4+rw_h%n_basis*4+rw_h%nnz_g*4+prev_nnz*8

   call elsi_allocate(aux_h,nnz_val,rw_h%nnz_l_sp,"nnz_val",caller)

   call MPI_File_read_at_all(f_handle,offset,nnz_val,rw_h%nnz_l_sp,mpi_real8,&
           mpi_status_ignore,ierr)

   ! Close file
   call MPI_File_close(f_handle,ierr)

   ! Redistribute matrix
   aux_h%matrix_format = PEXSI_CSC
   call elsi_set_csc(aux_h,rw_h%nnz_g,rw_h%nnz_l_sp,rw_h%n_lcol_sp,row_ind,&
           col_ptr)

   if(.not. allocated(aux_h%dm_real_pexsi)) then
      call elsi_allocate(aux_h,aux_h%dm_real_pexsi,rw_h%nnz_l_sp,&
              "dm_real_pexsi",caller)
   endif

   aux_h%dm_real_pexsi = nnz_val

   call elsi_sips_to_blacs_dm_real(aux_h,mat)

   call elsi_deallocate(aux_h,col_ptr,"col_ptr")
   call elsi_deallocate(aux_h,row_ind,"row_ind")
   call elsi_deallocate(aux_h,nnz_val,"nnz_val")

   call elsi_get_time(t1)

   write(info_str,"('  Finished reading matrix')")
   call elsi_say(aux_h,info_str,aux_h%stdio)
   write(info_str,"('  | Time :',F10.3,' s')") t1-t0
   call elsi_say(aux_h,info_str,aux_h%stdio)

   call elsi_cleanup(aux_h)

end subroutine

!>
!! This routine reads a 1D block CSC matrix from file.
!!
subroutine elsi_read_mat_real_sparse(rw_h,f_name,row_ind,col_ptr,mat)

   implicit none

   type(elsi_rw_handle), intent(inout) :: rw_h                      !< Handle
   character(*),         intent(in)    :: f_name                    !< File name
   integer(kind=i4),     intent(out)   :: row_ind(rw_h%nnz_l_sp)    !< Row index
   integer(kind=i4),     intent(out)   :: col_ptr(rw_h%n_lcol_sp+1) !< Column pointer
   real(kind=r8),        intent(out)   :: mat(rw_h%nnz_l_sp)        !< Matrix

   integer(kind=i4)   :: ierr
   integer(kind=i4)   :: f_handle
   integer(kind=i4)   :: f_mode
   integer(kind=i4)   :: n_lcol0
   integer(kind=i4)   :: prev_nnz
   integer(kind=i8)   :: offset
   logical            :: file_ok
   real(kind=r8)      :: t0
   real(kind=r8)      :: t1
   character(len=200) :: info_str

   type(elsi_handle) :: aux_h

   character(len=40), parameter :: caller = "elsi_read_mat_real_sparse"

   inquire(file=f_name,exist=file_ok)

   if(.not. file_ok) then
      call elsi_rw_stop(" File does not exist.",rw_h,caller)
   endif

   ! Output
   aux_h%myid_all         = rw_h%myid
   aux_h%stdio%print_info = rw_h%print_info
   aux_h%stdio%print_unit = rw_h%print_unit

   call elsi_get_time(t0)

   ! Open file
   f_mode = mpi_mode_rdonly

   call MPI_File_open(rw_h%mpi_comm,f_name,f_mode,mpi_info_null,f_handle,ierr)

   ! Compute n_lcol0
   n_lcol0 = rw_h%n_basis/rw_h%n_procs

   ! Read column pointer
   offset = int(HEADER_SIZE,kind=i8)*4+rw_h%myid*n_lcol0*4

   call MPI_File_read_at_all(f_handle,offset,col_ptr,rw_h%n_lcol_sp+1,&
           mpi_integer4,mpi_status_ignore,ierr)

   if(rw_h%myid == rw_h%n_procs-1) then
      col_ptr(rw_h%n_lcol_sp+1) = rw_h%nnz_g+1
   endif

   ! Shift column pointer
   prev_nnz = col_ptr(1)-1
   col_ptr  = col_ptr-prev_nnz

   ! Read row index
   offset = int(HEADER_SIZE,kind=i8)*4+rw_h%n_basis*4+prev_nnz*4

   call MPI_File_read_at_all(f_handle,offset,row_ind,rw_h%nnz_l_sp,&
           mpi_integer4,mpi_status_ignore,ierr)

   ! Read non-zero value
   offset = int(HEADER_SIZE,kind=i8)*4+rw_h%n_basis*4+rw_h%nnz_g*4+prev_nnz*8

   call MPI_File_read_at_all(f_handle,offset,mat,rw_h%nnz_l_sp,mpi_real8,&
           mpi_status_ignore,ierr)

   ! Close file
   call MPI_File_close(f_handle,ierr)

   call elsi_get_time(t1)

   write(info_str,"('  Finished reading matrix')")
   call elsi_say(aux_h,info_str,aux_h%stdio)
   write(info_str,"('  | Time :',F10.3,' s')") t1-t0
   call elsi_say(aux_h,info_str,aux_h%stdio)

end subroutine

!>
!! This routine reads a 2D block-cyclic dense matrix from file.
!!
subroutine elsi_read_mat_complex_mp(rw_h,f_name,mat)

   implicit none

   type(elsi_rw_handle), intent(inout) :: rw_h                         !< Handle
   character(*),         intent(in)    :: f_name                       !< File name
   complex(kind=r8),     intent(out)   :: mat(rw_h%n_lrow,rw_h%n_lcol) !< Matrix

   integer(kind=i4)   :: ierr
   integer(kind=i4)   :: f_handle
   integer(kind=i4)   :: f_mode
   integer(kind=i4)   :: n_lcol0
   integer(kind=i4)   :: prev_nnz
   integer(kind=i8)   :: offset
   logical            :: file_ok
   real(kind=r8)      :: t0
   real(kind=r8)      :: t1
   character(len=200) :: info_str

   integer(kind=i4), allocatable :: row_ind(:)
   integer(kind=i4), allocatable :: col_ptr(:)
   complex(kind=r8), allocatable :: nnz_val(:)

   type(elsi_handle) :: aux_h

   character(len=40), parameter :: caller = "elsi_read_mat_complex_mp"

   inquire(file=f_name,exist=file_ok)

   if(.not. file_ok) then
      call elsi_rw_stop(" File does not exist.",rw_h,caller)
   endif

   call elsi_init(aux_h,PEXSI_SOLVER,MULTI_PROC,BLACS_DENSE,rw_h%n_basis,&
           rw_h%n_electrons,0)
   call elsi_set_mpi(aux_h,rw_h%mpi_comm)
   call elsi_set_blacs(aux_h,rw_h%blacs_ctxt,rw_h%blk)

   ! Output
   aux_h%output_timings   = .false.
   aux_h%myid_all         = rw_h%myid
   aux_h%stdio%print_info = rw_h%print_info
   aux_h%print_mem        = rw_h%print_mem
   aux_h%stdio%print_unit = rw_h%print_unit

   call elsi_get_time(t0)

   ! Open file
   f_mode = mpi_mode_rdonly

   call MPI_File_open(rw_h%mpi_comm,f_name,f_mode,mpi_info_null,f_handle,ierr)

   ! Compute n_lcol_sp
   rw_h%n_lcol_sp = rw_h%n_basis/rw_h%n_procs
   n_lcol0        = rw_h%n_lcol_sp
   if(rw_h%myid == rw_h%n_procs-1) then
      rw_h%n_lcol_sp = rw_h%n_basis-(rw_h%n_procs-1)*n_lcol0
   endif

   call elsi_allocate(aux_h,col_ptr,rw_h%n_lcol_sp+1,"col_ptr",caller)

   ! Read column pointer
   offset = int(HEADER_SIZE,kind=i8)*4+rw_h%myid*n_lcol0*4

   call MPI_File_read_at_all(f_handle,offset,col_ptr,rw_h%n_lcol_sp+1,&
           mpi_integer4,mpi_status_ignore,ierr)

   if(rw_h%myid == rw_h%n_procs-1) then
      col_ptr(rw_h%n_lcol_sp+1) = rw_h%nnz_g+1
   endif

   ! Shift column pointer
   prev_nnz = col_ptr(1)-1
   col_ptr  = col_ptr-prev_nnz

   ! Compute nnz_l_sp
   rw_h%nnz_l_sp = col_ptr(rw_h%n_lcol_sp+1)-col_ptr(1)

   call elsi_allocate(aux_h,row_ind,rw_h%nnz_l_sp,"row_ind",caller)

   ! Read row index
   offset = int(HEADER_SIZE,kind=i8)*4+rw_h%n_basis*4+prev_nnz*4

   call MPI_File_read_at_all(f_handle,offset,row_ind,rw_h%nnz_l_sp,&
           mpi_integer4,mpi_status_ignore,ierr)

   ! Read non-zero value
   offset = int(HEADER_SIZE,kind=i8)*4+rw_h%n_basis*4+rw_h%nnz_g*4+prev_nnz*16

   call elsi_allocate(aux_h,nnz_val,rw_h%nnz_l_sp,"nnz_val",caller)

   call MPI_File_read_at_all(f_handle,offset,nnz_val,rw_h%nnz_l_sp,&
           mpi_complex16,mpi_status_ignore,ierr)

   ! Close file
   call MPI_File_close(f_handle,ierr)

   ! Redistribute matrix
   aux_h%matrix_format = PEXSI_CSC
   call elsi_set_csc(aux_h,rw_h%nnz_g,rw_h%nnz_l_sp,rw_h%n_lcol_sp,row_ind,&
           col_ptr)

   if(.not. allocated(aux_h%dm_cmplx_pexsi)) then
      call elsi_allocate(aux_h,aux_h%dm_cmplx_pexsi,rw_h%nnz_l_sp,&
              "dm_cmplx_pexsi",caller)
   endif

   aux_h%dm_cmplx_pexsi = nnz_val

   call elsi_sips_to_blacs_dm_cmplx(aux_h,mat)

   call elsi_deallocate(aux_h,col_ptr,"col_ptr")
   call elsi_deallocate(aux_h,row_ind,"row_ind")
   call elsi_deallocate(aux_h,nnz_val,"nnz_val")

   call elsi_get_time(t1)

   write(info_str,"('  Finished reading matrix')")
   call elsi_say(aux_h,info_str,aux_h%stdio)
   write(info_str,"('  | Time :',F10.3,' s')") t1-t0
   call elsi_say(aux_h,info_str,aux_h%stdio)

   call elsi_cleanup(aux_h)

end subroutine

!>
!! This routine reads a 1D block CSC matrix from file.
!!
subroutine elsi_read_mat_complex_sparse(rw_h,f_name,row_ind,col_ptr,mat)

   implicit none

   type(elsi_rw_handle), intent(inout) :: rw_h                      !< Handle
   character(*),         intent(in)    :: f_name                    !< File name
   integer(kind=i4),     intent(out)   :: row_ind(rw_h%nnz_l_sp)    !< Row index
   integer(kind=i4),     intent(out)   :: col_ptr(rw_h%n_lcol_sp+1) !< Column pointer
   complex(kind=r8),     intent(out)   :: mat(rw_h%nnz_l_sp)        !< Matrix

   integer(kind=i4)   :: ierr
   integer(kind=i4)   :: f_handle
   integer(kind=i4)   :: f_mode
   integer(kind=i4)   :: n_lcol0
   integer(kind=i4)   :: prev_nnz
   integer(kind=i8)   :: offset
   logical            :: file_ok
   real(kind=r8)      :: t0
   real(kind=r8)      :: t1
   character(len=200) :: info_str

   type(elsi_handle) :: aux_h

   character(len=40), parameter :: caller = "elsi_read_mat_complex_sparse"

   inquire(file=f_name,exist=file_ok)

   if(.not. file_ok) then
      call elsi_rw_stop(" File does not exist.",rw_h,caller)
   endif

   ! Output
   aux_h%myid_all         = rw_h%myid
   aux_h%stdio%print_info = rw_h%print_info
   aux_h%stdio%print_unit = rw_h%print_unit

   call elsi_get_time(t0)

   ! Open file
   f_mode = mpi_mode_rdonly

   call MPI_File_open(rw_h%mpi_comm,f_name,f_mode,mpi_info_null,f_handle,ierr)

   ! Compute n_lcol0
   n_lcol0 = rw_h%n_basis/rw_h%n_procs

   ! Read column pointer
   offset = int(HEADER_SIZE,kind=i8)*4+rw_h%myid*n_lcol0*4

   call MPI_File_read_at_all(f_handle,offset,col_ptr,rw_h%n_lcol_sp+1,&
           mpi_integer4,mpi_status_ignore,ierr)

   if(rw_h%myid == rw_h%n_procs-1) then
      col_ptr(rw_h%n_lcol_sp+1) = rw_h%nnz_g+1
   endif

   ! Shift column pointer
   prev_nnz = col_ptr(1)-1
   col_ptr  = col_ptr-prev_nnz

   ! Read row index
   offset = int(HEADER_SIZE,kind=i8)*4+rw_h%n_basis*4+prev_nnz*4

   call MPI_File_read_at_all(f_handle,offset,row_ind,rw_h%nnz_l_sp,&
           mpi_integer4,mpi_status_ignore,ierr)

   ! Read non-zero value
   offset = int(HEADER_SIZE,kind=i8)*4+rw_h%n_basis*4+rw_h%nnz_g*4+prev_nnz*16

   call MPI_File_read_at_all(f_handle,offset,mat,rw_h%nnz_l_sp,mpi_complex16,&
           mpi_status_ignore,ierr)

   ! Close file
   call MPI_File_close(f_handle,ierr)

   call elsi_get_time(t1)

   write(info_str,"('  Finished reading matrix')")
   call elsi_say(aux_h,info_str,aux_h%stdio)
   write(info_str,"('  | Time :',F10.3,' s')") t1-t0
   call elsi_say(aux_h,info_str,aux_h%stdio)

   call elsi_cleanup(aux_h)

end subroutine

!>
!! This routine writes a 2D block-cyclic dense matrix to file.
!!
subroutine elsi_write_mat_real_mp(rw_h,f_name,mat)

   implicit none

   type(elsi_rw_handle), intent(in) :: rw_h                         !< Handle
   character(*),         intent(in) :: f_name                       !< File name
   real(kind=r8),        intent(in) :: mat(rw_h%n_lrow,rw_h%n_lcol) !< Matrix

   integer(kind=i4)   :: ierr
   integer(kind=i4)   :: f_handle
   integer(kind=i4)   :: f_mode
   integer(kind=i4)   :: header(HEADER_SIZE)
   integer(kind=i4)   :: n_lcol0
   integer(kind=i4)   :: prev_nnz
   integer(kind=i8)   :: offset
   real(kind=r8)      :: t0
   real(kind=r8)      :: t1
   character(len=200) :: info_str

   real(kind=r8), allocatable :: dummy(:,:)

   type(elsi_handle) :: aux_h

   character(len=40), parameter :: caller = "elsi_write_mat_real_mp"

   call elsi_init(aux_h,SIPS_SOLVER,MULTI_PROC,BLACS_DENSE,rw_h%n_basis,&
           rw_h%n_electrons,0)
   call elsi_set_mpi(aux_h,rw_h%mpi_comm)
   call elsi_set_blacs(aux_h,rw_h%blacs_ctxt,rw_h%blk)
   call elsi_get_time(t0)

   ! Output
   aux_h%output_timings   = .false.
   aux_h%myid_all         = rw_h%myid
   aux_h%stdio%print_info = rw_h%print_info
   aux_h%print_mem        = rw_h%print_mem
   aux_h%stdio%print_unit = rw_h%print_unit

   aux_h%zero_def     = rw_h%zero_def
   aux_h%ovlp_is_unit = .true.
   aux_h%n_elsi_calls = 1
   aux_h%n_lcol_sp    = rw_h%n_basis/rw_h%n_procs
   aux_h%sips_n_elpa  = 0
   if(rw_h%myid == rw_h%n_procs-1) then
      aux_h%n_lcol_sp = rw_h%n_basis-(rw_h%n_procs-1)*aux_h%n_lcol_sp
   endif

   call elsi_allocate(aux_h,dummy,1,1,"dummy",caller)
   call elsi_blacs_to_sips_hs_real(aux_h,mat,dummy)
   call elsi_deallocate(aux_h,dummy,"dummy")

   ! Open file
   f_mode = mpi_mode_wronly+mpi_mode_create

   call MPI_File_open(rw_h%mpi_comm,f_name,f_mode,mpi_info_null,f_handle,ierr)

   ! Write header
   header(1)    = FILE_VERSION
   header(2)    = UNSET
   header(3)    = REAL_DATA
   header(4)    = rw_h%n_basis
   header(5)    = int(rw_h%n_electrons,kind=i4)
   header(6)    = aux_h%nnz_g
   header(7:8)  = UNSET
   header(9:16) = rw_h%header_user

   if(rw_h%myid == 0) then
      offset = 0

      call MPI_File_write_at(f_handle,offset,header,HEADER_SIZE,mpi_integer4,&
              mpi_status_ignore,ierr)
   endif

   ! Compute shift of column pointers
   prev_nnz = 0

   call MPI_Exscan(aux_h%nnz_l_sp,prev_nnz,1,mpi_integer4,mpi_sum,&
           rw_h%mpi_comm,ierr)

   ! Shift column pointer
   aux_h%col_ptr_pexsi = aux_h%col_ptr_pexsi+prev_nnz

   ! Write column pointer
   n_lcol0 = rw_h%n_basis/rw_h%n_procs
   offset  = int(HEADER_SIZE,kind=i8)*4+rw_h%myid*n_lcol0*4

   call MPI_File_write_at_all(f_handle,offset,aux_h%col_ptr_pexsi,&
           aux_h%n_lcol_sp,mpi_integer4,mpi_status_ignore,ierr)

   ! Write row index
   offset = int(HEADER_SIZE,kind=i8)*4+rw_h%n_basis*4+prev_nnz*4

   call MPI_File_write_at_all(f_handle,offset,aux_h%row_ind_pexsi,&
           aux_h%nnz_l_sp,mpi_integer4,mpi_status_ignore,ierr)

   ! Write non-zero value
   offset = int(HEADER_SIZE,kind=i8)*4+rw_h%n_basis*4+aux_h%nnz_g*4+prev_nnz*8

   call MPI_File_write_at_all(f_handle,offset,aux_h%ham_real_pexsi,&
           aux_h%nnz_l_sp,mpi_real8,mpi_status_ignore,ierr)

   ! Close file
   call MPI_File_close(f_handle,ierr)

   call elsi_get_time(t1)

   write(info_str,"('  Finished writing matrix')")
   call elsi_say(aux_h,info_str,aux_h%stdio)
   write(info_str,"('  | Time :',F10.3,' s')") t1-t0
   call elsi_say(aux_h,info_str,aux_h%stdio)

   call elsi_cleanup(aux_h)

end subroutine

!>
!! This routine writes a 2D block-cyclic dense matrix to file.
!!
subroutine elsi_write_mat_complex_mp(rw_h,f_name,mat)

   implicit none

   type(elsi_rw_handle), intent(in) :: rw_h                         !< Handle
   character(*),         intent(in) :: f_name                       !< File name
   complex(kind=r8),     intent(in) :: mat(rw_h%n_lrow,rw_h%n_lcol) !< Matrix

   integer(kind=i4)   :: ierr
   integer(kind=i4)   :: f_handle
   integer(kind=i4)   :: f_mode
   integer(kind=i4)   :: header(HEADER_SIZE)
   integer(kind=i4)   :: n_lcol0
   integer(kind=i4)   :: prev_nnz
   integer(kind=i8)   :: offset
   real(kind=r8)      :: t0
   real(kind=r8)      :: t1
   character(len=200) :: info_str

   complex(kind=r8), allocatable :: dummy(:,:)

   type(elsi_handle) :: aux_h

   character(len=40), parameter :: caller = "elsi_write_mat_complex_mp"

   call elsi_init(aux_h,SIPS_SOLVER,MULTI_PROC,BLACS_DENSE,rw_h%n_basis,&
           rw_h%n_electrons,0)
   call elsi_set_mpi(aux_h,rw_h%mpi_comm)
   call elsi_set_blacs(aux_h,rw_h%blacs_ctxt,rw_h%blk)
   call elsi_get_time(t0)

   ! Output
   aux_h%output_timings   = .false.
   aux_h%myid_all         = rw_h%myid
   aux_h%stdio%print_info = rw_h%print_info
   aux_h%print_mem        = rw_h%print_mem
   aux_h%stdio%print_unit = rw_h%print_unit

   aux_h%zero_def     = rw_h%zero_def
   aux_h%ovlp_is_unit = .true.
   aux_h%n_elsi_calls = 1
   aux_h%n_lcol_sp    = rw_h%n_basis/rw_h%n_procs
   aux_h%sips_n_elpa  = 0
   if(rw_h%myid == rw_h%n_procs-1) then
      aux_h%n_lcol_sp = rw_h%n_basis-(rw_h%n_procs-1)*aux_h%n_lcol_sp
   endif

   call elsi_allocate(aux_h,dummy,1,1,"dummy",caller)
   call elsi_blacs_to_sips_hs_cmplx(aux_h,mat,dummy)
   call elsi_deallocate(aux_h,dummy,"dummy")

   ! Open file
   f_mode = mpi_mode_wronly+mpi_mode_create

   call MPI_File_open(rw_h%mpi_comm,f_name,f_mode,mpi_info_null,f_handle,ierr)

   ! Write header
   header(1)    = FILE_VERSION
   header(2)    = UNSET
   header(3)    = CMPLX_DATA
   header(4)    = rw_h%n_basis
   header(5)    = int(rw_h%n_electrons,kind=i4)
   header(6)    = aux_h%nnz_g
   header(7:8)  = UNSET
   header(9:16) = rw_h%header_user

   if(rw_h%myid == 0) then
      offset = 0

      call MPI_File_write_at(f_handle,offset,header,HEADER_SIZE,mpi_integer4,&
              mpi_status_ignore,ierr)
   endif

   ! Compute shift of column pointers
   prev_nnz = 0

   call MPI_Exscan(aux_h%nnz_l_sp,prev_nnz,1,mpi_integer4,mpi_sum,&
           rw_h%mpi_comm,ierr)

   ! Shift column pointer
   aux_h%col_ptr_pexsi = aux_h%col_ptr_pexsi+prev_nnz

   ! Write column pointer
   n_lcol0 = rw_h%n_basis/rw_h%n_procs
   offset  = int(HEADER_SIZE,kind=i8)*4+rw_h%myid*n_lcol0*4

   call MPI_File_write_at_all(f_handle,offset,aux_h%col_ptr_pexsi,&
           aux_h%n_lcol_sp,mpi_integer4,mpi_status_ignore,ierr)

   ! Write row index
   offset = int(HEADER_SIZE,kind=i8)*4+rw_h%n_basis*4+prev_nnz*4

   call MPI_File_write_at_all(f_handle,offset,aux_h%row_ind_pexsi,&
           aux_h%nnz_l_sp,mpi_integer4,mpi_status_ignore,ierr)

   ! Write non-zero value
   offset = int(HEADER_SIZE,kind=i8)*4+rw_h%n_basis*4+aux_h%nnz_g*4+prev_nnz*16

   call MPI_File_write_at_all(f_handle,offset,aux_h%ham_cmplx_pexsi,&
           aux_h%nnz_l_sp,mpi_complex16,mpi_status_ignore,ierr)

   ! Close file
   call MPI_File_close(f_handle,ierr)

   call elsi_get_time(t1)

   write(info_str,"('  Finished writing matrix')")
   call elsi_say(aux_h,info_str,aux_h%stdio)
   write(info_str,"('  | Time :',F10.3,' s')") t1-t0
   call elsi_say(aux_h,info_str,aux_h%stdio)

   call elsi_cleanup(aux_h)

end subroutine

!>
!! This routine writes a 1D block CSC matrix to file.
!!
subroutine elsi_write_mat_real_sparse(rw_h,f_name,row_ind,col_ptr,mat)

   implicit none

   type(elsi_rw_handle), intent(in) :: rw_h                      !< Handle
   character(*),         intent(in) :: f_name                    !< File name
   integer(kind=i4),     intent(in) :: row_ind(rw_h%nnz_l_sp)    !< Row index
   integer(kind=i4),     intent(in) :: col_ptr(rw_h%n_lcol_sp+1) !< Column pointer
   real(kind=r8),        intent(in) :: mat(rw_h%nnz_l_sp)        !< Matrix

   integer(kind=i4)   :: ierr
   integer(kind=i4)   :: f_handle
   integer(kind=i4)   :: f_mode
   integer(kind=i4)   :: header(HEADER_SIZE)
   integer(kind=i4)   :: prev_nnz
   integer(kind=i4)   :: n_lcol0
   integer(kind=i8)   :: offset
   real(kind=r8)      :: t0
   real(kind=r8)      :: t1
   character(len=200) :: info_str

   integer(kind=i4), allocatable :: col_ptr_shift(:)

   type(elsi_handle) :: aux_h

   character(len=40), parameter :: caller = "elsi_write_mat_real_sparse"

   ! Output
   aux_h%myid_all         = rw_h%myid
   aux_h%stdio%print_info = rw_h%print_info
   aux_h%stdio%print_unit = rw_h%print_unit

   call elsi_get_time(t0)

   ! Open file
   f_mode = mpi_mode_wronly+mpi_mode_create

   call MPI_File_open(rw_h%mpi_comm,f_name,f_mode,mpi_info_null,f_handle,ierr)

   ! Write header
   header(1)    = FILE_VERSION
   header(2)    = UNSET
   header(3)    = REAL_DATA
   header(4)    = rw_h%n_basis
   header(5)    = int(rw_h%n_electrons,kind=i4)
   header(6)    = rw_h%nnz_g
   header(7:8)  = UNSET
   header(9:16) = rw_h%header_user

   if(rw_h%myid == 0) then
      offset = 0

      call MPI_File_write_at(f_handle,offset,header,HEADER_SIZE,mpi_integer4,&
              mpi_status_ignore,ierr)
   endif

   ! Compute shift of column pointers
   prev_nnz = 0

   call MPI_Exscan(rw_h%nnz_l_sp,prev_nnz,1,mpi_integer4,mpi_sum,rw_h%mpi_comm,&
           ierr)

   ! Shift column pointer
   allocate(col_ptr_shift(rw_h%n_lcol_sp+1))

   col_ptr_shift = col_ptr+prev_nnz

   ! Write column pointer
   n_lcol0 = rw_h%n_basis/rw_h%n_procs
   offset  = int(HEADER_SIZE,kind=i8)*4+rw_h%myid*n_lcol0*4

   call MPI_File_write_at_all(f_handle,offset,col_ptr_shift,rw_h%n_lcol_sp,&
           mpi_integer4,mpi_status_ignore,ierr)

   deallocate(col_ptr_shift)

   ! Write row index
   offset = int(HEADER_SIZE,kind=i8)*4+rw_h%n_basis*4+prev_nnz*4

   call MPI_File_write_at_all(f_handle,offset,row_ind,rw_h%nnz_l_sp,&
           mpi_integer4,mpi_status_ignore,ierr)

   ! Write non-zero value
   offset = int(HEADER_SIZE,kind=i8)*4+rw_h%n_basis*4+rw_h%nnz_g*4+prev_nnz*8

   call MPI_File_write_at_all(f_handle,offset,mat,rw_h%nnz_l_sp,mpi_real8,&
           mpi_status_ignore,ierr)

   ! Close file
   call MPI_File_close(f_handle,ierr)

   call elsi_get_time(t1)

   write(info_str,"('  Finished writing matrix')")
   call elsi_say(aux_h,info_str,aux_h%stdio)
   write(info_str,"('  | Time :',F10.3,' s')") t1-t0
   call elsi_say(aux_h,info_str,aux_h%stdio)

end subroutine

!>
!! This routine writes a 1D block CSC matrix to file.
!!
subroutine elsi_write_mat_complex_sparse(rw_h,f_name,row_ind,col_ptr,mat)

   implicit none

   type(elsi_rw_handle), intent(in) :: rw_h                      !< Handle
   character(*),         intent(in) :: f_name                    !< File name
   integer(kind=i4),     intent(in) :: row_ind(rw_h%nnz_l_sp)    !< Row index
   integer(kind=i4),     intent(in) :: col_ptr(rw_h%n_lcol_sp+1) !< Column pointer
   complex(kind=r8),     intent(in) :: mat(rw_h%nnz_l_sp)        !< Matrix

   integer(kind=i4)   :: ierr
   integer(kind=i4)   :: f_handle
   integer(kind=i4)   :: f_mode
   integer(kind=i4)   :: header(HEADER_SIZE)
   integer(kind=i4)   :: prev_nnz
   integer(kind=i4)   :: n_lcol0
   integer(kind=i8)   :: offset
   real(kind=r8)      :: t0
   real(kind=r8)      :: t1
   character(len=200) :: info_str

   integer(kind=i4), allocatable :: col_ptr_shift(:)

   type(elsi_handle) :: aux_h

   character(len=40), parameter :: caller = "elsi_write_mat_complex_sparse"

   ! Output
   aux_h%myid_all         = rw_h%myid
   aux_h%stdio%print_info = rw_h%print_info
   aux_h%stdio%print_unit = rw_h%print_unit

   call elsi_get_time(t0)

   ! Open file
   f_mode = mpi_mode_wronly+mpi_mode_create

   call MPI_File_open(rw_h%mpi_comm,f_name,f_mode,mpi_info_null,f_handle,ierr)

   ! Write header
   header(1)    = FILE_VERSION
   header(2)    = UNSET
   header(3)    = CMPLX_DATA
   header(4)    = rw_h%n_basis
   header(5)    = int(rw_h%n_electrons,kind=i4)
   header(6)    = rw_h%nnz_g
   header(7:8)  = UNSET
   header(9:16) = rw_h%header_user

   if(rw_h%myid == 0) then
      offset = 0

      call MPI_File_write_at(f_handle,offset,header,HEADER_SIZE,mpi_integer4,&
              mpi_status_ignore,ierr)
   endif

   ! Compute shift of column pointers
   prev_nnz = 0

   call MPI_Exscan(rw_h%nnz_l_sp,prev_nnz,1,mpi_integer4,mpi_sum,rw_h%mpi_comm,&
           ierr)

   ! Shift column pointer
   allocate(col_ptr_shift(rw_h%n_lcol_sp+1))

   col_ptr_shift = col_ptr+prev_nnz

   ! Write column pointer
   n_lcol0 = rw_h%n_basis/rw_h%n_procs
   offset  = int(HEADER_SIZE,kind=i8)*4+rw_h%myid*n_lcol0*4

   call MPI_File_write_at_all(f_handle,offset,col_ptr_shift,rw_h%n_lcol_sp,&
           mpi_integer4,mpi_status_ignore,ierr)

   deallocate(col_ptr_shift)

   ! Write row index
   offset = int(HEADER_SIZE,kind=i8)*4+rw_h%n_basis*4+prev_nnz*4

   call MPI_File_write_at_all(f_handle,offset,row_ind,rw_h%nnz_l_sp,&
           mpi_integer4,mpi_status_ignore,ierr)

   ! Write non-zero value
   offset = int(HEADER_SIZE,kind=i8)*4+rw_h%n_basis*4+rw_h%nnz_g*4+prev_nnz*16

   call MPI_File_write_at_all(f_handle,offset,mat,rw_h%nnz_l_sp,mpi_complex16,&
           mpi_status_ignore,ierr)

   ! Close file
   call MPI_File_close(f_handle,ierr)

   call elsi_get_time(t1)

   write(info_str,"('  Finished writing matrix')")
   call elsi_say(aux_h,info_str,aux_h%stdio)
   write(info_str,"('  | Time :',F10.3,' s')") t1-t0
   call elsi_say(aux_h,info_str,aux_h%stdio)

end subroutine

!>
!! This routine reads the dimensions of a 2D block-cyclic dense matrix from
!! file.
!!
subroutine elsi_read_mat_dim_sp(rw_h,f_name,n_electron,n_basis,n_lrow,n_lcol)

   implicit none

   type(elsi_rw_handle), intent(inout) :: rw_h       !< Handle
   character(*),         intent(in)    :: f_name     !< File name
   real(kind=r8),        intent(out)   :: n_electron !< Number of electrons
   integer(kind=i4),     intent(out)   :: n_basis    !< Matrix size
   integer(kind=i4),     intent(out)   :: n_lrow     !< Local number of rows
   integer(kind=i4),     intent(out)   :: n_lcol     !< Local number of columns

   integer(kind=i4) :: header(HEADER_SIZE)
   integer(kind=i8) :: offset
   logical          :: file_ok

   character(len=40), parameter :: caller = "elsi_read_mat_dim_sp"

   inquire(file=f_name,exist=file_ok)

   if(.not. file_ok) then
      call elsi_rw_stop(" File does not exist.",rw_h,caller)
   endif

   ! Open file
   open(file=f_name,unit=99,access="stream",form="unformatted")

   ! Read header
   offset = 1

   read(unit=99,pos=offset) header

   close(unit=99)

   n_basis    = header(4)
   n_electron = real(header(5),kind=r8)
   n_lrow     = n_basis
   n_lcol     = n_basis

   rw_h%n_basis     = n_basis
   rw_h%n_electrons = n_electron
   rw_h%n_lrow      = n_lrow
   rw_h%n_lcol      = n_lcol

end subroutine

!>
!! This routine reads a 2D block-cyclic dense matrix from file.
!!
subroutine elsi_read_mat_real_sp(rw_h,f_name,mat)

   implicit none

   type(elsi_rw_handle), intent(inout) :: rw_h                         !< Handle
   character(*),         intent(in)    :: f_name                       !< File name
   real(kind=r8),        intent(out)   :: mat(rw_h%n_lrow,rw_h%n_lcol) !< Matrix

   integer(kind=i4)   :: header(HEADER_SIZE)
   integer(kind=i4)   :: i_val
   integer(kind=i4)   :: i
   integer(kind=i4)   :: j
   integer(kind=i4)   :: this_nnz
   integer(kind=i8)   :: offset
   logical            :: file_ok
   real(kind=r8)      :: t0
   real(kind=r8)      :: t1
   character(len=200) :: info_str

   integer(kind=i4), allocatable :: row_ind(:)
   integer(kind=i4), allocatable :: col_ptr(:)
   real(kind=r8),    allocatable :: nnz_val(:)

   type(elsi_handle) :: aux_h

   character(len=40), parameter :: caller = "elsi_read_mat_real_sp"

   inquire(file=f_name,exist=file_ok)

   if(.not. file_ok) then
      call elsi_rw_stop(" File does not exist.",rw_h,caller)
   endif

   ! Output
   aux_h%myid_all         = rw_h%myid
   aux_h%stdio%print_info = rw_h%print_info
   aux_h%stdio%print_unit = rw_h%print_unit

   call elsi_get_time(t0)

   ! Open file
   open(file=f_name,unit=99,access="stream",form="unformatted")

   ! Read header
   offset = 1

   read(unit=99,pos=offset) header

   rw_h%nnz_g     = header(6)
   rw_h%nnz_l_sp  = header(6)
   rw_h%n_lcol_sp = rw_h%n_basis

   call elsi_allocate(aux_h,col_ptr,rw_h%n_lcol_sp+1,"col_ptr",caller)

   ! Read column pointer
   offset = int(1,kind=i8)+HEADER_SIZE*4

   read(unit=99,pos=offset) col_ptr(1:rw_h%n_lcol_sp)

   col_ptr(rw_h%n_lcol_sp+1) = rw_h%nnz_g+1

   call elsi_allocate(aux_h,row_ind,rw_h%nnz_l_sp,"row_ind",caller)

   ! Read row index
   offset = int(1,kind=i8)+HEADER_SIZE*4+rw_h%n_basis*4

   read(unit=99,pos=offset) row_ind

   ! Read non-zero value
   offset = int(1,kind=i8)+HEADER_SIZE*4+rw_h%n_basis*4+rw_h%nnz_g*4

   call elsi_allocate(aux_h,nnz_val,rw_h%nnz_l_sp,"nnz_val",caller)

   read(unit=99,pos=offset) nnz_val

   ! Close file
   close(unit=99)

   ! Convert to dense
   mat = 0.0_r8

   i_val = 0
   do i = 1,rw_h%n_basis
      this_nnz = col_ptr(i+1)-col_ptr(i)

      do j = i_val+1,i_val+this_nnz
         mat(row_ind(j),i) = nnz_val(j)
      enddo

      i_val = i_val+this_nnz
   enddo

   call elsi_deallocate(aux_h,col_ptr,"col_ptr")
   call elsi_deallocate(aux_h,row_ind,"row_ind")
   call elsi_deallocate(aux_h,nnz_val,"nnz_val")

   call elsi_get_time(t1)

   write(info_str,"('  Finished reading matrix')")
   call elsi_say(aux_h,info_str,aux_h%stdio)
   write(info_str,"('  | Time :',F10.3,' s')") t1-t0
   call elsi_say(aux_h,info_str,aux_h%stdio)

end subroutine

!>
!! This routine reads a 2D block-cyclic dense matrix from file.
!!
subroutine elsi_read_mat_complex_sp(rw_h,f_name,mat)

   implicit none

   type(elsi_rw_handle), intent(inout) :: rw_h                         !< Handle
   character(*),         intent(in)    :: f_name                       !< File name
   complex(kind=r8),     intent(out)   :: mat(rw_h%n_lrow,rw_h%n_lcol) !< Matrix

   integer(kind=i4)   :: header(HEADER_SIZE)
   integer(kind=i4)   :: i_val
   integer(kind=i4)   :: i
   integer(kind=i4)   :: j
   integer(kind=i4)   :: this_nnz
   integer(kind=i8)   :: offset
   logical            :: file_ok
   real(kind=r8)      :: t0
   real(kind=r8)      :: t1
   character(len=200) :: info_str

   integer(kind=i4), allocatable :: row_ind(:)
   integer(kind=i4), allocatable :: col_ptr(:)
   complex(kind=r8), allocatable :: nnz_val(:)

   type(elsi_handle) :: aux_h

   character(len=40), parameter :: caller = "elsi_read_mat_complex_sp"

   inquire(file=f_name,exist=file_ok)

   if(.not. file_ok) then
      call elsi_rw_stop(" File does not exist.",rw_h,caller)
   endif

   ! Output
   aux_h%myid_all         = rw_h%myid
   aux_h%stdio%print_info = rw_h%print_info
   aux_h%stdio%print_unit = rw_h%print_unit

   call elsi_get_time(t0)

   ! Open file
   open(file=f_name,unit=99,access="stream",form="unformatted")

   ! Read header
   offset = 1

   read(unit=99,pos=offset) header

   rw_h%nnz_g     = header(6)
   rw_h%nnz_l_sp  = header(6)
   rw_h%n_lcol_sp = rw_h%n_basis

   call elsi_allocate(aux_h,col_ptr,rw_h%n_lcol_sp+1,"col_ptr",caller)

   ! Read column pointer
   offset = int(1,kind=i8)+HEADER_SIZE*4

   read(unit=99,pos=offset) col_ptr(1:rw_h%n_lcol_sp)

   col_ptr(rw_h%n_lcol_sp+1) = rw_h%nnz_g+1

   call elsi_allocate(aux_h,row_ind,rw_h%nnz_l_sp,"row_ind",caller)

   ! Read row index
   offset = int(1,kind=i8)+HEADER_SIZE*4+rw_h%n_basis*4

   read(unit=99,pos=offset) row_ind

   ! Read non-zero value
   offset = int(1,kind=i8)+HEADER_SIZE*4+rw_h%n_basis*4+rw_h%nnz_g*4

   call elsi_allocate(aux_h,nnz_val,rw_h%nnz_l_sp,"nnz_val",caller)

   read(unit=99,pos=offset) nnz_val

   ! Close file
   close(unit=99)

   ! Convert to dense
   mat = (0.0_r8,0.0_r8)

   i_val = 0
   do i = 1,rw_h%n_basis
      this_nnz = col_ptr(i+1)-col_ptr(i)

      do j = i_val+1,i_val+this_nnz
         mat(row_ind(j),i) = nnz_val(j)
      enddo

      i_val = i_val+this_nnz
   enddo

   call elsi_deallocate(aux_h,col_ptr,"col_ptr")
   call elsi_deallocate(aux_h,row_ind,"row_ind")
   call elsi_deallocate(aux_h,nnz_val,"nnz_val")

   call elsi_get_time(t1)

   write(info_str,"('  Finished reading matrix')")
   call elsi_say(aux_h,info_str,aux_h%stdio)
   write(info_str,"('  | Time :',F10.3,' s')") t1-t0
   call elsi_say(aux_h,info_str,aux_h%stdio)

end subroutine

!>
!! This routine writes a 2D block-cyclic dense matrix to file.
!!
subroutine elsi_write_mat_real_sp(rw_h,f_name,mat)

   implicit none

   type(elsi_rw_handle), intent(in) :: rw_h                         !< Handle
   character(*),         intent(in) :: f_name                       !< File name
   real(kind=r8),        intent(in) :: mat(rw_h%n_lrow,rw_h%n_lcol) !< Matrix

   integer(kind=i4)   :: header(HEADER_SIZE)
   integer(kind=i4)   :: i_val
   integer(kind=i4)   :: i
   integer(kind=i4)   :: j
   integer(kind=i4)   :: this_nnz
   integer(kind=i4)   :: nnz_g
   integer(kind=i8)   :: offset
   real(kind=r8)      :: t0
   real(kind=r8)      :: t1
   character(len=200) :: info_str

   integer(kind=i4), allocatable :: row_ind(:)
   integer(kind=i4), allocatable :: col_ptr(:)
   real(kind=r8),    allocatable :: nnz_val(:)

   type(elsi_handle) :: aux_h

   character(len=40), parameter :: caller = "elsi_write_mat_real_sp"

   ! Output
   aux_h%myid_all         = rw_h%myid
   aux_h%stdio%print_info = rw_h%print_info
   aux_h%stdio%print_unit = rw_h%print_unit
   aux_h%zero_def         = rw_h%zero_def

   call elsi_get_time(t0)

   ! Compute nnz
   call elsi_get_local_nnz_real(aux_h,mat,rw_h%n_lrow,rw_h%n_lcol,nnz_g)

   ! Convert to CSC
   call elsi_allocate(aux_h,col_ptr,rw_h%n_basis+1,"col_ptr",caller)
   call elsi_allocate(aux_h,row_ind,nnz_g,"row_ind",caller)
   call elsi_allocate(aux_h,nnz_val,nnz_g,"nnz_val",caller)

   i_val   = 0
   col_ptr = 1

   do i = 1,rw_h%n_lcol
      this_nnz = 0

      do j = 1,rw_h%n_lrow
         if(abs(mat(j,i)) > rw_h%zero_def) then
            this_nnz       = this_nnz+1
            i_val          = i_val+1
            nnz_val(i_val) = mat(j,i)
            row_ind(i_val) = j
         endif
      enddo

      col_ptr(i+1) = col_ptr(i)+this_nnz
   enddo

   ! Open file
   open(file=f_name,unit=99,access="stream",form="unformatted")

   ! Write header
   header(1)    = FILE_VERSION
   header(2)    = UNSET
   header(3)    = REAL_DATA
   header(4)    = rw_h%n_basis
   header(5)    = int(rw_h%n_electrons,kind=i4)
   header(6)    = nnz_g
   header(7:8)  = UNSET
   header(9:16) = rw_h%header_user

   offset = 1
   write(unit=99,pos=offset) header

   ! Write column pointer
   offset = int(1,kind=i8)+HEADER_SIZE*4

   write(unit=99,pos=offset) col_ptr(1:rw_h%n_basis)

   ! Write row index
   offset = int(1,kind=i8)+HEADER_SIZE*4+rw_h%n_basis*4

   write(unit=99,pos=offset) row_ind

   ! Write non-zero value
   offset = int(1,kind=i8)+HEADER_SIZE*4+rw_h%n_basis*4+nnz_g*4

   write(unit=99,pos=offset) nnz_val

   ! Close file
   close(unit=99)

   call elsi_deallocate(aux_h,col_ptr,"col_ptr")
   call elsi_deallocate(aux_h,row_ind,"row_ind")
   call elsi_deallocate(aux_h,nnz_val,"nnz_val")

   call elsi_get_time(t1)

   write(info_str,"('  Finished writing matrix')")
   call elsi_say(aux_h,info_str,aux_h%stdio)
   write(info_str,"('  | Time :',F10.3,' s')") t1-t0
   call elsi_say(aux_h,info_str,aux_h%stdio)

end subroutine

!>
!! This routine writes a 2D block-cyclic dense matrix to file.
!!
subroutine elsi_write_mat_complex_sp(rw_h,f_name,mat)

   implicit none

   type(elsi_rw_handle), intent(in) :: rw_h                         !< Handle
   character(*),         intent(in) :: f_name                       !< File name
   complex(kind=r8),     intent(in) :: mat(rw_h%n_lrow,rw_h%n_lcol) !< Matrix

   integer(kind=i4)   :: header(HEADER_SIZE)
   integer(kind=i4)   :: i_val
   integer(kind=i4)   :: i
   integer(kind=i4)   :: j
   integer(kind=i4)   :: this_nnz
   integer(kind=i4)   :: nnz_g
   integer(kind=i8)   :: offset
   real(kind=r8)      :: t0
   real(kind=r8)      :: t1
   character(len=200) :: info_str

   integer(kind=i4), allocatable :: row_ind(:)
   integer(kind=i4), allocatable :: col_ptr(:)
   complex(kind=r8), allocatable :: nnz_val(:)

   type(elsi_handle) :: aux_h

   character(len=40), parameter :: caller = "elsi_write_mat_complex_sp"

   ! Output
   aux_h%myid_all         = rw_h%myid
   aux_h%stdio%print_info = rw_h%print_info
   aux_h%stdio%print_unit = rw_h%print_unit
   aux_h%zero_def         = rw_h%zero_def

   call elsi_get_time(t0)

   ! Compute nnz
   call elsi_get_local_nnz_cmplx(aux_h,mat,rw_h%n_lrow,rw_h%n_lcol,nnz_g)

   ! Convert to CSC
   call elsi_allocate(aux_h,col_ptr,rw_h%n_basis+1,"col_ptr",caller)
   call elsi_allocate(aux_h,row_ind,nnz_g,"row_ind",caller)
   call elsi_allocate(aux_h,nnz_val,nnz_g,"nnz_val",caller)

   i_val   = 0
   col_ptr = 1

   do i = 1,rw_h%n_lcol
      this_nnz = 0

      do j = 1,rw_h%n_lrow
         if(abs(mat(j,i)) > rw_h%zero_def) then
            this_nnz       = this_nnz+1
            i_val          = i_val+1
            nnz_val(i_val) = mat(j,i)
            row_ind(i_val) = j
         endif
      enddo

      col_ptr(i+1) = col_ptr(i)+this_nnz
   enddo

   ! Open file
   open(file=f_name,unit=99,access="stream",form="unformatted")

   ! Write header
   header(1)    = FILE_VERSION
   header(2)    = UNSET
   header(3)    = CMPLX_DATA
   header(4)    = rw_h%n_basis
   header(5)    = int(rw_h%n_electrons,kind=i4)
   header(6)    = nnz_g
   header(7:8)  = UNSET
   header(9:16) = rw_h%header_user

   offset = 1
   write(unit=99,pos=offset) header

   ! Write column pointer
   offset = int(1,kind=i8)+HEADER_SIZE*4

   write(unit=99,pos=offset) col_ptr(1:rw_h%n_basis)

   ! Write row index
   offset = int(1,kind=i8)+HEADER_SIZE*4+rw_h%n_basis*4

   write(unit=99,pos=offset) row_ind

   ! Write non-zero value
   offset = int(1,kind=i8)+HEADER_SIZE*4+rw_h%n_basis*4+nnz_g*4

   write(unit=99,pos=offset) nnz_val

   ! Close file
   close(unit=99)

   call elsi_deallocate(aux_h,col_ptr,"col_ptr")
   call elsi_deallocate(aux_h,row_ind,"row_ind")
   call elsi_deallocate(aux_h,nnz_val,"nnz_val")

   call elsi_get_time(t1)

   write(info_str,"('  Finished writing matrix')")
   call elsi_say(aux_h,info_str,aux_h%stdio)
   write(info_str,"('  | Time :',F10.3,' s')") t1-t0
   call elsi_say(aux_h,info_str,aux_h%stdio)

end subroutine

end module ELSI_MAT_IO
