### GCC ###

SET(CMAKE_Fortran_COMPILER "mpifort" CACHE STRING "MPI Fortran compiler")
SET(CMAKE_C_COMPILER "mpicc" CACHE STRING "MPI C compiler")
SET(CMAKE_CXX_COMPILER "mpicxx" CACHE STRING "MPI C++ compiler")

SET(CMAKE_Fortran_FLAGS "-O3 -fallow-argument-mismatch" CACHE STRING "Fortran flags")
SET(CMAKE_C_FLAGS "-O3 -std=c99" CACHE STRING "C flags")
SET(CMAKE_CXX_FLAGS "-O3 -std=c++11" CACHE STRING "C++ flags")
SET(CMAKE_CUDA_FLAGS "-O3 -arch=sm_80" CACHE STRING "CUDA flags")
SET(CMAKE_CUDA_ARCHITECTURES "80" CACHE STRING "CUDA Arch")

SET(USE_GPU_CUDA ON CACHE BOOL "Use CUDA-based GPU acceleration in ELPA and ChASE")
SET(ENABLE_CHASE ON CACHE BOOL "Enable ChASE eigensolver")
SET(ENABLE_TESTS ON CACHE BOOL "Enable Fortran tests")
SET(ENABLE_C_TESTS ON CACHE BOOL "Enable C tests")

SET(LIB_PATHS "$ENV{MKLROOT}/lib/intel64 $ENV{CUDA_HOME}/lib64" CACHE STRING "External library paths")
SET(LIBS "mkl_scalapack_lp64 mkl_blacs_openmpi_lp64 mkl_gf_lp64 mkl_sequential mkl_core cublas cusolver cudart" CACHE STRING "External libraries")


