### NVHPC ###

SET(CMAKE_Fortran_COMPILER "mpifort" CACHE STRING "MPI Fortran compiler")
SET(CMAKE_C_COMPILER "mpicc" CACHE STRING "MPI C compiler")
SET(CMAKE_CXX_COMPILER "mpic++" CACHE STRING "MPI C++ compiler")

SET(CMAKE_Fortran_FLAGS "-O2 -Mvect=nosimd" CACHE STRING "Fortran flags")
SET(CMAKE_C_FLAGS "-O1 -c99" CACHE STRING "C flags") # SCOTCH segfaults with "O2"
SET(CMAKE_CXX_FLAGS "-O2 --c++11 -D__GCC_ATOMIC_TEST_AND_SET_TRUEVAL=1" CACHE STRING "C++ flags")

SET(ENABLE_PEXSI ON CACHE BOOL "Enable PEXSI")
SET(ENABLE_CHASE ON CACHE BOOL "Enable ChASE eigensolver")
SET(ENABLE_TESTS ON CACHE BOOL "Enable Fortran tests")
SET(ENABLE_C_TESTS ON CACHE BOOL "Enable C tests")
# SET(USE_ELPA_2023 ON CACHE BOOL "ENABLE ELPA 2023")

SET(LIB_PATHS "$ENV{nvcompdir}/lib $ENV{nvcommdir}/openmpi/openmpi-3.1.5/lib" CACHE STRING "External library paths")
SET(LIBS "scalapack lapack blas" CACHE STRING "External libraries")

SET(MPIEXEC_1P "mpirun --allow-run-as-root --mca io romio314 -n 1" CACHE STRING "Command to run serial tests with 1 MPI task")
SET(MPIEXEC_NP "mpirun --allow-run-as-root --mca io romio314 -n 4" CACHE STRING "Command to run parallel tests with multiple MPI tasks")
