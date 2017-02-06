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
! Copyright of the original code rests with the authors inside the ELPA
! consortium. The copyright of any additional modifications shall rest
! with their original authors, but shall adhere to the licensing terms
! distributed along with the original code in the file "COPYING".
!
! Author: Andreas Marek, MPCDF

module ELPA_utilities

  implicit none

  private

  public :: debug_messages_via_environment_variable,pcol,prow,error_unit
  public :: map_global_array_index_to_local_index

  integer, parameter :: error_unit = 0

contains

  function debug_messages_via_environment_variable() result(isSet)

    use precision

    implicit none

    logical :: isSet

    isSet = .false.

  end function debug_messages_via_environment_variable

  !Processor col for global col number
  pure function pcol(i,nblk,np_cols) result(col)

    use precision

    implicit none

    integer(kind=ik), intent(in) :: i,nblk,np_cols
    integer(kind=ik)             :: col

    col = MOD((i-1)/nblk,np_cols)

  end function

  !Processor row for global row number
  pure function prow(i,nblk,np_rows) result(row)

    use precision

    implicit none

    integer(kind=ik), intent(in) :: i,nblk,np_rows
    integer(kind=ik)             :: row

    row = MOD((i-1)/nblk,np_rows)

  end function

  function map_global_array_index_to_local_index(iGLobal,jGlobal,iLocal,jLocal,nblk,np_rows,np_cols,my_prow,my_pcol) &
    result(possible)

    use precision

    implicit none

    integer(kind=ik)              :: pi, pj, li, lj, xi, xj
    integer(kind=ik), intent(in)  :: iGlobal, jGlobal, nblk, np_rows, np_cols, my_prow, my_pcol
    integer(kind=ik), intent(out) :: iLocal, jLocal
    logical                       :: possible

    possible = .true.
    iLocal = 0
    jLocal = 0

    pi = prow(iGlobal,nblk,np_rows)

    if(my_prow .ne. pi) then
       possible = .false.
       return
    endif

    pj = pcol(jGlobal,nblk,np_cols)

    if(my_pcol .ne. pj) then
       possible = .false.
       return
    endif

    li = (iGlobal-1)/(np_rows*nblk) ! block number for rows
    lj = (jGlobal-1)/(np_cols*nblk) ! block number for columns

    xi = mod((iGlobal-1),nblk)+1    ! offset in block li
    xj = mod((jGlobal-1),nblk)+1    ! offset in block lj

    iLocal = li*nblk+xi
    jLocal = lj*nblk+xj

  end function

end module ELPA_utilities