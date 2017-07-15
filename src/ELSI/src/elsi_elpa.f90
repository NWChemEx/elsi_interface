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
!! This module provides interfaces to ELPA.
!!
module ELSI_ELPA

   use ISO_C_BINDING
   use ELSI_CONSTANTS, only: REAL_VALUES,COMPLEX_VALUES,UNSET
   use ELSI_DIMENSIONS, only: elsi_handle
   use ELSI_MU, only: elsi_compute_mu_and_occ
   use ELSI_PRECISION, only: r8,i4
   use ELSI_TIMERS
   use ELSI_UTILS
   use CHECK_SINGULARITY, only: elpa_check_singularity_real_double,&
                                elpa_check_singularity_complex_double
   use ELPA1
   use ELPA2

   implicit none
   private

   public :: elsi_get_elpa_comms
   public :: elsi_compute_occ_elpa
   public :: elsi_compute_dm_elpa
   public :: elsi_compute_edm_elpa
   public :: elsi_solve_evp_elpa
   public :: elsi_solve_evp_elpa_sp

contains

!>
!! This routine gets the row and column communicators for ELPA.
!!
subroutine elsi_get_elpa_comms(elsi_h)

   implicit none

   type(elsi_handle), intent(inout) :: elsi_h !< Handle

   integer(kind=i4) :: success

   character*40, parameter :: caller = "elsi_get_elpa_comms"

   success = elpa_get_communicators(elsi_h%mpi_comm,elsi_h%my_p_row,&
      elsi_h%my_p_col,elsi_h%mpi_comm_row,elsi_h%mpi_comm_col)

end subroutine

!>
!! This routine computes the chemical potential and occupation numbers.
!!
subroutine elsi_compute_occ_elpa(elsi_h)

   implicit none

   type(elsi_handle), intent(inout) :: elsi_h !< Handle

   real(kind=r8)              :: k_weights(1) ! Dummy weights of k-points
   real(kind=r8), allocatable :: eval_aux(:,:,:)
   real(kind=r8), allocatable :: occ_aux(:,:,:)

   character*40, parameter :: caller = "elsi_compute_occ_elpa"

   k_weights(1) = 1.0_r8

   if(.not. allocated(elsi_h%occ_elpa)) then
       call elsi_allocate(elsi_h,elsi_h%occ_elpa,elsi_h%n_states,"occ_elpa",caller)
   endif

   call elsi_allocate(elsi_h,eval_aux,elsi_h%n_states,1,1,"eval_aux",caller)
   call elsi_allocate(elsi_h,occ_aux,elsi_h%n_states,1,1,"occ_aux",caller)

   eval_aux(1:elsi_h%n_states,1,1) = elsi_h%eval(1:elsi_h%n_states)
   occ_aux = 0.0_r8

   call elsi_compute_mu_and_occ(elsi_h,elsi_h%n_electrons,elsi_h%n_states,&
           elsi_h%n_spins,elsi_h%n_kpts,k_weights,eval_aux,occ_aux,elsi_h%mu)

   elsi_h%occ_elpa(:) = occ_aux(:,1,1)

   call elsi_deallocate(elsi_h,eval_aux,"eval_aux")
   call elsi_deallocate(elsi_h,occ_aux,"occ_aux")

end subroutine

!>
!! This routine constructs the density matrix.
!!
subroutine elsi_compute_dm_elpa(elsi_h)

   implicit none

   type(elsi_handle), intent(inout) :: elsi_h !< Handle

   real(kind=r8),    allocatable :: tmp_real(:,:)
   complex(kind=r8), allocatable :: tmp_complex(:,:)
   real(kind=r8),    allocatable :: factor(:)
   integer(kind=i4)              :: i,i_col,i_row,max_state

   character*40, parameter :: caller = "elsi_compute_dm_elpa"

   call elsi_start_density_matrix_time(elsi_h)

   call elsi_allocate(elsi_h,factor,elsi_h%n_states,"factor",caller)
   factor = 0.0_r8

   max_state = 0

   do i = 1,elsi_h%n_states
      if(elsi_h%occ_elpa(i) > 0.0_r8) then
         factor(i) = sqrt(elsi_h%occ_elpa(i))
         max_state = i
      endif
   enddo

   select case(elsi_h%matrix_data_type)
   case(REAL_VALUES)
      call elsi_allocate(elsi_h,tmp_real,elsi_h%n_l_rows,&
              elsi_h%n_l_cols,"tmp_real",caller)
      tmp_real = elsi_h%evec_real

      do i = 1,elsi_h%n_states
         if(factor(i) > 0.0_r8) then
            if(elsi_h%local_col(i) > 0) then
               tmp_real(:,elsi_h%local_col(i)) = &
                  tmp_real(:,elsi_h%local_col(i))*factor(i)
            endif
         elseif(elsi_h%local_col(i) .ne. 0) then
            tmp_real(:,elsi_h%local_col(i)) = 0.0_r8
         endif
      enddo

      elsi_h%den_mat = 0.0_r8

      ! Compute density matrix
      call pdsyrk('U','N',elsi_h%n_basis,max_state,1.0_r8,tmp_real,1,1,&
              elsi_h%sc_desc,0.0_r8,elsi_h%den_mat,1,1,elsi_h%sc_desc)

   case(COMPLEX_VALUES)
      call elsi_allocate(elsi_h,tmp_complex,elsi_h%n_l_rows,&
              elsi_h%n_l_cols,"tmp_complex",caller)
      tmp_complex = elsi_h%evec_complex

      do i = 1,elsi_h%n_states
         if(factor(i) > 0.0_r8) then
            if(elsi_h%local_col(i) > 0) then
               tmp_complex(:,elsi_h%local_col(i)) = &
                  tmp_complex(:,elsi_h%local_col(i))*factor(i)
            endif
         elseif(elsi_h%local_col(i) .ne. 0) then
            tmp_complex(:,elsi_h%local_col(i)) = (0.0_r8,0.0_r8)
         endif
      enddo

      elsi_h%den_mat = 0.0_r8

      call elsi_allocate(elsi_h,tmp_real,elsi_h%n_l_rows,&
              elsi_h%n_l_cols,"tmp_real",caller)

      ! Compute density matrix
      call pdsyrk('U','N',elsi_h%n_basis,max_state,1.0_r8,real(tmp_complex),&
              1,1,elsi_h%sc_desc,0.0_r8,elsi_h%den_mat,1,1,elsi_h%sc_desc)
      call pdsyrk('U','N',elsi_h%n_basis,max_state,1.0_r8,aimag(tmp_complex),&
              1,1,elsi_h%sc_desc,0.0_r8,tmp_real,1,1,elsi_h%sc_desc)

      elsi_h%den_mat = elsi_h%den_mat+tmp_real
   end select

   call elsi_deallocate(elsi_h,factor,"factor")
   if(allocated(tmp_real))    call elsi_deallocate(elsi_h,tmp_real,"tmp_real")
   if(allocated(tmp_complex)) call elsi_deallocate(elsi_h,tmp_complex,"tmp_complex")

   ! Set full matrix from upper triangle
   call elsi_allocate(elsi_h,tmp_real,elsi_h%n_l_rows,&
           elsi_h%n_l_cols,"tmp_real",caller)

   call pdtran(elsi_h%n_basis,elsi_h%n_basis,1.0_r8,elsi_h%den_mat,1,1,&
           elsi_h%sc_desc,0.0_r8,tmp_real,1,1,elsi_h%sc_desc)

   do i_col = 1,elsi_h%n_basis-1
      if(elsi_h%local_col(i_col) == 0) cycle
      do i_row = i_col+1,elsi_h%n_basis
         if(elsi_h%local_row(i_row) > 0) then
            elsi_h%den_mat(elsi_h%local_row(i_row),elsi_h%local_col(i_col)) = &
               tmp_real(elsi_h%local_row(i_row),elsi_h%local_col(i_col))
         endif
      enddo
   enddo

   call elsi_deallocate(elsi_h,tmp_real,"tmp_real")

   call elsi_stop_density_matrix_time(elsi_h)

end subroutine

!>
!! This routine constructs the energy-weighted density matrix.
!!
subroutine elsi_compute_edm_elpa(elsi_h)

   implicit none

   type(elsi_handle), intent(inout) :: elsi_h !< Handle

   real(kind=r8),    allocatable :: tmp_real(:,:)
   complex(kind=r8), allocatable :: tmp_complex(:,:)
   real(kind=r8),    allocatable :: factor(:)
   integer(kind=i4)              :: i,i_col,i_row,max_state

   character*40, parameter :: caller = "elsi_compute_edm_elpa"

   call elsi_allocate(elsi_h,factor,elsi_h%n_states,"factor",caller)

   max_state = 0

   do i = 1,elsi_h%n_states
      factor(i) = -1.0_r8*elsi_h%occ_elpa(i)*elsi_h%eval(i)
      if(factor(i) > 0.0_r8) then
         factor(i) = sqrt(factor(i))
         max_state = i
      else
         factor(i) = 0.0_r8
      endif
   enddo

   select case(elsi_h%matrix_data_type)
   case(REAL_VALUES)
      call elsi_allocate(elsi_h,tmp_real,elsi_h%n_l_rows,&
              elsi_h%n_l_cols,"tmp_real",caller)
      tmp_real = elsi_h%evec_real

      do i = 1,elsi_h%n_states
         if(factor(i) > 0.0_r8) then
            if(elsi_h%local_col(i) > 0) then
               tmp_real(:,elsi_h%local_col(i)) = tmp_real(:,elsi_h%local_col(i))*factor(i)
            endif
         elseif(elsi_h%local_col(i) .ne. 0) then
            tmp_real(:,elsi_h%local_col(i)) = 0.0_r8
         endif
      enddo

      elsi_h%den_mat = 0.0_r8

      ! Compute density matrix
      call pdsyrk('U','N',elsi_h%n_basis,max_state,1.0_r8,tmp_real,1,1,&
              elsi_h%sc_desc,0.0_r8,elsi_h%den_mat,1,1,elsi_h%sc_desc)

   case(COMPLEX_VALUES)
      call elsi_allocate(elsi_h,tmp_complex,elsi_h%n_l_rows,&
              elsi_h%n_l_cols,"tmp_complex",caller)
      tmp_complex = elsi_h%evec_complex

      do i = 1,elsi_h%n_states
         if(factor(i) > 0.0_r8) then
            if(elsi_h%local_col(i) > 0) then
               tmp_complex(:,elsi_h%local_col(i)) = &
                  tmp_complex(:,elsi_h%local_col(i))*factor(i)
            endif
         elseif(elsi_h%local_col(i) .ne. 0) then
            tmp_complex(:,elsi_h%local_col(i)) = (0.0_r8,0.0_r8)
         endif
      enddo

      elsi_h%den_mat = 0.0_r8

      call elsi_allocate(elsi_h,tmp_real,elsi_h%n_l_rows,&
              elsi_h%n_l_cols,"tmp_real",caller)

      ! Compute density matrix
      call pdsyrk('U','N',elsi_h%n_basis,max_state,1.0_r8,real(tmp_complex),&
              1,1,elsi_h%sc_desc,0.0_r8,elsi_h%den_mat,1,1,elsi_h%sc_desc)
      call pdsyrk('U','N',elsi_h%n_basis,max_state,1.0_r8,aimag(tmp_complex),&
              1,1,elsi_h%sc_desc,0.0_r8,tmp_real,1,1,elsi_h%sc_desc)

      elsi_h%den_mat = elsi_h%den_mat+tmp_real
   end select

   elsi_h%den_mat = -1.0_r8*elsi_h%den_mat

   call elsi_deallocate(elsi_h,factor,"factor")
   if(allocated(tmp_real))    call elsi_deallocate(elsi_h,tmp_real,"tmp_real")
   if(allocated(tmp_complex)) call elsi_deallocate(elsi_h,tmp_complex,"tmp_complex")

   ! Set full matrix from upper triangle
   call elsi_allocate(elsi_h,tmp_real,elsi_h%n_l_rows,elsi_h%n_l_cols,"tmp_real",caller)

   call pdtran(elsi_h%n_basis,elsi_h%n_basis,1.0_r8,elsi_h%den_mat,1,1,&
           elsi_h%sc_desc,0.0_r8,tmp_real,1,1,elsi_h%sc_desc)

   do i_col = 1,elsi_h%n_basis-1
      if(elsi_h%local_col(i_col) == 0) cycle
      do i_row = i_col+1,elsi_h%n_basis
         if(elsi_h%local_row(i_row) > 0) then
            elsi_h%den_mat(elsi_h%local_row(i_row),elsi_h%local_col(i_col)) = &
               tmp_real(elsi_h%local_row(i_row),elsi_h%local_col(i_col))
         endif
      enddo
   enddo

   call elsi_deallocate(elsi_h,tmp_real,"tmp_real")

end subroutine

!> 
!! This routine transforms a generalized eigenproblem (Hv = eSv) to
!! the standard form (H'v' = ev').
!!
!! First perform a Cholesky decomposition: S = (U^T)U, so that Hv = e(U^T)Uv.
!!
!! Then the new standard eigenproblem is
!! H(U^-1)(Uv) = e(U^T)(Uv) => ((U^-1)^T)H(U^-1)(Uv) = e(Uv).
!!
!! On exit, (U^-1) is stored in S to be reused later.
!!
subroutine elsi_to_standard_evp(elsi_h)

   implicit none

   type(elsi_handle), intent(inout) :: elsi_h !< Handle

   integer(kind=i4)              :: i_row,i_col
   real(kind=r8),    allocatable :: tmp_real(:,:)
   complex(kind=r8), allocatable :: tmp_complex(:,:)
   logical                       :: success

   character*40, parameter :: caller = "elsi_to_standard_evp"

   select case(elsi_h%matrix_data_type)
   case(COMPLEX_VALUES)
      if(elsi_h%n_elsi_calls == 1) then
         if(.not. elsi_h%no_sing_check) then
            call elsi_check_singularity(elsi_h)
         endif

         if(elsi_h%n_nonsing == elsi_h%n_basis) then ! Not singular
            call elsi_start_cholesky_time(elsi_h)

            elsi_h%ovlp_is_sing = .false.

            ! Compute S = (U^T)U, U -> S
            success = elpa_cholesky_complex_double(elsi_h%n_basis,&
                         elsi_h%ovlp_complex,elsi_h%n_l_rows,elsi_h%n_b_rows,&
                         elsi_h%n_l_cols,elsi_h%mpi_comm_row,elsi_h%mpi_comm_col,&
                         .false.)
            if(.not. success) then
               call elsi_stop(" Cholesky decomposition failed.",elsi_h,caller)
            endif

            ! compute U^-1 -> S
            success = elpa_invert_trm_complex_double(elsi_h%n_basis,&
                         elsi_h%ovlp_complex,elsi_h%n_l_rows,elsi_h%n_b_rows,&
                         elsi_h%n_l_cols,elsi_h%mpi_comm_row,elsi_h%mpi_comm_col,&
                         .false.)
            if(.not. success) then
               call elsi_stop(" Matrix inversion failed.",elsi_h,caller)
            endif

            call elsi_stop_cholesky_time(elsi_h)
         endif
      endif ! n_elsi_calls == 1

      call elsi_start_transform_evp_time(elsi_h)

      call elsi_allocate(elsi_h,tmp_complex,elsi_h%n_l_rows,&
              elsi_h%n_l_cols,"tmp_complex",caller)

      if(elsi_h%ovlp_is_sing) then ! Use scaled eigenvectors
         ! tmp_complex = H_complex * S_complex
         call pzgemm('N','N',elsi_h%n_basis,elsi_h%n_nonsing,elsi_h%n_basis,&
                 (1.0_r8,0.0_r8),elsi_h%ham_complex,1,1,elsi_h%sc_desc,&
                 elsi_h%ovlp_complex,1,1,elsi_h%sc_desc,(0.0_r8,0.0_r8),&
                 tmp_complex,1,1,elsi_h%sc_desc)

         ! H_complex = (S_complex)^* * tmp_complex
         call pzgemm('C','N',elsi_h%n_nonsing,elsi_h%n_nonsing,elsi_h%n_basis,&
                 (1.0_r8,0.0_r8),elsi_h%ovlp_complex,1,1,elsi_h%sc_desc,&
                 tmp_complex,1,1,elsi_h%sc_desc,(0.0_r8,0.0_r8),&
                 elsi_h%ham_complex,1,1,elsi_h%sc_desc)

      else ! Use cholesky
         success = elpa_mult_ah_b_complex_double('U','L',elsi_h%n_basis,&
                      elsi_h%n_basis,elsi_h%ovlp_complex,elsi_h%n_l_rows,&
                      elsi_h%n_l_cols,elsi_h%ham_complex,elsi_h%n_l_rows,&
                      elsi_h%n_l_cols,elsi_h%n_b_rows,elsi_h%mpi_comm_row,&
                      elsi_h%mpi_comm_col,tmp_complex,elsi_h%n_l_rows,&
                      elsi_h%n_l_cols)

         call pztranc(elsi_h%n_basis,elsi_h%n_basis,(1.0_r8,0.0_r8),tmp_complex,&
                 1,1,elsi_h%sc_desc,(0.0_r8,0.0_r8),elsi_h%ham_complex,1,1,&
                 elsi_h%sc_desc)

         tmp_complex = elsi_h%ham_complex

         success = elpa_mult_ah_b_complex_double('U','U',elsi_h%n_basis,&
                      elsi_h%n_basis,elsi_h%ovlp_complex,elsi_h%n_l_rows,&
                      elsi_h%n_l_cols,tmp_complex,elsi_h%n_l_rows,elsi_h%n_l_cols,&
                      elsi_h%n_b_rows,elsi_h%mpi_comm_row,elsi_h%mpi_comm_col,&
                      elsi_h%ham_complex,elsi_h%n_l_rows,elsi_h%n_l_cols)

         call pztranc(elsi_h%n_basis,elsi_h%n_basis,(1.0_r8,0.0_r8),&
                 elsi_h%ham_complex,1,1,elsi_h%sc_desc,(0.0_r8,0.0_r8),&
                 tmp_complex,1,1,elsi_h%sc_desc)

         ! Set the lower part from the upper
         do i_col = 1,elsi_h%n_basis-1
            if(elsi_h%local_col(i_col) == 0) cycle
            do i_row = i_col+1,elsi_h%n_basis
               if(elsi_h%local_row(i_row) > 0) then
                  elsi_h%ham_complex(elsi_h%local_row(i_row),elsi_h%local_col(i_col)) = &
                     tmp_complex(elsi_h%local_row(i_row),elsi_h%local_col(i_col))
               endif
            enddo
         enddo

         do i_col=1,elsi_h%n_basis
            if(elsi_h%local_col(i_col) == 0 .or. elsi_h%local_row(i_col) == 0) cycle
            elsi_h%ham_complex(elsi_h%local_row(i_col),elsi_h%local_col(i_col)) = &
               dble(elsi_h%ham_complex(elsi_h%local_row(i_col),elsi_h%local_col(i_col)))
         enddo
      endif

      call elsi_stop_transform_evp_time(elsi_h)

   case(REAL_VALUES)
      if(elsi_h%n_elsi_calls == 1) then
         if(.not. elsi_h%no_sing_check) then
            call elsi_check_singularity(elsi_h)
         endif

         if(elsi_h%n_nonsing == elsi_h%n_basis) then ! Not singular
            call elsi_start_cholesky_time(elsi_h)

            elsi_h%ovlp_is_sing = .false.

            ! Compute S = (U^T)U, U -> S
            success = elpa_cholesky_real_double(elsi_h%n_basis,elsi_h%ovlp_real,&
                         elsi_h%n_l_rows,elsi_h%n_b_rows,elsi_h%n_l_cols,&
                         elsi_h%mpi_comm_row,elsi_h%mpi_comm_col,.false.)
            if(.not. success) then
               call elsi_stop(" Cholesky decomposition failed.",elsi_h,caller)
            endif

            ! compute U^-1 -> S
            success = elpa_invert_trm_real_double(elsi_h%n_basis,elsi_h%ovlp_real,&
                         elsi_h%n_l_rows,elsi_h%n_b_rows,elsi_h%n_l_cols,&
                         elsi_h%mpi_comm_row,elsi_h%mpi_comm_col,.false.)
            if(.not. success) then
               call elsi_stop(" Matrix inversion failed.",elsi_h,caller)
            endif

            call elsi_stop_cholesky_time(elsi_h)
         endif
      endif ! n_elsi_calls == 1

      call elsi_start_transform_evp_time(elsi_h)

      call elsi_allocate(elsi_h,tmp_real,elsi_h%n_l_rows,elsi_h%n_l_cols,"tmp_real",caller)

      if(elsi_h%ovlp_is_sing) then ! Use scaled eigenvectors
         ! tmp_real = H_real * S_real
         call pdgemm('N','N',elsi_h%n_basis,elsi_h%n_nonsing,elsi_h%n_basis,&
                 1.0_r8,elsi_h%ham_real,1,1,elsi_h%sc_desc,elsi_h%ovlp_real,1,1,&
                 elsi_h%sc_desc,0.0_r8,tmp_real,1,1,elsi_h%sc_desc)

         ! H_real = (S_real)^T * tmp_real
         call pdgemm('T','N',elsi_h%n_nonsing,elsi_h%n_nonsing,elsi_h%n_basis,&
                 1.0_r8,elsi_h%ovlp_real,1,1,elsi_h%sc_desc,tmp_real,1,1,elsi_h%sc_desc,&
                 0.0_r8,elsi_h%ham_real,1,1,elsi_h%sc_desc)

      else ! Use Cholesky
         success = elpa_mult_at_b_real_double('U','L',elsi_h%n_basis,elsi_h%n_basis,&
                      elsi_h%ovlp_real,elsi_h%n_l_rows,elsi_h%n_l_cols,elsi_h%ham_real,&
                      elsi_h%n_l_rows,elsi_h%n_l_cols,elsi_h%n_b_rows,elsi_h%mpi_comm_row,&
                      elsi_h%mpi_comm_col,tmp_real,elsi_h%n_l_rows,elsi_h%n_l_cols)

         call pdtran(elsi_h%n_basis,elsi_h%n_basis,1.0_r8,tmp_real,1,1,elsi_h%sc_desc,&
                 0.0_r8,elsi_h%ham_real,1,1,elsi_h%sc_desc)

         tmp_real = elsi_h%ham_real

         success = elpa_mult_at_b_real_double('U','U',elsi_h%n_basis,elsi_h%n_basis,&
                      elsi_h%ovlp_real,elsi_h%n_l_rows,elsi_h%n_l_cols,tmp_real,&
                      elsi_h%n_l_rows,elsi_h%n_l_cols,elsi_h%n_b_rows,elsi_h%mpi_comm_row,&
                      elsi_h%mpi_comm_col,elsi_h%ham_real,elsi_h%n_l_rows,elsi_h%n_l_cols)

         call pdtran(elsi_h%n_basis,elsi_h%n_basis,1.0_r8,elsi_h%ham_real,1,1,&
                     elsi_h%sc_desc,0.0_r8,tmp_real,1,1,elsi_h%sc_desc)

         ! Set the lower part from the upper
         do i_col = 1,elsi_h%n_basis-1
            if(elsi_h%local_col(i_col) == 0) cycle
            do i_row = i_col+1,elsi_h%n_basis
               if(elsi_h%local_row(i_row) > 0) then
                  elsi_h%ham_real(elsi_h%local_row(i_row),elsi_h%local_col(i_col)) = &
                     tmp_real(elsi_h%local_row(i_row),elsi_h%local_col(i_col))
               endif
            enddo
         enddo
      endif

      call elsi_stop_transform_evp_time(elsi_h)

   end select

   if(allocated(tmp_real))    call elsi_deallocate(elsi_h,tmp_real,"tmp_real")
   if(allocated(tmp_complex)) call elsi_deallocate(elsi_h,tmp_complex,"tmp_complex")

end subroutine

!> 
!! This routine checks the singularity of overlap matrix by computing all
!! its eigenvalues.
!!
!! On exit, S is not modified if not singular, while overwritten by scaled
!! eigenvectors if singular, which is used to transform the generalized
!! eigenproblem to the standard form without using Cholesky.
!!
subroutine elsi_check_singularity(elsi_h)

   implicit none

   type(elsi_handle), intent(inout) :: elsi_h !< Handle

   real(kind=r8)                 :: ev_sqrt
   real(kind=r8),    allocatable :: ev_overlap(:)
   real(kind=r8),    allocatable :: tmp_real(:,:)
   complex(kind=r8), allocatable :: tmp_complex(:,:)
   integer(kind=i4)              :: i
   logical                       :: success
   character*200                 :: info_str

   character*40, parameter :: caller = "elsi_check_singularity"

   call elsi_start_singularity_check_time(elsi_h)

   select case(elsi_h%matrix_data_type)
   case(COMPLEX_VALUES)
      call elsi_allocate(elsi_h,tmp_complex,elsi_h%n_l_rows,&
              elsi_h%n_l_cols,"tmp_complex",caller)

      ! Use tmp_complex to store overlap matrix, otherwise it will
      ! be destroyed by eigenvalue calculation
      ! The nonsingular eigenvalues must be the first ones, so find
      ! eigenvalues of negative overlap matrix
      tmp_complex = -elsi_h%ovlp_complex

      call elsi_allocate(elsi_h,ev_overlap,elsi_h%n_basis,"ev_overlap",caller)

      ! Use customized ELPA 2-stage solver to check overlap singularity
      ! Eigenvectors computed only for singular overlap matrix
      success = elpa_check_singularity_complex_double(elsi_h%n_basis,elsi_h%n_basis,&
                   tmp_complex,elsi_h%n_l_rows,ev_overlap,elsi_h%evec_complex,&
                   elsi_h%n_l_rows,elsi_h%n_b_rows,elsi_h%n_l_cols,elsi_h%mpi_comm_row,&
                   elsi_h%mpi_comm_col,elsi_h%mpi_comm,elsi_h%sing_tol,&
                   elsi_h%n_nonsing)
      if(.not. success) then
         call elsi_stop(" ELPA failed when solving eigenvalue problem."//&
                 " Exiting...",elsi_h,caller)
      endif

      ! Stop if n_states is larger than n_nonsing
      if(elsi_h%n_nonsing < elsi_h%n_states) then ! Too singular to continue
         call elsi_stop(" Overlap matrix is singular. The number of"//&
                 " basis functions after removing singularity is smaller"//&
                 " than the number of states. Exiting...",elsi_h,caller)
      elseif(elsi_h%n_nonsing < elsi_h%n_basis) then ! Singular
         elsi_h%ovlp_is_sing = .true.

         if(elsi_h%stop_sing) then
            call elsi_stop(" Overlap matrix is singular. Running with a"//&
                    " a near-singular basis set may lead to completely"//&
                    " wrong numerical results. Exiting...",elsi_h,caller)
         endif

         call elsi_statement_print("  Overlap matrix is singular. A large"//&
                 " basis sest may be in use. Note that running with a"//&
                 " near-singular basis set may lead to completely wrong"//&
                 " numerical results.",elsi_h)

         write(info_str,"(A,I13)") "  | Number of basis functions reduced to: ",&
            elsi_h%n_nonsing
         call elsi_statement_print(info_str,elsi_h)

         call elsi_statement_print("  Using scaled eigenvectors of overlap"//&
                 " matrix for transformation",elsi_h)

         ! Overlap matrix is overwritten with scaled eigenvectors
         do i = 1,elsi_h%n_nonsing
            ev_sqrt = sqrt(ev_overlap(i))
            if(elsi_h%local_col(i) == 0) cycle
            elsi_h%ovlp_complex(:,elsi_h%local_col(i)) = &
               elsi_h%evec_complex(:,elsi_h%local_col(i))/ev_sqrt
         enddo

      else ! Nonsingular
         elsi_h%ovlp_is_sing = .false.
         call elsi_statement_print("  Overlap matrix is nonsingular",elsi_h)
      endif ! Singular overlap?

   case(REAL_VALUES)
      call elsi_allocate(elsi_h,tmp_real,elsi_h%n_l_rows,elsi_h%n_l_cols,"tmp_real",caller)

      ! Use tmp_real to store overlap matrix, otherwise it will be
      ! destroyed by eigenvalue calculation
      ! The nonsingular eigenvalues must be the first ones, so find
      ! eigenvalues of negative overlap matrix
      tmp_real = -elsi_h%ovlp_real

      call elsi_allocate(elsi_h,ev_overlap,elsi_h%n_basis,"ev_overlap",caller)

      ! Use customized ELPA 2-stage solver to check overlap singularity
      ! Eigenvectors computed only for singular overlap matrix
      success = elpa_check_singularity_real_double(elsi_h%n_basis,elsi_h%n_basis,&
                   tmp_real,elsi_h%n_l_rows,ev_overlap,elsi_h%evec_real,elsi_h%n_l_rows,&
                   elsi_h%n_b_rows,elsi_h%n_l_cols,elsi_h%mpi_comm_row,elsi_h%mpi_comm_col,&
                   elsi_h%mpi_comm,elsi_h%sing_tol,elsi_h%n_nonsing)
      if(.not. success) then
         call elsi_stop(" ELPA failed when solving eigenvalue problem."//&
                 " Exiting...",elsi_h,caller)
      endif

      ! Stop if n_states is larger than n_nonsing
      if(elsi_h%n_nonsing < elsi_h%n_states) then ! Too singular to continue
         call elsi_stop(" Overlap matrix is singular. The number of basis"//&
                 " functions after removing singularity is smaller than the"//&
                 " number of states. Exiting...",elsi_h,caller)
      elseif(elsi_h%n_nonsing < elsi_h%n_basis) then ! Singular
         elsi_h%ovlp_is_sing = .true.

         if(elsi_h%stop_sing) then
            call elsi_stop(" Overlap matrix is singular. Running with a"//&
                    " near-singular basis set may lead to completely"//&
                    " wrong numerical results. Exiting...",elsi_h,caller)
         endif

         call elsi_statement_print("  Overlap matrix is singular. Note that"//&
                 " running with a near-singular basis set may lead to"//&
                 " completely wrong numerical results.",elsi_h)

         write(info_str,"(A,I13)") "  | Number of basis functions reduced to: ",&
            elsi_h%n_nonsing
         call elsi_statement_print(info_str,elsi_h)

         call elsi_statement_print("  Using scaled eigenvectors of"//&
                 " overlap matrix for transformation",elsi_h)

         ! Overlap matrix is overwritten with scaled eigenvectors
         do i = 1,elsi_h%n_nonsing
            ev_sqrt = sqrt(ev_overlap(i))
            if(elsi_h%local_col(i) == 0) cycle
            elsi_h%ovlp_real(:,elsi_h%local_col(i)) = &
               elsi_h%evec_real(:,elsi_h%local_col(i))/ev_sqrt
         enddo

      else ! Nonsingular
         elsi_h%ovlp_is_sing = .false.
         call elsi_statement_print("  Overlap matrix is nonsingular",elsi_h)
      endif ! Singular overlap?

   end select ! select matrix_data_type

   if(allocated(ev_overlap))  call elsi_deallocate(elsi_h,ev_overlap,"ev_overlap")
   if(allocated(tmp_real))    call elsi_deallocate(elsi_h,tmp_real,"tmp_real")
   if(allocated(tmp_complex)) call elsi_deallocate(elsi_h,tmp_complex,"tmp_complex")

   call elsi_stop_singularity_check_time(elsi_h)

end subroutine

!> 
!! This routine back-transforms eigenvectors in the standard form (H'v' = ev')
!! to the original generalized form (Hv = eSv), by computing v = (U^-1)v'.
!!
subroutine elsi_to_original_ev(elsi_h)

   implicit none

   type(elsi_handle), intent(inout) :: elsi_h !< Handle

   logical                       :: success
   real(kind=r8),    allocatable :: tmp_real(:,:)
   complex(kind=r8), allocatable :: tmp_complex(:,:)

   character*40, parameter :: caller = "elsi_to_original_ev"

   call elsi_start_back_transform_ev_time(elsi_h)

   select case(elsi_h%matrix_data_type)
   case(COMPLEX_VALUES)
      call elsi_allocate(elsi_h,tmp_complex,elsi_h%n_l_rows,&
              elsi_h%n_l_cols,"tmp_complex",caller)
      tmp_complex = elsi_h%evec_complex

      if(elsi_h%ovlp_is_sing) then
         ! Transform matrix is stored in S_complex after elsi_to_standard_evp
         call pzgemm('N','N',elsi_h%n_basis,elsi_h%n_states,elsi_h%n_nonsing,&
                 (1.0_r8,0.0_r8),elsi_h%ovlp_complex,1,1,elsi_h%sc_desc,tmp_complex,&
                 1,1,elsi_h%sc_desc,(0.0_r8,0.0_r8),elsi_h%evec_complex,1,1,elsi_h%sc_desc)
      else ! Nonsingular, use Cholesky
         ! (U^-1) is stored in S_complex after elsi_to_standard_evp
         ! C_complex = S_complex * C_complex = S_complex * tmp_complex
         call pztranc(elsi_h%n_basis,elsi_h%n_basis,(1.0_r8,0.0_r8),elsi_h%ovlp_complex,&
                 1,1,elsi_h%sc_desc,(0.0_r8,0.0_r8),elsi_h%ham_complex,1,1,elsi_h%sc_desc)

         success = elpa_mult_ah_b_complex_double('L','N',elsi_h%n_basis,elsi_h%n_states,&
                      elsi_h%ham_complex,elsi_h%n_l_rows,elsi_h%n_l_cols,tmp_complex,&
                      elsi_h%n_l_rows,elsi_h%n_l_cols,elsi_h%n_b_rows,elsi_h%mpi_comm_row,&
                      elsi_h%mpi_comm_col,elsi_h%evec_complex,elsi_h%n_l_rows,elsi_h%n_l_cols)
      endif

   case(REAL_VALUES)
      call elsi_allocate(elsi_h,tmp_real,elsi_h%n_l_rows,elsi_h%n_l_cols,"tmp_real",caller)
      tmp_real = elsi_h%evec_real

      if(elsi_h%ovlp_is_sing) then
         ! Transform matrix is stored in S_real after elsi_to_standard_evp
         call pdgemm('N','N',elsi_h%n_basis,elsi_h%n_states,elsi_h%n_nonsing,1.0_r8,&
                 elsi_h%ovlp_real,1,1,elsi_h%sc_desc,tmp_real,1,1,elsi_h%sc_desc,0.0_r8,&
                 elsi_h%evec_real,1,1,elsi_h%sc_desc)
      else ! Nonsingular, use Cholesky
         ! (U^-1) is stored in S_real after elsi_to_standard_evp
         ! C_real = S_real * C_real = S_real * tmp_real
         call pdtran(elsi_h%n_basis,elsi_h%n_basis,1.0_r8,elsi_h%ovlp_real,1,1,&
                 elsi_h%sc_desc,0.0_r8,elsi_h%ham_real,1,1,elsi_h%sc_desc)

         success = elpa_mult_at_b_real_double('L','N',elsi_h%n_basis,elsi_h%n_states,&
                      elsi_h%ham_real,elsi_h%n_l_rows,elsi_h%n_l_cols,tmp_real,elsi_h%n_l_rows,&
                      elsi_h%n_l_cols,elsi_h%n_b_rows,elsi_h%mpi_comm_row,elsi_h%mpi_comm_col,&
                      elsi_h%evec_real,elsi_h%n_l_rows,elsi_h%n_l_cols)
      endif

   end select

   if(allocated(tmp_real))    call elsi_deallocate(elsi_h,tmp_real,"tmp_real")
   if(allocated(tmp_complex)) call elsi_deallocate(elsi_h,tmp_complex,"tmp_complex")

   call elsi_stop_back_transform_ev_time(elsi_h)

end subroutine

!>
!! This routine interfaces to ELPA.
!!
subroutine elsi_solve_evp_elpa(elsi_h)

   implicit none
   include "mpif.h"

   type(elsi_handle), intent(inout) :: elsi_h !< Handle

   integer(kind=i4) :: mpierr
   logical          :: success

   character*40, parameter :: caller = "elsi_solve_evp_elpa"

   elpa_print_times = elsi_h%elpa_output

   ! Choose 1-stage or 2-stage solver
   if(elsi_h%elpa_solver == UNSET) then
      if(elsi_h%n_basis < 250) then
         elsi_h%elpa_solver = 1
      else
         elsi_h%elpa_solver = 2
      endif
   endif

   ! Transform to standard form
   if(.not. elsi_h%ovlp_is_unit) then
      call elsi_to_standard_evp(elsi_h)
   endif

   call elsi_start_standard_evp_time(elsi_h)

   ! Solve evp, return eigenvalues and eigenvectors
   if(elsi_h%elpa_solver == 2) then ! 2-stage solver
      call elsi_statement_print("  Starting ELPA 2-stage eigensolver",elsi_h)
      select case(elsi_h%matrix_data_type)
      case(COMPLEX_VALUES)
         success = elpa_solve_evp_complex_2stage_double(elsi_h%n_nonsing,elsi_h%n_states,&
                      elsi_h%ham_complex,elsi_h%n_l_rows,elsi_h%eval,elsi_h%evec_complex,&
                      elsi_h%n_l_rows,elsi_h%n_b_rows,elsi_h%n_l_cols,elsi_h%mpi_comm_row,&
                      elsi_h%mpi_comm_col,elsi_h%mpi_comm)
      case(REAL_VALUES)
         success = elpa_solve_evp_real_2stage_double(elsi_h%n_nonsing,elsi_h%n_states,&
                      elsi_h%ham_real,elsi_h%n_l_rows,elsi_h%eval,elsi_h%evec_real,&
                      elsi_h%n_l_rows,elsi_h%n_b_rows,elsi_h%n_l_cols,elsi_h%mpi_comm_row,&
                      elsi_h%mpi_comm_col,elsi_h%mpi_comm)
      end select
   else ! 1-stage solver
      call elsi_statement_print("  Starting ELPA 1-stage eigensolver",elsi_h)
      select case(elsi_h%matrix_data_type)
      case(COMPLEX_VALUES)
         success = elpa_solve_evp_complex_1stage_double(elsi_h%n_nonsing,elsi_h%n_states,&
                      elsi_h%ham_complex,elsi_h%n_l_rows,elsi_h%eval,elsi_h%evec_complex,&
                      elsi_h%n_l_rows,elsi_h%n_b_rows,elsi_h%n_l_cols,elsi_h%mpi_comm_row,&
                      elsi_h%mpi_comm_col,elsi_h%mpi_comm)
      case(REAL_VALUES)
         success = elpa_solve_evp_real_1stage_double(elsi_h%n_nonsing,elsi_h%n_states,&
                      elsi_h%ham_real,elsi_h%n_l_rows,elsi_h%eval,elsi_h%evec_real,&
                      elsi_h%n_l_rows,elsi_h%n_b_rows,elsi_h%n_l_cols,elsi_h%mpi_comm_row,&
                      elsi_h%mpi_comm_col,elsi_h%mpi_comm)
      end select
   endif

   call elsi_stop_standard_evp_time(elsi_h)

   if(.not. success) then
      call elsi_stop(" ELPA failed when solving eigenvalue problem."//&
              " Exiting...",elsi_h,caller)
   endif

   ! Back-transform eigenvectors
   if(.not. elsi_h%ovlp_is_unit) then
      call elsi_to_original_ev(elsi_h)
   endif

   call MPI_Barrier(elsi_h%mpi_comm,mpierr)

end subroutine

!> 
!! This routine transforms a generalized eigenproblem (Hv = eSv) to
!! the standard form (H'v' = ev').
!!
!! First perform a Cholesky decomposition: S = (U^T)U, so that Hv = e(U^T)Uv.
!!
!! Then the new standard eigenproblem is
!! H(U^-1)(Uv) = e(U^T)(Uv) => ((U^-1)^T)H(U^-1)(Uv) = e(Uv).
!!
!! On exit, (U^-1) is stored in S to be reused later.
!!
subroutine elsi_to_standard_evp_sp(elsi_h)

   implicit none
   include 'mpif.h'

   type(elsi_handle), intent(inout) :: elsi_h !< Handle

   real(kind=r8),    allocatable :: tmp_real(:,:)
   complex(kind=r8), allocatable :: tmp_complex(:,:)
   logical                       :: success
   integer(kind=i4)              :: ierr
   integer(kind=i4)              :: nwork
   integer(kind=i4)              :: n
   integer(kind=i4), parameter   :: nblk=128

   character*40, parameter :: caller = "elsi_to_standard_evp_sp"

   select case(elsi_h%matrix_data_type)
   case(COMPLEX_VALUES)
      if(elsi_h%n_elsi_calls == 1) then
         if(.not. elsi_h%no_sing_check) then
            call elsi_check_singularity_sp(elsi_h)
         endif
      endif ! n_elsi_calls == 1

      if(elsi_h%n_nonsing == elsi_h%n_basis) then ! Not singular
         call elsi_start_cholesky_time(elsi_h)

         elsi_h%ovlp_is_sing = .false.

         ! Compute S = (U^H)U, U -> S
         call zpotrf('U',elsi_h%n_basis,elsi_h%ovlp_complex,elsi_h%n_basis,ierr)

         ! compute U^-1 -> S
         call ztrtri('U','N',elsi_h%n_basis,elsi_h%ovlp_complex,elsi_h%n_basis,ierr)

         call elsi_stop_cholesky_time(elsi_h)
      endif

      call elsi_start_transform_evp_time(elsi_h)

      call elsi_allocate(elsi_h,tmp_complex,elsi_h%n_l_rows,&
              elsi_h%n_l_cols,"tmp_complex",caller)

      if(elsi_h%ovlp_is_sing) then ! Use scaled eigenvectors
         ! tmp_complex = H_complex * S_complex
         call zgemm('N','N',elsi_h%n_basis,elsi_h%n_nonsing,elsi_h%n_basis,&
                 (1.0_r8,0.0_r8),elsi_h%ham_complex(1,1),elsi_h%n_basis,&
                 elsi_h%ovlp_complex(1,1),elsi_h%n_basis,(0.0_r8,0.0_r8),&
                 tmp_complex(1,1),elsi_h%n_basis)

         ! H_complex = (S_complex)^* * tmp_complex
         call zgemm('C','N',elsi_h%n_nonsing,elsi_h%n_nonsing,elsi_h%n_basis,&
                 (1.0_r8,0.0_r8),elsi_h%ovlp_complex(1,1),elsi_h%n_basis,&
                 tmp_complex(1,1),elsi_h%n_basis,(0.0_r8,0.0_r8),&
                 elsi_h%ham_complex(1,1),elsi_h%n_basis)

      else ! Use cholesky
         ! tmp_complex = H_complex * S_complex
         do n = 1,elsi_h%n_basis,nblk
            nwork = nblk

            if(n+nwork-1 > elsi_h%n_basis) then
               nwork = elsi_h%n_basis-n+1
            endif

            call zgemm('N','N',n+nwork-1,nwork,n+nwork-1,(1.0_r8,0.0_r8),&
                    elsi_h%ham_complex(1,1),elsi_h%n_basis,elsi_h%ovlp_complex(1,n),&
                    elsi_h%n_basis,(0.0_r8,0.0_r8),tmp_complex(1,n),elsi_h%n_basis)
         enddo

         ! H_complex = (tmp_complex)^* * S_complex
         do n = 1,elsi_h%n_basis,nblk
            nwork = nblk

            if(n+nwork-1 > elsi_h%n_basis) then
               nwork = elsi_h%n_basis-n+1
            endif

            call zgemm('C','N',nwork,elsi_h%n_basis-n+1,n+nwork-1,(1.0_r8,0.0_r8),&
                    elsi_h%ovlp_complex(1,n),elsi_h%n_basis,tmp_complex(1,n),&
                    elsi_h%n_basis,(0.0_r8,0.0_r8),elsi_h%ham_complex(n,n),&
                    elsi_h%n_basis)
         enddo
      endif

      call elsi_stop_transform_evp_time(elsi_h)

   case(REAL_VALUES)
      if(elsi_h%n_elsi_calls == 1) then
         if(.not. elsi_h%no_sing_check) then
            call elsi_check_singularity_sp(elsi_h)
         endif
      endif ! n_elsi_calls == 1

      if(elsi_h%n_nonsing == elsi_h%n_basis) then ! Not singular
         call elsi_start_cholesky_time(elsi_h)

         elsi_h%ovlp_is_sing = .false.

         ! Compute S = (U^T)U, U -> S
         call dpotrf('U',elsi_h%n_basis,elsi_h%ovlp_real,elsi_h%n_basis,ierr)

         ! compute U^-1 -> S
         call dtrtri('U','N',elsi_h%n_basis,elsi_h%ovlp_real,elsi_h%n_basis,ierr)

         call elsi_stop_cholesky_time(elsi_h)
      endif

      call elsi_start_transform_evp_time(elsi_h)

      call elsi_allocate(elsi_h,tmp_real,elsi_h%n_l_rows,&
              elsi_h%n_l_cols,"tmp_real",caller)

      if(elsi_h%ovlp_is_sing) then ! Use scaled eigenvectors
         ! tmp_real = H_real * S_real
         call dgemm('N','N',elsi_h%n_basis,elsi_h%n_nonsing,elsi_h%n_basis,&
                 1.0_r8,elsi_h%ham_real(1,1),elsi_h%n_basis,elsi_h%ovlp_real(1,1),&
                 elsi_h%n_basis,0.0_r8,tmp_real(1,1),elsi_h%n_basis)

         ! H_real = (S_real)^T * tmp_real
         call dgemm('T','N',elsi_h%n_nonsing,elsi_h%n_nonsing,elsi_h%n_basis,&
                 1.0_r8,elsi_h%ovlp_real(1,1),elsi_h%n_basis,tmp_real(1,1),&
                 elsi_h%n_basis,0.0_r8,elsi_h%ham_real(1,1),elsi_h%n_basis)

      else ! Use Cholesky
        ! tmp_real = H_real * S_real
        do n = 1,elsi_h%n_basis,nblk
           nwork = nblk

           if(n+nwork-1 > elsi_h%n_basis) then
              nwork = elsi_h%n_basis-n+1
           endif

           call dgemm('N','N',n+nwork-1,nwork,n+nwork-1,1.0_r8,elsi_h%ham_real(1,1),&
                   elsi_h%n_basis,elsi_h%ovlp_real(1,n),elsi_h%n_basis,0.0_r8,&
                   tmp_real(1,n),elsi_h%n_basis) 
        enddo

        ! H_real = (tmp_real)*T * S_real
        do n = 1,elsi_h%n_basis,nblk
           nwork = nblk

           if(n+nwork-1 > elsi_h%n_basis) then
              nwork = elsi_h%n_basis-n+1
           endif

           call dgemm('T','N',nwork,elsi_h%n_basis-n+1,n+nwork-1,1.0_r8,&
                   elsi_h%ovlp_real(1,n),elsi_h%n_basis,tmp_real(1,n),&
                   elsi_h%n_basis,0.0_r8,elsi_h%ham_real(n,n),elsi_h%n_basis)
        enddo
     endif

     call elsi_stop_transform_evp_time(elsi_h)

   end select

   if(allocated(tmp_real))    call elsi_deallocate(elsi_h,tmp_real,"tmp_real")
   if(allocated(tmp_complex)) call elsi_deallocate(elsi_h,tmp_complex,"tmp_complex")

end subroutine

!> 
!! This routine back-transforms eigenvectors in the standard form (H'v' = ev')
!! to the original generalized form (Hv = eSv), by computing v = (U^-1)v'.
!!
subroutine elsi_to_original_ev_sp(elsi_h)

   implicit none

   type(elsi_handle), intent(inout) :: elsi_h !< Handle

   real(kind=r8),    allocatable :: tmp_real(:,:)
   complex(kind=r8), allocatable :: tmp_complex(:,:)

   character*40, parameter :: caller = "elsi_to_original_ev_sp"

   call elsi_start_back_transform_ev_time(elsi_h)

   select case(elsi_h%matrix_data_type)
   case(COMPLEX_VALUES)
      if(elsi_h%ovlp_is_sing) then
         call elsi_allocate(elsi_h,tmp_complex,elsi_h%n_l_rows,&
                 elsi_h%n_l_cols,"tmp_complex",caller)
         tmp_complex = elsi_h%evec_complex

         ! Transform matrix is stored in S_complex after elsi_to_standard_evp
         call zgemm('N','N',elsi_h%n_basis,elsi_h%n_states,elsi_h%n_nonsing,&
                 (1.0_r8,0.0_r8),elsi_h%ovlp_complex(1,1),elsi_h%n_basis,&
                 tmp_complex(1,1),elsi_h%n_basis,(0.0_r8,0.0_r8),&
                 elsi_h%evec_complex(1,1),elsi_h%n_basis)

         call elsi_deallocate(elsi_h,tmp_complex,"tmp_complex")
      else ! Nonsingular, use Cholesky
         ! (U^-1) is stored in S_complex after elsi_to_standard_evp
         call ztrmm('L','U','N','N',elsi_h%n_basis,elsi_h%n_states,(1.0_r8,0.0_r8),&
                 elsi_h%ovlp_complex(1,1),elsi_h%n_basis,elsi_h%evec_complex(1,1),&
                 elsi_h%n_basis)
      endif

   case(REAL_VALUES)
      if(elsi_h%ovlp_is_sing) then
         call elsi_allocate(elsi_h,tmp_real,elsi_h%n_l_rows,&
                 elsi_h%n_l_cols,"tmp_real",caller)
         tmp_real = elsi_h%evec_real

         ! Transform matrix is stored in S_real after elsi_to_standard_evp
         call dgemm('N','N',elsi_h%n_basis,elsi_h%n_states,elsi_h%n_nonsing,1.0_r8,&
                 elsi_h%ovlp_real(1,1),elsi_h%n_basis,tmp_real(1,1),elsi_h%n_basis,&
                 0.0_r8,elsi_h%evec_real(1,1),elsi_h%n_basis)

         call elsi_deallocate(elsi_h,tmp_real,"tmp_real")
      else ! Nonsingular, use Cholesky
         ! (U^-1) is stored in S_real after elsi_to_standard_evp
         call dtrmm('L','U','N','N',elsi_h%n_basis,elsi_h%n_states,1.0_r8,&
                 elsi_h%ovlp_real(1,1),elsi_h%n_basis,elsi_h%evec_real(1,1),&
                 elsi_h%n_basis)
      endif

   end select

   call elsi_stop_back_transform_ev_time(elsi_h)

end subroutine

!>
!! This routine interfaces to ELPA.
!!
subroutine elsi_solve_evp_elpa_sp(elsi_h)

   implicit none
   include "mpif.h"

   type(elsi_handle), intent(inout) :: elsi_h !< Handle

   real(kind=r8),    allocatable :: d(:),e(:)
   real(kind=r8),    allocatable :: tau_real(:)
   complex(kind=r8), allocatable :: tau_complex(:)
   real(kind=r8),    allocatable :: tmp_real(:,:)
   complex(kind=r8), allocatable :: tmp_complex(:,:)
   logical                       :: success
   integer(kind=i4)              :: ierr

   character*40, parameter :: caller = "elsi_solve_evp_elpa_sp"

   call elsi_allocate(elsi_h,d,elsi_h%n_basis,"d",caller)
   call elsi_allocate(elsi_h,e,elsi_h%n_basis,"e",caller)

   ! Transform to standard form
   if(.not. elsi_h%ovlp_is_unit) then
      call elsi_to_standard_evp_sp(elsi_h)
   endif

   ! Solve evp, return eigenvalues and eigenvectors
   call elsi_statement_print("  Starting ELPA eigensolver",elsi_h)

   call elsi_start_standard_evp_time(elsi_h)

   select case(elsi_h%matrix_data_type)
   case(COMPLEX_VALUES)
      call elsi_allocate(elsi_h,tau_complex,elsi_h%n_basis,"tau_complex",caller)
      call elsi_allocate(elsi_h,tmp_real,elsi_h%n_basis,elsi_h%n_basis,"tmp_real",caller)
      call elsi_allocate(elsi_h,tmp_complex,elsi_h%n_basis,elsi_h%n_basis,"tmp_complex",caller)

      call zhetrd('U',elsi_h%n_basis,elsi_h%ham_complex,elsi_h%n_basis,d,e,tau_complex,&
              tmp_complex,elsi_h%n_basis*elsi_h%n_basis,ierr)

      success = elpa_solve_tridi_double(elsi_h%n_basis,elsi_h%n_states,d,e,tmp_real,&
                   elsi_h%n_basis,64,elsi_h%n_basis,mpi_comm_self,mpi_comm_self,.false.)

      elsi_h%eval(1:elsi_h%n_states) = d(1:elsi_h%n_states)
      elsi_h%evec_complex(1:elsi_h%n_basis,1:elsi_h%n_states) = &
         tmp_real(1:elsi_h%n_basis,1:elsi_h%n_states)

      call zunmtr('L','U','N',elsi_h%n_basis,elsi_h%n_states,elsi_h%ham_complex,&
              elsi_h%n_basis,tau_complex,elsi_h%evec_complex,elsi_h%n_basis,&
              tmp_complex,elsi_h%n_basis*elsi_h%n_basis,ierr)

      call elsi_deallocate(elsi_h,tau_complex,"tau_complex")
      call elsi_deallocate(elsi_h,tmp_real,"tmp_real")
      call elsi_deallocate(elsi_h,tmp_complex,"tmp_complex")

   case(REAL_VALUES)
      call elsi_allocate(elsi_h,tau_real,elsi_h%n_basis,"tau_real",caller)
      call elsi_allocate(elsi_h,tmp_real,elsi_h%n_basis,elsi_h%n_basis,"tmp_real",caller)

      call dsytrd('U',elsi_h%n_basis,elsi_h%ham_real,elsi_h%n_basis,d,e,tau_real,tmp_real,&
              elsi_h%n_basis*elsi_h%n_basis,ierr)

      success = elpa_solve_tridi_double(elsi_h%n_basis,elsi_h%n_states,d,e,tmp_real,&
                   elsi_h%n_basis,64,elsi_h%n_basis,mpi_comm_self,mpi_comm_self,.false.)

      elsi_h%eval(1:elsi_h%n_states) = d(1:elsi_h%n_states)
      elsi_h%evec_real(1:elsi_h%n_basis,1:elsi_h%n_states) = &
         tmp_real(1:elsi_h%n_basis,1:elsi_h%n_states)

      call dormtr('L','U','N',elsi_h%n_basis,elsi_h%n_states,elsi_h%ham_real,&
              elsi_h%n_basis,tau_real,elsi_h%evec_real,elsi_h%n_basis,tmp_real,&
              elsi_h%n_basis*elsi_h%n_basis,ierr)

      call elsi_deallocate(elsi_h,tau_real,"tau_real")
      call elsi_deallocate(elsi_h,tmp_real,"tmp_real")

   end select

   call elsi_stop_standard_evp_time(elsi_h)

   call elsi_deallocate(elsi_h,d,"d")
   call elsi_deallocate(elsi_h,e,"e")

   if(.not. success) then
      call elsi_stop(" ELPA failed when solving eigenvalue problem."//&
              " Exiting...",elsi_h,caller)
   endif

   ! Back-transform eigenvectors
   if(.not. elsi_h%ovlp_is_unit) then
      call elsi_to_original_ev_sp(elsi_h)
   endif

end subroutine

!> 
!! This routine checks the singularity of overlap matrix by computing all
!! its eigenvalues.
!!
!! On exit, S is not modified if not singular, while overwritten by scaled
!! eigenvectors if singular, which is used to transform the generalized
!! eigenvalue problem to standard form without using Cholesky.
!!
subroutine elsi_check_singularity_sp(elsi_h)

   implicit none
   include "mpif.h"

   type(elsi_handle), intent(inout) :: elsi_h !< Handle

   real(kind=r8)                 :: ev_sqrt
   real(kind=r8),    allocatable :: ev_overlap(:)
   real(kind=r8),    allocatable :: tmp_real(:,:)
   complex(kind=r8), allocatable :: tmp_complex(:,:)
   integer(kind=i4)              :: i,i_col
   logical                       :: success
   character*200                 :: info_str

   character*40, parameter :: caller = "elsi_check_singularity_sp"

   call elsi_start_singularity_check_time(elsi_h)

   select case(elsi_h%matrix_data_type)
   case(COMPLEX_VALUES)
      call elsi_allocate(elsi_h,tmp_complex,elsi_h%n_l_rows,&
              elsi_h%n_l_cols,"tmp_complex",caller)

      ! Use tmp_complex to store overlap matrix, otherwise it will
      ! be destroyed by eigenvalue calculation
      ! The nonsingular eigenvalues must be the first ones, so find
      ! eigenvalues of negative overlap matrix
      tmp_complex = -elsi_h%ovlp_complex

      call elsi_allocate(elsi_h,ev_overlap,elsi_h%n_basis,"ev_overlap",caller)

      ! Use customized ELPA 2-stage solver to check overlap singularity
      ! Eigenvectors computed only for singular overlap matrix
      success = elpa_check_singularity_complex_double(elsi_h%n_basis,elsi_h%n_basis,&
                   tmp_complex,elsi_h%n_l_rows,ev_overlap,elsi_h%evec_complex,&
                   elsi_h%n_l_rows,elsi_h%n_b_rows,elsi_h%n_l_cols,mpi_comm_self,&
                   mpi_comm_self,mpi_comm_self,elsi_h%sing_tol,elsi_h%n_nonsing)
      if(.not. success) then
         call elsi_stop(" ELPA failed when solving eigenvalue problem."//&
                 " Exiting...",elsi_h,caller)
      endif

      ! Stop if n_states is larger than n_nonsing
      if(elsi_h%n_nonsing < elsi_h%n_states) then ! Too singular to continue
         call elsi_stop(" Overlap matrix is singular. The number of"//&
                 " basis functions after removing singularity is smaller"//&
                 " than the number of states. Exiting...",elsi_h,caller)
      elseif(elsi_h%n_nonsing < elsi_h%n_basis) then ! Singular
         elsi_h%ovlp_is_sing = .true.

         if(elsi_h%stop_sing) then
            call elsi_stop(" Overlap matrix is singular. Running with a"//&
                    " near-singular basis set may lead to completely"//&
                    " wrong numerical results. Exiting...",elsi_h,caller)
         endif

         call elsi_statement_print("  Overlap matrix is singular. Note"//&
                 " that running with a near-singular basis set may lead"//&
                 " to completely wrong numerical results.",elsi_h)

         write(info_str,"(A,I13)") "  | Number of basis functions reduced to: ",&
            elsi_h%n_nonsing
         call elsi_statement_print(info_str,elsi_h)

         call elsi_statement_print("  Using scaled eigenvectors of"//&
                 " overlap matrix for transformation",elsi_h)

         ! Overlap matrix is overwritten with scaled eigenvectors
         do i = 1,elsi_h%n_nonsing
            ev_sqrt = sqrt(ev_overlap(i))
            elsi_h%ovlp_complex(:,i) = elsi_h%evec_complex(:,i)/ev_sqrt
         enddo

      else ! Nonsingular
         elsi_h%ovlp_is_sing = .false.
         call elsi_statement_print("  Overlap matrix is nonsingular",elsi_h)
      endif ! Singular overlap?

   case(REAL_VALUES)
      call elsi_allocate(elsi_h,tmp_real,elsi_h%n_l_rows,&
              elsi_h%n_l_cols,"tmp_real",caller)

      ! Use tmp_real to store overlap matrix, otherwise it will be
      ! destroyed by eigenvalue calculation
      ! The nonsingular eigenvalues must be the first ones, so find
      ! eigenvalues of negative overlap matrix
      tmp_real = -elsi_h%ovlp_real

      call elsi_allocate(elsi_h,ev_overlap,elsi_h%n_basis,"ev_overlap",caller)

      ! Use customized ELPA 2-stage solver to check overlap singularity
      ! Eigenvectors computed only for singular overlap matrix
      success = elpa_check_singularity_real_double(elsi_h%n_basis,elsi_h%n_basis,&
                   tmp_real,elsi_h%n_l_rows,ev_overlap,elsi_h%evec_real,&
                   elsi_h%n_l_rows,elsi_h%n_b_rows,elsi_h%n_l_cols,mpi_comm_self,&
                   mpi_comm_self,mpi_comm_self,elsi_h%sing_tol,elsi_h%n_nonsing)
      if(.not. success) then
         call elsi_stop(" ELPA failed when solving eigenvalue problem."//&
                 " Exiting...",elsi_h,caller)
      endif

      ! Stop if n_states is larger than n_nonsing
      if(elsi_h%n_nonsing < elsi_h%n_states) then ! Too singular to continue
         call elsi_stop(" Overlap matrix is singular. The number of"//&
                 " basis functions after removing singularity is smaller"//&
                 " than the number of states. Exiting...",elsi_h,caller)
      elseif(elsi_h%n_nonsing < elsi_h%n_basis) then ! Singular
         elsi_h%ovlp_is_sing = .true.

         if(elsi_h%stop_sing) then
            call elsi_stop(" Overlap matrix is singular. Running with a"//&
                    " near-singular basis set may lead to completely wrong"//&
                    " numerical results. Exiting...",elsi_h,caller)
         endif

         call elsi_statement_print("  Overlap matrix is singular. Note"//&
                 " that running with a near-singular basis set may lead to"//&
                 " completely wrong numerical results.",elsi_h)

         write(info_str,"(A,I13)") "  | Number of basis functions reduced to: ",&
            elsi_h%n_nonsing
         call elsi_statement_print(info_str,elsi_h)

         call elsi_statement_print("  Using scaled eigenvectors of"//&
                 " overlap matrix for transformation",elsi_h)

         ! Overlap matrix is overwritten with scaled eigenvectors
         do i = 1,elsi_h%n_nonsing
            ev_sqrt = sqrt(ev_overlap(i))
            elsi_h%ovlp_real(:,i) = elsi_h%evec_real(:,i)/ev_sqrt
         enddo

      else ! Nonsingular
         elsi_h%ovlp_is_sing = .false.
         call elsi_statement_print("  Overlap matrix is nonsingular",elsi_h)
      endif ! Singular overlap?

   end select ! select matrix_data_type

   if(allocated(ev_overlap))  call elsi_deallocate(elsi_h,ev_overlap,"ev_overlap")
   if(allocated(tmp_real))    call elsi_deallocate(elsi_h,tmp_real,"tmp_real")
   if(allocated(tmp_complex)) call elsi_deallocate(elsi_h,tmp_complex,"tmp_complex")

   call elsi_stop_singularity_check_time(elsi_h)

end subroutine

end module ELSI_ELPA
