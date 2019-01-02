! Copyright (c) 2015-2019, the ELSI team.
! All rights reserved.
!
! This file is part of ELSI and is distributed under the BSD 3-clause license,
! which may be found in the LICENSE file in the ELSI root directory.

!>
!! This module contains a collection of basic utility routines.
!!
module ELSI_UTILS

   use ELSI_CONSTANTS, only: UNSET,UT_MAT,LT_MAT,N_SOLVERS,N_PARALLEL_MODES,&
       N_MATRIX_FORMATS,MULTI_PROC,SINGLE_PROC,BLACS_DENSE,PEXSI_CSC,&
       SIESTA_CSC,GENERIC_COO,ELPA_SOLVER,OMM_SOLVER,PEXSI_SOLVER,SIPS_SOLVER,&
       NTPOLY_SOLVER
   use ELSI_DATATYPE, only: elsi_param_t,elsi_basic_t
   use ELSI_IO, only: elsi_say,elsi_get_time
   use ELSI_MALLOC, only: elsi_allocate,elsi_deallocate
   use ELSI_MPI, only: elsi_stop,elsi_check_mpi,mpi_sum,mpi_real8,&
       mpi_complex16,mpi_comm_self
   use ELSI_PRECISION, only: i4,r8

   implicit none

   private

   public :: elsi_check
   public :: elsi_check_init
   public :: elsi_reset_param
   public :: elsi_reset_basic
   public :: elsi_get_gid
   public :: elsi_get_lid
   public :: elsi_get_nnz
   public :: elsi_trace_mat
   public :: elsi_trace_mat_mat
   public :: elsi_set_full_mat
   public :: elsi_build_dm
   public :: elsi_build_edm
   public :: elsi_gram_schmidt

   interface elsi_get_nnz
      module procedure elsi_get_nnz_real
      module procedure elsi_get_nnz_cmplx
   end interface

   interface elsi_trace_mat
      module procedure elsi_trace_mat_real
      module procedure elsi_trace_mat_cmplx
   end interface

   interface elsi_trace_mat_mat
      module procedure elsi_trace_mat_mat_real
      module procedure elsi_trace_mat_mat_cmplx
   end interface

   interface elsi_set_full_mat
      module procedure elsi_set_full_mat_real
      module procedure elsi_set_full_mat_cmplx
   end interface

   interface elsi_build_dm
      module procedure elsi_build_dm_real
      module procedure elsi_build_dm_cmplx
   end interface

   interface elsi_build_edm
      module procedure elsi_build_edm_real
      module procedure elsi_build_edm_cmplx
   end interface

   interface elsi_gram_schmidt
      module procedure elsi_gram_schmidt_real
      module procedure elsi_gram_schmidt_cmplx
   end interface

contains

!>
!! This routine resets ELSI runtime parameters.
!!
subroutine elsi_reset_param(ph)

   implicit none

   type(elsi_param_t), intent(out) :: ph

   character(len=*), parameter :: caller = "elsi_reset_handle"

   ph%solver = UNSET
   ph%matrix_format = UNSET
   ph%parallel_mode = UNSET
   ph%n_calls = 0
   ph%n_calls_all = 0
   ph%save_ovlp = .false.
   ph%unit_ovlp = .false.
   ph%ill_ovlp = .false.
   ph%ill_check = .true.
   ph%ill_tol = 1.0e-5_r8
   ph%ill_abort = .false.
   ph%n_good = UNSET
   ph%n_electrons = 0.0_r8
   ph%n_basis = UNSET
   ph%n_spins = 1
   ph%n_kpts = 1
   ph%n_states = UNSET
   ph%n_states_solve = UNSET
   ph%i_spin = 1
   ph%i_kpt = 1
   ph%i_wt = 1.0_r8
   ph%spin_degen = 0.0_r8
   ph%spin_is_set = .false.
   ph%ebs = 0.0_r8
   ph%edm_ready_real = .false.
   ph%edm_ready_cmplx = .false.
   ph%mu = 0.0_r8
   ph%ts = 0.0_r8
   ph%mu_scheme = 0
   ph%mu_width = 1.0e-2_r8
   ph%mu_tol = 1.0e-13_r8
   ph%mu_max_steps = 100
   ph%mu_mp_order = 1
   ph%first_blacs_to_ntpoly = .true.
   ph%first_blacs_to_pexsi = .true.
   ph%first_blacs_to_sips = .true.
   ph%first_generic_to_blacs = .true.
   ph%first_generic_to_ntpoly = .true.
   ph%first_generic_to_pexsi = .true.
   ph%first_siesta_to_blacs = .true.
   ph%first_siesta_to_pexsi = .true.
   ph%first_sips_to_blacs = .true.
   ph%first_sips_to_ntpoly = .true.
   ph%elpa_solver = 2
   ph%elpa_n_single = 0
   ph%elpa_comm_row = UNSET
   ph%elpa_comm_col = UNSET
   ph%elpa_gpu = .false.
   ph%elpa_gpu_kernels = .false.
   ph%elpa_autotune = .false.
   ph%elpa_output = .false.
   ph%elpa_first = .true.
   ph%elpa_started = .false.
   ph%omm_n_lrow = UNSET
   ph%omm_n_states = UNSET
   ph%omm_n_elpa = 5
   ph%omm_flavor = 0
   ph%omm_desc = UNSET
   ph%omm_tol = 1.0e-12_r8
   ph%omm_output = .false.
   ph%omm_first = .true.
   ph%omm_started = .false.
   ph%pexsi_np_per_pole = UNSET
   ph%pexsi_np_per_point = UNSET
   ph%pexsi_my_prow = UNSET
   ph%pexsi_my_pcol = UNSET
   ph%pexsi_n_prow = UNSET
   ph%pexsi_n_pcol = UNSET
   ph%pexsi_my_point = UNSET
   ph%pexsi_myid_point = UNSET
   ph%pexsi_comm_intra_pole = UNSET
   ph%pexsi_comm_inter_pole = UNSET
   ph%pexsi_comm_inter_point = UNSET
   ph%pexsi_ne = 0.0_r8
   ph%pexsi_first = .true.
   ph%pexsi_started = .false.
   ph%sips_n_elpa = 0
   ph%sips_np_per_slice = UNSET
   ph%sips_n_slices = UNSET
   ph%sips_slice_type = 2
   ph%sips_buffer = 1.0e-2_r8
   ph%sips_interval(1) = -2.0_r8
   ph%sips_interval(2) = 2.0_r8
   ph%sips_inertia_tol = 1.0e-3_r8
   ph%sips_do_inertia = .true.
   ph%sips_first = .true.
   ph%sips_started = .false.
   ph%nt_n_group = 1
   ph%nt_method = 2
   ph%nt_isr = 5
   ph%nt_max_iter = 100
   ph%nt_tol = 1.0e-8_r8
   ph%nt_filter = 1.0e-15_r8
   ph%nt_output = .false.
   ph%nt_first = .true.
   ph%nt_started = .false.

end subroutine

!>
!! This routine resets ELSI basic information.
!!
subroutine elsi_reset_basic(bh)

   implicit none

   type(elsi_basic_t), intent(out) :: bh

   character(len=*), parameter :: caller = "elsi_reset_basic"

   bh%print_info = 0
   bh%print_unit = 6
   bh%print_json = 0
   bh%json_init = .false.
   bh%user_tag = ""
   bh%uuid = ""
   bh%uuid_ready = .false.
   bh%myid = UNSET
   bh%myid_all = UNSET
   bh%n_procs = UNSET
   bh%n_procs_all = UNSET
   bh%comm = UNSET
   bh%comm_all = UNSET
   bh%mpi_ready = .false.
   bh%mpi_all_ready = .false.
   bh%blacs_ctxt = UNSET
   bh%desc = UNSET
   bh%blk = UNSET
   bh%n_prow = UNSET
   bh%n_pcol = UNSET
   bh%my_prow = UNSET
   bh%my_pcol = UNSET
   bh%n_lrow = UNSET
   bh%n_lcol = UNSET
   bh%nnz_l = UNSET
   bh%blacs_ready = .false.
   bh%nnz_g = UNSET
   bh%nnz_l_sp = UNSET
   bh%n_lcol_sp = UNSET
   bh%def0 = 1.0e-15_r8
   bh%nnz_l_sp1 = UNSET
   bh%n_lcol_sp1 = UNSET
   bh%pexsi_csc_ready = .false.
   bh%nnz_l_sp2 = UNSET
   bh%n_lcol_sp2 = UNSET
   bh%blk_sp2 = UNSET
   bh%siesta_csc_ready = .false.
   bh%nnz_l_sp3 = UNSET
   bh%generic_coo_ready = .false.

end subroutine

!>
!! This routine guarantees that there are no unsupported or mutually conflicting
!! parameters before running actual calculations.
!!
subroutine elsi_check(ph,bh,caller)

   implicit none

   type(elsi_param_t), intent(inout) :: ph
   type(elsi_basic_t), intent(inout) :: bh
   character(len=*), intent(in) :: caller

   ! General check of solver, parallel mode, matrix format
   if(ph%solver < 0 .or. ph%solver >= N_SOLVERS) then
      call elsi_stop(bh,"Unsupported solver.",caller)
   end if

   if(ph%parallel_mode < 0 .or. ph%parallel_mode >= N_PARALLEL_MODES) then
      call elsi_stop(bh,"Unsupported parallel mode.",caller)
   end if

   if(ph%matrix_format < 0 .or. ph%matrix_format >= N_MATRIX_FORMATS) then
      call elsi_stop(bh,"Unsupported matirx format.",caller)
   end if

   ! Spin
   if(ph%n_spins > 1 .and. .not. bh%mpi_all_ready) then
      call elsi_stop(bh,"Calculations with two spin channels require a"//&
           " global MPI communicator.",caller)
   end if

   ! k-point
   if(ph%n_kpts > 1 .and. .not. bh%mpi_all_ready) then
      call elsi_stop(bh,"Calculations with multiple k-points require a"//&
           " global MPI communicator.",caller)
   end if

   if(.not. ph%spin_is_set) then
      if(ph%n_spins == 2) then
         ph%spin_degen = 1.0_r8
      else
         ph%spin_degen = 2.0_r8
      end if
   end if

   if(.not. bh%mpi_ready) then
      bh%comm = mpi_comm_self
      bh%n_procs = 1
      bh%myid = 0
   end if

   if(.not. bh%mpi_all_ready) then
      bh%comm_all = bh%comm
      bh%n_procs_all = bh%n_procs
      bh%myid_all = bh%myid
   end if

   if(bh%myid_all /= 0) then
      bh%print_info = 0
   end if

   if(ph%parallel_mode == MULTI_PROC) then
      if(.not. bh%mpi_ready) then
         call elsi_stop(bh,"MULTI_PROC parallel mode requires MPI.",caller)
      end if
   end if

   if(ph%matrix_format == BLACS_DENSE) then
      if(.not. bh%blacs_ready .and. ph%parallel_mode /= SINGLE_PROC) then
         call elsi_stop(bh,"BLACS matrix format not properly set up.",caller)
      end if
   else if(ph%matrix_format == SIESTA_CSC) then
      if(.not. bh%siesta_csc_ready) then
         call elsi_stop(bh,"SIESTA_CSC matrix format not properly set up.",&
              caller)
      end if

      if(bh%blk_sp2 == UNSET) then
         call elsi_stop(bh,"Block size should be set for SIESTA_CSC matrix"//&
              " format.",caller)
      end if
   else if(ph%matrix_format == PEXSI_CSC) then
      if(.not. bh%pexsi_csc_ready) then
         call elsi_stop(bh,"PEXSI_CSC matrix format not properly set up.",&
              caller)
      end if

      if(ph%solver == PEXSI_SOLVER .and. ph%pexsi_np_per_pole == UNSET) then
         call elsi_stop(bh,"Number of MPI tasks per pole should be set for"//&
              " PEXSI_CSC matrix format and PEXSI solver.",caller)
      end if
   else if(ph%matrix_format == GENERIC_COO) then
      if(.not. bh%generic_coo_ready) then
         call elsi_stop(bh,"GENERIC_COO matrix format not properly set up.",&
              caller)
      end if
   end if

   if(ph%unit_ovlp) then
      ph%save_ovlp = .false.
   end if

   ! Specific check for each solver
   select case(ph%solver)
   case(ELPA_SOLVER)
      ! Nothing
   case(OMM_SOLVER)
      if(ph%parallel_mode /= MULTI_PROC) then
         call elsi_stop(bh,"libOMM requires MULTI_PROC parallel mode.",caller)
      end if
   case(PEXSI_SOLVER)
      if(ph%parallel_mode /= MULTI_PROC) then
         call elsi_stop(bh,"PEXSI requires MULTI_PROC parallel mode.",caller)
      end if

      if(mod(bh%n_procs,ph%pexsi_options%nPoints) /= 0) then
         call elsi_stop(bh,"To use PEXSI, number of mu points must be a"//&
              " divisor of number of MPI tasks.",caller)
      end if

      if(ph%pexsi_np_per_pole /= UNSET) then
         if(mod(bh%n_procs,ph%pexsi_np_per_pole*ph%pexsi_options%nPoints)&
            /= 0) then
            call elsi_stop(bh,"To use PEXSI, specified number of MPI tasks"//&
                 " per pole times number of mu points must be a divisor of"//&
                 " number of MPI tasks.",caller)
         end if

         if(ph%pexsi_np_per_pole*ph%pexsi_options%numPole&
            *ph%pexsi_options%nPoints < bh%n_procs) then
            call elsi_stop(bh,"Specified number of MPI tasks per pole too"//&
                 " small for this number of MPI tasks.",caller)
         end if
      end if
   case(SIPS_SOLVER)
      if(ph%n_basis < bh%n_procs) then
         call elsi_stop(bh,"Matrix size too small to use SLEPc-SIPs with"//&
              " this number of MPI tasks.",caller)
      end if

      if(ph%parallel_mode /= MULTI_PROC) then
         call elsi_stop(bh,"SLEPc-SIPs requires MULTI_PROC parallel mode.",&
              caller)
      end if

      if(ph%n_spins > 1) then
         call elsi_stop(bh,"Calculations with two spin channels not yet"//&
              " supported with SLEPc-SIPs.",caller)
      end if

      if(ph%n_kpts > 1) then
         call elsi_stop(bh,"Calculations with multiple k-points not yet"//&
              " supported with SLEPc-SIPs.",caller)
      end if
   case(NTPOLY_SOLVER)
      if(ph%parallel_mode /= MULTI_PROC) then
         call elsi_stop(bh,"NTPoly requires MULTI_PROC parallel mode.",caller)
      end if
   end select

end subroutine

!>
!! This routine checks whether a handle has been properly initialized.
!!
subroutine elsi_check_init(bh,init,caller)

   implicit none

   type(elsi_basic_t), intent(in) :: bh
   logical, intent(in) :: init
   character(len=*), intent(in) :: caller

   if(.not. init) then
      call elsi_stop(bh,"Invalid handle! Not initialized.",caller)
   end if

end subroutine

!>
!! This routine gets the global index from the local index of a 2D block-cyclic
!! distribution.
!!
subroutine elsi_get_gid(myid,n_procs,blk,lid,gid)

   implicit none

   integer(kind=i4), intent(in) :: myid
   integer(kind=i4), intent(in) :: n_procs
   integer(kind=i4), intent(in) :: blk
   integer(kind=i4), intent(in) :: lid
   integer(kind=i4), intent(out) :: gid

   character(len=*), parameter :: caller = "elsi_get_gid"

   gid = lid+myid*blk+((lid-1)/blk)*blk*(n_procs-1)

end subroutine

!>
!! This routine gets the local index from the global index of a 2D block-cyclic
!! distribution.
!!
subroutine elsi_get_lid(n_procs,blk,gid,lid)

   implicit none

   integer(kind=i4), intent(in) :: n_procs
   integer(kind=i4), intent(in) :: blk
   integer(kind=i4), intent(in) :: gid
   integer(kind=i4), intent(out) :: lid

   character(len=*), parameter :: caller = "elsi_get_lid"

   lid = (gid-1)/(n_procs*blk)*blk+mod((gid-1),blk)+1

end subroutine

!>
!! This routine counts the number of non_zero elements in a matrix.
!!
subroutine elsi_get_nnz_real(def0,n_row,n_col,mat,nnz)

   implicit none

   real(kind=r8), intent(in) :: def0
   integer(kind=i4), intent(in) :: n_row
   integer(kind=i4), intent(in) :: n_col
   real(kind=r8), intent(in) :: mat(n_row,n_col)
   integer(kind=i4), intent(out) :: nnz

   integer(kind=i4) :: i_row
   integer(kind=i4) :: i_col

   character(len=*), parameter :: caller = "elsi_get_nnz_real"

   nnz = 0

   do i_col = 1,n_col
      do i_row = 1,n_row
         if(abs(mat(i_row,i_col)) > def0) then
            nnz = nnz+1
         end if
      end do
   end do

end subroutine

!>
!! This routine counts the number of non_zero elements in a matrix.
!!
subroutine elsi_get_nnz_cmplx(def0,n_row,n_col,mat,nnz)

   implicit none

   real(kind=r8), intent(in) :: def0
   integer(kind=i4), intent(in) :: n_row
   integer(kind=i4), intent(in) :: n_col
   complex(kind=r8), intent(in) :: mat(n_row,n_col)
   integer(kind=i4), intent(out) :: nnz

   integer(kind=i4) :: i_row
   integer(kind=i4) :: i_col

   character(len=*), parameter :: caller = "elsi_get_nnz_cmplx"

   nnz = 0

   do i_col = 1,n_col
      do i_row = 1,n_row
         if(abs(mat(i_row,i_col)) > def0) then
            nnz = nnz+1
         end if
      end do
   end do

end subroutine

!>
!! This routine computes the trace of a matrix. The size of the matrix is
!! restricted to be identical to Hamiltonian.
!!
subroutine elsi_trace_mat_real(ph,bh,row_map,col_map,mat,trace)

   implicit none

   type(elsi_param_t), intent(in) :: ph
   type(elsi_basic_t), intent(in) :: bh
   integer(kind=i4), intent(in) :: row_map(ph%n_basis)
   integer(kind=i4), intent(in) :: col_map(ph%n_basis)
   real(kind=r8), intent(in) :: mat(bh%n_lrow,bh%n_lcol)
   real(kind=r8), intent(out) :: trace

   integer(kind=i4) :: i
   integer(kind=i4) :: ierr
   real(kind=r8) :: l_trace ! Local result

   character(len=*), parameter :: caller = "elsi_trace_mat_real"

   l_trace = 0.0_r8

   do i = 1,ph%n_basis
      if(row_map(i) > 0 .and. col_map(i) > 0) then
         l_trace = l_trace + mat(row_map(i),col_map(i))
      end if
   end do

   call MPI_Allreduce(l_trace,trace,1,mpi_real8,mpi_sum,bh%comm,ierr)

   call elsi_check_mpi(bh,"MPI_Allreduce",ierr,caller)

end subroutine

!>
!! This routine computes the trace of a matrix. The size of the matrix is
!! restricted to be identical to Hamiltonian.
!!
subroutine elsi_trace_mat_cmplx(ph,bh,row_map,col_map,mat,trace)

   implicit none

   type(elsi_param_t), intent(in) :: ph
   type(elsi_basic_t), intent(in) :: bh
   integer(kind=i4), intent(in) :: row_map(ph%n_basis)
   integer(kind=i4), intent(in) :: col_map(ph%n_basis)
   complex(kind=r8), intent(in) :: mat(bh%n_lrow,bh%n_lcol)
   complex(kind=r8), intent(out) :: trace

   integer(kind=i4) :: i
   integer(kind=i4) :: ierr
   complex(kind=r8) :: l_trace ! Local result

   character(len=*), parameter :: caller = "elsi_trace_mat_cmplx"

   l_trace = (0.0_r8,0.0_r8)

   do i = 1,ph%n_basis
      if(row_map(i) > 0 .and. col_map(i) > 0) then
         l_trace = l_trace + mat(row_map(i),col_map(i))
      end if
   end do

   call MPI_Allreduce(l_trace,trace,1,mpi_complex16,mpi_sum,bh%comm,ierr)

   call elsi_check_mpi(bh,"MPI_Allreduce",ierr,caller)

end subroutine

!>
!! This routine computes the trace of the product of two matrices. The size of
!! the two matrices is restricted to be identical to Hamiltonian.
!!
subroutine elsi_trace_mat_mat_real(bh,mat1,mat2,trace)

   implicit none

   type(elsi_basic_t), intent(in) :: bh
   real(kind=r8), intent(in) :: mat1(bh%n_lrow,bh%n_lcol)
   real(kind=r8), intent(in) :: mat2(bh%n_lrow,bh%n_lcol)
   real(kind=r8), intent(out) :: trace

   real(kind=r8) :: l_trace ! Local result
   integer(kind=i4) :: ierr

   real(kind=r8), external :: ddot

   character(len=*), parameter :: caller = "elsi_trace_mat_mat_real"

   l_trace = ddot(bh%n_lrow*bh%n_lcol,mat1,1,mat2,1)

   call MPI_Allreduce(l_trace,trace,1,mpi_real8,mpi_sum,bh%comm,ierr)

   call elsi_check_mpi(bh,"MPI_Allreduce",ierr,caller)

end subroutine

!>
!! This routine computes the trace of the product of two matrices. The size of
!! the two matrices is restricted to be identical to Hamiltonian.
!!
subroutine elsi_trace_mat_mat_cmplx(bh,mat1,mat2,trace)

   implicit none

   type(elsi_basic_t), intent(in) :: bh
   complex(kind=r8), intent(in) :: mat1(bh%n_lrow,bh%n_lcol)
   complex(kind=r8), intent(in) :: mat2(bh%n_lrow,bh%n_lcol)
   complex(kind=r8), intent(out) :: trace

   complex(kind=r8) :: l_trace ! Local result
   integer(kind=i4) :: ierr

   complex(kind=r8), external :: zdotc

   character(len=*), parameter :: caller = "elsi_trace_mat_mat_cmplx"

   l_trace = zdotc(bh%n_lrow*bh%n_lcol,mat1,1,mat2,1)

   call MPI_Allreduce(l_trace,trace,1,mpi_complex16,mpi_sum,bh%comm,ierr)

   call elsi_check_mpi(bh,"MPI_Allreduce",ierr,caller)

end subroutine

!>
!! This routine symmetrizes an upper or lower triangular matrix. The size of
!! the matrix should be the same as the Hamiltonian matrix.
!!
subroutine elsi_set_full_mat_real(ph,bh,uplo,row_map,col_map,mat)

   implicit none

   type(elsi_param_t), intent(in) :: ph
   type(elsi_basic_t), intent(in) :: bh
   integer(kind=i4), intent(in) :: uplo
   integer(kind=i4), intent(in) :: row_map(ph%n_basis)
   integer(kind=i4), intent(in) :: col_map(ph%n_basis)
   real(kind=r8), intent(inout) :: mat(bh%n_lrow,bh%n_lcol)

   integer(kind=i4) :: i
   integer(kind=i4) :: j

   real(kind=r8), allocatable :: tmp(:,:)

   character(len=*), parameter :: caller = "elsi_set_full_mat_real"

   call elsi_allocate(bh,tmp,bh%n_lrow,bh%n_lcol+2*bh%blk,"tmp",caller)

   call pdtran(ph%n_basis,ph%n_basis,1.0_r8,mat,1,1,bh%desc,0.0_r8,tmp,1,1,&
        bh%desc)

   if(uplo == UT_MAT) then
      do j = 1,ph%n_basis-1
         if(col_map(j) > 0) then
            do i = j+1,ph%n_basis
               if(row_map(i) > 0) then
                  mat(row_map(i),col_map(j)) = tmp(row_map(i),col_map(j))
               end if
            end do
         end if
      end do
   else if(uplo == LT_MAT) then
      do j = 2,ph%n_basis
         if(col_map(j) > 0) then
            do i = 1,j-1
               if(row_map(i) > 0) then
                  mat(row_map(i),col_map(j)) = tmp(row_map(i),col_map(j))
               end if
            end do
         end if
      end do
   end if

   call elsi_deallocate(bh,tmp,"tmp")

end subroutine

!>
!! This routine symmetrizes an upper or lower triangular matrix. The size of
!! the matrix should be the same as the Hamiltonian matrix.
!!
subroutine elsi_set_full_mat_cmplx(ph,bh,uplo,row_map,col_map,mat)

   implicit none

   type(elsi_param_t), intent(in) :: ph
   type(elsi_basic_t), intent(in) :: bh
   integer(kind=i4), intent(in) :: uplo
   integer(kind=i4), intent(in) :: row_map(ph%n_basis)
   integer(kind=i4), intent(in) :: col_map(ph%n_basis)
   complex(kind=r8), intent(inout) :: mat(bh%n_lrow,bh%n_lcol)

   integer(kind=i4) :: i
   integer(kind=i4) :: j

   complex(kind=r8), allocatable :: tmp(:,:)

   character(len=*), parameter :: caller = "elsi_set_full_mat_cmplx"

   call elsi_allocate(bh,tmp,bh%n_lrow,bh%n_lcol+2*bh%blk,"tmp",caller)

   call pztranc(ph%n_basis,ph%n_basis,(1.0_r8,0.0_r8),mat,1,1,bh%desc,&
        (0.0_r8,0.0_r8),tmp,1,1,bh%desc)

   if(uplo == UT_MAT) then
      do j = 1,ph%n_basis-1
         if(col_map(j) > 0) then
            do i = j+1,ph%n_basis
               if(row_map(i) > 0) then
                  mat(row_map(i),col_map(j)) = tmp(row_map(i),col_map(j))
               end if
            end do
         end if
      end do
   else if(uplo == LT_MAT) then
      do j = 2,ph%n_basis
         if(col_map(j) > 0) then
            do i = 1,j-1
               if(row_map(i) > 0) then
                  mat(row_map(i),col_map(j)) = tmp(row_map(i),col_map(j))
               end if
            end do
         end if
      end do
   end if

   call elsi_deallocate(bh,tmp,"tmp")

   ! Make diagonal real
   do j = 1,ph%n_basis
      if(col_map(j) > 0 .and. row_map(j) > 0) then
         mat(row_map(j),col_map(j)) = real(mat(row_map(j),col_map(j)),kind=r8)
      end if
   end do

end subroutine

!>
!! This routine constructs the density matrix from occupation numbers and
!! eigenvectors.
!!
subroutine elsi_build_dm_real(ph,bh,row_map,col_map,occ,evec,dm)

   implicit none

   type(elsi_param_t), intent(in) :: ph
   type(elsi_basic_t), intent(in) :: bh
   integer(kind=i4), intent(in) :: row_map(ph%n_basis)
   integer(kind=i4), intent(in) :: col_map(ph%n_basis)
   real(kind=r8), intent(in) :: occ(ph%n_states)
   real(kind=r8), intent(in) :: evec(bh%n_lrow,bh%n_lcol)
   real(kind=r8), intent(out) :: dm(bh%n_lrow,bh%n_lcol)

   integer(kind=i4) :: i
   integer(kind=i4) :: max_state
   real(kind=r8) :: t0
   real(kind=r8) :: t1
   character(len=200) :: msg

   real(kind=r8), allocatable :: factor(:)
   real(kind=r8), allocatable :: tmp(:,:)

   character(len=*), parameter :: caller = "elsi_build_dm_real"

   call elsi_get_time(t0)

   call elsi_allocate(bh,factor,ph%n_states_solve,"factor",caller)
   call elsi_allocate(bh,tmp,bh%n_lrow,bh%n_lcol,"tmp",caller)

   max_state = 0

   do i = 1,ph%n_states_solve
      if(occ(i) > 0.0_r8) then
         factor(i) = sqrt(occ(i))
         max_state = i
      end if
   end do

   tmp = evec

   do i = 1,ph%n_states_solve
      if(factor(i) > 0.0_r8) then
         if(col_map(i) > 0) then
            tmp(:,col_map(i)) = tmp(:,col_map(i))*factor(i)
         end if
      else if(col_map(i) /= 0) then
         tmp(:,col_map(i)) = 0.0_r8
      end if
   end do

   dm = 0.0_r8

   ! Compute density matrix
   call pdsyrk("U","N",ph%n_basis,max_state,1.0_r8,tmp,1,1,bh%desc,0.0_r8,dm,1,&
        1,bh%desc)

   call elsi_deallocate(bh,factor,"factor")
   call elsi_deallocate(bh,tmp,"tmp")

   call elsi_set_full_mat(ph,bh,UT_MAT,row_map,col_map,dm)

   call elsi_get_time(t1)

   write(msg,"(2X,A)") "Finished density matrix calculation"
   call elsi_say(bh,msg)
   write(msg,"(2X,A,F10.3,A)") "| Time :",t1-t0," s"
   call elsi_say(bh,msg)

end subroutine

!>
!! This routine constructs the density matrix from occupation numbers and
!! eigenvectors.
!!
subroutine elsi_build_dm_cmplx(ph,bh,row_map,col_map,occ,evec,dm)

   implicit none

   type(elsi_param_t), intent(in) :: ph
   type(elsi_basic_t), intent(in) :: bh
   integer(kind=i4), intent(in) :: row_map(ph%n_basis)
   integer(kind=i4), intent(in) :: col_map(ph%n_basis)
   real(kind=r8), intent(in) :: occ(ph%n_states)
   complex(kind=r8), intent(in) :: evec(bh%n_lrow,bh%n_lcol)
   complex(kind=r8), intent(out) :: dm(bh%n_lrow,bh%n_lcol)

   integer(kind=i4) :: i
   integer(kind=i4) :: max_state
   real(kind=r8) :: t0
   real(kind=r8) :: t1
   character(len=200) :: msg

   real(kind=r8), allocatable :: factor(:)
   complex(kind=r8), allocatable :: tmp(:,:)

   character(len=*), parameter :: caller = "elsi_build_dm_cmplx"

   call elsi_get_time(t0)

   call elsi_allocate(bh,factor,ph%n_states_solve,"factor",caller)
   call elsi_allocate(bh,tmp,bh%n_lrow,bh%n_lcol,"tmp",caller)

   max_state = 0

   do i = 1,ph%n_states_solve
      if(occ(i) > 0.0_r8) then
         factor(i) = sqrt(occ(i))
         max_state = i
      end if
   end do

   tmp = evec

   do i = 1,ph%n_states_solve
      if(factor(i) > 0.0_r8) then
         if(col_map(i) > 0) then
            tmp(:,col_map(i)) = tmp(:,col_map(i))*factor(i)
         end if
      else if(col_map(i) /= 0) then
         tmp(:,col_map(i)) = (0.0_r8,0.0_r8)
      end if
   end do

   dm = (0.0_r8,0.0_r8)

   ! Compute density matrix
   call pzherk("U","N",ph%n_basis,max_state,(1.0_r8,0.0_r8),tmp,1,1,bh%desc,&
        (0.0_r8,0.0_r8),dm,1,1,bh%desc)

   call elsi_deallocate(bh,factor,"factor")
   call elsi_deallocate(bh,tmp,"tmp")

   call elsi_set_full_mat(ph,bh,UT_MAT,row_map,col_map,dm)

   call elsi_get_time(t1)

   write(msg,"(2X,A)") "Finished density matrix calculation"
   call elsi_say(bh,msg)
   write(msg,"(2X,A,F10.3,A)") "| Time :",t1-t0," s"
   call elsi_say(bh,msg)

end subroutine

!>
!! This routine constructs the energy-weighted density matrix from occupation
!! numbers, eigenvalues, and eigenvectors.
!!
subroutine elsi_build_edm_real(ph,bh,row_map,col_map,occ,eval,evec,edm)

   implicit none

   type(elsi_param_t), intent(in) :: ph
   type(elsi_basic_t), intent(in) :: bh
   integer(kind=i4), intent(in) :: row_map(ph%n_basis)
   integer(kind=i4), intent(in) :: col_map(ph%n_basis)
   real(kind=r8), intent(in) :: occ(ph%n_states)
   real(kind=r8), intent(in) :: eval(ph%n_states)
   real(kind=r8), intent(in) :: evec(bh%n_lrow,bh%n_lcol)
   real(kind=r8), intent(out) :: edm(bh%n_lrow,bh%n_lcol)

   integer(kind=i4) :: i
   integer(kind=i4) :: max_state
   real(kind=r8) :: t0
   real(kind=r8) :: t1
   character(len=200) :: msg

   real(kind=r8), allocatable :: factor(:)
   real(kind=r8), allocatable :: tmp(:,:)

   character(len=*), parameter :: caller = "elsi_build_edm_real"

   call elsi_get_time(t0)

   call elsi_allocate(bh,factor,ph%n_states_solve,"factor",caller)
   call elsi_allocate(bh,tmp,bh%n_lrow,bh%n_lcol,"tmp",caller)

   max_state = 0

   do i = 1,ph%n_states_solve
      factor(i) = -occ(i)*eval(i)
      if(factor(i) > 0.0_r8) then
         factor(i) = sqrt(factor(i))
         max_state = i
      else
         factor(i) = 0.0_r8
      end if
   end do

   tmp = evec

   do i = 1,ph%n_states_solve
      if(factor(i) > 0.0_r8) then
         if(col_map(i) > 0) then
            tmp(:,col_map(i)) = tmp(:,col_map(i))*factor(i)
         end if
      else if(col_map(i) /= 0) then
         tmp(:,col_map(i)) = 0.0_r8
      end if
   end do

   edm = 0.0_r8

   ! Compute density matrix
   call pdsyrk("U","N",ph%n_basis,max_state,-1.0_r8,tmp,1,1,bh%desc,0.0_r8,edm,&
        1,1,bh%desc)

   call elsi_deallocate(bh,factor,"factor")
   call elsi_deallocate(bh,tmp,"tmp")

   call elsi_set_full_mat(ph,bh,UT_MAT,row_map,col_map,edm)

   call elsi_get_time(t1)

   write(msg,"(2X,A)") "Finished energy density matrix calculation"
   call elsi_say(bh,msg)
   write(msg,"(2X,A,F10.3,A)") "| Time :",t1-t0," s"
   call elsi_say(bh,msg)

end subroutine

!>
!! This routine constructs the energy-weighted density matrix from occupation
!! numbers, eigenvalues, and eigenvectors.
!!
subroutine elsi_build_edm_cmplx(ph,bh,row_map,col_map,occ,eval,evec,edm)

   implicit none

   type(elsi_param_t), intent(in) :: ph
   type(elsi_basic_t), intent(in) :: bh
   integer(kind=i4), intent(in) :: row_map(ph%n_basis)
   integer(kind=i4), intent(in) :: col_map(ph%n_basis)
   real(kind=r8), intent(in) :: occ(ph%n_states)
   real(kind=r8), intent(in) :: eval(ph%n_states)
   complex(kind=r8), intent(in) :: evec(bh%n_lrow,bh%n_lcol)
   complex(kind=r8), intent(out) :: edm(bh%n_lrow,bh%n_lcol)

   integer(kind=i4) :: i
   integer(kind=i4) :: max_state
   real(kind=r8) :: t0
   real(kind=r8) :: t1
   character(len=200) :: msg

   real(kind=r8), allocatable :: factor(:)
   complex(kind=r8), allocatable :: tmp(:,:)

   character(len=*), parameter :: caller = "elsi_build_edm_cmplx"

   call elsi_get_time(t0)

   call elsi_allocate(bh,factor,ph%n_states_solve,"factor",caller)
   call elsi_allocate(bh,tmp,bh%n_lrow,bh%n_lcol,"tmp",caller)

   max_state = 0

   do i = 1,ph%n_states_solve
      factor(i) = -occ(i)*eval(i)
      if(factor(i) > 0.0_r8) then
         factor(i) = sqrt(factor(i))
         max_state = i
      else
         factor(i) = 0.0_r8
      end if
   end do

   tmp = evec

   do i = 1,ph%n_states_solve
      if(factor(i) > 0.0_r8) then
         if(col_map(i) > 0) then
            tmp(:,col_map(i)) = tmp(:,col_map(i))*factor(i)
         end if
      else if(col_map(i) /= 0) then
         tmp(:,col_map(i)) = (0.0_r8,0.0_r8)
      end if
   end do

   edm = (0.0_r8,0.0_r8)

   ! Compute density matrix
   call pzherk("U","N",ph%n_basis,max_state,(-1.0_r8,0.0_r8),tmp,1,1,bh%desc,&
        (0.0_r8,0.0_r8),edm,1,1,bh%desc)

   call elsi_deallocate(bh,factor,"factor")
   call elsi_deallocate(bh,tmp,"tmp")

   call elsi_set_full_mat(ph,bh,UT_MAT,row_map,col_map,edm)

   call elsi_get_time(t1)

   write(msg,"(2X,A)") "Finished energy density matrix calculation"
   call elsi_say(bh,msg)
   write(msg,"(2X,A,F10.3,A)") "| Time :",t1-t0," s"
   call elsi_say(bh,msg)

end subroutine

!>
!! This routine orthonormalizes eigenvectors with respect to an overlap matrix
!! using a modified Gram-Schmidt algorithm.
!!
subroutine elsi_gram_schmidt_real(ph,bh,col_map,ovlp,evec)

   implicit none

   type(elsi_param_t), intent(in) :: ph
   type(elsi_basic_t), intent(in) :: bh
   integer(kind=i4), intent(in) :: col_map(ph%n_basis)
   real(kind=r8), intent(in) :: ovlp(bh%n_lrow,bh%n_lcol)
   real(kind=r8), intent(inout) :: evec(bh%n_lrow,bh%n_lcol)

   integer(kind=i4) :: j
   integer(kind=i4) :: i_done
   integer(kind=i4) :: n_block
   real(kind=r8) :: norm
   real(kind=r8) :: t0
   real(kind=r8) :: t1
   character(len=200) :: msg

   real(kind=r8), allocatable :: tmp1(:)
   real(kind=r8), allocatable :: tmp2(:,:)
   real(kind=r8), allocatable :: tmp3(:,:)

   character(len=*), parameter :: caller = "elsi_gram_schmidt_real"

   call elsi_get_time(t0)

   n_block = bh%n_pcol*bh%blk

   call elsi_allocate(bh,tmp1,bh%n_lrow,"tmp1",caller)
   call elsi_allocate(bh,tmp2,bh%n_lrow,bh%n_lcol,"tmp2",caller)
   call elsi_allocate(bh,tmp3,bh%n_lrow,bh%n_lcol,"tmp3",caller)

   call pdsymm("L","U",ph%n_basis,ph%n_states,1.0_r8,ovlp,1,1,bh%desc,evec,1,1,&
        bh%desc,0.0_r8,tmp2,1,1,bh%desc)

   i_done = 0

   do j = 1,ph%n_states
      if(j > i_done+1) then
         ! Dot product of evec(j) with evec(i_done+1..j-1)
         call pdgemv("T",ph%n_basis,j-1-i_done,1.0_r8,tmp2,1,i_done+1,bh%desc,&
              evec,1,j,bh%desc,1,0.0_r8,tmp1,1,1,bh%desc,1)

         ! Orthogonalize
         call pdgemv("N",ph%n_basis,j-1-i_done,-1.0_r8,evec,1,i_done+1,bh%desc,&
              tmp1,1,1,bh%desc,1,1.0_r8,evec,1,j,bh%desc,1)

         call pdgemv("N",ph%n_basis,j-1-i_done,-1.0_r8,tmp2,1,i_done+1,bh%desc,&
              tmp1,1,1,bh%desc,1,1.0_r8,tmp2,1,j,bh%desc,1)
      end if

      ! Normalize
      norm = 0.0_r8

      call pddot(ph%n_basis,norm,tmp2,1,j,bh%desc,1,evec,1,j,bh%desc,1)

      if(col_map(j) > 0) then
         evec(:,col_map(j)) = evec(:,col_map(j))/sqrt(norm)
         tmp2(:,col_map(j)) = tmp2(:,col_map(j))/sqrt(norm)
      end if

      if(j-i_done == n_block .and. j < ph%n_states) then
         ! Dot product of evec(i_done+1..j) with evec(j+1..n_states)
         call pdgemm("T","N",n_block,ph%n_states-j,ph%n_basis,1.0_r8,tmp2,1,&
              i_done+1,bh%desc,evec,1,j+1,bh%desc,0.0_r8,tmp3,1,j+1,bh%desc)

         ! Orthogonalize
         call pdgemm("N","N",ph%n_basis,ph%n_states-j,n_block,-1.0_r8,evec,1,&
              i_done+1,bh%desc,tmp3,1,j+1,bh%desc,1.0_r8,evec,1,j+1,bh%desc)

         i_done = i_done+n_block
      end if
   end do

   call elsi_deallocate(bh,tmp1,"tmp1")
   call elsi_deallocate(bh,tmp2,"tmp2")
   call elsi_deallocate(bh,tmp3,"tmp3")

   call elsi_get_time(t1)

   write(msg,"(2X,A)") "Finished Gram-Schmidt orthonormalization"
   call elsi_say(bh,msg)
   write(msg,"(2X,A,F10.3,A)") "| Time :",t1-t0," s"
   call elsi_say(bh,msg)

end subroutine

!>
!! This routine orthonormalizes eigenvectors with respect to an overlap matrix
!! using a modified Gram-Schmidt algorithm.
!!
subroutine elsi_gram_schmidt_cmplx(ph,bh,col_map,ovlp,evec)

   implicit none

   type(elsi_param_t), intent(in) :: ph
   type(elsi_basic_t), intent(in) :: bh
   integer(kind=i4), intent(in) :: col_map(ph%n_basis)
   complex(kind=r8), intent(in) :: ovlp(bh%n_lrow,bh%n_lcol)
   complex(kind=r8), intent(inout) :: evec(bh%n_lrow,bh%n_lcol)

   integer(kind=i4) :: j
   integer(kind=i4) :: i_done
   integer(kind=i4) :: n_block
   complex(kind=r8) :: norm
   real(kind=r8) :: t0
   real(kind=r8) :: t1
   character(len=200) :: msg

   complex(kind=r8), allocatable :: tmp1(:)
   complex(kind=r8), allocatable :: tmp2(:,:)
   complex(kind=r8), allocatable :: tmp3(:,:)

   character(len=*), parameter :: caller = "elsi_new_ev_cmplx"

   call elsi_get_time(t0)

   n_block = bh%n_pcol*bh%blk

   call elsi_allocate(bh,tmp1,bh%n_lrow,"tmp1",caller)
   call elsi_allocate(bh,tmp2,bh%n_lrow,bh%n_lcol,"tmp2",caller)
   call elsi_allocate(bh,tmp3,bh%n_lrow,bh%n_lcol,"tmp3",caller)

   call pzhemm("L","U",ph%n_basis,ph%n_states,(1.0_r8,0.0_r8),ovlp,1,1,bh%desc,&
        evec,1,1,bh%desc,(0.0_r8,0.0_r8),tmp2,1,1,bh%desc)

   i_done = 0

   do j = 1,ph%n_states
      if(j > i_done+1) then
         ! Dot product of evec(j) with evec(i_done+1..j-1)
         call pzgemv("C",ph%n_basis,j-1-i_done,(1.0_r8,0.0_r8),tmp2,1,i_done+1,&
              bh%desc,evec,1,j,bh%desc,1,(0.0_r8,0.0_r8),tmp1,1,1,bh%desc,1)

         ! Orthogonalize
         call pzgemv("N",ph%n_basis,j-1-i_done,(-1.0_r8,0.0_r8),evec,1,&
              i_done+1,bh%desc,tmp1,1,1,bh%desc,1,(1.0_r8,0.0_r8),evec,1,j,&
              bh%desc,1)

         call pzgemv("N",ph%n_basis,j-1-i_done,(-1.0_r8,0.0_r8),tmp2,1,&
              i_done+1,bh%desc,tmp1,1,1,bh%desc,1,(1.0_r8,0.0_r8),tmp2,1,j,&
              bh%desc,1)
      end if

      ! Normalize
      norm = (0.0_r8,0.0_r8)

      call pzdotc(ph%n_basis,norm,tmp2,1,j,bh%desc,1,evec,1,j,bh%desc,1)

      if(col_map(j) > 0) then
         evec(:,col_map(j)) = evec(:,col_map(j))/sqrt(real(norm,kind=r8))
         tmp2(:,col_map(j)) = tmp2(:,col_map(j))/sqrt(real(norm,kind=r8))
      end if

      if(j-i_done == n_block .and. j < ph%n_states) then
         ! Dot product of evec(i_done+1..j) with evec(j+1..n_states)
         call pzgemm("C","N",n_block,ph%n_states-j,ph%n_basis,(1.0_r8,0.0_r8),&
              tmp2,1,i_done+1,bh%desc,evec,1,j+1,bh%desc,(0.0_r8,0.0_r8),tmp3,&
              1,j+1,bh%desc)

         ! Orthogonalize
         call pzgemm("N","N",ph%n_basis,ph%n_states-j,n_block,(-1.0_r8,0.0_r8),&
              evec,1,i_done+1,bh%desc,tmp3,1,j+1,bh%desc,(1.0_r8,0.0_r8),evec,&
              1,j+1,bh%desc)

         i_done = i_done+n_block
      end if
   end do

   call elsi_deallocate(bh,tmp1,"tmp1")
   call elsi_deallocate(bh,tmp2,"tmp2")
   call elsi_deallocate(bh,tmp3,"tmp3")

   call elsi_get_time(t1)

   write(msg,"(2X,A)") "Finished Gram-Schmidt orthonormalization"
   call elsi_say(bh,msg)
   write(msg,"(2X,A,F10.3,A)") "| Time :",t1-t0," s"
   call elsi_say(bh,msg)

end subroutine

end module ELSI_UTILS
