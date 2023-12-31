! Copyright (c) 2015-2021, the ELSI team.
! All rights reserved.
!
! This file is part of ELSI and is distributed under the BSD 3-clause license,
! which may be found in the LICENSE file in the ELSI root directory.

!>
!! Perform parallel matrix IO.
!!
module ELSI_RW

   use, intrinsic :: ISO_C_BINDING
   use ELSI_CONSTANT, only: HEADER_SIZE,WRITE_FILE,REAL_DATA,CMPLX_DATA,&
       FILE_VERSION,MULTI_PROC,SINGLE_PROC,UNSET,N_PARALLEL_MODES,MASK_H
   use ELSI_DATATYPE, only: elsi_rw_handle,elsi_basic_t,elsi_param_t
   use ELSI_MALLOC, only: elsi_allocate,elsi_deallocate
   use ELSI_MPI
   use ELSI_OUTPUT, only: elsi_get_unit
   use ELSI_PRECISION, only: r8,i4,i8
   use ELSI_REDIST, only: elsi_blacs_to_mask,elsi_blacs_to_sips_hs_dim,&
       elsi_blacs_to_sips_hs,elsi_sips_to_blacs_dm
   use ELSI_UTIL, only: elsi_reset_basic,elsi_check_init,elsi_check_err

   implicit none

   private

   public :: elsi_init_rw
   public :: elsi_finalize_rw
   public :: elsi_set_rw_mpi
   public :: elsi_set_rw_blacs
   public :: elsi_set_rw_zero_def
   public :: elsi_set_rw_header
   public :: elsi_get_rw_header
   public :: elsi_read_mat_dim
   public :: elsi_read_mat_real
   public :: elsi_read_mat_complex
   public :: elsi_write_mat_real
   public :: elsi_write_mat_complex

   public :: elsi_set_rw_csc 
   interface elsi_set_rw_csc
      module procedure elsi_set_rw_csc_i8
      module procedure elsi_set_rw_csc_i4
   end interface

   public :: elsi_read_mat_dim_sparse
   interface elsi_read_mat_dim_sparse
      module procedure elsi_read_mat_dim_sparse_i8
      module procedure elsi_read_mat_dim_sparse_i4
   end interface

   public :: elsi_read_mat_real_sparse
   interface elsi_read_mat_real_sparse
      module procedure elsi_read_mat_real_sparse_i8
      module procedure elsi_read_mat_real_sparse_i4
   end interface
   
   public :: elsi_read_mat_complex_sparse
   interface elsi_read_mat_complex_sparse
      module procedure elsi_read_mat_complex_sparse_i8
      module procedure elsi_read_mat_complex_sparse_i4
   end interface

   public :: elsi_write_mat_real_sparse
   interface elsi_write_mat_real_sparse
      module procedure elsi_write_mat_real_sparse_i8
      module procedure elsi_write_mat_real_sparse_i4
   end interface

   public :: elsi_write_mat_complex_sparse
   interface elsi_write_mat_complex_sparse
      module procedure elsi_write_mat_complex_sparse_i8
      module procedure elsi_write_mat_complex_sparse_i4
   end interface

   interface elsi_read_mat_mp
      module procedure elsi_read_mat_mp_real
      module procedure elsi_read_mat_mp_cmplx
   end interface

   interface elsi_read_mat_sp
      module procedure elsi_read_mat_sp_real
      module procedure elsi_read_mat_sp_cmplx
   end interface

   interface elsi_write_mat_mp
      module procedure elsi_write_mat_mp_real
      module procedure elsi_write_mat_mp_cmplx
   end interface

   interface elsi_write_mat_sp
      module procedure elsi_write_mat_sp_real
      module procedure elsi_write_mat_sp_cmplx
   end interface

contains

!>
!! Initialize a handle for reading and writing matrices.
!!
subroutine elsi_init_rw(rwh,task,parallel_mode,n_basis,n_electron)

   implicit none

   type(elsi_rw_handle), intent(out) :: rwh !< Handle
   integer(kind=i4), intent(in) :: task !< READ_MAT,WRITE_MAT
   integer(kind=i4), intent(in) :: parallel_mode !< SINGLE_PROC,MULTI_PROC
   integer(kind=i4), intent(in) :: n_basis !< Number of basis functions
   real(kind=r8), intent(in) :: n_electron !< Number of electrons

   character(len=*), parameter :: caller = "elsi_init_rw"

   ! For safety
   call elsi_reset_rw(rwh)
   call elsi_reset_basic(rwh%bh)

   rwh%handle_init = .true.
   rwh%rw_task = task
   rwh%parallel_mode = parallel_mode
   rwh%n_basis = n_basis
   rwh%n_electrons = n_electron

   if(parallel_mode == SINGLE_PROC) then
      rwh%bh%n_lrow = n_basis
      rwh%bh%n_lcol = n_basis
      rwh%bh%myid = 0
      rwh%bh%n_procs = 1
   end if

end subroutine

!>
!! Finalize a handle.
!!
subroutine elsi_finalize_rw(rwh)

   implicit none

   type(elsi_rw_handle), intent(inout) :: rwh !< Handle

   character(len=*), parameter :: caller = "elsi_finalize_rw"

   call elsi_check_init(rwh%bh,rwh%handle_init,caller)
   call elsi_reset_rw(rwh)
   call elsi_reset_basic(rwh%bh)

end subroutine

!>
!! Set the MPI communicator.
!!
subroutine elsi_set_rw_mpi(rwh,comm)

   implicit none

   type(elsi_rw_handle), intent(inout) :: rwh !< Handle
   integer(kind=i4), intent(in) :: comm !< Communicator

   integer(kind=i4) :: ierr

   character(len=*), parameter :: caller = "elsi_set_rw_mpi"

   call elsi_check_init(rwh%bh,rwh%handle_init,caller)

   if(rwh%parallel_mode == MULTI_PROC) then
      rwh%bh%comm = comm

      call MPI_Comm_rank(comm,rwh%bh%myid,ierr)
      call MPI_Comm_size(comm,rwh%bh%n_procs,ierr)

      rwh%bh%mpi_ready = .true.
   end if

end subroutine

!>
!! Set the BLACS context and the block size.
!!
subroutine elsi_set_rw_blacs(rwh,blacs_ctxt,block_size)

   implicit none

   type(elsi_rw_handle), intent(inout) :: rwh !< Handle
   integer(kind=i4), intent(in) :: blacs_ctxt !< BLACS context
   integer(kind=i4), intent(in) :: block_size !< Block size

   integer(kind=i4), external :: numroc

   character(len=*), parameter :: caller = "elsi_set_rw_blacs"

   call elsi_check_init(rwh%bh,rwh%handle_init,caller)

   if(rwh%parallel_mode == MULTI_PROC) then
      rwh%bh%blacs_ctxt = blacs_ctxt
      rwh%bh%blk = block_size

      ! Get processor grid information
      call BLACS_Gridinfo(blacs_ctxt,rwh%bh%n_prow,rwh%bh%n_pcol,&
           rwh%bh%my_prow,rwh%bh%my_pcol)

      if(rwh%rw_task == WRITE_FILE) then
         ! Get local size of matrix
         rwh%bh%n_lrow = numroc(rwh%n_basis,rwh%bh%blk,rwh%bh%my_prow,0,&
            rwh%bh%n_prow)
         rwh%bh%n_lcol = numroc(rwh%n_basis,rwh%bh%blk,rwh%bh%my_pcol,0,&
            rwh%bh%n_pcol)
      end if
   end if

end subroutine

!>
!! Set the sparsity pattern.
!!
subroutine elsi_set_rw_csc_i8(rwh,nnz_g,nnz_l_sp,n_lcol_sp)

   implicit none

   type(elsi_rw_handle), intent(inout) :: rwh !< Handle
   integer(kind=i8), intent(in) :: nnz_g !< Global number of nonzeros
   integer(kind=i8), intent(in) :: nnz_l_sp !< Local number of nonzeros
   integer(kind=i4), intent(in) :: n_lcol_sp !< Local number of columns

   character(len=*), parameter :: caller = "elsi_set_rw_csc_i8"

   call elsi_check_init(rwh%bh,rwh%handle_init,caller)

   rwh%bh%nnz_g = nnz_g
   rwh%bh%nnz_l_sp = nnz_l_sp
   rwh%bh%n_lcol_sp = n_lcol_sp

end subroutine

!>
!! Set the sparsity pattern.
!!
subroutine elsi_set_rw_csc_i4(rwh,nnz_g_i4,nnz_l_sp_i4,n_lcol_sp)

   implicit none

   type(elsi_rw_handle), intent(inout) :: rwh !< Handle
   integer(kind=i4), intent(in) :: nnz_g_i4 !< Global number of nonzeros
   integer(kind=i4), intent(in) :: nnz_l_sp_i4 !< Local number of nonzeros
   integer(kind=i4), intent(in) :: n_lcol_sp !< Local number of columns

   integer(kind=i8) :: nnz_g, nnz_l_sp

   character(len=*), parameter :: caller = "elsi_set_rw_csc_i4"

   nnz_g = int(nnz_g_i4,kind=i8)
   nnz_l_sp = int(nnz_l_sp_i4,kind=i8)
   call elsi_set_rw_csc_i8(rwh,nnz_g,nnz_l_sp,n_lcol_sp)

end subroutine

!>
!! Set the threshold to define "zero".
!!
subroutine elsi_set_rw_zero_def(rwh,zero_def)

   implicit none

   type(elsi_rw_handle), intent(inout) :: rwh !< Handle
   real(kind=r8), intent(in) :: zero_def !< Zero tolerance

   character(len=*), parameter :: caller = "elsi_set_rw_zero_def"

   call elsi_check_init(rwh%bh,rwh%handle_init,caller)

   rwh%bh%def0 = zero_def

end subroutine

!>
!! Set a matrix file header.
!!
subroutine elsi_set_rw_header(rwh,header_user)

   implicit none

   type(elsi_rw_handle), intent(inout) :: rwh !< Handle
   integer(kind=i4), intent(in) :: header_user(8) !< User's header

   character(len=*), parameter :: caller = "elsi_set_rw_header"

   call elsi_check_init(rwh%bh,rwh%handle_init,caller)

   rwh%header_user(:) = header_user

end subroutine

!>
!! Get a matrix file header.
!!
subroutine elsi_get_rw_header(rwh,header_user)

   implicit none

   type(elsi_rw_handle), intent(in) :: rwh !< Handle
   integer(kind=i4), intent(out) :: header_user(8) !< User's header

   character(len=*), parameter :: caller = "elsi_get_rw_header"

   call elsi_check_init(rwh%bh,rwh%handle_init,caller)

   header_user(:) = rwh%header_user

end subroutine

!>
!! Ensure there are no unsupported or mutually conflicting parameters before
!! reading or writing data.
!!
subroutine elsi_check_rw(bh,parallel_mode,n_basis,caller)

   implicit none

   type(elsi_basic_t), intent(in) :: bh
   integer(kind=i4), intent(in) :: parallel_mode
   integer(kind=i4), intent(in) :: n_basis
   character(len=*), intent(in) :: caller

   character(len=200) :: msg

   if(parallel_mode < 0 .or. parallel_mode >= N_PARALLEL_MODES) then
      write(msg,"(A)") "Unsupported parallel mode"
      call elsi_stop(bh,msg,caller)
   end if

   if(parallel_mode == MULTI_PROC) then
      if(.not. bh%mpi_ready) then
         write(msg,"(A)") "MULTI_PROC parallel mode requires MPI"
         call elsi_stop(bh,msg,caller)
      end if
   end if

   if(n_basis < bh%n_procs) then
      write(msg,"(A)") "Number of MPI tasks too large"
      call elsi_stop(bh,msg,caller)
   end if

end subroutine

!>
!! Reset rw handle.
!!
subroutine elsi_reset_rw(rwh)

   implicit none

   type(elsi_rw_handle), intent(out) :: rwh

   character(len=*), parameter :: caller = "elsi_reset_rw"

   rwh%rw_task = UNSET
   rwh%parallel_mode = UNSET
   rwh%matrix_format = UNSET
   rwh%n_electrons = 0.0_r8
   rwh%n_basis = UNSET
   rwh%header_user(:) = UNSET
   rwh%handle_init = .false.

end subroutine

!>
!! Read the dimensions of a 2D block-cyclic dense matrix from file.
!!
subroutine elsi_read_mat_dim(rwh,f_name,n_electron,n_basis,n_lrow,n_lcol)

   implicit none

   type(elsi_rw_handle), intent(inout) :: rwh !< Handle
   character(len=*), intent(in) :: f_name !< File name
   real(kind=r8), intent(out) :: n_electron !< Number of electrons
   integer(kind=i4), intent(out) :: n_basis !< Matrix size
   integer(kind=i4), intent(out) :: n_lrow !< Local number of rows
   integer(kind=i4), intent(out) :: n_lcol !< Local number of columns

   character(len=*), parameter :: caller = "elsi_read_mat_dim"

   call elsi_check_init(rwh%bh,rwh%handle_init,caller)

   if(rwh%parallel_mode == MULTI_PROC) then
      call elsi_read_mat_dim_mp(rwh,f_name,n_electron,n_basis,n_lrow,n_lcol)
   else
      call elsi_read_mat_dim_sp(rwh,f_name,n_electron,n_basis,n_lrow,n_lcol)
   end if

end subroutine

!>
!! Read a 2D block-cyclic dense matrix from file.
!!
subroutine elsi_read_mat_real(rwh,f_name,mat)

   implicit none

   type(elsi_rw_handle), intent(inout) :: rwh !< Handle
   character(len=*), intent(in) :: f_name !< File name
   real(kind=r8), intent(out) :: mat(rwh%bh%n_lrow,rwh%bh%n_lcol) !< Matrix

   character(len=*), parameter :: caller = "elsi_read_mat_real"

   call elsi_check_init(rwh%bh,rwh%handle_init,caller)
   call elsi_check_rw(rwh%bh,rwh%parallel_mode,rwh%n_basis,caller)

   if(rwh%parallel_mode == MULTI_PROC) then
      call elsi_read_mat_mp(rwh,f_name,mat)
   else
      call elsi_read_mat_sp(rwh,f_name,mat)
   end if

end subroutine

!>
!! Write a 2D block-cyclic dense matrix to file.
!!
subroutine elsi_write_mat_real(rwh,f_name,mat)

   implicit none

   type(elsi_rw_handle), intent(in) :: rwh !< Handle
   character(len=*), intent(in) :: f_name !< File name
   real(kind=r8), intent(in) :: mat(rwh%bh%n_lrow,rwh%bh%n_lcol) !< Matrix

   character(len=*), parameter :: caller = "elsi_write_mat_real"

   call elsi_check_init(rwh%bh,rwh%handle_init,caller)
   call elsi_check_rw(rwh%bh,rwh%parallel_mode,rwh%n_basis,caller)

   if(rwh%parallel_mode == MULTI_PROC) then
      call elsi_write_mat_mp(rwh,f_name,mat)
   else
      call elsi_write_mat_sp(rwh,f_name,mat)
   end if

end subroutine

!>
!! Read a 2D block-cyclic dense matrix from file.
!!
subroutine elsi_read_mat_complex(rwh,f_name,mat)

   implicit none

   type(elsi_rw_handle), intent(inout) :: rwh !< Handle
   character(len=*), intent(in) :: f_name !< File name
   complex(kind=r8), intent(out) :: mat(rwh%bh%n_lrow,rwh%bh%n_lcol) !< Matrix

   character(len=*), parameter :: caller = "elsi_read_mat_complex"

   call elsi_check_init(rwh%bh,rwh%handle_init,caller)
   call elsi_check_rw(rwh%bh,rwh%parallel_mode,rwh%n_basis,caller)

   if(rwh%parallel_mode == MULTI_PROC) then
      call elsi_read_mat_mp(rwh,f_name,mat)
   else
      call elsi_read_mat_sp(rwh,f_name,mat)
   end if

end subroutine

!>
!! Write a 2D block-cyclic dense matrix to file.
!!
subroutine elsi_write_mat_complex(rwh,f_name,mat)

   implicit none

   type(elsi_rw_handle), intent(in) :: rwh !< Handle
   character(len=*), intent(in) :: f_name !< File name
   complex(kind=r8), intent(in) :: mat(rwh%bh%n_lrow,rwh%bh%n_lcol) !< Matrix

   character(len=*), parameter :: caller = "elsi_write_mat_complex"

   call elsi_check_init(rwh%bh,rwh%handle_init,caller)
   call elsi_check_rw(rwh%bh,rwh%parallel_mode,rwh%n_basis,caller)

   if(rwh%parallel_mode == MULTI_PROC) then
      call elsi_write_mat_mp(rwh,f_name,mat)
   else
      call elsi_write_mat_sp(rwh,f_name,mat)
   end if

end subroutine

!>
!! Read the dimensions of a 2D block-cyclic dense matrix from file.
!!
subroutine elsi_read_mat_dim_mp(rwh,f_name,n_electron,n_basis,n_lrow,n_lcol)

   implicit none

   type(elsi_rw_handle), intent(inout) :: rwh !< Handle
   character(len=*), intent(in) :: f_name !< File name
   real(kind=r8), intent(out) :: n_electron !< Number of electrons
   integer(kind=i4), intent(out) :: n_basis !< Matrix size
   integer(kind=i4), intent(out) :: n_lrow !< Local number of rows
   integer(kind=i4), intent(out) :: n_lcol !< Local number of columns

   integer(kind=i4) :: ierr
   integer(kind=i4) :: f_handle
   integer(kind=i4) :: f_mode
   integer(kind=i8) :: header(HEADER_SIZE)
   integer(kind=i8) :: offset

   integer(kind=i4), external :: numroc

   character(len=*), parameter :: caller = "elsi_read_mat_dim_mp"

   ! Open file
   f_mode = MPI_MODE_RDONLY

   call MPI_File_open(rwh%bh%comm,f_name,f_mode,MPI_INFO_NULL,f_handle,ierr)

   call elsi_check_err(rwh%bh,"MPI_File_open",ierr,caller)

   ! Read header
   if(rwh%bh%myid == 0) then
      offset = 0

      call MPI_File_read_at(f_handle,offset,header,HEADER_SIZE,MPI_INTEGER8,&
           MPI_STATUS_IGNORE,ierr)

      call elsi_check_err(rwh%bh,"MPI_File_read_at",ierr,caller)
   end if

   ! Close file
   call MPI_File_close(f_handle,ierr)

   call elsi_check_err(rwh%bh,"MPI_File_close",ierr,caller)

   ! Broadcast header
   call MPI_Bcast(header,HEADER_SIZE,MPI_INTEGER8,0,rwh%bh%comm,ierr)

   call elsi_check_err(rwh%bh,"MPI_Bcast",ierr,caller)

   n_basis = header(4)
   n_electron = real(header(5),kind=r8)

   ! Get local size of matrix
   n_lrow = numroc(n_basis,rwh%bh%blk,rwh%bh%my_prow,0,rwh%bh%n_prow)
   n_lcol = numroc(n_basis,rwh%bh%blk,rwh%bh%my_pcol,0,rwh%bh%n_pcol)

   rwh%n_basis = n_basis
   rwh%n_electrons = n_electron
   rwh%bh%n_lrow = n_lrow
   rwh%bh%n_lcol = n_lcol
   rwh%bh%nnz_g = header(6)
   rwh%header_user(:) = header(9:16)

end subroutine

!>
!! Read the dimensions of a 1D block CSC matrix from file.
!!
subroutine elsi_read_mat_dim_sparse_i8(rwh,f_name,n_electron,n_basis,nnz_g,&
   nnz_l_sp,n_lcol_sp)

   implicit none

   type(elsi_rw_handle), intent(inout) :: rwh !< Handle
   character(len=*), intent(in) :: f_name !< File name
   real(kind=r8), intent(out) :: n_electron !< Number of electrons
   integer(kind=i4), intent(out) :: n_basis !< Matrix size
   integer(kind=i8), intent(out) :: nnz_g !< Global number of nonzeros
   integer(kind=i8), intent(out) :: nnz_l_sp !< Local number of nonzeros
   integer(kind=i4), intent(out) :: n_lcol_sp !< Local number of columns

   integer(kind=i4) :: ierr
   integer(kind=i4) :: f_handle
   integer(kind=i4) :: f_mode
   integer(kind=i8) :: header(HEADER_SIZE)
   integer(kind=i4) :: n_lcol0
   integer(kind=i8) :: prev_nnz
   integer(kind=i8) :: offset

   integer(kind=i8), allocatable :: col_ptr(:)

   character(len=*), parameter :: caller = "elsi_read_mat_dim_sparse_i8"

   call elsi_check_init(rwh%bh,rwh%handle_init,caller)

   ! Open file
   f_mode = MPI_MODE_RDONLY

   call MPI_File_open(rwh%bh%comm,f_name,f_mode,MPI_INFO_NULL,f_handle,ierr)

   call elsi_check_err(rwh%bh,"MPI_File_open",ierr,caller)

   ! Read header
   if(rwh%bh%myid == 0) then
      offset = 0

      call MPI_File_read_at(f_handle,offset,header,HEADER_SIZE,MPI_INTEGER8,&
           MPI_STATUS_IGNORE,ierr)

      call elsi_check_err(rwh%bh,"MPI_File_read_at",ierr,caller)
   end if

   ! Broadcast header
   call MPI_Bcast(header,HEADER_SIZE,MPI_INTEGER8,0,rwh%bh%comm,ierr)

   call elsi_check_err(rwh%bh,"MPI_Bcast",ierr,caller)

   n_basis = header(4)
   n_electron = real(header(5),kind=r8)
   nnz_g = header(6)

   ! Compute n_lcol
   n_lcol_sp = n_basis/rwh%bh%n_procs
   n_lcol0 = n_lcol_sp

   if(rwh%bh%myid == rwh%bh%n_procs-1) then
      n_lcol_sp = n_basis-(rwh%bh%n_procs-1)*n_lcol0
   end if

   call elsi_allocate(rwh%bh,col_ptr,n_lcol_sp+1,"col_ptr",caller)

   ! Read column pointer
   offset = int(HEADER_SIZE,kind=i8)*8+rwh%bh%myid*n_lcol0*8

   call MPI_File_read_at_all(f_handle,offset,col_ptr,n_lcol_sp+1,MPI_INTEGER8,&
        MPI_STATUS_IGNORE,ierr)

   call elsi_check_err(rwh%bh,"MPI_File_read_at_all",ierr,caller)

   ! Close file
   call MPI_File_close(f_handle,ierr)

   call elsi_check_err(rwh%bh,"MPI_File_close",ierr,caller)

   if(rwh%bh%myid == rwh%bh%n_procs-1) then
      col_ptr(n_lcol_sp+1) = nnz_g+1
   end if

   ! Shift column pointer
   prev_nnz = col_ptr(1)-1
   col_ptr(:) = col_ptr-prev_nnz

   ! Compute nnz_l_sp
   nnz_l_sp = col_ptr(n_lcol_sp+1)-col_ptr(1)

   call elsi_deallocate(rwh%bh,col_ptr,"col_ptr")

   rwh%n_basis = n_basis
   rwh%n_electrons = n_electron
   rwh%bh%nnz_g = nnz_g
   rwh%bh%nnz_l_sp = nnz_l_sp
   rwh%bh%n_lcol_sp = n_lcol_sp
   rwh%header_user(:) = header(9:16)

end subroutine

!>
!! Read the dimensions of a 1D block CSC matrix from file.
!!
subroutine elsi_read_mat_dim_sparse_i4(rwh,f_name,n_electron,n_basis,nnz_g_i4,&
   nnz_l_sp_i4,n_lcol_sp)

   implicit none

   type(elsi_rw_handle), intent(inout) :: rwh !< Handle
   character(len=*), intent(in) :: f_name !< File name
   real(kind=r8), intent(out) :: n_electron !< Number of electrons
   integer(kind=i4), intent(out) :: n_basis !< Matrix size
   integer(kind=i4), intent(out) :: nnz_g_i4 !< Global number of nonzeros
   integer(kind=i4), intent(out) :: nnz_l_sp_i4 !< Local number of nonzeros
   integer(kind=i4), intent(out) :: n_lcol_sp !< Local number of columns

   integer(kind=i8) :: nnz_g, nnz_l_sp
   character(len=*), parameter :: caller = "elsi_read_mat_dim_sparse_i4"

   call elsi_read_mat_dim_sparse_i8(rwh,f_name,n_electron,n_basis,nnz_g,&
           nnz_l_sp,n_lcol_sp)
   nnz_g_i4 = int(nnz_g, kind=i4)
   nnz_l_sp_i4 = int(nnz_l_sp, kind=i4)

end subroutine

!>
!! Read a 2D block-cyclic dense matrix from file.
!!
subroutine elsi_read_mat_mp_real(rwh,f_name,mat)

   implicit none

   type(elsi_rw_handle), intent(inout) :: rwh !< Handle
   character(len=*), intent(in) :: f_name !< File name
   real(kind=r8), intent(out) :: mat(rwh%bh%n_lrow,rwh%bh%n_lcol) !< Matrix

   integer(kind=i4) :: ierr
   integer(kind=i4) :: f_handle
   integer(kind=i4) :: f_mode
   integer(kind=i4) :: n_lcol0
   integer(kind=i8) :: prev_nnz ! **
   integer(kind=i8) :: offset

   real(kind=r8), allocatable :: nnz_val(:)
   integer(kind=i4), allocatable :: row_ind(:) ! **
   integer(kind=i8), allocatable :: col_ptr(:) ! **

   type(elsi_param_t) :: ph

   character(len=*), parameter :: caller = "elsi_read_mat_mp_real"

   ! Open file
   f_mode = MPI_MODE_RDONLY

   call MPI_File_open(rwh%bh%comm,f_name,f_mode,MPI_INFO_NULL,f_handle,ierr)

   call elsi_check_err(rwh%bh,"MPI_File_open",ierr,caller)

   ! Compute n_lcol_sp
   rwh%bh%n_lcol_sp = rwh%n_basis/rwh%bh%n_procs
   n_lcol0 = rwh%bh%n_lcol_sp

   if(rwh%bh%myid == rwh%bh%n_procs-1) then
      rwh%bh%n_lcol_sp = rwh%n_basis-(rwh%bh%n_procs-1)*n_lcol0
   end if

   call elsi_allocate(rwh%bh,col_ptr,rwh%bh%n_lcol_sp+1,"col_ptr",caller)

   ! Read column pointer
   offset = int(HEADER_SIZE,kind=i8)*8+rwh%bh%myid*int(n_lcol0, kind=i8)*8

   call MPI_File_read_at_all(f_handle,offset,col_ptr,rwh%bh%n_lcol_sp+1,&
        MPI_INTEGER8,MPI_STATUS_IGNORE,ierr)

   call elsi_check_err(rwh%bh,"MPI_File_read_at_all (col_ptr)",ierr,caller)

   if(rwh%bh%myid == rwh%bh%n_procs-1) then
      col_ptr(rwh%bh%n_lcol_sp+1) = rwh%bh%nnz_g+1
   end if

   ! Shift column pointer
   prev_nnz = col_ptr(1)-1
   col_ptr(:) = col_ptr-prev_nnz

   ! Compute nnz_l_sp
   rwh%bh%nnz_l_sp = col_ptr(rwh%bh%n_lcol_sp+1)-col_ptr(1) ! **

   call elsi_allocate(rwh%bh,row_ind,rwh%bh%nnz_l_sp,"row_ind",caller) ! **

   ! Read row index
   offset = int(HEADER_SIZE,kind=i8)*8+int(rwh%n_basis, kind=i8)*8+int(prev_nnz, kind=i8)*4 ! **

   call MPI_File_read_at_all(f_handle,offset,row_ind,rwh%bh%nnz_l_sp,&
        MPI_INTEGER4,MPI_STATUS_IGNORE,ierr)

   call elsi_check_err(rwh%bh,"MPI_File_read_at_all (row_ind)",ierr,caller)

   ! Read nonzero value
   offset = int(HEADER_SIZE,kind=i8)*8+rwh%n_basis*8+int(rwh%bh%nnz_g, kind=i8)*4+int(prev_nnz, kind=i8)*8

   call elsi_allocate(rwh%bh,nnz_val,rwh%bh%nnz_l_sp,"nnz_val",caller)

   call MPI_File_read_at_all(f_handle,offset,nnz_val,rwh%bh%nnz_l_sp,MPI_REAL8,&
        MPI_STATUS_IGNORE,ierr)

   call elsi_check_err(rwh%bh,"MPI_File_real_at_all",ierr,caller)

   ! Close file
   call MPI_File_close(f_handle,ierr)

   call elsi_check_err(rwh%bh,"MPI_File_close",ierr,caller)

   ! Redistribute matrix
   ph%n_basis = rwh%n_basis
   rwh%bh%nnz_l_sp1 = rwh%bh%nnz_l_sp
   rwh%bh%n_lcol_sp1 = rwh%bh%n_lcol_sp

   call elsi_sips_to_blacs_dm(ph,rwh%bh,nnz_val,row_ind,col_ptr,mat)

   call elsi_deallocate(rwh%bh,col_ptr,"col_ptr")
   call elsi_deallocate(rwh%bh,row_ind,"row_ind")
   call elsi_deallocate(rwh%bh,nnz_val,"nnz_val")

end subroutine

!>
!! Read a 1D block CSC matrix from file.
!!
subroutine elsi_read_mat_real_sparse_i8(rwh,f_name,row_ind,col_ptr,mat)

   implicit none

   type(elsi_rw_handle), intent(inout) :: rwh !< Handle
   character(len=*), intent(in) :: f_name !< File name
   integer(kind=i4), intent(out) :: row_ind(rwh%bh%nnz_l_sp) !< Row index
   integer(kind=i8), intent(out) :: col_ptr(rwh%bh%n_lcol_sp+1) !< Column pointer
   real(kind=r8), intent(out) :: mat(rwh%bh%nnz_l_sp) !< Matrix

   integer(kind=i4) :: ierr
   integer(kind=i4) :: f_handle
   integer(kind=i4) :: f_mode
   integer(kind=i4) :: n_lcol0
   integer(kind=i8) :: prev_nnz
   integer(kind=i8) :: offset

   character(len=*), parameter :: caller = "elsi_read_mat_real_sparse_i8"

   call elsi_check_init(rwh%bh,rwh%handle_init,caller)
   call elsi_check_rw(rwh%bh,rwh%parallel_mode,rwh%n_basis,caller)

   ! Open file
   f_mode = MPI_MODE_RDONLY

   call MPI_File_open(rwh%bh%comm,f_name,f_mode,MPI_INFO_NULL,f_handle,ierr)

   call elsi_check_err(rwh%bh,"MPI_File_open",ierr,caller)

   ! Compute n_lcol0
   n_lcol0 = rwh%n_basis/rwh%bh%n_procs

   ! Read column pointer
   offset = int(HEADER_SIZE,kind=i8)*8+rwh%bh%myid*n_lcol0*8

   call MPI_File_read_at_all(f_handle,offset,col_ptr,rwh%bh%n_lcol_sp+1,&
        MPI_INTEGER8,MPI_STATUS_IGNORE,ierr)

   call elsi_check_err(rwh%bh,"MPI_File_read_at_all",ierr,caller)

   if(rwh%bh%myid == rwh%bh%n_procs-1) then
      col_ptr(rwh%bh%n_lcol_sp+1) = rwh%bh%nnz_g+1
   end if

   ! Shift column pointer
   prev_nnz = col_ptr(1)-1
   col_ptr(:) = col_ptr-prev_nnz

   ! Read row index
   offset = int(HEADER_SIZE,kind=i8)*8+rwh%n_basis*8+int(prev_nnz, kind=i8)*4

   call MPI_File_read_at_all(f_handle,offset,row_ind,rwh%bh%nnz_l_sp,&
        MPI_INTEGER4,MPI_STATUS_IGNORE,ierr)

   call elsi_check_err(rwh%bh,"MPI_File_read_at_all",ierr,caller)

   ! Read nonzero value
   offset = int(HEADER_SIZE,kind=i8)*8+rwh%n_basis*8+int(rwh%bh%nnz_g, kind=i8)*4+int(prev_nnz, kind=i8)*8

   call MPI_File_read_at_all(f_handle,offset,mat,rwh%bh%nnz_l_sp,MPI_REAL8,&
        MPI_STATUS_IGNORE,ierr)

   call elsi_check_err(rwh%bh,"MPI_File_read_at_all",ierr,caller)

   ! Close file
   call MPI_File_close(f_handle,ierr)

   call elsi_check_err(rwh%bh,"MPI_File_close",ierr,caller)

end subroutine

!>
!! Read a 1D block CSC matrix from file.
!!
subroutine elsi_read_mat_real_sparse_i4(rwh,f_name,row_ind,col_ptr_i4,mat)

   implicit none

   type(elsi_rw_handle), intent(inout) :: rwh !< Handle
   character(len=*), intent(in) :: f_name !< File name
   integer(kind=i4), intent(out) :: row_ind(rwh%bh%nnz_l_sp) !< Row index
   integer(kind=i4), intent(out) :: col_ptr_i4(rwh%bh%n_lcol_sp+1) !< Column pointer
   real(kind=r8), intent(out) :: mat(rwh%bh%nnz_l_sp) !< Matrix

   integer(kind=i8) :: col_ptr(rwh%bh%n_lcol_sp+1)

   character(len=*), parameter :: caller = "elsi_read_mat_real_sparse_i4"

   call elsi_read_mat_real_sparse_i8(rwh,f_name,row_ind,col_ptr,mat)
   col_ptr_i4 = int(col_ptr, kind=i4)

end subroutine

!>
!! Read a 2D block-cyclic dense matrix from file.
!!
subroutine elsi_read_mat_mp_cmplx(rwh,f_name,mat)

   implicit none

   type(elsi_rw_handle), intent(inout) :: rwh !< Handle
   character(len=*), intent(in) :: f_name !< File name
   complex(kind=r8), intent(out) :: mat(rwh%bh%n_lrow,rwh%bh%n_lcol) !< Matrix

   integer(kind=i4) :: ierr
   integer(kind=i4) :: f_handle
   integer(kind=i4) :: f_mode
   integer(kind=i4) :: n_lcol0
   integer(kind=i8) :: prev_nnz
   integer(kind=i8) :: offset

   complex(kind=r8), allocatable :: nnz_val(:)
   integer(kind=i4), allocatable :: row_ind(:)
   integer(kind=i8), allocatable :: col_ptr(:)

   type(elsi_param_t) :: ph

   character(len=*), parameter :: caller = "elsi_read_mat_mp_cmplx"

   ! Open file
   f_mode = MPI_MODE_RDONLY

   call MPI_File_open(rwh%bh%comm,f_name,f_mode,MPI_INFO_NULL,f_handle,ierr)

   call elsi_check_err(rwh%bh,"MPI_File_open",ierr,caller)

   ! Compute n_lcol_sp
   rwh%bh%n_lcol_sp = rwh%n_basis/rwh%bh%n_procs
   n_lcol0 = rwh%bh%n_lcol_sp

   if(rwh%bh%myid == rwh%bh%n_procs-1) then
      rwh%bh%n_lcol_sp = rwh%n_basis-(rwh%bh%n_procs-1)*n_lcol0
   end if

   call elsi_allocate(rwh%bh,col_ptr,rwh%bh%n_lcol_sp+1,"col_ptr",caller)

   ! Read column pointer
   offset = int(HEADER_SIZE,kind=i8)*8+rwh%bh%myid*n_lcol0*8

   call MPI_File_read_at_all(f_handle,offset,col_ptr,rwh%bh%n_lcol_sp+1,&
        MPI_INTEGER8,MPI_STATUS_IGNORE,ierr)

   call elsi_check_err(rwh%bh,"MPI_File_read_at_all",ierr,caller)

   if(rwh%bh%myid == rwh%bh%n_procs-1) then
      col_ptr(rwh%bh%n_lcol_sp+1) = rwh%bh%nnz_g+1
   end if

   ! Shift column pointer
   prev_nnz = col_ptr(1)-1
   col_ptr(:) = col_ptr-prev_nnz

   ! Compute nnz_l_sp
   rwh%bh%nnz_l_sp = col_ptr(rwh%bh%n_lcol_sp+1)-col_ptr(1)

   call elsi_allocate(rwh%bh,row_ind,rwh%bh%nnz_l_sp,"row_ind",caller)

   ! Read row index
   offset = int(HEADER_SIZE,kind=i8)*8+rwh%n_basis*8+int(prev_nnz, kind=i8)*4

   call MPI_File_read_at_all(f_handle,offset,row_ind,rwh%bh%nnz_l_sp,&
        MPI_INTEGER4,MPI_STATUS_IGNORE,ierr)

   call elsi_check_err(rwh%bh,"MPI_File_read_at_all",ierr,caller)

   ! Read nonzero value
   offset = int(HEADER_SIZE,kind=i8)*8+rwh%n_basis*8+int(rwh%bh%nnz_g, kind=i8)*4+int(prev_nnz, kind=i8)*16

   call elsi_allocate(rwh%bh,nnz_val,rwh%bh%nnz_l_sp,"nnz_val",caller)

   call MPI_File_read_at_all(f_handle,offset,nnz_val,rwh%bh%nnz_l_sp,&
        MPI_COMPLEX16,MPI_STATUS_IGNORE,ierr)

   call elsi_check_err(rwh%bh,"MPI_File_read_at_all",ierr,caller)

   ! Close file
   call MPI_File_close(f_handle,ierr)

   call elsi_check_err(rwh%bh,"MPI_File_close",ierr,caller)

   ! Redistribute matrix
   ph%n_basis = rwh%n_basis
   rwh%bh%nnz_l_sp1 = rwh%bh%nnz_l_sp
   rwh%bh%n_lcol_sp1 = rwh%bh%n_lcol_sp

   call elsi_sips_to_blacs_dm(ph,rwh%bh,nnz_val,row_ind,col_ptr,mat)

   call elsi_deallocate(rwh%bh,col_ptr,"col_ptr")
   call elsi_deallocate(rwh%bh,row_ind,"row_ind")
   call elsi_deallocate(rwh%bh,nnz_val,"nnz_val")

end subroutine

!>
!! Read a 1D block CSC matrix from file.
!!
subroutine elsi_read_mat_complex_sparse_i8(rwh,f_name,row_ind,col_ptr,mat)

   implicit none

   type(elsi_rw_handle), intent(inout) :: rwh !< Handle
   character(len=*), intent(in) :: f_name !< File name
   integer(kind=i4), intent(out) :: row_ind(rwh%bh%nnz_l_sp) !< Row index
   integer(kind=i8), intent(out) :: col_ptr(rwh%bh%n_lcol_sp+1) !< Column pointer
   complex(kind=r8), intent(out) :: mat(rwh%bh%nnz_l_sp) !< Matrix

   integer(kind=i4) :: ierr
   integer(kind=i4) :: f_handle
   integer(kind=i4) :: f_mode
   integer(kind=i4) :: n_lcol0
   integer(kind=i8) :: prev_nnz
   integer(kind=i8) :: offset

   character(len=*), parameter :: caller = "elsi_read_mat_complex_sparse_i8"

   call elsi_check_init(rwh%bh,rwh%handle_init,caller)
   call elsi_check_rw(rwh%bh,rwh%parallel_mode,rwh%n_basis,caller)

   ! Open file
   f_mode = MPI_MODE_RDONLY

   call MPI_File_open(rwh%bh%comm,f_name,f_mode,MPI_INFO_NULL,f_handle,ierr)

   call elsi_check_err(rwh%bh,"MPI_File_open",ierr,caller)

   ! Compute n_lcol0
   n_lcol0 = rwh%n_basis/rwh%bh%n_procs

   ! Read column pointer
   offset = int(HEADER_SIZE,kind=i8)*8+rwh%bh%myid*n_lcol0*8

   call MPI_File_read_at_all(f_handle,offset,col_ptr,rwh%bh%n_lcol_sp+1,&
        MPI_INTEGER8,MPI_STATUS_IGNORE,ierr)

   call elsi_check_err(rwh%bh,"MPI_File_read_at_all",ierr,caller)

   if(rwh%bh%myid == rwh%bh%n_procs-1) then
      col_ptr(rwh%bh%n_lcol_sp+1) = rwh%bh%nnz_g+1
   end if

   ! Shift column pointer
   prev_nnz = col_ptr(1)-1
   col_ptr(:) = col_ptr-prev_nnz

   ! Read row index
   offset = int(HEADER_SIZE,kind=i8)*8+rwh%n_basis*8+int(prev_nnz, kind=i8)*4

   call MPI_File_read_at_all(f_handle,offset,row_ind,rwh%bh%nnz_l_sp,&
        MPI_INTEGER4,MPI_STATUS_IGNORE,ierr)

   call elsi_check_err(rwh%bh,"MPI_File_read_at_all",ierr,caller)

   ! Read nonzero value
   offset = int(HEADER_SIZE,kind=i8)*8+rwh%n_basis*8+int(rwh%bh%nnz_g, kind=i8)*4+int(prev_nnz, kind=i8)*16

   call MPI_File_read_at_all(f_handle,offset,mat,rwh%bh%nnz_l_sp,MPI_COMPLEX16,&
        MPI_STATUS_IGNORE,ierr)

   call elsi_check_err(rwh%bh,"MPI_File_read_at_all",ierr,caller)

   ! Close file
   call MPI_File_close(f_handle,ierr)

   call elsi_check_err(rwh%bh,"MPI_File_close",ierr,caller)

end subroutine

!>
!! Read a 1D block CSC matrix from file.
!!
subroutine elsi_read_mat_complex_sparse_i4(rwh,f_name,row_ind,col_ptr_i4,mat)

   implicit none

   type(elsi_rw_handle), intent(inout) :: rwh !< Handle
   character(len=*), intent(in) :: f_name !< File name
   integer(kind=i4), intent(out) :: row_ind(rwh%bh%nnz_l_sp) !< Row index
   integer(kind=i4), intent(out) :: col_ptr_i4(rwh%bh%n_lcol_sp+1) !< Column pointer
   complex(kind=r8), intent(out) :: mat(rwh%bh%nnz_l_sp) !< Matrix

   integer(kind=i8) :: col_ptr(rwh%bh%n_lcol_sp+1)

   character(len=*), parameter :: caller = "elsi_read_mat_complex_sparse_i4"

   call elsi_read_mat_complex_sparse_i8(rwh,f_name,row_ind,col_ptr,mat)
   col_ptr_i4 = int(col_ptr,kind=i4)

end subroutine

!>
!! Write a 2D block-cyclic dense matrix to file.
!!
subroutine elsi_write_mat_mp_real(rwh,f_name,mat)

   implicit none

   type(elsi_rw_handle), intent(in) :: rwh !< Handle
   character(len=*), intent(in) :: f_name !< File name
   real(kind=r8), intent(in) :: mat(rwh%bh%n_lrow,rwh%bh%n_lcol) !< Matrix

   real(kind=r8) :: dummy1(1,1)
   real(kind=r8) :: dummy2(1)
   integer(kind=i4) :: ierr
   integer(kind=i4) :: f_handle
   integer(kind=i4) :: f_mode
   integer(kind=i8) :: header(HEADER_SIZE)
   integer(kind=i4) :: n_lcol0
   integer(kind=i8) :: prev_nnz
   integer(kind=i8) :: offset

   real(kind=r8), allocatable :: mat_csc(:)
   integer(kind=i4), allocatable :: row_ind(:)
   integer(kind=i8), allocatable :: col_ptr(:)
   integer(kind=i8), allocatable :: mask(:,:)

   type(elsi_basic_t) :: bh
   type(elsi_param_t) :: ph

   character(len=*), parameter :: caller = "elsi_write_mat_mp_real"

   ph%n_basis = rwh%n_basis
   ph%unit_ovlp = .true.
   ph%sparsity_mask = MASK_H
   ph%first_blacs_to_pexsi = .true.
   bh = rwh%bh
   bh%n_lcol_sp = rwh%n_basis/bh%n_procs

   if(bh%myid == bh%n_procs-1) then
      bh%n_lcol_sp = rwh%n_basis-(bh%n_procs-1)*bh%n_lcol_sp
   end if

   call elsi_allocate(bh,mask,bh%n_lrow,bh%n_lcol,"mask",caller)

   call elsi_blacs_to_mask(ph,bh,mat,dummy1,mask)
   call elsi_blacs_to_sips_hs_dim(ph,bh,mask)

   call elsi_allocate(bh,mat_csc,bh%nnz_l_sp,"mat_csc",caller)
   call elsi_allocate(bh,row_ind,bh%nnz_l_sp,"row_ind",caller)
   call elsi_allocate(bh,col_ptr,bh%n_lcol_sp+1,"col_ptr",caller)

   call elsi_blacs_to_sips_hs(ph,bh,mat,dummy1,mask,mat_csc,dummy2,row_ind,&
        col_ptr)

   call elsi_deallocate(bh,mask,"mask")

   ! Open file
   f_mode = MPI_MODE_WRONLY+MPI_MODE_CREATE

   call MPI_File_open(bh%comm,f_name,f_mode,MPI_INFO_NULL,f_handle,ierr)

   call elsi_check_err(bh,"MPI_File_open",ierr,caller)

   ! Write header
   header(1) = FILE_VERSION
   header(2) = UNSET
   header(3) = REAL_DATA
   header(4) = rwh%n_basis
   header(5) = nint(rwh%n_electrons,kind=i4)
   header(6) = bh%nnz_g
   header(7:8) = UNSET
   header(9:16) = rwh%header_user

   if(bh%myid == 0) then
      offset = 0

      call MPI_File_write_at(f_handle,offset,header,HEADER_SIZE,MPI_INTEGER8,&
           MPI_STATUS_IGNORE,ierr)

      call elsi_check_err(bh,"MPI_File_write_at",ierr,caller)
   end if

   ! Compute shift of column pointers
   prev_nnz = 0

   call MPI_Exscan(bh%nnz_l_sp,prev_nnz,1,MPI_INTEGER8,MPI_SUM,bh%comm,ierr)

   call elsi_check_err(bh,"MPI_Exscan",ierr,caller)

   ! Shift column pointer
   col_ptr(:) = col_ptr+prev_nnz

   ! Write column pointer
   n_lcol0 = rwh%n_basis/bh%n_procs
   offset = int(HEADER_SIZE,kind=i8)*8+bh%myid*int(n_lcol0, kind=i8)*8

   call MPI_File_write_at_all(f_handle,offset,col_ptr,bh%n_lcol_sp,&
        MPI_INTEGER8,MPI_STATUS_IGNORE,ierr)

   call elsi_check_err(bh,"MPI_File_write_at_all",ierr,caller)

   ! Write row index
   offset = int(HEADER_SIZE,kind=i8)*8+rwh%n_basis*8+int(prev_nnz, kind=i8)*4

   call MPI_File_write_at_all(f_handle,offset,row_ind,bh%nnz_l_sp,MPI_INTEGER4,&
        MPI_STATUS_IGNORE,ierr)

   call elsi_check_err(bh,"MPI_File_write_at_all",ierr,caller)

   ! Write nonzero value
   offset = int(HEADER_SIZE,kind=i8)*8+rwh%n_basis*8+int(bh%nnz_g, kind=i8)*4+int(prev_nnz, kind=i8)*8

   call MPI_File_write_at_all(f_handle,offset,mat_csc,bh%nnz_l_sp,MPI_REAL8,&
        MPI_STATUS_IGNORE,ierr)

   call elsi_check_err(bh,"MPI_File_write_at_all",ierr,caller)

   ! Close file
   call MPI_File_close(f_handle,ierr)

   call elsi_check_err(bh,"MPI_File_close",ierr,caller)

   call elsi_deallocate(bh,row_ind,"row_ind")
   call elsi_deallocate(bh,col_ptr,"col_ptr")
   call elsi_deallocate(bh,mat_csc,"mat_csc")

end subroutine

!>
!! Write a 2D block-cyclic dense matrix to file.
!!
subroutine elsi_write_mat_mp_cmplx(rwh,f_name,mat)

   implicit none

   type(elsi_rw_handle), intent(in) :: rwh !< Handle
   character(len=*), intent(in) :: f_name !< File name
   complex(kind=r8), intent(in) :: mat(rwh%bh%n_lrow,rwh%bh%n_lcol) !< Matrix

   complex(kind=r8) :: dummy1(1,1)
   complex(kind=r8) :: dummy2(1)
   integer(kind=i4) :: ierr
   integer(kind=i4) :: f_handle
   integer(kind=i4) :: f_mode
   integer(kind=i8) :: header(HEADER_SIZE)
   integer(kind=i4) :: n_lcol0
   integer(kind=i8) :: prev_nnz
   integer(kind=i8) :: offset

   complex(kind=r8), allocatable :: mat_csc(:)
   integer(kind=i4), allocatable :: row_ind(:)
   integer(kind=i8), allocatable :: col_ptr(:)
   integer(kind=i8), allocatable :: mask(:,:)

   type(elsi_basic_t) :: bh
   type(elsi_param_t) :: ph

   character(len=*), parameter :: caller = "elsi_write_mat_mp_cmplx"

   ph%n_basis = rwh%n_basis
   ph%unit_ovlp = .true.
   ph%sparsity_mask = MASK_H
   ph%first_blacs_to_pexsi = .true.
   bh = rwh%bh
   bh%n_lcol_sp = rwh%n_basis/bh%n_procs

   if(bh%myid == bh%n_procs-1) then
      bh%n_lcol_sp = rwh%n_basis-(bh%n_procs-1)*bh%n_lcol_sp
   end if

   call elsi_allocate(bh,mask,bh%n_lrow,bh%n_lcol,"mask",caller)

   call elsi_blacs_to_mask(ph,bh,mat,dummy1,mask)
   call elsi_blacs_to_sips_hs_dim(ph,bh,mask)

   call elsi_allocate(bh,mat_csc,bh%nnz_l_sp,"mat_csc",caller)
   call elsi_allocate(bh,row_ind,bh%nnz_l_sp,"row_ind",caller)
   call elsi_allocate(bh,col_ptr,bh%n_lcol_sp+1,"col_ptr",caller)

   call elsi_blacs_to_sips_hs(ph,bh,mat,dummy1,mask,mat_csc,dummy2,row_ind,&
        col_ptr)

   call elsi_deallocate(bh,mask,"mask")

   ! Open file
   f_mode = MPI_MODE_WRONLY+MPI_MODE_CREATE

   call MPI_File_open(bh%comm,f_name,f_mode,MPI_INFO_NULL,f_handle,ierr)

   call elsi_check_err(bh,"MPI_File_open",ierr,caller)

   ! Write header
   header(1) = FILE_VERSION
   header(2) = UNSET
   header(3) = CMPLX_DATA
   header(4) = rwh%n_basis
   header(5) = nint(rwh%n_electrons,kind=i4)
   header(6) = bh%nnz_g
   header(7:8) = UNSET
   header(9:16) = rwh%header_user

   if(bh%myid == 0) then
      offset = 0

      call MPI_File_write_at(f_handle,offset,header,HEADER_SIZE,MPI_INTEGER8,&
           MPI_STATUS_IGNORE,ierr)

      call elsi_check_err(bh,"MPI_File_write_at",ierr,caller)
   end if

   ! Compute shift of column pointers
   prev_nnz = 0

   call MPI_Exscan(bh%nnz_l_sp,prev_nnz,1,MPI_INTEGER8,MPI_SUM,bh%comm,ierr)

   call elsi_check_err(bh,"MPI_Exscan",ierr,caller)

   ! Shift column pointer
   col_ptr(:) = col_ptr+prev_nnz

   ! Write column pointer
   n_lcol0 = rwh%n_basis/bh%n_procs
   offset = int(HEADER_SIZE,kind=i8)*8+bh%myid*n_lcol0*8

   call MPI_File_write_at_all(f_handle,offset,col_ptr,bh%n_lcol_sp,&
        MPI_INTEGER8,MPI_STATUS_IGNORE,ierr)

   call elsi_check_err(bh,"MPI_File_write_at_all",ierr,caller)

   ! Write row index
   offset = int(HEADER_SIZE,kind=i8)*8+rwh%n_basis*8+int(prev_nnz, kind=i8)*4

   call MPI_File_write_at_all(f_handle,offset,row_ind,bh%nnz_l_sp,MPI_INTEGER4,&
        MPI_STATUS_IGNORE,ierr)

   call elsi_check_err(bh,"MPI_File_write_at_all",ierr,caller)

   ! Write nonzero value
   offset = int(HEADER_SIZE,kind=i8)*8+rwh%n_basis*8+int(bh%nnz_g, kind=i8)*4+int(prev_nnz, kind=i8)*16

   call MPI_File_write_at_all(f_handle,offset,mat_csc,bh%nnz_l_sp,&
        MPI_COMPLEX16,MPI_STATUS_IGNORE,ierr)

   call elsi_check_err(bh,"MPI_File_write_at_all",ierr,caller)

   ! Close file
   call MPI_File_close(f_handle,ierr)

   call elsi_check_err(bh,"MPI_File_close",ierr,caller)

   call elsi_deallocate(bh,col_ptr,"col_ptr")
   call elsi_deallocate(bh,row_ind,"row_ind")
   call elsi_deallocate(bh,mat_csc,"mat_csc")

end subroutine

!>
!! Write a 1D block CSC matrix to file.
!!
subroutine elsi_write_mat_real_sparse_i8(rwh,f_name,row_ind,col_ptr,mat)

   implicit none

   type(elsi_rw_handle), intent(in) :: rwh !< Handle
   character(len=*), intent(in) :: f_name !< File name
   integer(kind=i4), intent(in) :: row_ind(rwh%bh%nnz_l_sp) !< Row index
   integer(kind=i8), intent(in) :: col_ptr(rwh%bh%n_lcol_sp+1) !< Column pointer
   real(kind=r8), intent(in) :: mat(rwh%bh%nnz_l_sp) !< Matrix

   integer(kind=i4) :: ierr
   integer(kind=i4) :: f_handle
   integer(kind=i4) :: f_mode
   integer(kind=i8) :: header(HEADER_SIZE)
   integer(kind=i8) :: prev_nnz
   integer(kind=i4) :: n_lcol0
   integer(kind=i8) :: offset

   integer(kind=i8), allocatable :: col_ptr_shift(:)

   character(len=*), parameter :: caller = "elsi_write_mat_real_sparse_i8"

   call elsi_check_init(rwh%bh,rwh%handle_init,caller)
   call elsi_check_rw(rwh%bh,rwh%parallel_mode,rwh%n_basis,caller)

   ! Open file
   f_mode = MPI_MODE_WRONLY+MPI_MODE_CREATE

   call MPI_File_open(rwh%bh%comm,f_name,f_mode,MPI_INFO_NULL,f_handle,ierr)

   call elsi_check_err(rwh%bh,"MPI_File_open",ierr,caller)

   ! Write header
   header(1) = FILE_VERSION
   header(2) = UNSET
   header(3) = REAL_DATA
   header(4) = rwh%n_basis
   header(5) = nint(rwh%n_electrons,kind=i4)
   header(6) = rwh%bh%nnz_g
   header(7:8) = UNSET
   header(9:16) = rwh%header_user

   if(rwh%bh%myid == 0) then
      offset = 0

      call MPI_File_write_at(f_handle,offset,header,HEADER_SIZE,MPI_INTEGER8,&
           MPI_STATUS_IGNORE,ierr)

      call elsi_check_err(rwh%bh,"MPI_File_write_at",ierr,caller)
   end if

   ! Compute shift of column pointers
   prev_nnz = 0

   call MPI_Exscan(rwh%bh%nnz_l_sp,prev_nnz,1,MPI_INTEGER8,MPI_SUM,rwh%bh%comm,&
        ierr)

   call elsi_check_err(rwh%bh,"MPI_Exscan",ierr,caller)

   ! Shift column pointer
   call elsi_allocate(rwh%bh,col_ptr_shift,rwh%bh%n_lcol_sp+1,"col_ptr_shift",&
        caller)

   col_ptr_shift(:) = col_ptr+prev_nnz

   ! Write column pointer
   n_lcol0 = rwh%n_basis/rwh%bh%n_procs
   offset = int(HEADER_SIZE,kind=i8)*8+rwh%bh%myid*n_lcol0*8

   call MPI_File_write_at_all(f_handle,offset,col_ptr_shift,rwh%bh%n_lcol_sp,&
        MPI_INTEGER8,MPI_STATUS_IGNORE,ierr)

   call elsi_check_err(rwh%bh,"MPI_File_write_at_all",ierr,caller)

   call elsi_deallocate(rwh%bh,col_ptr_shift,"col_ptr_shift")

   ! Write row index
   offset = int(HEADER_SIZE,kind=i8)*8+rwh%n_basis*8+int(prev_nnz, kind=i8)*4

   call MPI_File_write_at_all(f_handle,offset,row_ind,rwh%bh%nnz_l_sp,&
        MPI_INTEGER4,MPI_STATUS_IGNORE,ierr)

   call elsi_check_err(rwh%bh,"MPI_File_write_at_all",ierr,caller)

   ! Write nonzero value
   offset = int(HEADER_SIZE,kind=i8)*8+rwh%n_basis*8+int(rwh%bh%nnz_g, kind=i8)*4+int(prev_nnz, kind=i8)*8

   call MPI_File_write_at_all(f_handle,offset,mat,rwh%bh%nnz_l_sp,MPI_REAL8,&
        MPI_STATUS_IGNORE,ierr)

   call elsi_check_err(rwh%bh,"MPI_File_write_at_all",ierr,caller)

   ! Close file
   call MPI_File_close(f_handle,ierr)

   call elsi_check_err(rwh%bh,"MPI_File_close",ierr,caller)

end subroutine

!>
!! Write a 1D block CSC matrix to file.
!!
subroutine elsi_write_mat_real_sparse_i4(rwh,f_name,row_ind,col_ptr_i4,mat)

   implicit none

   type(elsi_rw_handle), intent(in) :: rwh !< Handle
   character(len=*), intent(in) :: f_name !< File name
   integer(kind=i4), intent(in) :: row_ind(rwh%bh%nnz_l_sp) !< Row index
   integer(kind=i4), intent(in) :: col_ptr_i4(rwh%bh%n_lcol_sp+1) !< Column pointer
   real(kind=r8), intent(in) :: mat(rwh%bh%nnz_l_sp) !< Matrix

   integer(kind=i8) :: col_ptr(rwh%bh%n_lcol_sp+1)
   character(len=*), parameter :: caller = "elsi_write_mat_real_sparse_i4"

   col_ptr = int(col_ptr_i4,kind=i8)
   call elsi_write_mat_real_sparse_i8(rwh,f_name,row_ind,col_ptr,mat)

end subroutine

!>
!! Write a 1D block CSC matrix to file.
!!
subroutine elsi_write_mat_complex_sparse_i8(rwh,f_name,row_ind,col_ptr,mat)

   implicit none

   type(elsi_rw_handle), intent(in) :: rwh !< Handle
   character(len=*), intent(in) :: f_name !< File name
   integer(kind=i4), intent(in) :: row_ind(rwh%bh%nnz_l_sp) !< Row index
   integer(kind=i8), intent(in) :: col_ptr(rwh%bh%n_lcol_sp+1) !< Column pointer
   complex(kind=r8), intent(in) :: mat(rwh%bh%nnz_l_sp) !< Matrix

   integer(kind=i4) :: ierr
   integer(kind=i4) :: f_handle
   integer(kind=i4) :: f_mode
   integer(kind=i8) :: header(HEADER_SIZE)
   integer(kind=i8) :: prev_nnz
   integer(kind=i4) :: n_lcol0
   integer(kind=i8) :: offset

   integer(kind=i8), allocatable :: col_ptr_shift(:)

   character(len=*), parameter :: caller = "elsi_write_mat_complex_sparse_i8"

   call elsi_check_init(rwh%bh,rwh%handle_init,caller)
   call elsi_check_rw(rwh%bh,rwh%parallel_mode,rwh%n_basis,caller)

   ! Open file
   f_mode = MPI_MODE_WRONLY+MPI_MODE_CREATE

   call MPI_File_open(rwh%bh%comm,f_name,f_mode,MPI_INFO_NULL,f_handle,ierr)

   call elsi_check_err(rwh%bh,"MPI_File_open",ierr,caller)

   ! Write header
   header(1) = FILE_VERSION
   header(2) = UNSET
   header(3) = CMPLX_DATA
   header(4) = rwh%n_basis
   header(5) = nint(rwh%n_electrons,kind=i4)
   header(6) = rwh%bh%nnz_g
   header(7:8) = UNSET
   header(9:16) = rwh%header_user

   if(rwh%bh%myid == 0) then
      offset = 0

      call MPI_File_write_at(f_handle,offset,header,HEADER_SIZE,MPI_INTEGER8,&
           MPI_STATUS_IGNORE,ierr)

      call elsi_check_err(rwh%bh,"MPI_File_write_at",ierr,caller)
   end if

   ! Compute shift of column pointers
   prev_nnz = 0

   call MPI_Exscan(rwh%bh%nnz_l_sp,prev_nnz,1,MPI_INTEGER8,MPI_SUM,rwh%bh%comm,&
        ierr)

   call elsi_check_err(rwh%bh,"MPI_Exscan",ierr,caller)

   ! Shift column pointer
   call elsi_allocate(rwh%bh,col_ptr_shift,rwh%bh%n_lcol_sp+1,"col_ptr_shift",&
        caller)

   col_ptr_shift(:) = col_ptr+prev_nnz

   ! Write column pointer
   n_lcol0 = rwh%n_basis/rwh%bh%n_procs
   offset = int(HEADER_SIZE,kind=i8)*8+rwh%bh%myid*n_lcol0*8

   call MPI_File_write_at_all(f_handle,offset,col_ptr_shift,rwh%bh%n_lcol_sp,&
        MPI_INTEGER8,MPI_STATUS_IGNORE,ierr)

   call elsi_check_err(rwh%bh,"MPI_File_write_at_all",ierr,caller)

   call elsi_deallocate(rwh%bh,col_ptr_shift,"col_ptr_shift")

   ! Write row index
   offset = int(HEADER_SIZE,kind=i8)*8+rwh%n_basis*8+int(prev_nnz, kind=i8)*4

   call MPI_File_write_at_all(f_handle,offset,row_ind,rwh%bh%nnz_l_sp,&
        MPI_INTEGER4,MPI_STATUS_IGNORE,ierr)

   call elsi_check_err(rwh%bh,"MPI_File_write_at_all",ierr,caller)

   ! Write nonzero value
   offset = int(HEADER_SIZE,kind=i8)*8+rwh%n_basis*8+int(rwh%bh%nnz_g, kind=i8)*4+int(prev_nnz, kind=i8)*16

   call MPI_File_write_at_all(f_handle,offset,mat,rwh%bh%nnz_l_sp,&
        MPI_COMPLEX16,MPI_STATUS_IGNORE,ierr)

   call elsi_check_err(rwh%bh,"MPI_File_write_at_all",ierr,caller)

   ! Close file
   call MPI_File_close(f_handle,ierr)

   call elsi_check_err(rwh%bh,"MPI_File_close",ierr,caller)

end subroutine

!>
!! Write a 1D block CSC matrix to file.
!!
subroutine elsi_write_mat_complex_sparse_i4(rwh,f_name,row_ind,col_ptr_i4,mat)

   implicit none

   type(elsi_rw_handle), intent(in) :: rwh !< Handle
   character(len=*), intent(in) :: f_name !< File name
   integer(kind=i4), intent(in) :: row_ind(rwh%bh%nnz_l_sp) !< Row index
   integer(kind=i4), intent(in) :: col_ptr_i4(rwh%bh%n_lcol_sp+1) !< Column pointer
   complex(kind=r8), intent(in) :: mat(rwh%bh%nnz_l_sp) !< Matrix

   integer(kind=i8) :: col_ptr(rwh%bh%n_lcol_sp+1)

   character(len=*), parameter :: caller = "elsi_write_mat_complex_sparse_i4"

   col_ptr = int(col_ptr_i4,kind=i8)

   call elsi_write_mat_complex_sparse_i8(rwh,f_name,row_ind,col_ptr,mat)

end subroutine

!>
!! Read the dimensions of a 2D block-cyclic dense matrix from file.
!!
subroutine elsi_read_mat_dim_sp(rwh,f_name,n_electron,n_basis,n_lrow,n_lcol)

   implicit none

   type(elsi_rw_handle), intent(inout) :: rwh !< Handle
   character(len=*), intent(in) :: f_name !< File name
   real(kind=r8), intent(out) :: n_electron !< Number of electrons
   integer(kind=i4), intent(out) :: n_basis !< Matrix size
   integer(kind=i4), intent(out) :: n_lrow !< Local number of rows
   integer(kind=i4), intent(out) :: n_lcol !< Local number of columns

   integer(kind=i8) :: header(HEADER_SIZE)
   integer(kind=i4) :: f_unit
   integer(kind=i8) :: offset
   integer(kind=i4) :: ierr
   character(len=200) :: msg

   character(len=*), parameter :: caller = "elsi_read_mat_dim_sp"

   ! Open file
   call elsi_get_unit(f_unit)

   open(f_unit,file=f_name,access="stream",form="unformatted",status="old",&
      iostat=ierr)

   if(ierr /= 0) then
      write(msg,"(2A)") "Failed to open file ",trim(f_name)
      call elsi_stop(rwh%bh,msg,caller)
   end if

   ! Read header
   offset = 1

   read(f_unit,pos=offset) header

   close(f_unit)

   n_basis = header(4)
   n_electron = real(header(5),kind=r8)
   n_lrow = n_basis
   n_lcol = n_basis
   rwh%n_basis = n_basis
   rwh%n_electrons = n_electron
   rwh%bh%n_lrow = n_lrow
   rwh%bh%n_lcol = n_lcol
   rwh%header_user(:) = header(9:16)

end subroutine

!>
!! Read a 2D block-cyclic dense matrix from file.
!!
subroutine elsi_read_mat_sp_real(rwh,f_name,mat)

   implicit none

   type(elsi_rw_handle), intent(inout) :: rwh !< Handle
   character(len=*), intent(in) :: f_name !< File name
   real(kind=r8), intent(out) :: mat(rwh%bh%n_lrow,rwh%bh%n_lcol) !< Matrix

   integer(kind=i8) :: header(HEADER_SIZE)
   integer(kind=i8) :: i_val
   integer(kind=i8) :: i
   integer(kind=i8) :: j
   integer(kind=i8) :: this_nnz
   integer(kind=i4) :: f_unit
   integer(kind=i8) :: offset
   integer(kind=i4) :: ierr
   character(len=200) :: msg

   real(kind=r8), allocatable :: nnz_val(:)
   integer(kind=i4), allocatable :: row_ind(:)
   integer(kind=i8), allocatable :: col_ptr(:)

   character(len=*), parameter :: caller = "elsi_read_mat_sp_real"

   !integer(kind=i8) :: nnz_l_sp_temp

   ! Open file
   call elsi_get_unit(f_unit)

   open(f_unit,file=f_name,access="stream",form="unformatted",status="old",&
      iostat=ierr)

   if(ierr /= 0) then
      write(msg,"(2A)") "Failed to open file ",trim(f_name)
      call elsi_stop(rwh%bh,msg,caller)
   end if

   ! Read header
   offset = 1

   read(f_unit,pos=offset) header

   rwh%bh%nnz_g = header(6)
   !RUYI
   write(*,*) header(1:16)
   rwh%bh%nnz_l_sp = header(6)
   !nnz_l_sp_temp = header(6)
   rwh%bh%n_lcol_sp = rwh%n_basis

   call elsi_allocate(rwh%bh,col_ptr,rwh%bh%n_lcol_sp+1,"col_ptr",caller)

   ! Read column pointer
   offset = int(1,kind=i8)+HEADER_SIZE*8

   read(f_unit,pos=offset) col_ptr(1:rwh%bh%n_lcol_sp)

   col_ptr(rwh%bh%n_lcol_sp+1) = rwh%bh%nnz_g+1
   call elsi_allocate(rwh%bh,row_ind,rwh%bh%nnz_l_sp,"row_ind",caller)
   !call elsi_allocate(rwh%bh,row_ind,nnz_l_sp_temp,"row_ind",caller)

   ! Read row index
   offset = int(1,kind=i8)+HEADER_SIZE*8+rwh%n_basis*8

   read(f_unit,pos=offset) row_ind

   ! Read nonzero value
   offset = int(1,kind=i8)+int(HEADER_SIZE,kind=i8)*8+int(rwh%n_basis,kind=i4)*8+int(rwh%bh%nnz_g,kind=i8)*4
   call elsi_allocate(rwh%bh,nnz_val,rwh%bh%nnz_l_sp,"nnz_val",caller)
   !call elsi_allocate(rwh%bh,nnz_val,nnz_l_sp_temp,"nnz_val",caller)

   read(f_unit,pos=offset) nnz_val

   ! Close file
   close(f_unit)

   ! Convert to dense
   mat(:,:) = 0.0_r8

   i_val = 0
   do i = 1,rwh%n_basis
      this_nnz = col_ptr(i+1)-col_ptr(i)

      do j = i_val+1,i_val+this_nnz
         mat(row_ind(j),i) = nnz_val(j)
      end do

      i_val = i_val+this_nnz
   end do

   call elsi_deallocate(rwh%bh,col_ptr,"col_ptr")
   call elsi_deallocate(rwh%bh,row_ind,"row_ind")
   call elsi_deallocate(rwh%bh,nnz_val,"nnz_val")

end subroutine

!>
!! Read a 2D block-cyclic dense matrix from file.
!!
subroutine elsi_read_mat_sp_cmplx(rwh,f_name,mat)

   implicit none

   type(elsi_rw_handle), intent(inout) :: rwh !< Handle
   character(len=*), intent(in) :: f_name !< File name
   complex(kind=r8), intent(out) :: mat(rwh%bh%n_lrow,rwh%bh%n_lcol) !< Matrix

   integer(kind=i8) :: header(HEADER_SIZE)
   integer(kind=i8) :: i_val
   integer(kind=i8) :: i
   integer(kind=i8) :: j
   integer(kind=i8) :: this_nnz
   integer(kind=i4) :: f_unit
   integer(kind=i8) :: offset
   integer(kind=i4) :: ierr
   character(len=200) :: msg

   complex(kind=r8), allocatable :: nnz_val(:)
   integer(kind=i4), allocatable :: row_ind(:)
   integer(kind=i8), allocatable :: col_ptr(:)

   character(len=*), parameter :: caller = "elsi_read_mat_sp_cmplx"

   ! Open file
   call elsi_get_unit(f_unit)

   open(f_unit,file=f_name,access="stream",form="unformatted",status="old",&
      iostat=ierr)

   if(ierr /= 0) then
      write(msg,"(2A)") "Failed to open file ",trim(f_name)
      call elsi_stop(rwh%bh,msg,caller)
   end if

   ! Read header
   offset = 1

   read(f_unit,pos=offset) header

   rwh%bh%nnz_g = header(6)
   rwh%bh%nnz_l_sp = header(6)
   rwh%bh%n_lcol_sp = rwh%n_basis

   call elsi_allocate(rwh%bh,col_ptr,rwh%bh%n_lcol_sp+1,"col_ptr",caller)

   ! Read column pointer
   offset = int(1,kind=i8)+HEADER_SIZE*8

   read(f_unit,pos=offset) col_ptr(1:rwh%bh%n_lcol_sp)

   col_ptr(rwh%bh%n_lcol_sp+1) = rwh%bh%nnz_g+1

   call elsi_allocate(rwh%bh,row_ind,rwh%bh%nnz_l_sp,"row_ind",caller)

   ! Read row index
   offset = int(1,kind=i8)+HEADER_SIZE*8+rwh%n_basis*8

   read(f_unit,pos=offset) row_ind

   ! Read nonzero value
   offset = int(1,kind=i8)+HEADER_SIZE*8+rwh%n_basis*8+int(rwh%bh%nnz_g, kind=i8)*4

   call elsi_allocate(rwh%bh,nnz_val,rwh%bh%nnz_l_sp,"nnz_val",caller)

   read(f_unit,pos=offset) nnz_val

   ! Close file
   close(f_unit)

   ! Convert to dense
   mat(:,:) = (0.0_r8,0.0_r8)

   i_val = 0
   do i = 1,rwh%n_basis
      this_nnz = col_ptr(i+1)-col_ptr(i)

      do j = i_val+1,i_val+this_nnz
         mat(row_ind(j),i) = nnz_val(j)
      end do

      i_val = i_val+this_nnz
   end do

   call elsi_deallocate(rwh%bh,col_ptr,"col_ptr")
   call elsi_deallocate(rwh%bh,row_ind,"row_ind")
   call elsi_deallocate(rwh%bh,nnz_val,"nnz_val")

end subroutine

!>
!! Write a 2D block-cyclic dense matrix to file.
!!
subroutine elsi_write_mat_sp_real(rwh,f_name,mat)

   implicit none

   type(elsi_rw_handle), intent(in) :: rwh !< Handle
   character(len=*), intent(in) :: f_name !< File name
   real(kind=r8), intent(in) :: mat(rwh%bh%n_lrow,rwh%bh%n_lcol) !< Matrix

   integer(kind=i8) :: header(HEADER_SIZE)
   integer(kind=i8) :: i_val
   integer(kind=i8) :: i
   integer(kind=i8) :: j
   integer(kind=i8) :: this_nnz
   integer(kind=i8) :: nnz_g
   integer(kind=i4) :: f_unit
   integer(kind=i8) :: offset
   integer(kind=i4) :: ierr
   character(len=200) :: msg

   real(kind=r8), allocatable :: nnz_val(:)
   integer(kind=i4), allocatable :: row_ind(:)
   integer(kind=i8), allocatable :: col_ptr(:)

   character(len=*), parameter :: caller = "elsi_write_mat_sp_real"

   ! Compute nnz
!   nnz_g = count( (abs(mat) > rwh%bh%def0), kind=i8)
   nnz_g = 0
   do i = 1, rwh%bh%n_lrow
      do j = 1, rwh%bh%n_lcol
         if (abs(mat(i,j)) > rwh%bh%def0) nnz_g=nnz_g+1
      enddo
   enddo

   ! Convert to CSC
   call elsi_allocate(rwh%bh,col_ptr,rwh%n_basis+1,"col_ptr",caller)
   call elsi_allocate(rwh%bh,row_ind,nnz_g,"row_ind",caller)
   call elsi_allocate(rwh%bh,nnz_val,nnz_g,"nnz_val",caller)

   i_val = 0
   col_ptr(:) = 1
   row_ind(:) = 0

   do i = 1,rwh%bh%n_lcol
      this_nnz = 0

      do j = 1,rwh%bh%n_lrow
         if(abs(mat(j,i)) > rwh%bh%def0) then
            this_nnz = this_nnz+1
            i_val = i_val+1
            nnz_val(i_val) = mat(j,i)
            row_ind(i_val) = j
         end if
      end do
      col_ptr(i+1) = col_ptr(i)+this_nnz
   end do

   ! Open file
   call elsi_get_unit(f_unit)

   open(f_unit,file=f_name,access="stream",form="unformatted",iostat=ierr)

   if(ierr /= 0) then
      write(msg,"(2A)") "Failed to open file ",trim(f_name)
      call elsi_stop(rwh%bh,msg,caller)
   end if

   ! Write header
   header(1) = FILE_VERSION
   header(2) = UNSET
   header(3) = REAL_DATA
   header(4) = rwh%n_basis
   header(5) = nint(rwh%n_electrons,kind=i4)
   header(6) = nnz_g
   header(7:8) = UNSET
   header(9:16) = rwh%header_user

   offset = 1
   write(f_unit,pos=offset) header

   ! Write column pointer
   offset = int(1,kind=i8)+HEADER_SIZE*8

   write(f_unit,pos=offset) col_ptr(1:rwh%n_basis)

   ! Write row index
   offset = int(1,kind=i8)+HEADER_SIZE*8+rwh%n_basis*8

   write(f_unit,pos=offset) row_ind

   ! Write nonzero value
   offset = int(1,kind=i8)+HEADER_SIZE*8+rwh%n_basis*8+int(nnz_g, kind=i8)*4

   write(f_unit,pos=offset) nnz_val

   ! Close file
   close(f_unit)

   call elsi_deallocate(rwh%bh,col_ptr,"col_ptr")
   call elsi_deallocate(rwh%bh,row_ind,"row_ind")
   call elsi_deallocate(rwh%bh,nnz_val,"nnz_val")

end subroutine

!>
!! Write a 2D block-cyclic dense matrix to file.
!!
subroutine elsi_write_mat_sp_cmplx(rwh,f_name,mat)

   implicit none

   type(elsi_rw_handle), intent(in) :: rwh !< Handle
   character(len=*), intent(in) :: f_name !< File name
   complex(kind=r8), intent(in) :: mat(rwh%bh%n_lrow,rwh%bh%n_lcol) !< Matrix

   integer(kind=i8) :: header(HEADER_SIZE)
   integer(kind=i8) :: i_val
   integer(kind=i8) :: i
   integer(kind=i8) :: j
   integer(kind=i8) :: this_nnz
   integer(kind=i8) :: nnz_g
   integer(kind=i4) :: f_unit
   integer(kind=i8) :: offset
   integer(kind=i4) :: ierr
   character(len=200) :: msg

   complex(kind=r8), allocatable :: nnz_val(:)
   integer(kind=i4), allocatable :: row_ind(:)
   integer(kind=i8), allocatable :: col_ptr(:)

   character(len=*), parameter :: caller = "elsi_write_mat_sp_cmplx"

   ! Compute nnz
!   nnz_g = count( (abs(mat) > rwh%bh%def0), kind=i8)
   nnz_g = 0
   do i = 1, rwh%bh%n_lrow
      do j = 1, rwh%bh%n_lcol
         if (abs(mat(i,j)) > rwh%bh%def0) nnz_g=nnz_g+1
      enddo
   enddo

   ! Convert to CSC
   call elsi_allocate(rwh%bh,col_ptr,rwh%n_basis+1,"col_ptr",caller)
   call elsi_allocate(rwh%bh,row_ind,nnz_g,"row_ind",caller)
   call elsi_allocate(rwh%bh,nnz_val,nnz_g,"nnz_val",caller)

   i_val = 0
   col_ptr(:) = 1

   do i = 1,rwh%bh%n_lcol
      this_nnz = 0

      do j = 1,rwh%bh%n_lrow
         if(abs(mat(j,i)) > rwh%bh%def0) then
            this_nnz = this_nnz+1
            i_val = i_val+1
            nnz_val(i_val) = mat(j,i)
            row_ind(i_val) = j
         end if
      end do

      col_ptr(i+1) = col_ptr(i)+this_nnz
   end do

   ! Open file
   call elsi_get_unit(f_unit)

   open(f_unit,file=f_name,access="stream",form="unformatted",iostat=ierr)

   if(ierr /= 0) then
      write(msg,"(2A)") "Failed to open file ",trim(f_name)
      call elsi_stop(rwh%bh,msg,caller)
   end if

   ! Write header
   header(1) = FILE_VERSION
   header(2) = UNSET
   header(3) = CMPLX_DATA
   header(4) = rwh%n_basis
   header(5) = nint(rwh%n_electrons,kind=i4)
   header(6) = nnz_g
   header(7:8) = UNSET
   header(9:16) = rwh%header_user

   offset = 1
   write(f_unit,pos=offset) header

   ! Write column pointer
   offset = int(1,kind=i8)+HEADER_SIZE*8

   write(f_unit,pos=offset) col_ptr(1:rwh%n_basis)

   ! Write row index
   offset = int(1,kind=i8)+HEADER_SIZE*8+rwh%n_basis*8

   write(f_unit,pos=offset) row_ind

   ! Write nonzero value
   offset = int(1,kind=i8)+HEADER_SIZE*8+rwh%n_basis*8+int(nnz_g, kind=i8)*4

   write(f_unit,pos=offset) nnz_val

   ! Close file
   close(f_unit)

   call elsi_deallocate(rwh%bh,col_ptr,"col_ptr")
   call elsi_deallocate(rwh%bh,row_ind,"row_ind")
   call elsi_deallocate(rwh%bh,nnz_val,"nnz_val")

end subroutine

end module ELSI_RW
