










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
! ELPA1 -- Faster replacements for ScaLAPACK symmetric eigenvalue routines
!
! Copyright of the original code rests with the authors inside the ELPA
! consortium. The copyright of any additional modifications shall rest
! with their original authors, but shall adhere to the licensing terms
! distributed along with the original code in the file "COPYING".
!
! This file has been rewritten by A. Marek, MPCDF

!> \brief Fortran module which provides helper routines for matrix calculations
module elpa1_auxiliary_impl
  use elpa_utilities
  use elpa_cholesky
  use elpa_invert_trm
  use elpa_multiply_a_b

  implicit none

  contains


















!> \brief  elpa_solve_tridi_double_impl: Solve tridiagonal eigensystem for a double-precision matrix with divide and conquer method
!> \details
!> \param  obj                    elpa_t object contains:
!> \param     - obj%na            Order of matrix
!> \param     - obj%nev           number of eigenvalues/vectors to be computed
!> \param     - obj%local_nrows   Leading dimension of q
!> \param     - obj%local_ncols   local columns of matrix q
!> \param     - obj%nblk          blocksize of cyclic distribution, must be the same in both directions!
!> \param     - obj%mpi_comm_rows MPI communicator for rows
!> \param     - obj%mpi_comm_cols MPI communicator for columns
!> \param     - obj%wantDebug     logical, more debug information on failure
!> \param d                       array d(na) on input diagonal elements of tridiagonal matrix, on
!>                                output the eigenvalues in ascending order
!> \param e                       array e(na) on input subdiagonal elements of matrix, on exit destroyed
!> \param q                       on exit : matrix q(ldq,matrixCols) contains the eigenvectors
!> \result succes                 logical, reports success or failure
    function elpa_solve_tridi_double_impl(obj, d, e, q) result(success)

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
! ELPA1 -- Faster replacements for ScaLAPACK symmetric eigenvalue routines
!
! Copyright of the original code rests with the authors inside the ELPA
! consortium. The copyright of any additional modifications shall rest
! with their original authors, but shall adhere to the licensing terms
! distributed along with the original code in the file "COPYING".
!
! Author: A. Marek, MPCDF







      use elpa1_compute, solve_tridi_&
                         &double&
                         &_private_impl => solve_tridi_&
                         &double&
                         &_impl
      use precision
      use elpa_abstract_impl
      use elpa_omp
      use solve_tridi
      implicit none
      class(elpa_abstract_impl_t), intent(inout) :: obj
      integer(kind=ik)         :: na, nev, matrixRows, nblk, matrixCols, mpi_comm_rows, mpi_comm_cols
      integer(kind=ik)         :: mpi_comm_all
      real(kind=rk8) :: d(obj%na), e(obj%na)
      real(kind=rk8) :: q(obj%local_nrows,*)

      logical                  :: wantDebug
      logical                  :: success

      integer                  :: debug, error
      integer                  :: nrThreads, limitThreads

      call obj%timer%start("elpa_solve_tridi_public_&
      &real&
      &_&
      &double&
      &")
      na         = obj%na
      nev        = obj%nev
      nblk       = obj%nblk
      matrixRows = obj%local_nrows
      matrixCols = obj%local_ncols

      nrThreads=1

      call obj%get("mpi_comm_rows", mpi_comm_rows,error)
      if (error .ne. ELPA_OK) then
        print *,"Problem getting option for mpi_comm_rows. Aborting..."
        stop 1
      endif
      call obj%get("mpi_comm_cols", mpi_comm_cols,error)
      if (error .ne. ELPA_OK) then
        print *,"Problem getting option for mpi_comm_cols. Aborting..."
        stop 1
      endif
      call obj%get("mpi_comm_parent", mpi_comm_all,error)
      if (error .ne. ELPA_OK) then
        print *,"Problem getting option for mpi_comm_all. Aborting..."
        stop 1
      endif

      call obj%get("debug",debug,error)
      if (error .ne. ELPA_OK) then
        print *,"Problem getting option for debug. Aborting..."
        stop 1
      endif
      if (debug == 1) then
        wantDebug = .true.
      else
        wantDebug = .false.
      endif
      success = .false.

      call solve_tridi_&
      &double&
      &_private_impl(obj, na, nev, d, e, q, matrixRows, nblk, matrixCols, &
               mpi_comm_all, mpi_comm_rows, mpi_comm_cols,.false., wantDebug, success, &
               nrThreads)


      ! restore original OpenMP settings


      call obj%timer%stop("elpa_solve_tridi_public_&
      &real&
      &_&
      &double&
      &")




    end function




















!> \brief  elpa_solve_tridi_single_impl: Solve tridiagonal eigensystem for a single-precision matrix with divide and conquer method
!> \details
!> \param  obj                    elpa_t object contains:
!> \param     - obj%na            Order of matrix
!> \param     - obj%nev           number of eigenvalues/vectors to be computed
!> \param     - obj%local_nrows   Leading dimension of q
!> \param     - obj%local_ncols   local columns of matrix q
!> \param     - obj%nblk          blocksize of cyclic distribution, must be the same in both directions!
!> \param     - obj%mpi_comm_rows MPI communicator for rows
!> \param     - obj%mpi_comm_cols MPI communicator for columns
!> \param     - obj%wantDebug     logical, more debug information on failure
!> \param d                       array d(na) on input diagonal elements of tridiagonal matrix, on
!>                                output the eigenvalues in ascending order
!> \param e                       array e(na) on input subdiagonal elements of matrix, on exit destroyed
!> \param q                       on exit : matrix q(ldq,matrixCols) contains the eigenvectors
!> \result succes                 logical, reports success or failure
    function elpa_solve_tridi_single_impl(obj, d, e, q) result(success)

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
! ELPA1 -- Faster replacements for ScaLAPACK symmetric eigenvalue routines
!
! Copyright of the original code rests with the authors inside the ELPA
! consortium. The copyright of any additional modifications shall rest
! with their original authors, but shall adhere to the licensing terms
! distributed along with the original code in the file "COPYING".
!
! Author: A. Marek, MPCDF







      use elpa1_compute, solve_tridi_&
                         &single&
                         &_private_impl => solve_tridi_&
                         &single&
                         &_impl
      use precision
      use elpa_abstract_impl
      use elpa_omp
      use solve_tridi
      implicit none
      class(elpa_abstract_impl_t), intent(inout) :: obj
      integer(kind=ik)         :: na, nev, matrixRows, nblk, matrixCols, mpi_comm_rows, mpi_comm_cols
      integer(kind=ik)         :: mpi_comm_all
      real(kind=rk4) :: d(obj%na), e(obj%na)
      real(kind=rk4) :: q(obj%local_nrows,*)

      logical                  :: wantDebug
      logical                  :: success

      integer                  :: debug, error
      integer                  :: nrThreads, limitThreads

      call obj%timer%start("elpa_solve_tridi_public_&
      &real&
      &_&
      &single&
      &")
      na         = obj%na
      nev        = obj%nev
      nblk       = obj%nblk
      matrixRows = obj%local_nrows
      matrixCols = obj%local_ncols

      nrThreads=1

      call obj%get("mpi_comm_rows", mpi_comm_rows,error)
      if (error .ne. ELPA_OK) then
        print *,"Problem getting option for mpi_comm_rows. Aborting..."
        stop 1
      endif
      call obj%get("mpi_comm_cols", mpi_comm_cols,error)
      if (error .ne. ELPA_OK) then
        print *,"Problem getting option for mpi_comm_cols. Aborting..."
        stop 1
      endif
      call obj%get("mpi_comm_parent", mpi_comm_all,error)
      if (error .ne. ELPA_OK) then
        print *,"Problem getting option for mpi_comm_all. Aborting..."
        stop 1
      endif

      call obj%get("debug",debug,error)
      if (error .ne. ELPA_OK) then
        print *,"Problem getting option for debug. Aborting..."
        stop 1
      endif
      if (debug == 1) then
        wantDebug = .true.
      else
        wantDebug = .false.
      endif
      success = .false.

      call solve_tridi_&
      &single&
      &_private_impl(obj, na, nev, d, e, q, matrixRows, nblk, matrixCols, &
               mpi_comm_all, mpi_comm_rows, mpi_comm_cols,.false., wantDebug, success, &
               nrThreads)


      ! restore original OpenMP settings


      call obj%timer%stop("elpa_solve_tridi_public_&
      &real&
      &_&
      &single&
      &")




    end function




end module elpa1_auxiliary_impl

