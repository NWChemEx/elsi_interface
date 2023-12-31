! Copyright (c) 2015-2021, the ELSI team.
! All rights reserved.
!
! This file is part of ELSI and is distributed under the BSD 3-clause license,
! which may be found in the LICENSE file in the ELSI root directory.

!>
!! This subroutine tests reading and writing complex matrices.
!!
subroutine test_rw_cmplx(comm,h_file,s_file)

   use ELSI
   use ELSI_MPI
   use ELSI_PRECISION, only: r8,i4,i8

   implicit none

   integer(kind=i4), intent(in) :: comm
   character(len=*), intent(in) :: h_file
   character(len=*), intent(in) :: s_file

   integer(kind=i4) :: n_proc
   integer(kind=i4) :: nprow
   integer(kind=i4) :: npcol
   integer(kind=i4) :: myid
   integer(kind=i4) :: ierr
   integer(kind=i4) :: blk
   integer(kind=i4) :: blacs_ctxt
   integer(kind=i4) :: n_basis
   integer(kind=i4) :: l_rows
   integer(kind=i4) :: l_cols
   integer(kind=i8) :: nnz_g
   integer(kind=i8) :: nnz_l

   real(kind=r8) :: n_electrons
   real(kind=r8) :: err
   real(kind=r8) :: t1
   real(kind=r8) :: t2

   logical :: den_ok

   integer(kind=i4), allocatable :: row_ind(:)
   integer(kind=i8), allocatable :: col_ptr(:)

   complex(kind=r8), allocatable :: ham(:,:)
   complex(kind=r8), allocatable :: ham_save(:,:)
   complex(kind=r8), allocatable :: ovlp(:,:)
   complex(kind=r8), allocatable :: ovlp_save(:,:)
   complex(kind=r8), allocatable :: ham_csc(:)
   complex(kind=r8), allocatable :: ham_csc_save(:)
   complex(kind=r8), allocatable :: ovlp_csc(:)
   complex(kind=r8), allocatable :: ovlp_csc_save(:)

   type(elsi_rw_handle) :: rwh

   real(kind=r8), parameter :: tol = 1.0e-20_r8

   call MPI_Comm_size(comm,n_proc,ierr)
   call MPI_Comm_rank(comm,myid,ierr)

   if(myid == 0) then
      write(*,'("  ################################")')
      write(*,'("  ##     ELSI TEST PROGRAMS     ##")')
      write(*,'("  ################################")')
      write(*,*)
   end if

   ! Set up square-like processor grid
   do npcol = nint(sqrt(real(n_proc))),2,-1
      if(mod(n_proc,npcol) == 0) exit
   end do
   nprow = n_proc/npcol

   ! Set block size
   blk = 32

   ! Set up BLACS
   blacs_ctxt = comm
   call BLACS_Gridinit(blacs_ctxt,'r',nprow,npcol)

   ! Read H and S matrices
   if(n_proc == 1) then
      ! Test SINGLE_PROC mode
      call elsi_init_rw(rwh,0,0,0,0.0_r8)
   else
      ! Test MULTI_PROC mode
      call elsi_init_rw(rwh,0,1,0,0.0_r8)
      call elsi_set_rw_mpi(rwh,comm)
      call elsi_set_rw_blacs(rwh,blacs_ctxt,blk)
   end if

   call elsi_read_mat_dim(rwh,h_file,n_electrons,n_basis,l_rows,l_cols)

   allocate(ham(l_rows,l_cols))
   allocate(ham_save(l_rows,l_cols))
   allocate(ovlp(l_rows,l_cols))
   allocate(ovlp_save(l_rows,l_cols))

   t1 = MPI_Wtime()

   call elsi_read_mat_complex(rwh,h_file,ham)
   call elsi_read_mat_complex(rwh,s_file,ovlp)

   call elsi_finalize_rw(rwh)

   ham_save(:,:) = ham
   ovlp_save(:,:) = ovlp

   t2 = MPI_Wtime()

   if(myid == 0) then
      write(*,"(2X,A)") "Finished reading H and S matrices"
      write(*,"(2X,A,F10.3,A)") "| Time :",t2-t1,"s"
      write(*,*)
   end if

   if(n_proc == 1) then
      ! Test SINGLE_PROC mode
      call elsi_init_rw(rwh,1,0,n_basis,n_electrons)
   else
      ! Test MULTI_PROC mode
      call elsi_init_rw(rwh,1,1,n_basis,n_electrons)
      call elsi_set_rw_mpi(rwh,comm)
      call elsi_set_rw_blacs(rwh,blacs_ctxt,blk)
   end if

   call elsi_set_rw_zero_def(rwh,tol)

   call elsi_write_mat_complex(rwh,"H_complex.tmp",ham)
   call elsi_write_mat_complex(rwh,"S_complex.tmp",ovlp)

   call elsi_finalize_rw(rwh)

   t1 = MPI_Wtime()

   if(myid == 0) then
      write(*,"(2X,A)") "Finished writing H and S matrices"
      write(*,"(2X,A,F10.3,A)") "| Time :",t1-t2,"s"
      write(*,*)
   end if

   ! Read H and S matrices
   if(n_proc == 1) then
      ! Test SINGLE_PROC mode
      call elsi_init_rw(rwh,0,0,0,0.0_r8)
   else
      ! Test MULTI_PROC mode
      call elsi_init_rw(rwh,0,1,0,0.0_r8)
      call elsi_set_rw_mpi(rwh,comm)
      call elsi_set_rw_blacs(rwh,blacs_ctxt,blk)
   end if

   call elsi_read_mat_dim(rwh,"H_complex.tmp",n_electrons,n_basis,l_rows,l_cols)

   call elsi_read_mat_complex(rwh,"H_complex.tmp",ham)
   call elsi_read_mat_complex(rwh,"S_complex.tmp",ovlp)

   call elsi_finalize_rw(rwh)

   t2 = MPI_Wtime()

   if(myid == 0) then
      write(*,"(2X,A)") "Finished reading H and S matrices"
      write(*,"(2X,A,F10.3,A)") "| Time :",t2-t1,"s"
      write(*,*)
   end if

   err = max(maxval(abs(ham-ham_save)),maxval(abs(ovlp-ovlp_save)))

   if(err < tol) then
      den_ok = .true.
   else
      den_ok = .false.
   end if

   deallocate(ham)
   deallocate(ham_save)
   deallocate(ovlp)
   deallocate(ovlp_save)

   ! Read H and S matrices
   call elsi_init_rw(rwh,0,1,0,0.0_r8)
   call elsi_set_rw_mpi(rwh,comm)

   call elsi_read_mat_dim_sparse(rwh,h_file,n_electrons,n_basis,nnz_g,nnz_l,&
        l_cols)

   allocate(ham_csc(nnz_l))
   allocate(ham_csc_save(nnz_l))
   allocate(ovlp_csc(nnz_l))
   allocate(ovlp_csc_save(nnz_l))
   allocate(row_ind(nnz_l))
   allocate(col_ptr(l_cols+1))

   t1 = MPI_Wtime()

   call elsi_read_mat_complex_sparse(rwh,h_file,row_ind,col_ptr,ham_csc)
   call elsi_read_mat_complex_sparse(rwh,s_file,row_ind,col_ptr,ovlp_csc)

   call elsi_finalize_rw(rwh)

   ham_csc_save(:) = ham_csc
   ovlp_csc_save(:) = ovlp_csc

   t2 = MPI_Wtime()

   if(myid == 0) then
      write(*,"(2X,A)") "Finished reading H and S matrices"
      write(*,"(2X,A,F10.3,A)") "| Time :",t2-t1,"s"
      write(*,*)
   end if

   ! Test MULTI_PROC mode
   call elsi_init_rw(rwh,1,1,n_basis,n_electrons)
   call elsi_set_rw_mpi(rwh,comm)
   call elsi_set_rw_csc(rwh,nnz_g,nnz_l,l_cols)

   call elsi_write_mat_complex_sparse(rwh,"H_complex.tmp",row_ind,col_ptr,&
        ham_csc)
   call elsi_write_mat_complex_sparse(rwh,"S_complex.tmp",row_ind,col_ptr,&
        ovlp_csc)

   call elsi_finalize_rw(rwh)

   t1 = MPI_Wtime()

   if(myid == 0) then
      write(*,"(2X,A)") "Finished writing H and S matrices"
      write(*,"(2X,A,F10.3,A)") "| Time :",t1-t2,"s"
      write(*,*)
   end if

   ! Read H and S matrices
   call elsi_init_rw(rwh,0,1,0,0.0_r8)
   call elsi_set_rw_mpi(rwh,comm)

   call elsi_read_mat_dim_sparse(rwh,"H_complex.tmp",n_electrons,n_basis,nnz_g,&
        nnz_l,l_cols)

   call elsi_read_mat_complex_sparse(rwh,"H_complex.tmp",row_ind,col_ptr,&
        ham_csc)
   call elsi_read_mat_complex_sparse(rwh,"S_complex.tmp",row_ind,col_ptr,&
        ovlp_csc)

   call elsi_finalize_rw(rwh)

   t2 = MPI_Wtime()

   if(myid == 0) then
      write(*,"(2X,A)") "Finished reading H and S matrices"
      write(*,"(2X,A,F10.3,A)") "| Time :",t2-t1,"s"
      write(*,*)
   end if

   err = max(maxval(abs(ham_csc-ham_csc_save)),&
      maxval(abs(ovlp_csc-ovlp_csc_save)))

   if(myid == 0) then
      if(err < tol .and. den_ok) then
         write(*,"(2X,A)") "Passed."
      else
         write(*,"(2X,A)") "Failed."
      end if
      write(*,*)
   end if

   deallocate(ham_csc)
   deallocate(ham_csc_save)
   deallocate(ovlp_csc)
   deallocate(ovlp_csc_save)
   deallocate(row_ind)
   deallocate(col_ptr)

   call BLACS_Gridexit(blacs_ctxt)
   call BLACS_Exit(1)

end subroutine
