! Copyright (c) 2015-2021, the ELSI team.
! All rights reserved.
!
! This file is part of ELSI and is distributed under the BSD 3-clause license,
! which may be found in the LICENSE file in the ELSI root directory.

!>
!! Interface to LAPACK.
!!
module ELSI_LAPACK

   use ELSI_CONSTANT, only: FC_BASIC,FC_PLUS_V
   use ELSI_DATATYPE, only: elsi_param_t,elsi_basic_t
   use ELSI_ELPA, only: elsi_elpa_tridiag
   use ELSI_MALLOC, only: elsi_allocate,elsi_deallocate
   use ELSI_OUTPUT, only: elsi_say,elsi_get_time
   use ELSI_PRECISION, only: r8,i4
   use ELSI_SORT, only: elsi_heapsort,elsi_permute

   implicit none

   private

   public :: elsi_solve_lapack
   public :: elsi_do_fc_lapack
   public :: elsi_undo_fc_lapack

   !>
   !! For ChASE 
   !!
   public :: elsi_check_ovlp_sp
   public :: elsi_factor_ovlp_sp
   public :: elsi_reduce_evp_sp
   public :: elsi_back_ev_sp
   
   interface elsi_solve_lapack
      module procedure elsi_solve_lapack_real
      module procedure elsi_solve_lapack_cmplx
   end interface

   interface elsi_check_ovlp_sp
      module procedure elsi_check_ovlp_sp_real
      module procedure elsi_check_ovlp_sp_cmplx
   end interface

   interface elsi_factor_ovlp_sp
      module procedure elsi_factor_ovlp_sp_real
      module procedure elsi_factor_ovlp_sp_cmplx
   end interface

   interface elsi_reduce_evp_sp
      module procedure elsi_reduce_evp_sp_real
      module procedure elsi_reduce_evp_sp_cmplx
   end interface

   interface elsi_back_ev_sp
      module procedure elsi_back_ev_sp_real
      module procedure elsi_back_ev_sp_cmplx
   end interface

   interface elsi_do_fc_lapack
      module procedure elsi_do_fc_lapack_real
      module procedure elsi_do_fc_lapack_cmplx
   end interface

   interface elsi_undo_fc_lapack
      module procedure elsi_undo_fc_lapack_real
      module procedure elsi_undo_fc_lapack_cmplx
   end interface

contains

!>
!! Cholesky factorize the overlap matrix in place.
!!
subroutine elsi_factor_ovlp_sp_real(ph,bh,ovlp)

   implicit none

   type(elsi_param_t), intent(in) :: ph
   type(elsi_basic_t), intent(in) :: bh
   real(kind=r8), intent(inout) :: ovlp(ph%n_basis,ph%n_basis)

   real(kind=r8) :: t0
   real(kind=r8) :: t1
   integer(kind=i4) :: i
   integer(kind=i4) :: j
   integer(kind=i4) :: ierr
   character(len=200) :: msg

   character(len=*), parameter :: caller = "elsi_factor_ovlp_sp_real"

   call elsi_get_time(t0)

   ! Erase lower triangle
   do j = 1,ph%n_basis-1
      do i= j+1,ph%n_basis
         ovlp(i,j) = 0.0_r8
      end do
   end do

   ! S = U
   call dpotrf("U",ph%n_basis,ovlp,ph%n_basis,ierr)

   ! S = U^(-1)
   call dtrtri("U","N",ph%n_basis,ovlp,ph%n_basis,ierr)

   call elsi_get_time(t1)

   write(msg,"(A)") "Finished Cholesky decomposition"
   call elsi_say(bh,msg)
   write(msg,"(A,F10.3,A)") "| Time :",t1-t0," s"
   call elsi_say(bh,msg)

end subroutine

!>
!! Transform a generalized eigenproblem to standard form using Cholesky or eigen
!! decomposition of the overlap matrix.
!!
subroutine elsi_reduce_evp_sp_real(ph,bh,ham,ovlp,evec)

   implicit none

   type(elsi_param_t), intent(in) :: ph
   type(elsi_basic_t), intent(in) :: bh
   real(kind=r8), intent(inout) :: ham(ph%n_basis,ph%n_basis)
   real(kind=r8), intent(in) :: ovlp(ph%n_basis,ph%n_basis)
   real(kind=r8), intent(out) :: evec(ph%n_basis,ph%n_basis)

   real(kind=r8) :: t0
   real(kind=r8) :: t1
   integer(kind=i4) :: nwork
   integer(kind=i4) :: n
   character(len=200) :: msg

   integer(kind=i4), parameter :: nblk = 128
   character(len=*), parameter :: caller = "elsi_reduce_evp_sp_real"

   call elsi_get_time(t0)

   ! H = U^(-T) H U^(-1)
   if(ph%ill_ovlp) then
      call dgemm("N","N",ph%n_basis,ph%n_good,ph%n_basis,1.0_r8,ham,ph%n_basis,&
           ovlp,ph%n_basis,0.0_r8,evec,ph%n_basis)

      call dgemm("T","N",ph%n_good,ph%n_good,ph%n_basis,1.0_r8,ovlp,ph%n_basis,&
           evec,ph%n_basis,0.0_r8,ham,ph%n_basis)
   else
      do n = 1,ph%n_basis,nblk
         nwork = nblk

         if(n+nwork-1 > ph%n_basis) then
            nwork = ph%n_basis-n+1
         end if

         call dgemm("N","N",n+nwork-1,nwork,n+nwork-1,1.0_r8,ham,ph%n_basis,&
              ovlp(1,n),ph%n_basis,0.0_r8,evec(1,n),ph%n_basis)
      end do

      do n = 1,ph%n_basis,nblk
         nwork = nblk

         if(n+nwork-1 > ph%n_basis) then
            nwork = ph%n_basis-n+1
         end if

         call dgemm("T","N",nwork,ph%n_basis-n+1,n+nwork-1,1.0_r8,ovlp(1,n),&
              ph%n_basis,evec(1,n),ph%n_basis,0.0_r8,ham(n,n),ph%n_basis)
      end do
   end if

   call elsi_get_time(t1)

   write(msg,"(A)") "Finished transformation to standard eigenproblem"
   call elsi_say(bh,msg)
   write(msg,"(A,F10.3,A)") "| Time :",t1-t0," s"
   call elsi_say(bh,msg)

end subroutine

!>
!! Back-transform eigenvectors in the standard form to the original generalized
!! form.
!!
subroutine elsi_back_ev_sp_real(ph,bh,ovlp,evec)

   implicit none

   type(elsi_param_t), intent(in) :: ph
   type(elsi_basic_t), intent(in) :: bh
   real(kind=r8), intent(in) :: ovlp(ph%n_basis,ph%n_basis)
   real(kind=r8), intent(inout) :: evec(ph%n_basis,ph%n_basis)

   real(kind=r8) :: t0
   real(kind=r8) :: t1
   character(len=200) :: msg

   real(kind=r8), allocatable :: tmp(:,:)

   character(len=*), parameter :: caller = "elsi_back_ev_sp_real"

   call elsi_get_time(t0)

   if(ph%ill_ovlp) then
      call elsi_allocate(bh,tmp,ph%n_basis,ph%n_basis,"tmp",caller)

      tmp(:,:) = evec

      call dgemm("N","N",ph%n_basis,ph%n_states_solve,ph%n_good,1.0_r8,ovlp,&
           ph%n_basis,tmp,ph%n_basis,0.0_r8,evec,ph%n_basis)

      call elsi_deallocate(bh,tmp,"tmp")
   else
      call dtrmm("L","U","N","N",ph%n_basis,ph%n_states,1.0_r8,ovlp,ph%n_basis,&
           evec,ph%n_basis)
   end if

   call elsi_get_time(t1)

   write(msg,"(A)") "Finished back-transformation of eigenvectors"
   call elsi_say(bh,msg)
   write(msg,"(A,F10.3,A)") "| Time :",t1-t0," s"
   call elsi_say(bh,msg)

end subroutine

!>
!! Interface to LAPACK.
!!
subroutine elsi_solve_lapack_real(ph,bh,ham,ovlp,eval,evec)

   implicit none

   type(elsi_param_t), intent(inout) :: ph
   type(elsi_basic_t), intent(in) :: bh
   real(kind=r8), intent(inout) :: ham(ph%n_basis,ph%n_basis)
   real(kind=r8), intent(inout) :: ovlp(ph%n_basis,ph%n_basis)
   real(kind=r8), intent(out) :: eval(ph%n_basis)
   real(kind=r8), intent(out) :: evec(ph%n_basis,ph%n_basis)

   real(kind=r8) :: t0
   real(kind=r8) :: t1
   integer(kind=i4) :: ierr
   character(len=200) :: msg

   real(kind=r8), allocatable :: offd(:)
   real(kind=r8), allocatable :: tau(:)
   real(kind=r8), allocatable :: tmp(:,:)

   character(len=*), parameter :: caller = "elsi_solve_lapack_real"

   ! Ill-conditioning check
   if(.not. ph%unit_ovlp .and. ph%ill_check) then
      call elsi_check_ovlp_sp(ph,bh,ovlp,eval,evec)
   end if

   write(msg,"(A)") "Starting LAPACK eigensolver"
   call elsi_say(bh,msg)

   ! Transform to standard form
   if(.not. ph%unit_ovlp) then
      if(ph%n_good == ph%n_basis) then
         ! Do Cholesky if not singular
         call elsi_factor_ovlp_sp(ph,bh,ovlp)
      end if

      call elsi_reduce_evp_sp(ph,bh,ham,ovlp,evec)
   end if

   ! Solve
   call elsi_get_time(t0)

   call elsi_allocate(bh,offd,ph%n_good,"offd",caller)
   call elsi_allocate(bh,tau,ph%n_good,"tau",caller)
   call elsi_allocate(bh,tmp,ph%n_good,ph%n_good,"tmp",caller)

   call dsytrd("U",ph%n_good,ham,ph%n_basis,eval,offd,tau,tmp,ph%n_good**2,ierr)

   call elsi_elpa_tridiag(ph,bh,eval(1:ph%n_good),offd,tmp)

   evec(1:ph%n_good,1:ph%n_states_solve) = tmp(1:ph%n_good,1:ph%n_states_solve)

   call dormtr("L","U","N",ph%n_good,ph%n_states_solve,ham,ph%n_basis,tau,evec,&
        ph%n_basis,tmp,ph%n_good**2,ierr)

   call elsi_deallocate(bh,offd,"offd")
   call elsi_deallocate(bh,tau,"tau")
   call elsi_deallocate(bh,tmp,"tmp")

   ! Overwrite zero eigenvalues
   if(ph%n_good < ph%n_basis) then
      eval(ph%n_good+1:ph%n_basis) = eval(ph%n_good)+10.0_r8
   end if

   call elsi_get_time(t1)

   write(msg,"(A)") "Finished solving standard eigenproblem"
   call elsi_say(bh,msg)
   write(msg,"(A,F10.3,A)") "| Time :",t1-t0," s"
   call elsi_say(bh,msg)

   ! Back-transform eigenvectors
   if(.not. ph%unit_ovlp) then
      call elsi_back_ev_sp(ph,bh,ovlp,evec)
   end if

   ! Switch back to full dimension in case of frozen core
   if(ph%n_basis_c > 0) then
      ph%n_basis = ph%n_basis_v+ph%n_basis_c
      ph%n_states = ph%n_states+ph%n_basis_c
      ph%n_good = ph%n_good+ph%n_basis_c
      ph%n_states_solve = ph%n_states_solve+ph%n_basis_c
   end if

end subroutine

!>
!! Check the singularity of overlap matrix by computing all its eigenvalues. If
!! S is singular, it is overwritten by its eigen decomposition on exit.
!!
subroutine elsi_check_ovlp_sp_real(ph,bh,ovlp,eval,evec)

   implicit none

   type(elsi_param_t), intent(inout) :: ph
   type(elsi_basic_t), intent(in) :: bh
   real(kind=r8), intent(inout) :: ovlp(ph%n_basis,ph%n_basis)
   real(kind=r8), intent(out) :: eval(ph%n_basis)
   real(kind=r8), intent(out) :: evec(ph%n_basis,ph%n_basis)

   real(kind=r8) :: ev_sqrt
   real(kind=r8) :: t0
   real(kind=r8) :: t1
   integer(kind=i4) :: i
   integer(kind=i4) :: ierr
   character(len=200) :: msg

   real(kind=r8), allocatable :: copy(:,:)
   real(kind=r8), allocatable :: offd(:)
   real(kind=r8), allocatable :: tau(:)
   real(kind=r8), allocatable :: tmp(:,:)

   character(len=*), parameter :: caller = "elsi_check_ovlp_sp_real"

   call elsi_get_time(t0)

   call elsi_allocate(bh,copy,ph%n_basis,ph%n_basis,"copy",caller)

   ! Save overlap
   copy(:,:) = -ovlp

   call elsi_allocate(bh,offd,ph%n_basis,"offd",caller)
   call elsi_allocate(bh,tau,ph%n_basis,"tau",caller)
   call elsi_allocate(bh,tmp,ph%n_basis,ph%n_basis,"tmp",caller)

   call dsytrd("U",ph%n_basis,copy,ph%n_basis,eval,offd,tau,tmp,ph%n_basis**2,&
        ierr)

   ph%n_good = ph%n_basis
   ph%n_states_solve = ph%n_basis

   call elsi_elpa_tridiag(ph,bh,eval,offd,tmp)

   ! Get the number of nonsingular eigenvalues
   eval(:) = -eval

   do i = 1,ph%n_basis
      if(eval(i) < ph%ill_tol) then
         ph%n_good = ph%n_good-1
      end if
   end do

   ph%n_states_solve = min(ph%n_good,ph%n_states)
   ph%ovlp_ev_min = eval(ph%n_basis)
   ph%ovlp_ev_max = eval(1)

   if(ph%n_good < ph%n_basis) then
      write(msg,"(A)") "Overlap matrix is singular"
      call elsi_say(bh,msg)
      write(msg,"(A,E12.4,A,E12.4)") "| Lowest and highest eigenvalues :",&
         eval(ph%n_basis),",",eval(1)
      call elsi_say(bh,msg)
      write(msg,"(A,I10)") "| Number of basis functions reduced to :",ph%n_good
      call elsi_say(bh,msg)

      ph%ill_ovlp = .true.
      evec(:,:) = tmp

      call dormtr("L","U","N",ph%n_basis,ph%n_basis,copy,ph%n_basis,tau,evec,&
           ph%n_basis,tmp,ph%n_basis**2,ierr)

      ! Overlap matrix is overwritten with scaled eigenvectors
      do i = 1,ph%n_good
         ev_sqrt = sqrt(eval(i))
         ovlp(:,i) = evec(:,i)/ev_sqrt
      end do
   else
      write(msg,"(A)") "Overlap matrix is not singular"
      call elsi_say(bh,msg)
      write(msg,"(A,E12.4,A,E12.4)") "| Lowest and highest eigenvalues :",&
         eval(ph%n_basis),",",eval(1)
      call elsi_say(bh,msg)

      ph%ill_ovlp = .false.
   end if

   call elsi_deallocate(bh,offd,"offd")
   call elsi_deallocate(bh,tau,"tau")
   call elsi_deallocate(bh,tmp,"tmp")
   call elsi_deallocate(bh,copy,"copy")

   call elsi_get_time(t1)

   write(msg,"(A)") "Finished singularity check of overlap matrix"
   call elsi_say(bh,msg)
   write(msg,"(A,F10.3,A)") "| Time :",t1-t0," s"
   call elsi_say(bh,msg)

end subroutine

!>
!! Freeze core orbitals by transforming Hamiltonian and overlap.
!!
subroutine elsi_do_fc_lapack_real(ph,ham,ovlp,evec,perm)

   implicit none

   type(elsi_param_t), intent(inout) :: ph
   real(kind=r8), intent(inout) :: ham(ph%n_basis,ph%n_basis)
   real(kind=r8), intent(inout) :: ovlp(ph%n_basis,ph%n_basis)
   real(kind=r8), intent(out) :: evec(ph%n_basis,ph%n_basis)
   integer(kind=i4), intent(in) :: perm(ph%n_basis)

   integer(kind=i4) :: i

   character(len=*), parameter :: caller = "elsi_do_fc_lapack_real"

   if(ph%fc_perm) then
      evec(:,:) = ovlp

      do i = 1,ph%n_basis
         if(i /= perm(i)) then
            evec(:,i) = ovlp(:,perm(i))
         end if
      end do

      ovlp(:,:) = evec

      do i = 1,ph%n_basis
         if(i /= perm(i)) then
            ovlp(i,:) = evec(perm(i),:)
         end if
      end do
   end if

   evec(:,:) = ovlp

   ! S_vv = S_vv - S_vc * S_cv
   call dsyrk("U","N",ph%n_basis_v,ph%n_basis_c,-1.0_r8,evec(ph%n_basis_c+1,1),&
        ph%n_basis,1.0_r8,ovlp(ph%n_basis_c+1,ph%n_basis_c+1),ph%n_basis)

   if(ph%fc_perm) then
      evec(:,:) = ham

      do i = 1,ph%n_basis
         if(i /= perm(i)) then
            evec(:,i) = ham(:,perm(i))
         end if
      end do

      ham(:,:) = evec

      do i = 1,ph%n_basis
         if(i /= perm(i)) then
            ham(i,:) = evec(perm(i),:)
         end if
      end do
   end if

   ! Compute H_vv
   evec(:,:) = 0.0_r8

   if(ph%fc_method == FC_PLUS_V) then
      ! H_vv = H_vv + S_vc * H_cc * S_cv - H_vc * S_cv - S_vc * H_cv
      ! More accurate than H_vv = H_vv - S_vc * H_cc * S_cv
      ! H_vv = A + A^*
      ! A = 0.5*H_vv + (0.5*S_vc * H_cc - H_vc) * S_cv
      call dgemm("N","N",ph%n_basis_v,ph%n_basis_c,ph%n_basis_c,0.5_r8,&
           ovlp(ph%n_basis_c+1,1),ph%n_basis,ham,ph%n_basis,0.0_r8,&
           evec(ph%n_basis_c+1,1),ph%n_basis)

      evec(:,:) = evec-ham

      call dgemm("N","N",ph%n_basis_v,ph%n_basis_v,ph%n_basis_c,1.0_r8,&
           evec(ph%n_basis_c+1,1),ph%n_basis,ovlp(1,ph%n_basis_c+1),ph%n_basis,&
           0.5_r8,ham(ph%n_basis_c+1,ph%n_basis_c+1),ph%n_basis)

      ham(ph%n_basis_c+1:ph%n_basis,ph%n_basis_c+1:ph%n_basis) =&
         ham(ph%n_basis_c+1:ph%n_basis,ph%n_basis_c+1:ph%n_basis)&
         +transpose(ham(ph%n_basis_c+1:ph%n_basis,ph%n_basis_c+1:ph%n_basis))
   else
      ! H_vv = H_vv - S_vc * H_cc * S_cv
      call dgemm("N","N",ph%n_basis_v,ph%n_basis_c,ph%n_basis_c,1.0_r8,&
           ovlp(ph%n_basis_c+1,1),ph%n_basis,ham,ph%n_basis,0.0_r8,&
           evec(ph%n_basis_c+1,1),ph%n_basis)

      call dgemm("N","N",ph%n_basis_v,ph%n_basis_v,ph%n_basis_c,-1.0_r8,&
           evec(ph%n_basis_c+1,1),ph%n_basis,ovlp(1,ph%n_basis_c+1),ph%n_basis,&
           1.0_r8,ham(ph%n_basis_c+1,ph%n_basis_c+1),ph%n_basis)
   end if

   ! Switch to valence dimension
   ph%n_basis = ph%n_basis-ph%n_basis_c
   ph%n_states = ph%n_states-ph%n_basis_c
   ph%n_good = ph%n_good-ph%n_basis_c
   ph%n_states_solve = ph%n_states_solve-ph%n_basis_c

end subroutine

!>
!! Transforming eigenvectors back to unfrozen eigenproblem.
!!
subroutine elsi_undo_fc_lapack_real(ph,bh,ham,ovlp,evec,perm,eval_c)

   implicit none

   type(elsi_param_t), intent(inout) :: ph
   type(elsi_basic_t), intent(inout) :: bh
   real(kind=r8), intent(inout) :: ham(ph%n_basis,ph%n_basis)
   real(kind=r8), intent(in) :: ovlp(ph%n_basis,ph%n_basis)
   real(kind=r8), intent(out) :: evec(ph%n_basis,ph%n_basis)
   integer(kind=i4), intent(in) :: perm(ph%n_basis)
   real(kind=r8), intent(out) :: eval_c(ph%n_basis_c)

   integer(kind=i4) :: i
   integer(kind=i4) :: j

   integer(kind=i4), allocatable :: idx(:)
   integer(kind=i4), allocatable :: tmp(:)

   character(len=*), parameter :: caller = "elsi_undo_fc_lapack_real"

   call elsi_allocate(bh,idx,ph%n_basis_c,"idx",caller)
   call elsi_allocate(bh,tmp,ph%n_basis_c,"tmp",caller)

   eval_c(:) = 0.0_r8

   do i = 1,ph%n_basis_c
      idx(i) = i

      if(ph%fc_method > FC_BASIC) then
         eval_c(i) = ham(i,i)/ovlp(i,i)
      else
         eval_c(i) = ham(i,i)
      end if
   end do

   call elsi_heapsort(ph%n_basis_c,eval_c,tmp)
   call elsi_permute(ph%n_basis_c,tmp,idx)

   evec(:,1:ph%n_basis_c) = 0.0_r8

   do j = 1,ph%n_basis_c
      i = idx(j)

      if(ph%fc_method > FC_BASIC) then
         evec(i,j) = 1.0_r8/sqrt(ovlp(i,i))
      else
         evec(i,j) = 1.0_r8
      end if
   end do

   call elsi_deallocate(bh,idx,"idx")
   call elsi_deallocate(bh,tmp,"tmp")

   ! C_cv = -S_cv * C_vv
   call dgemm("N","N",ph%n_basis_c,ph%n_basis_v,ph%n_basis_v,-1.0_r8,&
        ovlp(1,ph%n_basis_c+1),ph%n_basis,evec(ph%n_basis_c+1,ph%n_basis_c+1),&
        ph%n_basis,0.0_r8,evec(1,ph%n_basis_c+1),ph%n_basis)

   if(ph%fc_perm) then
      ham(:,:) = evec

      do i = 1,ph%n_basis
         if(i /= perm(i)) then
            evec(perm(i),:) = ham(i,:)
         end if
      end do
   end if

end subroutine

!>
!! Cholesky factorize the overlap matrix in place.
!!
subroutine elsi_factor_ovlp_sp_cmplx(ph,bh,ovlp)

   implicit none

   type(elsi_param_t), intent(in) :: ph
   type(elsi_basic_t), intent(in) :: bh
   complex(kind=r8), intent(inout) :: ovlp(ph%n_basis,ph%n_basis)

   real(kind=r8) :: t0
   real(kind=r8) :: t1
   integer(kind=i4) :: i
   integer(kind=i4) :: j
   integer(kind=i4) :: ierr
   character(len=200) :: msg

   character(len=*), parameter :: caller = "elsi_factor_ovlp_sp_cmplx"

   call elsi_get_time(t0)

   ! Erase lower triangle
   do j = 1,ph%n_basis-1
      do i= j+1,ph%n_basis
         ovlp(i,j) = (0.0_r8,0.0_r8)
      end do
   end do

   ! S = U
   call zpotrf("U",ph%n_basis,ovlp,ph%n_basis,ierr)

   ! S = U^(-1)
   call ztrtri("U","N",ph%n_basis,ovlp,ph%n_basis,ierr)

   call elsi_get_time(t1)

   write(msg,"(A)") "Finished Cholesky decomposition"
   call elsi_say(bh,msg)
   write(msg,"(A,F10.3,A)") "| Time :",t1-t0," s"
   call elsi_say(bh,msg)

end subroutine

!>
!! Transform a generalized eigenproblem to standard form using Cholesky or eigen
!! decomposition of the overlap matrix.
!!
subroutine elsi_reduce_evp_sp_cmplx(ph,bh,ham,ovlp,evec)

   implicit none

   type(elsi_param_t), intent(in) :: ph
   type(elsi_basic_t), intent(in) :: bh
   complex(kind=r8), intent(inout) :: ham(ph%n_basis,ph%n_basis)
   complex(kind=r8), intent(in) :: ovlp(ph%n_basis,ph%n_basis)
   complex(kind=r8), intent(out) :: evec(ph%n_basis,ph%n_basis)

   real(kind=r8) :: t0
   real(kind=r8) :: t1
   integer(kind=i4) :: nwork
   integer(kind=i4) :: n
   character(len=200) :: msg

   integer(kind=i4), parameter :: nblk = 128
   character(len=*), parameter :: caller = "elsi_reduce_evp_sp_cmplx"

   call elsi_get_time(t0)

   ! H = U^(-T) H U^(-1)
   if(ph%ill_ovlp) then
      call zgemm("N","N",ph%n_basis,ph%n_good,ph%n_basis,(1.0_r8,0.0_r8),ham,&
           ph%n_basis,ovlp,ph%n_basis,(0.0_r8,0.0_r8),evec,ph%n_basis)

      call zgemm("C","N",ph%n_good,ph%n_good,ph%n_basis,(1.0_r8,0.0_r8),ovlp,&
           ph%n_basis,evec,ph%n_basis,(0.0_r8,0.0_r8),ham,ph%n_basis)
   else
      do n = 1,ph%n_basis,nblk
         nwork = nblk

         if(n+nwork-1 > ph%n_basis) then
            nwork = ph%n_basis-n+1
         end if

         call zgemm("N","N",n+nwork-1,nwork,n+nwork-1,(1.0_r8,0.0_r8),ham,&
              ph%n_basis,ovlp(1,n),ph%n_basis,(0.0_r8,0.0_r8),evec(1,n),&
              ph%n_basis)
      end do

      do n = 1,ph%n_basis,nblk
         nwork = nblk

         if(n+nwork-1 > ph%n_basis) then
            nwork = ph%n_basis-n+1
         end if

         call zgemm("C","N",nwork,ph%n_basis-n+1,n+nwork-1,(1.0_r8,0.0_r8),&
              ovlp(1,n),ph%n_basis,evec(1,n),ph%n_basis,(0.0_r8,0.0_r8),&
              ham(n,n),ph%n_basis)
      end do
   end if

   call elsi_get_time(t1)

   write(msg,"(A)") "Finished transformation to standard eigenproblem"
   call elsi_say(bh,msg)
   write(msg,"(A,F10.3,A)") "| Time :",t1-t0," s"
   call elsi_say(bh,msg)

end subroutine

!>
!! Back-transform eigenvectors in the standard form to the original generalized
!! form.
!!
subroutine elsi_back_ev_sp_cmplx(ph,bh,ovlp,evec)

   implicit none

   type(elsi_param_t), intent(in) :: ph
   type(elsi_basic_t), intent(in) :: bh
   complex(kind=r8), intent(in) :: ovlp(ph%n_basis,ph%n_basis)
   complex(kind=r8), intent(inout) :: evec(ph%n_basis,ph%n_basis)

   real(kind=r8) :: t0
   real(kind=r8) :: t1
   character(len=200) :: msg

   complex(kind=r8), allocatable :: tmp(:,:)

   character(len=*), parameter :: caller = "elsi_back_ev_sp_cmplx"

   call elsi_get_time(t0)

   if(ph%ill_ovlp) then
      call elsi_allocate(bh,tmp,ph%n_basis,ph%n_basis,"tmp",caller)

      tmp(:,:) = evec

      call zgemm("N","N",ph%n_basis,ph%n_states_solve,ph%n_good,&
           (1.0_r8,0.0_r8),ovlp,ph%n_basis,tmp,ph%n_basis,(0.0_r8,0.0_r8),evec,&
           ph%n_basis)

      call elsi_deallocate(bh,tmp,"tmp")
   else
      call ztrmm("L","U","N","N",ph%n_basis,ph%n_states,(1.0_r8,0.0_r8),ovlp,&
           ph%n_basis,evec,ph%n_basis)
   end if

   call elsi_get_time(t1)

   write(msg,"(A)") "Finished back-transformation of eigenvectors"
   call elsi_say(bh,msg)
   write(msg,"(A,F10.3,A)") "| Time :",t1-t0," s"
   call elsi_say(bh,msg)

end subroutine

!>
!! Interface to LAPACK.
!!
subroutine elsi_solve_lapack_cmplx(ph,bh,ham,ovlp,eval,evec)

   implicit none

   type(elsi_param_t), intent(inout) :: ph
   type(elsi_basic_t), intent(in) :: bh
   complex(kind=r8), intent(inout) :: ham(ph%n_basis,ph%n_basis)
   complex(kind=r8), intent(inout) :: ovlp(ph%n_basis,ph%n_basis)
   real(kind=r8), intent(out) :: eval(ph%n_basis)
   complex(kind=r8), intent(out) :: evec(ph%n_basis,ph%n_basis)

   real(kind=r8) :: t0
   real(kind=r8) :: t1
   integer(kind=i4) :: ierr
   character(len=200) :: msg

   complex(kind=r8), allocatable :: tau(:)
   complex(kind=r8), allocatable :: tmp_cmplx(:,:)
   real(kind=r8), allocatable :: offd(:)
   real(kind=r8), allocatable :: tmp_real(:,:)

   character(len=*), parameter :: caller = "elsi_solve_lapack_cmplx"

   ! Ill-conditioning check
   if(.not. ph%unit_ovlp .and. ph%ill_check) then
      call elsi_check_ovlp_sp(ph,bh,ovlp,eval,evec)
   end if

   write(msg,"(A)") "Starting LAPACK eigensolver"
   call elsi_say(bh,msg)

   ! Transform to standard form
   if(.not. ph%unit_ovlp) then
      if(ph%n_good == ph%n_basis) then
         ! Do Cholesky if not singular
         call elsi_factor_ovlp_sp(ph,bh,ovlp)
      end if

      call elsi_reduce_evp_sp(ph,bh,ham,ovlp,evec)
   end if

   ! Solve
   call elsi_get_time(t0)

   call elsi_allocate(bh,offd,ph%n_good,"offd",caller)
   call elsi_allocate(bh,tau,ph%n_good,"tau",caller)
   call elsi_allocate(bh,tmp_real,ph%n_good,ph%n_good,"tmp_real",caller)
   call elsi_allocate(bh,tmp_cmplx,ph%n_good,ph%n_good,"tmp_cmplx",caller)

   call zhetrd("U",ph%n_good,ham,ph%n_basis,eval,offd,tau,tmp_cmplx,&
        ph%n_good**2,ierr)

   call elsi_elpa_tridiag(ph,bh,eval(1:ph%n_good),offd,tmp_real)

   evec(1:ph%n_good,1:ph%n_states_solve)&
      = tmp_real(1:ph%n_good,1:ph%n_states_solve)

   call zunmtr("L","U","N",ph%n_good,ph%n_states_solve,ham,ph%n_basis,tau,evec,&
        ph%n_basis,tmp_cmplx,ph%n_good**2,ierr)

   call elsi_deallocate(bh,offd,"offd")
   call elsi_deallocate(bh,tau,"tau")
   call elsi_deallocate(bh,tmp_real,"tmp_real")
   call elsi_deallocate(bh,tmp_cmplx,"tmp_cmplx")

   ! Overwrite zero eigenvalues
   if(ph%n_good < ph%n_basis) then
      eval(ph%n_good+1:ph%n_basis) = eval(ph%n_good)+10.0_r8
   end if

   call elsi_get_time(t1)

   write(msg,"(A)") "Finished solving standard eigenproblem"
   call elsi_say(bh,msg)
   write(msg,"(A,F10.3,A)") "| Time :",t1-t0," s"
   call elsi_say(bh,msg)

   ! Back-transform eigenvectors
   if(.not. ph%unit_ovlp) then
      call elsi_back_ev_sp(ph,bh,ovlp,evec)
   end if

   ! Switch back to full dimension in case of frozen core
   if(ph%n_basis_c > 0) then
      ph%n_basis = ph%n_basis_v+ph%n_basis_c
      ph%n_states = ph%n_states+ph%n_basis_c
      ph%n_good = ph%n_good+ph%n_basis_c
      ph%n_states_solve = ph%n_states_solve+ph%n_basis_c
   end if

end subroutine

!>
!! Check the singularity of overlap matrix by computing all its eigenvalues. If
!! S is singular, it is overwritten by its eigen decomposition on exit.
!!
subroutine elsi_check_ovlp_sp_cmplx(ph,bh,ovlp,eval,evec)

   implicit none

   type(elsi_param_t), intent(inout) :: ph
   type(elsi_basic_t), intent(in) :: bh
   complex(kind=r8), intent(inout) :: ovlp(ph%n_basis,ph%n_basis)
   real(kind=r8), intent(out) :: eval(ph%n_basis)
   complex(kind=r8), intent(out) :: evec(ph%n_basis,ph%n_basis)

   real(kind=r8) :: ev_sqrt
   real(kind=r8) :: t0
   real(kind=r8) :: t1
   integer(kind=i4) :: i
   integer(kind=i4) :: ierr
   character(len=200) :: msg

   complex(kind=r8), allocatable :: copy(:,:)
   complex(kind=r8), allocatable :: tau(:)
   complex(kind=r8), allocatable :: tmp_cmplx(:,:)
   real(kind=r8), allocatable :: offd(:)
   real(kind=r8), allocatable :: tmp_real(:,:)

   character(len=*), parameter :: caller = "elsi_check_ovlp_sp_cmplx"

   call elsi_get_time(t0)

   call elsi_allocate(bh,copy,ph%n_basis,ph%n_basis,"copy",caller)

   ! Save overlap
   copy(:,:) = -ovlp

   call elsi_allocate(bh,offd,ph%n_basis,"offd",caller)
   call elsi_allocate(bh,tau,ph%n_basis,"tau",caller)
   call elsi_allocate(bh,tmp_real,ph%n_basis,ph%n_basis,"tmp_real",caller)
   call elsi_allocate(bh,tmp_cmplx,ph%n_basis,ph%n_basis,"tmp_cmplx",caller)

   call zhetrd("U",ph%n_basis,copy,ph%n_basis,eval,offd,tau,tmp_cmplx,&
        ph%n_basis**2,ierr)

   ph%n_good = ph%n_basis
   ph%n_states_solve = ph%n_basis

   call elsi_elpa_tridiag(ph,bh,eval,offd,tmp_real)

   ! Get the number of nonsingular eigenvalues
   eval(:) = -eval

   do i = 1,ph%n_basis
      if(eval(i) < ph%ill_tol) then
         ph%n_good = ph%n_good-1
      end if
   end do

   ph%n_states_solve = min(ph%n_good,ph%n_states)
   ph%ovlp_ev_min = eval(ph%n_basis)
   ph%ovlp_ev_max = eval(1)

   if(ph%n_good < ph%n_basis) then
      write(msg,"(A)") "Overlap matrix is singular"
      call elsi_say(bh,msg)
      write(msg,"(A,E12.4,A,E12.4)") "| Lowest and highest eigenvalues :",&
         eval(ph%n_basis),",",eval(1)
      call elsi_say(bh,msg)
      write(msg,"(A,I10)") "| Number of basis functions reduced to :",ph%n_good
      call elsi_say(bh,msg)

      ph%ill_ovlp = .true.
      evec(:,:) = tmp_real

      call zunmtr("L","U","N",ph%n_basis,ph%n_basis,copy,ph%n_basis,tau,evec,&
           ph%n_basis,tmp_cmplx,ph%n_basis**2,ierr)

      ! Overlap matrix is overwritten with scaled eigenvectors
      do i = 1,ph%n_good
         ev_sqrt = sqrt(eval(i))
         ovlp(:,i) = evec(:,i)/ev_sqrt
      end do
   else
      write(msg,"(A)") "Overlap matrix is not singular"
      call elsi_say(bh,msg)
      write(msg,"(A,E12.4,A,E12.4)") "| Lowest and highest eigenvalues :",&
         eval(ph%n_basis),",",eval(1)
      call elsi_say(bh,msg)

      ph%ill_ovlp = .false.
   end if

   call elsi_deallocate(bh,offd,"offd")
   call elsi_deallocate(bh,tau,"tau")
   call elsi_deallocate(bh,tmp_real,"tmp_real")
   call elsi_deallocate(bh,tmp_cmplx,"tmp_cmplx")
   call elsi_deallocate(bh,copy,"copy")

   call elsi_get_time(t1)

   write(msg,"(A)") "Finished singularity check of overlap matrix"
   call elsi_say(bh,msg)
   write(msg,"(A,F10.3,A)") "| Time :",t1-t0," s"
   call elsi_say(bh,msg)

end subroutine

!>
!! Freeze core orbitals by transforming Hamiltonian and overlap.
!!
subroutine elsi_do_fc_lapack_cmplx(ph,ham,ovlp,evec,perm)

   implicit none

   type(elsi_param_t), intent(inout) :: ph
   complex(kind=r8), intent(inout) :: ham(ph%n_basis,ph%n_basis)
   complex(kind=r8), intent(inout) :: ovlp(ph%n_basis,ph%n_basis)
   complex(kind=r8), intent(out) :: evec(ph%n_basis,ph%n_basis)
   integer(kind=i4), intent(in) :: perm(ph%n_basis)

   integer(kind=i4) :: i

   character(len=*), parameter :: caller = "elsi_do_fc_lapack_cmplx"

   if(ph%fc_perm) then
      evec(:,:) = ovlp

      do i = 1,ph%n_basis
         if(i /= perm(i)) then
            evec(:,i) = ovlp(:,perm(i))
         end if
      end do

      ovlp(:,:) = evec

      do i = 1,ph%n_basis
         if(i /= perm(i)) then
            ovlp(i,:) = evec(perm(i),:)
         end if
      end do
   end if

   evec(:,:) = ovlp

   ! S_vv = S_vv - S_vc * S_cv
   call zherk("U","N",ph%n_basis_v,ph%n_basis_c,(-1.0_r8,0.0_r8),&
        evec(ph%n_basis_c+1,1),ph%n_basis,(1.0_r8,0.0_r8),&
        ovlp(ph%n_basis_c+1,ph%n_basis_c+1),ph%n_basis)

   if(ph%fc_perm) then
      evec(:,:) = ham

      do i = 1,ph%n_basis
         if(i /= perm(i)) then
            evec(:,i) = ham(:,perm(i))
         end if
      end do

      ham(:,:) = evec

      do i = 1,ph%n_basis
         if(i /= perm(i)) then
            ham(i,:) = evec(perm(i),:)
         end if
      end do
   end if

   ! Compute H_vv
   evec(:,:) = (0.0_r8,0.0_r8)

   if(ph%fc_method == FC_PLUS_V) then
      ! H_vv = H_vv + S_vc * H_cc * S_cv - H_vc * S_cv - S_vc * H_cv
      ! More accurate than H_vv = H_vv - S_vc * H_cc * S_cv
      ! H_vv = A + A^*
      ! A = 0.5*H_vv + (0.5*S_vc * H_cc - H_vc) * S_cv
      call zgemm("N","N",ph%n_basis_v,ph%n_basis_c,ph%n_basis_c,&
           (0.5_r8,0.0_r8),ovlp(ph%n_basis_c+1,1),ph%n_basis,ham,ph%n_basis,&
           (0.0_r8,0.0_r8),evec(ph%n_basis_c+1,1),ph%n_basis)

      evec(:,:) = evec-ham

      call zgemm("N","N",ph%n_basis_v,ph%n_basis_v,ph%n_basis_c,&
           (1.0_r8,0.0_r8),evec(ph%n_basis_c+1,1),ph%n_basis,&
           ovlp(1,ph%n_basis_c+1),ph%n_basis,(0.5_r8,0.0_r8),&
           ham(ph%n_basis_c+1,ph%n_basis_c+1),ph%n_basis)

      ham(ph%n_basis_c+1:ph%n_basis,ph%n_basis_c+1:ph%n_basis) =&
         ham(ph%n_basis_c+1:ph%n_basis,ph%n_basis_c+1:ph%n_basis)&
         +conjg(transpose(ham(ph%n_basis_c+1:ph%n_basis,&
         ph%n_basis_c+1:ph%n_basis)))
   else
      ! H_vv = H_vv - S_vc * H_cc * S_cv
      call zgemm("N","N",ph%n_basis_v,ph%n_basis_c,ph%n_basis_c,&
           (1.0_r8,0.0_r8),ovlp(ph%n_basis_c+1,1),ph%n_basis,ham,ph%n_basis,&
           (0.0_r8,0.0_r8),evec(ph%n_basis_c+1,1),ph%n_basis)

      call zgemm("N","N",ph%n_basis_v,ph%n_basis_v,ph%n_basis_c,&
           (-1.0_r8,0.0_r8),evec(ph%n_basis_c+1,1),ph%n_basis,&
           ovlp(1,ph%n_basis_c+1),ph%n_basis,(1.0_r8,0.0_r8),&
           ham(ph%n_basis_c+1,ph%n_basis_c+1),ph%n_basis)
   end if

   ! Switch to valence dimension
   ph%n_basis = ph%n_basis-ph%n_basis_c
   ph%n_states = ph%n_states-ph%n_basis_c
   ph%n_good = ph%n_good-ph%n_basis_c
   ph%n_states_solve = ph%n_states_solve-ph%n_basis_c

end subroutine

!>
!! Transforming eigenvectors back to unfrozen eigenproblem.
!!
subroutine elsi_undo_fc_lapack_cmplx(ph,bh,ham,ovlp,evec,perm,eval_c)

   implicit none

   type(elsi_param_t), intent(inout) :: ph
   type(elsi_basic_t), intent(inout) :: bh
   complex(kind=r8), intent(inout) :: ham(ph%n_basis,ph%n_basis)
   complex(kind=r8), intent(in) :: ovlp(ph%n_basis,ph%n_basis)
   complex(kind=r8), intent(out) :: evec(ph%n_basis,ph%n_basis)
   integer(kind=i4), intent(in) :: perm(ph%n_basis)
   real(kind=r8), intent(out) :: eval_c(ph%n_basis_c)

   integer(kind=i4) :: i
   integer(kind=i4) :: j

   integer(kind=i4), allocatable :: idx(:)
   integer(kind=i4), allocatable :: tmp(:)

   character(len=*), parameter :: caller = "elsi_undo_fc_lapack_cmplx"

   call elsi_allocate(bh,idx,ph%n_basis_c,"idx",caller)
   call elsi_allocate(bh,tmp,ph%n_basis_c,"tmp",caller)

   eval_c(:) = 0.0_r8

   do i = 1,ph%n_basis_c
      idx(i) = i

      if(ph%fc_method > FC_BASIC) then
         eval_c(i) = ham(i,i)/ovlp(i,i)
      else
         eval_c(i) = ham(i,i)
      end if
   end do

   call elsi_heapsort(ph%n_basis_c,eval_c,tmp)
   call elsi_permute(ph%n_basis_c,tmp,idx)

   evec(:,1:ph%n_basis_c) = (0.0_r8,0.0_r8)

   do j = 1,ph%n_basis_c
      i = idx(j)

      if(ph%fc_method > FC_BASIC) then
         evec(i,j) = (1.0_r8,0.0_r8)/sqrt(real(ovlp(i,i),kind=r8))
      else
         evec(i,j) = (1.0_r8,0.0_r8)
      end if
   end do

   call elsi_deallocate(bh,idx,"idx")
   call elsi_deallocate(bh,tmp,"tmp")

   ! C_cv = -S_cv * C_vv
   call zgemm("N","N",ph%n_basis_c,ph%n_basis_v,ph%n_basis_v,(-1.0_r8,0.0_r8),&
        ovlp(1,ph%n_basis_c+1),ph%n_basis,evec(ph%n_basis_c+1,ph%n_basis_c+1),&
        ph%n_basis,(0.0_r8,0.0_r8),evec(1,ph%n_basis_c+1),ph%n_basis)

   if(ph%fc_perm) then
      ham(:,:) = evec

      do i = 1,ph%n_basis
         if(i /= perm(i)) then
            evec(perm(i),:) = ham(i,:)
         end if
      end do
   end if

end subroutine

end module ELSI_LAPACK
