### Intel ###

SET(CMAKE_Fortran_COMPILER "mpiifort" CACHE STRING "MPI Fortran compiler")
SET(CMAKE_C_COMPILER "mpiicc" CACHE STRING "MPI C compiler")
SET(CMAKE_CXX_COMPILER "mpiicpc" CACHE STRING "MPI C++ compiler")

SET(CMAKE_Fortran_FLAGS "-O3 -ip -fp-model precise" CACHE STRING "Fortran flags")
SET(CMAKE_C_FLAGS "-O3 -ip -fp-model precise -std=c99" CACHE STRING "C flags")
SET(CMAKE_CXX_FLAGS "-O3 -ip -fp-model precise -std=c++11" CACHE STRING "C++ flags")

SET(ENABLE_PEXSI ON CACHE BOOL "Enable PEXSI")
SET(ENABLE_CHASE OFF CACHE BOOL "Enable ChASE eigensolver")
SET(CHASE_OUTPUT ON CACHE BOOL "Enable ChASE solver with output")
SET(ENABLE_TESTS ON CACHE BOOL "Enable Fortran tests")
SET(ENABLE_C_TESTS ON CACHE BOOL "Enable C tests")
# SET(USE_ELPA_2023 ON CACHE BOOL "ENABLE ELPA 2023")
#SET(ELPA2_KERNEL "AVX" CACHE STRING "Use AVX/AVX2/AVX512 ELPA2 kernel")

SET(LIB_PATHS "$ENV{MKLROOT}/lib/intel64" CACHE STRING "External library paths")
SET(LIBS "mkl_scalapack_lp64 mkl_blacs_intelmpi_lp64 mkl_intel_lp64 mkl_sequential mkl_core" CACHE STRING "External libraries")
