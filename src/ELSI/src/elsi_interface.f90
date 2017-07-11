! Copyright (c) 2015-2017, the ELSI team. All rights reserved.
!
! Redistribution and use in source and binary forms, with or without
! modification, are permitted provided that the following conditions are met:
!
!  * Redistributions of source code must retain the above copyright notice,
!    this list of conditions and the following disclaimer.
!
!  * Redistributions in binary form must reproduce the above copyright notice,
!    this list of conditions and the following disclaimer in the documentation
!    and/or other materials provided with the distribution.
!
!  * Neither the name of the "ELectronic Structure Infrastructure" project nor
!    the names of its contributors may be used to endorse or promote products
!    derived from this software without specific prior written permission.
!
! THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
! AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
! IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
! ARE DISCLAIMED. IN NO EVENT SHALL COPYRIGHT HOLDER BE LIABLE FOR ANY DIRECT,
! INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
! BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
! DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
! OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
! NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
! EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

!>
!! This module provides routines for solving the Kohn-Sham electronic structure
!! using ELPA, libOMM, PEXSI, CheSS, SIPs.
!!
module ELSI

   use iso_c_binding
   use ELSI_CONSTANTS, only: ELPA,LIBOMM,PEXSI,CHESS,SIPS,REAL_VALUES,&
                             COMPLEX_VALUES,SINGLE_PROC,MULTI_PROC,UNSET
   use ELSI_DIMENSIONS, only: elsi_handle,print_info,print_mem
   use ELSI_ELPA
   use ELSI_MATCONV, only: elsi_blacs_to_pexsi_dm,elsi_blacs_to_pexsi_hs,&
                           elsi_blacs_to_sips_hs,elsi_pexsi_to_blacs_dm,&
                           elsi_pexsi_to_blacs_hs
   use ELSI_MU, only: elsi_compute_mu_and_occ
   use ELSI_OMM
   use ELSI_PEXSI
   use ELSI_PRECISION, only: r8,i4
   use ELSI_SIPS
   use ELSI_TIMERS
   use ELSI_UTILS
   use MatrixSwitch, only: m_allocate,ms_scalapack_setup

   implicit none
   private

   character*8, parameter, public :: release_date = "20170527"

   ! Data type
   public :: elsi_handle

   ! Utilities
   public :: elsi_init
   public :: elsi_finalize
   public :: elsi_set_solver
   public :: elsi_set_mpi
   public :: elsi_set_blacs
   public :: elsi_set_csc
   public :: elsi_set_output
   public :: elsi_set_unit_ovlp
   public :: elsi_set_zero_def
   public :: elsi_set_sing_check
   public :: elsi_set_sing_tol
   public :: elsi_set_sing_stop
   public :: elsi_set_uplo
   public :: elsi_set_elpa_solver
   public :: elsi_set_omm_flavor
   public :: elsi_set_omm_n_elpa
   public :: elsi_set_omm_tol
   public :: elsi_set_omm_psp
   public :: elsi_set_pexsi_driver
   public :: elsi_set_pexsi_n_mu
   public :: elsi_set_pexsi_n_pole
   public :: elsi_set_pexsi_np_per_pole
   public :: elsi_set_pexsi_np_symbo
   public :: elsi_set_pexsi_temp
   public :: elsi_set_pexsi_gap
   public :: elsi_set_pexsi_mu_min
   public :: elsi_set_pexsi_mu_max
   public :: elsi_set_pexsi_inertia_tol
   public :: elsi_set_sips_slice_type
   public :: elsi_set_sips_n_slice
   public :: elsi_set_sips_left_bound
   public :: elsi_set_sips_slice_buffer
   public :: elsi_set_mu_broaden_scheme
   public :: elsi_set_mu_broaden_width
   public :: elsi_set_mu_tol
   public :: elsi_set_mu_spin_degen
   public :: elsi_get_ovlp_sing
   public :: elsi_get_mu
   public :: elsi_customize
   public :: elsi_customize_elpa
   public :: elsi_customize_omm
   public :: elsi_customize_pexsi
   public :: elsi_customize_sips
   public :: elsi_customize_mu
   public :: elsi_collect
   public :: elsi_collect_pexsi

   ! Solver interfaces
   public :: elsi_ev_real
   public :: elsi_ev_complex
   public :: elsi_ev_real_sparse
   public :: elsi_dm_real
   public :: elsi_dm_complex
   public :: elsi_dm_real_sparse
   public :: elsi_edm_real
   public :: elsi_compute_mu_and_occ

contains

!>
!! This routine initializes ELSI with the solver, parallel mode, matrix storage
!! format, number of basis functions (global size of the Hamiltonian matrix),
!! number of electrons, and number of states.
!!
subroutine elsi_init(elsi_h,solver,parallel_mode,matrix_storage_format,&
                     n_basis,n_electron,n_state)

   implicit none

   type(elsi_handle), intent(out) :: elsi_h                !< Handle
   integer(kind=i4),  intent(in)  :: solver                !< AUTO,ELPA,LIBOMM,PEXSI,CHESS,SIPS
   integer(kind=i4),  intent(in)  :: parallel_mode         !< SINGLE_PROC,MULTI_PROC
   integer(kind=i4),  intent(in)  :: matrix_storage_format !< BLACS_DENSE,PEXSI_CSC
   integer(kind=i4),  intent(in)  :: n_basis               !< Number of basis functions
   real(kind=r8),     intent(in)  :: n_electron            !< Number of electrons
   integer(kind=i4),  intent(in)  :: n_state               !< Number of states

   character*40, parameter :: caller = "elsi_init"

   ! For safety
   call elsi_cleanup(elsi_h)

   elsi_h%handle_initialized    = .true.
   elsi_h%n_g_size              = n_basis
   elsi_h%n_nonsingular         = n_basis
   elsi_h%n_electrons           = n_electron
   elsi_h%solver                = solver
   elsi_h%matrix_storage_format = matrix_storage_format
   elsi_h%parallel_mode         = parallel_mode
   elsi_h%n_elsi_calls          = 0

   if(parallel_mode == SINGLE_PROC) then
      elsi_h%n_l_rows = n_basis
      elsi_h%n_l_cols = n_basis
      elsi_h%n_b_rows = n_basis
      elsi_h%n_b_cols = n_basis
   endif

   if(solver == LIBOMM) then
      ! Set number of occupied states for libOMM
      elsi_h%n_states = nint(elsi_h%n_electrons/2.0_r8)
      ! Set libOMM default settings
      call elsi_set_omm_default_options(elsi_h)
   else
      elsi_h%n_states = n_state
   endif

   if(solver == PEXSI) then
      ! Set PEXSI default settings
      call elsi_set_pexsi_default_options(elsi_h)
   endif

   if(solver == SIPS) then
      ! Set SIPs default settings
      call elsi_set_sips_default_options(elsi_h)
   endif

   call elsi_init_timers(elsi_h)

end subroutine

!>
!! This routine sets the solver.
!!
subroutine elsi_set_solver(elsi_h,solver)

   implicit none

   type(elsi_handle), intent(inout) :: elsi_h !< Handle
   integer(kind=i4),  intent(in)    :: solver !< AUTO,ELPA,LIBOMM,PEXSI,CHESS,SIPS

   character*40, parameter :: caller = "elsi_set_solver"

   call elsi_check_handle(elsi_h,caller)

   elsi_h%solver = solver

end subroutine

!>
!! This routine sets the MPI communicator.
!!
subroutine elsi_set_mpi(elsi_h,mpi_comm)

   implicit none
   include "mpif.h"

   type(elsi_handle), intent(inout) :: elsi_h   !< Handle
   integer(kind=i4),  intent(in)    :: mpi_comm !< MPI communicator

   integer(kind=i4) :: mpierr

   character*40, parameter :: caller = "elsi_set_mpi"

   call elsi_check_handle(elsi_h,caller)

   if(elsi_h%parallel_mode == MULTI_PROC) then
      elsi_h%mpi_comm = mpi_comm

      call MPI_Comm_rank(mpi_comm,elsi_h%myid,mpierr)
      call MPI_Comm_size(mpi_comm,elsi_h%n_procs,mpierr)

      elsi_h%mpi_is_setup = .true.
   endif

end subroutine

!>
!! This routine sets the BLACS context and the block size.
!!
subroutine elsi_set_blacs(elsi_h,blacs_ctxt,block_size)

   implicit none

   type(elsi_handle), intent(inout) :: elsi_h     !< Handle
   integer(kind=i4),  intent(in)    :: blacs_ctxt !< BLACS context
   integer(kind=i4),  intent(in)    :: block_size !< Block size

   integer(kind=i4) :: i,i_row,i_col
   integer(kind=i4) :: blacs_info

   integer(kind=i4), external :: numroc

   character*40, parameter :: caller = "elsi_set_blacs"

   call elsi_check_handle(elsi_h,caller)

   if(elsi_h%parallel_mode == MULTI_PROC) then
      elsi_h%blacs_ctxt = blacs_ctxt
      elsi_h%n_b_rows = block_size
      elsi_h%n_b_cols = block_size

      ! Get processor grid information
      call blacs_gridinfo(elsi_h%blacs_ctxt,elsi_h%n_p_rows,elsi_h%n_p_cols,&
                          elsi_h%my_p_row,elsi_h%my_p_col)

      ! Get local size of matrix
      elsi_h%n_l_rows = numroc(elsi_h%n_g_size,elsi_h%n_b_rows,&
                               elsi_h%my_p_row,0,elsi_h%n_p_rows)
      elsi_h%n_l_cols = numroc(elsi_h%n_g_size,elsi_h%n_b_cols,&
                               elsi_h%my_p_col,0,elsi_h%n_p_cols)

      ! Get BLACS descriptor
      call descinit(elsi_h%sc_desc,elsi_h%n_g_size,elsi_h%n_g_size,&
                    elsi_h%n_b_rows,elsi_h%n_b_cols,0,0,elsi_h%blacs_ctxt,&
                    max(1,elsi_h%n_l_rows),blacs_info)

      ! Get ELPA communicators
      call elsi_get_elpa_comms(elsi_h)

      ! Compute global-local mapping
      call elsi_allocate(elsi_h,elsi_h%local_row,elsi_h%n_g_size,"local_row",caller)
      call elsi_allocate(elsi_h,elsi_h%local_col,elsi_h%n_g_size,"local_col",caller)

      i_row = 0
      i_col = 0

      do i = 1,elsi_h%n_g_size
         if(mod((i-1)/elsi_h%n_b_rows,elsi_h%n_p_rows) == elsi_h%my_p_row) then
            i_row = i_row+1
            elsi_h%local_row(i) = i_row
         endif
         if(mod((i-1)/elsi_h%n_b_cols,elsi_h%n_p_cols) == elsi_h%my_p_col) then
            i_col = i_col+1
            elsi_h%local_col(i) = i_col
         endif
      enddo

      ! Set up MatrixSwitch
      if(elsi_h%solver == LIBOMM) then
         call ms_scalapack_setup(elsi_h%mpi_comm,elsi_h%n_p_rows,'r',&
                                 elsi_h%n_b_rows,icontxt=elsi_h%blacs_ctxt)
      endif

      elsi_h%blacs_is_setup = .true.
   endif

end subroutine

!>
!! This routine sets the sparsity pattern.
!!
subroutine elsi_set_csc(elsi_h,nnz_g,nnz_l,n_l_cols,row_ind,col_ptr)

   implicit none

   type(elsi_handle), intent(inout) :: elsi_h            !< Handle
   integer(kind=i4),  intent(in)    :: nnz_g             !< Global number of nonzeros
   integer(kind=i4),  intent(in)    :: nnz_l             !< Local number of nonzeros
   integer(kind=i4),  intent(in)    :: n_l_cols          !< Local number of columns
   integer(kind=i4)                 :: row_ind(nnz_l)    !< Row index
   integer(kind=i4)                 :: col_ptr(n_l_cols) !< Column pointer

   character*40, parameter :: caller = "elsi_set_csc"

   call elsi_check_handle(elsi_h,caller)

   elsi_h%nnz_g          = nnz_g
   elsi_h%nnz_l_pexsi    = nnz_l
   elsi_h%n_l_cols_pexsi = n_l_cols

   call elsi_set_row_ind(elsi_h,row_ind)
   call elsi_set_col_ptr(elsi_h,col_ptr)

   elsi_h%sparsity_pattern_ready = .true.

end subroutine

!>
!! This routine gets the energy.
!!
subroutine elsi_get_energy(elsi_h,energy)

   implicit none

   type(elsi_handle), intent(inout) :: elsi_h !< Handle
   real(kind=r8),     intent(out)   :: energy !< Energy of the system

   integer(kind=i4) :: i_state
   character*200    :: info_str

   real(kind=r8), parameter :: n_spin = 2.0_r8
   character*40,  parameter :: caller = "elsi_get_energy"

   call elsi_check_handle(elsi_h,caller)

   select case(elsi_h%solver)
   case(ELPA)
      energy = 0.0_r8
      do i_state =1,elsi_h%n_states
         energy = energy+elsi_h%occ_elpa(i_state)*elsi_h%eval(i_state)
      enddo
   case(LIBOMM)
      energy = n_spin*elsi_h%total_energy
   case(PEXSI)
      energy = elsi_h%energy_hdm
   case(CHESS)
      call elsi_stop(" CHESS not yet implemented. Exiting...",elsi_h,caller)
   case(SIPS)
      call elsi_stop(" SIPS not yet implemented. Exiting...",elsi_h,caller)
   case DEFAULT
      call elsi_stop(" No supported solver has been chosen."//&
                     " Please choose ELPA, LIBOMM, or PEXSI solver."//&
                     " Exiting...",elsi_h,caller)
   end select

end subroutine

!>
!! This routine finalizes ELSI.
!!
subroutine elsi_finalize(elsi_h)

   implicit none

   type(elsi_handle), intent(inout) :: elsi_h !< Handle

   character*40, parameter :: caller = "elsi_finalize"

   call elsi_check_handle(elsi_h,caller)
   call elsi_final_print(elsi_h)
   call elsi_cleanup(elsi_h)

end subroutine

!>
!! This routine overrides ELSI default settings.
!!
subroutine elsi_customize(elsi_h,print_detail,overlap_is_unit,zero_threshold,&
                          no_singularity_check,singularity_tolerance,&
                          stop_singularity,uplo)

   implicit none

   type(elsi_handle), intent(inout)        :: elsi_h                !< Handle
   logical,           intent(in), optional :: print_detail          !< Print detailed info?
   logical,           intent(in), optional :: overlap_is_unit       !< Is overlap matrix unit?
   real(kind=r8),     intent(in), optional :: zero_threshold        !< Threshold to define "zero"
   logical,           intent(in), optional :: no_singularity_check  !< Do not perform singularity check of overlap
   real(kind=r8),     intent(in), optional :: singularity_tolerance !< Tolerance of overlap singularity
   logical,           intent(in), optional :: stop_singularity      !< Stop if overlap is singular
   integer,           intent(in), optional :: uplo                  !< Is input matrices upper/lower triangular?

   character*40, parameter :: caller = "elsi_customize"

   call elsi_check_handle(elsi_h,caller)

   ! Print detailed ELSI information? [Default: .false.]
   if(present(print_detail)) then
      print_info = print_detail
   endif

   ! Is the overlap matrix unit? [Default: .false.]
   if(present(overlap_is_unit)) then
      elsi_h%overlap_is_unit = overlap_is_unit
   endif

   ! Threshold to define numerical zero [Default: 1e-15_r8]
   if(present(zero_threshold)) then
      elsi_h%zero_threshold = zero_threshold
   endif

   ! Disable checking for overlap singularity? [Default: .false.]
   if(present(no_singularity_check)) then
      elsi_h%no_singularity_check = no_singularity_check
   endif

   ! Eigenfunctions of overlap matrix with eigenvalues smaller than
   ! this value will be removed to avoid singularity [Default: 1e-5_r8]
   if(present(singularity_tolerance)) then
      elsi_h%singularity_tolerance = singularity_tolerance
   endif

   ! Always stop if overlap is singular? [Default: .false.]
   if(present(stop_singularity)) then
      elsi_h%stop_singularity = stop_singularity
   endif

   ! Is the input matrices upper or lower triangular?
   ! 0: FULL_MAT, 1: UT_MAT, 2: LT_MAT [Default: 0]
   if(present(uplo)) then
      elsi_h%uplo = uplo
   endif

end subroutine

!>
!! This routine overrides libOMM default settings.
!!
subroutine elsi_customize_omm(elsi_h,n_elpa_steps,omm_flavor,eigen_shift,&
                              omm_tolerance,use_pspblas,omm_output)

   implicit none

   type(elsi_handle), intent(inout)        :: elsi_h        !< Handle
   integer(kind=i4),  intent(in), optional :: n_elpa_steps  !< Number of ELPA steps before libOMM
   integer(kind=i4),  intent(in), optional :: omm_flavor    !< How to perform orbital minimization
   real(kind=r8),     intent(in), optional :: eigen_shift   !< Eigenspectrum shift parameter
   real(kind=r8),     intent(in), optional :: omm_tolerance !< Tolerance of minimization
   logical,           intent(in), optional :: use_pspblas   !< Use pspBLAS sparse linear algebra?
   logical,           intent(in), optional :: omm_output    !< Output details?

   character*40, parameter :: caller = "elsi_customize_omm"

   call elsi_check_handle(elsi_h,caller)

   ! Number of ELPA steps [Default: 6]
   if(present(n_elpa_steps)) then
      elsi_h%n_elpa_steps = n_elpa_steps
   endif

   ! How to perform orbital minimization? [Default: 0]
   if(present(omm_flavor)) then
      elsi_h%omm_flavor = omm_flavor
   endif

   ! Eigenspectrum shift parameter [Default: 0.0_r8
   if(present(eigen_shift)) then
      elsi_h%eta = eigen_shift
   endif

   ! Tolerance for minimization [Default: 1.0e-10_r8]
   if(present(omm_tolerance)) then
      elsi_h%min_tol = omm_tolerance
   endif

   ! Use pspBLAS sparse linear algebra? [Default: .false.]
   if(present(use_pspblas)) then
      elsi_h%use_psp = use_pspblas
   endif

   ! Output details? [Default: .true.]
   if(present(omm_output)) then
      elsi_h%omm_output = omm_output
   endif

   if(elsi_h%solver .ne. LIBOMM) then
      call elsi_statement_print("  The chosen solver is not libOMM."//&
                                " Ignore elsi_customize_omm call.",elsi_h)
   endif

end subroutine

!>
!! This routine overrides PEXSI default settings.
!!
subroutine elsi_customize_pexsi(elsi_h,pexsi_driver,temperature,gap,delta_e,n_poles,&
                                n_procs_per_pole,n_mu_points,max_iteration,mu_min,&
                                mu_max,mu0,mu_inertia_tolerance,mu_inertia_expansion,&
                                mu_safeguard,n_electron_accuracy,matrix_type,&
                                is_symbolic_factorize,ordering,np_symbolic_factorize,&
                                verbosity)

   implicit none

   type(elsi_handle), intent(inout)        :: elsi_h                !< Handle
   integer(kind=i4),  intent(in), optional :: pexsi_driver          !< PEXSI DFT driver version
   real(kind=r8),     intent(in), optional :: temperature           !< Temperature, in the same unit as Hamiltonian
   real(kind=r8),     intent(in), optional :: gap                   !< Spectral gap, can be set to 0 in most cases
   real(kind=r8),     intent(in), optional :: delta_e               !< Upper bound for the spectral radius of S^(-1)H
   integer(kind=i4),  intent(in), optional :: n_poles               !< Number of poles
   integer(kind=i4),  intent(in), optional :: n_procs_per_pole      !< Number of processors for one pole
   integer(kind=i4),  intent(in), optional :: n_mu_points           !< Number of mu points
   integer(kind=i4),  intent(in), optional :: max_iteration         !< Maximum number of PEXSI iterations
   real(kind=r8),     intent(in), optional :: mu_min                !< Lower bound of chemical potential
   real(kind=r8),     intent(in), optional :: mu_max                !< Upper bound of chemical potential
   real(kind=r8),     intent(in), optional :: mu0                   !< Initial guess of chemical potential
   real(kind=r8),     intent(in), optional :: mu_inertia_tolerance  !< Tolerance of inertia counting
   real(kind=r8),     intent(in), optional :: mu_inertia_expansion  !< Expansion step size in inertia counting
   real(kind=r8),     intent(in), optional :: mu_safeguard          !< Safeguard to reinvoke inertia counting
   real(kind=r8),     intent(in), optional :: n_electron_accuracy   !< Accuracy of number of electrons
   integer(kind=i4),  intent(in), optional :: matrix_type           !< Type of input matrices
   integer(kind=i4),  intent(in), optional :: is_symbolic_factorize !< Perform symbolic factorization?
   integer(kind=i4),  intent(in), optional :: ordering              !< Ordering strategy for factorization and selected inversion
   integer(kind=i4),  intent(in), optional :: np_symbolic_factorize !< Number of processors for ParMETIS, only used if ordering=0
   integer(kind=i4),  intent(in), optional :: verbosity             !< Level of output info

   character*40, parameter :: caller = "elsi_customize_pexsi"

   call elsi_check_handle(elsi_h,caller)

   ! PEXSI DFT driver version [Default: 2]
   if(present(pexsi_driver)) then
      elsi_h%pexsi_driver = pexsi_driver
   endif

   ! Number of mu points [Default: 2]
   if(present(n_mu_points)) then
      elsi_h%n_mu_points = n_mu_points
   endif

   ! Temperature, in the same unit as H
   if(present(temperature)) then
      elsi_h%pexsi_options%temperature = temperature
   endif

   ! Spectral gap, can be set to 0 in most cases [Default: 0.0_r8]
   if(present(gap)) then
      elsi_h%pexsi_options%gap = gap
   endif

   ! Upper bound for the spectral radius of S^(-1)H [Default: 10.0_r8]
   if(present(delta_e)) then
      elsi_h%pexsi_options%deltaE = delta_e
   endif

   ! Number of poles [Default: 20]
   if(present(n_poles)) then
      elsi_h%pexsi_options%numPole = n_poles
   endif

   ! Number of processors for one pole
   if(present(n_procs_per_pole)) then
      if(mod(elsi_h%n_procs,n_procs_per_pole) == 0) then
         elsi_h%n_p_per_pole_pexsi = n_procs_per_pole
      else
         call elsi_stop("  The total number of MPI tasks must be a"//&
                        " multiple of the number of MPI tasks per"//&
                        " pole. Exiting...",elsi_h,caller)
      endif
   endif

   ! Maximum number of PEXSI iterations after each inertia
   ! counting procedure [Default: 3]
   if(present(max_iteration)) then
      elsi_h%pexsi_options%maxPEXSIIter = max_iteration
   endif

   ! From the second step, mu is from previous step
   if(elsi_h%n_elsi_calls == 0) then
      ! Initial guess of mu [Default: 0.0_r8]
      if(present(mu0)) then
         elsi_h%pexsi_options%mu0 = mu0
      endif

      ! Initial guess of lower bound for mu [Default: -10.0_r8]
      if(present(mu_min)) then
         elsi_h%pexsi_options%muMin0 = mu_min
      endif

      ! Initial guess of upper bound for mu [Default: 10.0_r8]
      if(present(mu_max)) then
         elsi_h%pexsi_options%muMax0 = mu_max
      endif
   endif

   ! Stopping criterion in terms of the chemical potential
   ! for the inertia counting procedure [Default: 0.05_r8]
   if(present(mu_inertia_tolerance)) then
      elsi_h%pexsi_options%muInertiaTolerance = mu_inertia_tolerance
   endif

   ! If the chemical potential is not in the initial interval,
   ! the interval is expanded by this value [Default: 0.3_r8]
   if(present(mu_inertia_expansion)) then
      elsi_h%pexsi_options%muInertiaExpansion = mu_inertia_expansion
   endif

   ! Safeguard criterion in terms of the chemical potential to
   ! reinvoke the inertia counting procedure [Default: 0.05_r8]
   if(present(mu_safeguard)) then
      elsi_h%pexsi_options%muPEXSISafeGuard = mu_safeguard
   endif

   ! Stopping criterion of the PEXSI iteration in terms of the
   ! number of electrons compared to the exact number [Default: 0.01_r8]
   if(present(n_electron_accuracy)) then
      elsi_h%pexsi_options%numElectronPEXSITolerance = n_electron_accuracy
      if(n_electron_accuracy < 1.0e-2_r8) then
         elsi_h%small_pexsi_tol = .true.
         elsi_h%final_pexsi_tol = n_electron_accuracy
      endif
   endif

   ! Type of input H and S matrices [Default: 0]
   ! 0: real symmetric
   ! 1: general complex
   if(present(matrix_type)) then
      elsi_h%pexsi_options%matrixType = matrix_type
   endif

   ! Whether to perform symbolic factorization [Default: 1]
   if(present(is_symbolic_factorize)) then
      elsi_h%pexsi_options%isSymbolicFactorize = is_symbolic_factorize
   endif

   ! Ordering strategy for factorization and selected inversion [Default: 0]
   ! 0: parallel ordering using ParMETIS
   ! 1: sequential ordering using METIS
   ! 2: multiple minimum degree ordering
   if(present(ordering)) then
      elsi_h%pexsi_options%ordering = ordering
   endif

   ! Number of processors for ParMETIS, only used if ordering=0 [Default: 1]
   if(present(np_symbolic_factorize)) then
      elsi_h%pexsi_options%npSymbFact = np_symbolic_factorize
   endif

   ! Level of output information [Default: 1]
   ! 0: no output
   ! 1: basic output
   ! 2: detailed output
   if(present(verbosity)) then
      elsi_h%pexsi_options%verbosity = verbosity
   endif

   if(elsi_h%solver .ne. PEXSI) then
      call elsi_statement_print("  The chosen solver is not PEXSI."//&
                                " Ignore elsi_customize_pexsi call.",elsi_h)
   endif

end subroutine

!>
!! This routine overrides ELPA default settings.
!!
subroutine elsi_customize_elpa(elsi_h,elpa_solver,elpa_output)

   implicit none

   type(elsi_handle), intent(inout)        :: elsi_h      !< Handle
   integer(kind=i4),  intent(in), optional :: elpa_solver !< 1-stage or 2-stage solver?
   logical,           intent(in), optional :: elpa_output !< Output details?

   character*40, parameter :: caller = "elsi_customize_elpa"

   call elsi_check_handle(elsi_h,caller)

   ! 1-stage or 2-stage solver? [Default: 2]
   if(present(elpa_solver)) then
      elsi_h%elpa_solver = elpa_solver
   endif

   ! Output details? [Default: .false.]
   if(present(elpa_output)) then
      elsi_h%elpa_output = elpa_output
   endif

   if(elsi_h%solver .ne. ELPA) then
      call elsi_statement_print("  The chosen solver is not ELPA."//&
                                " Ignore elsi_customize_elpa call.",elsi_h)
   endif

end subroutine

!>
!! This routine overrides SIPs default settings.
!!
subroutine elsi_customize_sips(elsi_h,slicing_method,n_slices,inertia_option,&
                               unbound,slice_buffer)

   implicit none

   type(elsi_handle), intent(inout)        :: elsi_h         !< Handle
   integer(kind=i4),  intent(in), optional :: slicing_method !< Method of slicing
   integer(kind=i4),  intent(in), optional :: n_slices       !< Number of slices
   integer(kind=i4),  intent(in), optional :: inertia_option !< Inertia counting before solve?
   integer(kind=i4),  intent(in), optional :: unbound        !< Bound the left side of the interval?
   real(kind=r8),     intent(in), optional :: slice_buffer   !< Small buffer to expand the interval

   character*40, parameter :: caller = "elsi_customize_sips"

   ! Method of slicing [Default: 3]
   ! 0: Equally spaced subintervals
   ! 1: K-meaans after equally spaced subintervals
   ! 2: Equally populated subintervals
   ! 3: K-means after equally populated subintervals
   if(present(slicing_method)) then
      elsi_h%slicing_method = slicing_method
   endif

   ! Number of slices
   if(present(n_slices)) then
      if(mod(elsi_h%n_procs,n_slices) == 0) then
         elsi_h%n_slices = n_slices
         elsi_h%n_p_per_slice_sips = elsi_h%n_procs/elsi_h%n_slices
      else
         call elsi_stop("  The total number of MPI tasks must be"//&
                        " a multiple of the number of slices."//&
                        " Exiting...",elsi_h,caller)
      endif
   endif

   ! Perform inertia computations before solve? [Default: 1]
   if(present(inertia_option)) then
      elsi_h%inertia_option = inertia_option
   endif

   ! Bound the left side of the interval [Default: 0]
   ! 0: Bound interval
   ! 1: -Infinity
   if(present(unbound)) then
      elsi_h%unbound = unbound
   endif

   ! Small buffer to expand the interval [Default: 0.1_r8]
   if(present(slice_buffer)) then
      elsi_h%slice_buffer = slice_buffer
   endif

   if(elsi_h%solver .ne. SIPS) then
      call elsi_statement_print("  The chosen solver is not SIPS."//&
                                " Ignore elsi_customize_sips call.",elsi_h)
   endif

end subroutine

!>
!! This routine overrides ELSI default settings for the chemical potential
!! determination module.
!!
subroutine elsi_customize_mu(elsi_h,broadening_scheme,broadening_width,&
                             occ_accuracy,mu_max_steps,spin_degeneracy)

   implicit none

   type(elsi_handle), intent(inout)        :: elsi_h            !< Handle
   integer(kind=i4),  intent(in), optional :: broadening_scheme !< Broadening method in chemical potential determination
   real(kind=r8),     intent(in), optional :: broadening_width  !< Broadening width in chemical potential determination
   real(kind=r8),     intent(in), optional :: occ_accuracy      !< Accuracy in electron count (sum of occ)
   integer(kind=i4),  intent(in), optional :: mu_max_steps      !< Maximum number of steps to find the chemical potential
   real(kind=r8),     intent(in), optional :: spin_degeneracy   !< Spin degeneracy

   character*40, parameter :: caller = "elsi_customize_mu"

   call elsi_check_handle(elsi_h,caller)

   ! Broadening scheme to compute Fermi level [Default: GAUSSIAN]
   if(present(broadening_scheme)) then
      elsi_h%broadening_scheme = broadening_scheme
   endif

   ! Broadening width to compute Fermi level [Default: 1e-2_r8]
   if(present(broadening_width)) then
      elsi_h%broadening_width = broadening_width
   endif

   ! Accuracy for chemical potential determination [Default: 1e-10_r8]
   if(present(occ_accuracy)) then
      elsi_h%occ_tolerance = occ_accuracy
   endif

   ! Maximum steps to determine the chemical potential [Default: 100]
   if(present(mu_max_steps)) then
      elsi_h%max_mu_steps = mu_max_steps
   endif

   ! Spin degeneracy [Default: 2.0_r8/n_spin]
   if(present(spin_degeneracy)) then
      elsi_h%spin_degen = spin_degeneracy
   endif

end subroutine

!>
!! This routine collects useful quantities that are not available via
!! the solver API.
!!
subroutine elsi_collect(elsi_h,overlap_is_singular,n_singular_basis,mu)

   implicit none

   type(elsi_handle), intent(inout)         :: elsi_h              !< Handle
   logical,           intent(out), optional :: overlap_is_singular !< Is overlap singular?
   integer,           intent(out), optional :: n_singular_basis    !< Number of singular basis functions
   real(kind=r8),     intent(out), optional :: mu                  !< Chemical potential

   character*40, parameter :: caller = "elsi_collect"

   call elsi_check_handle(elsi_h,caller)

   if(present(overlap_is_singular)) then
      overlap_is_singular = elsi_h%overlap_is_singular
   endif

   if(present(n_singular_basis)) then
      n_singular_basis = elsi_h%n_g_size-elsi_h%n_nonsingular
   endif

   if(present(mu)) then
      mu = elsi_h%mu

      if(.not. elsi_h%mu_ready) then
         call elsi_statement_print("  ATTENTION! The return value of mu may"//&
                                   " be 0, since it has not been computed.",elsi_h)
      endif

      elsi_h%mu_ready = .false.
   endif

end subroutine

!>
!! This routine collects results after a PEXSI calculation.
!!
subroutine elsi_collect_pexsi(elsi_h,mu,edm,fdm)

   implicit none

   type(elsi_handle), intent(in)            :: elsi_h                  !< Handle
   real(kind=r8),     intent(out), optional :: mu                      !< Chemical potential
   real(kind=r8),     intent(out), optional :: edm(elsi_h%nnz_l_pexsi) !< Energy density matrix
   real(kind=r8),     intent(out), optional :: fdm(elsi_h%nnz_l_pexsi) !< Free energy density matrix

   character*40, parameter :: caller = "elsi_collect_pexsi"

   call elsi_check_handle(elsi_h,caller)

   if(present(mu)) then
      mu = elsi_h%mu
   endif

   if(present(edm)) then
      edm = elsi_h%e_den_mat_pexsi
   endif

   if(present(fdm)) then
      fdm = elsi_h%f_den_mat_pexsi
   endif

end subroutine

!>
!! This routine sets ELSI output level.
!!
subroutine elsi_set_output(elsi_h,out_level)

   implicit none

   type(elsi_handle), intent(inout) :: elsi_h    !< Handle
   integer(kind=i4),  intent(in)    :: out_level !< Output level of ELSI

   character*40, parameter :: caller = "elsi_set_output"

   call elsi_check_handle(elsi_h,caller)

   if(out_level .le. 0) then
      print_info = .false.
      print_mem  = .false.
      elsi_h%omm_output = .false.
      elsi_h%pexsi_options%verbosity = 0
      elsi_h%elpa_output = .false.
   elseif(out_level == 1) then
      print_info = .true.
      print_mem  = .false.
      elsi_h%omm_output = .false.
      elsi_h%pexsi_options%verbosity = 0
      elsi_h%elpa_output = .false.
   elseif(out_level == 2) then
      print_info = .true.
      print_mem  = .false.
      elsi_h%omm_output = .true.
      elsi_h%pexsi_options%verbosity = 2
      elsi_h%elpa_output = .true.
   else
      print_info = .true.
      print_mem  = .true.
      elsi_h%omm_output = .true.
      elsi_h%pexsi_options%verbosity = 2
      elsi_h%elpa_output = .true.
   endif

end subroutine

!>
!! This routine sets the overlap matrix to be identity.
!!
subroutine elsi_set_unit_ovlp(elsi_h,unit_ovlp)

   implicit none

   type(elsi_handle), intent(inout) :: elsi_h    !< Handle
   integer(kind=i4),  intent(in)    :: unit_ovlp !< Overlap is an identity matrix?

   character*40, parameter :: caller = "elsi_set_unit_ovlp"

   call elsi_check_handle(elsi_h,caller)

   if(unit_ovlp == 0) then
      elsi_h%overlap_is_unit = .false.
   else
      elsi_h%overlap_is_unit = .true.
   endif

end subroutine

!>
!! This routine sets the threshold to define "zero".
!!
subroutine elsi_set_zero_def(elsi_h,zero_def)

   implicit none

   type(elsi_handle), intent(inout) :: elsi_h   !< Handle
   real(kind=r8),     intent(in)    :: zero_def !< Numbers smaller than this will be discarded

   character*40, parameter :: caller = "elsi_set_zero_def"

   call elsi_check_handle(elsi_h,caller)

   elsi_h%zero_threshold = zero_def

end subroutine

!>
!! This routine switches on/off the singularity check of the overlap matrix.
!!
subroutine elsi_set_sing_check(elsi_h,sing_check)

   implicit none

   type(elsi_handle), intent(inout) :: elsi_h     !< Handle
   integer(kind=i4),  intent(in)    :: sing_check !< Perform singularity check?

   character*40, parameter :: caller = "elsi_set_sing_check"

   call elsi_check_handle(elsi_h,caller)

   if(sing_check == 0) then
      elsi_h%no_singularity_check = .true.
   else
      elsi_h%no_singularity_check = .false.
   endif

end subroutine

!>
!! This routine sets the tolerance of the singularity check.
!!
subroutine elsi_set_sing_tol(elsi_h,sing_tol)

   implicit none

   type(elsi_handle), intent(inout) :: elsi_h   !< Handle
   real(kind=r8),     intent(in)    :: sing_tol !< Eigenfunctions of the overlap matrix with
                                                !! eigenvalues smaller than this value will
                                                !! be removed to avoid singularity

   character*40, parameter :: caller = "elsi_set_sing_tol"

   call elsi_check_handle(elsi_h,caller)

   elsi_h%singularity_tolerance = sing_tol

end subroutine

!>
!! This routine sets whether to stop in case of singular overlap matrix.
!!
subroutine elsi_set_sing_stop(elsi_h,sing_stop)

   implicit none

   type(elsi_handle), intent(inout) :: elsi_h    !< Handle
   integer(kind=i4),  intent(in)    :: sing_stop !< Always stop in case of singular overlap

   character*40, parameter :: caller = "elsi_set_sing_stop"

   call elsi_check_handle(elsi_h,caller)

   if(sing_stop == 0) then
      elsi_h%stop_singularity = .false.
   else
      elsi_h%stop_singularity = .true.
   endif

end subroutine

!>
!! This routine sets the input matrices to be full, upper triangular, or
!! lower triangular.
!!
subroutine elsi_set_uplo(elsi_h,uplo)

   implicit none

   type(elsi_handle), intent(inout) :: elsi_h !< Handle
   integer(kind=i4),  intent(in)    :: uplo   !< Input matrix triangular?

   character*40, parameter :: caller = "elsi_set_uplo"

   call elsi_check_handle(elsi_h,caller)

   elsi_h%uplo = uplo

end subroutine

!>
!! This routine sets the ELPA solver.
!!
subroutine elsi_set_elpa_solver(elsi_h,elpa_solver)

   implicit none

   type(elsi_handle), intent(inout) :: elsi_h      !< Handle
   integer(kind=i4),  intent(in)    :: elpa_solver !< Which ELPA solver?

   character*40, parameter :: caller = "elsi_set_elpa_solver"

   call elsi_check_handle(elsi_h,caller)

   elsi_h%elpa_solver = elpa_solver

end subroutine

!>
!! This routine sets the flavor of libOMM.
!!
subroutine elsi_set_omm_flavor(elsi_h,omm_flavor)

   implicit none

   type(elsi_handle), intent(inout) :: elsi_h     !< Handle
   integer(kind=i4),  intent(in)    :: omm_flavor !< Which libOMM flavor?

   character*40, parameter :: caller = "elsi_set_omm_flavor"

   call elsi_check_handle(elsi_h,caller)

   elsi_h%omm_flavor = omm_flavor

end subroutine

!>
!! This routine sets the number of ELPA steps when using libOMM.
!!
subroutine elsi_set_omm_n_elpa(elsi_h,n_elpa)

   implicit none

   type(elsi_handle), intent(inout) :: elsi_h !< Handle
   integer(kind=i4),  intent(in)    :: n_elpa !< Number of ELPA steps before libOMM

   character*40, parameter :: caller = "elsi_set_n_elpa"

   call elsi_check_handle(elsi_h,caller)

   elsi_h%n_elpa_steps = n_elpa

end subroutine

!>
!! This routine sets the tolerance of OMM minimization.
!!
subroutine elsi_set_omm_tol(elsi_h,min_tol)

   implicit none

   type(elsi_handle), intent(inout) :: elsi_h  !< Handle
   real(kind=r8),     intent(in)    :: min_tol !< Tolerance of OMM minimization

   character*40, parameter :: caller = "elsi_set_omm_tol"

   call elsi_check_handle(elsi_h,caller)

   elsi_h%min_tol = min_tol

end subroutine

!>
!! This routine switches on/off the matrix multiplications using PSP BLAS.
!!
subroutine elsi_set_omm_psp(elsi_h,use_psp)

   implicit none

   type(elsi_handle), intent(inout) :: elsi_h  !< Handle
   integer(kind=i4),  intent(in)    :: use_psp !< Use pspBLAS?

   character*40, parameter :: caller = "elsi_set_omm_psp"

   call elsi_check_handle(elsi_h,caller)

   elsi_h%use_psp = use_psp

end subroutine

!>
!! This routine sets the PEXSI driver.
!!
subroutine elsi_set_pexsi_driver(elsi_h,pexsi_driver)

   implicit none

   type(elsi_handle), intent(inout) :: elsi_h       !< Handle
   integer(kind=i4),  intent(in)    :: pexsi_driver !< Which PEXSI driver?

   character*40, parameter :: caller = "elsi_set_pexsi_driver"

   call elsi_check_handle(elsi_h,caller)

   elsi_h%pexsi_driver = pexsi_driver

end subroutine

!>
!! This routine sets the number of mu points when using PEXSI driver 2.
!!
subroutine elsi_set_pexsi_n_mu(elsi_h,n_mu)

   implicit none

   type(elsi_handle), intent(inout) :: elsi_h !< Handle
   integer(kind=i4),  intent(in)    :: n_mu   !< Number of mu points

   character*40, parameter :: caller = "elsi_set_pexsi_n_mu"

   call elsi_check_handle(elsi_h,caller)

   elsi_h%n_mu_points = n_mu

end subroutine

!>
!! This routine sets the number of poles in the pole expansion.
!!
subroutine elsi_set_pexsi_n_pole(elsi_h,n_pole)

   implicit none

   type(elsi_handle), intent(inout) :: elsi_h !< Handle
   integer(kind=i4),  intent(in)    :: n_pole !< Number of poles

   character*40, parameter :: caller = "elsi_set_pexsi_n_pole"

   call elsi_check_handle(elsi_h,caller)

   elsi_h%pexsi_options%numPole = n_pole

end subroutine

!>
!! This routine sets the number of MPI tasks assigned for one pole.
!!
subroutine elsi_set_pexsi_np_per_pole(elsi_h,np_per_pole)

   implicit none

   type(elsi_handle), intent(inout) :: elsi_h      !< Handle
   integer(kind=i4),  intent(in)    :: np_per_pole !< Number of processes per pole

   character*40, parameter :: caller = "elsi_set_pexsi_n_pole"

   call elsi_check_handle(elsi_h,caller)

   if(mod(elsi_h%n_procs,np_per_pole) == 0) then
      elsi_h%n_p_per_pole_pexsi = np_per_pole
   else
      call elsi_stop("  The total number of MPI tasks must be a"//&
                     " multiple of the number of MPI tasks per"//&
                     " pole. Exiting...",elsi_h,caller)
   endif

end subroutine

!>
!! This routine sets the number of MPI tasks for the symbolic factorization.
!!
subroutine elsi_set_pexsi_np_symbo(elsi_h,np_symbo)

   implicit none

   type(elsi_handle), intent(inout) :: elsi_h   !< Handle
   integer(kind=i4),  intent(in)    :: np_symbo !< Number of processes for symbolic factorization

   character*40, parameter :: caller = "elsi_set_pexsi_np_symbo"

   call elsi_check_handle(elsi_h,caller)

   elsi_h%pexsi_options%npSymbFact = np_symbo

end subroutine

!>
!! This routine sets the temperature parameter in PEXSI.
!!
subroutine elsi_set_pexsi_temp(elsi_h,temp)

   implicit none

   type(elsi_handle), intent(inout) :: elsi_h !< Handle
   real(kind=r8),     intent(in)    :: temp   !< Temperature

   character*40, parameter :: caller = "elsi_set_pexsi_temp"

   call elsi_check_handle(elsi_h,caller)

   elsi_h%pexsi_options%temperature = temp

end subroutine

!>
!! This routine sets the spectral gap in PEXSI.
!!
subroutine elsi_set_pexsi_gap(elsi_h,gap)

   implicit none

   type(elsi_handle), intent(inout) :: elsi_h !< Handle
   real(kind=r8),     intent(in)    :: gap    !< Gap

   character*40, parameter :: caller = "elsi_set_pexsi_gap"

   call elsi_check_handle(elsi_h,caller)

   elsi_h%pexsi_options%gap = gap

end subroutine

!>
!! This routine sets the lower bound of the chemical potential in PEXSI.
!!
subroutine elsi_set_pexsi_mu_min(elsi_h,mu_min)

   implicit none

   type(elsi_handle), intent(inout) :: elsi_h !< Handle
   real(kind=r8),     intent(in)    :: mu_min !< Lower bound of mu

   character*40, parameter :: caller = "elsi_set_pexsi_mu_min"

   call elsi_check_handle(elsi_h,caller)

   elsi_h%pexsi_options%muMin0 = mu_min

end subroutine

!>
!! This routine sets the upper bound of the chemical potential in PEXSI.
!!
subroutine elsi_set_pexsi_mu_max(elsi_h,mu_max)

   implicit none

   type(elsi_handle), intent(inout) :: elsi_h !< Handle
   real(kind=r8),     intent(in)    :: mu_max !< Upper bound of mu

   character*40, parameter :: caller = "elsi_set_pexsi_mu_max"

   call elsi_check_handle(elsi_h,caller)

   elsi_h%pexsi_options%muMax0 = mu_max

end subroutine

!>
!! This routine sets the tolerance of the estimation of the chemical
!! potential in the inertia counting procedure.
!!
subroutine elsi_set_pexsi_inertia_tol(elsi_h,inertia_tol)

   implicit none

   type(elsi_handle), intent(inout) :: elsi_h      !< Handle
   real(kind=r8),     intent(in)    :: inertia_tol !< tolerance of the estimation of the chemical
                                                   !! potential in the inertia counting procedure

   character*40, parameter :: caller = "elsi_set_pexsi_inertia_tol"

   call elsi_check_handle(elsi_h,caller)

   elsi_h%pexsi_options%muInertiaTolerance = inertia_tol

end subroutine

!>
!! This routine sets the slicing method when using SIPs.
!!
subroutine elsi_set_sips_slice_type(elsi_h,slice_type)

   implicit none

   type(elsi_handle), intent(inout) :: elsi_h     !< Handle
   integer(kind=i4),  intent(in)    :: slice_type !< Method of slicing

   character*40, parameter :: caller = "elsi_set_sips_slice_type"

   call elsi_check_handle(elsi_h,caller)

   elsi_h%slicing_method = slice_type

end subroutine

!>
!! This routine sets the number of slices in SIPs.
!!
subroutine elsi_set_sips_n_slice(elsi_h,n_slice)

   implicit none

   type(elsi_handle), intent(inout) :: elsi_h  !< Handle
   integer(kind=i4),  intent(in)    :: n_slice !< Number of slices

   character*40, parameter :: caller = "elsi_set_sips_n_slice"

   call elsi_check_handle(elsi_h,caller)

   if(mod(elsi_h%n_procs,n_slice) == 0) then
      elsi_h%n_slices = n_slice
      elsi_h%n_p_per_slice_sips = elsi_h%n_procs/n_slice
   else
      call elsi_stop("  The total number of MPI tasks must be"//&
                     " a multiple of the number of slices."//&
                     " Exiting...",elsi_h,caller)
   endif

end subroutine

!>
!! This routine sets the method to bound the left side of the eigenvalue
!! interval in SIPs.
!!
subroutine elsi_set_sips_left_bound(elsi_h,left_bound)

   implicit none

   type(elsi_handle), intent(inout) :: elsi_h     !< Handle
   integer(kind=i4),  intent(in)    :: left_bound !< How to bound the left side?

   character*40, parameter :: caller = "elsi_set_sips_left_bound"

   call elsi_check_handle(elsi_h,caller)

   elsi_h%unbound = left_bound

end subroutine

!>
!! This routine sets a small buffer to expand the eigenvalue interval
!! in SIPs.
!!
subroutine elsi_set_sips_slice_buffer(elsi_h,slice_buffer)

   implicit none

   type(elsi_handle), intent(inout) :: elsi_h       !< Handle
   real(kind=r8),     intent(in)    :: slice_buffer !< A buffer to expand the interval

   character*40, parameter :: caller = "elsi_set_sips_slice_buffer"

   call elsi_check_handle(elsi_h,caller)

   elsi_h%slice_buffer = slice_buffer

end subroutine

!>
!! This routine sets the broadening scheme to determine the chemical
!! potential and the occupation numbers.
!!
subroutine elsi_set_mu_broaden_scheme(elsi_h,broaden_scheme)

   implicit none

   type(elsi_handle), intent(inout) :: elsi_h         !< Handle
   integer(kind=i4),  intent(in)    :: broaden_scheme !< Broadening method

   character*40, parameter :: caller = "elsi_set_mu_broaden_method"

   call elsi_check_handle(elsi_h,caller)

   elsi_h%broadening_scheme = broaden_scheme

end subroutine

!>
!! This routine sets the broadening width to determine the chemical
!! potential and the occupation numbers.
!!
subroutine elsi_set_mu_broaden_width(elsi_h,broaden_width)

   implicit none

   type(elsi_handle), intent(inout) :: elsi_h        !< Handle
   real(kind=r8),     intent(in)    :: broaden_width !< Broadening width

   character*40, parameter :: caller = "elsi_set_mu_broaden_width"

   call elsi_check_handle(elsi_h,caller)

   elsi_h%broadening_width = broaden_width

end subroutine

!>
!! This routine sets the desired accuracy of the determination of the
!! chemical potential and the occupation numbers.
!!
subroutine elsi_set_mu_tol(elsi_h,mu_tol)

   implicit none

   type(elsi_handle), intent(inout) :: elsi_h !< Handle
   real(kind=r8),     intent(in)    :: mu_tol !< Accuracy of mu

   character*40, parameter :: caller = "elsi_set_mu_tol"

   call elsi_check_handle(elsi_h,caller)

   elsi_h%occ_tolerance = mu_tol

end subroutine

!>
!! This routine sets the spin degeneracy in the determination of the
!! chemical potential and the occupation numbers.
!!
subroutine elsi_set_mu_spin_degen(elsi_h,spin_degen)

   implicit none

   type(elsi_handle), intent(inout) :: elsi_h     !< Handle
   real(kind=r8),     intent(in)    :: spin_degen !< Spin degeneracy

   character*40, parameter :: caller = "elsi_set_mu_spin_degen"

   call elsi_check_handle(elsi_h,caller)

   elsi_h%spin_degen = spin_degen

end subroutine

!>
!! This routine gets the result of the singularity check of the
!! overlap matrix.
!!
subroutine elsi_get_ovlp_sing(elsi_h,ovlp_sing)

   implicit none

   type(elsi_handle), intent(inout) :: elsi_h    !< Handle
   integer(kind=i4),  intent(out)   :: ovlp_sing !< Is overlap singular?

   character*40, parameter :: caller = "elsi_get_ovlp_sing"

   call elsi_check_handle(elsi_h,caller)

   if(elsi_h%overlap_is_singular) then
      ovlp_sing = 1
   else
      ovlp_sing = 0
   endif

end subroutine

!>
!! This routine gets the chemical potential.
!!
subroutine elsi_get_mu(elsi_h,mu)

   implicit none

   type(elsi_handle), intent(inout) :: elsi_h !< Handle
   real(kind=r8),     intent(out)   :: mu     !< Chemical potential

   character*40, parameter :: caller = "elsi_get_mu"

   call elsi_check_handle(elsi_h,caller)

   mu = elsi_h%mu

   if(.not. elsi_h%mu_ready) then
      call elsi_statement_print("  ATTENTION! The return value of mu may"//&
                                " be 0, since it has not been computed.",elsi_h)
   endif

   elsi_h%mu_ready = .false.

end subroutine

!>
!! This routine computes the eigenvalues and eigenvectors.
!!
subroutine elsi_ev_real(elsi_h,H_in,S_in,e_val_out,e_vec_out)

   implicit none

   type(elsi_handle) :: elsi_h                                     !< Handle
   real(kind=r8)     :: H_in(elsi_h%n_l_rows,elsi_h%n_l_cols)      !< Hamiltonian
   real(kind=r8)     :: S_in(elsi_h%n_l_rows,elsi_h%n_l_cols)      !< Overlap
   real(kind=r8)     :: e_val_out(elsi_h%n_g_size)                 !< Eigenvalues
   real(kind=r8)     :: e_vec_out(elsi_h%n_l_rows,elsi_h%n_l_cols) !< Eigenvectors

   character*40, parameter :: caller = "elsi_ev_real"

   call elsi_check_handle(elsi_h,caller)

   ! Update counter
   elsi_h%n_elsi_calls = elsi_h%n_elsi_calls+1

   ! REAL case
   elsi_h%matrix_data_type = REAL_VALUES

   ! Safety check
   call elsi_check(elsi_h,caller)

   select case(elsi_h%solver)
   case(ELPA)
      ! Set matrices
      call elsi_set_hamiltonian(elsi_h,H_in)
      call elsi_set_overlap(elsi_h,S_in)
      call elsi_set_eigenvector(elsi_h,e_vec_out)
      call elsi_set_eigenvalue(elsi_h,e_val_out)

      ! Solve
      if(elsi_h%parallel_mode == SINGLE_PROC) then
         call elsi_solve_evp_elpa_sp(elsi_h)
      else ! Multi-proc
         call elsi_solve_evp_elpa(elsi_h)
      endif

   case(LIBOMM)
      call elsi_stop(" Only ELPA computes eigenvalues and eigenvectors."//&
                     " Choose ELPA if necessary. Exiting...",elsi_h,caller)
   case(PEXSI)
      call elsi_stop(" Only ELPA computes eigenvalues and eigenvectors."//&
                     " Choose ELPA if necessary. Exiting...",elsi_h,caller)
   case(CHESS)
      call elsi_stop(" Only ELPA computes eigenvalues and eigenvectors."//&
                     " Choose ELPA if necessary. Exiting...",elsi_h,caller)
   case(SIPS)
      call elsi_print_sips_options(elsi_h)

      ! Initialize SIPs
      call elsi_init_sips(elsi_h)

      ! Convert BLACS H and S to SIPs format
      call elsi_blacs_to_sips_hs(elsi_h,H_in,S_in)

      ! Set matrices
      call elsi_set_sparse_hamiltonian(elsi_h,elsi_h%ham_real_sips)
      call elsi_set_sparse_overlap(elsi_h,elsi_h%ovlp_real_sips)
      call elsi_set_row_ind(elsi_h,elsi_h%row_ind_sips)
      call elsi_set_col_ptr(elsi_h,elsi_h%col_ptr_sips)
      call elsi_set_eigenvalue(elsi_h,e_val_out)
      call elsi_set_eigenvector(elsi_h,e_vec_out)

      ! Solve
      call elsi_solve_evp_sips(elsi_h)

      ! Convert SIPs eigenvectors to BLACS format
      call elsi_sips_to_blacs_ev(elsi_h)

   case DEFAULT
      call elsi_stop(" No supported solver has been chosen."//&
                     " Please choose ELPA solver to compute"//&
                     " eigenvalues and eigenvectors. Exiting...",elsi_h,caller)
   end select

   elsi_h%matrix_data_type = UNSET

end subroutine

!>
!! This routine computes the eigenvalues and eigenvectors.
!!
subroutine elsi_ev_complex(elsi_h,H_in,S_in,e_val_out,e_vec_out)

   implicit none

   type(elsi_handle) :: elsi_h                                     !< Handle
   complex(kind=r8)  :: H_in(elsi_h%n_l_rows,elsi_h%n_l_cols)      !< Hamiltonian
   complex(kind=r8)  :: S_in(elsi_h%n_l_rows,elsi_h%n_l_cols)      !< Overlap
   real(kind=r8)     :: e_val_out(elsi_h%n_g_size)                 !< Eigenvalues
   complex(kind=r8)  :: e_vec_out(elsi_h%n_l_rows,elsi_h%n_l_cols) !< Eigenvectors

   character*40, parameter :: caller = "elsi_ev_complex"

   call elsi_check_handle(elsi_h,caller)

   ! Update counter
   elsi_h%n_elsi_calls = elsi_h%n_elsi_calls+1

   ! COMPLEX case
   elsi_h%matrix_data_type = COMPLEX_VALUES

   ! Safety check
   call elsi_check(elsi_h,caller)

   select case(elsi_h%solver)
   case(ELPA)
      ! Set matrices
      call elsi_set_hamiltonian(elsi_h,H_in)
      call elsi_set_overlap(elsi_h,S_in)
      call elsi_set_eigenvector(elsi_h,e_vec_out)
      call elsi_set_eigenvalue(elsi_h,e_val_out)

      ! Solve
      if(elsi_h%parallel_mode == SINGLE_PROC) then
         call elsi_solve_evp_elpa_sp(elsi_h)
      else ! MULTI_PROC
         call elsi_solve_evp_elpa(elsi_h)
      endif

   case(LIBOMM)
      call elsi_stop(" Only ELPA computes eigenvalues and eigenvectors."//&
                     " Choose ELPA if necessary. Exiting...",elsi_h,caller)
   case(PEXSI)
      call elsi_stop(" Only ELPA computes eigenvalues and eigenvectors."//&
                     " Choose ELPA if necessary. Exiting...",elsi_h,caller)
   case(CHESS)
      call elsi_stop(" Only ELPA computes eigenvalues and eigenvectors."//&
                     " Choose ELPA if necessary. Exiting...",elsi_h,caller)
   case(SIPS)
      call elsi_stop(" SIPS not yet implemented. Exiting...",elsi_h,caller)
   case DEFAULT
      call elsi_stop(" No supported solver has been chosen."//&
                     " Please choose ELPA solver to compute"//&
                     " eigenvalues and eigenvectors. Exiting...",elsi_h,caller)
   end select

   elsi_h%matrix_data_type = UNSET

end subroutine

!>
!! This routine computes the eigenvalues and eigenvectors.
!!
subroutine elsi_ev_real_sparse(elsi_h,H_in,S_in,e_val_out,e_vec_out)

   implicit none

   type(elsi_handle) :: elsi_h                                     !< Handle
   real(kind=r8)     :: H_in(elsi_h%nnz_l_pexsi)                   !< Hamiltonian
   real(kind=r8)     :: S_in(elsi_h%nnz_l_pexsi)                   !< Overlap
   real(kind=r8)     :: e_val_out(elsi_h%n_g_size)                 !< Eigenvalues
   real(kind=r8)     :: e_vec_out(elsi_h%n_l_rows,elsi_h%n_l_cols) !< Eigenvectors

   character*40, parameter :: caller = "elsi_ev_real_sparse"

   call elsi_check_handle(elsi_h,caller)

   ! Update counter
   elsi_h%n_elsi_calls = elsi_h%n_elsi_calls+1

   ! REAL case
   elsi_h%matrix_data_type = REAL_VALUES

   ! Safety check
   call elsi_check(elsi_h,caller)

   select case(elsi_h%solver)
   case(ELPA)
      ! Convert PEXSI H and S to BLACS format
      call elsi_pexsi_to_blacs_hs(elsi_h,H_in,S_in)

      ! Set matrices
      call elsi_set_hamiltonian(elsi_h,elsi_h%ham_real_elpa)
      call elsi_set_overlap(elsi_h,elsi_h%ovlp_real_elpa)
      call elsi_set_eigenvector(elsi_h,e_vec_out)
      call elsi_set_eigenvalue(elsi_h,e_val_out)

      ! Solve
      call elsi_solve_evp_elpa(elsi_h)

   case(LIBOMM)
      call elsi_stop(" Only ELPA computes eigenvalues and eigenvectors."//&
                     " Choose ELPA if necessary. Exiting...",elsi_h,caller)
   case(PEXSI)
      call elsi_stop(" Only ELPA computes eigenvalues and eigenvectors."//&
                     " Choose ELPA if necessary. Exiting...",elsi_h,caller)
   case(CHESS)
      call elsi_stop(" Only ELPA computes eigenvalues and eigenvectors."//&
                     " Choose ELPA if necessary. Exiting...",elsi_h,caller)
   case(SIPS)
      call elsi_stop(" Only ELPA computes eigenvalues and eigenvectors."//&
                     " Choose ELPA if necessary. Exiting...",elsi_h,caller)
   case DEFAULT
      call elsi_stop(" No supported solver has been chosen."//&
                     " Please choose ELPA solver to compute"//&
                     " eigenvalues and eigenvectors. Exiting...",elsi_h,caller)
   end select

   elsi_h%matrix_data_type = UNSET

end subroutine

!>
!! This routine computes the density matrix.
!!
subroutine elsi_dm_real(elsi_h,H_in,S_in,D_out,energy_out)

   implicit none

   type(elsi_handle) :: elsi_h                                 !< Handle
   real(kind=r8)     :: H_in(elsi_h%n_l_rows,elsi_h%n_l_cols)  !< Hamiltonian
   real(kind=r8)     :: S_in(elsi_h%n_l_rows,elsi_h%n_l_cols)  !< Overlap
   real(kind=r8)     :: D_out(elsi_h%n_l_rows,elsi_h%n_l_cols) !< Density matrix
   real(kind=r8)     :: energy_out                             !< Energy

   character*40, parameter :: caller = "elsi_dm_real"

   call elsi_check_handle(elsi_h,caller)

   ! Update counter
   elsi_h%n_elsi_calls = elsi_h%n_elsi_calls+1

   ! REAL case
   elsi_h%matrix_data_type = REAL_VALUES

   ! Safety check
   call elsi_check(elsi_h,caller)

   select case(elsi_h%solver)
   case(ELPA)
      ! Allocate
      if(.not. allocated(elsi_h%eval_elpa)) then
         call elsi_allocate(elsi_h,elsi_h%eval_elpa,elsi_h%n_g_size,&
                            "eval_elpa",caller)
      endif
      if(.not. allocated(elsi_h%evec_real_elpa)) then
         call elsi_allocate(elsi_h,elsi_h%evec_real_elpa,elsi_h%n_l_rows,&
                            elsi_h%n_l_cols,"evec_real_elpa",caller)
      endif

      ! Set matrices
      call elsi_set_hamiltonian(elsi_h,H_in)
      call elsi_set_overlap(elsi_h,S_in)
      call elsi_set_eigenvector(elsi_h,elsi_h%evec_real_elpa)
      call elsi_set_eigenvalue(elsi_h,elsi_h%eval_elpa)
      call elsi_set_density_matrix(elsi_h,D_out)

      ! Solve
      call elsi_solve_evp_elpa(elsi_h)

      ! Compute density matrix
      call elsi_compute_occ_elpa(elsi_h)
      call elsi_compute_dm_elpa(elsi_h)
      call elsi_get_energy(elsi_h,energy_out)

      elsi_h%mu_ready = .true.

   case(LIBOMM)
      call elsi_print_omm_options(elsi_h)

      if(elsi_h%n_elsi_calls .le. elsi_h%n_elpa_steps) then
         if((elsi_h%n_elsi_calls == 1) .and. (elsi_h%omm_flavor == 0)) then
            ! Overlap will be destroyed by Cholesky
            call elsi_allocate(elsi_h,elsi_h%ovlp_real_omm,elsi_h%n_l_rows,&
                               elsi_h%n_l_cols,"ovlp_real_omm",caller)
            elsi_h%ovlp_real_omm = S_in
         endif

         ! Compute libOMM initial guess by ELPA
         elsi_h%solver = ELPA

         ! Allocate
         if(.not. allocated(elsi_h%eval_elpa)) then
            call elsi_allocate(elsi_h,elsi_h%eval_elpa,elsi_h%n_g_size,&
                               "eval_elpa",caller)
         endif
         if(.not. allocated(elsi_h%evec_real_elpa)) then
            call elsi_allocate(elsi_h,elsi_h%evec_real_elpa,elsi_h%n_l_rows,&
                               elsi_h%n_l_cols,"evec_real_elpa",caller)
         endif

         ! Set matrices
         call elsi_set_hamiltonian(elsi_h,H_in)
         call elsi_set_overlap(elsi_h,S_in)
         call elsi_set_eigenvector(elsi_h,elsi_h%evec_real_elpa)
         call elsi_set_eigenvalue(elsi_h,elsi_h%eval_elpa)
         call elsi_set_density_matrix(elsi_h,D_out)

         ! Solve
         call elsi_solve_evp_elpa(elsi_h)

         ! Compute density matrix
         call elsi_compute_occ_elpa(elsi_h)
         call elsi_compute_dm_elpa(elsi_h)
         call elsi_get_energy(elsi_h,energy_out)

         ! Switch back to libOMM here to guarantee elsi_customize_omm
         elsi_h%solver = LIBOMM

      else ! ELPA is done
         if(allocated(elsi_h%ovlp_real_omm)) then
            ! Retrieve overlap matrix that has been destroyed by Cholesky
            S_in = elsi_h%ovlp_real_omm
            call elsi_deallocate(elsi_h,elsi_h%ovlp_real_omm,"ovlp_real_omm")

            call elsi_set_full_mat(elsi_h,S_in)
         endif

         ! Allocate
         if(.not. elsi_h%coeff_omm%is_initialized) then
            call m_allocate(elsi_h%coeff_omm,elsi_h%n_states,&
                            elsi_h%n_g_size,"pddbc")
         endif

         ! Set matrices
         call elsi_set_hamiltonian(elsi_h,H_in)
         call elsi_set_overlap(elsi_h,S_in)
         call elsi_set_density_matrix(elsi_h,D_out)

         ! Initialize coefficient matrix with ELPA eigenvectors if possible
         if((elsi_h%n_elpa_steps > 0) .and. &
            (elsi_h%n_elsi_calls == elsi_h%n_elpa_steps+1)) then
            ! libOMM coefficient matrix is the transpose of ELPA eigenvectors
            call pdtran(elsi_h%n_g_size,elsi_h%n_g_size,1.0_r8,elsi_h%evec_real,&
                        1,1,elsi_h%sc_desc,0.0_r8,D_out,1,1,elsi_h%sc_desc)

            elsi_h%coeff_omm%dval(1:elsi_h%coeff_omm%iaux2(1),1:elsi_h%coeff_omm%iaux2(2)) = &
               D_out(1:elsi_h%coeff_omm%iaux2(1),1:elsi_h%coeff_omm%iaux2(2))

            ! ELPA matrices are no longer needed
            if(associated(elsi_h%ham_real))      nullify(elsi_h%ham_real)
            if(associated(elsi_h%ovlp_real))     nullify(elsi_h%ovlp_real)
            if(associated(elsi_h%evec_real))     nullify(elsi_h%evec_real)
            if(associated(elsi_h%den_mat))       nullify(elsi_h%den_mat)
            if(associated(elsi_h%eval))          nullify(elsi_h%eval)
            if(allocated(elsi_h%evec_real_elpa)) call elsi_deallocate(elsi_h,elsi_h%evec_real_elpa,"evec_real_elpa")
            if(allocated(elsi_h%eval_elpa))      call elsi_deallocate(elsi_h,elsi_h%eval_elpa,"eval_elpa")
            if(allocated(elsi_h%occ_elpa))       call elsi_deallocate(elsi_h,elsi_h%occ_elpa,"occ_elpa")
         endif

         ! Solve
         call elsi_solve_evp_omm(elsi_h)

         elsi_h%den_mat_omm%dval = 2.0_r8*elsi_h%den_mat_omm%dval
         call elsi_get_energy(elsi_h,energy_out)
      endif

   case(PEXSI)
      call elsi_print_pexsi_options(elsi_h)

      ! Initialize PEXSI
      call elsi_init_pexsi(elsi_h)

      ! Convert BLACS H and S to PEXSI format
      call elsi_blacs_to_pexsi_hs(elsi_h,H_in,S_in)

      ! Allocate
      if(.not. allocated(elsi_h%den_mat_pexsi)) then
         call elsi_allocate(elsi_h,elsi_h%den_mat_pexsi,elsi_h%nnz_l_pexsi,&
                            "den_mat_pexsi",caller)
      endif
      elsi_h%den_mat_pexsi = 0.0_r8

      ! Set matrices
      call elsi_set_sparse_hamiltonian(elsi_h,elsi_h%ham_real_pexsi)
      call elsi_set_sparse_overlap(elsi_h,elsi_h%ovlp_real_pexsi)
      call elsi_set_row_ind(elsi_h,elsi_h%row_ind_pexsi)
      call elsi_set_col_ptr(elsi_h,elsi_h%col_ptr_pexsi)
      call elsi_set_sparse_density_matrix(elsi_h,elsi_h%den_mat_pexsi)

      ! Solve
      call elsi_solve_evp_pexsi(elsi_h)

      ! Convert PEXSI density matrix to BLACS format
      call elsi_pexsi_to_blacs_dm(elsi_h,D_out)
      call elsi_get_energy(elsi_h,energy_out)

      elsi_h%mu_ready = .true.

   case(CHESS)
      call elsi_stop(" CHESS not yet implemented. Exiting...",elsi_h,caller)
   case(SIPS)
      call elsi_stop(" SIPS not yet implemented. Exiting...",elsi_h,caller)
   case default
      call elsi_stop(" No supported solver has been chosen."//&
                     " Exiting...",elsi_h,caller)
   end select

   elsi_h%matrix_data_type = UNSET
   elsi_h%edm_ready = .true.

end subroutine

!>
!! This routine computes the energy-weighted density matrix.
!!
subroutine elsi_edm_real(elsi_h,D_out)

   implicit none

   type(elsi_handle), intent(inout) :: elsi_h                                 !< Handle
   real(kind=r8),     intent(out)   :: D_out(elsi_h%n_l_rows,elsi_h%n_l_cols) !< Energy density matrix

   character*40, parameter :: caller = "elsi_edm_real"

   call elsi_check_handle(elsi_h,caller)

   if(.not. elsi_h%edm_ready) then
      call elsi_stop(" Energy weighted density matrix has not been."//&
                     " computed. Exiting...",elsi_h,caller)
   endif

   ! REAL case
   elsi_h%matrix_data_type = REAL_VALUES

   select case(elsi_h%solver)
   case(ELPA)
      call elsi_set_density_matrix(elsi_h,D_out)

      call elsi_compute_edm_elpa(elsi_h)

   case(LIBOMM)
      call elsi_set_density_matrix(elsi_h,D_out)

      call elsi_compute_edm_omm(elsi_h)

      elsi_h%den_mat_omm%dval = 2.0_r8*elsi_h%den_mat_omm%dval

   case(PEXSI)
      elsi_h%den_mat_ccs = elsi_h%e_den_mat_pexsi

      call elsi_pexsi_to_blacs_dm(elsi_h,D_out)

   case(CHESS)
      call elsi_stop(" CHESS not yet implemented. Exiting...",elsi_h,caller)
   case(SIPS)
      call elsi_stop(" SIPS not yet implemented. Exiting...",elsi_h,caller)
   case DEFAULT
      call elsi_stop(" No supported solver has been chosen."//&
                     " Exiting...",elsi_h,caller)
   end select

   elsi_h%edm_ready = .false.
   elsi_h%matrix_data_type = UNSET

end subroutine

!>
!! This routine computes the density matrix.
!!
subroutine elsi_dm_complex(elsi_h,H_in,S_in,D_out,energy_out)

   implicit none

   type(elsi_handle) :: elsi_h                                 !< Handle
   complex(kind=r8)  :: H_in(elsi_h%n_l_rows,elsi_h%n_l_cols)  !< Hamiltonian
   complex(kind=r8)  :: S_in(elsi_h%n_l_rows,elsi_h%n_l_cols)  !< Overlap
   real(kind=r8)     :: D_out(elsi_h%n_l_rows,elsi_h%n_l_cols) !< Density matrix
   real(kind=r8)     :: energy_out                             !< Energy

   character*40, parameter :: caller = "elsi_dm_complex"

   call elsi_check_handle(elsi_h,caller)

   call elsi_stop(" ELSI density matrix solver for complex case not yet available."//&
                  " Exiting...",elsi_h,caller)

   ! Update counter
   elsi_h%n_elsi_calls = elsi_h%n_elsi_calls+1

   ! COMPLEX case
   elsi_h%matrix_data_type = COMPLEX_VALUES

   ! Safety check
   call elsi_check(elsi_h,caller)

   select case(elsi_h%solver)
   case(ELPA)
      ! Allocate
      if(.not. allocated(elsi_h%eval_elpa)) then
         call elsi_allocate(elsi_h,elsi_h%eval_elpa,elsi_h%n_g_size,"eval_elpa",caller)
      endif
      if(.not. allocated(elsi_h%evec_complex_elpa)) then
         call elsi_allocate(elsi_h,elsi_h%evec_complex_elpa,elsi_h%n_l_rows,&
                            elsi_h%n_l_cols,"evec_complex_elpa",caller)
      endif

      ! Set matrices
      call elsi_set_hamiltonian(elsi_h,H_in)
      call elsi_set_overlap(elsi_h,S_in)
      call elsi_set_eigenvector(elsi_h,elsi_h%evec_complex_elpa)
      call elsi_set_eigenvalue(elsi_h,elsi_h%eval_elpa)
      call elsi_set_density_matrix(elsi_h,D_out)

      ! Solve
      call elsi_solve_evp_elpa(elsi_h)

      ! Compute density matrix
      call elsi_compute_occ_elpa(elsi_h)
      call elsi_compute_dm_elpa(elsi_h)
      call elsi_get_energy(elsi_h,energy_out)

   case(LIBOMM)
      call elsi_print_omm_options(elsi_h)

      ! Allocate
      if(.not. elsi_h%coeff_omm%is_initialized) then
         call m_allocate(elsi_h%coeff_omm,elsi_h%n_states,&
                         elsi_h%n_g_size,"pddbc")
      endif

      ! Set matrices
      call elsi_set_hamiltonian(elsi_h,H_in)
      call elsi_set_overlap(elsi_h,S_in)
      call elsi_set_density_matrix(elsi_h,D_out)

      ! Solve
      call elsi_solve_evp_omm(elsi_h)

      elsi_h%den_mat_omm%dval = 2.0_r8*elsi_h%den_mat_omm%dval
      call elsi_get_energy(elsi_h,energy_out)

   case(PEXSI)
      call elsi_stop(" PEXSI not yet implemented. Exiting...",elsi_h,caller)
   case(CHESS)
      call elsi_stop(" CHESS not yet implemented. Exiting...",elsi_h,caller)
   case(SIPS)
      call elsi_stop(" SIPS not yet implemented. Exiting...",elsi_h,caller)
   case default
      call elsi_stop(" No supported solver has been chosen."//&
                     " Exiting...",elsi_h,caller)
   end select

   elsi_h%matrix_data_type = UNSET

end subroutine

!>
!! This routine computes the density matrix.
!!
subroutine elsi_dm_real_sparse(elsi_h,H_in,S_in,D_out,energy_out)

   implicit none

   type(elsi_handle) :: elsi_h                    !< Handle
   real(kind=r8)     :: H_in(elsi_h%nnz_l_pexsi)  !< Hamiltonian
   real(kind=r8)     :: S_in(elsi_h%nnz_l_pexsi)  !< Overlap
   real(kind=r8)     :: D_out(elsi_h%nnz_l_pexsi) !< Density matrix
   real(kind=r8)     :: energy_out                !< Energy

   character*40, parameter :: caller = "elsi_dm_real_sparse"

   call elsi_check_handle(elsi_h,caller)

   ! Update counter
   elsi_h%n_elsi_calls = elsi_h%n_elsi_calls+1

   ! REAL case
   elsi_h%matrix_data_type = REAL_VALUES

   ! Safety check
   call elsi_check(elsi_h,caller)

   select case(elsi_h%solver)
   case(ELPA)
      ! Convert PEXSI H and S to BLACS format
      call elsi_pexsi_to_blacs_hs(elsi_h,H_in,S_in)

      ! Allocate
      if(.not. allocated(elsi_h%eval_elpa)) then
         call elsi_allocate(elsi_h,elsi_h%eval_elpa,elsi_h%n_g_size,&
                            "eval_elpa",caller)
      endif
      if(.not. allocated(elsi_h%evec_real_elpa)) then
         call elsi_allocate(elsi_h,elsi_h%evec_real_elpa,elsi_h%n_l_rows,&
                            elsi_h%n_l_cols,"evec_real_elpa",caller)
      endif
      if(.not. allocated(elsi_h%den_mat_elpa)) then
         call elsi_allocate(elsi_h,elsi_h%den_mat_elpa,elsi_h%n_l_rows,&
                            elsi_h%n_l_cols,"den_mat_elpa",caller)
      endif

      ! Set matrices
      call elsi_set_hamiltonian(elsi_h,elsi_h%ham_real_elpa)
      call elsi_set_overlap(elsi_h,elsi_h%ovlp_real_elpa)
      call elsi_set_eigenvector(elsi_h,elsi_h%evec_real_elpa)
      call elsi_set_eigenvalue(elsi_h,elsi_h%eval_elpa)
      call elsi_set_density_matrix(elsi_h,elsi_h%den_mat_elpa)

      ! Solve eigenvalue problem
      call elsi_solve_evp_elpa(elsi_h)

      ! Compute density matrix
      call elsi_compute_occ_elpa(elsi_h)
      call elsi_compute_dm_elpa(elsi_h)
      call elsi_blacs_to_pexsi_dm(elsi_h,D_out)
      call elsi_get_energy(elsi_h,energy_out)

      elsi_h%mu_ready = .true.

   case(LIBOMM)
      call elsi_print_omm_options(elsi_h)

      ! Convert PEXSI H and S to BLACS format
      call elsi_pexsi_to_blacs_hs(elsi_h,H_in,S_in)

      if(elsi_h%n_elsi_calls .le. elsi_h%n_elpa_steps) then
         if((elsi_h%n_elsi_calls == 1) .and. (elsi_h%omm_flavor == 0)) then
            ! Overlap will be destroyed by Cholesky
            call elsi_allocate(elsi_h,elsi_h%ovlp_real_omm,elsi_h%n_l_rows,&
                               elsi_h%n_l_cols,"ovlp_real_omm",caller)
            elsi_h%ovlp_real_omm = elsi_h%ovlp_real_elpa
         endif

         ! Compute libOMM initial guess by ELPA
         elsi_h%solver = ELPA

         ! Allocate
         if(.not. allocated(elsi_h%eval_elpa)) then
            call elsi_allocate(elsi_h,elsi_h%eval_elpa,elsi_h%n_g_size,&
                               "eval_elpa",caller)
         endif
         if(.not. allocated(elsi_h%evec_real_elpa)) then
            call elsi_allocate(elsi_h,elsi_h%evec_real_elpa,elsi_h%n_l_rows,&
                               elsi_h%n_l_cols,"evec_real_elpa",caller)
         endif
         if(.not. allocated(elsi_h%den_mat_elpa)) then
            call elsi_allocate(elsi_h,elsi_h%den_mat_elpa,elsi_h%n_l_rows,&
                               elsi_h%n_l_cols,"den_mat_elpa",caller)
         endif

         ! Set matrices
         call elsi_set_hamiltonian(elsi_h,elsi_h%ham_real_elpa)
         call elsi_set_overlap(elsi_h,elsi_h%ovlp_real_elpa)
         call elsi_set_eigenvector(elsi_h,elsi_h%evec_real_elpa)
         call elsi_set_eigenvalue(elsi_h,elsi_h%eval_elpa)
         call elsi_set_density_matrix(elsi_h,elsi_h%den_mat_elpa)

         ! Solve eigenvalue problem
         call elsi_solve_evp_elpa(elsi_h)

         ! Compute density matrix
         call elsi_compute_occ_elpa(elsi_h)
         call elsi_compute_dm_elpa(elsi_h)
         call elsi_blacs_to_pexsi_dm(elsi_h,D_out)
         call elsi_get_energy(elsi_h,energy_out)

         ! Switch back to libOMM here to guarantee elsi_customize_omm
         elsi_h%solver = LIBOMM

      else ! ELPA is done
         if(allocated(elsi_h%ovlp_real_omm)) then
            ! Retrieve overlap matrix that has been destroyed by Cholesky
            elsi_h%ovlp_real_elpa = elsi_h%ovlp_real_omm
            call elsi_deallocate(elsi_h,elsi_h%ovlp_real_omm,"ovlp_real_omm")

            call elsi_set_full_mat(elsi_h,elsi_h%ovlp_real_elpa)
         endif

         ! Allocate
         if(.not. elsi_h%coeff_omm%is_initialized) then
            call m_allocate(elsi_h%coeff_omm,elsi_h%n_states,&
                            elsi_h%n_g_size,"pddbc")
         endif

         ! Set matrices
         call elsi_set_hamiltonian(elsi_h,elsi_h%ham_real_elpa)
         call elsi_set_overlap(elsi_h,elsi_h%ovlp_real_elpa)
         call elsi_set_density_matrix(elsi_h,elsi_h%den_mat_elpa)

         ! Initialize coefficient matrix with ELPA eigenvectors if possible
         if((elsi_h%n_elpa_steps > 0) .and. &
            (elsi_h%n_elsi_calls == elsi_h%n_elpa_steps+1)) then
            ! libOMM coefficient matrix is the transpose of ELPA eigenvectors
            call pdtran(elsi_h%n_g_size,elsi_h%n_g_size,1.0_r8,elsi_h%evec_real,1,1,&
                        elsi_h%sc_desc,0.0_r8,elsi_h%den_mat_elpa,1,1,elsi_h%sc_desc)

            elsi_h%coeff_omm%dval(1:elsi_h%coeff_omm%iaux2(1),1:elsi_h%coeff_omm%iaux2(2)) = &
               elsi_h%den_mat_elpa(1:elsi_h%coeff_omm%iaux2(1),1:elsi_h%coeff_omm%iaux2(2))

            ! ELPA matrices are no longer needed
            if(associated(elsi_h%ham_real))      nullify(elsi_h%ham_real)
            if(associated(elsi_h%ovlp_real))     nullify(elsi_h%ovlp_real)
            if(associated(elsi_h%evec_real))     nullify(elsi_h%evec_real)
            if(associated(elsi_h%den_mat))       nullify(elsi_h%den_mat)
            if(associated(elsi_h%eval))          nullify(elsi_h%eval)
            if(allocated(elsi_h%evec_real_elpa)) call elsi_deallocate(elsi_h,elsi_h%evec_real_elpa,"evec_real_elpa")
            if(allocated(elsi_h%eval_elpa))      call elsi_deallocate(elsi_h,elsi_h%eval_elpa,"eval_elpa")
            if(allocated(elsi_h%occ_elpa))       call elsi_deallocate(elsi_h,elsi_h%occ_elpa,"occ_elpa")
         endif

         ! Solve
         call elsi_solve_evp_omm(elsi_h)

         elsi_h%den_mat_omm%dval = 2.0_r8*elsi_h%den_mat_omm%dval
         call elsi_blacs_to_pexsi_dm(elsi_h,D_out)
         call elsi_get_energy(elsi_h,energy_out)
      endif

   case(PEXSI)
      call elsi_print_pexsi_options(elsi_h)

      ! Set matrices
      call elsi_set_sparse_hamiltonian(elsi_h,H_in)
      call elsi_set_sparse_overlap(elsi_h,S_in)
      call elsi_set_sparse_density_matrix(elsi_h,D_out)

      ! Initialize PEXSI
      call elsi_init_pexsi(elsi_h)

      ! Solve
      call elsi_solve_evp_pexsi(elsi_h)

      call elsi_get_energy(elsi_h,energy_out)

      elsi_h%mu_ready = .true.

   case(CHESS)
      call elsi_stop(" CHESS not yet implemented. Exiting...",elsi_h,caller)
   case(SIPS)
      call elsi_stop(" SIPS not yet implemented. Exiting...",elsi_h,caller)
   case default
      call elsi_stop(" No supported solver has been chosen."//&
                     " Exiting...",elsi_h,caller)
   end select

   elsi_h%matrix_data_type = UNSET
   elsi_h%edm_ready = .true.

end subroutine

end module ELSI
