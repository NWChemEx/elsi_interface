










!
!    Copyright 2017, L. Hüdepohl and A. Marek, MPCDF
!
!    This file is part of ELPA.
!
!    The ELPA library was originally created by the ELPA consortium,
!    consisting of the following organizations:
!
!    - Max Planck Computing and Data Facility (MPCDF), formerly known as
!      Rechenzentrum Garching der Max-Planck-Gesellschaft (RZG),
!    - Bergische Universität Wuppertal, Lehrstuhl für angewandte
!      Informatik,
!    - Technische Universität München, Lehrstuhl für Informatik mit
!      Schwerpunkt Wissenschaftliches Rechnen ,
!    - Fritz-Haber-Institut, Berlin, Abt. Theorie,
!    - Max-Plack-Institut für Mathematik in den Naturwissenschaften,
!      Leipzig, Abt. Komplexe Strukutren in Biologie und Kognition,
!      and
!    - IBM Deutschland GmbH
!
!    This particular source code file contains additions, changes and
!    enhancements authored by Intel Corporation which is not part of
!    the ELPA consortium.
!
!    More information can be found here:
!    http://elpa.mpcdf.mpg.de/
!
!    ELPA is free software: you can redistribute it and/or modify
!    it under the terms of the version 3 of the license of the
!    GNU Lesser General Public License as published by the Free
!    Software Foundation.
!
!    ELPA is distributed in the hope that it will be useful,
!    but WITHOUT ANY WARRANTY; without even the implied warranty of
!    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
!    GNU Lesser General Public License for more details.
!
!    You should have received a copy of the GNU Lesser General Public License
!    along with ELPA.  If not, see <http://www.gnu.org/licenses/>
!
!    ELPA reflects a substantial effort on the part of the original
!    ELPA consortium, and we ask you to respect the spirit of the
!    license that we chose: i.e., please contribute any changes you
!    may have back to the original ELPA library distribution, and keep
!    any derivatives of ELPA under the same license that we chose for
!    the original distribution, the GNU Lesser General Public License.
!
module elpa_constants
  use, intrinsic :: iso_c_binding, only : C_INT
  implicit none
  public

  integer(kind=C_INT),  parameter          :: SC_DESC_LEN = 9

 integer(kind=C_INT), parameter :: ELPA_OK = 0 
 integer(kind=C_INT), parameter :: ELPA_ERROR = -1 
 integer(kind=C_INT), parameter :: ELPA_ERROR_ENTRY_NOT_FOUND = -2 
 integer(kind=C_INT), parameter :: ELPA_ERROR_ENTRY_INVALID_VALUE = -3 
 integer(kind=C_INT), parameter :: ELPA_ERROR_ENTRY_ALREADY_SET = -4 
 integer(kind=C_INT), parameter :: ELPA_ERROR_ENTRY_NO_STRING_REPRESENTATION = -5 
 integer(kind=C_INT), parameter :: ELPA_ERROR_SETUP = -6 
 integer(kind=C_INT), parameter :: ELPA_ERROR_CRITICAL = -7 
 integer(kind=C_INT), parameter :: ELPA_ERROR_API_VERSION = -8 
 integer(kind=C_INT), parameter :: ELPA_ERROR_AUTOTUNE_API_VERSION = -9 
 integer(kind=C_INT), parameter :: ELPA_ERROR_AUTOTUNE_OBJECT_CHANGED = -10 
 integer(kind=C_INT), parameter :: ELPA_ERROR_ENTRY_READONLY = -11 
 integer(kind=C_INT), parameter :: ELPA_ERROR_CANNOT_OPEN_FILE = -12 

 integer(kind=C_INT), parameter :: COLUMN_MAJOR_ORDER = 1 
 integer(kind=C_INT), parameter :: ROW_MAJOR_ORDER = 2 

 integer(kind=C_INT), parameter :: ELPA_SOLVER_1STAGE = 1 
 integer(kind=C_INT), parameter :: ELPA_SOLVER_2STAGE = 2 

 integer(kind=C_INT), parameter :: ELPA_NUMBER_OF_SOLVERS = (0 +1 +1) 

 integer(kind=C_INT), parameter :: ELPA_2STAGE_REAL_GENERIC = 1 
 integer(kind=C_INT), parameter :: ELPA_2STAGE_REAL_GENERIC_SIMPLE = 2 
 integer(kind=C_INT), parameter :: ELPA_2STAGE_REAL_BGP = 3 
 integer(kind=C_INT), parameter :: ELPA_2STAGE_REAL_BGQ = 4 
 integer(kind=C_INT), parameter :: ELPA_2STAGE_REAL_SSE_ASSEMBLY = 5 
 integer(kind=C_INT), parameter :: ELPA_2STAGE_REAL_SSE_BLOCK2 = 6 
 integer(kind=C_INT), parameter :: ELPA_2STAGE_REAL_SSE_BLOCK4 = 7 
 integer(kind=C_INT), parameter :: ELPA_2STAGE_REAL_SSE_BLOCK6 = 8 
 integer(kind=C_INT), parameter :: ELPA_2STAGE_REAL_AVX_BLOCK2 = 9 
 integer(kind=C_INT), parameter :: ELPA_2STAGE_REAL_AVX_BLOCK4 = 10 
 integer(kind=C_INT), parameter :: ELPA_2STAGE_REAL_AVX_BLOCK6 = 11 
 integer(kind=C_INT), parameter :: ELPA_2STAGE_REAL_AVX2_BLOCK2 = 12 
 integer(kind=C_INT), parameter :: ELPA_2STAGE_REAL_AVX2_BLOCK4 = 13 
 integer(kind=C_INT), parameter :: ELPA_2STAGE_REAL_AVX2_BLOCK6 = 14 
 integer(kind=C_INT), parameter :: ELPA_2STAGE_REAL_AVX512_BLOCK2 = 15 
 integer(kind=C_INT), parameter :: ELPA_2STAGE_REAL_AVX512_BLOCK4 = 16 
 integer(kind=C_INT), parameter :: ELPA_2STAGE_REAL_AVX512_BLOCK6 = 17 
 integer(kind=C_INT), parameter :: ELPA_2STAGE_REAL_NVIDIA_GPU = 18 
 integer(kind=C_INT), parameter :: ELPA_2STAGE_REAL_AMD_GPU = 19 
 integer(kind=C_INT), parameter :: ELPA_2STAGE_REAL_INTEL_GPU = 20 
 integer(kind=C_INT), parameter :: ELPA_2STAGE_REAL_SPARC64_BLOCK2 = 21 
 integer(kind=C_INT), parameter :: ELPA_2STAGE_REAL_SPARC64_BLOCK4 = 22 
 integer(kind=C_INT), parameter :: ELPA_2STAGE_REAL_SPARC64_BLOCK6 = 23 
 integer(kind=C_INT), parameter :: ELPA_2STAGE_REAL_NEON_ARCH64_BLOCK2 = 24 
 integer(kind=C_INT), parameter :: ELPA_2STAGE_REAL_NEON_ARCH64_BLOCK4 = 25 
 integer(kind=C_INT), parameter :: ELPA_2STAGE_REAL_NEON_ARCH64_BLOCK6 = 26 
 integer(kind=C_INT), parameter :: ELPA_2STAGE_REAL_VSX_BLOCK2 = 27 
 integer(kind=C_INT), parameter :: ELPA_2STAGE_REAL_VSX_BLOCK4 = 28 
 integer(kind=C_INT), parameter :: ELPA_2STAGE_REAL_VSX_BLOCK6 = 29 
 integer(kind=C_INT), parameter :: ELPA_2STAGE_REAL_SVE128_BLOCK2 = 30 
 integer(kind=C_INT), parameter :: ELPA_2STAGE_REAL_SVE128_BLOCK4 = 31 
 integer(kind=C_INT), parameter :: ELPA_2STAGE_REAL_SVE128_BLOCK6 = 32 
 integer(kind=C_INT), parameter :: ELPA_2STAGE_REAL_SVE256_BLOCK2 = 33 
 integer(kind=C_INT), parameter :: ELPA_2STAGE_REAL_SVE256_BLOCK4 = 34 
 integer(kind=C_INT), parameter :: ELPA_2STAGE_REAL_SVE256_BLOCK6 = 35 
 integer(kind=C_INT), parameter :: ELPA_2STAGE_REAL_SVE512_BLOCK2 = 36 
 integer(kind=C_INT), parameter :: ELPA_2STAGE_REAL_SVE512_BLOCK4 = 37 
 integer(kind=C_INT), parameter :: ELPA_2STAGE_REAL_SVE512_BLOCK6 = 38 
 integer(kind=C_INT), parameter :: ELPA_2STAGE_REAL_GENERIC_SIMPLE_BLOCK4 = 39 
 integer(kind=C_INT), parameter :: ELPA_2STAGE_REAL_GENERIC_SIMPLE_BLOCK6 = 40 
 integer(kind=C_INT), parameter :: ELPA_2STAGE_REAL_NVIDIA_SM80_GPU = 41 
 integer(kind=C_INT), parameter :: ELPA_2STAGE_REAL_INVALID = -1 
 integer(kind=C_INT), parameter :: ELPA_2STAGE_REAL_DEFAULT = 1 

 integer(kind=C_INT), parameter :: ELPA_2STAGE_NUMBER_OF_REAL_KERNELS = & 
 (0 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1) 

 integer(kind=C_INT), parameter :: ELPA_2STAGE_COMPLEX_GENERIC = 1 
 integer(kind=C_INT), parameter :: ELPA_2STAGE_COMPLEX_GENERIC_SIMPLE = 2 
 integer(kind=C_INT), parameter :: ELPA_2STAGE_COMPLEX_BGP = 3 
 integer(kind=C_INT), parameter :: ELPA_2STAGE_COMPLEX_BGQ = 4 
 integer(kind=C_INT), parameter :: ELPA_2STAGE_COMPLEX_SSE_ASSEMBLY = 5 
 integer(kind=C_INT), parameter :: ELPA_2STAGE_COMPLEX_SSE_BLOCK1 = 6 
 integer(kind=C_INT), parameter :: ELPA_2STAGE_COMPLEX_SSE_BLOCK2 = 7 
 integer(kind=C_INT), parameter :: ELPA_2STAGE_COMPLEX_AVX_BLOCK1 = 8 
 integer(kind=C_INT), parameter :: ELPA_2STAGE_COMPLEX_AVX_BLOCK2 = 9 
 integer(kind=C_INT), parameter :: ELPA_2STAGE_COMPLEX_AVX2_BLOCK1 = 10 
 integer(kind=C_INT), parameter :: ELPA_2STAGE_COMPLEX_AVX2_BLOCK2 = 11 
 integer(kind=C_INT), parameter :: ELPA_2STAGE_COMPLEX_AVX512_BLOCK1 = 12 
 integer(kind=C_INT), parameter :: ELPA_2STAGE_COMPLEX_AVX512_BLOCK2 = 13 
 integer(kind=C_INT), parameter :: ELPA_2STAGE_COMPLEX_SVE128_BLOCK1 = 14 
 integer(kind=C_INT), parameter :: ELPA_2STAGE_COMPLEX_SVE128_BLOCK2 = 15 
 integer(kind=C_INT), parameter :: ELPA_2STAGE_COMPLEX_SVE256_BLOCK1 = 16 
 integer(kind=C_INT), parameter :: ELPA_2STAGE_COMPLEX_SVE256_BLOCK2 = 17 
 integer(kind=C_INT), parameter :: ELPA_2STAGE_COMPLEX_SVE512_BLOCK1 = 18 
 integer(kind=C_INT), parameter :: ELPA_2STAGE_COMPLEX_SVE512_BLOCK2 = 19 
 integer(kind=C_INT), parameter :: ELPA_2STAGE_COMPLEX_NEON_ARCH64_BLOCK1 = 20 
 integer(kind=C_INT), parameter :: ELPA_2STAGE_COMPLEX_NEON_ARCH64_BLOCK2 = 21 
 integer(kind=C_INT), parameter :: ELPA_2STAGE_COMPLEX_NVIDIA_GPU = 22 
 integer(kind=C_INT), parameter :: ELPA_2STAGE_COMPLEX_AMD_GPU = 23 
 integer(kind=C_INT), parameter :: ELPA_2STAGE_COMPLEX_INTEL_GPU = 24 
 integer(kind=C_INT), parameter :: ELPA_2STAGE_COMPLEX_NVIDIA_SM80_GPU = 25 
 integer(kind=C_INT), parameter :: ELPA_2STAGE_COMPLEX_INVALID = -1 
 integer(kind=C_INT), parameter :: ELPA_2STAGE_COMPLEX_DEFAULT = 1 

 integer(kind=C_INT), parameter :: ELPA_2STAGE_NUMBER_OF_COMPLEX_KERNELS = & 
 (0 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1) 

 integer(kind=C_INT), parameter :: ELPA_AUTOTUNE_NOT_TUNABLE = 0 
 integer(kind=C_INT), parameter :: ELPA_AUTOTUNE_GPU = 1 
 integer(kind=C_INT), parameter :: ELPA2_AUTOTUNE_KERNEL = 2 
 integer(kind=C_INT), parameter :: ELPA_AUTOTUNE_OPENMP = 3 
 integer(kind=C_INT), parameter :: ELPA_AUTOTUNE_TRANSPOSE_VECTORS = 4 
 integer(kind=C_INT), parameter :: ELPA2_AUTOTUNE_FULL_TO_BAND = 5 
 integer(kind=C_INT), parameter :: ELPA2_AUTOTUNE_BAND_TO_TRIDI = 6 
 integer(kind=C_INT), parameter :: ELPA_AUTOTUNE_SOLVE = 7 
 integer(kind=C_INT), parameter :: ELPA2_AUTOTUNE_TRIDI_TO_BAND = 8 
 integer(kind=C_INT), parameter :: ELPA2_AUTOTUNE_BAND_TO_FULL = 9 
 integer(kind=C_INT), parameter :: ELPA2_AUTOTUNE_MAIN = 10 
 integer(kind=C_INT), parameter :: ELPA1_AUTOTUNE_FULL_TO_TRIDI = 11 
 integer(kind=C_INT), parameter :: ELPA1_AUTOTUNE_TRIDI_TO_FULL = 12 
 integer(kind=C_INT), parameter :: ELPA_AUTOTUNE_MPI = 13 
 integer(kind=C_INT), parameter :: ELPA_AUTOTUNE_FAST = 14 
 integer(kind=C_INT), parameter :: ELPA_AUTOTUNE_MEDIUM = 15 
 integer(kind=C_INT), parameter :: ELPA2_AUTOTUNE_BAND_TO_FULL_BLOCKING = 16 
 integer(kind=C_INT), parameter :: ELPA1_AUTOTUNE_MAX_STORED_ROWS = 17 
 integer(kind=C_INT), parameter :: ELPA2_AUTOTUNE_TRIDI_TO_BAND_STRIPEWIDTH = 18 
 integer(kind=C_INT), parameter :: ELPA_AUTOTUNE_EXTENSIVE = 19 

 integer(kind=C_INT), parameter :: ELPA_AUTOTUNE_DOMAIN_REAL = 1 
 integer(kind=C_INT), parameter :: ELPA_AUTOTUNE_DOMAIN_COMPLEX = 2 
 integer(kind=C_INT), parameter :: ELPA_AUTOTUNE_DOMAIN_ANY = 3 

 integer(kind=C_INT), parameter :: ELPA_AUTOTUNE_PART_NONE = 0 
 integer(kind=C_INT), parameter :: ELPA_AUTOTUNE_PART_ANY = 1 
 integer(kind=C_INT), parameter :: ELPA_AUTOTUNE_PART_GENERALIZED = 2 
 integer(kind=C_INT), parameter :: ELPA_AUTOTUNE_PART_ELPA1 = 3 
 integer(kind=C_INT), parameter :: ELPA_AUTOTUNE_PART_ELPA2 = 4 

 integer(kind=C_INT), parameter :: ELPA_NUMBER_OF_AUTOTUNE_LEVELS = & 
 (0 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1 +1) 


  integer(kind=C_INT), parameter           :: ELPA_2STAGE_REAL_GPU    = ELPA_2STAGE_REAL_NVIDIA_GPU
  integer(kind=C_INT), parameter           :: ELPA_2STAGE_COMPLEX_GPU = ELPA_2STAGE_COMPLEX_NVIDIA_GPU
end module
