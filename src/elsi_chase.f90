module ELSI_CHASE
   use chase_diag, only: dchase, zchase, pdchase_init_blockcyclic, pzchase_init_blockcyclic, pdchase, pzchase
   use ELSI_CONSTANT, only: FC_BASIC,FC_PLUS_V
   use ELSI_DATATYPE, only: elsi_param_t,elsi_basic_t
   use ELSI_ELPA, only: elsi_elpa_tridiag
   use ELSI_MALLOC, only: elsi_allocate,elsi_deallocate
   use ELSI_OUTPUT, only: elsi_say,elsi_get_time
   use ELSI_PRECISION, only: r8,i4,i8
   use ELSI_SORT, only: elsi_heapsort,elsi_permute
  
   use ELSI_LAPACK, only: elsi_factor_ovlp_sp,elsi_reduce_evp_sp,elsi_back_ev_sp,elsi_check_ovlp_sp
   use ELSI_ELPA, only: elsi_factor_ovlp_elpa, elsi_reduce_evp_elpa, elsi_back_ev_elpa, &
                        elsi_check_ovlp_elpa, elsi_elpa_evec, elsi_elpa_setup

   implicit none
   private

   public :: elsi_solve_chase_sp
   public :: elsi_solve_chase_mp

   interface elsi_solve_chase_sp
       module procedure elsi_solve_chase_real_sp
       module procedure elsi_solve_chase_cmplx_sp
   end interface

   interface elsi_solve_chase_mp
       module procedure elsi_solve_chase_real_mp
       module procedure elsi_solve_chase_cmplx_mp
   end interface

contains

subroutine elsi_solve_chase_real_sp(ph,bh,ham,ovlp,eval,evec)
   implicit none

   type(elsi_param_t), intent(inout) :: ph
   type(elsi_basic_t), intent(in) :: bh
   real(kind=r8), intent(inout) :: ham(ph%n_basis,ph%n_basis)
   real(kind=r8), intent(inout) :: ovlp(ph%n_basis,ph%n_basis)
   real(kind=r8), intent(out) :: eval(ph%n_states)
   real(kind=r8), intent(out) :: evec(ph%n_basis,ph%n_states)

   real(kind=r8) :: t0
   real(kind=r8) :: t1
   integer(kind=i4) :: ierr
   character(len=200) :: msg

   character(len=*), parameter :: caller = "elsi_solve_chase_real_sp"
   
   !chase
   integer(kind=i4) :: nev, nex
   integer(kind=i4) :: i, j
   logical          :: isApprox
   character        :: Approx
   character        :: degOpt

   if(ph%chase_deg_opt) then
     degOpt = 'S'
   else
     degOpt = 'N'
   end if

   if(.not. ph%unit_ovlp .and. ph%ill_check) then
      call elsi_check_ovlp_sp(ph,bh,ovlp,eval,evec)
   end if
   
   nev = min(ph%n_states, ph%n_good)
   nex = min(max(int(nev * ph%chase_extra_space), ph%chase_min_extra_space), ph%n_good - nev)

   if(ph%chase_pre_n_good == ph%n_good .and. nev <= ph%chase_pre_n_states ) then
      ph%chase_started = .true.
   end if

   if(ph%chase_started .and. ph%chase_evecs_recycl) then
      isApprox = .true.
      Approx = 'A'
   else
      isApprox = .false.
      Approx = 'R'
   end if

   if(.not. ph%chase_started) then
      if(allocated(ph%pre_evec_real) ) then
         call elsi_deallocate(bh,ph%pre_evec_real,"pre_evec_real")
      end if
      call elsi_allocate(bh, ph%pre_evec_real, ph%n_good, nev+nex,&
             "pre_evec_real",caller)
   end if
   
   if(.not. ph%chase_started) then
      if(allocated(ph%pre_eval) ) then
         call elsi_deallocate(bh,ph%pre_eval,"pre_eval")
      end if           
      call elsi_allocate(bh,ph%pre_eval, nev+nex,"pre_eval",caller)
   end if

   ! Transform to standard form
   if(.not. ph%unit_ovlp) then
      if(ph%n_good == ph%n_basis) then
         ! Do Cholesky if not singular
         call elsi_factor_ovlp_sp(ph,bh,ovlp)
      end if

      call elsi_reduce_evp_sp(ph,bh,ham,ovlp,evec)
   end if
   call elsi_get_time(t0)
   ! Explicitly ensure the symmetricity of ham
   ! Required by ChASE
   do j = 1, ph%n_basis
      do i = 1,j
           ham(j, i) = ham(i, j)
      end do
   end do
   
   ! solve
   call dchase(ph%n_good, ham, ph%n_basis,ph%pre_evec_real, ph%pre_eval,nev, nex,&
               ph%chase_filter_deg, ph%chase_tol, Approx, degOpt)   

   evec(1:ph%n_good,1:nev) = ph%pre_evec_real(1:ph%n_good,1:nev)
   eval(1:nev) = ph%pre_eval(1:nev)
   
   call elsi_get_time(t1)
   write(msg,"(A)") "Finished solving standard eigenproblem"
   call elsi_say(bh,msg)
   write(msg,"(A,F10.3,A)") "| Time :",t1-t0," s"
   call elsi_say(bh,msg)

   ! Back-transform eigenvectors
   if(.not. ph%unit_ovlp) then
      call elsi_back_ev_sp(ph,bh,ovlp,evec)
   end if

   ph%chase_started = .true.
   ph%chase_pre_n_good = ph%n_good
   ph%chase_pre_n_states = nev

   ! Switch back to full dimension in case of frozen core
   if(ph%n_basis_c > 0) then
      ph%n_basis = ph%n_basis_v+ph%n_basis_c
      ph%n_states = ph%n_states+ph%n_basis_c
      ph%n_good = ph%n_good+ph%n_basis_c
      ph%n_states_solve = ph%n_states_solve+ph%n_basis_c
   end if
   
end subroutine         

subroutine elsi_solve_chase_cmplx_sp(ph,bh,ham,ovlp,eval,evec)
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

   character(len=*), parameter :: caller = "elsi_solve_chase_cmplx_sp"

   !chase
   integer(kind=i4) :: nev, nex
   integer(kind=i4) :: i, j
   complex(kind=r8) :: v
   logical          :: isApprox
   character        :: Approx
   character        :: degOpt

   if(ph%chase_deg_opt) then
     degOpt = 'S'
   else
     degOpt = 'N'
   end if

   v = (0.5_r8, 0.0_r8)

   ! Ill-conditioning check
   if(.not. ph%unit_ovlp .and. ph%ill_check) then
      call elsi_check_ovlp_sp(ph,bh,ovlp,eval,evec)
   end if

   nev = min(ph%n_states, ph%n_good)
   nex = min(max(int(nev * ph%chase_extra_space), ph%chase_min_extra_space), ph%n_good - nev)
 
   if(ph%chase_pre_n_good == ph%n_good .and. nev <= ph%chase_pre_n_states ) then
      ph%chase_started = .true.
   end if        

   if(ph%chase_started .and. ph%chase_evecs_recycl) then   
      isApprox = .true.
      Approx = 'A'
   else
      isApprox = .false.
      Approx = 'R'
   end if

   if(.not. ph%chase_started) then
      if(allocated(ph%pre_evec_cmplx) ) then
         call elsi_deallocate(bh,ph%pre_evec_cmplx,"pre_evec_cmplx")
      end if
      call elsi_allocate(bh, ph%pre_evec_cmplx, ph%n_good, nev+nex,&
             "pre_evec_cmplx",caller)
   end if

   if(.not. ph%chase_started) then
      if(allocated(ph%pre_eval)  ) then
         call elsi_deallocate(bh,ph%pre_eval,"pre_eval")
      end if
      call elsi_allocate(bh,ph%pre_eval, nev+nex,"pre_eval",caller)
   end if

   ! Transform to standard form
   if(.not. ph%unit_ovlp) then
      if(ph%n_good == ph%n_basis) then
         ! Do Cholesky if not singular
         call elsi_factor_ovlp_sp(ph,bh,ovlp)
      end if

      call elsi_reduce_evp_sp(ph,bh,ham,ovlp,evec)
   end if

   call elsi_get_time(t0)
   ! Explicitly ensure the hermeticity of ham
   ! Required by ChASE
   do j = 1, ph%n_basis
      do i = 1, j
         ham(j, i) = conjg(ham(i,j))
      end do
   end do
   ! solve
   call zchase(ph%n_good, ham, ph%n_basis,ph%pre_evec_cmplx, ph%pre_eval,nev, nex, &
               ph%chase_filter_deg, ph%chase_tol, Approx, degOpt)

   evec(1:ph%n_good,1:nev) = ph%pre_evec_cmplx(1:ph%n_good,1:nev)
   eval(1:nev) = ph%pre_eval(1:nev)

   call elsi_get_time(t1)
   write(msg,"(A)") "Finished solving standard eigenproblem"
   call elsi_say(bh,msg)
   write(msg,"(A,F10.3,A)") "| Time :",t1-t0," s"
   call elsi_say(bh,msg)
   
   ! Back-transform eigenvectors
   if(.not. ph%unit_ovlp) then
      call elsi_back_ev_sp(ph,bh,ovlp,evec)
   end if

   ph%chase_started = .true.
   ph%chase_pre_n_good = ph%n_good
   ph%chase_pre_n_states = nev

   ! Switch back to full dimension in case of frozen core
   if(ph%n_basis_c > 0) then
      ph%n_basis = ph%n_basis_v+ph%n_basis_c
      ph%n_states = ph%n_states+ph%n_basis_c
      ph%n_good = ph%n_good+ph%n_basis_c
      ph%n_states_solve = ph%n_states_solve+ph%n_basis_c
   end if
end subroutine


subroutine elsi_solve_chase_real_mp(ph,bh,ham,ovlp,eval,evec)

   implicit none

   type(elsi_param_t), intent(inout) :: ph
   type(elsi_basic_t), intent(inout) :: bh
   real(kind=r8), intent(inout) :: ham(bh%n_lrow,bh%n_lcol)
   real(kind=r8), intent(inout) :: ovlp(bh%n_lrow,bh%n_lcol)
   real(kind=r8), intent(out) :: eval(ph%n_basis)
   real(kind=r8), intent(out) :: evec(bh%n_lrow,bh%n_lcol)

   real(kind=r8) :: t0
   real(kind=r8) :: t1
   integer(kind=i4) :: ierr
   character(len=200) :: msg

   integer(kind=i4), external :: numroc

   character(len=*), parameter :: caller = "elsi_solve_chase_real_mp"   

   !chase
   integer(kind=i4) :: nev, nex
   integer(kind=i4) :: i, j
   logical          :: isApprox
   character        :: Approx
   integer(kind=i4) :: desc_ev(9)
   real(kind=r8) :: v
   character        :: degOpt

   if(ph%chase_deg_opt) then
     degOpt = 'S'
   else
     degOpt = 'N'
   end if

   v = 0.5_r8

   ! Ill-conditioning check
   if(.not. ph%unit_ovlp .and. ph%elpa_first .and. ph%ill_check) then
      call elsi_check_ovlp_elpa(ph,bh,ovlp,eval,evec)
   end if
   
   nev = min(ph%n_states, ph%n_good)
   nex = min(max(int(nev * ph%chase_extra_space), ph%chase_min_extra_space), ph%n_good - nev)

   if(ph%chase_pre_n_good == ph%n_good .and. nev <= ph%chase_pre_n_states ) then
      ph%chase_started = .true.
   end if

   if(ph%chase_started .and. ph%chase_evecs_recycl) then   
      isApprox = .true.
      Approx = 'A'
   else
      isApprox = .false.
      Approx = 'R'
   end if

   if(.not. ph%chase_started) then
      if(allocated(ph%pre_evec_real) ) then
         call elsi_deallocate(bh,ph%pre_evec_real,"pre_evec_real")
      end if           
      call elsi_allocate(bh, ph%pre_evec_real, ph%n_good, nev+nex,&
             "pre_evec_real",caller)
   end if

   if(.not. ph%chase_started) then
      if(allocated(ph%pre_eval) ) then
         call elsi_deallocate(bh,ph%pre_eval,"pre_eval")
      end if           
      call elsi_allocate(bh,ph%pre_eval, nev+nex,"pre_eval",caller)
   end if

   if(.not. ph%chase_started) then
      if(allocated(ph%htmp_r) ) then
         call elsi_deallocate(bh,ph%htmp_r,"htmp_r")
      end if           
      call elsi_allocate(bh, ph%htmp_r, bh%n_lrow,bh%n_lcol, "htmp_r",caller)
   end if
   
   ! Transform to standard form
   if(.not. ph%unit_ovlp) then
      if(ph%n_good == ph%n_basis) then
        ! Do Cholesky if not singular
        if( ph%elpa_first ) then
           call elsi_factor_ovlp_elpa(ph,bh,ovlp)
        else if(.not. ph%chase_same_ovlp) then
           call elsi_factor_ovlp_elpa(ph,bh,ovlp)
        end if
      end if

      call elsi_reduce_evp_elpa(ph,bh,ham,ovlp,evec)
   end if

   call elsi_get_time(t0)
   ! Solve
   ! Explicitly ensure the symmetricity of ham
   ! Required by ChASE
   ph%htmp_r(:,:) = ham(:,:)
   call pdgeadd('T', ph%n_basis, ph%n_basis, v, ph%htmp_r, 1, 1, bh%desc, &
                 v, ham, 1, 1, bh%desc)   

   call pdchase_init_blockcyclic( bh%comm, ph%n_good, bh%blk,bh%blk, nev, nex, &
                                      bh%n_prow, bh%n_pcol, 'R', 0, 0)

   call pdchase(ham, bh%n_lrow, ph%pre_evec_real, ph%pre_eval, &
                   ph%chase_filter_deg, ph%chase_tol, Approx, degOpt )

   eval(1:nev) = ph%pre_eval(1:nev)

   ! Dummy eigenvalues for correct chemical potential, no physical meaning!
   if(ph%n_good < ph%n_basis) then
      eval(ph%n_good+1:ph%n_basis) = eval(ph%n_good)+10.0_r8
   end if

   call descinit(desc_ev,ph%n_good, nev, ph%n_good, nev, 0, 0, &
                 bh%blacs_ctxt, ph%n_basis,ierr)

   call pdgemr2d(ph%n_good, nev, ph%pre_evec_real, 1, 1, desc_ev, evec, 1, 1, bh%desc, bh%blacs_ctxt)      

   call elsi_get_time(t1)

   write(msg,"(A)") "Finished solving standard eigenproblem"
   call elsi_say(bh,msg)
   write(msg,"(A,F10.3,A)") "| Time :",t1-t0," s"
   call elsi_say(bh,msg)

   ! Back-transform eigenvectors
   if(.not. ph%unit_ovlp) then
      call elsi_back_ev_elpa(ph,bh,ham,ovlp,evec)
   end if

   ! Switch back to full dimension in case of frozen core
   if(ph%n_basis_c > 0) then
      ph%n_basis = ph%n_basis_v+ph%n_basis_c
      ph%n_states = ph%n_states+ph%n_basis_c
      ph%n_good = ph%n_good+ph%n_basis_c
      ph%n_states_solve = ph%n_states_solve+ph%n_basis_c
      bh%n_lrow = numroc(ph%n_basis,bh%blk,bh%my_prow,0,bh%n_prow)
      bh%n_lcol = numroc(ph%n_basis,bh%blk,bh%my_pcol,0,bh%n_pcol)

      call descinit(bh%desc,ph%n_basis,ph%n_basis,bh%blk,bh%blk,0,0,&
           bh%blacs_ctxt,max(1,bh%n_lrow),ierr)
   end if
   
   ph%chase_started = .true.
   ph%elpa_first = .false.
   ph%chase_pre_n_good = ph%n_good
   ph%chase_pre_n_states = nev

end subroutine

subroutine elsi_solve_chase_cmplx_mp(ph,bh,ham,ovlp,eval,evec)
   implicit none

   type(elsi_param_t), intent(inout) :: ph
   type(elsi_basic_t), intent(inout) :: bh
   complex(kind=r8), intent(inout) :: ham(bh%n_lrow,bh%n_lcol)
   complex(kind=r8), intent(inout) :: ovlp(bh%n_lrow,bh%n_lcol)
   real(kind=r8), intent(out) :: eval(ph%n_basis)
   complex(kind=r8), intent(out) :: evec(bh%n_lrow,bh%n_lcol)

   real(kind=r8) :: t0
   real(kind=r8) :: t1
   integer(kind=i4) :: ierr
   character(len=200) :: msg

   integer(kind=i4), external :: numroc

   character(len=*), parameter :: caller = "elsi_solve_chase_cmplx_mp"

   !chase
   integer(kind=i4) :: nev, nex
   integer(kind=i4) :: i, j
   integer(kind=i4) :: desc_ev(9)
   complex(kind=r8) :: v
   logical          :: isApprox
   character        :: Approx
   character        :: degOpt

   if(ph%chase_deg_opt) then
     degOpt = 'S'
   else
     degOpt = 'N'
   end if

   v = (0.5_r8, 0.0_r8)
   
   ! Ill-conditioning check
   if(.not. ph%unit_ovlp .and. ph%elpa_first .and. ph%ill_check) then
      call elsi_check_ovlp_elpa(ph,bh,ovlp,eval,evec)
   end if

   nev = min(ph%n_states, ph%n_good)
   nex = min(max(int(nev * ph%chase_extra_space), ph%chase_min_extra_space), ph%n_good - nev)

   if(ph%chase_pre_n_good == ph%n_good .and. nev <= ph%chase_pre_n_states ) then
      ph%chase_started = .true.
   end if

   if(ph%chase_started .and. ph%chase_evecs_recycl) then   
      isApprox = .true.
      Approx = 'A'
   else
      isApprox = .false.
      Approx = 'R'
   end if

   if(.not. ph%chase_started) then
      if(allocated(ph%pre_evec_cmplx) ) then
         call elsi_deallocate(bh,ph%pre_evec_cmplx,"pre_evec_cmplx")
      end if           
      call elsi_allocate(bh, ph%pre_evec_cmplx, ph%n_good, nev+nex,&
             "pre_evec_cmplx",caller)
   end if

   if(.not. ph%chase_started) then
      if(allocated(ph%pre_eval) ) then
         call elsi_deallocate(bh,ph%pre_eval,"pre_eval")
      end if           
      call elsi_allocate(bh,ph%pre_eval, nev+nex,"pre_eval",caller)
   end if

   if(.not. ph%chase_started) then
      if(allocated(ph%htmp_c) ) then
         call elsi_deallocate(bh,ph%htmp_c,"htmp_c")
      end if           
      call elsi_allocate(bh, ph%htmp_c, bh%n_lrow,bh%n_lcol, "htmp_c",caller)
   end if

   ! Transform to standard form
   if(.not. ph%unit_ovlp) then
      if(ph%n_good == ph%n_basis) then
        ! Do Cholesky if not singular
        if( ph%elpa_first ) then
           call elsi_factor_ovlp_elpa(ph,bh,ovlp)
        else if(.not. ph%chase_same_ovlp) then
           call elsi_factor_ovlp_elpa(ph,bh,ovlp)
        end if
      end if

      call elsi_reduce_evp_elpa(ph,bh,ham,ovlp,evec)
   end if

   call elsi_get_time(t0)
   ! Solve
   ! Explicitly ensure the symmetricity of ham
   ! Required by ChASE
   ph%htmp_c(:,:) = ham(:,:)
   call pzgeadd('C', ph%n_basis, ph%n_basis, v,  ph%htmp_c, 1, 1, bh%desc, &
                 v, ham, 1, 1, bh%desc)   
         
   ! Solve
   call pzchase_init_blockcyclic( bh%comm, ph%n_good, bh%blk,bh%blk, nev, nex, &
                                      bh%n_prow, bh%n_pcol, 'R', 0, 0)

   call pzchase(ham, bh%n_lrow, ph%pre_evec_cmplx, ph%pre_eval, &
                   ph%chase_filter_deg, ph%chase_tol, Approx, degOpt )

   eval(1:nev) = ph%pre_eval(1:nev)

   ! Dummy eigenvalues for correct chemical potential, no physical meaning!
   if(ph%n_good < ph%n_basis) then
      eval(ph%n_good+1:ph%n_basis) = eval(ph%n_good)+10.0_r8
   end if

   call descinit(desc_ev,ph%n_good, nev, ph%n_good, nev, 0, 0, &
                 bh%blacs_ctxt, ph%n_basis,ierr)

   call pzgemr2d(ph%n_good, nev, ph%pre_evec_cmplx, 1, 1, desc_ev, evec, 1, 1, bh%desc, bh%blacs_ctxt)

   call elsi_get_time(t1)

   write(msg,"(A)") "Finished solving standard eigenproblem"
   call elsi_say(bh,msg)
   write(msg,"(A,F10.3,A)") "| Time :",t1-t0," s"
   call elsi_say(bh,msg)

   ! Back-transform eigenvectors
   if(.not. ph%unit_ovlp) then
      call elsi_back_ev_elpa(ph,bh,ham,ovlp,evec)
   end if

   ! Switch back to full dimension in case of frozen core
   if(ph%n_basis_c > 0) then
      ph%n_basis = ph%n_basis_v+ph%n_basis_c
      ph%n_states = ph%n_states+ph%n_basis_c
      ph%n_good = ph%n_good+ph%n_basis_c
      ph%n_states_solve = ph%n_states_solve+ph%n_basis_c
      bh%n_lrow = numroc(ph%n_basis,bh%blk,bh%my_prow,0,bh%n_prow)
      bh%n_lcol = numroc(ph%n_basis,bh%blk,bh%my_pcol,0,bh%n_pcol)

      call descinit(bh%desc,ph%n_basis,ph%n_basis,bh%blk,bh%blk,0,0,&
           bh%blacs_ctxt,max(1,bh%n_lrow),ierr)
   end if

   ph%chase_started = .true.
   ph%elpa_first = .false.   
   ph%chase_pre_n_good = ph%n_good
   ph%chase_pre_n_states = nev

end subroutine


end module ELSI_CHASE
