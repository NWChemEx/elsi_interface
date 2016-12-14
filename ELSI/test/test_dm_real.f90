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

!>
!! This program tests ELSI density matrix solver elsi_dm_real.
!!

program test_dm_real

   use ELSI
   use MatrixSwitch

   implicit none

   include "mpif.h"

   character(5) :: m_storage
   character(3) :: m_operation
   character(128) :: arg1
   character(128) :: arg2

   integer :: n_proc,nprow,npcol,myid,myprow,mypcol
   integer :: mpi_comm_global,mpi_comm_row,mpi_comm_col,mpierr
   integer :: blk
   integer :: BLACS_CTXT
   integer :: n_basis,n_states
   integer :: matrix_size,supercell(3)
   integer :: solver

   real*8 :: n_electrons,frac_occ,sparsity,orb_r_cut
   real*8 :: k_point(3)
   real*8 :: e_test,e_ref
   real*8 :: t1,t2

   ! VY: Reference values from calculations on Dec 6, 2016
   real*8, parameter :: e_elpa  = -126.817462901829d0
   real*8, parameter :: e_omm   = -126.817462499630d0
   real*8, parameter :: e_pexsi = -126.817728720387d0

   type(matrix) :: H,S,D

   ! Initialize MPI
   call MPI_Init(mpierr)
   mpi_comm_global = MPI_COMM_WORLD
   call MPI_Comm_size(mpi_comm_global,n_proc,mpierr)
   call MPI_Comm_rank(mpi_comm_global,myid,mpierr)

   ! Read command line arguments
   if(COMMAND_ARGUMENT_COUNT() == 2) then
      call GET_COMMAND_ARGUMENT(1,arg1)
      call GET_COMMAND_ARGUMENT(2,arg2)
      read(arg2,*) solver
      if(solver < 1 .or. solver > 3) then
         if(myid == 0) then
            write(*,'("  ################################################")')
            write(*,'("  ##  Wrong choice of solver!!                  ##")')
            write(*,'("  ##  Please choose:                            ##")')
            write(*,'("  ##  ELPA = 1; libOMM = 2; PEXSI = 3           ##")')
            write(*,'("  ################################################")')
            call MPI_Abort(mpi_comm_global,0,mpierr)
            stop
         endif
      endif
   else
      if(myid == 0) then
         write(*,'("  ################################################")')
         write(*,'("  ##  Wrong number of command line arguments!!  ##")')
         write(*,'("  ##  Arg#1: Path to Tomato seed folder.        ##")')
         write(*,'("  ##  Arg#2: Choice of solver.                  ##")')
         write(*,'("  ##         (ELPA = 1; libOMM = 2; PEXSI = 3)  ##")')
         write(*,'("  ################################################")')
         call MPI_Abort(mpi_comm_global,0,mpierr)
         stop
      endif
   endif

   ! Set up square-like grid
   do npcol = NINT(SQRT(REAL(n_proc))),2,-1
      if(MOD(n_proc,npcol) == 0) exit
   enddo
   nprow = n_proc/npcol

   ! Set block size
   blk = 32

   if(myid == 0) then
      write(*,'("  ################################################")')
      write(*,'("  ##             ELSI TEST PROGRAMS             ##")')
      write(*,'("  ################################################")')
      if(solver == 1) then
         write(*,'("  ##  Testing elsi_dm_real + ELPA               ##")')
         e_ref = e_elpa
      elseif(solver == 2) then
         write(*,'("  ##  Testing elsi_dm_real + libOMM             ##")')
         e_ref = e_omm
      else
         write(*,'("  ##  Testing elsi_dm_real + PEXSI              ##")')
         e_ref = e_pexsi
      endif
   endif

   ! Set up BLACS
   BLACS_CTXT = mpi_comm_global
   call BLACS_Gridinit(BLACS_CTXT,'r',nprow,npcol)
   call ms_scalapack_setup(mpi_comm_global,nprow,'r',blk,icontxt=BLACS_CTXT)

   ! Set up row/col communicators for ELPA solver and Cholesky factorization
   call BLACS_Gridinfo(BLACS_CTXT,nprow,npcol,myprow,mypcol)
   call MPI_Comm_split(mpi_comm_global,mypcol,myprow,mpi_comm_row,mpierr)
   call MPI_Comm_split(mpi_comm_global,myprow,mypcol,mpi_comm_col,mpierr)

   ! Set parameters
   m_storage = 'pddbc'
   m_operation = 'lap'
   n_basis = 22
   supercell = (/3,3,3/)
   orb_r_cut = 0.5d0
   k_point(1:3) = (/0d0,0d0,0d0/)

   ! Generate matrix
   if(myid == 0) write(*,'("  ##  Generating test matrix..                  ##")')

   t1 = MPI_Wtime()

   call tomato_TB(arg1,'silicon',.false.,frac_occ,n_basis,&
                  .false.,matrix_size,supercell,.false.,sparsity,orb_r_cut,&
                  n_states,.true.,k_point,.true.,0d0,H,S,m_storage,.true.)

   t2 = MPI_Wtime()

   if(myid == 0) then
      write(*,'("  ##  Done. Time:",F23.3,"s       ##")') t2-t1
      write(*,'("  ##  System:                      Silicon      ##")')
      write(*,'("  ##  Matrix size:",I21,"         ##")') matrix_size
      write(*,'("  ##  Sparsity:",F26.3,"%      ##")') 100d0*sparsity
      write(*,'("  ##  Number of electrons:",I12,"          ##")') 2*n_states
   endif

   ! Initialize ELSI
   n_electrons = 2d0*n_states

   call elsi_init(solver,1,0,matrix_size,n_electrons,n_states)
   call elsi_set_mpi(mpi_comm_global,n_proc,myid)
   call elsi_set_blacs(BLACS_CTXT,blk,blk,nprow,npcol,mpi_comm_row,mpi_comm_col)

   ! Solve problem
   call m_allocate(D,matrix_size,matrix_size,m_storage)

   if(myid == 0) then
      write(*,'("  ##  Solving Kohn-Sham problem..               ##")')
      write(*,'("  ################################################")')
   endif

   ! Disable ELPA if using libOMM
   if(solver == 2) call elsi_customize_omm(n_elpa_steps_omm=0)

   t1 = MPI_Wtime()

   call elsi_dm_real(H%dval,S%dval,D%dval,e_test)

   t2 = MPI_Wtime()

   if(myid == 0) then
      write(*,'("  ################################################")')
      write(*,'("  ##  Done. Time:",F23.3,"s       ##")') t2-t1
      if(ABS(e_test-e_ref) < 1d-6) then
         write(*,'("  ##  Passed.                                   ##")')
      else
         write(*,'("  ##  Failed!!                                  ##")')
      endif
      write(*,'("  ################################################")')
   endif

   ! Finalize ELSI
   call elsi_finalize()

   call m_deallocate(H)
   call m_deallocate(S)
   call m_deallocate(D)

   call MPI_Finalize(mpierr)

end program