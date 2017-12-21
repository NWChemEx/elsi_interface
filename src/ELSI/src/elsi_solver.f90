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
!! This module contains subroutines to solve an eigenproblem or to compute the
!! density matrix, using one of the five solvers ELPA, libOMM, PEXSI, CheSS,
!! and SIPs.
!!
module ELSI_SOLVER

   use ELSI_CHESS,     only: elsi_init_chess,elsi_solve_evp_chess_real
   use ELSI_CONSTANTS, only: ELPA_SOLVER,OMM_SOLVER,PEXSI_SOLVER,CHESS_SOLVER,&
                             SIPS_SOLVER,MULTI_PROC,SINGLE_PROC
   use ELSI_DATATYPE
   use ELSI_DMP,       only: elsi_solve_evp_dmp_real
   use ELSI_ELPA,      only: elsi_compute_occ_elpa,elsi_compute_dm_elpa_real,&
                             elsi_normalize_dm_elpa_real,&
                             elsi_solve_evp_elpa_real,&
                             elsi_compute_dm_elpa_cmplx,&
                             elsi_normalize_dm_elpa_cmplx,&
                             elsi_solve_evp_elpa_cmplx
   use ELSI_LAPACK,    only: elsi_solve_evp_lapack_real,&
                             elsi_solve_evp_lapack_cmplx
   use ELSI_MALLOC
   use ELSI_MATCONV
   use ELSI_OMM,       only: elsi_solve_evp_omm_real,&
                             elsi_solve_evp_omm_cmplx
   use ELSI_PEXSI,     only: elsi_init_pexsi,elsi_solve_evp_pexsi_real,&
                             elsi_solve_evp_pexsi_cmplx
   use ELSI_PRECISION, only: r8,i4
   use ELSI_SETUP,     only: elsi_set_blacs
   use ELSI_SIPS,      only: elsi_init_sips,elsi_solve_evp_sips_real,&
                             elsi_sips_to_blacs_ev_real
   use ELSI_UTILS
   use MATRIXSWITCH,   only: m_allocate

   implicit none

   private

   ! Solver
   public :: elsi_ev_real
   public :: elsi_ev_complex
   public :: elsi_ev_real_sparse
   public :: elsi_ev_complex_sparse
   public :: elsi_dm_real
   public :: elsi_dm_complex
   public :: elsi_dm_real_sparse
   public :: elsi_dm_complex_sparse

contains

!>
!! This routine gets the energy.
!!
subroutine elsi_get_energy(e_h,energy,solver)

   implicit none

   type(elsi_handle), intent(inout) :: e_h    !< Handle
   real(kind=r8),     intent(out)   :: energy !< Energy of the system
   integer(kind=i4),  intent(in)    :: solver !< Solver in use

   real(kind=r8)    :: tmp_real
   integer(kind=i4) :: i_state
   integer(kind=i4) :: mpierr

   character*40, parameter :: caller = "elsi_get_energy"

   select case(solver)
   case(ELPA_SOLVER)
      energy = 0.0_r8

      do i_state = 1,e_h%n_states_solve
         energy = energy+e_h%i_weight*e_h%eval_elpa(i_state)*&
                     e_h%occ_num(i_state,e_h%i_spin,e_h%i_kpt)
      enddo
   case(OMM_SOLVER)
      energy = e_h%spin_degen*e_h%energy_hdm*e_h%i_weight
   case(PEXSI_SOLVER)
      energy = e_h%energy_hdm*e_h%i_weight
   case(CHESS_SOLVER)
      energy = e_h%energy_hdm*e_h%i_weight
   case(SIPS_SOLVER)
      call elsi_stop(" SIPS not yet implemented.",e_h,caller)
   case(DMP_SOLVER)
      energy = e_h%spin_degen*e_h%energy_hdm*e_h%i_weight
   case default
      call elsi_stop(" Unsupported solver.",e_h,caller)
   end select

   if(e_h%n_spins*e_h%n_kpts > 1) then
      if(e_h%myid /= 0) then
         energy = 0.0_r8
      endif

      call MPI_Allreduce(energy,tmp_real,1,mpi_real8,mpi_sum,e_h%mpi_comm_all,&
              mpierr)

      energy = tmp_real
   endif

end subroutine

!>
!! This routine computes the eigenvalues and eigenvectors. Note the
!! intent(inout) - it is because everything has the potential to be reused in
!! the next call.
!!
subroutine elsi_ev_real(e_h,ham,ovlp,eval,evec)

   implicit none

   type(elsi_handle), intent(inout) :: e_h                         !< Handle
   real(kind=r8),     intent(inout) :: ham(e_h%n_lrow,e_h%n_lcol)  !< Hamiltonian
   real(kind=r8),     intent(inout) :: ovlp(e_h%n_lrow,e_h%n_lcol) !< Overlap
   real(kind=r8),     intent(inout) :: eval(e_h%n_basis)           !< Eigenvalues
   real(kind=r8),     intent(inout) :: evec(e_h%n_lrow,e_h%n_lcol) !< Eigenvectors

   character*40, parameter :: caller = "elsi_ev_real"

   call elsi_check_handle(e_h,caller)

   ! Update counter
   e_h%n_elsi_calls = e_h%n_elsi_calls+1

   ! Safety check
   call elsi_check(e_h,caller)

   call elsi_print_settings(e_h)

   select case(e_h%solver)
   case(ELPA_SOLVER)
      if(e_h%parallel_mode == SINGLE_PROC) then
         call elsi_solve_evp_lapack_real(e_h,ham,ovlp,eval,evec)
      else
         call elsi_solve_evp_elpa_real(e_h,ham,ovlp,eval,evec)
      endif
   case(OMM_SOLVER)
      call elsi_stop(" LIBOMM is not an eigensolver.",e_h,caller)
   case(PEXSI_SOLVER)
      call elsi_stop(" PEXSI is not an eigensolver.",e_h,caller)
   case(CHESS_SOLVER)
      call elsi_stop(" CHESS is not an eigensolver.",e_h,caller)
   case(SIPS_SOLVER)
      if(e_h%n_elsi_calls <= e_h%sips_n_elpa) then
         if(e_h%n_elsi_calls == 1) then
            ! Overlap will be destroyed by Cholesky
            call elsi_allocate(e_h,e_h%ovlp_real_copy,e_h%n_lrow,e_h%n_lcol,&
                    "ovlp_real_copy",caller)
            e_h%ovlp_real_copy = ovlp
         endif

         call elsi_solve_evp_elpa_real(e_h,ham,ovlp,eval,evec)
      else ! ELPA is done
         if(allocated(e_h%ovlp_real_copy)) then
            ! Retrieve overlap matrix that has been destroyed by Cholesky
            ovlp = e_h%ovlp_real_copy
            call elsi_deallocate(e_h,e_h%ovlp_real_copy,"ovlp_real_copy")
         endif

         call elsi_init_sips(e_h)
         call elsi_blacs_to_sips_hs_real(e_h,ham,ovlp)
         call elsi_solve_evp_sips_real(e_h,e_h%ham_real_sips,&
                 e_h%ovlp_real_sips,eval)
         call elsi_sips_to_blacs_ev_real(e_h,evec)
      endif
   case(DMP_SOLVER)
      call elsi_stop(" DMP is not an eigensolver.",e_h,caller)
   case default
      call elsi_stop(" Unsupported solver.",e_h,caller)
   end select

end subroutine

!>
!! This routine computes the eigenvalues and eigenvectors. Note the
!! intent(inout) - it is because everything has the potential to be reused in
!! the next call.
!!
subroutine elsi_ev_complex(e_h,ham,ovlp,eval,evec)

   implicit none

   type(elsi_handle), intent(inout) :: e_h                         !< Handle
   complex(kind=r8),  intent(inout) :: ham(e_h%n_lrow,e_h%n_lcol)  !< Hamiltonian
   complex(kind=r8),  intent(inout) :: ovlp(e_h%n_lrow,e_h%n_lcol) !< Overlap
   real(kind=r8),     intent(inout) :: eval(e_h%n_basis)           !< Eigenvalues
   complex(kind=r8),  intent(inout) :: evec(e_h%n_lrow,e_h%n_lcol) !< Eigenvectors

   character*40, parameter :: caller = "elsi_ev_complex"

   call elsi_check_handle(e_h,caller)

   ! Update counter
   e_h%n_elsi_calls = e_h%n_elsi_calls+1

   ! Safety check
   call elsi_check(e_h,caller)

   call elsi_print_settings(e_h)

   select case(e_h%solver)
   case(ELPA_SOLVER)
      if(e_h%parallel_mode == SINGLE_PROC) then
         call elsi_solve_evp_lapack_cmplx(e_h,ham,ovlp,eval,evec)
      else
         call elsi_solve_evp_elpa_cmplx(e_h,ham,ovlp,eval,evec)
      endif
   case(OMM_SOLVER)
      call elsi_stop(" LIBOMM is not an eigensolver.",e_h,caller)
   case(PEXSI_SOLVER)
      call elsi_stop(" PEXSI is not an eigensolver.",e_h,caller)
   case(CHESS_SOLVER)
      call elsi_stop(" CHESS is not an eigensolver.",e_h,caller)
   case(SIPS_SOLVER)
      call elsi_stop(" SIPS not yet implemented.",e_h,caller)
   case(DMP_SOLVER)
      call elsi_stop(" DMP is not an eigensolver.",e_h,caller)
   case default
      call elsi_stop(" Unsupported solver.",e_h,caller)
   end select

end subroutine

!>
!! This routine computes the eigenvalues and eigenvectors. Note the
!! intent(inout) - it is because everything has the potential to be reused in
!! the next call.
!!
subroutine elsi_ev_real_sparse(e_h,ham,ovlp,eval,evec)

   implicit none

   type(elsi_handle), intent(inout) :: e_h                         !< Handle
   real(kind=r8),     intent(inout) :: ham(e_h%nnz_l_sp)           !< Hamiltonian
   real(kind=r8),     intent(inout) :: ovlp(e_h%nnz_l_sp)          !< Overlap
   real(kind=r8),     intent(inout) :: eval(e_h%n_basis)           !< Eigenvalues
   real(kind=r8),     intent(inout) :: evec(e_h%n_lrow,e_h%n_lcol) !< Eigenvectors

   character*40, parameter :: caller = "elsi_ev_real_sparse"

   call elsi_check_handle(e_h,caller)

   ! Update counter
   e_h%n_elsi_calls = e_h%n_elsi_calls+1

   ! Safety check
   call elsi_check(e_h,caller)

   call elsi_print_settings(e_h)

   select case(e_h%solver)
   case(ELPA_SOLVER)
      call elsi_sips_to_blacs_hs_real(e_h,ham,ovlp)
      call elsi_solve_evp_elpa_real(e_h,e_h%ham_real_elpa,e_h%ovlp_real_elpa,&
              eval,evec)
   case(OMM_SOLVER)
      call elsi_stop(" LIBOMM is not an eigensolver.",e_h,caller)
   case(PEXSI_SOLVER)
      call elsi_stop(" PEXSI is not an eigensolver.",e_h,caller)
   case(CHESS_SOLVER)
      call elsi_stop(" CHESS is not an eigensolver.",e_h,caller)
   case(SIPS_SOLVER) ! TODO
      call elsi_stop(" SIPS not yet implemented.",e_h,caller)
   case(DMP_SOLVER)
      call elsi_stop(" DMP is not an eigensolver.",e_h,caller)
   case default
      call elsi_stop(" Unsupported solver.",e_h,caller)
   end select

end subroutine

!>
!! This routine computes the eigenvalues and eigenvectors. Note the
!! intent(inout) - it is because everything has the potential to be reused in
!! the next call.
!!
subroutine elsi_ev_complex_sparse(e_h,ham,ovlp,eval,evec)

   implicit none

   type(elsi_handle), intent(inout) :: e_h                         !< Handle
   complex(kind=r8),  intent(inout) :: ham(e_h%nnz_l_sp)           !< Hamiltonian
   complex(kind=r8),  intent(inout) :: ovlp(e_h%nnz_l_sp)          !< Overlap
   real(kind=r8),     intent(inout) :: eval(e_h%n_basis)           !< Eigenvalues
   complex(kind=r8),  intent(inout) :: evec(e_h%n_lrow,e_h%n_lcol) !< Eigenvectors

   character*40, parameter :: caller = "elsi_ev_complex_sparse"

   call elsi_check_handle(e_h,caller)

   ! Update counter
   e_h%n_elsi_calls = e_h%n_elsi_calls+1

   ! Safety check
   call elsi_check(e_h,caller)

   call elsi_print_settings(e_h)

   select case(e_h%solver)
   case(ELPA_SOLVER)
      call elsi_sips_to_blacs_hs_cmplx(e_h,ham,ovlp)
      call elsi_solve_evp_elpa_cmplx(e_h,e_h%ham_cmplx_elpa,&
              e_h%ovlp_cmplx_elpa,eval,evec)
   case(OMM_SOLVER)
      call elsi_stop(" LIBOMM is not an eigensolver.",e_h,caller)
   case(PEXSI_SOLVER)
      call elsi_stop(" PEXSI is not an eigensolver.",e_h,caller)
   case(CHESS_SOLVER)
      call elsi_stop(" CHESS is not an eigensolver.",e_h,caller)
   case(SIPS_SOLVER)
      call elsi_stop(" SIPS not yet implemented.",e_h,caller)
   case(DMP_SOLVER)
      call elsi_stop(" DMP is not an eigensolver.",e_h,caller)
   case default
      call elsi_stop(" Unsupported solver.",e_h,caller)
   end select

end subroutine

!>
!! This routine computes the density matrix. Note the intent(inout) - it is
!! because everything has the potential to be reused in the next call.
!!
subroutine elsi_dm_real(e_h,ham,ovlp,dm,energy)

   implicit none

   type(elsi_handle), intent(inout) :: e_h                         !< Handle
   real(kind=r8),     intent(inout) :: ham(e_h%n_lrow,e_h%n_lcol)  !< Hamiltonian
   real(kind=r8),     intent(inout) :: ovlp(e_h%n_lrow,e_h%n_lcol) !< Overlap
   real(kind=r8),     intent(inout) :: dm(e_h%n_lrow,e_h%n_lcol)   !< Density matrix
   real(kind=r8),     intent(inout) :: energy                      !< Energy

   character*40, parameter :: caller = "elsi_dm_real"

   call elsi_check_handle(e_h,caller)

   ! Update counter
   e_h%n_elsi_calls = e_h%n_elsi_calls+1

   ! Safety check
   call elsi_check(e_h,caller)

   call elsi_print_settings(e_h)

   select case(e_h%solver)
   case(ELPA_SOLVER)
      ! Allocate
      if(.not. allocated(e_h%eval_elpa)) then
         call elsi_allocate(e_h,e_h%eval_elpa,e_h%n_basis,"eval_elpa",caller)
      endif
      if(.not. allocated(e_h%evec_real_elpa)) then
         call elsi_allocate(e_h,e_h%evec_real_elpa,e_h%n_lrow,e_h%n_lcol,&
                 "evec_real_elpa",caller)
      endif

      ! Save overlap
      if(e_h%n_elsi_calls==1 .and. e_h%n_single_steps > 0) then
         call elsi_allocate(e_h,e_h%ovlp_real_copy,e_h%n_lrow,e_h%n_lcol,&
                 "ovlp_real_copy",caller)
         e_h%ovlp_real_copy = ovlp
      endif

      call elsi_solve_evp_elpa_real(e_h,ham,ovlp,e_h%eval_elpa,&
              e_h%evec_real_elpa)
      call elsi_compute_occ_elpa(e_h,e_h%eval_elpa)
      call elsi_compute_dm_elpa_real(e_h,e_h%evec_real_elpa,dm,ham)
      call elsi_get_energy(e_h,energy,ELPA_SOLVER)

      ! Normalize density matrix
      if(e_h%n_elsi_calls <= e_h%n_single_steps) then
         call elsi_normalize_dm_elpa_real(e_h,e_h%ovlp_real_copy,dm)
      endif

      e_h%mu_ready = .true.
   case(OMM_SOLVER)
      if(e_h%n_elsi_calls <= e_h%omm_n_elpa) then
         if(e_h%n_elsi_calls == 1 .and. e_h%omm_flavor == 0) then
            ! Overlap will be destroyed by Cholesky
            call elsi_allocate(e_h,e_h%ovlp_real_copy,e_h%n_lrow,e_h%n_lcol,&
                    "ovlp_real_copy",caller)
            e_h%ovlp_real_copy = ovlp
         endif

         ! Compute libOMM initial guess by ELPA
         if(.not. allocated(e_h%eval_elpa)) then
            call elsi_allocate(e_h,e_h%eval_elpa,e_h%n_basis,"eval_elpa",caller)
         endif
         if(.not. allocated(e_h%evec_real_elpa)) then
            call elsi_allocate(e_h,e_h%evec_real_elpa,e_h%n_lrow,e_h%n_lcol,&
                    "evec_real_elpa",caller)
         endif

         call elsi_solve_evp_elpa_real(e_h,ham,ovlp,e_h%eval_elpa,&
                 e_h%evec_real_elpa)
         call elsi_compute_occ_elpa(e_h,e_h%eval_elpa)
         call elsi_compute_dm_elpa_real(e_h,e_h%evec_real_elpa,dm,ham)
         call elsi_get_energy(e_h,energy,ELPA_SOLVER)
      else ! ELPA is done
         if(allocated(e_h%ovlp_real_copy)) then
            ! Retrieve overlap matrix that has been destroyed by Cholesky
            ovlp = e_h%ovlp_real_copy
            call elsi_deallocate(e_h,e_h%ovlp_real_copy,"ovlp_real_copy")
         endif

         if(.not. e_h%coeff%is_initialized) then
            call m_allocate(e_h%coeff,e_h%n_states_omm,e_h%n_basis,"pddbc")
         endif

         ! Initialize coefficient matrix with ELPA eigenvectors if possible
         if(e_h%omm_n_elpa > 0 .and. e_h%n_elsi_calls == e_h%omm_n_elpa+1) then
            ! libOMM coefficient matrix is the transpose of ELPA eigenvectors
            call pdtran(e_h%n_basis,e_h%n_basis,1.0_r8,e_h%evec_real_elpa,1,1,&
                    e_h%sc_desc,0.0_r8,dm,1,1,e_h%sc_desc)

            e_h%coeff%dval(1:e_h%coeff%iaux2(1),1:e_h%coeff%iaux2(2)) = &
               dm(1:e_h%coeff%iaux2(1),1:e_h%coeff%iaux2(2))

            ! ELPA matrices are no longer needed
            if(allocated(e_h%evec_real_elpa)) then
               call elsi_deallocate(e_h,e_h%evec_real_elpa,"evec_real_elpa")
            endif
            if(allocated(e_h%eval_elpa)) then
               call elsi_deallocate(e_h,e_h%eval_elpa,"eval_elpa")
            endif
            if(allocated(e_h%eval_all)) then
               call elsi_deallocate(e_h,e_h%eval_all,"eval_all")
            endif
            if(allocated(e_h%occ_num)) then
               call elsi_deallocate(e_h,e_h%occ_num,"occ_num")
            endif
            if(allocated(e_h%k_weight)) then
               call elsi_deallocate(e_h,e_h%k_weight,"k_weight")
            endif
         endif

         call elsi_solve_evp_omm_real(e_h,ham,ovlp,dm)
         call elsi_get_energy(e_h,energy,OMM_SOLVER)
      endif
   case(PEXSI_SOLVER)
      call elsi_init_pexsi(e_h)
      call elsi_blacs_to_pexsi_hs_real(e_h,ham,ovlp)

      if(.not. allocated(e_h%dm_real_pexsi)) then
         call elsi_allocate(e_h,e_h%dm_real_pexsi,e_h%nnz_l_sp,"dm_real_pexsi",&
                 caller)
      endif
      e_h%dm_real_pexsi = 0.0_r8

      call elsi_solve_evp_pexsi_real(e_h,e_h%ham_real_pexsi,&
              e_h%ovlp_real_pexsi,e_h%dm_real_pexsi)
      call elsi_pexsi_to_blacs_dm_real(e_h,dm)
      call elsi_get_energy(e_h,energy,PEXSI_SOLVER)

      e_h%mu_ready = .true.
   case(CHESS_SOLVER)
      call elsi_blacs_to_chess_hs_real(e_h,ham,ovlp)
      call elsi_init_chess(e_h)
      call elsi_solve_evp_chess_real(e_h)
      call elsi_chess_to_blacs_dm_real(e_h,dm)
      call elsi_get_energy(e_h,energy,CHESS_SOLVER)

      e_h%mu_ready = .true.
   case(SIPS_SOLVER)
      call elsi_stop(" SIPS not yet implemented.",e_h,caller)
   case(DMP_SOLVER)
      ! Save Hamiltonian and overlap
      if(e_h%n_elsi_calls==1) then
         call elsi_allocate(e_h,e_h%ham_real_copy,e_h%n_lrow,e_h%n_lcol,&
                 "ham_real_copy",caller)
         call elsi_allocate(e_h,e_h%ovlp_real_copy,e_h%n_lrow,e_h%n_lcol,&
                 "ovlp_real_copy",caller)
         e_h%ovlp_real_copy = ovlp
      endif
      e_h%ham_real_copy = ham

      ! Solve
      call elsi_solve_evp_dmp_real(e_h,ham,ovlp,dm)
      call elsi_get_energy(e_h,energy,DMP_SOLVER)
   case default
      call elsi_stop(" Unsupported solver.",e_h,caller)
   end select

   e_h%edm_ready_real = .true.

end subroutine

!>
!! This routine computes the density matrix. Note the intent(inout) - it is
!! because everything has the potential to be reused in the next call.
!!
subroutine elsi_dm_complex(e_h,ham,ovlp,dm,energy)

   implicit none

   type(elsi_handle), intent(inout) :: e_h                         !< Handle
   complex(kind=r8),  intent(inout) :: ham(e_h%n_lrow,e_h%n_lcol)  !< Hamiltonian
   complex(kind=r8),  intent(inout) :: ovlp(e_h%n_lrow,e_h%n_lcol) !< Overlap
   complex(kind=r8),  intent(inout) :: dm(e_h%n_lrow,e_h%n_lcol)   !< Density matrix
   real(kind=r8),     intent(inout) :: energy                      !< Energy

   character*40, parameter :: caller = "elsi_dm_complex"

   call elsi_check_handle(e_h,caller)

   ! Update counter
   e_h%n_elsi_calls = e_h%n_elsi_calls+1

   ! Safety check
   call elsi_check(e_h,caller)

   call elsi_print_settings(e_h)

   select case(e_h%solver)
   case(ELPA_SOLVER)
      if(.not. allocated(e_h%eval_elpa)) then
         call elsi_allocate(e_h,e_h%eval_elpa,e_h%n_basis,"eval_elpa",caller)
      endif
      if(.not. allocated(e_h%evec_cmplx_elpa)) then
         call elsi_allocate(e_h,e_h%evec_cmplx_elpa,e_h%n_lrow,e_h%n_lcol,&
                 "evec_cmplx_elpa",caller)
      endif

      ! Save overlap
      if(e_h%n_elsi_calls==1 .and. e_h%n_single_steps > 0) then
         call elsi_allocate(e_h,e_h%ovlp_cmplx_copy,e_h%n_lrow,e_h%n_lcol,&
                 "ovlp_cmplx_copy",caller)
         e_h%ovlp_cmplx_copy = ovlp
      endif

      call elsi_solve_evp_elpa_cmplx(e_h,ham,ovlp,e_h%eval_elpa,&
              e_h%evec_cmplx_elpa)
      call elsi_compute_occ_elpa(e_h,e_h%eval_elpa)
      call elsi_compute_dm_elpa_cmplx(e_h,e_h%evec_cmplx_elpa,dm,ham)
      call elsi_get_energy(e_h,energy,ELPA_SOLVER)

      ! Normalize density matrix
      if(e_h%n_elsi_calls <= e_h%n_single_steps) then
         call elsi_normalize_dm_elpa_cmplx(e_h,e_h%ovlp_cmplx_copy,dm)
      endif

      e_h%mu_ready = .true.
   case(OMM_SOLVER)
      if(e_h%n_elsi_calls <= e_h%omm_n_elpa) then
         if(e_h%n_elsi_calls == 1 .and. e_h%omm_flavor == 0) then
            ! Overlap will be destroyed by Cholesky
            call elsi_allocate(e_h,e_h%ovlp_cmplx_copy,e_h%n_lrow,e_h%n_lcol,&
                    "ovlp_cmplx_copy",caller)
            e_h%ovlp_cmplx_copy = ovlp
         endif

         ! Compute libOMM initial guess by ELPA
         if(.not. allocated(e_h%eval_elpa)) then
            call elsi_allocate(e_h,e_h%eval_elpa,e_h%n_basis,"eval_elpa",caller)
         endif
         if(.not. allocated(e_h%evec_cmplx_elpa)) then
            call elsi_allocate(e_h,e_h%evec_cmplx_elpa,e_h%n_lrow,e_h%n_lcol,&
                    "evec_cmplx_elpa",caller)
         endif

         call elsi_solve_evp_elpa_cmplx(e_h,ham,ovlp,e_h%eval_elpa,&
                 e_h%evec_cmplx_elpa)
         call elsi_compute_occ_elpa(e_h,e_h%eval_elpa)
         call elsi_compute_dm_elpa_cmplx(e_h,e_h%evec_cmplx_elpa,dm,ham)
         call elsi_get_energy(e_h,energy,ELPA_SOLVER)
      else ! ELPA is done
         if(allocated(e_h%ovlp_cmplx_copy)) then
            ! Retrieve overlap matrix that has been destroyed by Cholesky
            ovlp = e_h%ovlp_cmplx_copy
            call elsi_deallocate(e_h,e_h%ovlp_cmplx_copy,"ovlp_cmplx_copy")
         endif

         if(.not. e_h%coeff%is_initialized) then
            call m_allocate(e_h%coeff,e_h%n_states_omm,e_h%n_basis,"pzdbc")
         endif

         ! Initialize coefficient matrix with ELPA eigenvectors if possible
         if(e_h%omm_n_elpa > 0 .and. e_h%n_elsi_calls == e_h%omm_n_elpa+1) then
            ! libOMM coefficient matrix is the transpose of ELPA eigenvectors
            call pztranc(e_h%n_basis,e_h%n_basis,(1.0_r8,0.0_r8),&
                    e_h%evec_cmplx_elpa,1,1,e_h%sc_desc,(0.0_r8,0.0_r8),dm,1,1,&
                    e_h%sc_desc)

            e_h%coeff%zval(1:e_h%coeff%iaux2(1),1:e_h%coeff%iaux2(2)) = &
               dm(1:e_h%coeff%iaux2(1),1:e_h%coeff%iaux2(2))

            ! ELPA matrices are no longer needed
            if(allocated(e_h%evec_cmplx_elpa)) then
               call elsi_deallocate(e_h,e_h%evec_cmplx_elpa,"evec_cmplx_elpa")
            endif
            if(allocated(e_h%eval_elpa)) then
               call elsi_deallocate(e_h,e_h%eval_elpa,"eval_elpa")
            endif
            if(allocated(e_h%eval_all)) then
               call elsi_deallocate(e_h,e_h%eval_all,"eval_all")
            endif
            if(allocated(e_h%occ_num)) then
               call elsi_deallocate(e_h,e_h%occ_num,"occ_num")
            endif
            if(allocated(e_h%k_weight)) then
               call elsi_deallocate(e_h,e_h%k_weight,"k_weight")
            endif
         endif

         call elsi_solve_evp_omm_cmplx(e_h,ham,ovlp,dm)
         call elsi_get_energy(e_h,energy,OMM_SOLVER)
      endif
   case(PEXSI_SOLVER)
      call elsi_init_pexsi(e_h)
      call elsi_blacs_to_pexsi_hs_cmplx(e_h,ham,ovlp)

      if(.not. allocated(e_h%dm_cmplx_pexsi)) then
         call elsi_allocate(e_h,e_h%dm_cmplx_pexsi,e_h%nnz_l_sp,&
                 "dm_cmplx_pexsi",caller)
      endif
      e_h%dm_cmplx_pexsi = (0.0_r8,0.0_r8)

      call elsi_solve_evp_pexsi_cmplx(e_h,e_h%ham_cmplx_pexsi,&
              e_h%ovlp_cmplx_pexsi,e_h%dm_cmplx_pexsi)
      call elsi_pexsi_to_blacs_dm_cmplx(e_h,dm)
      call elsi_get_energy(e_h,energy,PEXSI_SOLVER)

      e_h%mu_ready = .true.
   case(CHESS_SOLVER)
      call elsi_stop(" CHESS not yet implemented.",e_h,caller)
   case(SIPS_SOLVER)
      call elsi_stop(" SIPS not yet implemented.",e_h,caller)
   case(DMP_SOLVER)
      call elsi_stop(" DMP not yet implemented.",e_h,caller)
   case default
      call elsi_stop(" Unsupported solver.",e_h,caller)
   end select

   e_h%edm_ready_cmplx = .true.

end subroutine

!>
!! This routine computes the density matrix. Note the intent(inout) - it is
!! because everything has the potential to be reused in the next call.
!!
subroutine elsi_dm_real_sparse(e_h,ham,ovlp,dm,energy)

   implicit none

   type(elsi_handle), intent(inout) :: e_h                !< Handle
   real(kind=r8),     intent(inout) :: ham(e_h%nnz_l_sp)  !< Hamiltonian
   real(kind=r8),     intent(inout) :: ovlp(e_h%nnz_l_sp) !< Overlap
   real(kind=r8),     intent(inout) :: dm(e_h%nnz_l_sp)   !< Density matrix
   real(kind=r8),     intent(inout) :: energy             !< Energy

   character*40, parameter :: caller = "elsi_dm_real_sparse"

   call elsi_check_handle(e_h,caller)

   ! Update counter
   e_h%n_elsi_calls = e_h%n_elsi_calls+1

   ! Safety check
   call elsi_check(e_h,caller)

   call elsi_print_settings(e_h)

   select case(e_h%solver)
   case(ELPA_SOLVER)
      ! Set up BLACS if not done by user
      if(.not. e_h%blacs_ready) then
         call elsi_init_blacs(e_h)
      endif

      call elsi_sips_to_blacs_hs_real(e_h,ham,ovlp)

      if(.not. allocated(e_h%eval_elpa)) then
         call elsi_allocate(e_h,e_h%eval_elpa,e_h%n_basis,"eval_elpa",caller)
      endif
      if(.not. allocated(e_h%evec_real_elpa)) then
         call elsi_allocate(e_h,e_h%evec_real_elpa,e_h%n_lrow,e_h%n_lcol,&
                 "evec_real_elpa",caller)
      endif
      if(.not. allocated(e_h%dm_real_elpa)) then
         call elsi_allocate(e_h,e_h%dm_real_elpa,e_h%n_lrow,e_h%n_lcol,&
                 "dm_real_elpa",caller)
      endif

      call elsi_solve_evp_elpa_real(e_h,e_h%ham_real_elpa,e_h%ovlp_real_elpa,&
              e_h%eval_elpa,e_h%evec_real_elpa)
      call elsi_compute_occ_elpa(e_h,e_h%eval_elpa)
      call elsi_compute_dm_elpa_real(e_h,e_h%evec_real_elpa,e_h%dm_real_elpa,&
              e_h%ham_real_elpa)
      call elsi_blacs_to_sips_dm_real(e_h,dm)
      call elsi_get_energy(e_h,energy,ELPA_SOLVER)

      e_h%mu_ready = .true.
   case(OMM_SOLVER)
      ! Set up BLACS if not done by user
      if(.not. e_h%blacs_ready) then
         call elsi_init_blacs(e_h)
      endif

      call elsi_sips_to_blacs_hs_real(e_h,ham,ovlp)

      if(e_h%n_elsi_calls <= e_h%omm_n_elpa) then
         if(e_h%n_elsi_calls == 1 .and. e_h%omm_flavor == 0) then
            ! Overlap will be destroyed by Cholesky
            call elsi_allocate(e_h,e_h%ovlp_real_copy,e_h%n_lrow,e_h%n_lcol,&
                    "ovlp_real_copy",caller)
            e_h%ovlp_real_copy = e_h%ovlp_real_elpa
         endif

         ! Compute libOMM initial guess by ELPA
         if(.not. allocated(e_h%eval_elpa)) then
            call elsi_allocate(e_h,e_h%eval_elpa,e_h%n_basis,"eval_elpa",caller)
         endif
         if(.not. allocated(e_h%evec_real_elpa)) then
            call elsi_allocate(e_h,e_h%evec_real_elpa,e_h%n_lrow,e_h%n_lcol,&
                    "evec_real_elpa",caller)
         endif
         if(.not. allocated(e_h%dm_real_elpa)) then
            call elsi_allocate(e_h,e_h%dm_real_elpa,e_h%n_lrow,e_h%n_lcol,&
                    "dm_real_elpa",caller)
         endif

         call elsi_solve_evp_elpa_real(e_h,e_h%ham_real_elpa,&
                 e_h%ovlp_real_elpa,e_h%eval_elpa,e_h%evec_real_elpa)
         call elsi_compute_occ_elpa(e_h,e_h%eval_elpa)
         call elsi_compute_dm_elpa_real(e_h,e_h%evec_real_elpa,&
                 e_h%dm_real_elpa,e_h%ham_real_elpa)
         call elsi_blacs_to_sips_dm_real(e_h,dm)
         call elsi_get_energy(e_h,energy,ELPA_SOLVER)
      else ! ELPA is done
         if(allocated(e_h%ovlp_real_copy)) then
            ! Retrieve overlap matrix that has been destroyed by Cholesky
            e_h%ovlp_real_elpa = e_h%ovlp_real_copy
            call elsi_deallocate(e_h,e_h%ovlp_real_copy,"ovlp_real_copy")
         endif

         if(.not. e_h%coeff%is_initialized) then
            call m_allocate(e_h%coeff,e_h%n_states_omm,e_h%n_basis,"pddbc")
         endif
         if(.not. allocated(e_h%dm_real_elpa)) then
            call elsi_allocate(e_h,e_h%dm_real_elpa,e_h%n_lrow,e_h%n_lcol,&
                    "dm_real_elpa",caller)
         endif

         ! Initialize coefficient matrix with ELPA eigenvectors if possible
         if(e_h%omm_n_elpa > 0 .and. e_h%n_elsi_calls == e_h%omm_n_elpa+1) then
            ! libOMM coefficient matrix is the transpose of ELPA eigenvectors
            call pdtran(e_h%n_basis,e_h%n_basis,1.0_r8,e_h%evec_real_elpa,1,1,&
                    e_h%sc_desc,0.0_r8,e_h%dm_real_elpa,1,1,e_h%sc_desc)

            e_h%coeff%dval(1:e_h%coeff%iaux2(1),1:e_h%coeff%iaux2(2)) = &
               e_h%dm_real_elpa(1:e_h%coeff%iaux2(1),1:e_h%coeff%iaux2(2))

            ! ELPA matrices are no longer needed
            if(allocated(e_h%evec_real_elpa)) then
               call elsi_deallocate(e_h,e_h%evec_real_elpa,"evec_real_elpa")
            endif
            if(allocated(e_h%eval_elpa)) then
               call elsi_deallocate(e_h,e_h%eval_elpa,"eval_elpa")
            endif
            if(allocated(e_h%occ_num)) then
               call elsi_deallocate(e_h,e_h%occ_num,"occ_num")
            endif
         endif

         call elsi_solve_evp_omm_real(e_h,e_h%ham_real_elpa,e_h%ovlp_real_elpa,&
                 e_h%dm_real_elpa)
         call elsi_blacs_to_sips_dm_real(e_h,dm)
         call elsi_get_energy(e_h,energy,OMM_SOLVER)
      endif
   case(PEXSI_SOLVER)
      call elsi_init_pexsi(e_h)
      call elsi_solve_evp_pexsi_real(e_h,ham,ovlp,dm)
      call elsi_get_energy(e_h,energy,PEXSI_SOLVER)

      e_h%mu_ready = .true.
   case(CHESS_SOLVER) ! TODO
      call elsi_stop(" CHESS not yet implemented.",e_h,caller)
   case(SIPS_SOLVER)
      call elsi_stop(" SIPS not yet implemented.",e_h,caller)
   case(DMP_SOLVER)
      ! Set up BLACS if not done by user
      if(.not. e_h%blacs_ready) then
         call elsi_init_blacs(e_h)
      endif

      call elsi_sips_to_blacs_hs_real(e_h,ham,ovlp)

      if(.not. allocated(e_h%dm_real_elpa)) then
         call elsi_allocate(e_h,e_h%dm_real_elpa,e_h%n_lrow,e_h%n_lcol,&
                 "dm_real_elpa",caller)
      endif

      ! Save Hamiltonian and overlap
      if(e_h%n_elsi_calls==1) then
         call elsi_allocate(e_h,e_h%ham_real_copy,e_h%n_lrow,e_h%n_lcol,&
                 "ham_real_copy",caller)
         call elsi_allocate(e_h,e_h%ovlp_real_copy,e_h%n_lrow,e_h%n_lcol,&
                 "ovlp_real_copy",caller)
         e_h%ham_real_copy  = e_h%ham_real_elpa
         e_h%ovlp_real_copy = e_h%ovlp_real_elpa
      endif

      call elsi_solve_evp_dmp_real(e_h,e_h%ham_real_elpa,e_h%ovlp_real_elpa,&
              e_h%dm_real_elpa)
      call elsi_blacs_to_sips_dm_real(e_h,dm)
      call elsi_get_energy(e_h,energy,DMP_SOLVER)
   case default
      call elsi_stop(" Unsupported solver.",e_h,caller)
   end select

   e_h%edm_ready_real = .true.

end subroutine

!>
!! This routine computes the density matrix. Note the intent(inout) - it is
!! because everything has the potential to be reused in the next call.
!!
subroutine elsi_dm_complex_sparse(e_h,ham,ovlp,dm,energy)

   implicit none

   type(elsi_handle), intent(inout) :: e_h                !< Handle
   complex(kind=r8),  intent(inout) :: ham(e_h%nnz_l_sp)  !< Hamiltonian
   complex(kind=r8),  intent(inout) :: ovlp(e_h%nnz_l_sp) !< Overlap
   complex(kind=r8),  intent(inout) :: dm(e_h%nnz_l_sp)   !< Density matrix
   real(kind=r8),     intent(inout) :: energy             !< Energy

   character*40, parameter :: caller = "elsi_dm_complex_sparse"

   call elsi_check_handle(e_h,caller)

   ! Update counter
   e_h%n_elsi_calls = e_h%n_elsi_calls+1

   ! Safety check
   call elsi_check(e_h,caller)

   call elsi_print_settings(e_h)

   select case(e_h%solver)
   case(ELPA_SOLVER)
      ! Set up BLACS if not done by user
      if(.not. e_h%blacs_ready) then
         call elsi_init_blacs(e_h)
      endif

      call elsi_sips_to_blacs_hs_cmplx(e_h,ham,ovlp)

      if(.not. allocated(e_h%eval_elpa)) then
         call elsi_allocate(e_h,e_h%eval_elpa,e_h%n_basis,"eval_elpa",caller)
      endif
      if(.not. allocated(e_h%evec_cmplx_elpa)) then
         call elsi_allocate(e_h,e_h%evec_cmplx_elpa,e_h%n_lrow,e_h%n_lcol,&
                 "evec_cmplx_elpa",caller)
      endif
      if(.not. allocated(e_h%dm_cmplx_elpa)) then
         call elsi_allocate(e_h,e_h%dm_cmplx_elpa,e_h%n_lrow,e_h%n_lcol,&
                 "dm_cmplx_elpa",caller)
      endif

      call elsi_solve_evp_elpa_cmplx(e_h,e_h%ham_cmplx_elpa,&
              e_h%ovlp_cmplx_elpa,e_h%eval_elpa,e_h%evec_cmplx_elpa)
      call elsi_compute_occ_elpa(e_h,e_h%eval_elpa)
      call elsi_compute_dm_elpa_cmplx(e_h,e_h%evec_cmplx_elpa,&
              e_h%dm_cmplx_elpa,e_h%ham_cmplx_elpa)
      call elsi_blacs_to_sips_dm_cmplx(e_h,dm)
      call elsi_get_energy(e_h,energy,ELPA_SOLVER)

      e_h%mu_ready = .true.
   case(OMM_SOLVER)
      ! Set up BLACS if not done by user
      if(.not. e_h%blacs_ready) then
         call elsi_init_blacs(e_h)
      endif

      call elsi_sips_to_blacs_hs_cmplx(e_h,ham,ovlp)

      if(e_h%n_elsi_calls <= e_h%omm_n_elpa) then
         if(e_h%n_elsi_calls == 1 .and. e_h%omm_flavor == 0) then
            ! Overlap will be destroyed by Cholesky
            call elsi_allocate(e_h,e_h%ovlp_cmplx_copy,e_h%n_lrow,e_h%n_lcol,&
                    "ovlp_cmplx_copy",caller)
            e_h%ovlp_cmplx_copy = e_h%ovlp_cmplx_elpa
         endif

         if(.not. allocated(e_h%eval_elpa)) then
            call elsi_allocate(e_h,e_h%eval_elpa,e_h%n_basis,"eval_elpa",caller)
         endif
         if(.not. allocated(e_h%evec_cmplx_elpa)) then
            call elsi_allocate(e_h,e_h%evec_cmplx_elpa,e_h%n_lrow,e_h%n_lcol,&
                    "evec_cmplx_elpa",caller)
         endif
         if(.not. allocated(e_h%dm_cmplx_elpa)) then
            call elsi_allocate(e_h,e_h%dm_cmplx_elpa,e_h%n_lrow,e_h%n_lcol,&
                    "dm_cmplx_elpa",caller)
         endif

         call elsi_solve_evp_elpa_cmplx(e_h,e_h%ham_cmplx_elpa,&
                 e_h%ovlp_cmplx_elpa,e_h%eval_elpa,e_h%evec_cmplx_elpa)
         call elsi_compute_occ_elpa(e_h,e_h%eval_elpa)
         call elsi_compute_dm_elpa_cmplx(e_h,e_h%evec_cmplx_elpa,&
                 e_h%dm_cmplx_elpa,e_h%ham_cmplx_elpa)
         call elsi_blacs_to_sips_dm_cmplx(e_h,dm)
         call elsi_get_energy(e_h,energy,ELPA_SOLVER)
      else ! ELPA is done
         if(allocated(e_h%ovlp_cmplx_copy)) then
            ! Retrieve overlap matrix that has been destroyed by Cholesky
            e_h%ovlp_cmplx_elpa = e_h%ovlp_cmplx_copy
            call elsi_deallocate(e_h,e_h%ovlp_cmplx_copy,"ovlp_cmplx_copy")
         endif

         if(.not. e_h%coeff%is_initialized) then
            call m_allocate(e_h%coeff,e_h%n_states_omm,e_h%n_basis,"pzdbc")
         endif
         if(.not. allocated(e_h%dm_cmplx_elpa)) then
            call elsi_allocate(e_h,e_h%dm_cmplx_elpa,e_h%n_lrow,e_h%n_lcol,&
                    "dm_cmplx_elpa",caller)
         endif

         ! Initialize coefficient matrix with ELPA eigenvectors if possible
         if(e_h%omm_n_elpa > 0 .and. e_h%n_elsi_calls == e_h%omm_n_elpa+1) then
            ! libOMM coefficient matrix is the transpose of ELPA eigenvectors
            call pztranc(e_h%n_basis,e_h%n_basis,(1.0_r8,0.0_r8),&
                    e_h%evec_cmplx_elpa,1,1,e_h%sc_desc,(0.0_r8,0.0_r8),&
                    e_h%dm_cmplx_elpa,1,1,e_h%sc_desc)

            e_h%coeff%zval(1:e_h%coeff%iaux2(1),1:e_h%coeff%iaux2(2)) = &
               e_h%dm_cmplx_elpa(1:e_h%coeff%iaux2(1),1:e_h%coeff%iaux2(2))

            ! ELPA matrices are no longer needed
            if(allocated(e_h%evec_cmplx_elpa)) then
               call elsi_deallocate(e_h,e_h%evec_cmplx_elpa,"evec_cmplx_elpa")
            endif
            if(allocated(e_h%eval_elpa)) then
               call elsi_deallocate(e_h,e_h%eval_elpa,"eval_elpa")
            endif
            if(allocated(e_h%occ_num)) then
               call elsi_deallocate(e_h,e_h%occ_num,"occ_num")
            endif
         endif

         call elsi_solve_evp_omm_cmplx(e_h,e_h%ham_cmplx_elpa,&
                 e_h%ovlp_cmplx_elpa,e_h%dm_cmplx_elpa)
         call elsi_blacs_to_sips_dm_cmplx(e_h,dm)
         call elsi_get_energy(e_h,energy,OMM_SOLVER)
      endif
   case(PEXSI_SOLVER)
      call elsi_init_pexsi(e_h)
      call elsi_solve_evp_pexsi_cmplx(e_h,ham,ovlp,dm)
      call elsi_get_energy(e_h,energy,PEXSI_SOLVER)

      e_h%mu_ready = .true.
   case(CHESS_SOLVER)
      call elsi_stop(" CHESS not yet implemented.",e_h,caller)
   case(SIPS_SOLVER)
      call elsi_stop(" SIPS not yet implemented.",e_h,caller)
   case(DMP_SOLVER)
      call elsi_stop(" DMP not yet implemented.",e_h,caller)
   case default
      call elsi_stop(" Unsupported solver.",e_h,caller)
   end select

   e_h%edm_ready_cmplx = .true.

end subroutine

!>
!! This routine initializes BLACS, in case that the user selects a sparse format
!! and BLACS is still used internally.
!!
subroutine elsi_init_blacs(e_h)

   implicit none

   type(elsi_handle), intent(inout) :: e_h !< Handle

   integer(kind=i4) :: nprow
   integer(kind=i4) :: npcol
   integer(kind=i4) :: blacs_ctxt
   integer(kind=i4) :: block_size

   character*40, parameter :: caller = "elsi_init_blacs"

   if(e_h%parallel_mode == MULTI_PROC .and. .not. e_h%blacs_ready) then
      ! Set square-like process grid
      do nprow = nint(sqrt(real(e_h%n_procs))),2,-1
         if(mod(e_h%n_procs,nprow) == 0) exit
      enddo

      npcol = e_h%n_procs/nprow

      if(max(nprow,npcol) > e_h%n_basis) then
         call elsi_stop(" Matrix size is too small for this number of MPI"//&
                 "tasks.",e_h,caller)
      endif

      ! Initialize BLACS
      blacs_ctxt = e_h%mpi_comm

      call BLACS_Gridinit(blacs_ctxt,'r',nprow,npcol)

      ! Find block size
      block_size = 1

      ! Maximum allowed value: 256
      do while (2*block_size*max(nprow,npcol) <= e_h%n_basis .and. &
                block_size < 256)
         block_size = 2*block_size
      enddo

      ! ELPA works better with a small block_size
      if(e_h%solver == ELPA_SOLVER) then
         block_size = min(32,block_size)
      endif

      call elsi_set_blacs(e_h,blacs_ctxt,block_size)
   endif

end subroutine

!>
!! This routine prints ELSI settings.
!!
subroutine elsi_print_settings(e_h)

   implicit none

   type(elsi_handle), intent(in) :: e_h !< Handle

   character*200 :: info_str

   character*40, parameter :: caller = "elsi_print_settings"

   select case(e_h%solver)
   case(CHESS_SOLVER)
      call elsi_say(e_h,"  CheSS settings:")

      write(info_str,"('  | Error function decay length ',E10.2)") e_h%erf_decay
      call elsi_say(e_h,info_str)

      write(info_str,"('  | Lower bound of decay length ',E10.2)")&
         e_h%erf_decay_min
      call elsi_say(e_h,info_str)

      write(info_str,"('  | Upper bound of decay length ',E10.2)")&
         e_h%erf_decay_max
      call elsi_say(e_h,info_str)

      write(info_str,"('  | Lower bound of H eigenvalue ',E10.2)")&
         e_h%ev_ham_min
      call elsi_say(e_h,info_str)

      write(info_str,"('  | Upper bound of H eigenvalue ',E10.2)")&
         e_h%ev_ham_max
      call elsi_say(e_h,info_str)

      write(info_str,"('  | Lower bound of S eigenvalue ',E10.2)")&
         e_h%ev_ovlp_min
      call elsi_say(e_h,info_str)

      write(info_str,"('  | Upper bound of S eigenvalue ',E10.2)") &
         e_h%ev_ovlp_max
      call elsi_say(e_h,info_str)
   case(ELPA_SOLVER)
      if(e_h%parallel_mode == MULTI_PROC) then
         call elsi_say(e_h,"  ELPA settings:")

         write(info_str,"('  | ELPA solver ',I10)") e_h%elpa_solver
         call elsi_say(e_h,info_str)
      endif
   case(OMM_SOLVER)
      call elsi_say(e_h,"  libOMM settings:")

      write(info_str,"('  | Number of ELPA steps       ',I10)") e_h%omm_n_elpa
      call elsi_say(e_h,info_str)

      write(info_str,"('  | OMM minimization flavor    ',I10)") e_h%omm_flavor
      call elsi_say(e_h,info_str)

      write(info_str,"('  | OMM minimization tolerance ',E10.2)") e_h%min_tol
      call elsi_say(e_h,info_str)
   case(PEXSI_SOLVER)
      call elsi_say(e_h,"  PEXSI settings:")

      write(info_str,"('  | Electron temperature       ',E10.2)")&
         e_h%pexsi_options%temperature
      call elsi_say(e_h,info_str)

      write(info_str,"('  | Spectral gap               ',F10.3)")&
         e_h%pexsi_options%gap
      call elsi_say(e_h,info_str)

      write(info_str,"('  | Spectral width             ',F10.3)")&
         e_h%pexsi_options%deltaE
      call elsi_say(e_h,info_str)

      write(info_str,"('  | Number of poles            ',I10)")&
         e_h%pexsi_options%numPole
      call elsi_say(e_h,info_str)

      write(info_str,"('  | Number of mu points        ',I10)")&
         e_h%pexsi_options%nPoints
      call elsi_say(e_h,info_str)

      write(info_str,"('  | Lower bound of mu          ',E10.2)")&
         e_h%pexsi_options%muMin0
      call elsi_say(e_h,info_str)

      write(info_str,"('  | Upper bound of mu          ',E10.2)")&
         e_h%pexsi_options%muMax0
      call elsi_say(e_h,info_str)

      write(info_str,"('  | Inertia counting tolerance ',E10.2)")&
         e_h%pexsi_options%muInertiaTolerance
      call elsi_say(e_h,info_str)

      write(info_str,"('  | MPI tasks for symbolic     ',I10)")&
         e_h%pexsi_options%npSymbFact
      call elsi_say(e_h,info_str)
   case(SIPS_SOLVER)
      call elsi_say(e_h,"  SIPs settings:")

      write(info_str,"('  | Slicing method            ',I10)")&
         e_h%slicing_method
      call elsi_say(e_h,info_str)

      write(info_str,"('  | Lower bound of eigenvalue ',E10.2)") e_h%ev_min
      call elsi_say(e_h,info_str)

      write(info_str,"('  | Upper bound of eigenvalue ',E10.2)") e_h%ev_max
      call elsi_say(e_h,info_str)

      write(info_str,"('  | Inertia counting          ',I10)")&
         e_h%inertia_option
      call elsi_say(e_h,info_str)

      write(info_str,"('  | Left bound option         ',I10)") e_h%unbound
      call elsi_say(e_h,info_str)

      write(info_str,"('  | Slice buffer              ',E10.2)")&
         e_h%slice_buffer
      call elsi_say(e_h,info_str)
   case(DMP_SOLVER)
      call elsi_say(e_h,"  DMP settings:")

      write(info_str,"('  | Purification method              ',I10)")&
         e_h%dmp_method
      call elsi_say(e_h,info_str)

      write(info_str,"('  | Max number of purification steps ',I10)")&
         e_h%max_dmp_iter
      call elsi_say(e_h,info_str)

      write(info_str,"('  | Convergence tolerance            ',E10.2)")&
         e_h%dmp_tol
      call elsi_say(e_h,info_str)
   end select

end subroutine

end module ELSI_SOLVER
