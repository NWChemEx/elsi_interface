module ELSI_CHASE
   use ELSI_DATATYPE, only: elsi_param_t,elsi_basic_t
   use ELSI_PRECISION, only: r8,i4,i8

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

   write(*,"(A)") "**Error! A ChASE stub routine was called"
   stop

end subroutine

subroutine elsi_solve_chase_cmplx_sp(ph,bh,ham,ovlp,eval,evec)
   implicit none

   type(elsi_param_t), intent(inout) :: ph
   type(elsi_basic_t), intent(in) :: bh
   complex(kind=r8), intent(inout) :: ham(ph%n_basis,ph%n_basis)
   complex(kind=r8), intent(inout) :: ovlp(ph%n_basis,ph%n_basis)
   real(kind=r8), intent(out) :: eval(ph%n_basis)
   complex(kind=r8), intent(out) :: evec(ph%n_basis,ph%n_basis)
   
   write(*,"(A)") "**Error! A ChASE stub routine was called"
   stop

end subroutine

subroutine elsi_solve_chase_real_mp(ph,bh,ham,ovlp,eval,evec)

   implicit none

   type(elsi_param_t), intent(inout) :: ph
   type(elsi_basic_t), intent(inout) :: bh
   real(kind=r8), intent(inout) :: ham(bh%n_lrow,bh%n_lcol)
   real(kind=r8), intent(inout) :: ovlp(bh%n_lrow,bh%n_lcol)
   real(kind=r8), intent(out) :: eval(ph%n_basis)
   real(kind=r8), intent(out) :: evec(bh%n_lrow,bh%n_lcol)

   write(*,"(A)") "**Error! A ChASE stub routine was called"
   stop

end subroutine

subroutine elsi_solve_chase_cmplx_mp(ph,bh,ham,ovlp,eval,evec)
   implicit none

   type(elsi_param_t), intent(inout) :: ph
   type(elsi_basic_t), intent(inout) :: bh
   complex(kind=r8), intent(inout) :: ham(bh%n_lrow,bh%n_lcol)
   complex(kind=r8), intent(inout) :: ovlp(bh%n_lrow,bh%n_lcol)
   real(kind=r8), intent(out) :: eval(ph%n_basis)
   complex(kind=r8), intent(out) :: evec(bh%n_lrow,bh%n_lcol)

   write(*,"(A)") "**Error! A ChASE stub routine was called"
   stop

end subroutine   

end module ELSI_CHASE        
