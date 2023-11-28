












module elpa_blas_gpu
  use iso_c_binding
  use elpa_general_gpu, only : use_gpu_vendor, nvidia_gpu, amd_gpu, intel_gpu, openmp_offload_gpu, sycl_gpu, no_gpu, &
                               gpu_vendor



  interface gpublas_Dcopy
    module procedure gpublas_Dcopy_intptr
    module procedure gpublas_Dcopy_cptr
  end interface

  interface gpublas_Dtrmm
    module procedure gpublas_Dtrmm_intptr
    module procedure gpublas_Dtrmm_cptr
  end interface
  
  interface gpublas_Dtrsm
    module procedure gpublas_Dtrsm_intptr
    module procedure gpublas_Dtrsm_cptr
  end interface
  
  interface gpublas_Dgemm
    module procedure gpublas_Dgemm_intptr
    module procedure gpublas_Dgemm_cptr
  end interface

  interface gpublas_Dscal
    module procedure gpublas_Dscal_intptr
    module procedure gpublas_Dscal_cptr
  end interface

  interface gpublas_Ddot
    module procedure gpublas_Ddot_intptr
    module procedure gpublas_Ddot_cptr
  end interface

  interface gpublas_Daxpy
    module procedure gpublas_Daxpy_intptr
    module procedure gpublas_Daxpy_cptr
  end interface

  interface gpublas_Scopy
    module procedure gpublas_Scopy_intptr
    module procedure gpublas_Scopy_cptr
  end interface

  interface gpublas_Strmm
    module procedure gpublas_Strmm_intptr
    module procedure gpublas_Strmm_cptr
  end interface
  
  interface gpublas_Strsm
    module procedure gpublas_Strsm_intptr
    module procedure gpublas_Strsm_cptr
  end interface
  
  interface gpublas_Sgemm
    module procedure gpublas_Sgemm_intptr
    module procedure gpublas_Sgemm_cptr
  end interface

  interface gpublas_Sscal
    module procedure gpublas_Sscal_intptr
    module procedure gpublas_Sscal_cptr
  end interface

  interface gpublas_Sdot
    module procedure gpublas_Sdot_intptr
    module procedure gpublas_Sdot_cptr
  end interface

  interface gpublas_Saxpy
    module procedure gpublas_Saxpy_intptr
    module procedure gpublas_Saxpy_cptr
  end interface

  interface gpublas_Zcopy
    module procedure gpublas_Zcopy_intptr
    module procedure gpublas_Zcopy_cptr
  end interface

  interface gpublas_Ztrmm
    module procedure gpublas_Ztrmm_intptr
    module procedure gpublas_Ztrmm_cptr
  end interface
  
  interface gpublas_Ztrsm
    module procedure gpublas_Ztrsm_intptr
    module procedure gpublas_Ztrsm_cptr
  end interface
  
  interface gpublas_Zgemm
    module procedure gpublas_Zgemm_intptr
    module procedure gpublas_Zgemm_cptr
  end interface

  interface gpublas_Zscal
    module procedure gpublas_Zscal_intptr
    module procedure gpublas_Zscal_cptr
  end interface

  interface gpublas_Zdot
    module procedure gpublas_Zdot_intptr
    module procedure gpublas_Zdot_cptr
  end interface

  interface gpublas_Zaxpy
    module procedure gpublas_Zaxpy_intptr
    module procedure gpublas_Zaxpy_cptr
  end interface

  interface gpublas_Ccopy
    module procedure gpublas_Ccopy_intptr
    module procedure gpublas_Ccopy_cptr
  end interface

  interface gpublas_Ctrmm
    module procedure gpublas_Ctrmm_intptr
    module procedure gpublas_Ctrmm_cptr
  end interface
  
  interface gpublas_Ctrsm
    module procedure gpublas_Ctrsm_intptr
    module procedure gpublas_Ctrsm_cptr
  end interface
  
  interface gpublas_Cgemm
    module procedure gpublas_Cgemm_intptr
    module procedure gpublas_Cgemm_cptr
  end interface

  interface gpublas_Cscal
    module procedure gpublas_Cscal_intptr
    module procedure gpublas_Cscal_cptr
  end interface

  interface gpublas_Cdot
    module procedure gpublas_Cdot_intptr
    module procedure gpublas_Cdot_cptr
  end interface

  interface gpublas_Caxpy
    module procedure gpublas_Caxpy_intptr
    module procedure gpublas_Caxpy_cptr
  end interface


  contains

    function gpublas_set_stream(handle, stream) result(success)
      use, intrinsic :: iso_c_binding

      implicit none

      integer(kind=c_intptr_t), intent(in)  :: handle
      integer(kind=c_intptr_t), intent(in)  :: stream
      logical                               :: success


      success = .true.

    end function


    subroutine gpublas_Dgemv(cta, m, n, alpha, a, lda, x, incx, beta, y, incy, handle)
      use, intrinsic :: iso_c_binding
      use cuda_functions

      implicit none
      character(1,C_CHAR),value       :: cta
      integer(kind=C_INT)             :: m,n
      integer(kind=C_INT), intent(in) :: lda,incx,incy
      real(kind=C_DOUBLE)             :: alpha,beta
      integer(kind=C_intptr_T)        :: a, x, y
      integer(kind=c_intptr_t)        :: handle

        if (use_gpu_vendor == nvidia_gpu) then
          call cublas_Dgemv(cta, m, n, alpha, a, lda, x, incx, beta, y, incy, handle)
        endif



    end subroutine

    subroutine gpublas_Dgemm_intptr(cta, ctb, m, n, k, alpha, a, lda, b, ldb, beta, c, ldc, handle)
      use, intrinsic :: iso_c_binding
      use cuda_functions

      implicit none
      character(1,C_CHAR),value       :: cta, ctb
      integer(kind=C_INT)             :: m,n,k
      integer(kind=C_INT), intent(in) :: lda,ldb,ldc
      real(kind=C_DOUBLE)             :: alpha,beta
      integer(kind=C_intptr_T)        :: a, b, c
      integer(kind=c_intptr_t)        :: handle

        if (use_gpu_vendor == nvidia_gpu) then
          call cublas_Dgemm_intptr(cta, ctb, m, n, k, alpha, a, lda, b, ldb, beta, c, ldc, handle)
        endif




    end subroutine 

    subroutine gpublas_Dgemm_cptr(cta, ctb, m, n, k, alpha, a, lda, b, ldb, beta, c, ldc, handle)
      use, intrinsic :: iso_c_binding
      use cuda_functions

      implicit none
      character(1,C_CHAR),value       :: cta, ctb
      integer(kind=C_INT)             :: m,n,k
      integer(kind=C_INT), intent(in) :: lda,ldb,ldc
      real(kind=C_DOUBLE)             :: alpha,beta
      type(c_ptr)                     :: a, b, c
      integer(kind=c_intptr_t)        :: handle

        if (use_gpu_vendor == nvidia_gpu) then
          call cublas_Dgemm_cptr(cta, ctb, m, n, k, alpha, a, lda, b, ldb, beta, c, ldc, handle)
        endif




    end subroutine 

    subroutine gpublas_Dcopy_intptr(n, x, incx, y, incy, handle)

      use, intrinsic :: iso_c_binding
      use cuda_functions

      implicit none
      integer(kind=C_INT)             :: n
      integer(kind=C_INT), intent(in) :: incx, incy
      integer(kind=C_intptr_T)        :: x, y
      integer(kind=c_intptr_t)     :: handle

        if (use_gpu_vendor == nvidia_gpu) then
          call cublas_Dcopy_intptr(n, x, incx, y, incy, handle)
        endif



    end subroutine

    subroutine gpublas_Dcopy_cptr(n, x, incx, y, incy, handle)

      use, intrinsic :: iso_c_binding
      use cuda_functions

      implicit none
      integer(kind=C_INT)             :: n
      integer(kind=C_INT), intent(in) :: incx, incy
      type(c_ptr)                     :: x, y
      integer(kind=c_intptr_t)     :: handle

        if (use_gpu_vendor == nvidia_gpu) then
          call cublas_Dcopy_cptr(n, x, incx, y, incy, handle)
        endif



    end subroutine

    subroutine gpublas_Dtrmm_intptr(side, uplo, trans, diag, m, n, alpha, a, lda, b, ldb, handle)

      use, intrinsic :: iso_c_binding
      use cuda_functions

      implicit none
      character(1,C_CHAR),value       :: side, uplo, trans, diag
      integer(kind=C_INT)             :: m,n
      integer(kind=C_INT), intent(in) :: lda,ldb
      real(kind=C_DOUBLE)             :: alpha
      integer(kind=C_intptr_T)        :: a, b
      integer(kind=c_intptr_t)     :: handle

        if (use_gpu_vendor == nvidia_gpu) then
          call cublas_Dtrmm_intptr(side, uplo, trans, diag, m, n, alpha, a, lda, b, ldb, handle)
        endif




    end subroutine


    subroutine gpublas_Dtrmm_cptr(side, uplo, trans, diag, m, n, alpha, a, lda, b, ldb, handle)

      use, intrinsic :: iso_c_binding
      use cuda_functions

      implicit none
      character(1,C_CHAR),value       :: side, uplo, trans, diag
      integer(kind=C_INT)             :: m,n
      integer(kind=C_INT), intent(in) :: lda,ldb
      real(kind=C_DOUBLE)             :: alpha
      type(c_ptr)                     :: a, b
      integer(kind=c_intptr_t)     :: handle

        if (use_gpu_vendor == nvidia_gpu) then
          call cublas_Dtrmm_cptr(side, uplo, trans, diag, m, n, alpha, a, lda, b, ldb, handle)
        endif



    end subroutine

    subroutine gpublas_Dtrsm_intptr(side, uplo, trans, diag, m, n, alpha, a, lda, b, ldb, handle)

      use, intrinsic :: iso_c_binding
      use cuda_functions

      implicit none
      character(1,C_CHAR),value       :: side, uplo, trans, diag
      integer(kind=C_INT)             :: m,n
      integer(kind=C_INT), intent(in) :: lda,ldb
      real(kind=C_DOUBLE)             :: alpha
      integer(kind=C_intptr_T)        :: a, b
      integer(kind=c_intptr_t)     :: handle

        if (use_gpu_vendor == nvidia_gpu) then
          call cublas_Dtrsm_intptr(side, uplo, trans, diag, m, n, alpha, a, lda, b, ldb, handle)
        endif



    end subroutine

    subroutine gpublas_Dtrsm_cptr(side, uplo, trans, diag, m, n, alpha, a, lda, b, ldb, handle)

      use, intrinsic :: iso_c_binding
      use cuda_functions

      implicit none
      character(1,C_CHAR),value       :: side, uplo, trans, diag
      integer(kind=C_INT)             :: m,n
      integer(kind=C_INT), intent(in) :: lda,ldb
      real(kind=C_DOUBLE)             :: alpha
      type(c_ptr)                     :: a, b
      integer(kind=c_intptr_t)     :: handle

        if (use_gpu_vendor == nvidia_gpu) then
          call cublas_Dtrsm_cptr(side, uplo, trans, diag, m, n, alpha, a, lda, b, ldb, handle)
        endif



    end subroutine
    subroutine gpublas_Sgemv(cta, m, n, alpha, a, lda, x, incx, beta, y, incy, handle)
      use, intrinsic :: iso_c_binding
      use cuda_functions

      implicit none
      character(1,C_CHAR),value       :: cta
      integer(kind=C_INT)             :: m,n
      integer(kind=C_INT), intent(in) :: lda,incx,incy
      real(kind=C_FLOAT)              :: alpha,beta
      integer(kind=C_intptr_T)        :: a, x, y
      integer(kind=c_intptr_t)        :: handle

        if (use_gpu_vendor == nvidia_gpu) then
          call cublas_Sgemv(cta, m, n, alpha, a, lda, x, incx, beta, y, incy, handle)
        endif



    end subroutine

    subroutine gpublas_Sgemm_intptr(cta, ctb, m, n, k, alpha, a, lda, b, ldb, beta, c, ldc, handle)
      use, intrinsic :: iso_c_binding
      use cuda_functions

      implicit none
      character(1,C_CHAR),value       :: cta, ctb
      integer(kind=C_INT)             :: m,n,k
      integer(kind=C_INT), intent(in) :: lda,ldb,ldc
      real(kind=C_FLOAT)              :: alpha,beta
      integer(kind=C_intptr_T)        :: a, b, c
      integer(kind=c_intptr_t)        :: handle

        if (use_gpu_vendor == nvidia_gpu) then
          call cublas_Sgemm_intptr(cta, ctb, m, n, k, alpha, a, lda, b, ldb, beta, c, ldc, handle)
        endif




    end subroutine 

    subroutine gpublas_Sgemm_cptr(cta, ctb, m, n, k, alpha, a, lda, b, ldb, beta, c, ldc, handle)
      use, intrinsic :: iso_c_binding
      use cuda_functions

      implicit none
      character(1,C_CHAR),value       :: cta, ctb
      integer(kind=C_INT)             :: m,n,k
      integer(kind=C_INT), intent(in) :: lda,ldb,ldc
      real(kind=C_FLOAT)              :: alpha,beta
      type(c_ptr)                     :: a, b, c
      integer(kind=c_intptr_t)        :: handle

        if (use_gpu_vendor == nvidia_gpu) then
          call cublas_Sgemm_cptr(cta, ctb, m, n, k, alpha, a, lda, b, ldb, beta, c, ldc, handle)
        endif




    end subroutine 

    subroutine gpublas_Scopy_intptr(n, x, incx, y, incy, handle)

      use, intrinsic :: iso_c_binding
      use cuda_functions

      implicit none
      integer(kind=C_INT)             :: n
      integer(kind=C_INT), intent(in) :: incx, incy
      integer(kind=C_intptr_T)        :: x, y
      integer(kind=c_intptr_t)     :: handle

        if (use_gpu_vendor == nvidia_gpu) then
          call cublas_Scopy_intptr(n, x, incx, y, incy, handle)
        endif



    end subroutine

    subroutine gpublas_Scopy_cptr(n, x, incx, y, incy, handle)

      use, intrinsic :: iso_c_binding
      use cuda_functions

      implicit none
      integer(kind=C_INT)             :: n
      integer(kind=C_INT), intent(in) :: incx, incy
      type(c_ptr)                     :: x, y
      integer(kind=c_intptr_t)     :: handle

        if (use_gpu_vendor == nvidia_gpu) then
          call cublas_Scopy_cptr(n, x, incx, y, incy, handle)
        endif



    end subroutine

    subroutine gpublas_Strmm_intptr(side, uplo, trans, diag, m, n, alpha, a, lda, b, ldb, handle)

      use, intrinsic :: iso_c_binding
      use cuda_functions

      implicit none
      character(1,C_CHAR),value       :: side, uplo, trans, diag
      integer(kind=C_INT)             :: m,n
      integer(kind=C_INT), intent(in) :: lda,ldb
      real(kind=C_FLOAT)              :: alpha
      integer(kind=C_intptr_T)        :: a, b
      integer(kind=c_intptr_t)     :: handle

        if (use_gpu_vendor == nvidia_gpu) then
          call cublas_Strmm_intptr(side, uplo, trans, diag, m, n, alpha, a, lda, b, ldb, handle)
        endif




    end subroutine


    subroutine gpublas_Strmm_cptr(side, uplo, trans, diag, m, n, alpha, a, lda, b, ldb, handle)

      use, intrinsic :: iso_c_binding
      use cuda_functions

      implicit none
      character(1,C_CHAR),value       :: side, uplo, trans, diag
      integer(kind=C_INT)             :: m,n
      integer(kind=C_INT), intent(in) :: lda,ldb
      real(kind=C_FLOAT)              :: alpha
      type(c_ptr)                     :: a, b
      integer(kind=c_intptr_t)     :: handle

        if (use_gpu_vendor == nvidia_gpu) then
          call cublas_Strmm_cptr(side, uplo, trans, diag, m, n, alpha, a, lda, b, ldb, handle)
        endif



    end subroutine

    subroutine gpublas_Strsm_intptr(side, uplo, trans, diag, m, n, alpha, a, lda, b, ldb, handle)

      use, intrinsic :: iso_c_binding
      use cuda_functions

      implicit none
      character(1,C_CHAR),value       :: side, uplo, trans, diag
      integer(kind=C_INT)             :: m,n
      integer(kind=C_INT), intent(in) :: lda,ldb
      real(kind=C_FLOAT)              :: alpha
      integer(kind=C_intptr_T)        :: a, b
      integer(kind=c_intptr_t)     :: handle

        if (use_gpu_vendor == nvidia_gpu) then
          call cublas_Strsm_intptr(side, uplo, trans, diag, m, n, alpha, a, lda, b, ldb, handle)
        endif



    end subroutine

    subroutine gpublas_Strsm_cptr(side, uplo, trans, diag, m, n, alpha, a, lda, b, ldb, handle)

      use, intrinsic :: iso_c_binding
      use cuda_functions

      implicit none
      character(1,C_CHAR),value       :: side, uplo, trans, diag
      integer(kind=C_INT)             :: m,n
      integer(kind=C_INT), intent(in) :: lda,ldb
      real(kind=C_FLOAT)              :: alpha
      type(c_ptr)                     :: a, b
      integer(kind=c_intptr_t)     :: handle

        if (use_gpu_vendor == nvidia_gpu) then
          call cublas_Strsm_cptr(side, uplo, trans, diag, m, n, alpha, a, lda, b, ldb, handle)
        endif



    end subroutine
    subroutine gpublas_Zgemv(cta, m, n, alpha, a, lda, x, incx, beta, y, incy, handle)
      use, intrinsic :: iso_c_binding
      use cuda_functions

      implicit none
      character(1,C_CHAR),value       :: cta
      integer(kind=C_INT)             :: m,n
      integer(kind=C_INT), intent(in) :: lda,incx,incy
      complex(kind=C_double_complex)  :: alpha,beta
      integer(kind=C_intptr_T)        :: a, x, y
      integer(kind=c_intptr_t)        :: handle

        if (use_gpu_vendor == nvidia_gpu) then
          call cublas_Zgemv(cta, m, n, alpha, a, lda, x, incx, beta, y, incy, handle)
        endif



    end subroutine

    subroutine gpublas_Zgemm_intptr(cta, ctb, m, n, k, alpha, a, lda, b, ldb, beta, c, ldc, handle)
      use, intrinsic :: iso_c_binding
      use cuda_functions

      implicit none
      character(1,C_CHAR),value       :: cta, ctb
      integer(kind=C_INT)             :: m,n,k
      integer(kind=C_INT), intent(in) :: lda,ldb,ldc
      complex(kind=C_DOUBLE_COMPLEX)  :: alpha,beta
      integer(kind=C_intptr_T)        :: a, b, c
      integer(kind=c_intptr_t)        :: handle

        if (use_gpu_vendor == nvidia_gpu) then
          call cublas_Zgemm_intptr(cta, ctb, m, n, k, alpha, a, lda, b, ldb, beta, c, ldc, handle)
        endif




    end subroutine 

    subroutine gpublas_Zgemm_cptr(cta, ctb, m, n, k, alpha, a, lda, b, ldb, beta, c, ldc, handle)
      use, intrinsic :: iso_c_binding
      use cuda_functions

      implicit none
      character(1,C_CHAR),value       :: cta, ctb
      integer(kind=C_INT)             :: m,n,k
      integer(kind=C_INT), intent(in) :: lda,ldb,ldc
      complex(kind=C_DOUBLE_COMPLEX)  :: alpha,beta
      type(c_ptr)                     :: a, b, c
      integer(kind=c_intptr_t)        :: handle

        if (use_gpu_vendor == nvidia_gpu) then
          call cublas_Zgemm_cptr(cta, ctb, m, n, k, alpha, a, lda, b, ldb, beta, c, ldc, handle)
        endif




    end subroutine 

    subroutine gpublas_Zcopy_intptr(n, x, incx, y, incy, handle)

      use, intrinsic :: iso_c_binding
      use cuda_functions

      implicit none
      integer(kind=C_INT)             :: n
      integer(kind=C_INT), intent(in) :: incx, incy
      integer(kind=C_intptr_T)        :: x, y
      integer(kind=c_intptr_t)     :: handle

        if (use_gpu_vendor == nvidia_gpu) then
          call cublas_Zcopy_intptr(n, x, incx, y, incy, handle)
        endif



    end subroutine

    subroutine gpublas_Zcopy_cptr(n, x, incx, y, incy, handle)

      use, intrinsic :: iso_c_binding
      use cuda_functions

      implicit none
      integer(kind=C_INT)             :: n
      integer(kind=C_INT), intent(in) :: incx, incy
      type(c_ptr)                     :: x, y
      integer(kind=c_intptr_t)     :: handle

        if (use_gpu_vendor == nvidia_gpu) then
          call cublas_Zcopy_cptr(n, x, incx, y, incy, handle)
        endif



    end subroutine

    subroutine gpublas_Ztrmm_intptr(side, uplo, trans, diag, m, n, alpha, a, lda, b, ldb, handle)

      use, intrinsic :: iso_c_binding
      use cuda_functions

      implicit none
      character(1,C_CHAR),value       :: side, uplo, trans, diag
      integer(kind=C_INT)             :: m,n
      integer(kind=C_INT), intent(in) :: lda,ldb
      complex(kind=C_DOUBLE_COMPLEX)  :: alpha
      integer(kind=C_intptr_T)        :: a, b
      integer(kind=c_intptr_t)     :: handle

        if (use_gpu_vendor == nvidia_gpu) then
          call cublas_Ztrmm_intptr(side, uplo, trans, diag, m, n, alpha, a, lda, b, ldb, handle)
        endif




    end subroutine


    subroutine gpublas_Ztrmm_cptr(side, uplo, trans, diag, m, n, alpha, a, lda, b, ldb, handle)

      use, intrinsic :: iso_c_binding
      use cuda_functions

      implicit none
      character(1,C_CHAR),value       :: side, uplo, trans, diag
      integer(kind=C_INT)             :: m,n
      integer(kind=C_INT), intent(in) :: lda,ldb
      complex(kind=C_DOUBLE_COMPLEX)  :: alpha
      type(c_ptr)                     :: a, b
      integer(kind=c_intptr_t)     :: handle

        if (use_gpu_vendor == nvidia_gpu) then
          call cublas_Ztrmm_cptr(side, uplo, trans, diag, m, n, alpha, a, lda, b, ldb, handle)
        endif



    end subroutine

    subroutine gpublas_Ztrsm_intptr(side, uplo, trans, diag, m, n, alpha, a, lda, b, ldb, handle)

      use, intrinsic :: iso_c_binding
      use cuda_functions

      implicit none
      character(1,C_CHAR),value       :: side, uplo, trans, diag
      integer(kind=C_INT)             :: m,n
      integer(kind=C_INT), intent(in) :: lda,ldb
      complex(kind=C_DOUBLE_COMPLEX)  :: alpha
      integer(kind=C_intptr_T)        :: a, b
      integer(kind=c_intptr_t)     :: handle

        if (use_gpu_vendor == nvidia_gpu) then
          call cublas_Ztrsm_intptr(side, uplo, trans, diag, m, n, alpha, a, lda, b, ldb, handle)
        endif



    end subroutine

    subroutine gpublas_Ztrsm_cptr(side, uplo, trans, diag, m, n, alpha, a, lda, b, ldb, handle)

      use, intrinsic :: iso_c_binding
      use cuda_functions

      implicit none
      character(1,C_CHAR),value       :: side, uplo, trans, diag
      integer(kind=C_INT)             :: m,n
      integer(kind=C_INT), intent(in) :: lda,ldb
      complex(kind=C_DOUBLE_COMPLEX)  :: alpha
      type(c_ptr)                     :: a, b
      integer(kind=c_intptr_t)     :: handle

        if (use_gpu_vendor == nvidia_gpu) then
          call cublas_Ztrsm_cptr(side, uplo, trans, diag, m, n, alpha, a, lda, b, ldb, handle)
        endif



    end subroutine
    subroutine gpublas_Cgemv(cta, m, n, alpha, a, lda, x, incx, beta, y, incy, handle)
      use, intrinsic :: iso_c_binding
      use cuda_functions

      implicit none
      character(1,C_CHAR),value       :: cta
      integer(kind=C_INT)             :: m,n
      integer(kind=C_INT), intent(in) :: lda,incx,incy
      complex(kind=C_float_complex)  :: alpha,beta
      integer(kind=C_intptr_T)        :: a, x, y
      integer(kind=c_intptr_t)        :: handle

        if (use_gpu_vendor == nvidia_gpu) then
          call cublas_Cgemv(cta, m, n, alpha, a, lda, x, incx, beta, y, incy, handle)
        endif



    end subroutine

    subroutine gpublas_Cgemm_intptr(cta, ctb, m, n, k, alpha, a, lda, b, ldb, beta, c, ldc, handle)
      use, intrinsic :: iso_c_binding
      use cuda_functions

      implicit none
      character(1,C_CHAR),value       :: cta, ctb
      integer(kind=C_INT)             :: m,n,k
      integer(kind=C_INT), intent(in) :: lda,ldb,ldc
      complex(kind=C_FLOAT_COMPLEX)  :: alpha,beta
      integer(kind=C_intptr_T)        :: a, b, c
      integer(kind=c_intptr_t)        :: handle

        if (use_gpu_vendor == nvidia_gpu) then
          call cublas_Cgemm_intptr(cta, ctb, m, n, k, alpha, a, lda, b, ldb, beta, c, ldc, handle)
        endif




    end subroutine 

    subroutine gpublas_Cgemm_cptr(cta, ctb, m, n, k, alpha, a, lda, b, ldb, beta, c, ldc, handle)
      use, intrinsic :: iso_c_binding
      use cuda_functions

      implicit none
      character(1,C_CHAR),value       :: cta, ctb
      integer(kind=C_INT)             :: m,n,k
      integer(kind=C_INT), intent(in) :: lda,ldb,ldc
      complex(kind=C_FLOAT_COMPLEX)  :: alpha,beta
      type(c_ptr)                     :: a, b, c
      integer(kind=c_intptr_t)        :: handle

        if (use_gpu_vendor == nvidia_gpu) then
          call cublas_Cgemm_cptr(cta, ctb, m, n, k, alpha, a, lda, b, ldb, beta, c, ldc, handle)
        endif




    end subroutine 

    subroutine gpublas_Ccopy_intptr(n, x, incx, y, incy, handle)

      use, intrinsic :: iso_c_binding
      use cuda_functions

      implicit none
      integer(kind=C_INT)             :: n
      integer(kind=C_INT), intent(in) :: incx, incy
      integer(kind=C_intptr_T)        :: x, y
      integer(kind=c_intptr_t)     :: handle

        if (use_gpu_vendor == nvidia_gpu) then
          call cublas_Ccopy_intptr(n, x, incx, y, incy, handle)
        endif



    end subroutine

    subroutine gpublas_Ccopy_cptr(n, x, incx, y, incy, handle)

      use, intrinsic :: iso_c_binding
      use cuda_functions

      implicit none
      integer(kind=C_INT)             :: n
      integer(kind=C_INT), intent(in) :: incx, incy
      type(c_ptr)                     :: x, y
      integer(kind=c_intptr_t)     :: handle

        if (use_gpu_vendor == nvidia_gpu) then
          call cublas_Ccopy_cptr(n, x, incx, y, incy, handle)
        endif



    end subroutine

    subroutine gpublas_Ctrmm_intptr(side, uplo, trans, diag, m, n, alpha, a, lda, b, ldb, handle)

      use, intrinsic :: iso_c_binding
      use cuda_functions

      implicit none
      character(1,C_CHAR),value       :: side, uplo, trans, diag
      integer(kind=C_INT)             :: m,n
      integer(kind=C_INT), intent(in) :: lda,ldb
      complex(kind=C_FLOAT_COMPLEX)   :: alpha
      integer(kind=C_intptr_T)        :: a, b
      integer(kind=c_intptr_t)     :: handle

        if (use_gpu_vendor == nvidia_gpu) then
          call cublas_Ctrmm_intptr(side, uplo, trans, diag, m, n, alpha, a, lda, b, ldb, handle)
        endif




    end subroutine


    subroutine gpublas_Ctrmm_cptr(side, uplo, trans, diag, m, n, alpha, a, lda, b, ldb, handle)

      use, intrinsic :: iso_c_binding
      use cuda_functions

      implicit none
      character(1,C_CHAR),value       :: side, uplo, trans, diag
      integer(kind=C_INT)             :: m,n
      integer(kind=C_INT), intent(in) :: lda,ldb
      complex(kind=C_FLOAT_COMPLEX)   :: alpha
      type(c_ptr)                     :: a, b
      integer(kind=c_intptr_t)     :: handle

        if (use_gpu_vendor == nvidia_gpu) then
          call cublas_Ctrmm_cptr(side, uplo, trans, diag, m, n, alpha, a, lda, b, ldb, handle)
        endif



    end subroutine

    subroutine gpublas_Ctrsm_intptr(side, uplo, trans, diag, m, n, alpha, a, lda, b, ldb, handle)

      use, intrinsic :: iso_c_binding
      use cuda_functions

      implicit none
      character(1,C_CHAR),value       :: side, uplo, trans, diag
      integer(kind=C_INT)             :: m,n
      integer(kind=C_INT), intent(in) :: lda,ldb
      complex(kind=C_FLOAT_COMPLEX)   :: alpha
      integer(kind=C_intptr_T)        :: a, b
      integer(kind=c_intptr_t)     :: handle

        if (use_gpu_vendor == nvidia_gpu) then
          call cublas_Ctrsm_intptr(side, uplo, trans, diag, m, n, alpha, a, lda, b, ldb, handle)
        endif



    end subroutine

    subroutine gpublas_Ctrsm_cptr(side, uplo, trans, diag, m, n, alpha, a, lda, b, ldb, handle)

      use, intrinsic :: iso_c_binding
      use cuda_functions

      implicit none
      character(1,C_CHAR),value       :: side, uplo, trans, diag
      integer(kind=C_INT)             :: m,n
      integer(kind=C_INT), intent(in) :: lda,ldb
      complex(kind=C_FLOAT_COMPLEX)   :: alpha
      type(c_ptr)                     :: a, b
      integer(kind=c_intptr_t)     :: handle

        if (use_gpu_vendor == nvidia_gpu) then
          call cublas_Ctrsm_cptr(side, uplo, trans, diag, m, n, alpha, a, lda, b, ldb, handle)
        endif



    end subroutine

    subroutine gpublas_getPointerMode(gpublasHandle, mode)

      use, intrinsic :: iso_c_binding
      use cuda_functions

      implicit none
      integer(kind=c_intptr_t)          :: gpublasHandle
      integer(kind=c_int)               :: mode

        if (use_gpu_vendor == nvidia_gpu) then
          call cublas_getPointerMode(gpublasHandle, mode)
        endif



    end subroutine

    subroutine gpublas_setPointerMode(gpublasHandle, mode)

      use, intrinsic :: iso_c_binding

      implicit none
      integer(kind=c_intptr_t)          :: gpublasHandle
      integer(kind=c_int)               :: mode




    end subroutine

    subroutine gpublas_Ddot_intptr(gpublasHandle, length, x, incx, y, incy, z)

      use, intrinsic :: iso_c_binding

      implicit none
      integer(kind=c_intptr_t)          :: gpublasHandle
      integer(kind=c_int)               :: length, incx, incy
      integer(kind=c_intptr_t)          :: x, y, z




    end subroutine

    subroutine gpublas_Ddot_cptr(gpublasHandle, length, x, incx, y, incy, z)

      use, intrinsic :: iso_c_binding

      implicit none
      integer(kind=c_intptr_t)          :: gpublasHandle
      integer(kind=c_int)               :: length, incx, incy
      type(c_ptr)                       :: x, y, z




    end subroutine

    subroutine gpublas_Dscal_intptr(gpublasHandle, length, alpha, x, incx)

      use, intrinsic :: iso_c_binding

      implicit none
      integer(kind=c_intptr_t)          :: gpublasHandle
      integer(kind=c_int)               :: length, incx
      real(kind=C_DOUBLE)             :: alpha
      integer(kind=c_intptr_t)           :: x




    end subroutine

    subroutine gpublas_Dscal_cptr(gpublasHandle, length, alpha, x, incx)

      use, intrinsic :: iso_c_binding

      implicit none
      integer(kind=c_intptr_t)          :: gpublasHandle
      integer(kind=c_int)               :: length, incx
      real(kind=C_DOUBLE)             :: alpha
      type(c_ptr)                       :: x




    end subroutine


    subroutine gpublas_Daxpy_intptr(gpublasHandle, length, alpha, x, incx, y, incy)

      use, intrinsic :: iso_c_binding

      implicit none
      integer(kind=c_intptr_t)          :: gpublasHandle
      integer(kind=c_int)               :: length, incx, incy
      real(kind=C_DOUBLE)             :: alpha
      integer(kind=c_intptr_t)           :: x, y




    end subroutine

    subroutine gpublas_Daxpy_cptr(gpublasHandle, length, alpha, x, incx, y, incy)

      use, intrinsic :: iso_c_binding

      implicit none
      integer(kind=c_intptr_t)          :: gpublasHandle
      integer(kind=c_int)               :: length, incx, incy
      real(kind=C_DOUBLE)             :: alpha
      type(c_ptr)                       :: x, y




    end subroutine
    subroutine gpublas_Sdot_intptr(gpublasHandle, length, x, incx, y, incy, z)

      use, intrinsic :: iso_c_binding

      implicit none
      integer(kind=c_intptr_t)          :: gpublasHandle
      integer(kind=c_int)               :: length, incx, incy
      integer(kind=c_intptr_t)          :: x, y, z




    end subroutine

    subroutine gpublas_Sdot_cptr(gpublasHandle, length, x, incx, y, incy, z)

      use, intrinsic :: iso_c_binding

      implicit none
      integer(kind=c_intptr_t)          :: gpublasHandle
      integer(kind=c_int)               :: length, incx, incy
      type(c_ptr)                       :: x, y, z




    end subroutine

    subroutine gpublas_Sscal_intptr(gpublasHandle, length, alpha, x, incx)

      use, intrinsic :: iso_c_binding

      implicit none
      integer(kind=c_intptr_t)          :: gpublasHandle
      integer(kind=c_int)               :: length, incx
      real(kind=C_FLOAT)              :: alpha
      integer(kind=c_intptr_t)           :: x




    end subroutine

    subroutine gpublas_Sscal_cptr(gpublasHandle, length, alpha, x, incx)

      use, intrinsic :: iso_c_binding

      implicit none
      integer(kind=c_intptr_t)          :: gpublasHandle
      integer(kind=c_int)               :: length, incx
      real(kind=C_FLOAT)              :: alpha
      type(c_ptr)                       :: x




    end subroutine


    subroutine gpublas_Saxpy_intptr(gpublasHandle, length, alpha, x, incx, y, incy)

      use, intrinsic :: iso_c_binding

      implicit none
      integer(kind=c_intptr_t)          :: gpublasHandle
      integer(kind=c_int)               :: length, incx, incy
      real(kind=C_FLOAT)              :: alpha
      integer(kind=c_intptr_t)           :: x, y




    end subroutine

    subroutine gpublas_Saxpy_cptr(gpublasHandle, length, alpha, x, incx, y, incy)

      use, intrinsic :: iso_c_binding

      implicit none
      integer(kind=c_intptr_t)          :: gpublasHandle
      integer(kind=c_int)               :: length, incx, incy
      real(kind=C_FLOAT)              :: alpha
      type(c_ptr)                       :: x, y




    end subroutine
    subroutine gpublas_Zdot_intptr(conj, gpublasHandle, length, x, incx, y, incy, z)

      use, intrinsic :: iso_c_binding

      implicit none
      character(1,C_CHAR),value       :: conj
      integer(kind=c_intptr_t)          :: gpublasHandle
      integer(kind=c_int)               :: length, incx, incy
      integer(kind=c_intptr_t)          :: x, y, z




    end subroutine

    subroutine gpublas_Zdot_cptr(conj, gpublasHandle, length, x, incx, y, incy, z)

      use, intrinsic :: iso_c_binding

      implicit none
      character(1,C_CHAR),value       :: conj
      integer(kind=c_intptr_t)          :: gpublasHandle
      integer(kind=c_int)               :: length, incx, incy
      type(c_ptr)                       :: x, y, z




    end subroutine

    subroutine gpublas_Zscal_intptr(gpublasHandle, length, alpha, x, incx)

      use, intrinsic :: iso_c_binding

      implicit none
      integer(kind=c_intptr_t)          :: gpublasHandle
      integer(kind=c_int)               :: length, incx
      complex(kind=C_DOUBLE_COMPLEX)  :: alpha
      integer(kind=c_intptr_t)           :: x




    end subroutine

    subroutine gpublas_Zscal_cptr(gpublasHandle, length, alpha, x, incx)

      use, intrinsic :: iso_c_binding

      implicit none
      integer(kind=c_intptr_t)          :: gpublasHandle
      integer(kind=c_int)               :: length, incx
      complex(kind=C_DOUBLE_COMPLEX)  :: alpha
      type(c_ptr)                       :: x




    end subroutine


    subroutine gpublas_Zaxpy_intptr(gpublasHandle, length, alpha, x, incx, y, incy)

      use, intrinsic :: iso_c_binding

      implicit none
      integer(kind=c_intptr_t)          :: gpublasHandle
      integer(kind=c_int)               :: length, incx, incy
      complex(kind=C_DOUBLE_COMPLEX)  :: alpha
      integer(kind=c_intptr_t)           :: x, y




    end subroutine

    subroutine gpublas_Zaxpy_cptr(gpublasHandle, length, alpha, x, incx, y, incy)

      use, intrinsic :: iso_c_binding

      implicit none
      integer(kind=c_intptr_t)          :: gpublasHandle
      integer(kind=c_int)               :: length, incx, incy
      complex(kind=C_DOUBLE_COMPLEX)  :: alpha
      type(c_ptr)                       :: x, y




    end subroutine
    subroutine gpublas_Cdot_intptr(conj, gpublasHandle, length, x, incx, y, incy, z)

      use, intrinsic :: iso_c_binding

      implicit none
      character(1,C_CHAR),value       :: conj
      integer(kind=c_intptr_t)          :: gpublasHandle
      integer(kind=c_int)               :: length, incx, incy
      integer(kind=c_intptr_t)          :: x, y, z




    end subroutine

    subroutine gpublas_Cdot_cptr(conj, gpublasHandle, length, x, incx, y, incy, z)

      use, intrinsic :: iso_c_binding

      implicit none
      character(1,C_CHAR),value       :: conj
      integer(kind=c_intptr_t)          :: gpublasHandle
      integer(kind=c_int)               :: length, incx, incy
      type(c_ptr)                       :: x, y, z




    end subroutine

    subroutine gpublas_Cscal_intptr(gpublasHandle, length, alpha, x, incx)

      use, intrinsic :: iso_c_binding

      implicit none
      integer(kind=c_intptr_t)          :: gpublasHandle
      integer(kind=c_int)               :: length, incx
      complex(kind=C_FLOAT_COMPLEX)  :: alpha
      integer(kind=c_intptr_t)           :: x




    end subroutine

    subroutine gpublas_Cscal_cptr(gpublasHandle, length, alpha, x, incx)

      use, intrinsic :: iso_c_binding

      implicit none
      integer(kind=c_intptr_t)          :: gpublasHandle
      integer(kind=c_int)               :: length, incx
      complex(kind=C_FLOAT_COMPLEX)  :: alpha
      type(c_ptr)                       :: x




    end subroutine


    subroutine gpublas_Caxpy_intptr(gpublasHandle, length, alpha, x, incx, y, incy)

      use, intrinsic :: iso_c_binding

      implicit none
      integer(kind=c_intptr_t)          :: gpublasHandle
      integer(kind=c_int)               :: length, incx, incy
      complex(kind=C_FLOAT_COMPLEX)  :: alpha
      integer(kind=c_intptr_t)           :: x, y




    end subroutine

    subroutine gpublas_Caxpy_cptr(gpublasHandle, length, alpha, x, incx, y, incy)

      use, intrinsic :: iso_c_binding

      implicit none
      integer(kind=c_intptr_t)          :: gpublasHandle
      integer(kind=c_int)               :: length, incx, incy
      complex(kind=C_FLOAT_COMPLEX)  :: alpha
      type(c_ptr)                       :: x, y




    end subroutine

end module

