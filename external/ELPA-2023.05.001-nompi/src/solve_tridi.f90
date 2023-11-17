











module solve_tridi
  use precision
  implicit none
  private

  public :: solve_tridi_double
  public :: solve_tridi_single

  contains

! real double precision first




















!cannot use "../src/solve_tridi/./../general/error_checking.inc" because filename with path can be too long for gfortran (max line length)


subroutine solve_tridi_&
&double &
    ( obj, na, nev, d, e, q, ldq, nblk, matrixCols, mpi_comm_all, mpi_comm_rows, &
                                           mpi_comm_cols, useGPU, wantDebug, success, max_threads )

      use precision
      use elpa_abstract_impl
      use merge_recursive
      use merge_systems
      use elpa_mpi
      use ELPA_utilities
      use distribute_global_column
      use elpa_mpi
      implicit none
!    Copyright 2011, A. Marek
!
!    This file is part of ELPA.
!
!    The ELPA library was originally created by the ELPA consortium,
!    consisting of the following organizations:
!
!    - Max Planck Computing and Data Facility (MPCDF), formerly known as
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
  integer, parameter :: rk = C_DOUBLE
  integer, parameter :: rck = C_DOUBLE
  real(kind=rck), parameter      :: ZERO=0.0_rk, ONE = 1.0_rk

      class(elpa_abstract_impl_t), intent(inout) :: obj
      integer(kind=ik), intent(in)               :: na, nev, ldq, nblk, matrixCols, &
                                                    mpi_comm_all, mpi_comm_rows, mpi_comm_cols
      real(kind=rk8), intent(inout)    :: d(na), e(na)
      real(kind=rk8), intent(inout)    :: q(ldq,*)
      logical, intent(in)                        :: useGPU, wantDebug
      logical, intent(out)                       :: success

      integer(kind=ik)                           :: i, j, n, np, nc, nev1, l_cols, l_rows
      integer(kind=ik)                           :: my_prow, my_pcol, np_rows, np_cols
      integer(kind=MPI_KIND)                     :: mpierr, my_prowMPI, my_pcolMPI, np_rowsMPI, np_colsMPI
      integer(kind=ik), allocatable              :: limits(:), l_col(:), p_col(:), l_col_bc(:), p_col_bc(:)

      integer(kind=ik)                           :: istat
      character(200)                             :: errorMessage
      character(20)                              :: gpuString
      integer(kind=ik), intent(in)               :: max_threads

      if(useGPU) then
        gpuString = "_gpu"
      else
        gpuString = ""
      endif

      call obj%timer%start("solve_tridi" // "_double" // gpuString)

      call obj%timer%start("mpi_communication")
      call mpi_comm_rank(int(mpi_comm_rows,kind=MPI_KIND) ,my_prowMPI, mpierr)
      call mpi_comm_size(int(mpi_comm_rows,kind=MPI_KIND) ,np_rowsMPI, mpierr)
      call mpi_comm_rank(int(mpi_comm_cols,kind=MPI_KIND) ,my_pcolMPI, mpierr)
      call mpi_comm_size(int(mpi_comm_cols,kind=MPI_KIND) ,np_colsMPI, mpierr)

      my_prow = int(my_prowMPI,kind=c_int)
      np_rows = int(np_rowsMPI,kind=c_int)
      my_pcol = int(my_pcolMPI,kind=c_int)
      np_cols = int(np_colsMPI,kind=c_int)

      call obj%timer%stop("mpi_communication")

      success = .true.

      l_rows = local_index(na, my_prow, np_rows, nblk, -1) ! Local rows of a and q
      l_cols = local_index(na, my_pcol, np_cols, nblk, -1) ! Local columns of q

      ! Set Q to 0
      q(1:l_rows, 1:l_cols) = 0.0_rk

      ! Get the limits of the subdivisons, each subdivison has as many cols
      ! as fit on the respective processor column

      allocate(limits(0:np_cols), stat=istat, errmsg=errorMessage)
      call check_allocate_f("solve_tridi: limits", 128,  istat,  errorMessage)

      limits(0) = 0
      do np=0,np_cols-1
        nc = local_index(na, np, np_cols, nblk, -1) ! number of columns on proc column np

        ! Check for the case that a column has have zero width.
        ! This is not supported!
        ! Scalapack supports it but delivers no results for these columns,
        ! which is rather annoying
        if (nc==0) then
          call obj%timer%stop("solve_tridi" // "_double")
          if (wantDebug) write(error_unit,*) 'ELPA1_solve_tridi: ERROR: Problem contains processor column with zero width'
          success = .false.
          return
        endif
        limits(np+1) = limits(np) + nc
      enddo

      ! Subdivide matrix by subtracting rank 1 modifications

      do i=1,np_cols-1
        n = limits(i)
        d(n) = d(n)-abs(e(n))
        d(n+1) = d(n+1)-abs(e(n))
      enddo

      ! Solve sub problems on processsor columns

      nc = limits(my_pcol) ! column after which my problem starts

      if (np_cols>1) then
        nev1 = l_cols ! all eigenvectors are needed
      else
        nev1 = MIN(nev,l_cols)
      endif
      call solve_tridi_col_&
           &double &
             (obj, l_cols, nev1, nc, d(nc+1), e(nc+1), q, ldq, nblk,  &
                        matrixCols, mpi_comm_rows, useGPU, wantDebug, success, max_threads)
      if (.not.(success)) then
        call obj%timer%stop("solve_tridi" // "_double" // gpuString)
        return
      endif
      ! If there is only 1 processor column, we are done

      if (np_cols==1) then
        deallocate(limits, stat=istat, errmsg=errorMessage)
        call check_deallocate_f("solve_tridi: limits", 176,  istat,  errorMessage)

        call obj%timer%stop("solve_tridi" // "_double" // gpuString)
        return
      endif

      ! Set index arrays for Q columns

      ! Dense distribution scheme:

      allocate(l_col(na), stat=istat, errmsg=errorMessage)
      call check_allocate_f("solve_tridi: l_col", 187,  istat,  errorMessage)

      allocate(p_col(na), stat=istat, errmsg=errorMessage)
      call check_allocate_f("solve_tridi: p_col", 190,  istat,  errorMessage)

      n = 0
      do np=0,np_cols-1
        nc = local_index(na, np, np_cols, nblk, -1)
        do i=1,nc
          n = n+1
          l_col(n) = i
          p_col(n) = np
        enddo
      enddo

      ! Block cyclic distribution scheme, only nev columns are set:

      allocate(l_col_bc(na), stat=istat, errmsg=errorMessage)
      call check_allocate_f("solve_tridi: l_col_bc", 205,  istat,  errorMessage)

      allocate(p_col_bc(na), stat=istat, errmsg=errorMessage)
      call check_allocate_f("solve_tridi: p_col_bc", 208,  istat,  errorMessage)

      p_col_bc(:) = -1
      l_col_bc(:) = -1

      do i = 0, na-1, nblk*np_cols
        do j = 0, np_cols-1
          do n = 1, nblk
            if (i+j*nblk+n <= MIN(nev,na)) then
              p_col_bc(i+j*nblk+n) = j
              l_col_bc(i+j*nblk+n) = i/np_cols + n
             endif
           enddo
         enddo
      enddo

      ! Recursively merge sub problems
      call merge_recursive_&
           &double &
           (obj, 0, np_cols, ldq, matrixCols, nblk, &
           l_col, p_col, l_col_bc, p_col_bc, limits, &
           np_cols, na, q, d, e, &
           mpi_comm_all, mpi_comm_rows, mpi_comm_cols,&
           useGPU, wantDebug, success, max_threads)

      if (.not.(success)) then
        call obj%timer%stop("solve_tridi" // "_double" // gpuString)
        return
      endif

      deallocate(limits,l_col,p_col,l_col_bc,p_col_bc, stat=istat, errmsg=errorMessage)
      call check_deallocate_f("solve_tridi: limits, l_col, p_col, l_col_bc, p_col_bc", 239,  istat,  errorMessage)

      call obj%timer%stop("solve_tridi" // "_double" // gpuString)
      return

    end subroutine solve_tridi_&
        &double

    subroutine solve_tridi_col_&
    &double &
      ( obj, na, nev, nqoff, d, e, q, ldq, nblk, matrixCols, mpi_comm_rows, useGPU, wantDebug, success, max_threads )

   ! Solves the symmetric, tridiagonal eigenvalue problem on one processor column
   ! with the divide and conquer method.
   ! Works best if the number of processor rows is a power of 2!
      use precision
      use elpa_abstract_impl
      use elpa_mpi
      use merge_systems
      use ELPA_utilities
      use distribute_global_column
      implicit none
      class(elpa_abstract_impl_t), intent(inout) :: obj

      integer(kind=ik)              :: na, nev, nqoff, ldq, nblk, matrixCols, mpi_comm_rows
      real(kind=rk8)      :: d(na), e(na)
      real(kind=rk8)      :: q(ldq,*)

      integer(kind=ik), parameter   :: min_submatrix_size = 16 ! Minimum size of the submatrices to be used

      real(kind=rk8), allocatable    :: qmat1(:,:), qmat2(:,:)
      integer(kind=ik)              :: i, n, np
      integer(kind=ik)              :: ndiv, noff, nmid, nlen, max_size
      integer(kind=ik)              :: my_prow, np_rows
      integer(kind=MPI_KIND)        :: mpierr, my_prowMPI, np_rowsMPI

      integer(kind=ik), allocatable :: limits(:), l_col(:), p_col_i(:), p_col_o(:)
      logical, intent(in)           :: useGPU, wantDebug
      logical, intent(out)          :: success
      integer(kind=ik)              :: istat
      character(200)                :: errorMessage

      integer(kind=ik), intent(in)  :: max_threads

      integer(kind=MPI_KIND)        :: bcast_request1, bcast_request2
      logical                       :: useNonBlockingCollectivesRows
      integer(kind=c_int)           :: non_blocking_collectives, error

      success = .true.

      call obj%timer%start("solve_tridi_col" // "_double")

      call obj%get("nbc_row_solve_tridi", non_blocking_collectives, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "Problem setting option for non blocking collectives for rows in solve_tridi. Aborting..."
        success = .false.
        return
      endif

      if (non_blocking_collectives .eq. 1) then
        useNonBlockingCollectivesRows = .true.
      else
        useNonBlockingCollectivesRows = .false.
      endif

      call obj%timer%start("mpi_communication")
      call mpi_comm_rank(int(mpi_comm_rows,kind=MPI_KIND), my_prowMPI, mpierr)
      call mpi_comm_size(int(mpi_comm_rows,kind=MPI_KIND), np_rowsMPI, mpierr)

      my_prow = int(my_prowMPI,kind=c_int)
      np_rows = int(np_rowsMPI,kind=c_int)
      call obj%timer%stop("mpi_communication")
      success = .true.
      ! Calculate the number of subdivisions needed.

      n = na
      ndiv = 1
      do while(2*ndiv<=np_rows .and. n>2*min_submatrix_size)
        n = ((n+3)/4)*2 ! the bigger one of the two halves, we want EVEN boundaries
        ndiv = ndiv*2
      enddo

      ! If there is only 1 processor row and not all eigenvectors are needed
      ! and the matrix size is big enough, then use 2 subdivisions
      ! so that merge_systems is called once and only the needed
      ! eigenvectors are calculated for the final problem.

      if (np_rows==1 .and. nev<na .and. na>2*min_submatrix_size) ndiv = 2

      allocate(limits(0:ndiv), stat=istat, errmsg=errorMessage)
      call check_deallocate_f("solve_tridi_col: limits", 445,  istat,  errorMessage)

      limits(0) = 0
      limits(ndiv) = na

      n = ndiv
      do while(n>1)
        n = n/2 ! n is always a power of 2
        do i=0,ndiv-1,2*n
          ! We want to have even boundaries (for cache line alignments)
          limits(i+n) = limits(i) + ((limits(i+2*n)-limits(i)+3)/4)*2
        enddo
      enddo

      ! Calculate the maximum size of a subproblem

      max_size = 0
      do i=1,ndiv
        max_size = MAX(max_size,limits(i)-limits(i-1))
      enddo

      ! Subdivide matrix by subtracting rank 1 modifications

      do i=1,ndiv-1
        n = limits(i)
        d(n) = d(n)-abs(e(n))
        d(n+1) = d(n+1)-abs(e(n))
      enddo

      if (np_rows==1)    then

        ! For 1 processor row there may be 1 or 2 subdivisions
        do n=0,ndiv-1
          noff = limits(n)        ! Start of subproblem
          nlen = limits(n+1)-noff ! Size of subproblem

          call solve_tridi_single_problem_&
          &double &
                                  (obj, nlen,d(noff+1),e(noff+1), &
                                    q(nqoff+noff+1,noff+1),ubound(q,dim=1), wantDebug, success)

          if (.not.(success)) return
        enddo

      else

        ! Solve sub problems in parallel with solve_tridi_single
        ! There is at maximum 1 subproblem per processor

        allocate(qmat1(max_size,max_size), stat=istat, errmsg=errorMessage)
        call check_deallocate_f("solve_tridi_col: qmat1", 495,  istat,  errorMessage)

        allocate(qmat2(max_size,max_size), stat=istat, errmsg=errorMessage)
        call check_deallocate_f("solve_tridi_col: qmat2", 498,  istat,  errorMessage)

        qmat1 = 0 ! Make sure that all elements are defined

        if (my_prow < ndiv) then

          noff = limits(my_prow)        ! Start of subproblem
          nlen = limits(my_prow+1)-noff ! Size of subproblem
          call solve_tridi_single_problem_&
          &double &
                                    (obj, nlen,d(noff+1),e(noff+1),qmat1, &
                                    ubound(qmat1,dim=1), wantDebug, success)

          if (.not.(success)) return
        endif

        ! Fill eigenvectors in qmat1 into global matrix q

        do np = 0, ndiv-1

          noff = limits(np)
          nlen = limits(np+1)-noff
!          qmat2 = qmat1 ! is this correct
          do i=1,nlen

            call distribute_global_column_&
            &double &
                     (obj, qmat1(1,i), q(1,noff+i), nqoff+noff, nlen, my_prow, np_rows, nblk)
          enddo

        enddo

        deallocate(qmat1, qmat2, stat=istat, errmsg=errorMessage)
        call check_deallocate_f("solve_tridi_col: qmat1, qmat2", 561,  istat,  errorMessage)

      endif

      ! Allocate and set index arrays l_col and p_col

      allocate(l_col(na), p_col_i(na),  p_col_o(na), stat=istat, errmsg=errorMessage)
      call check_deallocate_f("solve_tridi_col: l_col, p_col_i, p_col_o", 568,  istat,  errorMessage)

      do i=1,na
        l_col(i) = i
        p_col_i(i) = 0
        p_col_o(i) = 0
      enddo

      ! Merge subproblems

      n = 1
      do while(n<ndiv) ! if ndiv==1, the problem was solved by single call to solve_tridi_single

        do i=0,ndiv-1,2*n

          noff = limits(i)
          nmid = limits(i+n) - noff
          nlen = limits(i+2*n) - noff

          if (nlen == na) then
            ! Last merge, set p_col_o=-1 for unneeded (output) eigenvectors
            p_col_o(nev+1:na) = -1
          endif
          call merge_systems_&
          &double &
                              (obj, nlen, nmid, d(noff+1), e(noff+nmid), q, ldq, nqoff+noff, nblk, &
                               matrixCols, int(mpi_comm_rows,kind=ik), int(mpi_comm_self,kind=ik), &
                               l_col(noff+1), p_col_i(noff+1), &
                               l_col(noff+1), p_col_o(noff+1), 0, 1, useGPU, wantDebug, success, max_threads)
          if (.not.(success)) return

        enddo

        n = 2*n

      enddo

      deallocate(limits, l_col, p_col_i, p_col_o, stat=istat, errmsg=errorMessage)
      call check_deallocate_f("solve_tridi_col: limits, l_col, p_col_i, p_col_o", 606,  istat,  errorMessage)

      call obj%timer%stop("solve_tridi_col" // "_double")

    end subroutine solve_tridi_col_&
    &double

    subroutine solve_tridi_single_problem_&
    &double &
    (obj, nlen, d, e, q, ldq, wantDebug, success)

   ! Solves the symmetric, tridiagonal eigenvalue problem on a single processor.
   ! Takes precautions if DSTEDC fails or if the eigenvalues are not ordered correctly.
     use precision
     use elpa_abstract_impl
     use elpa_blas_interfaces
     use ELPA_utilities
     implicit none
     class(elpa_abstract_impl_t), intent(inout) :: obj
     integer(kind=ik)                         :: nlen, ldq
     real(kind=rk8)                 :: d(nlen), e(nlen), q(ldq,nlen)

     real(kind=rk8), allocatable    :: work(:), qtmp(:), ds(:), es(:)
     real(kind=rk8)                 :: dtmp

     integer(kind=ik)              :: i, j, lwork, liwork, info
     integer(kind=BLAS_KIND)       :: infoBLAS
     integer(kind=ik), allocatable :: iwork(:)

     logical, intent(in)           :: wantDebug
     logical, intent(out)          :: success
      integer(kind=ik)             :: istat
      character(200)               :: errorMessage

     call obj%timer%start("solve_tridi_single" // "_double")

     success = .true.
     allocate(ds(nlen), es(nlen), stat=istat, errmsg=errorMessage)
     call check_allocate_f("solve_tridi_single: ds, es", 644,  istat,  errorMessage)

     ! Save d and e for the case that dstedc fails

     ds(:) = d(:)
     es(:) = e(:)

     ! First try dstedc, this is normally faster but it may fail sometimes (why???)

     lwork = 1 + 4*nlen + nlen**2
     liwork =  3 + 5*nlen
     allocate(work(lwork), iwork(liwork), stat=istat, errmsg=errorMessage)
     call check_allocate_f("solve_tridi_single: work, iwork", 656,  istat,  errorMessage)
     call obj%timer%start("blas")
     call DSTEDC('I', int(nlen,kind=BLAS_KIND), d, e, q, int(ldq,kind=BLAS_KIND),    &
                          work, int(lwork,kind=BLAS_KIND), int(iwork,kind=BLAS_KIND), int(liwork,kind=BLAS_KIND), &
                          infoBLAS)
     info = int(infoBLAS,kind=ik)
     call obj%timer%stop("blas")

     if (info /= 0) then

       ! DSTEDC failed, try DSTEQR. The workspace is enough for DSTEQR.

       write(error_unit,'(a,i8,a)') 'Warning: Lapack routine DSTEDC failed, info= ',info,', Trying DSTEQR!'

       d(:) = ds(:)
       e(:) = es(:)
       call obj%timer%start("blas")
       call DSTEQR('I', int(nlen,kind=BLAS_KIND), d, e, q, int(ldq,kind=BLAS_KIND), work, infoBLAS )
       info = int(infoBLAS,kind=ik)
       call obj%timer%stop("blas")

       ! If DSTEQR fails also, we don't know what to do further ...

       if (info /= 0) then
         if (wantDebug) then
           write(error_unit,'(a,i8,a)') 'ELPA1_solve_tridi_single: ERROR: Lapack routine DSTEQR failed, info= ',info,', Aborting!'
         endif
         success = .false.
         return
       endif
     end if

       deallocate(work,iwork,ds,es, stat=istat, errmsg=errorMessage)
       call check_deallocate_f("solve_tridi_single: work, iwork, ds, es", 689,  istat,  errorMessage)

      ! Check if eigenvalues are monotonically increasing
      ! This seems to be not always the case  (in the IBM implementation of dstedc ???)

      do i=1,nlen-1
        if (d(i+1)<d(i)) then
          if (abs(d(i+1) - d(i)) / abs(d(i+1) + d(i)) > 1e-14_rk8) then
            write(error_unit,'(a,i8,2g25.16)') '***WARNING: Monotony error dste**:',i+1,d(i),d(i+1)
          else
            write(error_unit,'(a,i8,2g25.16)') 'Info: Monotony error dste{dc,qr}:',i+1,d(i),d(i+1)
            write(error_unit,'(a)') 'The eigenvalues from a lapack call are not sorted to machine precision.'
            write(error_unit,'(a)') 'In this extent, this is completely harmless.'
            write(error_unit,'(a)') 'Still, we keep this info message just in case.'
          end if
          allocate(qtmp(nlen), stat=istat, errmsg=errorMessage)
          call check_allocate_f("solve_tridi_single: qtmp", 709,  istat,  errorMessage)

          dtmp = d(i+1)
          qtmp(1:nlen) = q(1:nlen,i+1)
          do j=i,1,-1
            if (dtmp<d(j)) then
              d(j+1)        = d(j)
              q(1:nlen,j+1) = q(1:nlen,j)
            else
              exit ! Loop
            endif
          enddo
          d(j+1)        = dtmp
          q(1:nlen,j+1) = qtmp(1:nlen)
          deallocate(qtmp, stat=istat, errmsg=errorMessage)
          call check_deallocate_f("solve_tridi_single: qtmp", 724,  istat,  errorMessage)

       endif
     enddo
     call obj%timer%stop("solve_tridi_single" // "_double")

    end subroutine solve_tridi_single_problem_&
    &double



! real single precision first






















!cannot use "../src/solve_tridi/./../general/error_checking.inc" because filename with path can be too long for gfortran (max line length)


subroutine solve_tridi_&
&single &
    ( obj, na, nev, d, e, q, ldq, nblk, matrixCols, mpi_comm_all, mpi_comm_rows, &
                                           mpi_comm_cols, useGPU, wantDebug, success, max_threads )

      use precision
      use elpa_abstract_impl
      use merge_recursive
      use merge_systems
      use elpa_mpi
      use ELPA_utilities
      use distribute_global_column
      use elpa_mpi
      implicit none
!    Copyright 2011, A. Marek
!
!    This file is part of ELPA.
!
!    The ELPA library was originally created by the ELPA consortium,
!    consisting of the following organizations:
!
!    - Max Planck Computing and Data Facility (MPCDF), formerly known as
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
  integer, parameter :: rk = C_FLOAT
  integer, parameter :: rck = C_FLOAT
  real(kind=rck), parameter      :: ZERO=0.0_rk, ONE = 1.0_rk

      class(elpa_abstract_impl_t), intent(inout) :: obj
      integer(kind=ik), intent(in)               :: na, nev, ldq, nblk, matrixCols, &
                                                    mpi_comm_all, mpi_comm_rows, mpi_comm_cols
      real(kind=rk4), intent(inout)    :: d(na), e(na)
      real(kind=rk4), intent(inout)    :: q(ldq,*)
      logical, intent(in)                        :: useGPU, wantDebug
      logical, intent(out)                       :: success

      integer(kind=ik)                           :: i, j, n, np, nc, nev1, l_cols, l_rows
      integer(kind=ik)                           :: my_prow, my_pcol, np_rows, np_cols
      integer(kind=MPI_KIND)                     :: mpierr, my_prowMPI, my_pcolMPI, np_rowsMPI, np_colsMPI
      integer(kind=ik), allocatable              :: limits(:), l_col(:), p_col(:), l_col_bc(:), p_col_bc(:)

      integer(kind=ik)                           :: istat
      character(200)                             :: errorMessage
      character(20)                              :: gpuString
      integer(kind=ik), intent(in)               :: max_threads

      if(useGPU) then
        gpuString = "_gpu"
      else
        gpuString = ""
      endif

      call obj%timer%start("solve_tridi" // "_single" // gpuString)

      call obj%timer%start("mpi_communication")
      call mpi_comm_rank(int(mpi_comm_rows,kind=MPI_KIND) ,my_prowMPI, mpierr)
      call mpi_comm_size(int(mpi_comm_rows,kind=MPI_KIND) ,np_rowsMPI, mpierr)
      call mpi_comm_rank(int(mpi_comm_cols,kind=MPI_KIND) ,my_pcolMPI, mpierr)
      call mpi_comm_size(int(mpi_comm_cols,kind=MPI_KIND) ,np_colsMPI, mpierr)

      my_prow = int(my_prowMPI,kind=c_int)
      np_rows = int(np_rowsMPI,kind=c_int)
      my_pcol = int(my_pcolMPI,kind=c_int)
      np_cols = int(np_colsMPI,kind=c_int)

      call obj%timer%stop("mpi_communication")

      success = .true.

      l_rows = local_index(na, my_prow, np_rows, nblk, -1) ! Local rows of a and q
      l_cols = local_index(na, my_pcol, np_cols, nblk, -1) ! Local columns of q

      ! Set Q to 0
      q(1:l_rows, 1:l_cols) = 0.0_rk

      ! Get the limits of the subdivisons, each subdivison has as many cols
      ! as fit on the respective processor column

      allocate(limits(0:np_cols), stat=istat, errmsg=errorMessage)
      call check_allocate_f("solve_tridi: limits", 128,  istat,  errorMessage)

      limits(0) = 0
      do np=0,np_cols-1
        nc = local_index(na, np, np_cols, nblk, -1) ! number of columns on proc column np

        ! Check for the case that a column has have zero width.
        ! This is not supported!
        ! Scalapack supports it but delivers no results for these columns,
        ! which is rather annoying
        if (nc==0) then
          call obj%timer%stop("solve_tridi" // "_single")
          if (wantDebug) write(error_unit,*) 'ELPA1_solve_tridi: ERROR: Problem contains processor column with zero width'
          success = .false.
          return
        endif
        limits(np+1) = limits(np) + nc
      enddo

      ! Subdivide matrix by subtracting rank 1 modifications

      do i=1,np_cols-1
        n = limits(i)
        d(n) = d(n)-abs(e(n))
        d(n+1) = d(n+1)-abs(e(n))
      enddo

      ! Solve sub problems on processsor columns

      nc = limits(my_pcol) ! column after which my problem starts

      if (np_cols>1) then
        nev1 = l_cols ! all eigenvectors are needed
      else
        nev1 = MIN(nev,l_cols)
      endif
      call solve_tridi_col_&
           &single &
             (obj, l_cols, nev1, nc, d(nc+1), e(nc+1), q, ldq, nblk,  &
                        matrixCols, mpi_comm_rows, useGPU, wantDebug, success, max_threads)
      if (.not.(success)) then
        call obj%timer%stop("solve_tridi" // "_single" // gpuString)
        return
      endif
      ! If there is only 1 processor column, we are done

      if (np_cols==1) then
        deallocate(limits, stat=istat, errmsg=errorMessage)
        call check_deallocate_f("solve_tridi: limits", 176,  istat,  errorMessage)

        call obj%timer%stop("solve_tridi" // "_single" // gpuString)
        return
      endif

      ! Set index arrays for Q columns

      ! Dense distribution scheme:

      allocate(l_col(na), stat=istat, errmsg=errorMessage)
      call check_allocate_f("solve_tridi: l_col", 187,  istat,  errorMessage)

      allocate(p_col(na), stat=istat, errmsg=errorMessage)
      call check_allocate_f("solve_tridi: p_col", 190,  istat,  errorMessage)

      n = 0
      do np=0,np_cols-1
        nc = local_index(na, np, np_cols, nblk, -1)
        do i=1,nc
          n = n+1
          l_col(n) = i
          p_col(n) = np
        enddo
      enddo

      ! Block cyclic distribution scheme, only nev columns are set:

      allocate(l_col_bc(na), stat=istat, errmsg=errorMessage)
      call check_allocate_f("solve_tridi: l_col_bc", 205,  istat,  errorMessage)

      allocate(p_col_bc(na), stat=istat, errmsg=errorMessage)
      call check_allocate_f("solve_tridi: p_col_bc", 208,  istat,  errorMessage)

      p_col_bc(:) = -1
      l_col_bc(:) = -1

      do i = 0, na-1, nblk*np_cols
        do j = 0, np_cols-1
          do n = 1, nblk
            if (i+j*nblk+n <= MIN(nev,na)) then
              p_col_bc(i+j*nblk+n) = j
              l_col_bc(i+j*nblk+n) = i/np_cols + n
             endif
           enddo
         enddo
      enddo

      ! Recursively merge sub problems
      call merge_recursive_&
           &single &
           (obj, 0, np_cols, ldq, matrixCols, nblk, &
           l_col, p_col, l_col_bc, p_col_bc, limits, &
           np_cols, na, q, d, e, &
           mpi_comm_all, mpi_comm_rows, mpi_comm_cols,&
           useGPU, wantDebug, success, max_threads)

      if (.not.(success)) then
        call obj%timer%stop("solve_tridi" // "_single" // gpuString)
        return
      endif

      deallocate(limits,l_col,p_col,l_col_bc,p_col_bc, stat=istat, errmsg=errorMessage)
      call check_deallocate_f("solve_tridi: limits, l_col, p_col, l_col_bc, p_col_bc", 239,  istat,  errorMessage)

      call obj%timer%stop("solve_tridi" // "_single" // gpuString)
      return

    end subroutine solve_tridi_&
        &single

    subroutine solve_tridi_col_&
    &single &
      ( obj, na, nev, nqoff, d, e, q, ldq, nblk, matrixCols, mpi_comm_rows, useGPU, wantDebug, success, max_threads )

   ! Solves the symmetric, tridiagonal eigenvalue problem on one processor column
   ! with the divide and conquer method.
   ! Works best if the number of processor rows is a power of 2!
      use precision
      use elpa_abstract_impl
      use elpa_mpi
      use merge_systems
      use ELPA_utilities
      use distribute_global_column
      implicit none
      class(elpa_abstract_impl_t), intent(inout) :: obj

      integer(kind=ik)              :: na, nev, nqoff, ldq, nblk, matrixCols, mpi_comm_rows
      real(kind=rk4)      :: d(na), e(na)
      real(kind=rk4)      :: q(ldq,*)

      integer(kind=ik), parameter   :: min_submatrix_size = 16 ! Minimum size of the submatrices to be used

      real(kind=rk4), allocatable    :: qmat1(:,:), qmat2(:,:)
      integer(kind=ik)              :: i, n, np
      integer(kind=ik)              :: ndiv, noff, nmid, nlen, max_size
      integer(kind=ik)              :: my_prow, np_rows
      integer(kind=MPI_KIND)        :: mpierr, my_prowMPI, np_rowsMPI

      integer(kind=ik), allocatable :: limits(:), l_col(:), p_col_i(:), p_col_o(:)
      logical, intent(in)           :: useGPU, wantDebug
      logical, intent(out)          :: success
      integer(kind=ik)              :: istat
      character(200)                :: errorMessage

      integer(kind=ik), intent(in)  :: max_threads

      integer(kind=MPI_KIND)        :: bcast_request1, bcast_request2
      logical                       :: useNonBlockingCollectivesRows
      integer(kind=c_int)           :: non_blocking_collectives, error

      success = .true.

      call obj%timer%start("solve_tridi_col" // "_single")

      call obj%get("nbc_row_solve_tridi", non_blocking_collectives, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "Problem setting option for non blocking collectives for rows in solve_tridi. Aborting..."
        success = .false.
        return
      endif

      if (non_blocking_collectives .eq. 1) then
        useNonBlockingCollectivesRows = .true.
      else
        useNonBlockingCollectivesRows = .false.
      endif

      call obj%timer%start("mpi_communication")
      call mpi_comm_rank(int(mpi_comm_rows,kind=MPI_KIND), my_prowMPI, mpierr)
      call mpi_comm_size(int(mpi_comm_rows,kind=MPI_KIND), np_rowsMPI, mpierr)

      my_prow = int(my_prowMPI,kind=c_int)
      np_rows = int(np_rowsMPI,kind=c_int)
      call obj%timer%stop("mpi_communication")
      success = .true.
      ! Calculate the number of subdivisions needed.

      n = na
      ndiv = 1
      do while(2*ndiv<=np_rows .and. n>2*min_submatrix_size)
        n = ((n+3)/4)*2 ! the bigger one of the two halves, we want EVEN boundaries
        ndiv = ndiv*2
      enddo

      ! If there is only 1 processor row and not all eigenvectors are needed
      ! and the matrix size is big enough, then use 2 subdivisions
      ! so that merge_systems is called once and only the needed
      ! eigenvectors are calculated for the final problem.

      if (np_rows==1 .and. nev<na .and. na>2*min_submatrix_size) ndiv = 2

      allocate(limits(0:ndiv), stat=istat, errmsg=errorMessage)
      call check_deallocate_f("solve_tridi_col: limits", 445,  istat,  errorMessage)

      limits(0) = 0
      limits(ndiv) = na

      n = ndiv
      do while(n>1)
        n = n/2 ! n is always a power of 2
        do i=0,ndiv-1,2*n
          ! We want to have even boundaries (for cache line alignments)
          limits(i+n) = limits(i) + ((limits(i+2*n)-limits(i)+3)/4)*2
        enddo
      enddo

      ! Calculate the maximum size of a subproblem

      max_size = 0
      do i=1,ndiv
        max_size = MAX(max_size,limits(i)-limits(i-1))
      enddo

      ! Subdivide matrix by subtracting rank 1 modifications

      do i=1,ndiv-1
        n = limits(i)
        d(n) = d(n)-abs(e(n))
        d(n+1) = d(n+1)-abs(e(n))
      enddo

      if (np_rows==1)    then

        ! For 1 processor row there may be 1 or 2 subdivisions
        do n=0,ndiv-1
          noff = limits(n)        ! Start of subproblem
          nlen = limits(n+1)-noff ! Size of subproblem

          call solve_tridi_single_problem_&
          &single &
                                  (obj, nlen,d(noff+1),e(noff+1), &
                                    q(nqoff+noff+1,noff+1),ubound(q,dim=1), wantDebug, success)

          if (.not.(success)) return
        enddo

      else

        ! Solve sub problems in parallel with solve_tridi_single
        ! There is at maximum 1 subproblem per processor

        allocate(qmat1(max_size,max_size), stat=istat, errmsg=errorMessage)
        call check_deallocate_f("solve_tridi_col: qmat1", 495,  istat,  errorMessage)

        allocate(qmat2(max_size,max_size), stat=istat, errmsg=errorMessage)
        call check_deallocate_f("solve_tridi_col: qmat2", 498,  istat,  errorMessage)

        qmat1 = 0 ! Make sure that all elements are defined

        if (my_prow < ndiv) then

          noff = limits(my_prow)        ! Start of subproblem
          nlen = limits(my_prow+1)-noff ! Size of subproblem
          call solve_tridi_single_problem_&
          &single &
                                    (obj, nlen,d(noff+1),e(noff+1),qmat1, &
                                    ubound(qmat1,dim=1), wantDebug, success)

          if (.not.(success)) return
        endif

        ! Fill eigenvectors in qmat1 into global matrix q

        do np = 0, ndiv-1

          noff = limits(np)
          nlen = limits(np+1)-noff
!          qmat2 = qmat1 ! is this correct
          do i=1,nlen

            call distribute_global_column_&
            &single &
                     (obj, qmat1(1,i), q(1,noff+i), nqoff+noff, nlen, my_prow, np_rows, nblk)
          enddo

        enddo

        deallocate(qmat1, qmat2, stat=istat, errmsg=errorMessage)
        call check_deallocate_f("solve_tridi_col: qmat1, qmat2", 561,  istat,  errorMessage)

      endif

      ! Allocate and set index arrays l_col and p_col

      allocate(l_col(na), p_col_i(na),  p_col_o(na), stat=istat, errmsg=errorMessage)
      call check_deallocate_f("solve_tridi_col: l_col, p_col_i, p_col_o", 568,  istat,  errorMessage)

      do i=1,na
        l_col(i) = i
        p_col_i(i) = 0
        p_col_o(i) = 0
      enddo

      ! Merge subproblems

      n = 1
      do while(n<ndiv) ! if ndiv==1, the problem was solved by single call to solve_tridi_single

        do i=0,ndiv-1,2*n

          noff = limits(i)
          nmid = limits(i+n) - noff
          nlen = limits(i+2*n) - noff

          if (nlen == na) then
            ! Last merge, set p_col_o=-1 for unneeded (output) eigenvectors
            p_col_o(nev+1:na) = -1
          endif
          call merge_systems_&
          &single &
                              (obj, nlen, nmid, d(noff+1), e(noff+nmid), q, ldq, nqoff+noff, nblk, &
                               matrixCols, int(mpi_comm_rows,kind=ik), int(mpi_comm_self,kind=ik), &
                               l_col(noff+1), p_col_i(noff+1), &
                               l_col(noff+1), p_col_o(noff+1), 0, 1, useGPU, wantDebug, success, max_threads)
          if (.not.(success)) return

        enddo

        n = 2*n

      enddo

      deallocate(limits, l_col, p_col_i, p_col_o, stat=istat, errmsg=errorMessage)
      call check_deallocate_f("solve_tridi_col: limits, l_col, p_col_i, p_col_o", 606,  istat,  errorMessage)

      call obj%timer%stop("solve_tridi_col" // "_single")

    end subroutine solve_tridi_col_&
    &single

    subroutine solve_tridi_single_problem_&
    &single &
    (obj, nlen, d, e, q, ldq, wantDebug, success)

   ! Solves the symmetric, tridiagonal eigenvalue problem on a single processor.
   ! Takes precautions if DSTEDC fails or if the eigenvalues are not ordered correctly.
     use precision
     use elpa_abstract_impl
     use elpa_blas_interfaces
     use ELPA_utilities
     implicit none
     class(elpa_abstract_impl_t), intent(inout) :: obj
     integer(kind=ik)                         :: nlen, ldq
     real(kind=rk4)                 :: d(nlen), e(nlen), q(ldq,nlen)

     real(kind=rk4), allocatable    :: work(:), qtmp(:), ds(:), es(:)
     real(kind=rk4)                 :: dtmp

     integer(kind=ik)              :: i, j, lwork, liwork, info
     integer(kind=BLAS_KIND)       :: infoBLAS
     integer(kind=ik), allocatable :: iwork(:)

     logical, intent(in)           :: wantDebug
     logical, intent(out)          :: success
      integer(kind=ik)             :: istat
      character(200)               :: errorMessage

     call obj%timer%start("solve_tridi_single" // "_single")

     success = .true.
     allocate(ds(nlen), es(nlen), stat=istat, errmsg=errorMessage)
     call check_allocate_f("solve_tridi_single: ds, es", 644,  istat,  errorMessage)

     ! Save d and e for the case that dstedc fails

     ds(:) = d(:)
     es(:) = e(:)

     ! First try dstedc, this is normally faster but it may fail sometimes (why???)

     lwork = 1 + 4*nlen + nlen**2
     liwork =  3 + 5*nlen
     allocate(work(lwork), iwork(liwork), stat=istat, errmsg=errorMessage)
     call check_allocate_f("solve_tridi_single: work, iwork", 656,  istat,  errorMessage)
     call obj%timer%start("blas")
     call SSTEDC('I', int(nlen,kind=BLAS_KIND), d, e, q, int(ldq,kind=BLAS_KIND),    &
                          work, int(lwork,kind=BLAS_KIND), int(iwork,kind=BLAS_KIND), int(liwork,kind=BLAS_KIND), &
                          infoBLAS)
     info = int(infoBLAS,kind=ik)
     call obj%timer%stop("blas")

     if (info /= 0) then

       ! DSTEDC failed, try DSTEQR. The workspace is enough for DSTEQR.

       write(error_unit,'(a,i8,a)') 'Warning: Lapack routine DSTEDC failed, info= ',info,', Trying DSTEQR!'

       d(:) = ds(:)
       e(:) = es(:)
       call obj%timer%start("blas")
       call SSTEQR('I', int(nlen,kind=BLAS_KIND), d, e, q, int(ldq,kind=BLAS_KIND), work, infoBLAS )
       info = int(infoBLAS,kind=ik)
       call obj%timer%stop("blas")

       ! If DSTEQR fails also, we don't know what to do further ...

       if (info /= 0) then
         if (wantDebug) then
           write(error_unit,'(a,i8,a)') 'ELPA1_solve_tridi_single: ERROR: Lapack routine DSTEQR failed, info= ',info,', Aborting!'
         endif
         success = .false.
         return
       endif
     end if

       deallocate(work,iwork,ds,es, stat=istat, errmsg=errorMessage)
       call check_deallocate_f("solve_tridi_single: work, iwork, ds, es", 689,  istat,  errorMessage)

      ! Check if eigenvalues are monotonically increasing
      ! This seems to be not always the case  (in the IBM implementation of dstedc ???)

      do i=1,nlen-1
        if (d(i+1)<d(i)) then
          if (abs(d(i+1) - d(i)) / abs(d(i+1) + d(i)) > 1e-14_rk4) then
            write(error_unit,'(a,i8,2g25.16)') '***WARNING: Monotony error dste**:',i+1,d(i),d(i+1)
          else
            write(error_unit,'(a,i8,2g25.16)') 'Info: Monotony error dste{dc,qr}:',i+1,d(i),d(i+1)
            write(error_unit,'(a)') 'The eigenvalues from a lapack call are not sorted to machine precision.'
            write(error_unit,'(a)') 'In this extent, this is completely harmless.'
            write(error_unit,'(a)') 'Still, we keep this info message just in case.'
          end if
          allocate(qtmp(nlen), stat=istat, errmsg=errorMessage)
          call check_allocate_f("solve_tridi_single: qtmp", 709,  istat,  errorMessage)

          dtmp = d(i+1)
          qtmp(1:nlen) = q(1:nlen,i+1)
          do j=i,1,-1
            if (dtmp<d(j)) then
              d(j+1)        = d(j)
              q(1:nlen,j+1) = q(1:nlen,j)
            else
              exit ! Loop
            endif
          enddo
          d(j+1)        = dtmp
          q(1:nlen,j+1) = qtmp(1:nlen)
          deallocate(qtmp, stat=istat, errmsg=errorMessage)
          call check_deallocate_f("solve_tridi_single: qtmp", 724,  istat,  errorMessage)

       endif
     enddo
     call obj%timer%stop("solve_tridi_single" // "_single")

    end subroutine solve_tridi_single_problem_&
    &single


end module
