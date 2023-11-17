










!    Copyright 2014, A. Marek
!
!    This file is part of ELPA.
!
!    The ELPA library was originally created by the ELPA consortium,
!    consisting of the following organizations:
!
!    - Rechenzentrum Garching der Max-Planck-Gesellschaft (RZG),
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
! This file was written by A. Marek, MPCDF


module test_cuda_functions
  use, intrinsic :: iso_c_binding
  use precision_for_tests
  implicit none

  public


!    Copyright 2014 - 2023, A. Marek
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
! Author: Andreas Marek, MPCDF
! This file is the generated version. Do NOT edit


  integer(kind=ik) :: cudaMemcpyHostToDevice
  integer(kind=ik) :: cudaMemcpyDeviceToHost
  integer(kind=ik) :: cudaMemcpyDeviceToDevice
  integer(kind=ik) :: cudaHostRegisterDefault
  integer(kind=ik) :: cudaHostRegisterPortable
  integer(kind=ik) :: cudaHostRegisterMapped

  integer(kind=ik) :: cublasPointerModeDevice
  integer(kind=ik) :: cublasPointerModeHost

  ! streams

  interface
    function cuda_stream_create_c(cudaStream) result(istat) &
             bind(C, name="cudaStreamCreateFromC")
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=C_intptr_T) :: cudaStream
      integer(kind=C_INT)      :: istat
    end function
  end interface

  interface
    function cuda_stream_destroy_c(cudaStream) result(istat) &
             bind(C, name="cudaStreamDestroyFromC")
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=C_intptr_T), value :: cudaStream
      integer(kind=C_INT)             :: istat
    end function
  end interface

  interface
    function cuda_stream_synchronize_explicit_c(cudaStream) result(istat) &
             bind(C, name="cudaStreamSynchronizeExplicitFromC")
      use, intrinsic :: iso_c_binding
      implicit none

      integer(kind=C_intptr_T), value  :: cudaStream
      integer(kind=C_INT)              :: istat
    end function
  end interface

  interface
    function cuda_stream_synchronize_implicit_c() result(istat) &
             bind(C, name="cudaStreamSynchronizeImplicitFromC")
      use, intrinsic :: iso_c_binding
      implicit none

      integer(kind=C_INT)              :: istat
    end function
  end interface

  interface
    function cublas_set_stream_c(cudaHandle, cudaStream) result(istat) &
             bind(C, name="cublasSetStreamFromC")
      use, intrinsic :: iso_c_binding
      implicit none

      integer(kind=C_intptr_T), value  :: cudaHandle
      integer(kind=C_intptr_T), value  :: cudaStream
      integer(kind=C_INT)              :: istat
    end function
  end interface

  interface
    function cusolver_set_stream_c(cusolverHandle, cudaStream) result(istat) &
             bind(C, name="cusolverSetStreamFromC")
      use, intrinsic :: iso_c_binding
      implicit none

      integer(kind=C_intptr_T), value  :: cusolverHandle
      integer(kind=C_intptr_T), value  :: cudaStream
      integer(kind=C_INT)              :: istat
    end function
  end interface

  ! functions to set and query the GPU devices
  interface
    function cublas_create_c(cudaHandle) result(istat) &
             bind(C, name="cublasCreateFromC")
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=C_intptr_T) :: cudaHandle
      integer(kind=C_INT)      :: istat
    end function
  end interface

  interface
    function cublas_destroy_c(cudaHandle) result(istat) &
             bind(C, name="cublasDestroyFromC")
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=C_intptr_T), value :: cudaHandle
      integer(kind=C_INT)      :: istat
    end function
  end interface

  interface
    function cusolver_create_c(cusolverHandle) result(istat) &
             bind(C, name="cusolverCreateFromC")
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=C_intptr_T) :: cusolverHandle
      integer(kind=C_INT)      :: istat
    end function
  end interface

  interface
    function cusolver_destroy_c(cusolverHandle) result(istat) &
             bind(C, name="cusolverDestroyFromC")
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=C_intptr_T), value :: cusolverHandle
      integer(kind=C_INT)      :: istat
    end function
  end interface

  interface
    function cuda_setdevice_c(n) result(istat) &
             bind(C, name="cudaSetDeviceFromC")

      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=C_INT), value    :: n
      integer(kind=C_INT)           :: istat
    end function
  end interface

  interface
    function cuda_getdevicecount_c(n) result(istat) &
             bind(C, name="cudaGetDeviceCountFromC")
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=C_INT), intent(out) :: n
      integer(kind=C_INT)              :: istat
    end function
  end interface

  interface
    function cuda_devicesynchronize_c()result(istat) &
             bind(C,name="cudaDeviceSynchronizeFromC")

      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=C_INT)                       :: istat
    end function
  end interface

  ! functions to copy GPU memory
  interface
    function cuda_memcpyDeviceToDevice_c() result(flag) &
             bind(C, name="cudaMemcpyDeviceToDeviceFromC")
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=c_int) :: flag
    end function
  end interface

  interface
    function cuda_memcpyHostToDevice_c() result(flag) &
             bind(C, name="cudaMemcpyHostToDeviceFromC")
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=c_int) :: flag
    end function
  end interface

  interface
    function cuda_memcpyDeviceToHost_c() result(flag) &
             bind(C, name="cudaMemcpyDeviceToHostFromC")
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=c_int) :: flag
    end function
  end interface

  interface
    function cuda_hostRegisterDefault_c() result(flag) &
             bind(C, name="cudaHostRegisterDefaultFromC")
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=c_int) :: flag
    end function
  end interface

  interface
    function cuda_hostRegisterPortable_c() result(flag) &
             bind(C, name="cudaHostRegisterPortableFromC")
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=c_int) :: flag
    end function
  end interface

  interface
    function cuda_hostRegisterMapped_c() result(flag) &
             bind(C, name="cudaHostRegisterMappedFromC")
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=c_int) :: flag
    end function
  end interface

  interface
    function cuda_memcpy_intptr_c(dst, src, size, dir) result(istat) &
             bind(C, name="cudaMemcpyFromC")
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=C_intptr_t), value              :: dst
      integer(kind=C_intptr_t), value              :: src
      integer(kind=c_intptr_t), intent(in), value    :: size
      integer(kind=C_INT), intent(in), value       :: dir
      integer(kind=C_INT)                          :: istat
    end function
  end interface

  interface
    function cuda_memcpy_cptr_c(dst, src, size, dir) result(istat) &
             bind(C, name="cudaMemcpyFromC")
      use, intrinsic :: iso_c_binding
      implicit none
      type(c_ptr), value                           :: dst
      type(c_ptr), value                           :: src
      integer(kind=c_intptr_t), intent(in), value  :: size
      integer(kind=C_INT), intent(in), value       :: dir
      integer(kind=C_INT)                          :: istat
    end function
  end interface

  interface
    function cuda_memcpy_mixed_to_device_c(dst, src, size, dir) result(istat) &
             bind(C, name="cudaMemcpyFromC")
      use, intrinsic :: iso_c_binding
      implicit none
      type(c_ptr), value                           :: dst
      integer(kind=c_intptr_t), value              :: src
      integer(kind=c_intptr_t), intent(in), value  :: size
      integer(kind=C_INT), intent(in), value       :: dir
      integer(kind=C_INT)                          :: istat
    end function
  end interface

  interface
    function cuda_memcpy_mixed_to_host_c(dst, src, size, dir) result(istat) &
             bind(C, name="cudaMemcpyFromC")
      use, intrinsic :: iso_c_binding
      implicit none
      type(c_ptr), value                           :: src
      integer(kind=c_intptr_t), value              :: dst
      integer(kind=c_intptr_t), intent(in), value  :: size
      integer(kind=C_INT), intent(in), value       :: dir
      integer(kind=C_INT)                          :: istat
    end function
  end interface

  interface
    function cuda_memcpy_async_intptr_c(dst, src, size, dir, cudaStream) result(istat) &
             bind(C, name="cudaMemcpyAsyncFromC")
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=C_intptr_t), value              :: dst
      integer(kind=C_intptr_t), value              :: src
      integer(kind=c_intptr_t), intent(in), value  :: size
      integer(kind=C_INT), intent(in), value       :: dir
      integer(kind=c_intptr_t), value              :: cudaStream
      integer(kind=C_INT)                          :: istat
    end function
  end interface

  interface
    function cuda_memcpy_async_cptr_c(dst, src, size, dir, cudaStream) result(istat) &
             bind(C, name="cudaMemcpyAsyncFromC")
      use, intrinsic :: iso_c_binding
      implicit none
      type(c_ptr), value                           :: dst
      type(c_ptr), value                           :: src
      integer(kind=c_intptr_t), intent(in), value  :: size
      integer(kind=C_INT), intent(in), value       :: dir
      integer(kind=c_intptr_t), value              :: cudaStream
      integer(kind=C_INT)                          :: istat
    end function
  end interface

  interface
    function cuda_memcpy_async_mixed_to_device_c(dst, src, size, dir, cudaStream) result(istat) &
             bind(C, name="cudaMemcpyAsyncFromC")
      use, intrinsic :: iso_c_binding
      implicit none
      type(c_ptr), value                           :: dst
      integer(kind=C_intptr_t), value              :: src
      integer(kind=c_intptr_t), intent(in), value  :: size
      integer(kind=C_INT), intent(in), value       :: dir
      integer(kind=c_intptr_t), value              :: cudaStream
      integer(kind=C_INT)                          :: istat
    end function
  end interface

  interface
    function cuda_memcpy_async_mixed_to_host_c(dst, src, size, dir, cudaStream) result(istat) &
             bind(C, name="cudaMemcpyAsyncFromC")
      use, intrinsic :: iso_c_binding
      implicit none
      type(c_ptr), value                           :: src
      integer(kind=C_intptr_t), value              :: dst
      integer(kind=c_intptr_t), intent(in), value  :: size
      integer(kind=C_INT), intent(in), value       :: dir
      integer(kind=c_intptr_t), value              :: cudaStream
      integer(kind=C_INT)                          :: istat
    end function
  end interface

  interface
    function cuda_memcpy2d_intptr_c(dst, dpitch, src, spitch, width, height , dir) result(istat) &
             bind(C, name="cudaMemcpy2dFromC")
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=C_intptr_T), value                :: dst
      integer(kind=c_intptr_t), intent(in), value    :: dpitch
      integer(kind=C_intptr_T), value                :: src
      integer(kind=c_intptr_t), intent(in), value    :: spitch
      integer(kind=c_intptr_t), intent(in), value    :: width
      integer(kind=c_intptr_t), intent(in), value    :: height
      integer(kind=C_INT), intent(in), value         :: dir
      integer(kind=C_INT)                            :: istat
    end function
  end interface

  interface
    function cuda_memcpy2d_cptr_c(dst, dpitch, src, spitch, width, height , dir) result(istat) &
             bind(C, name="cudaMemcpy2dFromC")
      use, intrinsic :: iso_c_binding
      implicit none
      type(c_ptr), value                :: dst
      integer(kind=c_intptr_t), intent(in), value    :: dpitch
      type(c_ptr), value                :: src
      integer(kind=c_intptr_t), intent(in), value    :: spitch
      integer(kind=c_intptr_t), intent(in), value    :: width
      integer(kind=c_intptr_t), intent(in), value    :: height
      integer(kind=C_INT), intent(in), value         :: dir
      integer(kind=C_INT)                            :: istat
    end function
  end interface

  interface
    function cuda_memcpy2d_async_intptr_c(dst, dpitch, src, spitch, width, height, dir, cudaStream) result(istat) &
             bind(C, name="cudaMemcpy2dAsyncFromC")
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=C_intptr_T), value                :: dst
      integer(kind=c_intptr_t), intent(in), value    :: dpitch
      integer(kind=C_intptr_T), value                :: src
      integer(kind=c_intptr_t), intent(in), value    :: spitch
      integer(kind=c_intptr_t), intent(in), value    :: width
      integer(kind=c_intptr_t), intent(in), value    :: height
      integer(kind=C_INT), intent(in), value         :: dir
      integer(kind=c_intptr_t), value                :: cudaStream
      integer(kind=C_INT)                            :: istat
    end function
  end interface

  interface
    function cuda_memcpy2d_async_cptr_c(dst, dpitch, src, spitch, width, height, dir, cudaStream) result(istat) &
             bind(C, name="cudaMemcpy2dAsyncFromC")
      use, intrinsic :: iso_c_binding
      implicit none
      type(c_ptr), value                :: dst
      integer(kind=c_intptr_t), intent(in), value    :: dpitch
      type(c_ptr), value                :: src
      integer(kind=c_intptr_t), intent(in), value    :: spitch
      integer(kind=c_intptr_t), intent(in), value    :: width
      integer(kind=c_intptr_t), intent(in), value    :: height
      integer(kind=C_INT), intent(in), value         :: dir
      integer(kind=c_intptr_t), value                :: cudaStream
      integer(kind=C_INT)                            :: istat
    end function
  end interface

  interface
    function cuda_host_register_c(a, size, flag) result(istat) &
             bind(C, name="cudaHostRegisterFromC")
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=C_intptr_t), value              :: a
      integer(kind=c_intptr_t), intent(in), value  :: size
      integer(kind=C_INT), intent(in), value       :: flag
      integer(kind=C_INT)                          :: istat
    end function
  end interface

  interface
    function cuda_host_unregister_c(a) result(istat) &
             bind(C, name="cudaHostUnregisterFromC")
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=C_intptr_t), value              :: a
      integer(kind=C_INT)                          :: istat
    end function
  end interface

  interface cuda_free
    module procedure cuda_free_intptr
    module procedure cuda_free_cptr
  end interface

  interface
    function cuda_free_intptr_c(a) result(istat) &
             bind(C, name="cudaFreeFromC")
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=C_intptr_T), value  :: a
      integer(kind=C_INT)              :: istat
    end function
  end interface

  interface
    function cuda_free_cptr_c(a) result(istat) &
             bind(C, name="cudaFreeFromC")
      use, intrinsic :: iso_c_binding
      implicit none
      type(c_ptr), value  :: a
      integer(kind=C_INT)              :: istat
    end function
  end interface

  interface cuda_memcpy
    module procedure cuda_memcpy_intptr
    module procedure cuda_memcpy_cptr
    module procedure cuda_memcpy_mixed_to_device
    module procedure cuda_memcpy_mixed_to_host
  end interface

  interface cuda_memcpy_async
    module procedure cuda_memcpy_async_intptr
    module procedure cuda_memcpy_async_cptr
    module procedure cuda_memcpy_async_mixed_to_device
    module procedure cuda_memcpy_async_mixed_to_host
  end interface

  interface cuda_malloc
    module procedure cuda_malloc_intptr
    module procedure cuda_malloc_cptr
  end interface

  interface
    function cuda_malloc_intptr_c(a, width_height) result(istat) &
             bind(C, name="cudaMallocFromC")
      use, intrinsic :: iso_c_binding
      implicit none
      ! no value since **pointer
      integer(kind=C_intptr_T)                    :: a
      integer(kind=c_intptr_t), intent(in), value :: width_height
      integer(kind=C_INT)                         :: istat
    end function
  end interface


  interface
    function cuda_malloc_cptr_c(a, width_height) result(istat) &
             bind(C, name="cudaMallocFromC")
      use, intrinsic :: iso_c_binding
      implicit none
      ! no value since **pointer
      type(c_ptr)                                 :: a
      integer(kind=c_intptr_t), intent(in), value :: width_height
      integer(kind=C_INT)                         :: istat
    end function
  end interface

  interface
    function cuda_free_host_c(a) result(istat) &
             bind(C, name="cudaFreeHostFromC")
      use, intrinsic :: iso_c_binding
      implicit none
      type(c_ptr), value               :: a
      integer(kind=C_INT)              :: istat
    end function
  end interface

  interface
    function cuda_malloc_host_c(a, width_height) result(istat) &
             bind(C, name="cudaMallocHostFromC")
      use, intrinsic :: iso_c_binding
      implicit none
      type(c_ptr)                    :: a
      integer(kind=c_intptr_t), intent(in), value   :: width_height
      integer(kind=C_INT)                         :: istat
    end function
  end interface

  interface
    function cuda_memset_c(a, val, size) result(istat) &
             bind(C, name="cudaMemsetFromC")
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=C_intptr_T), value            :: a
      integer(kind=C_INT), value                 :: val
      integer(kind=c_intptr_t), intent(in), value  :: size
      integer(kind=C_INT)                        :: istat
    end function
  end interface

  interface
    function cuda_memset_async_c(a, val, size, cudaStream) result(istat) &
             bind(C, name="cudaMemsetAsyncFromC")
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=C_intptr_T), value            :: a
      integer(kind=C_INT), value                 :: val
      integer(kind=c_intptr_t), intent(in), value  :: size
      integer(kind=C_INT)                        :: istat
      integer(kind=c_intptr_t), value            :: cudaStream
    end function
  end interface

  interface
    subroutine cusolver_Dtrtri_c(cusolverHandle, uplo, diag, n, a, lda, info) &
                              bind(C,name="cusolverDtrtri_elpa_wrapper")
      use, intrinsic :: iso_c_binding
      implicit none
      character(1,C_CHAR),value                 :: uplo, diag
      integer(kind=C_INT64_T), intent(in),value :: n, lda
      integer(kind=C_intptr_T), value           :: a
      integer(kind=C_INT)                       :: info
      integer(kind=C_intptr_T), value           :: cusolverHandle
    end subroutine
  end interface

  interface
    subroutine cusolver_Dpotrf_c(cusolverHandle, uplo, n, a, lda, info) &
                              bind(C,name="cusolverDpotrf_elpa_wrapper")
      use, intrinsic :: iso_c_binding
      implicit none
      character(1,C_CHAR),value                 :: uplo
      integer(kind=C_INT), intent(in),value     :: n, lda
      integer(kind=C_intptr_T), value           :: a
      integer(kind=C_INT)                       :: info
      integer(kind=C_intptr_T), value           :: cusolverHandle
    end subroutine
  end interface

  interface cublas_Dgemm
    module procedure cublas_Dgemm_intptr
    module procedure cublas_Dgemm_cptr
  end interface

  interface
    subroutine cublas_Dgemm_intptr_c(cublasHandle, cta, ctb, m, n, k, alpha, a, lda, b, ldb, beta, c, ldc) &
                              bind(C,name="cublasDgemm_elpa_wrapper")
      use, intrinsic :: iso_c_binding
      implicit none
      character(1,C_CHAR),value               :: cta, ctb
      integer(kind=C_INT),value               :: m,n,k
      integer(kind=C_INT), intent(in), value  :: lda,ldb,ldc
      real(kind=C_DOUBLE) ,value               :: alpha,beta
      integer(kind=C_intptr_T), value         :: a, b, c
      integer(kind=C_intptr_T), value         :: cublasHandle
    end subroutine
  end interface

  interface
    subroutine cublas_Dgemm_cptr_c(cublasHandle, cta, ctb, m, n, k, alpha, a, lda, b, ldb, beta, c, ldc) &
                              bind(C,name="cublasDgemm_elpa_wrapper")
      use, intrinsic :: iso_c_binding
      implicit none
      character(1,C_CHAR),value               :: cta, ctb
      integer(kind=C_INT),value               :: m,n,k
      integer(kind=C_INT), intent(in), value  :: lda,ldb,ldc
      real(kind=C_DOUBLE) ,value               :: alpha,beta
      type(c_ptr), value                      :: a, b, c
      integer(kind=C_intptr_T), value         :: cublasHandle
    end subroutine
  end interface

  interface cublas_Dcopy
    module procedure cublas_Dcopy_intptr
    module procedure cublas_Dcopy_cptr
  end interface

  interface
    subroutine cublas_Dcopy_intptr_c(cublasHandle, n, x, incx, y, incy) &
                              bind(C,name="cublasDcopy_elpa_wrapper")
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=C_INT),value               :: n
      integer(kind=C_INT), intent(in), value  :: incx,incy
      integer(kind=C_intptr_T), value         :: x, y
      integer(kind=C_intptr_T), value         :: cublasHandle
    end subroutine
  end interface

  interface
    subroutine cublas_Dcopy_cptr_c(cublasHandle, n, x, incx, y, incy) &
                              bind(C,name="cublasDcopy_elpa_wrapper")
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=C_INT),value               :: n
      integer(kind=C_INT), intent(in), value  :: incx,incy
      type(c_ptr), value                      :: x, y
      integer(kind=C_intptr_T), value         :: cublasHandle
    end subroutine
  end interface

  interface cublas_Dtrmm
    module procedure cublas_Dtrmm_intptr
    module procedure cublas_Dtrmm_cptr
  end interface

  interface
    subroutine cublas_Dtrmm_intptr_c(cublasHandle, side, uplo, trans, diag, m, n, alpha, a, lda, b, ldb) &
                              bind(C,name="cublasDtrmm_elpa_wrapper")
      use, intrinsic :: iso_c_binding
      implicit none
      character(1,C_CHAR),value               :: side, uplo, trans, diag
      integer(kind=C_INT),value               :: m,n
      integer(kind=C_INT), intent(in), value  :: lda,ldb
      real(kind=C_DOUBLE) , value              :: alpha
      integer(kind=C_intptr_T), value         :: a, b
      integer(kind=C_intptr_T), value         :: cublasHandle
    end subroutine
  end interface

  interface
    subroutine cublas_Dtrmm_cptr_c(cublasHandle, side, uplo, trans, diag, m, n, alpha, a, lda, b, ldb) &
                              bind(C,name="cublasDtrmm_elpa_wrapper")
      use, intrinsic :: iso_c_binding
      implicit none
      character(1,C_CHAR),value               :: side, uplo, trans, diag
      integer(kind=C_INT),value               :: m,n
      integer(kind=C_INT), intent(in), value  :: lda,ldb
      real(kind=C_DOUBLE) , value              :: alpha
      type(c_ptr), value                      :: a, b
      integer(kind=C_intptr_T), value         :: cublasHandle
    end subroutine
  end interface

  interface cublas_Dtrsm
    module procedure cublas_Dtrsm_intptr
    module procedure cublas_Dtrsm_cptr
  end interface

  interface
    subroutine cublas_Dtrsm_intptr_c(cublasHandle, side, uplo, trans, diag, m, n, alpha, a, lda, b, ldb) &
                              bind(C,name="cublasDtrsm_elpa_wrapper")
      use, intrinsic :: iso_c_binding
      implicit none
      character(1,C_CHAR),value               :: side, uplo, trans, diag
      integer(kind=C_INT),value               :: m,n
      integer(kind=C_INT), intent(in), value  :: lda,ldb
      real(kind=C_DOUBLE) , value              :: alpha
      integer(kind=C_intptr_T), value         :: a, b
      integer(kind=C_intptr_T), value         :: cublasHandle
    end subroutine
  end interface

  interface
    subroutine cublas_Dtrsm_cptr_c(cublasHandle, side, uplo, trans, diag, m, n, alpha, a, lda, b, ldb) &
                              bind(C,name="cublasDtrsm_elpa_wrapper")
      use, intrinsic :: iso_c_binding
      implicit none
      character(1,C_CHAR),value               :: side, uplo, trans, diag
      integer(kind=C_INT),value               :: m,n
      integer(kind=C_INT), intent(in), value  :: lda,ldb
      real(kind=C_DOUBLE) , value              :: alpha
      type(c_ptr), value                      :: a, b
      integer(kind=C_intptr_T), value         :: cublasHandle
    end subroutine
  end interface

  interface
    subroutine cublas_Dgemv_c(cublasHandle, cta, m, n, alpha, a, lda, x, incx, beta, y, incy) &
                              bind(C,name="cublasDgemv_elpa_wrapper")
      use, intrinsic :: iso_c_binding
      implicit none
      character(1,C_CHAR),value               :: cta
      integer(kind=C_INT),value               :: m,n
      integer(kind=C_INT), intent(in), value  :: lda,incx,incy
      real(kind=C_DOUBLE) , value              :: alpha, beta
      integer(kind=C_intptr_T), value         :: a, x, y
      integer(kind=C_intptr_T), value         :: cublasHandle
    end subroutine
  end interface

  interface
    subroutine cusolver_Strtri_c(cusolverHandle, uplo, diag, n, a, lda, info) &
                              bind(C,name="cusolverStrtri_elpa_wrapper")
      use, intrinsic :: iso_c_binding
      implicit none
      character(1,C_CHAR),value                 :: uplo, diag
      integer(kind=C_INT64_T), intent(in),value :: n, lda
      integer(kind=C_intptr_T), value           :: a
      integer(kind=C_INT)                       :: info
      integer(kind=C_intptr_T), value           :: cusolverHandle
    end subroutine
  end interface

  interface
    subroutine cusolver_Spotrf_c(cusolverHandle, uplo, n, a, lda, info) &
                              bind(C,name="cusolverSpotrf_elpa_wrapper")
      use, intrinsic :: iso_c_binding
      implicit none
      character(1,C_CHAR),value                 :: uplo
      integer(kind=C_INT), intent(in),value     :: n, lda
      integer(kind=C_intptr_T), value           :: a
      integer(kind=C_INT)                       :: info
      integer(kind=C_intptr_T), value           :: cusolverHandle
    end subroutine
  end interface

  interface cublas_Sgemm
    module procedure cublas_Sgemm_intptr
    module procedure cublas_Sgemm_cptr
  end interface

  interface
    subroutine cublas_Sgemm_intptr_c(cublasHandle, cta, ctb, m, n, k, alpha, a, lda, b, ldb, beta, c, ldc) &
                              bind(C,name="cublasSgemm_elpa_wrapper")
      use, intrinsic :: iso_c_binding
      implicit none
      character(1,C_CHAR),value               :: cta, ctb
      integer(kind=C_INT),value               :: m,n,k
      integer(kind=C_INT), intent(in), value  :: lda,ldb,ldc
      real(kind=C_FLOAT) ,value               :: alpha,beta
      integer(kind=C_intptr_T), value         :: a, b, c
      integer(kind=C_intptr_T), value         :: cublasHandle
    end subroutine
  end interface

  interface
    subroutine cublas_Sgemm_cptr_c(cublasHandle, cta, ctb, m, n, k, alpha, a, lda, b, ldb, beta, c, ldc) &
                              bind(C,name="cublasSgemm_elpa_wrapper")
      use, intrinsic :: iso_c_binding
      implicit none
      character(1,C_CHAR),value               :: cta, ctb
      integer(kind=C_INT),value               :: m,n,k
      integer(kind=C_INT), intent(in), value  :: lda,ldb,ldc
      real(kind=C_FLOAT) ,value               :: alpha,beta
      type(c_ptr), value                      :: a, b, c
      integer(kind=C_intptr_T), value         :: cublasHandle
    end subroutine
  end interface

  interface cublas_Scopy
    module procedure cublas_Scopy_intptr
    module procedure cublas_Scopy_cptr
  end interface

  interface
    subroutine cublas_Scopy_intptr_c(cublasHandle, n, x, incx, y, incy) &
                              bind(C,name="cublasScopy_elpa_wrapper")
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=C_INT),value               :: n
      integer(kind=C_INT), intent(in), value  :: incx,incy
      integer(kind=C_intptr_T), value         :: x, y
      integer(kind=C_intptr_T), value         :: cublasHandle
    end subroutine
  end interface

  interface
    subroutine cublas_Scopy_cptr_c(cublasHandle, n, x, incx, y, incy) &
                              bind(C,name="cublasScopy_elpa_wrapper")
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=C_INT),value               :: n
      integer(kind=C_INT), intent(in), value  :: incx,incy
      type(c_ptr), value                      :: x, y
      integer(kind=C_intptr_T), value         :: cublasHandle
    end subroutine
  end interface

  interface cublas_Strmm
    module procedure cublas_Strmm_intptr
    module procedure cublas_Strmm_cptr
  end interface

  interface
    subroutine cublas_Strmm_intptr_c(cublasHandle, side, uplo, trans, diag, m, n, alpha, a, lda, b, ldb) &
                              bind(C,name="cublasStrmm_elpa_wrapper")
      use, intrinsic :: iso_c_binding
      implicit none
      character(1,C_CHAR),value               :: side, uplo, trans, diag
      integer(kind=C_INT),value               :: m,n
      integer(kind=C_INT), intent(in), value  :: lda,ldb
      real(kind=C_FLOAT) , value              :: alpha
      integer(kind=C_intptr_T), value         :: a, b
      integer(kind=C_intptr_T), value         :: cublasHandle
    end subroutine
  end interface

  interface
    subroutine cublas_Strmm_cptr_c(cublasHandle, side, uplo, trans, diag, m, n, alpha, a, lda, b, ldb) &
                              bind(C,name="cublasStrmm_elpa_wrapper")
      use, intrinsic :: iso_c_binding
      implicit none
      character(1,C_CHAR),value               :: side, uplo, trans, diag
      integer(kind=C_INT),value               :: m,n
      integer(kind=C_INT), intent(in), value  :: lda,ldb
      real(kind=C_FLOAT) , value              :: alpha
      type(c_ptr), value                      :: a, b
      integer(kind=C_intptr_T), value         :: cublasHandle
    end subroutine
  end interface

  interface cublas_Strsm
    module procedure cublas_Strsm_intptr
    module procedure cublas_Strsm_cptr
  end interface

  interface
    subroutine cublas_Strsm_intptr_c(cublasHandle, side, uplo, trans, diag, m, n, alpha, a, lda, b, ldb) &
                              bind(C,name="cublasStrsm_elpa_wrapper")
      use, intrinsic :: iso_c_binding
      implicit none
      character(1,C_CHAR),value               :: side, uplo, trans, diag
      integer(kind=C_INT),value               :: m,n
      integer(kind=C_INT), intent(in), value  :: lda,ldb
      real(kind=C_FLOAT) , value              :: alpha
      integer(kind=C_intptr_T), value         :: a, b
      integer(kind=C_intptr_T), value         :: cublasHandle
    end subroutine
  end interface

  interface
    subroutine cublas_Strsm_cptr_c(cublasHandle, side, uplo, trans, diag, m, n, alpha, a, lda, b, ldb) &
                              bind(C,name="cublasStrsm_elpa_wrapper")
      use, intrinsic :: iso_c_binding
      implicit none
      character(1,C_CHAR),value               :: side, uplo, trans, diag
      integer(kind=C_INT),value               :: m,n
      integer(kind=C_INT), intent(in), value  :: lda,ldb
      real(kind=C_FLOAT) , value              :: alpha
      type(c_ptr), value                      :: a, b
      integer(kind=C_intptr_T), value         :: cublasHandle
    end subroutine
  end interface

  interface
    subroutine cublas_Sgemv_c(cublasHandle, cta, m, n, alpha, a, lda, x, incx, beta, y, incy) &
                              bind(C,name="cublasSgemv_elpa_wrapper")
      use, intrinsic :: iso_c_binding
      implicit none
      character(1,C_CHAR),value               :: cta
      integer(kind=C_INT),value               :: m,n
      integer(kind=C_INT), intent(in), value  :: lda,incx,incy
      real(kind=C_FLOAT) , value              :: alpha, beta
      integer(kind=C_intptr_T), value         :: a, x, y
      integer(kind=C_intptr_T), value         :: cublasHandle
    end subroutine
  end interface

  interface
    subroutine cusolver_Ztrtri_c(cusolverHandle, uplo, diag, n, a, lda, info) &
                              bind(C,name="cusolverZtrtri_elpa_wrapper")
      use, intrinsic :: iso_c_binding
      implicit none
      character(1,C_CHAR),value                 :: uplo, diag
      integer(kind=C_INT64_T), intent(in),value :: n, lda
      integer(kind=C_intptr_T), value           :: a
      integer(kind=C_INT)                       :: info
      integer(kind=C_intptr_T), value           :: cusolverHandle
    end subroutine
  end interface

  interface
    subroutine cusolver_Zpotrf_c(cusolverHandle, uplo, n, a, lda, info) &
                              bind(C,name="cusolverZpotrf_elpa_wrapper")
      use, intrinsic :: iso_c_binding
      implicit none
      character(1,C_CHAR),value                 :: uplo
      integer(kind=C_INT), intent(in),value     :: n, lda
      integer(kind=C_intptr_T), value           :: a
      integer(kind=C_INT)                       :: info
      integer(kind=C_intptr_T), value           :: cusolverHandle
    end subroutine
  end interface

  interface cublas_Zgemm
    module procedure cublas_Zgemm_intptr
    module procedure cublas_Zgemm_cptr
  end interface

  interface
    subroutine cublas_Zgemm_intptr_c(cublasHandle, cta, ctb, m, n, k, alpha, a, lda, b, ldb, beta, c, ldc) &
                              bind(C,name="cublasZgemm_elpa_wrapper")
      use, intrinsic :: iso_c_binding
      implicit none
      character(1,C_CHAR),value               :: cta, ctb
      integer(kind=C_INT),value               :: m,n,k
      integer(kind=C_INT), intent(in), value  :: lda,ldb,ldc
      complex(kind=C_DOUBLE_COMPLEX) ,value               :: alpha,beta
      integer(kind=C_intptr_T), value         :: a, b, c
      integer(kind=C_intptr_T), value         :: cublasHandle
    end subroutine
  end interface

  interface
    subroutine cublas_Zgemm_cptr_c(cublasHandle, cta, ctb, m, n, k, alpha, a, lda, b, ldb, beta, c, ldc) &
                              bind(C,name="cublasZgemm_elpa_wrapper")
      use, intrinsic :: iso_c_binding
      implicit none
      character(1,C_CHAR),value               :: cta, ctb
      integer(kind=C_INT),value               :: m,n,k
      integer(kind=C_INT), intent(in), value  :: lda,ldb,ldc
      complex(kind=C_DOUBLE_COMPLEX) ,value               :: alpha,beta
      type(c_ptr), value                      :: a, b, c
      integer(kind=C_intptr_T), value         :: cublasHandle
    end subroutine
  end interface

  interface cublas_Zcopy
    module procedure cublas_Zcopy_intptr
    module procedure cublas_Zcopy_cptr
  end interface

  interface
    subroutine cublas_Zcopy_intptr_c(cublasHandle, n, x, incx, y, incy) &
                              bind(C,name="cublasZcopy_elpa_wrapper")
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=C_INT),value               :: n
      integer(kind=C_INT), intent(in), value  :: incx,incy
      integer(kind=C_intptr_T), value         :: x, y
      integer(kind=C_intptr_T), value         :: cublasHandle
    end subroutine
  end interface

  interface
    subroutine cublas_Zcopy_cptr_c(cublasHandle, n, x, incx, y, incy) &
                              bind(C,name="cublasZcopy_elpa_wrapper")
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=C_INT),value               :: n
      integer(kind=C_INT), intent(in), value  :: incx,incy
      type(c_ptr), value                      :: x, y
      integer(kind=C_intptr_T), value         :: cublasHandle
    end subroutine
  end interface

  interface cublas_Ztrmm
    module procedure cublas_Ztrmm_intptr
    module procedure cublas_Ztrmm_cptr
  end interface

  interface
    subroutine cublas_Ztrmm_intptr_c(cublasHandle, side, uplo, trans, diag, m, n, alpha, a, lda, b, ldb) &
                              bind(C,name="cublasZtrmm_elpa_wrapper")
      use, intrinsic :: iso_c_binding
      implicit none
      character(1,C_CHAR),value               :: side, uplo, trans, diag
      integer(kind=C_INT),value               :: m,n
      integer(kind=C_INT), intent(in), value  :: lda,ldb
      complex(kind=C_DOUBLE_COMPLEX) , value              :: alpha
      integer(kind=C_intptr_T), value         :: a, b
      integer(kind=C_intptr_T), value         :: cublasHandle
    end subroutine
  end interface

  interface
    subroutine cublas_Ztrmm_cptr_c(cublasHandle, side, uplo, trans, diag, m, n, alpha, a, lda, b, ldb) &
                              bind(C,name="cublasZtrmm_elpa_wrapper")
      use, intrinsic :: iso_c_binding
      implicit none
      character(1,C_CHAR),value               :: side, uplo, trans, diag
      integer(kind=C_INT),value               :: m,n
      integer(kind=C_INT), intent(in), value  :: lda,ldb
      complex(kind=C_DOUBLE_COMPLEX) , value              :: alpha
      type(c_ptr), value                      :: a, b
      integer(kind=C_intptr_T), value         :: cublasHandle
    end subroutine
  end interface

  interface cublas_Ztrsm
    module procedure cublas_Ztrsm_intptr
    module procedure cublas_Ztrsm_cptr
  end interface

  interface
    subroutine cublas_Ztrsm_intptr_c(cublasHandle, side, uplo, trans, diag, m, n, alpha, a, lda, b, ldb) &
                              bind(C,name="cublasZtrsm_elpa_wrapper")
      use, intrinsic :: iso_c_binding
      implicit none
      character(1,C_CHAR),value               :: side, uplo, trans, diag
      integer(kind=C_INT),value               :: m,n
      integer(kind=C_INT), intent(in), value  :: lda,ldb
      complex(kind=C_DOUBLE_COMPLEX) , value              :: alpha
      integer(kind=C_intptr_T), value         :: a, b
      integer(kind=C_intptr_T), value         :: cublasHandle
    end subroutine
  end interface

  interface
    subroutine cublas_Ztrsm_cptr_c(cublasHandle, side, uplo, trans, diag, m, n, alpha, a, lda, b, ldb) &
                              bind(C,name="cublasZtrsm_elpa_wrapper")
      use, intrinsic :: iso_c_binding
      implicit none
      character(1,C_CHAR),value               :: side, uplo, trans, diag
      integer(kind=C_INT),value               :: m,n
      integer(kind=C_INT), intent(in), value  :: lda,ldb
      complex(kind=C_DOUBLE_COMPLEX) , value              :: alpha
      type(c_ptr), value                      :: a, b
      integer(kind=C_intptr_T), value         :: cublasHandle
    end subroutine
  end interface

  interface
    subroutine cublas_Zgemv_c(cublasHandle, cta, m, n, alpha, a, lda, x, incx, beta, y, incy) &
                              bind(C,name="cublasZgemv_elpa_wrapper")
      use, intrinsic :: iso_c_binding
      implicit none
      character(1,C_CHAR),value               :: cta
      integer(kind=C_INT),value               :: m,n
      integer(kind=C_INT), intent(in), value  :: lda,incx,incy
      complex(kind=C_DOUBLE_COMPLEX) , value              :: alpha, beta
      integer(kind=C_intptr_T), value         :: a, x, y
      integer(kind=C_intptr_T), value         :: cublasHandle
    end subroutine
  end interface

  interface
    subroutine cusolver_Ctrtri_c(cusolverHandle, uplo, diag, n, a, lda, info) &
                              bind(C,name="cusolverCtrtri_elpa_wrapper")
      use, intrinsic :: iso_c_binding
      implicit none
      character(1,C_CHAR),value                 :: uplo, diag
      integer(kind=C_INT64_T), intent(in),value :: n, lda
      integer(kind=C_intptr_T), value           :: a
      integer(kind=C_INT)                       :: info
      integer(kind=C_intptr_T), value           :: cusolverHandle
    end subroutine
  end interface

  interface
    subroutine cusolver_Cpotrf_c(cusolverHandle, uplo, n, a, lda, info) &
                              bind(C,name="cusolverCpotrf_elpa_wrapper")
      use, intrinsic :: iso_c_binding
      implicit none
      character(1,C_CHAR),value                 :: uplo
      integer(kind=C_INT), intent(in),value     :: n, lda
      integer(kind=C_intptr_T), value           :: a
      integer(kind=C_INT)                       :: info
      integer(kind=C_intptr_T), value           :: cusolverHandle
    end subroutine
  end interface

  interface cublas_Cgemm
    module procedure cublas_Cgemm_intptr
    module procedure cublas_Cgemm_cptr
  end interface

  interface
    subroutine cublas_Cgemm_intptr_c(cublasHandle, cta, ctb, m, n, k, alpha, a, lda, b, ldb, beta, c, ldc) &
                              bind(C,name="cublasCgemm_elpa_wrapper")
      use, intrinsic :: iso_c_binding
      implicit none
      character(1,C_CHAR),value               :: cta, ctb
      integer(kind=C_INT),value               :: m,n,k
      integer(kind=C_INT), intent(in), value  :: lda,ldb,ldc
      complex(kind=C_FLOAT_COMPLEX) ,value               :: alpha,beta
      integer(kind=C_intptr_T), value         :: a, b, c
      integer(kind=C_intptr_T), value         :: cublasHandle
    end subroutine
  end interface

  interface
    subroutine cublas_Cgemm_cptr_c(cublasHandle, cta, ctb, m, n, k, alpha, a, lda, b, ldb, beta, c, ldc) &
                              bind(C,name="cublasCgemm_elpa_wrapper")
      use, intrinsic :: iso_c_binding
      implicit none
      character(1,C_CHAR),value               :: cta, ctb
      integer(kind=C_INT),value               :: m,n,k
      integer(kind=C_INT), intent(in), value  :: lda,ldb,ldc
      complex(kind=C_FLOAT_COMPLEX) ,value               :: alpha,beta
      type(c_ptr), value                      :: a, b, c
      integer(kind=C_intptr_T), value         :: cublasHandle
    end subroutine
  end interface

  interface cublas_Ccopy
    module procedure cublas_Ccopy_intptr
    module procedure cublas_Ccopy_cptr
  end interface

  interface
    subroutine cublas_Ccopy_intptr_c(cublasHandle, n, x, incx, y, incy) &
                              bind(C,name="cublasCcopy_elpa_wrapper")
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=C_INT),value               :: n
      integer(kind=C_INT), intent(in), value  :: incx,incy
      integer(kind=C_intptr_T), value         :: x, y
      integer(kind=C_intptr_T), value         :: cublasHandle
    end subroutine
  end interface

  interface
    subroutine cublas_Ccopy_cptr_c(cublasHandle, n, x, incx, y, incy) &
                              bind(C,name="cublasCcopy_elpa_wrapper")
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=C_INT),value               :: n
      integer(kind=C_INT), intent(in), value  :: incx,incy
      type(c_ptr), value                      :: x, y
      integer(kind=C_intptr_T), value         :: cublasHandle
    end subroutine
  end interface

  interface cublas_Ctrmm
    module procedure cublas_Ctrmm_intptr
    module procedure cublas_Ctrmm_cptr
  end interface

  interface
    subroutine cublas_Ctrmm_intptr_c(cublasHandle, side, uplo, trans, diag, m, n, alpha, a, lda, b, ldb) &
                              bind(C,name="cublasCtrmm_elpa_wrapper")
      use, intrinsic :: iso_c_binding
      implicit none
      character(1,C_CHAR),value               :: side, uplo, trans, diag
      integer(kind=C_INT),value               :: m,n
      integer(kind=C_INT), intent(in), value  :: lda,ldb
      complex(kind=C_FLOAT_COMPLEX) , value              :: alpha
      integer(kind=C_intptr_T), value         :: a, b
      integer(kind=C_intptr_T), value         :: cublasHandle
    end subroutine
  end interface

  interface
    subroutine cublas_Ctrmm_cptr_c(cublasHandle, side, uplo, trans, diag, m, n, alpha, a, lda, b, ldb) &
                              bind(C,name="cublasCtrmm_elpa_wrapper")
      use, intrinsic :: iso_c_binding
      implicit none
      character(1,C_CHAR),value               :: side, uplo, trans, diag
      integer(kind=C_INT),value               :: m,n
      integer(kind=C_INT), intent(in), value  :: lda,ldb
      complex(kind=C_FLOAT_COMPLEX) , value              :: alpha
      type(c_ptr), value                      :: a, b
      integer(kind=C_intptr_T), value         :: cublasHandle
    end subroutine
  end interface

  interface cublas_Ctrsm
    module procedure cublas_Ctrsm_intptr
    module procedure cublas_Ctrsm_cptr
  end interface

  interface
    subroutine cublas_Ctrsm_intptr_c(cublasHandle, side, uplo, trans, diag, m, n, alpha, a, lda, b, ldb) &
                              bind(C,name="cublasCtrsm_elpa_wrapper")
      use, intrinsic :: iso_c_binding
      implicit none
      character(1,C_CHAR),value               :: side, uplo, trans, diag
      integer(kind=C_INT),value               :: m,n
      integer(kind=C_INT), intent(in), value  :: lda,ldb
      complex(kind=C_FLOAT_COMPLEX) , value              :: alpha
      integer(kind=C_intptr_T), value         :: a, b
      integer(kind=C_intptr_T), value         :: cublasHandle
    end subroutine
  end interface

  interface
    subroutine cublas_Ctrsm_cptr_c(cublasHandle, side, uplo, trans, diag, m, n, alpha, a, lda, b, ldb) &
                              bind(C,name="cublasCtrsm_elpa_wrapper")
      use, intrinsic :: iso_c_binding
      implicit none
      character(1,C_CHAR),value               :: side, uplo, trans, diag
      integer(kind=C_INT),value               :: m,n
      integer(kind=C_INT), intent(in), value  :: lda,ldb
      complex(kind=C_FLOAT_COMPLEX) , value              :: alpha
      type(c_ptr), value                      :: a, b
      integer(kind=C_intptr_T), value         :: cublasHandle
    end subroutine
  end interface

  interface
    subroutine cublas_Cgemv_c(cublasHandle, cta, m, n, alpha, a, lda, x, incx, beta, y, incy) &
                              bind(C,name="cublasCgemv_elpa_wrapper")
      use, intrinsic :: iso_c_binding
      implicit none
      character(1,C_CHAR),value               :: cta
      integer(kind=C_INT),value               :: m,n
      integer(kind=C_INT), intent(in), value  :: lda,incx,incy
      complex(kind=C_FLOAT_COMPLEX) , value              :: alpha, beta
      integer(kind=C_intptr_T), value         :: a, x, y
      integer(kind=C_intptr_T), value         :: cublasHandle
    end subroutine
  end interface


  interface
    function cublas_pointerModeDevice_c() result(flag) &
               bind(C, name="cublasPointerModeDeviceFromC")
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=c_int) :: flag
    end function
  end interface

  interface
    function cublas_pointerModeHost_c() result(flag) &
               bind(C, name="cublasPointerModeHostFromC")
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=c_int) :: flag
    end function
  end interface

  interface
    subroutine cublas_getPointerMode_c(cublasHandle, mode) &
               bind(C, name="cublasGetPointerModeFromC")
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=C_intptr_T), value   :: cublasHandle
      integer(kind=c_int)               :: mode
    end subroutine
  end interface

  interface
    subroutine cublas_setPointerMode_c(cublasHandle, mode) &
               bind(C, name="cublasSetPointerModeFromC")
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=C_intptr_T),value    :: cublasHandle
      integer(kind=c_int), value        :: mode
    end subroutine
  end interface

  interface cublas_Ddot
    module procedure cublas_Ddot_intptr
    module procedure cublas_Ddot_cptr
  end interface

  interface
    subroutine cublas_Ddot_intptr_c(cublasHandle, length, x, incx, y, incy, z) &
               bind(C, name="cublasDdot_elpa_wrapper")
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=C_intptr_T), value         :: cublasHandle
      integer(kind=C_INT),value               :: length, incx, incy
      integer(kind=C_intptr_T), value         :: x, y, z
    end subroutine
  end interface

  interface
    subroutine cublas_Ddot_cptr_c(cublasHandle, length, x, incx, y, incy, z) &
               bind(C, name="cublasDdot_elpa_wrapper")
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=C_intptr_T), value         :: cublasHandle
      integer(kind=C_INT),value               :: length, incx, incy
      type(c_ptr), value                      :: x, y, z
    end subroutine
  end interface

  interface cublas_Dscal
    module procedure cublas_Dscal_intptr
    module procedure cublas_Dscal_cptr
  end interface

  interface
    subroutine cublas_Dscal_intptr_c(cublasHandle, length, alpha, x, incx) &
               bind(C, name="cublasDscal_elpa_wrapper")
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=C_intptr_T), value         :: cublasHandle
      integer(kind=C_INT),value               :: length, incx
      real(kind=C_DOUBLE) ,value                :: alpha
      integer(kind=C_intptr_T), value         :: x
    end subroutine
  end interface

  interface
    subroutine cublas_Dscal_cptr_c(cublasHandle, length, alpha, x, incx) &
               bind(C, name="cublasDscal_elpa_wrapper")
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=C_intptr_T), value         :: cublasHandle
      integer(kind=C_INT),value               :: length, incx
      real(kind=C_DOUBLE) ,value                :: alpha
      type(c_ptr), value                      :: x
    end subroutine
  end interface

  interface cublas_Daxpy
    module procedure cublas_Daxpy_intptr
    module procedure cublas_Daxpy_cptr
  end interface

  interface
    subroutine cublas_Daxpy_intptr_c(cublasHandle, length, alpha, x, incx, y, incy) &
               bind(C, name="cublasDscal_elpa_wrapper")
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=C_intptr_T), value         :: cublasHandle
      integer(kind=C_INT),value               :: length, incx, incy
      real(kind=C_DOUBLE) ,value                :: alpha
      integer(kind=C_intptr_T), value         :: x, y
    end subroutine
  end interface

  interface
    subroutine cublas_Daxpy_cptr_c(cublasHandle, length, alpha, x, incx, y, incy) &
               bind(C, name="cublasDscal_elpa_wrapper")
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=C_intptr_T), value         :: cublasHandle
      integer(kind=C_INT),value               :: length, incx, incy
      real(kind=C_DOUBLE) ,value                :: alpha
      type(c_ptr), value                      :: x, y
    end subroutine
  end interface

  interface cublas_Sdot
    module procedure cublas_Sdot_intptr
    module procedure cublas_Sdot_cptr
  end interface

  interface
    subroutine cublas_Sdot_intptr_c(cublasHandle, length, x, incx, y, incy, z) &
               bind(C, name="cublasSdot_elpa_wrapper")
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=C_intptr_T), value         :: cublasHandle
      integer(kind=C_INT),value               :: length, incx, incy
      integer(kind=C_intptr_T), value         :: x, y, z
    end subroutine
  end interface

  interface
    subroutine cublas_Sdot_cptr_c(cublasHandle, length, x, incx, y, incy, z) &
               bind(C, name="cublasSdot_elpa_wrapper")
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=C_intptr_T), value         :: cublasHandle
      integer(kind=C_INT),value               :: length, incx, incy
      type(c_ptr), value                      :: x, y, z
    end subroutine
  end interface

  interface cublas_Sscal
    module procedure cublas_Sscal_intptr
    module procedure cublas_Sscal_cptr
  end interface

  interface
    subroutine cublas_Sscal_intptr_c(cublasHandle, length, alpha, x, incx) &
               bind(C, name="cublasSscal_elpa_wrapper")
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=C_intptr_T), value         :: cublasHandle
      integer(kind=C_INT),value               :: length, incx
      real(kind=C_FLOAT) ,value                :: alpha
      integer(kind=C_intptr_T), value         :: x
    end subroutine
  end interface

  interface
    subroutine cublas_Sscal_cptr_c(cublasHandle, length, alpha, x, incx) &
               bind(C, name="cublasSscal_elpa_wrapper")
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=C_intptr_T), value         :: cublasHandle
      integer(kind=C_INT),value               :: length, incx
      real(kind=C_FLOAT) ,value                :: alpha
      type(c_ptr), value                      :: x
    end subroutine
  end interface

  interface cublas_Saxpy
    module procedure cublas_Saxpy_intptr
    module procedure cublas_Saxpy_cptr
  end interface

  interface
    subroutine cublas_Saxpy_intptr_c(cublasHandle, length, alpha, x, incx, y, incy) &
               bind(C, name="cublasSscal_elpa_wrapper")
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=C_intptr_T), value         :: cublasHandle
      integer(kind=C_INT),value               :: length, incx, incy
      real(kind=C_FLOAT) ,value                :: alpha
      integer(kind=C_intptr_T), value         :: x, y
    end subroutine
  end interface

  interface
    subroutine cublas_Saxpy_cptr_c(cublasHandle, length, alpha, x, incx, y, incy) &
               bind(C, name="cublasSscal_elpa_wrapper")
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=C_intptr_T), value         :: cublasHandle
      integer(kind=C_INT),value               :: length, incx, incy
      real(kind=C_FLOAT) ,value                :: alpha
      type(c_ptr), value                      :: x, y
    end subroutine
  end interface

  interface cublas_Zdot
    module procedure cublas_Zdot_intptr
    module procedure cublas_Zdot_cptr
  end interface

  interface
    subroutine cublas_Zdot_intptr_c(conj, cublasHandle, length, x, incx, y, incy, z) &
               bind(C, name="cublasZdot_elpa_wrapper")
      use, intrinsic :: iso_c_binding
      implicit none
      character(1,C_CHAR),value               :: conj
      integer(kind=C_intptr_T), value         :: cublasHandle
      integer(kind=C_INT),value               :: length, incx, incy
      integer(kind=C_intptr_T), value         :: x, y, z
    end subroutine
  end interface

  interface
    subroutine cublas_Zdot_cptr_c(conj, cublasHandle, length, x, incx, y, incy, z) &
               bind(C, name="cublasZdot_elpa_wrapper")
      use, intrinsic :: iso_c_binding
      implicit none
      character(1,C_CHAR),value               :: conj
      integer(kind=C_intptr_T), value         :: cublasHandle
      integer(kind=C_INT),value               :: length, incx, incy
      type(c_ptr), value                      :: x, y, z
    end subroutine
  end interface

  interface cublas_Zscal
    module procedure cublas_Zscal_intptr
    module procedure cublas_Zscal_cptr
  end interface

  interface
    subroutine cublas_Zscal_intptr_c(cublasHandle, length, alpha, x, incx) &
               bind(C, name="cublasZscal_elpa_wrapper")
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=C_intptr_T), value         :: cublasHandle
      integer(kind=C_INT),value               :: length, incx
      complex(kind=C_DOUBLE_COMPLEX) ,value                :: alpha
      integer(kind=C_intptr_T), value         :: x
    end subroutine
  end interface

  interface
    subroutine cublas_Zscal_cptr_c(cublasHandle, length, alpha, x, incx) &
               bind(C, name="cublasZscal_elpa_wrapper")
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=C_intptr_T), value         :: cublasHandle
      integer(kind=C_INT),value               :: length, incx
      complex(kind=C_DOUBLE_COMPLEX) ,value                :: alpha
      type(c_ptr), value                      :: x
    end subroutine
  end interface

  interface cublas_Zaxpy
    module procedure cublas_Zaxpy_intptr
    module procedure cublas_Zaxpy_cptr
  end interface

  interface
    subroutine cublas_Zaxpy_intptr_c(cublasHandle, length, alpha, x, incx, y, incy) &
               bind(C, name="cublasZscal_elpa_wrapper")
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=C_intptr_T), value         :: cublasHandle
      integer(kind=C_INT),value               :: length, incx, incy
      complex(kind=C_DOUBLE_COMPLEX) ,value                :: alpha
      integer(kind=C_intptr_T), value         :: x, y
    end subroutine
  end interface

  interface
    subroutine cublas_Zaxpy_cptr_c(cublasHandle, length, alpha, x, incx, y, incy) &
               bind(C, name="cublasZscal_elpa_wrapper")
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=C_intptr_T), value         :: cublasHandle
      integer(kind=C_INT),value               :: length, incx, incy
      complex(kind=C_DOUBLE_COMPLEX) ,value                :: alpha
      type(c_ptr), value                      :: x, y
    end subroutine
  end interface

  interface cublas_Cdot
    module procedure cublas_Cdot_intptr
    module procedure cublas_Cdot_cptr
  end interface

  interface
    subroutine cublas_Cdot_intptr_c(conj, cublasHandle, length, x, incx, y, incy, z) &
               bind(C, name="cublasCdot_elpa_wrapper")
      use, intrinsic :: iso_c_binding
      implicit none
      character(1,C_CHAR),value               :: conj
      integer(kind=C_intptr_T), value         :: cublasHandle
      integer(kind=C_INT),value               :: length, incx, incy
      integer(kind=C_intptr_T), value         :: x, y, z
    end subroutine
  end interface

  interface
    subroutine cublas_Cdot_cptr_c(conj, cublasHandle, length, x, incx, y, incy, z) &
               bind(C, name="cublasCdot_elpa_wrapper")
      use, intrinsic :: iso_c_binding
      implicit none
      character(1,C_CHAR),value               :: conj
      integer(kind=C_intptr_T), value         :: cublasHandle
      integer(kind=C_INT),value               :: length, incx, incy
      type(c_ptr), value                      :: x, y, z
    end subroutine
  end interface

  interface cublas_Cscal
    module procedure cublas_Cscal_intptr
    module procedure cublas_Cscal_cptr
  end interface

  interface
    subroutine cublas_Cscal_intptr_c(cublasHandle, length, alpha, x, incx) &
               bind(C, name="cublasCscal_elpa_wrapper")
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=C_intptr_T), value         :: cublasHandle
      integer(kind=C_INT),value               :: length, incx
      complex(kind=C_FLOAT_COMPLEX) ,value                :: alpha
      integer(kind=C_intptr_T), value         :: x
    end subroutine
  end interface

  interface
    subroutine cublas_Cscal_cptr_c(cublasHandle, length, alpha, x, incx) &
               bind(C, name="cublasCscal_elpa_wrapper")
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=C_intptr_T), value         :: cublasHandle
      integer(kind=C_INT),value               :: length, incx
      complex(kind=C_FLOAT_COMPLEX) ,value                :: alpha
      type(c_ptr), value                      :: x
    end subroutine
  end interface

  interface cublas_Caxpy
    module procedure cublas_Caxpy_intptr
    module procedure cublas_Caxpy_cptr
  end interface

  interface
    subroutine cublas_Caxpy_intptr_c(cublasHandle, length, alpha, x, incx, y, incy) &
               bind(C, name="cublasCscal_elpa_wrapper")
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=C_intptr_T), value         :: cublasHandle
      integer(kind=C_INT),value               :: length, incx, incy
      complex(kind=C_FLOAT_COMPLEX) ,value                :: alpha
      integer(kind=C_intptr_T), value         :: x, y
    end subroutine
  end interface

  interface
    subroutine cublas_Caxpy_cptr_c(cublasHandle, length, alpha, x, incx, y, incy) &
               bind(C, name="cublasCscal_elpa_wrapper")
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=C_intptr_T), value         :: cublasHandle
      integer(kind=C_INT),value               :: length, incx, incy
      complex(kind=C_FLOAT_COMPLEX) ,value                :: alpha
      type(c_ptr), value                      :: x, y
    end subroutine
  end interface

  contains

    function cuda_stream_create(cudaStream) result(success)
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=C_intptr_t)                  :: cudaStream
      logical                                   :: success
      success = cuda_stream_create_c(cudaStream) /= 0
    end function

    function cuda_stream_destroy(cudaStream) result(success)
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=C_intptr_t)                  :: cudaStream
      logical                                   :: success
      success = cuda_stream_destroy_c(cudaStream) /= 0
    end function

    function cublas_set_stream(cublasHandle, cudaStream) result(success)
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=C_intptr_t)                  :: cublasHandle
      integer(kind=C_intptr_t)                  :: cudaStream
      logical                                   :: success
      success = cublas_set_stream_c(cublasHandle, cudaStream) /= 0
    end function

    function cusolver_set_stream(cusolverHandle, cudaStream) result(success)
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=C_intptr_t)                  :: cusolverHandle
      integer(kind=C_intptr_t)                  :: cudaStream
      logical                                   :: success

      success = .true.
    end function


    function cuda_stream_synchronize(cudaStream) result(success)
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=C_intptr_t), optional        :: cudaStream
      logical                                   :: success
      if (present(cudaStream)) then
        success = cuda_stream_synchronize_explicit_c(cudaStream) /= 0
      else
        success = cuda_stream_synchronize_implicit_c() /= 0
      endif
    end function


    function cublas_create(cublasHandle) result(success)
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=C_intptr_t)                  :: cublasHandle
      logical                                   :: success
      success = cublas_create_c(cublasHandle) /= 0
    end function

    function cublas_destroy(cublasHandle) result(success)
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=C_intptr_t)   :: cublasHandle
      logical                    :: success
      success = cublas_destroy_c(cublasHandle) /= 0
    end function

    function cusolver_create(cusolverHandle) result(success)
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=C_intptr_t)                  :: cusolverHandle
      logical                                   :: success
      success = .true.
    end function

    function cusolver_destroy(cusolverHandle) result(success)
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=C_intptr_t)                  :: cusolverHandle
      logical                                   :: success
      success = .true.
    end function

    function cuda_setdevice(n) result(success)
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=ik), intent(in)  :: n
      logical                       :: success
      success = cuda_setdevice_c(int(n,kind=c_int)) /= 0
    end function

    function cuda_getdevicecount(n) result(success)
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=ik)     :: n
      integer(kind=c_int)  :: nCasted
      logical              :: success
      success = cuda_getdevicecount_c(nCasted) /=0
      n = int(nCasted)
    end function

    function cuda_devicesynchronize()result(success)
      use, intrinsic :: iso_c_binding
      implicit none
      logical :: success
      success = cuda_devicesynchronize_c() /=0
    end function

    function cuda_malloc_intptr(a, width_height) result(success)
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=c_intptr_t)                  :: a
      integer(kind=c_intptr_t), intent(in)      :: width_height
      logical                                   :: success
      success = cuda_malloc_intptr_c(a, width_height) /= 0
    end function

    function cuda_malloc_cptr(a, width_height) result(success)
      use, intrinsic :: iso_c_binding
      implicit none
      type(c_ptr)                               :: a
      integer(kind=c_intptr_t), intent(in)      :: width_height
      logical                                   :: success
      success = cuda_malloc_cptr_c(a, width_height) /= 0
    end function

    function cuda_free_intptr(a) result(success)
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=C_intptr_T) :: a
      logical                  :: success
      success = cuda_free_intptr_c(a) /= 0
    end function

    function cuda_free_cptr(a) result(success)
      use, intrinsic :: iso_c_binding
      implicit none
      type(c_ptr) :: a
      logical                  :: success
      success = cuda_free_cptr_c(a) /= 0
    end function

    function cuda_malloc_host(a, width_height) result(success)
      use, intrinsic :: iso_c_binding
      implicit none
      type(c_ptr)                               :: a
      integer(kind=c_intptr_t), intent(in)      :: width_height
      logical                                   :: success
      success = cuda_malloc_host_c(a, width_height) /= 0
    end function

    function cuda_free_host(a) result(success)
      use, intrinsic :: iso_c_binding
      implicit none
      type(c_ptr)                   :: a
      logical                  :: success
      success = cuda_free_host_c(a) /= 0
    end function

    function cuda_memset(a, val, size) result(success)
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=c_intptr_t)                :: a
      integer(kind=ik)                        :: val
      integer(kind=c_intptr_t), intent(in)      :: size
      integer(kind=C_INT)                     :: istat
      logical :: success
      success= cuda_memset_c(a, int(val,kind=c_int), int(size,kind=c_intptr_t)) /=0
    end function

    function cuda_memset_async(a, val, size, cudaStream) result(success)
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=c_intptr_t)                :: a
      integer(kind=ik)                        :: val
      integer(kind=c_intptr_t), intent(in)    :: size
      integer(kind=C_INT)                     :: istat
      integer(kind=c_intptr_t)                :: cudaStream
      logical :: success

      success= cuda_memset_async_c(a, int(val,kind=c_int), int(size,kind=c_intptr_t), cudaStream) /=0
    end function

    function cuda_memcpyDeviceToDevice() result(flag)
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=ik) :: flag
      flag = int(cuda_memcpyDeviceToDevice_c())
    end function

    function cuda_memcpyHostToDevice() result(flag)
      use, intrinsic :: iso_c_binding
      use precision
      implicit none
      integer(kind=ik) :: flag
      flag = int(cuda_memcpyHostToDevice_c())
    end function

    function cuda_memcpyDeviceToHost() result(flag)
      use, intrinsic :: iso_c_binding
      use precision
      implicit none
      integer(kind=ik) :: flag
      flag = int( cuda_memcpyDeviceToHost_c())
    end function

    function cuda_hostRegisterDefault() result(flag)
      use, intrinsic :: iso_c_binding
      use precision
      implicit none
      integer(kind=ik) :: flag
      flag = int(cuda_hostRegisterDefault_c())
    end function

    function cuda_hostRegisterPortable() result(flag)
      use, intrinsic :: iso_c_binding
      use precision
      implicit none
      integer(kind=ik) :: flag
      flag = int(cuda_hostRegisterPortable_c())
    end function

    function cuda_hostRegisterMapped() result(flag)
      use, intrinsic :: iso_c_binding
      use precision
      implicit none
      integer(kind=ik) :: flag
      flag = int(cuda_hostRegisterMapped_c())
    end function

    function cuda_memcpy_intptr(dst, src, size, dir) result(success)
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=C_intptr_t)              :: dst
      integer(kind=C_intptr_t)              :: src
      integer(kind=c_intptr_t), intent(in)  :: size
      integer(kind=C_INT), intent(in)       :: dir
      logical :: success
      success = cuda_memcpy_intptr_c(dst, src, size, dir) /= 0
    end function

    function cuda_memcpy_cptr(dst, src, size, dir) result(success)
      use, intrinsic :: iso_c_binding
      implicit none
      type(c_ptr)                           :: dst
      type(c_ptr)                           :: src
      integer(kind=c_intptr_t), intent(in)  :: size
      integer(kind=C_INT), intent(in)       :: dir
      logical :: success
      success = cuda_memcpy_cptr_c(dst, src, size, dir) /= 0
    end function

    function cuda_memcpy_mixed_to_device(dst, src, size, dir) result(success)
      use, intrinsic :: iso_c_binding
      implicit none
      type(c_ptr)                           :: dst
      integer(kind=C_intptr_t)              :: src
      integer(kind=c_intptr_t), intent(in)  :: size
      integer(kind=C_INT), intent(in)       :: dir
      logical :: success
      success = cuda_memcpy_mixed_to_device_c(dst, src, size, dir) /= 0
    end function

    function cuda_memcpy_mixed_to_host(dst, src, size, dir) result(success)
      use, intrinsic :: iso_c_binding
      implicit none
      type(c_ptr)                           :: src
      integer(kind=C_intptr_t)              :: dst
      integer(kind=c_intptr_t), intent(in)  :: size
      integer(kind=C_INT), intent(in)       :: dir
      logical :: success
      success = cuda_memcpy_mixed_to_host_c(dst, src, size, dir) /= 0
    end function

    function cuda_memcpy_async_intptr(dst, src, size, dir, cudaStream) result(success)
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=C_intptr_t)              :: dst
      integer(kind=C_intptr_t)              :: src
      integer(kind=c_intptr_t), intent(in)  :: size
      integer(kind=C_INT), intent(in)       :: dir
      integer(kind=c_intptr_t), intent(in)  :: cudaStream
      logical :: success
      success = cuda_memcpy_async_intptr_c(dst, src, size, dir, cudaStream) /= 0
    end function

    function cuda_memcpy_async_cptr(dst, src, size, dir, cudaStream) result(success)
      use, intrinsic :: iso_c_binding
      implicit none
      type(c_ptr)                           :: dst
      type(c_ptr)                           :: src
      integer(kind=c_intptr_t), intent(in)  :: size
      integer(kind=C_INT), intent(in)       :: dir
      integer(kind=c_intptr_t), intent(in)  :: cudaStream
      logical :: success
      success = cuda_memcpy_async_cptr_c(dst, src, size, dir, cudaStream) /= 0
    end function

    function cuda_memcpy_async_mixed_to_device(dst, src, size, dir, cudaStream) result(success)
      use, intrinsic :: iso_c_binding
      implicit none
      type(c_ptr)                           :: dst
      integer(kind=C_intptr_t)              :: src
      integer(kind=c_intptr_t), intent(in)  :: size
      integer(kind=C_INT), intent(in)       :: dir
      integer(kind=c_intptr_t), intent(in)  :: cudaStream
      logical :: success
      success = cuda_memcpy_async_mixed_to_device_c(dst, src, size, dir, cudaStream) /= 0
    end function

    function cuda_memcpy_async_mixed_to_host(dst, src, size, dir, cudaStream) result(success)
      use, intrinsic :: iso_c_binding
      implicit none
      type(c_ptr)                           :: src
      integer(kind=C_intptr_t)              :: dst
      integer(kind=c_intptr_t), intent(in)  :: size
      integer(kind=C_INT), intent(in)       :: dir
      integer(kind=c_intptr_t), intent(in)  :: cudaStream
      logical :: success
      success = cuda_memcpy_async_mixed_to_host_c(dst, src, size, dir, cudaStream) /= 0
    end function

    function cuda_memcpy2d_intptr(dst, dpitch, src, spitch, width, height , dir) result(success)
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=C_intptr_T)           :: dst
      integer(kind=c_intptr_t), intent(in) :: dpitch
      integer(kind=C_intptr_T)           :: src
      integer(kind=c_intptr_t), intent(in) :: spitch
      integer(kind=c_intptr_t), intent(in) :: width
      integer(kind=c_intptr_t), intent(in) :: height
      integer(kind=C_INT), intent(in)    :: dir
      logical                            :: success
      success = cuda_memcpy2d_intptr_c(dst, dpitch, src, spitch, width, height , dir) /= 0
    end function

    function cuda_memcpy2d_cptr(dst, dpitch, src, spitch, width, height , dir) result(success)
      use, intrinsic :: iso_c_binding
      implicit none
      type(c_ptr)           :: dst
      integer(kind=c_intptr_t), intent(in) :: dpitch
      type(c_ptr)           :: src
      integer(kind=c_intptr_t), intent(in) :: spitch
      integer(kind=c_intptr_t), intent(in) :: width
      integer(kind=c_intptr_t), intent(in) :: height
      integer(kind=C_INT), intent(in)    :: dir
      logical                            :: success
      success = cuda_memcpy2d_cptr_c(dst, dpitch, src, spitch, width, height , dir) /= 0
    end function

    function cuda_memcpy2d_async_intptr(dst, dpitch, src, spitch, width, height, dir, cudaStream) result(success)
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=C_intptr_T)           :: dst
      integer(kind=c_intptr_t), intent(in) :: dpitch
      integer(kind=C_intptr_T)           :: src
      integer(kind=c_intptr_t), intent(in) :: spitch
      integer(kind=c_intptr_t), intent(in) :: width
      integer(kind=c_intptr_t), intent(in) :: height
      integer(kind=C_INT), intent(in)    :: dir
      integer(kind=c_intptr_t), intent(in) :: cudaStream
      logical                            :: success
      success = cuda_memcpy2d_async_intptr_c(dst, dpitch, src, spitch, width, height, dir, cudaStream) /= 0
    end function

    function cuda_memcpy2d_async_cptr(dst, dpitch, src, spitch, width, height, dir, cudaStream) result(success)
      use, intrinsic :: iso_c_binding
      implicit none
      type(c_ptr)           :: dst
      integer(kind=c_intptr_t), intent(in) :: dpitch
      type(c_ptr)           :: src
      integer(kind=c_intptr_t), intent(in) :: spitch
      integer(kind=c_intptr_t), intent(in) :: width
      integer(kind=c_intptr_t), intent(in) :: height
      integer(kind=C_INT), intent(in)    :: dir
      integer(kind=c_intptr_t), intent(in) :: cudaStream
      logical                            :: success
      success = cuda_memcpy2d_async_cptr_c(dst, dpitch, src, spitch, width, height, dir, cudaStream) /= 0
    end function

    function cuda_host_register(a, size, flag) result(success)
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=C_intptr_t)              :: a
      integer(kind=c_intptr_t), intent(in)  :: size
      integer(kind=C_INT), intent(in)       :: flag
      logical :: success
      success = cuda_host_register_c(a, size, flag) /= 0
    end function

    function cuda_host_unregister(a) result(success)
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=C_intptr_t)              :: a
      logical :: success
      success = cuda_host_unregister_c(a) /= 0
    end function

    subroutine cusolver_Dtrtri(uplo, diag, n, a, lda, info, cusolverHandle)
      use, intrinsic :: iso_c_binding
      implicit none
      character(1,C_CHAR),value       :: uplo, diag
      integer(kind=C_INT64_T)         :: n, lda
      integer(kind=c_intptr_t)        :: a
      integer(kind=c_int)             :: info
      integer(kind=C_intptr_T)        :: cusolverHandle
    end subroutine

    subroutine cusolver_Dpotrf(uplo, n, a, lda, info, cusolverHandle)
      use, intrinsic :: iso_c_binding
      implicit none
      character(1,C_CHAR),value       :: uplo
      integer(kind=C_INT)             :: n, lda
      integer(kind=c_intptr_t)        :: a
      integer(kind=c_int)             :: info
      integer(kind=C_intptr_T)        :: cusolverHandle
    end subroutine

    subroutine cublas_Dgemm_intptr(cta, ctb, m, n, k, alpha, a, lda, b, ldb, beta, c, ldc, cublasHandle)
      use, intrinsic :: iso_c_binding
      implicit none
      character(1,C_CHAR),value       :: cta, ctb
      integer(kind=C_INT)             :: m,n,k
      integer(kind=C_INT), intent(in) :: lda,ldb,ldc
      real(kind=C_DOUBLE) ,value               :: alpha,beta
      integer(kind=C_intptr_T)        :: a, b, c
      integer(kind=C_intptr_T)        :: cublasHandle
      call cublas_Dgemm_intptr_c(cublasHandle, cta, ctb, m, n, k, alpha, a, lda, b, ldb, beta, c, ldc)
    end subroutine

    subroutine cublas_Dgemm_cptr(cta, ctb, m, n, k, alpha, a, lda, b, ldb, beta, c, ldc, cublasHandle)
      use, intrinsic :: iso_c_binding
      implicit none
      character(1,C_CHAR),value       :: cta, ctb
      integer(kind=C_INT)             :: m,n,k
      integer(kind=C_INT), intent(in) :: lda,ldb,ldc
      real(kind=C_DOUBLE) ,value               :: alpha,beta
      type(c_ptr)                     :: a, b, c
      integer(kind=C_intptr_T)        :: cublasHandle
      call cublas_Dgemm_cptr_c(cublasHandle, cta, ctb, m, n, k, alpha, a, lda, b, ldb, beta, c, ldc)
    end subroutine

    subroutine cublas_Dcopy_intptr(n, x, incx, y, incy, cublasHandle)
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=C_INT)             :: n
      integer(kind=C_INT), intent(in) :: incx, incy
      integer(kind=C_intptr_T)        :: x, y
      integer(kind=C_intptr_T)        :: cublasHandle
      call cublas_Dcopy_intptr_c(cublasHandle, n, x, incx, y, incy)
    end subroutine

    subroutine cublas_Dcopy_cptr(n, x, incx, y, incy, cublasHandle)
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=C_INT)             :: n
      integer(kind=C_INT), intent(in) :: incx, incy
      type(c_ptr)                     :: x, y
      integer(kind=C_intptr_T)        :: cublasHandle
      call cublas_Dcopy_cptr_c(cublasHandle, n, x, incx, y, incy)
    end subroutine

    subroutine cublas_Dtrmm_intptr(side, uplo, trans, diag, m, n, alpha, a, lda, b, ldb, cublasHandle)
      use, intrinsic :: iso_c_binding
      implicit none
      character(1,C_CHAR),value       :: side, uplo, trans, diag
      integer(kind=C_INT)             :: m,n
      integer(kind=C_INT), intent(in) :: lda,ldb
      real(kind=C_DOUBLE) ,value               :: alpha
      integer(kind=C_intptr_T)        :: a, b
      integer(kind=C_intptr_T)        :: cublasHandle
      call cublas_Dtrmm_intptr_c(cublasHandle, side, uplo, trans, diag, m, n, alpha, a, lda, b, ldb)
    end subroutine

    subroutine cublas_Dtrmm_cptr(side, uplo, trans, diag, m, n, alpha, a, lda, b, ldb, cublasHandle)
      use, intrinsic :: iso_c_binding
      implicit none
      character(1,C_CHAR),value       :: side, uplo, trans, diag
      integer(kind=C_INT)             :: m,n
      integer(kind=C_INT), intent(in) :: lda,ldb
      real(kind=C_DOUBLE) ,value               :: alpha
      type(c_ptr)                     :: a, b
      integer(kind=C_intptr_T)        :: cublasHandle
      call cublas_Dtrmm_cptr_c(cublasHandle, side, uplo, trans, diag, m, n, alpha, a, lda, b, ldb)
    end subroutine

    subroutine cublas_Dtrsm_intptr(side, uplo, trans, diag, m, n, alpha, a, lda, b, ldb, cublasHandle)
      use, intrinsic :: iso_c_binding
      implicit none
      character(1,C_CHAR),value       :: side, uplo, trans, diag
      integer(kind=C_INT)             :: m,n
      integer(kind=C_INT), intent(in) :: lda,ldb
      real(kind=C_DOUBLE) ,value               :: alpha
      integer(kind=C_intptr_T)        :: a, b
      integer(kind=C_intptr_T)        :: cublasHandle
      call cublas_Dtrsm_intptr_c(cublasHandle, side, uplo, trans, diag, m, n, alpha, a, lda, b, ldb)
    end subroutine

    subroutine cublas_Dtrsm_cptr(side, uplo, trans, diag, m, n, alpha, a, lda, b, ldb, cublasHandle)
      use, intrinsic :: iso_c_binding
      implicit none
      character(1,C_CHAR),value       :: side, uplo, trans, diag
      integer(kind=C_INT)             :: m,n
      integer(kind=C_INT), intent(in) :: lda,ldb
      real(kind=C_DOUBLE) ,value               :: alpha
      type(c_ptr)                    :: a, b
      integer(kind=C_intptr_T)        :: cublasHandle
      call cublas_Dtrsm_cptr_c(cublasHandle, side, uplo, trans, diag, m, n, alpha, a, lda, b, ldb)
    end subroutine

    subroutine cublas_Dgemv(cta, m, n, alpha, a, lda, x, incx, beta, y, incy, cublasHandle)
      use, intrinsic :: iso_c_binding
      implicit none
      character(1,C_CHAR),value       :: cta
      integer(kind=C_INT)             :: m,n
      integer(kind=C_INT), intent(in) :: lda,incx,incy
      real(kind=C_DOUBLE) ,value               :: alpha,beta
      integer(kind=C_intptr_T)        :: a, x, y
      integer(kind=C_intptr_T)        :: cublasHandle
      call cublas_Dgemv_c(cublasHandle, cta, m, n, alpha, a, lda, x, incx, beta, y, incy)
    end subroutine

    subroutine cusolver_Strtri(uplo, diag, n, a, lda, info, cusolverHandle)
      use, intrinsic :: iso_c_binding
      implicit none
      character(1,C_CHAR),value       :: uplo, diag
      integer(kind=C_INT64_T)         :: n, lda
      integer(kind=c_intptr_t)        :: a
      integer(kind=c_int)             :: info
      integer(kind=C_intptr_T)        :: cusolverHandle
    end subroutine

    subroutine cusolver_Spotrf(uplo, n, a, lda, info, cusolverHandle)
      use, intrinsic :: iso_c_binding
      implicit none
      character(1,C_CHAR),value       :: uplo
      integer(kind=C_INT)             :: n, lda
      integer(kind=c_intptr_t)        :: a
      integer(kind=c_int)             :: info
      integer(kind=C_intptr_T)        :: cusolverHandle
    end subroutine

    subroutine cublas_Sgemm_intptr(cta, ctb, m, n, k, alpha, a, lda, b, ldb, beta, c, ldc, cublasHandle)
      use, intrinsic :: iso_c_binding
      implicit none
      character(1,C_CHAR),value       :: cta, ctb
      integer(kind=C_INT)             :: m,n,k
      integer(kind=C_INT), intent(in) :: lda,ldb,ldc
      real(kind=C_FLOAT) ,value               :: alpha,beta
      integer(kind=C_intptr_T)        :: a, b, c
      integer(kind=C_intptr_T)        :: cublasHandle
      call cublas_Sgemm_intptr_c(cublasHandle, cta, ctb, m, n, k, alpha, a, lda, b, ldb, beta, c, ldc)
    end subroutine

    subroutine cublas_Sgemm_cptr(cta, ctb, m, n, k, alpha, a, lda, b, ldb, beta, c, ldc, cublasHandle)
      use, intrinsic :: iso_c_binding
      implicit none
      character(1,C_CHAR),value       :: cta, ctb
      integer(kind=C_INT)             :: m,n,k
      integer(kind=C_INT), intent(in) :: lda,ldb,ldc
      real(kind=C_FLOAT) ,value               :: alpha,beta
      type(c_ptr)                     :: a, b, c
      integer(kind=C_intptr_T)        :: cublasHandle
      call cublas_Sgemm_cptr_c(cublasHandle, cta, ctb, m, n, k, alpha, a, lda, b, ldb, beta, c, ldc)
    end subroutine

    subroutine cublas_Scopy_intptr(n, x, incx, y, incy, cublasHandle)
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=C_INT)             :: n
      integer(kind=C_INT), intent(in) :: incx, incy
      integer(kind=C_intptr_T)        :: x, y
      integer(kind=C_intptr_T)        :: cublasHandle
      call cublas_Scopy_intptr_c(cublasHandle, n, x, incx, y, incy)
    end subroutine

    subroutine cublas_Scopy_cptr(n, x, incx, y, incy, cublasHandle)
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=C_INT)             :: n
      integer(kind=C_INT), intent(in) :: incx, incy
      type(c_ptr)                     :: x, y
      integer(kind=C_intptr_T)        :: cublasHandle
      call cublas_Scopy_cptr_c(cublasHandle, n, x, incx, y, incy)
    end subroutine

    subroutine cublas_Strmm_intptr(side, uplo, trans, diag, m, n, alpha, a, lda, b, ldb, cublasHandle)
      use, intrinsic :: iso_c_binding
      implicit none
      character(1,C_CHAR),value       :: side, uplo, trans, diag
      integer(kind=C_INT)             :: m,n
      integer(kind=C_INT), intent(in) :: lda,ldb
      real(kind=C_FLOAT) ,value               :: alpha
      integer(kind=C_intptr_T)        :: a, b
      integer(kind=C_intptr_T)        :: cublasHandle
      call cublas_Strmm_intptr_c(cublasHandle, side, uplo, trans, diag, m, n, alpha, a, lda, b, ldb)
    end subroutine

    subroutine cublas_Strmm_cptr(side, uplo, trans, diag, m, n, alpha, a, lda, b, ldb, cublasHandle)
      use, intrinsic :: iso_c_binding
      implicit none
      character(1,C_CHAR),value       :: side, uplo, trans, diag
      integer(kind=C_INT)             :: m,n
      integer(kind=C_INT), intent(in) :: lda,ldb
      real(kind=C_FLOAT) ,value               :: alpha
      type(c_ptr)                     :: a, b
      integer(kind=C_intptr_T)        :: cublasHandle
      call cublas_Strmm_cptr_c(cublasHandle, side, uplo, trans, diag, m, n, alpha, a, lda, b, ldb)
    end subroutine

    subroutine cublas_Strsm_intptr(side, uplo, trans, diag, m, n, alpha, a, lda, b, ldb, cublasHandle)
      use, intrinsic :: iso_c_binding
      implicit none
      character(1,C_CHAR),value       :: side, uplo, trans, diag
      integer(kind=C_INT)             :: m,n
      integer(kind=C_INT), intent(in) :: lda,ldb
      real(kind=C_FLOAT) ,value               :: alpha
      integer(kind=C_intptr_T)        :: a, b
      integer(kind=C_intptr_T)        :: cublasHandle
      call cublas_Strsm_intptr_c(cublasHandle, side, uplo, trans, diag, m, n, alpha, a, lda, b, ldb)
    end subroutine

    subroutine cublas_Strsm_cptr(side, uplo, trans, diag, m, n, alpha, a, lda, b, ldb, cublasHandle)
      use, intrinsic :: iso_c_binding
      implicit none
      character(1,C_CHAR),value       :: side, uplo, trans, diag
      integer(kind=C_INT)             :: m,n
      integer(kind=C_INT), intent(in) :: lda,ldb
      real(kind=C_FLOAT) ,value               :: alpha
      type(c_ptr)                    :: a, b
      integer(kind=C_intptr_T)        :: cublasHandle
      call cublas_Strsm_cptr_c(cublasHandle, side, uplo, trans, diag, m, n, alpha, a, lda, b, ldb)
    end subroutine

    subroutine cublas_Sgemv(cta, m, n, alpha, a, lda, x, incx, beta, y, incy, cublasHandle)
      use, intrinsic :: iso_c_binding
      implicit none
      character(1,C_CHAR),value       :: cta
      integer(kind=C_INT)             :: m,n
      integer(kind=C_INT), intent(in) :: lda,incx,incy
      real(kind=C_FLOAT) ,value               :: alpha,beta
      integer(kind=C_intptr_T)        :: a, x, y
      integer(kind=C_intptr_T)        :: cublasHandle
      call cublas_Sgemv_c(cublasHandle, cta, m, n, alpha, a, lda, x, incx, beta, y, incy)
    end subroutine

    subroutine cusolver_Ztrtri(uplo, diag, n, a, lda, info, cusolverHandle)
      use, intrinsic :: iso_c_binding
      implicit none
      character(1,C_CHAR),value       :: uplo, diag
      integer(kind=C_INT64_T)         :: n, lda
      integer(kind=c_intptr_t)        :: a
      integer(kind=c_int)             :: info
      integer(kind=C_intptr_T)        :: cusolverHandle
    end subroutine

    subroutine cusolver_Zpotrf(uplo, n, a, lda, info, cusolverHandle)
      use, intrinsic :: iso_c_binding
      implicit none
      character(1,C_CHAR),value       :: uplo
      integer(kind=C_INT)             :: n, lda
      integer(kind=c_intptr_t)        :: a
      integer(kind=c_int)             :: info
      integer(kind=C_intptr_T)        :: cusolverHandle
    end subroutine

    subroutine cublas_Zgemm_intptr(cta, ctb, m, n, k, alpha, a, lda, b, ldb, beta, c, ldc, cublasHandle)
      use, intrinsic :: iso_c_binding
      implicit none
      character(1,C_CHAR),value       :: cta, ctb
      integer(kind=C_INT)             :: m,n,k
      integer(kind=C_INT), intent(in) :: lda,ldb,ldc
      complex(kind=C_DOUBLE_COMPLEX) ,value               :: alpha,beta
      integer(kind=C_intptr_T)        :: a, b, c
      integer(kind=C_intptr_T)        :: cublasHandle
      call cublas_Zgemm_intptr_c(cublasHandle, cta, ctb, m, n, k, alpha, a, lda, b, ldb, beta, c, ldc)
    end subroutine

    subroutine cublas_Zgemm_cptr(cta, ctb, m, n, k, alpha, a, lda, b, ldb, beta, c, ldc, cublasHandle)
      use, intrinsic :: iso_c_binding
      implicit none
      character(1,C_CHAR),value       :: cta, ctb
      integer(kind=C_INT)             :: m,n,k
      integer(kind=C_INT), intent(in) :: lda,ldb,ldc
      complex(kind=C_DOUBLE_COMPLEX) ,value               :: alpha,beta
      type(c_ptr)                     :: a, b, c
      integer(kind=C_intptr_T)        :: cublasHandle
      call cublas_Zgemm_cptr_c(cublasHandle, cta, ctb, m, n, k, alpha, a, lda, b, ldb, beta, c, ldc)
    end subroutine

    subroutine cublas_Zcopy_intptr(n, x, incx, y, incy, cublasHandle)
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=C_INT)             :: n
      integer(kind=C_INT), intent(in) :: incx, incy
      integer(kind=C_intptr_T)        :: x, y
      integer(kind=C_intptr_T)        :: cublasHandle
      call cublas_Zcopy_intptr_c(cublasHandle, n, x, incx, y, incy)
    end subroutine

    subroutine cublas_Zcopy_cptr(n, x, incx, y, incy, cublasHandle)
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=C_INT)             :: n
      integer(kind=C_INT), intent(in) :: incx, incy
      type(c_ptr)                     :: x, y
      integer(kind=C_intptr_T)        :: cublasHandle
      call cublas_Zcopy_cptr_c(cublasHandle, n, x, incx, y, incy)
    end subroutine

    subroutine cublas_Ztrmm_intptr(side, uplo, trans, diag, m, n, alpha, a, lda, b, ldb, cublasHandle)
      use, intrinsic :: iso_c_binding
      implicit none
      character(1,C_CHAR),value       :: side, uplo, trans, diag
      integer(kind=C_INT)             :: m,n
      integer(kind=C_INT), intent(in) :: lda,ldb
      complex(kind=C_DOUBLE_COMPLEX) ,value               :: alpha
      integer(kind=C_intptr_T)        :: a, b
      integer(kind=C_intptr_T)        :: cublasHandle
      call cublas_Ztrmm_intptr_c(cublasHandle, side, uplo, trans, diag, m, n, alpha, a, lda, b, ldb)
    end subroutine

    subroutine cublas_Ztrmm_cptr(side, uplo, trans, diag, m, n, alpha, a, lda, b, ldb, cublasHandle)
      use, intrinsic :: iso_c_binding
      implicit none
      character(1,C_CHAR),value       :: side, uplo, trans, diag
      integer(kind=C_INT)             :: m,n
      integer(kind=C_INT), intent(in) :: lda,ldb
      complex(kind=C_DOUBLE_COMPLEX) ,value               :: alpha
      type(c_ptr)                     :: a, b
      integer(kind=C_intptr_T)        :: cublasHandle
      call cublas_Ztrmm_cptr_c(cublasHandle, side, uplo, trans, diag, m, n, alpha, a, lda, b, ldb)
    end subroutine

    subroutine cublas_Ztrsm_intptr(side, uplo, trans, diag, m, n, alpha, a, lda, b, ldb, cublasHandle)
      use, intrinsic :: iso_c_binding
      implicit none
      character(1,C_CHAR),value       :: side, uplo, trans, diag
      integer(kind=C_INT)             :: m,n
      integer(kind=C_INT), intent(in) :: lda,ldb
      complex(kind=C_DOUBLE_COMPLEX) ,value               :: alpha
      integer(kind=C_intptr_T)        :: a, b
      integer(kind=C_intptr_T)        :: cublasHandle
      call cublas_Ztrsm_intptr_c(cublasHandle, side, uplo, trans, diag, m, n, alpha, a, lda, b, ldb)
    end subroutine

    subroutine cublas_Ztrsm_cptr(side, uplo, trans, diag, m, n, alpha, a, lda, b, ldb, cublasHandle)
      use, intrinsic :: iso_c_binding
      implicit none
      character(1,C_CHAR),value       :: side, uplo, trans, diag
      integer(kind=C_INT)             :: m,n
      integer(kind=C_INT), intent(in) :: lda,ldb
      complex(kind=C_DOUBLE_COMPLEX) ,value               :: alpha
      type(c_ptr)                    :: a, b
      integer(kind=C_intptr_T)        :: cublasHandle
      call cublas_Ztrsm_cptr_c(cublasHandle, side, uplo, trans, diag, m, n, alpha, a, lda, b, ldb)
    end subroutine

    subroutine cublas_Zgemv(cta, m, n, alpha, a, lda, x, incx, beta, y, incy, cublasHandle)
      use, intrinsic :: iso_c_binding
      implicit none
      character(1,C_CHAR),value       :: cta
      integer(kind=C_INT)             :: m,n
      integer(kind=C_INT), intent(in) :: lda,incx,incy
      complex(kind=C_DOUBLE_COMPLEX) ,value               :: alpha,beta
      integer(kind=C_intptr_T)        :: a, x, y
      integer(kind=C_intptr_T)        :: cublasHandle
      call cublas_Zgemv_c(cublasHandle, cta, m, n, alpha, a, lda, x, incx, beta, y, incy)
    end subroutine

    subroutine cusolver_Ctrtri(uplo, diag, n, a, lda, info, cusolverHandle)
      use, intrinsic :: iso_c_binding
      implicit none
      character(1,C_CHAR),value       :: uplo, diag
      integer(kind=C_INT64_T)         :: n, lda
      integer(kind=c_intptr_t)        :: a
      integer(kind=c_int)             :: info
      integer(kind=C_intptr_T)        :: cusolverHandle
    end subroutine

    subroutine cusolver_Cpotrf(uplo, n, a, lda, info, cusolverHandle)
      use, intrinsic :: iso_c_binding
      implicit none
      character(1,C_CHAR),value       :: uplo
      integer(kind=C_INT)             :: n, lda
      integer(kind=c_intptr_t)        :: a
      integer(kind=c_int)             :: info
      integer(kind=C_intptr_T)        :: cusolverHandle
    end subroutine

    subroutine cublas_Cgemm_intptr(cta, ctb, m, n, k, alpha, a, lda, b, ldb, beta, c, ldc, cublasHandle)
      use, intrinsic :: iso_c_binding
      implicit none
      character(1,C_CHAR),value       :: cta, ctb
      integer(kind=C_INT)             :: m,n,k
      integer(kind=C_INT), intent(in) :: lda,ldb,ldc
      complex(kind=C_FLOAT_COMPLEX) ,value               :: alpha,beta
      integer(kind=C_intptr_T)        :: a, b, c
      integer(kind=C_intptr_T)        :: cublasHandle
      call cublas_Cgemm_intptr_c(cublasHandle, cta, ctb, m, n, k, alpha, a, lda, b, ldb, beta, c, ldc)
    end subroutine

    subroutine cublas_Cgemm_cptr(cta, ctb, m, n, k, alpha, a, lda, b, ldb, beta, c, ldc, cublasHandle)
      use, intrinsic :: iso_c_binding
      implicit none
      character(1,C_CHAR),value       :: cta, ctb
      integer(kind=C_INT)             :: m,n,k
      integer(kind=C_INT), intent(in) :: lda,ldb,ldc
      complex(kind=C_FLOAT_COMPLEX) ,value               :: alpha,beta
      type(c_ptr)                     :: a, b, c
      integer(kind=C_intptr_T)        :: cublasHandle
      call cublas_Cgemm_cptr_c(cublasHandle, cta, ctb, m, n, k, alpha, a, lda, b, ldb, beta, c, ldc)
    end subroutine

    subroutine cublas_Ccopy_intptr(n, x, incx, y, incy, cublasHandle)
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=C_INT)             :: n
      integer(kind=C_INT), intent(in) :: incx, incy
      integer(kind=C_intptr_T)        :: x, y
      integer(kind=C_intptr_T)        :: cublasHandle
      call cublas_Ccopy_intptr_c(cublasHandle, n, x, incx, y, incy)
    end subroutine

    subroutine cublas_Ccopy_cptr(n, x, incx, y, incy, cublasHandle)
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=C_INT)             :: n
      integer(kind=C_INT), intent(in) :: incx, incy
      type(c_ptr)                     :: x, y
      integer(kind=C_intptr_T)        :: cublasHandle
      call cublas_Ccopy_cptr_c(cublasHandle, n, x, incx, y, incy)
    end subroutine

    subroutine cublas_Ctrmm_intptr(side, uplo, trans, diag, m, n, alpha, a, lda, b, ldb, cublasHandle)
      use, intrinsic :: iso_c_binding
      implicit none
      character(1,C_CHAR),value       :: side, uplo, trans, diag
      integer(kind=C_INT)             :: m,n
      integer(kind=C_INT), intent(in) :: lda,ldb
      complex(kind=C_FLOAT_COMPLEX) ,value               :: alpha
      integer(kind=C_intptr_T)        :: a, b
      integer(kind=C_intptr_T)        :: cublasHandle
      call cublas_Ctrmm_intptr_c(cublasHandle, side, uplo, trans, diag, m, n, alpha, a, lda, b, ldb)
    end subroutine

    subroutine cublas_Ctrmm_cptr(side, uplo, trans, diag, m, n, alpha, a, lda, b, ldb, cublasHandle)
      use, intrinsic :: iso_c_binding
      implicit none
      character(1,C_CHAR),value       :: side, uplo, trans, diag
      integer(kind=C_INT)             :: m,n
      integer(kind=C_INT), intent(in) :: lda,ldb
      complex(kind=C_FLOAT_COMPLEX) ,value               :: alpha
      type(c_ptr)                     :: a, b
      integer(kind=C_intptr_T)        :: cublasHandle
      call cublas_Ctrmm_cptr_c(cublasHandle, side, uplo, trans, diag, m, n, alpha, a, lda, b, ldb)
    end subroutine

    subroutine cublas_Ctrsm_intptr(side, uplo, trans, diag, m, n, alpha, a, lda, b, ldb, cublasHandle)
      use, intrinsic :: iso_c_binding
      implicit none
      character(1,C_CHAR),value       :: side, uplo, trans, diag
      integer(kind=C_INT)             :: m,n
      integer(kind=C_INT), intent(in) :: lda,ldb
      complex(kind=C_FLOAT_COMPLEX) ,value               :: alpha
      integer(kind=C_intptr_T)        :: a, b
      integer(kind=C_intptr_T)        :: cublasHandle
      call cublas_Ctrsm_intptr_c(cublasHandle, side, uplo, trans, diag, m, n, alpha, a, lda, b, ldb)
    end subroutine

    subroutine cublas_Ctrsm_cptr(side, uplo, trans, diag, m, n, alpha, a, lda, b, ldb, cublasHandle)
      use, intrinsic :: iso_c_binding
      implicit none
      character(1,C_CHAR),value       :: side, uplo, trans, diag
      integer(kind=C_INT)             :: m,n
      integer(kind=C_INT), intent(in) :: lda,ldb
      complex(kind=C_FLOAT_COMPLEX) ,value               :: alpha
      type(c_ptr)                    :: a, b
      integer(kind=C_intptr_T)        :: cublasHandle
      call cublas_Ctrsm_cptr_c(cublasHandle, side, uplo, trans, diag, m, n, alpha, a, lda, b, ldb)
    end subroutine

    subroutine cublas_Cgemv(cta, m, n, alpha, a, lda, x, incx, beta, y, incy, cublasHandle)
      use, intrinsic :: iso_c_binding
      implicit none
      character(1,C_CHAR),value       :: cta
      integer(kind=C_INT)             :: m,n
      integer(kind=C_INT), intent(in) :: lda,incx,incy
      complex(kind=C_FLOAT_COMPLEX) ,value               :: alpha,beta
      integer(kind=C_intptr_T)        :: a, x, y
      integer(kind=C_intptr_T)        :: cublasHandle
      call cublas_Cgemv_c(cublasHandle, cta, m, n, alpha, a, lda, x, incx, beta, y, incy)
    end subroutine

    function cublas_pointerModeDevice() result(flag)
      use, intrinsic :: iso_c_binding
      use precision
      implicit none
      integer(kind=ik) :: flag
      flag = int(cublas_pointerModeDevice_c())
    end function

    function cublas_pointerModeHost() result(flag)
      use, intrinsic :: iso_c_binding
      use precision
      implicit none
      integer(kind=ik) :: flag
      flag = int(cublas_pointerModeHost_c())
    end function

    subroutine cublas_getPointerMode(cublasHandle, mode)
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=c_intptr_t) :: cublasHandle
      integer(kind=c_int)      :: mode

      call cublas_getPointerMode_c(cublasHandle, mode)
    end subroutine

    subroutine cublas_setPointerMode(cublasHandle, mode)
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=c_intptr_t) :: cublasHandle
      integer(kind=c_int)      :: mode

      call cublas_setPointerMode_c(cublasHandle, mode)
    end subroutine


    subroutine cublas_Ddot_intptr(cublasHandle, length, x, incx, y, incy, z)
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=c_intptr_t) :: cublasHandle
      integer(kind=c_int)      :: length, incx, incy
      integer(kind=c_intptr_t) :: x, y, z

      call cublas_Ddot_intptr_c(cublasHandle, length, x, incx, y, incy, z)
    end subroutine

    subroutine cublas_Ddot_cptr(cublasHandle, length, x, incx, y, incy, z)
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=c_intptr_t) :: cublasHandle
      integer(kind=c_int)      :: length, incx, incy
      type(c_ptr)              :: x, y, z

      call cublas_Ddot_cptr_c(cublasHandle, length, x, incx, y, incy, z)
    end subroutine

    subroutine cublas_Dscal_intptr(cublasHandle, length, alpha, x, incx)
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=c_intptr_t) :: cublasHandle
      integer(kind=c_int)      :: length, incx
      real(kind=C_DOUBLE) ,value               :: alpha
      integer(kind=c_intptr_t) :: x

      call cublas_Dscal_intptr_c(cublasHandle, length, alpha, x, incx)
    end subroutine

    subroutine cublas_Dscal_cptr(cublasHandle, length, alpha, x, incx)
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=c_intptr_t) :: cublasHandle
      integer(kind=c_int)      :: length, incx
      real(kind=C_DOUBLE) ,value               :: alpha
      type(c_ptr)              :: x

      call cublas_Dscal_cptr_c(cublasHandle, length, alpha, x, incx)
    end subroutine

    subroutine cublas_Daxpy_intptr(cublasHandle, length, alpha, x, incx, y, incy)
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=c_intptr_t) :: cublasHandle
      integer(kind=c_int)      :: length, incx, incy
      real(kind=C_DOUBLE) ,value               :: alpha
      integer(kind=c_intptr_t) :: x, y

      call cublas_Daxpy_intptr_c(cublasHandle, length, alpha, x, incx, y, incy)
    end subroutine

    subroutine cublas_Daxpy_cptr(cublasHandle, length, alpha, x, incx, y, incy)
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=c_intptr_t) :: cublasHandle
      integer(kind=c_int)      :: length, incx, incy
      real(kind=C_DOUBLE) ,value               :: alpha
      type(c_ptr)              :: x, y

      call cublas_Daxpy_cptr_c(cublasHandle, length, alpha, x, incx, y, incy)
    end subroutine


    subroutine cublas_Sdot_intptr(cublasHandle, length, x, incx, y, incy, z)
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=c_intptr_t) :: cublasHandle
      integer(kind=c_int)      :: length, incx, incy
      integer(kind=c_intptr_t) :: x, y, z

      call cublas_Sdot_intptr_c(cublasHandle, length, x, incx, y, incy, z)
    end subroutine

    subroutine cublas_Sdot_cptr(cublasHandle, length, x, incx, y, incy, z)
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=c_intptr_t) :: cublasHandle
      integer(kind=c_int)      :: length, incx, incy
      type(c_ptr)              :: x, y, z

      call cublas_Sdot_cptr_c(cublasHandle, length, x, incx, y, incy, z)
    end subroutine

    subroutine cublas_Sscal_intptr(cublasHandle, length, alpha, x, incx)
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=c_intptr_t) :: cublasHandle
      integer(kind=c_int)      :: length, incx
      real(kind=C_FLOAT) ,value               :: alpha
      integer(kind=c_intptr_t) :: x

      call cublas_Sscal_intptr_c(cublasHandle, length, alpha, x, incx)
    end subroutine

    subroutine cublas_Sscal_cptr(cublasHandle, length, alpha, x, incx)
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=c_intptr_t) :: cublasHandle
      integer(kind=c_int)      :: length, incx
      real(kind=C_FLOAT) ,value               :: alpha
      type(c_ptr)              :: x

      call cublas_Sscal_cptr_c(cublasHandle, length, alpha, x, incx)
    end subroutine

    subroutine cublas_Saxpy_intptr(cublasHandle, length, alpha, x, incx, y, incy)
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=c_intptr_t) :: cublasHandle
      integer(kind=c_int)      :: length, incx, incy
      real(kind=C_FLOAT) ,value               :: alpha
      integer(kind=c_intptr_t) :: x, y

      call cublas_Saxpy_intptr_c(cublasHandle, length, alpha, x, incx, y, incy)
    end subroutine

    subroutine cublas_Saxpy_cptr(cublasHandle, length, alpha, x, incx, y, incy)
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=c_intptr_t) :: cublasHandle
      integer(kind=c_int)      :: length, incx, incy
      real(kind=C_FLOAT) ,value               :: alpha
      type(c_ptr)              :: x, y

      call cublas_Saxpy_cptr_c(cublasHandle, length, alpha, x, incx, y, incy)
    end subroutine


    subroutine cublas_Zdot_intptr(conj, cublasHandle, length, x, incx, y, incy, z)
      use, intrinsic :: iso_c_binding
      implicit none
       character(1,c_char), value   :: conj
      integer(kind=c_intptr_t) :: cublasHandle
      integer(kind=c_int)      :: length, incx, incy
      integer(kind=c_intptr_t) :: x, y, z

      call cublas_Zdot_intptr_c(conj,cublasHandle, length, x, incx, y, incy, z)
    end subroutine

    subroutine cublas_Zdot_cptr(conj, cublasHandle, length, x, incx, y, incy, z)
      use, intrinsic :: iso_c_binding
      implicit none
       character(1,c_char), value   :: conj
      integer(kind=c_intptr_t) :: cublasHandle
      integer(kind=c_int)      :: length, incx, incy
      type(c_ptr)              :: x, y, z

      call cublas_Zdot_cptr_c(conj,cublasHandle, length, x, incx, y, incy, z)
    end subroutine

    subroutine cublas_Zscal_intptr(cublasHandle, length, alpha, x, incx)
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=c_intptr_t) :: cublasHandle
      integer(kind=c_int)      :: length, incx
      complex(kind=C_DOUBLE_COMPLEX) ,value               :: alpha
      integer(kind=c_intptr_t) :: x

      call cublas_Zscal_intptr_c(cublasHandle, length, alpha, x, incx)
    end subroutine

    subroutine cublas_Zscal_cptr(cublasHandle, length, alpha, x, incx)
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=c_intptr_t) :: cublasHandle
      integer(kind=c_int)      :: length, incx
      complex(kind=C_DOUBLE_COMPLEX) ,value               :: alpha
      type(c_ptr)              :: x

      call cublas_Zscal_cptr_c(cublasHandle, length, alpha, x, incx)
    end subroutine

    subroutine cublas_Zaxpy_intptr(cublasHandle, length, alpha, x, incx, y, incy)
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=c_intptr_t) :: cublasHandle
      integer(kind=c_int)      :: length, incx, incy
      complex(kind=C_DOUBLE_COMPLEX) ,value               :: alpha
      integer(kind=c_intptr_t) :: x, y

      call cublas_Zaxpy_intptr_c(cublasHandle, length, alpha, x, incx, y, incy)
    end subroutine

    subroutine cublas_Zaxpy_cptr(cublasHandle, length, alpha, x, incx, y, incy)
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=c_intptr_t) :: cublasHandle
      integer(kind=c_int)      :: length, incx, incy
      complex(kind=C_DOUBLE_COMPLEX) ,value               :: alpha
      type(c_ptr)              :: x, y

      call cublas_Zaxpy_cptr_c(cublasHandle, length, alpha, x, incx, y, incy)
    end subroutine


    subroutine cublas_Cdot_intptr(conj, cublasHandle, length, x, incx, y, incy, z)
      use, intrinsic :: iso_c_binding
      implicit none
       character(1,c_char), value   :: conj
      integer(kind=c_intptr_t) :: cublasHandle
      integer(kind=c_int)      :: length, incx, incy
      integer(kind=c_intptr_t) :: x, y, z

      call cublas_Cdot_intptr_c(conj,cublasHandle, length, x, incx, y, incy, z)
    end subroutine

    subroutine cublas_Cdot_cptr(conj, cublasHandle, length, x, incx, y, incy, z)
      use, intrinsic :: iso_c_binding
      implicit none
       character(1,c_char), value   :: conj
      integer(kind=c_intptr_t) :: cublasHandle
      integer(kind=c_int)      :: length, incx, incy
      type(c_ptr)              :: x, y, z

      call cublas_Cdot_cptr_c(conj,cublasHandle, length, x, incx, y, incy, z)
    end subroutine

    subroutine cublas_Cscal_intptr(cublasHandle, length, alpha, x, incx)
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=c_intptr_t) :: cublasHandle
      integer(kind=c_int)      :: length, incx
      complex(kind=C_FLOAT_COMPLEX) ,value               :: alpha
      integer(kind=c_intptr_t) :: x

      call cublas_Cscal_intptr_c(cublasHandle, length, alpha, x, incx)
    end subroutine

    subroutine cublas_Cscal_cptr(cublasHandle, length, alpha, x, incx)
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=c_intptr_t) :: cublasHandle
      integer(kind=c_int)      :: length, incx
      complex(kind=C_FLOAT_COMPLEX) ,value               :: alpha
      type(c_ptr)              :: x

      call cublas_Cscal_cptr_c(cublasHandle, length, alpha, x, incx)
    end subroutine

    subroutine cublas_Caxpy_intptr(cublasHandle, length, alpha, x, incx, y, incy)
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=c_intptr_t) :: cublasHandle
      integer(kind=c_int)      :: length, incx, incy
      complex(kind=C_FLOAT_COMPLEX) ,value               :: alpha
      integer(kind=c_intptr_t) :: x, y

      call cublas_Caxpy_intptr_c(cublasHandle, length, alpha, x, incx, y, incy)
    end subroutine

    subroutine cublas_Caxpy_cptr(cublasHandle, length, alpha, x, incx, y, incy)
      use, intrinsic :: iso_c_binding
      implicit none
      integer(kind=c_intptr_t) :: cublasHandle
      integer(kind=c_int)      :: length, incx, incy
      complex(kind=C_FLOAT_COMPLEX) ,value               :: alpha
      type(c_ptr)              :: x, y

      call cublas_Caxpy_cptr_c(cublasHandle, length, alpha, x, incx, y, incy)
    end subroutine


end module test_cuda_functions
