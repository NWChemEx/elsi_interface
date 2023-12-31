#pragma once

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



/* This might seem over-engineered, but helps to re-use this file also on the
 * Fortran side and thus to keep the definitions in this one place here
 */

/* Private helper macros */
#define ELPA_ENUM_ENTRY(name, value, ...) \
        name = value,
#define ELPA_ENUM_SUM(name, value, ...) +1

/* MATRIX layout */
#define ELPA_FOR_ALL_MATRIX_LAYOUTS(X) \
	X(COLUMN_MAJOR_ORDER, 1) \
	X(ROW_MAJOR_ORDER, 2)

enum MATRIX_LAYOUTS {
	ELPA_FOR_ALL_MATRIX_LAYOUTS(ELPA_ENUM_ENTRY)
};

#define ELPA_NUMBER_OF_MATRIX_LAYOUTS (0 ELPA_FOR_ALL_MATRIX_LAYOUTS(ELPA_ENUM_SUM))

/* Solver constants */
#define ELPA_FOR_ALL_SOLVERS(X) \
        X(ELPA_SOLVER_1STAGE, 1) \
        X(ELPA_SOLVER_2STAGE, 2)

enum ELPA_SOLVERS {
        ELPA_FOR_ALL_SOLVERS(ELPA_ENUM_ENTRY)
};

#define ELPA_NUMBER_OF_SOLVERS (0 ELPA_FOR_ALL_SOLVERS(ELPA_ENUM_SUM))

/* Kernel constants */
#define ELPA_FOR_ALL_2STAGE_REAL_KERNELS(X, ...) \
        X(ELPA_2STAGE_REAL_GENERIC, 1, 1, __VA_ARGS__) \
        X(ELPA_2STAGE_REAL_GENERIC_SIMPLE, 2, 0, __VA_ARGS__) \
        X(ELPA_2STAGE_REAL_BGP, 3, 0, __VA_ARGS__) \
        X(ELPA_2STAGE_REAL_BGQ, 4, 0, __VA_ARGS__) \
        X(ELPA_2STAGE_REAL_SSE_ASSEMBLY, 5, 0, __VA_ARGS__) \
        X(ELPA_2STAGE_REAL_SSE_BLOCK2, 6, 0, __VA_ARGS__) \
        X(ELPA_2STAGE_REAL_SSE_BLOCK4, 7, 0, __VA_ARGS__) \
        X(ELPA_2STAGE_REAL_SSE_BLOCK6, 8, 0, __VA_ARGS__) \
        X(ELPA_2STAGE_REAL_AVX_BLOCK2, 9, 0, __VA_ARGS__) \
        X(ELPA_2STAGE_REAL_AVX_BLOCK4, 10, 0, __VA_ARGS__) \
        X(ELPA_2STAGE_REAL_AVX_BLOCK6, 11, 0, __VA_ARGS__) \
        X(ELPA_2STAGE_REAL_AVX2_BLOCK2, 12, 0, __VA_ARGS__) \
        X(ELPA_2STAGE_REAL_AVX2_BLOCK4, 13, 0, __VA_ARGS__) \
        X(ELPA_2STAGE_REAL_AVX2_BLOCK6, 14, 0, __VA_ARGS__) \
        X(ELPA_2STAGE_REAL_AVX512_BLOCK2, 15, 0, __VA_ARGS__) \
        X(ELPA_2STAGE_REAL_AVX512_BLOCK4, 16, 0, __VA_ARGS__) \
        X(ELPA_2STAGE_REAL_AVX512_BLOCK6, 17, 0, __VA_ARGS__) \
        X(ELPA_2STAGE_REAL_NVIDIA_GPU, 18, 0, __VA_ARGS__) \
        X(ELPA_2STAGE_REAL_AMD_GPU, 19, 0, __VA_ARGS__) \
        X(ELPA_2STAGE_REAL_INTEL_GPU_SYCL, 20, 0, __VA_ARGS__) \
        X(ELPA_2STAGE_REAL_SPARC64_BLOCK2, 21, 0, __VA_ARGS__) \
        X(ELPA_2STAGE_REAL_SPARC64_BLOCK4, 22, 0, __VA_ARGS__) \
        X(ELPA_2STAGE_REAL_SPARC64_BLOCK6, 23, 0, __VA_ARGS__) \
        X(ELPA_2STAGE_REAL_NEON_ARCH64_BLOCK2, 24, 0, __VA_ARGS__) \
        X(ELPA_2STAGE_REAL_NEON_ARCH64_BLOCK4, 25, 0, __VA_ARGS__) \
        X(ELPA_2STAGE_REAL_NEON_ARCH64_BLOCK6, 26, 0, __VA_ARGS__) \
        X(ELPA_2STAGE_REAL_VSX_BLOCK2, 27, 0, __VA_ARGS__) \
        X(ELPA_2STAGE_REAL_VSX_BLOCK4, 28, 0, __VA_ARGS__) \
        X(ELPA_2STAGE_REAL_VSX_BLOCK6, 29, 0, __VA_ARGS__) \
        X(ELPA_2STAGE_REAL_SVE128_BLOCK2, 30, 0, __VA_ARGS__) \
        X(ELPA_2STAGE_REAL_SVE128_BLOCK4, 31, 0, __VA_ARGS__) \
        X(ELPA_2STAGE_REAL_SVE128_BLOCK6, 32, 0, __VA_ARGS__) \
        X(ELPA_2STAGE_REAL_SVE256_BLOCK2, 33, 0, __VA_ARGS__) \
        X(ELPA_2STAGE_REAL_SVE256_BLOCK4, 34, 0, __VA_ARGS__) \
        X(ELPA_2STAGE_REAL_SVE256_BLOCK6, 35, 0, __VA_ARGS__) \
        X(ELPA_2STAGE_REAL_SVE512_BLOCK2, 36, 0, __VA_ARGS__) \
        X(ELPA_2STAGE_REAL_SVE512_BLOCK4, 37, 0, __VA_ARGS__) \
        X(ELPA_2STAGE_REAL_SVE512_BLOCK6, 38, 0, __VA_ARGS__) \
        X(ELPA_2STAGE_REAL_GENERIC_SIMPLE_BLOCK4, 39, 0, __VA_ARGS__) \
        X(ELPA_2STAGE_REAL_GENERIC_SIMPLE_BLOCK6, 40, 0, __VA_ARGS__) \
        X(ELPA_2STAGE_REAL_NVIDIA_SM80_GPU, 41, 0, __VA_ARGS__)

#define ELPA_FOR_ALL_2STAGE_REAL_KERNELS_AND_DEFAULT(X) \
        ELPA_FOR_ALL_2STAGE_REAL_KERNELS(X) \
        X(ELPA_2STAGE_REAL_INVALID, -1, choke me) \
        X(ELPA_2STAGE_REAL_DEFAULT, 1, choke me)

enum ELPA_REAL_KERNELS {
        ELPA_FOR_ALL_2STAGE_REAL_KERNELS_AND_DEFAULT(ELPA_ENUM_ENTRY)
};


#define ELPA_FOR_ALL_2STAGE_COMPLEX_KERNELS(X, ...) \
        X(ELPA_2STAGE_COMPLEX_GENERIC, 1, 1, __VA_ARGS__) \
        X(ELPA_2STAGE_COMPLEX_GENERIC_SIMPLE, 2, 0, __VA_ARGS__) \
        X(ELPA_2STAGE_COMPLEX_BGP, 3, 0, __VA_ARGS__) \
        X(ELPA_2STAGE_COMPLEX_BGQ, 4, 0, __VA_ARGS__) \
        X(ELPA_2STAGE_COMPLEX_SSE_ASSEMBLY, 5, 0, __VA_ARGS__) \
        X(ELPA_2STAGE_COMPLEX_SSE_BLOCK1, 6, 0, __VA_ARGS__) \
        X(ELPA_2STAGE_COMPLEX_SSE_BLOCK2, 7, 0, __VA_ARGS__) \
        X(ELPA_2STAGE_COMPLEX_AVX_BLOCK1, 8, 0, __VA_ARGS__) \
        X(ELPA_2STAGE_COMPLEX_AVX_BLOCK2, 9, 0, __VA_ARGS__) \
        X(ELPA_2STAGE_COMPLEX_AVX2_BLOCK1, 10, 0, __VA_ARGS__) \
        X(ELPA_2STAGE_COMPLEX_AVX2_BLOCK2, 11, 0, __VA_ARGS__) \
        X(ELPA_2STAGE_COMPLEX_AVX512_BLOCK1, 12, 0, __VA_ARGS__) \
        X(ELPA_2STAGE_COMPLEX_AVX512_BLOCK2, 13, 0, __VA_ARGS__) \
        X(ELPA_2STAGE_COMPLEX_SVE128_BLOCK1, 14, 0, __VA_ARGS__) \
        X(ELPA_2STAGE_COMPLEX_SVE128_BLOCK2, 15, 0, __VA_ARGS__) \
        X(ELPA_2STAGE_COMPLEX_SVE256_BLOCK1, 16, 0, __VA_ARGS__) \
        X(ELPA_2STAGE_COMPLEX_SVE256_BLOCK2, 17, 0, __VA_ARGS__) \
        X(ELPA_2STAGE_COMPLEX_SVE512_BLOCK1, 18, 0, __VA_ARGS__) \
        X(ELPA_2STAGE_COMPLEX_SVE512_BLOCK2, 19, 0, __VA_ARGS__) \
        X(ELPA_2STAGE_COMPLEX_NEON_ARCH64_BLOCK1, 20, 0, __VA_ARGS__) \
        X(ELPA_2STAGE_COMPLEX_NEON_ARCH64_BLOCK2, 21, 0, __VA_ARGS__) \
        X(ELPA_2STAGE_COMPLEX_NVIDIA_GPU, 22, 0, __VA_ARGS__) \
        X(ELPA_2STAGE_COMPLEX_AMD_GPU, 23, 0, __VA_ARGS__) \
        X(ELPA_2STAGE_COMPLEX_INTEL_GPU_SYCL, 24, 0, __VA_ARGS__) \
        X(ELPA_2STAGE_COMPLEX_NVIDIA_SM80_GPU, 25, 0, __VA_ARGS__)

#define ELPA_FOR_ALL_2STAGE_COMPLEX_KERNELS_AND_DEFAULT(X) \
        ELPA_FOR_ALL_2STAGE_COMPLEX_KERNELS(X) \
        X(ELPA_2STAGE_COMPLEX_INVALID, -1, choke me) \
        X(ELPA_2STAGE_COMPLEX_DEFAULT, 1, choke me)

enum ELPA_COMPLEX_KERNELS {
        ELPA_FOR_ALL_2STAGE_COMPLEX_KERNELS_AND_DEFAULT(ELPA_ENUM_ENTRY)
};



/* General constants */
#define ELPA_FOR_ALL_ERRORS(X) \
        X(ELPA_OK, 0) \
        X(ELPA_ERROR, -1) \
        X(ELPA_ERROR_ENTRY_NOT_FOUND, -2) \
        X(ELPA_ERROR_ENTRY_INVALID_VALUE, -3) \
        X(ELPA_ERROR_ENTRY_ALREADY_SET, -4) \
        X(ELPA_ERROR_ENTRY_NO_STRING_REPRESENTATION, -5) \
        X(ELPA_ERROR_SETUP, -6) \
        X(ELPA_ERROR_CRITICAL, -7) \
        X(ELPA_ERROR_API_VERSION, -8) \
        X(ELPA_ERROR_AUTOTUNE_API_VERSION, -9) \
        X(ELPA_ERROR_AUTOTUNE_OBJECT_CHANGED, -10) \
        X(ELPA_ERROR_ENTRY_READONLY, -11) \
        X(ELPA_ERROR_CANNOT_OPEN_FILE, -12) \
        X(ELPA_ERROR_DURING_COMPUTATION, -13) \


enum ELPA_ERRORS {
        ELPA_FOR_ALL_ERRORS(ELPA_ENUM_ENTRY)
};

enum ELPA_CONSTANTS {
        ELPA_2STAGE_NUMBER_OF_COMPLEX_KERNELS = (0 ELPA_FOR_ALL_2STAGE_COMPLEX_KERNELS(ELPA_ENUM_SUM)),
        ELPA_2STAGE_NUMBER_OF_REAL_KERNELS = (0 ELPA_FOR_ALL_2STAGE_REAL_KERNELS(ELPA_ENUM_SUM)),
};

#define ELPA_FOR_ALL_AUTOTUNE_LEVELS(X, ...) \
        X(ELPA_AUTOTUNE_NOT_TUNABLE, 0) \
        X(ELPA_AUTOTUNE_GPU, 1) \
        X(ELPA2_AUTOTUNE_KERNEL, 2) \
	X(ELPA_AUTOTUNE_OPENMP, 3) \
        X(ELPA_AUTOTUNE_TRANSPOSE_VECTORS, 4) \
        X(ELPA2_AUTOTUNE_FULL_TO_BAND, 5) \
        X(ELPA2_AUTOTUNE_BAND_TO_TRIDI, 6) \
        X(ELPA_AUTOTUNE_SOLVE, 7) \
        X(ELPA2_AUTOTUNE_TRIDI_TO_BAND, 8) \
        X(ELPA2_AUTOTUNE_BAND_TO_FULL, 9) \
        X(ELPA2_AUTOTUNE_MAIN, 10) \
        X(ELPA1_AUTOTUNE_FULL_TO_TRIDI, 11) \
        X(ELPA1_AUTOTUNE_TRIDI_TO_FULL, 12) \
        X(ELPA_AUTOTUNE_MPI, 13) \
        X(ELPA_AUTOTUNE_FAST, 14) \
        X(ELPA_AUTOTUNE_MEDIUM, 15) \
	X(ELPA2_AUTOTUNE_BAND_TO_FULL_BLOCKING, 16) \
	X(ELPA1_AUTOTUNE_MAX_STORED_ROWS, 17) \
	X(ELPA2_AUTOTUNE_TRIDI_TO_BAND_STRIPEWIDTH, 18) \
	X(ELPA_AUTOTUNE_EXTENSIVE, 19)

        //X(ELPA_AUTOTUNE_MEDIUM, 16)

enum ELPA_AUTOTUNE_LEVELS {
        ELPA_FOR_ALL_AUTOTUNE_LEVELS(ELPA_ENUM_ENTRY)
};

#define ELPA_NUMBER_OF_AUTOTUNE_LEVELS (0 ELPA_FOR_ALL_AUTOTUNE_LEVELS(ELPA_ENUM_SUM))

#define ELPA_FOR_ALL_AUTOTUNE_DOMAINS(X, ...) \
        X(ELPA_AUTOTUNE_DOMAIN_REAL, 1) \
        X(ELPA_AUTOTUNE_DOMAIN_COMPLEX, 2) \
        X(ELPA_AUTOTUNE_DOMAIN_ANY, 3)

enum ELPA_AUTOTUNE_DOMAINS {
        ELPA_FOR_ALL_AUTOTUNE_DOMAINS(ELPA_ENUM_ENTRY)
};


#define ELPA_FOR_ALL_AUTOTUNE_PARTS(X, ...) \
        X(ELPA_AUTOTUNE_PART_NONE, 0) \
        X(ELPA_AUTOTUNE_PART_ANY, 1) \
        X(ELPA_AUTOTUNE_PART_GENERALIZED, 2) \
        X(ELPA_AUTOTUNE_PART_ELPA1, 3) \
        X(ELPA_AUTOTUNE_PART_ELPA2, 4)

enum ELPA_AUTOTUNE_PARTS {
        ELPA_FOR_ALL_AUTOTUNE_PARTS(ELPA_ENUM_ENTRY)
};
