! Copyright (c) 2015-2021, the ELSI team.
! All rights reserved.
!
! This file is part of ELSI and is distributed under the BSD 3-clause license,
! which may be found in the LICENSE file in the ELSI root directory.

!>
!! This subroutine tests the occ numbers under various occupation constraints
!!
subroutine test_occ_non_aufbau(comm,mu_width)

   use ELSI
   use ELSI_MPI
   use ELSI_PRECISION, only: r8,i4

   implicit none

   integer(kind=i4), intent(in) :: comm
   integer(kind=i4) :: occ_state
   integer(kind=i4) :: occ_spin
   real(kind=r8), intent(in) :: mu_width

   integer(kind=i4) :: n_proc
   integer(kind=i4) :: nprow
   integer(kind=i4) :: npcol
   integer(kind=i4) :: myid
   integer(kind=i4) :: myprow
   integer(kind=i4) :: mypcol
   integer(kind=i4) :: ierr
   integer(kind=i4) :: blk
   integer(kind=i4) :: blacs_ctxt
   integer(kind=i4) :: n_basis
   integer(kind=i4) :: l_rows
   integer(kind=i4) :: l_cols
   integer(kind=i4) :: l_rows2
   integer(kind=i4) :: l_cols2
   integer(kind=i4) :: header(8)
   integer(kind=i4) :: i_state
   integer(kind=i4) :: i_spin
   integer(kind=i4) :: i_kpt
   integer(kind=i4) :: i_count
   integer(kind=i4) :: i_count2

   integer(kind=i4) :: n_spin
   integer(kind=i4) :: n_kpt
   real(kind=r8) :: n_electrons
   real(kind=r8), allocatable :: k_wt(:)
   real(kind=r8), allocatable :: eval(:,:,:)
   real(kind=r8), allocatable :: test_occ(:,:,:)
   real(kind=r8), allocatable  :: occ(:,:,:) !< Occupation numbers
   real(kind=r8)  :: mu !< Chemical potential

   real(kind=r8) :: tol
   real(kind=r8) :: t1
   real(kind=r8) :: t2

   logical :: file_exist
   logical :: test_1 = .false.
   logical :: test_2 = .false.
   logical :: test_3 = .false.
   logical :: test_4 = .false.

   type(elsi_handle) :: eh

   integer(kind=i4), external :: numroc

   ! Reference values
   real(kind=r8), parameter :: e_ref = 0.31442451613_r8

   character(len=*), parameter :: file_name = "elsi.in"

   call MPI_Comm_size(comm,n_proc,ierr)
   call MPI_Comm_rank(comm,myid,ierr)

   tol = 1.0e-8_r8
   header(:) = 0

   ! Single constraint test
   if(myid == 0) then
      write(*,"(2X,A)") "################################"
      write(*,"(2X,A)") "##     ELSI TEST PROGRAMS     ##"
      write(*,"(2X,A)") "##     Single Constraint      ##"
      write(*,"(2X,A)") "################################"
      write(*,*)
      write(*,*)
   end if

   n_kpt = 1
   n_spin = 1
   n_basis = 100
   n_electrons = 100

   allocate(eval(n_basis,n_spin,n_kpt))
   allocate(test_occ(n_basis,n_spin,n_kpt))
   allocate(occ(n_basis,n_spin,n_kpt))
   allocate(k_wt(n_kpt))

   do i_state = 1, n_basis
      do i_spin = 1, n_spin
         do i_kpt = 1, n_kpt
            eval(i_state,i_spin,i_kpt) = dble(i_state)
         end do
      end do
   end do

   do i_kpt = 1, n_kpt
      k_wt(i_kpt) = 1/real(n_kpt)
   end do

   eh%ph%mu_width = mu_width

   ! Initialize ELSI
   call elsi_init(eh,1,1,0,n_basis,n_electrons,n_basis)
   call elsi_set_mpi(eh,comm)

   eh%ph%occ_non_aufbau = .true.
   eh%ph%n_constraints = 1

   allocate(eh%ph%constr_state(eh%ph%n_constraints,n_kpt))
   allocate(eh%ph%constr_spin(eh%ph%n_constraints))
   allocate(eh%ph%constr_occ(eh%ph%n_constraints))

   eh%ph%constr_state(1,1) = 4
   eh%ph%constr_spin(1) = 1
   eh%ph%constr_occ(1) = 0.0

   ! Customize ELSI
   call elsi_set_output(eh,2)
   call elsi_set_output_log(eh,1)

   ! Run ELSI occupations
   call elsi_compute_mu_and_occ(eh,n_electrons,n_basis,n_spin,n_kpt,k_wt,eval,&
        occ,mu)

   ! Print out occupations
   if(myid == 0) then
      write(*,"(2X,A)") "Finished occ_non_aufbau"
      write(*,*) "#chemical potential mu", mu
      write(*,*) "# state eigenvalue occ"
      do i_state = 1, n_basis
         do i_spin = 1, n_spin
            do i_kpt = 1, n_kpt
               write(*,*) i_state, eval(i_state,i_spin,i_kpt), occ(i_state,i_spin,i_kpt)
            end do
         end do
      end do
      write(*,*)
   end if

   ! Set up test occupation array
   do i_count = 1,51
      test_occ(i_count,n_spin,n_kpt) = 2.0
   end do

   do i_count = 52,100
      test_occ(i_count,n_spin,n_kpt) = 0.0
   end do

   test_occ(eh%ph%constr_state(1,1),n_spin,n_kpt) = eh%ph%constr_occ(1)

   ! Check occupations are correct
   if (all(test_occ .eq. occ)) then
      write(*,"(2X,A)") "Pass single constraint"
      test_1 = .true.
   else
      write(*,"(2X,A)") "Fail single constraint"
   end if

   write(*,*)

   ! Finalize ELSI
   call elsi_finalize(eh)

   deallocate(eval)
   deallocate(test_occ)
   deallocate(occ)
   deallocate(k_wt)

   ! Multiple constraint test
   if(myid == 0) then
      write(*,"(2X,A)") "################################"
      write(*,"(2X,A)") "##     ELSI TEST PROGRAMS     ##"
      write(*,"(2X,A)") "##    Multiple Constraint     ##"
      write(*,"(2X,A)") "################################"
      write(*,*)
      write(*,*)
   end if

   n_kpt = 1
   n_spin = 1
   n_basis = 100
   n_electrons = 100

   allocate(eval(n_basis,n_spin,n_kpt))
   allocate(test_occ(n_basis,n_spin,n_kpt))
   allocate(occ(n_basis,n_spin,n_kpt))
   allocate(k_wt(n_kpt))
   do i_state = 1, n_basis
      do i_spin = 1, n_spin
         do i_kpt = 1, n_kpt
            eval(i_state,i_spin,i_kpt) = dble(i_state)
         end do
      end do
   end do

   do i_kpt = 1, n_kpt
      k_wt(i_kpt) = 1/real(n_kpt)
   end do

   eh%ph%mu_width = mu_width

   ! Initialize ELSI
   call elsi_init(eh,1,1,0,n_basis,n_electrons,n_basis)
   call elsi_set_mpi(eh,comm)

   eh%ph%occ_non_aufbau = .true.
   eh%ph%n_constraints = 2

   allocate(eh%ph%constr_state(eh%ph%n_constraints,n_kpt))
   allocate(eh%ph%constr_spin(eh%ph%n_constraints))
   allocate(eh%ph%constr_occ(eh%ph%n_constraints))

   ! First constraint settings
   eh%ph%constr_state(1,1) = 4
   eh%ph%constr_spin(1) = 1
   eh%ph%constr_occ(1) = 1.0
   ! Second constraint settings
   eh%ph%constr_state(2,1) = 5
   eh%ph%constr_spin(2) = 1
   eh%ph%constr_occ(2) = 1.0

   ! Customize ELSI
   call elsi_set_output(eh,2)
   call elsi_set_output_log(eh,1)

   ! Run ELSI occupations
   call elsi_compute_mu_and_occ(eh,n_electrons,n_basis,n_spin,n_kpt,k_wt,eval,&
        occ,mu)

   ! Print out occupations
   if(myid == 0) then
      write(*,"(2X,A)") "Finished occ_non_aufbau"
      write(*,*) "#chemical potential mu", mu
      write(*,*) "# state eigenvalue occ"
      do i_state = 1, n_basis
         do i_spin = 1, n_spin
            do i_kpt = 1, n_kpt
               write(*,*) i_state, eval(i_state,i_spin,i_kpt), occ(i_state,i_spin,i_kpt)
            end do
         end do
      end do
      write(*,*)
   end if

   ! Set up test occupation array
   do i_count = 1,51
      test_occ(i_count,n_spin,n_kpt) = 2.0
   end do

   do i_count = 52,100
      test_occ(i_count,n_spin,n_kpt) = 0.0
   end do

   test_occ(eh%ph%constr_state(1,1),n_spin,n_kpt) = eh%ph%constr_occ(1)
   test_occ(eh%ph%constr_state(2,1),n_spin,n_kpt) = eh%ph%constr_occ(2)

   ! Check occupations are correct
   if (all(test_occ .eq. occ)) then
      write(*,"(2X,A)") "Pass multiple constraints"
      test_2 = .true.
   else
      write(*,"(2X,A)") "Fail multiple constraints"
   end if

   write(*,*)

   ! Finalize ELSI
   call elsi_finalize(eh)

   deallocate(eval)
   deallocate(test_occ)
   deallocate(occ)
   deallocate(k_wt)

   ! Spin degenerate test
   if(myid == 0) then
      write(*,"(2X,A)") "################################"
      write(*,"(2X,A)") "##     ELSI TEST PROGRAMS     ##"
      write(*,"(2X,A)") "##       Spin degenerate      ##"
      write(*,"(2X,A)") "################################"
      write(*,*)
      write(*,*)
   end if

   n_kpt = 1
   n_spin = 2
   n_basis = 100
   n_electrons = 100

   allocate(eval(n_basis,n_spin,n_kpt))
   allocate(test_occ(n_basis,n_spin,n_kpt))
   allocate(occ(n_basis,n_spin,n_kpt))
   allocate(k_wt(n_kpt))

   do i_state = 1, n_basis
      do i_spin = 1, n_spin
         do i_kpt = 1, n_kpt
            eval(i_state,i_spin,i_kpt) = dble(i_state)
         end do
      end do
   end do

   do i_kpt = 1, n_kpt
      k_wt(i_kpt) = 1/real(n_kpt)
   end do

   eh%ph%mu_width = mu_width

   ! Initialize ELSI
   call elsi_init(eh,1,1,0,n_basis,n_electrons,n_basis)
   call elsi_set_mpi(eh,comm)

   eh%ph%occ_non_aufbau = .true.
   eh%ph%n_constraints = 1

   allocate(eh%ph%constr_state(eh%ph%n_constraints,n_kpt))
   allocate(eh%ph%constr_spin(eh%ph%n_constraints))
   allocate(eh%ph%constr_occ(eh%ph%n_constraints))

   eh%ph%n_spins = 2
   eh%ph%spin_degen = 1.d0
   eh%ph%constr_state(1,1) = 4
   eh%ph%constr_spin(1) = 1
   eh%ph%constr_occ(1) = 0.0

   ! Customize ELSI
   call elsi_set_output(eh,2)
   call elsi_set_output_log(eh,1)

   ! Run ELSI occupations
   call elsi_compute_mu_and_occ(eh,n_electrons,n_basis,n_spin,n_kpt,k_wt,eval,&
        occ,mu)

   ! Print out occupations
      if(myid == 0) then
         write(*,"(2X,A)") "Finished occ_non_aufbau"
         write(*,*) "#chemical potential mu", mu
         write(*,*) "# state eigenvalue occ"
         do i_state = 1, n_basis
            do i_spin = 1, n_spin
               do i_kpt = 1, n_kpt
                  write(*,*) i_state, eval(i_state,i_spin,i_kpt), occ(i_state,i_spin,i_kpt)
               end do
            end do
         end do
         write(*,*)
      end if
   
         ! Set up test occupation array
      do i_count = 1,50
         do i_count2 = 1,2
            test_occ(i_count,i_count2,n_kpt) = 1.0
         end do
      end do
   
      do i_count = 52,100
         do i_count2 = 1,2
            test_occ(i_count,i_count2,n_kpt) = 0.0
         end do
      end do
   
      do i_count = 1,2
         test_occ(51,i_count,n_kpt) = 0.5
      end do
   
      test_occ(eh%ph%constr_state(1,1),eh%ph%constr_spin(1),n_kpt) = eh%ph%constr_occ(1)
   
      ! Check occupations are correct
      if (all(test_occ .eq. occ)) then
         write(*,"(2X,A)") "Pass spin degenerate"
         test_3 = .true.
      else
         write(*,"(2X,A)") "Failspin degenerate"
      end if
   
      write(*,*)
   
      ! Finalize ELSI
      call elsi_finalize(eh)
   
      deallocate(eval)
      deallocate(test_occ)
      deallocate(occ)
      deallocate(k_wt)

      ! Multiple k-point test
      if(myid == 0) then
         write(*,"(2X,A)") "################################"
         write(*,"(2X,A)") "##     ELSI TEST PROGRAMS     ##"
         write(*,"(2X,A)") "##     Multiple k-points      ##"
         write(*,"(2X,A)") "################################"
         write(*,*)
         write(*,*)
      end if
   
      n_kpt = 3
      n_spin = 1
      n_basis = 100
      n_electrons = 100
   
      allocate(eval(n_basis,n_spin,n_kpt))
      allocate(test_occ(n_basis,n_spin,n_kpt))
      allocate(occ(n_basis,n_spin,n_kpt))
      allocate(k_wt(n_kpt))
   
      do i_state = 1, n_basis
         do i_spin = 1, n_spin
            do i_kpt = 1, n_kpt
               eval(i_state,i_spin,i_kpt) = dble(i_state)
            end do
         end do
      end do
   
      do i_kpt = 1, n_kpt
         k_wt(i_kpt) = 1/real(n_kpt)
      end do
   
      eh%ph%mu_width = mu_width
   
      ! Initialize ELSI
      call elsi_init(eh,1,1,0,n_basis,n_electrons,n_basis)
      call elsi_set_mpi(eh,comm)
   
      eh%ph%occ_non_aufbau = .true.
      eh%ph%n_constraints = 1
   
      allocate(eh%ph%constr_state(eh%ph%n_constraints,n_kpt))
      allocate(eh%ph%constr_spin(eh%ph%n_constraints))
      allocate(eh%ph%constr_occ(eh%ph%n_constraints))
   
      eh%ph%constr_state = 4
      eh%ph%constr_spin(1) = 1
      eh%ph%constr_occ(1) = 1.0

      ! Customize ELSI
      call elsi_set_output(eh,2)
      call elsi_set_output_log(eh,1)
   
      ! Run ELSI occupations
      call elsi_compute_mu_and_occ(eh,n_electrons,n_basis,n_spin,n_kpt,k_wt,eval,&
           occ,mu)
   
      ! Print out occupations
      if(myid == 0) then
         write(*,"(2X,A)") "Finished occ_non_aufbau"
         write(*,*) "#chemical potential mu", mu
         write(*,*) "# state eigenvalue occ"
         do i_state = 1, n_basis
            do i_spin = 1, n_spin
               do i_kpt = 1, n_kpt
                  write(*,*) i_state, eval(i_state,i_spin,i_kpt), occ(i_state,i_spin,i_kpt)
               end do
            end do
         end do
         write(*,*)
      end if
   
      ! Set up test occupation array
      do i_count = 1,50
         do i_count2 = 1,n_kpt
            test_occ(i_count,1,i_count2) = 2.0
         end do
      end do
   
      do i_count = 52,100
         do i_count2 = 1,n_kpt
            test_occ(i_count,1,i_count2) = 0.0
         end do
      end do
   
      do i_count = 1, n_kpt
         test_occ(eh%ph%constr_state(1,1),n_spin,i_count) = eh%ph%constr_occ(1)
      end do
   
      ! Check occupations are correct
      if (all(test_occ(1:50,1,1:n_kpt) .eq. occ(1:50,1,1:n_kpt))) then
         write(*,"(2X,A)") "Pass multiple k-points"
         test_4 = .true.
      else
         write(*,"(2X,A)") "Fail multiple k-points"
      end if

   write(*,*)

   ! Finalize ELSI
   call elsi_finalize(eh)

   deallocate(eval)
   deallocate(test_occ)
   deallocate(occ)
   deallocate(k_wt)

   ! Check if all tests passed or failed
   if (test_1 .and. test_2 .and. test_3 .and. test_4) then
      write(*,"(2X,A)") "Passed."
   else
      write(*,"(2X,A)") "Failed."
   end if

end subroutine