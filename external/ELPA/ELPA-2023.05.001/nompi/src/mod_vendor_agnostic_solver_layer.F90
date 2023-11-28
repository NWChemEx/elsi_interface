












module elpa_solver_gpu
  use iso_c_binding
  use elpa_general_gpu, only : use_gpu_vendor, nvidia_gpu, amd_gpu, intel_gpu, openmp_offload_gpu, sycl_gpu, no_gpu, &
                                gpu_vendor



  contains

    subroutine gpusolver_Dtrtri(uplo, diag, n, a, lda, info, handle)
      use, intrinsic :: iso_c_binding
      use cuda_functions

      implicit none
      character(1,C_CHAR),value       :: uplo, diag
      integer(kind=C_INT64_T)         :: n, lda
      integer(kind=c_intptr_t)        :: a
      integer(kind=c_int)             :: info
      integer(kind=c_intptr_t)        :: handle

      if (use_gpu_vendor == nvidia_gpu) then
        call cusolver_Dtrtri(uplo, diag, n, a, lda, info, handle)
      endif


    end subroutine

    subroutine gpusolver_Dpotrf(uplo, n, a, lda, info, handle)
      use, intrinsic :: iso_c_binding
      use cuda_functions

      implicit none
      character(1,C_CHAR),value       :: uplo
      integer(kind=C_INT)             :: n, lda
      integer(kind=c_intptr_t)        :: a
      integer(kind=c_int)             :: info
      integer(kind=c_intptr_t)        :: handle

      if (use_gpu_vendor == nvidia_gpu) then
        call cusolver_Dpotrf(uplo, n, a, lda, info, handle)
      endif


    end subroutine

    subroutine gpusolver_Strtri(uplo, diag, n, a, lda, info, handle)
      use, intrinsic :: iso_c_binding
      use cuda_functions

      implicit none
      character(1,C_CHAR),value       :: uplo, diag
      integer(kind=C_INT64_T)         :: n, lda
      integer(kind=c_intptr_t)        :: a
      integer(kind=c_int)             :: info
      integer(kind=c_intptr_t)        :: handle

      if (use_gpu_vendor == nvidia_gpu) then
        call cusolver_Strtri(uplo, diag, n, a, lda, info, handle)
      endif


    end subroutine

    subroutine gpusolver_Spotrf(uplo, n, a, lda, info, handle)
      use, intrinsic :: iso_c_binding
      use cuda_functions

      implicit none
      character(1,C_CHAR),value       :: uplo
      integer(kind=C_INT)             :: n, lda
      integer(kind=c_intptr_t)        :: a
      integer(kind=c_int)             :: info
      integer(kind=c_intptr_t)        :: handle

      if (use_gpu_vendor == nvidia_gpu) then
        call cusolver_Spotrf(uplo, n, a, lda, info, handle)
      endif


    end subroutine

    subroutine gpusolver_Ztrtri(uplo, diag, n, a, lda, info, handle)
      use, intrinsic :: iso_c_binding
      use cuda_functions

      implicit none
      character(1,C_CHAR),value       :: uplo, diag
      integer(kind=C_INT64_T)         :: n, lda
      integer(kind=c_intptr_t)        :: a
      integer(kind=c_int)             :: info
      integer(kind=c_intptr_t)        :: handle

      if (use_gpu_vendor == nvidia_gpu) then
        call cusolver_Ztrtri(uplo, diag, n, a, lda, info, handle)
      endif


    end subroutine

    subroutine gpusolver_Zpotrf(uplo, n, a, lda, info, handle)
      use, intrinsic :: iso_c_binding
      use cuda_functions

      implicit none
      character(1,C_CHAR),value       :: uplo
      integer(kind=C_INT)             :: n, lda
      integer(kind=c_intptr_t)        :: a
      integer(kind=c_int)             :: info
      integer(kind=c_intptr_t)        :: handle

      if (use_gpu_vendor == nvidia_gpu) then
        call cusolver_Zpotrf(uplo, n, a, lda, info, handle)
      endif


    end subroutine

    subroutine gpusolver_Ctrtri(uplo, diag, n, a, lda, info, handle)
      use, intrinsic :: iso_c_binding
      use cuda_functions

      implicit none
      character(1,C_CHAR),value       :: uplo, diag
      integer(kind=C_INT64_T)         :: n, lda
      integer(kind=c_intptr_t)        :: a
      integer(kind=c_int)             :: info
      integer(kind=c_intptr_t)        :: handle

      if (use_gpu_vendor == nvidia_gpu) then
        call cusolver_Ctrtri(uplo, diag, n, a, lda, info, handle)
      endif


    end subroutine

    subroutine gpusolver_Cpotrf(uplo, n, a, lda, info, handle)
      use, intrinsic :: iso_c_binding
      use cuda_functions

      implicit none
      character(1,C_CHAR),value       :: uplo
      integer(kind=C_INT)             :: n, lda
      integer(kind=c_intptr_t)        :: a
      integer(kind=c_int)             :: info
      integer(kind=c_intptr_t)        :: handle

      if (use_gpu_vendor == nvidia_gpu) then
        call cusolver_Cpotrf(uplo, n, a, lda, info, handle)
      endif


    end subroutine


end module

