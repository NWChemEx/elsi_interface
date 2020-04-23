!   This file is part of ELPA.
!
!    The ELPA library was originally created by the ELPA consortium,
!    consisting of the following organizations:
!
!    - Max Planck Computing and Data Facility (MPCDF), fomerly known as
!      Rechenzentrum Garching der Max-Planck-Gesellschaft (RZG),
!    - Bergische Universität Wuppertal, Lehrstuhl für angewandte
!      Informatik,
!    - Technische Universität München, Lehrstuhl für Informatik mit
!      Schwerpunkt Wissenschaftliches Rechnen ,
!    - Fritz-Haber-Institut, Berlin, Abt. Theorie,
!    - Max-Plack-Institut für Mathematik in den Naturwissenschaften,
!      Leipzig, Abt. Komplexe Strukutren in Biologie und Kognition,
!      and
!    - IBM Deutschland GmbH
!
!    This particular source code file contains additions, changes and
!    enhancements authored by Intel Corporation which is not part of
!    the ELPA consortium.
!
!    More information can be found here:
!    http://elpa.mpcdf.mpg.de/
!
!    ELPA is free software: you can redistribute it and/or modify
!    it under the terms of the version 3 of the license of the
!    GNU Lesser General Public License as published by the Free
!    Software Foundation.
!
!    ELPA is distributed in the hope that it will be useful,
!    but WITHOUT ANY WARRANTY; without even the implied warranty of
!    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
!    GNU Lesser General Public License for more details.
!
!    You should have received a copy of the GNU Lesser General Public License
!    along with ELPA.  If not, see <http://www.gnu.org/licenses/>
!
!    ELPA reflects a substantial effort on the part of the original
!    ELPA consortium, and we ask you to respect the spirit of the
!    license that we chose: i.e., please contribute any changes you
!    may have back to the original ELPA library distribution, and keep
!    any derivatives of ELPA under the same license that we chose for
!    the original distribution, the GNU Lesser General Public License.
!
!
! ELPA1 -- Faster replacements for ScaLAPACK symmetric eigenvalue routines
!
! Copyright of the original code rests with the authors inside the ELPA
! consortium. The copyright of any additional modifications shall rest
! with their original authors, but shall adhere to the licensing terms
! distributed along with the original code in the file "COPYING".

! ELPA2 -- 2-stage solver for ELPA
!
! Copyright of the original code rests with the authors inside the ELPA
! consortium. The copyright of any additional modifications shall rest
! with their original authors, but shall adhere to the licensing terms
! distributed along with the original code in the file "COPYING".

module redist

   public

contains

! --------------------------------------------------------------------------------------------------
! redist_band: redistributes band from 2D block cyclic form to 1D band

   subroutine redist_band_&
   &real&
   &_&
   &double &
      (obj, a_mat, lda, na, nblk, nbw, matrixCols, mpi_comm_rows, mpi_comm_cols, communicator, ab, useGPU)

      use elpa_abstract_impl
      use elpa2_workload
      use precision
      use, intrinsic :: iso_c_binding
      use cuda_functions
      use elpa_utilities, only : local_index, check_allocate_f, check_deallocate_f
      use elpa_mpi
      implicit none

      class(elpa_abstract_impl_t), intent(inout)       :: obj
      logical, intent(in)                              :: useGPU
      integer(kind=ik), intent(in)                     :: lda, na, nblk, nbw, matrixCols, mpi_comm_rows, mpi_comm_cols, communicator
      real(kind=c_double), intent(in)  :: a_mat(lda, matrixCols)
      real(kind=c_double), intent(out) :: ab(:,:)

      integer(kind=ik), allocatable                    :: ncnt_s(:), nstart_s(:), ncnt_r(:), nstart_r(:), &
         block_limits(:)
      integer(kind=ik), allocatable                    :: global_id(:,:), global_id_tmp(:,:)
      real(kind=c_double), allocatable :: sbuf(:,:,:), rbuf(:,:,:), buf(:,:)

      integer(kind=ik)                                 :: i, j, my_pe, n_pes, my_prow, np_rows, my_pcol, np_cols, &
         nfact, np, npr, npc, is, js
      integer(kind=MPI_KIND)                           :: my_peMPI, n_pesMPI, my_prowMPI, np_rowsMPI, my_pcolMPI, np_colsMPI
      integer(kind=MPI_KIND)                           :: mpierr
      integer(kind=ik)                                 :: nblocks_total, il, jl, l_rows, l_cols, n_off

      integer(kind=ik)                                 :: istat
      character(200)                                   :: errorMessage

      logical                                          :: successCUDA
      integer(kind=c_intptr_t), parameter              :: size_of_datatype = size_of_&
      &double&
      &_&
      &real

      call obj%timer%start("redist_band_&
      &real&
      &" // &
      &"_double" &
         )

      call obj%timer%start("mpi_communication")
      call mpi_comm_rank(int(communicator,kind=MPI_KIND), my_peMPI, mpierr)
      call mpi_comm_size(int(communicator,kind=MPI_KIND), n_pesMPI, mpierr)

      call mpi_comm_rank(int(mpi_comm_rows,kind=MPI_KIND) ,my_prowMPI, mpierr)
      call mpi_comm_size(int(mpi_comm_rows,kind=MPI_KIND) ,np_rowsMPI, mpierr)
      call mpi_comm_rank(int(mpi_comm_cols,kind=MPI_KIND) ,my_pcolMPI, mpierr)
      call mpi_comm_size(int(mpi_comm_cols,kind=MPI_KIND) ,np_colsMPI, mpierr)

      my_pe = int(my_peMPI,kind=c_int)
      n_pes = int(n_pesMPI,kind=c_int)
      my_prow = int(my_prowMPI,kind=c_int)
      np_rows = int(np_rowsMPI,kind=c_int)
      my_pcol = int(my_pcolMPI,kind=c_int)
      np_cols = int(np_colsMPI,kind=c_int)

      call obj%timer%stop("mpi_communication")

      ! Get global_id mapping 2D procssor coordinates to global id

      allocate(global_id(0:np_rows-1,0:np_cols-1), stat=istat, errmsg=errorMessage)
      call check_allocate_f("redist_band: global_id", 120,  istat,  errorMessage)
      global_id(:,:) = 0
      global_id(my_prow, my_pcol) = my_pe
      call obj%timer%start("mpi_communication")
      call mpi_allreduce(mpi_in_place, global_id, int(np_rows*np_cols,kind=MPI_KIND), mpi_integer, mpi_sum, &
         int(communicator,kind=MPI_KIND), mpierr)
      call obj%timer%stop("mpi_communication")
      ! Set work distribution

      nblocks_total = (na-1)/nbw + 1

      allocate(block_limits(0:n_pes), stat=istat, errmsg=errorMessage)
      call check_allocate_f("redist_band: block_limits", 146,  istat,  errorMessage)
      call divide_band(obj, nblocks_total, n_pes, block_limits)

      allocate(ncnt_s(0:n_pes-1), stat=istat, errmsg=errorMessage)
      call check_allocate_f("redist_band: ncnt_s", 151,  istat,  errorMessage)
      allocate(nstart_s(0:n_pes-1), stat=istat, errmsg=errorMessage)
      call check_allocate_f("redist_band: nstart_s", 153,  istat,  errorMessage)
      allocate(ncnt_r(0:n_pes-1), stat=istat, errmsg=errorMessage)
      call check_allocate_f("redist_band: ncnt_r", 155,  istat,  errorMessage)
      allocate(nstart_r(0:n_pes-1), stat=istat, errmsg=errorMessage)
      call check_allocate_f("redist_band: nstart_r", 157,  istat,  errorMessage)

      nfact = nbw/nblk

      ! Count how many blocks go to which PE

      ncnt_s(:) = 0
      np = 0 ! receiver PE number
      do j=0,(na-1)/nblk ! loop over rows of blocks
         if (j/nfact==block_limits(np+1)) np = np+1
         if (mod(j,np_rows) == my_prow) then
            do i=0,nfact
               if (mod(i+j,np_cols) == my_pcol) then
                  ncnt_s(np) = ncnt_s(np) + 1
               endif
            enddo
         endif
      enddo

      ! Allocate send buffer

      allocate(sbuf(nblk,nblk,sum(ncnt_s)), stat=istat, errmsg=errorMessage)
      call check_allocate_f("redist_band: sbuf", 180,  istat,  errorMessage)
      sbuf(:,:,:) = 0.

      ! Determine start offsets in send buffer

      nstart_s(0) = 0
      do i=1,n_pes-1
         nstart_s(i) = nstart_s(i-1) + ncnt_s(i-1)
      enddo

      ! Fill send buffer

      l_rows = local_index(na, my_prow, np_rows, nblk, -1) ! Local rows of a_mat
      l_cols = local_index(na, my_pcol, np_cols, nblk, -1) ! Local columns of a_mat

      np = 0
      do j=0,(na-1)/nblk ! loop over rows of blocks
         if (j/nfact==block_limits(np+1)) np = np+1
         if (mod(j,np_rows) == my_prow) then
            do i=0,nfact
               if (mod(i+j,np_cols) == my_pcol) then
                  nstart_s(np) = nstart_s(np) + 1
                  js = (j/np_rows)*nblk
                  is = ((i+j)/np_cols)*nblk
                  jl = MIN(nblk,l_rows-js)
                  il = MIN(nblk,l_cols-is)

                  sbuf(1:jl,1:il,nstart_s(np)) = a_mat(js+1:js+jl,is+1:is+il)
               endif
            enddo
         endif
      enddo

      ! Count how many blocks we get from which PE

      ncnt_r(:) = 0
      do j=block_limits(my_pe)*nfact,min(block_limits(my_pe+1)*nfact-1,(na-1)/nblk)
         npr = mod(j,np_rows)
         do i=0,nfact
            npc = mod(i+j,np_cols)
            np = global_id(npr, npc)
            ncnt_r(np) = ncnt_r(np) + 1
         enddo
      enddo

      ! Allocate receive buffer

      allocate(rbuf(nblk,nblk,sum(ncnt_r)), stat=istat, errmsg=errorMessage)
      call check_allocate_f("redist_band: rbuf", 228,  istat,  errorMessage)

      ! Set send counts/send offsets, receive counts/receive offsets
      ! now actually in variables, not in blocks

      ncnt_s(:) = ncnt_s(:)*nblk*nblk

      nstart_s(0) = 0
      do i=1,n_pes-1
         nstart_s(i) = nstart_s(i-1) + ncnt_s(i-1)
      enddo

      ncnt_r(:) = ncnt_r(:)*nblk*nblk

      nstart_r(0) = 0
      do i=1,n_pes-1
         nstart_r(i) = nstart_r(i-1) + ncnt_r(i-1)
      enddo

      ! Exchange all data with MPI_Alltoallv
      call obj%timer%start("mpi_communication")

      call MPI_Alltoallv(sbuf, int(ncnt_s,kind=MPI_KIND), int(nstart_s,kind=MPI_KIND), MPI_REAL8, &
         rbuf, int(ncnt_r,kind=MPI_KIND), int(nstart_r,kind=MPI_KIND), MPI_REAL8, &
         int(communicator,kind=MPI_KIND), mpierr)

      call obj%timer%stop("mpi_communication")

! set band from receive buffer

      ncnt_r(:) = ncnt_r(:)/(nblk*nblk)

      nstart_r(0) = 0
      do i=1,n_pes-1
         nstart_r(i) = nstart_r(i-1) + ncnt_r(i-1)
      enddo

      allocate(buf((nfact+1)*nblk,nblk),stat=istat, errmsg=errorMessage)
      call check_allocate_f("redist_band: buf", 270,  istat,  errorMessage)

      ! n_off: Offset of ab within band
      n_off = block_limits(my_pe)*nbw

      do j=block_limits(my_pe)*nfact,min(block_limits(my_pe+1)*nfact-1,(na-1)/nblk)
         npr = mod(j,np_rows)
         do i=0,nfact
            npc = mod(i+j,np_cols)
            np = global_id(npr, npc)
            nstart_r(np) = nstart_r(np) + 1
            buf(i*nblk+1:i*nblk+nblk,:) = transpose(rbuf(:,:,nstart_r(np)))
         enddo
         do i=1,MIN(nblk,na-j*nblk)
            ab(1:nbw+1,i+j*nblk-n_off) = buf(i:i+nbw,i)
         enddo
      enddo

      deallocate(ncnt_s, nstart_s, stat=istat, errmsg=errorMessage)
      call check_deallocate_f("redist_band: ncnt_s, nstart_s", 294,  istat,  errorMessage)
      deallocate(ncnt_r, nstart_r, stat=istat, errmsg=errorMessage)
      call check_deallocate_f("redist_band: ncnt_r, nstart_r", 296,  istat,  errorMessage)
      deallocate(global_id, stat=istat, errmsg=errorMessage)
      call check_deallocate_f("redist_band: global_id", 298,  istat,  errorMessage)
      deallocate(block_limits, stat=istat, errmsg=errorMessage)
      call check_deallocate_f("redist_band: block_limits", 300,  istat,  errorMessage)

      deallocate(sbuf, rbuf, buf, stat=istat, errmsg=errorMessage)
      call check_deallocate_f("redist_band: sbuf, rbuf, buf", 303,  istat,  errorMessage)

      call obj%timer%stop("redist_band_&
      &real&
      &" // &
      &"_double" &
         )

   end subroutine

! single precision

! --------------------------------------------------------------------------------------------------
! redist_band: redistributes band from 2D block cyclic form to 1D band

   subroutine redist_band_&
   &real&
   &_&
   &single &
      (obj, a_mat, lda, na, nblk, nbw, matrixCols, mpi_comm_rows, mpi_comm_cols, communicator, ab, useGPU)

      use elpa_abstract_impl
      use elpa2_workload
      use precision
      use, intrinsic :: iso_c_binding
      use cuda_functions
      use elpa_utilities, only : local_index, check_allocate_f, check_deallocate_f
      use elpa_mpi
      implicit none

      class(elpa_abstract_impl_t), intent(inout)       :: obj
      logical, intent(in)                              :: useGPU
      integer(kind=ik), intent(in)                     :: lda, na, nblk, nbw, matrixCols, mpi_comm_rows, mpi_comm_cols, communicator
      real(kind=c_float), intent(in)  :: a_mat(lda, matrixCols)
      real(kind=c_float), intent(out) :: ab(:,:)

      integer(kind=ik), allocatable                    :: ncnt_s(:), nstart_s(:), ncnt_r(:), nstart_r(:), &
         block_limits(:)
      integer(kind=ik), allocatable                    :: global_id(:,:), global_id_tmp(:,:)
      real(kind=c_float), allocatable :: sbuf(:,:,:), rbuf(:,:,:), buf(:,:)

      integer(kind=ik)                                 :: i, j, my_pe, n_pes, my_prow, np_rows, my_pcol, np_cols, &
         nfact, np, npr, npc, is, js
      integer(kind=MPI_KIND)                           :: my_peMPI, n_pesMPI, my_prowMPI, np_rowsMPI, my_pcolMPI, np_colsMPI
      integer(kind=MPI_KIND)                           :: mpierr
      integer(kind=ik)                                 :: nblocks_total, il, jl, l_rows, l_cols, n_off

      integer(kind=ik)                                 :: istat
      character(200)                                   :: errorMessage

      logical                                          :: successCUDA
      integer(kind=c_intptr_t), parameter              :: size_of_datatype = size_of_&
      &single&
      &_&
      &real

      call obj%timer%start("redist_band_&
      &real&
      &" // &
      &"_single" &
         )

      call obj%timer%start("mpi_communication")
      call mpi_comm_rank(int(communicator,kind=MPI_KIND), my_peMPI, mpierr)
      call mpi_comm_size(int(communicator,kind=MPI_KIND), n_pesMPI, mpierr)

      call mpi_comm_rank(int(mpi_comm_rows,kind=MPI_KIND) ,my_prowMPI, mpierr)
      call mpi_comm_size(int(mpi_comm_rows,kind=MPI_KIND) ,np_rowsMPI, mpierr)
      call mpi_comm_rank(int(mpi_comm_cols,kind=MPI_KIND) ,my_pcolMPI, mpierr)
      call mpi_comm_size(int(mpi_comm_cols,kind=MPI_KIND) ,np_colsMPI, mpierr)

      my_pe = int(my_peMPI,kind=c_int)
      n_pes = int(n_pesMPI,kind=c_int)
      my_prow = int(my_prowMPI,kind=c_int)
      np_rows = int(np_rowsMPI,kind=c_int)
      my_pcol = int(my_pcolMPI,kind=c_int)
      np_cols = int(np_colsMPI,kind=c_int)

      call obj%timer%stop("mpi_communication")

      ! Get global_id mapping 2D procssor coordinates to global id

      allocate(global_id(0:np_rows-1,0:np_cols-1), stat=istat, errmsg=errorMessage)
      call check_allocate_f("redist_band: global_id", 120,  istat,  errorMessage)
      global_id(:,:) = 0
      global_id(my_prow, my_pcol) = my_pe
      call obj%timer%start("mpi_communication")
      call mpi_allreduce(mpi_in_place, global_id, int(np_rows*np_cols,kind=MPI_KIND), mpi_integer, mpi_sum, &
         int(communicator,kind=MPI_KIND), mpierr)
      call obj%timer%stop("mpi_communication")
      ! Set work distribution

      nblocks_total = (na-1)/nbw + 1

      allocate(block_limits(0:n_pes), stat=istat, errmsg=errorMessage)
      call check_allocate_f("redist_band: block_limits", 146,  istat,  errorMessage)
      call divide_band(obj, nblocks_total, n_pes, block_limits)

      allocate(ncnt_s(0:n_pes-1), stat=istat, errmsg=errorMessage)
      call check_allocate_f("redist_band: ncnt_s", 151,  istat,  errorMessage)
      allocate(nstart_s(0:n_pes-1), stat=istat, errmsg=errorMessage)
      call check_allocate_f("redist_band: nstart_s", 153,  istat,  errorMessage)
      allocate(ncnt_r(0:n_pes-1), stat=istat, errmsg=errorMessage)
      call check_allocate_f("redist_band: ncnt_r", 155,  istat,  errorMessage)
      allocate(nstart_r(0:n_pes-1), stat=istat, errmsg=errorMessage)
      call check_allocate_f("redist_band: nstart_r", 157,  istat,  errorMessage)

      nfact = nbw/nblk

      ! Count how many blocks go to which PE

      ncnt_s(:) = 0
      np = 0 ! receiver PE number
      do j=0,(na-1)/nblk ! loop over rows of blocks
         if (j/nfact==block_limits(np+1)) np = np+1
         if (mod(j,np_rows) == my_prow) then
            do i=0,nfact
               if (mod(i+j,np_cols) == my_pcol) then
                  ncnt_s(np) = ncnt_s(np) + 1
               endif
            enddo
         endif
      enddo

      ! Allocate send buffer

      allocate(sbuf(nblk,nblk,sum(ncnt_s)), stat=istat, errmsg=errorMessage)
      call check_allocate_f("redist_band: sbuf", 180,  istat,  errorMessage)
      sbuf(:,:,:) = 0.

      ! Determine start offsets in send buffer

      nstart_s(0) = 0
      do i=1,n_pes-1
         nstart_s(i) = nstart_s(i-1) + ncnt_s(i-1)
      enddo

      ! Fill send buffer

      l_rows = local_index(na, my_prow, np_rows, nblk, -1) ! Local rows of a_mat
      l_cols = local_index(na, my_pcol, np_cols, nblk, -1) ! Local columns of a_mat

      np = 0
      do j=0,(na-1)/nblk ! loop over rows of blocks
         if (j/nfact==block_limits(np+1)) np = np+1
         if (mod(j,np_rows) == my_prow) then
            do i=0,nfact
               if (mod(i+j,np_cols) == my_pcol) then
                  nstart_s(np) = nstart_s(np) + 1
                  js = (j/np_rows)*nblk
                  is = ((i+j)/np_cols)*nblk
                  jl = MIN(nblk,l_rows-js)
                  il = MIN(nblk,l_cols-is)

                  sbuf(1:jl,1:il,nstart_s(np)) = a_mat(js+1:js+jl,is+1:is+il)
               endif
            enddo
         endif
      enddo

      ! Count how many blocks we get from which PE

      ncnt_r(:) = 0
      do j=block_limits(my_pe)*nfact,min(block_limits(my_pe+1)*nfact-1,(na-1)/nblk)
         npr = mod(j,np_rows)
         do i=0,nfact
            npc = mod(i+j,np_cols)
            np = global_id(npr, npc)
            ncnt_r(np) = ncnt_r(np) + 1
         enddo
      enddo

      ! Allocate receive buffer

      allocate(rbuf(nblk,nblk,sum(ncnt_r)), stat=istat, errmsg=errorMessage)
      call check_allocate_f("redist_band: rbuf", 228,  istat,  errorMessage)

      ! Set send counts/send offsets, receive counts/receive offsets
      ! now actually in variables, not in blocks

      ncnt_s(:) = ncnt_s(:)*nblk*nblk

      nstart_s(0) = 0
      do i=1,n_pes-1
         nstart_s(i) = nstart_s(i-1) + ncnt_s(i-1)
      enddo

      ncnt_r(:) = ncnt_r(:)*nblk*nblk

      nstart_r(0) = 0
      do i=1,n_pes-1
         nstart_r(i) = nstart_r(i-1) + ncnt_r(i-1)
      enddo

      ! Exchange all data with MPI_Alltoallv
      call obj%timer%start("mpi_communication")

      call MPI_Alltoallv(sbuf, int(ncnt_s,kind=MPI_KIND), int(nstart_s,kind=MPI_KIND), MPI_REAL4, &
         rbuf, int(ncnt_r,kind=MPI_KIND), int(nstart_r,kind=MPI_KIND), MPI_REAL4, &
         int(communicator,kind=MPI_KIND), mpierr)

      call obj%timer%stop("mpi_communication")

! set band from receive buffer

      ncnt_r(:) = ncnt_r(:)/(nblk*nblk)

      nstart_r(0) = 0
      do i=1,n_pes-1
         nstart_r(i) = nstart_r(i-1) + ncnt_r(i-1)
      enddo

      allocate(buf((nfact+1)*nblk,nblk),stat=istat, errmsg=errorMessage)
      call check_allocate_f("redist_band: buf", 270,  istat,  errorMessage)

      ! n_off: Offset of ab within band
      n_off = block_limits(my_pe)*nbw

      do j=block_limits(my_pe)*nfact,min(block_limits(my_pe+1)*nfact-1,(na-1)/nblk)
         npr = mod(j,np_rows)
         do i=0,nfact
            npc = mod(i+j,np_cols)
            np = global_id(npr, npc)
            nstart_r(np) = nstart_r(np) + 1
            buf(i*nblk+1:i*nblk+nblk,:) = transpose(rbuf(:,:,nstart_r(np)))
         enddo
         do i=1,MIN(nblk,na-j*nblk)
            ab(1:nbw+1,i+j*nblk-n_off) = buf(i:i+nbw,i)
         enddo
      enddo

      deallocate(ncnt_s, nstart_s, stat=istat, errmsg=errorMessage)
      call check_deallocate_f("redist_band: ncnt_s, nstart_s", 294,  istat,  errorMessage)
      deallocate(ncnt_r, nstart_r, stat=istat, errmsg=errorMessage)
      call check_deallocate_f("redist_band: ncnt_r, nstart_r", 296,  istat,  errorMessage)
      deallocate(global_id, stat=istat, errmsg=errorMessage)
      call check_deallocate_f("redist_band: global_id", 298,  istat,  errorMessage)
      deallocate(block_limits, stat=istat, errmsg=errorMessage)
      call check_deallocate_f("redist_band: block_limits", 300,  istat,  errorMessage)

      deallocate(sbuf, rbuf, buf, stat=istat, errmsg=errorMessage)
      call check_deallocate_f("redist_band: sbuf, rbuf, buf", 303,  istat,  errorMessage)

      call obj%timer%stop("redist_band_&
      &real&
      &" // &
      &"_single" &
         )

   end subroutine

! double precision

! --------------------------------------------------------------------------------------------------
! redist_band: redistributes band from 2D block cyclic form to 1D band

   subroutine redist_band_&
   &complex&
   &_&
   &double &
      (obj, a_mat, lda, na, nblk, nbw, matrixCols, mpi_comm_rows, mpi_comm_cols, communicator, ab, useGPU)

      use elpa_abstract_impl
      use elpa2_workload
      use precision
      use, intrinsic :: iso_c_binding
      use cuda_functions
      use elpa_utilities, only : local_index, check_allocate_f, check_deallocate_f
      use elpa_mpi
      implicit none

      class(elpa_abstract_impl_t), intent(inout)       :: obj
      logical, intent(in)                              :: useGPU
      integer(kind=ik), intent(in)                     :: lda, na, nblk, nbw, matrixCols, mpi_comm_rows, mpi_comm_cols, communicator
      complex(kind=c_double), intent(in)  :: a_mat(lda, matrixCols)
      complex(kind=c_double), intent(out) :: ab(:,:)

      integer(kind=ik), allocatable                    :: ncnt_s(:), nstart_s(:), ncnt_r(:), nstart_r(:), &
         block_limits(:)
      integer(kind=ik), allocatable                    :: global_id(:,:), global_id_tmp(:,:)
      complex(kind=c_double), allocatable :: sbuf(:,:,:), rbuf(:,:,:), buf(:,:)

      integer(kind=ik)                                 :: i, j, my_pe, n_pes, my_prow, np_rows, my_pcol, np_cols, &
         nfact, np, npr, npc, is, js
      integer(kind=MPI_KIND)                           :: my_peMPI, n_pesMPI, my_prowMPI, np_rowsMPI, my_pcolMPI, np_colsMPI
      integer(kind=MPI_KIND)                           :: mpierr
      integer(kind=ik)                                 :: nblocks_total, il, jl, l_rows, l_cols, n_off

      integer(kind=ik)                                 :: istat
      character(200)                                   :: errorMessage

      logical                                          :: successCUDA
      integer(kind=c_intptr_t), parameter              :: size_of_datatype = size_of_&
      &double&
      &_&
      &complex

      call obj%timer%start("redist_band_&
      &complex&
      &" // &
      &"_double" &
         )

      call obj%timer%start("mpi_communication")
      call mpi_comm_rank(int(communicator,kind=MPI_KIND), my_peMPI, mpierr)
      call mpi_comm_size(int(communicator,kind=MPI_KIND), n_pesMPI, mpierr)

      call mpi_comm_rank(int(mpi_comm_rows,kind=MPI_KIND) ,my_prowMPI, mpierr)
      call mpi_comm_size(int(mpi_comm_rows,kind=MPI_KIND) ,np_rowsMPI, mpierr)
      call mpi_comm_rank(int(mpi_comm_cols,kind=MPI_KIND) ,my_pcolMPI, mpierr)
      call mpi_comm_size(int(mpi_comm_cols,kind=MPI_KIND) ,np_colsMPI, mpierr)

      my_pe = int(my_peMPI,kind=c_int)
      n_pes = int(n_pesMPI,kind=c_int)
      my_prow = int(my_prowMPI,kind=c_int)
      np_rows = int(np_rowsMPI,kind=c_int)
      my_pcol = int(my_pcolMPI,kind=c_int)
      np_cols = int(np_colsMPI,kind=c_int)

      call obj%timer%stop("mpi_communication")

      ! Get global_id mapping 2D procssor coordinates to global id

      allocate(global_id(0:np_rows-1,0:np_cols-1), stat=istat, errmsg=errorMessage)
      call check_allocate_f("redist_band: global_id", 120,  istat,  errorMessage)
      global_id(:,:) = 0
      global_id(my_prow, my_pcol) = my_pe
      call obj%timer%start("mpi_communication")
      call mpi_allreduce(mpi_in_place, global_id, int(np_rows*np_cols,kind=MPI_KIND), mpi_integer, mpi_sum, &
         int(communicator,kind=MPI_KIND), mpierr)
      call obj%timer%stop("mpi_communication")
      ! Set work distribution

      nblocks_total = (na-1)/nbw + 1

      allocate(block_limits(0:n_pes), stat=istat, errmsg=errorMessage)
      call check_allocate_f("redist_band: block_limits", 146,  istat,  errorMessage)
      call divide_band(obj, nblocks_total, n_pes, block_limits)

      allocate(ncnt_s(0:n_pes-1), stat=istat, errmsg=errorMessage)
      call check_allocate_f("redist_band: ncnt_s", 151,  istat,  errorMessage)
      allocate(nstart_s(0:n_pes-1), stat=istat, errmsg=errorMessage)
      call check_allocate_f("redist_band: nstart_s", 153,  istat,  errorMessage)
      allocate(ncnt_r(0:n_pes-1), stat=istat, errmsg=errorMessage)
      call check_allocate_f("redist_band: ncnt_r", 155,  istat,  errorMessage)
      allocate(nstart_r(0:n_pes-1), stat=istat, errmsg=errorMessage)
      call check_allocate_f("redist_band: nstart_r", 157,  istat,  errorMessage)

      nfact = nbw/nblk

      ! Count how many blocks go to which PE

      ncnt_s(:) = 0
      np = 0 ! receiver PE number
      do j=0,(na-1)/nblk ! loop over rows of blocks
         if (j/nfact==block_limits(np+1)) np = np+1
         if (mod(j,np_rows) == my_prow) then
            do i=0,nfact
               if (mod(i+j,np_cols) == my_pcol) then
                  ncnt_s(np) = ncnt_s(np) + 1
               endif
            enddo
         endif
      enddo

      ! Allocate send buffer

      allocate(sbuf(nblk,nblk,sum(ncnt_s)), stat=istat, errmsg=errorMessage)
      call check_allocate_f("redist_band: sbuf", 180,  istat,  errorMessage)
      sbuf(:,:,:) = 0.

      ! Determine start offsets in send buffer

      nstart_s(0) = 0
      do i=1,n_pes-1
         nstart_s(i) = nstart_s(i-1) + ncnt_s(i-1)
      enddo

      ! Fill send buffer

      l_rows = local_index(na, my_prow, np_rows, nblk, -1) ! Local rows of a_mat
      l_cols = local_index(na, my_pcol, np_cols, nblk, -1) ! Local columns of a_mat

      np = 0
      do j=0,(na-1)/nblk ! loop over rows of blocks
         if (j/nfact==block_limits(np+1)) np = np+1
         if (mod(j,np_rows) == my_prow) then
            do i=0,nfact
               if (mod(i+j,np_cols) == my_pcol) then
                  nstart_s(np) = nstart_s(np) + 1
                  js = (j/np_rows)*nblk
                  is = ((i+j)/np_cols)*nblk
                  jl = MIN(nblk,l_rows-js)
                  il = MIN(nblk,l_cols-is)

                  sbuf(1:jl,1:il,nstart_s(np)) = a_mat(js+1:js+jl,is+1:is+il)
               endif
            enddo
         endif
      enddo

      ! Count how many blocks we get from which PE

      ncnt_r(:) = 0
      do j=block_limits(my_pe)*nfact,min(block_limits(my_pe+1)*nfact-1,(na-1)/nblk)
         npr = mod(j,np_rows)
         do i=0,nfact
            npc = mod(i+j,np_cols)
            np = global_id(npr, npc)
            ncnt_r(np) = ncnt_r(np) + 1
         enddo
      enddo

      ! Allocate receive buffer

      allocate(rbuf(nblk,nblk,sum(ncnt_r)), stat=istat, errmsg=errorMessage)
      call check_allocate_f("redist_band: rbuf", 228,  istat,  errorMessage)

      ! Set send counts/send offsets, receive counts/receive offsets
      ! now actually in variables, not in blocks

      ncnt_s(:) = ncnt_s(:)*nblk*nblk

      nstart_s(0) = 0
      do i=1,n_pes-1
         nstart_s(i) = nstart_s(i-1) + ncnt_s(i-1)
      enddo

      ncnt_r(:) = ncnt_r(:)*nblk*nblk

      nstart_r(0) = 0
      do i=1,n_pes-1
         nstart_r(i) = nstart_r(i-1) + ncnt_r(i-1)
      enddo

      ! Exchange all data with MPI_Alltoallv
      call obj%timer%start("mpi_communication")

      call MPI_Alltoallv(sbuf, int(ncnt_s,kind=MPI_KIND), int(nstart_s,kind=MPI_KIND), MPI_COMPLEX16, &
         rbuf, int(ncnt_r,kind=MPI_KIND), int(nstart_r,kind=MPI_KIND), MPI_COMPLEX16, &
         int(communicator,kind=MPI_KIND), mpierr)

      call obj%timer%stop("mpi_communication")

! set band from receive buffer

      ncnt_r(:) = ncnt_r(:)/(nblk*nblk)

      nstart_r(0) = 0
      do i=1,n_pes-1
         nstart_r(i) = nstart_r(i-1) + ncnt_r(i-1)
      enddo

      allocate(buf((nfact+1)*nblk,nblk),stat=istat, errmsg=errorMessage)
      call check_allocate_f("redist_band: buf", 270,  istat,  errorMessage)

      ! n_off: Offset of ab within band
      n_off = block_limits(my_pe)*nbw

      do j=block_limits(my_pe)*nfact,min(block_limits(my_pe+1)*nfact-1,(na-1)/nblk)
         npr = mod(j,np_rows)
         do i=0,nfact
            npc = mod(i+j,np_cols)
            np = global_id(npr, npc)
            nstart_r(np) = nstart_r(np) + 1
            buf(i*nblk+1:i*nblk+nblk,:) = conjg(transpose(rbuf(:,:,nstart_r(np))))
         enddo
         do i=1,MIN(nblk,na-j*nblk)
            ab(1:nbw+1,i+j*nblk-n_off) = buf(i:i+nbw,i)
         enddo
      enddo

      deallocate(ncnt_s, nstart_s, stat=istat, errmsg=errorMessage)
      call check_deallocate_f("redist_band: ncnt_s, nstart_s", 294,  istat,  errorMessage)
      deallocate(ncnt_r, nstart_r, stat=istat, errmsg=errorMessage)
      call check_deallocate_f("redist_band: ncnt_r, nstart_r", 296,  istat,  errorMessage)
      deallocate(global_id, stat=istat, errmsg=errorMessage)
      call check_deallocate_f("redist_band: global_id", 298,  istat,  errorMessage)
      deallocate(block_limits, stat=istat, errmsg=errorMessage)
      call check_deallocate_f("redist_band: block_limits", 300,  istat,  errorMessage)

      deallocate(sbuf, rbuf, buf, stat=istat, errmsg=errorMessage)
      call check_deallocate_f("redist_band: sbuf, rbuf, buf", 303,  istat,  errorMessage)

      call obj%timer%stop("redist_band_&
      &complex&
      &" // &
      &"_double" &
         )

   end subroutine

! --------------------------------------------------------------------------------------------------
! redist_band: redistributes band from 2D block cyclic form to 1D band

   subroutine redist_band_&
   &complex&
   &_&
   &single &
      (obj, a_mat, lda, na, nblk, nbw, matrixCols, mpi_comm_rows, mpi_comm_cols, communicator, ab, useGPU)

      use elpa_abstract_impl
      use elpa2_workload
      use precision
      use, intrinsic :: iso_c_binding
      use cuda_functions
      use elpa_utilities, only : local_index, check_allocate_f, check_deallocate_f
      use elpa_mpi
      implicit none

      class(elpa_abstract_impl_t), intent(inout)       :: obj
      logical, intent(in)                              :: useGPU
      integer(kind=ik), intent(in)                     :: lda, na, nblk, nbw, matrixCols, mpi_comm_rows, mpi_comm_cols, communicator
      complex(kind=c_float), intent(in)  :: a_mat(lda, matrixCols)
      complex(kind=c_float), intent(out) :: ab(:,:)

      integer(kind=ik), allocatable                    :: ncnt_s(:), nstart_s(:), ncnt_r(:), nstart_r(:), &
         block_limits(:)
      integer(kind=ik), allocatable                    :: global_id(:,:), global_id_tmp(:,:)
      complex(kind=c_float), allocatable :: sbuf(:,:,:), rbuf(:,:,:), buf(:,:)

      integer(kind=ik)                                 :: i, j, my_pe, n_pes, my_prow, np_rows, my_pcol, np_cols, &
         nfact, np, npr, npc, is, js
      integer(kind=MPI_KIND)                           :: my_peMPI, n_pesMPI, my_prowMPI, np_rowsMPI, my_pcolMPI, np_colsMPI
      integer(kind=MPI_KIND)                           :: mpierr
      integer(kind=ik)                                 :: nblocks_total, il, jl, l_rows, l_cols, n_off

      integer(kind=ik)                                 :: istat
      character(200)                                   :: errorMessage

      logical                                          :: successCUDA
      integer(kind=c_intptr_t), parameter              :: size_of_datatype = size_of_&
      &single&
      &_&
      &complex

      call obj%timer%start("redist_band_&
      &complex&
      &" // &
      &"_single" &
         )

      call obj%timer%start("mpi_communication")
      call mpi_comm_rank(int(communicator,kind=MPI_KIND), my_peMPI, mpierr)
      call mpi_comm_size(int(communicator,kind=MPI_KIND), n_pesMPI, mpierr)

      call mpi_comm_rank(int(mpi_comm_rows,kind=MPI_KIND) ,my_prowMPI, mpierr)
      call mpi_comm_size(int(mpi_comm_rows,kind=MPI_KIND) ,np_rowsMPI, mpierr)
      call mpi_comm_rank(int(mpi_comm_cols,kind=MPI_KIND) ,my_pcolMPI, mpierr)
      call mpi_comm_size(int(mpi_comm_cols,kind=MPI_KIND) ,np_colsMPI, mpierr)

      my_pe = int(my_peMPI,kind=c_int)
      n_pes = int(n_pesMPI,kind=c_int)
      my_prow = int(my_prowMPI,kind=c_int)
      np_rows = int(np_rowsMPI,kind=c_int)
      my_pcol = int(my_pcolMPI,kind=c_int)
      np_cols = int(np_colsMPI,kind=c_int)

      call obj%timer%stop("mpi_communication")

      ! Get global_id mapping 2D procssor coordinates to global id

      allocate(global_id(0:np_rows-1,0:np_cols-1), stat=istat, errmsg=errorMessage)
      call check_allocate_f("redist_band: global_id", 120,  istat,  errorMessage)
      global_id(:,:) = 0
      global_id(my_prow, my_pcol) = my_pe
      call obj%timer%start("mpi_communication")
      call mpi_allreduce(mpi_in_place, global_id, int(np_rows*np_cols,kind=MPI_KIND), mpi_integer, mpi_sum, &
         int(communicator,kind=MPI_KIND), mpierr)
      call obj%timer%stop("mpi_communication")
      ! Set work distribution

      nblocks_total = (na-1)/nbw + 1

      allocate(block_limits(0:n_pes), stat=istat, errmsg=errorMessage)
      call check_allocate_f("redist_band: block_limits", 146,  istat,  errorMessage)
      call divide_band(obj, nblocks_total, n_pes, block_limits)

      allocate(ncnt_s(0:n_pes-1), stat=istat, errmsg=errorMessage)
      call check_allocate_f("redist_band: ncnt_s", 151,  istat,  errorMessage)
      allocate(nstart_s(0:n_pes-1), stat=istat, errmsg=errorMessage)
      call check_allocate_f("redist_band: nstart_s", 153,  istat,  errorMessage)
      allocate(ncnt_r(0:n_pes-1), stat=istat, errmsg=errorMessage)
      call check_allocate_f("redist_band: ncnt_r", 155,  istat,  errorMessage)
      allocate(nstart_r(0:n_pes-1), stat=istat, errmsg=errorMessage)
      call check_allocate_f("redist_band: nstart_r", 157,  istat,  errorMessage)

      nfact = nbw/nblk

      ! Count how many blocks go to which PE

      ncnt_s(:) = 0
      np = 0 ! receiver PE number
      do j=0,(na-1)/nblk ! loop over rows of blocks
         if (j/nfact==block_limits(np+1)) np = np+1
         if (mod(j,np_rows) == my_prow) then
            do i=0,nfact
               if (mod(i+j,np_cols) == my_pcol) then
                  ncnt_s(np) = ncnt_s(np) + 1
               endif
            enddo
         endif
      enddo

      ! Allocate send buffer

      allocate(sbuf(nblk,nblk,sum(ncnt_s)), stat=istat, errmsg=errorMessage)
      call check_allocate_f("redist_band: sbuf", 180,  istat,  errorMessage)
      sbuf(:,:,:) = 0.

      ! Determine start offsets in send buffer

      nstart_s(0) = 0
      do i=1,n_pes-1
         nstart_s(i) = nstart_s(i-1) + ncnt_s(i-1)
      enddo

      ! Fill send buffer

      l_rows = local_index(na, my_prow, np_rows, nblk, -1) ! Local rows of a_mat
      l_cols = local_index(na, my_pcol, np_cols, nblk, -1) ! Local columns of a_mat

      np = 0
      do j=0,(na-1)/nblk ! loop over rows of blocks
         if (j/nfact==block_limits(np+1)) np = np+1
         if (mod(j,np_rows) == my_prow) then
            do i=0,nfact
               if (mod(i+j,np_cols) == my_pcol) then
                  nstart_s(np) = nstart_s(np) + 1
                  js = (j/np_rows)*nblk
                  is = ((i+j)/np_cols)*nblk
                  jl = MIN(nblk,l_rows-js)
                  il = MIN(nblk,l_cols-is)

                  sbuf(1:jl,1:il,nstart_s(np)) = a_mat(js+1:js+jl,is+1:is+il)
               endif
            enddo
         endif
      enddo

      ! Count how many blocks we get from which PE

      ncnt_r(:) = 0
      do j=block_limits(my_pe)*nfact,min(block_limits(my_pe+1)*nfact-1,(na-1)/nblk)
         npr = mod(j,np_rows)
         do i=0,nfact
            npc = mod(i+j,np_cols)
            np = global_id(npr, npc)
            ncnt_r(np) = ncnt_r(np) + 1
         enddo
      enddo

      ! Allocate receive buffer

      allocate(rbuf(nblk,nblk,sum(ncnt_r)), stat=istat, errmsg=errorMessage)
      call check_allocate_f("redist_band: rbuf", 228,  istat,  errorMessage)

      ! Set send counts/send offsets, receive counts/receive offsets
      ! now actually in variables, not in blocks

      ncnt_s(:) = ncnt_s(:)*nblk*nblk

      nstart_s(0) = 0
      do i=1,n_pes-1
         nstart_s(i) = nstart_s(i-1) + ncnt_s(i-1)
      enddo

      ncnt_r(:) = ncnt_r(:)*nblk*nblk

      nstart_r(0) = 0
      do i=1,n_pes-1
         nstart_r(i) = nstart_r(i-1) + ncnt_r(i-1)
      enddo

      ! Exchange all data with MPI_Alltoallv
      call obj%timer%start("mpi_communication")

      call MPI_Alltoallv(sbuf, int(ncnt_s,kind=MPI_KIND), int(nstart_s,kind=MPI_KIND), MPI_COMPLEX8, &
         rbuf, int(ncnt_r,kind=MPI_KIND), int(nstart_r,kind=MPI_KIND), MPI_COMPLEX8, &
         int(communicator,kind=MPI_KIND), mpierr)

      call obj%timer%stop("mpi_communication")

! set band from receive buffer

      ncnt_r(:) = ncnt_r(:)/(nblk*nblk)

      nstart_r(0) = 0
      do i=1,n_pes-1
         nstart_r(i) = nstart_r(i-1) + ncnt_r(i-1)
      enddo

      allocate(buf((nfact+1)*nblk,nblk),stat=istat, errmsg=errorMessage)
      call check_allocate_f("redist_band: buf", 270,  istat,  errorMessage)

      ! n_off: Offset of ab within band
      n_off = block_limits(my_pe)*nbw

      do j=block_limits(my_pe)*nfact,min(block_limits(my_pe+1)*nfact-1,(na-1)/nblk)
         npr = mod(j,np_rows)
         do i=0,nfact
            npc = mod(i+j,np_cols)
            np = global_id(npr, npc)
            nstart_r(np) = nstart_r(np) + 1
            buf(i*nblk+1:i*nblk+nblk,:) = conjg(transpose(rbuf(:,:,nstart_r(np))))
         enddo
         do i=1,MIN(nblk,na-j*nblk)
            ab(1:nbw+1,i+j*nblk-n_off) = buf(i:i+nbw,i)
         enddo
      enddo

      deallocate(ncnt_s, nstart_s, stat=istat, errmsg=errorMessage)
      call check_deallocate_f("redist_band: ncnt_s, nstart_s", 294,  istat,  errorMessage)
      deallocate(ncnt_r, nstart_r, stat=istat, errmsg=errorMessage)
      call check_deallocate_f("redist_band: ncnt_r, nstart_r", 296,  istat,  errorMessage)
      deallocate(global_id, stat=istat, errmsg=errorMessage)
      call check_deallocate_f("redist_band: global_id", 298,  istat,  errorMessage)
      deallocate(block_limits, stat=istat, errmsg=errorMessage)
      call check_deallocate_f("redist_band: block_limits", 300,  istat,  errorMessage)

      deallocate(sbuf, rbuf, buf, stat=istat, errmsg=errorMessage)
      call check_deallocate_f("redist_band: sbuf, rbuf, buf", 303,  istat,  errorMessage)

      call obj%timer%stop("redist_band_&
      &complex&
      &" // &
      &"_single" &
         )

   end subroutine

end module redist

