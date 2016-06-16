!Copyright (c) 2016, ELSI consortium
!All rights reserved.
!
!Redistribution and use in source and binary forms, with or without
!modification, are permitted provided that the following conditions are met:
! * Redistributions of source code must retain the above copyright
!   notice, this list of conditions and the following disclaimer.
! * Redistributions in binary form must reproduce the above copyright
!   notice, this list of conditions and the following disclaimer in the
!   documentation and/or other materials provided with the distribution.
! * Neither the name of the ELSI project nor the
!   names of its contributors may be used to endorse or promote products
!   derived from this software without specific prior written permission.
!
!THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
!AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
!IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
!DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
!FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
!DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
!SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
!CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
!OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
!OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

!> ELSI Interchange
!! This module is the actual ELSI interface, providing functions for setting up
!! and solving or circumventing an eigenvalue problem using ELPA, libOMM, PEXSI,
!! or CheSS.
!!

module ELSI

  use iso_c_binding
  use ELSI_DIMENSIONS
  use ELSI_TIMERS
  use ELSI_MPI_TOOLS
  use ELPA1
  use ELPA2
  use MatrixSwitch_wrapper
  use MatrixSwitch_wrapper_params
  use f_ppexsi_interface

  implicit none
  private

  !< Hamiltonian, overlap, density matrix, and eigenvectors
  !! are stored by MatrixSwitch

  !< libOMM: coefficient matrix, kinetic energy matrix
  type(matrix) :: Coeff_omm, T_omm
  !< ELPA: eigenvalues
  real*8, allocatable :: eigenvalues(:)
  !< PEXSI: energy density matrix, free energy density matrix
  type(matrix) :: ED_pexsi, FED_pexsi
  !< CHESS:

  !< The following variables from ELSI Dimensions are public
  public :: ELPA, LIBOMM, PEXSI, CHESS

  !< The following routines are public:
  public :: elsi_init             !< Set dimensions in code
  public :: elsi_init_from_file   !< Get dimensions from HDF5 file
  public :: elsi_set_method       !< Set method
  public :: elsi_write_evp        !< Write eigenvalue problem to HDF5
  public :: elsi_read_evp         !< Read eigenvalue problem from HDF5
  public :: elsi_customize_elpa   !< Set ELPA parameters
  public :: elsi_customize_omm    !< Set libOMM parameters
  public :: elsi_customize_pexsi  !< Set PEXSI parameters
  public :: elsi_customize_chess  !< Set CheSS parameters
  public :: elsi_get_total_energy !< Get total energy
  public :: elsi_finalize         !< Finalize ELSI
  public :: elsi_ev               !< Compute eigenvalues and eigenvectors
  public :: elsi_dm               !< Compute density matrix

contains

!>
!!  This routine initializes ELSI.
!!
subroutine elsi_init(solver,mpi_comm_world)

   implicit none

   integer, intent(in) :: solver !< ELPA, LIBOMM, PEXSI, CHESS
   integer, intent(in) :: mpi_comm_world !< MPI global communicator

!   call elsi_init_timers()
!   call elsi_start_total_time()
!   call hdf5_init()

   call elsi_set_method(solver)

   mpi_comm_global = mpi_comm_world

   call mpi_comm_rank(mpi_comm_global,myid,mpierr)
   call mpi_comm_size(mpi_comm_global,n_procs,mpierr)

end subroutine

!>
!!  This routine overrides ELPA default settings.
!!
subroutine elsi_customize_elpa(mpi_comm_row_in,mpi_comm_col_in)

   implicit none

   integer, intent(in) :: mpi_comm_row_in
   integer, intent(in) :: mpi_comm_col_in

   mpi_comm_row = mpi_comm_row_in
   mpi_comm_col = mpi_comm_col_in

   call mpi_comm_rank(mpi_comm_row,my_p_row,mpierr)
   call mpi_comm_rank(mpi_comm_col,my_p_col,mpierr)
   call mpi_comm_size(mpi_comm_row,n_p_rows,mpierr)
   call mpi_comm_size(mpi_comm_col,n_p_cols,mpierr)

end subroutine

!>
!!  This routine overrides libOMM default settings.
!!
subroutine elsi_customize_omm(scale_kinetic_in,calc_ed_in,eta_in,&
                              min_tol_in,nk_times_nspin_in,i_k_spin_in,&
                              omm_verbose_in,do_dealloc_in)

   implicit none

   real*8,  intent(in), optional :: scale_kinetic_in
   logical, intent(in), optional :: calc_ed_in
   real*8,  intent(in), optional :: eta_in
   real*8,  intent(in), optional :: min_tol_in
   integer, intent(in), optional :: nk_times_nspin_in
   integer, intent(in), optional :: i_k_spin_in
   logical, intent(in), optional :: omm_verbose_in
   logical, intent(in), optional :: do_dealloc_in

   ! Scaling of kinetic energy matrix
   scale_kinetic = scale_kinetic_in
   ! Calculate energy weigthed density matrix
   calc_ed = calc_ed_in
   ! Eigenspectrum shift parameter
   eta = eta_in
   ! Tolerance for minimization
   min_tol = min_tol_in
   ! n_k_points * n_spin
   nk_times_nspin = nk_times_nspin_in
   ! Index
   i_k_spin = i_k_spin_in
   ! OMM output
   omm_verbose = omm_verbose_in
   ! Deallocate internal storage
   do_dealloc = do_dealloc_in

end subroutine

!>
!!  This routine overrides PEXSI default settings.
!!
subroutine elsi_customize_pexsi()

   implicit none


end subroutine

!>
!!  This routine overrides CheSS default settings.
!!
subroutine elsi_customize_chess()

   implicit none


end subroutine

!>
!!  This routine sets the method.
!!
subroutine elsi_set_method(i_method)

   implicit none

   integer, intent(in) :: i_method

   method = i_method

end subroutine

!>
!!  This routine writes an eigenvalue problem to an HDF5 file.
!!
subroutine elsi_write_evp(file_name)

   implicit none
   include "mpif.h"

   character(len=*), intent(in) :: file_name !< File name where to write

   integer :: file_id  !< HDF5 File identifier
   integer :: group_id !< HDF5 Group identifier
   real*8, allocatable :: buffer(:,:) !< Read buffer for PEXSI
   character*40, parameter :: caller = "elsi_write_evp"
  
!   call elsi_start_write_evp_time()

!   if(method == PEXSI) then
!      call elsi_allocate(buffer, n_l_rows, n_l_cols, "buffer", caller) 
!   endif

!   call hdf5_create_file(file_name, mpi_comm_global, mpi_info_null, file_id)

   ! Hamiltonian
!   call hdf5_create_group(file_id, "hamiltonian", group_id)

   ! Matrix dimension
!   call hdf5_write_attribute(group_id, "n_matrix_rows", n_g_rank)
!   call hdf5_write_attribute(group_id, "n_matrix_cols", n_g_rank)

   ! Hamiltonian Write
!   call hdf5_get_scalapack_pattern()
   
!   select case (method)
!      case (ELPA,OMM)
!         call hdf5_write_matrix_parallel(group_id, "matrix", H_real)
!      case (PEXSI)
!         call elsi_ccs_to_dense(buffer, n_l_rows, n_l_cols, H_real_sparse, &
!                                n_l_nonzero, sparse_index, sparse_pointer)
!         call hdf5_write_matrix_parallel(group_id, "matrix", buffer)
!      case DEFAULT
!         call elsi_stop(" No supported method has been chosen. " &
!                        // " Please choose method CHESS, ELPA, OMM, or PEXSI. " &
!                        // " Exiting... ",caller)
!   end select

!   call hdf5_close_group(group_id)

   ! The Overlap Matrix
!   call hdf5_create_group(file_id, "overlap", group_id)
   
   ! Matrix dimension
!   call hdf5_write_attribute(group_id, "n_matrix_rows", n_g_rank)
!   call hdf5_write_attribute(group_id, "n_matrix_cols", n_g_rank)

   ! Overlap
!   select case (method)
!      case (ELPA,OMM) 
!         call hdf5_write_matrix_parallel(group_id, "matrix", S_real)
!      case (PEXSI)
!         call elsi_ccs_to_dense(buffer, n_l_rows, n_l_cols, S_real_sparse,&
!                                n_l_nonzero, sparse_index, sparse_pointer)
!         call hdf5_write_matrix_parallel(group_id, "matrix", buffer)
!      case DEFAULT
!         call elsi_stop(" No supported method has been chosen. " &
!                        // " Please choose method CHESS, ELPA, OMM, or PEXSI. " &
!                        // " Exiting... ",caller)
!   end select

!   call hdf5_close_group(group_id)
!   call hdf5_close_file(file_id)

!   call elsi_stop_write_evp_time()

!   if(allocated(buffer)) deallocate(buffer)

end subroutine

!>
!!  This routine reads an eigenvalue problem from a file.
!!
subroutine elsi_read_evp(file_name)

   implicit none
   include "mpif.h"
   
   character(len=*), intent(in) :: file_name !< File to open

   integer :: file_id  !< HDF5 File identifier
   integer :: group_id !< HDF5 Group identifier
   real*8, allocatable :: buffer(:,:) !< Read buffer for PEXSI
   character*40, parameter :: caller = "elsi_read_evp"

   ! For PEXSI we need to create a buffer
   ! we convert it directly to the CCS format

!   call elsi_start_read_evp_time()

!   if(method == PEXSI) then
!      call elsi_allocate(buffer, n_l_rows, n_l_cols, "buffer", caller) 
!   endif

!   call hdf5_open_file(file_name, mpi_comm_global, mpi_info_null, file_id)

   ! The Hamiltonian
!   call hdf5_open_group(file_id, "hamiltonian", group_id)
   
   ! Hamiltonian Read
!   call hdf5_get_scalapack_pattern()
!   select case (method)
!      case (ELPA,OMM)
!         call hdf5_read_matrix_parallel(group_id, "matrix", H_real)
!      case (PEXSI)
!         call hdf5_read_matrix_parallel(group_id, "matrix", buffer)
!         call elsi_compute_N_nonzero(buffer,n_l_rows, n_l_cols)
!         call elsi_allocate(H_real_sparse, n_l_nonzero, "H_real_sparse", caller)
!         call elsi_allocate(sparse_index, n_l_nonzero, "sparse_index", caller)
!         call elsi_allocate(sparse_pointer, n_l_cols+1, "sparse_pointer", caller)
!         call elsi_dense_to_ccs(buffer, n_l_rows, n_l_cols, H_real_sparse,&
!                                n_l_nonzero, sparse_index, sparse_pointer)
!      case DEFAULT
!         call elsi_stop(" No supported method has been chosen. " &
!                        // " Please choose method CHESS, ELPA, OMM, or PEXSI. " &
!                        // " Exiting... ",caller)
!   end select

!   call hdf5_close_group(group_id)

   ! The Overlap Matrix
!   call hdf5_open_group(file_id, "overlap", group_id)
   
   ! Overlap Read
!   select case (method)
!      case (ELPA,OMM)
!         call hdf5_read_matrix_parallel(group_id, "matrix", S_real)
!      case (PEXSI)
!         call hdf5_read_matrix_parallel(group_id, "matrix", buffer)
!         call elsi_allocate(S_real_sparse, n_l_nonzero, "S_real_sparse", caller)
!         call elsi_dense_to_ccs_by_pattern(buffer, n_l_rows, n_l_cols, S_real_sparse,&
!                                           n_l_nonzero, sparse_index, sparse_pointer)
!      case DEFAULT
!         call elsi_stop(" No supported method has been chosen. " &
!                        // " Please choose method CHESS, ELPA, OMM, or PEXSI. " &
!                        // " Exiting... ",caller)
!   end select

   ! TODO Check if overlap is unity
!   overlap_is_unity = .False.
   
!   call hdf5_close_group(group_id)
!   call hdf5_close_file(file_id)

!   if(allocated(buffer)) deallocate(buffer)

!   call elsi_stop_read_evp_time()

end subroutine

!>
!!  This routine initialize an eigenvalue problem from a file.
!!
subroutine elsi_init_from_file(file_name, block_rows, block_cols)

   implicit none
   include "mpif.h"

   character(len=*), intent(in) :: file_name !< File to open
   integer, intent(in) :: block_rows !< Block rows of matrix
   integer, intent(in) :: block_cols !< Block cols of matrix

   integer :: file_id !< HDF5 File identifier 
   integer :: group_id !< HDF5 Group identifier

   character*40, parameter :: caller = "elsi_init_from_file"

!   call elsi_start_read_evp_time()

!   n_b_rows = block_rows
!   n_b_cols = block_cols

!   if(.not. mpi_is_setup) call elsi_stop("MPI needs to be set up first!",caller)

!   call hdf5_open_file(file_name, mpi_comm_global, mpi_info_null, file_id)

   ! The Hamiltonian
!   call hdf5_open_group(file_id, "hamiltonian", group_id)

   ! Matrix dimension
!   call hdf5_read_attribute(group_id, "n_matrix_rows", n_g_rank)
!   call hdf5_read_attribute(group_id, "n_matrix_cols", n_g_rank)

!   call hdf5_close_group(group_id)
!   call hdf5_close_file(file_id)
!   call elsi_stop_read_evp_time()

end subroutine

!>
!!  This routine gets information from MatrixSwitch.
!!
subroutine elsi_get_ms_info()

   implicit none

   sc_desc  = ms_matrices(ms_lookup('H'))%iaux1
   n_g_rank = sc_desc(3)
   n_l_rows = ms_matrices(ms_lookup('H'))%iaux2(1)
   n_l_cols = ms_matrices(ms_lookup('H'))%iaux2(2)
   n_b_rows = sc_desc(5)
   n_b_cols = sc_desc(6)

end subroutine

!>
!!  This routine interfaces to ELPA.
!!
subroutine elsi_solve_evp_elpa(cholesky)

   implicit none
   include "mpif.h"

   logical, intent(in) :: cholesky ! If .true. factorize overlap

   logical :: success
   logical :: two_step_solver
   character*100, parameter :: caller = "elsi_solve_evp_elpa"

   call elsi_start_solve_evp_time()

   ! Choose 1-stage or 2-stage solver
   two_step_solver = .true.

   if(n_g_rank < 256) then
      two_step_solver = .false.
   endif

   ! Transform to standard form
   if(.not. overlap_is_unity) then
      call elsi_statement_print(" Tansforming to standard evp")
      call elsi_to_standard_evp(cholesky)
   endif

   ! Solve evp, return eigenvalues and eigenvectors
   if(two_step_solver) then ! 2-stage solver
      call elsi_statement_print(" Starting ELPA 2-stage solver")
      if(.not. ms_matrices(ms_lookup('H'))%is_real) then ! Complex
         success = solve_evp_complex_2stage(n_g_rank, n_states, &
                   ms_matrices(ms_lookup('H'))%zval, n_l_rows, &
                   eigenvalues, ms_matrices(ms_lookup('C'))%zval, &
                   n_l_rows, n_b_rows, n_l_cols, &
                   mpi_comm_row, mpi_comm_col, mpi_comm_global)
      else ! Real
         success = solve_evp_real_2stage(n_g_rank, n_states, &
                   ms_matrices(ms_lookup('H'))%dval, n_l_rows, &
                   eigenvalues, ms_matrices(ms_lookup('C'))%dval, &
                   n_l_rows, n_b_rows, n_l_cols, &
                   mpi_comm_row, mpi_comm_col, mpi_comm_global)
      endif
   else ! 1-stage solver
      call elsi_statement_print(" Starting ELPA 1-stage solver")
      if(.not. ms_matrices(ms_lookup('H'))%is_real) then ! Complex
         success = solve_evp_complex(n_g_rank, n_states, &
                   ms_matrices(ms_lookup('H'))%zval, n_l_rows, &
                   eigenvalues, ms_matrices(ms_lookup('C'))%zval, &
                   n_l_rows, n_b_rows, n_l_cols, &
                   mpi_comm_row, mpi_comm_col)
      else ! Real
         success = solve_evp_real(n_g_rank, n_states, &
                   ms_matrices(ms_lookup('H'))%dval, n_l_rows, &
                   eigenvalues, ms_matrices(ms_lookup('C'))%dval, &
                   n_l_rows, n_b_rows, n_l_cols, &
                   mpi_comm_row, mpi_comm_col)
      endif
   endif

   if(.not.success) then
      call elsi_stop(" ELPA failed when solving the eigenvalue problem. " &
                     // " Exiting... ", caller)
   endif

   ! Back-transform eigenvectors
   if(.not. overlap_is_unity) then
      call elsi_statement_print(" Transforming to original eigenvectors")
      call elsi_to_original_ev()
   endif

   call MPI_BARRIER(mpi_comm_global,mpierr)
   call elsi_stop_solve_evp_time()

end subroutine

!>
!!  This routine interfaces to libOMM.
!!
subroutine elsi_solve_evp_omm(cholesky)

   implicit none
   include "mpif.h"

   logical, intent(in) :: cholesky ! If .true. factorize overlap

   logical :: success
   character*100, parameter :: caller = "elsi_solve_evp_omm"

   call elsi_start_solve_evp_time()

   call elsi_set_omm_default_options()

   if(cholesky) then
      new_overlap = .true.
      C_matrix_initialized = .false.

      ! Cholesky
      if(.not. ms_matrices(ms_lookup('S'))%is_real) then ! Complex
         ! Compute S = (U^T)U, U -> S
         call cholesky_complex(n_g_rank, ms_matrices(ms_lookup('S'))%zval, &
                               n_l_rows, n_b_rows, n_l_cols, mpi_comm_row, &
                               mpi_comm_col, .false., success)

      else ! Real
         ! Compute S = (U^T)U, U -> S
         call cholesky_real(n_g_rank, ms_matrices(ms_lookup('S'))%dval, &
                            n_l_rows, n_b_rows, n_l_cols, mpi_comm_row, &
                            mpi_comm_col, .false., success)
      endif

   else
      new_overlap = .false.
      C_matrix_initialized = .true.
   endif

   ! Shift eigenvalue spectrum
!   call m_add(ms_matrices(ms_lookup('S')),'N',ms_matrices(ms_lookup('H')),-eta,1d0,"lap")

   call omm(n_g_rank, n_states, ms_matrices(ms_lookup('H')), ms_matrices(ms_lookup('S')), &
            new_overlap, total_energy, ms_matrices(ms_lookup('D')), calc_ED, eta, &
            Coeff_omm, C_matrix_initialized, T_omm, scale_kinetic, omm_flavour, &
            nk_times_nspin, i_k_spin, min_tol, omm_verbose, do_dealloc, "pddbc", "lap", myid)

   call MPI_BARRIER(mpi_comm_global,mpierr)
   call elsi_stop_solve_evp_time()

end subroutine

!>
!!  This routine interfaces to PEXSI.
!!
subroutine elsi_solve_evp_pexsi()

   implicit none
   include "mpif.h"

   character*100, parameter :: caller = "elsi_solve_evp_pexsi"

   call elsi_stop(" PEXSI: not yet implemented. Exiting... ", caller)

   call elsi_start_solve_evp_time()

   ! FIXME

!   if(.not. allocated(D_real_sparse))  allocate(D_real_sparse(n_l_nonzero))
!   if(.not. allocated(ED_real_sparse)) allocate(ED_real_sparse(n_l_nonzero))
!   if(.not. allocated(FD_real_sparse)) allocate(FD_real_sparse(n_l_nonzero))

   ! Set the default options
!   call elsi_set_pexsi_default_options()

   ! Load sparse matrices for PEXSI
!   if(overlap_is_unity) then
!      call f_ppexsi_load_real_symmetric_hs_matrix(pexsi_plan, pexsi_options, &
!           n_g_rank, n_g_nonzero, n_l_nonzero, n_l_cols, sparse_pointer, &
!           sparse_index, H_real_sparse, 1, S_real_sparse, pexsi_info)
!   else
!      call f_ppexsi_load_real_symmetric_hs_matrix(pexsi_plan, pexsi_options, &
!           n_g_rank, n_g_nonzero, n_l_nonzero, n_l_cols, sparse_pointer, &
!           sparse_index, H_real_sparse, 0, S_real_sparse, pexsi_info)
!   endif

!   if(pexsi_info /= 0) then
!      call elsi_stop("PEXSI was not able to load H/S matrix.",caller)
!   endif

!   ! Solve the eigenvalue problem
!   call f_ppexsi_dft_driver(pexsi_plan, pexsi_options, n_electrons, &
!        mu_Pexsi, n_electrons_pexsi, mu_min_inertia, mu_max_inertia, &
!        n_total_inertia_iter, n_total_pexsi_iter, pexsi_info)
   
!   if(pexsi_info /= 0) then
!      call elsi_stop("PEXSI DFT Driver was not able to solve the problem.",caller)
!   endif

   ! Get the results
!   call f_ppexsi_retrieve_real_symmetric_dft_matrix(pexsi_plan, &
!        D_real_sparse, ED_real_sparse, FD_real_sparse, e_tot_H, &
!        e_tot_S, f_tot, pexsi_info)

!   if(pexsi_info /= 0) then
!      call elsi_stop("PEXSI was not able to retrieve the solution.",caller)
!   endif

!   if(myid == 0) then
!      write(*,*) "Total energy (H*DM)         = ", e_tot_H
!      write(*,*) "Total energy (S*EDM)        = ", e_tot_S
!      write(*,*) "Total free energy           = ", f_tot
!   endif

   call MPI_BARRIER(mpi_comm_global,mpierr)
   call elsi_stop_solve_evp_time()

end subroutine

!>
!!  This routine interfaces to CheSS.
!!
subroutine elsi_solve_evp_chess()

   implicit none
   include "mpif.h"

   character*100, parameter :: caller = "elsi_solve_evp_chess"

   call elsi_stop(" CheSS: not yet implemented. Exiting... ", caller)

   ! TODO: implement CHESS

   call elsi_start_solve_evp_time()

   call MPI_BARRIER(mpi_comm_global,mpierr)
   call elsi_stop_solve_evp_time()

end subroutine

!>
!!  This routine gets total energy.
!!
subroutine elsi_get_total_energy(e_tot,n_occupied)

   implicit none

   real*8, intent(out) :: e_tot !< Eigenvalues
   integer, intent(in), optional :: n_occupied

   integer, parameter :: n_spin = 2 ! Only support non-spin-polarizard systems
   character*40, parameter :: caller = "elsi_get_total_energy"

   select case (method)
      case (ELPA)
         if(present(n_occupied)) then
            e_tot = n_spin * SUM(eigenvalues(1:n_occupied))
            call elsi_statement_print( " Sum of eigenvalues of occupied states")
         else
            e_tot = n_spin * SUM(eigenvalues(1:n_states))
            call elsi_statement_print( &
                 " Sum of eigenvalues of all (occupied and unoccupied) states")
         endif
      case (LIBOMM)
         e_tot = n_spin * total_energy
      case (PEXSI)
      case (CHESS)
      case DEFAULT
         call elsi_stop(" No supported method has been chosen. " &
                        // " Please choose method CHESS, ELPA, LIBOMM, or PEXSI. " &
                        // " Exiting... ", caller)
   end select

end subroutine

!>
!!  This routine gets the number of occupied states from occupation numbers.
!!
subroutine elsi_get_occupied_number(occ)

   implicit none

   real*8, intent(in) :: occ(n_states)

   integer :: i,occupied

   do i = 1,n_states,1
      if(occ(i) > 0d0) then
         occupied = i
      endif
   enddo

   n_states = occupied

end subroutine

!>
!!  This routine constructs the density matrix using eigenvectors from ELPA.
!!
subroutine elsi_compute_dm_elpa(occ)

   implicit none

   real*8, intent(in) :: occ(n_states) !< Occupation number

   real*8, allocatable :: tmp_real(:,:) !< Real eigenvectors, temporary
   complex*16, allocatable :: tmp_complex(:,:) !< Complex eigenvectors, temporary
   real*8, allocatable :: factor(:) !< Factor to construct density matrix

   ! This should be moved into elsi_mpi_tools
   integer, allocatable :: local_row(:)
   integer, allocatable :: local_col(:)
   integer :: i_col, i_row, i
   character*40, parameter :: caller = "elsi_compute_dm_elpa"

   select case (method)
      case (ELPA)
         ! Mapping of global rows/cols to local
         call elsi_allocate(local_row,n_g_rank,"local_row",caller)
         call elsi_allocate(local_col,n_g_rank,"local_col",caller)
         local_row = 0
         local_col = 0

         i_row = 0
         i_col = 0

         do i = 1,n_g_rank,1
            if(MOD((i-1)/n_b_rows,n_p_rows) == my_p_row) then
               i_row = i_row+1
               local_row(i) = i_row
            endif
            if(MOD((i-1)/n_b_cols,n_p_cols) == my_p_col) then
               i_col = i_col+1
               local_col(i) = i_col
            endif
         enddo
         
         if(ms_matrices(ms_lookup('H'))%is_real) then ! Real
            ! Get eigenvectors into tmp_real
            call elsi_allocate(tmp_real,n_l_rows,n_l_cols,"tmp_real",caller)
            tmp_real = ms_matrices(ms_lookup('C'))%dval

            ! Compute the factors used to construct density matrix
            call elsi_allocate(factor,n_states,"factor",caller)
            factor = 0d0

            do i = 1,n_states,1
               if(occ(i) > 0d0) then
                  factor(i) = sqrt(occ(i))
               endif
            enddo

            do i = 1,n_states,1
               if(factor(i) > 0d0) then
                  if(local_col(i) > 0) then
                     tmp_real(:,local_col(i)) = tmp_real(:,local_col(i)) * factor(i)
                  endif
               elseif(local_col(i) .ne. 0) then
                  tmp_real(:,local_col(i)) = 0d0
               endif
            enddo

            ! Compute density matrix
            call pdsyrk('U', 'N', n_g_rank, n_states, 1.d0, tmp_real, 1, 1, sc_desc, &
                        0.d0, ms_matrices(ms_lookup('D'))%dval, 1, sc_desc)

         else ! Complex
            ! Get eigenvectors into tmp_complex
            call elsi_allocate(tmp_complex,n_l_rows,n_l_cols,"tmp_complex",caller)
            tmp_complex = ms_matrices(ms_lookup('C'))%zval

            ! Compute the factors used to construct density matrix
            call elsi_allocate(factor,n_states,"factor",caller)
            factor = 0d0

            do i = 1,n_states,1
               if(occ(i) > 0d0) then
                  factor(i) = sqrt(occ(i))
               endif
            enddo

            do i = 1,n_states,1
               if(factor(i) > 0d0) then
                  if(local_col(i) > 0) then
                     tmp_complex(:,local_col(i)) = tmp_complex(:,local_col(i)) * factor(i)
                  endif
               elseif(local_col(i) .ne. 0) then
                  tmp_complex(:,local_col(i)) = 0d0
               endif
            enddo

            ! Compute density matrix
            call pzherk('U', 'N', n_g_rank, n_states, (1.d0,0.d0), &
                        tmp_complex, 1, 1, sc_desc, (0.d0,0.d0), &
                        ms_matrices(ms_lookup('D'))%dval, 1, 1, sc_desc)

         endif

         deallocate(local_row)
         deallocate(local_col)
         deallocate(factor)
         if(allocated(tmp_real))    deallocate(tmp_real)
         if(allocated(tmp_complex)) deallocate(tmp_complex)

      case (CHESS)
         call elsi_stop(" CHESS does not compute the density matrix from eigenvectors! " &
                        // " Exiting... ", caller)
      case (LIBOMM)
         call elsi_stop(" LIBOMM does not compute the density matrix from eigenvectors! " &
                        // " Exiting... ", caller)
      case (PEXSI)
         call elsi_stop(" PEXSI does not compute the density matrix from eigenvectors! " &
                        // " Exiting... ", caller)
      case DEFAULT
         call elsi_stop(" No supported method has been chosen. " &
                        // " Please choose method CHESS, ELPA, LIBOMM, or PEXSI. " &
                        // " Exiting... ", caller)
   end select

end subroutine

!>
!!  This routine deallocates the matrices
!!
subroutine elsi_deallocate_matrices()

   implicit none

   ! Free Memory
   if(ms_matrices(ms_lookup('H'))%is_initialized) &
      call m_deallocate('H')

   if(ms_matrices(ms_lookup('S'))%is_initialized) &
      call m_deallocate('S')

   if(ms_matrices(ms_lookup('D'))%is_initialized) &
      call m_deallocate('D')

   if(ms_matrices(ms_lookup('C'))%is_initialized) &
      call m_deallocate('C')

   if(allocated(eigenvalues)) deallocate(eigenvalues)

!   if(Coeff_omm%is_initialized) call m_deallocate_orig(Coeff_omm)

!   if(T_omm%is_initialized) call m_deallocate_orig(T_omm)

!   CHESS
!   PEXSI

end subroutine

!>
!!  This routine finalizes ELSI.
!!
subroutine elsi_finalize()

   implicit none
   include "mpif.h"

   call MPI_BARRIER(mpi_comm_global, mpierr)

   call elsi_deallocate_matrices()

   if(method == PEXSI) call f_ppexsi_plan_finalize(pexsi_plan, pexsi_info)
   
!   call hdf5_finalize()
   
!   call elsi_stop_total_time()
!   call elsi_print_timers()

!   if(.not.external_blacs) call elsi_finalize_blacs()
!   if(.not.external_mpi)   call elsi_finalize_mpi()

end subroutine

!> 
!! This routine transforms a generalized eigenvalue problem (Ac = Bcv)
!! to standard form (A'c' = c'v)
!!
!! Starting from Hv = eSv, we first perform a Cholesky decomposition of S
!! S = (U^T)U, resulting in Hv = e(U^T)Uv
!!
!! Using 1=U^-1U we define a new standard eigenvalue problem by
!! H(U^-1)(Uv) = e(U^T)(Uv) => ((U^-1)^T)H(U^-1)(Uv) = e(Uv)
!!
!! On exit, (U^-1) is stored in S, to be used for back-transformation
!!
subroutine elsi_to_standard_evp(cholesky)

   logical, intent(in) :: cholesky !< If .True. factorize Overlap

   logical :: success !< Success flag
   real*8, allocatable :: buffer_real(:,:) !< Real valued matrix buffer
   complex*16, allocatable :: buffer_complex(:,:) !< Complex valued matrix buffer
   character*100, parameter :: caller = "elsi_to_standard_evp"

   select case (method)
      case (ELPA)
         if(.not. ms_matrices(ms_lookup('H'))%is_real) then ! Complex
            call elsi_allocate(buffer_complex, n_l_rows, n_l_cols, "buffer_complex", caller)

            if(cholesky) then
               call elsi_statement_print(" Starting Cholesky decomposition")
               ! Compute S = (U^T)U, U -> S
               call cholesky_complex(n_g_rank, ms_matrices(ms_lookup('S'))%zval, &
                                     n_l_rows, n_b_rows, n_l_cols, mpi_comm_row, &
                                     mpi_comm_col, .false., success)
               if(.not.success) then
                  call elsi_stop(" Cholesky decomposition failed. Exiting... ", caller)
               endif

               ! compute U^-1 -> S
               call invert_trm_complex(n_g_rank, ms_matrices(ms_lookup('S'))%zval, &
                                       n_l_rows, n_b_rows, n_l_cols, mpi_comm_row, &
                                       mpi_comm_col, .false., success)
               if(.not.success) then
                  call elsi_stop(" Matrix invertion failed. Exiting... ", caller)
               endif
            endif

            ! compute H(U^-1) -> buff
            call pzgemm('N','N', n_g_rank, n_g_rank, n_g_rank, 1.0d0, &
                        ms_matrices(ms_lookup('H'))%zval, 1, 1, sc_desc, &
                        ms_matrices(ms_lookup('S'))%zval, 1, 1, &
                        sc_desc, 0.0d0, buffer_complex, 1, 1, sc_desc)

            ! compute ((U^-1)^T)H by (H(U^-1))^T -> H
            call pztranc(n_g_rank, n_g_rank, 1.d0, buffer_complex, 1, 1, sc_desc, &
                         0.d0, ms_matrices(ms_lookup('H'))%zval, 1, 1, sc_desc)

            ! compute ((U^-1)^T)H(U^-1) -> H
            buffer_complex = ms_matrices(ms_lookup('H'))%zval
            call pzgemm('N','N', n_g_rank, n_g_rank, n_g_rank, 1.0d0, buffer_complex, &
                        1, 1, sc_desc, ms_matrices(ms_lookup('S'))%zval, 1, 1, sc_desc, &
                        0.0d0, ms_matrices(ms_lookup('H'))%zval, 1, 1, sc_desc)

         else ! Real
            call elsi_allocate(buffer_real, n_l_rows, n_l_cols, "buffer_real", caller)

            if(cholesky) then
               call elsi_statement_print(" Starting Cholesky decomposition")
               ! Compute S = (U^T)U, U -> S
               call cholesky_real(n_g_rank, ms_matrices(ms_lookup('S'))%dval, &
                                  n_l_rows, n_b_rows, n_l_cols, mpi_comm_row, &
                                  mpi_comm_col, .false., success)
               if(.not.success) then
                  call elsi_stop(" Cholesky decomposition failed. Exiting... ", caller)
               endif

               ! compute U^-1 -> S
               call invert_trm_real(n_g_rank, ms_matrices(ms_lookup('S'))%dval, &
                                    n_l_rows, n_b_rows, n_l_cols, mpi_comm_row, &
                                    mpi_comm_col, .false., success)
               if(.not.success) then
                  call elsi_stop(" Matrix invertion failed. Exiting... " , caller)
               endif
            endif

            ! compute H(U^-1) -> buff
            call pdgemm('N','N', n_g_rank, n_g_rank, n_g_rank, 1.0d0, &
                        ms_matrices(ms_lookup('H'))%dval, 1, 1, &
                        sc_desc, ms_matrices(ms_lookup('S'))%dval, 1, 1, &
                        sc_desc, 0.0d0, buffer_real, 1, 1, sc_desc)

            ! compute ((U^-1)^T)H by (H(U^-1))^T -> H
            call pdtran(n_g_rank, n_g_rank, 1.d0, buffer_real, 1, 1, sc_desc, &
                        0.d0, ms_matrices(ms_lookup('H'))%dval, 1, 1, sc_desc)

            ! compute ((U^-1)^T)H(U^-1) -> H
            buffer_real = ms_matrices(ms_lookup('H'))%dval
            call pdgemm('N','N', n_g_rank, n_g_rank, n_g_rank, 1.0d0, buffer_real, &
                        1, 1, sc_desc, ms_matrices(ms_lookup('S'))%dval, 1, 1, &
                        sc_desc, 0.0d0, ms_matrices(ms_lookup('H'))%dval, 1, 1, sc_desc)
         endif

      case (LIBOMM)
         call elsi_stop(" libOMM: no need to transform evp! Exiting... ", caller)
      case (PEXSI)
         call elsi_stop(" PEXSI: no need to transform evp! Exiting... ", caller)
      case (CHESS)
         call elsi_stop(" CHESS: no need to transform evp! Exiting... ", caller)
      case DEFAULT
         call elsi_stop(" No supported method has been chosen. " &
                        // " Please choose method CHESS, ELPA, LIBOMM, or PEXSI. " &
                        // " Exiting... ", caller)
   end select

   if(allocated(buffer_real))    deallocate(buffer_real)
   if(allocated(buffer_complex)) deallocate(buffer_complex)

end subroutine

!> 
!! This routine does the back-transformation of the eigenvectors in standard
!! form (A'c' = c'v) to the original generalized form (Ac = Bcv)
!!
!! v = (U^-1)v'
!!
subroutine elsi_to_original_ev()

   real*8, allocatable :: buffer_real(:,:) !< Real valued matrix buffer
   complex*16, allocatable :: buffer_complex (:,:) !< Complex valued matrix buffer
   character*100, parameter :: caller = "elsi_to_original_ev"

   select case (method)
      case (ELPA)
         if(.not. ms_matrices(ms_lookup('H'))%is_real) then ! Complex
            ! (U^-1) is stored in S after elsi_to_standard_evp
            ! C = (U^-1) * C
            call elsi_allocate(buffer_complex,n_l_rows,n_l_cols,"temp",caller)
            buffer_complex = ms_matrices(ms_lookup('C'))%zval

            call pzgemm('N', 'N', n_g_rank, n_states, n_g_rank, 1.0d0, &
                        ms_matrices(ms_lookup('S'))%zval, 1, 1, sc_desc, &
                        buffer_complex, 1, 1, sc_desc, 0.0d0, &
                        ms_matrices(ms_lookup('C'))%zval, 1, 1, sc_desc)

         else ! Real
            ! (U^-1) is stored in S after elsi_to_standard_evp
            ! C = (U^-1) * C
            call elsi_allocate(buffer_real,n_l_rows,n_l_cols,"temp",caller)
            buffer_real = ms_matrices(ms_lookup('C'))%dval
            ! method (a)
!            call pdtran(n_g_rank, n_g_rank, 1.d0, S_real, 1, 1, sc_desc, &
!                        0.d0, H_real, 1, 1, sc_desc)
!            call mult_at_b_real('L', 'N', n_g_rank, n_eigenvectors, H_real, &
!                                n_l_rows, buffer_real, n_l_rows, n_b_rows, &
!                                mpi_comm_row, mpi_comm_col, vectors_real, n_l_rows)

            ! method (b)
            call pdgemm('N', 'N', n_g_rank, n_states, n_g_rank, 1.0d0, &
                        ms_matrices(ms_lookup('S'))%dval, 1, 1, sc_desc, &
                        buffer_real, 1, 1, sc_desc, 0.0d0, &
                        ms_matrices(ms_lookup('C'))%dval, 1, 1, sc_desc)
         endif

      case (LIBOMM)
         call elsi_stop(" libOMM: no eigenvectors here! Exiting... ", caller)
      case (PEXSI)
         call elsi_stop(" PEXSI: no eigenvectors here! Exiting... ", caller)
      case (CHESS)
         call elsi_stop(" CHESS: no eigenvectors here! Exiting... ", caller)
      case DEFAULT
         call elsi_stop(" No supported method has been chosen. " &
                        // " Please choose method CHESS, ELPA, LIBOMM, or PEXSI. " &
                        // " Exiting... ", caller)
   end select

   if(allocated(buffer_real))    deallocate(buffer_real)
   if(allocated(buffer_complex)) deallocate(buffer_complex)

end subroutine

!>
!!  This routine computes eigenvalues and eigenvectors.
!!  ELPA is the only supported method.
!!
!!  This needs to be written in the case where the user needs the eigensystem
!!  but a non-ELPA method was used, that is, the code would switch over to ELPA
!!  to obtain the eigensystem from the supplied Hamiltonian and, afterward, 
!!  switch back to the original method.  The user always needs to have the
!!  option of obtaining the eigensystem because many post-processed methods
!!  depend on them (and not the density matrix!)
!!
subroutine elsi_ev(need_cholesky, n_state, e_val)

   implicit none

   logical, intent(inout) :: need_cholesky !< If .true. factorize Overlap
   integer, intent(in) :: n_state          !< Number of states
   real*8, intent(out) :: e_val(n_state)   !< Eigenvalues

   character*40, parameter :: caller = "elsi_ev"

   ! Initialize timers
   call elsi_init_timers()
   call elsi_start_total_time()

   ! For ELPA this is the number of eigenvectors, including occupied states
   ! and unoccupied states in some cases
   n_states = n_state
   ! Matrices should be ready
   if(.not. ms_matrices(ms_lookup('H'))%is_initialized) then
      call elsi_stop(" Hamiltonian not found! Exiting... ", caller)
   endif

   if(.not. ms_matrices(ms_lookup('S'))%is_initialized) then
      call elsi_stop(" Overlap not found! Exiting... ", caller)
   endif

   ! Fetch all the information from MatrixSwitch
   call elsi_get_ms_info()

   ! Here the only supported method is ELPA
   select case (method)
      case (ELPA)
         ! Allocate eigenvalues for ELPA
         call elsi_allocate(eigenvalues,n_states,"eigenvalues",caller)

         ! Solve eigenvalue problem with ELPA
         call elsi_solve_evp_elpa(need_cholesky)

      case (LIBOMM)
         call elsi_stop(" Only ELPA outputs eigenvalues and eigenvectors. " &
                        // " Choose ELPA if necessary. " &
                        // " Exiting... ", caller)
      case (PEXSI)
         call elsi_stop(" Only ELPA outputs eigenvalues and eigenvectors. " &
                        // " Choose ELPA if necessary. " &
                        // " Exiting... ", caller)
      case (CHESS)
         call elsi_stop(" Only ELPA outputs eigenvalues and eigenvectors. " &
                        // " Choose ELPA if necessary. " &
                        // " Exiting... ", caller)
      case DEFAULT
         call elsi_stop(" No supported method has been chosen. " &
                        // " Please choose method ELPA to compute eigenpairs. " &
                        // " Exiting... ", caller)
   end select

   ! Cholesky no more than once
   need_cholesky = .false.

   ! Get eigenvalues
   e_val(1:n_states) = eigenvalues(1:n_states)
   deallocate(eigenvalues)

   ! Print ELSI timing
   call elsi_stop_total_time()
   call elsi_print_timers()

end subroutine

!>
!!  This routine computes the density matrix.
!!
subroutine elsi_dm(need_cholesky, n_state, occupation)

   implicit none

   logical, intent(inout) :: need_cholesky             !< If .true. factorize Overlap
   integer, intent(in) :: n_state                      !< Number of states
   real*8, intent(in), optional :: occupation(n_state) !< Occupation number, only needed by ELPA

   character*40, parameter :: caller = "elsi_dm"

   ! Initialize timers
   call elsi_init_timers()
   call elsi_start_total_time()

   ! For libOMM, PEXSI, and CHESS, this is the number of occupied states
   ! For ELPA, this is the number of total states; the number of occupied
   ! states will be obtained from occupation numbers
   n_states = n_state

   ! Matrices should be ready
   if(.not. ms_matrices(ms_lookup('H'))%is_initialized) then
      call elsi_stop(" Hamiltonian not found! Exiting... ", caller)
   endif

   if(.not. ms_matrices(ms_lookup('S'))%is_initialized) then
      call elsi_stop(" Overlap not found! Exiting... ", caller)
   endif

   ! Fetch all the information from MatrixSwitch
   call elsi_get_ms_info()

   ! Solve eigenvalue problem
   select case (method)
      case (ELPA)
         if(present(occupation)) then ! So far so good
            ! Get the number of occupied states into n_states
            call elsi_get_occupied_number(occupation)

            ! Allocate eigenvalues for ELPA
            call elsi_allocate(eigenvalues,n_states,"eigenvalues",caller)

            ! Solve eigenvalue problem with ELPA
            call elsi_solve_evp_elpa(need_cholesky)

            ! Compute density matrix from eigenvectors
            call elsi_compute_dm_elpa(occupation)

         else ! Stop
            call elsi_stop(" ELSI is attempting to compute density matrix using ELPA. " &
                           // " Occupation numbers must be provided in this case. " &
                           // " Or, try CHESS, LIBOMM, or PEXSI. " &
                           // " Exiting... ", caller)
         endif
      case (LIBOMM)
         ! Allocate coefficient matrix for libOMM
!         if(.not. Coeff_omm%is_initialized) then
!            call m_allocate_orig(Coeff_omm,n_states,n_g_rank,'pddbc')
!         endif
         call elsi_solve_evp_omm(need_cholesky)
      case (PEXSI)
         call elsi_solve_evp_pexsi()
      case (CHESS)
         call elsi_solve_evp_chess()
      case DEFAULT
         call elsi_stop(" No supported method has been chosen. " &
                        // " Please choose method CHESS, ELPA, LIBOMM, or PEXSI. " &
                        // " Exiting... ", caller)
   end select

   ! Cholesky needs to be done no more than once
   need_cholesky = .false.

   ! Print ELSI timing
   call elsi_stop_total_time()
   call elsi_print_timers()

end subroutine

end module ELSI
