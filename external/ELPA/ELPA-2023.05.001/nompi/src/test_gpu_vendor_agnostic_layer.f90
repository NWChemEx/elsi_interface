












module test_gpu
  use precision_for_tests
  use iso_c_binding



!#ifdef WITH_INTEL_GPU_VERSION
!  use mkl_offload
!#endif
  integer(kind=c_int), parameter :: nvidia_gpu = 1
  integer(kind=c_int), parameter :: amd_gpu = 2
  integer(kind=c_int), parameter :: intel_gpu = 3
  integer(kind=c_int), parameter :: openmp_offload_gpu = 4
  integer(kind=c_int), parameter :: sycl_gpu = 5
  integer(kind=c_int), parameter :: no_gpu = -1

  ! the following variables, as long as they are not stored in the ELPA object
  ! prohibit to run ELPA at the same time on different GPUs of different vendors!
  integer(kind=c_int)            :: use_gpu_vendor
  integer(kind=c_int)            :: gpuHostRegisterDefault    
  integer(kind=c_int)            :: gpuMemcpyHostToDevice    
  integer(kind=c_int)            :: gpuMemcpyDeviceToHost   
  integer(kind=c_int)            :: gpuMemcpyDeviceToDevice
  integer(kind=c_int)            :: gpuHostRegisterMapped
  integer(kind=c_int)            :: gpuHostRegisterPortable

  integer(kind=c_int)            :: gpublasPointerModeHost
  integer(kind=c_int)            :: gpublasPointerModeDevice
  integer(kind=c_int)            :: gpublasDefaultPointerMode

  !! per task information should be stored elsewhere
  !integer(kind=C_intptr_T), allocatable :: gpublasHandleArray(:)
  !integer(kind=c_int), allocatable      :: gpuDeviceArray(:)
  !integer(kind=c_intptr_t)              :: my_stream



  integer(kind=c_intptr_t), parameter :: size_of_double_real    = 8_rk8
  integer(kind=c_intptr_t), parameter :: size_of_single_real    = 4_rk4

  integer(kind=c_intptr_t), parameter :: size_of_double_complex = 16_ck8
  integer(kind=c_intptr_t), parameter :: size_of_single_complex = 8_ck4

  interface gpu_memcpy
    module procedure gpu_memcpy_intptr
    module procedure gpu_memcpy_cptr
    module procedure gpu_memcpy_mixed_to_device
    module procedure gpu_memcpy_mixed_to_host
  end interface

  interface gpu_memcpy_async
    module procedure gpu_memcpy_async_intptr
    module procedure gpu_memcpy_async_cptr
    module procedure gpu_memcpy_async_mixed_to_device
    module procedure gpu_memcpy_async_mixed_to_host
  end interface

  interface gpu_memcpy2d
    module procedure gpu_memcpy2d_intptr
    module procedure gpu_memcpy2d_cptr
  end interface

  interface gpu_memcpy2d_async
    module procedure gpu_memcpy2d_async_intptr
    module procedure gpu_memcpy2d_async_cptr
  end interface

  interface gpu_malloc
    module procedure gpu_malloc_intptr
    module procedure gpu_malloc_cptr
  end interface

  interface gpu_free
    module procedure gpu_free_intptr
    module procedure gpu_free_cptr
  end interface

  interface gpu_vendor
    module procedure gpu_vendor_internal
    module procedure gpu_vendor_external_tests
  end interface

  contains
    function gpu_vendor_internal() result(vendor)
      implicit none
      integer(kind=c_int) :: vendor
      ! default
      vendor = no_gpu
      vendor = nvidia_gpu
!#ifdef WITH_INTEL_GPU_VERSION
!      vendor = intel_gpu
!#endif
      use_gpu_vendor = vendor
      return
    end function

    function gpu_vendor_external_tests(set_vendor) result(vendor)
      implicit none
      integer(kind=c_int)             :: vendor
      integer(kind=c_int), intent(in) :: set_vendor
      ! default
      vendor = no_gpu
      if (set_vendor == nvidia_gpu) then
        vendor = nvidia_gpu
      endif
      if (set_vendor == amd_gpu) then
        vendor = amd_gpu
      endif
      if (vendor == no_gpu) then
        print *,"setting gpu vendor in tests does not work"
        stop 1
      endif
!#if TEST_INTEL_GPU == 1
!      vendor = intel_gpu
!#endif
      use_gpu_vendor = vendor
      return
    end function

    subroutine set_gpu_parameters
      use cuda_functions
      implicit none

      if (use_gpu_vendor == nvidia_gpu) then
        cudaMemcpyHostToDevice   = cuda_memcpyHostToDevice()
        gpuMemcpyHostToDevice    = cudaMemcpyHostToDevice
        cudaMemcpyDeviceToHost   = cuda_memcpyDeviceToHost()
        gpuMemcpyDeviceToHost    = cudaMemcpyDeviceToHost
        cudaMemcpyDeviceToDevice = cuda_memcpyDeviceToDevice()
        gpuMemcpyDeviceToDevice  = cudaMemcpyDeviceToDevice
        cudaHostRegisterPortable = cuda_hostRegisterPortable()
        gpuHostRegisterPortable  = cudaHostRegisterPortable
        cudaHostRegisterMapped   = cuda_hostRegisterMapped()
        gpuHostRegisterMapped    = cudaHostRegisterMapped
        cudaHostRegisterDefault  = cuda_hostRegisterDefault()
        gpuHostRegisterDefault   = cudaHostRegisterDefault

        cublasPointerModeDevice  = cublas_PointerModeDevice()
        gpublasPointerModeDevice = cublasPointerModeDevice
        cublasPointerModeHost    = cublas_PointerModeHost()
        gpublasPointerModeHost   = cublasPointerModeHost
      endif




    end subroutine


    function gpu_stream_synchronize(stream) result(success)
      use, intrinsic :: iso_c_binding
      use cuda_functions

      implicit none

      integer(kind=c_intptr_t), intent(in), optional  :: stream
      logical                                         :: success

      success = .true.
      if (present(stream)) then
      else
      endif



    end function

    function gpu_getdevicecount(n) result(success)
      use, intrinsic :: iso_c_binding
      use cuda_functions

      implicit none

      integer(kind=ik)              :: n
      logical                       :: success

      success = cuda_getdevicecount(n)

      if (.not.(success)) then
        print *,"error in cuda_getdevicecount"
        stop 1
      endif
    end function

    function gpu_setdevice(n) result(success)
      use, intrinsic :: iso_c_binding
      use cuda_functions

      implicit none

      integer(kind=ik), intent(in)  :: n
      logical                       :: success

      if (use_gpu_vendor == nvidia_gpu) then
        success = cuda_setdevice(n)
      endif
    end function

    function gpu_devicesynchronize() result(success)
      use, intrinsic :: iso_c_binding
      use cuda_functions
      implicit none
      logical                              :: success

      success = .false.

      if (use_gpu_vendor == nvidia_gpu) then
        success = cuda_devicesynchronize()
      endif
    end function

    function gpu_malloc_host(array, elements) result(success)
      use, intrinsic :: iso_c_binding
      use cuda_functions


      implicit none
      type(c_ptr)                          :: array
      integer(kind=c_intptr_t), intent(in) :: elements
      logical                              :: success

      success = .false.

      if (use_gpu_vendor == nvidia_gpu) then
        success = cuda_malloc_host(array, elements)
      endif



    end function

    function gpu_malloc_intptr(array, elements) result(success)
      use, intrinsic :: iso_c_binding
      use cuda_functions
      implicit none
      integer(kind=C_intptr_T)             :: array
      integer(kind=c_intptr_t), intent(in) :: elements
      logical                              :: success

      success = .false.

      if (use_gpu_vendor == nvidia_gpu) then
        success = cuda_malloc_intptr(array, elements)
      endif




    end function

    function gpu_malloc_cptr(array, elements) result(success)
      use, intrinsic :: iso_c_binding
      use cuda_functions
      implicit none
      type(c_ptr)                          :: array
      integer(kind=c_intptr_t), intent(in) :: elements
      logical                              :: success

      success = .false.

      if (use_gpu_vendor == nvidia_gpu) then
        success = cuda_malloc_cptr(array, elements)
      endif




    end function

    function gpu_host_register(array, elements, flag) result(success)
      use, intrinsic :: iso_c_binding
      use cuda_functions
      implicit none
      integer(kind=C_intptr_t)              :: array
      integer(kind=c_intptr_t), intent(in)  :: elements
      integer(kind=C_INT), intent(in)       :: flag
      logical :: success

      success = .false.

      if (use_gpu_vendor == nvidia_gpu) then
        success = cuda_host_register(array, elements, flag)
      endif




    end function
    
    function gpu_memcpy_intptr(dst, src, size, dir) result(success)
      use, intrinsic :: iso_c_binding
      use cuda_functions

      implicit none
      integer(kind=C_intptr_t)              :: dst
      integer(kind=C_intptr_t)              :: src
      integer(kind=c_intptr_t), intent(in)  :: size
      integer(kind=C_INT), intent(in)       :: dir
      logical                               :: success

      success = .false.

      if (use_gpu_vendor == nvidia_gpu) then
        success = cuda_memcpy_intptr(dst, src, size, dir)
      endif



      return
    
    end function
    
    function gpu_memcpy_cptr(dst, src, size, dir) result(success)
      use, intrinsic :: iso_c_binding
      use cuda_functions
      implicit none
      type(c_ptr)                           :: dst
      type(c_ptr)                           :: src
      integer(kind=c_intptr_t), intent(in)  :: size
      integer(kind=C_INT), intent(in)       :: dir
      logical                               :: success

      success = .false.

      if (use_gpu_vendor == nvidia_gpu) then
        success = cuda_memcpy_cptr(dst, src, size, dir)
      endif



      return
    
    end function
    
    function gpu_memcpy_mixed_to_device(dst, src, size, dir) result(success)
      use, intrinsic :: iso_c_binding
      use cuda_functions

      implicit none
      type(c_ptr)                           :: dst
      integer(kind=C_intptr_t)              :: src
      integer(kind=c_intptr_t), intent(in)  :: size
      integer(kind=C_INT), intent(in)       :: dir
      logical :: success

      success = .false.

      if (use_gpu_vendor == nvidia_gpu) then
        success = cuda_memcpy_mixed_to_device(dst, src, size, dir)
      endif



    
    end function
    
    function gpu_memcpy_mixed_to_host(dst, src, size, dir) result(success)
      use, intrinsic :: iso_c_binding
      use cuda_functions

      implicit none
      type(c_ptr)                           :: src
      integer(kind=C_intptr_t)              :: dst
      integer(kind=c_intptr_t), intent(in)  :: size
      integer(kind=C_INT), intent(in)       :: dir
      logical :: success

      success = .false.

      if (use_gpu_vendor == nvidia_gpu) then
        success = cuda_memcpy_mixed_to_host(dst, src, size, dir)
      endif



    
    end function

    function gpu_memcpy_async_intptr(dst, src, size, dir, stream) result(success)
      use, intrinsic :: iso_c_binding
      use cuda_functions

      implicit none
      integer(kind=C_intptr_t)              :: dst
      integer(kind=C_intptr_t)              :: src
      integer(kind=c_intptr_t), intent(in)  :: size
      integer(kind=C_INT), intent(in)       :: dir
      integer(kind=c_intptr_t), intent(in)  :: stream
      logical                               :: success

      success = .false.

      if (use_gpu_vendor == nvidia_gpu) then
        success = cuda_memcpy_async_intptr(dst, src, size, dir, stream)
      endif
  


      return
    
    end function
    
    function gpu_memcpy_async_cptr(dst, src, size, dir, stream) result(success)
      use, intrinsic :: iso_c_binding
      use cuda_functions
      implicit none
      type(c_ptr)                           :: dst
      type(c_ptr)                           :: src
      integer(kind=c_intptr_t), intent(in)  :: size
      integer(kind=C_INT), intent(in)       :: dir
      integer(kind=c_intptr_t), intent(in)  :: stream
      logical                               :: success

      success = .false.

      if (use_gpu_vendor == nvidia_gpu) then
        success = cuda_memcpy_async_cptr(dst, src, size, dir, stream)
      endif



      return
    
    end function
    
    function gpu_memcpy_async_mixed_to_device(dst, src, size, dir, stream) result(success)
      use, intrinsic :: iso_c_binding
      use cuda_functions

      implicit none
      type(c_ptr)                           :: dst
      integer(kind=C_intptr_t)              :: src
      integer(kind=c_intptr_t), intent(in)  :: size
      integer(kind=c_intptr_t), intent(in)  :: stream
      integer(kind=C_INT), intent(in)       :: dir
      logical :: success

      success = .false.

      if (use_gpu_vendor == nvidia_gpu) then
        success = cuda_memcpy_async_mixed_to_device(dst, src, size, dir, stream)
      endif



    
    end function
    
    function gpu_memcpy_async_mixed_to_host(dst, src, size, dir, stream) result(success)
      use, intrinsic :: iso_c_binding
      use cuda_functions

      implicit none
      type(c_ptr)                           :: src
      integer(kind=C_intptr_t)              :: dst
      integer(kind=c_intptr_t), intent(in)  :: size
      integer(kind=c_intptr_t), intent(in)  :: stream
      integer(kind=C_INT), intent(in)       :: dir
      logical :: success

      success = .false.

      if (use_gpu_vendor == nvidia_gpu) then
        success = cuda_memcpy_async_mixed_to_host(dst, src, size, dir, stream)
      endif



    
    end function

    function gpu_memset(a, val, size) result(success)
      use, intrinsic :: iso_c_binding
      use cuda_functions

      implicit none
      integer(kind=c_intptr_t)             :: a
      integer(kind=ik)                     :: val
      integer(kind=c_intptr_t), intent(in) :: size
      integer(kind=C_INT)                  :: istat

      logical :: success

      success = .false.

      if (use_gpu_vendor == nvidia_gpu) then
        success = cuda_memset(a, val, size)
      endif




    end function

    function gpu_memset_async(a, val, size, stream) result(success)
      use, intrinsic :: iso_c_binding
      use cuda_functions

      implicit none
      integer(kind=c_intptr_t)             :: a
      integer(kind=ik)                     :: val
      integer(kind=c_intptr_t), intent(in) :: size
      integer(kind=C_INT)                  :: istat
      integer(kind=c_intptr_t), intent(in) :: stream

      logical :: success

      success = .false.

      if (use_gpu_vendor == nvidia_gpu) then
        success = cuda_memset_async(a, val, size, stream)
      endif




    end function

    function gpu_free_intptr(a) result(success)
      use, intrinsic :: iso_c_binding
      use cuda_functions

      implicit none
      integer(kind=c_intptr_t)                :: a

      logical :: success

      success = .false.

      if (use_gpu_vendor == nvidia_gpu) then
        success = cuda_free_intptr(a)
      endif




    end function

    function gpu_free_cptr(a) result(success)
      use, intrinsic :: iso_c_binding
      use cuda_functions

      implicit none
      type(c_ptr)              :: a

      logical :: success

      success = .false.

      if (use_gpu_vendor == nvidia_gpu) then
        success = cuda_free_cptr(a)
      endif




    end function

    function gpu_free_host(a) result(success)
      use, intrinsic :: iso_c_binding
      use cuda_functions

      implicit none
      type(c_ptr), value          :: a

      logical :: success

      success = .false.

      if (use_gpu_vendor == nvidia_gpu) then
        success = cuda_free_host(a)
      endif



    end function

    function gpu_host_unregister(a) result(success)
      use, intrinsic :: iso_c_binding
      use cuda_functions

      implicit none
      integer(kind=c_intptr_t)                :: a

      logical :: success

      success = .false.

      if (use_gpu_vendor == nvidia_gpu) then
        success = cuda_host_unregister(a)
      endif




    end function

    function gpu_memcpy2d_intptr(dst, dpitch, src, spitch, width, height , dir) result(success)

      use, intrinsic :: iso_c_binding
      use cuda_functions

      implicit none

      integer(kind=C_intptr_T)           :: dst
      integer(kind=c_intptr_t), intent(in) :: dpitch
      integer(kind=C_intptr_T)           :: src
      integer(kind=c_intptr_t), intent(in) :: spitch
      integer(kind=c_intptr_t), intent(in) :: width
      integer(kind=c_intptr_t), intent(in) :: height
      integer(kind=C_INT), intent(in)    :: dir
      logical                            :: success

      success = .false.

      if (use_gpu_vendor == nvidia_gpu) then
        success = cuda_memcpy2d_intptr(dst, dpitch, src, spitch, width, height , dir)
      endif



    end function

    function gpu_memcpy2d_cptr(dst, dpitch, src, spitch, width, height , dir) result(success)

      use, intrinsic :: iso_c_binding
      use cuda_functions

      implicit none

      type(c_ptr)         :: dst
      integer(kind=c_intptr_t), intent(in) :: dpitch
      type(c_ptr)           :: src
      integer(kind=c_intptr_t), intent(in) :: spitch
      integer(kind=c_intptr_t), intent(in) :: width
      integer(kind=c_intptr_t), intent(in) :: height
      integer(kind=C_INT), intent(in)    :: dir
      logical                            :: success

      success = .false.

      if (use_gpu_vendor == nvidia_gpu) then
        success = cuda_memcpy2d_cptr(dst, dpitch, src, spitch, width, height , dir)
      endif



    end function

    function gpu_memcpy2d_async_intptr(dst, dpitch, src, spitch, width, height, dir, stream) result(success)

      use, intrinsic :: iso_c_binding
      use cuda_functions

      implicit none

      integer(kind=C_intptr_T)           :: dst
      integer(kind=c_intptr_t), intent(in) :: dpitch
      integer(kind=C_intptr_T)           :: src
      integer(kind=c_intptr_t), intent(in) :: spitch
      integer(kind=c_intptr_t), intent(in) :: width
      integer(kind=c_intptr_t), intent(in) :: height
      integer(kind=C_INT), intent(in)    :: dir
      integer(kind=c_intptr_t), intent(in) :: stream
      logical                            :: success

      success = .false.

      if (use_gpu_vendor == nvidia_gpu) then
        success = cuda_memcpy2d_async_intptr(dst, dpitch, src, spitch, width, height, dir, stream)
      endif



    end function

    function gpu_memcpy2d_async_cptr(dst, dpitch, src, spitch, width, height, dir, stream) result(success)

      use, intrinsic :: iso_c_binding
      use cuda_functions

      implicit none

      type(c_ptr)         :: dst
      integer(kind=c_intptr_t), intent(in) :: dpitch
      type(c_ptr)           :: src
      integer(kind=c_intptr_t), intent(in) :: spitch
      integer(kind=c_intptr_t), intent(in) :: width
      integer(kind=c_intptr_t), intent(in) :: height
      integer(kind=C_INT), intent(in)    :: dir
      integer(kind=c_intptr_t), intent(in) :: stream
      logical                            :: success

      success = .false.

      if (use_gpu_vendor == nvidia_gpu) then
        success = cuda_memcpy2d_async_cptr(dst, dpitch, src, spitch, width, height, dir, stream)
      endif



    end function


end module 
