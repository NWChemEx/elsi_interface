! Copyright (c) 2015-2021, the ELSI team.
! All rights reserved.
!
! This file is part of ELSI and is distributed under the BSD 3-clause license,
! which may be found in the LICENSE file in the ELSI root directory.

!>
!! Determine occupation numbers, chemical potential, and electronic entropy.
!!
module ELSI_OCC

   use ELSI_CONSTANT, only: GAUSSIAN,FERMI,METHFESSEL_PAXTON,COLD,CUBIC,&
       SQRT_PI,INVERT_SQRT_PI
   use ELSI_DATATYPE, only: elsi_param_t,elsi_basic_t, elsi_handle
   use ELSI_MALLOC, only: elsi_allocate,elsi_deallocate
   use ELSI_MPI
   use ELSI_OUTPUT, only: elsi_say
   use ELSI_PRECISION, only: r8,i4
   use ELSI_SORT, only: elsi_heapsort,elsi_permute,elsi_unpermute
   use ELSI_UTIL, only: elsi_check_err

   implicit none

   private

   public :: elsi_mu_and_occ
   public :: elsi_entropy
   public :: elsi_get_occ_for_dm
   public :: elsi_check_electrons

contains

!>
!! Compute the chemical potential and occupation numbers.
!!
subroutine elsi_mu_and_occ(ph,bh,n_electron,n_state,n_spin,n_kpt,k_wt,eval,occ,&
   mu)

   implicit none

   type(elsi_param_t), intent(in) :: ph
   type(elsi_basic_t), intent(in) :: bh
   real(kind=r8), intent(in) :: n_electron
   integer(kind=i4), intent(in) :: n_state
   integer(kind=i4), intent(in) :: n_spin
   integer(kind=i4), intent(in) :: n_kpt
   real(kind=r8), intent(in) :: k_wt(n_kpt)
   real(kind=r8), intent(in) :: eval(n_state,n_spin,n_kpt)
   real(kind=r8), intent(out) :: occ(n_state,n_spin,n_kpt)
   real(kind=r8), intent(out) :: mu

   real(kind=r8) :: occ1(n_state,n_spin,n_kpt)
   real(kind=r8) :: occ2(n_state,n_spin,n_kpt)
   real(kind=r8) :: mu1
   real(kind=r8) :: mu2

   call elsi_mu_and_occ_normal(ph,bh,n_electron,n_state,n_spin,n_kpt,k_wt,&
        eval,occ,mu)

end subroutine
!>
!! Compute the chemical potential and occupation numbers normal distribution.
!!
subroutine elsi_mu_and_occ_normal(ph,bh,n_electron,n_state,n_spin,n_kpt,k_wt,eval,occ,&
   mu)

   implicit none

   type(elsi_param_t), intent(in) :: ph
   type(elsi_basic_t), intent(in) :: bh
   real(kind=r8), intent(in) :: n_electron
   integer(kind=i4), intent(in) :: n_state
   integer(kind=i4), intent(in) :: n_spin
   integer(kind=i4), intent(in) :: n_kpt
   real(kind=r8), intent(in) :: k_wt(n_kpt)
   real(kind=r8), intent(in) :: eval(n_state,n_spin,n_kpt)
   real(kind=r8), intent(out) :: occ(n_state,n_spin,n_kpt)
   real(kind=r8), intent(out) :: mu

   real(kind=r8) :: mu_min
   real(kind=r8) :: mu_max
   real(kind=r8) :: buf
   real(kind=r8) :: diff_min ! Error on lower bound
   real(kind=r8) :: diff_max ! Error on upper bound
   integer(kind=i4) :: i_step
   logical :: found_mu
   logical :: found_interval
   character(len=200) :: msg
   integer :: i_state, i_spin, i_kpt

   character(len=*), parameter :: caller = "elsi_mu_and_occ_normal"

   ! Determine upper and lower bounds of mu
   mu_min = minval(eval)
   mu_max = maxval(eval)
   buf = 0.5_r8*abs(mu_max-mu_min)

   if(mu_max - mu_min < ph%mu_tol) then
      mu_min = mu_min-1.0_r8
      mu_max = mu_max+1.0_r8
   end if

   occ(:,:,:) = 0.0_r8
   found_mu = .false.
   found_interval = .false.

   ! Find solution interval
   do i_step = 1,ph%mu_max_steps
      call elsi_check_electrons(ph,n_electron,n_state,n_spin,n_kpt,k_wt,eval,&
           occ,mu_min,diff_min)

      if(abs(diff_min) < ph%mu_tol) then
         mu = mu_min
         found_mu = .true.

         exit
      end if

      call elsi_check_electrons(ph,n_electron,n_state,n_spin,n_kpt,k_wt,eval,&
           occ,mu_max,diff_max)

      if(abs(diff_max) < ph%mu_tol) then
         mu = mu_max
         found_mu = .true.

         exit
      end if

      if(diff_min*diff_max < 0.0_r8) then
         found_interval = .true.

         exit
      end if

      ! Enlarge interval if solution not found
      mu_min = mu_min-buf
      mu_max = mu_max+buf
   end do

   if(.not. found_interval .and. .not. found_mu) then
      ! Test fully occupied and empty states
      diff_max = n_state*n_spin*ph%spin_degen-n_electron

      if(abs(diff_max) < ph%mu_tol) then
         found_mu = .true.
         mu = maxval(eval)+10.0_r8
         occ(:,:,:) = ph%spin_degen
      else if(abs(n_electron) < ph%mu_tol) then
         found_mu = .true.
         mu = minval(eval)-10.0_r8
         occ(:,:,:) = 0.0_r8
      else
         write(msg,"(A)") "*** A problem occurred in subroutine elsi_mu_and_occ_normal"
         call elsi_say(bh,msg)
         write(msg,"(A)") "The ELSI routine to determine occupation numbers elsi_mu_and_occ_normal was unable to"
         call elsi_say(bh,msg)
         write(msg,"(A)") "find a suitable chemical potential (Fermi level). This may be"
         call elsi_say(bh,msg)
         write(msg,"(A)") "due to faulty input to the routine, i.e. a problem at an earlier stage of"
         call elsi_say(bh,msg)
         write(msg,"(A)") "the computation. For reference, the eigenvalues (in internal units of the"
         call elsi_say(bh,msg)
         write(msg,"(A)") "the code, typically atomic units in electronic structure theory) have the"
         call elsi_say(bh,msg)
         write(msg,"(A)") "following values:"
         call elsi_say(bh,msg)
         do i_kpt = 1, n_kpt
           write(msg,"(A,I8)") "k-point ", i_kpt
           call elsi_say(bh,msg)
           do i_spin = 1, n_spin
             write(msg,"(A,I5)") "spin channel ", i_spin
             call elsi_say(bh,msg)
             write(msg,"(A)") "EV number eigenvalue "
             call elsi_say(bh,msg)
             do i_state = 1, n_state
               write(msg,"(I8,A,E14.7)") i_state, " ", eval(i_state, i_spin, i_kpt)
               call elsi_say(bh,msg)
             end do
           end do
         end do
         call sleep(10)
         write(msg,"(A)") "Chemical potential not found - please see above &
                           for a more detailed error message and output"
         call elsi_stop(bh,msg,caller)
      end if
   end if

   if(found_interval .and. .not. found_mu) then
      ! Perform bisection
      call elsi_find_mu(ph,bh,n_electron,n_state,n_spin,n_kpt,k_wt,eval,occ,&
           mu_min,mu_max,mu)
   end if

end subroutine

!>
!! Compute the number of electrons for a given chemical potential, return the
!! error in the number of electrons. The occupation numbers are updated as well.
!!
subroutine elsi_check_electrons(ph,n_electron,n_state,n_spin,n_kpt,k_wt,eval,&
   occ,mu,diff)

   implicit none

   type(elsi_param_t), intent(in) :: ph
   real(kind=r8), intent(in) :: n_electron
   integer(kind=i4), intent(in) :: n_state
   integer(kind=i4), intent(in) :: n_spin
   integer(kind=i4), intent(in) :: n_kpt
   real(kind=r8), intent(in) :: k_wt(n_kpt)
   real(kind=r8), intent(in) :: eval(n_state,n_spin,n_kpt)
   real(kind=r8), intent(out) :: occ(n_state,n_spin,n_kpt)
   real(kind=r8), intent(in) :: mu
   real(kind=r8), intent(out) :: diff

   real(kind=r8) :: spin_degen
   real(kind=r8) :: invert_width
   real(kind=r8) :: delta
   real(kind=r8) :: max_exp ! Maximum possible exponent
   real(kind=r8) :: arg
   real(kind=r8) :: wt
   real(kind=r8) :: A
   real(kind=r8) :: H_even
   real(kind=r8) :: H_odd
   integer(kind=i4) :: i_state
   integer(kind=i4) :: i_kpt
   integer(kind=i4) :: i_spin
   integer(kind=i4) :: i_mp
   integer(kind=i4) :: i_constraints

   character(len=*), parameter :: caller = "elsi_check_electrons"

   invert_width = 1.0_r8/ph%mu_width
   diff = 0.0_r8

   if(.not. ph%spin_is_set) then
      if(n_spin == 2) then
         spin_degen = 1.0_r8
      else
         spin_degen = 2.0_r8
      end if
   else
      spin_degen = ph%spin_degen
   end if

   select case(ph%mu_scheme)
   case(GAUSSIAN)
      do i_kpt = 1,n_kpt
         do i_spin = 1,n_spin
            do i_state = 1,n_state
               occ(i_state,i_spin,i_kpt) = spin_degen*0.5_r8&
                  *(1.0_r8-erf((eval(i_state,i_spin,i_kpt)-mu)*invert_width))

               diff = diff+occ(i_state,i_spin,i_kpt)*k_wt(i_kpt)
            end do
         end do
      end do
   case(FERMI)
      max_exp = maxexponent(mu)*log(2.0_r8)

      do i_kpt = 1,n_kpt
         do i_spin = 1,n_spin
            do i_state = 1,n_state
               arg = (eval(i_state,i_spin,i_kpt)-mu)*invert_width

               if(arg < max_exp) then
                  occ(i_state,i_spin,i_kpt) = spin_degen/(1.0_r8+exp(arg))

                  diff = diff+occ(i_state,i_spin,i_kpt)*k_wt(i_kpt)
               else
                  occ(i_state,i_spin,i_kpt) = 0.0_r8
               end if
            end do
         end do
      end do
   case(METHFESSEL_PAXTON)
      do i_kpt = 1,n_kpt
         do i_spin = 1,n_spin
            do i_state = 1,n_state
               arg = (eval(i_state,i_spin,i_kpt)-mu)*invert_width
               wt = exp(-arg**2)

               occ(i_state,i_spin,i_kpt) = 0.5_r8*(1.0_r8-erf(arg))*spin_degen

               if(ph%mu_mp_order > 0) then
                  A = -0.25_r8*INVERT_SQRT_PI
                  H_even = 1.0_r8
                  H_odd = 2.0_r8*arg

                  occ(i_state,i_spin,i_kpt) = occ(i_state,i_spin,i_kpt)&
                     +A*H_odd*wt*spin_degen
               end if

               if(ph%mu_mp_order > 1) then
                  do i_mp = 2,ph%mu_mp_order
                     A = -0.25_r8/real(i_mp,kind=r8)*A
                     H_even = 2.0_r8*arg*H_odd-2.0_r8*real(i_mp,kind=r8)*H_even
                     H_odd = 2.0_r8*arg*H_even-2.0_r8*real(i_mp+1,kind=r8)*H_odd

                     occ(i_state,i_spin,i_kpt) = occ(i_state,i_spin,i_kpt)&
                        +A*H_odd*wt*spin_degen
                  end do
               end if

               diff = diff+occ(i_state,i_spin,i_kpt)*k_wt(i_kpt)
            end do
         end do
      end do
   case(CUBIC)
      ! To have a consistent slope of the occupation function at the chemical
      ! potential, the parameters for GAUSSIAN and CUBIC should be related as:
      delta = 0.75_r8*SQRT_PI*ph%mu_width

      do i_kpt = 1,n_kpt
         do i_spin = 1,n_spin
            do i_state = 1,n_state
               arg = (eval(i_state,i_spin,i_kpt)-mu)/delta

               if(arg <= -1.0_r8) then
                  occ(i_state,i_spin,i_kpt) = spin_degen
               else if(arg >= 1.0_r8) then
                  occ(i_state,i_spin,i_kpt) = 0.0_r8
               else
                  occ(i_state,i_spin,i_kpt) = spin_degen*0.25_r8*(arg+2.0_r8)&
                     *(arg-1.0_r8)**2
               end if

               diff = diff+occ(i_state,i_spin,i_kpt)*k_wt(i_kpt)
            end do
         end do
      end do
   case(COLD)
      do i_kpt = 1,n_kpt
         do i_spin = 1,n_spin
            do i_state = 1,n_state
               arg = (eval(i_state,i_spin,i_kpt)-mu)*invert_width
               arg = arg-sqrt(0.5_r8)

               occ(i_state,i_spin,i_kpt) = (0.5_r8-erf(arg)*0.5_r8&
                  -INVERT_SQRT_PI*sqrt(0.5_r8)*exp(-arg**2))*spin_degen

               diff = diff+occ(i_state,i_spin,i_kpt)*k_wt(i_kpt)
            end do
         end do
      end do
   end select

   ! If chose to run a calculation if using a non-Aufbau occupation
   if (ph%occ_non_aufbau) then
      do i_constraints = 1, ph%n_constraints, 1
         do i_kpt = 1, n_kpt, 1
            ! Calculate an inital electron difference
            diff = diff - occ(ph%constr_state(i_constraints,i_kpt),&
               ph%constr_spin(i_constraints),i_kpt) * k_wt(i_kpt)
            ! Apply occupations from the property arrays
            occ(ph%constr_state(i_constraints,i_kpt),ph%constr_spin(i_constraints),&
               i_kpt) = ph%constr_occ(i_constraints)
            ! Check electron difference with constraint applied
            diff = diff + occ(ph%constr_state(i_constraints,i_kpt),&
               ph%constr_spin(i_constraints),i_kpt) * k_wt(i_kpt)
         end do
      end do
   end if

   diff = diff-n_electron

end subroutine

!>
!! Compute the chemical potential using a bisection algorithm.
!!
subroutine elsi_find_mu(ph,bh,n_electron,n_state,n_spin,n_kpt,k_wt,eval,occ,&
   mu_min,mu_max,mu)

   implicit none

   type(elsi_param_t), intent(in) :: ph
   type(elsi_basic_t), intent(in) :: bh
   real(kind=r8), intent(in) :: n_electron
   integer(kind=i4), intent(in) :: n_state
   integer(kind=i4), intent(in) :: n_spin
   integer(kind=i4), intent(in) :: n_kpt
   real(kind=r8), intent(in) :: k_wt(n_kpt)
   real(kind=r8), intent(in) :: eval(n_state,n_spin,n_kpt)
   real(kind=r8), intent(out) :: occ(n_state,n_spin,n_kpt)
   real(kind=r8), intent(in) :: mu_min
   real(kind=r8), intent(in) :: mu_max
   real(kind=r8), intent(out) :: mu

   real(kind=r8) :: mu_left
   real(kind=r8) :: mu_right
   real(kind=r8) :: mu_mid
   real(kind=r8) :: diff_left ! Electron count error on left bound
   real(kind=r8) :: diff_right ! Electron count error on right bound
   real(kind=r8) :: diff_mid ! Electron count error on middle point
   integer(kind=i4) :: i_step
   logical :: found_mu
   character(len=200) :: msg

   character(len=*), parameter :: caller = "elsi_find_mu"

   i_step = 0
   found_mu = .false.
   mu_left = mu_min
   mu_right = mu_max

   call elsi_check_electrons(ph,n_electron,n_state,n_spin,n_kpt,k_wt,eval,occ,&
        mu_left,diff_left)
   call elsi_check_electrons(ph,n_electron,n_state,n_spin,n_kpt,k_wt,eval,occ,&
        mu_right,diff_right)

   if(abs(diff_left) < ph%mu_tol) then
      mu = mu_left
      found_mu = .true.
   else if(abs(diff_right) < ph%mu_tol) then
      mu = mu_right
      found_mu = .true.
   end if

   do while(.not. found_mu .and. i_step < ph%mu_max_steps)
      i_step = i_step+1
      mu_mid = 0.5_r8*(mu_left+mu_right)

      call elsi_check_electrons(ph,n_electron,n_state,n_spin,n_kpt,k_wt,eval,&
           occ,mu_mid,diff_mid)

      if(abs(diff_mid) < ph%mu_tol) then
         mu = mu_mid
         found_mu = .true.
      else if(diff_mid < 0.0_r8) then
         mu_left = mu_mid
      else if(diff_mid > 0.0_r8) then
         mu_right = mu_mid
      end if
   end do

   if(found_mu) then
      call elsi_check_electrons(ph,n_electron,n_state,n_spin,n_kpt,k_wt,eval,&
           occ,mu,diff_right)
   else
      ! Use mu of the right bound...
      call elsi_check_electrons(ph,n_electron,n_state,n_spin,n_kpt,k_wt,eval,&
           occ,mu_right,diff_right)

      mu = mu_right

      ! ...with adjusted occupation numbers
      write(msg,"(A)") "Chemical potential cannot reach required accuracy"
      call elsi_say(bh,msg)
      write(msg,"(A,E12.4,A)") "| Residual error :",diff_right
      call elsi_say(bh,msg)
      write(msg,"(A)") "Error will be removed from highest occupied states"
      call elsi_say(bh,msg)

      call elsi_adjust_occ(ph,bh,n_state,n_spin,n_kpt,k_wt,eval,occ,diff_right)
   end if

end subroutine

!>
!! Cancel the small error in number of electrons.
!!
subroutine elsi_adjust_occ(ph,bh,n_state,n_spin,n_kpt,k_wt,eval,occ,diff)

   implicit none

   type(elsi_param_t), intent(in) :: ph
   type(elsi_basic_t), intent(in) :: bh
   integer(kind=i4), intent(in) :: n_state
   integer(kind=i4), intent(in) :: n_spin
   integer(kind=i4), intent(in) :: n_kpt
   real(kind=r8), intent(in) :: k_wt(n_kpt)
   real(kind=r8), intent(in) :: eval(n_state,n_spin,n_kpt)
   real(kind=r8), intent(inout) :: occ(n_state,n_spin,n_kpt)
   real(kind=r8), intent(inout) :: diff

   integer(kind=i4) :: n_total
   integer(kind=i4) :: i_state
   integer(kind=i4) :: i_kpt
   integer(kind=i4) :: i_spin
   integer(kind=i4) :: i_val

   integer(kind=i4), allocatable :: eval_tmp(:)
   real(kind=r8), allocatable :: occ_tmp(:)

   character(len=*), parameter :: caller = "elsi_adjust_occ"

   n_total = n_state*n_spin*n_kpt

   call elsi_allocate(bh,eval_tmp,n_total,"eval_tmp",caller)
   call elsi_allocate(bh,occ_tmp,n_total,"occ_tmp",caller)

   ! Put eval into a 1D array
   i_val = 0

   do i_kpt = 1,n_kpt
      do i_spin = 1,n_spin
         do i_state = 1,n_state
            i_val = i_val+1
            eval_tmp(i_val) = eval(i_state,i_spin,i_kpt)
         end do
      end do
   end do

   ! Put occ into a 1D array
   i_val = 0

   do i_kpt = 1,n_kpt
      do i_spin = 1,n_spin
         do i_state = 1,n_state
            i_val = i_val+1
            occ_tmp(i_val) = occ(i_state,i_spin,i_kpt)
         end do
      end do
   end do

   ! Remove error
   do i_val = n_total,1,-1
      i_kpt = (eval_tmp(i_val)-1)/(n_spin*n_state)+1

      if(occ_tmp(i_val) > 0.0_r8) then
         if(k_wt(i_kpt)*occ_tmp(i_val) > diff) then
            occ_tmp(i_val) = occ_tmp(i_val)-diff/k_wt(i_kpt)
            diff = 0.0_r8
         else
            diff = diff-k_wt(i_kpt)*occ_tmp(i_val)
            occ_tmp(i_val) = 0.0_r8
         end if
      end if

      if(diff <= ph%mu_tol) then
         exit
      end if
   end do

   ! Put adjusted occ back into a 3D array
   i_val = 0

   do i_kpt = 1,n_kpt
      do i_spin = 1,n_spin
         do i_state = 1,n_state
            i_val = i_val+1
            occ(i_state,i_spin,i_kpt) = occ_tmp(i_val)
         end do
      end do
   end do

   call elsi_deallocate(bh,eval_tmp,"eval_tmp")
   call elsi_deallocate(bh,occ_tmp,"occ_tmp")

end subroutine

!>
!! Compute the electronic entropy.
!!
subroutine elsi_entropy(ph,n_state,n_spin,n_kpt,k_wt,eval,occ,mu,ts)

   implicit none

   type(elsi_param_t), intent(in) :: ph !< Parameters
   integer(kind=i4), intent(in) :: n_state !< Number of states
   integer(kind=i4), intent(in) :: n_spin !< Number of spins
   integer(kind=i4), intent(in) :: n_kpt !< Number of k-points
   real(kind=r8), intent(in) :: k_wt(n_kpt) !< K-points weights
   real(kind=r8), intent(in) :: eval(n_state,n_spin,n_kpt) !< Eigenvalues
   real(kind=r8), intent(in) :: occ(n_state,n_spin,n_kpt) !< Occupation numbers
   real(kind=r8), intent(in) :: mu !< Input chemical potential
   real(kind=r8), intent(out) :: ts !< Entropy

   real(kind=r8) :: spin_degen
   real(kind=r8) :: invert_width
   real(kind=r8) :: delta
   real(kind=r8) :: pre
   real(kind=r8) :: arg
   real(kind=r8) :: wt
   real(kind=r8) :: A
   real(kind=r8) :: H_even
   real(kind=r8) :: H_odd
   integer(kind=i4) :: i_state
   integer(kind=i4) :: i_kpt
   integer(kind=i4) :: i_spin
   integer(kind=i4) :: i_mp

   real(kind=r8), parameter :: ts_thr = 1.0e-15_r8
   character(len=*), parameter :: caller = "elsi_entropy"

   invert_width = 1.0_r8/ph%mu_width
   ts = 0.0_r8
   pre = 0.0_r8

   if(.not. ph%spin_is_set) then
      if(n_spin == 2) then
         spin_degen = 1.0_r8
      else
         spin_degen = 2.0_r8
      end if
   else
      spin_degen = ph%spin_degen
   end if

   select case(ph%mu_scheme)
   case(GAUSSIAN)
      pre = 0.5_r8*spin_degen*ph%mu_width*INVERT_SQRT_PI

      do i_kpt = 1,n_kpt
         do i_spin = 1,n_spin
            do i_state = 1,n_state
               arg = (eval(i_state,i_spin,i_kpt)-mu)*invert_width
               ts = ts+exp(-arg**2)*k_wt(i_kpt)
            end do
         end do
      end do
   case(FERMI)
      pre = spin_degen*ph%mu_width

      do i_kpt = 1,n_kpt
         do i_spin = 1,n_spin
            do i_state = 1,n_state
               arg = occ(i_state,i_spin,i_kpt)/spin_degen

               if(1.0_r8-arg > ts_thr .and. arg > ts_thr) then
                  ts = ts-(arg*log(arg)+(1.0_r8-arg)*log(1.0_r8-arg))&
                     *k_wt(i_kpt)
               end if
            end do
         end do
      end do
   case(METHFESSEL_PAXTON)
      pre = 0.5_r8*spin_degen*ph%mu_width

      do i_kpt = 1,n_kpt
         do i_spin = 1,n_spin
            do i_state = 1,n_state
               arg = (eval(i_state,i_spin,i_kpt)-mu)*invert_width
               wt = exp(-arg**2)
               A = INVERT_SQRT_PI
               H_even = 1.0_r8
               H_odd = 2.0_r8*arg
               ts = ts+INVERT_SQRT_PI*wt*k_wt(i_kpt)

               do i_mp = 1,ph%mu_mp_order
                  A = -0.25_r8/real(i_mp,kind=r8)*A
                  H_even = 2.0_r8*arg*H_odd-2.0_r8*real(i_mp,kind=r8)*H_even
                  H_odd = 2.0_r8*arg*H_even-2.0_r8*real(i_mp+1,kind=r8)*H_odd
                  ts = ts+A*H_even*wt*k_wt(i_kpt)
               end do
            end do
         end do
      end do
   case(CUBIC)
      delta = 0.75_r8*ph%mu_width*SQRT_PI
      pre = 0.1875_r8*spin_degen*ph%mu_width

      do i_kpt = 1,n_kpt
         do i_spin = 1,n_spin
            do i_state = 1,n_state
               arg = (eval(i_state,i_spin,i_kpt)-mu)/delta

               if(arg > -1.0_r8 .and. arg < 1.0_r8) then
                  ts = ts+(((arg**2)-1.0_r8)**2)*k_wt(i_kpt)
               end if
            end do
         end do
      end do
   case(COLD)
      pre = 0.5_r8*spin_degen*ph%mu_width*INVERT_SQRT_PI

      do i_kpt = 1,n_kpt
         do i_spin = 1,n_spin
            do i_state = 1,n_state
               arg = (eval(i_state,i_spin,i_kpt)-mu)*invert_width
               ts = ts+exp(-(arg-sqrt(0.5_r8))**2)*(1.0_r8-sqrt(2.0_r8)*arg)
            end do
         end do
      end do
   end select

   ts = pre*ts

end subroutine

!>
!! Compute the occupation numbers to be used to construct density matrices.
!!
subroutine elsi_get_occ_for_dm(ph,bh,eval,occ)

   implicit none

   type(elsi_param_t), intent(inout) :: ph
   type(elsi_basic_t), intent(in) :: bh
   real(kind=r8), intent(in) :: eval(ph%n_basis)
   real(kind=r8), intent(out) :: occ(ph%n_states,ph%n_spins,ph%n_kpts)

   real(kind=r8) :: mu
   real(kind=r8) :: ts
   real(kind=r8) :: n_electrons
   integer(kind=i4) :: n_states
   integer(kind=i4) :: n_spins
   integer(kind=i4) :: n_kpts
   integer(kind=i4) :: i
   integer(kind=i4) :: ierr

   real(kind=r8), allocatable :: eval_all(:,:,:)
   real(kind=r8), allocatable :: k_wt(:)
   real(kind=r8), allocatable :: tmp1(:)
   real(kind=r8), allocatable :: tmp2(:,:,:)

   character(len=*), parameter :: caller = "elsi_get_occ_for_dm"

   ! Gather eigenvalues and occupation numbers
   call elsi_allocate(bh,eval_all,ph%n_states,ph%n_spins,ph%n_kpts,"eval_all",&
        caller)
   call elsi_allocate(bh,k_wt,ph%n_kpts,"k_wt",caller)

   if(ph%n_kpts > 1) then
      call elsi_allocate(bh,tmp1,ph%n_kpts,"tmp",caller)

      if(bh%myid == 0 .and. ph%i_spin == 1) then
         tmp1(ph%i_kpt) = ph%i_wt
      end if

      call MPI_Allreduce(tmp1,k_wt,ph%n_kpts,MPI_REAL8,MPI_SUM,bh%comm_all,ierr)

      call elsi_check_err(bh,"MPI_Allreduce",ierr,caller)

      call elsi_deallocate(bh,tmp1,"tmp")
   else
      k_wt = ph%i_wt
   end if

   if(ph%n_spins*ph%n_kpts > 1) then
      call elsi_allocate(bh,tmp2,ph%n_states,ph%n_spins,ph%n_kpts,"tmp",caller)

      if(bh%myid == 0) then
         tmp2(:,ph%i_spin,ph%i_kpt) = eval(1:ph%n_states)
      end if

      call MPI_Allreduce(tmp2,eval_all,ph%n_states*ph%n_spins*ph%n_kpts,&
           MPI_REAL8,MPI_SUM,bh%comm_all,ierr)

      call elsi_check_err(bh,"MPI_Allreduce",ierr,caller)

      call elsi_deallocate(bh,tmp2,"tmp")
   else
      eval_all(:,ph%i_spin,ph%i_kpt) = eval(1:ph%n_states)
   end if

   ! Calculate chemical potential, occupation numbers, and electronic entropy
   n_electrons = ph%n_electrons
   n_states = ph%n_states
   n_spins = ph%n_spins
   n_kpts = ph%n_kpts

   call elsi_mu_and_occ(ph,bh,n_electrons,n_states,n_spins,n_kpts,k_wt,&
        eval_all,occ,mu)

   call elsi_entropy(ph,n_states,n_spins,n_kpts,k_wt,eval_all,occ,mu,ts)

   ph%mu = mu
   ph%ts = ts

   ! Calculate band structure energy
   ph%ebs = 0.0_r8

   do i = 1,ph%n_states_solve
      ph%ebs = ph%ebs+eval(i)*occ(i,ph%i_spin,ph%i_kpt)
   end do

   call elsi_deallocate(bh,eval_all,"eval_all")
   call elsi_deallocate(bh,k_wt,"k_wt")

end subroutine

end module ELSI_OCC
