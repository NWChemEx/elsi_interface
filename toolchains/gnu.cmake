### GCC ###

SET(CMAKE_Fortran_COMPILER "mpifort" CACHE STRING "MPI Fortran compiler")
SET(CMAKE_C_COMPILER "mpicc" CACHE STRING "MPI C compiler")
SET(CMAKE_CXX_COMPILER "mpicxx" CACHE STRING "MPI C++ compiler")

SET(CMAKE_Fortran_FLAGS "-O3 -ffree-line-length-none -fallow-argument-mismatch" CACHE STRING "Fortran flags")
SET(CMAKE_C_FLAGS "-O3 -std=c99" CACHE STRING "C flags")
SET(CMAKE_CXX_FLAGS "-O3 -std=c++11" CACHE STRING "C++ flags")

SET(ENABLE_PEXSI ON CACHE BOOL "Enable PEXSI")
SET(ENABLE_TESTS ON CACHE BOOL "Enable Fortran tests")
SET(ENABLE_C_TESTS ON CACHE BOOL "Enable C tests")
# SET(USE_ELPA_2023 ON CACHE BOOL "ENABLE ELPA 2023")
#SET(ELPA2_KERNEL "AVX" CACHE STRING "Use AVX/AVX2/AVX512 ELPA2 kernel")

SET(LIB_PATHS "/usr/local/lib" CACHE STRING "External library paths")
SET(LIBS "libscalapack.a;liblapack.a;librefblas.a" CACHE STRING "External libraries")
