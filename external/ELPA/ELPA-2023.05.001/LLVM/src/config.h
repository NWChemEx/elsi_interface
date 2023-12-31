/* Copyright 2014 - 2023, A. Marek */

/*     This file is part of ELPA. */

/*     The ELPA library was originally created by the ELPA consortium, */
/*     consisting of the following organizations: */

/*     - Max Planck Computing and Data Facility (MPCDF), formerly known as */
/*       Rechenzentrum Garching der Max-Planck-Gesellschaft (RZG), */
/*     - Bergische Universität Wuppertal, Lehrstuhl für angewandte */
/*       Informatik, */
/*     - Technische Universität München, Lehrstuhl für Informatik mit */
/*       Schwerpunkt Wissenschaftliches Rechnen , */
/*     - Fritz-Haber-Institut, Berlin, Abt. Theorie, */
/*     - Max-Plack-Institut für Mathematik in den Naturwissenschaften, */
/*       Leipzig, Abt. Komplexe Strukutren in Biologie und Kognition, */
/*       and */
/*     - IBM Deutschland GmbH */


/*     More information can be found here: */
/*     http://elpa.mpcdf.mpg.de/ */

/*     ELPA is free software: you can redistribute it and/or modify */
/*     it under the terms of the version 3 of the license of the */
/*     GNU Lesser General Public License as published by the Free */
/*     Software Foundation. */

/*     ELPA is distributed in the hope that it will be useful, */
/*     but WITHOUT ANY WARRANTY; without even the implied warranty of */
/*     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the */
/*     GNU Lesser General Public License for more details. */

/*     You should have received a copy of the GNU Lesser General Public License */
/*     along with ELPA.  If not, see <http://www.gnu.org/licenses/> */

/*     ELPA reflects a substantial effort on the part of the original */
/*     ELPA consortium, and we ask you to respect the spirit of the */
/*     license that we chose: i.e., please contribute any changes you */
/*     may have back to the original ELPA library distribution, and keep */
/*     any derivatives of ELPA under the same license that we chose for */
/*     the original distribution, the GNU Lesser General Public License. */

/*  Author: Andreas Marek, MPCDF */
/*  This file is the generated version. Do NOT edit */



/* config.h.  Generated from config.h.in by configure.  */
/* config.h.in.  Generated from configure.ac by autoheader.  */

/* ELPA can at runtime limit the number of OpenMP threads to 1 if needed */
/* #undef ALLOW_THREAD_LIMITING */

/* use blocking in trans_ev_band_to_full */
#define BAND_TO_FULL_BLOCKING 1

/* build for FUGAKU */
/* #undef BUILD_FUGAKU */

/* build for K-Computer */
/* #undef BUILD_KCOMPUTER */

/* build for SX-Aurora */
/* #undef BUILD_SXAURORA */

/* "Current ELPA API version" */
#define CURRENT_API_VERSION 20231705

/* "Current ELPA autotune version" */
#define CURRENT_AUTOTUNE_VERSION 20231705

/* "disable use AMD GPU in C-headers" */
#define CURRENT_WITH_AMD_GPU_VERSION 0

/* "disable use NVIDIA GPU in C-headers" */
#define CURRENT_WITH_NVIDIA_GPU_VERSION 0

/* "disable use SYCL GPU in C-headers" */
#define CURRENT_WITH_SYCL_GPU_VERSION 0

/* enable CUDA debugging */
/* #undef DEBUG_CUDA */

/* Earliest supported ELPA API version */
#define EARLIEST_API_VERSION 20170403

/* Earliest ELPA API version, which supports autotuning */
#define EARLIEST_AUTOTUNE_VERSION 20171201

/* "Time of build" */
#define ELPA_BUILDTIME 1697654807

/* enable autotuning functionality */
#define ENABLE_AUTOTUNING 1

/* enable C++ tests */
#define ENABLE_CPP_TESTS 1

/* enable C tests */
#define ENABLE_C_TESTS 1

/* enable ifx compiler builds */
/* #undef ENABLE_IFX_COMPILER */

/* allow to link against the 64bit integer versions of math libraries */
/* #undef HAVE_64BIT_INTEGER_MATH_SUPPORT */

/* allow to link against the 64bit integer versions of the MPI library */
/* #undef HAVE_64BIT_INTEGER_MPI_SUPPORT */

/* Define to 1 to support Advanced Bit Manipulation */
/* #undef HAVE_ABM */

/* Define to 1 to support Multi-Precision Add-Carry Instruction Extensions */
#define HAVE_ADX 1

/* Define to 1 to support Advanced Encryption Standard New Instruction Set
   (AES-NI) */
#define HAVE_AES 1

/* Support Altivec instructions */
/* #undef HAVE_ALTIVEC */

/* AVX is supported on this CPU */
#define HAVE_AVX 1

/* AVX2 is supported on this CPU */
#define HAVE_AVX2 1

/* AVX512 is supported on this CPU */
/* #undef HAVE_AVX512 */

/* Define to 1 to support AVX-512 Byte and Word Instructions */
#define HAVE_AVX512_BW 1

/* Define to 1 to support AVX-512 Conflict Detection Instructions */
#define HAVE_AVX512_CD 1

/* Define to 1 to support AVX-512 Doubleword and Quadword Instructions */
#define HAVE_AVX512_DQ 1

/* Define to 1 to support AVX-512 Exponential & Reciprocal Instructions */
/* #undef HAVE_AVX512_ER */

/* Define to 1 to support AVX-512 Foundation Extensions */
#define HAVE_AVX512_F 1

/* Define to 1 to support AVX-512 Integer Fused Multiply Add Instructions */
/* #undef HAVE_AVX512_IFMA */

/* Define to 1 to support AVX-512 Conflict Prefetch Instructions */
/* #undef HAVE_AVX512_PF */

/* Define to 1 to support AVX-512 Vector Byte Manipulation Instructions */
/* #undef HAVE_AVX512_VBMI */

/* Define to 1 to support AVX-512 Vector Length Extensions */
#define HAVE_AVX512_VL 1

/* AVX512 for Xeon is supported on this CPU */
/* #undef HAVE_AVX512_XEON */

/* AVX512 for Xeon-PHI is supported on this CPU */
/* #undef HAVE_AVX512_XEON_PHI */

/* Define to 1 to support Bit Manipulation Instruction Set 1 */
#define HAVE_BMI1 1

/* Define to 1 to support Bit Manipulation Instruction Set 2 */
#define HAVE_BMI2 1

/* define if the compiler supports basic C++17 syntax */
#define HAVE_CXX17 1

/* Enable more timing */
#define HAVE_DETAILED_TIMINGS 1

/* Define to 1 if you have the <dlfcn.h> header file. */
/* #undef HAVE_DLFCN_H */

/* Fortran can query environment variables */
#define HAVE_ENVIRONMENT_CHECKING 1

/* Define to 1 to support Fused Multiply-Add Extensions 3 */
#define HAVE_FMA3 1

/* Define to 1 to support Fused Multiply-Add Extensions 4 */
/* #undef HAVE_FMA4 */

/* automatically support clusters with different Intel CPUs */
/* #undef HAVE_HETEROGENOUS_CLUSTER_SUPPORT */

/* Define to 1 if you have the <inttypes.h> header file. */
#define HAVE_INTTYPES_H 1

/* can use module iso_fortran_env */
#define HAVE_ISO_FORTRAN_ENV 1

/* Use the PAPI library */
/* #undef HAVE_LIBPAPI */

/* Use likwid */
/* #undef HAVE_LIKWID */

/* Define to 1 to support Multimedia Extensions */
#define HAVE_MMX 1

/* can use the Fortran mpi module */
/* #undef HAVE_MPI_MODULE */

/* Define to 1 to support Memory Protection Extensions */
#define HAVE_MPX 1

/* NEON_ARCH64 intrinsics are supported on this CPU */
/* #undef HAVE_NEON_ARCH64_SSE */

/* Define to 1 to support Prefetch Vector Data Into Caches WT1 */
/* #undef HAVE_PREFETCHWT1 */

/* Define to 1 to support Digital Random Number Generator */
#define HAVE_RDRND 1

/* Redirect stdout and stderr of test programs per MPI tasks to a file */
/* #undef HAVE_REDIRECT */

/* Define to 1 to support Secure Hash Algorithm Extension */
/* #undef HAVE_SHA */

/* build for skewsyemmtric case */
#define HAVE_SKEWSYMMETRIC 1

/* SPARC64 intrinsics are supported on this CPU */
/* #undef HAVE_SPARC64_SSE */

/* Define to 1 to support Streaming SIMD Extensions */
#define HAVE_SSE 1

/* Define to 1 to support Streaming SIMD Extensions */
#define HAVE_SSE2 1

/* Define to 1 to support Streaming SIMD Extensions 3 */
#define HAVE_SSE3 1

/* Define to 1 to support Streaming SIMD Extensions 4.1 */
#define HAVE_SSE4_1 1

/* Define to 1 to support Streaming SIMD Extensions 4.2 */
#define HAVE_SSE4_2 1

/* Define to 1 to support AMD Streaming SIMD Extensions 4a */
/* #undef HAVE_SSE4a */

/* gcc intrinsics SSE is supported on this CPU */
/* #undef HAVE_SSE_INTRINSICS */

/* Define to 1 to support Supplemental Streaming SIMD Extensions 3 */
#define HAVE_SSSE3 1

/* Define to 1 if you have the <stdint.h> header file. */
#define HAVE_STDINT_H 1

/* Define to 1 if you have the <stdio.h> header file. */
#define HAVE_STDIO_H 1

/* Define to 1 if you have the <stdlib.h> header file. */
#define HAVE_STDLIB_H 1

/* Define to 1 if you have the <strings.h> header file. */
#define HAVE_STRINGS_H 1

/* Define to 1 if you have the <string.h> header file. */
#define HAVE_STRING_H 1

/* MPI threading support is sufficient */
/* #undef HAVE_SUFFICIENT_MPI_THREADING_SUPPORT */

/* SVE128 is supported on this CPU */
/* #undef HAVE_SVE128 */

/* SVE256 is supported on this CPU */
/* #undef HAVE_SVE256 */

/* SVE512 is supported on this CPU */
/* #undef HAVE_SVE512 */

/* Define to 1 if you have the <sys/stat.h> header file. */
#define HAVE_SYS_STAT_H 1

/* Define to 1 if you have the <sys/types.h> header file. */
#define HAVE_SYS_TYPES_H 1

/* Define to 1 if you have the <unistd.h> header file. */
#define HAVE_UNISTD_H 1

/* Support VSX instructions */
/* #undef HAVE_VSX */

/* Altivec VSX intrinsics are supported on this CPU */
#define HAVE_VSX_SSE 1

/* Define to 1 to support eXtended Operations Extensions */
/* #undef HAVE_XOP */

/* use hipblas instead of rocblas */
/* #undef HIPBLAS */

/* use blocking in loops */
/* #undef LOOP_BLOCKING */

/* Define to the sub-directory where libtool stores uninstalled libraries. */
#define LT_OBJDIR ".libs/"

/* need not to append an underscore */
/* #undef NEED_NO_UNDERSCORE_TO_LINK_AGAINST_FORTRAN */

/* need to append an underscore */
/* #undef NEED_UNDERSCORE_TO_LINK_AGAINST_FORTRAN */

/* enable error argument in C-API to be optional */
/* #undef OPTIONAL_C_ERROR_ARGUMENT */

/* Name of package */
#define PACKAGE "elpa"

/* Define to the address where bug reports for this package should be sent. */
#define PACKAGE_BUGREPORT "elpa-library@mpcdf.mpg.de"

/* Define to the full name of this package. */
#define PACKAGE_NAME "elpa"

/* Define to the full name and version of this package. */
#define PACKAGE_STRING "elpa 2023.05.001"

/* Define to the one symbol short name of this package. */
#define PACKAGE_TARNAME "elpa"

/* Define to the home page for this package. */
#define PACKAGE_URL ""

/* Define to the version of this package. */
#define PACKAGE_VERSION "2023.05.001"

/* In some kernels pack real to complex */
#define PACK_REAL_TO_COMPLEX 1

/* Work around a PGI bug with variable-length string results */
/* #undef PGI_VARIABLE_STRING_BUG */

/* enable matrix re-distribution during autotuning */
/* #undef REDISTRIBUTE_MATRIX */

/* The size of `long int', as computed by sizeof. */
#define SIZEOF_LONG_INT 8

/* Define to 1 if all of the C90 standard headers exist (not just the ones
   required in a freestanding environment). This macro is provided for
   backward compatibility; new code need not use it. */
#define STDC_HEADERS 1

/* compile build config into the library object */
/* #undef STORE_BUILD_CONFIG */

/* can check at runtime the threading support level of MPI */
/* #undef THREADING_SUPPORT_CHECK */

/* for performance reasons use assumed size Fortran arrays, even if not
   debuggable */
#define USE_ASSUMED_SIZE 1

/* use some Fortran 2008 features */
#define USE_FORTRAN2008 1

/* Version number of package */
#define VERSION "2023.05.001"

/* build also single-precision for complex calculation */
#define WANT_SINGLE_PRECISION_COMPLEX 1

/* build also single-precision for real calculation */
#define WANT_SINGLE_PRECISION_REAL 1

/* AMD GPU kernel should be build */
/* #undef WITH_AMD_GPU_KERNEL */

/* enable AMD GPU support */
/* #undef WITH_AMD_GPU_VERSION */

/* enable AMD rocsolver */
/* #undef WITH_AMD_ROCSOLVER */

/* Build elpa_m4_kernel kernel */
/* #undef WITH_COMPLEX_AMD_GPU_KERNEL */

/* Build elpa_m4_kernel kernel */
/* #undef WITH_COMPLEX_AVX2_BLOCK1_KERNEL */

/* Build elpa_m4_kernel kernel */
/* #undef WITH_COMPLEX_AVX2_BLOCK2_KERNEL */

/* Build elpa_m4_kernel kernel */
/* #undef WITH_COMPLEX_AVX512_BLOCK1_KERNEL */

/* Build elpa_m4_kernel kernel */
/* #undef WITH_COMPLEX_AVX512_BLOCK2_KERNEL */

/* Build elpa_m4_kernel kernel */
/* #undef WITH_COMPLEX_AVX_BLOCK1_KERNEL */

/* Build elpa_m4_kernel kernel */
/* #undef WITH_COMPLEX_AVX_BLOCK2_KERNEL */

/* Build elpa_m4_kernel kernel */
/* #undef WITH_COMPLEX_BGP_KERNEL */

/* Build elpa_m4_kernel kernel */
/* #undef WITH_COMPLEX_BGQ_KERNEL */

/* Build elpa_m4_kernel kernel */
#define WITH_COMPLEX_GENERIC_KERNEL 1

/* Build elpa_m4_kernel kernel */
/* #undef WITH_COMPLEX_GENERIC_SIMPLE_KERNEL */

/* Build elpa_m4_kernel kernel */
/* #undef WITH_COMPLEX_INTEL_GPU_SYCL_KERNEL */

/* Build elpa_m4_kernel kernel */
/* #undef WITH_COMPLEX_NEON_ARCH64_BLOCK1_KERNEL */

/* Build elpa_m4_kernel kernel */
/* #undef WITH_COMPLEX_NEON_ARCH64_BLOCK2_KERNEL */

/* Build elpa_m4_kernel kernel */
/* #undef WITH_COMPLEX_NVIDIA_GPU_KERNEL */

/* Build elpa_m4_kernel kernel */
/* #undef WITH_COMPLEX_NVIDIA_SM80_GPU_KERNEL */

/* Build elpa_m4_kernel kernel */
/* #undef WITH_COMPLEX_SSE_ASSEMBLY_KERNEL */

/* Build elpa_m4_kernel kernel */
/* #undef WITH_COMPLEX_SSE_BLOCK1_KERNEL */

/* Build elpa_m4_kernel kernel */
/* #undef WITH_COMPLEX_SSE_BLOCK2_KERNEL */

/* Build elpa_m4_kernel kernel */
/* #undef WITH_COMPLEX_SVE128_BLOCK1_KERNEL */

/* Build elpa_m4_kernel kernel */
/* #undef WITH_COMPLEX_SVE128_BLOCK2_KERNEL */

/* Build elpa_m4_kernel kernel */
/* #undef WITH_COMPLEX_SVE256_BLOCK1_KERNEL */

/* Build elpa_m4_kernel kernel */
/* #undef WITH_COMPLEX_SVE256_BLOCK2_KERNEL */

/* Build elpa_m4_kernel kernel */
/* #undef WITH_COMPLEX_SVE512_BLOCK1_KERNEL */

/* Build elpa_m4_kernel kernel */
/* #undef WITH_COMPLEX_SVE512_BLOCK2_KERNEL */

/* use cucub library in some kernels */
/* #undef WITH_CUCUB */

/* enable CUDA-aware MPI */
/* #undef WITH_CUDA_AWARE_MPI */

/* use only one specific complex kernel (set at compile time) */
#define WITH_FIXED_COMPLEX_KERNEL 1

/* use only one specific real kernel (set at compile time) */
#define WITH_FIXED_REAL_KERNEL 1

/* enable streams in GPU code */
/* #undef WITH_GPU_STREAMS */

/* use hipcub library in some kernels */
/* #undef WITH_HIPCUB */

/* use MPI */
#define WITH_MPI 1

/* enable CUDA cusolver */
/* #undef WITH_NVIDIA_CUSOLVER */

/* Nvidia GPU kernel should be build */
/* #undef WITH_NVIDIA_GPU_KERNEL */

/* the NVIDIA GPU kernels for A100 can be used */
/* #undef WITH_NVIDIA_GPU_SM80_COMPUTE_CAPABILITY */

/* enable Nvidia GPU support */
/* #undef WITH_NVIDIA_GPU_VERSION */

/* enable usage of NVIDIA NCCL */
/* #undef WITH_NVIDIA_NCCL */

/* Nvidia sm_80 GPU kernel should be build */
/* #undef WITH_NVIDIA_SM80_GPU_KERNEL */

/* enable NVTX support */
/* #undef WITH_NVTX */

/* enable INTEL GPU support via OpenMP backend */
/* #undef WITH_OPENMP_OFFLOAD_GPU_VERSION */

/* use OpenMP threading */
/* #undef WITH_OPENMP_TRADITIONAL */

/* build and install python wrapper */
/* #undef WITH_PYTHON */

/* Build elpa_m4_kernel kernel */
/* #undef WITH_REAL_AMD_GPU_KERNEL */

/* Build elpa_m4_kernel kernel */
/* #undef WITH_REAL_AVX2_BLOCK2_KERNEL */

/* Build elpa_m4_kernel kernel */
/* #undef WITH_REAL_AVX2_BLOCK4_KERNEL */

/* Build elpa_m4_kernel kernel */
/* #undef WITH_REAL_AVX2_BLOCK6_KERNEL */

/* Build elpa_m4_kernel kernel */
/* #undef WITH_REAL_AVX512_BLOCK2_KERNEL */

/* Build elpa_m4_kernel kernel */
/* #undef WITH_REAL_AVX512_BLOCK4_KERNEL */

/* Build elpa_m4_kernel kernel */
/* #undef WITH_REAL_AVX512_BLOCK6_KERNEL */

/* Build elpa_m4_kernel kernel */
/* #undef WITH_REAL_AVX_BLOCK2_KERNEL */

/* Build elpa_m4_kernel kernel */
/* #undef WITH_REAL_AVX_BLOCK4_KERNEL */

/* Build elpa_m4_kernel kernel */
/* #undef WITH_REAL_AVX_BLOCK6_KERNEL */

/* Build elpa_m4_kernel kernel */
/* #undef WITH_REAL_BGP_KERNEL */

/* Build elpa_m4_kernel kernel */
/* #undef WITH_REAL_BGQ_KERNEL */

/* Build elpa_m4_kernel kernel */
#define WITH_REAL_GENERIC_KERNEL 1

/* Build elpa_m4_kernel kernel */
/* #undef WITH_REAL_GENERIC_SIMPLE_BLOCK4_KERNEL */

/* Build elpa_m4_kernel kernel */
/* #undef WITH_REAL_GENERIC_SIMPLE_BLOCK6_KERNEL */

/* Build elpa_m4_kernel kernel */
/* #undef WITH_REAL_GENERIC_SIMPLE_KERNEL */

/* Build elpa_m4_kernel kernel */
/* #undef WITH_REAL_INTEL_GPU_SYCL_KERNEL */

/* Build elpa_m4_kernel kernel */
/* #undef WITH_REAL_NEON_ARCH64_BLOCK2_KERNEL */

/* Build elpa_m4_kernel kernel */
/* #undef WITH_REAL_NEON_ARCH64_BLOCK4_KERNEL */

/* Build elpa_m4_kernel kernel */
/* #undef WITH_REAL_NEON_ARCH64_BLOCK6_KERNEL */

/* Build elpa_m4_kernel kernel */
/* #undef WITH_REAL_NVIDIA_GPU_KERNEL */

/* Build elpa_m4_kernel kernel */
/* #undef WITH_REAL_NVIDIA_SM80_GPU_KERNEL */

/* Build elpa_m4_kernel kernel */
/* #undef WITH_REAL_SPARC64_BLOCK2_KERNEL */

/* Build elpa_m4_kernel kernel */
/* #undef WITH_REAL_SPARC64_BLOCK4_KERNEL */

/* Build elpa_m4_kernel kernel */
/* #undef WITH_REAL_SPARC64_BLOCK6_KERNEL */

/* Build elpa_m4_kernel kernel */
/* #undef WITH_REAL_SSE_ASSEMBLY_KERNEL */

/* Build elpa_m4_kernel kernel */
/* #undef WITH_REAL_SSE_BLOCK2_KERNEL */

/* Build elpa_m4_kernel kernel */
/* #undef WITH_REAL_SSE_BLOCK4_KERNEL */

/* Build elpa_m4_kernel kernel */
/* #undef WITH_REAL_SSE_BLOCK6_KERNEL */

/* Build elpa_m4_kernel kernel */
/* #undef WITH_REAL_SVE128_BLOCK2_KERNEL */

/* Build elpa_m4_kernel kernel */
/* #undef WITH_REAL_SVE128_BLOCK4_KERNEL */

/* Build elpa_m4_kernel kernel */
/* #undef WITH_REAL_SVE128_BLOCK6_KERNEL */

/* Build elpa_m4_kernel kernel */
/* #undef WITH_REAL_SVE256_BLOCK2_KERNEL */

/* Build elpa_m4_kernel kernel */
/* #undef WITH_REAL_SVE256_BLOCK4_KERNEL */

/* Build elpa_m4_kernel kernel */
/* #undef WITH_REAL_SVE256_BLOCK6_KERNEL */

/* Build elpa_m4_kernel kernel */
/* #undef WITH_REAL_SVE512_BLOCK2_KERNEL */

/* Build elpa_m4_kernel kernel */
/* #undef WITH_REAL_SVE512_BLOCK4_KERNEL */

/* Build elpa_m4_kernel kernel */
/* #undef WITH_REAL_SVE512_BLOCK6_KERNEL */

/* Build elpa_m4_kernel kernel */
/* #undef WITH_REAL_VSX_BLOCK2_KERNEL */

/* Build elpa_m4_kernel kernel */
/* #undef WITH_REAL_VSX_BLOCK4_KERNEL */

/* Build elpa_m4_kernel kernel */
/* #undef WITH_REAL_VSX_BLOCK6_KERNEL */

/* build SCALAPACK test cases */
/* #undef WITH_SCALAPACK_TESTS */

/* enable INTEL GPU support via SYCL backend */
/* #undef WITH_SYCL_GPU_VERSION */
