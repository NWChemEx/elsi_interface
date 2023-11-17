












module elpa_gpu_util
  use precision
  use iso_c_binding

!cannot use "../src/GPU/../general/error_checking.inc" because filename with path can be too long for gfortran (max line length)

  interface gpu_memcpy_async_and_stream_synchronize
    module procedure gpu_memcpy_async_and_stream_synchronize_double_scalar
    module procedure gpu_memcpy_async_and_stream_synchronize_single_scalar
    module procedure gpu_memcpy_async_and_stream_synchronize_complex_scalar
    module procedure gpu_memcpy_async_and_stream_synchronize_complex_single_scalar
    module procedure gpu_memcpy_async_and_stream_synchronize_double_1d
    module procedure gpu_memcpy_async_and_stream_synchronize_single_1d
    module procedure gpu_memcpy_async_and_stream_synchronize_complex_1d
    module procedure gpu_memcpy_async_and_stream_synchronize_complex_single_1d
    module procedure gpu_memcpy_async_and_stream_synchronize_double_2d
    module procedure gpu_memcpy_async_and_stream_synchronize_single_2d
    module procedure gpu_memcpy_async_and_stream_synchronize_complex_2d
    module procedure gpu_memcpy_async_and_stream_synchronize_complex_single_2d
    module procedure gpu_memcpy_async_and_stream_synchronize_double_3d
    module procedure gpu_memcpy_async_and_stream_synchronize_single_3d
    module procedure gpu_memcpy_async_and_stream_synchronize_complex_3d
    module procedure gpu_memcpy_async_and_stream_synchronize_complex_single_3d
  end interface

  contains


    subroutine gpu_memcpy_async_and_stream_synchronize_double_scalar &
                (errormessage, devPtr, devPtrOffset, &
                 hostarray, &
                num, direction, my_stream, doSyncBefore, doSyncAfter, doSyncDefault)

      use iso_c_binding
      use elpa_gpu
      use elpa_utilities

      implicit none
      integer(kind=c_intptr_t), intent(in)          :: my_stream
      logical                                       :: successGPU
      character(len=*)                              :: errormessage
      integer(kind=c_intptr_t)                      :: devPtr
      integer(kind=c_intptr_t)                      :: devPtrOffset

      logical                                       :: doSyncBefore
      logical                                       :: doSyncAfter
      logical                                       :: doSyncDefault

      real(kind=c_double)                           :: &
                                             hostArray
      integer(kind=c_intptr_t)                      :: num
      integer(kind=c_int), intent(in)               :: direction

      if (doSyncBefore) then
        successGPU = gpu_stream_synchronize(my_stream)
        call check_memcpy_GPU_f(trim(errormessage), 50,  successGPU)
      endif

      if (direction .eq. gpuMemcpyHostToDevice) then
        successGPU = gpu_memcpy_async(devPtr+devPtrOffset, &
                    int(loc(hostarray),kind=c_intptr_t), &
                                      num, direction, my_stream)
      else if (direction .eq. gpuMemcpyDeviceToHost) then
        successGPU = gpu_memcpy_async(&
                    int(loc(hostarray),kind=c_intptr_t), &
                                      devPtr+devPtrOffset, num, direction, my_stream)
      else
        print *,"gpu_memcpy_async_and_stream_synchronize: unknown error"
        stop 1
      endif

      if (doSyncAfter) then
        successGPU = gpu_stream_synchronize(my_stream)
        call check_memcpy_GPU_f(trim(errormessage), 68,  successGPU)
      endif
      if (doSyncDefault) then
        ! synchronize streamsPerThread; maybe not neccessary
        successGPU = gpu_stream_synchronize()
        call check_memcpy_GPU_f(trim(errormessage), 73,  successGPU)
      endif
    end


    subroutine gpu_memcpy_async_and_stream_synchronize_single_scalar &
                (errormessage, devPtr, devPtrOffset, &
                 hostarray, &
                num, direction, my_stream, doSyncBefore, doSyncAfter, doSyncDefault)

      use iso_c_binding
      use elpa_gpu
      use elpa_utilities

      implicit none
      integer(kind=c_intptr_t), intent(in)          :: my_stream
      logical                                       :: successGPU
      character(len=*)                              :: errormessage
      integer(kind=c_intptr_t)                      :: devPtr
      integer(kind=c_intptr_t)                      :: devPtrOffset

      logical                                       :: doSyncBefore
      logical                                       :: doSyncAfter
      logical                                       :: doSyncDefault

      real(kind=c_float)                            :: &
                                             hostArray
      integer(kind=c_intptr_t)                      :: num
      integer(kind=c_int), intent(in)               :: direction

      if (doSyncBefore) then
        successGPU = gpu_stream_synchronize(my_stream)
        call check_memcpy_GPU_f(trim(errormessage), 105,  successGPU)
      endif

      if (direction .eq. gpuMemcpyHostToDevice) then
        successGPU = gpu_memcpy_async(devPtr+devPtrOffset, &
                    int(loc(hostarray),kind=c_intptr_t), &
                                      num, direction, my_stream)
      else if (direction .eq. gpuMemcpyDeviceToHost) then
        successGPU = gpu_memcpy_async(&
                    int(loc(hostarray),kind=c_intptr_t), &
                                      devPtr+devPtrOffset, num, direction, my_stream)
      else
        print *,"gpu_memcpy_async_and_stream_synchronize: unknown error"
        stop 1
      endif

      if (doSyncAfter) then
        successGPU = gpu_stream_synchronize(my_stream)
        call check_memcpy_GPU_f(trim(errormessage), 123,  successGPU)
      endif
      if (doSyncDefault) then
        ! synchronize streamsPerThread; maybe not neccessary
        successGPU = gpu_stream_synchronize()
        call check_memcpy_GPU_f(trim(errormessage), 128,  successGPU)
      endif
    end


    subroutine gpu_memcpy_async_and_stream_synchronize_complex_scalar &
                (errormessage, devPtr, devPtrOffset, &
                 hostarray, &
                num, direction, my_stream, doSyncBefore, doSyncAfter, doSyncDefault)

      use iso_c_binding
      use elpa_gpu
      use elpa_utilities

      implicit none
      integer(kind=c_intptr_t), intent(in)          :: my_stream
      logical                                       :: successGPU
      character(len=*)                              :: errormessage
      integer(kind=c_intptr_t)                      :: devPtr
      integer(kind=c_intptr_t)                      :: devPtrOffset

      logical                                       :: doSyncBefore
      logical                                       :: doSyncAfter
      logical                                       :: doSyncDefault

      complex(kind=c_double_complex)                :: &
                                             hostArray
      integer(kind=c_intptr_t)                      :: num
      integer(kind=c_int), intent(in)               :: direction

      if (doSyncBefore) then
        successGPU = gpu_stream_synchronize(my_stream)
        call check_memcpy_GPU_f(trim(errormessage), 160,  successGPU)
      endif

      if (direction .eq. gpuMemcpyHostToDevice) then
        successGPU = gpu_memcpy_async(devPtr+devPtrOffset, &
                    int(loc(hostarray),kind=c_intptr_t), &
                                      num, direction, my_stream)
      else if (direction .eq. gpuMemcpyDeviceToHost) then
        successGPU = gpu_memcpy_async(&
                    int(loc(hostarray),kind=c_intptr_t), &
                                      devPtr+devPtrOffset, num, direction, my_stream)
      else
        print *,"gpu_memcpy_async_and_stream_synchronize: unknown error"
        stop 1
      endif

      if (doSyncAfter) then
        successGPU = gpu_stream_synchronize(my_stream)
        call check_memcpy_GPU_f(trim(errormessage), 178,  successGPU)
      endif
      if (doSyncDefault) then
        ! synchronize streamsPerThread; maybe not neccessary
        successGPU = gpu_stream_synchronize()
        call check_memcpy_GPU_f(trim(errormessage), 183,  successGPU)
      endif
    end


    subroutine gpu_memcpy_async_and_stream_synchronize_complex_single_scalar &
                (errormessage, devPtr, devPtrOffset, &
                 hostarray, &
                num, direction, my_stream, doSyncBefore, doSyncAfter, doSyncDefault)

      use iso_c_binding
      use elpa_gpu
      use elpa_utilities

      implicit none
      integer(kind=c_intptr_t), intent(in)          :: my_stream
      logical                                       :: successGPU
      character(len=*)                              :: errormessage
      integer(kind=c_intptr_t)                      :: devPtr
      integer(kind=c_intptr_t)                      :: devPtrOffset

      logical                                       :: doSyncBefore
      logical                                       :: doSyncAfter
      logical                                       :: doSyncDefault

      complex(kind=c_float_complex)                 :: &
                                             hostArray
      integer(kind=c_intptr_t)                      :: num
      integer(kind=c_int), intent(in)               :: direction

      if (doSyncBefore) then
        successGPU = gpu_stream_synchronize(my_stream)
        call check_memcpy_GPU_f(trim(errormessage), 215,  successGPU)
      endif

      if (direction .eq. gpuMemcpyHostToDevice) then
        successGPU = gpu_memcpy_async(devPtr+devPtrOffset, &
                    int(loc(hostarray),kind=c_intptr_t), &
                                      num, direction, my_stream)
      else if (direction .eq. gpuMemcpyDeviceToHost) then
        successGPU = gpu_memcpy_async(&
                    int(loc(hostarray),kind=c_intptr_t), &
                                      devPtr+devPtrOffset, num, direction, my_stream)
      else
        print *,"gpu_memcpy_async_and_stream_synchronize: unknown error"
        stop 1
      endif

      if (doSyncAfter) then
        successGPU = gpu_stream_synchronize(my_stream)
        call check_memcpy_GPU_f(trim(errormessage), 233,  successGPU)
      endif
      if (doSyncDefault) then
        ! synchronize streamsPerThread; maybe not neccessary
        successGPU = gpu_stream_synchronize()
        call check_memcpy_GPU_f(trim(errormessage), 238,  successGPU)
      endif
    end


    subroutine gpu_memcpy_async_and_stream_synchronize_double_1d &
                (errormessage, devPtr, devPtrOffset, &
                 hostarray, &
                 off1, &
                num, direction, my_stream, doSyncBefore, doSyncAfter, doSyncDefault)

      use iso_c_binding
      use elpa_gpu
      use elpa_utilities

      implicit none
      integer(kind=c_intptr_t), intent(in)          :: my_stream
      logical                                       :: successGPU
      character(len=*)                              :: errormessage
      integer(kind=c_intptr_t)                      :: devPtr
      integer(kind=c_intptr_t)                      :: devPtrOffset

      integer(kind=ik), intent(in)                  :: off1
      logical                                       :: doSyncBefore
      logical                                       :: doSyncAfter
      logical                                       :: doSyncDefault

      real(kind=c_double)                           :: &
                                         hostArray(:)
      integer(kind=c_intptr_t)                      :: num
      integer(kind=c_int), intent(in)               :: direction

      if (doSyncBefore) then
        successGPU = gpu_stream_synchronize(my_stream)
        call check_memcpy_GPU_f(trim(errormessage), 272,  successGPU)
      endif

      if (direction .eq. gpuMemcpyHostToDevice) then
        successGPU = gpu_memcpy_async(devPtr+devPtrOffset, &
                    int(loc(hostarray(off1)),kind=c_intptr_t), &
                                      num, direction, my_stream)
      else if (direction .eq. gpuMemcpyDeviceToHost) then
        successGPU = gpu_memcpy_async(&
                    int(loc(hostarray(off1)),kind=c_intptr_t), &
                                      devPtr+devPtrOffset, num, direction, my_stream)
      else
        print *,"gpu_memcpy_async_and_stream_synchronize: unknown error"
        stop 1
      endif

      if (doSyncAfter) then
        successGPU = gpu_stream_synchronize(my_stream)
        call check_memcpy_GPU_f(trim(errormessage), 290,  successGPU)
      endif
      if (doSyncDefault) then
        ! synchronize streamsPerThread; maybe not neccessary
        successGPU = gpu_stream_synchronize()
        call check_memcpy_GPU_f(trim(errormessage), 295,  successGPU)
      endif
    end


    subroutine gpu_memcpy_async_and_stream_synchronize_single_1d &
                (errormessage, devPtr, devPtrOffset, &
                 hostarray, &
                 off1, &
                num, direction, my_stream, doSyncBefore, doSyncAfter, doSyncDefault)

      use iso_c_binding
      use elpa_gpu
      use elpa_utilities

      implicit none
      integer(kind=c_intptr_t), intent(in)          :: my_stream
      logical                                       :: successGPU
      character(len=*)                              :: errormessage
      integer(kind=c_intptr_t)                      :: devPtr
      integer(kind=c_intptr_t)                      :: devPtrOffset

      integer(kind=ik), intent(in)                  :: off1
      logical                                       :: doSyncBefore
      logical                                       :: doSyncAfter
      logical                                       :: doSyncDefault

      real(kind=c_float)                            :: &
                                         hostArray(:)
      integer(kind=c_intptr_t)                      :: num
      integer(kind=c_int), intent(in)               :: direction

      if (doSyncBefore) then
        successGPU = gpu_stream_synchronize(my_stream)
        call check_memcpy_GPU_f(trim(errormessage), 329,  successGPU)
      endif

      if (direction .eq. gpuMemcpyHostToDevice) then
        successGPU = gpu_memcpy_async(devPtr+devPtrOffset, &
                    int(loc(hostarray(off1)),kind=c_intptr_t), &
                                      num, direction, my_stream)
      else if (direction .eq. gpuMemcpyDeviceToHost) then
        successGPU = gpu_memcpy_async(&
                    int(loc(hostarray(off1)),kind=c_intptr_t), &
                                      devPtr+devPtrOffset, num, direction, my_stream)
      else
        print *,"gpu_memcpy_async_and_stream_synchronize: unknown error"
        stop 1
      endif

      if (doSyncAfter) then
        successGPU = gpu_stream_synchronize(my_stream)
        call check_memcpy_GPU_f(trim(errormessage), 347,  successGPU)
      endif
      if (doSyncDefault) then
        ! synchronize streamsPerThread; maybe not neccessary
        successGPU = gpu_stream_synchronize()
        call check_memcpy_GPU_f(trim(errormessage), 352,  successGPU)
      endif
    end


    subroutine gpu_memcpy_async_and_stream_synchronize_complex_1d &
                (errormessage, devPtr, devPtrOffset, &
                 hostarray, &
                 off1, &
                num, direction, my_stream, doSyncBefore, doSyncAfter, doSyncDefault)

      use iso_c_binding
      use elpa_gpu
      use elpa_utilities

      implicit none
      integer(kind=c_intptr_t), intent(in)          :: my_stream
      logical                                       :: successGPU
      character(len=*)                              :: errormessage
      integer(kind=c_intptr_t)                      :: devPtr
      integer(kind=c_intptr_t)                      :: devPtrOffset

      integer(kind=ik), intent(in)                  :: off1
      logical                                       :: doSyncBefore
      logical                                       :: doSyncAfter
      logical                                       :: doSyncDefault

      complex(kind=c_double_complex)                :: &
                                         hostArray(:)
      integer(kind=c_intptr_t)                      :: num
      integer(kind=c_int), intent(in)               :: direction

      if (doSyncBefore) then
        successGPU = gpu_stream_synchronize(my_stream)
        call check_memcpy_GPU_f(trim(errormessage), 386,  successGPU)
      endif

      if (direction .eq. gpuMemcpyHostToDevice) then
        successGPU = gpu_memcpy_async(devPtr+devPtrOffset, &
                    int(loc(hostarray(off1)),kind=c_intptr_t), &
                                      num, direction, my_stream)
      else if (direction .eq. gpuMemcpyDeviceToHost) then
        successGPU = gpu_memcpy_async(&
                    int(loc(hostarray(off1)),kind=c_intptr_t), &
                                      devPtr+devPtrOffset, num, direction, my_stream)
      else
        print *,"gpu_memcpy_async_and_stream_synchronize: unknown error"
        stop 1
      endif

      if (doSyncAfter) then
        successGPU = gpu_stream_synchronize(my_stream)
        call check_memcpy_GPU_f(trim(errormessage), 404,  successGPU)
      endif
      if (doSyncDefault) then
        ! synchronize streamsPerThread; maybe not neccessary
        successGPU = gpu_stream_synchronize()
        call check_memcpy_GPU_f(trim(errormessage), 409,  successGPU)
      endif
    end


    subroutine gpu_memcpy_async_and_stream_synchronize_complex_single_1d &
                (errormessage, devPtr, devPtrOffset, &
                 hostarray, &
                 off1, &
                num, direction, my_stream, doSyncBefore, doSyncAfter, doSyncDefault)

      use iso_c_binding
      use elpa_gpu
      use elpa_utilities

      implicit none
      integer(kind=c_intptr_t), intent(in)          :: my_stream
      logical                                       :: successGPU
      character(len=*)                              :: errormessage
      integer(kind=c_intptr_t)                      :: devPtr
      integer(kind=c_intptr_t)                      :: devPtrOffset

      integer(kind=ik), intent(in)                  :: off1
      logical                                       :: doSyncBefore
      logical                                       :: doSyncAfter
      logical                                       :: doSyncDefault

      complex(kind=c_float_complex)                 :: &
                                         hostArray(:)
      integer(kind=c_intptr_t)                      :: num
      integer(kind=c_int), intent(in)               :: direction

      if (doSyncBefore) then
        successGPU = gpu_stream_synchronize(my_stream)
        call check_memcpy_GPU_f(trim(errormessage), 443,  successGPU)
      endif

      if (direction .eq. gpuMemcpyHostToDevice) then
        successGPU = gpu_memcpy_async(devPtr+devPtrOffset, &
                    int(loc(hostarray(off1)),kind=c_intptr_t), &
                                      num, direction, my_stream)
      else if (direction .eq. gpuMemcpyDeviceToHost) then
        successGPU = gpu_memcpy_async(&
                    int(loc(hostarray(off1)),kind=c_intptr_t), &
                                      devPtr+devPtrOffset, num, direction, my_stream)
      else
        print *,"gpu_memcpy_async_and_stream_synchronize: unknown error"
        stop 1
      endif

      if (doSyncAfter) then
        successGPU = gpu_stream_synchronize(my_stream)
        call check_memcpy_GPU_f(trim(errormessage), 461,  successGPU)
      endif
      if (doSyncDefault) then
        ! synchronize streamsPerThread; maybe not neccessary
        successGPU = gpu_stream_synchronize()
        call check_memcpy_GPU_f(trim(errormessage), 466,  successGPU)
      endif
    end


    subroutine gpu_memcpy_async_and_stream_synchronize_double_2d &
                (errormessage, devPtr, devPtrOffset, &
                 hostarray, &
                 off1, off2, &
                num, direction, my_stream, doSyncBefore, doSyncAfter, doSyncDefault)

      use iso_c_binding
      use elpa_gpu
      use elpa_utilities

      implicit none
      integer(kind=c_intptr_t), intent(in)          :: my_stream
      logical                                       :: successGPU
      character(len=*)                              :: errormessage
      integer(kind=c_intptr_t)                      :: devPtr
      integer(kind=c_intptr_t)                      :: devPtrOffset

      integer(kind=ik), intent(in)                  :: off1
      integer(kind=ik), intent(in)                  :: off2
      logical                                       :: doSyncBefore
      logical                                       :: doSyncAfter
      logical                                       :: doSyncDefault

      real(kind=c_double)                           :: &
                                         hostArray(:,:)
      integer(kind=c_intptr_t)                      :: num
      integer(kind=c_int), intent(in)               :: direction

      if (doSyncBefore) then
        successGPU = gpu_stream_synchronize(my_stream)
        call check_memcpy_GPU_f(trim(errormessage), 501,  successGPU)
      endif

      if (direction .eq. gpuMemcpyHostToDevice) then
        successGPU = gpu_memcpy_async(devPtr+devPtrOffset, &
                    int(loc(hostarray(off1,off2)),kind=c_intptr_t), &
                                      num, direction, my_stream)
      else if (direction .eq. gpuMemcpyDeviceToHost) then
        successGPU = gpu_memcpy_async(&
                    int(loc(hostarray(off1,off2)),kind=c_intptr_t), &
                                      devPtr+devPtrOffset, num, direction, my_stream)
      else
        print *,"gpu_memcpy_async_and_stream_synchronize: unknown error"
        stop 1
      endif

      if (doSyncAfter) then
        successGPU = gpu_stream_synchronize(my_stream)
        call check_memcpy_GPU_f(trim(errormessage), 519,  successGPU)
      endif
      if (doSyncDefault) then
        ! synchronize streamsPerThread; maybe not neccessary
        successGPU = gpu_stream_synchronize()
        call check_memcpy_GPU_f(trim(errormessage), 524,  successGPU)
      endif
    end


    subroutine gpu_memcpy_async_and_stream_synchronize_single_2d &
                (errormessage, devPtr, devPtrOffset, &
                 hostarray, &
                 off1, off2, &
                num, direction, my_stream, doSyncBefore, doSyncAfter, doSyncDefault)

      use iso_c_binding
      use elpa_gpu
      use elpa_utilities

      implicit none
      integer(kind=c_intptr_t), intent(in)          :: my_stream
      logical                                       :: successGPU
      character(len=*)                              :: errormessage
      integer(kind=c_intptr_t)                      :: devPtr
      integer(kind=c_intptr_t)                      :: devPtrOffset

      integer(kind=ik), intent(in)                  :: off1
      integer(kind=ik), intent(in)                  :: off2
      logical                                       :: doSyncBefore
      logical                                       :: doSyncAfter
      logical                                       :: doSyncDefault

      real(kind=c_float)                            :: &
                                         hostArray(:,:)
      integer(kind=c_intptr_t)                      :: num
      integer(kind=c_int), intent(in)               :: direction

      if (doSyncBefore) then
        successGPU = gpu_stream_synchronize(my_stream)
        call check_memcpy_GPU_f(trim(errormessage), 559,  successGPU)
      endif

      if (direction .eq. gpuMemcpyHostToDevice) then
        successGPU = gpu_memcpy_async(devPtr+devPtrOffset, &
                    int(loc(hostarray(off1,off2)),kind=c_intptr_t), &
                                      num, direction, my_stream)
      else if (direction .eq. gpuMemcpyDeviceToHost) then
        successGPU = gpu_memcpy_async(&
                    int(loc(hostarray(off1,off2)),kind=c_intptr_t), &
                                      devPtr+devPtrOffset, num, direction, my_stream)
      else
        print *,"gpu_memcpy_async_and_stream_synchronize: unknown error"
        stop 1
      endif

      if (doSyncAfter) then
        successGPU = gpu_stream_synchronize(my_stream)
        call check_memcpy_GPU_f(trim(errormessage), 577,  successGPU)
      endif
      if (doSyncDefault) then
        ! synchronize streamsPerThread; maybe not neccessary
        successGPU = gpu_stream_synchronize()
        call check_memcpy_GPU_f(trim(errormessage), 582,  successGPU)
      endif
    end


    subroutine gpu_memcpy_async_and_stream_synchronize_complex_2d &
                (errormessage, devPtr, devPtrOffset, &
                 hostarray, &
                 off1, off2, &
                num, direction, my_stream, doSyncBefore, doSyncAfter, doSyncDefault)

      use iso_c_binding
      use elpa_gpu
      use elpa_utilities

      implicit none
      integer(kind=c_intptr_t), intent(in)          :: my_stream
      logical                                       :: successGPU
      character(len=*)                              :: errormessage
      integer(kind=c_intptr_t)                      :: devPtr
      integer(kind=c_intptr_t)                      :: devPtrOffset

      integer(kind=ik), intent(in)                  :: off1
      integer(kind=ik), intent(in)                  :: off2
      logical                                       :: doSyncBefore
      logical                                       :: doSyncAfter
      logical                                       :: doSyncDefault

      complex(kind=c_double_complex)                :: &
                                         hostArray(:,:)
      integer(kind=c_intptr_t)                      :: num
      integer(kind=c_int), intent(in)               :: direction

      if (doSyncBefore) then
        successGPU = gpu_stream_synchronize(my_stream)
        call check_memcpy_GPU_f(trim(errormessage), 617,  successGPU)
      endif

      if (direction .eq. gpuMemcpyHostToDevice) then
        successGPU = gpu_memcpy_async(devPtr+devPtrOffset, &
                    int(loc(hostarray(off1,off2)),kind=c_intptr_t), &
                                      num, direction, my_stream)
      else if (direction .eq. gpuMemcpyDeviceToHost) then
        successGPU = gpu_memcpy_async(&
                    int(loc(hostarray(off1,off2)),kind=c_intptr_t), &
                                      devPtr+devPtrOffset, num, direction, my_stream)
      else
        print *,"gpu_memcpy_async_and_stream_synchronize: unknown error"
        stop 1
      endif

      if (doSyncAfter) then
        successGPU = gpu_stream_synchronize(my_stream)
        call check_memcpy_GPU_f(trim(errormessage), 635,  successGPU)
      endif
      if (doSyncDefault) then
        ! synchronize streamsPerThread; maybe not neccessary
        successGPU = gpu_stream_synchronize()
        call check_memcpy_GPU_f(trim(errormessage), 640,  successGPU)
      endif
    end


    subroutine gpu_memcpy_async_and_stream_synchronize_complex_single_2d &
                (errormessage, devPtr, devPtrOffset, &
                 hostarray, &
                 off1, off2, &
                num, direction, my_stream, doSyncBefore, doSyncAfter, doSyncDefault)

      use iso_c_binding
      use elpa_gpu
      use elpa_utilities

      implicit none
      integer(kind=c_intptr_t), intent(in)          :: my_stream
      logical                                       :: successGPU
      character(len=*)                              :: errormessage
      integer(kind=c_intptr_t)                      :: devPtr
      integer(kind=c_intptr_t)                      :: devPtrOffset

      integer(kind=ik), intent(in)                  :: off1
      integer(kind=ik), intent(in)                  :: off2
      logical                                       :: doSyncBefore
      logical                                       :: doSyncAfter
      logical                                       :: doSyncDefault

      complex(kind=c_float_complex)                 :: &
                                         hostArray(:,:)
      integer(kind=c_intptr_t)                      :: num
      integer(kind=c_int), intent(in)               :: direction

      if (doSyncBefore) then
        successGPU = gpu_stream_synchronize(my_stream)
        call check_memcpy_GPU_f(trim(errormessage), 675,  successGPU)
      endif

      if (direction .eq. gpuMemcpyHostToDevice) then
        successGPU = gpu_memcpy_async(devPtr+devPtrOffset, &
                    int(loc(hostarray(off1,off2)),kind=c_intptr_t), &
                                      num, direction, my_stream)
      else if (direction .eq. gpuMemcpyDeviceToHost) then
        successGPU = gpu_memcpy_async(&
                    int(loc(hostarray(off1,off2)),kind=c_intptr_t), &
                                      devPtr+devPtrOffset, num, direction, my_stream)
      else
        print *,"gpu_memcpy_async_and_stream_synchronize: unknown error"
        stop 1
      endif

      if (doSyncAfter) then
        successGPU = gpu_stream_synchronize(my_stream)
        call check_memcpy_GPU_f(trim(errormessage), 693,  successGPU)
      endif
      if (doSyncDefault) then
        ! synchronize streamsPerThread; maybe not neccessary
        successGPU = gpu_stream_synchronize()
        call check_memcpy_GPU_f(trim(errormessage), 698,  successGPU)
      endif
    end


    subroutine gpu_memcpy_async_and_stream_synchronize_double_3d &
                (errormessage, devPtr, devPtrOffset, &
                 hostarray, &
                 off1, off2, off3, &
                num, direction, my_stream, doSyncBefore, doSyncAfter, doSyncDefault)

      use iso_c_binding
      use elpa_gpu
      use elpa_utilities

      implicit none
      integer(kind=c_intptr_t), intent(in)          :: my_stream
      logical                                       :: successGPU
      character(len=*)                              :: errormessage
      integer(kind=c_intptr_t)                      :: devPtr
      integer(kind=c_intptr_t)                      :: devPtrOffset

      integer(kind=ik), intent(in)                  :: off1
      integer(kind=ik), intent(in)                  :: off2
      integer(kind=ik), intent(in)                  :: off3
      logical                                       :: doSyncBefore
      logical                                       :: doSyncAfter
      logical                                       :: doSyncDefault

      real(kind=c_double)                           :: &
                                         hostArray(:,:,:)
      integer(kind=c_intptr_t)                      :: num
      integer(kind=c_int), intent(in)               :: direction

      if (doSyncBefore) then
        successGPU = gpu_stream_synchronize(my_stream)
        call check_memcpy_GPU_f(trim(errormessage), 734,  successGPU)
      endif

      if (direction .eq. gpuMemcpyHostToDevice) then
        successGPU = gpu_memcpy_async(devPtr+devPtrOffset, &
                    int(loc(hostarray(off1,off2,off3)),kind=c_intptr_t), &
                                      num, direction, my_stream)
      else if (direction .eq. gpuMemcpyDeviceToHost) then
        successGPU = gpu_memcpy_async(&
                    int(loc(hostarray(off1,off2,off3)),kind=c_intptr_t), &
                                      devPtr+devPtrOffset, num, direction, my_stream)
      else
        print *,"gpu_memcpy_async_and_stream_synchronize: unknown error"
        stop 1
      endif

      if (doSyncAfter) then
        successGPU = gpu_stream_synchronize(my_stream)
        call check_memcpy_GPU_f(trim(errormessage), 752,  successGPU)
      endif
      if (doSyncDefault) then
        ! synchronize streamsPerThread; maybe not neccessary
        successGPU = gpu_stream_synchronize()
        call check_memcpy_GPU_f(trim(errormessage), 757,  successGPU)
      endif
    end


    subroutine gpu_memcpy_async_and_stream_synchronize_single_3d &
                (errormessage, devPtr, devPtrOffset, &
                 hostarray, &
                 off1, off2, off3, &
                num, direction, my_stream, doSyncBefore, doSyncAfter, doSyncDefault)

      use iso_c_binding
      use elpa_gpu
      use elpa_utilities

      implicit none
      integer(kind=c_intptr_t), intent(in)          :: my_stream
      logical                                       :: successGPU
      character(len=*)                              :: errormessage
      integer(kind=c_intptr_t)                      :: devPtr
      integer(kind=c_intptr_t)                      :: devPtrOffset

      integer(kind=ik), intent(in)                  :: off1
      integer(kind=ik), intent(in)                  :: off2
      integer(kind=ik), intent(in)                  :: off3
      logical                                       :: doSyncBefore
      logical                                       :: doSyncAfter
      logical                                       :: doSyncDefault

      real(kind=c_float)                            :: &
                                         hostArray(:,:,:)
      integer(kind=c_intptr_t)                      :: num
      integer(kind=c_int), intent(in)               :: direction

      if (doSyncBefore) then
        successGPU = gpu_stream_synchronize(my_stream)
        call check_memcpy_GPU_f(trim(errormessage), 793,  successGPU)
      endif

      if (direction .eq. gpuMemcpyHostToDevice) then
        successGPU = gpu_memcpy_async(devPtr+devPtrOffset, &
                    int(loc(hostarray(off1,off2,off3)),kind=c_intptr_t), &
                                      num, direction, my_stream)
      else if (direction .eq. gpuMemcpyDeviceToHost) then
        successGPU = gpu_memcpy_async(&
                    int(loc(hostarray(off1,off2,off3)),kind=c_intptr_t), &
                                      devPtr+devPtrOffset, num, direction, my_stream)
      else
        print *,"gpu_memcpy_async_and_stream_synchronize: unknown error"
        stop 1
      endif

      if (doSyncAfter) then
        successGPU = gpu_stream_synchronize(my_stream)
        call check_memcpy_GPU_f(trim(errormessage), 811,  successGPU)
      endif
      if (doSyncDefault) then
        ! synchronize streamsPerThread; maybe not neccessary
        successGPU = gpu_stream_synchronize()
        call check_memcpy_GPU_f(trim(errormessage), 816,  successGPU)
      endif
    end


    subroutine gpu_memcpy_async_and_stream_synchronize_complex_3d &
                (errormessage, devPtr, devPtrOffset, &
                 hostarray, &
                 off1, off2, off3, &
                num, direction, my_stream, doSyncBefore, doSyncAfter, doSyncDefault)

      use iso_c_binding
      use elpa_gpu
      use elpa_utilities

      implicit none
      integer(kind=c_intptr_t), intent(in)          :: my_stream
      logical                                       :: successGPU
      character(len=*)                              :: errormessage
      integer(kind=c_intptr_t)                      :: devPtr
      integer(kind=c_intptr_t)                      :: devPtrOffset

      integer(kind=ik), intent(in)                  :: off1
      integer(kind=ik), intent(in)                  :: off2
      integer(kind=ik), intent(in)                  :: off3
      logical                                       :: doSyncBefore
      logical                                       :: doSyncAfter
      logical                                       :: doSyncDefault

      complex(kind=c_double_complex)                :: &
                                         hostArray(:,:,:)
      integer(kind=c_intptr_t)                      :: num
      integer(kind=c_int), intent(in)               :: direction

      if (doSyncBefore) then
        successGPU = gpu_stream_synchronize(my_stream)
        call check_memcpy_GPU_f(trim(errormessage), 852,  successGPU)
      endif

      if (direction .eq. gpuMemcpyHostToDevice) then
        successGPU = gpu_memcpy_async(devPtr+devPtrOffset, &
                    int(loc(hostarray(off1,off2,off3)),kind=c_intptr_t), &
                                      num, direction, my_stream)
      else if (direction .eq. gpuMemcpyDeviceToHost) then
        successGPU = gpu_memcpy_async(&
                    int(loc(hostarray(off1,off2,off3)),kind=c_intptr_t), &
                                      devPtr+devPtrOffset, num, direction, my_stream)
      else
        print *,"gpu_memcpy_async_and_stream_synchronize: unknown error"
        stop 1
      endif

      if (doSyncAfter) then
        successGPU = gpu_stream_synchronize(my_stream)
        call check_memcpy_GPU_f(trim(errormessage), 870,  successGPU)
      endif
      if (doSyncDefault) then
        ! synchronize streamsPerThread; maybe not neccessary
        successGPU = gpu_stream_synchronize()
        call check_memcpy_GPU_f(trim(errormessage), 875,  successGPU)
      endif
    end


    subroutine gpu_memcpy_async_and_stream_synchronize_complex_single_3d &
                (errormessage, devPtr, devPtrOffset, &
                 hostarray, &
                 off1, off2, off3, &
                num, direction, my_stream, doSyncBefore, doSyncAfter, doSyncDefault)

      use iso_c_binding
      use elpa_gpu
      use elpa_utilities

      implicit none
      integer(kind=c_intptr_t), intent(in)          :: my_stream
      logical                                       :: successGPU
      character(len=*)                              :: errormessage
      integer(kind=c_intptr_t)                      :: devPtr
      integer(kind=c_intptr_t)                      :: devPtrOffset

      integer(kind=ik), intent(in)                  :: off1
      integer(kind=ik), intent(in)                  :: off2
      integer(kind=ik), intent(in)                  :: off3
      logical                                       :: doSyncBefore
      logical                                       :: doSyncAfter
      logical                                       :: doSyncDefault

      complex(kind=c_float_complex)                 :: &
                                         hostArray(:,:,:)
      integer(kind=c_intptr_t)                      :: num
      integer(kind=c_int), intent(in)               :: direction

      if (doSyncBefore) then
        successGPU = gpu_stream_synchronize(my_stream)
        call check_memcpy_GPU_f(trim(errormessage), 911,  successGPU)
      endif

      if (direction .eq. gpuMemcpyHostToDevice) then
        successGPU = gpu_memcpy_async(devPtr+devPtrOffset, &
                    int(loc(hostarray(off1,off2,off3)),kind=c_intptr_t), &
                                      num, direction, my_stream)
      else if (direction .eq. gpuMemcpyDeviceToHost) then
        successGPU = gpu_memcpy_async(&
                    int(loc(hostarray(off1,off2,off3)),kind=c_intptr_t), &
                                      devPtr+devPtrOffset, num, direction, my_stream)
      else
        print *,"gpu_memcpy_async_and_stream_synchronize: unknown error"
        stop 1
      endif

      if (doSyncAfter) then
        successGPU = gpu_stream_synchronize(my_stream)
        call check_memcpy_GPU_f(trim(errormessage), 929,  successGPU)
      endif
      if (doSyncDefault) then
        ! synchronize streamsPerThread; maybe not neccessary
        successGPU = gpu_stream_synchronize()
        call check_memcpy_GPU_f(trim(errormessage), 934,  successGPU)
      endif
    end


end module

