! Copyright (c) 2015-2018, the ELSI team.
! All rights reserved.
!
! This file is part of ELSI and is distributed under the BSD 3-clause license,
! which may be found in the LICENSE file in the ELSI root directory.

!>
!! This module provides interfaces to libOMM.
!!
module ELSI_OMM

   use ELSI_CONSTANTS, only: UNSET
   use ELSI_DATATYPE, only: elsi_param_t,elsi_basic_t
   use ELSI_IO, only: elsi_say,elsi_get_time
   use ELSI_MPI, only: elsi_check_mpi,mpi_sum,mpi_integer4
   use ELSI_PRECISION, only: r8,i4
   use ELSI_UTILS, only: elsi_get_nnz
   use ELPA1, only: elpa_cholesky_real_double,elpa_cholesky_complex_double,&
       elpa_invert_trm_real_double,elpa_invert_trm_complex_double
   use MATRIXSWITCH, only: matrix,m_register_pdbc,ms_scalapack_setup,&
       m_deallocate

   implicit none

   private

   public :: elsi_init_omm
   public :: elsi_cleanup_omm
   public :: elsi_solve_omm
   public :: elsi_compute_edm_omm

   interface elsi_solve_omm
      module procedure elsi_solve_omm_real
      module procedure elsi_solve_omm_cmplx
   end interface

   interface elsi_compute_edm_omm
      module procedure elsi_compute_edm_omm_real
      module procedure elsi_compute_edm_omm_cmplx
   end interface

contains

!>
!! This routine initializes libOMM.
!!
subroutine elsi_init_omm(ph,bh)

   implicit none

   type(elsi_param_t), intent(inout) :: ph
   type(elsi_basic_t), intent(in) :: bh

   integer(kind=i4) :: ierr

   integer(kind=i4), external :: numroc

   character(len=*), parameter :: caller = "elsi_init_omm"

   if(.not. ph%omm_started) then
      call ms_scalapack_setup(bh%comm,bh%n_prow,"r",bh%blk,&
              icontxt=bh%blacs_ctxt)

      ph%omm_n_lrow = numroc(ph%omm_n_states,bh%blk,bh%my_prow,0,bh%n_prow)

      call descinit(ph%omm_desc,ph%omm_n_states,ph%n_basis,bh%blk,bh%blk,0,0,&
              bh%blacs_ctxt,max(1,ph%omm_n_lrow),ierr)

      ph%omm_started = .true.
   end if

end subroutine

!>
!! This routine interfaces to libOMM.
!!
subroutine elsi_solve_omm_real(ph,bh,ham,ovlp,coeff,dm)

   implicit none

   type(elsi_param_t), intent(inout) :: ph
   type(elsi_basic_t), intent(inout) :: bh
   real(kind=r8), intent(inout) :: ham(bh%n_lrow,bh%n_lcol)
   real(kind=r8), intent(inout) :: ovlp(bh%n_lrow,bh%n_lcol)
   real(kind=r8), intent(inout) :: coeff(ph%omm_n_lrow,bh%n_lcol)
   real(kind=r8), intent(inout) :: dm(bh%n_lrow,bh%n_lcol)

   logical :: coeff_ready
   logical :: new_ovlp
   logical :: success
   real(kind=r8) :: t0
   real(kind=r8) :: t1
   integer(kind=i4) :: ierr
   character(len=200) :: info_str

   type(matrix) :: ham_omm
   type(matrix) :: ovlp_omm
   type(matrix) :: c_omm
   type(matrix) :: dm_omm
   type(matrix) :: t_omm

   character(len=*), parameter :: caller = "elsi_solve_omm_real"

   call m_register_pdbc(ham_omm,ham,bh%desc)
   call m_register_pdbc(ovlp_omm,ovlp,bh%desc)
   call m_register_pdbc(c_omm,coeff,ph%omm_desc)
   call m_register_pdbc(dm_omm,dm,bh%desc)

   ! Compute sparsity
   if(bh%nnz_g == UNSET) then
      if(bh%nnz_l == UNSET) then
         call elsi_get_nnz(bh%def0,ham,bh%n_lrow,bh%n_lcol,bh%nnz_l)
      end if

      call MPI_Allreduce(bh%nnz_l,bh%nnz_g,1,mpi_integer4,mpi_sum,bh%comm,ierr)

      call elsi_check_mpi(bh,"MPI_Allreduce",ierr,caller)
   end if

   if(.not. ph%ovlp_is_unit) then
      if(ph%omm_flavor == 2) then
         if(ph%n_calls == 1) then
            call elsi_get_time(t0)

            ! Cholesky factorization
            success = elpa_cholesky_real_double(ph%n_basis,ovlp,bh%n_lrow,&
                         bh%blk,bh%n_lcol,ph%elpa_comm_row,ph%elpa_comm_col,&
                         .false.)

            call elsi_get_time(t1)

            write(info_str,"(2X,A)") "Finished Cholesky decomposition"
            call elsi_say(bh,info_str)
            write(info_str,"(2X,A,F10.3,A)") "| Time :",t1-t0," s"
            call elsi_say(bh,info_str)
         end if

         if(ph%omm_first) then
            success = elpa_invert_trm_real_double(ph%n_basis,ovlp,bh%n_lrow,&
                         bh%blk,bh%n_lcol,ph%elpa_comm_row,ph%elpa_comm_col,&
                         .false.)
         end if
      end if
   end if

   if(ph%n_calls == 1) then
      coeff_ready = .false.
   else
      coeff_ready = .true.
   end if

   if(ph%omm_first) then
      new_ovlp = .true.
   else
      new_ovlp = .false.
   end if

   call elsi_get_time(t0)

   write(info_str,"(2X,A)") "Starting OMM density matrix solver"
   call elsi_say(bh,info_str)

   call omm(ph%n_basis,ph%omm_n_states,ham_omm,ovlp_omm,new_ovlp,ph%ebs,dm_omm,&
           .false.,0.0_r8,c_omm,coeff_ready,t_omm,0.0_r8,ph%omm_flavor,1,1,&
           ph%omm_tol,ph%omm_output,.false.,"pddbc","lap")

   dm = ph%spin_degen*dm

   call m_deallocate(ham_omm)
   call m_deallocate(ovlp_omm)
   call m_deallocate(c_omm)
   call m_deallocate(dm_omm)

   call elsi_get_time(t1)

   write(info_str,"(2X,A)") "Finished density matrix calculation"
   call elsi_say(bh,info_str)
   write(info_str,"(2X,A,F10.3,A)") "| Time :",t1-t0," s"
   call elsi_say(bh,info_str)

   ph%omm_first = .false.

end subroutine

!>
!! This routine computes the energy-weighted density matrix.
!!
subroutine elsi_compute_edm_omm_real(ph,bh,coeff,edm)

   implicit none

   type(elsi_param_t), intent(in) :: ph
   type(elsi_basic_t), intent(in) :: bh
   real(kind=r8), intent(inout) :: coeff(ph%omm_n_lrow,bh%n_lcol)
   real(kind=r8), intent(inout) :: edm(bh%n_lrow,bh%n_lcol)

   real(kind=r8) :: t0
   real(kind=r8) :: t1
   character(len=200) :: info_str

   type(matrix) :: ham_omm
   type(matrix) :: ovlp_omm
   type(matrix) :: c_omm
   type(matrix) :: edm_omm
   type(matrix) :: t_omm

   character(len=*), parameter :: caller = "elsi_compute_edm_omm_real"

   call elsi_get_time(t0)

   call m_register_pdbc(c_omm,coeff,ph%omm_desc)
   call m_register_pdbc(edm_omm,edm,bh%desc)

   call omm(ph%n_basis,ph%omm_n_states,ham_omm,ovlp_omm,.false.,ph%ebs,edm_omm,&
           .true.,0.0_r8,c_omm,.true.,t_omm,0.0_r8,ph%omm_flavor,1,1,&
           ph%omm_tol,ph%omm_output,.false.,"pddbc","lap")

   edm = ph%spin_degen*edm

   call m_deallocate(c_omm)
   call m_deallocate(edm_omm)

   call elsi_get_time(t1)

   write(info_str,"(2X,A)") "Finished energy density matrix calculation"
   call elsi_say(bh,info_str)
   write(info_str,"(2X,A,F10.3,A)") "| Time :",t1-t0," s"
   call elsi_say(bh,info_str)

end subroutine

!>
!! This routine interfaces to libOMM.
!!
subroutine elsi_solve_omm_cmplx(ph,bh,ham,ovlp,coeff,dm)

   implicit none

   type(elsi_param_t), intent(inout) :: ph
   type(elsi_basic_t), intent(inout) :: bh
   complex(kind=r8), intent(inout) :: ham(bh%n_lrow,bh%n_lcol)
   complex(kind=r8), intent(inout) :: ovlp(bh%n_lrow,bh%n_lcol)
   complex(kind=r8), intent(inout) :: coeff(ph%omm_n_lrow,bh%n_lcol)
   complex(kind=r8), intent(inout) :: dm(bh%n_lrow,bh%n_lcol)

   logical :: coeff_ready
   logical :: new_ovlp
   logical :: success
   real(kind=r8) :: t0
   real(kind=r8) :: t1
   integer(kind=i4) :: ierr
   character(len=200) :: info_str

   type(matrix) :: ham_omm
   type(matrix) :: ovlp_omm
   type(matrix) :: c_omm
   type(matrix) :: dm_omm
   type(matrix) :: t_omm

   character(len=*), parameter :: caller = "elsi_solve_omm_cmplx"

   call m_register_pdbc(ham_omm,ham,bh%desc)
   call m_register_pdbc(ovlp_omm,ovlp,bh%desc)
   call m_register_pdbc(c_omm,coeff,ph%omm_desc)
   call m_register_pdbc(dm_omm,dm,bh%desc)

   ! Compute sparsity
   if(bh%nnz_g == UNSET) then
      if(bh%nnz_l == UNSET) then
         call elsi_get_nnz(bh%def0,ham,bh%n_lrow,bh%n_lcol,bh%nnz_l)
      end if

      call MPI_Allreduce(bh%nnz_l,bh%nnz_g,1,mpi_integer4,mpi_sum,bh%comm,ierr)

      call elsi_check_mpi(bh,"MPI_Allreduce",ierr,caller)
   end if

   if(.not. ph%ovlp_is_unit) then
      if(ph%omm_flavor == 2) then
         if(ph%n_calls == 1) then
            call elsi_get_time(t0)

            ! Cholesky factorization
            success = elpa_cholesky_complex_double(ph%n_basis,ovlp,bh%n_lrow,&
                         bh%blk,bh%n_lcol,ph%elpa_comm_row,ph%elpa_comm_col,&
                         .false.)

            call elsi_get_time(t1)

            write(info_str,"(2X,A)") "Finished Cholesky decomposition"
            call elsi_say(bh,info_str)
            write(info_str,"(2X,A,F10.3,A)") "| Time :",t1-t0," s"
            call elsi_say(bh,info_str)
         end if

         if(ph%omm_first) then
            success = elpa_invert_trm_complex_double(ph%n_basis,ovlp,bh%n_lrow,&
                         bh%blk,bh%n_lcol,ph%elpa_comm_row,ph%elpa_comm_col,&
                         .false.)
         end if
      end if
   end if

   if(ph%n_calls == 1) then
      coeff_ready = .false.
   else
      coeff_ready = .true.
   end if

   if(ph%omm_first) then
      new_ovlp = .true.
   else
      new_ovlp = .false.
   end if

   call elsi_get_time(t0)

   write(info_str,"(2X,A)") "Starting OMM density matrix solver"
   call elsi_say(bh,info_str)

   call omm(ph%n_basis,ph%omm_n_states,ham_omm,ovlp_omm,new_ovlp,ph%ebs,dm_omm,&
           .false.,0.0_r8,c_omm,coeff_ready,t_omm,0.0_r8,ph%omm_flavor,1,1,&
           ph%omm_tol,ph%omm_output,.false.,"pzdbc","lap")

   dm = ph%spin_degen*dm

   call m_deallocate(ham_omm)
   call m_deallocate(ovlp_omm)
   call m_deallocate(c_omm)
   call m_deallocate(dm_omm)

   call elsi_get_time(t1)

   write(info_str,"(2X,A)") "Finished density matrix calculation"
   call elsi_say(bh,info_str)
   write(info_str,"(2X,A,F10.3,A)") "| Time :",t1-t0," s"
   call elsi_say(bh,info_str)

   ph%omm_first = .false.

end subroutine

!>
!! This routine computes the energy-weighted density matrix.
!!
subroutine elsi_compute_edm_omm_cmplx(ph,bh,coeff,edm)

   implicit none

   type(elsi_param_t), intent(in) :: ph
   type(elsi_basic_t), intent(in) :: bh
   complex(kind=r8), intent(inout) :: coeff(ph%omm_n_lrow,bh%n_lcol)
   complex(kind=r8), intent(inout) :: edm(bh%n_lrow,bh%n_lcol)

   real(kind=r8) :: t0
   real(kind=r8) :: t1
   character(len=200) :: info_str

   type(matrix) :: ham_omm
   type(matrix) :: ovlp_omm
   type(matrix) :: c_omm
   type(matrix) :: edm_omm
   type(matrix) :: t_omm

   character(len=*), parameter :: caller = "elsi_compute_edm_omm_cmplx"

   call elsi_get_time(t0)

   call m_register_pdbc(c_omm,coeff,ph%omm_desc)
   call m_register_pdbc(edm_omm,edm,bh%desc)

   call omm(ph%n_basis,ph%omm_n_states,ham_omm,ovlp_omm,.false.,ph%ebs,edm_omm,&
           .true.,0.0_r8,c_omm,.true.,t_omm,0.0_r8,ph%omm_flavor,1,1,&
           ph%omm_tol,ph%omm_output,.false.,"pzdbc","lap")

   edm = ph%spin_degen*edm

   call m_deallocate(c_omm)
   call m_deallocate(edm_omm)

   call elsi_get_time(t1)

   write(info_str,"(2X,A)") "Finished energy density matrix calculation"
   call elsi_say(bh,info_str)
   write(info_str,"(2X,A,F10.3,A)") "| Time :",t1-t0," s"
   call elsi_say(bh,info_str)

end subroutine

!>
!! This routine cleans up libOMM.
!!
subroutine elsi_cleanup_omm(ph)

   implicit none

   type(elsi_param_t), intent(inout) :: ph

   character(len=*), parameter :: caller = "elsi_cleanup_omm"

   ph%omm_started = .false.

end subroutine

end module ELSI_OMM
