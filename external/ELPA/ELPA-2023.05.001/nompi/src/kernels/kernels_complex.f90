










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
! --------------------------------------------------------------------------------------------------
!
! This file contains the compute intensive kernels for the Householder transformations.
! It should be compiled with the highest possible optimization level.
!
! On Intel use -O3 -xSSE4.2 (or the SSE level fitting to your CPU)
!
! Copyright of the original code rests with the authors inside the ELPA
! consortium. The copyright of any additional modifications shall rest
! with their original authors, but shall adhere to the licensing terms
! distributed along with the original code in the file "COPYING".
!
! --------------------------------------------------------------------------------------------------




  ! the Intel compiler creates a temp array copy of array q!
  ! this should be prevented, if possible without using assumed size arrays
  subroutine single_hh_trafo_complex_generic_double(q, hh, nb, nq, ldq)
    use precision
    use elpa_abstract_impl
    implicit none

 !   class(elpa_abstract_impl_t), intent(inout) :: obj
    integer(kind=ik), intent(in)    :: nb, nq, ldq
    complex(kind=ck8), intent(inout) :: q(ldq,*)
    complex(kind=ck8), intent(in)    :: hh(*)

    integer(kind=ik)                :: i

!#ifdef 1
!
!      call obj%timer%start("kernel generic: single_hh_trafo_complex_generic_double")
!
!#else
!
!      call obj%timer%start("kernel generic: single_hh_trafo_complex_generic_single")
!
!#endif
    ! Safety only:

    if(mod(ldq,4) /= 0) STOP 'double_hh_trafo: ldq not divisible by 4!'

    ! Do the Householder transformations

    ! Always a multiple of 4 Q-rows is transformed, even if nq is smaller

    do i=1,nq-8,12

       call hh_trafo_complex_kernel_12_double(q(i,1),hh, nb, ldq)

    enddo

    ! i > nq-8 now, i.e. at most 8 rows remain

    if(nq-i+1 > 4) then

       call hh_trafo_complex_kernel_8_double(q(i,1),hh, nb, ldq)

    else if(nq-i+1 > 0) then

       call hh_trafo_complex_kernel_4_double(q(i,1),hh, nb, ldq)

    endif

!#ifdef 1
!
!      call obj%timer%stop("kernel generic: single_hh_trafo_complex_generic_double")
!
!#else
!
!      call obj%timer%stop("kernel generic: single_hh_trafo_complex_generic_single")
!
!#endif

  end subroutine single_hh_trafo_complex_generic_double
  ! --------------------------------------------------------------------------------------------------

  subroutine double_hh_trafo_complex_generic_double(q, hh, nb, nq, ldq, ldh)
    use precision
    implicit none

    integer(kind=ik), intent(in)    :: nb, nq, ldq, ldh
    complex(kind=ck8), intent(inout) :: q(ldq,*)
    complex(kind=ck8), intent(in)    :: hh(ldh,*)
    complex(kind=ck8)                :: s

    integer(kind=ik)                 :: i

    ! Safety only:

 !     call obj%timer%start("kernel generic: double_hh_trafo_complex_generic_double")

    if(mod(ldq,4) /= 0) STOP 'double_hh_trafo: ldq not divisible by 4!'

    ! Calculate dot product of the two Householder vectors

    s = conjg(hh(2,2)*1)
    do i=3,nb
       s = s+(conjg(hh(i,2))*hh(i-1,1))
    enddo

    ! Do the Householder transformations

    ! Always a multiple of 4 Q-rows is transformed, even if nq is smaller

    do i=1,nq,4

       call hh_trafo_complex_kernel_4_2hv_double(q(i,1),hh, nb, ldq, ldh, s)

    enddo

    !do i=1,nq-8,12

    !   call hh_trafo_complex_kernel_12_2hv(q(i,1),hh, nb, ldq, ldh, s)

    !enddo

    ! i > nq-8 now, i.e. at most 8 rows remain

    !if(nq-i+1 > 4) then

    !   call hh_trafo_complex_kernel_8_2hv(q(i,1),hh, nb, ldq, ldh, s)

    !else if(nq-i+1 > 0) then

    !   call hh_trafo_complex_kernel_4_2hv(q(i:ldq,1:nb+1),hh(1:ldh,1:2), nb, ldq, ldh, s)

    !endif


 !     call obj%timer%stop("kernel generic: double_hh_trafo_complex_generic_double")


  end subroutine double_hh_trafo_complex_generic_double
  ! --------------------------------------------------------------------------------------------------

  subroutine hh_trafo_complex_kernel_12_double(q, hh, nb, ldq)
    use precision
    implicit none

    integer(kind=ik), intent(in)    :: nb, ldq
    complex(kind=ck8), intent(inout) :: q(ldq,*)
    complex(kind=ck8), intent(in)    :: hh(*)
    complex(kind=ck8)                :: x1, x2, x3, x4, x5, x6, x7, x8, x9, xa, xb, xc
    complex(kind=ck8)                :: h1, tau1
    integer(kind=ik)                :: i


   !   call obj%timer%start("kernel generic: hh_trafo_complex_kernel_12_double")

    x1 = q(1,1)
    x2 = q(2,1)
    x3 = q(3,1)
    x4 = q(4,1)
    x5 = q(5,1)
    x6 = q(6,1)
    x7 = q(7,1)
    x8 = q(8,1)
    x9 = q(9,1)
    xa = q(10,1)
    xb = q(11,1)
    xc = q(12,1)

    !DEC$ VECTOR ALIGNED
    do i=2,nb
       h1 = conjg(hh(i))
       x1 = x1 + q(1,i)*h1
       x2 = x2 + q(2,i)*h1
       x3 = x3 + q(3,i)*h1
       x4 = x4 + q(4,i)*h1
       x5 = x5 + q(5,i)*h1
       x6 = x6 + q(6,i)*h1
       x7 = x7 + q(7,i)*h1
       x8 = x8 + q(8,i)*h1
       x9 = x9 + q(9,i)*h1
       xa = xa + q(10,i)*h1
       xb = xb + q(11,i)*h1
       xc = xc + q(12,i)*h1
    enddo

    tau1 = hh(1)

    h1 = -tau1
    x1 = x1*h1
    x2 = x2*h1
    x3 = x3*h1
    x4 = x4*h1
    x5 = x5*h1
    x6 = x6*h1
    x7 = x7*h1
    x8 = x8*h1
    x9 = x9*h1
    xa = xa*h1
    xb = xb*h1
    xc = xc*h1

    q(1,1) = q(1,1) + x1
    q(2,1) = q(2,1) + x2
    q(3,1) = q(3,1) + x3
    q(4,1) = q(4,1) + x4
    q(5,1) = q(5,1) + x5
    q(6,1) = q(6,1) + x6
    q(7,1) = q(7,1) + x7
    q(8,1) = q(8,1) + x8
    q(9,1) = q(9,1) + x9
    q(10,1) = q(10,1) + xa
    q(11,1) = q(11,1) + xb
    q(12,1) = q(12,1) + xc

    !DEC$ VECTOR ALIGNED
    do i=2,nb
       h1 = hh(i)
       q(1,i) = q(1,i) + x1*h1
       q(2,i) = q(2,i) + x2*h1
       q(3,i) = q(3,i) + x3*h1
       q(4,i) = q(4,i) + x4*h1
       q(5,i) = q(5,i) + x5*h1
       q(6,i) = q(6,i) + x6*h1
       q(7,i) = q(7,i) + x7*h1
       q(8,i) = q(8,i) + x8*h1
       q(9,i) = q(9,i) + x9*h1
       q(10,i) = q(10,i) + xa*h1
       q(11,i) = q(11,i) + xb*h1
       q(12,i) = q(12,i) + xc*h1
    enddo


   !   call obj%timer%stop("kernel generic: hh_trafo_complex_kernel_12_double")


  end subroutine hh_trafo_complex_kernel_12_double
  ! --------------------------------------------------------------------------------------------------

  subroutine hh_trafo_complex_kernel_8_double(q, hh, nb, ldq)
    use precision
    implicit none

    integer(kind=ik), intent(in)    :: nb, ldq
    complex(kind=ck8), intent(inout) :: q(ldq,*)
    complex(kind=ck8), intent(in)    :: hh(*)
    complex(kind=ck8)                :: x1, x2, x3, x4, x5, x6, x7, x8
    complex(kind=ck8)                :: h1, tau1
    integer(kind=ik)                :: i


   !   call obj%timer%start("kernel generic: hh_trafo_complex_kernel_8_double")

    x1 = q(1,1)
    x2 = q(2,1)
    x3 = q(3,1)
    x4 = q(4,1)
    x5 = q(5,1)
    x6 = q(6,1)
    x7 = q(7,1)
    x8 = q(8,1)

    !DEC$ VECTOR ALIGNED
    do i=2,nb
       h1 = conjg(hh(i))
       x1 = x1 + q(1,i)*h1
       x2 = x2 + q(2,i)*h1
       x3 = x3 + q(3,i)*h1
       x4 = x4 + q(4,i)*h1
       x5 = x5 + q(5,i)*h1
       x6 = x6 + q(6,i)*h1
       x7 = x7 + q(7,i)*h1
       x8 = x8 + q(8,i)*h1
    enddo

    tau1 = hh(1)

    h1 = -tau1
    x1 = x1*h1
    x2 = x2*h1
    x3 = x3*h1
    x4 = x4*h1
    x5 = x5*h1
    x6 = x6*h1
    x7 = x7*h1
    x8 = x8*h1

    q(1,1) = q(1,1) + x1
    q(2,1) = q(2,1) + x2
    q(3,1) = q(3,1) + x3
    q(4,1) = q(4,1) + x4
    q(5,1) = q(5,1) + x5
    q(6,1) = q(6,1) + x6
    q(7,1) = q(7,1) + x7
    q(8,1) = q(8,1) + x8

    !DEC$ VECTOR ALIGNED
    do i=2,nb
       h1 = hh(i)
       q(1,i) = q(1,i) + x1*h1
       q(2,i) = q(2,i) + x2*h1
       q(3,i) = q(3,i) + x3*h1
       q(4,i) = q(4,i) + x4*h1
       q(5,i) = q(5,i) + x5*h1
       q(6,i) = q(6,i) + x6*h1
       q(7,i) = q(7,i) + x7*h1
       q(8,i) = q(8,i) + x8*h1
    enddo


    !  call obj%timer%stop("kernel generic: hh_trafo_complex_kernel_8_double")


  end subroutine hh_trafo_complex_kernel_8_double
  ! --------------------------------------------------------------------------------------------------

  subroutine hh_trafo_complex_kernel_4_double(q, hh, nb, ldq)
    use precision
    implicit none

    integer(kind=ik), intent(in)    :: nb, ldq
    complex(kind=ck8), intent(inout) :: q(ldq,*)
    complex(kind=ck8), intent(in)    :: hh(*)
    complex(kind=ck8)                :: x1, x2, x3, x4
    complex(kind=ck8)                :: h1, tau1
    integer(kind=ik)                :: i


    !  call obj%timer%start("kernel generic: hh_trafo_complex_kernel_4_double")


    x1 = q(1,1)
    x2 = q(2,1)
    x3 = q(3,1)
    x4 = q(4,1)

    !DEC$ VECTOR ALIGNED
    do i=2,nb
       h1 = conjg(hh(i))
       x1 = x1 + q(1,i)*h1
       x2 = x2 + q(2,i)*h1
       x3 = x3 + q(3,i)*h1
       x4 = x4 + q(4,i)*h1
    enddo

    tau1 = hh(1)

    h1 = -tau1
    x1 = x1*h1
    x2 = x2*h1
    x3 = x3*h1
    x4 = x4*h1

    q(1,1) = q(1,1) + x1
    q(2,1) = q(2,1) + x2
    q(3,1) = q(3,1) + x3
    q(4,1) = q(4,1) + x4

    !DEC$ VECTOR ALIGNED
    do i=2,nb
       h1 = hh(i)
       q(1,i) = q(1,i) + x1*h1
       q(2,i) = q(2,i) + x2*h1
       q(3,i) = q(3,i) + x3*h1
       q(4,i) = q(4,i) + x4*h1
    enddo


   !   call obj%timer%stop("kernel generic: hh_trafo_complex_kernel_4_double")


  end subroutine hh_trafo_complex_kernel_4_double
  ! --------------------------------------------------------------------------------------------------

  subroutine hh_trafo_complex_kernel_4_2hv_double(q, hh, nb, ldq, ldh, s)
    use precision
    implicit none

    integer(kind=ik), intent(in)    :: nb, ldq, ldh
    complex(kind=ck8), intent(inout) :: q(ldq,*)
    complex(kind=ck8), intent(in)    :: hh(ldh,*)
    complex(kind=ck8), intent(in)    :: s

    complex(kind=ck8)                :: x1, x2, x3, x4, y1, y2, y3, y4
    complex(kind=ck8)                :: h1, h2, tau1, tau2
    integer(kind=ik)                :: i


   !   call obj%timer%start("kernel generic: hh_trafo_complex_kernel_4_2hv_double")

    x1 = q(1,2)
    x2 = q(2,2)
    x3 = q(3,2)
    x4 = q(4,2)

    y1 = q(1,1) + q(1,2)*conjg(hh(2,2))
    y2 = q(2,1) + q(2,2)*conjg(hh(2,2))
    y3 = q(3,1) + q(3,2)*conjg(hh(2,2))
    y4 = q(4,1) + q(4,2)*conjg(hh(2,2))

    !DEC$ VECTOR ALIGNED
    do i=3,nb
       h1 = conjg(hh(i-1,1))
       h2 = conjg(hh(i,2))
       x1 = x1 + q(1,i)*h1
       y1 = y1 + q(1,i)*h2
       x2 = x2 + q(2,i)*h1
       y2 = y2 + q(2,i)*h2
       x3 = x3 + q(3,i)*h1
       y3 = y3 + q(3,i)*h2
       x4 = x4 + q(4,i)*h1
       y4 = y4 + q(4,i)*h2
    enddo

    x1 = x1 + q(1,nb+1)*conjg(hh(nb,1))
    x2 = x2 + q(2,nb+1)*conjg(hh(nb,1))
    x3 = x3 + q(3,nb+1)*conjg(hh(nb,1))
    x4 = x4 + q(4,nb+1)*conjg(hh(nb,1))

    tau1 = hh(1,1)
    tau2 = hh(1,2)

    h1 = -tau1
    x1 = x1*h1
    x2 = x2*h1
    x3 = x3*h1
    x4 = x4*h1
    h1 = -tau2
    h2 = -tau2*s
    y1 = y1*h1 + x1*h2
    y2 = y2*h1 + x2*h2
    y3 = y3*h1 + x3*h2
    y4 = y4*h1 + x4*h2

    q(1,1) = q(1,1) + y1
    q(2,1) = q(2,1) + y2
    q(3,1) = q(3,1) + y3
    q(4,1) = q(4,1) + y4

    q(1,2) = q(1,2) + x1 + y1*hh(2,2)
    q(2,2) = q(2,2) + x2 + y2*hh(2,2)
    q(3,2) = q(3,2) + x3 + y3*hh(2,2)
    q(4,2) = q(4,2) + x4 + y4*hh(2,2)

    !DEC$ VECTOR ALIGNED
    do i=3,nb
       h1 = hh(i-1,1)
       h2 = hh(i,2)
       q(1,i) = q(1,i) + x1*h1 + y1*h2
       q(2,i) = q(2,i) + x2*h1 + y2*h2
       q(3,i) = q(3,i) + x3*h1 + y3*h2
       q(4,i) = q(4,i) + x4*h1 + y4*h2
    enddo

    q(1,nb+1) = q(1,nb+1) + x1*hh(nb,1)
    q(2,nb+1) = q(2,nb+1) + x2*hh(nb,1)
    q(3,nb+1) = q(3,nb+1) + x3*hh(nb,1)
    q(4,nb+1) = q(4,nb+1) + x4*hh(nb,1)


   !   call obj%timer%stop("kernel generic: hh_trafo_complex_kernel_4_2hv_double")


  end subroutine hh_trafo_complex_kernel_4_2hv_double

  ! --------------------------------------------------------------------------------------------------

  subroutine hh_trafo_complex_kernel_8_2hv_double(q, hh, nb, ldq, ldh, s)
    use precision
    implicit none

    integer(kind=ik), intent(in)    :: nb, ldq, ldh
    complex(kind=ck8), intent(inout) :: q(ldq,*)
    complex(kind=ck8), intent(in)    :: hh(ldh,*)
    complex(kind=ck8), intent(in)    :: s

    complex(kind=ck8)                :: x1, x2, x3, x4, x5, x6 ,x7, x8, y1, y2, y3, y4, y5, y6, y7, y8
    complex(kind=ck8)                :: h1, h2, tau1, tau2
    integer(kind=ik)                :: i


   !   call obj%timer%start("kernel generic: hh_trafo_complex_kernel_8_2hv_double")


    x1 = q(1,2)
    x2 = q(2,2)
    x3 = q(3,2)
    x4 = q(4,2)
    x5 = q(5,2)
    x6 = q(6,2)
    x7 = q(7,2)
    x8 = q(8,2)

    y1 = q(1,1) + q(1,2)*conjg(hh(2,2))
    y2 = q(2,1) + q(2,2)*conjg(hh(2,2))
    y3 = q(3,1) + q(3,2)*conjg(hh(2,2))
    y4 = q(4,1) + q(4,2)*conjg(hh(2,2))
    y5 = q(5,1) + q(5,2)*conjg(hh(2,2))
    y6 = q(6,1) + q(6,2)*conjg(hh(2,2))
    y7 = q(7,1) + q(7,2)*conjg(hh(2,2))
    y8 = q(8,1) + q(8,2)*conjg(hh(2,2))

    !DEC$ VECTOR ALIGNED
    do i=3,nb
       h1 = conjg(hh(i-1,1))
       h2 = conjg(hh(i,2))
       x1 = x1 + q(1,i)*h1
       y1 = y1 + q(1,i)*h2
       x2 = x2 + q(2,i)*h1
       y2 = y2 + q(2,i)*h2
       x3 = x3 + q(3,i)*h1
       y3 = y3 + q(3,i)*h2
       x4 = x4 + q(4,i)*h1
       y4 = y4 + q(4,i)*h2
       x5 = x5 + q(5,i)*h1
       y5 = y5 + q(5,i)*h2
       x6 = x6 + q(6,i)*h1
       y6 = y6 + q(6,i)*h2
       x7 = x7 + q(7,i)*h1
       y7 = y7 + q(7,i)*h2
       x8 = x8 + q(8,i)*h1
       y8 = y8 + q(8,i)*h2
    enddo

    x1 = x1 + q(1,nb+1)*conjg(hh(nb,1))
    x2 = x2 + q(2,nb+1)*conjg(hh(nb,1))
    x3 = x3 + q(3,nb+1)*conjg(hh(nb,1))
    x4 = x4 + q(4,nb+1)*conjg(hh(nb,1))
    x5 = x5 + q(5,nb+1)*conjg(hh(nb,1))
    x6 = x6 + q(6,nb+1)*conjg(hh(nb,1))
    x7 = x7 + q(7,nb+1)*conjg(hh(nb,1))
    x8 = x8 + q(8,nb+1)*conjg(hh(nb,1))

    tau1 = hh(1,1)
    tau2 = hh(1,2)

    h1 = -tau1
    x1 = x1*h1
    x2 = x2*h1
    x3 = x3*h1
    x4 = x4*h1
    x5 = x5*h1
    x6 = x6*h1
    x7 = x7*h1
    x8 = x8*h1

    h1 = -tau2
    h2 = -tau2*s
    y1 = y1*h1 + x1*h2
    y2 = y2*h1 + x2*h2
    y3 = y3*h1 + x3*h2
    y4 = y4*h1 + x4*h2
    y5 = y5*h1 + x5*h2
    y6 = y6*h1 + x6*h2
    y7 = y7*h1 + x7*h2
    y8 = y8*h1 + x8*h2

    q(1,1) = q(1,1) + y1
    q(2,1) = q(2,1) + y2
    q(3,1) = q(3,1) + y3
    q(4,1) = q(4,1) + y4
    q(5,1) = q(5,1) + y5
    q(6,1) = q(6,1) + y6
    q(7,1) = q(7,1) + y7
    q(8,1) = q(8,1) + y8

    q(1,2) = q(1,2) + x1 + y1*hh(2,2)
    q(2,2) = q(2,2) + x2 + y2*hh(2,2)
    q(3,2) = q(3,2) + x3 + y3*hh(2,2)
    q(4,2) = q(4,2) + x4 + y4*hh(2,2)
    q(5,2) = q(5,2) + x5 + y5*hh(2,2)
    q(6,2) = q(6,2) + x6 + y6*hh(2,2)
    q(7,2) = q(7,2) + x7 + y7*hh(2,2)
    q(8,2) = q(8,2) + x8 + y8*hh(2,2)

    !DEC$ VECTOR ALIGNED
    do i=3,nb
       h1 = hh(i-1,1)
       h2 = hh(i,2)
       q(1,i) = q(1,i) + x1*h1 + y1*h2
       q(2,i) = q(2,i) + x2*h1 + y2*h2
       q(3,i) = q(3,i) + x3*h1 + y3*h2
       q(4,i) = q(4,i) + x4*h1 + y4*h2
       q(5,i) = q(5,i) + x5*h1 + y5*h2
       q(6,i) = q(6,i) + x6*h1 + y6*h2
       q(7,i) = q(7,i) + x7*h1 + y7*h2
       q(8,i) = q(8,i) + x8*h1 + y8*h2
    enddo

    q(1,nb+1) = q(1,nb+1) + x1*hh(nb,1)
    q(2,nb+1) = q(2,nb+1) + x2*hh(nb,1)
    q(3,nb+1) = q(3,nb+1) + x3*hh(nb,1)
    q(4,nb+1) = q(4,nb+1) + x4*hh(nb,1)
    q(5,nb+1) = q(5,nb+1) + x5*hh(nb,1)
    q(6,nb+1) = q(6,nb+1) + x6*hh(nb,1)
    q(7,nb+1) = q(7,nb+1) + x7*hh(nb,1)
    q(8,nb+1) = q(8,nb+1) + x8*hh(nb,1)


   !   call obj%timer%stop("kernel generic: hh_trafo_complex_kernel_8_2hv_double")


  end subroutine hh_trafo_complex_kernel_8_2hv_double
  ! --------------------------------------------------------------------------------------------------

  subroutine hh_trafo_complex_kernel_12_2hv_double(q, hh, nb, ldq, ldh, s)
    use precision
    implicit none

    integer(kind=ik), intent(in)    :: nb, ldq, ldh
    complex(kind=ck8), intent(inout) :: q(ldq,*)
    complex(kind=ck8), intent(in)    :: hh(ldh,*)
    complex(kind=ck8), intent(in)    :: s

    complex(kind=ck8)                :: x1, x2, x3, x4, x5, x6 ,x7, x8, x9, x10, x11, x12, y1, y2, y3, y4, y5, y6, &
                                       y7, y8, y9, y10, y11, y12
    complex(kind=ck8)                :: h1, h2, tau1, tau2
    integer(kind=ik)                :: i


   !   call obj%timer%start("kernel generic: hh_trafo_complex_kernel_12_2hv_double")

    x1 = q(1,2)
    x2 = q(2,2)
    x3 = q(3,2)
    x4 = q(4,2)
    x5 = q(5,2)
    x6 = q(6,2)
    x7 = q(7,2)
    x8 = q(8,2)
    x9 = q(9,2)
    x10 = q(10,2)
    x11 = q(11,2)
    x12 = q(12,2)

    y1 = q(1,1) + q(1,2)*conjg(hh(2,2))
    y2 = q(2,1) + q(2,2)*conjg(hh(2,2))
    y3 = q(3,1) + q(3,2)*conjg(hh(2,2))
    y4 = q(4,1) + q(4,2)*conjg(hh(2,2))
    y5 = q(5,1) + q(5,2)*conjg(hh(2,2))
    y6 = q(6,1) + q(6,2)*conjg(hh(2,2))
    y7 = q(7,1) + q(7,2)*conjg(hh(2,2))
    y8 = q(8,1) + q(8,2)*conjg(hh(2,2))
    y9 = q(9,1) + q(9,2)*conjg(hh(2,2))
    y10 = q(10,1) + q(10,2)*conjg(hh(2,2))
    y11 = q(11,1) + q(11,2)*conjg(hh(2,2))
    y12 = q(12,1) + q(12,2)*conjg(hh(2,2))

    !DEC$ VECTOR ALIGNED
    do i=3,nb
       h1 = conjg(hh(i-1,1))
       h2 = conjg(hh(i,2))
       x1 = x1 + q(1,i)*h1
       y1 = y1 + q(1,i)*h2
       x2 = x2 + q(2,i)*h1
       y2 = y2 + q(2,i)*h2
       x3 = x3 + q(3,i)*h1
       y3 = y3 + q(3,i)*h2
       x4 = x4 + q(4,i)*h1
       y4 = y4 + q(4,i)*h2
       x5 = x5 + q(5,i)*h1
       y5 = y5 + q(5,i)*h2
       x6 = x6 + q(6,i)*h1
       y6 = y6 + q(6,i)*h2
       x7 = x7 + q(7,i)*h1
       y7 = y7 + q(7,i)*h2
       x8 = x8 + q(8,i)*h1
       y8 = y8 + q(8,i)*h2
       x9 = x9 + q(9,i)*h1
       y9 = y9 + q(9,i)*h2
       x10 = x10 + q(10,i)*h1
       y10 = y10 + q(10,i)*h2
       x11 = x11 + q(11,i)*h1
       y11 = y11 + q(11,i)*h2
       x12 = x12 + q(12,i)*h1
       y12 = y12 + q(12,i)*h2
    enddo

    x1 = x1 + q(1,nb+1)*conjg(hh(nb,1))
    x2 = x2 + q(2,nb+1)*conjg(hh(nb,1))
    x3 = x3 + q(3,nb+1)*conjg(hh(nb,1))
    x4 = x4 + q(4,nb+1)*conjg(hh(nb,1))
    x5 = x5 + q(5,nb+1)*conjg(hh(nb,1))
    x6 = x6 + q(6,nb+1)*conjg(hh(nb,1))
    x7 = x7 + q(7,nb+1)*conjg(hh(nb,1))
    x8 = x8 + q(8,nb+1)*conjg(hh(nb,1))
    x9 = x9 + q(9,nb+1)*conjg(hh(nb,1))
    x10 = x10 + q(10,nb+1)*conjg(hh(nb,1))
    x11 = x11 + q(11,nb+1)*conjg(hh(nb,1))
    x12 = x12 + q(12,nb+1)*conjg(hh(nb,1))

    tau1 = hh(1,1)
    tau2 = hh(1,2)

    h1 = -tau1
    x1 = x1*h1
    x2 = x2*h1
    x3 = x3*h1
    x4 = x4*h1
    x5 = x5*h1
    x6 = x6*h1
    x7 = x7*h1
    x8 = x8*h1
    x9 = x9*h1
    x10 = x10*h1
    x11 = x11*h1
    x12 = x12*h1
    h1 = -tau2
    h2 = -tau2*s
    y1 = y1*h1 + x1*h2
    y2 = y2*h1 + x2*h2
    y3 = y3*h1 + x3*h2
    y4 = y4*h1 + x4*h2
    y5 = y5*h1 + x5*h2
    y6 = y6*h1 + x6*h2
    y7 = y7*h1 + x7*h2
    y8 = y8*h1 + x8*h2
    y9 = y9*h1 + x9*h2
    y10 = y10*h1 + x10*h2
    y11 = y11*h1 + x11*h2
    y12 = y12*h1 + x12*h2

    q(1,1) = q(1,1) + y1
    q(2,1) = q(2,1) + y2
    q(3,1) = q(3,1) + y3
    q(4,1) = q(4,1) + y4
    q(5,1) = q(5,1) + y5
    q(6,1) = q(6,1) + y6
    q(7,1) = q(7,1) + y7
    q(8,1) = q(8,1) + y8
    q(9,1) = q(9,1) + y9
    q(10,1) = q(10,1) + y10
    q(11,1) = q(11,1) + y11
    q(12,1) = q(12,1) + y12

    q(1,2) = q(1,2) + x1 + y1*hh(2,2)
    q(2,2) = q(2,2) + x2 + y2*hh(2,2)
    q(3,2) = q(3,2) + x3 + y3*hh(2,2)
    q(4,2) = q(4,2) + x4 + y4*hh(2,2)
    q(5,2) = q(5,2) + x5 + y5*hh(2,2)
    q(6,2) = q(6,2) + x6 + y6*hh(2,2)
    q(7,2) = q(7,2) + x7 + y7*hh(2,2)
    q(8,2) = q(8,2) + x8 + y8*hh(2,2)
    q(9,2) = q(9,2) + x9 + y9*hh(2,2)
    q(10,2) = q(10,2) + x10 + y10*hh(2,2)
    q(11,2) = q(11,2) + x11 + y11*hh(2,2)
    q(12,2) = q(12,2) + x12 + y12*hh(2,2)

    !DEC$ VECTOR ALIGNED
    do i=3,nb
       h1 = hh(i-1,1)
       h2 = hh(i,2)
       q(1,i) = q(1,i) + x1*h1 + y1*h2
       q(2,i) = q(2,i) + x2*h1 + y2*h2
       q(3,i) = q(3,i) + x3*h1 + y3*h2
       q(4,i) = q(4,i) + x4*h1 + y4*h2
       q(5,i) = q(5,i) + x5*h1 + y5*h2
       q(6,i) = q(6,i) + x6*h1 + y6*h2
       q(7,i) = q(7,i) + x7*h1 + y7*h2
       q(8,i) = q(8,i) + x8*h1 + y8*h2
       q(9,i) = q(9,i) + x9*h1 + y9*h2
       q(10,i) = q(10,i) + x10*h1 + y10*h2
       q(11,i) = q(11,i) + x11*h1 + y11*h2
       q(12,i) = q(12,i) + x12*h1 + y12*h2
    enddo

    q(1,nb+1) = q(1,nb+1) + x1*hh(nb,1)
    q(2,nb+1) = q(2,nb+1) + x2*hh(nb,1)
    q(3,nb+1) = q(3,nb+1) + x3*hh(nb,1)
    q(4,nb+1) = q(4,nb+1) + x4*hh(nb,1)
    q(5,nb+1) = q(5,nb+1) + x5*hh(nb,1)
    q(6,nb+1) = q(6,nb+1) + x6*hh(nb,1)
    q(7,nb+1) = q(7,nb+1) + x7*hh(nb,1)
    q(8,nb+1) = q(8,nb+1) + x8*hh(nb,1)
    q(9,nb+1) = q(9,nb+1) + x9*hh(nb,1)
    q(10,nb+1) = q(10,nb+1) + x10*hh(nb,1)
    q(11,nb+1) = q(11,nb+1) + x11*hh(nb,1)
    q(12,nb+1) = q(12,nb+1) + x12*hh(nb,1)


   !   call obj%timer%stop("kernel generic: hh_trafo_complex_kernel_12_2hv_double")


  end subroutine hh_trafo_complex_kernel_12_2hv_double


  ! the Intel compiler creates a temp array copy of array q!
  ! this should be prevented, if possible without using assumed size arrays
  subroutine single_hh_trafo_complex_generic_single(q, hh, nb, nq, ldq)
    use precision
    use elpa_abstract_impl
    implicit none

 !   class(elpa_abstract_impl_t), intent(inout) :: obj
    integer(kind=ik), intent(in)    :: nb, nq, ldq
    complex(kind=ck4), intent(inout) :: q(ldq,*)
    complex(kind=ck4), intent(in)    :: hh(*)

    integer(kind=ik)                :: i

!#ifdef DOUBLE_PRECISION_COMPLEX
!
!      call obj%timer%start("kernel generic: single_hh_trafo_complex_generic_double")
!
!#else
!
!      call obj%timer%start("kernel generic: single_hh_trafo_complex_generic_single")
!
!#endif
    ! Safety only:

    if(mod(ldq,4) /= 0) STOP 'double_hh_trafo: ldq not divisible by 4!'

    ! Do the Householder transformations

    ! Always a multiple of 4 Q-rows is transformed, even if nq is smaller

    do i=1,nq-8,12

       call hh_trafo_complex_kernel_12_single(q(i,1),hh, nb, ldq)

    enddo

    ! i > nq-8 now, i.e. at most 8 rows remain

    if(nq-i+1 > 4) then

       call hh_trafo_complex_kernel_8_single(q(i,1),hh, nb, ldq)

    else if(nq-i+1 > 0) then

       call hh_trafo_complex_kernel_4_single(q(i,1),hh, nb, ldq)

    endif

!#ifdef DOUBLE_PRECISION_COMPLEX
!
!      call obj%timer%stop("kernel generic: single_hh_trafo_complex_generic_double")
!
!#else
!
!      call obj%timer%stop("kernel generic: single_hh_trafo_complex_generic_single")
!
!#endif

  end subroutine single_hh_trafo_complex_generic_single
  ! --------------------------------------------------------------------------------------------------

  subroutine double_hh_trafo_complex_generic_single(q, hh, nb, nq, ldq, ldh)
    use precision
    implicit none

    integer(kind=ik), intent(in)    :: nb, nq, ldq, ldh
    complex(kind=ck4), intent(inout) :: q(ldq,*)
    complex(kind=ck4), intent(in)    :: hh(ldh,*)
    complex(kind=ck4)                :: s

    integer(kind=ik)                 :: i

    ! Safety only:

  !    call obj%timer%start("kernel generic: double_hh_trafo_complex_generic_single")

    if(mod(ldq,4) /= 0) STOP 'double_hh_trafo: ldq not divisible by 4!'

    ! Calculate dot product of the two Householder vectors

    s = conjg(hh(2,2)*1)
    do i=3,nb
       s = s+(conjg(hh(i,2))*hh(i-1,1))
    enddo

    ! Do the Householder transformations

    ! Always a multiple of 4 Q-rows is transformed, even if nq is smaller

    do i=1,nq,4

       call hh_trafo_complex_kernel_4_2hv_single(q(i,1),hh, nb, ldq, ldh, s)

    enddo

    !do i=1,nq-8,12

    !   call hh_trafo_complex_kernel_12_2hv(q(i,1),hh, nb, ldq, ldh, s)

    !enddo

    ! i > nq-8 now, i.e. at most 8 rows remain

    !if(nq-i+1 > 4) then

    !   call hh_trafo_complex_kernel_8_2hv(q(i,1),hh, nb, ldq, ldh, s)

    !else if(nq-i+1 > 0) then

    !   call hh_trafo_complex_kernel_4_2hv(q(i:ldq,1:nb+1),hh(1:ldh,1:2), nb, ldq, ldh, s)

    !endif


  !    call obj%timer%stop("kernel generic: double_hh_trafo_complex_generic_single")


  end subroutine double_hh_trafo_complex_generic_single
  ! --------------------------------------------------------------------------------------------------

  subroutine hh_trafo_complex_kernel_12_single(q, hh, nb, ldq)
    use precision
    implicit none

    integer(kind=ik), intent(in)    :: nb, ldq
    complex(kind=ck4), intent(inout) :: q(ldq,*)
    complex(kind=ck4), intent(in)    :: hh(*)
    complex(kind=ck4)                :: x1, x2, x3, x4, x5, x6, x7, x8, x9, xa, xb, xc
    complex(kind=ck4)                :: h1, tau1
    integer(kind=ik)                :: i


  !    call obj%timer%start("kernel generic: hh_trafo_complex_kernel_12_single")

    x1 = q(1,1)
    x2 = q(2,1)
    x3 = q(3,1)
    x4 = q(4,1)
    x5 = q(5,1)
    x6 = q(6,1)
    x7 = q(7,1)
    x8 = q(8,1)
    x9 = q(9,1)
    xa = q(10,1)
    xb = q(11,1)
    xc = q(12,1)

    !DEC$ VECTOR ALIGNED
    do i=2,nb
       h1 = conjg(hh(i))
       x1 = x1 + q(1,i)*h1
       x2 = x2 + q(2,i)*h1
       x3 = x3 + q(3,i)*h1
       x4 = x4 + q(4,i)*h1
       x5 = x5 + q(5,i)*h1
       x6 = x6 + q(6,i)*h1
       x7 = x7 + q(7,i)*h1
       x8 = x8 + q(8,i)*h1
       x9 = x9 + q(9,i)*h1
       xa = xa + q(10,i)*h1
       xb = xb + q(11,i)*h1
       xc = xc + q(12,i)*h1
    enddo

    tau1 = hh(1)

    h1 = -tau1
    x1 = x1*h1
    x2 = x2*h1
    x3 = x3*h1
    x4 = x4*h1
    x5 = x5*h1
    x6 = x6*h1
    x7 = x7*h1
    x8 = x8*h1
    x9 = x9*h1
    xa = xa*h1
    xb = xb*h1
    xc = xc*h1

    q(1,1) = q(1,1) + x1
    q(2,1) = q(2,1) + x2
    q(3,1) = q(3,1) + x3
    q(4,1) = q(4,1) + x4
    q(5,1) = q(5,1) + x5
    q(6,1) = q(6,1) + x6
    q(7,1) = q(7,1) + x7
    q(8,1) = q(8,1) + x8
    q(9,1) = q(9,1) + x9
    q(10,1) = q(10,1) + xa
    q(11,1) = q(11,1) + xb
    q(12,1) = q(12,1) + xc

    !DEC$ VECTOR ALIGNED
    do i=2,nb
       h1 = hh(i)
       q(1,i) = q(1,i) + x1*h1
       q(2,i) = q(2,i) + x2*h1
       q(3,i) = q(3,i) + x3*h1
       q(4,i) = q(4,i) + x4*h1
       q(5,i) = q(5,i) + x5*h1
       q(6,i) = q(6,i) + x6*h1
       q(7,i) = q(7,i) + x7*h1
       q(8,i) = q(8,i) + x8*h1
       q(9,i) = q(9,i) + x9*h1
       q(10,i) = q(10,i) + xa*h1
       q(11,i) = q(11,i) + xb*h1
       q(12,i) = q(12,i) + xc*h1
    enddo


   !   call obj%timer%stop("kernel generic: hh_trafo_complex_kernel_12_single")


  end subroutine hh_trafo_complex_kernel_12_single
  ! --------------------------------------------------------------------------------------------------

  subroutine hh_trafo_complex_kernel_8_single(q, hh, nb, ldq)
    use precision
    implicit none

    integer(kind=ik), intent(in)    :: nb, ldq
    complex(kind=ck4), intent(inout) :: q(ldq,*)
    complex(kind=ck4), intent(in)    :: hh(*)
    complex(kind=ck4)                :: x1, x2, x3, x4, x5, x6, x7, x8
    complex(kind=ck4)                :: h1, tau1
    integer(kind=ik)                :: i


   !   call obj%timer%start("kernel generic: hh_trafo_complex_kernel_8_single")

    x1 = q(1,1)
    x2 = q(2,1)
    x3 = q(3,1)
    x4 = q(4,1)
    x5 = q(5,1)
    x6 = q(6,1)
    x7 = q(7,1)
    x8 = q(8,1)

    !DEC$ VECTOR ALIGNED
    do i=2,nb
       h1 = conjg(hh(i))
       x1 = x1 + q(1,i)*h1
       x2 = x2 + q(2,i)*h1
       x3 = x3 + q(3,i)*h1
       x4 = x4 + q(4,i)*h1
       x5 = x5 + q(5,i)*h1
       x6 = x6 + q(6,i)*h1
       x7 = x7 + q(7,i)*h1
       x8 = x8 + q(8,i)*h1
    enddo

    tau1 = hh(1)

    h1 = -tau1
    x1 = x1*h1
    x2 = x2*h1
    x3 = x3*h1
    x4 = x4*h1
    x5 = x5*h1
    x6 = x6*h1
    x7 = x7*h1
    x8 = x8*h1

    q(1,1) = q(1,1) + x1
    q(2,1) = q(2,1) + x2
    q(3,1) = q(3,1) + x3
    q(4,1) = q(4,1) + x4
    q(5,1) = q(5,1) + x5
    q(6,1) = q(6,1) + x6
    q(7,1) = q(7,1) + x7
    q(8,1) = q(8,1) + x8

    !DEC$ VECTOR ALIGNED
    do i=2,nb
       h1 = hh(i)
       q(1,i) = q(1,i) + x1*h1
       q(2,i) = q(2,i) + x2*h1
       q(3,i) = q(3,i) + x3*h1
       q(4,i) = q(4,i) + x4*h1
       q(5,i) = q(5,i) + x5*h1
       q(6,i) = q(6,i) + x6*h1
       q(7,i) = q(7,i) + x7*h1
       q(8,i) = q(8,i) + x8*h1
    enddo


   !   call obj%timer%stop("kernel generic: hh_trafo_complex_kernel_8_single")


  end subroutine hh_trafo_complex_kernel_8_single
  ! --------------------------------------------------------------------------------------------------

  subroutine hh_trafo_complex_kernel_4_single(q, hh, nb, ldq)
    use precision
    implicit none

    integer(kind=ik), intent(in)    :: nb, ldq
    complex(kind=ck4), intent(inout) :: q(ldq,*)
    complex(kind=ck4), intent(in)    :: hh(*)
    complex(kind=ck4)                :: x1, x2, x3, x4
    complex(kind=ck4)                :: h1, tau1
    integer(kind=ik)                :: i


    !  call obj%timer%start("kernel generic: hh_trafo_complex_kernel_4_single")


    x1 = q(1,1)
    x2 = q(2,1)
    x3 = q(3,1)
    x4 = q(4,1)

    !DEC$ VECTOR ALIGNED
    do i=2,nb
       h1 = conjg(hh(i))
       x1 = x1 + q(1,i)*h1
       x2 = x2 + q(2,i)*h1
       x3 = x3 + q(3,i)*h1
       x4 = x4 + q(4,i)*h1
    enddo

    tau1 = hh(1)

    h1 = -tau1
    x1 = x1*h1
    x2 = x2*h1
    x3 = x3*h1
    x4 = x4*h1

    q(1,1) = q(1,1) + x1
    q(2,1) = q(2,1) + x2
    q(3,1) = q(3,1) + x3
    q(4,1) = q(4,1) + x4

    !DEC$ VECTOR ALIGNED
    do i=2,nb
       h1 = hh(i)
       q(1,i) = q(1,i) + x1*h1
       q(2,i) = q(2,i) + x2*h1
       q(3,i) = q(3,i) + x3*h1
       q(4,i) = q(4,i) + x4*h1
    enddo


   !   call obj%timer%stop("kernel generic: hh_trafo_complex_kernel_4_single")


  end subroutine hh_trafo_complex_kernel_4_single
  ! --------------------------------------------------------------------------------------------------

  subroutine hh_trafo_complex_kernel_4_2hv_single(q, hh, nb, ldq, ldh, s)
    use precision
    implicit none

    integer(kind=ik), intent(in)    :: nb, ldq, ldh
    complex(kind=ck4), intent(inout) :: q(ldq,*)
    complex(kind=ck4), intent(in)    :: hh(ldh,*)
    complex(kind=ck4), intent(in)    :: s

    complex(kind=ck4)                :: x1, x2, x3, x4, y1, y2, y3, y4
    complex(kind=ck4)                :: h1, h2, tau1, tau2
    integer(kind=ik)                :: i


  !    call obj%timer%start("kernel generic: hh_trafo_complex_kernel_4_2hv_single")

    x1 = q(1,2)
    x2 = q(2,2)
    x3 = q(3,2)
    x4 = q(4,2)

    y1 = q(1,1) + q(1,2)*conjg(hh(2,2))
    y2 = q(2,1) + q(2,2)*conjg(hh(2,2))
    y3 = q(3,1) + q(3,2)*conjg(hh(2,2))
    y4 = q(4,1) + q(4,2)*conjg(hh(2,2))

    !DEC$ VECTOR ALIGNED
    do i=3,nb
       h1 = conjg(hh(i-1,1))
       h2 = conjg(hh(i,2))
       x1 = x1 + q(1,i)*h1
       y1 = y1 + q(1,i)*h2
       x2 = x2 + q(2,i)*h1
       y2 = y2 + q(2,i)*h2
       x3 = x3 + q(3,i)*h1
       y3 = y3 + q(3,i)*h2
       x4 = x4 + q(4,i)*h1
       y4 = y4 + q(4,i)*h2
    enddo

    x1 = x1 + q(1,nb+1)*conjg(hh(nb,1))
    x2 = x2 + q(2,nb+1)*conjg(hh(nb,1))
    x3 = x3 + q(3,nb+1)*conjg(hh(nb,1))
    x4 = x4 + q(4,nb+1)*conjg(hh(nb,1))

    tau1 = hh(1,1)
    tau2 = hh(1,2)

    h1 = -tau1
    x1 = x1*h1
    x2 = x2*h1
    x3 = x3*h1
    x4 = x4*h1
    h1 = -tau2
    h2 = -tau2*s
    y1 = y1*h1 + x1*h2
    y2 = y2*h1 + x2*h2
    y3 = y3*h1 + x3*h2
    y4 = y4*h1 + x4*h2

    q(1,1) = q(1,1) + y1
    q(2,1) = q(2,1) + y2
    q(3,1) = q(3,1) + y3
    q(4,1) = q(4,1) + y4

    q(1,2) = q(1,2) + x1 + y1*hh(2,2)
    q(2,2) = q(2,2) + x2 + y2*hh(2,2)
    q(3,2) = q(3,2) + x3 + y3*hh(2,2)
    q(4,2) = q(4,2) + x4 + y4*hh(2,2)

    !DEC$ VECTOR ALIGNED
    do i=3,nb
       h1 = hh(i-1,1)
       h2 = hh(i,2)
       q(1,i) = q(1,i) + x1*h1 + y1*h2
       q(2,i) = q(2,i) + x2*h1 + y2*h2
       q(3,i) = q(3,i) + x3*h1 + y3*h2
       q(4,i) = q(4,i) + x4*h1 + y4*h2
    enddo

    q(1,nb+1) = q(1,nb+1) + x1*hh(nb,1)
    q(2,nb+1) = q(2,nb+1) + x2*hh(nb,1)
    q(3,nb+1) = q(3,nb+1) + x3*hh(nb,1)
    q(4,nb+1) = q(4,nb+1) + x4*hh(nb,1)


   !   call obj%timer%stop("kernel generic: hh_trafo_complex_kernel_4_2hv_single")


  end subroutine hh_trafo_complex_kernel_4_2hv_single

  ! --------------------------------------------------------------------------------------------------

  subroutine hh_trafo_complex_kernel_8_2hv_single(q, hh, nb, ldq, ldh, s)
    use precision
    implicit none

    integer(kind=ik), intent(in)    :: nb, ldq, ldh
    complex(kind=ck4), intent(inout) :: q(ldq,*)
    complex(kind=ck4), intent(in)    :: hh(ldh,*)
    complex(kind=ck4), intent(in)    :: s

    complex(kind=ck4)                :: x1, x2, x3, x4, x5, x6 ,x7, x8, y1, y2, y3, y4, y5, y6, y7, y8
    complex(kind=ck4)                :: h1, h2, tau1, tau2
    integer(kind=ik)                :: i


   !   call obj%timer%start("kernel generic: hh_trafo_complex_kernel_8_2hv_single")


    x1 = q(1,2)
    x2 = q(2,2)
    x3 = q(3,2)
    x4 = q(4,2)
    x5 = q(5,2)
    x6 = q(6,2)
    x7 = q(7,2)
    x8 = q(8,2)

    y1 = q(1,1) + q(1,2)*conjg(hh(2,2))
    y2 = q(2,1) + q(2,2)*conjg(hh(2,2))
    y3 = q(3,1) + q(3,2)*conjg(hh(2,2))
    y4 = q(4,1) + q(4,2)*conjg(hh(2,2))
    y5 = q(5,1) + q(5,2)*conjg(hh(2,2))
    y6 = q(6,1) + q(6,2)*conjg(hh(2,2))
    y7 = q(7,1) + q(7,2)*conjg(hh(2,2))
    y8 = q(8,1) + q(8,2)*conjg(hh(2,2))

    !DEC$ VECTOR ALIGNED
    do i=3,nb
       h1 = conjg(hh(i-1,1))
       h2 = conjg(hh(i,2))
       x1 = x1 + q(1,i)*h1
       y1 = y1 + q(1,i)*h2
       x2 = x2 + q(2,i)*h1
       y2 = y2 + q(2,i)*h2
       x3 = x3 + q(3,i)*h1
       y3 = y3 + q(3,i)*h2
       x4 = x4 + q(4,i)*h1
       y4 = y4 + q(4,i)*h2
       x5 = x5 + q(5,i)*h1
       y5 = y5 + q(5,i)*h2
       x6 = x6 + q(6,i)*h1
       y6 = y6 + q(6,i)*h2
       x7 = x7 + q(7,i)*h1
       y7 = y7 + q(7,i)*h2
       x8 = x8 + q(8,i)*h1
       y8 = y8 + q(8,i)*h2
    enddo

    x1 = x1 + q(1,nb+1)*conjg(hh(nb,1))
    x2 = x2 + q(2,nb+1)*conjg(hh(nb,1))
    x3 = x3 + q(3,nb+1)*conjg(hh(nb,1))
    x4 = x4 + q(4,nb+1)*conjg(hh(nb,1))
    x5 = x5 + q(5,nb+1)*conjg(hh(nb,1))
    x6 = x6 + q(6,nb+1)*conjg(hh(nb,1))
    x7 = x7 + q(7,nb+1)*conjg(hh(nb,1))
    x8 = x8 + q(8,nb+1)*conjg(hh(nb,1))

    tau1 = hh(1,1)
    tau2 = hh(1,2)

    h1 = -tau1
    x1 = x1*h1
    x2 = x2*h1
    x3 = x3*h1
    x4 = x4*h1
    x5 = x5*h1
    x6 = x6*h1
    x7 = x7*h1
    x8 = x8*h1

    h1 = -tau2
    h2 = -tau2*s
    y1 = y1*h1 + x1*h2
    y2 = y2*h1 + x2*h2
    y3 = y3*h1 + x3*h2
    y4 = y4*h1 + x4*h2
    y5 = y5*h1 + x5*h2
    y6 = y6*h1 + x6*h2
    y7 = y7*h1 + x7*h2
    y8 = y8*h1 + x8*h2

    q(1,1) = q(1,1) + y1
    q(2,1) = q(2,1) + y2
    q(3,1) = q(3,1) + y3
    q(4,1) = q(4,1) + y4
    q(5,1) = q(5,1) + y5
    q(6,1) = q(6,1) + y6
    q(7,1) = q(7,1) + y7
    q(8,1) = q(8,1) + y8

    q(1,2) = q(1,2) + x1 + y1*hh(2,2)
    q(2,2) = q(2,2) + x2 + y2*hh(2,2)
    q(3,2) = q(3,2) + x3 + y3*hh(2,2)
    q(4,2) = q(4,2) + x4 + y4*hh(2,2)
    q(5,2) = q(5,2) + x5 + y5*hh(2,2)
    q(6,2) = q(6,2) + x6 + y6*hh(2,2)
    q(7,2) = q(7,2) + x7 + y7*hh(2,2)
    q(8,2) = q(8,2) + x8 + y8*hh(2,2)

    !DEC$ VECTOR ALIGNED
    do i=3,nb
       h1 = hh(i-1,1)
       h2 = hh(i,2)
       q(1,i) = q(1,i) + x1*h1 + y1*h2
       q(2,i) = q(2,i) + x2*h1 + y2*h2
       q(3,i) = q(3,i) + x3*h1 + y3*h2
       q(4,i) = q(4,i) + x4*h1 + y4*h2
       q(5,i) = q(5,i) + x5*h1 + y5*h2
       q(6,i) = q(6,i) + x6*h1 + y6*h2
       q(7,i) = q(7,i) + x7*h1 + y7*h2
       q(8,i) = q(8,i) + x8*h1 + y8*h2
    enddo

    q(1,nb+1) = q(1,nb+1) + x1*hh(nb,1)
    q(2,nb+1) = q(2,nb+1) + x2*hh(nb,1)
    q(3,nb+1) = q(3,nb+1) + x3*hh(nb,1)
    q(4,nb+1) = q(4,nb+1) + x4*hh(nb,1)
    q(5,nb+1) = q(5,nb+1) + x5*hh(nb,1)
    q(6,nb+1) = q(6,nb+1) + x6*hh(nb,1)
    q(7,nb+1) = q(7,nb+1) + x7*hh(nb,1)
    q(8,nb+1) = q(8,nb+1) + x8*hh(nb,1)


    !  call obj%timer%stop("kernel generic: hh_trafo_complex_kernel_8_2hv_single")


  end subroutine hh_trafo_complex_kernel_8_2hv_single
  ! --------------------------------------------------------------------------------------------------

  subroutine hh_trafo_complex_kernel_12_2hv_single(q, hh, nb, ldq, ldh, s)
    use precision
    implicit none

    integer(kind=ik), intent(in)    :: nb, ldq, ldh
    complex(kind=ck4), intent(inout) :: q(ldq,*)
    complex(kind=ck4), intent(in)    :: hh(ldh,*)
    complex(kind=ck4), intent(in)    :: s

    complex(kind=ck4)                :: x1, x2, x3, x4, x5, x6 ,x7, x8, x9, x10, x11, x12, y1, y2, y3, y4, y5, y6, &
                                       y7, y8, y9, y10, y11, y12
    complex(kind=ck4)                :: h1, h2, tau1, tau2
    integer(kind=ik)                :: i


  !    call obj%timer%start("kernel generic: hh_trafo_complex_kernel_12_2hv_single")

    x1 = q(1,2)
    x2 = q(2,2)
    x3 = q(3,2)
    x4 = q(4,2)
    x5 = q(5,2)
    x6 = q(6,2)
    x7 = q(7,2)
    x8 = q(8,2)
    x9 = q(9,2)
    x10 = q(10,2)
    x11 = q(11,2)
    x12 = q(12,2)

    y1 = q(1,1) + q(1,2)*conjg(hh(2,2))
    y2 = q(2,1) + q(2,2)*conjg(hh(2,2))
    y3 = q(3,1) + q(3,2)*conjg(hh(2,2))
    y4 = q(4,1) + q(4,2)*conjg(hh(2,2))
    y5 = q(5,1) + q(5,2)*conjg(hh(2,2))
    y6 = q(6,1) + q(6,2)*conjg(hh(2,2))
    y7 = q(7,1) + q(7,2)*conjg(hh(2,2))
    y8 = q(8,1) + q(8,2)*conjg(hh(2,2))
    y9 = q(9,1) + q(9,2)*conjg(hh(2,2))
    y10 = q(10,1) + q(10,2)*conjg(hh(2,2))
    y11 = q(11,1) + q(11,2)*conjg(hh(2,2))
    y12 = q(12,1) + q(12,2)*conjg(hh(2,2))

    !DEC$ VECTOR ALIGNED
    do i=3,nb
       h1 = conjg(hh(i-1,1))
       h2 = conjg(hh(i,2))
       x1 = x1 + q(1,i)*h1
       y1 = y1 + q(1,i)*h2
       x2 = x2 + q(2,i)*h1
       y2 = y2 + q(2,i)*h2
       x3 = x3 + q(3,i)*h1
       y3 = y3 + q(3,i)*h2
       x4 = x4 + q(4,i)*h1
       y4 = y4 + q(4,i)*h2
       x5 = x5 + q(5,i)*h1
       y5 = y5 + q(5,i)*h2
       x6 = x6 + q(6,i)*h1
       y6 = y6 + q(6,i)*h2
       x7 = x7 + q(7,i)*h1
       y7 = y7 + q(7,i)*h2
       x8 = x8 + q(8,i)*h1
       y8 = y8 + q(8,i)*h2
       x9 = x9 + q(9,i)*h1
       y9 = y9 + q(9,i)*h2
       x10 = x10 + q(10,i)*h1
       y10 = y10 + q(10,i)*h2
       x11 = x11 + q(11,i)*h1
       y11 = y11 + q(11,i)*h2
       x12 = x12 + q(12,i)*h1
       y12 = y12 + q(12,i)*h2
    enddo

    x1 = x1 + q(1,nb+1)*conjg(hh(nb,1))
    x2 = x2 + q(2,nb+1)*conjg(hh(nb,1))
    x3 = x3 + q(3,nb+1)*conjg(hh(nb,1))
    x4 = x4 + q(4,nb+1)*conjg(hh(nb,1))
    x5 = x5 + q(5,nb+1)*conjg(hh(nb,1))
    x6 = x6 + q(6,nb+1)*conjg(hh(nb,1))
    x7 = x7 + q(7,nb+1)*conjg(hh(nb,1))
    x8 = x8 + q(8,nb+1)*conjg(hh(nb,1))
    x9 = x9 + q(9,nb+1)*conjg(hh(nb,1))
    x10 = x10 + q(10,nb+1)*conjg(hh(nb,1))
    x11 = x11 + q(11,nb+1)*conjg(hh(nb,1))
    x12 = x12 + q(12,nb+1)*conjg(hh(nb,1))

    tau1 = hh(1,1)
    tau2 = hh(1,2)

    h1 = -tau1
    x1 = x1*h1
    x2 = x2*h1
    x3 = x3*h1
    x4 = x4*h1
    x5 = x5*h1
    x6 = x6*h1
    x7 = x7*h1
    x8 = x8*h1
    x9 = x9*h1
    x10 = x10*h1
    x11 = x11*h1
    x12 = x12*h1
    h1 = -tau2
    h2 = -tau2*s
    y1 = y1*h1 + x1*h2
    y2 = y2*h1 + x2*h2
    y3 = y3*h1 + x3*h2
    y4 = y4*h1 + x4*h2
    y5 = y5*h1 + x5*h2
    y6 = y6*h1 + x6*h2
    y7 = y7*h1 + x7*h2
    y8 = y8*h1 + x8*h2
    y9 = y9*h1 + x9*h2
    y10 = y10*h1 + x10*h2
    y11 = y11*h1 + x11*h2
    y12 = y12*h1 + x12*h2

    q(1,1) = q(1,1) + y1
    q(2,1) = q(2,1) + y2
    q(3,1) = q(3,1) + y3
    q(4,1) = q(4,1) + y4
    q(5,1) = q(5,1) + y5
    q(6,1) = q(6,1) + y6
    q(7,1) = q(7,1) + y7
    q(8,1) = q(8,1) + y8
    q(9,1) = q(9,1) + y9
    q(10,1) = q(10,1) + y10
    q(11,1) = q(11,1) + y11
    q(12,1) = q(12,1) + y12

    q(1,2) = q(1,2) + x1 + y1*hh(2,2)
    q(2,2) = q(2,2) + x2 + y2*hh(2,2)
    q(3,2) = q(3,2) + x3 + y3*hh(2,2)
    q(4,2) = q(4,2) + x4 + y4*hh(2,2)
    q(5,2) = q(5,2) + x5 + y5*hh(2,2)
    q(6,2) = q(6,2) + x6 + y6*hh(2,2)
    q(7,2) = q(7,2) + x7 + y7*hh(2,2)
    q(8,2) = q(8,2) + x8 + y8*hh(2,2)
    q(9,2) = q(9,2) + x9 + y9*hh(2,2)
    q(10,2) = q(10,2) + x10 + y10*hh(2,2)
    q(11,2) = q(11,2) + x11 + y11*hh(2,2)
    q(12,2) = q(12,2) + x12 + y12*hh(2,2)

    !DEC$ VECTOR ALIGNED
    do i=3,nb
       h1 = hh(i-1,1)
       h2 = hh(i,2)
       q(1,i) = q(1,i) + x1*h1 + y1*h2
       q(2,i) = q(2,i) + x2*h1 + y2*h2
       q(3,i) = q(3,i) + x3*h1 + y3*h2
       q(4,i) = q(4,i) + x4*h1 + y4*h2
       q(5,i) = q(5,i) + x5*h1 + y5*h2
       q(6,i) = q(6,i) + x6*h1 + y6*h2
       q(7,i) = q(7,i) + x7*h1 + y7*h2
       q(8,i) = q(8,i) + x8*h1 + y8*h2
       q(9,i) = q(9,i) + x9*h1 + y9*h2
       q(10,i) = q(10,i) + x10*h1 + y10*h2
       q(11,i) = q(11,i) + x11*h1 + y11*h2
       q(12,i) = q(12,i) + x12*h1 + y12*h2
    enddo

    q(1,nb+1) = q(1,nb+1) + x1*hh(nb,1)
    q(2,nb+1) = q(2,nb+1) + x2*hh(nb,1)
    q(3,nb+1) = q(3,nb+1) + x3*hh(nb,1)
    q(4,nb+1) = q(4,nb+1) + x4*hh(nb,1)
    q(5,nb+1) = q(5,nb+1) + x5*hh(nb,1)
    q(6,nb+1) = q(6,nb+1) + x6*hh(nb,1)
    q(7,nb+1) = q(7,nb+1) + x7*hh(nb,1)
    q(8,nb+1) = q(8,nb+1) + x8*hh(nb,1)
    q(9,nb+1) = q(9,nb+1) + x9*hh(nb,1)
    q(10,nb+1) = q(10,nb+1) + x10*hh(nb,1)
    q(11,nb+1) = q(11,nb+1) + x11*hh(nb,1)
    q(12,nb+1) = q(12,nb+1) + x12*hh(nb,1)


   !   call obj%timer%stop("kernel generic: hh_trafo_complex_kernel_12_2hv_single")


  end subroutine hh_trafo_complex_kernel_12_2hv_single


! --------------------------------------------------------------------------------------------------
