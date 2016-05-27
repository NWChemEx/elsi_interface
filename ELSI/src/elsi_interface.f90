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
!! This module is the actual ELSI Interface, providing functions for setting up
!! and solving or circumventing an eigenvalue problem using ELPA, OMM, or PEXSI
!!

module ELSI

  use iso_c_binding
  use ELSI_DIMENSIONS
  use ELSI_TIMERS
  use ELSI_MPI_TOOLS
  use ELSI_HDF5_TOOLS
  use ELSI_MATRIX_CONVERSION
  use ELPA1
  use ELPA2
  use matrixswitch
  use f_ppexsi_interface

  implicit none
  private

  !< Internal Storage
  !< Real Hamiltonian Matrix 
  real*8, target, allocatable     :: H_real_target(:,:) 
  !< Complex Hamiltonian Matrix 
  complex*16, target, allocatable :: H_complex_target(:,:) 
  !< Real Overlap Matrix
  real*8, target, allocatable     :: S_real_target(:,:)   
  !< Complex Overlap Matrix
  complex*16, target, allocatable :: S_complex_target(:,:)   
  !< Eigenvalues   
  real*8, allocatable             :: eigenvalues(:)
  !< Real Eigenvectors   
  real*8, allocatable             :: vectors_real(:,:)
  !< Complex Eigenvectors 
  complex*16, allocatable         :: vectors_complex(:,:) 

  ! Pointers
  !< Real Hamiltonian Matrix 
  real*8, pointer                 :: H_real(:,:)
  !< External Complex Hamiltonian Matrix
  complex*16, pointer             :: H_complex(:,:) 
  !< External Real Overlap Matrix
  real*8, pointer                 :: S_real(:,:)   
  !< External Complex Overlap Matrix
  complex*16, pointer             :: S_complex(:,:)
  
  !OMM
  !< OMM Hamiltonian Matrix
  type(Matrix) :: OMM_H_matrix
  !< OMM Overlap Matrix
  type(Matrix) :: OMM_S_matrix
  !< OMM coefficient Matrix
  type(Matrix) :: OMM_C_matrix
  !< OMM Density Matrix
  type(Matrix) :: OMM_D_matrix
  !< OMM Kinetic Energy Density Matrix
  type(Matrix) :: OMM_T_matrix

  !PESXI
  !< Sparse Hamiltonian
  real*8,  allocatable  :: H_real_sparse(:)
  !< Sparse Overlap 
  real*8,  allocatable  :: S_real_sparse(:)
  !< Sparse Density Matrix 
  real*8,  allocatable  :: D_real_sparse(:)
  !< Sparse Energy Density Matrix 
  real*8,  allocatable  :: ED_real_sparse(:)
  !< Sparse Free Energy Density Matrix 
  real*8,  allocatable  :: FD_real_sparse(:)
  !< Sparse Index Array
  integer, allocatable  :: sparse_index(:)
  !< Sparse Pointer Array
  integer, allocatable  :: sparse_pointer(:)
  
  !< The following variables from ELSI Dimensions are public
  public :: ELPA, OMM_DENSE, PEXSI
  public :: REAL_VALUES, COMPLEX_VALUES

  ! The following routines are public:
  public :: elsi_initialize_mpi                !< ELSI MPI initializer if not done elsewhere  
  public :: elsi_initialize_problem            !< Set dimensions in code
  public :: elsi_initialize_problem_from_file  !< Get dimensions from HDF5 file
  public :: elsi_set_method                    !< Set routine for method
  public :: elsi_set_mode                      !< Set routine for mode
  public :: elsi_allocate_matrices             !< Initialize matrices
  public :: elsi_deallocate_matrices           !< Cleanup matrix memory
  public :: elsi_set_hamiltonian               !< Set Hamilitonian by Reference
  public :: elsi_set_hamiltonian_element       !< Set Hamilitonian element
  public :: elsi_symmetrize_hamiltonian        !< Symmetrize Hamiltonian matrix
  public :: elsi_get_hamiltonian               !< Get Hamiltonian by Reference
  public :: elsi_set_overlap                   !< Set Overlap by Reference
  public :: elsi_set_overlap_element           !< Set Overlap by Reference
  public :: elsi_symmetrize_overlap            !< Symmetrize Overlap matrix
  public :: elsi_get_overlap                   !< Get Overlap by Reference
  public :: elsi_write_ev_problem              !< Write eigenvalue problem to HDF5
  public :: elsi_read_ev_problem               !< Read eigenvalue problem from HDF5
  public :: elsi_solve_ev_problem              !< Solve eigenvalue problem 
  public :: elsi_get_eigenvalues               !< Get the eigenvalues 
  public :: elsi_get_eigenvectors              !< Get the eigenvectots
  public :: elsi_get_total_energy              !< Get the sum of occupied eigenvalues 
  public :: elsi_finalize                      !< Finalize and cleanup ELSI
  public :: scalapack_dense_to_pexsi_sparse    !< Converte ScaLAPACK dense matrix to PEXSI sparse
  public :: elsi_ev_real                       !< API v1 that outputs eigenvalues and eigenvectors
  public :: elsi_ev_complex                    !< API v1 that outputs eigenvalues and eigenvectors
!  public :: elsi_dm_real                     !< API v2 that outputs density matrix
!  public :: elsi_dm_complex                  !< API v2 that outputs density matrix

  ! from other modules
  public :: elsi_initialize_blacs
  public :: elsi_get_local_dimensions
  public :: elsi_get_myid
  public :: elsi_get_global_row
  public :: elsi_get_global_col
  public :: elsi_set_mpi
  public :: elsi_set_blacs
  public :: elsi_get_global_dimensions

  interface elsi_set_hamiltonian
     module procedure elsi_set_real_hamiltonian,&
                      elsi_set_complex_hamiltonian
  end interface 

  interface elsi_set_hamiltonian_element
     module procedure elsi_set_real_hamiltonian_element,&
                      elsi_set_complex_hamiltonian_element
  end interface 

  interface elsi_get_hamiltonian
     module procedure elsi_get_real_hamiltonian,&
                      elsi_get_complex_hamiltonian
  end interface 
  
  interface elsi_set_overlap
     module procedure elsi_set_real_overlap,&
                      elsi_set_complex_overlap
  end interface 

  interface elsi_set_overlap_element
     module procedure elsi_set_real_overlap_element,&
                      elsi_set_complex_overlap_element
  end interface 

  interface elsi_get_overlap
     module procedure elsi_get_real_overlap,&
                      elsi_get_complex_overlap
  end interface

  interface elsi_get_eigenvectors
     module procedure elsi_get_real_eigenvectors,&
                      elsi_get_complex_eigenvectors
  end interface 

contains

!>
!!  This routine sets the matrix dimensions for the eigenvalue problem
!!
subroutine elsi_initialize_problem(matrixsize, block_rows, block_cols)

   implicit none

   integer, intent(in) :: matrixsize  !< Global dimension of matrix
   integer, intent(in) :: block_rows  !< Block rows of matrix
   integer, intent(in) :: block_cols  !< Block cols of matrix

   n_g_rank = matrixsize
   n_b_rows = block_rows
   n_b_cols = block_cols

end subroutine

!>
!!  This routine sets the method of choice for solving the eigenvalue problem
!!
subroutine elsi_set_method(i_method)

   implicit none

   integer, intent(in) :: i_method !< ELPA,OMM,PEXSI
   
   call elsi_initialize_timers()
   call elsi_start_total_time()
   call hdf5_initialize ()

   method = i_method
   select case (method)
      case (ELPA)
      case (OMM_DENSE)
      case (PEXSI)
      case DEFAULT
         call elsi_stop("No method has been chosen."//&
                        " Please choose method ELPA, OMM_DENSE, or PEXSI", "elsi_set_method")
   end select

end subroutine

!>
!!  This routine sets the mode of the eigenvalue solver (Real or Complex)
!!
subroutine elsi_set_mode(i_mode)

   implicit none

   integer, intent(in) :: i_mode !< REAL_VALUES,COMPLEX_VALUES

   character*40, parameter :: caller = "elsi_set_mode"

   mode = i_mode

end subroutine 

!>
!!  This routine prepares the matrices based on the dimension and method
!!  specified
subroutine elsi_allocate_matrices()

   implicit none

   character*200 :: message
   character*40, parameter :: caller = "elsi_allocate_matrices"

   select case (method)
      case (ELPA)
         call elsi_allocate(eigenvalues,n_g_rank,"eigenvalues",caller)
         select case (mode)
            case (COMPLEX_VALUES)
               call elsi_allocate(H_complex_target, n_l_rows, n_l_cols,&
                                  "H_complex_target", caller)      
               call elsi_allocate(S_complex_target, n_l_rows, n_l_cols,&
                                  "S_complex_target", caller)
               call elsi_allocate(vectors_complex, n_l_rows, n_l_cols,&
                                  "vectors_complex", caller)
               H_complex => H_complex_target
               S_complex => S_complex_target
               H_complex = CMPLX(0d0,0d0)
               S_complex = CMPLX(0d0,0d0)
               vectors_complex = CMPLX(0d0,0d0)
            case (REAL_VALUES)
               call elsi_allocate(H_real_target, n_l_rows, n_l_cols,&
                                  "H_real_target", caller)      
               call elsi_allocate(S_real_target, n_l_rows, n_l_cols,&
                                  "S_real_target", caller)
               call elsi_allocate(vectors_real, n_l_rows, n_l_cols,&
                                  "vectors_real", caller)
               H_real => H_real_target
               S_real => S_real_target
               H_real = 0d0
               S_real = 0d0
               vectors_real = 0d0
            case DEFAULT
               call elsi_stop("No mode has been chosen. "//&
                              "Please choose method REAL_VALUES or COMPLEX_VALUES",&
                              caller)
         end select
      case (OMM_DENSE)
         select case (mode)
            case (COMPLEX_VALUES)
               call elsi_allocate(H_complex_target, n_l_rows, n_l_cols,&
                                  "H_complex_target", caller)      
               call elsi_allocate(S_complex_target, n_l_rows, n_l_cols,&
                                  "S_complex_target", caller)
               call elsi_allocate(vectors_complex, n_l_rows, n_l_cols,&
                                  "vectors_complex", caller)
               H_complex => H_complex_target
               S_complex => S_complex_target
               H_complex = CMPLX(0d0,0d0)
               S_complex = CMPLX(0d0,0d0)
               call m_register_pdbc (OMM_H_matrix, H_complex, sc_desc)
               call m_register_pdbc (OMM_S_matrix, S_complex, sc_desc)
               call m_allocate (OMM_D_matrix, n_g_rank, n_g_rank, "pzdbc")
               call m_allocate (OMM_T_matrix, n_g_rank, n_g_rank, "pzdbc")

            case (REAL_VALUES)
               call elsi_allocate(H_real_target, n_l_rows, n_l_cols,&
                                  "H_real_target", caller)      
               call elsi_allocate(S_real_target, n_l_rows, n_l_cols,&
                                  "S_real_target", caller)
               call elsi_allocate(vectors_real, n_l_rows, n_l_cols,&
                                  "vectors_real", caller)
               H_real => H_real_target
               S_real => S_real_target
               H_real = 0d0
               S_real = 0d0

               call m_register_pdbc (OMM_H_matrix, H_real, sc_desc)
               call m_register_pdbc (OMM_S_matrix, S_real, sc_desc)
               call m_allocate (OMM_D_matrix, n_g_rank, n_g_rank, "pddbc")
               call m_allocate (OMM_T_matrix, n_g_rank, n_g_rank, "pddbc")

            case DEFAULT
               call elsi_stop("No mode has been chosen. "//&
                              "Please choose method REAL_VALUES or COMPLEX_VALUES",&
                              caller)
         end select

      case (PEXSI)
         select case (mode)
            case (REAL_VALUES)
               ! We do not allocate anything here, yet.
            case DEFAULT
               call elsi_stop("No mode has been chosen. "//&
                              "Please choose method REAL_VALUES or COMPLEX_VALUES",&
                              caller)
         end select

      case DEFAULT
         call elsi_stop("No method has been chosen. "//&
                        "Please choose method ELPA, OMM_DENSE, or PEXSI",&
                        caller)
   end select
end subroutine

!>
!!  This routine sets the element (i_row,i_col) real hamiltonian matrix 
!!
subroutine elsi_set_real_hamiltonian_element(element,i_row,i_col)

   implicit none

   integer, intent(in) :: i_row   !< Row position
   integer, intent(in) :: i_col   !< Col position
   real*8, intent(in)  :: element !< Value 
   character*40, parameter :: caller = "elsi_set_real_hamiltonian_element"
   
   select case (method)
      case (ELPA,OMM_DENSE)
         if(mode == REAL_VALUES) then
            if(associated(H_real)) then
               H_real(i_row,i_col) = element
            else 
               call elsi_stop("Hamiltonian not created/linked.",caller)
            endif
         else  
            call elsi_stop("Wrong mode: "//&
                 "Complex valued hamiltonian to be written in real storage",&
                 caller)
         endif
      case (PEXSI)
         call elsi_stop("PEXSI not implemented yet!",caller)
      case DEFAULT
         call elsi_stop("No method has been chosen. "//&
                        "Please choose method ELPA, OMM_DENSE, or PEXSI",&
                        caller)
   end select

end subroutine

!>
!!  This routine sets the full local real hamiltonian matrix 
!!
subroutine elsi_set_real_hamiltonian(h,n_rows,n_cols)

   implicit none

   integer, intent(in) :: n_rows !< Number of rows
   integer, intent(in) :: n_cols !< Number of cols
   real*8, target, intent(in) :: h(n_rows,n_cols) !< Hamiltonian
   character*40, parameter :: caller = "elsi_set_real_hamiltonian"

   select case (method)
      case (ELPA)
         if(mode == REAL_VALUES) then
            H_real => h      
         else  
            write(*,'(2a)') "Wrong mode:",&
                  "Complex valued hamiltonian to be written in real storage"
            stop
         end if
      case (OMM_DENSE)
         call m_register_pdbc(OMM_H_matrix,h,sc_desc)
         H_real => OMM_H_matrix%dval
      case (PEXSI)
         call elsi_stop("PEXSI not implemented yet!",caller)
      case DEFAULT
         call elsi_stop("No method has been chosen. "//&
                        "Please choose method ELPA, OMM_DENSE, or PEXSI",&
                        caller)
   end select

end subroutine

!>
!!  This routine sets the element (i_row, i_col) in the complex 
!!  hamiltonian matrix 
!!
subroutine elsi_set_complex_hamiltonian_element(element,i_row,i_col)

   implicit none

   integer, intent(in)     :: i_row   !< Row position
   integer, intent(in)     :: i_col   !< Col position
   complex*16, intent(in)  :: element !< Value
   character*40, parameter :: caller = "elsi_set_complex_hamiltonian_element"

   select case (method)
      case (ELPA,OMM_DENSE)
         if(mode == COMPLEX_VALUES) then
            H_complex(i_row,i_col) = element      
         else  
            write(*,'(2a)') "Wrong mode:",&
                  "Complex valued hamiltonian to be written in real storage"
            stop
         endif
      case (PEXSI)
         call elsi_stop("PEXSI not implemented yet!",caller)
      case DEFAULT
         call elsi_stop("No method has been chosen. "//&
                       "Please choose method ELPA, OMM_DENSE, or PEXSI",&
                       caller)
   end select

end subroutine

!>
!!  This routine sets the full complex hamiltonian matrix 
!!
subroutine elsi_set_complex_hamiltonian(h,n_rows,n_cols)

   implicit none

   integer, intent(in) :: n_rows !< Number of rows
   integer, intent(in) :: n_cols !< Number of cols
   complex*16, target, intent(in) :: h(n_rows,n_cols) !< Hamiltonian
   character*40, parameter :: caller = "elsi_set_complex_hamiltonian"

   select case (method)
      case (ELPA)
         if(mode == COMPLEX_VALUES) then
            H_complex => h      
         else  
            write(*,'(2a)') "Wrong mode:",&
                  "Real valued hamiltonian to be written in complex storage"
            stop
         endif
      case (OMM_DENSE)
         call m_register_pdbc(OMM_H_matrix,h,sc_desc)
         H_complex => OMM_H_matrix%zval
         write(*,'(a)') "OMM not implemented yet!"
         stop
      case (PEXSI)
         call elsi_stop("PEXSI not implemented yet!",caller)
      case DEFAULT
         call elsi_stop("No method has been chosen. "//&
                        "Please choose method ELPA, OMM_DENSE, or PEXSI",&
                        caller)
   end select

end subroutine

!>
!!  This routine sets the element (i_row, i_col) in the real 
!!  overlap matrix 
!!
subroutine elsi_set_real_overlap_element(element,i_row,i_col)

   implicit none

   integer, intent(in) :: i_row   !< Row position
   integer, intent(in) :: i_col   !< Col position
   real*8, intent(in)  :: element !< Value
   character*40, parameter :: caller = "elsi_set_real_overlap_element"

   select case (method)
      case (ELPA,OMM_DENSE)
         if(mode == REAL_VALUES) then
            S_real(i_row,i_col) = element      
         else  
            write(*,'(2a)') "Wrong mode:",&
                  "Complex valued overlap to be written in real storage"
            stop
         endif
      case (PEXSI)
         call elsi_stop("PEXSI not implemented yet!",caller)
      case DEFAULT
         call elsi_stop("No method has been chosen. "//&
                        "Please choose method ELPA, OMM_DENSE, or PEXSI",&
                        caller)
   end select

   overlap_is_unity = .False.

end subroutine

!>
!!  This routine symmetrizes an upper or lower triangle hamiltonian
!!
subroutine elsi_symmetrize_hamiltonian()

  implicit none

  real*8,     allocatable :: buffer_real   (:,:)
  complex*16, allocatable :: buffer_complex(:,:)
  complex*16, parameter   :: CONE = (1d0,0d0)

  integer :: l_row, l_col  !< Local matrix indices
  integer :: g_row, g_col  !< Global matrix indices

  character*40, parameter :: caller = "elsi_symmetrize_hamiltonian"

  select case (method)
     case (ELPA,OMM_DENSE)
        if(mode == REAL_VALUES) then
           call elsi_allocate(buffer_real, n_l_rows, n_l_cols,&
                              "buffer_real", caller)
           buffer_real(:,:) = H_real(:,:)
           call pdtran(n_g_rank, n_g_rank, 1.d0, buffer_real, 1, 1,&
                       sc_desc, 1.d0, H_real, 1, 1, sc_desc)
           deallocate(buffer_real)
            
           do l_row = 1, n_l_rows
              call elsi_get_global_row(g_row, l_row)
              do l_col = l_row, n_l_cols
                 call elsi_get_global_col(g_col, l_col)
                 if(g_row == g_col) then
                    H_real(l_row,l_col) = 0.5d0 * H_real(l_row,l_col)
                 endif
              enddo
           enddo

        else 
           call elsi_allocate(buffer_complex, n_l_rows, n_l_cols,&
                              "buffer_complex", caller)
           buffer_complex(:,:) = H_complex(:,:)
           call pztranc(n_g_rank, n_g_rank, CONE, buffer_complex, 1, 1,&
                        sc_desc, CONE, H_complex, 1, 1, sc_desc)
           deallocate(buffer_complex)

           do l_row = 1, n_l_rows
              call elsi_get_global_row(g_row, l_row)
              do l_col = l_row, n_l_cols
                 call elsi_get_global_col(g_col, l_col)
                 if(g_row == g_col) then
                    H_complex(l_row,l_col) = 0.5d0 * H_complex(l_row,l_col)
                 endif
              enddo
           enddo

        endif
     case (PEXSI)
        call elsi_stop("PEXSI not implemented yet!",caller)
     case DEFAULT
        call elsi_stop("No method has been chosen. "//&
                       "Please choose method ELPA, OMM_DENSE, or PEXSI",&
                       caller)
   end select

   if (allocated(buffer_real))    deallocate (buffer_real)
   if (allocated(buffer_complex)) deallocate (buffer_complex)

end subroutine 

!>
!!  This routine symmetrizes an upper or lower triangle overlap
!!
subroutine elsi_symmetrize_overlap()

  implicit none

  real*8,     allocatable :: buffer_real   (:,:)
  complex*16, allocatable :: buffer_complex(:,:)
  complex*16, parameter   :: CONE = (1d0,0d0)

  integer :: l_row, l_col  !< Local matrix indices
  integer :: g_row, g_col  !< Global matrix indices

  character*40, parameter :: caller = "elsi_symmetrize_overlap"
  
  select case (method)
     case (ELPA,OMM_DENSE)
        if(mode == REAL_VALUES) then
           call elsi_allocate(buffer_real, n_l_rows, n_l_cols,&
                             "buffer_real", caller)
           buffer_real(:,:) = S_real(:,:)
           call pdtran(n_g_rank, n_g_rank, 1.d0, buffer_real, 1, 1,&
                       sc_desc, 1.d0, S_real, 1, 1, sc_desc)
           deallocate(buffer_real)

           do l_row = 1, n_l_rows
              call elsi_get_global_row(g_row, l_row)
              do l_col = l_row, n_l_cols
                 call elsi_get_global_col(g_col, l_col)
                 if(g_row == g_col) then
                    S_real(l_row,l_col) = 0.5d0 * S_real(l_row,l_col)
                 endif
              enddo
           enddo

        else
           call elsi_allocate(buffer_complex, n_l_rows, n_l_cols,&
                              "buffer_complex", caller)
           buffer_complex(:,:) = S_complex(:,:)
           call pztranc(n_g_rank, n_g_rank, CONE, buffer_complex, 1, 1,&
                        sc_desc, CONE, S_complex, 1, 1, sc_desc)
           deallocate(buffer_complex)

           do l_row = 1, n_l_rows
              call elsi_get_global_row(g_row, l_row)
              do l_col = l_row, n_l_cols
                 call elsi_get_global_col(g_col, l_col)
                 if(g_row == g_col) then
                    S_complex(l_row,l_col) = 0.5d0 * S_complex(l_row,l_col)
                 endif
              enddo
           enddo
        endif
     case (PEXSI)
        call elsi_stop("PEXSI not implemented yet!",caller)
     case DEFAULT
        call elsi_stop("No method has been chosen. "//&
                       "Please choose method ELPA, OMM_DENSE, or PEXSI",&
                       caller)
   end select
   
   if (allocated(buffer_real))    deallocate (buffer_real)
   if (allocated(buffer_complex)) deallocate (buffer_complex)

end subroutine 

!>
!!  This routine sets the real overlap matrix
!!
subroutine elsi_set_real_overlap(s,n_rows,n_cols)

   implicit none

   integer, intent(in) :: n_rows !< Number of rows
   integer, intent(in) :: n_cols !< Number of cols
   real*8, target, intent(in) :: s(n_rows,n_cols) !< Overlap
   character*40, parameter :: caller = "elsi_set_real_overlap"

   select case (method)
      case (ELPA)
         if(mode == REAL_VALUES) then
            S_real => s      
         else  
            write(*,'(2a)') "Wrong mode:",&
                            "Complex valued overlap to be written in real storage"
            stop
         endif
      case (OMM_DENSE)
         call m_register_pdbc(OMM_S_matrix,s,sc_desc)
         S_real => OMM_S_matrix%dval
      case (PEXSI)
        call elsi_stop("PEXSI not implemented yet!",caller)
      case DEFAULT
         call elsi_stop("No method has been chosen. "//&
                        "Please choose method ELPA, OMM_DENSE, or PEXSI",&
                        caller)
   end select

   overlap_is_unity = .False.

end subroutine

!>
!!  This routine sets one element (i_row, i_col) of the complex overlap matrix
!!
subroutine elsi_set_complex_overlap_element(element,i_row,i_col)

   implicit none

   integer, intent(in)     :: i_row   !< Row position
   integer, intent(in)     :: i_col   !< Col position
   complex*16, intent(in)  :: element !< Value
   character*40, parameter :: caller = "elsi_set_complex_overlap_element"

   select case (method)
      case (ELPA,OMM_DENSE)
         if(mode == COMPLEX_VALUES) then
            S_complex(i_row,i_col) = element      
         else  
            write(*,'(2a)') "Wrong mode:",&
                  "Real valued overlap to be written in complex storage"
            stop
         endif
      case (PEXSI)
         call elsi_stop("PEXSI not implemented yet!",caller)
      case DEFAULT
         call elsi_stop("No method has been chosen. "//&
                        "Please choose method ELPA, OMM_DENSE, or PEXSI",&
                        caller)
   end select

   overlap_is_unity = .False.

end subroutine

!>
!!  This routine sets the full complex overlap matrix
!!
subroutine elsi_set_complex_overlap(s,n_rows,n_cols)

   implicit none

   integer, intent(in) :: n_rows !< Number of rows
   integer, intent(in) :: n_cols !< Number of cols
   complex*16, target, intent(in) :: s(n_rows,n_cols) !< Overlap
   character*40, parameter :: caller = "elsi_set_complex_overlap"

   select case (method)
      case (ELPA)
         if(mode == COMPLEX_VALUES) then
            S_complex => s      
         else  
            write(*,'(2a)') "Wrong mode:",&
                  " Real valued overlap to be written in complex storage"
            stop
         endif
      case (OMM_DENSE)
         call m_register_pdbc(OMM_S_matrix,s,sc_desc)
         S_complex => OMM_S_matrix%zval
      case (PEXSI)
         call elsi_stop("PEXSI not implemented yet!",caller)
      case DEFAULT
         call elsi_stop("No method has been chosen. "//&
                        "Please choose method ELPA, OMM_DENSE, or PEXSI",&
                        caller)
   end select

   overlap_is_unity = .False.

end subroutine

!>
!!  This routine gets the real hamiltonian matrix
!!
subroutine elsi_get_real_hamiltonian(h,n_rows,n_cols)

   implicit none

   integer, intent(in) :: n_rows !< Number of rows
   integer, intent(in) :: n_cols !< Number of cols
   real*8, intent(out) :: h(n_rows,n_cols) !< Hamiltonian
   character*40, parameter :: caller = "elsi_get_real_hamiltonian"

   select case (method)
      case (ELPA,OMM_DENSE)
         if(mode == REAL_VALUES) then
            h(:,:) = H_real(:,:)      
         else  
            write(*,'(2a)') "Wrong mode:",&
                  "Real valued hamiltonian to be written in complex storage"
            stop
         endif
      case (PEXSI)
         call elsi_stop("PEXSI not implemented yet!",caller)
      case DEFAULT
         call elsi_stop("No method has been chosen. "//&
                        "Please choose method ELPA, OMM_DENSE, or PEXSI",&
                        caller)
   end select

end subroutine

!>
!!  This routine gets the complex hamiltonian matrix 
!!
subroutine elsi_get_complex_hamiltonian(h,n_rows,n_cols)

   implicit none

   integer, intent(in) :: n_rows !< Number of rows
   integer, intent(in) :: n_cols !< Number of cols
   complex*16, intent(out) :: h(n_rows,n_cols) !< Hamiltonian
   character*40, parameter :: caller = "elsi_get_coomplex_hamiltonian"

   select case (method)
      case (ELPA,OMM_DENSE)
         if(mode == COMPLEX_VALUES) then
            h(:,:) = H_complex(:,:)      
         else  
            write(*,'(2a)') "Wrong mode:",&
                  "Complex valued hamiltonian to be written in real storage"
            stop
         endif
      case (PEXSI)
         call elsi_stop("PEXSI not implemented yet!",caller)
      case DEFAULT
         call elsi_stop("No method has been chosen. "//&
                        "Please choose method ELPA, OMM_DENSE, or PEXSI",&
                        caller)
   end select

end subroutine

!>
!!  This routine gets the real overlap matrix
!!
subroutine elsi_get_real_overlap(s,n_rows,n_cols)

   implicit none

   integer, intent(in) :: n_rows !< Number of rows
   integer, intent(in) :: n_cols !< Number of cols
   real*8, intent(out) :: s(n_rows,n_cols) !< Overlap
   character*40, parameter :: caller = "elsi_get_real_overlap"

   select case (method)
      case (ELPA,OMM_DENSE)
         if(mode == REAL_VALUES) then
            s(:,:) = S_real(:,:)    
         else  
            write(*,'(2a)') "Wrong mode:",&
                  "Real valued overlap to be written in complex storage"
            stop
         endif
      case (PEXSI)
         call elsi_stop("PEXSI not implemented yet!",caller)
      case DEFAULT
         call elsi_stop("No method has been chosen. "//&
                        "Please choose method ELPA, OMM_DENSE, or PEXSI",&
                        caller)
   end select

end subroutine

!>
!!  This routine gets the complex overlap matrix 
!!
subroutine elsi_get_complex_overlap(s,n_rows,n_cols)

   implicit none

   integer, intent(in) :: n_rows !< Number of rows
   integer, intent(in) :: n_cols !< Number of cols
   complex*16, intent(out) :: s(n_rows,n_cols) !< Overlap
   character*40, parameter :: caller = "elsi_get_complex_overlap"

   select case (method)
      case (ELPA,OMM_DENSE)
         if(mode == COMPLEX_VALUES) then
            s(:,:) = S_complex(:,:)      
         else  
            write(*,'(2a)') "Wrong mode:",&
                  "Complex valued overlap to be written in real storage"
            stop
         endif
      case (PEXSI)
         call elsi_stop("PEXSI not implemented yet!",caller)
      case DEFAULT
         write(*,'(2a)') "No method has been chosen. ",&
               "Please choose method ELPA, OMM_DENSE, or PEXSI"
         stop
   end select

end subroutine

!>
!!  This routine writes the complete eigenvalue problem into a file
!!
subroutine elsi_write_ev_problem(file_name)

   implicit none
   include "mpif.h"

   character(len=*), intent(in) :: file_name !< File name where to write

   integer :: file_id   !< HDF5 File identifier
   integer :: group_id  !< HDF5 Group identifier
   real*8, allocatable :: buffer(:,:) !< Read buffer for PEXSI

   character*40, parameter :: caller = "elsi_write_ev_problem"
  
   call elsi_start_write_evp_time()

   if(method == PEXSI) then
      call elsi_allocate(buffer, n_l_rows, n_l_cols, "buffer", caller) 
   endif

   call hdf5_create_file(file_name, mpi_comm_global, mpi_info_null, file_id)

   ! The Hamiltonian
   call hdf5_create_group(file_id, "hamiltonian", group_id)
   
   ! Matrix dimension
   call hdf5_write_attribute(group_id, "n_matrix_rows", n_g_rank)
   call hdf5_write_attribute(group_id, "n_matrix_cols", n_g_rank)

   ! Hamiltonian Write
   call hdf5_get_scalapack_pattern()
   
   select case (method)
      case (ELPA,OMM_DENSE)
         call hdf5_write_matrix_parallel(group_id, "matrix", H_real)
      case (PEXSI)
         call elsi_ccs_to_dense(buffer, n_l_rows, n_l_cols, H_real_sparse,&
                                n_l_nonzero, sparse_index, sparse_pointer)
         call hdf5_write_matrix_parallel(group_id, "matrix", buffer)
      case DEFAULT
         call elsi_stop("No supported method has been chosen. "&
                        // "Please choose method ELPA, OMM_DENSE, or PEXSI",&
                        caller)
   end select

   call hdf5_close_group(group_id)

   ! The Overlap Matrix
   call hdf5_create_group(file_id, "overlap", group_id)
   
   ! Matrix dimension
   call hdf5_write_attribute(group_id, "n_matrix_rows", n_g_rank)
   call hdf5_write_attribute(group_id, "n_matrix_cols", n_g_rank)

   ! Overlap Write
   select case (method)
      case (ELPA,OMM_DENSE) 
         call hdf5_write_matrix_parallel(group_id, "matrix", S_real)
      case (PEXSI)
         call elsi_ccs_to_dense(buffer, n_l_rows, n_l_cols, S_real_sparse,&
                                n_l_nonzero, sparse_index, sparse_pointer)
         call hdf5_write_matrix_parallel(group_id, "matrix", buffer)
      case DEFAULT
         call elsi_stop("No supported method has been chosen. "&
                        // "Please choose method ELPA, OMM_DENSE, or PEXSI",&
                        caller)
   end select

   call hdf5_close_group(group_id)

   call hdf5_close_file(file_id)

   call elsi_stop_write_evp_time()

   if (allocated(buffer)) deallocate (buffer)

end subroutine

!>
!!  This routine reads the eigenvalue problem from a file
!!
subroutine elsi_read_ev_problem(file_name)

   implicit none
   include "mpif.h"
   
   character(len=*), intent(in) :: file_name !< File to open

   integer :: file_id  !< HDF5 File identifier
   integer :: group_id !< HDF5 Group identifier
   real*8, allocatable :: buffer(:,:) !< Read buffer for PEXSI
  
   character*40, parameter :: caller = "elsi_read_ev_problem"

   ! For Pexsi we need to create a buffer 
   ! we convert it directly to the CCS format

   call elsi_start_read_evp_time()

   if(method == PEXSI) then
      call elsi_allocate(buffer, n_l_rows, n_l_cols, "buffer", caller) 
   endif

   call hdf5_open_file(file_name, mpi_comm_global, mpi_info_null, file_id)

   ! The Hamiltonian
   call hdf5_open_group(file_id, "hamiltonian", group_id)
   
   ! Hamiltonian Read
   call hdf5_get_scalapack_pattern()
   select case (method)
      case (ELPA,OMM_DENSE)
         call hdf5_read_matrix_parallel(group_id, "matrix", H_real)
      case (PEXSI)
         call hdf5_read_matrix_parallel(group_id, "matrix", buffer)
         call elsi_compute_N_nonzero(buffer,n_l_rows, n_l_cols)
         call elsi_allocate(H_real_sparse, n_l_nonzero, "H_real_sparse", caller)
         call elsi_allocate(sparse_index, n_l_nonzero, "sparse_index", caller)
         call elsi_allocate(sparse_pointer, n_l_cols+1, "sparse_pointer", caller)
         call elsi_dense_to_ccs(buffer, n_l_rows, n_l_cols, H_real_sparse,&
                                n_l_nonzero, sparse_index, sparse_pointer)
      case DEFAULT
         call elsi_stop("No supported method has been chosen. "&
                        // "Please choose method ELPA, OMM_DENSE, or PEXSI",&
                        caller)
    end select

   call hdf5_close_group(group_id)

   ! The Overlap Matrix
   call hdf5_open_group(file_id, "overlap", group_id)
   
   ! Overlap Read
   select case (method)
      case (ELPA,OMM_DENSE)
         call hdf5_read_matrix_parallel(group_id, "matrix", S_real)
      case (PEXSI)
         call hdf5_read_matrix_parallel(group_id, "matrix", buffer)
         call elsi_allocate(S_real_sparse, n_l_nonzero, "S_real_sparse", caller)
         call elsi_dense_to_ccs_by_pattern(buffer, n_l_rows, n_l_cols, S_real_sparse,&
                                           n_l_nonzero, sparse_index, sparse_pointer)
      case DEFAULT
         call elsi_stop("No supported method has been chosen. "&
                        // "Please choose method ELPA, OMM_DENSE, or PEXSI",&
                        caller)
         stop
   end select

   ! TODO Check if overlap is unity
   overlap_is_unity = .False.
   
   call hdf5_close_group(group_id)

   call hdf5_close_file(file_id)

   if (allocated(buffer)) deallocate (buffer)

   call elsi_stop_read_evp_time()

end subroutine

!>
!!  This routine sets the method of choice for solving the eigenvalue problem
!!
subroutine elsi_initialize_problem_from_file(file_name, block_rows, block_cols)

   implicit none
   include "mpif.h"

   character(len=*), intent(in) :: file_name !< File to open
   integer, intent(in) :: block_rows  !< Block rows of matrix
   integer, intent(in) :: block_cols  !< Block cols of matrix

   integer :: file_id  !< HDF5 File identifier 
   integer :: group_id !< HDF5 Group identifier
   character*40, parameter :: caller = "elsi_initialize_problem_from_file"

   call elsi_start_read_evp_time()

   n_b_rows = block_rows
   n_b_cols = block_cols

   if (.not. mpi_is_setup) call elsi_stop("MPI needs to be setup first!",caller)

   call hdf5_open_file(file_name, mpi_comm_global, mpi_info_null, file_id)

   ! The Hamiltonian
   call hdf5_open_group(file_id, "hamiltonian", group_id)

   ! Matrix dimension
   call hdf5_read_attribute(group_id, "n_matrix_rows", n_g_rank)
   call hdf5_read_attribute(group_id, "n_matrix_cols", n_g_rank)

   call hdf5_close_group(group_id)
   call hdf5_close_file(file_id)
   call elsi_stop_read_evp_time()

end subroutine

!>
!!  This routine interfaces to the eigenvalue solvers
!!
subroutine elsi_solve_ev_problem(Cholesky, number_of_states)

   implicit none
   include "mpif.h"

   logical, intent(in) :: Cholesky        !< If .True. factorize Overlap
   real*8, intent(in) :: number_of_states !< Number of states

   logical :: success
   logical :: two_step_solver
   real*8  :: val
   integer :: i,j
   integer :: i_task
   character(len=4096) :: string_message
   character*100, parameter :: caller = "elsi_solve_ev_problem"

   call elsi_start_solve_evp_time()

   if(method == ELPA .or. method == OMM_DENSE) then
      if(mode == REAL_VALUES .and. .not. associated(H_real)) then
         call elsi_stop("Hamiltonian not created/linked.",caller)
      endif
   
      if(mode == COMPLEX_VALUES .and. .not. associated(H_complex)) then
         call elsi_stop("Hamiltonian not created/linked.",caller)
      endif
   endif

   if(method == PEXSI) then
      if(mode == REAL_VALUES .and. .not. allocated(H_real_sparse)) then
         call elsi_stop("Hamiltonian not created/linked.",caller)
      endif
   endif

   n_eigenvectors = number_of_states

   select case (method)
      case (ELPA)
         ! Choose 1-stage or 2-stage solver
         two_step_solver = .True.

         if(n_g_rank < 256) then
            two_step_solver = .False.
         endif

         if(1d0*n_eigenvectors/n_g_rank > elpa_step_switch) then
            two_step_solver = .False.
         endif

         ! Transform to standard form
         if(.not. overlap_is_unity) then
            call elsi_statement_print(" Tansforming to standard evp")
            call elsi_to_standard_ev_problem(Cholesky)
         endif

         ! Solve evp, reture eigenvalues and eigenvectors
         if(two_step_solver) then ! 2-stage solver
            call elsi_statement_print(" Starting ELPA 2-stage solver")
            select case (mode)
               case (COMPLEX_VALUES)
                  success = solve_evp_complex_2stage( &
                            n_g_rank, n_eigenvectors, H_complex, &
                            n_l_rows, eigenvalues, vectors_complex, &
                            n_l_rows, n_b_rows, n_l_cols, &
                            mpi_comm_row, mpi_comm_col, mpi_comm_global)
               case (REAL_VALUES)
                  success = solve_evp_real_2stage( &
                            n_g_rank, n_eigenvectors, H_real, &
                            n_l_rows, eigenvalues, vectors_real, &
                            n_l_rows, n_b_rows, n_l_cols, &
                            mpi_comm_row, mpi_comm_col, mpi_comm_global)
            end select
         else ! 1-stage solver
            call elsi_statement_print(" Starting ELPA 1-stage solver")
            select case (mode)
               case (COMPLEX_VALUES)
                  success = solve_evp_complex( &
                            n_g_rank, n_eigenvectors, H_complex, &
                            n_l_rows, eigenvalues, vectors_complex, &
                            n_l_rows, n_b_rows, n_l_cols, &
                            mpi_comm_row, mpi_comm_col)
               case (REAL_VALUES)
                  success = solve_evp_real( &
                            n_g_rank, n_eigenvectors, H_real, &
                            n_l_rows, eigenvalues, vectors_real, &
                            n_l_rows, n_b_rows, n_l_cols, &
                            mpi_comm_row, mpi_comm_col)
            end select
         endif

         if(.not.success) then
            call elsi_stop("ELPA failed in solving eigenvalue problem.",caller)
         endif

         ! Back-transform eigenvectors
         if(.not. overlap_is_unity) then
            call elsi_statement_print(" Transforming to original eigenvectors")
            call elsi_to_original_ev()
         endif

      case (OMM_DENSE)

         call elsi_set_omm_default_options()

         ! Prepare Coefficient matrix
         select case (mode)
            case (COMPLEX_VALUES)
               call m_allocate (OMM_C_matrix, n_eigenvectors, n_g_rank, "pzdbc")
               C_matrix_initialized = .False.
            case (REAL_VALUES)
               call m_allocate (OMM_C_matrix, n_eigenvectors, n_g_rank, "pddbc")
               C_matrix_initialized = .False.
         end select

         ! Shift eigenvalue spectrum
         call m_add(OMM_S_matrix,'N',OMM_H_matrix,-eta,1d0,"lap")

         call omm(n_g_rank, n_eigenvectors, OMM_H_matrix, OMM_S_matrix, &
                  new_overlap, total_energy, OMM_D_matrix, calc_ED, eta, &
                  OMM_C_matrix, C_matrix_initialized, OMM_T_matrix, &
                  scale_kinetic, omm_flavour, nk_times_nspin, i_k_spin,&
                  min_tol, omm_verbose, do_dealloc, "pddbc", "lap", myid)

      case (PEXSI)

         if(.not. allocated(D_real_sparse))  allocate (D_real_sparse(n_l_nonzero))
         if(.not. allocated(ED_real_sparse)) allocate (ED_real_sparse(n_l_nonzero))
         if(.not. allocated(FD_real_sparse)) allocate (FD_real_sparse(n_l_nonzero))

         ! Set the default options
         !TODO: User interface is missing
         call elsi_set_pexsi_default_options()

         ! Load sparse matrices for PEXSI
         if(overlap_is_unity) then
            call f_ppexsi_load_real_symmetric_hs_matrix(pexsi_plan, pexsi_options, &
                 n_g_rank, n_g_nonzero, n_l_nonzero, n_l_cols, sparse_pointer, &
                 sparse_index, H_real_sparse, 1, S_real_sparse, pexsi_info)
         else
            call f_ppexsi_load_real_symmetric_hs_matrix(pexsi_plan, pexsi_options, &
                 n_g_rank, n_g_nonzero, n_l_nonzero, n_l_cols, sparse_pointer, &
                 sparse_index, H_real_sparse, 0, S_real_sparse, pexsi_info)
         endif

         if(pexsi_info /= 0) then
            call elsi_stop("PEXSI not able to load H/S matrix.",caller)
         endif

         ! Solve the eigenvalue problem
         call f_ppexsi_dft_driver(pexsi_plan, pexsi_options, n_electrons, &
              mu_Pexsi, n_electrons_pexsi, mu_min_inertia, mu_max_inertia, &
              n_total_inertia_iter, n_total_pexsi_iter, pexsi_info)
         
         if(pexsi_info /= 0) then
            call elsi_stop("PEXSI DFT Driver not able to solve problem.",caller)
         endif

         ! Get the results
         call f_ppexsi_retrieve_real_symmetric_dft_matrix(pexsi_plan, &
              D_real_sparse, ED_real_sparse, FD_real_sparse, e_tot_H, &
              e_tot_S, f_tot, pexsi_info)

         if(pexsi_info /= 0) then
            call elsi_stop("PEXSI not able to retrieve solution.",caller)
         endif

         if(myid == 0) then
            write(*,*) "Total energy (H*DM)         = ", e_tot_H
            write(*,*) "Total energy (S*EDM)        = ", e_tot_S
            write(*,*) "Total free energy           = ", f_tot
         endif

      case DEFAULT
         call elsi_stop("No method has been chosen. "//&
                        "Please choose method ELPA, OMM, or PEXSI",caller)
   end select

   call MPI_BARRIER(mpi_comm_global, mpierr)
   call elsi_stop_solve_evp_time()

end subroutine

!>
!!  This routine gets the eigenvalues
!!
subroutine elsi_get_eigenvalues(eigenvalues_out,n_eigenvalues)

   implicit none

   real*8, intent(in) :: n_eigenvalues !< Number of eigenvalues
   real*8, intent(out) :: eigenvalues_out(n_eigenvalues) !< Eigenvalues
   character*40, parameter :: caller = "elsi_get_eigenvalues"

   select case (method)
      case (ELPA)
         eigenvalues_out(1:n_eigenvalues) = eigenvalues(1:n_eigenvalues)
      case (OMM_DENSE)
         call elsi_stop("OMM_DENSE not implemented yet!",caller)
      case (PEXSI)
         call elsi_stop("PEXSI not implemented yet!",caller)
      case DEFAULT
         call elsi_stop("No method has been chosen. "//&
                        "Please choose method ELPA, OMM_DENSE, or PEXSI",&
                        caller)
   end select

end subroutine

!>
!!  This routine gets the eigenvectors
!!
subroutine elsi_get_real_eigenvectors(eigenvectors_out)

   implicit none

   real*8, intent(out) :: eigenvectors_out(n_l_rows,n_l_cols) !< Eigenvectors

   character*100, parameter :: caller = "elsi_get_real_eigenvectors"

   select case (method)
      case (ELPA)

         eigenvectors_out = vectors_real

      case (OMM_DENSE)
         call elsi_stop("OMM does not deal with eigenvectors!",caller)
      case (PEXSI)
         call elsi_stop("PEXSI does not deal with eigenvectors!",caller)
      case DEFAULT
         call elsi_stop("No method has been chosen. "//&
                        "Please choose method ELPA, OMM_DENSE, or PEXSI",&
                        caller)
   end select

end subroutine

!>
!!  This routine gets the eigenvectors
!!
subroutine elsi_get_complex_eigenvectors(eigenvectors_out)

   implicit none

   complex*16, intent(out) :: eigenvectors_out(n_l_rows,n_l_cols) !< Eigenvectors

   character*100, parameter :: caller = "elsi_get_complex_eigenvectors"

   select case (method)
      case (ELPA)

         eigenvectors_out = vectors_complex

      case (OMM_DENSE)
         call elsi_stop("OMM does not deal with eigenvectors!",caller)
      case (PEXSI)
         call elsi_stop("PEXSI does not deal with eigenvectors!",caller)
      case DEFAULT
         call elsi_stop("No method has been chosen. "//&
                        "Please choose method ELPA, OMM_DENSE, or PEXSI",&
                        caller)
   end select

end subroutine

!>
!!  This routine gets the sum of eigenvalues a.k.a total energy
!!
subroutine elsi_get_total_energy(e_tot)

   implicit none

   real*8, intent(out) :: e_tot !< Eigenvalues
   character*40, parameter :: caller = "elsi_get_total_energy"

   select case (method)
      case (ELPA)
         e_tot = 2d0 * SUM(eigenvalues(1:n_eigenvectors))      
      case (OMM_DENSE)
         e_tot = 2d0 * total_energy 
      case (PEXSI)
         e_tot = e_tot_h     
      case DEFAULT
         call elsi_stop("No method has been chosen. "//&
                        "Please choose method ELPA, OMM_DENSE, or PEXSI",&
                        caller)
   end select

end subroutine

!>
!!  This routine deallocates the matrices
!!
subroutine elsi_deallocate_matrices()

   implicit none

   ! Nullify pointers
   if (associated(H_real))    nullify (H_real)
   if (associated(H_complex)) nullify (H_complex)
   if (associated(S_real))    nullify (S_real)
   if (associated(S_complex)) nullify (S_complex)
 
   ! Free Memory
   if (allocated(H_real_target))    deallocate(H_real_target)
   if (allocated(H_complex_target)) deallocate(H_complex_target)
   if (allocated(S_real_target))    deallocate(S_real_target)
   if (allocated(S_complex_target)) deallocate(S_complex_target)
   if (allocated(vectors_real))     deallocate(vectors_real)
   if (allocated(vectors_complex))  deallocate(vectors_complex)
   if (allocated(eigenvalues))      deallocate(eigenvalues)
   if (allocated(H_real_sparse))    deallocate(H_real_sparse)
   if (allocated(S_real_sparse))    deallocate(S_real_sparse)
   if (allocated(D_real_sparse))    deallocate(D_real_sparse)
   if (allocated(ED_real_sparse))   deallocate(ED_real_sparse)
   if (allocated(FD_real_sparse))   deallocate(FD_real_sparse)
   if (allocated(sparse_index))     deallocate(sparse_index)
   if (allocated(sparse_pointer))   deallocate(sparse_pointer)

   if(method == OMM_DENSE) then
      call m_deallocate (OMM_H_matrix)
      call m_deallocate (OMM_S_matrix)
      call m_deallocate (OMM_C_matrix)
      call m_deallocate (OMM_D_matrix)
      call m_deallocate (OMM_T_matrix)
   endif

end subroutine

!>
!!  This routine shuts elsi down
!!
subroutine elsi_finalize()

   implicit none
   include "mpif.h"

   call MPI_BARRIER(mpi_comm_global, mpierr)

   call elsi_deallocate_matrices()

   if(mode == PEXSI) call f_ppexsi_plan_finalize(pexsi_plan, pexsi_info)
   
   call hdf5_finalize()
   
   call elsi_stop_total_time()
   call elsi_print_timers()

   if(.not.external_blacs) call elsi_finalize_blacs()
   if(.not.external_mpi)   call elsi_finalize_mpi()

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
subroutine elsi_to_standard_ev_problem(Cholesky)

   logical, intent(in) :: Cholesky                 !< If .True. factorize Overlap

   logical :: success                              !< Success flag
   real*8,     allocatable :: buffer_real (:,:)    !< Real valued matrix buffer
   complex*16, allocatable :: buffer_complex (:,:) !< Complex valued matrix buffer

   character*100, parameter :: caller = "elsi_to_standard_ev_problem"

   select case (method)
      case (ELPA)
         select case (mode)
            case (COMPLEX_VALUES)
               call elsi_allocate(buffer_complex, n_l_rows, n_l_cols, &
                                  "buffer_complex",caller)

               if(Cholesky) then
                  call elsi_statement_print(" Starting Cholesty decomposition")
                  ! Compute S = (U^T)U, U -> S
                  call cholesky_complex(n_g_rank, S_complex, n_l_rows, &
                                        n_b_rows, n_l_cols, mpi_comm_row, &
                                        mpi_comm_col, .False., success)
                  if(.not.success) then
                     call elsi_stop("Cholesky decomposition failed.",caller)
                  endif

                  ! compute U^-1 -> S
                  call invert_trm_complex(n_g_rank, S_complex, n_l_rows, &
                                          n_b_rows, n_l_cols, mpi_comm_row, &
                                          mpi_comm_col, .False., success)
                  if(.not.success) then
                     call elsi_stop("Matrix invertion failed.",caller)
                  endif
               endif

               ! compute H(U^-1) -> buff
               call pzgemm('N','N', n_g_rank, n_g_rank, n_g_rank, 1.0d0, &
                           H_complex, 1, 1, sc_desc, S_complex, 1, 1, sc_desc, &
                           0.0d0, buffer_complex, 1, 1, sc_desc)

               ! compute ((U^-1)^T)H by (H(U^-1))^T -> H
               call pztranc(n_g_rank, n_g_rank, 1.d0, buffer_complex, 1, 1, &
                            sc_desc, 0.d0, H_complex, 1, 1, sc_desc)

               ! compute ((U^-1)^T)H(U^-1) -> H
               buffer_complex = H_complex
               call pzgemm('N','N', n_g_rank, n_g_rank, n_g_rank, 1.0d0, &
                           buffer_complex, 1, 1, sc_desc, S_complex, 1, 1, &
                           sc_desc, 0.0d0, H_complex, 1, 1, sc_desc)

            case (REAL_VALUES)
               call elsi_allocate(buffer_real, n_l_rows, n_l_cols, &
                                  "buffer_real",caller)

               if(Cholesky) then
                  call elsi_statement_print(" Starting Cholesty decomposition")
                  ! Compute S = (U^T)U, U -> S
                  call cholesky_real(n_g_rank, S_real, n_l_rows, &
                                     n_b_rows, n_l_cols, mpi_comm_row, &
                                     mpi_comm_col, .False., success)
                  if(.not.success) then
                     call elsi_stop("Cholesky decomposition failed.",caller)
                  endif

                  ! compute U^-1 -> S
                  call invert_trm_real(n_g_rank, S_real, n_l_rows, &
                                       n_b_rows, n_l_cols, mpi_comm_row, &
                                       mpi_comm_col, .False., success)
                  if(.not.success) then
                     call elsi_stop("Matrix invertion failed.",caller)
                  endif
               endif

               ! compute H(U^-1) -> buff
               call pdgemm('N','N', n_g_rank, n_g_rank, n_g_rank, 1.0d0, &
                           H_real, 1, 1, sc_desc, S_real, 1, 1, sc_desc, &
                           0.0d0, buffer_real, 1, 1, sc_desc)

               ! compute ((U^-1)^T)H by (H(U^-1))^T -> H
               call pdtran(n_g_rank, n_g_rank, 1.d0, buffer_real, 1, 1, &
                           sc_desc, 0.d0, H_real, 1, 1, sc_desc)

               ! compute ((U^-1)^T)H(U^-1) -> H
               buffer_real = H_real
               call pdgemm('N','N', n_g_rank, n_g_rank, n_g_rank, 1.0d0, &
                           buffer_real, 1, 1, sc_desc, S_real, 1, 1, &
                           sc_desc, 0.0d0, H_real, 1, 1, sc_desc)
         end select

      case (OMM_DENSE)
         call elsi_stop("OMM does not need to transform evp.",caller)

      case (PEXSI)
         call elsi_stop("PEXSI does not need to transform evp.",caller)

      case DEFAULT
         call elsi_stop("No method has been chosen. " // &
                        "Please choose method ELPA, OMM_DENSE, or PEXSI.", &
                        caller)
   end select

   if (allocated(buffer_real))    deallocate (buffer_real)
   if (allocated(buffer_complex)) deallocate (buffer_complex)

end subroutine

!> 
!! This routine does the back-transformation of the eigenvectors in standard
!! form (A'c' = c'v) to the original generalized form (Ac = Bcv)
!!
!! v = (U^-1)v'
!!
subroutine elsi_to_original_ev()

   real*8, allocatable :: buffer_real(:,:)         !< Real valued matrix buffer
   complex*16, allocatable :: buffer_complex (:,:) !< Complex valued matrix buffer
   character*100, parameter :: caller = "elsi_to_original_ev"

   select case (method)
      case (ELPA)
         select case (mode)
            case (COMPLEX_VALUES)
               ! (U^-1) is stored in S_complex after
               ! elsi_to_standard_ev_problem
               ! vectors_complex = S_complex * vectors_complex
               call elsi_allocate(buffer_complex,n_l_rows,n_l_cols,"temp",caller)
               buffer_complex = vectors_complex

               call pzgemm('N', 'N', n_g_rank, n_eigenvectors, n_g_rank, &
                           1.0d0, S_complex, 1, 1, sc_desc, buffer_complex, 1, 1, &
                           sc_desc, 0.0d0, vectors_complex, 1, 1, sc_desc)

            case (REAL_VALUES)
               ! (U^-1) is stored in S_real after
               ! elsi_to_standard_ev_problem
               ! vectors_real = S_real * vectors_real
               call elsi_allocate(buffer_real,n_l_rows,n_l_cols,"temp",caller)
               buffer_real = vectors_real

               ! method (a)
!               call pdtran(n_g_rank, n_g_rank, 1.d0, S_real, 1, 1, sc_desc, &
!                           0.d0, H_real, 1, 1, sc_desc)
!               call mult_at_b_real('L', 'N', n_g_rank, n_eigenvectors, H_real, &
!                                   n_l_rows, buffer_real, n_l_rows, n_b_rows, &
!                                   mpi_comm_row, mpi_comm_col, vectors_real, n_l_rows)

               ! method (b)
               call pdgemm('N', 'N', n_g_rank, n_eigenvectors, n_g_rank, &
                           1.0d0, S_real, 1, 1, sc_desc, buffer_real , 1, 1, &
                           sc_desc, 0.0d0, vectors_real, 1, 1, sc_desc)
         end select

      case (OMM_DENSE)
         call elsi_stop("OMM does not need to transform evp.",caller)
      case (PEXSI)
         call elsi_stop("PEXSI does not need to transform evp.",caller)
      case DEFAULT
         call elsi_stop("No method has been chosen. " // &
                        "Please choose method ELPA, OMM_DENSE, or PEXSI.", &
                        caller)
   end select

   if (allocated(buffer_real))    deallocate (buffer_real)
   if (allocated(buffer_complex)) deallocate (buffer_complex)

end subroutine

!>
!!  This routine transforms the eigenvalue problem from scalapack dense to pexsi sparse
!!
subroutine scalapack_dense_to_pexsi_sparse(H_external, S_external, &
           n_l_rows_external, n_l_cols_external, mpi_comm_external, &
           blacs_ctxt_external, sc_desc_external)

   implicit none
   include "mpif.h"

   ! Arguments
   integer :: n_l_rows_external
   integer :: n_l_cols_external
   real*8  :: H_external(n_l_rows_external, n_l_cols_external) 
   real*8  :: S_external(n_l_rows_external, n_l_cols_external) 
   integer :: mpi_comm_external
   integer :: blacs_ctxt_external
   integer :: sc_desc_external(9)

   ! External functions
   integer, external :: numroc

   ! Local variables
   integer :: n_p_rows_external
   integer :: n_p_cols_external
   integer :: my_p_row_external
   integer :: my_p_col_external
   integer :: mpi_comm_row_external
   integer :: mpi_comm_col_external
   
   real*8,  allocatable :: buffer(:,:)
   integer :: n_buffer_nonzero
   integer :: n_buffer_bcast_nonzero
   integer :: id_sent
   real*8,  allocatable :: buffer_sparse(:)
   integer, allocatable :: buffer_sparse_index(:)
   integer, allocatable :: buffer_sparse_pointer(:)
   real*8,  allocatable :: buffer_bcast_sparse(:)
   integer, allocatable :: buffer_bcast_sparse_index(:)
   integer, allocatable :: buffer_bcast_sparse_pointer(:)
   integer :: sc_desc_buffer(9)
   integer :: n_l_buffer_rows
   integer :: n_l_buffer_cols
   integer :: n_b_buffer_rows
   integer :: n_b_buffer_cols
   
   integer :: n_l_cols_g
   integer :: n_cols_add
   integer :: blacs_col_offset
   integer :: pexsi_col_offset
   integer :: my_col_offset
   integer :: g_column
   integer :: offset_B
   integer :: offset
   integer :: n_elements
   integer :: i_proc, i_col, id, l_col
   
   integer, allocatable :: n_l_nonzero_column(:)
   character*100, parameter :: caller = "scalapack_dense_to_pexsi_sparse"

   call elsi_start_dist_pexsi_time()

   call elsi_statement_print("Redistribution of H and S for PEXSI Started")

   ! Caution: only n_g_nonzero is meaningful, 
   ! n_l_nonzero refers to wrong distribution
   call elsi_compute_N_nonzero(H_external,n_l_rows_external, n_l_cols_external)
   n_l_nonzero = -1

   call BLACS_Gridinfo(blacs_ctxt_external, n_p_rows_external, &
                       n_p_cols_external, my_p_row_external, &
                       my_p_col_external)

   ! Scalapack has a bug:
   if((n_p_rows_external == 1 .or. n_p_cols_external == 1) &
      .and. n_procs /= 1) then
      if(myid == 0) &
      print *, "We encountered an scalapack bug when working "//&
      "with prime process numbers and using pdtran to transform a matrix "  //&
      "to a different blacs transcriptor. We stop here and wait for a "     //&
      "scalapack patch. While this setup is an inefficient corner case, "   //&
      "restart your calculation choosing a process number which in a "      //&
      "square number in best case for optimal performance and refrain from "//&
      "using prime numbers."
      call MPI_ABORT(mpi_comm_external)
      stop
   endif

   call mpi_comm_split(mpi_comm_external, my_p_col_external, &
                       my_p_row_external, mpi_comm_row_external, mpierr)
   call mpi_comm_split(mpi_comm_external, my_p_row_external, &
                       my_p_col_external, mpi_comm_col_external, mpierr)
   
   ! Determine dimensions of buffer for transformation to PEXSI layout
   n_b_buffer_rows = n_g_rank
   n_b_buffer_cols = CEILING(1d0*n_g_rank / n_p_cols_external)
   n_l_buffer_rows = n_g_rank
   n_l_buffer_cols = numroc(n_g_rank, n_b_buffer_cols, my_p_col_external, &
                            0, n_p_cols_external)

   if(myid == 0) then
      write(*,"('|-------------------------------------------------------')")
      write(*,"('| Initial Parallel Distribution:                        ')")
      write(*,"('|-------------------------------------------------------')")
      write(*,"('| Process grid                   : ',I5,' x ',I5)")&
         n_p_rows_external, n_p_cols_external
      write(*,"('| Buffer Dimension               : ',I5,' x ',I5)")&
         n_l_buffer_rows, n_b_buffer_cols
   endif

   ! Setup new descriptor for buffer based on the new dimensions
   call descinit(sc_desc_buffer, n_g_rank, n_g_rank, n_b_buffer_rows, n_b_buffer_cols, &
                 0, 0, blacs_ctxt_external, n_l_buffer_rows, blacs_info)

   ! PEXSI setup
   n_l_rows = n_g_rank
   n_l_cols_g = FLOOR(1d0*n_g_rank / n_procs)
   n_cols_add = n_g_rank - n_l_cols_g * n_procs
   
   if(myid == n_procs - 1) then
      n_l_cols = n_l_cols_g + n_cols_add
   else
      n_l_cols = n_l_cols_g
   endif

   ! The Hamiltonian
   call elsi_allocate(buffer, n_l_buffer_rows, n_l_buffer_cols, &
                      "buffer", caller)
   call pdtran(n_g_rank, n_g_rank, 1d0, H_external, 1, 1, &
               sc_desc_external, 0d0, buffer, 1, 1, sc_desc_buffer)

   ! Calculate number of nonzero elements on this process
   ! Here we set no the meaningful n_l_nonzero
   call elsi_allocate(n_l_nonzero_column, n_g_rank, &
                      "n_l_nonzero_column", caller)
   blacs_col_offset = 1 + my_p_col_external * n_b_buffer_cols
   call elsi_get_n_nonzero_column(buffer, n_l_buffer_rows, n_l_buffer_cols, &
                                  blacs_col_offset, n_l_nonzero_column)
   pexsi_col_offset = 1 + myid * n_l_cols_g
   n_l_nonzero = &
   sum(n_l_nonzero_column(pexsi_col_offset:pexsi_col_offset + n_l_cols - 1))

   !call elsi_vector_print(n_l_nonzero_column, n_g_rank, "n_l_nonzero_column")
   !call elsi_value_print(n_l_nonzero, "n_l_nonzero")

   call elsi_allocate(H_real_sparse, n_l_nonzero, "H_real_sparse", caller)
   call elsi_allocate(sparse_index, n_l_nonzero, "sparse_index", caller)
   call elsi_allocate(sparse_pointer, n_l_cols + 1, "sparse_pointer", caller)
   sparse_index = -1
   sparse_pointer = -1

   call elsi_get_local_N_nonzero(buffer, n_l_buffer_rows, &
                                 n_b_buffer_cols, n_buffer_nonzero)

   call elsi_allocate(buffer_sparse, n_buffer_nonzero, "buffer_sparse", caller)
   call elsi_allocate(buffer_sparse_index, n_buffer_nonzero, &
                      "buffer_sparse_index", caller)
   call elsi_allocate(buffer_sparse_pointer, n_b_buffer_cols + 1, &
                      "buffer_sparse_pointer", caller)
   call elsi_dense_to_ccs(buffer, n_l_buffer_rows, n_l_buffer_cols, &
                          buffer_sparse, n_buffer_nonzero, buffer_sparse_index, &
                          buffer_sparse_pointer)
   deallocate(buffer)

   !call elsi_vector_print(buffer_sparse, n_buffer_nonzero, "Hamiltonian sparse")
   !call elsi_vector_print(buffer_sparse_index, n_buffer_nonzero, "Hamiltonian sparse index")
   !call elsi_vector_print(buffer_sparse_pointer, n_b_buffer_cols+1, "Hamiltonian sparse pointer")

   do i_proc = 0, n_p_cols_external - 1
   
      n_buffer_bcast_nonzero = n_buffer_nonzero

      id_sent = i_proc

      !call elsi_value_print(id_sent,"id sent")

      call MPI_Bcast(n_buffer_bcast_nonzero, 1, MPI_INT, id_sent, &
                     mpi_comm_external, mpierr)
      
      call elsi_allocate(buffer_bcast_sparse, n_buffer_bcast_nonzero, &
                         "buffer_bcast_spase", caller)
      call elsi_allocate(buffer_bcast_sparse_index, n_buffer_bcast_nonzero, &
                         "buffer_bcast_sparse_index", caller)
      call elsi_allocate(buffer_bcast_sparse_pointer,n_b_buffer_cols + 1, &
                         "buffer_bcast_sparse_pointer", caller)

      if(myid == id_sent) then
         buffer_bcast_sparse         = buffer_sparse
         buffer_bcast_sparse_index   = buffer_sparse_index
         buffer_bcast_sparse_pointer = buffer_sparse_pointer
      else
         buffer_bcast_sparse         = 0
         buffer_bcast_sparse_index   = 0
         buffer_bcast_sparse_pointer = 0
      endif

      ! However, no inter BLACS is possible so we have to do some by hand
      ! communication and broadcast the results over all the processes
      call MPI_Bcast(buffer_bcast_sparse, n_buffer_bcast_nonzero, &
                     MPI_DOUBLE, id_sent, mpi_comm_external, mpierr)
      call MPI_Bcast(buffer_bcast_sparse_index, n_buffer_bcast_nonzero, &
                     MPI_INT, id_sent, mpi_comm_external, mpierr)  
      call MPI_Bcast(buffer_bcast_sparse_pointer, n_b_buffer_cols + 1, &
                     MPI_INT, id_sent, mpi_comm_external, mpierr)  
 
      !call elsi_vector_print(buffer_bcast_sparse_pointer, n_b_buffer_cols+1,&
      !      "Hamiltonian sparse pointer bcast")

      blacs_col_offset = 1 + i_proc * n_b_buffer_cols
      pexsi_col_offset = 1 + myid * n_l_cols_g
      my_col_offset    = 1 + pexsi_col_offset - blacs_col_offset

      ! Fill elements from buffer
      do i_col = my_col_offset, my_col_offset + n_l_cols - 1
        
         if(i_col > 0 .and. i_col <= n_b_buffer_cols) then
         
            ! Get the global column
            !print *, "process ", myid, " pexsi_col_offset ", pexsi_col_offset
            g_column = i_col + blacs_col_offset - 1
            !print *, "process ", myid, " g_column ", g_column
         
            ! Get the offset in the buffer for this column
            offset_B = buffer_bcast_sparse_pointer(i_col)
            !print *, "process ", myid, " offset_B ", offset_B

            ! How many elements are in this column
            n_elements = buffer_bcast_sparse_pointer(i_col+1) &
                         - buffer_bcast_sparse_pointer(i_col)
            !print *, "process ", myid, " n_elements ", n_elements

            ! Local offset
            l_col = i_col - my_col_offset + 1
            !print *, "process ", myid, " l_col ", l_col
         
            offset = sum(n_l_nonzero_column(pexsi_col_offset:g_column-1)) + 1
            !print *, "process ", myid, " offset ", offset
         
            ! Populate sparse matrix
            sparse_pointer(l_col) = offset
            !print *, "process ", myid, " filling ", offset, " to ", &
            !   offset+n_elements-1, " from ", offset_B, " to ", &
            !   offset_B+n_elements-1 

            H_real_sparse(offset:offset+n_elements-1) = &
            buffer_bcast_sparse(offset_B:offset_B+n_elements-1)
            sparse_index(offset:offset+n_elements-1) = &
            buffer_bcast_sparse_index(offset_B:offset_B+n_elements-1)

        endif

     enddo
      
     deallocate(buffer_bcast_sparse)
     deallocate(buffer_bcast_sparse_index)
     deallocate(buffer_bcast_sparse_pointer)

  enddo

     ! Last element in sparse pointer is n_l_nonzero + 1
     sparse_pointer(n_l_cols + 1) = n_l_nonzero + 1

     !call elsi_stop("Stop here","dense_to_pexsi")

     ! The Overlap Matrix
     call elsi_allocate(buffer, n_l_buffer_rows, n_b_buffer_cols, &
                        "buffer", caller)
     buffer = 0d0 
     call pdtran(n_g_rank, n_g_rank, &
                 1d0, S_external, 1, 1, sc_desc_external, &
                 0d0, buffer, 1, 1, sc_desc_buffer)

     call elsi_allocate(S_real_sparse, n_l_nonzero, "S_real_sparse", caller)
     call elsi_dense_to_ccs_by_pattern(buffer, n_l_buffer_rows, n_l_buffer_cols, &
                                       buffer_sparse, n_buffer_nonzero, buffer_sparse_index, &
                                       buffer_sparse_pointer)
     deallocate(buffer)
   
     do i_proc = 0, n_p_cols_external - 1
   
        n_buffer_bcast_nonzero = n_buffer_nonzero

        id_sent = i_proc

        call MPI_Bcast(n_buffer_bcast_nonzero, 1, MPI_INT, id_sent, &
                       mpi_comm_external, mpierr)

        call elsi_allocate(buffer_bcast_sparse, n_buffer_bcast_nonzero, &
                           "buffer_bcast_sparse", caller)
        call elsi_allocate(buffer_bcast_sparse_index, n_buffer_bcast_nonzero, &
                           "buffer_bcast_sparse_index", caller)
        call elsi_allocate(buffer_bcast_sparse_pointer, n_b_buffer_cols + 1, &
                           "buffer_bcast_sparse_pointer", caller)

        if(myid == id_sent) then
           buffer_bcast_sparse         = buffer_sparse
           buffer_bcast_sparse_index   = buffer_sparse_index
           buffer_bcast_sparse_pointer = buffer_sparse_pointer
        else
           buffer_bcast_sparse         = 0
           buffer_bcast_sparse_index   = 0
           buffer_bcast_sparse_pointer = 0
        endif

        ! However, no inter BLACS is possible so we have to do some by hand
        ! communication and broadcast the results over all the processes
        call MPI_Bcast(buffer_bcast_sparse, n_buffer_bcast_nonzero, &
                       MPI_DOUBLE, id_sent, mpi_comm_external, mpierr)
        call MPI_Bcast(buffer_bcast_sparse_index, n_buffer_bcast_nonzero, &
                       MPI_INT, id_sent, mpi_comm_external, mpierr)  
        call MPI_Bcast(buffer_bcast_sparse_pointer, n_b_buffer_cols + 1, &
                       MPI_INT, id_sent, mpi_comm_external, mpierr)  
  
        blacs_col_offset = 1 + i_proc * n_b_buffer_cols
        pexsi_col_offset = 1 + myid * n_l_cols_g
        my_col_offset    = 1 + pexsi_col_offset - blacs_col_offset

        ! Fill elements from buffer
        do i_col = my_col_offset, my_col_offset + n_l_cols - 1
        
           if(i_col > 0 .and. i_col <= n_b_buffer_cols) then

              ! Get the global column
              g_column = i_col + blacs_col_offset - 1
         
              ! Get the offset in the buffer for this column
              offset_B = buffer_bcast_sparse_pointer(i_col)

              ! How many elements are in this column
              n_elements = buffer_bcast_sparse_pointer(i_col+1) &
                           - buffer_bcast_sparse_pointer(i_col)

              ! Local offset
              l_col = i_col - my_col_offset + 1

              ! Populate sparse matrix
              offset = sparse_pointer(l_col)
              S_real_sparse(offset:offset+n_elements-1) = &
              buffer_bcast_sparse(offset_B:offset_B+n_elements-1)

           endif

        enddo
       
        deallocate(buffer_bcast_sparse)
        deallocate(buffer_bcast_sparse_index)
        deallocate(buffer_bcast_sparse_pointer)

   enddo

   deallocate(buffer_sparse)
   deallocate(buffer_sparse_index)
   deallocate(buffer_sparse_pointer)
   deallocate(n_l_nonzero_column)

   ! TODO Check if overlap is unity
   overlap_is_unity = .False.
   
   call elsi_stop_dist_pexsi_time()
   
   call elsi_statement_print("Redistribution of H and S for PEXSI Done")

end subroutine

! ########################################
! ###    ELSI API UNDER DEVELOPMENT    ###
! ########################################

!>
!!  This is the ELPA API v1 that outputs the eigenvalues and eigenvectors
!!
subroutine elsi_ev_real(Ham, Ovlp, Cholesky, matrix_size, n_row, n_col, &
                        b_row, b_col, n_state, E_val, E_vec, method, &
                        n_p_row, n_p_col, my_p_id, my_p_row, my_p_col, &
                        mpi_comm_row, mpi_comm_col, mpi_comm_global, &
                        blacs_context, sc_desc)

   implicit none

   real*8, target, intent(in) :: Ham(n_row,n_col)    !< Hamiltonian
   real*8, target, intent(in) :: Ovlp(n_row,n_col)   !< Overlap
   logical, intent(inout) :: Cholesky                !< If .True. factorize Overlap
   integer, intent(in) :: matrix_size                !< Dimension of matrix
   integer, intent(in) :: n_row                      !< Number of local rows
   integer, intent(in) :: n_col                      !< Number of local columns
   integer, intent(in) :: b_row                      !< Row block number
   integer, intent(in) :: b_col                      !< Column block number
   real*8,  intent(in) :: n_state                    !< Number of states
   real*8, intent(out) :: E_val(n_state)             !< Eigenvalues
   real*8, intent(out) :: E_vec(n_row,n_col)         !< Eigenvectors
   integer, intent(in) :: method                     !< ELPA,OMM,PEXSI
   integer, intent(in) :: n_p_row                    !< Number of processes in row
   integer, intent(in) :: n_p_col                    !< Number of processes in column
   integer, intent(in) :: my_p_id                    !< Process id
   integer, intent(in) :: my_p_row                   !< Process row position
   integer, intent(in) :: my_p_col                   !< Process column position
   integer, intent(in) :: mpi_comm_row               !< Row communicator
   integer, intent(in) :: mpi_comm_col               !< Column communicator
   integer, intent(in) :: mpi_comm_global            !< Global communicator
   integer, intent(in) :: blacs_context              !< BLACS context
   integer, intent(in) :: sc_desc(9)                 !< BLACS descriptor

   ! Set MPI
   call elsi_set_mpi(mpi_comm_global,n_p_row*n_p_col,my_p_id)

   ! Initialization
   call elsi_initialize_problem(matrix_size,b_row,b_col)

   ! Choice of ELPA, OMM_DENSE, PEXSI
   if(method == 0) call elsi_set_method(ELPA)
   if(method == 1) call elsi_set_method(OMM_DENSE)
   if(method == 2) call elsi_set_method(PEXSI)

   ! REAL case
   call elsi_set_mode(REAL_VALUES)

   ! Set BLACS
   call elsi_set_blacs(blacs_context,n_p_row,n_p_col,my_p_row,my_p_col,&
                       mpi_comm_row,mpi_comm_col,n_row,n_col,sc_desc)

   ! Allocation of matrices
   call elsi_allocate_matrices()

   ! Set Hamiltonian and Overlap matrices
   call elsi_set_hamiltonian(Ham,n_row,n_col)
   call elsi_set_overlap(Ovlp,n_row,n_col)

   ! Solve eigenvalue problem
   call elsi_solve_ev_problem(Cholesky,n_state)
   Cholesky = .False.

   call elsi_get_eigenvalues(E_val,n_state)
   call elsi_get_eigenvectors(E_vec)

   ! Shut down
   call elsi_finalize()

end subroutine

!>
!!  This is the ELPA API v1 that outputs the eigenvalues and eigenvectors
!!
subroutine elsi_ev_complex(Ham, Ovlp, Cholesky, matrix_size, n_row, n_col, &
                           b_row, b_col, n_state, E_val, E_vec, method, &
                           n_p_row, n_p_col, my_p_id, my_p_row, my_p_col, &
                           mpi_comm_row, mpi_comm_col, mpi_comm_global, &
                           blacs_context, sc_desc)

   implicit none

   complex*16, target, intent(in) :: Ham(n_row,n_col)    !< Hamiltonian
   complex*16, target, intent(in) :: Ovlp(n_row,n_col)   !< Overlap
   logical, intent(inout) :: Cholesky                    !< If .True. factorize Overlap
   integer, intent(in) :: matrix_size                    !< Dimension of matrix
   integer, intent(in) :: n_row                          !< Number of local rows
   integer, intent(in) :: n_col                          !< Number of local columns
   integer, intent(in) :: b_row                          !< Row block number
   integer, intent(in) :: b_col                          !< Column block number
   real*8, intent(in)  :: n_state                        !< Number of states
   real*8, intent(out) :: E_val(n_state)                 !< Eigenvalues
   complex*16, intent(out) :: E_vec(n_row,n_col)         !< Eigenvectors
   integer, intent(in) :: method                         !< ELPA,OMM,PEXSI
   integer, intent(in) :: n_p_row                        !< Number of processes in row
   integer, intent(in) :: n_p_col                        !< Number of processes in column
   integer, intent(in) :: my_p_id                        !< Process id
   integer, intent(in) :: my_p_row                       !< Process row position
   integer, intent(in) :: my_p_col                       !< Process column position
   integer, intent(in) :: mpi_comm_row                   !< Row communicator
   integer, intent(in) :: mpi_comm_col                   !< Column communicator
   integer, intent(in) :: mpi_comm_global                !< Global communicator
   integer, intent(in) :: blacs_context                  !< BLACS context
   integer, intent(in) :: sc_desc(9)                     !< BLACS descriptor

   ! Set MPI
   call elsi_set_mpi(mpi_comm_global,n_p_row*n_p_col,my_p_id)

   ! Initialization
   call elsi_initialize_problem(matrix_size,b_row,b_col)

   ! Choice of ELPA, OMM_DENSE, PEXSI
   if(method == 0) call elsi_set_method(ELPA)
   if(method == 1) call elsi_set_method(OMM_DENSE)
   if(method == 2) call elsi_set_method(PEXSI)

   ! COMPLEX case
   call elsi_set_mode(COMPLEX_VALUES)

   ! Set BLACS
   call elsi_set_blacs(blacs_context,n_p_row,n_p_col,my_p_row,my_p_col,&
                       mpi_comm_row,mpi_comm_col,n_row,n_col,sc_desc)

   ! Allocation of matrices
   call elsi_allocate_matrices()

   ! Set Hamiltonian and Overlap matrices
   call elsi_set_hamiltonian(Ham,n_row,n_col)
   call elsi_set_overlap(Ovlp,n_row,n_col)

   ! Solve eigenvalue problem
   call elsi_solve_ev_problem(Cholesky,n_state)
   Cholesky = .False.

   call elsi_get_eigenvalues(E_val,n_state)
   call elsi_get_eigenvectors(E_vec)

   ! Shut down
   call elsi_finalize()

end subroutine

end module ELSI
