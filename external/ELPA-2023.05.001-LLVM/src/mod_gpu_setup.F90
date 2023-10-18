












module elpa_gpu_setup
  !use precision
  use iso_c_binding

  type :: elpa_gpu_setup_t
    integer(kind=c_int)            :: use_gpu_vendor

    ! per task information should be stored elsewhere
    integer(kind=C_intptr_T), allocatable :: gpublasHandleArray(:)
    integer(kind=C_intptr_T), allocatable :: gpusolverHandleArray(:)
    integer(kind=c_int), allocatable      :: gpuDeviceArray(:)
    integer(kind=c_intptr_t)              :: my_stream

    integer(kind=C_intptr_T), allocatable :: cublasHandleArray(:)
    integer(kind=C_intptr_T), allocatable :: cusolverHandleArray(:)
    integer(kind=c_int), allocatable      :: cudaDeviceArray(:)

    integer(kind=C_intptr_T), allocatable :: rocblasHandleArray(:)
    integer(kind=C_intptr_T), allocatable :: rocsolverHandleArray(:)
    integer(kind=c_int), allocatable      :: hipDeviceArray(:)

    integer(kind=C_intptr_T), allocatable :: syclHandleArray(:)
    integer(kind=C_intptr_T), allocatable :: syclsolverHandleArray(:)
    integer(kind=c_int), allocatable      :: syclDeviceArray(:)

    integer(kind=C_intptr_T), allocatable :: openmpOffloadHandleArray(:)
    integer(kind=C_intptr_T), allocatable :: openmpOffloadsolverHandleArray(:)
    integer(kind=c_int), allocatable      :: openmpOffloadDeviceArray(:)

    logical                               :: gpuAlreadySet

    integer(kind=c_intptr_t)              :: ccl_comm_rows, ccl_comm_cols, ccl_comm_all
  end type

end module

