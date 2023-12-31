










!   This file is part of ELPA.
!
!    The ELPA library was originally created by the ELPA consortium,
!    consisting of the following organizations:
!
!    - Max Planck Computing and Data Facility (MPCDF), fomerly known as
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
!
! ELPA2 -- 2-stage solver for ELPA
!
! Copyright of the original code rests with the authors inside the ELPA
! consortium. The copyright of any additional modifications shall rest
! with their original authors, but shall adhere to the licensing terms
! distributed along with the original code in the file "COPYING".
!
! Author: Andreas Marek, MPCDF

!> \brief Fortran module which provides the routines to use the 2-stage ELPA solver. Implementation only. Should not be used directly
module elpa2_impl
  use elpa_utilities, only : error_unit

  implicit none

  private

  public :: elpa_solve_evp_real_2stage_a_h_a_double_impl          !< Driver routine for real double-precision 2-stage eigenvalue problem
  public :: elpa_solve_evp_complex_2stage_a_h_a_double_impl       !< Driver routine for complex double-precision 2-stage eigenvalue problem
  public :: elpa_solve_evp_real_2stage_a_h_a_single_impl          !< Driver routine for real single-precision 2-stage eigenvalue problem

  public :: elpa_solve_evp_complex_2stage_a_h_a_single_impl       !< Driver routine for complex single-precision 2-stage eigenvalue problem

  public :: elpa_solve_skew_evp_real_2stage_a_h_a_double_impl          !< Driver routine for real double-precision 2-stage skew-symmetric eigenvalue problem
  public :: elpa_solve_skew_evp_real_2stage_a_h_a_single_impl          !< Driver routine for real single-precision 2-stage skew-symmetric eigenvalue problem

  public :: elpa_solve_evp_real_2stage_d_ptr_double_impl          !< Driver routine for real double-precision 2-stage eigenvalue problem
  public :: elpa_solve_evp_complex_2stage_d_ptr_double_impl       !< Driver routine for complex double-precision 2-stage eigenvalue problem
  public :: elpa_solve_evp_real_2stage_d_ptr_single_impl          !< Driver routine for real single-precision 2-stage eigenvalue problem

  public :: elpa_solve_evp_complex_2stage_d_ptr_single_impl       !< Driver routine for complex single-precision 2-stage eigenvalue problem

  public :: elpa_solve_skew_evp_real_2stage_d_ptr_double_impl          !< Driver routine for real double-precision 2-stage skew-symmetric eigenvalue problem
  public :: elpa_solve_skew_evp_real_2stage_d_ptr_single_impl          !< Driver routine for real single-precision 2-stage skew-symmetric eigenvalue problem


  contains


















!-------------------------------------------------------------------------------
!>  \brief elpa_solve_evp_real_2stage_host_arrays_double_impl: Fortran function to solve the double-precision real eigenvalue problem with a 2 stage approach
!>
!>  Parameters
!>
!>  \param na                                   Order of matrix a
!>
!>  \param nev                                  Number of eigenvalues needed
!>
!>  \param a(lda,matrixCols)                    Distributed matrix for which eigenvalues are to be computed.
!>                                              Distribution is like in Scalapack.
!>                                              The full matrix must be set (not only one half like in scalapack).
!>                                              Destroyed on exit (upper and lower half).
!>
!>  \param lda                                  Leading dimension of a
!>
!>  \param ev(na)                               On output: eigenvalues of a, every processor gets the complete set
!>
!>  \param q(ldq,matrixCols)                    On output: Eigenvectors of a
!>                                              Distribution is like in Scalapack.
!>                                              Must be always dimensioned to the full size (corresponding to (na,na))
!>                                              even if only a part of the eigenvalues is needed.
!>
!>  \param ldq                                  Leading dimension of q
!>
!>  \param nblk                                 blocksize of cyclic distribution, must be the same in both directions!
!>
!>  \param matrixCols                           local columns of matrix a and q
!>
!>  \param mpi_comm_rows                        MPI communicator for rows
!>  \param mpi_comm_cols                        MPI communicator for columns
!>  \param mpi_comm_all                         MPI communicator for the total processor set
!>
!>  \param kernel                               specify ELPA2 kernel to use
!>
!>  \param useQR (optional)                     use QR decomposition
!>  \param useGPU (optional)                    decide whether to use GPUs or not
!>
!>  \result success                             logical, false if error occured
!-------------------------------------------------------------------------------


!cannot use "../src/elpa2/../general/error_checking.inc" because filename with path can be too long for gfortran (max line length)


 function elpa_solve_evp_&
  &real&
  &_&
  &2stage_a_h_a_&
  &double&
  &_impl (obj, &
   aExtern, &
   evExtern, &
   qExtern) result(success)

   !use matrix_plot
   use elpa_abstract_impl
   use elpa_utilities
   use elpa1_compute
   use elpa2_compute
   use elpa_mpi
   use cuda_functions
   use hip_functions
   use elpa_gpu
   use mod_check_for_gpu
   use elpa_omp
   use solve_tridi
   use thread_affinity
   use, intrinsic :: iso_c_binding
   implicit none
!    Copyright 2011, A. Marek
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
!
  integer, parameter :: rk = C_DOUBLE
  integer, parameter :: rck = C_DOUBLE
  real(kind=rck), parameter      :: ZERO=0.0_rk, ONE = 1.0_rk

   class(elpa_abstract_impl_t), intent(inout)                         :: obj
   logical                                                            :: useGPU
   logical                                                            :: isSkewsymmetric
   logical                                                            :: useQR
   logical                                                            :: useQRActual
   integer(kind=c_int)                                                :: kernel, kernelByUser
   logical                                                            :: userHasSetKernel

   
!#ifdef REDISTRIBUTE_MATRIX

   real(kind=c_double), intent(inout), target         :: aExtern(obj%local_nrows,*)
   real(kind=c_double), optional, intent(out), target :: qExtern(obj%local_nrows,*)

!#else 
!
!#ifdef 1
!   real(kind=c_double), intent(inout)                 :: a(obj%local_nrows,*)
!   real(kind=c_double), optional, intent(out), target :: q(obj%local_nrows,*)
!#else
!   real(kind=c_double), intent(inout)                 :: a(obj%local_nrows,obj%local_ncols)
!#ifdef ACTIVATE_SKEW
!   real(kind=c_double), optional, target, intent(out) :: q(obj%local_nrows,2*obj%local_ncols)
!#else
!   real(kind=c_double), optional, target, intent(out) :: q(obj%local_nrows,obj%local_ncols)
!#endif
!#endif
!
!#endif 


    real(kind=rck), pointer                                  :: a(:,:)
    real(kind=rck), pointer                                  :: q(:,:)
    real(kind=rk8), pointer                                  :: ev(:)

   real(kind=c_double), target, intent(inout)                  :: evExtern(obj%na)

   real(kind=c_double), allocatable                   :: hh_trans(:,:)

   integer(kind=c_int)                                                :: my_pe, n_pes, my_prow, my_pcol, np_rows, np_cols
   integer(kind=MPI_KIND)                                             :: my_peMPI, n_pesMPI, my_prowMPI, my_pcolMPI, &
                                                                         np_rowsMPI, np_colsMPI, mpierr
   integer(kind=c_int)                                                :: nbw, num_blocks
   real(kind=c_double), allocatable                   :: tmat(:,:,:)
   real(kind=c_double), allocatable                            :: e(:)
   real(kind=c_double), allocatable, target           :: q_dummy(:,:)
   real(kind=c_double), pointer                       :: q_actual(:,:)


   integer(kind=c_int)                                                :: i
   logical                                                            :: success, successGPU
   integer(kind=c_int)                                                :: success_int
   logical                                                            :: wantDebug
   integer(kind=c_int)                                                :: istat, gpu, skewsymmetric, debug, qr
   character(200)                                                     :: errorMessage
   logical                                                            :: do_useGPU, do_useGPU_bandred, &
                                                                         do_useGPU_tridiag_band, do_useGPU_solve_tridi, &
                                                                         do_useGPU_trans_ev_tridi_to_band, &
                                                                         do_useGPU_trans_ev_band_to_full
   integer(kind=c_int)                                                :: numberOfGPUDevices
   integer(kind=c_intptr_t), parameter                                :: size_of_datatype = size_of_&
                                                                                            &double&
                                                                                            &_&
                                                                                            &real
   integer(kind=c_intptr_t), parameter                                :: size_of_real_datatype = size_of_&
                                                                                                 &double&
                                                                                                 &_real
   integer(kind=ik)                                                   :: na, nev, nblk, matrixCols, &
                                                                         mpi_comm_rows, mpi_comm_cols,        &
                                                                         mpi_comm_all, check_pd, error, matrixRows
   real(kind=c_double)                                         :: thres_pd

   real(kind=rck), pointer                                   :: aIntern(:,:)
   real(kind=c_double), pointer                       :: qIntern(:,:)
   real(kind=rk8), pointer                                  :: evIntern(:)

   logical                                                            :: do_bandred, do_tridiag, do_solve_tridi,  &
                                                                         do_trans_to_band, do_trans_to_full
   logical                                                            :: good_nblk_gpu

   integer(kind=ik)                                                   :: nrThreads, limitThreads
   integer(kind=ik)                                                   :: global_index
   logical                                                            :: reDistributeMatrix, doRedistributeMatrix
   integer(kind=ik)                                                   :: pinningInfo

   integer(kind=MPI_KIND)                                             :: bcast_request1, bcast_request2, allreduce_request1, &
                                                                         allreduce_request2, allreduce_request3, &
                                                                         allreduce_request4, allreduce_request5, &
                                                                         allreduce_request6, allreduce_request7, &
                                                                         allreduce_request8
   logical                                                            :: useNonBlockingCollectivesAll
   integer(kind=ik)                                                   :: gpu_old, gpu_new
   integer(kind=ik)                                                   :: non_blocking_collectives_all













    call obj%timer%start("elpa_solve_evp_&
    &real&
    &_2stage_&
    &double&
    &")

    call obj%get("debug",debug, error)
    if (error .ne. ELPA_OK) then
      write(error_unit,*) "ELPA2: Problem getting option for debug settings. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

    endif

    wantDebug = debug == 1

    ! check legacy GPU setings
    ! check legacy GPU setings
    if (obj%is_set("gpu") == 1) then
      write(error_unit,*) "You still use the deprecated option 'gpu', consider switching to 'nvidia-gpu'"
      call obj%get("gpu", gpu_old, error)     
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "GPU_SOLVER : Problem getting option for gpu. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_evp_&
     &real&
     &_1stage_&
     &double&
     &")
     success = .false.
     return
      endif
      if (obj%is_set("nvidia-gpu") == 0) then
        ! set gpu and nvidia-gpu consistent
        call obj%set("nvidia-gpu", gpu_old, error)
        if (error .ne. ELPA_OK) then
          write(error_unit,*) "GPU_SOLVER : Problem setting option for nvidia-gpu. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_evp_&
     &real&
     &_1stage_&
     &double&
     &")
     success = .false.
     return
        endif
        write(error_unit,*) "Will set the new keyword 'nvidia-gpu' now."
        write(error_unit,*) "And ignore the 'gpu' keyword from now on"
      else ! obj%is_set("nvidia-gpu") == 0
        call obj%get("nvidia-gpu", gpu_new, error)
        if (error .ne. ELPA_OK) then
          write(error_unit,*) "GPU_SOLVER : Problem getting option for nvidia-gpu. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_evp_&
     &real&
     &_1stage_&
     &double&
     &")
     success = .false.
     return
        endif
        if (gpu_old .ne. gpu_new) then
                write(error_unit,*) "Please do not set 'gpu' but 'nvidia-gpu' instead"
          write(error_unit,*) "You cannot set gpu = ",gpu_old," and nvidia-gpu=",gpu_new,". Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_evp_&
     &real&
     &_1stage_&
     &double&
     &")
     success = .false.
     return
        endif
      endif ! obj%is_set("nvidia-gpu") == 0
      if (obj%is_set("amd-gpu") == 0) then
        ! amd-gpu is not set, but gpu is set
        ! this is ok in anycase
      else ! obj%is_set("amd-gpu") == 0
        call obj%get("amd-gpu", gpu_new, error)
        if (error .ne. ELPA_OK) then
          write(error_unit,*) "GPU_SOLVER : Problem getting option for amd-gpu. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_evp_&
     &real&
     &_1stage_&
     &double&
     &")
     success = .false.
     return
        endif
        ! this is ok, if gpu == 0 and amd-gpu == 1 or
        !             if gpu == 0 and amd-gpu == 0 or
        !             if gpu == 1 and amd-gpu == 0
        if (gpu_old .eq. 1 .and. gpu_new .eq. 1) then
          write(error_unit,*) "GPU_SOLVER : You cannot set gpu = 1 and amd-gpu = 1. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_evp_&
     &real&
     &_1stage_&
     &double&
     &")
     success = .false.
     return
        endif
      endif ! amd-gpu
      if (obj%is_set("intel-gpu") == 0) then
        ! intel-gpu is not set, but gpu is set
        ! this is ok in anycase
      else ! obj%is_set("intel-gpu") == 0
        call obj%get("intel-gpu", gpu_new, error)
        if (error .ne. ELPA_OK) then
          write(error_unit,*) "GPU_SOLVER : Problem getting option for intel-gpu. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_evp_&
     &real&
     &_1stage_&
     &double&
     &")
     success = .false.
     return
        endif
        ! this is ok, if gpu == 0 and intel-gpu == 1 or
        !             if gpu == 0 and intel-gpu == 0 or
        !             if gpu == 1 and intel-gpu == 0
        if (gpu_old .eq. 1 .and. gpu_new .eq. 1) then
          write(error_unit,*) "GPU_SOLVER : You cannot set gpu = 1 and intel-gpu = 1. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_evp_&
     &real&
     &_1stage_&
     &double&
     &")
     success = .false.
     return
        endif
      endif ! intel-gpu
    else ! gpu not set
      ! nothing to do since the legacy option is not set
    endif ! gpu is set

    ! GPU settings
    if (gpu_vendor() == NVIDIA_GPU) then
      call obj%get("nvidia-gpu", gpu, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "GPU_SOLVER : Problem getting option for NVIDIA GPU. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_evp_&
     &real&
     &_1stage_&
     &double&
     &")
     success = .false.
     return
      endif
    else if (gpu_vendor() == AMD_GPU) then
      call obj%get("amd-gpu", gpu, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "GPU_SOLVER : Problem getting option for AMD GPU. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_evp_&
     &real&
     &_1stage_&
     &double&
     &")
     success = .false.
     return
      endif
    else if (gpu_vendor() == INTEL_GPU) then
      call obj%get("intel-gpu", gpu, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "GPU_SOLVER : Problem getting option for INTEL GPU. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_evp_&
     &real&
     &_1stage_&
     &double&
     &")
     success = .false.
     return
      endif
    else ! no supported gpu
      gpu = 0
    endif

   if (gpu .eq. 1) then
     useGPU =.true.
   else
     useGPU = .false.
   endif


    do_useGPU = .false.

    ! get the kernel and check whether it has been set by the user
    if (obj%is_set("real_kernel") == 1) then
      userHasSetKernel = .true.
    else
      userHasSetKernel = .false.
    endif

    ! after this point you may _never_ call get for the kernel again, or set the
    ! kernel !! The reason is that we might have to adjust the kernel, which is
    ! passed as a variable
    call obj%get("real_kernel", kernel, error)
    if (error .ne. ELPA_OK) then
      write(error_unit,*) "ELPA2: Problem getting option for kernel settings. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

    endif

    ! to implement a possibiltiy to set this
    useNonBlockingCollectivesAll = .false.

    call obj%get("mpi_comm_rows",mpi_comm_rows, error)
    if (error .ne. ELPA_OK) then
      write(error_unit,*) "ELPA2: Problem getting option for mpi_comm_rows. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

    endif
    call obj%get("mpi_comm_cols",mpi_comm_cols,error)
    if (error .ne. ELPA_OK) then
      write(error_unit,*) "ELPA2: Problem getting option for mpi_comm_cols. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

    endif
    call obj%get("mpi_comm_parent",mpi_comm_all,error)
    if (error .ne. ELPA_OK) then
      write(error_unit,*) "ELPA2: Problem getting option for mpi_comm_parent. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

    endif

    call obj%timer%start("mpi_communication")
    call mpi_comm_rank(int(mpi_comm_all,kind=MPI_KIND) ,my_peMPI ,mpierr)
    call mpi_comm_size(int(mpi_comm_all,kind=MPI_KIND) ,n_pesMPI ,mpierr)

    call mpi_comm_rank(int(mpi_comm_rows,kind=MPI_KIND) ,my_prowMPI ,mpierr)
    call mpi_comm_size(int(mpi_comm_rows,kind=MPI_KIND) ,np_rowsMPI ,mpierr)
    call mpi_comm_rank(int(mpi_comm_cols,kind=MPI_KIND) ,my_pcolMPI ,mpierr)
    call mpi_comm_size(int(mpi_comm_cols,kind=MPI_KIND) ,np_colsMPI ,mpierr)

    my_pe = int(my_peMPI, kind=c_int)
    n_pes = int(n_pesMPI, kind=c_int)
    my_prow = int(my_prowMPI, kind=c_int)
    np_rows = int(np_rowsMPI, kind=c_int)
    my_pcol = int(my_pcolMPI, kind=c_int)
    np_cols = int(np_colsMPI, kind=c_int)

    call obj%timer%stop("mpi_communication")

    na         = obj%na
    nev        = obj%nev
    nblk       = obj%nblk
    matrixCols = obj%local_ncols
    matrixRows = obj%local_nrows

    call obj%get("nbc_all_elpa2_main", non_blocking_collectives_all, error)
    if (error .ne. ELPA_OK) then
      write(error_unit,*) "ELPA2: Problem getting option for non blocking collectives. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

    endif

    if (non_blocking_collectives_all .eq. 1) then
      useNonBlockingCollectivesAll = .true.
    else
      useNonBlockingCollectivesAll = .false.
    endif

    ! openmp setting
    nrThreads = 1


    if (useGPU) then
      call obj%timer%start("check_for_gpu")
      if (check_for_gpu(obj, my_pe, numberOfGPUDevices, wantDebug=wantDebug)) then
        do_useGPU = .true.
        ! set the neccessary parameters
        call set_gpu_parameters()

      else
        write(error_unit,*) "ELPA2: GPUs are requested but not detected! Aborting..."
        call obj%timer%stop("check_for_gpu")
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

      endif
      call obj%timer%stop("check_for_gpu")

      if (nblk*(max(np_rows,np_cols)-1) >= na) then
        if (my_pe .eq. 0) then
          write(error_unit,*) "ELPA: Warning, block size too large for this matrix size and process grid!"
          write(error_unit,*) "Choose a smaller block size if possible.",nblk*(max(np_rows,np_cols)-1),na
          write(error_unit,*) "Disabling GPU usage! "
        endif

        do_useGPU = .false.
        if (kernel .eq. ELPA_2STAGE_REAL_NVIDIA_GPU) then
          if (userHasSetKernel) then
            ! user fixed inconsistent input.
            ! sadly, we do have to abort
            if (my_pe .eq. 0) then
              write(error_unit,*) "You set (fixed) the kernel to GPU, but GPUs cannot be used."
              write(error_unit,*) "Either adapt the block size or the process grid, or do not set the GPU kernel! Aborting..."
            endif
            stop 1
          else
            ! here we should set the default kernel
            kernel = ELPA_2STAGE_REAL_DEFAULT
          endif
        endif
      endif

    endif ! useGPU




    do_useGPU_bandred = do_useGPU
    do_useGPU_tridiag_band = .false.  ! not yet ported
    do_useGPU_solve_tridi = do_useGPU
    do_useGPU_trans_ev_tridi_to_band = do_useGPU
    do_useGPU_trans_ev_band_to_full = do_useGPU


   reDistributeMatrix = .false.



   ! aIntern, qIntern, are normally pointers since no matrix redistribution is used
   ! point them to  the external arrays
   aIntern => aExtern(1:matrixRows,1:matrixCols)
   if (present(qExtern)) then
     qIntern => qExtern(1:matrixRows,1:matrixCols)
   endif

  ! whether a matrix redistribution or not is happening we still
  ! have to point ev
   evIntern => evExtern(1:obj%na)

     a       => aIntern(1:matrixRows,1:matrixCols)
     if (present(qExtern)) then
       q       => qIntern(1:matrixRows,1:matrixCols)
     endif

   ev      => evIntern(1:obj%na)

   call obj%get("output_pinning_information", pinningInfo, error)
   if (error .ne. ELPA_OK) then
     write(error_unit,*) "ELPA2: Problem setting option for debug. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

   endif

   if (pinningInfo .eq. 1) then
     call init_thread_affinity(nrThreads)

     call check_thread_affinity()
     if (my_pe .eq. 0) call print_thread_affinity(my_pe)
     call cleanup_thread_affinity()
   endif

    success = .true.

    if (present(qExtern)) then
      obj%eigenvalues_only = .false.
    else
      obj%eigenvalues_only = .true.
    endif

   ! special case na = 1
   if (na .eq. 1) then
     ev(1) = a(1,1)
     if (.not.(obj%eigenvalues_only)) then
       q(1,1) = ONE
     endif

     ! restore original OpenMP settings

     call obj%timer%stop("elpa_solve_evp_&
     &real&
     &_2stage_&
     &double&
     &")
     success = .true.
     return
   endif

   if (nev == 0) then
     nev = 1
     obj%eigenvalues_only = .true.
   endif

    !call obj%get("real_kernel", kernel, error)
    !if (error .ne. ELPA_OK) then
    !  print *,"Problem getting option for kernel settings. Aborting..."
    !  stop 1
    !endif

    isSkewsymmetric = .false.

    ! only if we want (and can) use GPU in general, look what are the
    ! requirements for individual routines. Implicitly they are all set to 1, so
    ! unless specified otherwise by the user, GPU versions of all individual
    ! routines should be used
    if (do_useGPU) then
      call obj%get("gpu_bandred", gpu, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "ELPA2: Problem getting option gpu_bandred settings. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

      endif
      do_useGPU_bandred = (gpu == 1)

      ! not yet ported
      !call obj%get("gpu_tridiag_band", gpu, error)
      !if (error .ne. ELPA_OK) then
      !  print *,"Problem getting option for gpu_tridiag_band settings. Aborting..."
      !  stop 1
      !endif
      !do_useGPU_tridiag_band = (gpu == 1)

      call obj%get("gpu_solve_tridi", gpu, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "ELPA2: Problem getting option for gpu_solve_tridi settings. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

      endif
      do_useGPU_solve_tridi = (gpu == 1)

      call obj%get("gpu_trans_ev_tridi_to_band", gpu, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "ELPA2: Problem getting option for gpu_trans_ev_tridi_to_band settings. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

      endif
      do_useGPU_trans_ev_tridi_to_band = (gpu == 1)

      call obj%get("gpu_trans_ev_band_to_full", gpu, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "ELPA2: Problem getting option for gpu_trans_ev_band_to_full settings. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

      endif
      do_useGPU_trans_ev_band_to_full = (gpu == 1)
    endif

    ! check consistency between request for GPUs and defined kernel
    if (do_useGPU_trans_ev_tridi_to_band) then
      ! if the user has set explicitely a kernel before than honour this
      ! otherwise set GPU kernel
      if (userHasSetKernel) then
        if (kernel .ne. ELPA_2STAGE_REAL_NVIDIA_GPU) then
          write(error_unit,*) "ELPA: Warning, GPU usage has been requested but compute kernel is set by the user as non-GPU!"
          write(error_unit,*) "The compute kernel will be executed on CPUs!"
          do_useGPU_trans_ev_tridi_to_band = .false.
          kernel = ELPA_2STAGE_REAL_DEFAULT
        else
          good_nblk_gpu = .false.
        endif
      else ! userHasSetKernel
        !call obj%set("real_kernel", ELPA_2STAGE_REAL_NVIDIA_GPU, error)
        !if (error .ne. ELPA_OK) then
        !  write(error_unit,*) "Cannot set kernel to GPU kernel"
        !  stop 1
        !endif

        if (my_pe .eq. 0) write(error_unit,*) "You requested the GPU version, thus the GPU kernel is activated"
        good_nblk_gpu = .false.

        kernel = ELPA_2STAGE_REAL_NVIDIA_GPU
      endif ! userHasSetKernel

      ! Accepted values are 2,4,8,16,...,512
      do i = 1,10
        if (nblk == 2**i) then
          good_nblk_gpu = .true.
          exit
        endif
      enddo

      if (.not. good_nblk_gpu .and. do_useGPU_trans_ev_tridi_to_band) then
         write(error_unit,*) "ELPA: Warning, GPU kernel only works with block size 2^n (n = 1, 2, ..., 10)!"
         write(error_unit,*) "The compute kernel will be executed on CPUs!"
         write(error_unit,*) "We recommend changing the block size to 2^n"
         do_useGPU_trans_ev_tridi_to_band = .false.
         ! should be set
         kernel = ELPA_2STAGE_REAL_DEFAULT
      endif
    endif





    ! check again, now kernel and do_useGPU_trans_ev_tridi_to_band should be
    ! finally consistent
    if (do_useGPU_trans_ev_tridi_to_band) then
      !call obj%get("real_kernel", kernel, error)
      !if (error .ne. ELPA_OK) then
      !  write(error_unit,*) "Cannot get kernel to GPU kernel"
      !  stop 1
      !endif
      if (kernel .ne. ELPA_2STAGE_REAL_NVIDIA_GPU) then
        ! this should never happen, checking as an assert
        write(error_unit,*) "ELPA: INTERNAL ERROR setting GPU kernel!  Aborting..."
        stop 1
      endif
    else ! do not use GPU
      if (kernel .eq. ELPA_2STAGE_REAL_NVIDIA_GPU) then
        ! combination not allowed
        write(error_unit,*) "ELPA: Warning, GPU usage has NOT been requested but compute kernel &
                            &is defined as the GPU kernel!  Setting default kernel"
        kernel = ELPA_2STAGE_REAL_DEFAULT
        !TODO do error handling properly
      endif
    endif



     !! consistency check: is user set kernel still identical with "kernel" or did
     !! we change it above? This is a mess and should be cleaned up
     !call obj%get("real_kernel",kernelByUser,error)
     !if (error .ne. ELPA_OK) then
     !  print *,"Problem getting option for user kernel settings. Aborting..."
     !  stop 1
     !endif

     !if (kernelByUser .ne. kernel) then
     !  call obj%set("real_kernel", kernel, error)
     !  if (error .ne. ELPA_OK) then
     !    print *,"Problem setting kernel. Aborting..."
     !    stop 1
     !  endif
     !endif


    call obj%get("qr",qr,error)
    if (error .ne. ELPA_OK) then
      print *,"ELPA2: Problem getting option for qr settings. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

    endif
    if (qr .eq. 1) then
      useQR = .true.
    else
      useQR = .false.
    endif

    useQRActual = .false.
    ! set usage of qr decomposition via API call
    if (useQR) useQRActual = .true.
    if (.not.(useQR)) useQRACtual = .false.

    if (useQRActual) then
      if (mod(na,2) .ne. 0) then
        if (wantDebug) then
          write(error_unit,*) "solve_evp_real_2stage: QR-decomposition: blocksize does not fit with matrixsize"
        endif
        write(error_unit,*) "Do not use QR-decomposition for this matrix and blocksize."
        success = .false.
        return
      endif
    endif

    if (.not. obj%eigenvalues_only) then
      q_actual => q(1:matrixRows,1:matrixCols)
    else
     allocate(q_dummy(1:matrixRows,1:matrixCols), stat=istat, errmsg=errorMessage)
     call check_allocate_f("elpa2_template: q_dummy", 998,  istat,  errorMessage)
     q_actual => q_dummy(1:matrixRows,1:matrixCols)
    endif

    ! set the default values for each of the 5 compute steps
    do_bandred        = .true.
    do_tridiag        = .true.
    do_solve_tridi    = .true.
    do_trans_to_band  = .true.
    do_trans_to_full  = .true.

    if (obj%eigenvalues_only) then
      do_trans_to_band  = .false.
      do_trans_to_full  = .false.
    endif

    if (obj%is_set("bandwidth") == 1) then
      ! bandwidth is set. That means, that the inputed matrix is actually banded and thus the
      ! first step of ELPA2 should be skipped
      call obj%get("bandwidth",nbw,error)
      if (nbw == 0) then
        if (wantDebug) then
          write(error_unit,*) "Specified bandwidth = 0; ELPA refuses to solve the eigenvalue problem ", &
                              "for a diagonal matrix! This is too simple"
          endif
          write(error_unit,*) "Specified bandwidth = 0; ELPA refuses to solve the eigenvalue problem ", &
                 "for a diagonal matrix! This is too simple"
        success = .false.
        return
      endif
      if (mod(nbw, nblk) .ne. 0) then
        ! treat matrix with an effective bandwidth slightly bigger than specified bandwidth
        ! such that effective bandwidth is a multiply of nblk. which is a prerequiste for ELPA
        nbw = nblk * ceiling(real(nbw,kind=c_double)/real(nblk,kind=c_double))

        ! just check that effective bandwidth is NOT larger than matrix size
        if (nbw .gt. na) then
          if (wantDebug) then
            write(error_unit,*) "Specified bandwidth ",nbw," leads internaly to a computed bandwidth ", &
                                "which is larger than the matrix size ",na," ! ELPA will abort! Try to", &
                                "solve your problem by not specifing a bandwidth"
          endif
          print *, "Specified bandwidth ",nbw," leads internaly to a computed bandwidth ", &
                                "which is larger than the matrix size ",na," ! ELPA will abort! Try to", &
                                "solve your problem by not specifing a bandwidth"
          success = .false.
          return
        endif
      endif
      do_bandred       = .false. ! we already have a banded matrix
      do_solve_tridi   = .true.  ! we also have to solve something :-)
      do_trans_to_band = .true.  ! and still we have to backsub to banded
      do_trans_to_full = .false. ! but not to full since we have a banded matrix
    else ! matrix is not banded, determine the intermediate bandwidth for full->banded->tridi
      !first check if the intermediate bandwidth was set by the user
      call obj%get("intermediate_bandwidth", nbw, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "Problem getting option for intermediate_bandwidth. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

      endif

      if(nbw == 0) then
        ! intermediate bandwidth was not specified, select one of the defaults

        ! Choose bandwidth, must be a multiple of nblk, set to a value >= 32
        ! On older systems (IBM Bluegene/P, Intel Nehalem) a value of 32 was optimal.
        ! For Intel(R) Xeon(R) E5 v2 and v3, better use 64 instead of 32!
        ! For IBM Bluegene/Q this is not clear at the moment. We have to keep an eye
        ! on this and maybe allow a run-time optimization here
        nbw = (63/nblk+1)*nblk
      else
        ! intermediate bandwidth has been specified by the user, check, whether correctly
        if (mod(nbw, nblk) .ne. 0) then
          print *, "Specified bandwidth ",nbw," has to be mutiple of the blocksize ", nblk, ". Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

        endif
      endif !nbw == 0

      num_blocks = (na-1)/nbw + 1

      ! tmat is needed only in full->band and band->full steps, so alocate here
      ! (not allocated for banded matrix on input)
      allocate(tmat(nbw,nbw,num_blocks), stat=istat, errmsg=errorMessage)
      call check_allocate_f("elpa2_template: tmat", 1085,  istat,  errorMessage)

      do_bandred       = .true.
      do_solve_tridi   = .true.
      do_trans_to_band = .true.
      do_trans_to_full = .true.
    endif  ! matrix not already banded on input

    ! start the computations in 5 steps
    if (do_bandred) then
      call obj%autotune_timer%start("full_to_band")
      call obj%timer%start("full_to_band")
      ! Reduction full -> band
      call bandred_&
      &real&
      &_&
      &double &
      (obj, na, a, &
      matrixRows, nblk, nbw, matrixCols, num_blocks, mpi_comm_rows, mpi_comm_cols, tmat, &
      wantDebug, do_useGPU_bandred, success, &
      useQRActual, &
       nrThreads, isSkewsymmetric)

      call obj%timer%stop("full_to_band")
      call obj%autotune_timer%stop("full_to_band")
  
      if (success) then
        success_int = 0
      else
        success_int = 1
      endif

      if (useNonBlockingCollectivesAll) then
        call mpi_iallreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), &
        allreduce_request2, mpierr)
        call mpi_wait(allreduce_request2, MPI_STATUS_IGNORE, mpierr)
      else
        call mpi_allreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), mpierr)
      endif
      if (success_int .eq. 1) then
        write(error_unit,*) "ELPA2: bandred returned an error. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

      endif
    endif

     ! Reduction band -> tridiagonal
     if (do_tridiag) then
       allocate(e(na), stat=istat, errmsg=errorMessage)
       call check_allocate_f("elpa2_template: e", 1143,  istat,  errorMessage)

       call obj%autotune_timer%start("band_to_tridi")
       call obj%timer%start("band_to_tridi")
       call tridiag_band_&
       &real&
       &_&
       &double&
       (obj, na, nbw, nblk, a, matrixRows, ev, e, matrixCols, hh_trans, mpi_comm_rows, mpi_comm_cols, mpi_comm_all, &
       do_useGPU_tridiag_band, wantDebug, nrThreads, isSkewsymmetric, success)
  
       if (success) then
         success_int = 0
       else
         success_int = 1
       endif

       if (useNonBlockingCollectivesAll) then
         call mpi_iallreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), &
         allreduce_request3, mpierr)
         call mpi_wait(allreduce_request3, MPI_STATUS_IGNORE, mpierr)
       else
         call mpi_allreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), mpierr)
       endif
       if (success_int .eq. 1) then
         write(error_unit,*) "Error in tridiag_band. Aborting..."
         return
       endif

       call obj%timer%start("mpi_communication")
       if (useNonBlockingCollectivesAll) then
         call mpi_ibcast(ev, int(na,kind=MPI_KIND), MPI_REAL8, 0_MPI_KIND, int(mpi_comm_all,kind=MPI_KIND), bcast_request1, mpierr)
         call mpi_ibcast(e, int(na,kind=MPI_KIND), MPI_REAL8, 0_MPI_KIND, int(mpi_comm_all,kind=MPI_KIND), bcast_request2, mpierr)

         call mpi_wait(bcast_request1, MPI_STATUS_IGNORE, mpierr)
         call mpi_wait(bcast_request2, MPI_STATUS_IGNORE, mpierr)
       else
         call mpi_bcast(ev, int(na,kind=MPI_KIND), MPI_REAL8, 0_MPI_KIND, int(mpi_comm_all,kind=MPI_KIND), mpierr)
         call mpi_bcast(e, int(na,kind=MPI_KIND), MPI_REAL8, 0_MPI_KIND, int(mpi_comm_all,kind=MPI_KIND), mpierr)
       endif
       call obj%timer%stop("mpi_communication")

       call obj%timer%stop("band_to_tridi")
       call obj%autotune_timer%stop("band_to_tridi")
     endif ! do_tridiag


     ! Solve tridiagonal system
     if (do_solve_tridi) then
       call obj%autotune_timer%start("solve")
       call obj%timer%start("solve")

       call solve_tridi_&
       &double &
       (obj, na, nev, ev, e, &
       q_actual, matrixRows,   &
       nblk, matrixCols, mpi_comm_all, mpi_comm_rows, mpi_comm_cols, do_useGPU_solve_tridi, wantDebug, &
               success, nrThreads)

       call obj%timer%stop("solve")
       call obj%autotune_timer%stop("solve")
  
       if (success) then
         success_int = 0
       else
         success_int = 1
       endif

       if (useNonBlockingCollectivesAll) then
         call mpi_iallreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), &
         allreduce_request4, mpierr)
         call mpi_wait(allreduce_request4, MPI_STATUS_IGNORE, mpierr)
       else
         call mpi_allreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), mpierr)
       endif

       if (success_int .eq. 1) then
         write(error_unit,*) "ELPA2: solve returned an error: Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

       endif
     endif ! do_solve_tridi

     deallocate(e, stat=istat, errmsg=errorMessage)
     call check_deallocate_f("elpa2_template: e", 1257,  istat,  errorMessage)

     if (obj%eigenvalues_only) then
       do_trans_to_band = .false.
       do_trans_to_full = .false.
     else
       call obj%get("check_pd",check_pd,error)
       if (error .ne. ELPA_OK) then
         write(error_unit,*) "Problem getting option for check_pd. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

       endif
       if (check_pd .eq. 1) then
         call obj%get("thres_pd_&
         &double&
         &",thres_pd,error)
         if (error .ne. ELPA_OK) then
            write(error_unit,*) "Problem getting option for thres_pd_&
            &double&
            &. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

         endif

         check_pd = 0
         do i = 1, na
           if (ev(i) .gt. thres_pd) then
             check_pd = check_pd + 1
           endif
         enddo
         if (check_pd .lt. na) then
           ! not positiv definite => eigenvectors needed
           do_trans_to_band = .true.
           do_trans_to_full = .true.
         else
           do_trans_to_band = .false.
           do_trans_to_full = .false.
         endif
       endif
     endif ! eigenvalues only


       if (isSkewsymmetric) then
       ! Extra transformation step for skew-symmetric matrix. Multiplication with diagonal complex matrix D.
       ! This makes the eigenvectors complex.
       ! For now real part of eigenvectors is generated in first half of q, imaginary part in second part.
         q(1:matrixRows, matrixCols+1:2*matrixCols) = 0.0
         do i = 1, matrixRows
!          global_index = indxl2g(i, nblk, my_prow, 0, np_rows)
           global_index = np_rows*nblk*((i-1)/nblk) + MOD(i-1,nblk) + MOD(np_rows+my_prow-0, np_rows)*nblk + 1
           if (mod(global_index-1,4) .eq. 0) then
              ! do nothing
           end if
           if (mod(global_index-1,4) .eq. 1) then
              q(i,matrixCols+1:2*matrixCols) = q(i,1:matrixCols)
              q(i,1:matrixCols) = 0
           end if
           if (mod(global_index-1,4) .eq. 2) then
              q(i,1:matrixCols) = -q(i,1:matrixCols)
           end if
           if (mod(global_index-1,4) .eq. 3) then
              q(i,matrixCols+1:2*matrixCols) = -q(i,1:matrixCols)
              q(i,1:matrixCols) = 0
           end if
         end do
       endif

       ! Backtransform stage 1
     if (do_trans_to_band) then

       !debug
!#if defined(WITH_OPENMP_OFFLOAD_GPU_VERSION) || defined(WITH_SYCL_GPU_VERSION)
       !if (gpu_vendor() == OPENMP_OFFLOAD_GPU .or. gpu_vendor() == SYCL_GPU) then
       call obj%autotune_timer%start("tridi_to_band")
       call obj%timer%start("tridi_to_band")
       ! In the skew-symmetric case this transforms the real part
       call trans_ev_tridi_to_band_&
       &real&
       &_&
       &double &
       (obj, na, nev, nblk, nbw, q, &
       matrixRows, matrixCols, hh_trans, my_pe, mpi_comm_rows, mpi_comm_cols, &
       wantDebug, do_useGPU_trans_ev_tridi_to_band, &
       nrThreads, success=success, kernel=kernel)
       call obj%timer%stop("tridi_to_band")
       call obj%autotune_timer%stop("tridi_to_band")

       if (success) then
         success_int = 0
       else
         success_int = 1
       endif

       if (useNonBlockingCollectivesAll) then
         call mpi_iallreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), &
         allreduce_request5, mpierr)
         call mpi_wait(allreduce_request5, MPI_STATUS_IGNORE, mpierr)
       else
         call mpi_allreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), mpierr)
       endif

       if (success_int .eq. 1) then
         write(error_unit,*) "ELPA2: trans_ev_tridi_to_band returned an error. Aborting..."
         return
       endif

     endif ! do_trans_to_band

     ! the array q (currently) always resides on host even when using GPU

     if (do_trans_to_full) then
       call obj%autotune_timer%start("band_to_full")
       call obj%timer%start("band_to_full")
       ! Backtransform stage 2
       ! In the skew-symemtric case this transforms the real part
       call trans_ev_band_to_full_&
       &real&
       &_&
       &double &
       (obj, na, nev, nblk, nbw, a, &
       matrixRows, tmat, q,  &
       matrixRows, matrixCols, num_blocks, mpi_comm_rows, mpi_comm_cols, do_useGPU_trans_ev_band_to_full &
       , useQRActual  &
       , success)
       call obj%timer%stop("band_to_full")
       call obj%autotune_timer%stop("band_to_full")

       if (success) then
         success_int = 0
       else
         success_int = 1
       endif

       if (useNonBlockingCollectivesAll) then
         call mpi_iallreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), &
         allreduce_request6, mpierr)
         call mpi_wait(allreduce_request6, MPI_STATUS_IGNORE, mpierr)
       else
         call mpi_allreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), mpierr)
       endif
       if (success_int .eq. 1) then
         write(error_unit,*) "Error in trans_ev_band_to_full. Aborting..."
         return
       endif
     endif ! do_trans_to_full
! #ifdef 
!        call prmat(na,useGPU,q(1:matrixRows, 1:matrixCols),q_dev,matrixRows,matrixCols,nblk,my_prow,my_pcol,np_rows,np_cols,'R',1)
! #endif


     !skew symmetric imaginary part for tridi_to_band and band_to_full
     if (isSkewsymmetric) then
       if (do_trans_to_band) then
         call obj%autotune_timer%start("tridi_to_band")
         call obj%timer%start("skew_tridi_to_band")
         ! Transform imaginary part
         ! Transformation of real and imaginary part could also be one call of trans_ev_tridi acting on the n x 2n matrix.
         call trans_ev_tridi_to_band_&
         &real&
         &_&
         &double &
         (obj, na, nev, nblk, nbw, q(1:matrixRows, matrixCols+1:2*matrixCols), &
         matrixRows, matrixCols, hh_trans, my_pe, mpi_comm_rows, mpi_comm_cols, &
         wantDebug, do_useGPU_trans_ev_tridi_to_band, &
         nrThreads, success=success, kernel=kernel)

         call obj%timer%stop("skew_tridi_to_band")
         call obj%autotune_timer%stop("tridi_to_band")

         if (success) then
           success_int = 0
         else
           success_int = 1
         endif

         if (useNonBlockingCollectivesAll) then
           call mpi_iallreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), &
           allreduce_request7, mpierr)
           call mpi_wait(allreduce_request7, MPI_STATUS_IGNORE, mpierr)
         else
           call mpi_allreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), mpierr)
         endif
         if (success_int .eq. 1) then
          write(error_unit,*) "Error in trans_ev_tridi_to_band (imaginary part). Aborting..."
          return
         endif
       endif ! do_trans_tridi_to_band

       if (do_trans_to_full) then
       call obj%autotune_timer%start("band_to_full")
       call obj%timer%start("band_to_full")
         ! Transform imaginary part
         ! Transformation of real and imaginary part could also be one call of trans_ev_band_to_full_ acting on the n x 2n matrix.
         call trans_ev_band_to_full_&
         &real&
         &_&
         &double &
         (obj, na, nev, nblk, nbw, a, &
         matrixRows, tmat, q(1:matrixRows, matrixCols+1:2*matrixCols),  &
         matrixRows, matrixCols, num_blocks, mpi_comm_rows, mpi_comm_cols, do_useGPU_trans_ev_band_to_full, &
         useQRActual, &
         success)

         call obj%timer%stop("band_to_full")
         call obj%autotune_timer%stop("band_to_full")

         if (success) then
           success_int = 0
         else
           success_int = 1
         endif

         if (useNonBlockingCollectivesAll) then
           call mpi_iallreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), &
           allreduce_request8, mpierr)
           call mpi_wait(allreduce_request8, MPI_STATUS_IGNORE, mpierr)
         else
           call mpi_allreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), mpierr)
         endif
         if (success_int .eq. 1) then
          write(error_unit,*) "Error in trans_ev_band_to_full (imaginary part). Aborting..."
          return
         endif
       endif ! do_trans_to_full
     endif ! isSkewSymmetric


     ! We can now deallocate the stored householder vectors
     deallocate(hh_trans, stat=istat, errmsg=errorMessage)
     call check_deallocate_f("elpa2_template: hh_trans", 1537,  istat,  errorMessage)

     ! make sure tmat is deallocated when using check_pd
     if (allocated(tmat)) then
       deallocate(tmat, stat=istat, errmsg=errorMessage)
       call check_deallocate_f("elpa2_template: tmat", 1542,  istat,  errorMessage)
     endif

     if (obj%eigenvalues_only) then
       deallocate(q_dummy, stat=istat, errmsg=errorMessage)
       call check_deallocate_f("elpa2_template: q_dummy", 1547,  istat,  errorMessage)
     endif

     ! restore original OpenMP settings



   nullify(aIntern)
   nullify(evIntern)
   if (present(qExtern)) then
     nullify(qIntern)
   endif

   nullify(ev)
   nullify(a)
   nullify(q)

  nullify(q_actual)

     call obj%timer%stop("elpa_solve_evp_&
     &real&
     &_2stage_&
     &double&
     &")
1    format(a,f10.3)

   end function

! vim: syntax=fortran

















!-------------------------------------------------------------------------------
!>  \brief elpa_solve_evp_real_2stage_d_ptr_double_impl: Fortran function to solve the double-precision real eigenvalue problem with a 2 stage approach
!>
!>  Parameters
!>
!>  \param na                                   Order of matrix a
!>
!>  \param nev                                  Number of eigenvalues needed
!>
!>  \param a                                    Distributed matrix for which eigenvalues are to be computed.
!>                                              Distribution is like in Scalapack.
!>                                              The full matrix must be set (not only one half like in scalapack).
!>                                              Destroyed on exit (upper and lower half).
!>
!>  \param lda                                  Leading dimension of a
!>
!>  \param ev                                   On output: eigenvalues of a, every processor gets the complete set
!>
!>  \param q                                    On output: Eigenvectors of a
!>                                              Distribution is like in Scalapack.
!>                                              Must be always dimensioned to the full size (corresponding to (na,na))
!>                                              even if only a part of the eigenvalues is needed.
!>
!>  \param ldq                                  Leading dimension of q
!>
!>  \param nblk                                 blocksize of cyclic distribution, must be the same in both directions!
!>
!>  \param matrixCols                           local columns of matrix a and q
!>
!>  \param mpi_comm_rows                        MPI communicator for rows
!>  \param mpi_comm_cols                        MPI communicator for columns
!>  \param mpi_comm_all                         MPI communicator for the total processor set
!>
!>  \param kernel                               specify ELPA2 kernel to use
!>
!>  \param useQR (optional)                     use QR decomposition
!>  \param useGPU (optional)                    decide whether to use GPUs or not
!>
!>  \result success                             logical, false if error occured
!-------------------------------------------------------------------------------


!cannot use "../src/elpa2/../general/error_checking.inc" because filename with path can be too long for gfortran (max line length)


 function elpa_solve_evp_&
  &real&
  &_&
  &2stage_d_ptr_&
  &double&
  &_impl (obj, &
   aExtern, &
   evExtern, &
   qExtern) result(success)

   !use matrix_plot
   use elpa_abstract_impl
   use elpa_utilities
   use elpa1_compute
   use elpa2_compute
   use elpa_mpi
   use cuda_functions
   use hip_functions
   use elpa_gpu
   use mod_check_for_gpu
   use elpa_omp
   use solve_tridi
   use thread_affinity
   use, intrinsic :: iso_c_binding
   implicit none
!    Copyright 2011, A. Marek
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
!
  integer, parameter :: rk = C_DOUBLE
  integer, parameter :: rck = C_DOUBLE
  real(kind=rck), parameter      :: ZERO=0.0_rk, ONE = 1.0_rk

   class(elpa_abstract_impl_t), intent(inout)                         :: obj
   logical                                                            :: useGPU
   logical                                                            :: isSkewsymmetric
   logical                                                            :: useQR
   logical                                                            :: useQRActual
   integer(kind=c_int)                                                :: kernel, kernelByUser
   logical                                                            :: userHasSetKernel


!#ifdef REDISTRIBUTE_MATRIX
   type(c_ptr)                                                        :: aExtern
   type(c_ptr), optional                                              :: qExtern
!#else 
!   type(c_ptr)                                                        :: a, q
!#endif 


    real(kind=rck), pointer                                  :: a(:,:)
    real(kind=rck), pointer                                  :: q(:,:)
    real(kind=rk8), pointer                                  :: ev(:)

   type(c_ptr)                                                        :: evExtern

   real(kind=c_double), allocatable                   :: hh_trans(:,:)

   integer(kind=c_int)                                                :: my_pe, n_pes, my_prow, my_pcol, np_rows, np_cols
   integer(kind=MPI_KIND)                                             :: my_peMPI, n_pesMPI, my_prowMPI, my_pcolMPI, &
                                                                         np_rowsMPI, np_colsMPI, mpierr
   integer(kind=c_int)                                                :: nbw, num_blocks
   real(kind=c_double), allocatable                   :: tmat(:,:,:)
   real(kind=c_double), allocatable                            :: e(:)
   real(kind=c_double), allocatable, target           :: q_dummy(:,:)
   real(kind=c_double), pointer                       :: q_actual(:,:)


   integer(kind=c_int)                                                :: i
   logical                                                            :: success, successGPU
   integer(kind=c_int)                                                :: success_int
   logical                                                            :: wantDebug
   integer(kind=c_int)                                                :: istat, gpu, skewsymmetric, debug, qr
   character(200)                                                     :: errorMessage
   logical                                                            :: do_useGPU, do_useGPU_bandred, &
                                                                         do_useGPU_tridiag_band, do_useGPU_solve_tridi, &
                                                                         do_useGPU_trans_ev_tridi_to_band, &
                                                                         do_useGPU_trans_ev_band_to_full
   integer(kind=c_int)                                                :: numberOfGPUDevices
   integer(kind=c_intptr_t), parameter                                :: size_of_datatype = size_of_&
                                                                                            &double&
                                                                                            &_&
                                                                                            &real
   integer(kind=c_intptr_t), parameter                                :: size_of_real_datatype = size_of_&
                                                                                                 &double&
                                                                                                 &_real
   integer(kind=ik)                                                   :: na, nev, nblk, matrixCols, &
                                                                         mpi_comm_rows, mpi_comm_cols,        &
                                                                         mpi_comm_all, check_pd, error, matrixRows
   real(kind=c_double)                                         :: thres_pd

   real(kind=rck), pointer                                   :: aIntern(:,:)
   real(kind=c_double), pointer                       :: qIntern(:,:)
   real(kind=rk8), pointer                                  :: evIntern(:)

   logical                                                            :: do_bandred, do_tridiag, do_solve_tridi,  &
                                                                         do_trans_to_band, do_trans_to_full
   logical                                                            :: good_nblk_gpu

   integer(kind=ik)                                                   :: nrThreads, limitThreads
   integer(kind=ik)                                                   :: global_index
   logical                                                            :: reDistributeMatrix, doRedistributeMatrix
   integer(kind=ik)                                                   :: pinningInfo

   integer(kind=MPI_KIND)                                             :: bcast_request1, bcast_request2, allreduce_request1, &
                                                                         allreduce_request2, allreduce_request3, &
                                                                         allreduce_request4, allreduce_request5, &
                                                                         allreduce_request6, allreduce_request7, &
                                                                         allreduce_request8
   logical                                                            :: useNonBlockingCollectivesAll
   integer(kind=ik)                                                   :: gpu_old, gpu_new
   integer(kind=ik)                                                   :: non_blocking_collectives_all













    call obj%timer%start("elpa_solve_evp_&
    &real&
    &_2stage_&
    &double&
    &")

    call obj%get("debug",debug, error)
    if (error .ne. ELPA_OK) then
      write(error_unit,*) "ELPA2: Problem getting option for debug settings. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

    endif

    wantDebug = debug == 1

    ! check legacy GPU setings
    ! check legacy GPU setings
    if (obj%is_set("gpu") == 1) then
      write(error_unit,*) "You still use the deprecated option 'gpu', consider switching to 'nvidia-gpu'"
      call obj%get("gpu", gpu_old, error)     
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "GPU_SOLVER : Problem getting option for gpu. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_evp_&
     &real&
     &_1stage_&
     &double&
     &")
     success = .false.
     return
      endif
      if (obj%is_set("nvidia-gpu") == 0) then
        ! set gpu and nvidia-gpu consistent
        call obj%set("nvidia-gpu", gpu_old, error)
        if (error .ne. ELPA_OK) then
          write(error_unit,*) "GPU_SOLVER : Problem setting option for nvidia-gpu. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_evp_&
     &real&
     &_1stage_&
     &double&
     &")
     success = .false.
     return
        endif
        write(error_unit,*) "Will set the new keyword 'nvidia-gpu' now."
        write(error_unit,*) "And ignore the 'gpu' keyword from now on"
      else ! obj%is_set("nvidia-gpu") == 0
        call obj%get("nvidia-gpu", gpu_new, error)
        if (error .ne. ELPA_OK) then
          write(error_unit,*) "GPU_SOLVER : Problem getting option for nvidia-gpu. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_evp_&
     &real&
     &_1stage_&
     &double&
     &")
     success = .false.
     return
        endif
        if (gpu_old .ne. gpu_new) then
                write(error_unit,*) "Please do not set 'gpu' but 'nvidia-gpu' instead"
          write(error_unit,*) "You cannot set gpu = ",gpu_old," and nvidia-gpu=",gpu_new,". Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_evp_&
     &real&
     &_1stage_&
     &double&
     &")
     success = .false.
     return
        endif
      endif ! obj%is_set("nvidia-gpu") == 0
      if (obj%is_set("amd-gpu") == 0) then
        ! amd-gpu is not set, but gpu is set
        ! this is ok in anycase
      else ! obj%is_set("amd-gpu") == 0
        call obj%get("amd-gpu", gpu_new, error)
        if (error .ne. ELPA_OK) then
          write(error_unit,*) "GPU_SOLVER : Problem getting option for amd-gpu. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_evp_&
     &real&
     &_1stage_&
     &double&
     &")
     success = .false.
     return
        endif
        ! this is ok, if gpu == 0 and amd-gpu == 1 or
        !             if gpu == 0 and amd-gpu == 0 or
        !             if gpu == 1 and amd-gpu == 0
        if (gpu_old .eq. 1 .and. gpu_new .eq. 1) then
          write(error_unit,*) "GPU_SOLVER : You cannot set gpu = 1 and amd-gpu = 1. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_evp_&
     &real&
     &_1stage_&
     &double&
     &")
     success = .false.
     return
        endif
      endif ! amd-gpu
      if (obj%is_set("intel-gpu") == 0) then
        ! intel-gpu is not set, but gpu is set
        ! this is ok in anycase
      else ! obj%is_set("intel-gpu") == 0
        call obj%get("intel-gpu", gpu_new, error)
        if (error .ne. ELPA_OK) then
          write(error_unit,*) "GPU_SOLVER : Problem getting option for intel-gpu. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_evp_&
     &real&
     &_1stage_&
     &double&
     &")
     success = .false.
     return
        endif
        ! this is ok, if gpu == 0 and intel-gpu == 1 or
        !             if gpu == 0 and intel-gpu == 0 or
        !             if gpu == 1 and intel-gpu == 0
        if (gpu_old .eq. 1 .and. gpu_new .eq. 1) then
          write(error_unit,*) "GPU_SOLVER : You cannot set gpu = 1 and intel-gpu = 1. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_evp_&
     &real&
     &_1stage_&
     &double&
     &")
     success = .false.
     return
        endif
      endif ! intel-gpu
    else ! gpu not set
      ! nothing to do since the legacy option is not set
    endif ! gpu is set

    ! GPU settings
    if (gpu_vendor() == NVIDIA_GPU) then
      call obj%get("nvidia-gpu", gpu, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "GPU_SOLVER : Problem getting option for NVIDIA GPU. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_evp_&
     &real&
     &_1stage_&
     &double&
     &")
     success = .false.
     return
      endif
    else if (gpu_vendor() == AMD_GPU) then
      call obj%get("amd-gpu", gpu, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "GPU_SOLVER : Problem getting option for AMD GPU. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_evp_&
     &real&
     &_1stage_&
     &double&
     &")
     success = .false.
     return
      endif
    else if (gpu_vendor() == INTEL_GPU) then
      call obj%get("intel-gpu", gpu, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "GPU_SOLVER : Problem getting option for INTEL GPU. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_evp_&
     &real&
     &_1stage_&
     &double&
     &")
     success = .false.
     return
      endif
    else ! no supported gpu
      gpu = 0
    endif

   if (gpu .eq. 1) then
     useGPU =.true.
   else
     write(error_unit,*) "GPU_SOLVER : You used the interface for device pointers but did not specify GPU usage!. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_evp_&
     &real&
     &_1stage_&
     &double&
     &")
     success = .false.
     return
     useGPU = .false.
   endif


    do_useGPU = .false.

    ! get the kernel and check whether it has been set by the user
    if (obj%is_set("real_kernel") == 1) then
      userHasSetKernel = .true.
    else
      userHasSetKernel = .false.
    endif

    ! after this point you may _never_ call get for the kernel again, or set the
    ! kernel !! The reason is that we might have to adjust the kernel, which is
    ! passed as a variable
    call obj%get("real_kernel", kernel, error)
    if (error .ne. ELPA_OK) then
      write(error_unit,*) "ELPA2: Problem getting option for kernel settings. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

    endif

    ! to implement a possibiltiy to set this
    useNonBlockingCollectivesAll = .false.

    call obj%get("mpi_comm_rows",mpi_comm_rows, error)
    if (error .ne. ELPA_OK) then
      write(error_unit,*) "ELPA2: Problem getting option for mpi_comm_rows. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

    endif
    call obj%get("mpi_comm_cols",mpi_comm_cols,error)
    if (error .ne. ELPA_OK) then
      write(error_unit,*) "ELPA2: Problem getting option for mpi_comm_cols. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

    endif
    call obj%get("mpi_comm_parent",mpi_comm_all,error)
    if (error .ne. ELPA_OK) then
      write(error_unit,*) "ELPA2: Problem getting option for mpi_comm_parent. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

    endif

    call obj%timer%start("mpi_communication")
    call mpi_comm_rank(int(mpi_comm_all,kind=MPI_KIND) ,my_peMPI ,mpierr)
    call mpi_comm_size(int(mpi_comm_all,kind=MPI_KIND) ,n_pesMPI ,mpierr)

    call mpi_comm_rank(int(mpi_comm_rows,kind=MPI_KIND) ,my_prowMPI ,mpierr)
    call mpi_comm_size(int(mpi_comm_rows,kind=MPI_KIND) ,np_rowsMPI ,mpierr)
    call mpi_comm_rank(int(mpi_comm_cols,kind=MPI_KIND) ,my_pcolMPI ,mpierr)
    call mpi_comm_size(int(mpi_comm_cols,kind=MPI_KIND) ,np_colsMPI ,mpierr)

    my_pe = int(my_peMPI, kind=c_int)
    n_pes = int(n_pesMPI, kind=c_int)
    my_prow = int(my_prowMPI, kind=c_int)
    np_rows = int(np_rowsMPI, kind=c_int)
    my_pcol = int(my_pcolMPI, kind=c_int)
    np_cols = int(np_colsMPI, kind=c_int)

    call obj%timer%stop("mpi_communication")

    na         = obj%na
    nev        = obj%nev
    nblk       = obj%nblk
    matrixCols = obj%local_ncols
    matrixRows = obj%local_nrows

    call obj%get("nbc_all_elpa2_main", non_blocking_collectives_all, error)
    if (error .ne. ELPA_OK) then
      write(error_unit,*) "ELPA2: Problem getting option for non blocking collectives. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

    endif

    if (non_blocking_collectives_all .eq. 1) then
      useNonBlockingCollectivesAll = .true.
    else
      useNonBlockingCollectivesAll = .false.
    endif

    ! openmp setting
    nrThreads = 1


    if (useGPU) then
      call obj%timer%start("check_for_gpu")
      if (check_for_gpu(obj, my_pe, numberOfGPUDevices, wantDebug=wantDebug)) then
        do_useGPU = .true.
        ! set the neccessary parameters
        call set_gpu_parameters()

      else
        write(error_unit,*) "ELPA2: GPUs are requested but not detected! Aborting..."
        call obj%timer%stop("check_for_gpu")
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

      endif
      call obj%timer%stop("check_for_gpu")

      if (nblk*(max(np_rows,np_cols)-1) >= na) then
        if (my_pe .eq. 0) then
          write(error_unit,*) "ELPA: Warning, block size too large for this matrix size and process grid!"
          write(error_unit,*) "Choose a smaller block size if possible.",nblk*(max(np_rows,np_cols)-1),na
          write(error_unit,*) "Disabling GPU usage! "
        endif

        do_useGPU = .false.
        if (kernel .eq. ELPA_2STAGE_REAL_NVIDIA_GPU) then
          if (userHasSetKernel) then
            ! user fixed inconsistent input.
            ! sadly, we do have to abort
            if (my_pe .eq. 0) then
              write(error_unit,*) "You set (fixed) the kernel to GPU, but GPUs cannot be used."
              write(error_unit,*) "Either adapt the block size or the process grid, or do not set the GPU kernel! Aborting..."
            endif
            stop 1
          else
            ! here we should set the default kernel
            kernel = ELPA_2STAGE_REAL_DEFAULT
          endif
        endif
      endif

    endif ! useGPU




    do_useGPU_bandred = do_useGPU
    do_useGPU_tridiag_band = .false.  ! not yet ported
    do_useGPU_solve_tridi = do_useGPU
    do_useGPU_trans_ev_tridi_to_band = do_useGPU
    do_useGPU_trans_ev_band_to_full = do_useGPU


   reDistributeMatrix = .false.


   allocate(aIntern(1:matrixRows,1:matrixCols))
   a       => aIntern(1:matrixRows,1:matrixCols)

   allocate(evIntern(1:obj%na))
   ev      => evIntern(1:obj%na)

   if (present(qExtern)) then
     allocate(qIntern(1:matrixRows,1:matrixCols))
   endif
   !TODO: intel gpu
   ! in case of devcice pointer _AND_ redistribute
   ! 1. copy aExtern to aIntern_dummy
   ! 2. redistribute aIntern_dummy to aIntern


   successGPU = gpu_memcpy(c_loc(aIntern(1,1)), aExtern, matrixRows*matrixCols*size_of_datatype, &
                             gpuMemcpyDeviceToHost)
   call check_memcpy_GPU_f("elpa2: aExtern -> aIntern", 548,  successGPU)


     a       => aIntern(1:matrixRows,1:matrixCols)
     if (present(qExtern)) then
       q       => qIntern(1:matrixRows,1:matrixCols)
     endif

   ev      => evIntern(1:obj%na)

   call obj%get("output_pinning_information", pinningInfo, error)
   if (error .ne. ELPA_OK) then
     write(error_unit,*) "ELPA2: Problem setting option for debug. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

   endif

   if (pinningInfo .eq. 1) then
     call init_thread_affinity(nrThreads)

     call check_thread_affinity()
     if (my_pe .eq. 0) call print_thread_affinity(my_pe)
     call cleanup_thread_affinity()
   endif

    success = .true.

    if (present(qExtern)) then
      obj%eigenvalues_only = .false.
    else
      obj%eigenvalues_only = .true.
    endif

   ! special case na = 1
   if (na .eq. 1) then
     ev(1) = a(1,1)
     if (.not.(obj%eigenvalues_only)) then
       q(1,1) = ONE
     endif

     ! restore original OpenMP settings

     call obj%timer%stop("elpa_solve_evp_&
     &real&
     &_2stage_&
     &double&
     &")
     success = .true.
     return
   endif

   if (nev == 0) then
     nev = 1
     obj%eigenvalues_only = .true.
   endif

    !call obj%get("real_kernel", kernel, error)
    !if (error .ne. ELPA_OK) then
    !  print *,"Problem getting option for kernel settings. Aborting..."
    !  stop 1
    !endif

    isSkewsymmetric = .false.

    ! only if we want (and can) use GPU in general, look what are the
    ! requirements for individual routines. Implicitly they are all set to 1, so
    ! unless specified otherwise by the user, GPU versions of all individual
    ! routines should be used
    if (do_useGPU) then
      call obj%get("gpu_bandred", gpu, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "ELPA2: Problem getting option gpu_bandred settings. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

      endif
      do_useGPU_bandred = (gpu == 1)

      ! not yet ported
      !call obj%get("gpu_tridiag_band", gpu, error)
      !if (error .ne. ELPA_OK) then
      !  print *,"Problem getting option for gpu_tridiag_band settings. Aborting..."
      !  stop 1
      !endif
      !do_useGPU_tridiag_band = (gpu == 1)

      call obj%get("gpu_solve_tridi", gpu, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "ELPA2: Problem getting option for gpu_solve_tridi settings. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

      endif
      do_useGPU_solve_tridi = (gpu == 1)

      call obj%get("gpu_trans_ev_tridi_to_band", gpu, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "ELPA2: Problem getting option for gpu_trans_ev_tridi_to_band settings. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

      endif
      do_useGPU_trans_ev_tridi_to_band = (gpu == 1)

      call obj%get("gpu_trans_ev_band_to_full", gpu, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "ELPA2: Problem getting option for gpu_trans_ev_band_to_full settings. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

      endif
      do_useGPU_trans_ev_band_to_full = (gpu == 1)
    endif

    ! check consistency between request for GPUs and defined kernel
    if (do_useGPU_trans_ev_tridi_to_band) then
      ! if the user has set explicitely a kernel before than honour this
      ! otherwise set GPU kernel
      if (userHasSetKernel) then
        if (kernel .ne. ELPA_2STAGE_REAL_NVIDIA_GPU) then
          write(error_unit,*) "ELPA: Warning, GPU usage has been requested but compute kernel is set by the user as non-GPU!"
          write(error_unit,*) "The compute kernel will be executed on CPUs!"
          do_useGPU_trans_ev_tridi_to_band = .false.
          kernel = ELPA_2STAGE_REAL_DEFAULT
        else
          good_nblk_gpu = .false.
        endif
      else ! userHasSetKernel
        !call obj%set("real_kernel", ELPA_2STAGE_REAL_NVIDIA_GPU, error)
        !if (error .ne. ELPA_OK) then
        !  write(error_unit,*) "Cannot set kernel to GPU kernel"
        !  stop 1
        !endif

        if (my_pe .eq. 0) write(error_unit,*) "You requested the GPU version, thus the GPU kernel is activated"
        good_nblk_gpu = .false.

        kernel = ELPA_2STAGE_REAL_NVIDIA_GPU
      endif ! userHasSetKernel

      ! Accepted values are 2,4,8,16,...,512
      do i = 1,10
        if (nblk == 2**i) then
          good_nblk_gpu = .true.
          exit
        endif
      enddo

      if (.not. good_nblk_gpu .and. do_useGPU_trans_ev_tridi_to_band) then
         write(error_unit,*) "ELPA: Warning, GPU kernel only works with block size 2^n (n = 1, 2, ..., 10)!"
         write(error_unit,*) "The compute kernel will be executed on CPUs!"
         write(error_unit,*) "We recommend changing the block size to 2^n"
         do_useGPU_trans_ev_tridi_to_band = .false.
         ! should be set
         kernel = ELPA_2STAGE_REAL_DEFAULT
      endif
    endif





    ! check again, now kernel and do_useGPU_trans_ev_tridi_to_band should be
    ! finally consistent
    if (do_useGPU_trans_ev_tridi_to_band) then
      !call obj%get("real_kernel", kernel, error)
      !if (error .ne. ELPA_OK) then
      !  write(error_unit,*) "Cannot get kernel to GPU kernel"
      !  stop 1
      !endif
      if (kernel .ne. ELPA_2STAGE_REAL_NVIDIA_GPU) then
        ! this should never happen, checking as an assert
        write(error_unit,*) "ELPA: INTERNAL ERROR setting GPU kernel!  Aborting..."
        stop 1
      endif
    else ! do not use GPU
      if (kernel .eq. ELPA_2STAGE_REAL_NVIDIA_GPU) then
        ! combination not allowed
        write(error_unit,*) "ELPA: Warning, GPU usage has NOT been requested but compute kernel &
                            &is defined as the GPU kernel!  Setting default kernel"
        kernel = ELPA_2STAGE_REAL_DEFAULT
        !TODO do error handling properly
      endif
    endif



     !! consistency check: is user set kernel still identical with "kernel" or did
     !! we change it above? This is a mess and should be cleaned up
     !call obj%get("real_kernel",kernelByUser,error)
     !if (error .ne. ELPA_OK) then
     !  print *,"Problem getting option for user kernel settings. Aborting..."
     !  stop 1
     !endif

     !if (kernelByUser .ne. kernel) then
     !  call obj%set("real_kernel", kernel, error)
     !  if (error .ne. ELPA_OK) then
     !    print *,"Problem setting kernel. Aborting..."
     !    stop 1
     !  endif
     !endif


    call obj%get("qr",qr,error)
    if (error .ne. ELPA_OK) then
      print *,"ELPA2: Problem getting option for qr settings. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

    endif
    if (qr .eq. 1) then
      useQR = .true.
    else
      useQR = .false.
    endif

    useQRActual = .false.
    ! set usage of qr decomposition via API call
    if (useQR) useQRActual = .true.
    if (.not.(useQR)) useQRACtual = .false.

    if (useQRActual) then
      if (mod(na,2) .ne. 0) then
        if (wantDebug) then
          write(error_unit,*) "solve_evp_real_2stage: QR-decomposition: blocksize does not fit with matrixsize"
        endif
        write(error_unit,*) "Do not use QR-decomposition for this matrix and blocksize."
        success = .false.
        return
      endif
    endif

    if (.not. obj%eigenvalues_only) then
      q_actual => q(1:matrixRows,1:matrixCols)
    else
     allocate(q_dummy(1:matrixRows,1:matrixCols), stat=istat, errmsg=errorMessage)
     call check_allocate_f("elpa2_template: q_dummy", 998,  istat,  errorMessage)
     q_actual => q_dummy(1:matrixRows,1:matrixCols)
    endif

    ! set the default values for each of the 5 compute steps
    do_bandred        = .true.
    do_tridiag        = .true.
    do_solve_tridi    = .true.
    do_trans_to_band  = .true.
    do_trans_to_full  = .true.

    if (obj%eigenvalues_only) then
      do_trans_to_band  = .false.
      do_trans_to_full  = .false.
    endif

    if (obj%is_set("bandwidth") == 1) then
      ! bandwidth is set. That means, that the inputed matrix is actually banded and thus the
      ! first step of ELPA2 should be skipped
      call obj%get("bandwidth",nbw,error)
      if (nbw == 0) then
        if (wantDebug) then
          write(error_unit,*) "Specified bandwidth = 0; ELPA refuses to solve the eigenvalue problem ", &
                              "for a diagonal matrix! This is too simple"
          endif
          write(error_unit,*) "Specified bandwidth = 0; ELPA refuses to solve the eigenvalue problem ", &
                 "for a diagonal matrix! This is too simple"
        success = .false.
        return
      endif
      if (mod(nbw, nblk) .ne. 0) then
        ! treat matrix with an effective bandwidth slightly bigger than specified bandwidth
        ! such that effective bandwidth is a multiply of nblk. which is a prerequiste for ELPA
        nbw = nblk * ceiling(real(nbw,kind=c_double)/real(nblk,kind=c_double))

        ! just check that effective bandwidth is NOT larger than matrix size
        if (nbw .gt. na) then
          if (wantDebug) then
            write(error_unit,*) "Specified bandwidth ",nbw," leads internaly to a computed bandwidth ", &
                                "which is larger than the matrix size ",na," ! ELPA will abort! Try to", &
                                "solve your problem by not specifing a bandwidth"
          endif
          print *, "Specified bandwidth ",nbw," leads internaly to a computed bandwidth ", &
                                "which is larger than the matrix size ",na," ! ELPA will abort! Try to", &
                                "solve your problem by not specifing a bandwidth"
          success = .false.
          return
        endif
      endif
      do_bandred       = .false. ! we already have a banded matrix
      do_solve_tridi   = .true.  ! we also have to solve something :-)
      do_trans_to_band = .true.  ! and still we have to backsub to banded
      do_trans_to_full = .false. ! but not to full since we have a banded matrix
    else ! matrix is not banded, determine the intermediate bandwidth for full->banded->tridi
      !first check if the intermediate bandwidth was set by the user
      call obj%get("intermediate_bandwidth", nbw, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "Problem getting option for intermediate_bandwidth. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

      endif

      if(nbw == 0) then
        ! intermediate bandwidth was not specified, select one of the defaults

        ! Choose bandwidth, must be a multiple of nblk, set to a value >= 32
        ! On older systems (IBM Bluegene/P, Intel Nehalem) a value of 32 was optimal.
        ! For Intel(R) Xeon(R) E5 v2 and v3, better use 64 instead of 32!
        ! For IBM Bluegene/Q this is not clear at the moment. We have to keep an eye
        ! on this and maybe allow a run-time optimization here
        nbw = (63/nblk+1)*nblk
      else
        ! intermediate bandwidth has been specified by the user, check, whether correctly
        if (mod(nbw, nblk) .ne. 0) then
          print *, "Specified bandwidth ",nbw," has to be mutiple of the blocksize ", nblk, ". Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

        endif
      endif !nbw == 0

      num_blocks = (na-1)/nbw + 1

      ! tmat is needed only in full->band and band->full steps, so alocate here
      ! (not allocated for banded matrix on input)
      allocate(tmat(nbw,nbw,num_blocks), stat=istat, errmsg=errorMessage)
      call check_allocate_f("elpa2_template: tmat", 1085,  istat,  errorMessage)

      do_bandred       = .true.
      do_solve_tridi   = .true.
      do_trans_to_band = .true.
      do_trans_to_full = .true.
    endif  ! matrix not already banded on input

    ! start the computations in 5 steps
    if (do_bandred) then
      call obj%autotune_timer%start("full_to_band")
      call obj%timer%start("full_to_band")
      ! Reduction full -> band
      call bandred_&
      &real&
      &_&
      &double &
      (obj, na, a, &
      matrixRows, nblk, nbw, matrixCols, num_blocks, mpi_comm_rows, mpi_comm_cols, tmat, &
      wantDebug, do_useGPU_bandred, success, &
      useQRActual, &
       nrThreads, isSkewsymmetric)

      call obj%timer%stop("full_to_band")
      call obj%autotune_timer%stop("full_to_band")
  
      if (success) then
        success_int = 0
      else
        success_int = 1
      endif

      if (useNonBlockingCollectivesAll) then
        call mpi_iallreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), &
        allreduce_request2, mpierr)
        call mpi_wait(allreduce_request2, MPI_STATUS_IGNORE, mpierr)
      else
        call mpi_allreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), mpierr)
      endif
      if (success_int .eq. 1) then
        write(error_unit,*) "ELPA2: bandred returned an error. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

      endif
    endif

     ! Reduction band -> tridiagonal
     if (do_tridiag) then
       allocate(e(na), stat=istat, errmsg=errorMessage)
       call check_allocate_f("elpa2_template: e", 1143,  istat,  errorMessage)

       call obj%autotune_timer%start("band_to_tridi")
       call obj%timer%start("band_to_tridi")
       call tridiag_band_&
       &real&
       &_&
       &double&
       (obj, na, nbw, nblk, a, matrixRows, ev, e, matrixCols, hh_trans, mpi_comm_rows, mpi_comm_cols, mpi_comm_all, &
       do_useGPU_tridiag_band, wantDebug, nrThreads, isSkewsymmetric, success)
  
       if (success) then
         success_int = 0
       else
         success_int = 1
       endif

       if (useNonBlockingCollectivesAll) then
         call mpi_iallreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), &
         allreduce_request3, mpierr)
         call mpi_wait(allreduce_request3, MPI_STATUS_IGNORE, mpierr)
       else
         call mpi_allreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), mpierr)
       endif
       if (success_int .eq. 1) then
         write(error_unit,*) "Error in tridiag_band. Aborting..."
         return
       endif

       call obj%timer%start("mpi_communication")
       if (useNonBlockingCollectivesAll) then
         call mpi_ibcast(ev, int(na,kind=MPI_KIND), MPI_REAL8, 0_MPI_KIND, int(mpi_comm_all,kind=MPI_KIND), bcast_request1, mpierr)
         call mpi_ibcast(e, int(na,kind=MPI_KIND), MPI_REAL8, 0_MPI_KIND, int(mpi_comm_all,kind=MPI_KIND), bcast_request2, mpierr)

         call mpi_wait(bcast_request1, MPI_STATUS_IGNORE, mpierr)
         call mpi_wait(bcast_request2, MPI_STATUS_IGNORE, mpierr)
       else
         call mpi_bcast(ev, int(na,kind=MPI_KIND), MPI_REAL8, 0_MPI_KIND, int(mpi_comm_all,kind=MPI_KIND), mpierr)
         call mpi_bcast(e, int(na,kind=MPI_KIND), MPI_REAL8, 0_MPI_KIND, int(mpi_comm_all,kind=MPI_KIND), mpierr)
       endif
       call obj%timer%stop("mpi_communication")

       call obj%timer%stop("band_to_tridi")
       call obj%autotune_timer%stop("band_to_tridi")
     endif ! do_tridiag


     ! Solve tridiagonal system
     if (do_solve_tridi) then
       call obj%autotune_timer%start("solve")
       call obj%timer%start("solve")

       call solve_tridi_&
       &double &
       (obj, na, nev, ev, e, &
       q_actual, matrixRows,   &
       nblk, matrixCols, mpi_comm_all, mpi_comm_rows, mpi_comm_cols, do_useGPU_solve_tridi, wantDebug, &
               success, nrThreads)

       call obj%timer%stop("solve")
       call obj%autotune_timer%stop("solve")
  
       if (success) then
         success_int = 0
       else
         success_int = 1
       endif

       if (useNonBlockingCollectivesAll) then
         call mpi_iallreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), &
         allreduce_request4, mpierr)
         call mpi_wait(allreduce_request4, MPI_STATUS_IGNORE, mpierr)
       else
         call mpi_allreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), mpierr)
       endif

       if (success_int .eq. 1) then
         write(error_unit,*) "ELPA2: solve returned an error: Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

       endif
     endif ! do_solve_tridi

     deallocate(e, stat=istat, errmsg=errorMessage)
     call check_deallocate_f("elpa2_template: e", 1257,  istat,  errorMessage)

     if (obj%eigenvalues_only) then
       do_trans_to_band = .false.
       do_trans_to_full = .false.
     else
       call obj%get("check_pd",check_pd,error)
       if (error .ne. ELPA_OK) then
         write(error_unit,*) "Problem getting option for check_pd. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

       endif
       if (check_pd .eq. 1) then
         call obj%get("thres_pd_&
         &double&
         &",thres_pd,error)
         if (error .ne. ELPA_OK) then
            write(error_unit,*) "Problem getting option for thres_pd_&
            &double&
            &. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

         endif

         check_pd = 0
         do i = 1, na
           if (ev(i) .gt. thres_pd) then
             check_pd = check_pd + 1
           endif
         enddo
         if (check_pd .lt. na) then
           ! not positiv definite => eigenvectors needed
           do_trans_to_band = .true.
           do_trans_to_full = .true.
         else
           do_trans_to_band = .false.
           do_trans_to_full = .false.
         endif
       endif
     endif ! eigenvalues only


       if (isSkewsymmetric) then
       ! Extra transformation step for skew-symmetric matrix. Multiplication with diagonal complex matrix D.
       ! This makes the eigenvectors complex.
       ! For now real part of eigenvectors is generated in first half of q, imaginary part in second part.
         q(1:matrixRows, matrixCols+1:2*matrixCols) = 0.0
         do i = 1, matrixRows
!          global_index = indxl2g(i, nblk, my_prow, 0, np_rows)
           global_index = np_rows*nblk*((i-1)/nblk) + MOD(i-1,nblk) + MOD(np_rows+my_prow-0, np_rows)*nblk + 1
           if (mod(global_index-1,4) .eq. 0) then
              ! do nothing
           end if
           if (mod(global_index-1,4) .eq. 1) then
              q(i,matrixCols+1:2*matrixCols) = q(i,1:matrixCols)
              q(i,1:matrixCols) = 0
           end if
           if (mod(global_index-1,4) .eq. 2) then
              q(i,1:matrixCols) = -q(i,1:matrixCols)
           end if
           if (mod(global_index-1,4) .eq. 3) then
              q(i,matrixCols+1:2*matrixCols) = -q(i,1:matrixCols)
              q(i,1:matrixCols) = 0
           end if
         end do
       endif

       ! Backtransform stage 1
     if (do_trans_to_band) then

       !debug
!#if defined(WITH_OPENMP_OFFLOAD_GPU_VERSION) || defined(WITH_SYCL_GPU_VERSION)
       !if (gpu_vendor() == OPENMP_OFFLOAD_GPU .or. gpu_vendor() == SYCL_GPU) then
       call obj%autotune_timer%start("tridi_to_band")
       call obj%timer%start("tridi_to_band")
       ! In the skew-symmetric case this transforms the real part
       call trans_ev_tridi_to_band_&
       &real&
       &_&
       &double &
       (obj, na, nev, nblk, nbw, q, &
       matrixRows, matrixCols, hh_trans, my_pe, mpi_comm_rows, mpi_comm_cols, &
       wantDebug, do_useGPU_trans_ev_tridi_to_band, &
       nrThreads, success=success, kernel=kernel)
       call obj%timer%stop("tridi_to_band")
       call obj%autotune_timer%stop("tridi_to_band")

       if (success) then
         success_int = 0
       else
         success_int = 1
       endif

       if (useNonBlockingCollectivesAll) then
         call mpi_iallreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), &
         allreduce_request5, mpierr)
         call mpi_wait(allreduce_request5, MPI_STATUS_IGNORE, mpierr)
       else
         call mpi_allreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), mpierr)
       endif

       if (success_int .eq. 1) then
         write(error_unit,*) "ELPA2: trans_ev_tridi_to_band returned an error. Aborting..."
         return
       endif

     endif ! do_trans_to_band

     ! the array q (currently) always resides on host even when using GPU

     if (do_trans_to_full) then
       call obj%autotune_timer%start("band_to_full")
       call obj%timer%start("band_to_full")
       ! Backtransform stage 2
       ! In the skew-symemtric case this transforms the real part
       call trans_ev_band_to_full_&
       &real&
       &_&
       &double &
       (obj, na, nev, nblk, nbw, a, &
       matrixRows, tmat, q,  &
       matrixRows, matrixCols, num_blocks, mpi_comm_rows, mpi_comm_cols, do_useGPU_trans_ev_band_to_full &
       , useQRActual  &
       , success)
       call obj%timer%stop("band_to_full")
       call obj%autotune_timer%stop("band_to_full")

       if (success) then
         success_int = 0
       else
         success_int = 1
       endif

       if (useNonBlockingCollectivesAll) then
         call mpi_iallreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), &
         allreduce_request6, mpierr)
         call mpi_wait(allreduce_request6, MPI_STATUS_IGNORE, mpierr)
       else
         call mpi_allreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), mpierr)
       endif
       if (success_int .eq. 1) then
         write(error_unit,*) "Error in trans_ev_band_to_full. Aborting..."
         return
       endif
     endif ! do_trans_to_full
! #ifdef 
!        call prmat(na,useGPU,q(1:matrixRows, 1:matrixCols),q_dev,matrixRows,matrixCols,nblk,my_prow,my_pcol,np_rows,np_cols,'R',1)
! #endif


     !skew symmetric imaginary part for tridi_to_band and band_to_full
     if (isSkewsymmetric) then
       if (do_trans_to_band) then
         call obj%autotune_timer%start("tridi_to_band")
         call obj%timer%start("skew_tridi_to_band")
         ! Transform imaginary part
         ! Transformation of real and imaginary part could also be one call of trans_ev_tridi acting on the n x 2n matrix.
         call trans_ev_tridi_to_band_&
         &real&
         &_&
         &double &
         (obj, na, nev, nblk, nbw, q(1:matrixRows, matrixCols+1:2*matrixCols), &
         matrixRows, matrixCols, hh_trans, my_pe, mpi_comm_rows, mpi_comm_cols, &
         wantDebug, do_useGPU_trans_ev_tridi_to_band, &
         nrThreads, success=success, kernel=kernel)

         call obj%timer%stop("skew_tridi_to_band")
         call obj%autotune_timer%stop("tridi_to_band")

         if (success) then
           success_int = 0
         else
           success_int = 1
         endif

         if (useNonBlockingCollectivesAll) then
           call mpi_iallreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), &
           allreduce_request7, mpierr)
           call mpi_wait(allreduce_request7, MPI_STATUS_IGNORE, mpierr)
         else
           call mpi_allreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), mpierr)
         endif
         if (success_int .eq. 1) then
          write(error_unit,*) "Error in trans_ev_tridi_to_band (imaginary part). Aborting..."
          return
         endif
       endif ! do_trans_tridi_to_band

       if (do_trans_to_full) then
       call obj%autotune_timer%start("band_to_full")
       call obj%timer%start("band_to_full")
         ! Transform imaginary part
         ! Transformation of real and imaginary part could also be one call of trans_ev_band_to_full_ acting on the n x 2n matrix.
         call trans_ev_band_to_full_&
         &real&
         &_&
         &double &
         (obj, na, nev, nblk, nbw, a, &
         matrixRows, tmat, q(1:matrixRows, matrixCols+1:2*matrixCols),  &
         matrixRows, matrixCols, num_blocks, mpi_comm_rows, mpi_comm_cols, do_useGPU_trans_ev_band_to_full, &
         useQRActual, &
         success)

         call obj%timer%stop("band_to_full")
         call obj%autotune_timer%stop("band_to_full")

         if (success) then
           success_int = 0
         else
           success_int = 1
         endif

         if (useNonBlockingCollectivesAll) then
           call mpi_iallreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), &
           allreduce_request8, mpierr)
           call mpi_wait(allreduce_request8, MPI_STATUS_IGNORE, mpierr)
         else
           call mpi_allreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), mpierr)
         endif
         if (success_int .eq. 1) then
          write(error_unit,*) "Error in trans_ev_band_to_full (imaginary part). Aborting..."
          return
         endif
       endif ! do_trans_to_full
     endif ! isSkewSymmetric


     ! We can now deallocate the stored householder vectors
     deallocate(hh_trans, stat=istat, errmsg=errorMessage)
     call check_deallocate_f("elpa2_template: hh_trans", 1537,  istat,  errorMessage)

     ! make sure tmat is deallocated when using check_pd
     if (allocated(tmat)) then
       deallocate(tmat, stat=istat, errmsg=errorMessage)
       call check_deallocate_f("elpa2_template: tmat", 1542,  istat,  errorMessage)
     endif

     if (obj%eigenvalues_only) then
       deallocate(q_dummy, stat=istat, errmsg=errorMessage)
       call check_deallocate_f("elpa2_template: q_dummy", 1547,  istat,  errorMessage)
     endif

     ! restore original OpenMP settings



   !copy qIntern and ev to provided device pointers
   if (present(qExtern)) then
   successGPU = gpu_memcpy(qExtern, c_loc(qIntern(1,1)), obj%local_nrows*obj%local_ncols*size_of_datatype, &
                             gpuMemcpyHostToDevice)
   endif
   call check_memcpy_GPU_f("elpa1: qIntern -> qExtern", 1607,  successGPU)
   successGPU = gpu_memcpy(evExtern, c_loc(ev(1)), obj%na*size_of_real_datatype, &
                             gpuMemcpyHostToDevice)
   call check_memcpy_GPU_f("elpa1: ev -> evExtern", 1610,  successGPU)


     deallocate(aIntern)
     !deallocate(evIntern)
     nullify(evIntern)
     if (present(qExtern)) then
       deallocate(qIntern)
     endif



   nullify(ev)
   nullify(a)
   nullify(q)

  nullify(q_actual)

     call obj%timer%stop("elpa_solve_evp_&
     &real&
     &_2stage_&
     &double&
     &")
1    format(a,f10.3)

   end function

! vim: syntax=fortran



















!-------------------------------------------------------------------------------
!>  \brief elpa_solve_evp_real_2stage_host_arrays_single_impl: Fortran function to solve the single-precision real eigenvalue problem with a 2 stage approach
!>
!>  Parameters
!>
!>  \param na                                   Order of matrix a
!>
!>  \param nev                                  Number of eigenvalues needed
!>
!>  \param a(lda,matrixCols)                    Distributed matrix for which eigenvalues are to be computed.
!>                                              Distribution is like in Scalapack.
!>                                              The full matrix must be set (not only one half like in scalapack).
!>                                              Destroyed on exit (upper and lower half).
!>
!>  \param lda                                  Leading dimension of a
!>
!>  \param ev(na)                               On output: eigenvalues of a, every processor gets the complete set
!>
!>  \param q(ldq,matrixCols)                    On output: Eigenvectors of a
!>                                              Distribution is like in Scalapack.
!>                                              Must be always dimensioned to the full size (corresponding to (na,na))
!>                                              even if only a part of the eigenvalues is needed.
!>
!>  \param ldq                                  Leading dimension of q
!>
!>  \param nblk                                 blocksize of cyclic distribution, must be the same in both directions!
!>
!>  \param matrixCols                           local columns of matrix a and q
!>
!>  \param mpi_comm_rows                        MPI communicator for rows
!>  \param mpi_comm_cols                        MPI communicator for columns
!>  \param mpi_comm_all                         MPI communicator for the total processor set
!>
!>  \param kernel                               specify ELPA2 kernel to use
!>
!>  \param useQR (optional)                     use QR decomposition
!>  \param useGPU (optional)                    decide whether GPUs should be used or not
!>
!>  \result success                             logical, false if error occured
!-------------------------------------------------------------------------------


!cannot use "../src/elpa2/../general/error_checking.inc" because filename with path can be too long for gfortran (max line length)


 function elpa_solve_evp_&
  &real&
  &_&
  &2stage_a_h_a_&
  &single&
  &_impl (obj, &
   aExtern, &
   evExtern, &
   qExtern) result(success)

   !use matrix_plot
   use elpa_abstract_impl
   use elpa_utilities
   use elpa1_compute
   use elpa2_compute
   use elpa_mpi
   use cuda_functions
   use hip_functions
   use elpa_gpu
   use mod_check_for_gpu
   use elpa_omp
   use solve_tridi
   use thread_affinity
   use, intrinsic :: iso_c_binding
   implicit none
!    Copyright 2011, A. Marek
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
!
  integer, parameter :: rk = C_FLOAT
  integer, parameter :: rck = C_FLOAT
  real(kind=rck), parameter      :: ZERO=0.0_rk, ONE = 1.0_rk

   class(elpa_abstract_impl_t), intent(inout)                         :: obj
   logical                                                            :: useGPU
   logical                                                            :: isSkewsymmetric
   logical                                                            :: useQR
   logical                                                            :: useQRActual
   integer(kind=c_int)                                                :: kernel, kernelByUser
   logical                                                            :: userHasSetKernel

   
!#ifdef REDISTRIBUTE_MATRIX

   real(kind=c_float), intent(inout), target         :: aExtern(obj%local_nrows,*)
   real(kind=c_float), optional, intent(out), target :: qExtern(obj%local_nrows,*)

!#else 
!
!#ifdef 1
!   real(kind=c_float), intent(inout)                 :: a(obj%local_nrows,*)
!   real(kind=c_float), optional, intent(out), target :: q(obj%local_nrows,*)
!#else
!   real(kind=c_float), intent(inout)                 :: a(obj%local_nrows,obj%local_ncols)
!#ifdef ACTIVATE_SKEW
!   real(kind=c_float), optional, target, intent(out) :: q(obj%local_nrows,2*obj%local_ncols)
!#else
!   real(kind=c_float), optional, target, intent(out) :: q(obj%local_nrows,obj%local_ncols)
!#endif
!#endif
!
!#endif 


    real(kind=rck), pointer                                  :: a(:,:)
    real(kind=rck), pointer                                  :: q(:,:)
    real(kind=rk4), pointer                                  :: ev(:)

   real(kind=c_float), target, intent(inout)                  :: evExtern(obj%na)

   real(kind=c_float), allocatable                   :: hh_trans(:,:)

   integer(kind=c_int)                                                :: my_pe, n_pes, my_prow, my_pcol, np_rows, np_cols
   integer(kind=MPI_KIND)                                             :: my_peMPI, n_pesMPI, my_prowMPI, my_pcolMPI, &
                                                                         np_rowsMPI, np_colsMPI, mpierr
   integer(kind=c_int)                                                :: nbw, num_blocks
   real(kind=c_float), allocatable                   :: tmat(:,:,:)
   real(kind=c_float), allocatable                            :: e(:)
   real(kind=c_float), allocatable, target           :: q_dummy(:,:)
   real(kind=c_float), pointer                       :: q_actual(:,:)


   integer(kind=c_int)                                                :: i
   logical                                                            :: success, successGPU
   integer(kind=c_int)                                                :: success_int
   logical                                                            :: wantDebug
   integer(kind=c_int)                                                :: istat, gpu, skewsymmetric, debug, qr
   character(200)                                                     :: errorMessage
   logical                                                            :: do_useGPU, do_useGPU_bandred, &
                                                                         do_useGPU_tridiag_band, do_useGPU_solve_tridi, &
                                                                         do_useGPU_trans_ev_tridi_to_band, &
                                                                         do_useGPU_trans_ev_band_to_full
   integer(kind=c_int)                                                :: numberOfGPUDevices
   integer(kind=c_intptr_t), parameter                                :: size_of_datatype = size_of_&
                                                                                            &single&
                                                                                            &_&
                                                                                            &real
   integer(kind=c_intptr_t), parameter                                :: size_of_real_datatype = size_of_&
                                                                                                 &single&
                                                                                                 &_real
   integer(kind=ik)                                                   :: na, nev, nblk, matrixCols, &
                                                                         mpi_comm_rows, mpi_comm_cols,        &
                                                                         mpi_comm_all, check_pd, error, matrixRows
   real(kind=c_float)                                         :: thres_pd

   real(kind=rck), pointer                                   :: aIntern(:,:)
   real(kind=c_float), pointer                       :: qIntern(:,:)
   real(kind=rk4), pointer                                  :: evIntern(:)

   logical                                                            :: do_bandred, do_tridiag, do_solve_tridi,  &
                                                                         do_trans_to_band, do_trans_to_full
   logical                                                            :: good_nblk_gpu

   integer(kind=ik)                                                   :: nrThreads, limitThreads
   integer(kind=ik)                                                   :: global_index
   logical                                                            :: reDistributeMatrix, doRedistributeMatrix
   integer(kind=ik)                                                   :: pinningInfo

   integer(kind=MPI_KIND)                                             :: bcast_request1, bcast_request2, allreduce_request1, &
                                                                         allreduce_request2, allreduce_request3, &
                                                                         allreduce_request4, allreduce_request5, &
                                                                         allreduce_request6, allreduce_request7, &
                                                                         allreduce_request8
   logical                                                            :: useNonBlockingCollectivesAll
   integer(kind=ik)                                                   :: gpu_old, gpu_new
   integer(kind=ik)                                                   :: non_blocking_collectives_all













    call obj%timer%start("elpa_solve_evp_&
    &real&
    &_2stage_&
    &single&
    &")

    call obj%get("debug",debug, error)
    if (error .ne. ELPA_OK) then
      write(error_unit,*) "ELPA2: Problem getting option for debug settings. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

    endif

    wantDebug = debug == 1

    ! check legacy GPU setings
    ! check legacy GPU setings
    if (obj%is_set("gpu") == 1) then
      write(error_unit,*) "You still use the deprecated option 'gpu', consider switching to 'nvidia-gpu'"
      call obj%get("gpu", gpu_old, error)     
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "GPU_SOLVER : Problem getting option for gpu. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_evp_&
     &real&
     &_1stage_&
     &single&
     &")
     success = .false.
     return
      endif
      if (obj%is_set("nvidia-gpu") == 0) then
        ! set gpu and nvidia-gpu consistent
        call obj%set("nvidia-gpu", gpu_old, error)
        if (error .ne. ELPA_OK) then
          write(error_unit,*) "GPU_SOLVER : Problem setting option for nvidia-gpu. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_evp_&
     &real&
     &_1stage_&
     &single&
     &")
     success = .false.
     return
        endif
        write(error_unit,*) "Will set the new keyword 'nvidia-gpu' now."
        write(error_unit,*) "And ignore the 'gpu' keyword from now on"
      else ! obj%is_set("nvidia-gpu") == 0
        call obj%get("nvidia-gpu", gpu_new, error)
        if (error .ne. ELPA_OK) then
          write(error_unit,*) "GPU_SOLVER : Problem getting option for nvidia-gpu. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_evp_&
     &real&
     &_1stage_&
     &single&
     &")
     success = .false.
     return
        endif
        if (gpu_old .ne. gpu_new) then
                write(error_unit,*) "Please do not set 'gpu' but 'nvidia-gpu' instead"
          write(error_unit,*) "You cannot set gpu = ",gpu_old," and nvidia-gpu=",gpu_new,". Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_evp_&
     &real&
     &_1stage_&
     &single&
     &")
     success = .false.
     return
        endif
      endif ! obj%is_set("nvidia-gpu") == 0
      if (obj%is_set("amd-gpu") == 0) then
        ! amd-gpu is not set, but gpu is set
        ! this is ok in anycase
      else ! obj%is_set("amd-gpu") == 0
        call obj%get("amd-gpu", gpu_new, error)
        if (error .ne. ELPA_OK) then
          write(error_unit,*) "GPU_SOLVER : Problem getting option for amd-gpu. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_evp_&
     &real&
     &_1stage_&
     &single&
     &")
     success = .false.
     return
        endif
        ! this is ok, if gpu == 0 and amd-gpu == 1 or
        !             if gpu == 0 and amd-gpu == 0 or
        !             if gpu == 1 and amd-gpu == 0
        if (gpu_old .eq. 1 .and. gpu_new .eq. 1) then
          write(error_unit,*) "GPU_SOLVER : You cannot set gpu = 1 and amd-gpu = 1. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_evp_&
     &real&
     &_1stage_&
     &single&
     &")
     success = .false.
     return
        endif
      endif ! amd-gpu
      if (obj%is_set("intel-gpu") == 0) then
        ! intel-gpu is not set, but gpu is set
        ! this is ok in anycase
      else ! obj%is_set("intel-gpu") == 0
        call obj%get("intel-gpu", gpu_new, error)
        if (error .ne. ELPA_OK) then
          write(error_unit,*) "GPU_SOLVER : Problem getting option for intel-gpu. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_evp_&
     &real&
     &_1stage_&
     &single&
     &")
     success = .false.
     return
        endif
        ! this is ok, if gpu == 0 and intel-gpu == 1 or
        !             if gpu == 0 and intel-gpu == 0 or
        !             if gpu == 1 and intel-gpu == 0
        if (gpu_old .eq. 1 .and. gpu_new .eq. 1) then
          write(error_unit,*) "GPU_SOLVER : You cannot set gpu = 1 and intel-gpu = 1. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_evp_&
     &real&
     &_1stage_&
     &single&
     &")
     success = .false.
     return
        endif
      endif ! intel-gpu
    else ! gpu not set
      ! nothing to do since the legacy option is not set
    endif ! gpu is set

    ! GPU settings
    if (gpu_vendor() == NVIDIA_GPU) then
      call obj%get("nvidia-gpu", gpu, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "GPU_SOLVER : Problem getting option for NVIDIA GPU. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_evp_&
     &real&
     &_1stage_&
     &single&
     &")
     success = .false.
     return
      endif
    else if (gpu_vendor() == AMD_GPU) then
      call obj%get("amd-gpu", gpu, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "GPU_SOLVER : Problem getting option for AMD GPU. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_evp_&
     &real&
     &_1stage_&
     &single&
     &")
     success = .false.
     return
      endif
    else if (gpu_vendor() == INTEL_GPU) then
      call obj%get("intel-gpu", gpu, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "GPU_SOLVER : Problem getting option for INTEL GPU. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_evp_&
     &real&
     &_1stage_&
     &single&
     &")
     success = .false.
     return
      endif
    else ! no supported gpu
      gpu = 0
    endif

   if (gpu .eq. 1) then
     useGPU =.true.
   else
     useGPU = .false.
   endif


    do_useGPU = .false.

    ! get the kernel and check whether it has been set by the user
    if (obj%is_set("real_kernel") == 1) then
      userHasSetKernel = .true.
    else
      userHasSetKernel = .false.
    endif

    ! after this point you may _never_ call get for the kernel again, or set the
    ! kernel !! The reason is that we might have to adjust the kernel, which is
    ! passed as a variable
    call obj%get("real_kernel", kernel, error)
    if (error .ne. ELPA_OK) then
      write(error_unit,*) "ELPA2: Problem getting option for kernel settings. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

    endif

    ! to implement a possibiltiy to set this
    useNonBlockingCollectivesAll = .false.

    call obj%get("mpi_comm_rows",mpi_comm_rows, error)
    if (error .ne. ELPA_OK) then
      write(error_unit,*) "ELPA2: Problem getting option for mpi_comm_rows. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

    endif
    call obj%get("mpi_comm_cols",mpi_comm_cols,error)
    if (error .ne. ELPA_OK) then
      write(error_unit,*) "ELPA2: Problem getting option for mpi_comm_cols. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

    endif
    call obj%get("mpi_comm_parent",mpi_comm_all,error)
    if (error .ne. ELPA_OK) then
      write(error_unit,*) "ELPA2: Problem getting option for mpi_comm_parent. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

    endif

    call obj%timer%start("mpi_communication")
    call mpi_comm_rank(int(mpi_comm_all,kind=MPI_KIND) ,my_peMPI ,mpierr)
    call mpi_comm_size(int(mpi_comm_all,kind=MPI_KIND) ,n_pesMPI ,mpierr)

    call mpi_comm_rank(int(mpi_comm_rows,kind=MPI_KIND) ,my_prowMPI ,mpierr)
    call mpi_comm_size(int(mpi_comm_rows,kind=MPI_KIND) ,np_rowsMPI ,mpierr)
    call mpi_comm_rank(int(mpi_comm_cols,kind=MPI_KIND) ,my_pcolMPI ,mpierr)
    call mpi_comm_size(int(mpi_comm_cols,kind=MPI_KIND) ,np_colsMPI ,mpierr)

    my_pe = int(my_peMPI, kind=c_int)
    n_pes = int(n_pesMPI, kind=c_int)
    my_prow = int(my_prowMPI, kind=c_int)
    np_rows = int(np_rowsMPI, kind=c_int)
    my_pcol = int(my_pcolMPI, kind=c_int)
    np_cols = int(np_colsMPI, kind=c_int)

    call obj%timer%stop("mpi_communication")

    na         = obj%na
    nev        = obj%nev
    nblk       = obj%nblk
    matrixCols = obj%local_ncols
    matrixRows = obj%local_nrows

    call obj%get("nbc_all_elpa2_main", non_blocking_collectives_all, error)
    if (error .ne. ELPA_OK) then
      write(error_unit,*) "ELPA2: Problem getting option for non blocking collectives. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

    endif

    if (non_blocking_collectives_all .eq. 1) then
      useNonBlockingCollectivesAll = .true.
    else
      useNonBlockingCollectivesAll = .false.
    endif

    ! openmp setting
    nrThreads = 1


    if (useGPU) then
      call obj%timer%start("check_for_gpu")
      if (check_for_gpu(obj, my_pe, numberOfGPUDevices, wantDebug=wantDebug)) then
        do_useGPU = .true.
        ! set the neccessary parameters
        call set_gpu_parameters()

      else
        write(error_unit,*) "ELPA2: GPUs are requested but not detected! Aborting..."
        call obj%timer%stop("check_for_gpu")
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

      endif
      call obj%timer%stop("check_for_gpu")

      if (nblk*(max(np_rows,np_cols)-1) >= na) then
        if (my_pe .eq. 0) then
          write(error_unit,*) "ELPA: Warning, block size too large for this matrix size and process grid!"
          write(error_unit,*) "Choose a smaller block size if possible.",nblk*(max(np_rows,np_cols)-1),na
          write(error_unit,*) "Disabling GPU usage! "
        endif

        do_useGPU = .false.
        if (kernel .eq. ELPA_2STAGE_REAL_NVIDIA_GPU) then
          if (userHasSetKernel) then
            ! user fixed inconsistent input.
            ! sadly, we do have to abort
            if (my_pe .eq. 0) then
              write(error_unit,*) "You set (fixed) the kernel to GPU, but GPUs cannot be used."
              write(error_unit,*) "Either adapt the block size or the process grid, or do not set the GPU kernel! Aborting..."
            endif
            stop 1
          else
            ! here we should set the default kernel
            kernel = ELPA_2STAGE_REAL_DEFAULT
          endif
        endif
      endif

    endif ! useGPU




    do_useGPU_bandred = do_useGPU
    do_useGPU_tridiag_band = .false.  ! not yet ported
    do_useGPU_solve_tridi = do_useGPU
    do_useGPU_trans_ev_tridi_to_band = do_useGPU
    do_useGPU_trans_ev_band_to_full = do_useGPU


   reDistributeMatrix = .false.



   ! aIntern, qIntern, are normally pointers since no matrix redistribution is used
   ! point them to  the external arrays
   aIntern => aExtern(1:matrixRows,1:matrixCols)
   if (present(qExtern)) then
     qIntern => qExtern(1:matrixRows,1:matrixCols)
   endif

  ! whether a matrix redistribution or not is happening we still
  ! have to point ev
   evIntern => evExtern(1:obj%na)

     a       => aIntern(1:matrixRows,1:matrixCols)
     if (present(qExtern)) then
       q       => qIntern(1:matrixRows,1:matrixCols)
     endif

   ev      => evIntern(1:obj%na)

   call obj%get("output_pinning_information", pinningInfo, error)
   if (error .ne. ELPA_OK) then
     write(error_unit,*) "ELPA2: Problem setting option for debug. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

   endif

   if (pinningInfo .eq. 1) then
     call init_thread_affinity(nrThreads)

     call check_thread_affinity()
     if (my_pe .eq. 0) call print_thread_affinity(my_pe)
     call cleanup_thread_affinity()
   endif

    success = .true.

    if (present(qExtern)) then
      obj%eigenvalues_only = .false.
    else
      obj%eigenvalues_only = .true.
    endif

   ! special case na = 1
   if (na .eq. 1) then
     ev(1) = a(1,1)
     if (.not.(obj%eigenvalues_only)) then
       q(1,1) = ONE
     endif

     ! restore original OpenMP settings

     call obj%timer%stop("elpa_solve_evp_&
     &real&
     &_2stage_&
     &single&
     &")
     success = .true.
     return
   endif

   if (nev == 0) then
     nev = 1
     obj%eigenvalues_only = .true.
   endif

    !call obj%get("real_kernel", kernel, error)
    !if (error .ne. ELPA_OK) then
    !  print *,"Problem getting option for kernel settings. Aborting..."
    !  stop 1
    !endif

    isSkewsymmetric = .false.

    ! only if we want (and can) use GPU in general, look what are the
    ! requirements for individual routines. Implicitly they are all set to 1, so
    ! unless specified otherwise by the user, GPU versions of all individual
    ! routines should be used
    if (do_useGPU) then
      call obj%get("gpu_bandred", gpu, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "ELPA2: Problem getting option gpu_bandred settings. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

      endif
      do_useGPU_bandred = (gpu == 1)

      ! not yet ported
      !call obj%get("gpu_tridiag_band", gpu, error)
      !if (error .ne. ELPA_OK) then
      !  print *,"Problem getting option for gpu_tridiag_band settings. Aborting..."
      !  stop 1
      !endif
      !do_useGPU_tridiag_band = (gpu == 1)

      call obj%get("gpu_solve_tridi", gpu, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "ELPA2: Problem getting option for gpu_solve_tridi settings. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

      endif
      do_useGPU_solve_tridi = (gpu == 1)

      call obj%get("gpu_trans_ev_tridi_to_band", gpu, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "ELPA2: Problem getting option for gpu_trans_ev_tridi_to_band settings. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

      endif
      do_useGPU_trans_ev_tridi_to_band = (gpu == 1)

      call obj%get("gpu_trans_ev_band_to_full", gpu, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "ELPA2: Problem getting option for gpu_trans_ev_band_to_full settings. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

      endif
      do_useGPU_trans_ev_band_to_full = (gpu == 1)
    endif

    ! check consistency between request for GPUs and defined kernel
    if (do_useGPU_trans_ev_tridi_to_band) then
      ! if the user has set explicitely a kernel before than honour this
      ! otherwise set GPU kernel
      if (userHasSetKernel) then
        if (kernel .ne. ELPA_2STAGE_REAL_NVIDIA_GPU) then
          write(error_unit,*) "ELPA: Warning, GPU usage has been requested but compute kernel is set by the user as non-GPU!"
          write(error_unit,*) "The compute kernel will be executed on CPUs!"
          do_useGPU_trans_ev_tridi_to_band = .false.
          kernel = ELPA_2STAGE_REAL_DEFAULT
        else
          good_nblk_gpu = .false.
        endif
      else ! userHasSetKernel
        !call obj%set("real_kernel", ELPA_2STAGE_REAL_NVIDIA_GPU, error)
        !if (error .ne. ELPA_OK) then
        !  write(error_unit,*) "Cannot set kernel to GPU kernel"
        !  stop 1
        !endif

        if (my_pe .eq. 0) write(error_unit,*) "You requested the GPU version, thus the GPU kernel is activated"
        good_nblk_gpu = .false.

        kernel = ELPA_2STAGE_REAL_NVIDIA_GPU
      endif ! userHasSetKernel

      ! Accepted values are 2,4,8,16,...,512
      do i = 1,10
        if (nblk == 2**i) then
          good_nblk_gpu = .true.
          exit
        endif
      enddo

      if (.not. good_nblk_gpu .and. do_useGPU_trans_ev_tridi_to_band) then
         write(error_unit,*) "ELPA: Warning, GPU kernel only works with block size 2^n (n = 1, 2, ..., 10)!"
         write(error_unit,*) "The compute kernel will be executed on CPUs!"
         write(error_unit,*) "We recommend changing the block size to 2^n"
         do_useGPU_trans_ev_tridi_to_band = .false.
         ! should be set
         kernel = ELPA_2STAGE_REAL_DEFAULT
      endif
    endif





    ! check again, now kernel and do_useGPU_trans_ev_tridi_to_band should be
    ! finally consistent
    if (do_useGPU_trans_ev_tridi_to_band) then
      !call obj%get("real_kernel", kernel, error)
      !if (error .ne. ELPA_OK) then
      !  write(error_unit,*) "Cannot get kernel to GPU kernel"
      !  stop 1
      !endif
      if (kernel .ne. ELPA_2STAGE_REAL_NVIDIA_GPU) then
        ! this should never happen, checking as an assert
        write(error_unit,*) "ELPA: INTERNAL ERROR setting GPU kernel!  Aborting..."
        stop 1
      endif
    else ! do not use GPU
      if (kernel .eq. ELPA_2STAGE_REAL_NVIDIA_GPU) then
        ! combination not allowed
        write(error_unit,*) "ELPA: Warning, GPU usage has NOT been requested but compute kernel &
                            &is defined as the GPU kernel!  Setting default kernel"
        kernel = ELPA_2STAGE_REAL_DEFAULT
        !TODO do error handling properly
      endif
    endif

    ! special case at the moment NO single precision kernels on POWER 8 -> set GENERIC for now
    if (kernel .eq. ELPA_2STAGE_REAL_VSX_BLOCK2 .or. &
        kernel .eq. ELPA_2STAGE_REAL_VSX_BLOCK4 .or. &
        kernel .eq. ELPA_2STAGE_REAL_VSX_BLOCK6        ) then
        write(error_unit,*) "ELPA: At the moment there exist no specific SINGLE precision kernels for POWER8"
        write(error_unit,*) "The GENERIC kernel will be used at the moment"
        kernel = ELPA_2STAGE_REAL_GENERIC
    endif
    ! special case at the moment NO single precision kernels on SPARC64 -> set GENERIC for now
    if (kernel .eq. ELPA_2STAGE_REAL_SPARC64_BLOCK2 .or. &
        kernel .eq. ELPA_2STAGE_REAL_SPARC64_BLOCK4 .or. &
        kernel .eq. ELPA_2STAGE_REAL_SPARC64_BLOCK6        ) then
        write(error_unit,*) "ELPA: At the moment there exist no specific SINGLE precision kernels for SPARC64"
        write(error_unit,*) "The GENERIC kernel will be used at the moment"
        kernel = ELPA_2STAGE_REAL_GENERIC
    endif


     !! consistency check: is user set kernel still identical with "kernel" or did
     !! we change it above? This is a mess and should be cleaned up
     !call obj%get("real_kernel",kernelByUser,error)
     !if (error .ne. ELPA_OK) then
     !  print *,"Problem getting option for user kernel settings. Aborting..."
     !  stop 1
     !endif

     !if (kernelByUser .ne. kernel) then
     !  call obj%set("real_kernel", kernel, error)
     !  if (error .ne. ELPA_OK) then
     !    print *,"Problem setting kernel. Aborting..."
     !    stop 1
     !  endif
     !endif


    call obj%get("qr",qr,error)
    if (error .ne. ELPA_OK) then
      print *,"ELPA2: Problem getting option for qr settings. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

    endif
    if (qr .eq. 1) then
      useQR = .true.
    else
      useQR = .false.
    endif

    useQRActual = .false.
    ! set usage of qr decomposition via API call
    if (useQR) useQRActual = .true.
    if (.not.(useQR)) useQRACtual = .false.

    if (useQRActual) then
      if (mod(na,2) .ne. 0) then
        if (wantDebug) then
          write(error_unit,*) "solve_evp_real_2stage: QR-decomposition: blocksize does not fit with matrixsize"
        endif
        write(error_unit,*) "Do not use QR-decomposition for this matrix and blocksize."
        success = .false.
        return
      endif
    endif

    if (.not. obj%eigenvalues_only) then
      q_actual => q(1:matrixRows,1:matrixCols)
    else
     allocate(q_dummy(1:matrixRows,1:matrixCols), stat=istat, errmsg=errorMessage)
     call check_allocate_f("elpa2_template: q_dummy", 998,  istat,  errorMessage)
     q_actual => q_dummy(1:matrixRows,1:matrixCols)
    endif

    ! set the default values for each of the 5 compute steps
    do_bandred        = .true.
    do_tridiag        = .true.
    do_solve_tridi    = .true.
    do_trans_to_band  = .true.
    do_trans_to_full  = .true.

    if (obj%eigenvalues_only) then
      do_trans_to_band  = .false.
      do_trans_to_full  = .false.
    endif

    if (obj%is_set("bandwidth") == 1) then
      ! bandwidth is set. That means, that the inputed matrix is actually banded and thus the
      ! first step of ELPA2 should be skipped
      call obj%get("bandwidth",nbw,error)
      if (nbw == 0) then
        if (wantDebug) then
          write(error_unit,*) "Specified bandwidth = 0; ELPA refuses to solve the eigenvalue problem ", &
                              "for a diagonal matrix! This is too simple"
          endif
          write(error_unit,*) "Specified bandwidth = 0; ELPA refuses to solve the eigenvalue problem ", &
                 "for a diagonal matrix! This is too simple"
        success = .false.
        return
      endif
      if (mod(nbw, nblk) .ne. 0) then
        ! treat matrix with an effective bandwidth slightly bigger than specified bandwidth
        ! such that effective bandwidth is a multiply of nblk. which is a prerequiste for ELPA
        nbw = nblk * ceiling(real(nbw,kind=c_double)/real(nblk,kind=c_double))

        ! just check that effective bandwidth is NOT larger than matrix size
        if (nbw .gt. na) then
          if (wantDebug) then
            write(error_unit,*) "Specified bandwidth ",nbw," leads internaly to a computed bandwidth ", &
                                "which is larger than the matrix size ",na," ! ELPA will abort! Try to", &
                                "solve your problem by not specifing a bandwidth"
          endif
          print *, "Specified bandwidth ",nbw," leads internaly to a computed bandwidth ", &
                                "which is larger than the matrix size ",na," ! ELPA will abort! Try to", &
                                "solve your problem by not specifing a bandwidth"
          success = .false.
          return
        endif
      endif
      do_bandred       = .false. ! we already have a banded matrix
      do_solve_tridi   = .true.  ! we also have to solve something :-)
      do_trans_to_band = .true.  ! and still we have to backsub to banded
      do_trans_to_full = .false. ! but not to full since we have a banded matrix
    else ! matrix is not banded, determine the intermediate bandwidth for full->banded->tridi
      !first check if the intermediate bandwidth was set by the user
      call obj%get("intermediate_bandwidth", nbw, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "Problem getting option for intermediate_bandwidth. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

      endif

      if(nbw == 0) then
        ! intermediate bandwidth was not specified, select one of the defaults

        ! Choose bandwidth, must be a multiple of nblk, set to a value >= 32
        ! On older systems (IBM Bluegene/P, Intel Nehalem) a value of 32 was optimal.
        ! For Intel(R) Xeon(R) E5 v2 and v3, better use 64 instead of 32!
        ! For IBM Bluegene/Q this is not clear at the moment. We have to keep an eye
        ! on this and maybe allow a run-time optimization here
        nbw = (63/nblk+1)*nblk
      else
        ! intermediate bandwidth has been specified by the user, check, whether correctly
        if (mod(nbw, nblk) .ne. 0) then
          print *, "Specified bandwidth ",nbw," has to be mutiple of the blocksize ", nblk, ". Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

        endif
      endif !nbw == 0

      num_blocks = (na-1)/nbw + 1

      ! tmat is needed only in full->band and band->full steps, so alocate here
      ! (not allocated for banded matrix on input)
      allocate(tmat(nbw,nbw,num_blocks), stat=istat, errmsg=errorMessage)
      call check_allocate_f("elpa2_template: tmat", 1085,  istat,  errorMessage)

      do_bandred       = .true.
      do_solve_tridi   = .true.
      do_trans_to_band = .true.
      do_trans_to_full = .true.
    endif  ! matrix not already banded on input

    ! start the computations in 5 steps
    if (do_bandred) then
      call obj%autotune_timer%start("full_to_band")
      call obj%timer%start("full_to_band")
      ! Reduction full -> band
      call bandred_&
      &real&
      &_&
      &single &
      (obj, na, a, &
      matrixRows, nblk, nbw, matrixCols, num_blocks, mpi_comm_rows, mpi_comm_cols, tmat, &
      wantDebug, do_useGPU_bandred, success, &
      useQRActual, &
       nrThreads, isSkewsymmetric)

      call obj%timer%stop("full_to_band")
      call obj%autotune_timer%stop("full_to_band")
  
      if (success) then
        success_int = 0
      else
        success_int = 1
      endif

      if (useNonBlockingCollectivesAll) then
        call mpi_iallreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), &
        allreduce_request2, mpierr)
        call mpi_wait(allreduce_request2, MPI_STATUS_IGNORE, mpierr)
      else
        call mpi_allreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), mpierr)
      endif
      if (success_int .eq. 1) then
        write(error_unit,*) "ELPA2: bandred returned an error. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

      endif
    endif

     ! Reduction band -> tridiagonal
     if (do_tridiag) then
       allocate(e(na), stat=istat, errmsg=errorMessage)
       call check_allocate_f("elpa2_template: e", 1143,  istat,  errorMessage)

       call obj%autotune_timer%start("band_to_tridi")
       call obj%timer%start("band_to_tridi")
       call tridiag_band_&
       &real&
       &_&
       &single&
       (obj, na, nbw, nblk, a, matrixRows, ev, e, matrixCols, hh_trans, mpi_comm_rows, mpi_comm_cols, mpi_comm_all, &
       do_useGPU_tridiag_band, wantDebug, nrThreads, isSkewsymmetric, success)
  
       if (success) then
         success_int = 0
       else
         success_int = 1
       endif

       if (useNonBlockingCollectivesAll) then
         call mpi_iallreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), &
         allreduce_request3, mpierr)
         call mpi_wait(allreduce_request3, MPI_STATUS_IGNORE, mpierr)
       else
         call mpi_allreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), mpierr)
       endif
       if (success_int .eq. 1) then
         write(error_unit,*) "Error in tridiag_band. Aborting..."
         return
       endif

       call obj%timer%start("mpi_communication")
       if (useNonBlockingCollectivesAll) then
         call mpi_ibcast(ev, int(na,kind=MPI_KIND), MPI_REAL4, 0_MPI_KIND, int(mpi_comm_all,kind=MPI_KIND), bcast_request1, mpierr)
         call mpi_ibcast(e, int(na,kind=MPI_KIND), MPI_REAL4, 0_MPI_KIND, int(mpi_comm_all,kind=MPI_KIND), bcast_request2, mpierr)

         call mpi_wait(bcast_request1, MPI_STATUS_IGNORE, mpierr)
         call mpi_wait(bcast_request2, MPI_STATUS_IGNORE, mpierr)
       else
         call mpi_bcast(ev, int(na,kind=MPI_KIND), MPI_REAL4, 0_MPI_KIND, int(mpi_comm_all,kind=MPI_KIND), mpierr)
         call mpi_bcast(e, int(na,kind=MPI_KIND), MPI_REAL4, 0_MPI_KIND, int(mpi_comm_all,kind=MPI_KIND), mpierr)
       endif
       call obj%timer%stop("mpi_communication")

       call obj%timer%stop("band_to_tridi")
       call obj%autotune_timer%stop("band_to_tridi")
     endif ! do_tridiag


     ! Solve tridiagonal system
     if (do_solve_tridi) then
       call obj%autotune_timer%start("solve")
       call obj%timer%start("solve")

       call solve_tridi_&
       &single &
       (obj, na, nev, ev, e, &
       q_actual, matrixRows,   &
       nblk, matrixCols, mpi_comm_all, mpi_comm_rows, mpi_comm_cols, do_useGPU_solve_tridi, wantDebug, &
               success, nrThreads)

       call obj%timer%stop("solve")
       call obj%autotune_timer%stop("solve")
  
       if (success) then
         success_int = 0
       else
         success_int = 1
       endif

       if (useNonBlockingCollectivesAll) then
         call mpi_iallreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), &
         allreduce_request4, mpierr)
         call mpi_wait(allreduce_request4, MPI_STATUS_IGNORE, mpierr)
       else
         call mpi_allreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), mpierr)
       endif

       if (success_int .eq. 1) then
         write(error_unit,*) "ELPA2: solve returned an error: Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

       endif
     endif ! do_solve_tridi

     deallocate(e, stat=istat, errmsg=errorMessage)
     call check_deallocate_f("elpa2_template: e", 1257,  istat,  errorMessage)

     if (obj%eigenvalues_only) then
       do_trans_to_band = .false.
       do_trans_to_full = .false.
     else
       call obj%get("check_pd",check_pd,error)
       if (error .ne. ELPA_OK) then
         write(error_unit,*) "Problem getting option for check_pd. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

       endif
       if (check_pd .eq. 1) then
         call obj%get("thres_pd_&
         &single&
         &",thres_pd,error)
         if (error .ne. ELPA_OK) then
            write(error_unit,*) "Problem getting option for thres_pd_&
            &single&
            &. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

         endif

         check_pd = 0
         do i = 1, na
           if (ev(i) .gt. thres_pd) then
             check_pd = check_pd + 1
           endif
         enddo
         if (check_pd .lt. na) then
           ! not positiv definite => eigenvectors needed
           do_trans_to_band = .true.
           do_trans_to_full = .true.
         else
           do_trans_to_band = .false.
           do_trans_to_full = .false.
         endif
       endif
     endif ! eigenvalues only


       if (isSkewsymmetric) then
       ! Extra transformation step for skew-symmetric matrix. Multiplication with diagonal complex matrix D.
       ! This makes the eigenvectors complex.
       ! For now real part of eigenvectors is generated in first half of q, imaginary part in second part.
         q(1:matrixRows, matrixCols+1:2*matrixCols) = 0.0
         do i = 1, matrixRows
!          global_index = indxl2g(i, nblk, my_prow, 0, np_rows)
           global_index = np_rows*nblk*((i-1)/nblk) + MOD(i-1,nblk) + MOD(np_rows+my_prow-0, np_rows)*nblk + 1
           if (mod(global_index-1,4) .eq. 0) then
              ! do nothing
           end if
           if (mod(global_index-1,4) .eq. 1) then
              q(i,matrixCols+1:2*matrixCols) = q(i,1:matrixCols)
              q(i,1:matrixCols) = 0
           end if
           if (mod(global_index-1,4) .eq. 2) then
              q(i,1:matrixCols) = -q(i,1:matrixCols)
           end if
           if (mod(global_index-1,4) .eq. 3) then
              q(i,matrixCols+1:2*matrixCols) = -q(i,1:matrixCols)
              q(i,1:matrixCols) = 0
           end if
         end do
       endif

       ! Backtransform stage 1
     if (do_trans_to_band) then

       !debug
!#if defined(WITH_OPENMP_OFFLOAD_GPU_VERSION) || defined(WITH_SYCL_GPU_VERSION)
       !if (gpu_vendor() == OPENMP_OFFLOAD_GPU .or. gpu_vendor() == SYCL_GPU) then
       call obj%autotune_timer%start("tridi_to_band")
       call obj%timer%start("tridi_to_band")
       ! In the skew-symmetric case this transforms the real part
       call trans_ev_tridi_to_band_&
       &real&
       &_&
       &single &
       (obj, na, nev, nblk, nbw, q, &
       matrixRows, matrixCols, hh_trans, my_pe, mpi_comm_rows, mpi_comm_cols, &
       wantDebug, do_useGPU_trans_ev_tridi_to_band, &
       nrThreads, success=success, kernel=kernel)
       call obj%timer%stop("tridi_to_band")
       call obj%autotune_timer%stop("tridi_to_band")

       if (success) then
         success_int = 0
       else
         success_int = 1
       endif

       if (useNonBlockingCollectivesAll) then
         call mpi_iallreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), &
         allreduce_request5, mpierr)
         call mpi_wait(allreduce_request5, MPI_STATUS_IGNORE, mpierr)
       else
         call mpi_allreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), mpierr)
       endif

       if (success_int .eq. 1) then
         write(error_unit,*) "ELPA2: trans_ev_tridi_to_band returned an error. Aborting..."
         return
       endif

     endif ! do_trans_to_band

     ! the array q (currently) always resides on host even when using GPU

     if (do_trans_to_full) then
       call obj%autotune_timer%start("band_to_full")
       call obj%timer%start("band_to_full")
       ! Backtransform stage 2
       ! In the skew-symemtric case this transforms the real part
       call trans_ev_band_to_full_&
       &real&
       &_&
       &single &
       (obj, na, nev, nblk, nbw, a, &
       matrixRows, tmat, q,  &
       matrixRows, matrixCols, num_blocks, mpi_comm_rows, mpi_comm_cols, do_useGPU_trans_ev_band_to_full &
       , useQRActual  &
       , success)
       call obj%timer%stop("band_to_full")
       call obj%autotune_timer%stop("band_to_full")

       if (success) then
         success_int = 0
       else
         success_int = 1
       endif

       if (useNonBlockingCollectivesAll) then
         call mpi_iallreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), &
         allreduce_request6, mpierr)
         call mpi_wait(allreduce_request6, MPI_STATUS_IGNORE, mpierr)
       else
         call mpi_allreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), mpierr)
       endif
       if (success_int .eq. 1) then
         write(error_unit,*) "Error in trans_ev_band_to_full. Aborting..."
         return
       endif
     endif ! do_trans_to_full
! #ifdef DOUBLE_PRECISION_REAL
!        call prmat(na,useGPU,q(1:matrixRows, 1:matrixCols),q_dev,matrixRows,matrixCols,nblk,my_prow,my_pcol,np_rows,np_cols,'R',1)
! #endif


     !skew symmetric imaginary part for tridi_to_band and band_to_full
     if (isSkewsymmetric) then
       if (do_trans_to_band) then
         call obj%autotune_timer%start("tridi_to_band")
         call obj%timer%start("skew_tridi_to_band")
         ! Transform imaginary part
         ! Transformation of real and imaginary part could also be one call of trans_ev_tridi acting on the n x 2n matrix.
         call trans_ev_tridi_to_band_&
         &real&
         &_&
         &single &
         (obj, na, nev, nblk, nbw, q(1:matrixRows, matrixCols+1:2*matrixCols), &
         matrixRows, matrixCols, hh_trans, my_pe, mpi_comm_rows, mpi_comm_cols, &
         wantDebug, do_useGPU_trans_ev_tridi_to_band, &
         nrThreads, success=success, kernel=kernel)

         call obj%timer%stop("skew_tridi_to_band")
         call obj%autotune_timer%stop("tridi_to_band")

         if (success) then
           success_int = 0
         else
           success_int = 1
         endif

         if (useNonBlockingCollectivesAll) then
           call mpi_iallreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), &
           allreduce_request7, mpierr)
           call mpi_wait(allreduce_request7, MPI_STATUS_IGNORE, mpierr)
         else
           call mpi_allreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), mpierr)
         endif
         if (success_int .eq. 1) then
          write(error_unit,*) "Error in trans_ev_tridi_to_band (imaginary part). Aborting..."
          return
         endif
       endif ! do_trans_tridi_to_band

       if (do_trans_to_full) then
       call obj%autotune_timer%start("band_to_full")
       call obj%timer%start("band_to_full")
         ! Transform imaginary part
         ! Transformation of real and imaginary part could also be one call of trans_ev_band_to_full_ acting on the n x 2n matrix.
         call trans_ev_band_to_full_&
         &real&
         &_&
         &single &
         (obj, na, nev, nblk, nbw, a, &
         matrixRows, tmat, q(1:matrixRows, matrixCols+1:2*matrixCols),  &
         matrixRows, matrixCols, num_blocks, mpi_comm_rows, mpi_comm_cols, do_useGPU_trans_ev_band_to_full, &
         useQRActual, &
         success)

         call obj%timer%stop("band_to_full")
         call obj%autotune_timer%stop("band_to_full")

         if (success) then
           success_int = 0
         else
           success_int = 1
         endif

         if (useNonBlockingCollectivesAll) then
           call mpi_iallreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), &
           allreduce_request8, mpierr)
           call mpi_wait(allreduce_request8, MPI_STATUS_IGNORE, mpierr)
         else
           call mpi_allreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), mpierr)
         endif
         if (success_int .eq. 1) then
          write(error_unit,*) "Error in trans_ev_band_to_full (imaginary part). Aborting..."
          return
         endif
       endif ! do_trans_to_full
     endif ! isSkewSymmetric


     ! We can now deallocate the stored householder vectors
     deallocate(hh_trans, stat=istat, errmsg=errorMessage)
     call check_deallocate_f("elpa2_template: hh_trans", 1537,  istat,  errorMessage)

     ! make sure tmat is deallocated when using check_pd
     if (allocated(tmat)) then
       deallocate(tmat, stat=istat, errmsg=errorMessage)
       call check_deallocate_f("elpa2_template: tmat", 1542,  istat,  errorMessage)
     endif

     if (obj%eigenvalues_only) then
       deallocate(q_dummy, stat=istat, errmsg=errorMessage)
       call check_deallocate_f("elpa2_template: q_dummy", 1547,  istat,  errorMessage)
     endif

     ! restore original OpenMP settings



   nullify(aIntern)
   nullify(evIntern)
   if (present(qExtern)) then
     nullify(qIntern)
   endif

   nullify(ev)
   nullify(a)
   nullify(q)

  nullify(q_actual)

     call obj%timer%stop("elpa_solve_evp_&
     &real&
     &_2stage_&
     &single&
     &")
1    format(a,f10.3)

   end function

! vim: syntax=fortran



















!-------------------------------------------------------------------------------
!>  \brief elpa_solve_evp_real_2stage_d_ptr_single_impl: Fortran function to solve the single-precision real eigenvalue problem with a 2 stage approach
!>
!>  Parameters
!>
!>  \param na                                   Order of matrix a
!>
!>  \param nev                                  Number of eigenvalues needed
!>
!>  \param a                                    Distributed matrix for which eigenvalues are to be computed.
!>                                              Distribution is like in Scalapack.
!>                                              The full matrix must be set (not only one half like in scalapack).
!>                                              Destroyed on exit (upper and lower half).
!>
!>  \param lda                                  Leading dimension of a
!>
!>  \param ev                                   On output: eigenvalues of a, every processor gets the complete set
!>
!>  \param q                                    On output: Eigenvectors of a
!>                                              Distribution is like in Scalapack.
!>                                              Must be always dimensioned to the full size (corresponding to (na,na))
!>                                              even if only a part of the eigenvalues is needed.
!>
!>  \param ldq                                  Leading dimension of q
!>
!>  \param nblk                                 blocksize of cyclic distribution, must be the same in both directions!
!>
!>  \param matrixCols                           local columns of matrix a and q
!>
!>  \param mpi_comm_rows                        MPI communicator for rows
!>  \param mpi_comm_cols                        MPI communicator for columns
!>  \param mpi_comm_all                         MPI communicator for the total processor set
!>
!>  \param kernel                               specify ELPA2 kernel to use
!>
!>  \param useQR (optional)                     use QR decomposition
!>  \param useGPU (optional)                    decide whether GPUs should be used or not
!>
!>  \result success                             logical, false if error occured
!-------------------------------------------------------------------------------


!cannot use "../src/elpa2/../general/error_checking.inc" because filename with path can be too long for gfortran (max line length)


 function elpa_solve_evp_&
  &real&
  &_&
  &2stage_d_ptr_&
  &single&
  &_impl (obj, &
   aExtern, &
   evExtern, &
   qExtern) result(success)

   !use matrix_plot
   use elpa_abstract_impl
   use elpa_utilities
   use elpa1_compute
   use elpa2_compute
   use elpa_mpi
   use cuda_functions
   use hip_functions
   use elpa_gpu
   use mod_check_for_gpu
   use elpa_omp
   use solve_tridi
   use thread_affinity
   use, intrinsic :: iso_c_binding
   implicit none
!    Copyright 2011, A. Marek
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
!
  integer, parameter :: rk = C_FLOAT
  integer, parameter :: rck = C_FLOAT
  real(kind=rck), parameter      :: ZERO=0.0_rk, ONE = 1.0_rk

   class(elpa_abstract_impl_t), intent(inout)                         :: obj
   logical                                                            :: useGPU
   logical                                                            :: isSkewsymmetric
   logical                                                            :: useQR
   logical                                                            :: useQRActual
   integer(kind=c_int)                                                :: kernel, kernelByUser
   logical                                                            :: userHasSetKernel


!#ifdef REDISTRIBUTE_MATRIX
   type(c_ptr)                                                        :: aExtern
   type(c_ptr), optional                                              :: qExtern
!#else 
!   type(c_ptr)                                                        :: a, q
!#endif 


    real(kind=rck), pointer                                  :: a(:,:)
    real(kind=rck), pointer                                  :: q(:,:)
    real(kind=rk4), pointer                                  :: ev(:)

   type(c_ptr)                                                        :: evExtern

   real(kind=c_float), allocatable                   :: hh_trans(:,:)

   integer(kind=c_int)                                                :: my_pe, n_pes, my_prow, my_pcol, np_rows, np_cols
   integer(kind=MPI_KIND)                                             :: my_peMPI, n_pesMPI, my_prowMPI, my_pcolMPI, &
                                                                         np_rowsMPI, np_colsMPI, mpierr
   integer(kind=c_int)                                                :: nbw, num_blocks
   real(kind=c_float), allocatable                   :: tmat(:,:,:)
   real(kind=c_float), allocatable                            :: e(:)
   real(kind=c_float), allocatable, target           :: q_dummy(:,:)
   real(kind=c_float), pointer                       :: q_actual(:,:)


   integer(kind=c_int)                                                :: i
   logical                                                            :: success, successGPU
   integer(kind=c_int)                                                :: success_int
   logical                                                            :: wantDebug
   integer(kind=c_int)                                                :: istat, gpu, skewsymmetric, debug, qr
   character(200)                                                     :: errorMessage
   logical                                                            :: do_useGPU, do_useGPU_bandred, &
                                                                         do_useGPU_tridiag_band, do_useGPU_solve_tridi, &
                                                                         do_useGPU_trans_ev_tridi_to_band, &
                                                                         do_useGPU_trans_ev_band_to_full
   integer(kind=c_int)                                                :: numberOfGPUDevices
   integer(kind=c_intptr_t), parameter                                :: size_of_datatype = size_of_&
                                                                                            &single&
                                                                                            &_&
                                                                                            &real
   integer(kind=c_intptr_t), parameter                                :: size_of_real_datatype = size_of_&
                                                                                                 &single&
                                                                                                 &_real
   integer(kind=ik)                                                   :: na, nev, nblk, matrixCols, &
                                                                         mpi_comm_rows, mpi_comm_cols,        &
                                                                         mpi_comm_all, check_pd, error, matrixRows
   real(kind=c_float)                                         :: thres_pd

   real(kind=rck), pointer                                   :: aIntern(:,:)
   real(kind=c_float), pointer                       :: qIntern(:,:)
   real(kind=rk4), pointer                                  :: evIntern(:)

   logical                                                            :: do_bandred, do_tridiag, do_solve_tridi,  &
                                                                         do_trans_to_band, do_trans_to_full
   logical                                                            :: good_nblk_gpu

   integer(kind=ik)                                                   :: nrThreads, limitThreads
   integer(kind=ik)                                                   :: global_index
   logical                                                            :: reDistributeMatrix, doRedistributeMatrix
   integer(kind=ik)                                                   :: pinningInfo

   integer(kind=MPI_KIND)                                             :: bcast_request1, bcast_request2, allreduce_request1, &
                                                                         allreduce_request2, allreduce_request3, &
                                                                         allreduce_request4, allreduce_request5, &
                                                                         allreduce_request6, allreduce_request7, &
                                                                         allreduce_request8
   logical                                                            :: useNonBlockingCollectivesAll
   integer(kind=ik)                                                   :: gpu_old, gpu_new
   integer(kind=ik)                                                   :: non_blocking_collectives_all













    call obj%timer%start("elpa_solve_evp_&
    &real&
    &_2stage_&
    &single&
    &")

    call obj%get("debug",debug, error)
    if (error .ne. ELPA_OK) then
      write(error_unit,*) "ELPA2: Problem getting option for debug settings. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

    endif

    wantDebug = debug == 1

    ! check legacy GPU setings
    ! check legacy GPU setings
    if (obj%is_set("gpu") == 1) then
      write(error_unit,*) "You still use the deprecated option 'gpu', consider switching to 'nvidia-gpu'"
      call obj%get("gpu", gpu_old, error)     
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "GPU_SOLVER : Problem getting option for gpu. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_evp_&
     &real&
     &_1stage_&
     &single&
     &")
     success = .false.
     return
      endif
      if (obj%is_set("nvidia-gpu") == 0) then
        ! set gpu and nvidia-gpu consistent
        call obj%set("nvidia-gpu", gpu_old, error)
        if (error .ne. ELPA_OK) then
          write(error_unit,*) "GPU_SOLVER : Problem setting option for nvidia-gpu. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_evp_&
     &real&
     &_1stage_&
     &single&
     &")
     success = .false.
     return
        endif
        write(error_unit,*) "Will set the new keyword 'nvidia-gpu' now."
        write(error_unit,*) "And ignore the 'gpu' keyword from now on"
      else ! obj%is_set("nvidia-gpu") == 0
        call obj%get("nvidia-gpu", gpu_new, error)
        if (error .ne. ELPA_OK) then
          write(error_unit,*) "GPU_SOLVER : Problem getting option for nvidia-gpu. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_evp_&
     &real&
     &_1stage_&
     &single&
     &")
     success = .false.
     return
        endif
        if (gpu_old .ne. gpu_new) then
                write(error_unit,*) "Please do not set 'gpu' but 'nvidia-gpu' instead"
          write(error_unit,*) "You cannot set gpu = ",gpu_old," and nvidia-gpu=",gpu_new,". Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_evp_&
     &real&
     &_1stage_&
     &single&
     &")
     success = .false.
     return
        endif
      endif ! obj%is_set("nvidia-gpu") == 0
      if (obj%is_set("amd-gpu") == 0) then
        ! amd-gpu is not set, but gpu is set
        ! this is ok in anycase
      else ! obj%is_set("amd-gpu") == 0
        call obj%get("amd-gpu", gpu_new, error)
        if (error .ne. ELPA_OK) then
          write(error_unit,*) "GPU_SOLVER : Problem getting option for amd-gpu. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_evp_&
     &real&
     &_1stage_&
     &single&
     &")
     success = .false.
     return
        endif
        ! this is ok, if gpu == 0 and amd-gpu == 1 or
        !             if gpu == 0 and amd-gpu == 0 or
        !             if gpu == 1 and amd-gpu == 0
        if (gpu_old .eq. 1 .and. gpu_new .eq. 1) then
          write(error_unit,*) "GPU_SOLVER : You cannot set gpu = 1 and amd-gpu = 1. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_evp_&
     &real&
     &_1stage_&
     &single&
     &")
     success = .false.
     return
        endif
      endif ! amd-gpu
      if (obj%is_set("intel-gpu") == 0) then
        ! intel-gpu is not set, but gpu is set
        ! this is ok in anycase
      else ! obj%is_set("intel-gpu") == 0
        call obj%get("intel-gpu", gpu_new, error)
        if (error .ne. ELPA_OK) then
          write(error_unit,*) "GPU_SOLVER : Problem getting option for intel-gpu. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_evp_&
     &real&
     &_1stage_&
     &single&
     &")
     success = .false.
     return
        endif
        ! this is ok, if gpu == 0 and intel-gpu == 1 or
        !             if gpu == 0 and intel-gpu == 0 or
        !             if gpu == 1 and intel-gpu == 0
        if (gpu_old .eq. 1 .and. gpu_new .eq. 1) then
          write(error_unit,*) "GPU_SOLVER : You cannot set gpu = 1 and intel-gpu = 1. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_evp_&
     &real&
     &_1stage_&
     &single&
     &")
     success = .false.
     return
        endif
      endif ! intel-gpu
    else ! gpu not set
      ! nothing to do since the legacy option is not set
    endif ! gpu is set

    ! GPU settings
    if (gpu_vendor() == NVIDIA_GPU) then
      call obj%get("nvidia-gpu", gpu, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "GPU_SOLVER : Problem getting option for NVIDIA GPU. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_evp_&
     &real&
     &_1stage_&
     &single&
     &")
     success = .false.
     return
      endif
    else if (gpu_vendor() == AMD_GPU) then
      call obj%get("amd-gpu", gpu, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "GPU_SOLVER : Problem getting option for AMD GPU. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_evp_&
     &real&
     &_1stage_&
     &single&
     &")
     success = .false.
     return
      endif
    else if (gpu_vendor() == INTEL_GPU) then
      call obj%get("intel-gpu", gpu, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "GPU_SOLVER : Problem getting option for INTEL GPU. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_evp_&
     &real&
     &_1stage_&
     &single&
     &")
     success = .false.
     return
      endif
    else ! no supported gpu
      gpu = 0
    endif

   if (gpu .eq. 1) then
     useGPU =.true.
   else
     write(error_unit,*) "GPU_SOLVER : You used the interface for device pointers but did not specify GPU usage!. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_evp_&
     &real&
     &_1stage_&
     &single&
     &")
     success = .false.
     return
     useGPU = .false.
   endif


    do_useGPU = .false.

    ! get the kernel and check whether it has been set by the user
    if (obj%is_set("real_kernel") == 1) then
      userHasSetKernel = .true.
    else
      userHasSetKernel = .false.
    endif

    ! after this point you may _never_ call get for the kernel again, or set the
    ! kernel !! The reason is that we might have to adjust the kernel, which is
    ! passed as a variable
    call obj%get("real_kernel", kernel, error)
    if (error .ne. ELPA_OK) then
      write(error_unit,*) "ELPA2: Problem getting option for kernel settings. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

    endif

    ! to implement a possibiltiy to set this
    useNonBlockingCollectivesAll = .false.

    call obj%get("mpi_comm_rows",mpi_comm_rows, error)
    if (error .ne. ELPA_OK) then
      write(error_unit,*) "ELPA2: Problem getting option for mpi_comm_rows. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

    endif
    call obj%get("mpi_comm_cols",mpi_comm_cols,error)
    if (error .ne. ELPA_OK) then
      write(error_unit,*) "ELPA2: Problem getting option for mpi_comm_cols. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

    endif
    call obj%get("mpi_comm_parent",mpi_comm_all,error)
    if (error .ne. ELPA_OK) then
      write(error_unit,*) "ELPA2: Problem getting option for mpi_comm_parent. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

    endif

    call obj%timer%start("mpi_communication")
    call mpi_comm_rank(int(mpi_comm_all,kind=MPI_KIND) ,my_peMPI ,mpierr)
    call mpi_comm_size(int(mpi_comm_all,kind=MPI_KIND) ,n_pesMPI ,mpierr)

    call mpi_comm_rank(int(mpi_comm_rows,kind=MPI_KIND) ,my_prowMPI ,mpierr)
    call mpi_comm_size(int(mpi_comm_rows,kind=MPI_KIND) ,np_rowsMPI ,mpierr)
    call mpi_comm_rank(int(mpi_comm_cols,kind=MPI_KIND) ,my_pcolMPI ,mpierr)
    call mpi_comm_size(int(mpi_comm_cols,kind=MPI_KIND) ,np_colsMPI ,mpierr)

    my_pe = int(my_peMPI, kind=c_int)
    n_pes = int(n_pesMPI, kind=c_int)
    my_prow = int(my_prowMPI, kind=c_int)
    np_rows = int(np_rowsMPI, kind=c_int)
    my_pcol = int(my_pcolMPI, kind=c_int)
    np_cols = int(np_colsMPI, kind=c_int)

    call obj%timer%stop("mpi_communication")

    na         = obj%na
    nev        = obj%nev
    nblk       = obj%nblk
    matrixCols = obj%local_ncols
    matrixRows = obj%local_nrows

    call obj%get("nbc_all_elpa2_main", non_blocking_collectives_all, error)
    if (error .ne. ELPA_OK) then
      write(error_unit,*) "ELPA2: Problem getting option for non blocking collectives. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

    endif

    if (non_blocking_collectives_all .eq. 1) then
      useNonBlockingCollectivesAll = .true.
    else
      useNonBlockingCollectivesAll = .false.
    endif

    ! openmp setting
    nrThreads = 1


    if (useGPU) then
      call obj%timer%start("check_for_gpu")
      if (check_for_gpu(obj, my_pe, numberOfGPUDevices, wantDebug=wantDebug)) then
        do_useGPU = .true.
        ! set the neccessary parameters
        call set_gpu_parameters()

      else
        write(error_unit,*) "ELPA2: GPUs are requested but not detected! Aborting..."
        call obj%timer%stop("check_for_gpu")
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

      endif
      call obj%timer%stop("check_for_gpu")

      if (nblk*(max(np_rows,np_cols)-1) >= na) then
        if (my_pe .eq. 0) then
          write(error_unit,*) "ELPA: Warning, block size too large for this matrix size and process grid!"
          write(error_unit,*) "Choose a smaller block size if possible.",nblk*(max(np_rows,np_cols)-1),na
          write(error_unit,*) "Disabling GPU usage! "
        endif

        do_useGPU = .false.
        if (kernel .eq. ELPA_2STAGE_REAL_NVIDIA_GPU) then
          if (userHasSetKernel) then
            ! user fixed inconsistent input.
            ! sadly, we do have to abort
            if (my_pe .eq. 0) then
              write(error_unit,*) "You set (fixed) the kernel to GPU, but GPUs cannot be used."
              write(error_unit,*) "Either adapt the block size or the process grid, or do not set the GPU kernel! Aborting..."
            endif
            stop 1
          else
            ! here we should set the default kernel
            kernel = ELPA_2STAGE_REAL_DEFAULT
          endif
        endif
      endif

    endif ! useGPU




    do_useGPU_bandred = do_useGPU
    do_useGPU_tridiag_band = .false.  ! not yet ported
    do_useGPU_solve_tridi = do_useGPU
    do_useGPU_trans_ev_tridi_to_band = do_useGPU
    do_useGPU_trans_ev_band_to_full = do_useGPU


   reDistributeMatrix = .false.


   allocate(aIntern(1:matrixRows,1:matrixCols))
   a       => aIntern(1:matrixRows,1:matrixCols)

   allocate(evIntern(1:obj%na))
   ev      => evIntern(1:obj%na)

   if (present(qExtern)) then
     allocate(qIntern(1:matrixRows,1:matrixCols))
   endif
   !TODO: intel gpu
   ! in case of devcice pointer _AND_ redistribute
   ! 1. copy aExtern to aIntern_dummy
   ! 2. redistribute aIntern_dummy to aIntern


   successGPU = gpu_memcpy(c_loc(aIntern(1,1)), aExtern, matrixRows*matrixCols*size_of_datatype, &
                             gpuMemcpyDeviceToHost)
   call check_memcpy_GPU_f("elpa2: aExtern -> aIntern", 548,  successGPU)


     a       => aIntern(1:matrixRows,1:matrixCols)
     if (present(qExtern)) then
       q       => qIntern(1:matrixRows,1:matrixCols)
     endif

   ev      => evIntern(1:obj%na)

   call obj%get("output_pinning_information", pinningInfo, error)
   if (error .ne. ELPA_OK) then
     write(error_unit,*) "ELPA2: Problem setting option for debug. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

   endif

   if (pinningInfo .eq. 1) then
     call init_thread_affinity(nrThreads)

     call check_thread_affinity()
     if (my_pe .eq. 0) call print_thread_affinity(my_pe)
     call cleanup_thread_affinity()
   endif

    success = .true.

    if (present(qExtern)) then
      obj%eigenvalues_only = .false.
    else
      obj%eigenvalues_only = .true.
    endif

   ! special case na = 1
   if (na .eq. 1) then
     ev(1) = a(1,1)
     if (.not.(obj%eigenvalues_only)) then
       q(1,1) = ONE
     endif

     ! restore original OpenMP settings

     call obj%timer%stop("elpa_solve_evp_&
     &real&
     &_2stage_&
     &single&
     &")
     success = .true.
     return
   endif

   if (nev == 0) then
     nev = 1
     obj%eigenvalues_only = .true.
   endif

    !call obj%get("real_kernel", kernel, error)
    !if (error .ne. ELPA_OK) then
    !  print *,"Problem getting option for kernel settings. Aborting..."
    !  stop 1
    !endif

    isSkewsymmetric = .false.

    ! only if we want (and can) use GPU in general, look what are the
    ! requirements for individual routines. Implicitly they are all set to 1, so
    ! unless specified otherwise by the user, GPU versions of all individual
    ! routines should be used
    if (do_useGPU) then
      call obj%get("gpu_bandred", gpu, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "ELPA2: Problem getting option gpu_bandred settings. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

      endif
      do_useGPU_bandred = (gpu == 1)

      ! not yet ported
      !call obj%get("gpu_tridiag_band", gpu, error)
      !if (error .ne. ELPA_OK) then
      !  print *,"Problem getting option for gpu_tridiag_band settings. Aborting..."
      !  stop 1
      !endif
      !do_useGPU_tridiag_band = (gpu == 1)

      call obj%get("gpu_solve_tridi", gpu, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "ELPA2: Problem getting option for gpu_solve_tridi settings. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

      endif
      do_useGPU_solve_tridi = (gpu == 1)

      call obj%get("gpu_trans_ev_tridi_to_band", gpu, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "ELPA2: Problem getting option for gpu_trans_ev_tridi_to_band settings. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

      endif
      do_useGPU_trans_ev_tridi_to_band = (gpu == 1)

      call obj%get("gpu_trans_ev_band_to_full", gpu, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "ELPA2: Problem getting option for gpu_trans_ev_band_to_full settings. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

      endif
      do_useGPU_trans_ev_band_to_full = (gpu == 1)
    endif

    ! check consistency between request for GPUs and defined kernel
    if (do_useGPU_trans_ev_tridi_to_band) then
      ! if the user has set explicitely a kernel before than honour this
      ! otherwise set GPU kernel
      if (userHasSetKernel) then
        if (kernel .ne. ELPA_2STAGE_REAL_NVIDIA_GPU) then
          write(error_unit,*) "ELPA: Warning, GPU usage has been requested but compute kernel is set by the user as non-GPU!"
          write(error_unit,*) "The compute kernel will be executed on CPUs!"
          do_useGPU_trans_ev_tridi_to_band = .false.
          kernel = ELPA_2STAGE_REAL_DEFAULT
        else
          good_nblk_gpu = .false.
        endif
      else ! userHasSetKernel
        !call obj%set("real_kernel", ELPA_2STAGE_REAL_NVIDIA_GPU, error)
        !if (error .ne. ELPA_OK) then
        !  write(error_unit,*) "Cannot set kernel to GPU kernel"
        !  stop 1
        !endif

        if (my_pe .eq. 0) write(error_unit,*) "You requested the GPU version, thus the GPU kernel is activated"
        good_nblk_gpu = .false.

        kernel = ELPA_2STAGE_REAL_NVIDIA_GPU
      endif ! userHasSetKernel

      ! Accepted values are 2,4,8,16,...,512
      do i = 1,10
        if (nblk == 2**i) then
          good_nblk_gpu = .true.
          exit
        endif
      enddo

      if (.not. good_nblk_gpu .and. do_useGPU_trans_ev_tridi_to_band) then
         write(error_unit,*) "ELPA: Warning, GPU kernel only works with block size 2^n (n = 1, 2, ..., 10)!"
         write(error_unit,*) "The compute kernel will be executed on CPUs!"
         write(error_unit,*) "We recommend changing the block size to 2^n"
         do_useGPU_trans_ev_tridi_to_band = .false.
         ! should be set
         kernel = ELPA_2STAGE_REAL_DEFAULT
      endif
    endif





    ! check again, now kernel and do_useGPU_trans_ev_tridi_to_band should be
    ! finally consistent
    if (do_useGPU_trans_ev_tridi_to_band) then
      !call obj%get("real_kernel", kernel, error)
      !if (error .ne. ELPA_OK) then
      !  write(error_unit,*) "Cannot get kernel to GPU kernel"
      !  stop 1
      !endif
      if (kernel .ne. ELPA_2STAGE_REAL_NVIDIA_GPU) then
        ! this should never happen, checking as an assert
        write(error_unit,*) "ELPA: INTERNAL ERROR setting GPU kernel!  Aborting..."
        stop 1
      endif
    else ! do not use GPU
      if (kernel .eq. ELPA_2STAGE_REAL_NVIDIA_GPU) then
        ! combination not allowed
        write(error_unit,*) "ELPA: Warning, GPU usage has NOT been requested but compute kernel &
                            &is defined as the GPU kernel!  Setting default kernel"
        kernel = ELPA_2STAGE_REAL_DEFAULT
        !TODO do error handling properly
      endif
    endif

    ! special case at the moment NO single precision kernels on POWER 8 -> set GENERIC for now
    if (kernel .eq. ELPA_2STAGE_REAL_VSX_BLOCK2 .or. &
        kernel .eq. ELPA_2STAGE_REAL_VSX_BLOCK4 .or. &
        kernel .eq. ELPA_2STAGE_REAL_VSX_BLOCK6        ) then
        write(error_unit,*) "ELPA: At the moment there exist no specific SINGLE precision kernels for POWER8"
        write(error_unit,*) "The GENERIC kernel will be used at the moment"
        kernel = ELPA_2STAGE_REAL_GENERIC
    endif
    ! special case at the moment NO single precision kernels on SPARC64 -> set GENERIC for now
    if (kernel .eq. ELPA_2STAGE_REAL_SPARC64_BLOCK2 .or. &
        kernel .eq. ELPA_2STAGE_REAL_SPARC64_BLOCK4 .or. &
        kernel .eq. ELPA_2STAGE_REAL_SPARC64_BLOCK6        ) then
        write(error_unit,*) "ELPA: At the moment there exist no specific SINGLE precision kernels for SPARC64"
        write(error_unit,*) "The GENERIC kernel will be used at the moment"
        kernel = ELPA_2STAGE_REAL_GENERIC
    endif


     !! consistency check: is user set kernel still identical with "kernel" or did
     !! we change it above? This is a mess and should be cleaned up
     !call obj%get("real_kernel",kernelByUser,error)
     !if (error .ne. ELPA_OK) then
     !  print *,"Problem getting option for user kernel settings. Aborting..."
     !  stop 1
     !endif

     !if (kernelByUser .ne. kernel) then
     !  call obj%set("real_kernel", kernel, error)
     !  if (error .ne. ELPA_OK) then
     !    print *,"Problem setting kernel. Aborting..."
     !    stop 1
     !  endif
     !endif


    call obj%get("qr",qr,error)
    if (error .ne. ELPA_OK) then
      print *,"ELPA2: Problem getting option for qr settings. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

    endif
    if (qr .eq. 1) then
      useQR = .true.
    else
      useQR = .false.
    endif

    useQRActual = .false.
    ! set usage of qr decomposition via API call
    if (useQR) useQRActual = .true.
    if (.not.(useQR)) useQRACtual = .false.

    if (useQRActual) then
      if (mod(na,2) .ne. 0) then
        if (wantDebug) then
          write(error_unit,*) "solve_evp_real_2stage: QR-decomposition: blocksize does not fit with matrixsize"
        endif
        write(error_unit,*) "Do not use QR-decomposition for this matrix and blocksize."
        success = .false.
        return
      endif
    endif

    if (.not. obj%eigenvalues_only) then
      q_actual => q(1:matrixRows,1:matrixCols)
    else
     allocate(q_dummy(1:matrixRows,1:matrixCols), stat=istat, errmsg=errorMessage)
     call check_allocate_f("elpa2_template: q_dummy", 998,  istat,  errorMessage)
     q_actual => q_dummy(1:matrixRows,1:matrixCols)
    endif

    ! set the default values for each of the 5 compute steps
    do_bandred        = .true.
    do_tridiag        = .true.
    do_solve_tridi    = .true.
    do_trans_to_band  = .true.
    do_trans_to_full  = .true.

    if (obj%eigenvalues_only) then
      do_trans_to_band  = .false.
      do_trans_to_full  = .false.
    endif

    if (obj%is_set("bandwidth") == 1) then
      ! bandwidth is set. That means, that the inputed matrix is actually banded and thus the
      ! first step of ELPA2 should be skipped
      call obj%get("bandwidth",nbw,error)
      if (nbw == 0) then
        if (wantDebug) then
          write(error_unit,*) "Specified bandwidth = 0; ELPA refuses to solve the eigenvalue problem ", &
                              "for a diagonal matrix! This is too simple"
          endif
          write(error_unit,*) "Specified bandwidth = 0; ELPA refuses to solve the eigenvalue problem ", &
                 "for a diagonal matrix! This is too simple"
        success = .false.
        return
      endif
      if (mod(nbw, nblk) .ne. 0) then
        ! treat matrix with an effective bandwidth slightly bigger than specified bandwidth
        ! such that effective bandwidth is a multiply of nblk. which is a prerequiste for ELPA
        nbw = nblk * ceiling(real(nbw,kind=c_double)/real(nblk,kind=c_double))

        ! just check that effective bandwidth is NOT larger than matrix size
        if (nbw .gt. na) then
          if (wantDebug) then
            write(error_unit,*) "Specified bandwidth ",nbw," leads internaly to a computed bandwidth ", &
                                "which is larger than the matrix size ",na," ! ELPA will abort! Try to", &
                                "solve your problem by not specifing a bandwidth"
          endif
          print *, "Specified bandwidth ",nbw," leads internaly to a computed bandwidth ", &
                                "which is larger than the matrix size ",na," ! ELPA will abort! Try to", &
                                "solve your problem by not specifing a bandwidth"
          success = .false.
          return
        endif
      endif
      do_bandred       = .false. ! we already have a banded matrix
      do_solve_tridi   = .true.  ! we also have to solve something :-)
      do_trans_to_band = .true.  ! and still we have to backsub to banded
      do_trans_to_full = .false. ! but not to full since we have a banded matrix
    else ! matrix is not banded, determine the intermediate bandwidth for full->banded->tridi
      !first check if the intermediate bandwidth was set by the user
      call obj%get("intermediate_bandwidth", nbw, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "Problem getting option for intermediate_bandwidth. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

      endif

      if(nbw == 0) then
        ! intermediate bandwidth was not specified, select one of the defaults

        ! Choose bandwidth, must be a multiple of nblk, set to a value >= 32
        ! On older systems (IBM Bluegene/P, Intel Nehalem) a value of 32 was optimal.
        ! For Intel(R) Xeon(R) E5 v2 and v3, better use 64 instead of 32!
        ! For IBM Bluegene/Q this is not clear at the moment. We have to keep an eye
        ! on this and maybe allow a run-time optimization here
        nbw = (63/nblk+1)*nblk
      else
        ! intermediate bandwidth has been specified by the user, check, whether correctly
        if (mod(nbw, nblk) .ne. 0) then
          print *, "Specified bandwidth ",nbw," has to be mutiple of the blocksize ", nblk, ". Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

        endif
      endif !nbw == 0

      num_blocks = (na-1)/nbw + 1

      ! tmat is needed only in full->band and band->full steps, so alocate here
      ! (not allocated for banded matrix on input)
      allocate(tmat(nbw,nbw,num_blocks), stat=istat, errmsg=errorMessage)
      call check_allocate_f("elpa2_template: tmat", 1085,  istat,  errorMessage)

      do_bandred       = .true.
      do_solve_tridi   = .true.
      do_trans_to_band = .true.
      do_trans_to_full = .true.
    endif  ! matrix not already banded on input

    ! start the computations in 5 steps
    if (do_bandred) then
      call obj%autotune_timer%start("full_to_band")
      call obj%timer%start("full_to_band")
      ! Reduction full -> band
      call bandred_&
      &real&
      &_&
      &single &
      (obj, na, a, &
      matrixRows, nblk, nbw, matrixCols, num_blocks, mpi_comm_rows, mpi_comm_cols, tmat, &
      wantDebug, do_useGPU_bandred, success, &
      useQRActual, &
       nrThreads, isSkewsymmetric)

      call obj%timer%stop("full_to_band")
      call obj%autotune_timer%stop("full_to_band")
  
      if (success) then
        success_int = 0
      else
        success_int = 1
      endif

      if (useNonBlockingCollectivesAll) then
        call mpi_iallreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), &
        allreduce_request2, mpierr)
        call mpi_wait(allreduce_request2, MPI_STATUS_IGNORE, mpierr)
      else
        call mpi_allreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), mpierr)
      endif
      if (success_int .eq. 1) then
        write(error_unit,*) "ELPA2: bandred returned an error. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

      endif
    endif

     ! Reduction band -> tridiagonal
     if (do_tridiag) then
       allocate(e(na), stat=istat, errmsg=errorMessage)
       call check_allocate_f("elpa2_template: e", 1143,  istat,  errorMessage)

       call obj%autotune_timer%start("band_to_tridi")
       call obj%timer%start("band_to_tridi")
       call tridiag_band_&
       &real&
       &_&
       &single&
       (obj, na, nbw, nblk, a, matrixRows, ev, e, matrixCols, hh_trans, mpi_comm_rows, mpi_comm_cols, mpi_comm_all, &
       do_useGPU_tridiag_band, wantDebug, nrThreads, isSkewsymmetric, success)
  
       if (success) then
         success_int = 0
       else
         success_int = 1
       endif

       if (useNonBlockingCollectivesAll) then
         call mpi_iallreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), &
         allreduce_request3, mpierr)
         call mpi_wait(allreduce_request3, MPI_STATUS_IGNORE, mpierr)
       else
         call mpi_allreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), mpierr)
       endif
       if (success_int .eq. 1) then
         write(error_unit,*) "Error in tridiag_band. Aborting..."
         return
       endif

       call obj%timer%start("mpi_communication")
       if (useNonBlockingCollectivesAll) then
         call mpi_ibcast(ev, int(na,kind=MPI_KIND), MPI_REAL4, 0_MPI_KIND, int(mpi_comm_all,kind=MPI_KIND), bcast_request1, mpierr)
         call mpi_ibcast(e, int(na,kind=MPI_KIND), MPI_REAL4, 0_MPI_KIND, int(mpi_comm_all,kind=MPI_KIND), bcast_request2, mpierr)

         call mpi_wait(bcast_request1, MPI_STATUS_IGNORE, mpierr)
         call mpi_wait(bcast_request2, MPI_STATUS_IGNORE, mpierr)
       else
         call mpi_bcast(ev, int(na,kind=MPI_KIND), MPI_REAL4, 0_MPI_KIND, int(mpi_comm_all,kind=MPI_KIND), mpierr)
         call mpi_bcast(e, int(na,kind=MPI_KIND), MPI_REAL4, 0_MPI_KIND, int(mpi_comm_all,kind=MPI_KIND), mpierr)
       endif
       call obj%timer%stop("mpi_communication")

       call obj%timer%stop("band_to_tridi")
       call obj%autotune_timer%stop("band_to_tridi")
     endif ! do_tridiag


     ! Solve tridiagonal system
     if (do_solve_tridi) then
       call obj%autotune_timer%start("solve")
       call obj%timer%start("solve")

       call solve_tridi_&
       &single &
       (obj, na, nev, ev, e, &
       q_actual, matrixRows,   &
       nblk, matrixCols, mpi_comm_all, mpi_comm_rows, mpi_comm_cols, do_useGPU_solve_tridi, wantDebug, &
               success, nrThreads)

       call obj%timer%stop("solve")
       call obj%autotune_timer%stop("solve")
  
       if (success) then
         success_int = 0
       else
         success_int = 1
       endif

       if (useNonBlockingCollectivesAll) then
         call mpi_iallreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), &
         allreduce_request4, mpierr)
         call mpi_wait(allreduce_request4, MPI_STATUS_IGNORE, mpierr)
       else
         call mpi_allreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), mpierr)
       endif

       if (success_int .eq. 1) then
         write(error_unit,*) "ELPA2: solve returned an error: Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

       endif
     endif ! do_solve_tridi

     deallocate(e, stat=istat, errmsg=errorMessage)
     call check_deallocate_f("elpa2_template: e", 1257,  istat,  errorMessage)

     if (obj%eigenvalues_only) then
       do_trans_to_band = .false.
       do_trans_to_full = .false.
     else
       call obj%get("check_pd",check_pd,error)
       if (error .ne. ELPA_OK) then
         write(error_unit,*) "Problem getting option for check_pd. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

       endif
       if (check_pd .eq. 1) then
         call obj%get("thres_pd_&
         &single&
         &",thres_pd,error)
         if (error .ne. ELPA_OK) then
            write(error_unit,*) "Problem getting option for thres_pd_&
            &single&
            &. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

         endif

         check_pd = 0
         do i = 1, na
           if (ev(i) .gt. thres_pd) then
             check_pd = check_pd + 1
           endif
         enddo
         if (check_pd .lt. na) then
           ! not positiv definite => eigenvectors needed
           do_trans_to_band = .true.
           do_trans_to_full = .true.
         else
           do_trans_to_band = .false.
           do_trans_to_full = .false.
         endif
       endif
     endif ! eigenvalues only


       if (isSkewsymmetric) then
       ! Extra transformation step for skew-symmetric matrix. Multiplication with diagonal complex matrix D.
       ! This makes the eigenvectors complex.
       ! For now real part of eigenvectors is generated in first half of q, imaginary part in second part.
         q(1:matrixRows, matrixCols+1:2*matrixCols) = 0.0
         do i = 1, matrixRows
!          global_index = indxl2g(i, nblk, my_prow, 0, np_rows)
           global_index = np_rows*nblk*((i-1)/nblk) + MOD(i-1,nblk) + MOD(np_rows+my_prow-0, np_rows)*nblk + 1
           if (mod(global_index-1,4) .eq. 0) then
              ! do nothing
           end if
           if (mod(global_index-1,4) .eq. 1) then
              q(i,matrixCols+1:2*matrixCols) = q(i,1:matrixCols)
              q(i,1:matrixCols) = 0
           end if
           if (mod(global_index-1,4) .eq. 2) then
              q(i,1:matrixCols) = -q(i,1:matrixCols)
           end if
           if (mod(global_index-1,4) .eq. 3) then
              q(i,matrixCols+1:2*matrixCols) = -q(i,1:matrixCols)
              q(i,1:matrixCols) = 0
           end if
         end do
       endif

       ! Backtransform stage 1
     if (do_trans_to_band) then

       !debug
!#if defined(WITH_OPENMP_OFFLOAD_GPU_VERSION) || defined(WITH_SYCL_GPU_VERSION)
       !if (gpu_vendor() == OPENMP_OFFLOAD_GPU .or. gpu_vendor() == SYCL_GPU) then
       call obj%autotune_timer%start("tridi_to_band")
       call obj%timer%start("tridi_to_band")
       ! In the skew-symmetric case this transforms the real part
       call trans_ev_tridi_to_band_&
       &real&
       &_&
       &single &
       (obj, na, nev, nblk, nbw, q, &
       matrixRows, matrixCols, hh_trans, my_pe, mpi_comm_rows, mpi_comm_cols, &
       wantDebug, do_useGPU_trans_ev_tridi_to_band, &
       nrThreads, success=success, kernel=kernel)
       call obj%timer%stop("tridi_to_band")
       call obj%autotune_timer%stop("tridi_to_band")

       if (success) then
         success_int = 0
       else
         success_int = 1
       endif

       if (useNonBlockingCollectivesAll) then
         call mpi_iallreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), &
         allreduce_request5, mpierr)
         call mpi_wait(allreduce_request5, MPI_STATUS_IGNORE, mpierr)
       else
         call mpi_allreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), mpierr)
       endif

       if (success_int .eq. 1) then
         write(error_unit,*) "ELPA2: trans_ev_tridi_to_band returned an error. Aborting..."
         return
       endif

     endif ! do_trans_to_band

     ! the array q (currently) always resides on host even when using GPU

     if (do_trans_to_full) then
       call obj%autotune_timer%start("band_to_full")
       call obj%timer%start("band_to_full")
       ! Backtransform stage 2
       ! In the skew-symemtric case this transforms the real part
       call trans_ev_band_to_full_&
       &real&
       &_&
       &single &
       (obj, na, nev, nblk, nbw, a, &
       matrixRows, tmat, q,  &
       matrixRows, matrixCols, num_blocks, mpi_comm_rows, mpi_comm_cols, do_useGPU_trans_ev_band_to_full &
       , useQRActual  &
       , success)
       call obj%timer%stop("band_to_full")
       call obj%autotune_timer%stop("band_to_full")

       if (success) then
         success_int = 0
       else
         success_int = 1
       endif

       if (useNonBlockingCollectivesAll) then
         call mpi_iallreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), &
         allreduce_request6, mpierr)
         call mpi_wait(allreduce_request6, MPI_STATUS_IGNORE, mpierr)
       else
         call mpi_allreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), mpierr)
       endif
       if (success_int .eq. 1) then
         write(error_unit,*) "Error in trans_ev_band_to_full. Aborting..."
         return
       endif
     endif ! do_trans_to_full
! #ifdef DOUBLE_PRECISION_REAL
!        call prmat(na,useGPU,q(1:matrixRows, 1:matrixCols),q_dev,matrixRows,matrixCols,nblk,my_prow,my_pcol,np_rows,np_cols,'R',1)
! #endif


     !skew symmetric imaginary part for tridi_to_band and band_to_full
     if (isSkewsymmetric) then
       if (do_trans_to_band) then
         call obj%autotune_timer%start("tridi_to_band")
         call obj%timer%start("skew_tridi_to_band")
         ! Transform imaginary part
         ! Transformation of real and imaginary part could also be one call of trans_ev_tridi acting on the n x 2n matrix.
         call trans_ev_tridi_to_band_&
         &real&
         &_&
         &single &
         (obj, na, nev, nblk, nbw, q(1:matrixRows, matrixCols+1:2*matrixCols), &
         matrixRows, matrixCols, hh_trans, my_pe, mpi_comm_rows, mpi_comm_cols, &
         wantDebug, do_useGPU_trans_ev_tridi_to_band, &
         nrThreads, success=success, kernel=kernel)

         call obj%timer%stop("skew_tridi_to_band")
         call obj%autotune_timer%stop("tridi_to_band")

         if (success) then
           success_int = 0
         else
           success_int = 1
         endif

         if (useNonBlockingCollectivesAll) then
           call mpi_iallreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), &
           allreduce_request7, mpierr)
           call mpi_wait(allreduce_request7, MPI_STATUS_IGNORE, mpierr)
         else
           call mpi_allreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), mpierr)
         endif
         if (success_int .eq. 1) then
          write(error_unit,*) "Error in trans_ev_tridi_to_band (imaginary part). Aborting..."
          return
         endif
       endif ! do_trans_tridi_to_band

       if (do_trans_to_full) then
       call obj%autotune_timer%start("band_to_full")
       call obj%timer%start("band_to_full")
         ! Transform imaginary part
         ! Transformation of real and imaginary part could also be one call of trans_ev_band_to_full_ acting on the n x 2n matrix.
         call trans_ev_band_to_full_&
         &real&
         &_&
         &single &
         (obj, na, nev, nblk, nbw, a, &
         matrixRows, tmat, q(1:matrixRows, matrixCols+1:2*matrixCols),  &
         matrixRows, matrixCols, num_blocks, mpi_comm_rows, mpi_comm_cols, do_useGPU_trans_ev_band_to_full, &
         useQRActual, &
         success)

         call obj%timer%stop("band_to_full")
         call obj%autotune_timer%stop("band_to_full")

         if (success) then
           success_int = 0
         else
           success_int = 1
         endif

         if (useNonBlockingCollectivesAll) then
           call mpi_iallreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), &
           allreduce_request8, mpierr)
           call mpi_wait(allreduce_request8, MPI_STATUS_IGNORE, mpierr)
         else
           call mpi_allreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), mpierr)
         endif
         if (success_int .eq. 1) then
          write(error_unit,*) "Error in trans_ev_band_to_full (imaginary part). Aborting..."
          return
         endif
       endif ! do_trans_to_full
     endif ! isSkewSymmetric


     ! We can now deallocate the stored householder vectors
     deallocate(hh_trans, stat=istat, errmsg=errorMessage)
     call check_deallocate_f("elpa2_template: hh_trans", 1537,  istat,  errorMessage)

     ! make sure tmat is deallocated when using check_pd
     if (allocated(tmat)) then
       deallocate(tmat, stat=istat, errmsg=errorMessage)
       call check_deallocate_f("elpa2_template: tmat", 1542,  istat,  errorMessage)
     endif

     if (obj%eigenvalues_only) then
       deallocate(q_dummy, stat=istat, errmsg=errorMessage)
       call check_deallocate_f("elpa2_template: q_dummy", 1547,  istat,  errorMessage)
     endif

     ! restore original OpenMP settings



   !copy qIntern and ev to provided device pointers
   if (present(qExtern)) then
   successGPU = gpu_memcpy(qExtern, c_loc(qIntern(1,1)), obj%local_nrows*obj%local_ncols*size_of_datatype, &
                             gpuMemcpyHostToDevice)
   endif
   call check_memcpy_GPU_f("elpa1: qIntern -> qExtern", 1607,  successGPU)
   successGPU = gpu_memcpy(evExtern, c_loc(ev(1)), obj%na*size_of_real_datatype, &
                             gpuMemcpyHostToDevice)
   call check_memcpy_GPU_f("elpa1: ev -> evExtern", 1610,  successGPU)


     deallocate(aIntern)
     !deallocate(evIntern)
     nullify(evIntern)
     if (present(qExtern)) then
       deallocate(qIntern)
     endif



   nullify(ev)
   nullify(a)
   nullify(q)

  nullify(q_actual)

     call obj%timer%stop("elpa_solve_evp_&
     &real&
     &_2stage_&
     &single&
     &")
1    format(a,f10.3)

   end function

! vim: syntax=fortran




















!>  \brief elpa_solve_evp_complex_2stage_host_arrays_double_impl: Fortran function to solve the double-precision complex eigenvalue problem with a 2 stage approach
!>
!>  Parameters
!>
!>  \param na                                   Order of matrix a
!>
!>  \param nev                                  Number of eigenvalues needed
!>
!>  \param a(lda,matrixCols)                    Distributed matrix for which eigenvalues are to be computed.
!>                                              Distribution is like in Scalapack.
!>                                              The full matrix must be set (not only one half like in scalapack).
!>                                              Destroyed on exit (upper and lower half).
!>
!>  \param lda                                  Leading dimension of a
!>
!>  \param ev(na)                               On output: eigenvalues of a, every processor gets the complete set
!>
!>  \param q(ldq,matrixCols)                    On output: Eigenvectors of a
!>                                              Distribution is like in Scalapack.
!>                                              Must be always dimensioned to the full size (corresponding to (na,na))
!>                                              even if only a part of the eigenvalues is needed.
!>
!>  \param ldq                                  Leading dimension of q
!>
!>  \param nblk                                 blocksize of cyclic distribution, must be the same in both directions!
!>
!>  \param matrixCols                           local columns of matrix a and q
!>
!>  \param mpi_comm_rows                        MPI communicator for rows
!>  \param mpi_comm_cols                        MPI communicator for columns
!>  \param mpi_comm_all                         MPI communicator for the total processor set
!>
!>  \param kernel                               specify ELPA2 kernel to use
!>  \param useGPU (optional)                    decide whether GPUs should be used or not
!>
!>  \result success                             logical, false if error occured
!-------------------------------------------------------------------------------


!cannot use "../src/elpa2/../general/error_checking.inc" because filename with path can be too long for gfortran (max line length)


 function elpa_solve_evp_&
  &complex&
  &_&
  &2stage_a_h_a_&
  &double&
  &_impl (obj, &
   aExtern, &
   evExtern, &
   qExtern) result(success)

   !use matrix_plot
   use elpa_abstract_impl
   use elpa_utilities
   use elpa1_compute
   use elpa2_compute
   use elpa_mpi
   use cuda_functions
   use hip_functions
   use elpa_gpu
   use mod_check_for_gpu
   use elpa_omp
   use solve_tridi
   use thread_affinity
   use, intrinsic :: iso_c_binding
   implicit none
!    Copyright 2011, A. Marek
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
!

  integer, parameter :: rk = C_DOUBLE
  integer, parameter :: ck = C_DOUBLE_COMPLEX
  integer, parameter :: rck = C_DOUBLE_COMPLEX
  complex(kind=rck), parameter     :: ZERO = (0.0_rk,0.0_rk), ONE = (1.0_rk,0.0_rk)
   class(elpa_abstract_impl_t), intent(inout)                         :: obj
   logical                                                            :: useGPU
   logical                                                            :: isSkewsymmetric
   integer(kind=c_int)                                                :: kernel, kernelByUser
   logical                                                            :: userHasSetKernel

   
!#ifdef REDISTRIBUTE_MATRIX

   complex(kind=c_double), intent(inout), target         :: aExtern(obj%local_nrows,*)
   complex(kind=c_double), optional, intent(out), target :: qExtern(obj%local_nrows,*)

!#else 
!
!#ifdef 1
!   complex(kind=c_double), intent(inout)                 :: a(obj%local_nrows,*)
!   complex(kind=c_double), optional, intent(out), target :: q(obj%local_nrows,*)
!#else
!   complex(kind=c_double), intent(inout)                 :: a(obj%local_nrows,obj%local_ncols)
!#ifdef ACTIVATE_SKEW
!   complex(kind=c_double), optional, target, intent(out) :: q(obj%local_nrows,2*obj%local_ncols)
!#else
!   complex(kind=c_double), optional, target, intent(out) :: q(obj%local_nrows,obj%local_ncols)
!#endif
!#endif
!
!#endif 


    complex(kind=rck), pointer                                  :: a(:,:)
    complex(kind=rck), pointer                                  :: q(:,:)
    real(kind=RK8), pointer                                  :: ev(:)

   real(kind=c_double), target, intent(inout)                  :: evExtern(obj%na)

   complex(kind=c_double), allocatable                   :: hh_trans(:,:)

   integer(kind=c_int)                                                :: my_pe, n_pes, my_prow, my_pcol, np_rows, np_cols
   integer(kind=MPI_KIND)                                             :: my_peMPI, n_pesMPI, my_prowMPI, my_pcolMPI, &
                                                                         np_rowsMPI, np_colsMPI, mpierr
   integer(kind=c_int)                                                :: nbw, num_blocks
   integer(kind=c_int)                                                :: l_cols_nev, l_rows, l_cols
   complex(kind=c_double), allocatable                   :: tmat(:,:,:)
   real(kind=c_double), allocatable                            :: e(:)
   real(kind=c_double), allocatable                            :: q_real(:,:)
   complex(kind=c_double), allocatable, target           :: q_dummy(:,:)
   complex(kind=c_double), pointer                       :: q_actual(:,:)


   integer(kind=c_int)                                                :: i
   logical                                                            :: success, successGPU
   integer(kind=c_int)                                                :: success_int
   logical                                                            :: wantDebug
   integer(kind=c_int)                                                :: istat, gpu, skewsymmetric, debug, qr
   character(200)                                                     :: errorMessage
   logical                                                            :: do_useGPU, do_useGPU_bandred, &
                                                                         do_useGPU_tridiag_band, do_useGPU_solve_tridi, &
                                                                         do_useGPU_trans_ev_tridi_to_band, &
                                                                         do_useGPU_trans_ev_band_to_full
   integer(kind=c_int)                                                :: numberOfGPUDevices
   integer(kind=c_intptr_t), parameter                                :: size_of_datatype = size_of_&
                                                                                            &double&
                                                                                            &_&
                                                                                            &complex
   integer(kind=c_intptr_t), parameter                                :: size_of_real_datatype = size_of_&
                                                                                                 &double&
                                                                                                 &_real
   integer(kind=ik)                                                   :: na, nev, nblk, matrixCols, &
                                                                         mpi_comm_rows, mpi_comm_cols,        &
                                                                         mpi_comm_all, check_pd, error, matrixRows
   real(kind=c_double)                                         :: thres_pd

   complex(kind=rck), pointer                                   :: aIntern(:,:)
   complex(kind=c_double), pointer                       :: qIntern(:,:)
   real(kind=RK8), pointer                                  :: evIntern(:)

   logical                                                            :: do_bandred, do_tridiag, do_solve_tridi,  &
                                                                         do_trans_to_band, do_trans_to_full
   logical                                                            :: good_nblk_gpu

   integer(kind=ik)                                                   :: nrThreads, limitThreads
   integer(kind=ik)                                                   :: global_index
   logical                                                            :: reDistributeMatrix, doRedistributeMatrix
   integer(kind=ik)                                                   :: pinningInfo

   integer(kind=MPI_KIND)                                             :: bcast_request1, bcast_request2, allreduce_request1, &
                                                                         allreduce_request2, allreduce_request3, &
                                                                         allreduce_request4, allreduce_request5, &
                                                                         allreduce_request6, allreduce_request7, &
                                                                         allreduce_request8
   logical                                                            :: useNonBlockingCollectivesAll
   integer(kind=ik)                                                   :: gpu_old, gpu_new
   integer(kind=ik)                                                   :: non_blocking_collectives_all











    call obj%timer%start("elpa_solve_evp_&
    &complex&
    &_2stage_&
    &double&
    &")

    call obj%get("debug",debug, error)
    if (error .ne. ELPA_OK) then
      write(error_unit,*) "ELPA2: Problem getting option for debug settings. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

    endif

    wantDebug = debug == 1

    ! check legacy GPU setings
    ! check legacy GPU setings
    if (obj%is_set("gpu") == 1) then
      write(error_unit,*) "You still use the deprecated option 'gpu', consider switching to 'nvidia-gpu'"
      call obj%get("gpu", gpu_old, error)     
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "GPU_SOLVER : Problem getting option for gpu. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_evp_&
     &complex&
     &_1stage_&
     &double&
     &")
     success = .false.
     return
      endif
      if (obj%is_set("nvidia-gpu") == 0) then
        ! set gpu and nvidia-gpu consistent
        call obj%set("nvidia-gpu", gpu_old, error)
        if (error .ne. ELPA_OK) then
          write(error_unit,*) "GPU_SOLVER : Problem setting option for nvidia-gpu. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_evp_&
     &complex&
     &_1stage_&
     &double&
     &")
     success = .false.
     return
        endif
        write(error_unit,*) "Will set the new keyword 'nvidia-gpu' now."
        write(error_unit,*) "And ignore the 'gpu' keyword from now on"
      else ! obj%is_set("nvidia-gpu") == 0
        call obj%get("nvidia-gpu", gpu_new, error)
        if (error .ne. ELPA_OK) then
          write(error_unit,*) "GPU_SOLVER : Problem getting option for nvidia-gpu. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_evp_&
     &complex&
     &_1stage_&
     &double&
     &")
     success = .false.
     return
        endif
        if (gpu_old .ne. gpu_new) then
                write(error_unit,*) "Please do not set 'gpu' but 'nvidia-gpu' instead"
          write(error_unit,*) "You cannot set gpu = ",gpu_old," and nvidia-gpu=",gpu_new,". Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_evp_&
     &complex&
     &_1stage_&
     &double&
     &")
     success = .false.
     return
        endif
      endif ! obj%is_set("nvidia-gpu") == 0
      if (obj%is_set("amd-gpu") == 0) then
        ! amd-gpu is not set, but gpu is set
        ! this is ok in anycase
      else ! obj%is_set("amd-gpu") == 0
        call obj%get("amd-gpu", gpu_new, error)
        if (error .ne. ELPA_OK) then
          write(error_unit,*) "GPU_SOLVER : Problem getting option for amd-gpu. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_evp_&
     &complex&
     &_1stage_&
     &double&
     &")
     success = .false.
     return
        endif
        ! this is ok, if gpu == 0 and amd-gpu == 1 or
        !             if gpu == 0 and amd-gpu == 0 or
        !             if gpu == 1 and amd-gpu == 0
        if (gpu_old .eq. 1 .and. gpu_new .eq. 1) then
          write(error_unit,*) "GPU_SOLVER : You cannot set gpu = 1 and amd-gpu = 1. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_evp_&
     &complex&
     &_1stage_&
     &double&
     &")
     success = .false.
     return
        endif
      endif ! amd-gpu
      if (obj%is_set("intel-gpu") == 0) then
        ! intel-gpu is not set, but gpu is set
        ! this is ok in anycase
      else ! obj%is_set("intel-gpu") == 0
        call obj%get("intel-gpu", gpu_new, error)
        if (error .ne. ELPA_OK) then
          write(error_unit,*) "GPU_SOLVER : Problem getting option for intel-gpu. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_evp_&
     &complex&
     &_1stage_&
     &double&
     &")
     success = .false.
     return
        endif
        ! this is ok, if gpu == 0 and intel-gpu == 1 or
        !             if gpu == 0 and intel-gpu == 0 or
        !             if gpu == 1 and intel-gpu == 0
        if (gpu_old .eq. 1 .and. gpu_new .eq. 1) then
          write(error_unit,*) "GPU_SOLVER : You cannot set gpu = 1 and intel-gpu = 1. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_evp_&
     &complex&
     &_1stage_&
     &double&
     &")
     success = .false.
     return
        endif
      endif ! intel-gpu
    else ! gpu not set
      ! nothing to do since the legacy option is not set
    endif ! gpu is set

    ! GPU settings
    if (gpu_vendor() == NVIDIA_GPU) then
      call obj%get("nvidia-gpu", gpu, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "GPU_SOLVER : Problem getting option for NVIDIA GPU. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_evp_&
     &complex&
     &_1stage_&
     &double&
     &")
     success = .false.
     return
      endif
    else if (gpu_vendor() == AMD_GPU) then
      call obj%get("amd-gpu", gpu, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "GPU_SOLVER : Problem getting option for AMD GPU. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_evp_&
     &complex&
     &_1stage_&
     &double&
     &")
     success = .false.
     return
      endif
    else if (gpu_vendor() == INTEL_GPU) then
      call obj%get("intel-gpu", gpu, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "GPU_SOLVER : Problem getting option for INTEL GPU. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_evp_&
     &complex&
     &_1stage_&
     &double&
     &")
     success = .false.
     return
      endif
    else ! no supported gpu
      gpu = 0
    endif

   if (gpu .eq. 1) then
     useGPU =.true.
   else
     useGPU = .false.
   endif


    do_useGPU = .false.

    ! get the kernel and check whether it has been set by the user
    if (obj%is_set("complex_kernel") == 1) then
      userHasSetKernel = .true.
    else
      userHasSetKernel = .false.
    endif

    ! after this point you may _never_ call get for the kernel again, or set the
    ! kernel !! The reason is that we might have to adjust the kernel, which is
    ! passed as a variable
    call obj%get("complex_kernel", kernel, error)
    if (error .ne. ELPA_OK) then
      write(error_unit,*) "ELPA2: Problem getting option for kernel settings. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

    endif

    ! to implement a possibiltiy to set this
    useNonBlockingCollectivesAll = .false.

    call obj%get("mpi_comm_rows",mpi_comm_rows, error)
    if (error .ne. ELPA_OK) then
      write(error_unit,*) "ELPA2: Problem getting option for mpi_comm_rows. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

    endif
    call obj%get("mpi_comm_cols",mpi_comm_cols,error)
    if (error .ne. ELPA_OK) then
      write(error_unit,*) "ELPA2: Problem getting option for mpi_comm_cols. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

    endif
    call obj%get("mpi_comm_parent",mpi_comm_all,error)
    if (error .ne. ELPA_OK) then
      write(error_unit,*) "ELPA2: Problem getting option for mpi_comm_parent. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

    endif

    call obj%timer%start("mpi_communication")
    call mpi_comm_rank(int(mpi_comm_all,kind=MPI_KIND) ,my_peMPI ,mpierr)
    call mpi_comm_size(int(mpi_comm_all,kind=MPI_KIND) ,n_pesMPI ,mpierr)

    call mpi_comm_rank(int(mpi_comm_rows,kind=MPI_KIND) ,my_prowMPI ,mpierr)
    call mpi_comm_size(int(mpi_comm_rows,kind=MPI_KIND) ,np_rowsMPI ,mpierr)
    call mpi_comm_rank(int(mpi_comm_cols,kind=MPI_KIND) ,my_pcolMPI ,mpierr)
    call mpi_comm_size(int(mpi_comm_cols,kind=MPI_KIND) ,np_colsMPI ,mpierr)

    my_pe = int(my_peMPI, kind=c_int)
    n_pes = int(n_pesMPI, kind=c_int)
    my_prow = int(my_prowMPI, kind=c_int)
    np_rows = int(np_rowsMPI, kind=c_int)
    my_pcol = int(my_pcolMPI, kind=c_int)
    np_cols = int(np_colsMPI, kind=c_int)

    call obj%timer%stop("mpi_communication")

    na         = obj%na
    nev        = obj%nev
    nblk       = obj%nblk
    matrixCols = obj%local_ncols
    matrixRows = obj%local_nrows

    call obj%get("nbc_all_elpa2_main", non_blocking_collectives_all, error)
    if (error .ne. ELPA_OK) then
      write(error_unit,*) "ELPA2: Problem getting option for non blocking collectives. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

    endif

    if (non_blocking_collectives_all .eq. 1) then
      useNonBlockingCollectivesAll = .true.
    else
      useNonBlockingCollectivesAll = .false.
    endif

    ! openmp setting
    nrThreads = 1


    if (useGPU) then
      call obj%timer%start("check_for_gpu")
      if (check_for_gpu(obj, my_pe, numberOfGPUDevices, wantDebug=wantDebug)) then
        do_useGPU = .true.
        ! set the neccessary parameters
        call set_gpu_parameters()

      else
        write(error_unit,*) "ELPA2: GPUs are requested but not detected! Aborting..."
        call obj%timer%stop("check_for_gpu")
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

      endif
      call obj%timer%stop("check_for_gpu")

      if (nblk*(max(np_rows,np_cols)-1) >= na) then
        if (my_pe .eq. 0) then
          write(error_unit,*) "ELPA: Warning, block size too large for this matrix size and process grid!"
          write(error_unit,*) "Choose a smaller block size if possible.",nblk*(max(np_rows,np_cols)-1),na
          write(error_unit,*) "Disabling GPU usage! "
        endif

        do_useGPU = .false.
        if (kernel .eq. ELPA_2STAGE_COMPLEX_NVIDIA_GPU) then
          if (userHasSetKernel) then
            ! user fixed inconsistent input.
            ! sadly, we do have to abort
            if (my_pe .eq. 0) then
              write(error_unit,*) "You set (fixed) the kernel to GPU, but GPUs cannot be used."
              write(error_unit,*) "Either adapt the block size or the process grid, or do not set the GPU kernel! Aborting..."
            endif
            stop 1
          else
            ! here we should set the default kernel
            kernel = ELPA_2STAGE_COMPLEX_DEFAULT
          endif
        endif
      endif

    endif ! useGPU




    do_useGPU_bandred = do_useGPU
    do_useGPU_tridiag_band = .false.  ! not yet ported
    do_useGPU_solve_tridi = do_useGPU
    do_useGPU_trans_ev_tridi_to_band = do_useGPU
    do_useGPU_trans_ev_band_to_full = do_useGPU


   reDistributeMatrix = .false.



   ! aIntern, qIntern, are normally pointers since no matrix redistribution is used
   ! point them to  the external arrays
   aIntern => aExtern(1:matrixRows,1:matrixCols)
   if (present(qExtern)) then
     qIntern => qExtern(1:matrixRows,1:matrixCols)
   endif

  ! whether a matrix redistribution or not is happening we still
  ! have to point ev
   evIntern => evExtern(1:obj%na)

     a       => aIntern(1:matrixRows,1:matrixCols)
     if (present(qExtern)) then
       q       => qIntern(1:matrixRows,1:matrixCols)
     endif

   ev      => evIntern(1:obj%na)

   call obj%get("output_pinning_information", pinningInfo, error)
   if (error .ne. ELPA_OK) then
     write(error_unit,*) "ELPA2: Problem setting option for debug. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

   endif

   if (pinningInfo .eq. 1) then
     call init_thread_affinity(nrThreads)

     call check_thread_affinity()
     if (my_pe .eq. 0) call print_thread_affinity(my_pe)
     call cleanup_thread_affinity()
   endif

    success = .true.

    if (present(qExtern)) then
      obj%eigenvalues_only = .false.
    else
      obj%eigenvalues_only = .true.
    endif

   ! special case na = 1
   if (na .eq. 1) then
     ev(1) = real(a(1,1))
     if (.not.(obj%eigenvalues_only)) then
       q(1,1) = ONE
     endif

     ! restore original OpenMP settings

     call obj%timer%stop("elpa_solve_evp_&
     &complex&
     &_2stage_&
     &double&
     &")
     success = .true.
     return
   endif

   if (nev == 0) then
     nev = 1
     obj%eigenvalues_only = .true.
   endif

    !call obj%get("complex_kernel", kernel, error)
    !if (error .ne. ELPA_OK) then
    !  print *,"Problem getting option for kernel settings. Aborting..."
    !  stop 1
    !endif

    isSkewsymmetric = .false.

    ! only if we want (and can) use GPU in general, look what are the
    ! requirements for individual routines. Implicitly they are all set to 1, so
    ! unless specified otherwise by the user, GPU versions of all individual
    ! routines should be used
    if (do_useGPU) then
      call obj%get("gpu_bandred", gpu, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "ELPA2: Problem getting option gpu_bandred settings. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

      endif
      do_useGPU_bandred = (gpu == 1)

      ! not yet ported
      !call obj%get("gpu_tridiag_band", gpu, error)
      !if (error .ne. ELPA_OK) then
      !  print *,"Problem getting option for gpu_tridiag_band settings. Aborting..."
      !  stop 1
      !endif
      !do_useGPU_tridiag_band = (gpu == 1)

      call obj%get("gpu_solve_tridi", gpu, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "ELPA2: Problem getting option for gpu_solve_tridi settings. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

      endif
      do_useGPU_solve_tridi = (gpu == 1)

      call obj%get("gpu_trans_ev_tridi_to_band", gpu, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "ELPA2: Problem getting option for gpu_trans_ev_tridi_to_band settings. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

      endif
      do_useGPU_trans_ev_tridi_to_band = (gpu == 1)

      call obj%get("gpu_trans_ev_band_to_full", gpu, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "ELPA2: Problem getting option for gpu_trans_ev_band_to_full settings. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

      endif
      do_useGPU_trans_ev_band_to_full = (gpu == 1)
    endif

    ! check consistency between request for GPUs and defined kernel
    if (do_useGPU_trans_ev_tridi_to_band) then
      ! if the user has set explicitely a kernel before than honour this
      ! otherwise set GPU kernel
      if (userHasSetKernel) then
        if (kernel .ne. ELPA_2STAGE_COMPLEX_NVIDIA_GPU) then
          write(error_unit,*) "ELPA: Warning, GPU usage has been requested but compute kernel is set by the user as non-GPU!"
          write(error_unit,*) "The compute kernel will be executed on CPUs!"
          do_useGPU_trans_ev_tridi_to_band = .false.
          kernel = ELPA_2STAGE_COMPLEX_DEFAULT
        else
          good_nblk_gpu = .false.
        endif
      else ! userHasSetKernel
        !call obj%set("complex_kernel", ELPA_2STAGE_COMPLEX_NVIDIA_GPU, error)
        !if (error .ne. ELPA_OK) then
        !  write(error_unit,*) "Cannot set kernel to GPU kernel"
        !  stop 1
        !endif

        if (my_pe .eq. 0) write(error_unit,*) "You requested the GPU version, thus the GPU kernel is activated"
        good_nblk_gpu = .false.

        kernel = ELPA_2STAGE_COMPLEX_NVIDIA_GPU
      endif ! userHasSetKernel

      ! Accepted values are 2,4,8,16,...,512
      do i = 1,10
        if (nblk == 2**i) then
          good_nblk_gpu = .true.
          exit
        endif
      enddo

      if (.not. good_nblk_gpu .and. do_useGPU_trans_ev_tridi_to_band) then
         write(error_unit,*) "ELPA: Warning, GPU kernel only works with block size 2^n (n = 1, 2, ..., 10)!"
         write(error_unit,*) "The compute kernel will be executed on CPUs!"
         write(error_unit,*) "We recommend changing the block size to 2^n"
         do_useGPU_trans_ev_tridi_to_band = .false.
         ! should be set
         kernel = ELPA_2STAGE_COMPLEX_DEFAULT
      endif
    endif





    ! check again, now kernel and do_useGPU_trans_ev_tridi_to_band should be
    ! finally consistent
    if (do_useGPU_trans_ev_tridi_to_band) then
      !call obj%get("complex_kernel", kernel, error)
      !if (error .ne. ELPA_OK) then
      !  write(error_unit,*) "Cannot get kernel to GPU kernel"
      !  stop 1
      !endif
      if (kernel .ne. ELPA_2STAGE_COMPLEX_NVIDIA_GPU) then
        ! this should never happen, checking as an assert
        write(error_unit,*) "ELPA: INTERNAL ERROR setting GPU kernel!  Aborting..."
        stop 1
      endif
    else ! do not use GPU
      if (kernel .eq. ELPA_2STAGE_COMPLEX_NVIDIA_GPU) then
        ! combination not allowed
        write(error_unit,*) "ELPA: Warning, GPU usage has NOT been requested but compute kernel &
                            &is defined as the GPU kernel!  Setting default kernel"
        kernel = ELPA_2STAGE_COMPLEX_DEFAULT
        !TODO do error handling properly
      endif
    endif


     !! consistency check: is user set kernel still identical with "kernel" or did
     !! we change it above? This is a mess and should be cleaned up
     !call obj%get("complex_kernel",kernelByUser,error)
     !if (error .ne. ELPA_OK) then
     !  print *,"Problem getting option for user kernel settings. Aborting..."
     !  stop 1
     !endif

     !if (kernelByUser .ne. kernel) then
     !  call obj%set("complex_kernel", kernel, error)
     !  if (error .ne. ELPA_OK) then
     !    print *,"Problem setting kernel. Aborting..."
     !    stop 1
     !  endif
     !endif




    if (.not. obj%eigenvalues_only) then
      q_actual => q(1:matrixRows,1:matrixCols)
    else
     allocate(q_dummy(1:matrixRows,1:matrixCols), stat=istat, errmsg=errorMessage)
     call check_allocate_f("elpa2_template: q_dummy", 998,  istat,  errorMessage)
     q_actual => q_dummy(1:matrixRows,1:matrixCols)
    endif

    ! set the default values for each of the 5 compute steps
    do_bandred        = .true.
    do_tridiag        = .true.
    do_solve_tridi    = .true.
    do_trans_to_band  = .true.
    do_trans_to_full  = .true.

    if (obj%eigenvalues_only) then
      do_trans_to_band  = .false.
      do_trans_to_full  = .false.
    endif

    if (obj%is_set("bandwidth") == 1) then
      ! bandwidth is set. That means, that the inputed matrix is actually banded and thus the
      ! first step of ELPA2 should be skipped
      call obj%get("bandwidth",nbw,error)
      if (nbw == 0) then
        if (wantDebug) then
          write(error_unit,*) "Specified bandwidth = 0; ELPA refuses to solve the eigenvalue problem ", &
                              "for a diagonal matrix! This is too simple"
          endif
          write(error_unit,*) "Specified bandwidth = 0; ELPA refuses to solve the eigenvalue problem ", &
                 "for a diagonal matrix! This is too simple"
        success = .false.
        return
      endif
      if (mod(nbw, nblk) .ne. 0) then
        ! treat matrix with an effective bandwidth slightly bigger than specified bandwidth
        ! such that effective bandwidth is a multiply of nblk. which is a prerequiste for ELPA
        nbw = nblk * ceiling(real(nbw,kind=c_double)/real(nblk,kind=c_double))

        ! just check that effective bandwidth is NOT larger than matrix size
        if (nbw .gt. na) then
          if (wantDebug) then
            write(error_unit,*) "Specified bandwidth ",nbw," leads internaly to a computed bandwidth ", &
                                "which is larger than the matrix size ",na," ! ELPA will abort! Try to", &
                                "solve your problem by not specifing a bandwidth"
          endif
          print *, "Specified bandwidth ",nbw," leads internaly to a computed bandwidth ", &
                                "which is larger than the matrix size ",na," ! ELPA will abort! Try to", &
                                "solve your problem by not specifing a bandwidth"
          success = .false.
          return
        endif
      endif
      do_bandred       = .false. ! we already have a banded matrix
      do_solve_tridi   = .true.  ! we also have to solve something :-)
      do_trans_to_band = .true.  ! and still we have to backsub to banded
      do_trans_to_full = .false. ! but not to full since we have a banded matrix
    else ! matrix is not banded, determine the intermediate bandwidth for full->banded->tridi
      !first check if the intermediate bandwidth was set by the user
      call obj%get("intermediate_bandwidth", nbw, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "Problem getting option for intermediate_bandwidth. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

      endif

      if(nbw == 0) then
        ! intermediate bandwidth was not specified, select one of the defaults

        ! Choose bandwidth, must be a multiple of nblk, set to a value >= 32
        ! On older systems (IBM Bluegene/P, Intel Nehalem) a value of 32 was optimal.
        ! For Intel(R) Xeon(R) E5 v2 and v3, better use 64 instead of 32!
        ! For IBM Bluegene/Q this is not clear at the moment. We have to keep an eye
        ! on this and maybe allow a run-time optimization here
        nbw = (31/nblk+1)*nblk
      else
        ! intermediate bandwidth has been specified by the user, check, whether correctly
        if (mod(nbw, nblk) .ne. 0) then
          print *, "Specified bandwidth ",nbw," has to be mutiple of the blocksize ", nblk, ". Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

        endif
      endif !nbw == 0

      num_blocks = (na-1)/nbw + 1

      ! tmat is needed only in full->band and band->full steps, so alocate here
      ! (not allocated for banded matrix on input)
      allocate(tmat(nbw,nbw,num_blocks), stat=istat, errmsg=errorMessage)
      call check_allocate_f("elpa2_template: tmat", 1085,  istat,  errorMessage)

      do_bandred       = .true.
      do_solve_tridi   = .true.
      do_trans_to_band = .true.
      do_trans_to_full = .true.
    endif  ! matrix not already banded on input

    ! start the computations in 5 steps
    if (do_bandred) then
      call obj%autotune_timer%start("full_to_band")
      call obj%timer%start("full_to_band")
      ! Reduction full -> band
      call bandred_&
      &complex&
      &_&
      &double &
      (obj, na, a, &
      matrixRows, nblk, nbw, matrixCols, num_blocks, mpi_comm_rows, mpi_comm_cols, tmat, &
      wantDebug, do_useGPU_bandred, success, &
       nrThreads, isSkewsymmetric)

      call obj%timer%stop("full_to_band")
      call obj%autotune_timer%stop("full_to_band")
  
      if (success) then
        success_int = 0
      else
        success_int = 1
      endif

      if (useNonBlockingCollectivesAll) then
        call mpi_iallreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), &
        allreduce_request2, mpierr)
        call mpi_wait(allreduce_request2, MPI_STATUS_IGNORE, mpierr)
      else
        call mpi_allreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), mpierr)
      endif
      if (success_int .eq. 1) then
        write(error_unit,*) "ELPA2: bandred returned an error. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

      endif
    endif

     ! Reduction band -> tridiagonal
     if (do_tridiag) then
       allocate(e(na), stat=istat, errmsg=errorMessage)
       call check_allocate_f("elpa2_template: e", 1143,  istat,  errorMessage)

       call obj%autotune_timer%start("band_to_tridi")
       call obj%timer%start("band_to_tridi")
       call tridiag_band_&
       &complex&
       &_&
       &double&
       (obj, na, nbw, nblk, a, matrixRows, ev, e, matrixCols, hh_trans, mpi_comm_rows, mpi_comm_cols, mpi_comm_all, &
       do_useGPU_tridiag_band, wantDebug, nrThreads, isSkewsymmetric, success)
  
       if (success) then
         success_int = 0
       else
         success_int = 1
       endif

       if (useNonBlockingCollectivesAll) then
         call mpi_iallreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), &
         allreduce_request3, mpierr)
         call mpi_wait(allreduce_request3, MPI_STATUS_IGNORE, mpierr)
       else
         call mpi_allreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), mpierr)
       endif
       if (success_int .eq. 1) then
         write(error_unit,*) "Error in tridiag_band. Aborting..."
         return
       endif

       call obj%timer%start("mpi_communication")
       if (useNonBlockingCollectivesAll) then
         call mpi_ibcast(ev, int(na,kind=MPI_KIND), MPI_REAL8, 0_MPI_KIND, int(mpi_comm_all,kind=MPI_KIND), bcast_request1, mpierr)
         call mpi_ibcast(e, int(na,kind=MPI_KIND), MPI_REAL8, 0_MPI_KIND, int(mpi_comm_all,kind=MPI_KIND), bcast_request2, mpierr)

         call mpi_wait(bcast_request1, MPI_STATUS_IGNORE, mpierr)
         call mpi_wait(bcast_request2, MPI_STATUS_IGNORE, mpierr)
       else
         call mpi_bcast(ev, int(na,kind=MPI_KIND), MPI_REAL8, 0_MPI_KIND, int(mpi_comm_all,kind=MPI_KIND), mpierr)
         call mpi_bcast(e, int(na,kind=MPI_KIND), MPI_REAL8, 0_MPI_KIND, int(mpi_comm_all,kind=MPI_KIND), mpierr)
       endif
       call obj%timer%stop("mpi_communication")

       call obj%timer%stop("band_to_tridi")
       call obj%autotune_timer%stop("band_to_tridi")
     endif ! do_tridiag

     l_rows = local_index(na, my_prow, np_rows, nblk, -1) ! Local rows of a and q
     l_cols = local_index(na, my_pcol, np_cols, nblk, -1) ! Local columns of q
     l_cols_nev = local_index(nev, my_pcol, np_cols, nblk, -1) ! Local columns corresponding to nev

     allocate(q_real(l_rows,l_cols), stat=istat, errmsg=errorMessage)
     call check_allocate_f("elpa2_template: q_real", 1205,  istat,  errorMessage)

     ! Solve tridiagonal system
     if (do_solve_tridi) then
       call obj%autotune_timer%start("solve")
       call obj%timer%start("solve")

       call solve_tridi_&
       &double &
       (obj, na, nev, ev, e, &
       q_real, ubound(q_real,dim=1), &
       nblk, matrixCols, mpi_comm_all, mpi_comm_rows, mpi_comm_cols, do_useGPU_solve_tridi, wantDebug, &
               success, nrThreads)

       call obj%timer%stop("solve")
       call obj%autotune_timer%stop("solve")
  
       if (success) then
         success_int = 0
       else
         success_int = 1
       endif

       if (useNonBlockingCollectivesAll) then
         call mpi_iallreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), &
         allreduce_request4, mpierr)
         call mpi_wait(allreduce_request4, MPI_STATUS_IGNORE, mpierr)
       else
         call mpi_allreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), mpierr)
       endif

       if (success_int .eq. 1) then
         write(error_unit,*) "ELPA2: solve returned an error: Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

       endif
     endif ! do_solve_tridi

     deallocate(e, stat=istat, errmsg=errorMessage)
     call check_deallocate_f("elpa2_template: e", 1257,  istat,  errorMessage)

     if (obj%eigenvalues_only) then
       do_trans_to_band = .false.
       do_trans_to_full = .false.
     else
       call obj%get("check_pd",check_pd,error)
       if (error .ne. ELPA_OK) then
         write(error_unit,*) "Problem getting option for check_pd. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

       endif
       if (check_pd .eq. 1) then
         call obj%get("thres_pd_&
         &double&
         &",thres_pd,error)
         if (error .ne. ELPA_OK) then
            write(error_unit,*) "Problem getting option for thres_pd_&
            &double&
            &. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

         endif

         check_pd = 0
         do i = 1, na
           if (ev(i) .gt. thres_pd) then
             check_pd = check_pd + 1
           endif
         enddo
         if (check_pd .lt. na) then
           ! not positiv definite => eigenvectors needed
           do_trans_to_band = .true.
           do_trans_to_full = .true.
         else
           do_trans_to_band = .false.
           do_trans_to_full = .false.
         endif
       endif
     endif ! eigenvalues only

     if (do_trans_to_band) then
       ! q must be given thats why from here on we can use q and not q_actual
       q(1:l_rows,1:l_cols_nev) = q_real(1:l_rows,1:l_cols_nev)
     endif

     ! make sure q_real is deallocated when using check_pd
     if (allocated(q_real)) then
       deallocate(q_real, stat=istat, errmsg=errorMessage)
       call check_deallocate_f("elpa2_template: q_real", 1305,  istat,  errorMessage)
     endif

       if (isSkewsymmetric) then
       ! Extra transformation step for skew-symmetric matrix. Multiplication with diagonal complex matrix D.
       ! This makes the eigenvectors complex.
       ! For now real part of eigenvectors is generated in first half of q, imaginary part in second part.
         q(1:matrixRows, matrixCols+1:2*matrixCols) = 0.0
         do i = 1, matrixRows
!          global_index = indxl2g(i, nblk, my_prow, 0, np_rows)
           global_index = np_rows*nblk*((i-1)/nblk) + MOD(i-1,nblk) + MOD(np_rows+my_prow-0, np_rows)*nblk + 1
           if (mod(global_index-1,4) .eq. 0) then
              ! do nothing
           end if
           if (mod(global_index-1,4) .eq. 1) then
              q(i,matrixCols+1:2*matrixCols) = q(i,1:matrixCols)
              q(i,1:matrixCols) = 0
           end if
           if (mod(global_index-1,4) .eq. 2) then
              q(i,1:matrixCols) = -q(i,1:matrixCols)
           end if
           if (mod(global_index-1,4) .eq. 3) then
              q(i,matrixCols+1:2*matrixCols) = -q(i,1:matrixCols)
              q(i,1:matrixCols) = 0
           end if
         end do
       endif

       ! Backtransform stage 1
     if (do_trans_to_band) then

       !debug
!#if defined(WITH_OPENMP_OFFLOAD_GPU_VERSION) || defined(WITH_SYCL_GPU_VERSION)
       !if (gpu_vendor() == OPENMP_OFFLOAD_GPU .or. gpu_vendor() == SYCL_GPU) then
       call obj%autotune_timer%start("tridi_to_band")
       call obj%timer%start("tridi_to_band")
       ! In the skew-symmetric case this transforms the real part
       call trans_ev_tridi_to_band_&
       &complex&
       &_&
       &double &
       (obj, na, nev, nblk, nbw, q, &
       matrixRows, matrixCols, hh_trans, my_pe, mpi_comm_rows, mpi_comm_cols, &
       wantDebug, do_useGPU_trans_ev_tridi_to_band, &
       nrThreads, success=success, kernel=kernel)
       call obj%timer%stop("tridi_to_band")
       call obj%autotune_timer%stop("tridi_to_band")

       if (success) then
         success_int = 0
       else
         success_int = 1
       endif

       if (useNonBlockingCollectivesAll) then
         call mpi_iallreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), &
         allreduce_request5, mpierr)
         call mpi_wait(allreduce_request5, MPI_STATUS_IGNORE, mpierr)
       else
         call mpi_allreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), mpierr)
       endif

       if (success_int .eq. 1) then
         write(error_unit,*) "ELPA2: trans_ev_tridi_to_band returned an error. Aborting..."
         return
       endif

     endif ! do_trans_to_band

     ! the array q (currently) always resides on host even when using GPU

     if (do_trans_to_full) then
       call obj%autotune_timer%start("band_to_full")
       call obj%timer%start("band_to_full")
       ! Backtransform stage 2
       ! In the skew-symemtric case this transforms the real part
       call trans_ev_band_to_full_&
       &complex&
       &_&
       &double &
       (obj, na, nev, nblk, nbw, a, &
       matrixRows, tmat, q,  &
       matrixRows, matrixCols, num_blocks, mpi_comm_rows, mpi_comm_cols, do_useGPU_trans_ev_band_to_full &
       , success)
       call obj%timer%stop("band_to_full")
       call obj%autotune_timer%stop("band_to_full")

       if (success) then
         success_int = 0
       else
         success_int = 1
       endif

       if (useNonBlockingCollectivesAll) then
         call mpi_iallreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), &
         allreduce_request6, mpierr)
         call mpi_wait(allreduce_request6, MPI_STATUS_IGNORE, mpierr)
       else
         call mpi_allreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), mpierr)
       endif
       if (success_int .eq. 1) then
         write(error_unit,*) "Error in trans_ev_band_to_full. Aborting..."
         return
       endif
     endif ! do_trans_to_full
! #ifdef DOUBLE_PRECISION_REAL
!        call prmat(na,useGPU,q(1:matrixRows, 1:matrixCols),q_dev,matrixRows,matrixCols,nblk,my_prow,my_pcol,np_rows,np_cols,'R',1)
! #endif


     !skew symmetric imaginary part for tridi_to_band and band_to_full
     if (isSkewsymmetric) then
       if (do_trans_to_band) then
         call obj%autotune_timer%start("tridi_to_band")
         call obj%timer%start("skew_tridi_to_band")
         ! Transform imaginary part
         ! Transformation of real and imaginary part could also be one call of trans_ev_tridi acting on the n x 2n matrix.
         call trans_ev_tridi_to_band_&
         &complex&
         &_&
         &double &
         (obj, na, nev, nblk, nbw, q(1:matrixRows, matrixCols+1:2*matrixCols), &
         matrixRows, matrixCols, hh_trans, my_pe, mpi_comm_rows, mpi_comm_cols, &
         wantDebug, do_useGPU_trans_ev_tridi_to_band, &
         nrThreads, success=success, kernel=kernel)

         call obj%timer%stop("skew_tridi_to_band")
         call obj%autotune_timer%stop("tridi_to_band")

         if (success) then
           success_int = 0
         else
           success_int = 1
         endif

         if (useNonBlockingCollectivesAll) then
           call mpi_iallreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), &
           allreduce_request7, mpierr)
           call mpi_wait(allreduce_request7, MPI_STATUS_IGNORE, mpierr)
         else
           call mpi_allreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), mpierr)
         endif
         if (success_int .eq. 1) then
          write(error_unit,*) "Error in trans_ev_tridi_to_band (imaginary part). Aborting..."
          return
         endif
       endif ! do_trans_tridi_to_band

       if (do_trans_to_full) then
       call obj%autotune_timer%start("band_to_full")
       call obj%timer%start("band_to_full")
         ! Transform imaginary part
         ! Transformation of real and imaginary part could also be one call of trans_ev_band_to_full_ acting on the n x 2n matrix.
         call trans_ev_band_to_full_&
         &complex&
         &_&
         &double &
         (obj, na, nev, nblk, nbw, a, &
         matrixRows, tmat, q(1:matrixRows, matrixCols+1:2*matrixCols),  &
         matrixRows, matrixCols, num_blocks, mpi_comm_rows, mpi_comm_cols, do_useGPU_trans_ev_band_to_full, &
         success)

         call obj%timer%stop("band_to_full")
         call obj%autotune_timer%stop("band_to_full")

         if (success) then
           success_int = 0
         else
           success_int = 1
         endif

         if (useNonBlockingCollectivesAll) then
           call mpi_iallreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), &
           allreduce_request8, mpierr)
           call mpi_wait(allreduce_request8, MPI_STATUS_IGNORE, mpierr)
         else
           call mpi_allreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), mpierr)
         endif
         if (success_int .eq. 1) then
          write(error_unit,*) "Error in trans_ev_band_to_full (imaginary part). Aborting..."
          return
         endif
       endif ! do_trans_to_full
     endif ! isSkewSymmetric


     ! We can now deallocate the stored householder vectors
     deallocate(hh_trans, stat=istat, errmsg=errorMessage)
     call check_deallocate_f("elpa2_template: hh_trans", 1537,  istat,  errorMessage)

     ! make sure tmat is deallocated when using check_pd
     if (allocated(tmat)) then
       deallocate(tmat, stat=istat, errmsg=errorMessage)
       call check_deallocate_f("elpa2_template: tmat", 1542,  istat,  errorMessage)
     endif

     if (obj%eigenvalues_only) then
       deallocate(q_dummy, stat=istat, errmsg=errorMessage)
       call check_deallocate_f("elpa2_template: q_dummy", 1547,  istat,  errorMessage)
     endif

     ! restore original OpenMP settings



   nullify(aIntern)
   nullify(evIntern)
   if (present(qExtern)) then
     nullify(qIntern)
   endif

   nullify(ev)
   nullify(a)
   nullify(q)

  nullify(q_actual)

     call obj%timer%stop("elpa_solve_evp_&
     &complex&
     &_2stage_&
     &double&
     &")
1    format(a,f10.3)

   end function

! vim: syntax=fortran



















!>  \brief elpa_solve_evp_complex_2stage_d_ptr_double_impl: Fortran function to solve the double-precision complex eigenvalue problem with a 2 stage approach
!>
!>  Parameters
!>
!>  \param na                                   Order of matrix a
!>
!>  \param nev                                  Number of eigenvalues needed
!>
!>  \param a                                    Distributed matrix for which eigenvalues are to be computed.
!>                                              Distribution is like in Scalapack.
!>                                              The full matrix must be set (not only one half like in scalapack).
!>                                              Destroyed on exit (upper and lower half).
!>
!>  \param lda                                  Leading dimension of a
!>
!>  \param ev                                   On output: eigenvalues of a, every processor gets the complete set
!>
!>  \param q                                    On output: Eigenvectors of a
!>                                              Distribution is like in Scalapack.
!>                                              Must be always dimensioned to the full size (corresponding to (na,na))
!>                                              even if only a part of the eigenvalues is needed.
!>
!>  \param ldq                                  Leading dimension of q
!>
!>  \param nblk                                 blocksize of cyclic distribution, must be the same in both directions!
!>
!>  \param matrixCols                           local columns of matrix a and q
!>
!>  \param mpi_comm_rows                        MPI communicator for rows
!>  \param mpi_comm_cols                        MPI communicator for columns
!>  \param mpi_comm_all                         MPI communicator for the total processor set
!>
!>  \param kernel                               specify ELPA2 kernel to use
!>  \param useGPU (optional)                    decide whether GPUs should be used or not
!>
!>  \result success                             logical, false if error occured
!-------------------------------------------------------------------------------


!cannot use "../src/elpa2/../general/error_checking.inc" because filename with path can be too long for gfortran (max line length)


 function elpa_solve_evp_&
  &complex&
  &_&
  &2stage_d_ptr_&
  &double&
  &_impl (obj, &
   aExtern, &
   evExtern, &
   qExtern) result(success)

   !use matrix_plot
   use elpa_abstract_impl
   use elpa_utilities
   use elpa1_compute
   use elpa2_compute
   use elpa_mpi
   use cuda_functions
   use hip_functions
   use elpa_gpu
   use mod_check_for_gpu
   use elpa_omp
   use solve_tridi
   use thread_affinity
   use, intrinsic :: iso_c_binding
   implicit none
!    Copyright 2011, A. Marek
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
!

  integer, parameter :: rk = C_DOUBLE
  integer, parameter :: ck = C_DOUBLE_COMPLEX
  integer, parameter :: rck = C_DOUBLE_COMPLEX
  complex(kind=rck), parameter     :: ZERO = (0.0_rk,0.0_rk), ONE = (1.0_rk,0.0_rk)
   class(elpa_abstract_impl_t), intent(inout)                         :: obj
   logical                                                            :: useGPU
   logical                                                            :: isSkewsymmetric
   integer(kind=c_int)                                                :: kernel, kernelByUser
   logical                                                            :: userHasSetKernel


!#ifdef REDISTRIBUTE_MATRIX
   type(c_ptr)                                                        :: aExtern
   type(c_ptr), optional                                              :: qExtern
!#else 
!   type(c_ptr)                                                        :: a, q
!#endif 


    complex(kind=rck), pointer                                  :: a(:,:)
    complex(kind=rck), pointer                                  :: q(:,:)
    real(kind=RK8), pointer                                  :: ev(:)

   type(c_ptr)                                                        :: evExtern

   complex(kind=c_double), allocatable                   :: hh_trans(:,:)

   integer(kind=c_int)                                                :: my_pe, n_pes, my_prow, my_pcol, np_rows, np_cols
   integer(kind=MPI_KIND)                                             :: my_peMPI, n_pesMPI, my_prowMPI, my_pcolMPI, &
                                                                         np_rowsMPI, np_colsMPI, mpierr
   integer(kind=c_int)                                                :: nbw, num_blocks
   integer(kind=c_int)                                                :: l_cols_nev, l_rows, l_cols
   complex(kind=c_double), allocatable                   :: tmat(:,:,:)
   real(kind=c_double), allocatable                            :: e(:)
   real(kind=c_double), allocatable                            :: q_real(:,:)
   complex(kind=c_double), allocatable, target           :: q_dummy(:,:)
   complex(kind=c_double), pointer                       :: q_actual(:,:)


   integer(kind=c_int)                                                :: i
   logical                                                            :: success, successGPU
   integer(kind=c_int)                                                :: success_int
   logical                                                            :: wantDebug
   integer(kind=c_int)                                                :: istat, gpu, skewsymmetric, debug, qr
   character(200)                                                     :: errorMessage
   logical                                                            :: do_useGPU, do_useGPU_bandred, &
                                                                         do_useGPU_tridiag_band, do_useGPU_solve_tridi, &
                                                                         do_useGPU_trans_ev_tridi_to_band, &
                                                                         do_useGPU_trans_ev_band_to_full
   integer(kind=c_int)                                                :: numberOfGPUDevices
   integer(kind=c_intptr_t), parameter                                :: size_of_datatype = size_of_&
                                                                                            &double&
                                                                                            &_&
                                                                                            &complex
   integer(kind=c_intptr_t), parameter                                :: size_of_real_datatype = size_of_&
                                                                                                 &double&
                                                                                                 &_real
   integer(kind=ik)                                                   :: na, nev, nblk, matrixCols, &
                                                                         mpi_comm_rows, mpi_comm_cols,        &
                                                                         mpi_comm_all, check_pd, error, matrixRows
   real(kind=c_double)                                         :: thres_pd

   complex(kind=rck), pointer                                   :: aIntern(:,:)
   complex(kind=c_double), pointer                       :: qIntern(:,:)
   real(kind=RK8), pointer                                  :: evIntern(:)

   logical                                                            :: do_bandred, do_tridiag, do_solve_tridi,  &
                                                                         do_trans_to_band, do_trans_to_full
   logical                                                            :: good_nblk_gpu

   integer(kind=ik)                                                   :: nrThreads, limitThreads
   integer(kind=ik)                                                   :: global_index
   logical                                                            :: reDistributeMatrix, doRedistributeMatrix
   integer(kind=ik)                                                   :: pinningInfo

   integer(kind=MPI_KIND)                                             :: bcast_request1, bcast_request2, allreduce_request1, &
                                                                         allreduce_request2, allreduce_request3, &
                                                                         allreduce_request4, allreduce_request5, &
                                                                         allreduce_request6, allreduce_request7, &
                                                                         allreduce_request8
   logical                                                            :: useNonBlockingCollectivesAll
   integer(kind=ik)                                                   :: gpu_old, gpu_new
   integer(kind=ik)                                                   :: non_blocking_collectives_all











    call obj%timer%start("elpa_solve_evp_&
    &complex&
    &_2stage_&
    &double&
    &")

    call obj%get("debug",debug, error)
    if (error .ne. ELPA_OK) then
      write(error_unit,*) "ELPA2: Problem getting option for debug settings. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

    endif

    wantDebug = debug == 1

    ! check legacy GPU setings
    ! check legacy GPU setings
    if (obj%is_set("gpu") == 1) then
      write(error_unit,*) "You still use the deprecated option 'gpu', consider switching to 'nvidia-gpu'"
      call obj%get("gpu", gpu_old, error)     
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "GPU_SOLVER : Problem getting option for gpu. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_evp_&
     &complex&
     &_1stage_&
     &double&
     &")
     success = .false.
     return
      endif
      if (obj%is_set("nvidia-gpu") == 0) then
        ! set gpu and nvidia-gpu consistent
        call obj%set("nvidia-gpu", gpu_old, error)
        if (error .ne. ELPA_OK) then
          write(error_unit,*) "GPU_SOLVER : Problem setting option for nvidia-gpu. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_evp_&
     &complex&
     &_1stage_&
     &double&
     &")
     success = .false.
     return
        endif
        write(error_unit,*) "Will set the new keyword 'nvidia-gpu' now."
        write(error_unit,*) "And ignore the 'gpu' keyword from now on"
      else ! obj%is_set("nvidia-gpu") == 0
        call obj%get("nvidia-gpu", gpu_new, error)
        if (error .ne. ELPA_OK) then
          write(error_unit,*) "GPU_SOLVER : Problem getting option for nvidia-gpu. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_evp_&
     &complex&
     &_1stage_&
     &double&
     &")
     success = .false.
     return
        endif
        if (gpu_old .ne. gpu_new) then
                write(error_unit,*) "Please do not set 'gpu' but 'nvidia-gpu' instead"
          write(error_unit,*) "You cannot set gpu = ",gpu_old," and nvidia-gpu=",gpu_new,". Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_evp_&
     &complex&
     &_1stage_&
     &double&
     &")
     success = .false.
     return
        endif
      endif ! obj%is_set("nvidia-gpu") == 0
      if (obj%is_set("amd-gpu") == 0) then
        ! amd-gpu is not set, but gpu is set
        ! this is ok in anycase
      else ! obj%is_set("amd-gpu") == 0
        call obj%get("amd-gpu", gpu_new, error)
        if (error .ne. ELPA_OK) then
          write(error_unit,*) "GPU_SOLVER : Problem getting option for amd-gpu. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_evp_&
     &complex&
     &_1stage_&
     &double&
     &")
     success = .false.
     return
        endif
        ! this is ok, if gpu == 0 and amd-gpu == 1 or
        !             if gpu == 0 and amd-gpu == 0 or
        !             if gpu == 1 and amd-gpu == 0
        if (gpu_old .eq. 1 .and. gpu_new .eq. 1) then
          write(error_unit,*) "GPU_SOLVER : You cannot set gpu = 1 and amd-gpu = 1. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_evp_&
     &complex&
     &_1stage_&
     &double&
     &")
     success = .false.
     return
        endif
      endif ! amd-gpu
      if (obj%is_set("intel-gpu") == 0) then
        ! intel-gpu is not set, but gpu is set
        ! this is ok in anycase
      else ! obj%is_set("intel-gpu") == 0
        call obj%get("intel-gpu", gpu_new, error)
        if (error .ne. ELPA_OK) then
          write(error_unit,*) "GPU_SOLVER : Problem getting option for intel-gpu. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_evp_&
     &complex&
     &_1stage_&
     &double&
     &")
     success = .false.
     return
        endif
        ! this is ok, if gpu == 0 and intel-gpu == 1 or
        !             if gpu == 0 and intel-gpu == 0 or
        !             if gpu == 1 and intel-gpu == 0
        if (gpu_old .eq. 1 .and. gpu_new .eq. 1) then
          write(error_unit,*) "GPU_SOLVER : You cannot set gpu = 1 and intel-gpu = 1. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_evp_&
     &complex&
     &_1stage_&
     &double&
     &")
     success = .false.
     return
        endif
      endif ! intel-gpu
    else ! gpu not set
      ! nothing to do since the legacy option is not set
    endif ! gpu is set

    ! GPU settings
    if (gpu_vendor() == NVIDIA_GPU) then
      call obj%get("nvidia-gpu", gpu, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "GPU_SOLVER : Problem getting option for NVIDIA GPU. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_evp_&
     &complex&
     &_1stage_&
     &double&
     &")
     success = .false.
     return
      endif
    else if (gpu_vendor() == AMD_GPU) then
      call obj%get("amd-gpu", gpu, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "GPU_SOLVER : Problem getting option for AMD GPU. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_evp_&
     &complex&
     &_1stage_&
     &double&
     &")
     success = .false.
     return
      endif
    else if (gpu_vendor() == INTEL_GPU) then
      call obj%get("intel-gpu", gpu, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "GPU_SOLVER : Problem getting option for INTEL GPU. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_evp_&
     &complex&
     &_1stage_&
     &double&
     &")
     success = .false.
     return
      endif
    else ! no supported gpu
      gpu = 0
    endif

   if (gpu .eq. 1) then
     useGPU =.true.
   else
     write(error_unit,*) "GPU_SOLVER : You used the interface for device pointers but did not specify GPU usage!. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_evp_&
     &complex&
     &_1stage_&
     &double&
     &")
     success = .false.
     return
     useGPU = .false.
   endif


    do_useGPU = .false.

    ! get the kernel and check whether it has been set by the user
    if (obj%is_set("complex_kernel") == 1) then
      userHasSetKernel = .true.
    else
      userHasSetKernel = .false.
    endif

    ! after this point you may _never_ call get for the kernel again, or set the
    ! kernel !! The reason is that we might have to adjust the kernel, which is
    ! passed as a variable
    call obj%get("complex_kernel", kernel, error)
    if (error .ne. ELPA_OK) then
      write(error_unit,*) "ELPA2: Problem getting option for kernel settings. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

    endif

    ! to implement a possibiltiy to set this
    useNonBlockingCollectivesAll = .false.

    call obj%get("mpi_comm_rows",mpi_comm_rows, error)
    if (error .ne. ELPA_OK) then
      write(error_unit,*) "ELPA2: Problem getting option for mpi_comm_rows. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

    endif
    call obj%get("mpi_comm_cols",mpi_comm_cols,error)
    if (error .ne. ELPA_OK) then
      write(error_unit,*) "ELPA2: Problem getting option for mpi_comm_cols. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

    endif
    call obj%get("mpi_comm_parent",mpi_comm_all,error)
    if (error .ne. ELPA_OK) then
      write(error_unit,*) "ELPA2: Problem getting option for mpi_comm_parent. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

    endif

    call obj%timer%start("mpi_communication")
    call mpi_comm_rank(int(mpi_comm_all,kind=MPI_KIND) ,my_peMPI ,mpierr)
    call mpi_comm_size(int(mpi_comm_all,kind=MPI_KIND) ,n_pesMPI ,mpierr)

    call mpi_comm_rank(int(mpi_comm_rows,kind=MPI_KIND) ,my_prowMPI ,mpierr)
    call mpi_comm_size(int(mpi_comm_rows,kind=MPI_KIND) ,np_rowsMPI ,mpierr)
    call mpi_comm_rank(int(mpi_comm_cols,kind=MPI_KIND) ,my_pcolMPI ,mpierr)
    call mpi_comm_size(int(mpi_comm_cols,kind=MPI_KIND) ,np_colsMPI ,mpierr)

    my_pe = int(my_peMPI, kind=c_int)
    n_pes = int(n_pesMPI, kind=c_int)
    my_prow = int(my_prowMPI, kind=c_int)
    np_rows = int(np_rowsMPI, kind=c_int)
    my_pcol = int(my_pcolMPI, kind=c_int)
    np_cols = int(np_colsMPI, kind=c_int)

    call obj%timer%stop("mpi_communication")

    na         = obj%na
    nev        = obj%nev
    nblk       = obj%nblk
    matrixCols = obj%local_ncols
    matrixRows = obj%local_nrows

    call obj%get("nbc_all_elpa2_main", non_blocking_collectives_all, error)
    if (error .ne. ELPA_OK) then
      write(error_unit,*) "ELPA2: Problem getting option for non blocking collectives. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

    endif

    if (non_blocking_collectives_all .eq. 1) then
      useNonBlockingCollectivesAll = .true.
    else
      useNonBlockingCollectivesAll = .false.
    endif

    ! openmp setting
    nrThreads = 1


    if (useGPU) then
      call obj%timer%start("check_for_gpu")
      if (check_for_gpu(obj, my_pe, numberOfGPUDevices, wantDebug=wantDebug)) then
        do_useGPU = .true.
        ! set the neccessary parameters
        call set_gpu_parameters()

      else
        write(error_unit,*) "ELPA2: GPUs are requested but not detected! Aborting..."
        call obj%timer%stop("check_for_gpu")
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

      endif
      call obj%timer%stop("check_for_gpu")

      if (nblk*(max(np_rows,np_cols)-1) >= na) then
        if (my_pe .eq. 0) then
          write(error_unit,*) "ELPA: Warning, block size too large for this matrix size and process grid!"
          write(error_unit,*) "Choose a smaller block size if possible.",nblk*(max(np_rows,np_cols)-1),na
          write(error_unit,*) "Disabling GPU usage! "
        endif

        do_useGPU = .false.
        if (kernel .eq. ELPA_2STAGE_COMPLEX_NVIDIA_GPU) then
          if (userHasSetKernel) then
            ! user fixed inconsistent input.
            ! sadly, we do have to abort
            if (my_pe .eq. 0) then
              write(error_unit,*) "You set (fixed) the kernel to GPU, but GPUs cannot be used."
              write(error_unit,*) "Either adapt the block size or the process grid, or do not set the GPU kernel! Aborting..."
            endif
            stop 1
          else
            ! here we should set the default kernel
            kernel = ELPA_2STAGE_COMPLEX_DEFAULT
          endif
        endif
      endif

    endif ! useGPU




    do_useGPU_bandred = do_useGPU
    do_useGPU_tridiag_band = .false.  ! not yet ported
    do_useGPU_solve_tridi = do_useGPU
    do_useGPU_trans_ev_tridi_to_band = do_useGPU
    do_useGPU_trans_ev_band_to_full = do_useGPU


   reDistributeMatrix = .false.


   allocate(aIntern(1:matrixRows,1:matrixCols))
   a       => aIntern(1:matrixRows,1:matrixCols)

   allocate(evIntern(1:obj%na))
   ev      => evIntern(1:obj%na)

   if (present(qExtern)) then
     allocate(qIntern(1:matrixRows,1:matrixCols))
   endif
   !TODO: intel gpu
   ! in case of devcice pointer _AND_ redistribute
   ! 1. copy aExtern to aIntern_dummy
   ! 2. redistribute aIntern_dummy to aIntern


   successGPU = gpu_memcpy(c_loc(aIntern(1,1)), aExtern, matrixRows*matrixCols*size_of_datatype, &
                             gpuMemcpyDeviceToHost)
   call check_memcpy_GPU_f("elpa2: aExtern -> aIntern", 548,  successGPU)


     a       => aIntern(1:matrixRows,1:matrixCols)
     if (present(qExtern)) then
       q       => qIntern(1:matrixRows,1:matrixCols)
     endif

   ev      => evIntern(1:obj%na)

   call obj%get("output_pinning_information", pinningInfo, error)
   if (error .ne. ELPA_OK) then
     write(error_unit,*) "ELPA2: Problem setting option for debug. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

   endif

   if (pinningInfo .eq. 1) then
     call init_thread_affinity(nrThreads)

     call check_thread_affinity()
     if (my_pe .eq. 0) call print_thread_affinity(my_pe)
     call cleanup_thread_affinity()
   endif

    success = .true.

    if (present(qExtern)) then
      obj%eigenvalues_only = .false.
    else
      obj%eigenvalues_only = .true.
    endif

   ! special case na = 1
   if (na .eq. 1) then
     ev(1) = real(a(1,1))
     if (.not.(obj%eigenvalues_only)) then
       q(1,1) = ONE
     endif

     ! restore original OpenMP settings

     call obj%timer%stop("elpa_solve_evp_&
     &complex&
     &_2stage_&
     &double&
     &")
     success = .true.
     return
   endif

   if (nev == 0) then
     nev = 1
     obj%eigenvalues_only = .true.
   endif

    !call obj%get("complex_kernel", kernel, error)
    !if (error .ne. ELPA_OK) then
    !  print *,"Problem getting option for kernel settings. Aborting..."
    !  stop 1
    !endif

    isSkewsymmetric = .false.

    ! only if we want (and can) use GPU in general, look what are the
    ! requirements for individual routines. Implicitly they are all set to 1, so
    ! unless specified otherwise by the user, GPU versions of all individual
    ! routines should be used
    if (do_useGPU) then
      call obj%get("gpu_bandred", gpu, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "ELPA2: Problem getting option gpu_bandred settings. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

      endif
      do_useGPU_bandred = (gpu == 1)

      ! not yet ported
      !call obj%get("gpu_tridiag_band", gpu, error)
      !if (error .ne. ELPA_OK) then
      !  print *,"Problem getting option for gpu_tridiag_band settings. Aborting..."
      !  stop 1
      !endif
      !do_useGPU_tridiag_band = (gpu == 1)

      call obj%get("gpu_solve_tridi", gpu, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "ELPA2: Problem getting option for gpu_solve_tridi settings. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

      endif
      do_useGPU_solve_tridi = (gpu == 1)

      call obj%get("gpu_trans_ev_tridi_to_band", gpu, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "ELPA2: Problem getting option for gpu_trans_ev_tridi_to_band settings. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

      endif
      do_useGPU_trans_ev_tridi_to_band = (gpu == 1)

      call obj%get("gpu_trans_ev_band_to_full", gpu, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "ELPA2: Problem getting option for gpu_trans_ev_band_to_full settings. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

      endif
      do_useGPU_trans_ev_band_to_full = (gpu == 1)
    endif

    ! check consistency between request for GPUs and defined kernel
    if (do_useGPU_trans_ev_tridi_to_band) then
      ! if the user has set explicitely a kernel before than honour this
      ! otherwise set GPU kernel
      if (userHasSetKernel) then
        if (kernel .ne. ELPA_2STAGE_COMPLEX_NVIDIA_GPU) then
          write(error_unit,*) "ELPA: Warning, GPU usage has been requested but compute kernel is set by the user as non-GPU!"
          write(error_unit,*) "The compute kernel will be executed on CPUs!"
          do_useGPU_trans_ev_tridi_to_band = .false.
          kernel = ELPA_2STAGE_COMPLEX_DEFAULT
        else
          good_nblk_gpu = .false.
        endif
      else ! userHasSetKernel
        !call obj%set("complex_kernel", ELPA_2STAGE_COMPLEX_NVIDIA_GPU, error)
        !if (error .ne. ELPA_OK) then
        !  write(error_unit,*) "Cannot set kernel to GPU kernel"
        !  stop 1
        !endif

        if (my_pe .eq. 0) write(error_unit,*) "You requested the GPU version, thus the GPU kernel is activated"
        good_nblk_gpu = .false.

        kernel = ELPA_2STAGE_COMPLEX_NVIDIA_GPU
      endif ! userHasSetKernel

      ! Accepted values are 2,4,8,16,...,512
      do i = 1,10
        if (nblk == 2**i) then
          good_nblk_gpu = .true.
          exit
        endif
      enddo

      if (.not. good_nblk_gpu .and. do_useGPU_trans_ev_tridi_to_band) then
         write(error_unit,*) "ELPA: Warning, GPU kernel only works with block size 2^n (n = 1, 2, ..., 10)!"
         write(error_unit,*) "The compute kernel will be executed on CPUs!"
         write(error_unit,*) "We recommend changing the block size to 2^n"
         do_useGPU_trans_ev_tridi_to_band = .false.
         ! should be set
         kernel = ELPA_2STAGE_COMPLEX_DEFAULT
      endif
    endif





    ! check again, now kernel and do_useGPU_trans_ev_tridi_to_band should be
    ! finally consistent
    if (do_useGPU_trans_ev_tridi_to_band) then
      !call obj%get("complex_kernel", kernel, error)
      !if (error .ne. ELPA_OK) then
      !  write(error_unit,*) "Cannot get kernel to GPU kernel"
      !  stop 1
      !endif
      if (kernel .ne. ELPA_2STAGE_COMPLEX_NVIDIA_GPU) then
        ! this should never happen, checking as an assert
        write(error_unit,*) "ELPA: INTERNAL ERROR setting GPU kernel!  Aborting..."
        stop 1
      endif
    else ! do not use GPU
      if (kernel .eq. ELPA_2STAGE_COMPLEX_NVIDIA_GPU) then
        ! combination not allowed
        write(error_unit,*) "ELPA: Warning, GPU usage has NOT been requested but compute kernel &
                            &is defined as the GPU kernel!  Setting default kernel"
        kernel = ELPA_2STAGE_COMPLEX_DEFAULT
        !TODO do error handling properly
      endif
    endif


     !! consistency check: is user set kernel still identical with "kernel" or did
     !! we change it above? This is a mess and should be cleaned up
     !call obj%get("complex_kernel",kernelByUser,error)
     !if (error .ne. ELPA_OK) then
     !  print *,"Problem getting option for user kernel settings. Aborting..."
     !  stop 1
     !endif

     !if (kernelByUser .ne. kernel) then
     !  call obj%set("complex_kernel", kernel, error)
     !  if (error .ne. ELPA_OK) then
     !    print *,"Problem setting kernel. Aborting..."
     !    stop 1
     !  endif
     !endif




    if (.not. obj%eigenvalues_only) then
      q_actual => q(1:matrixRows,1:matrixCols)
    else
     allocate(q_dummy(1:matrixRows,1:matrixCols), stat=istat, errmsg=errorMessage)
     call check_allocate_f("elpa2_template: q_dummy", 998,  istat,  errorMessage)
     q_actual => q_dummy(1:matrixRows,1:matrixCols)
    endif

    ! set the default values for each of the 5 compute steps
    do_bandred        = .true.
    do_tridiag        = .true.
    do_solve_tridi    = .true.
    do_trans_to_band  = .true.
    do_trans_to_full  = .true.

    if (obj%eigenvalues_only) then
      do_trans_to_band  = .false.
      do_trans_to_full  = .false.
    endif

    if (obj%is_set("bandwidth") == 1) then
      ! bandwidth is set. That means, that the inputed matrix is actually banded and thus the
      ! first step of ELPA2 should be skipped
      call obj%get("bandwidth",nbw,error)
      if (nbw == 0) then
        if (wantDebug) then
          write(error_unit,*) "Specified bandwidth = 0; ELPA refuses to solve the eigenvalue problem ", &
                              "for a diagonal matrix! This is too simple"
          endif
          write(error_unit,*) "Specified bandwidth = 0; ELPA refuses to solve the eigenvalue problem ", &
                 "for a diagonal matrix! This is too simple"
        success = .false.
        return
      endif
      if (mod(nbw, nblk) .ne. 0) then
        ! treat matrix with an effective bandwidth slightly bigger than specified bandwidth
        ! such that effective bandwidth is a multiply of nblk. which is a prerequiste for ELPA
        nbw = nblk * ceiling(real(nbw,kind=c_double)/real(nblk,kind=c_double))

        ! just check that effective bandwidth is NOT larger than matrix size
        if (nbw .gt. na) then
          if (wantDebug) then
            write(error_unit,*) "Specified bandwidth ",nbw," leads internaly to a computed bandwidth ", &
                                "which is larger than the matrix size ",na," ! ELPA will abort! Try to", &
                                "solve your problem by not specifing a bandwidth"
          endif
          print *, "Specified bandwidth ",nbw," leads internaly to a computed bandwidth ", &
                                "which is larger than the matrix size ",na," ! ELPA will abort! Try to", &
                                "solve your problem by not specifing a bandwidth"
          success = .false.
          return
        endif
      endif
      do_bandred       = .false. ! we already have a banded matrix
      do_solve_tridi   = .true.  ! we also have to solve something :-)
      do_trans_to_band = .true.  ! and still we have to backsub to banded
      do_trans_to_full = .false. ! but not to full since we have a banded matrix
    else ! matrix is not banded, determine the intermediate bandwidth for full->banded->tridi
      !first check if the intermediate bandwidth was set by the user
      call obj%get("intermediate_bandwidth", nbw, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "Problem getting option for intermediate_bandwidth. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

      endif

      if(nbw == 0) then
        ! intermediate bandwidth was not specified, select one of the defaults

        ! Choose bandwidth, must be a multiple of nblk, set to a value >= 32
        ! On older systems (IBM Bluegene/P, Intel Nehalem) a value of 32 was optimal.
        ! For Intel(R) Xeon(R) E5 v2 and v3, better use 64 instead of 32!
        ! For IBM Bluegene/Q this is not clear at the moment. We have to keep an eye
        ! on this and maybe allow a run-time optimization here
        nbw = (31/nblk+1)*nblk
      else
        ! intermediate bandwidth has been specified by the user, check, whether correctly
        if (mod(nbw, nblk) .ne. 0) then
          print *, "Specified bandwidth ",nbw," has to be mutiple of the blocksize ", nblk, ". Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

        endif
      endif !nbw == 0

      num_blocks = (na-1)/nbw + 1

      ! tmat is needed only in full->band and band->full steps, so alocate here
      ! (not allocated for banded matrix on input)
      allocate(tmat(nbw,nbw,num_blocks), stat=istat, errmsg=errorMessage)
      call check_allocate_f("elpa2_template: tmat", 1085,  istat,  errorMessage)

      do_bandred       = .true.
      do_solve_tridi   = .true.
      do_trans_to_band = .true.
      do_trans_to_full = .true.
    endif  ! matrix not already banded on input

    ! start the computations in 5 steps
    if (do_bandred) then
      call obj%autotune_timer%start("full_to_band")
      call obj%timer%start("full_to_band")
      ! Reduction full -> band
      call bandred_&
      &complex&
      &_&
      &double &
      (obj, na, a, &
      matrixRows, nblk, nbw, matrixCols, num_blocks, mpi_comm_rows, mpi_comm_cols, tmat, &
      wantDebug, do_useGPU_bandred, success, &
       nrThreads, isSkewsymmetric)

      call obj%timer%stop("full_to_band")
      call obj%autotune_timer%stop("full_to_band")
  
      if (success) then
        success_int = 0
      else
        success_int = 1
      endif

      if (useNonBlockingCollectivesAll) then
        call mpi_iallreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), &
        allreduce_request2, mpierr)
        call mpi_wait(allreduce_request2, MPI_STATUS_IGNORE, mpierr)
      else
        call mpi_allreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), mpierr)
      endif
      if (success_int .eq. 1) then
        write(error_unit,*) "ELPA2: bandred returned an error. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

      endif
    endif

     ! Reduction band -> tridiagonal
     if (do_tridiag) then
       allocate(e(na), stat=istat, errmsg=errorMessage)
       call check_allocate_f("elpa2_template: e", 1143,  istat,  errorMessage)

       call obj%autotune_timer%start("band_to_tridi")
       call obj%timer%start("band_to_tridi")
       call tridiag_band_&
       &complex&
       &_&
       &double&
       (obj, na, nbw, nblk, a, matrixRows, ev, e, matrixCols, hh_trans, mpi_comm_rows, mpi_comm_cols, mpi_comm_all, &
       do_useGPU_tridiag_band, wantDebug, nrThreads, isSkewsymmetric, success)
  
       if (success) then
         success_int = 0
       else
         success_int = 1
       endif

       if (useNonBlockingCollectivesAll) then
         call mpi_iallreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), &
         allreduce_request3, mpierr)
         call mpi_wait(allreduce_request3, MPI_STATUS_IGNORE, mpierr)
       else
         call mpi_allreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), mpierr)
       endif
       if (success_int .eq. 1) then
         write(error_unit,*) "Error in tridiag_band. Aborting..."
         return
       endif

       call obj%timer%start("mpi_communication")
       if (useNonBlockingCollectivesAll) then
         call mpi_ibcast(ev, int(na,kind=MPI_KIND), MPI_REAL8, 0_MPI_KIND, int(mpi_comm_all,kind=MPI_KIND), bcast_request1, mpierr)
         call mpi_ibcast(e, int(na,kind=MPI_KIND), MPI_REAL8, 0_MPI_KIND, int(mpi_comm_all,kind=MPI_KIND), bcast_request2, mpierr)

         call mpi_wait(bcast_request1, MPI_STATUS_IGNORE, mpierr)
         call mpi_wait(bcast_request2, MPI_STATUS_IGNORE, mpierr)
       else
         call mpi_bcast(ev, int(na,kind=MPI_KIND), MPI_REAL8, 0_MPI_KIND, int(mpi_comm_all,kind=MPI_KIND), mpierr)
         call mpi_bcast(e, int(na,kind=MPI_KIND), MPI_REAL8, 0_MPI_KIND, int(mpi_comm_all,kind=MPI_KIND), mpierr)
       endif
       call obj%timer%stop("mpi_communication")

       call obj%timer%stop("band_to_tridi")
       call obj%autotune_timer%stop("band_to_tridi")
     endif ! do_tridiag

     l_rows = local_index(na, my_prow, np_rows, nblk, -1) ! Local rows of a and q
     l_cols = local_index(na, my_pcol, np_cols, nblk, -1) ! Local columns of q
     l_cols_nev = local_index(nev, my_pcol, np_cols, nblk, -1) ! Local columns corresponding to nev

     allocate(q_real(l_rows,l_cols), stat=istat, errmsg=errorMessage)
     call check_allocate_f("elpa2_template: q_real", 1205,  istat,  errorMessage)

     ! Solve tridiagonal system
     if (do_solve_tridi) then
       call obj%autotune_timer%start("solve")
       call obj%timer%start("solve")

       call solve_tridi_&
       &double &
       (obj, na, nev, ev, e, &
       q_real, ubound(q_real,dim=1), &
       nblk, matrixCols, mpi_comm_all, mpi_comm_rows, mpi_comm_cols, do_useGPU_solve_tridi, wantDebug, &
               success, nrThreads)

       call obj%timer%stop("solve")
       call obj%autotune_timer%stop("solve")
  
       if (success) then
         success_int = 0
       else
         success_int = 1
       endif

       if (useNonBlockingCollectivesAll) then
         call mpi_iallreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), &
         allreduce_request4, mpierr)
         call mpi_wait(allreduce_request4, MPI_STATUS_IGNORE, mpierr)
       else
         call mpi_allreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), mpierr)
       endif

       if (success_int .eq. 1) then
         write(error_unit,*) "ELPA2: solve returned an error: Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

       endif
     endif ! do_solve_tridi

     deallocate(e, stat=istat, errmsg=errorMessage)
     call check_deallocate_f("elpa2_template: e", 1257,  istat,  errorMessage)

     if (obj%eigenvalues_only) then
       do_trans_to_band = .false.
       do_trans_to_full = .false.
     else
       call obj%get("check_pd",check_pd,error)
       if (error .ne. ELPA_OK) then
         write(error_unit,*) "Problem getting option for check_pd. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

       endif
       if (check_pd .eq. 1) then
         call obj%get("thres_pd_&
         &double&
         &",thres_pd,error)
         if (error .ne. ELPA_OK) then
            write(error_unit,*) "Problem getting option for thres_pd_&
            &double&
            &. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

         endif

         check_pd = 0
         do i = 1, na
           if (ev(i) .gt. thres_pd) then
             check_pd = check_pd + 1
           endif
         enddo
         if (check_pd .lt. na) then
           ! not positiv definite => eigenvectors needed
           do_trans_to_band = .true.
           do_trans_to_full = .true.
         else
           do_trans_to_band = .false.
           do_trans_to_full = .false.
         endif
       endif
     endif ! eigenvalues only

     if (do_trans_to_band) then
       ! q must be given thats why from here on we can use q and not q_actual
       q(1:l_rows,1:l_cols_nev) = q_real(1:l_rows,1:l_cols_nev)
     endif

     ! make sure q_real is deallocated when using check_pd
     if (allocated(q_real)) then
       deallocate(q_real, stat=istat, errmsg=errorMessage)
       call check_deallocate_f("elpa2_template: q_real", 1305,  istat,  errorMessage)
     endif

       if (isSkewsymmetric) then
       ! Extra transformation step for skew-symmetric matrix. Multiplication with diagonal complex matrix D.
       ! This makes the eigenvectors complex.
       ! For now real part of eigenvectors is generated in first half of q, imaginary part in second part.
         q(1:matrixRows, matrixCols+1:2*matrixCols) = 0.0
         do i = 1, matrixRows
!          global_index = indxl2g(i, nblk, my_prow, 0, np_rows)
           global_index = np_rows*nblk*((i-1)/nblk) + MOD(i-1,nblk) + MOD(np_rows+my_prow-0, np_rows)*nblk + 1
           if (mod(global_index-1,4) .eq. 0) then
              ! do nothing
           end if
           if (mod(global_index-1,4) .eq. 1) then
              q(i,matrixCols+1:2*matrixCols) = q(i,1:matrixCols)
              q(i,1:matrixCols) = 0
           end if
           if (mod(global_index-1,4) .eq. 2) then
              q(i,1:matrixCols) = -q(i,1:matrixCols)
           end if
           if (mod(global_index-1,4) .eq. 3) then
              q(i,matrixCols+1:2*matrixCols) = -q(i,1:matrixCols)
              q(i,1:matrixCols) = 0
           end if
         end do
       endif

       ! Backtransform stage 1
     if (do_trans_to_band) then

       !debug
!#if defined(WITH_OPENMP_OFFLOAD_GPU_VERSION) || defined(WITH_SYCL_GPU_VERSION)
       !if (gpu_vendor() == OPENMP_OFFLOAD_GPU .or. gpu_vendor() == SYCL_GPU) then
       call obj%autotune_timer%start("tridi_to_band")
       call obj%timer%start("tridi_to_band")
       ! In the skew-symmetric case this transforms the real part
       call trans_ev_tridi_to_band_&
       &complex&
       &_&
       &double &
       (obj, na, nev, nblk, nbw, q, &
       matrixRows, matrixCols, hh_trans, my_pe, mpi_comm_rows, mpi_comm_cols, &
       wantDebug, do_useGPU_trans_ev_tridi_to_band, &
       nrThreads, success=success, kernel=kernel)
       call obj%timer%stop("tridi_to_band")
       call obj%autotune_timer%stop("tridi_to_band")

       if (success) then
         success_int = 0
       else
         success_int = 1
       endif

       if (useNonBlockingCollectivesAll) then
         call mpi_iallreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), &
         allreduce_request5, mpierr)
         call mpi_wait(allreduce_request5, MPI_STATUS_IGNORE, mpierr)
       else
         call mpi_allreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), mpierr)
       endif

       if (success_int .eq. 1) then
         write(error_unit,*) "ELPA2: trans_ev_tridi_to_band returned an error. Aborting..."
         return
       endif

     endif ! do_trans_to_band

     ! the array q (currently) always resides on host even when using GPU

     if (do_trans_to_full) then
       call obj%autotune_timer%start("band_to_full")
       call obj%timer%start("band_to_full")
       ! Backtransform stage 2
       ! In the skew-symemtric case this transforms the real part
       call trans_ev_band_to_full_&
       &complex&
       &_&
       &double &
       (obj, na, nev, nblk, nbw, a, &
       matrixRows, tmat, q,  &
       matrixRows, matrixCols, num_blocks, mpi_comm_rows, mpi_comm_cols, do_useGPU_trans_ev_band_to_full &
       , success)
       call obj%timer%stop("band_to_full")
       call obj%autotune_timer%stop("band_to_full")

       if (success) then
         success_int = 0
       else
         success_int = 1
       endif

       if (useNonBlockingCollectivesAll) then
         call mpi_iallreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), &
         allreduce_request6, mpierr)
         call mpi_wait(allreduce_request6, MPI_STATUS_IGNORE, mpierr)
       else
         call mpi_allreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), mpierr)
       endif
       if (success_int .eq. 1) then
         write(error_unit,*) "Error in trans_ev_band_to_full. Aborting..."
         return
       endif
     endif ! do_trans_to_full
! #ifdef DOUBLE_PRECISION_REAL
!        call prmat(na,useGPU,q(1:matrixRows, 1:matrixCols),q_dev,matrixRows,matrixCols,nblk,my_prow,my_pcol,np_rows,np_cols,'R',1)
! #endif


     !skew symmetric imaginary part for tridi_to_band and band_to_full
     if (isSkewsymmetric) then
       if (do_trans_to_band) then
         call obj%autotune_timer%start("tridi_to_band")
         call obj%timer%start("skew_tridi_to_band")
         ! Transform imaginary part
         ! Transformation of real and imaginary part could also be one call of trans_ev_tridi acting on the n x 2n matrix.
         call trans_ev_tridi_to_band_&
         &complex&
         &_&
         &double &
         (obj, na, nev, nblk, nbw, q(1:matrixRows, matrixCols+1:2*matrixCols), &
         matrixRows, matrixCols, hh_trans, my_pe, mpi_comm_rows, mpi_comm_cols, &
         wantDebug, do_useGPU_trans_ev_tridi_to_band, &
         nrThreads, success=success, kernel=kernel)

         call obj%timer%stop("skew_tridi_to_band")
         call obj%autotune_timer%stop("tridi_to_band")

         if (success) then
           success_int = 0
         else
           success_int = 1
         endif

         if (useNonBlockingCollectivesAll) then
           call mpi_iallreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), &
           allreduce_request7, mpierr)
           call mpi_wait(allreduce_request7, MPI_STATUS_IGNORE, mpierr)
         else
           call mpi_allreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), mpierr)
         endif
         if (success_int .eq. 1) then
          write(error_unit,*) "Error in trans_ev_tridi_to_band (imaginary part). Aborting..."
          return
         endif
       endif ! do_trans_tridi_to_band

       if (do_trans_to_full) then
       call obj%autotune_timer%start("band_to_full")
       call obj%timer%start("band_to_full")
         ! Transform imaginary part
         ! Transformation of real and imaginary part could also be one call of trans_ev_band_to_full_ acting on the n x 2n matrix.
         call trans_ev_band_to_full_&
         &complex&
         &_&
         &double &
         (obj, na, nev, nblk, nbw, a, &
         matrixRows, tmat, q(1:matrixRows, matrixCols+1:2*matrixCols),  &
         matrixRows, matrixCols, num_blocks, mpi_comm_rows, mpi_comm_cols, do_useGPU_trans_ev_band_to_full, &
         success)

         call obj%timer%stop("band_to_full")
         call obj%autotune_timer%stop("band_to_full")

         if (success) then
           success_int = 0
         else
           success_int = 1
         endif

         if (useNonBlockingCollectivesAll) then
           call mpi_iallreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), &
           allreduce_request8, mpierr)
           call mpi_wait(allreduce_request8, MPI_STATUS_IGNORE, mpierr)
         else
           call mpi_allreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), mpierr)
         endif
         if (success_int .eq. 1) then
          write(error_unit,*) "Error in trans_ev_band_to_full (imaginary part). Aborting..."
          return
         endif
       endif ! do_trans_to_full
     endif ! isSkewSymmetric


     ! We can now deallocate the stored householder vectors
     deallocate(hh_trans, stat=istat, errmsg=errorMessage)
     call check_deallocate_f("elpa2_template: hh_trans", 1537,  istat,  errorMessage)

     ! make sure tmat is deallocated when using check_pd
     if (allocated(tmat)) then
       deallocate(tmat, stat=istat, errmsg=errorMessage)
       call check_deallocate_f("elpa2_template: tmat", 1542,  istat,  errorMessage)
     endif

     if (obj%eigenvalues_only) then
       deallocate(q_dummy, stat=istat, errmsg=errorMessage)
       call check_deallocate_f("elpa2_template: q_dummy", 1547,  istat,  errorMessage)
     endif

     ! restore original OpenMP settings



   !copy qIntern and ev to provided device pointers
   if (present(qExtern)) then
   successGPU = gpu_memcpy(qExtern, c_loc(qIntern(1,1)), obj%local_nrows*obj%local_ncols*size_of_datatype, &
                             gpuMemcpyHostToDevice)
   endif
   call check_memcpy_GPU_f("elpa1: qIntern -> qExtern", 1607,  successGPU)
   successGPU = gpu_memcpy(evExtern, c_loc(ev(1)), obj%na*size_of_real_datatype, &
                             gpuMemcpyHostToDevice)
   call check_memcpy_GPU_f("elpa1: ev -> evExtern", 1610,  successGPU)


     deallocate(aIntern)
     !deallocate(evIntern)
     nullify(evIntern)
     if (present(qExtern)) then
       deallocate(qIntern)
     endif



   nullify(ev)
   nullify(a)
   nullify(q)

  nullify(q_actual)

     call obj%timer%stop("elpa_solve_evp_&
     &complex&
     &_2stage_&
     &double&
     &")
1    format(a,f10.3)

   end function

! vim: syntax=fortran




















!>  \brief elpa_solve_evp_complex_2stage_host_arrays_single_impl: Fortran function to solve the single-precision complex eigenvalue problem with a 2 stage approach
!>
!>  Parameters
!>
!>  \param na                                   Order of matrix a
!>
!>  \param nev                                  Number of eigenvalues needed
!>
!>  \param a(lda,matrixCols)                    Distributed matrix for which eigenvalues are to be computed.
!>                                              Distribution is like in Scalapack.
!>                                              The full matrix must be set (not only one half like in scalapack).
!>                                              Destroyed on exit (upper and lower half).
!>
!>  \param lda                                  Leading dimension of a
!>
!>  \param ev(na)                               On output: eigenvalues of a, every processor gets the complete set
!>
!>  \param q(ldq,matrixCols)                    On output: Eigenvectors of a
!>                                              Distribution is like in Scalapack.
!>                                              Must be always dimensioned to the full size (corresponding to (na,na))
!>                                              even if only a part of the eigenvalues is needed.
!>
!>  \param ldq                                  Leading dimension of q
!>
!>  \param nblk                                 blocksize of cyclic distribution, must be the same in both directions!
!>
!>  \param matrixCols                           local columns of matrix a and q
!>
!>  \param mpi_comm_rows                        MPI communicator for rows
!>  \param mpi_comm_cols                        MPI communicator for columns
!>  \param mpi_comm_all                         MPI communicator for the total processor set
!>
!>  \param kernel                               specify ELPA2 kernel to use
!>  \param useGPU (optional)                    decide whether GPUs should be used or not
!>
!>  \result success                             logical, false if error occured
!-------------------------------------------------------------------------------


!cannot use "../src/elpa2/../general/error_checking.inc" because filename with path can be too long for gfortran (max line length)


 function elpa_solve_evp_&
  &complex&
  &_&
  &2stage_a_h_a_&
  &single&
  &_impl (obj, &
   aExtern, &
   evExtern, &
   qExtern) result(success)

   !use matrix_plot
   use elpa_abstract_impl
   use elpa_utilities
   use elpa1_compute
   use elpa2_compute
   use elpa_mpi
   use cuda_functions
   use hip_functions
   use elpa_gpu
   use mod_check_for_gpu
   use elpa_omp
   use solve_tridi
   use thread_affinity
   use, intrinsic :: iso_c_binding
   implicit none
!    Copyright 2011, A. Marek
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
!

  integer, parameter :: rk = C_FLOAT
  integer, parameter :: ck = C_FLOAT_COMPLEX
  integer, parameter :: rck = C_FLOAT_COMPLEX
  complex(kind=rck), parameter     :: ZERO = (0.0_rk,0.0_rk), ONE = (1.0_rk,0.0_rk)
   class(elpa_abstract_impl_t), intent(inout)                         :: obj
   logical                                                            :: useGPU
   logical                                                            :: isSkewsymmetric
   integer(kind=c_int)                                                :: kernel, kernelByUser
   logical                                                            :: userHasSetKernel

   
!#ifdef REDISTRIBUTE_MATRIX

   complex(kind=c_float), intent(inout), target         :: aExtern(obj%local_nrows,*)
   complex(kind=c_float), optional, intent(out), target :: qExtern(obj%local_nrows,*)

!#else 
!
!#ifdef 1
!   complex(kind=c_float), intent(inout)                 :: a(obj%local_nrows,*)
!   complex(kind=c_float), optional, intent(out), target :: q(obj%local_nrows,*)
!#else
!   complex(kind=c_float), intent(inout)                 :: a(obj%local_nrows,obj%local_ncols)
!#ifdef ACTIVATE_SKEW
!   complex(kind=c_float), optional, target, intent(out) :: q(obj%local_nrows,2*obj%local_ncols)
!#else
!   complex(kind=c_float), optional, target, intent(out) :: q(obj%local_nrows,obj%local_ncols)
!#endif
!#endif
!
!#endif 


    complex(kind=rck), pointer                                  :: a(:,:)
    complex(kind=rck), pointer                                  :: q(:,:)
    real(kind=RK4), pointer                                  :: ev(:)

   real(kind=c_float), target, intent(inout)                  :: evExtern(obj%na)

   complex(kind=c_float), allocatable                   :: hh_trans(:,:)

   integer(kind=c_int)                                                :: my_pe, n_pes, my_prow, my_pcol, np_rows, np_cols
   integer(kind=MPI_KIND)                                             :: my_peMPI, n_pesMPI, my_prowMPI, my_pcolMPI, &
                                                                         np_rowsMPI, np_colsMPI, mpierr
   integer(kind=c_int)                                                :: nbw, num_blocks
   integer(kind=c_int)                                                :: l_cols_nev, l_rows, l_cols
   complex(kind=c_float), allocatable                   :: tmat(:,:,:)
   real(kind=c_float), allocatable                            :: e(:)
   real(kind=c_float), allocatable                            :: q_real(:,:)
   complex(kind=c_float), allocatable, target           :: q_dummy(:,:)
   complex(kind=c_float), pointer                       :: q_actual(:,:)


   integer(kind=c_int)                                                :: i
   logical                                                            :: success, successGPU
   integer(kind=c_int)                                                :: success_int
   logical                                                            :: wantDebug
   integer(kind=c_int)                                                :: istat, gpu, skewsymmetric, debug, qr
   character(200)                                                     :: errorMessage
   logical                                                            :: do_useGPU, do_useGPU_bandred, &
                                                                         do_useGPU_tridiag_band, do_useGPU_solve_tridi, &
                                                                         do_useGPU_trans_ev_tridi_to_band, &
                                                                         do_useGPU_trans_ev_band_to_full
   integer(kind=c_int)                                                :: numberOfGPUDevices
   integer(kind=c_intptr_t), parameter                                :: size_of_datatype = size_of_&
                                                                                            &single&
                                                                                            &_&
                                                                                            &complex
   integer(kind=c_intptr_t), parameter                                :: size_of_real_datatype = size_of_&
                                                                                                 &single&
                                                                                                 &_real
   integer(kind=ik)                                                   :: na, nev, nblk, matrixCols, &
                                                                         mpi_comm_rows, mpi_comm_cols,        &
                                                                         mpi_comm_all, check_pd, error, matrixRows
   real(kind=c_float)                                         :: thres_pd

   complex(kind=rck), pointer                                   :: aIntern(:,:)
   complex(kind=c_float), pointer                       :: qIntern(:,:)
   real(kind=RK4), pointer                                  :: evIntern(:)

   logical                                                            :: do_bandred, do_tridiag, do_solve_tridi,  &
                                                                         do_trans_to_band, do_trans_to_full
   logical                                                            :: good_nblk_gpu

   integer(kind=ik)                                                   :: nrThreads, limitThreads
   integer(kind=ik)                                                   :: global_index
   logical                                                            :: reDistributeMatrix, doRedistributeMatrix
   integer(kind=ik)                                                   :: pinningInfo

   integer(kind=MPI_KIND)                                             :: bcast_request1, bcast_request2, allreduce_request1, &
                                                                         allreduce_request2, allreduce_request3, &
                                                                         allreduce_request4, allreduce_request5, &
                                                                         allreduce_request6, allreduce_request7, &
                                                                         allreduce_request8
   logical                                                            :: useNonBlockingCollectivesAll
   integer(kind=ik)                                                   :: gpu_old, gpu_new
   integer(kind=ik)                                                   :: non_blocking_collectives_all











    call obj%timer%start("elpa_solve_evp_&
    &complex&
    &_2stage_&
    &single&
    &")

    call obj%get("debug",debug, error)
    if (error .ne. ELPA_OK) then
      write(error_unit,*) "ELPA2: Problem getting option for debug settings. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

    endif

    wantDebug = debug == 1

    ! check legacy GPU setings
    ! check legacy GPU setings
    if (obj%is_set("gpu") == 1) then
      write(error_unit,*) "You still use the deprecated option 'gpu', consider switching to 'nvidia-gpu'"
      call obj%get("gpu", gpu_old, error)     
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "GPU_SOLVER : Problem getting option for gpu. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_evp_&
     &complex&
     &_1stage_&
     &single&
     &")
     success = .false.
     return
      endif
      if (obj%is_set("nvidia-gpu") == 0) then
        ! set gpu and nvidia-gpu consistent
        call obj%set("nvidia-gpu", gpu_old, error)
        if (error .ne. ELPA_OK) then
          write(error_unit,*) "GPU_SOLVER : Problem setting option for nvidia-gpu. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_evp_&
     &complex&
     &_1stage_&
     &single&
     &")
     success = .false.
     return
        endif
        write(error_unit,*) "Will set the new keyword 'nvidia-gpu' now."
        write(error_unit,*) "And ignore the 'gpu' keyword from now on"
      else ! obj%is_set("nvidia-gpu") == 0
        call obj%get("nvidia-gpu", gpu_new, error)
        if (error .ne. ELPA_OK) then
          write(error_unit,*) "GPU_SOLVER : Problem getting option for nvidia-gpu. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_evp_&
     &complex&
     &_1stage_&
     &single&
     &")
     success = .false.
     return
        endif
        if (gpu_old .ne. gpu_new) then
                write(error_unit,*) "Please do not set 'gpu' but 'nvidia-gpu' instead"
          write(error_unit,*) "You cannot set gpu = ",gpu_old," and nvidia-gpu=",gpu_new,". Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_evp_&
     &complex&
     &_1stage_&
     &single&
     &")
     success = .false.
     return
        endif
      endif ! obj%is_set("nvidia-gpu") == 0
      if (obj%is_set("amd-gpu") == 0) then
        ! amd-gpu is not set, but gpu is set
        ! this is ok in anycase
      else ! obj%is_set("amd-gpu") == 0
        call obj%get("amd-gpu", gpu_new, error)
        if (error .ne. ELPA_OK) then
          write(error_unit,*) "GPU_SOLVER : Problem getting option for amd-gpu. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_evp_&
     &complex&
     &_1stage_&
     &single&
     &")
     success = .false.
     return
        endif
        ! this is ok, if gpu == 0 and amd-gpu == 1 or
        !             if gpu == 0 and amd-gpu == 0 or
        !             if gpu == 1 and amd-gpu == 0
        if (gpu_old .eq. 1 .and. gpu_new .eq. 1) then
          write(error_unit,*) "GPU_SOLVER : You cannot set gpu = 1 and amd-gpu = 1. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_evp_&
     &complex&
     &_1stage_&
     &single&
     &")
     success = .false.
     return
        endif
      endif ! amd-gpu
      if (obj%is_set("intel-gpu") == 0) then
        ! intel-gpu is not set, but gpu is set
        ! this is ok in anycase
      else ! obj%is_set("intel-gpu") == 0
        call obj%get("intel-gpu", gpu_new, error)
        if (error .ne. ELPA_OK) then
          write(error_unit,*) "GPU_SOLVER : Problem getting option for intel-gpu. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_evp_&
     &complex&
     &_1stage_&
     &single&
     &")
     success = .false.
     return
        endif
        ! this is ok, if gpu == 0 and intel-gpu == 1 or
        !             if gpu == 0 and intel-gpu == 0 or
        !             if gpu == 1 and intel-gpu == 0
        if (gpu_old .eq. 1 .and. gpu_new .eq. 1) then
          write(error_unit,*) "GPU_SOLVER : You cannot set gpu = 1 and intel-gpu = 1. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_evp_&
     &complex&
     &_1stage_&
     &single&
     &")
     success = .false.
     return
        endif
      endif ! intel-gpu
    else ! gpu not set
      ! nothing to do since the legacy option is not set
    endif ! gpu is set

    ! GPU settings
    if (gpu_vendor() == NVIDIA_GPU) then
      call obj%get("nvidia-gpu", gpu, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "GPU_SOLVER : Problem getting option for NVIDIA GPU. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_evp_&
     &complex&
     &_1stage_&
     &single&
     &")
     success = .false.
     return
      endif
    else if (gpu_vendor() == AMD_GPU) then
      call obj%get("amd-gpu", gpu, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "GPU_SOLVER : Problem getting option for AMD GPU. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_evp_&
     &complex&
     &_1stage_&
     &single&
     &")
     success = .false.
     return
      endif
    else if (gpu_vendor() == INTEL_GPU) then
      call obj%get("intel-gpu", gpu, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "GPU_SOLVER : Problem getting option for INTEL GPU. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_evp_&
     &complex&
     &_1stage_&
     &single&
     &")
     success = .false.
     return
      endif
    else ! no supported gpu
      gpu = 0
    endif

   if (gpu .eq. 1) then
     useGPU =.true.
   else
     useGPU = .false.
   endif


    do_useGPU = .false.

    ! get the kernel and check whether it has been set by the user
    if (obj%is_set("complex_kernel") == 1) then
      userHasSetKernel = .true.
    else
      userHasSetKernel = .false.
    endif

    ! after this point you may _never_ call get for the kernel again, or set the
    ! kernel !! The reason is that we might have to adjust the kernel, which is
    ! passed as a variable
    call obj%get("complex_kernel", kernel, error)
    if (error .ne. ELPA_OK) then
      write(error_unit,*) "ELPA2: Problem getting option for kernel settings. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

    endif

    ! to implement a possibiltiy to set this
    useNonBlockingCollectivesAll = .false.

    call obj%get("mpi_comm_rows",mpi_comm_rows, error)
    if (error .ne. ELPA_OK) then
      write(error_unit,*) "ELPA2: Problem getting option for mpi_comm_rows. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

    endif
    call obj%get("mpi_comm_cols",mpi_comm_cols,error)
    if (error .ne. ELPA_OK) then
      write(error_unit,*) "ELPA2: Problem getting option for mpi_comm_cols. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

    endif
    call obj%get("mpi_comm_parent",mpi_comm_all,error)
    if (error .ne. ELPA_OK) then
      write(error_unit,*) "ELPA2: Problem getting option for mpi_comm_parent. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

    endif

    call obj%timer%start("mpi_communication")
    call mpi_comm_rank(int(mpi_comm_all,kind=MPI_KIND) ,my_peMPI ,mpierr)
    call mpi_comm_size(int(mpi_comm_all,kind=MPI_KIND) ,n_pesMPI ,mpierr)

    call mpi_comm_rank(int(mpi_comm_rows,kind=MPI_KIND) ,my_prowMPI ,mpierr)
    call mpi_comm_size(int(mpi_comm_rows,kind=MPI_KIND) ,np_rowsMPI ,mpierr)
    call mpi_comm_rank(int(mpi_comm_cols,kind=MPI_KIND) ,my_pcolMPI ,mpierr)
    call mpi_comm_size(int(mpi_comm_cols,kind=MPI_KIND) ,np_colsMPI ,mpierr)

    my_pe = int(my_peMPI, kind=c_int)
    n_pes = int(n_pesMPI, kind=c_int)
    my_prow = int(my_prowMPI, kind=c_int)
    np_rows = int(np_rowsMPI, kind=c_int)
    my_pcol = int(my_pcolMPI, kind=c_int)
    np_cols = int(np_colsMPI, kind=c_int)

    call obj%timer%stop("mpi_communication")

    na         = obj%na
    nev        = obj%nev
    nblk       = obj%nblk
    matrixCols = obj%local_ncols
    matrixRows = obj%local_nrows

    call obj%get("nbc_all_elpa2_main", non_blocking_collectives_all, error)
    if (error .ne. ELPA_OK) then
      write(error_unit,*) "ELPA2: Problem getting option for non blocking collectives. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

    endif

    if (non_blocking_collectives_all .eq. 1) then
      useNonBlockingCollectivesAll = .true.
    else
      useNonBlockingCollectivesAll = .false.
    endif

    ! openmp setting
    nrThreads = 1


    if (useGPU) then
      call obj%timer%start("check_for_gpu")
      if (check_for_gpu(obj, my_pe, numberOfGPUDevices, wantDebug=wantDebug)) then
        do_useGPU = .true.
        ! set the neccessary parameters
        call set_gpu_parameters()

      else
        write(error_unit,*) "ELPA2: GPUs are requested but not detected! Aborting..."
        call obj%timer%stop("check_for_gpu")
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

      endif
      call obj%timer%stop("check_for_gpu")

      if (nblk*(max(np_rows,np_cols)-1) >= na) then
        if (my_pe .eq. 0) then
          write(error_unit,*) "ELPA: Warning, block size too large for this matrix size and process grid!"
          write(error_unit,*) "Choose a smaller block size if possible.",nblk*(max(np_rows,np_cols)-1),na
          write(error_unit,*) "Disabling GPU usage! "
        endif

        do_useGPU = .false.
        if (kernel .eq. ELPA_2STAGE_COMPLEX_NVIDIA_GPU) then
          if (userHasSetKernel) then
            ! user fixed inconsistent input.
            ! sadly, we do have to abort
            if (my_pe .eq. 0) then
              write(error_unit,*) "You set (fixed) the kernel to GPU, but GPUs cannot be used."
              write(error_unit,*) "Either adapt the block size or the process grid, or do not set the GPU kernel! Aborting..."
            endif
            stop 1
          else
            ! here we should set the default kernel
            kernel = ELPA_2STAGE_COMPLEX_DEFAULT
          endif
        endif
      endif

    endif ! useGPU




    do_useGPU_bandred = do_useGPU
    do_useGPU_tridiag_band = .false.  ! not yet ported
    do_useGPU_solve_tridi = do_useGPU
    do_useGPU_trans_ev_tridi_to_band = do_useGPU
    do_useGPU_trans_ev_band_to_full = do_useGPU


   reDistributeMatrix = .false.



   ! aIntern, qIntern, are normally pointers since no matrix redistribution is used
   ! point them to  the external arrays
   aIntern => aExtern(1:matrixRows,1:matrixCols)
   if (present(qExtern)) then
     qIntern => qExtern(1:matrixRows,1:matrixCols)
   endif

  ! whether a matrix redistribution or not is happening we still
  ! have to point ev
   evIntern => evExtern(1:obj%na)

     a       => aIntern(1:matrixRows,1:matrixCols)
     if (present(qExtern)) then
       q       => qIntern(1:matrixRows,1:matrixCols)
     endif

   ev      => evIntern(1:obj%na)

   call obj%get("output_pinning_information", pinningInfo, error)
   if (error .ne. ELPA_OK) then
     write(error_unit,*) "ELPA2: Problem setting option for debug. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

   endif

   if (pinningInfo .eq. 1) then
     call init_thread_affinity(nrThreads)

     call check_thread_affinity()
     if (my_pe .eq. 0) call print_thread_affinity(my_pe)
     call cleanup_thread_affinity()
   endif

    success = .true.

    if (present(qExtern)) then
      obj%eigenvalues_only = .false.
    else
      obj%eigenvalues_only = .true.
    endif

   ! special case na = 1
   if (na .eq. 1) then
     ev(1) = real(a(1,1))
     if (.not.(obj%eigenvalues_only)) then
       q(1,1) = ONE
     endif

     ! restore original OpenMP settings

     call obj%timer%stop("elpa_solve_evp_&
     &complex&
     &_2stage_&
     &single&
     &")
     success = .true.
     return
   endif

   if (nev == 0) then
     nev = 1
     obj%eigenvalues_only = .true.
   endif

    !call obj%get("complex_kernel", kernel, error)
    !if (error .ne. ELPA_OK) then
    !  print *,"Problem getting option for kernel settings. Aborting..."
    !  stop 1
    !endif

    isSkewsymmetric = .false.

    ! only if we want (and can) use GPU in general, look what are the
    ! requirements for individual routines. Implicitly they are all set to 1, so
    ! unless specified otherwise by the user, GPU versions of all individual
    ! routines should be used
    if (do_useGPU) then
      call obj%get("gpu_bandred", gpu, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "ELPA2: Problem getting option gpu_bandred settings. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

      endif
      do_useGPU_bandred = (gpu == 1)

      ! not yet ported
      !call obj%get("gpu_tridiag_band", gpu, error)
      !if (error .ne. ELPA_OK) then
      !  print *,"Problem getting option for gpu_tridiag_band settings. Aborting..."
      !  stop 1
      !endif
      !do_useGPU_tridiag_band = (gpu == 1)

      call obj%get("gpu_solve_tridi", gpu, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "ELPA2: Problem getting option for gpu_solve_tridi settings. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

      endif
      do_useGPU_solve_tridi = (gpu == 1)

      call obj%get("gpu_trans_ev_tridi_to_band", gpu, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "ELPA2: Problem getting option for gpu_trans_ev_tridi_to_band settings. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

      endif
      do_useGPU_trans_ev_tridi_to_band = (gpu == 1)

      call obj%get("gpu_trans_ev_band_to_full", gpu, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "ELPA2: Problem getting option for gpu_trans_ev_band_to_full settings. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

      endif
      do_useGPU_trans_ev_band_to_full = (gpu == 1)
    endif

    ! check consistency between request for GPUs and defined kernel
    if (do_useGPU_trans_ev_tridi_to_band) then
      ! if the user has set explicitely a kernel before than honour this
      ! otherwise set GPU kernel
      if (userHasSetKernel) then
        if (kernel .ne. ELPA_2STAGE_COMPLEX_NVIDIA_GPU) then
          write(error_unit,*) "ELPA: Warning, GPU usage has been requested but compute kernel is set by the user as non-GPU!"
          write(error_unit,*) "The compute kernel will be executed on CPUs!"
          do_useGPU_trans_ev_tridi_to_band = .false.
          kernel = ELPA_2STAGE_COMPLEX_DEFAULT
        else
          good_nblk_gpu = .false.
        endif
      else ! userHasSetKernel
        !call obj%set("complex_kernel", ELPA_2STAGE_COMPLEX_NVIDIA_GPU, error)
        !if (error .ne. ELPA_OK) then
        !  write(error_unit,*) "Cannot set kernel to GPU kernel"
        !  stop 1
        !endif

        if (my_pe .eq. 0) write(error_unit,*) "You requested the GPU version, thus the GPU kernel is activated"
        good_nblk_gpu = .false.

        kernel = ELPA_2STAGE_COMPLEX_NVIDIA_GPU
      endif ! userHasSetKernel

      ! Accepted values are 2,4,8,16,...,512
      do i = 1,10
        if (nblk == 2**i) then
          good_nblk_gpu = .true.
          exit
        endif
      enddo

      if (.not. good_nblk_gpu .and. do_useGPU_trans_ev_tridi_to_band) then
         write(error_unit,*) "ELPA: Warning, GPU kernel only works with block size 2^n (n = 1, 2, ..., 10)!"
         write(error_unit,*) "The compute kernel will be executed on CPUs!"
         write(error_unit,*) "We recommend changing the block size to 2^n"
         do_useGPU_trans_ev_tridi_to_band = .false.
         ! should be set
         kernel = ELPA_2STAGE_COMPLEX_DEFAULT
      endif
    endif





    ! check again, now kernel and do_useGPU_trans_ev_tridi_to_band should be
    ! finally consistent
    if (do_useGPU_trans_ev_tridi_to_band) then
      !call obj%get("complex_kernel", kernel, error)
      !if (error .ne. ELPA_OK) then
      !  write(error_unit,*) "Cannot get kernel to GPU kernel"
      !  stop 1
      !endif
      if (kernel .ne. ELPA_2STAGE_COMPLEX_NVIDIA_GPU) then
        ! this should never happen, checking as an assert
        write(error_unit,*) "ELPA: INTERNAL ERROR setting GPU kernel!  Aborting..."
        stop 1
      endif
    else ! do not use GPU
      if (kernel .eq. ELPA_2STAGE_COMPLEX_NVIDIA_GPU) then
        ! combination not allowed
        write(error_unit,*) "ELPA: Warning, GPU usage has NOT been requested but compute kernel &
                            &is defined as the GPU kernel!  Setting default kernel"
        kernel = ELPA_2STAGE_COMPLEX_DEFAULT
        !TODO do error handling properly
      endif
    endif


     !! consistency check: is user set kernel still identical with "kernel" or did
     !! we change it above? This is a mess and should be cleaned up
     !call obj%get("complex_kernel",kernelByUser,error)
     !if (error .ne. ELPA_OK) then
     !  print *,"Problem getting option for user kernel settings. Aborting..."
     !  stop 1
     !endif

     !if (kernelByUser .ne. kernel) then
     !  call obj%set("complex_kernel", kernel, error)
     !  if (error .ne. ELPA_OK) then
     !    print *,"Problem setting kernel. Aborting..."
     !    stop 1
     !  endif
     !endif




    if (.not. obj%eigenvalues_only) then
      q_actual => q(1:matrixRows,1:matrixCols)
    else
     allocate(q_dummy(1:matrixRows,1:matrixCols), stat=istat, errmsg=errorMessage)
     call check_allocate_f("elpa2_template: q_dummy", 998,  istat,  errorMessage)
     q_actual => q_dummy(1:matrixRows,1:matrixCols)
    endif

    ! set the default values for each of the 5 compute steps
    do_bandred        = .true.
    do_tridiag        = .true.
    do_solve_tridi    = .true.
    do_trans_to_band  = .true.
    do_trans_to_full  = .true.

    if (obj%eigenvalues_only) then
      do_trans_to_band  = .false.
      do_trans_to_full  = .false.
    endif

    if (obj%is_set("bandwidth") == 1) then
      ! bandwidth is set. That means, that the inputed matrix is actually banded and thus the
      ! first step of ELPA2 should be skipped
      call obj%get("bandwidth",nbw,error)
      if (nbw == 0) then
        if (wantDebug) then
          write(error_unit,*) "Specified bandwidth = 0; ELPA refuses to solve the eigenvalue problem ", &
                              "for a diagonal matrix! This is too simple"
          endif
          write(error_unit,*) "Specified bandwidth = 0; ELPA refuses to solve the eigenvalue problem ", &
                 "for a diagonal matrix! This is too simple"
        success = .false.
        return
      endif
      if (mod(nbw, nblk) .ne. 0) then
        ! treat matrix with an effective bandwidth slightly bigger than specified bandwidth
        ! such that effective bandwidth is a multiply of nblk. which is a prerequiste for ELPA
        nbw = nblk * ceiling(real(nbw,kind=c_double)/real(nblk,kind=c_double))

        ! just check that effective bandwidth is NOT larger than matrix size
        if (nbw .gt. na) then
          if (wantDebug) then
            write(error_unit,*) "Specified bandwidth ",nbw," leads internaly to a computed bandwidth ", &
                                "which is larger than the matrix size ",na," ! ELPA will abort! Try to", &
                                "solve your problem by not specifing a bandwidth"
          endif
          print *, "Specified bandwidth ",nbw," leads internaly to a computed bandwidth ", &
                                "which is larger than the matrix size ",na," ! ELPA will abort! Try to", &
                                "solve your problem by not specifing a bandwidth"
          success = .false.
          return
        endif
      endif
      do_bandred       = .false. ! we already have a banded matrix
      do_solve_tridi   = .true.  ! we also have to solve something :-)
      do_trans_to_band = .true.  ! and still we have to backsub to banded
      do_trans_to_full = .false. ! but not to full since we have a banded matrix
    else ! matrix is not banded, determine the intermediate bandwidth for full->banded->tridi
      !first check if the intermediate bandwidth was set by the user
      call obj%get("intermediate_bandwidth", nbw, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "Problem getting option for intermediate_bandwidth. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

      endif

      if(nbw == 0) then
        ! intermediate bandwidth was not specified, select one of the defaults

        ! Choose bandwidth, must be a multiple of nblk, set to a value >= 32
        ! On older systems (IBM Bluegene/P, Intel Nehalem) a value of 32 was optimal.
        ! For Intel(R) Xeon(R) E5 v2 and v3, better use 64 instead of 32!
        ! For IBM Bluegene/Q this is not clear at the moment. We have to keep an eye
        ! on this and maybe allow a run-time optimization here
        nbw = (31/nblk+1)*nblk
      else
        ! intermediate bandwidth has been specified by the user, check, whether correctly
        if (mod(nbw, nblk) .ne. 0) then
          print *, "Specified bandwidth ",nbw," has to be mutiple of the blocksize ", nblk, ". Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

        endif
      endif !nbw == 0

      num_blocks = (na-1)/nbw + 1

      ! tmat is needed only in full->band and band->full steps, so alocate here
      ! (not allocated for banded matrix on input)
      allocate(tmat(nbw,nbw,num_blocks), stat=istat, errmsg=errorMessage)
      call check_allocate_f("elpa2_template: tmat", 1085,  istat,  errorMessage)

      do_bandred       = .true.
      do_solve_tridi   = .true.
      do_trans_to_band = .true.
      do_trans_to_full = .true.
    endif  ! matrix not already banded on input

    ! start the computations in 5 steps
    if (do_bandred) then
      call obj%autotune_timer%start("full_to_band")
      call obj%timer%start("full_to_band")
      ! Reduction full -> band
      call bandred_&
      &complex&
      &_&
      &single &
      (obj, na, a, &
      matrixRows, nblk, nbw, matrixCols, num_blocks, mpi_comm_rows, mpi_comm_cols, tmat, &
      wantDebug, do_useGPU_bandred, success, &
       nrThreads, isSkewsymmetric)

      call obj%timer%stop("full_to_band")
      call obj%autotune_timer%stop("full_to_band")
  
      if (success) then
        success_int = 0
      else
        success_int = 1
      endif

      if (useNonBlockingCollectivesAll) then
        call mpi_iallreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), &
        allreduce_request2, mpierr)
        call mpi_wait(allreduce_request2, MPI_STATUS_IGNORE, mpierr)
      else
        call mpi_allreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), mpierr)
      endif
      if (success_int .eq. 1) then
        write(error_unit,*) "ELPA2: bandred returned an error. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

      endif
    endif

     ! Reduction band -> tridiagonal
     if (do_tridiag) then
       allocate(e(na), stat=istat, errmsg=errorMessage)
       call check_allocate_f("elpa2_template: e", 1143,  istat,  errorMessage)

       call obj%autotune_timer%start("band_to_tridi")
       call obj%timer%start("band_to_tridi")
       call tridiag_band_&
       &complex&
       &_&
       &single&
       (obj, na, nbw, nblk, a, matrixRows, ev, e, matrixCols, hh_trans, mpi_comm_rows, mpi_comm_cols, mpi_comm_all, &
       do_useGPU_tridiag_band, wantDebug, nrThreads, isSkewsymmetric, success)
  
       if (success) then
         success_int = 0
       else
         success_int = 1
       endif

       if (useNonBlockingCollectivesAll) then
         call mpi_iallreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), &
         allreduce_request3, mpierr)
         call mpi_wait(allreduce_request3, MPI_STATUS_IGNORE, mpierr)
       else
         call mpi_allreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), mpierr)
       endif
       if (success_int .eq. 1) then
         write(error_unit,*) "Error in tridiag_band. Aborting..."
         return
       endif

       call obj%timer%start("mpi_communication")
       if (useNonBlockingCollectivesAll) then
         call mpi_ibcast(ev, int(na,kind=MPI_KIND), MPI_REAL4, 0_MPI_KIND, int(mpi_comm_all,kind=MPI_KIND), bcast_request1, mpierr)
         call mpi_ibcast(e, int(na,kind=MPI_KIND), MPI_REAL4, 0_MPI_KIND, int(mpi_comm_all,kind=MPI_KIND), bcast_request2, mpierr)

         call mpi_wait(bcast_request1, MPI_STATUS_IGNORE, mpierr)
         call mpi_wait(bcast_request2, MPI_STATUS_IGNORE, mpierr)
       else
         call mpi_bcast(ev, int(na,kind=MPI_KIND), MPI_REAL4, 0_MPI_KIND, int(mpi_comm_all,kind=MPI_KIND), mpierr)
         call mpi_bcast(e, int(na,kind=MPI_KIND), MPI_REAL4, 0_MPI_KIND, int(mpi_comm_all,kind=MPI_KIND), mpierr)
       endif
       call obj%timer%stop("mpi_communication")

       call obj%timer%stop("band_to_tridi")
       call obj%autotune_timer%stop("band_to_tridi")
     endif ! do_tridiag

     l_rows = local_index(na, my_prow, np_rows, nblk, -1) ! Local rows of a and q
     l_cols = local_index(na, my_pcol, np_cols, nblk, -1) ! Local columns of q
     l_cols_nev = local_index(nev, my_pcol, np_cols, nblk, -1) ! Local columns corresponding to nev

     allocate(q_real(l_rows,l_cols), stat=istat, errmsg=errorMessage)
     call check_allocate_f("elpa2_template: q_real", 1205,  istat,  errorMessage)

     ! Solve tridiagonal system
     if (do_solve_tridi) then
       call obj%autotune_timer%start("solve")
       call obj%timer%start("solve")

       call solve_tridi_&
       &single &
       (obj, na, nev, ev, e, &
       q_real, ubound(q_real,dim=1), &
       nblk, matrixCols, mpi_comm_all, mpi_comm_rows, mpi_comm_cols, do_useGPU_solve_tridi, wantDebug, &
               success, nrThreads)

       call obj%timer%stop("solve")
       call obj%autotune_timer%stop("solve")
  
       if (success) then
         success_int = 0
       else
         success_int = 1
       endif

       if (useNonBlockingCollectivesAll) then
         call mpi_iallreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), &
         allreduce_request4, mpierr)
         call mpi_wait(allreduce_request4, MPI_STATUS_IGNORE, mpierr)
       else
         call mpi_allreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), mpierr)
       endif

       if (success_int .eq. 1) then
         write(error_unit,*) "ELPA2: solve returned an error: Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

       endif
     endif ! do_solve_tridi

     deallocate(e, stat=istat, errmsg=errorMessage)
     call check_deallocate_f("elpa2_template: e", 1257,  istat,  errorMessage)

     if (obj%eigenvalues_only) then
       do_trans_to_band = .false.
       do_trans_to_full = .false.
     else
       call obj%get("check_pd",check_pd,error)
       if (error .ne. ELPA_OK) then
         write(error_unit,*) "Problem getting option for check_pd. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

       endif
       if (check_pd .eq. 1) then
         call obj%get("thres_pd_&
         &single&
         &",thres_pd,error)
         if (error .ne. ELPA_OK) then
            write(error_unit,*) "Problem getting option for thres_pd_&
            &single&
            &. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

         endif

         check_pd = 0
         do i = 1, na
           if (ev(i) .gt. thres_pd) then
             check_pd = check_pd + 1
           endif
         enddo
         if (check_pd .lt. na) then
           ! not positiv definite => eigenvectors needed
           do_trans_to_band = .true.
           do_trans_to_full = .true.
         else
           do_trans_to_band = .false.
           do_trans_to_full = .false.
         endif
       endif
     endif ! eigenvalues only

     if (do_trans_to_band) then
       ! q must be given thats why from here on we can use q and not q_actual
       q(1:l_rows,1:l_cols_nev) = q_real(1:l_rows,1:l_cols_nev)
     endif

     ! make sure q_real is deallocated when using check_pd
     if (allocated(q_real)) then
       deallocate(q_real, stat=istat, errmsg=errorMessage)
       call check_deallocate_f("elpa2_template: q_real", 1305,  istat,  errorMessage)
     endif

       if (isSkewsymmetric) then
       ! Extra transformation step for skew-symmetric matrix. Multiplication with diagonal complex matrix D.
       ! This makes the eigenvectors complex.
       ! For now real part of eigenvectors is generated in first half of q, imaginary part in second part.
         q(1:matrixRows, matrixCols+1:2*matrixCols) = 0.0
         do i = 1, matrixRows
!          global_index = indxl2g(i, nblk, my_prow, 0, np_rows)
           global_index = np_rows*nblk*((i-1)/nblk) + MOD(i-1,nblk) + MOD(np_rows+my_prow-0, np_rows)*nblk + 1
           if (mod(global_index-1,4) .eq. 0) then
              ! do nothing
           end if
           if (mod(global_index-1,4) .eq. 1) then
              q(i,matrixCols+1:2*matrixCols) = q(i,1:matrixCols)
              q(i,1:matrixCols) = 0
           end if
           if (mod(global_index-1,4) .eq. 2) then
              q(i,1:matrixCols) = -q(i,1:matrixCols)
           end if
           if (mod(global_index-1,4) .eq. 3) then
              q(i,matrixCols+1:2*matrixCols) = -q(i,1:matrixCols)
              q(i,1:matrixCols) = 0
           end if
         end do
       endif

       ! Backtransform stage 1
     if (do_trans_to_band) then

       !debug
!#if defined(WITH_OPENMP_OFFLOAD_GPU_VERSION) || defined(WITH_SYCL_GPU_VERSION)
       !if (gpu_vendor() == OPENMP_OFFLOAD_GPU .or. gpu_vendor() == SYCL_GPU) then
       call obj%autotune_timer%start("tridi_to_band")
       call obj%timer%start("tridi_to_band")
       ! In the skew-symmetric case this transforms the real part
       call trans_ev_tridi_to_band_&
       &complex&
       &_&
       &single &
       (obj, na, nev, nblk, nbw, q, &
       matrixRows, matrixCols, hh_trans, my_pe, mpi_comm_rows, mpi_comm_cols, &
       wantDebug, do_useGPU_trans_ev_tridi_to_band, &
       nrThreads, success=success, kernel=kernel)
       call obj%timer%stop("tridi_to_band")
       call obj%autotune_timer%stop("tridi_to_band")

       if (success) then
         success_int = 0
       else
         success_int = 1
       endif

       if (useNonBlockingCollectivesAll) then
         call mpi_iallreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), &
         allreduce_request5, mpierr)
         call mpi_wait(allreduce_request5, MPI_STATUS_IGNORE, mpierr)
       else
         call mpi_allreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), mpierr)
       endif

       if (success_int .eq. 1) then
         write(error_unit,*) "ELPA2: trans_ev_tridi_to_band returned an error. Aborting..."
         return
       endif

     endif ! do_trans_to_band

     ! the array q (currently) always resides on host even when using GPU

     if (do_trans_to_full) then
       call obj%autotune_timer%start("band_to_full")
       call obj%timer%start("band_to_full")
       ! Backtransform stage 2
       ! In the skew-symemtric case this transforms the real part
       call trans_ev_band_to_full_&
       &complex&
       &_&
       &single &
       (obj, na, nev, nblk, nbw, a, &
       matrixRows, tmat, q,  &
       matrixRows, matrixCols, num_blocks, mpi_comm_rows, mpi_comm_cols, do_useGPU_trans_ev_band_to_full &
       , success)
       call obj%timer%stop("band_to_full")
       call obj%autotune_timer%stop("band_to_full")

       if (success) then
         success_int = 0
       else
         success_int = 1
       endif

       if (useNonBlockingCollectivesAll) then
         call mpi_iallreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), &
         allreduce_request6, mpierr)
         call mpi_wait(allreduce_request6, MPI_STATUS_IGNORE, mpierr)
       else
         call mpi_allreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), mpierr)
       endif
       if (success_int .eq. 1) then
         write(error_unit,*) "Error in trans_ev_band_to_full. Aborting..."
         return
       endif
     endif ! do_trans_to_full
! #ifdef DOUBLE_PRECISION_REAL
!        call prmat(na,useGPU,q(1:matrixRows, 1:matrixCols),q_dev,matrixRows,matrixCols,nblk,my_prow,my_pcol,np_rows,np_cols,'R',1)
! #endif


     !skew symmetric imaginary part for tridi_to_band and band_to_full
     if (isSkewsymmetric) then
       if (do_trans_to_band) then
         call obj%autotune_timer%start("tridi_to_band")
         call obj%timer%start("skew_tridi_to_band")
         ! Transform imaginary part
         ! Transformation of real and imaginary part could also be one call of trans_ev_tridi acting on the n x 2n matrix.
         call trans_ev_tridi_to_band_&
         &complex&
         &_&
         &single &
         (obj, na, nev, nblk, nbw, q(1:matrixRows, matrixCols+1:2*matrixCols), &
         matrixRows, matrixCols, hh_trans, my_pe, mpi_comm_rows, mpi_comm_cols, &
         wantDebug, do_useGPU_trans_ev_tridi_to_band, &
         nrThreads, success=success, kernel=kernel)

         call obj%timer%stop("skew_tridi_to_band")
         call obj%autotune_timer%stop("tridi_to_band")

         if (success) then
           success_int = 0
         else
           success_int = 1
         endif

         if (useNonBlockingCollectivesAll) then
           call mpi_iallreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), &
           allreduce_request7, mpierr)
           call mpi_wait(allreduce_request7, MPI_STATUS_IGNORE, mpierr)
         else
           call mpi_allreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), mpierr)
         endif
         if (success_int .eq. 1) then
          write(error_unit,*) "Error in trans_ev_tridi_to_band (imaginary part). Aborting..."
          return
         endif
       endif ! do_trans_tridi_to_band

       if (do_trans_to_full) then
       call obj%autotune_timer%start("band_to_full")
       call obj%timer%start("band_to_full")
         ! Transform imaginary part
         ! Transformation of real and imaginary part could also be one call of trans_ev_band_to_full_ acting on the n x 2n matrix.
         call trans_ev_band_to_full_&
         &complex&
         &_&
         &single &
         (obj, na, nev, nblk, nbw, a, &
         matrixRows, tmat, q(1:matrixRows, matrixCols+1:2*matrixCols),  &
         matrixRows, matrixCols, num_blocks, mpi_comm_rows, mpi_comm_cols, do_useGPU_trans_ev_band_to_full, &
         success)

         call obj%timer%stop("band_to_full")
         call obj%autotune_timer%stop("band_to_full")

         if (success) then
           success_int = 0
         else
           success_int = 1
         endif

         if (useNonBlockingCollectivesAll) then
           call mpi_iallreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), &
           allreduce_request8, mpierr)
           call mpi_wait(allreduce_request8, MPI_STATUS_IGNORE, mpierr)
         else
           call mpi_allreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), mpierr)
         endif
         if (success_int .eq. 1) then
          write(error_unit,*) "Error in trans_ev_band_to_full (imaginary part). Aborting..."
          return
         endif
       endif ! do_trans_to_full
     endif ! isSkewSymmetric


     ! We can now deallocate the stored householder vectors
     deallocate(hh_trans, stat=istat, errmsg=errorMessage)
     call check_deallocate_f("elpa2_template: hh_trans", 1537,  istat,  errorMessage)

     ! make sure tmat is deallocated when using check_pd
     if (allocated(tmat)) then
       deallocate(tmat, stat=istat, errmsg=errorMessage)
       call check_deallocate_f("elpa2_template: tmat", 1542,  istat,  errorMessage)
     endif

     if (obj%eigenvalues_only) then
       deallocate(q_dummy, stat=istat, errmsg=errorMessage)
       call check_deallocate_f("elpa2_template: q_dummy", 1547,  istat,  errorMessage)
     endif

     ! restore original OpenMP settings



   nullify(aIntern)
   nullify(evIntern)
   if (present(qExtern)) then
     nullify(qIntern)
   endif

   nullify(ev)
   nullify(a)
   nullify(q)

  nullify(q_actual)

     call obj%timer%stop("elpa_solve_evp_&
     &complex&
     &_2stage_&
     &single&
     &")
1    format(a,f10.3)

   end function

! vim: syntax=fortran



















!>  \brief elpa_solve_evp_complex_2stage_d_ptr_single_impl: Fortran function to solve the single-precision complex eigenvalue problem with a 2 stage approach
!>
!>  Parameters
!>
!>  \param na                                   Order of matrix a
!>
!>  \param nev                                  Number of eigenvalues needed
!>
!>  \param a                                    Distributed matrix for which eigenvalues are to be computed.
!>                                              Distribution is like in Scalapack.
!>                                              The full matrix must be set (not only one half like in scalapack).
!>                                              Destroyed on exit (upper and lower half).
!>
!>  \param lda                                  Leading dimension of a
!>
!>  \param ev                                   On output: eigenvalues of a, every processor gets the complete set
!>
!>  \param q                                    On output: Eigenvectors of a
!>                                              Distribution is like in Scalapack.
!>                                              Must be always dimensioned to the full size (corresponding to (na,na))
!>                                              even if only a part of the eigenvalues is needed.
!>
!>  \param ldq                                  Leading dimension of q
!>
!>  \param nblk                                 blocksize of cyclic distribution, must be the same in both directions!
!>
!>  \param matrixCols                           local columns of matrix a and q
!>
!>  \param mpi_comm_rows                        MPI communicator for rows
!>  \param mpi_comm_cols                        MPI communicator for columns
!>  \param mpi_comm_all                         MPI communicator for the total processor set
!>
!>  \param kernel                               specify ELPA2 kernel to use
!>  \param useGPU (optional)                    decide whether GPUs should be used or not
!>
!>  \result success                             logical, false if error occured
!-------------------------------------------------------------------------------


!cannot use "../src/elpa2/../general/error_checking.inc" because filename with path can be too long for gfortran (max line length)


 function elpa_solve_evp_&
  &complex&
  &_&
  &2stage_d_ptr_&
  &single&
  &_impl (obj, &
   aExtern, &
   evExtern, &
   qExtern) result(success)

   !use matrix_plot
   use elpa_abstract_impl
   use elpa_utilities
   use elpa1_compute
   use elpa2_compute
   use elpa_mpi
   use cuda_functions
   use hip_functions
   use elpa_gpu
   use mod_check_for_gpu
   use elpa_omp
   use solve_tridi
   use thread_affinity
   use, intrinsic :: iso_c_binding
   implicit none
!    Copyright 2011, A. Marek
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
!

  integer, parameter :: rk = C_FLOAT
  integer, parameter :: ck = C_FLOAT_COMPLEX
  integer, parameter :: rck = C_FLOAT_COMPLEX
  complex(kind=rck), parameter     :: ZERO = (0.0_rk,0.0_rk), ONE = (1.0_rk,0.0_rk)
   class(elpa_abstract_impl_t), intent(inout)                         :: obj
   logical                                                            :: useGPU
   logical                                                            :: isSkewsymmetric
   integer(kind=c_int)                                                :: kernel, kernelByUser
   logical                                                            :: userHasSetKernel


!#ifdef REDISTRIBUTE_MATRIX
   type(c_ptr)                                                        :: aExtern
   type(c_ptr), optional                                              :: qExtern
!#else 
!   type(c_ptr)                                                        :: a, q
!#endif 


    complex(kind=rck), pointer                                  :: a(:,:)
    complex(kind=rck), pointer                                  :: q(:,:)
    real(kind=RK4), pointer                                  :: ev(:)

   type(c_ptr)                                                        :: evExtern

   complex(kind=c_float), allocatable                   :: hh_trans(:,:)

   integer(kind=c_int)                                                :: my_pe, n_pes, my_prow, my_pcol, np_rows, np_cols
   integer(kind=MPI_KIND)                                             :: my_peMPI, n_pesMPI, my_prowMPI, my_pcolMPI, &
                                                                         np_rowsMPI, np_colsMPI, mpierr
   integer(kind=c_int)                                                :: nbw, num_blocks
   integer(kind=c_int)                                                :: l_cols_nev, l_rows, l_cols
   complex(kind=c_float), allocatable                   :: tmat(:,:,:)
   real(kind=c_float), allocatable                            :: e(:)
   real(kind=c_float), allocatable                            :: q_real(:,:)
   complex(kind=c_float), allocatable, target           :: q_dummy(:,:)
   complex(kind=c_float), pointer                       :: q_actual(:,:)


   integer(kind=c_int)                                                :: i
   logical                                                            :: success, successGPU
   integer(kind=c_int)                                                :: success_int
   logical                                                            :: wantDebug
   integer(kind=c_int)                                                :: istat, gpu, skewsymmetric, debug, qr
   character(200)                                                     :: errorMessage
   logical                                                            :: do_useGPU, do_useGPU_bandred, &
                                                                         do_useGPU_tridiag_band, do_useGPU_solve_tridi, &
                                                                         do_useGPU_trans_ev_tridi_to_band, &
                                                                         do_useGPU_trans_ev_band_to_full
   integer(kind=c_int)                                                :: numberOfGPUDevices
   integer(kind=c_intptr_t), parameter                                :: size_of_datatype = size_of_&
                                                                                            &single&
                                                                                            &_&
                                                                                            &complex
   integer(kind=c_intptr_t), parameter                                :: size_of_real_datatype = size_of_&
                                                                                                 &single&
                                                                                                 &_real
   integer(kind=ik)                                                   :: na, nev, nblk, matrixCols, &
                                                                         mpi_comm_rows, mpi_comm_cols,        &
                                                                         mpi_comm_all, check_pd, error, matrixRows
   real(kind=c_float)                                         :: thres_pd

   complex(kind=rck), pointer                                   :: aIntern(:,:)
   complex(kind=c_float), pointer                       :: qIntern(:,:)
   real(kind=RK4), pointer                                  :: evIntern(:)

   logical                                                            :: do_bandred, do_tridiag, do_solve_tridi,  &
                                                                         do_trans_to_band, do_trans_to_full
   logical                                                            :: good_nblk_gpu

   integer(kind=ik)                                                   :: nrThreads, limitThreads
   integer(kind=ik)                                                   :: global_index
   logical                                                            :: reDistributeMatrix, doRedistributeMatrix
   integer(kind=ik)                                                   :: pinningInfo

   integer(kind=MPI_KIND)                                             :: bcast_request1, bcast_request2, allreduce_request1, &
                                                                         allreduce_request2, allreduce_request3, &
                                                                         allreduce_request4, allreduce_request5, &
                                                                         allreduce_request6, allreduce_request7, &
                                                                         allreduce_request8
   logical                                                            :: useNonBlockingCollectivesAll
   integer(kind=ik)                                                   :: gpu_old, gpu_new
   integer(kind=ik)                                                   :: non_blocking_collectives_all











    call obj%timer%start("elpa_solve_evp_&
    &complex&
    &_2stage_&
    &single&
    &")

    call obj%get("debug",debug, error)
    if (error .ne. ELPA_OK) then
      write(error_unit,*) "ELPA2: Problem getting option for debug settings. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

    endif

    wantDebug = debug == 1

    ! check legacy GPU setings
    ! check legacy GPU setings
    if (obj%is_set("gpu") == 1) then
      write(error_unit,*) "You still use the deprecated option 'gpu', consider switching to 'nvidia-gpu'"
      call obj%get("gpu", gpu_old, error)     
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "GPU_SOLVER : Problem getting option for gpu. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_evp_&
     &complex&
     &_1stage_&
     &single&
     &")
     success = .false.
     return
      endif
      if (obj%is_set("nvidia-gpu") == 0) then
        ! set gpu and nvidia-gpu consistent
        call obj%set("nvidia-gpu", gpu_old, error)
        if (error .ne. ELPA_OK) then
          write(error_unit,*) "GPU_SOLVER : Problem setting option for nvidia-gpu. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_evp_&
     &complex&
     &_1stage_&
     &single&
     &")
     success = .false.
     return
        endif
        write(error_unit,*) "Will set the new keyword 'nvidia-gpu' now."
        write(error_unit,*) "And ignore the 'gpu' keyword from now on"
      else ! obj%is_set("nvidia-gpu") == 0
        call obj%get("nvidia-gpu", gpu_new, error)
        if (error .ne. ELPA_OK) then
          write(error_unit,*) "GPU_SOLVER : Problem getting option for nvidia-gpu. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_evp_&
     &complex&
     &_1stage_&
     &single&
     &")
     success = .false.
     return
        endif
        if (gpu_old .ne. gpu_new) then
                write(error_unit,*) "Please do not set 'gpu' but 'nvidia-gpu' instead"
          write(error_unit,*) "You cannot set gpu = ",gpu_old," and nvidia-gpu=",gpu_new,". Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_evp_&
     &complex&
     &_1stage_&
     &single&
     &")
     success = .false.
     return
        endif
      endif ! obj%is_set("nvidia-gpu") == 0
      if (obj%is_set("amd-gpu") == 0) then
        ! amd-gpu is not set, but gpu is set
        ! this is ok in anycase
      else ! obj%is_set("amd-gpu") == 0
        call obj%get("amd-gpu", gpu_new, error)
        if (error .ne. ELPA_OK) then
          write(error_unit,*) "GPU_SOLVER : Problem getting option for amd-gpu. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_evp_&
     &complex&
     &_1stage_&
     &single&
     &")
     success = .false.
     return
        endif
        ! this is ok, if gpu == 0 and amd-gpu == 1 or
        !             if gpu == 0 and amd-gpu == 0 or
        !             if gpu == 1 and amd-gpu == 0
        if (gpu_old .eq. 1 .and. gpu_new .eq. 1) then
          write(error_unit,*) "GPU_SOLVER : You cannot set gpu = 1 and amd-gpu = 1. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_evp_&
     &complex&
     &_1stage_&
     &single&
     &")
     success = .false.
     return
        endif
      endif ! amd-gpu
      if (obj%is_set("intel-gpu") == 0) then
        ! intel-gpu is not set, but gpu is set
        ! this is ok in anycase
      else ! obj%is_set("intel-gpu") == 0
        call obj%get("intel-gpu", gpu_new, error)
        if (error .ne. ELPA_OK) then
          write(error_unit,*) "GPU_SOLVER : Problem getting option for intel-gpu. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_evp_&
     &complex&
     &_1stage_&
     &single&
     &")
     success = .false.
     return
        endif
        ! this is ok, if gpu == 0 and intel-gpu == 1 or
        !             if gpu == 0 and intel-gpu == 0 or
        !             if gpu == 1 and intel-gpu == 0
        if (gpu_old .eq. 1 .and. gpu_new .eq. 1) then
          write(error_unit,*) "GPU_SOLVER : You cannot set gpu = 1 and intel-gpu = 1. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_evp_&
     &complex&
     &_1stage_&
     &single&
     &")
     success = .false.
     return
        endif
      endif ! intel-gpu
    else ! gpu not set
      ! nothing to do since the legacy option is not set
    endif ! gpu is set

    ! GPU settings
    if (gpu_vendor() == NVIDIA_GPU) then
      call obj%get("nvidia-gpu", gpu, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "GPU_SOLVER : Problem getting option for NVIDIA GPU. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_evp_&
     &complex&
     &_1stage_&
     &single&
     &")
     success = .false.
     return
      endif
    else if (gpu_vendor() == AMD_GPU) then
      call obj%get("amd-gpu", gpu, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "GPU_SOLVER : Problem getting option for AMD GPU. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_evp_&
     &complex&
     &_1stage_&
     &single&
     &")
     success = .false.
     return
      endif
    else if (gpu_vendor() == INTEL_GPU) then
      call obj%get("intel-gpu", gpu, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "GPU_SOLVER : Problem getting option for INTEL GPU. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_evp_&
     &complex&
     &_1stage_&
     &single&
     &")
     success = .false.
     return
      endif
    else ! no supported gpu
      gpu = 0
    endif

   if (gpu .eq. 1) then
     useGPU =.true.
   else
     write(error_unit,*) "GPU_SOLVER : You used the interface for device pointers but did not specify GPU usage!. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_evp_&
     &complex&
     &_1stage_&
     &single&
     &")
     success = .false.
     return
     useGPU = .false.
   endif


    do_useGPU = .false.

    ! get the kernel and check whether it has been set by the user
    if (obj%is_set("complex_kernel") == 1) then
      userHasSetKernel = .true.
    else
      userHasSetKernel = .false.
    endif

    ! after this point you may _never_ call get for the kernel again, or set the
    ! kernel !! The reason is that we might have to adjust the kernel, which is
    ! passed as a variable
    call obj%get("complex_kernel", kernel, error)
    if (error .ne. ELPA_OK) then
      write(error_unit,*) "ELPA2: Problem getting option for kernel settings. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

    endif

    ! to implement a possibiltiy to set this
    useNonBlockingCollectivesAll = .false.

    call obj%get("mpi_comm_rows",mpi_comm_rows, error)
    if (error .ne. ELPA_OK) then
      write(error_unit,*) "ELPA2: Problem getting option for mpi_comm_rows. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

    endif
    call obj%get("mpi_comm_cols",mpi_comm_cols,error)
    if (error .ne. ELPA_OK) then
      write(error_unit,*) "ELPA2: Problem getting option for mpi_comm_cols. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

    endif
    call obj%get("mpi_comm_parent",mpi_comm_all,error)
    if (error .ne. ELPA_OK) then
      write(error_unit,*) "ELPA2: Problem getting option for mpi_comm_parent. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

    endif

    call obj%timer%start("mpi_communication")
    call mpi_comm_rank(int(mpi_comm_all,kind=MPI_KIND) ,my_peMPI ,mpierr)
    call mpi_comm_size(int(mpi_comm_all,kind=MPI_KIND) ,n_pesMPI ,mpierr)

    call mpi_comm_rank(int(mpi_comm_rows,kind=MPI_KIND) ,my_prowMPI ,mpierr)
    call mpi_comm_size(int(mpi_comm_rows,kind=MPI_KIND) ,np_rowsMPI ,mpierr)
    call mpi_comm_rank(int(mpi_comm_cols,kind=MPI_KIND) ,my_pcolMPI ,mpierr)
    call mpi_comm_size(int(mpi_comm_cols,kind=MPI_KIND) ,np_colsMPI ,mpierr)

    my_pe = int(my_peMPI, kind=c_int)
    n_pes = int(n_pesMPI, kind=c_int)
    my_prow = int(my_prowMPI, kind=c_int)
    np_rows = int(np_rowsMPI, kind=c_int)
    my_pcol = int(my_pcolMPI, kind=c_int)
    np_cols = int(np_colsMPI, kind=c_int)

    call obj%timer%stop("mpi_communication")

    na         = obj%na
    nev        = obj%nev
    nblk       = obj%nblk
    matrixCols = obj%local_ncols
    matrixRows = obj%local_nrows

    call obj%get("nbc_all_elpa2_main", non_blocking_collectives_all, error)
    if (error .ne. ELPA_OK) then
      write(error_unit,*) "ELPA2: Problem getting option for non blocking collectives. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

    endif

    if (non_blocking_collectives_all .eq. 1) then
      useNonBlockingCollectivesAll = .true.
    else
      useNonBlockingCollectivesAll = .false.
    endif

    ! openmp setting
    nrThreads = 1


    if (useGPU) then
      call obj%timer%start("check_for_gpu")
      if (check_for_gpu(obj, my_pe, numberOfGPUDevices, wantDebug=wantDebug)) then
        do_useGPU = .true.
        ! set the neccessary parameters
        call set_gpu_parameters()

      else
        write(error_unit,*) "ELPA2: GPUs are requested but not detected! Aborting..."
        call obj%timer%stop("check_for_gpu")
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

      endif
      call obj%timer%stop("check_for_gpu")

      if (nblk*(max(np_rows,np_cols)-1) >= na) then
        if (my_pe .eq. 0) then
          write(error_unit,*) "ELPA: Warning, block size too large for this matrix size and process grid!"
          write(error_unit,*) "Choose a smaller block size if possible.",nblk*(max(np_rows,np_cols)-1),na
          write(error_unit,*) "Disabling GPU usage! "
        endif

        do_useGPU = .false.
        if (kernel .eq. ELPA_2STAGE_COMPLEX_NVIDIA_GPU) then
          if (userHasSetKernel) then
            ! user fixed inconsistent input.
            ! sadly, we do have to abort
            if (my_pe .eq. 0) then
              write(error_unit,*) "You set (fixed) the kernel to GPU, but GPUs cannot be used."
              write(error_unit,*) "Either adapt the block size or the process grid, or do not set the GPU kernel! Aborting..."
            endif
            stop 1
          else
            ! here we should set the default kernel
            kernel = ELPA_2STAGE_COMPLEX_DEFAULT
          endif
        endif
      endif

    endif ! useGPU




    do_useGPU_bandred = do_useGPU
    do_useGPU_tridiag_band = .false.  ! not yet ported
    do_useGPU_solve_tridi = do_useGPU
    do_useGPU_trans_ev_tridi_to_band = do_useGPU
    do_useGPU_trans_ev_band_to_full = do_useGPU


   reDistributeMatrix = .false.


   allocate(aIntern(1:matrixRows,1:matrixCols))
   a       => aIntern(1:matrixRows,1:matrixCols)

   allocate(evIntern(1:obj%na))
   ev      => evIntern(1:obj%na)

   if (present(qExtern)) then
     allocate(qIntern(1:matrixRows,1:matrixCols))
   endif
   !TODO: intel gpu
   ! in case of devcice pointer _AND_ redistribute
   ! 1. copy aExtern to aIntern_dummy
   ! 2. redistribute aIntern_dummy to aIntern


   successGPU = gpu_memcpy(c_loc(aIntern(1,1)), aExtern, matrixRows*matrixCols*size_of_datatype, &
                             gpuMemcpyDeviceToHost)
   call check_memcpy_GPU_f("elpa2: aExtern -> aIntern", 548,  successGPU)


     a       => aIntern(1:matrixRows,1:matrixCols)
     if (present(qExtern)) then
       q       => qIntern(1:matrixRows,1:matrixCols)
     endif

   ev      => evIntern(1:obj%na)

   call obj%get("output_pinning_information", pinningInfo, error)
   if (error .ne. ELPA_OK) then
     write(error_unit,*) "ELPA2: Problem setting option for debug. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

   endif

   if (pinningInfo .eq. 1) then
     call init_thread_affinity(nrThreads)

     call check_thread_affinity()
     if (my_pe .eq. 0) call print_thread_affinity(my_pe)
     call cleanup_thread_affinity()
   endif

    success = .true.

    if (present(qExtern)) then
      obj%eigenvalues_only = .false.
    else
      obj%eigenvalues_only = .true.
    endif

   ! special case na = 1
   if (na .eq. 1) then
     ev(1) = real(a(1,1))
     if (.not.(obj%eigenvalues_only)) then
       q(1,1) = ONE
     endif

     ! restore original OpenMP settings

     call obj%timer%stop("elpa_solve_evp_&
     &complex&
     &_2stage_&
     &single&
     &")
     success = .true.
     return
   endif

   if (nev == 0) then
     nev = 1
     obj%eigenvalues_only = .true.
   endif

    !call obj%get("complex_kernel", kernel, error)
    !if (error .ne. ELPA_OK) then
    !  print *,"Problem getting option for kernel settings. Aborting..."
    !  stop 1
    !endif

    isSkewsymmetric = .false.

    ! only if we want (and can) use GPU in general, look what are the
    ! requirements for individual routines. Implicitly they are all set to 1, so
    ! unless specified otherwise by the user, GPU versions of all individual
    ! routines should be used
    if (do_useGPU) then
      call obj%get("gpu_bandred", gpu, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "ELPA2: Problem getting option gpu_bandred settings. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

      endif
      do_useGPU_bandred = (gpu == 1)

      ! not yet ported
      !call obj%get("gpu_tridiag_band", gpu, error)
      !if (error .ne. ELPA_OK) then
      !  print *,"Problem getting option for gpu_tridiag_band settings. Aborting..."
      !  stop 1
      !endif
      !do_useGPU_tridiag_band = (gpu == 1)

      call obj%get("gpu_solve_tridi", gpu, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "ELPA2: Problem getting option for gpu_solve_tridi settings. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

      endif
      do_useGPU_solve_tridi = (gpu == 1)

      call obj%get("gpu_trans_ev_tridi_to_band", gpu, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "ELPA2: Problem getting option for gpu_trans_ev_tridi_to_band settings. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

      endif
      do_useGPU_trans_ev_tridi_to_band = (gpu == 1)

      call obj%get("gpu_trans_ev_band_to_full", gpu, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "ELPA2: Problem getting option for gpu_trans_ev_band_to_full settings. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

      endif
      do_useGPU_trans_ev_band_to_full = (gpu == 1)
    endif

    ! check consistency between request for GPUs and defined kernel
    if (do_useGPU_trans_ev_tridi_to_band) then
      ! if the user has set explicitely a kernel before than honour this
      ! otherwise set GPU kernel
      if (userHasSetKernel) then
        if (kernel .ne. ELPA_2STAGE_COMPLEX_NVIDIA_GPU) then
          write(error_unit,*) "ELPA: Warning, GPU usage has been requested but compute kernel is set by the user as non-GPU!"
          write(error_unit,*) "The compute kernel will be executed on CPUs!"
          do_useGPU_trans_ev_tridi_to_band = .false.
          kernel = ELPA_2STAGE_COMPLEX_DEFAULT
        else
          good_nblk_gpu = .false.
        endif
      else ! userHasSetKernel
        !call obj%set("complex_kernel", ELPA_2STAGE_COMPLEX_NVIDIA_GPU, error)
        !if (error .ne. ELPA_OK) then
        !  write(error_unit,*) "Cannot set kernel to GPU kernel"
        !  stop 1
        !endif

        if (my_pe .eq. 0) write(error_unit,*) "You requested the GPU version, thus the GPU kernel is activated"
        good_nblk_gpu = .false.

        kernel = ELPA_2STAGE_COMPLEX_NVIDIA_GPU
      endif ! userHasSetKernel

      ! Accepted values are 2,4,8,16,...,512
      do i = 1,10
        if (nblk == 2**i) then
          good_nblk_gpu = .true.
          exit
        endif
      enddo

      if (.not. good_nblk_gpu .and. do_useGPU_trans_ev_tridi_to_band) then
         write(error_unit,*) "ELPA: Warning, GPU kernel only works with block size 2^n (n = 1, 2, ..., 10)!"
         write(error_unit,*) "The compute kernel will be executed on CPUs!"
         write(error_unit,*) "We recommend changing the block size to 2^n"
         do_useGPU_trans_ev_tridi_to_band = .false.
         ! should be set
         kernel = ELPA_2STAGE_COMPLEX_DEFAULT
      endif
    endif





    ! check again, now kernel and do_useGPU_trans_ev_tridi_to_band should be
    ! finally consistent
    if (do_useGPU_trans_ev_tridi_to_band) then
      !call obj%get("complex_kernel", kernel, error)
      !if (error .ne. ELPA_OK) then
      !  write(error_unit,*) "Cannot get kernel to GPU kernel"
      !  stop 1
      !endif
      if (kernel .ne. ELPA_2STAGE_COMPLEX_NVIDIA_GPU) then
        ! this should never happen, checking as an assert
        write(error_unit,*) "ELPA: INTERNAL ERROR setting GPU kernel!  Aborting..."
        stop 1
      endif
    else ! do not use GPU
      if (kernel .eq. ELPA_2STAGE_COMPLEX_NVIDIA_GPU) then
        ! combination not allowed
        write(error_unit,*) "ELPA: Warning, GPU usage has NOT been requested but compute kernel &
                            &is defined as the GPU kernel!  Setting default kernel"
        kernel = ELPA_2STAGE_COMPLEX_DEFAULT
        !TODO do error handling properly
      endif
    endif


     !! consistency check: is user set kernel still identical with "kernel" or did
     !! we change it above? This is a mess and should be cleaned up
     !call obj%get("complex_kernel",kernelByUser,error)
     !if (error .ne. ELPA_OK) then
     !  print *,"Problem getting option for user kernel settings. Aborting..."
     !  stop 1
     !endif

     !if (kernelByUser .ne. kernel) then
     !  call obj%set("complex_kernel", kernel, error)
     !  if (error .ne. ELPA_OK) then
     !    print *,"Problem setting kernel. Aborting..."
     !    stop 1
     !  endif
     !endif




    if (.not. obj%eigenvalues_only) then
      q_actual => q(1:matrixRows,1:matrixCols)
    else
     allocate(q_dummy(1:matrixRows,1:matrixCols), stat=istat, errmsg=errorMessage)
     call check_allocate_f("elpa2_template: q_dummy", 998,  istat,  errorMessage)
     q_actual => q_dummy(1:matrixRows,1:matrixCols)
    endif

    ! set the default values for each of the 5 compute steps
    do_bandred        = .true.
    do_tridiag        = .true.
    do_solve_tridi    = .true.
    do_trans_to_band  = .true.
    do_trans_to_full  = .true.

    if (obj%eigenvalues_only) then
      do_trans_to_band  = .false.
      do_trans_to_full  = .false.
    endif

    if (obj%is_set("bandwidth") == 1) then
      ! bandwidth is set. That means, that the inputed matrix is actually banded and thus the
      ! first step of ELPA2 should be skipped
      call obj%get("bandwidth",nbw,error)
      if (nbw == 0) then
        if (wantDebug) then
          write(error_unit,*) "Specified bandwidth = 0; ELPA refuses to solve the eigenvalue problem ", &
                              "for a diagonal matrix! This is too simple"
          endif
          write(error_unit,*) "Specified bandwidth = 0; ELPA refuses to solve the eigenvalue problem ", &
                 "for a diagonal matrix! This is too simple"
        success = .false.
        return
      endif
      if (mod(nbw, nblk) .ne. 0) then
        ! treat matrix with an effective bandwidth slightly bigger than specified bandwidth
        ! such that effective bandwidth is a multiply of nblk. which is a prerequiste for ELPA
        nbw = nblk * ceiling(real(nbw,kind=c_double)/real(nblk,kind=c_double))

        ! just check that effective bandwidth is NOT larger than matrix size
        if (nbw .gt. na) then
          if (wantDebug) then
            write(error_unit,*) "Specified bandwidth ",nbw," leads internaly to a computed bandwidth ", &
                                "which is larger than the matrix size ",na," ! ELPA will abort! Try to", &
                                "solve your problem by not specifing a bandwidth"
          endif
          print *, "Specified bandwidth ",nbw," leads internaly to a computed bandwidth ", &
                                "which is larger than the matrix size ",na," ! ELPA will abort! Try to", &
                                "solve your problem by not specifing a bandwidth"
          success = .false.
          return
        endif
      endif
      do_bandred       = .false. ! we already have a banded matrix
      do_solve_tridi   = .true.  ! we also have to solve something :-)
      do_trans_to_band = .true.  ! and still we have to backsub to banded
      do_trans_to_full = .false. ! but not to full since we have a banded matrix
    else ! matrix is not banded, determine the intermediate bandwidth for full->banded->tridi
      !first check if the intermediate bandwidth was set by the user
      call obj%get("intermediate_bandwidth", nbw, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "Problem getting option for intermediate_bandwidth. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

      endif

      if(nbw == 0) then
        ! intermediate bandwidth was not specified, select one of the defaults

        ! Choose bandwidth, must be a multiple of nblk, set to a value >= 32
        ! On older systems (IBM Bluegene/P, Intel Nehalem) a value of 32 was optimal.
        ! For Intel(R) Xeon(R) E5 v2 and v3, better use 64 instead of 32!
        ! For IBM Bluegene/Q this is not clear at the moment. We have to keep an eye
        ! on this and maybe allow a run-time optimization here
        nbw = (31/nblk+1)*nblk
      else
        ! intermediate bandwidth has been specified by the user, check, whether correctly
        if (mod(nbw, nblk) .ne. 0) then
          print *, "Specified bandwidth ",nbw," has to be mutiple of the blocksize ", nblk, ". Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

        endif
      endif !nbw == 0

      num_blocks = (na-1)/nbw + 1

      ! tmat is needed only in full->band and band->full steps, so alocate here
      ! (not allocated for banded matrix on input)
      allocate(tmat(nbw,nbw,num_blocks), stat=istat, errmsg=errorMessage)
      call check_allocate_f("elpa2_template: tmat", 1085,  istat,  errorMessage)

      do_bandred       = .true.
      do_solve_tridi   = .true.
      do_trans_to_band = .true.
      do_trans_to_full = .true.
    endif  ! matrix not already banded on input

    ! start the computations in 5 steps
    if (do_bandred) then
      call obj%autotune_timer%start("full_to_band")
      call obj%timer%start("full_to_band")
      ! Reduction full -> band
      call bandred_&
      &complex&
      &_&
      &single &
      (obj, na, a, &
      matrixRows, nblk, nbw, matrixCols, num_blocks, mpi_comm_rows, mpi_comm_cols, tmat, &
      wantDebug, do_useGPU_bandred, success, &
       nrThreads, isSkewsymmetric)

      call obj%timer%stop("full_to_band")
      call obj%autotune_timer%stop("full_to_band")
  
      if (success) then
        success_int = 0
      else
        success_int = 1
      endif

      if (useNonBlockingCollectivesAll) then
        call mpi_iallreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), &
        allreduce_request2, mpierr)
        call mpi_wait(allreduce_request2, MPI_STATUS_IGNORE, mpierr)
      else
        call mpi_allreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), mpierr)
      endif
      if (success_int .eq. 1) then
        write(error_unit,*) "ELPA2: bandred returned an error. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

      endif
    endif

     ! Reduction band -> tridiagonal
     if (do_tridiag) then
       allocate(e(na), stat=istat, errmsg=errorMessage)
       call check_allocate_f("elpa2_template: e", 1143,  istat,  errorMessage)

       call obj%autotune_timer%start("band_to_tridi")
       call obj%timer%start("band_to_tridi")
       call tridiag_band_&
       &complex&
       &_&
       &single&
       (obj, na, nbw, nblk, a, matrixRows, ev, e, matrixCols, hh_trans, mpi_comm_rows, mpi_comm_cols, mpi_comm_all, &
       do_useGPU_tridiag_band, wantDebug, nrThreads, isSkewsymmetric, success)
  
       if (success) then
         success_int = 0
       else
         success_int = 1
       endif

       if (useNonBlockingCollectivesAll) then
         call mpi_iallreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), &
         allreduce_request3, mpierr)
         call mpi_wait(allreduce_request3, MPI_STATUS_IGNORE, mpierr)
       else
         call mpi_allreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), mpierr)
       endif
       if (success_int .eq. 1) then
         write(error_unit,*) "Error in tridiag_band. Aborting..."
         return
       endif

       call obj%timer%start("mpi_communication")
       if (useNonBlockingCollectivesAll) then
         call mpi_ibcast(ev, int(na,kind=MPI_KIND), MPI_REAL4, 0_MPI_KIND, int(mpi_comm_all,kind=MPI_KIND), bcast_request1, mpierr)
         call mpi_ibcast(e, int(na,kind=MPI_KIND), MPI_REAL4, 0_MPI_KIND, int(mpi_comm_all,kind=MPI_KIND), bcast_request2, mpierr)

         call mpi_wait(bcast_request1, MPI_STATUS_IGNORE, mpierr)
         call mpi_wait(bcast_request2, MPI_STATUS_IGNORE, mpierr)
       else
         call mpi_bcast(ev, int(na,kind=MPI_KIND), MPI_REAL4, 0_MPI_KIND, int(mpi_comm_all,kind=MPI_KIND), mpierr)
         call mpi_bcast(e, int(na,kind=MPI_KIND), MPI_REAL4, 0_MPI_KIND, int(mpi_comm_all,kind=MPI_KIND), mpierr)
       endif
       call obj%timer%stop("mpi_communication")

       call obj%timer%stop("band_to_tridi")
       call obj%autotune_timer%stop("band_to_tridi")
     endif ! do_tridiag

     l_rows = local_index(na, my_prow, np_rows, nblk, -1) ! Local rows of a and q
     l_cols = local_index(na, my_pcol, np_cols, nblk, -1) ! Local columns of q
     l_cols_nev = local_index(nev, my_pcol, np_cols, nblk, -1) ! Local columns corresponding to nev

     allocate(q_real(l_rows,l_cols), stat=istat, errmsg=errorMessage)
     call check_allocate_f("elpa2_template: q_real", 1205,  istat,  errorMessage)

     ! Solve tridiagonal system
     if (do_solve_tridi) then
       call obj%autotune_timer%start("solve")
       call obj%timer%start("solve")

       call solve_tridi_&
       &single &
       (obj, na, nev, ev, e, &
       q_real, ubound(q_real,dim=1), &
       nblk, matrixCols, mpi_comm_all, mpi_comm_rows, mpi_comm_cols, do_useGPU_solve_tridi, wantDebug, &
               success, nrThreads)

       call obj%timer%stop("solve")
       call obj%autotune_timer%stop("solve")
  
       if (success) then
         success_int = 0
       else
         success_int = 1
       endif

       if (useNonBlockingCollectivesAll) then
         call mpi_iallreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), &
         allreduce_request4, mpierr)
         call mpi_wait(allreduce_request4, MPI_STATUS_IGNORE, mpierr)
       else
         call mpi_allreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), mpierr)
       endif

       if (success_int .eq. 1) then
         write(error_unit,*) "ELPA2: solve returned an error: Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

       endif
     endif ! do_solve_tridi

     deallocate(e, stat=istat, errmsg=errorMessage)
     call check_deallocate_f("elpa2_template: e", 1257,  istat,  errorMessage)

     if (obj%eigenvalues_only) then
       do_trans_to_band = .false.
       do_trans_to_full = .false.
     else
       call obj%get("check_pd",check_pd,error)
       if (error .ne. ELPA_OK) then
         write(error_unit,*) "Problem getting option for check_pd. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

       endif
       if (check_pd .eq. 1) then
         call obj%get("thres_pd_&
         &single&
         &",thres_pd,error)
         if (error .ne. ELPA_OK) then
            write(error_unit,*) "Problem getting option for thres_pd_&
            &single&
            &. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_evp_&
      &complex&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

         endif

         check_pd = 0
         do i = 1, na
           if (ev(i) .gt. thres_pd) then
             check_pd = check_pd + 1
           endif
         enddo
         if (check_pd .lt. na) then
           ! not positiv definite => eigenvectors needed
           do_trans_to_band = .true.
           do_trans_to_full = .true.
         else
           do_trans_to_band = .false.
           do_trans_to_full = .false.
         endif
       endif
     endif ! eigenvalues only

     if (do_trans_to_band) then
       ! q must be given thats why from here on we can use q and not q_actual
       q(1:l_rows,1:l_cols_nev) = q_real(1:l_rows,1:l_cols_nev)
     endif

     ! make sure q_real is deallocated when using check_pd
     if (allocated(q_real)) then
       deallocate(q_real, stat=istat, errmsg=errorMessage)
       call check_deallocate_f("elpa2_template: q_real", 1305,  istat,  errorMessage)
     endif

       if (isSkewsymmetric) then
       ! Extra transformation step for skew-symmetric matrix. Multiplication with diagonal complex matrix D.
       ! This makes the eigenvectors complex.
       ! For now real part of eigenvectors is generated in first half of q, imaginary part in second part.
         q(1:matrixRows, matrixCols+1:2*matrixCols) = 0.0
         do i = 1, matrixRows
!          global_index = indxl2g(i, nblk, my_prow, 0, np_rows)
           global_index = np_rows*nblk*((i-1)/nblk) + MOD(i-1,nblk) + MOD(np_rows+my_prow-0, np_rows)*nblk + 1
           if (mod(global_index-1,4) .eq. 0) then
              ! do nothing
           end if
           if (mod(global_index-1,4) .eq. 1) then
              q(i,matrixCols+1:2*matrixCols) = q(i,1:matrixCols)
              q(i,1:matrixCols) = 0
           end if
           if (mod(global_index-1,4) .eq. 2) then
              q(i,1:matrixCols) = -q(i,1:matrixCols)
           end if
           if (mod(global_index-1,4) .eq. 3) then
              q(i,matrixCols+1:2*matrixCols) = -q(i,1:matrixCols)
              q(i,1:matrixCols) = 0
           end if
         end do
       endif

       ! Backtransform stage 1
     if (do_trans_to_band) then

       !debug
!#if defined(WITH_OPENMP_OFFLOAD_GPU_VERSION) || defined(WITH_SYCL_GPU_VERSION)
       !if (gpu_vendor() == OPENMP_OFFLOAD_GPU .or. gpu_vendor() == SYCL_GPU) then
       call obj%autotune_timer%start("tridi_to_band")
       call obj%timer%start("tridi_to_band")
       ! In the skew-symmetric case this transforms the real part
       call trans_ev_tridi_to_band_&
       &complex&
       &_&
       &single &
       (obj, na, nev, nblk, nbw, q, &
       matrixRows, matrixCols, hh_trans, my_pe, mpi_comm_rows, mpi_comm_cols, &
       wantDebug, do_useGPU_trans_ev_tridi_to_band, &
       nrThreads, success=success, kernel=kernel)
       call obj%timer%stop("tridi_to_band")
       call obj%autotune_timer%stop("tridi_to_band")

       if (success) then
         success_int = 0
       else
         success_int = 1
       endif

       if (useNonBlockingCollectivesAll) then
         call mpi_iallreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), &
         allreduce_request5, mpierr)
         call mpi_wait(allreduce_request5, MPI_STATUS_IGNORE, mpierr)
       else
         call mpi_allreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), mpierr)
       endif

       if (success_int .eq. 1) then
         write(error_unit,*) "ELPA2: trans_ev_tridi_to_band returned an error. Aborting..."
         return
       endif

     endif ! do_trans_to_band

     ! the array q (currently) always resides on host even when using GPU

     if (do_trans_to_full) then
       call obj%autotune_timer%start("band_to_full")
       call obj%timer%start("band_to_full")
       ! Backtransform stage 2
       ! In the skew-symemtric case this transforms the real part
       call trans_ev_band_to_full_&
       &complex&
       &_&
       &single &
       (obj, na, nev, nblk, nbw, a, &
       matrixRows, tmat, q,  &
       matrixRows, matrixCols, num_blocks, mpi_comm_rows, mpi_comm_cols, do_useGPU_trans_ev_band_to_full &
       , success)
       call obj%timer%stop("band_to_full")
       call obj%autotune_timer%stop("band_to_full")

       if (success) then
         success_int = 0
       else
         success_int = 1
       endif

       if (useNonBlockingCollectivesAll) then
         call mpi_iallreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), &
         allreduce_request6, mpierr)
         call mpi_wait(allreduce_request6, MPI_STATUS_IGNORE, mpierr)
       else
         call mpi_allreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), mpierr)
       endif
       if (success_int .eq. 1) then
         write(error_unit,*) "Error in trans_ev_band_to_full. Aborting..."
         return
       endif
     endif ! do_trans_to_full
! #ifdef DOUBLE_PRECISION_REAL
!        call prmat(na,useGPU,q(1:matrixRows, 1:matrixCols),q_dev,matrixRows,matrixCols,nblk,my_prow,my_pcol,np_rows,np_cols,'R',1)
! #endif


     !skew symmetric imaginary part for tridi_to_band and band_to_full
     if (isSkewsymmetric) then
       if (do_trans_to_band) then
         call obj%autotune_timer%start("tridi_to_band")
         call obj%timer%start("skew_tridi_to_band")
         ! Transform imaginary part
         ! Transformation of real and imaginary part could also be one call of trans_ev_tridi acting on the n x 2n matrix.
         call trans_ev_tridi_to_band_&
         &complex&
         &_&
         &single &
         (obj, na, nev, nblk, nbw, q(1:matrixRows, matrixCols+1:2*matrixCols), &
         matrixRows, matrixCols, hh_trans, my_pe, mpi_comm_rows, mpi_comm_cols, &
         wantDebug, do_useGPU_trans_ev_tridi_to_band, &
         nrThreads, success=success, kernel=kernel)

         call obj%timer%stop("skew_tridi_to_band")
         call obj%autotune_timer%stop("tridi_to_band")

         if (success) then
           success_int = 0
         else
           success_int = 1
         endif

         if (useNonBlockingCollectivesAll) then
           call mpi_iallreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), &
           allreduce_request7, mpierr)
           call mpi_wait(allreduce_request7, MPI_STATUS_IGNORE, mpierr)
         else
           call mpi_allreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), mpierr)
         endif
         if (success_int .eq. 1) then
          write(error_unit,*) "Error in trans_ev_tridi_to_band (imaginary part). Aborting..."
          return
         endif
       endif ! do_trans_tridi_to_band

       if (do_trans_to_full) then
       call obj%autotune_timer%start("band_to_full")
       call obj%timer%start("band_to_full")
         ! Transform imaginary part
         ! Transformation of real and imaginary part could also be one call of trans_ev_band_to_full_ acting on the n x 2n matrix.
         call trans_ev_band_to_full_&
         &complex&
         &_&
         &single &
         (obj, na, nev, nblk, nbw, a, &
         matrixRows, tmat, q(1:matrixRows, matrixCols+1:2*matrixCols),  &
         matrixRows, matrixCols, num_blocks, mpi_comm_rows, mpi_comm_cols, do_useGPU_trans_ev_band_to_full, &
         success)

         call obj%timer%stop("band_to_full")
         call obj%autotune_timer%stop("band_to_full")

         if (success) then
           success_int = 0
         else
           success_int = 1
         endif

         if (useNonBlockingCollectivesAll) then
           call mpi_iallreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), &
           allreduce_request8, mpierr)
           call mpi_wait(allreduce_request8, MPI_STATUS_IGNORE, mpierr)
         else
           call mpi_allreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), mpierr)
         endif
         if (success_int .eq. 1) then
          write(error_unit,*) "Error in trans_ev_band_to_full (imaginary part). Aborting..."
          return
         endif
       endif ! do_trans_to_full
     endif ! isSkewSymmetric


     ! We can now deallocate the stored householder vectors
     deallocate(hh_trans, stat=istat, errmsg=errorMessage)
     call check_deallocate_f("elpa2_template: hh_trans", 1537,  istat,  errorMessage)

     ! make sure tmat is deallocated when using check_pd
     if (allocated(tmat)) then
       deallocate(tmat, stat=istat, errmsg=errorMessage)
       call check_deallocate_f("elpa2_template: tmat", 1542,  istat,  errorMessage)
     endif

     if (obj%eigenvalues_only) then
       deallocate(q_dummy, stat=istat, errmsg=errorMessage)
       call check_deallocate_f("elpa2_template: q_dummy", 1547,  istat,  errorMessage)
     endif

     ! restore original OpenMP settings



   !copy qIntern and ev to provided device pointers
   if (present(qExtern)) then
   successGPU = gpu_memcpy(qExtern, c_loc(qIntern(1,1)), obj%local_nrows*obj%local_ncols*size_of_datatype, &
                             gpuMemcpyHostToDevice)
   endif
   call check_memcpy_GPU_f("elpa1: qIntern -> qExtern", 1607,  successGPU)
   successGPU = gpu_memcpy(evExtern, c_loc(ev(1)), obj%na*size_of_real_datatype, &
                             gpuMemcpyHostToDevice)
   call check_memcpy_GPU_f("elpa1: ev -> evExtern", 1610,  successGPU)


     deallocate(aIntern)
     !deallocate(evIntern)
     nullify(evIntern)
     if (present(qExtern)) then
       deallocate(qIntern)
     endif



   nullify(ev)
   nullify(a)
   nullify(q)

  nullify(q_actual)

     call obj%timer%stop("elpa_solve_evp_&
     &complex&
     &_2stage_&
     &single&
     &")
1    format(a,f10.3)

   end function

! vim: syntax=fortran


















!-------------------------------------------------------------------------------
!>  \brief elpa_solve_skew_evp_real_2stage_host_arrays_double_impl: Fortran function to solve the double-precision real skew-symmetric eigenvalue problem with a 2 stage approach
!>
!>  Parameters
!>
!>  \param na                                   Order of matrix a
!>
!>  \param nev                                  Number of eigenvalues needed
!>
!>  \param a(lda,matrixCols)                    Distributed matrix for which eigenvalues are to be computed.
!>                                              Distribution is like in Scalapack.
!>                                              The full matrix must be set (not only one half like in scalapack).
!>                                              Destroyed on exit (upper and lower half).
!>
!>  \param lda                                  Leading dimension of a
!>
!>  \param ev(na)                               On output: eigenvalues of a, every processor gets the complete set
!>
!>  \param q(ldq,matrixCols)                    On output: Eigenvectors of a
!>                                              Distribution is like in Scalapack.
!>                                              Must be always dimensioned to the full size (corresponding to (na,na))
!>                                              even if only a part of the eigenvalues is needed.
!>
!>  \param ldq                                  Leading dimension of q
!>
!>  \param nblk                                 blocksize of cyclic distribution, must be the same in both directions!
!>
!>  \param matrixCols                           local columns of matrix a and q
!>
!>  \param mpi_comm_rows                        MPI communicator for rows
!>  \param mpi_comm_cols                        MPI communicator for columns
!>  \param mpi_comm_all                         MPI communicator for the total processor set
!>
!>  \param kernel                               specify ELPA2 kernel to use
!>
!>  \param useQR (optional)                     use QR decomposition
!>  \param useGPU (optional)                    decide whether to use GPUs or not
!>
!>  \result success                             logical, false if error occured
!-------------------------------------------------------------------------------


!cannot use "../src/elpa2/../general/error_checking.inc" because filename with path can be too long for gfortran (max line length)


 function elpa_solve_skew_evp_&
  &real&
  &_&
  &2stage_a_h_a_&
  &double&
  &_impl (obj, &
   aExtern, &
   evExtern, &
   qExtern) result(success)

   !use matrix_plot
   use elpa_abstract_impl
   use elpa_utilities
   use elpa1_compute
   use elpa2_compute
   use elpa_mpi
   use cuda_functions
   use hip_functions
   use elpa_gpu
   use mod_check_for_gpu
   use elpa_omp
   use solve_tridi
   use thread_affinity
   use, intrinsic :: iso_c_binding
   implicit none
!    Copyright 2011, A. Marek
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
!
  integer, parameter :: rk = C_DOUBLE
  integer, parameter :: rck = C_DOUBLE
  real(kind=rck), parameter      :: ZERO=0.0_rk, ONE = 1.0_rk

   class(elpa_abstract_impl_t), intent(inout)                         :: obj
   logical                                                            :: useGPU
   logical                                                            :: isSkewsymmetric
   logical                                                            :: useQR
   logical                                                            :: useQRActual
   integer(kind=c_int)                                                :: kernel, kernelByUser
   logical                                                            :: userHasSetKernel

   
!#ifdef REDISTRIBUTE_MATRIX

   real(kind=c_double), intent(inout), target         :: aExtern(obj%local_nrows,*)
   real(kind=c_double), optional, intent(out), target :: qExtern(obj%local_nrows,*)

!#else 
!
!#ifdef 1
!   real(kind=c_double), intent(inout)                 :: a(obj%local_nrows,*)
!   real(kind=c_double), optional, intent(out), target :: q(obj%local_nrows,*)
!#else
!   real(kind=c_double), intent(inout)                 :: a(obj%local_nrows,obj%local_ncols)
!#ifdef 
!   real(kind=c_double), optional, target, intent(out) :: q(obj%local_nrows,2*obj%local_ncols)
!#else
!   real(kind=c_double), optional, target, intent(out) :: q(obj%local_nrows,obj%local_ncols)
!#endif
!#endif
!
!#endif 


    real(kind=rck), pointer                                  :: a(:,:)
    real(kind=rck), pointer                                  :: q(:,:)
    real(kind=rk8), pointer                                  :: ev(:)

   real(kind=c_double), target, intent(inout)                  :: evExtern(obj%na)

   real(kind=c_double), allocatable                   :: hh_trans(:,:)

   integer(kind=c_int)                                                :: my_pe, n_pes, my_prow, my_pcol, np_rows, np_cols
   integer(kind=MPI_KIND)                                             :: my_peMPI, n_pesMPI, my_prowMPI, my_pcolMPI, &
                                                                         np_rowsMPI, np_colsMPI, mpierr
   integer(kind=c_int)                                                :: nbw, num_blocks
   real(kind=c_double), allocatable                   :: tmat(:,:,:)
   real(kind=c_double), allocatable                            :: e(:)
   real(kind=c_double), allocatable, target           :: q_dummy(:,:)
   real(kind=c_double), pointer                       :: q_actual(:,:)


   integer(kind=c_int)                                                :: i
   logical                                                            :: success, successGPU
   integer(kind=c_int)                                                :: success_int
   logical                                                            :: wantDebug
   integer(kind=c_int)                                                :: istat, gpu, skewsymmetric, debug, qr
   character(200)                                                     :: errorMessage
   logical                                                            :: do_useGPU, do_useGPU_bandred, &
                                                                         do_useGPU_tridiag_band, do_useGPU_solve_tridi, &
                                                                         do_useGPU_trans_ev_tridi_to_band, &
                                                                         do_useGPU_trans_ev_band_to_full
   integer(kind=c_int)                                                :: numberOfGPUDevices
   integer(kind=c_intptr_t), parameter                                :: size_of_datatype = size_of_&
                                                                                            &double&
                                                                                            &_&
                                                                                            &real
   integer(kind=c_intptr_t), parameter                                :: size_of_real_datatype = size_of_&
                                                                                                 &double&
                                                                                                 &_real
   integer(kind=ik)                                                   :: na, nev, nblk, matrixCols, &
                                                                         mpi_comm_rows, mpi_comm_cols,        &
                                                                         mpi_comm_all, check_pd, error, matrixRows
   real(kind=c_double)                                         :: thres_pd

   real(kind=rck), pointer                                   :: aIntern(:,:)
   real(kind=c_double), pointer                       :: qIntern(:,:)
   real(kind=rk8), pointer                                  :: evIntern(:)

   logical                                                            :: do_bandred, do_tridiag, do_solve_tridi,  &
                                                                         do_trans_to_band, do_trans_to_full
   logical                                                            :: good_nblk_gpu

   integer(kind=ik)                                                   :: nrThreads, limitThreads
   integer(kind=ik)                                                   :: global_index
   logical                                                            :: reDistributeMatrix, doRedistributeMatrix
   integer(kind=ik)                                                   :: pinningInfo

   integer(kind=MPI_KIND)                                             :: bcast_request1, bcast_request2, allreduce_request1, &
                                                                         allreduce_request2, allreduce_request3, &
                                                                         allreduce_request4, allreduce_request5, &
                                                                         allreduce_request6, allreduce_request7, &
                                                                         allreduce_request8
   logical                                                            :: useNonBlockingCollectivesAll
   integer(kind=ik)                                                   :: gpu_old, gpu_new
   integer(kind=ik)                                                   :: non_blocking_collectives_all













    call obj%timer%start("elpa_solve_skew_evp_&
    &real&
    &_2stage_&
    &double&
    &")

    call obj%get("debug",debug, error)
    if (error .ne. ELPA_OK) then
      write(error_unit,*) "ELPA2: Problem getting option for debug settings. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

    endif

    wantDebug = debug == 1

    ! check legacy GPU setings
    ! check legacy GPU setings
    if (obj%is_set("gpu") == 1) then
      write(error_unit,*) "You still use the deprecated option 'gpu', consider switching to 'nvidia-gpu'"
      call obj%get("gpu", gpu_old, error)     
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "GPU_SOLVER : Problem getting option for gpu. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_skew_evp_&
     &real&
     &_1stage_&
     &double&
     &")
     success = .false.
     return
      endif
      if (obj%is_set("nvidia-gpu") == 0) then
        ! set gpu and nvidia-gpu consistent
        call obj%set("nvidia-gpu", gpu_old, error)
        if (error .ne. ELPA_OK) then
          write(error_unit,*) "GPU_SOLVER : Problem setting option for nvidia-gpu. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_skew_evp_&
     &real&
     &_1stage_&
     &double&
     &")
     success = .false.
     return
        endif
        write(error_unit,*) "Will set the new keyword 'nvidia-gpu' now."
        write(error_unit,*) "And ignore the 'gpu' keyword from now on"
      else ! obj%is_set("nvidia-gpu") == 0
        call obj%get("nvidia-gpu", gpu_new, error)
        if (error .ne. ELPA_OK) then
          write(error_unit,*) "GPU_SOLVER : Problem getting option for nvidia-gpu. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_skew_evp_&
     &real&
     &_1stage_&
     &double&
     &")
     success = .false.
     return
        endif
        if (gpu_old .ne. gpu_new) then
                write(error_unit,*) "Please do not set 'gpu' but 'nvidia-gpu' instead"
          write(error_unit,*) "You cannot set gpu = ",gpu_old," and nvidia-gpu=",gpu_new,". Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_skew_evp_&
     &real&
     &_1stage_&
     &double&
     &")
     success = .false.
     return
        endif
      endif ! obj%is_set("nvidia-gpu") == 0
      if (obj%is_set("amd-gpu") == 0) then
        ! amd-gpu is not set, but gpu is set
        ! this is ok in anycase
      else ! obj%is_set("amd-gpu") == 0
        call obj%get("amd-gpu", gpu_new, error)
        if (error .ne. ELPA_OK) then
          write(error_unit,*) "GPU_SOLVER : Problem getting option for amd-gpu. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_skew_evp_&
     &real&
     &_1stage_&
     &double&
     &")
     success = .false.
     return
        endif
        ! this is ok, if gpu == 0 and amd-gpu == 1 or
        !             if gpu == 0 and amd-gpu == 0 or
        !             if gpu == 1 and amd-gpu == 0
        if (gpu_old .eq. 1 .and. gpu_new .eq. 1) then
          write(error_unit,*) "GPU_SOLVER : You cannot set gpu = 1 and amd-gpu = 1. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_skew_evp_&
     &real&
     &_1stage_&
     &double&
     &")
     success = .false.
     return
        endif
      endif ! amd-gpu
      if (obj%is_set("intel-gpu") == 0) then
        ! intel-gpu is not set, but gpu is set
        ! this is ok in anycase
      else ! obj%is_set("intel-gpu") == 0
        call obj%get("intel-gpu", gpu_new, error)
        if (error .ne. ELPA_OK) then
          write(error_unit,*) "GPU_SOLVER : Problem getting option for intel-gpu. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_skew_evp_&
     &real&
     &_1stage_&
     &double&
     &")
     success = .false.
     return
        endif
        ! this is ok, if gpu == 0 and intel-gpu == 1 or
        !             if gpu == 0 and intel-gpu == 0 or
        !             if gpu == 1 and intel-gpu == 0
        if (gpu_old .eq. 1 .and. gpu_new .eq. 1) then
          write(error_unit,*) "GPU_SOLVER : You cannot set gpu = 1 and intel-gpu = 1. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_skew_evp_&
     &real&
     &_1stage_&
     &double&
     &")
     success = .false.
     return
        endif
      endif ! intel-gpu
    else ! gpu not set
      ! nothing to do since the legacy option is not set
    endif ! gpu is set

    ! GPU settings
    if (gpu_vendor() == NVIDIA_GPU) then
      call obj%get("nvidia-gpu", gpu, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "GPU_SOLVER : Problem getting option for NVIDIA GPU. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_skew_evp_&
     &real&
     &_1stage_&
     &double&
     &")
     success = .false.
     return
      endif
    else if (gpu_vendor() == AMD_GPU) then
      call obj%get("amd-gpu", gpu, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "GPU_SOLVER : Problem getting option for AMD GPU. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_skew_evp_&
     &real&
     &_1stage_&
     &double&
     &")
     success = .false.
     return
      endif
    else if (gpu_vendor() == INTEL_GPU) then
      call obj%get("intel-gpu", gpu, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "GPU_SOLVER : Problem getting option for INTEL GPU. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_skew_evp_&
     &real&
     &_1stage_&
     &double&
     &")
     success = .false.
     return
      endif
    else ! no supported gpu
      gpu = 0
    endif

   if (gpu .eq. 1) then
     useGPU =.true.
   else
     useGPU = .false.
   endif


    do_useGPU = .false.

    ! get the kernel and check whether it has been set by the user
    if (obj%is_set("real_kernel") == 1) then
      userHasSetKernel = .true.
    else
      userHasSetKernel = .false.
    endif

    ! after this point you may _never_ call get for the kernel again, or set the
    ! kernel !! The reason is that we might have to adjust the kernel, which is
    ! passed as a variable
    call obj%get("real_kernel", kernel, error)
    if (error .ne. ELPA_OK) then
      write(error_unit,*) "ELPA2: Problem getting option for kernel settings. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

    endif

    ! to implement a possibiltiy to set this
    useNonBlockingCollectivesAll = .false.

    call obj%get("mpi_comm_rows",mpi_comm_rows, error)
    if (error .ne. ELPA_OK) then
      write(error_unit,*) "ELPA2: Problem getting option for mpi_comm_rows. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

    endif
    call obj%get("mpi_comm_cols",mpi_comm_cols,error)
    if (error .ne. ELPA_OK) then
      write(error_unit,*) "ELPA2: Problem getting option for mpi_comm_cols. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

    endif
    call obj%get("mpi_comm_parent",mpi_comm_all,error)
    if (error .ne. ELPA_OK) then
      write(error_unit,*) "ELPA2: Problem getting option for mpi_comm_parent. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

    endif

    call obj%timer%start("mpi_communication")
    call mpi_comm_rank(int(mpi_comm_all,kind=MPI_KIND) ,my_peMPI ,mpierr)
    call mpi_comm_size(int(mpi_comm_all,kind=MPI_KIND) ,n_pesMPI ,mpierr)

    call mpi_comm_rank(int(mpi_comm_rows,kind=MPI_KIND) ,my_prowMPI ,mpierr)
    call mpi_comm_size(int(mpi_comm_rows,kind=MPI_KIND) ,np_rowsMPI ,mpierr)
    call mpi_comm_rank(int(mpi_comm_cols,kind=MPI_KIND) ,my_pcolMPI ,mpierr)
    call mpi_comm_size(int(mpi_comm_cols,kind=MPI_KIND) ,np_colsMPI ,mpierr)

    my_pe = int(my_peMPI, kind=c_int)
    n_pes = int(n_pesMPI, kind=c_int)
    my_prow = int(my_prowMPI, kind=c_int)
    np_rows = int(np_rowsMPI, kind=c_int)
    my_pcol = int(my_pcolMPI, kind=c_int)
    np_cols = int(np_colsMPI, kind=c_int)

    call obj%timer%stop("mpi_communication")

    na         = obj%na
    nev        = obj%nev
    nblk       = obj%nblk
    matrixCols = obj%local_ncols
    matrixRows = obj%local_nrows

    call obj%get("nbc_all_elpa2_main", non_blocking_collectives_all, error)
    if (error .ne. ELPA_OK) then
      write(error_unit,*) "ELPA2: Problem getting option for non blocking collectives. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

    endif

    if (non_blocking_collectives_all .eq. 1) then
      useNonBlockingCollectivesAll = .true.
    else
      useNonBlockingCollectivesAll = .false.
    endif

    ! openmp setting
    nrThreads = 1


    if (useGPU) then
      call obj%timer%start("check_for_gpu")
      if (check_for_gpu(obj, my_pe, numberOfGPUDevices, wantDebug=wantDebug)) then
        do_useGPU = .true.
        ! set the neccessary parameters
        call set_gpu_parameters()

      else
        write(error_unit,*) "ELPA2: GPUs are requested but not detected! Aborting..."
        call obj%timer%stop("check_for_gpu")
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

      endif
      call obj%timer%stop("check_for_gpu")

      if (nblk*(max(np_rows,np_cols)-1) >= na) then
        if (my_pe .eq. 0) then
          write(error_unit,*) "ELPA: Warning, block size too large for this matrix size and process grid!"
          write(error_unit,*) "Choose a smaller block size if possible.",nblk*(max(np_rows,np_cols)-1),na
          write(error_unit,*) "Disabling GPU usage! "
        endif

        do_useGPU = .false.
        if (kernel .eq. ELPA_2STAGE_REAL_NVIDIA_GPU) then
          if (userHasSetKernel) then
            ! user fixed inconsistent input.
            ! sadly, we do have to abort
            if (my_pe .eq. 0) then
              write(error_unit,*) "You set (fixed) the kernel to GPU, but GPUs cannot be used."
              write(error_unit,*) "Either adapt the block size or the process grid, or do not set the GPU kernel! Aborting..."
            endif
            stop 1
          else
            ! here we should set the default kernel
            kernel = ELPA_2STAGE_REAL_DEFAULT
          endif
        endif
      endif

    endif ! useGPU




    do_useGPU_bandred = do_useGPU
    do_useGPU_tridiag_band = .false.  ! not yet ported
    do_useGPU_solve_tridi = do_useGPU
    do_useGPU_trans_ev_tridi_to_band = do_useGPU
    do_useGPU_trans_ev_band_to_full = do_useGPU


   reDistributeMatrix = .false.



   ! aIntern, qIntern, are normally pointers since no matrix redistribution is used
   ! point them to  the external arrays
   aIntern => aExtern(1:matrixRows,1:matrixCols)
   if (present(qExtern)) then
     qIntern => qExtern(1:matrixRows,1:2*matrixCols)
   endif

  ! whether a matrix redistribution or not is happening we still
  ! have to point ev
   evIntern => evExtern(1:obj%na)

     a       => aIntern(1:matrixRows,1:matrixCols)
     if (present(qExtern)) then
       q       => qIntern(1:matrixRows,1:2*matrixCols)
     endif

   ev      => evIntern(1:obj%na)

   call obj%get("output_pinning_information", pinningInfo, error)
   if (error .ne. ELPA_OK) then
     write(error_unit,*) "ELPA2: Problem setting option for debug. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

   endif

   if (pinningInfo .eq. 1) then
     call init_thread_affinity(nrThreads)

     call check_thread_affinity()
     if (my_pe .eq. 0) call print_thread_affinity(my_pe)
     call cleanup_thread_affinity()
   endif

    success = .true.

    if (present(qExtern)) then
      obj%eigenvalues_only = .false.
    else
      obj%eigenvalues_only = .true.
    endif

   ! special case na = 1
   if (na .eq. 1) then
     ev(1) = a(1,1)
     if (.not.(obj%eigenvalues_only)) then
       q(1,1) = ONE
     endif

     ! restore original OpenMP settings

     call obj%timer%stop("elpa_solve_skew_evp_&
     &real&
     &_2stage_&
     &double&
     &")
     success = .true.
     return
   endif

   if (nev == 0) then
     nev = 1
     obj%eigenvalues_only = .true.
   endif

    !call obj%get("real_kernel", kernel, error)
    !if (error .ne. ELPA_OK) then
    !  print *,"Problem getting option for kernel settings. Aborting..."
    !  stop 1
    !endif

    !call obj%get("is_skewsymmetric",skewsymmetric,error)
    !if (error .ne. ELPA_OK) then
    !  print *,"Problem getting option for skewsymmetric settings. Aborting..."
    !  stop 1
    !endif
    !isSkewsymmetric = (skewsymmetric == 1)
    isSkewsymmetric = .true.

    ! only if we want (and can) use GPU in general, look what are the
    ! requirements for individual routines. Implicitly they are all set to 1, so
    ! unless specified otherwise by the user, GPU versions of all individual
    ! routines should be used
    if (do_useGPU) then
      call obj%get("gpu_bandred", gpu, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "ELPA2: Problem getting option gpu_bandred settings. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

      endif
      do_useGPU_bandred = (gpu == 1)

      ! not yet ported
      !call obj%get("gpu_tridiag_band", gpu, error)
      !if (error .ne. ELPA_OK) then
      !  print *,"Problem getting option for gpu_tridiag_band settings. Aborting..."
      !  stop 1
      !endif
      !do_useGPU_tridiag_band = (gpu == 1)

      call obj%get("gpu_solve_tridi", gpu, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "ELPA2: Problem getting option for gpu_solve_tridi settings. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

      endif
      do_useGPU_solve_tridi = (gpu == 1)

      call obj%get("gpu_trans_ev_tridi_to_band", gpu, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "ELPA2: Problem getting option for gpu_trans_ev_tridi_to_band settings. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

      endif
      do_useGPU_trans_ev_tridi_to_band = (gpu == 1)

      call obj%get("gpu_trans_ev_band_to_full", gpu, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "ELPA2: Problem getting option for gpu_trans_ev_band_to_full settings. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

      endif
      do_useGPU_trans_ev_band_to_full = (gpu == 1)
    endif

    ! check consistency between request for GPUs and defined kernel
    if (do_useGPU_trans_ev_tridi_to_band) then
      ! if the user has set explicitely a kernel before than honour this
      ! otherwise set GPU kernel
      if (userHasSetKernel) then
        if (kernel .ne. ELPA_2STAGE_REAL_NVIDIA_GPU) then
          write(error_unit,*) "ELPA: Warning, GPU usage has been requested but compute kernel is set by the user as non-GPU!"
          write(error_unit,*) "The compute kernel will be executed on CPUs!"
          do_useGPU_trans_ev_tridi_to_band = .false.
          kernel = ELPA_2STAGE_REAL_DEFAULT
        else
          good_nblk_gpu = .false.
        endif
      else ! userHasSetKernel
        !call obj%set("real_kernel", ELPA_2STAGE_REAL_NVIDIA_GPU, error)
        !if (error .ne. ELPA_OK) then
        !  write(error_unit,*) "Cannot set kernel to GPU kernel"
        !  stop 1
        !endif

        if (my_pe .eq. 0) write(error_unit,*) "You requested the GPU version, thus the GPU kernel is activated"
        good_nblk_gpu = .false.

        kernel = ELPA_2STAGE_REAL_NVIDIA_GPU
      endif ! userHasSetKernel

      ! Accepted values are 2,4,8,16,...,512
      do i = 1,10
        if (nblk == 2**i) then
          good_nblk_gpu = .true.
          exit
        endif
      enddo

      if (.not. good_nblk_gpu .and. do_useGPU_trans_ev_tridi_to_band) then
         write(error_unit,*) "ELPA: Warning, GPU kernel only works with block size 2^n (n = 1, 2, ..., 10)!"
         write(error_unit,*) "The compute kernel will be executed on CPUs!"
         write(error_unit,*) "We recommend changing the block size to 2^n"
         do_useGPU_trans_ev_tridi_to_band = .false.
         ! should be set
         kernel = ELPA_2STAGE_REAL_DEFAULT
      endif
    endif





    ! check again, now kernel and do_useGPU_trans_ev_tridi_to_band should be
    ! finally consistent
    if (do_useGPU_trans_ev_tridi_to_band) then
      !call obj%get("real_kernel", kernel, error)
      !if (error .ne. ELPA_OK) then
      !  write(error_unit,*) "Cannot get kernel to GPU kernel"
      !  stop 1
      !endif
      if (kernel .ne. ELPA_2STAGE_REAL_NVIDIA_GPU) then
        ! this should never happen, checking as an assert
        write(error_unit,*) "ELPA: INTERNAL ERROR setting GPU kernel!  Aborting..."
        stop 1
      endif
    else ! do not use GPU
      if (kernel .eq. ELPA_2STAGE_REAL_NVIDIA_GPU) then
        ! combination not allowed
        write(error_unit,*) "ELPA: Warning, GPU usage has NOT been requested but compute kernel &
                            &is defined as the GPU kernel!  Setting default kernel"
        kernel = ELPA_2STAGE_REAL_DEFAULT
        !TODO do error handling properly
      endif
    endif

    ! special case at the moment NO single precision kernels on POWER 8 -> set GENERIC for now
    if (kernel .eq. ELPA_2STAGE_REAL_VSX_BLOCK2 .or. &
        kernel .eq. ELPA_2STAGE_REAL_VSX_BLOCK4 .or. &
        kernel .eq. ELPA_2STAGE_REAL_VSX_BLOCK6        ) then
        write(error_unit,*) "ELPA: At the moment there exist no specific SINGLE precision kernels for POWER8"
        write(error_unit,*) "The GENERIC kernel will be used at the moment"
        kernel = ELPA_2STAGE_REAL_GENERIC
    endif
    ! special case at the moment NO single precision kernels on SPARC64 -> set GENERIC for now
    if (kernel .eq. ELPA_2STAGE_REAL_SPARC64_BLOCK2 .or. &
        kernel .eq. ELPA_2STAGE_REAL_SPARC64_BLOCK4 .or. &
        kernel .eq. ELPA_2STAGE_REAL_SPARC64_BLOCK6        ) then
        write(error_unit,*) "ELPA: At the moment there exist no specific SINGLE precision kernels for SPARC64"
        write(error_unit,*) "The GENERIC kernel will be used at the moment"
        kernel = ELPA_2STAGE_REAL_GENERIC
    endif


     !! consistency check: is user set kernel still identical with "kernel" or did
     !! we change it above? This is a mess and should be cleaned up
     !call obj%get("real_kernel",kernelByUser,error)
     !if (error .ne. ELPA_OK) then
     !  print *,"Problem getting option for user kernel settings. Aborting..."
     !  stop 1
     !endif

     !if (kernelByUser .ne. kernel) then
     !  call obj%set("real_kernel", kernel, error)
     !  if (error .ne. ELPA_OK) then
     !    print *,"Problem setting kernel. Aborting..."
     !    stop 1
     !  endif
     !endif


    call obj%get("qr",qr,error)
    if (error .ne. ELPA_OK) then
      print *,"ELPA2: Problem getting option for qr settings. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

    endif
    if (qr .eq. 1) then
      useQR = .true.
    else
      useQR = .false.
    endif

    useQRActual = .false.
    ! set usage of qr decomposition via API call
    if (useQR) useQRActual = .true.
    if (.not.(useQR)) useQRACtual = .false.

    if (useQRActual) then
      if (mod(na,2) .ne. 0) then
        if (wantDebug) then
          write(error_unit,*) "solve_evp_real_2stage: QR-decomposition: blocksize does not fit with matrixsize"
        endif
        write(error_unit,*) "Do not use QR-decomposition for this matrix and blocksize."
        success = .false.
        return
      endif
    endif

    if (.not. obj%eigenvalues_only) then
      q_actual => q(1:matrixRows,1:matrixCols)
    else
     allocate(q_dummy(1:matrixRows,1:matrixCols), stat=istat, errmsg=errorMessage)
     call check_allocate_f("elpa2_template: q_dummy", 998,  istat,  errorMessage)
     q_actual => q_dummy(1:matrixRows,1:matrixCols)
    endif

    ! set the default values for each of the 5 compute steps
    do_bandred        = .true.
    do_tridiag        = .true.
    do_solve_tridi    = .true.
    do_trans_to_band  = .true.
    do_trans_to_full  = .true.

    if (obj%eigenvalues_only) then
      do_trans_to_band  = .false.
      do_trans_to_full  = .false.
    endif

    if (obj%is_set("bandwidth") == 1) then
      ! bandwidth is set. That means, that the inputed matrix is actually banded and thus the
      ! first step of ELPA2 should be skipped
      call obj%get("bandwidth",nbw,error)
      if (nbw == 0) then
        if (wantDebug) then
          write(error_unit,*) "Specified bandwidth = 0; ELPA refuses to solve the eigenvalue problem ", &
                              "for a diagonal matrix! This is too simple"
          endif
          write(error_unit,*) "Specified bandwidth = 0; ELPA refuses to solve the eigenvalue problem ", &
                 "for a diagonal matrix! This is too simple"
        success = .false.
        return
      endif
      if (mod(nbw, nblk) .ne. 0) then
        ! treat matrix with an effective bandwidth slightly bigger than specified bandwidth
        ! such that effective bandwidth is a multiply of nblk. which is a prerequiste for ELPA
        nbw = nblk * ceiling(real(nbw,kind=c_double)/real(nblk,kind=c_double))

        ! just check that effective bandwidth is NOT larger than matrix size
        if (nbw .gt. na) then
          if (wantDebug) then
            write(error_unit,*) "Specified bandwidth ",nbw," leads internaly to a computed bandwidth ", &
                                "which is larger than the matrix size ",na," ! ELPA will abort! Try to", &
                                "solve your problem by not specifing a bandwidth"
          endif
          print *, "Specified bandwidth ",nbw," leads internaly to a computed bandwidth ", &
                                "which is larger than the matrix size ",na," ! ELPA will abort! Try to", &
                                "solve your problem by not specifing a bandwidth"
          success = .false.
          return
        endif
      endif
      do_bandred       = .false. ! we already have a banded matrix
      do_solve_tridi   = .true.  ! we also have to solve something :-)
      do_trans_to_band = .true.  ! and still we have to backsub to banded
      do_trans_to_full = .false. ! but not to full since we have a banded matrix
    else ! matrix is not banded, determine the intermediate bandwidth for full->banded->tridi
      !first check if the intermediate bandwidth was set by the user
      call obj%get("intermediate_bandwidth", nbw, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "Problem getting option for intermediate_bandwidth. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

      endif

      if(nbw == 0) then
        ! intermediate bandwidth was not specified, select one of the defaults

        ! Choose bandwidth, must be a multiple of nblk, set to a value >= 32
        ! On older systems (IBM Bluegene/P, Intel Nehalem) a value of 32 was optimal.
        ! For Intel(R) Xeon(R) E5 v2 and v3, better use 64 instead of 32!
        ! For IBM Bluegene/Q this is not clear at the moment. We have to keep an eye
        ! on this and maybe allow a run-time optimization here
        nbw = (63/nblk+1)*nblk
      else
        ! intermediate bandwidth has been specified by the user, check, whether correctly
        if (mod(nbw, nblk) .ne. 0) then
          print *, "Specified bandwidth ",nbw," has to be mutiple of the blocksize ", nblk, ". Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

        endif
      endif !nbw == 0

      num_blocks = (na-1)/nbw + 1

      ! tmat is needed only in full->band and band->full steps, so alocate here
      ! (not allocated for banded matrix on input)
      allocate(tmat(nbw,nbw,num_blocks), stat=istat, errmsg=errorMessage)
      call check_allocate_f("elpa2_template: tmat", 1085,  istat,  errorMessage)

      do_bandred       = .true.
      do_solve_tridi   = .true.
      do_trans_to_band = .true.
      do_trans_to_full = .true.
    endif  ! matrix not already banded on input

    ! start the computations in 5 steps
    if (do_bandred) then
      call obj%autotune_timer%start("full_to_band")
      call obj%timer%start("full_to_band")
      ! Reduction full -> band
      call bandred_&
      &real&
      &_&
      &double &
      (obj, na, a, &
      matrixRows, nblk, nbw, matrixCols, num_blocks, mpi_comm_rows, mpi_comm_cols, tmat, &
      wantDebug, do_useGPU_bandred, success, &
      useQRActual, &
       nrThreads, isSkewsymmetric)

      call obj%timer%stop("full_to_band")
      call obj%autotune_timer%stop("full_to_band")
  
      if (success) then
        success_int = 0
      else
        success_int = 1
      endif

      if (useNonBlockingCollectivesAll) then
        call mpi_iallreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), &
        allreduce_request2, mpierr)
        call mpi_wait(allreduce_request2, MPI_STATUS_IGNORE, mpierr)
      else
        call mpi_allreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), mpierr)
      endif
      if (success_int .eq. 1) then
        write(error_unit,*) "ELPA2: bandred returned an error. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

      endif
    endif

     ! Reduction band -> tridiagonal
     if (do_tridiag) then
       allocate(e(na), stat=istat, errmsg=errorMessage)
       call check_allocate_f("elpa2_template: e", 1143,  istat,  errorMessage)

       call obj%autotune_timer%start("band_to_tridi")
       call obj%timer%start("band_to_tridi")
       call tridiag_band_&
       &real&
       &_&
       &double&
       (obj, na, nbw, nblk, a, matrixRows, ev, e, matrixCols, hh_trans, mpi_comm_rows, mpi_comm_cols, mpi_comm_all, &
       do_useGPU_tridiag_band, wantDebug, nrThreads, isSkewsymmetric, success)
  
       if (success) then
         success_int = 0
       else
         success_int = 1
       endif

       if (useNonBlockingCollectivesAll) then
         call mpi_iallreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), &
         allreduce_request3, mpierr)
         call mpi_wait(allreduce_request3, MPI_STATUS_IGNORE, mpierr)
       else
         call mpi_allreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), mpierr)
       endif
       if (success_int .eq. 1) then
         write(error_unit,*) "Error in tridiag_band. Aborting..."
         return
       endif

       call obj%timer%start("mpi_communication")
       if (useNonBlockingCollectivesAll) then
         call mpi_ibcast(ev, int(na,kind=MPI_KIND), MPI_REAL8, 0_MPI_KIND, int(mpi_comm_all,kind=MPI_KIND), bcast_request1, mpierr)
         call mpi_ibcast(e, int(na,kind=MPI_KIND), MPI_REAL8, 0_MPI_KIND, int(mpi_comm_all,kind=MPI_KIND), bcast_request2, mpierr)

         call mpi_wait(bcast_request1, MPI_STATUS_IGNORE, mpierr)
         call mpi_wait(bcast_request2, MPI_STATUS_IGNORE, mpierr)
       else
         call mpi_bcast(ev, int(na,kind=MPI_KIND), MPI_REAL8, 0_MPI_KIND, int(mpi_comm_all,kind=MPI_KIND), mpierr)
         call mpi_bcast(e, int(na,kind=MPI_KIND), MPI_REAL8, 0_MPI_KIND, int(mpi_comm_all,kind=MPI_KIND), mpierr)
       endif
       call obj%timer%stop("mpi_communication")

       call obj%timer%stop("band_to_tridi")
       call obj%autotune_timer%stop("band_to_tridi")
     endif ! do_tridiag


     ! Solve tridiagonal system
     if (do_solve_tridi) then
       call obj%autotune_timer%start("solve")
       call obj%timer%start("solve")

       call solve_tridi_&
       &double &
       (obj, na, nev, ev, e, &
       q_actual, matrixRows,   &
       nblk, matrixCols, mpi_comm_all, mpi_comm_rows, mpi_comm_cols, do_useGPU_solve_tridi, wantDebug, &
               success, nrThreads)

       call obj%timer%stop("solve")
       call obj%autotune_timer%stop("solve")
  
       if (success) then
         success_int = 0
       else
         success_int = 1
       endif

       if (useNonBlockingCollectivesAll) then
         call mpi_iallreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), &
         allreduce_request4, mpierr)
         call mpi_wait(allreduce_request4, MPI_STATUS_IGNORE, mpierr)
       else
         call mpi_allreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), mpierr)
       endif

       if (success_int .eq. 1) then
         write(error_unit,*) "ELPA2: solve returned an error: Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

       endif
     endif ! do_solve_tridi

     deallocate(e, stat=istat, errmsg=errorMessage)
     call check_deallocate_f("elpa2_template: e", 1257,  istat,  errorMessage)

     if (obj%eigenvalues_only) then
       do_trans_to_band = .false.
       do_trans_to_full = .false.
     else
       call obj%get("check_pd",check_pd,error)
       if (error .ne. ELPA_OK) then
         write(error_unit,*) "Problem getting option for check_pd. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

       endif
       if (check_pd .eq. 1) then
         call obj%get("thres_pd_&
         &double&
         &",thres_pd,error)
         if (error .ne. ELPA_OK) then
            write(error_unit,*) "Problem getting option for thres_pd_&
            &double&
            &. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

         endif

         check_pd = 0
         do i = 1, na
           if (ev(i) .gt. thres_pd) then
             check_pd = check_pd + 1
           endif
         enddo
         if (check_pd .lt. na) then
           ! not positiv definite => eigenvectors needed
           do_trans_to_band = .true.
           do_trans_to_full = .true.
         else
           do_trans_to_band = .false.
           do_trans_to_full = .false.
         endif
       endif
     endif ! eigenvalues only


       if (isSkewsymmetric) then
       ! Extra transformation step for skew-symmetric matrix. Multiplication with diagonal complex matrix D.
       ! This makes the eigenvectors complex.
       ! For now real part of eigenvectors is generated in first half of q, imaginary part in second part.
         q(1:matrixRows, matrixCols+1:2*matrixCols) = 0.0
         do i = 1, matrixRows
!          global_index = indxl2g(i, nblk, my_prow, 0, np_rows)
           global_index = np_rows*nblk*((i-1)/nblk) + MOD(i-1,nblk) + MOD(np_rows+my_prow-0, np_rows)*nblk + 1
           if (mod(global_index-1,4) .eq. 0) then
              ! do nothing
           end if
           if (mod(global_index-1,4) .eq. 1) then
              q(i,matrixCols+1:2*matrixCols) = q(i,1:matrixCols)
              q(i,1:matrixCols) = 0
           end if
           if (mod(global_index-1,4) .eq. 2) then
              q(i,1:matrixCols) = -q(i,1:matrixCols)
           end if
           if (mod(global_index-1,4) .eq. 3) then
              q(i,matrixCols+1:2*matrixCols) = -q(i,1:matrixCols)
              q(i,1:matrixCols) = 0
           end if
         end do
       endif

       ! Backtransform stage 1
     if (do_trans_to_band) then

       !debug
!#if defined(WITH_OPENMP_OFFLOAD_GPU_VERSION) || defined(WITH_SYCL_GPU_VERSION)
       !if (gpu_vendor() == OPENMP_OFFLOAD_GPU .or. gpu_vendor() == SYCL_GPU) then
       call obj%autotune_timer%start("tridi_to_band")
       call obj%timer%start("tridi_to_band")
       ! In the skew-symmetric case this transforms the real part
       call trans_ev_tridi_to_band_&
       &real&
       &_&
       &double &
       (obj, na, nev, nblk, nbw, q, &
       matrixRows, matrixCols, hh_trans, my_pe, mpi_comm_rows, mpi_comm_cols, &
       wantDebug, do_useGPU_trans_ev_tridi_to_band, &
       nrThreads, success=success, kernel=kernel)
       call obj%timer%stop("tridi_to_band")
       call obj%autotune_timer%stop("tridi_to_band")

       if (success) then
         success_int = 0
       else
         success_int = 1
       endif

       if (useNonBlockingCollectivesAll) then
         call mpi_iallreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), &
         allreduce_request5, mpierr)
         call mpi_wait(allreduce_request5, MPI_STATUS_IGNORE, mpierr)
       else
         call mpi_allreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), mpierr)
       endif

       if (success_int .eq. 1) then
         write(error_unit,*) "ELPA2: trans_ev_tridi_to_band returned an error. Aborting..."
         return
       endif

     endif ! do_trans_to_band

     ! the array q (currently) always resides on host even when using GPU

     if (do_trans_to_full) then
       call obj%autotune_timer%start("band_to_full")
       call obj%timer%start("band_to_full")
       ! Backtransform stage 2
       ! In the skew-symemtric case this transforms the real part
       call trans_ev_band_to_full_&
       &real&
       &_&
       &double &
       (obj, na, nev, nblk, nbw, a, &
       matrixRows, tmat, q,  &
       matrixRows, matrixCols, num_blocks, mpi_comm_rows, mpi_comm_cols, do_useGPU_trans_ev_band_to_full &
       , useQRActual  &
       , success)
       call obj%timer%stop("band_to_full")
       call obj%autotune_timer%stop("band_to_full")

       if (success) then
         success_int = 0
       else
         success_int = 1
       endif

       if (useNonBlockingCollectivesAll) then
         call mpi_iallreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), &
         allreduce_request6, mpierr)
         call mpi_wait(allreduce_request6, MPI_STATUS_IGNORE, mpierr)
       else
         call mpi_allreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), mpierr)
       endif
       if (success_int .eq. 1) then
         write(error_unit,*) "Error in trans_ev_band_to_full. Aborting..."
         return
       endif
     endif ! do_trans_to_full
! #ifdef 
!        call prmat(na,useGPU,q(1:matrixRows, 1:matrixCols),q_dev,matrixRows,matrixCols,nblk,my_prow,my_pcol,np_rows,np_cols,'R',1)
! #endif


     !skew symmetric imaginary part for tridi_to_band and band_to_full
     if (isSkewsymmetric) then
       if (do_trans_to_band) then
         call obj%autotune_timer%start("tridi_to_band")
         call obj%timer%start("skew_tridi_to_band")
         ! Transform imaginary part
         ! Transformation of real and imaginary part could also be one call of trans_ev_tridi acting on the n x 2n matrix.
         call trans_ev_tridi_to_band_&
         &real&
         &_&
         &double &
         (obj, na, nev, nblk, nbw, q(1:matrixRows, matrixCols+1:2*matrixCols), &
         matrixRows, matrixCols, hh_trans, my_pe, mpi_comm_rows, mpi_comm_cols, &
         wantDebug, do_useGPU_trans_ev_tridi_to_band, &
         nrThreads, success=success, kernel=kernel)

         call obj%timer%stop("skew_tridi_to_band")
         call obj%autotune_timer%stop("tridi_to_band")

         if (success) then
           success_int = 0
         else
           success_int = 1
         endif

         if (useNonBlockingCollectivesAll) then
           call mpi_iallreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), &
           allreduce_request7, mpierr)
           call mpi_wait(allreduce_request7, MPI_STATUS_IGNORE, mpierr)
         else
           call mpi_allreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), mpierr)
         endif
         if (success_int .eq. 1) then
          write(error_unit,*) "Error in trans_ev_tridi_to_band (imaginary part). Aborting..."
          return
         endif
       endif ! do_trans_tridi_to_band

       if (do_trans_to_full) then
       call obj%autotune_timer%start("band_to_full")
       call obj%timer%start("band_to_full")
         ! Transform imaginary part
         ! Transformation of real and imaginary part could also be one call of trans_ev_band_to_full_ acting on the n x 2n matrix.
         call trans_ev_band_to_full_&
         &real&
         &_&
         &double &
         (obj, na, nev, nblk, nbw, a, &
         matrixRows, tmat, q(1:matrixRows, matrixCols+1:2*matrixCols),  &
         matrixRows, matrixCols, num_blocks, mpi_comm_rows, mpi_comm_cols, do_useGPU_trans_ev_band_to_full, &
         useQRActual, &
         success)

         call obj%timer%stop("band_to_full")
         call obj%autotune_timer%stop("band_to_full")

         if (success) then
           success_int = 0
         else
           success_int = 1
         endif

         if (useNonBlockingCollectivesAll) then
           call mpi_iallreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), &
           allreduce_request8, mpierr)
           call mpi_wait(allreduce_request8, MPI_STATUS_IGNORE, mpierr)
         else
           call mpi_allreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), mpierr)
         endif
         if (success_int .eq. 1) then
          write(error_unit,*) "Error in trans_ev_band_to_full (imaginary part). Aborting..."
          return
         endif
       endif ! do_trans_to_full
     endif ! isSkewSymmetric


     ! We can now deallocate the stored householder vectors
     deallocate(hh_trans, stat=istat, errmsg=errorMessage)
     call check_deallocate_f("elpa2_template: hh_trans", 1537,  istat,  errorMessage)

     ! make sure tmat is deallocated when using check_pd
     if (allocated(tmat)) then
       deallocate(tmat, stat=istat, errmsg=errorMessage)
       call check_deallocate_f("elpa2_template: tmat", 1542,  istat,  errorMessage)
     endif

     if (obj%eigenvalues_only) then
       deallocate(q_dummy, stat=istat, errmsg=errorMessage)
       call check_deallocate_f("elpa2_template: q_dummy", 1547,  istat,  errorMessage)
     endif

     ! restore original OpenMP settings



   nullify(aIntern)
   nullify(evIntern)
   if (present(qExtern)) then
     nullify(qIntern)
   endif

   nullify(ev)
   nullify(a)
   nullify(q)

  nullify(q_actual)

     call obj%timer%stop("elpa_solve_skew_evp_&
     &real&
     &_2stage_&
     &double&
     &")
1    format(a,f10.3)

   end function

! vim: syntax=fortran

















!-------------------------------------------------------------------------------
!>  \brief elpa_solve_skew_evp_real_2stage_d_ptr_double_impl: Fortran function to solve the double-precision real skew-symmetric eigenvalue problem with a 2 stage approach
!>
!>  Parameters
!>
!>  \param na                                   Order of matrix a
!>
!>  \param nev                                  Number of eigenvalues needed
!>
!>  \param a                                    Distributed matrix for which eigenvalues are to be computed.
!>                                              Distribution is like in Scalapack.
!>                                              The full matrix must be set (not only one half like in scalapack).
!>                                              Destroyed on exit (upper and lower half).
!>
!>  \param lda                                  Leading dimension of a
!>
!>  \param ev                                   On output: eigenvalues of a, every processor gets the complete set
!>
!>  \param q                                    On output: Eigenvectors of a
!>                                              Distribution is like in Scalapack.
!>                                              Must be always dimensioned to the full size (corresponding to (na,na))
!>                                              even if only a part of the eigenvalues is needed.
!>
!>  \param ldq                                  Leading dimension of q
!>
!>  \param nblk                                 blocksize of cyclic distribution, must be the same in both directions!
!>
!>  \param matrixCols                           local columns of matrix a and q
!>
!>  \param mpi_comm_rows                        MPI communicator for rows
!>  \param mpi_comm_cols                        MPI communicator for columns
!>  \param mpi_comm_all                         MPI communicator for the total processor set
!>
!>  \param kernel                               specify ELPA2 kernel to use
!>
!>  \param useQR (optional)                     use QR decomposition
!>  \param useGPU (optional)                    decide whether to use GPUs or not
!>
!>  \result success                             logical, false if error occured
!-------------------------------------------------------------------------------


!cannot use "../src/elpa2/../general/error_checking.inc" because filename with path can be too long for gfortran (max line length)


 function elpa_solve_skew_evp_&
  &real&
  &_&
  &2stage_d_ptr_&
  &double&
  &_impl (obj, &
   aExtern, &
   evExtern, &
   qExtern) result(success)

   !use matrix_plot
   use elpa_abstract_impl
   use elpa_utilities
   use elpa1_compute
   use elpa2_compute
   use elpa_mpi
   use cuda_functions
   use hip_functions
   use elpa_gpu
   use mod_check_for_gpu
   use elpa_omp
   use solve_tridi
   use thread_affinity
   use, intrinsic :: iso_c_binding
   implicit none
!    Copyright 2011, A. Marek
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
!
  integer, parameter :: rk = C_DOUBLE
  integer, parameter :: rck = C_DOUBLE
  real(kind=rck), parameter      :: ZERO=0.0_rk, ONE = 1.0_rk

   class(elpa_abstract_impl_t), intent(inout)                         :: obj
   logical                                                            :: useGPU
   logical                                                            :: isSkewsymmetric
   logical                                                            :: useQR
   logical                                                            :: useQRActual
   integer(kind=c_int)                                                :: kernel, kernelByUser
   logical                                                            :: userHasSetKernel


!#ifdef REDISTRIBUTE_MATRIX
   type(c_ptr)                                                        :: aExtern
   type(c_ptr), optional                                              :: qExtern
!#else 
!   type(c_ptr)                                                        :: a, q
!#endif 


    real(kind=rck), pointer                                  :: a(:,:)
    real(kind=rck), pointer                                  :: q(:,:)
    real(kind=rk8), pointer                                  :: ev(:)

   type(c_ptr)                                                        :: evExtern

   real(kind=c_double), allocatable                   :: hh_trans(:,:)

   integer(kind=c_int)                                                :: my_pe, n_pes, my_prow, my_pcol, np_rows, np_cols
   integer(kind=MPI_KIND)                                             :: my_peMPI, n_pesMPI, my_prowMPI, my_pcolMPI, &
                                                                         np_rowsMPI, np_colsMPI, mpierr
   integer(kind=c_int)                                                :: nbw, num_blocks
   real(kind=c_double), allocatable                   :: tmat(:,:,:)
   real(kind=c_double), allocatable                            :: e(:)
   real(kind=c_double), allocatable, target           :: q_dummy(:,:)
   real(kind=c_double), pointer                       :: q_actual(:,:)


   integer(kind=c_int)                                                :: i
   logical                                                            :: success, successGPU
   integer(kind=c_int)                                                :: success_int
   logical                                                            :: wantDebug
   integer(kind=c_int)                                                :: istat, gpu, skewsymmetric, debug, qr
   character(200)                                                     :: errorMessage
   logical                                                            :: do_useGPU, do_useGPU_bandred, &
                                                                         do_useGPU_tridiag_band, do_useGPU_solve_tridi, &
                                                                         do_useGPU_trans_ev_tridi_to_band, &
                                                                         do_useGPU_trans_ev_band_to_full
   integer(kind=c_int)                                                :: numberOfGPUDevices
   integer(kind=c_intptr_t), parameter                                :: size_of_datatype = size_of_&
                                                                                            &double&
                                                                                            &_&
                                                                                            &real
   integer(kind=c_intptr_t), parameter                                :: size_of_real_datatype = size_of_&
                                                                                                 &double&
                                                                                                 &_real
   integer(kind=ik)                                                   :: na, nev, nblk, matrixCols, &
                                                                         mpi_comm_rows, mpi_comm_cols,        &
                                                                         mpi_comm_all, check_pd, error, matrixRows
   real(kind=c_double)                                         :: thres_pd

   real(kind=rck), pointer                                   :: aIntern(:,:)
   real(kind=c_double), pointer                       :: qIntern(:,:)
   real(kind=rk8), pointer                                  :: evIntern(:)

   logical                                                            :: do_bandred, do_tridiag, do_solve_tridi,  &
                                                                         do_trans_to_band, do_trans_to_full
   logical                                                            :: good_nblk_gpu

   integer(kind=ik)                                                   :: nrThreads, limitThreads
   integer(kind=ik)                                                   :: global_index
   logical                                                            :: reDistributeMatrix, doRedistributeMatrix
   integer(kind=ik)                                                   :: pinningInfo

   integer(kind=MPI_KIND)                                             :: bcast_request1, bcast_request2, allreduce_request1, &
                                                                         allreduce_request2, allreduce_request3, &
                                                                         allreduce_request4, allreduce_request5, &
                                                                         allreduce_request6, allreduce_request7, &
                                                                         allreduce_request8
   logical                                                            :: useNonBlockingCollectivesAll
   integer(kind=ik)                                                   :: gpu_old, gpu_new
   integer(kind=ik)                                                   :: non_blocking_collectives_all













    call obj%timer%start("elpa_solve_skew_evp_&
    &real&
    &_2stage_&
    &double&
    &")

    call obj%get("debug",debug, error)
    if (error .ne. ELPA_OK) then
      write(error_unit,*) "ELPA2: Problem getting option for debug settings. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

    endif

    wantDebug = debug == 1

    ! check legacy GPU setings
    ! check legacy GPU setings
    if (obj%is_set("gpu") == 1) then
      write(error_unit,*) "You still use the deprecated option 'gpu', consider switching to 'nvidia-gpu'"
      call obj%get("gpu", gpu_old, error)     
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "GPU_SOLVER : Problem getting option for gpu. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_skew_evp_&
     &real&
     &_1stage_&
     &double&
     &")
     success = .false.
     return
      endif
      if (obj%is_set("nvidia-gpu") == 0) then
        ! set gpu and nvidia-gpu consistent
        call obj%set("nvidia-gpu", gpu_old, error)
        if (error .ne. ELPA_OK) then
          write(error_unit,*) "GPU_SOLVER : Problem setting option for nvidia-gpu. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_skew_evp_&
     &real&
     &_1stage_&
     &double&
     &")
     success = .false.
     return
        endif
        write(error_unit,*) "Will set the new keyword 'nvidia-gpu' now."
        write(error_unit,*) "And ignore the 'gpu' keyword from now on"
      else ! obj%is_set("nvidia-gpu") == 0
        call obj%get("nvidia-gpu", gpu_new, error)
        if (error .ne. ELPA_OK) then
          write(error_unit,*) "GPU_SOLVER : Problem getting option for nvidia-gpu. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_skew_evp_&
     &real&
     &_1stage_&
     &double&
     &")
     success = .false.
     return
        endif
        if (gpu_old .ne. gpu_new) then
                write(error_unit,*) "Please do not set 'gpu' but 'nvidia-gpu' instead"
          write(error_unit,*) "You cannot set gpu = ",gpu_old," and nvidia-gpu=",gpu_new,". Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_skew_evp_&
     &real&
     &_1stage_&
     &double&
     &")
     success = .false.
     return
        endif
      endif ! obj%is_set("nvidia-gpu") == 0
      if (obj%is_set("amd-gpu") == 0) then
        ! amd-gpu is not set, but gpu is set
        ! this is ok in anycase
      else ! obj%is_set("amd-gpu") == 0
        call obj%get("amd-gpu", gpu_new, error)
        if (error .ne. ELPA_OK) then
          write(error_unit,*) "GPU_SOLVER : Problem getting option for amd-gpu. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_skew_evp_&
     &real&
     &_1stage_&
     &double&
     &")
     success = .false.
     return
        endif
        ! this is ok, if gpu == 0 and amd-gpu == 1 or
        !             if gpu == 0 and amd-gpu == 0 or
        !             if gpu == 1 and amd-gpu == 0
        if (gpu_old .eq. 1 .and. gpu_new .eq. 1) then
          write(error_unit,*) "GPU_SOLVER : You cannot set gpu = 1 and amd-gpu = 1. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_skew_evp_&
     &real&
     &_1stage_&
     &double&
     &")
     success = .false.
     return
        endif
      endif ! amd-gpu
      if (obj%is_set("intel-gpu") == 0) then
        ! intel-gpu is not set, but gpu is set
        ! this is ok in anycase
      else ! obj%is_set("intel-gpu") == 0
        call obj%get("intel-gpu", gpu_new, error)
        if (error .ne. ELPA_OK) then
          write(error_unit,*) "GPU_SOLVER : Problem getting option for intel-gpu. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_skew_evp_&
     &real&
     &_1stage_&
     &double&
     &")
     success = .false.
     return
        endif
        ! this is ok, if gpu == 0 and intel-gpu == 1 or
        !             if gpu == 0 and intel-gpu == 0 or
        !             if gpu == 1 and intel-gpu == 0
        if (gpu_old .eq. 1 .and. gpu_new .eq. 1) then
          write(error_unit,*) "GPU_SOLVER : You cannot set gpu = 1 and intel-gpu = 1. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_skew_evp_&
     &real&
     &_1stage_&
     &double&
     &")
     success = .false.
     return
        endif
      endif ! intel-gpu
    else ! gpu not set
      ! nothing to do since the legacy option is not set
    endif ! gpu is set

    ! GPU settings
    if (gpu_vendor() == NVIDIA_GPU) then
      call obj%get("nvidia-gpu", gpu, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "GPU_SOLVER : Problem getting option for NVIDIA GPU. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_skew_evp_&
     &real&
     &_1stage_&
     &double&
     &")
     success = .false.
     return
      endif
    else if (gpu_vendor() == AMD_GPU) then
      call obj%get("amd-gpu", gpu, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "GPU_SOLVER : Problem getting option for AMD GPU. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_skew_evp_&
     &real&
     &_1stage_&
     &double&
     &")
     success = .false.
     return
      endif
    else if (gpu_vendor() == INTEL_GPU) then
      call obj%get("intel-gpu", gpu, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "GPU_SOLVER : Problem getting option for INTEL GPU. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_skew_evp_&
     &real&
     &_1stage_&
     &double&
     &")
     success = .false.
     return
      endif
    else ! no supported gpu
      gpu = 0
    endif

   if (gpu .eq. 1) then
     useGPU =.true.
   else
     write(error_unit,*) "GPU_SOLVER : You used the interface for device pointers but did not specify GPU usage!. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_skew_evp_&
     &real&
     &_1stage_&
     &double&
     &")
     success = .false.
     return
     useGPU = .false.
   endif


    do_useGPU = .false.

    ! get the kernel and check whether it has been set by the user
    if (obj%is_set("real_kernel") == 1) then
      userHasSetKernel = .true.
    else
      userHasSetKernel = .false.
    endif

    ! after this point you may _never_ call get for the kernel again, or set the
    ! kernel !! The reason is that we might have to adjust the kernel, which is
    ! passed as a variable
    call obj%get("real_kernel", kernel, error)
    if (error .ne. ELPA_OK) then
      write(error_unit,*) "ELPA2: Problem getting option for kernel settings. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

    endif

    ! to implement a possibiltiy to set this
    useNonBlockingCollectivesAll = .false.

    call obj%get("mpi_comm_rows",mpi_comm_rows, error)
    if (error .ne. ELPA_OK) then
      write(error_unit,*) "ELPA2: Problem getting option for mpi_comm_rows. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

    endif
    call obj%get("mpi_comm_cols",mpi_comm_cols,error)
    if (error .ne. ELPA_OK) then
      write(error_unit,*) "ELPA2: Problem getting option for mpi_comm_cols. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

    endif
    call obj%get("mpi_comm_parent",mpi_comm_all,error)
    if (error .ne. ELPA_OK) then
      write(error_unit,*) "ELPA2: Problem getting option for mpi_comm_parent. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

    endif

    call obj%timer%start("mpi_communication")
    call mpi_comm_rank(int(mpi_comm_all,kind=MPI_KIND) ,my_peMPI ,mpierr)
    call mpi_comm_size(int(mpi_comm_all,kind=MPI_KIND) ,n_pesMPI ,mpierr)

    call mpi_comm_rank(int(mpi_comm_rows,kind=MPI_KIND) ,my_prowMPI ,mpierr)
    call mpi_comm_size(int(mpi_comm_rows,kind=MPI_KIND) ,np_rowsMPI ,mpierr)
    call mpi_comm_rank(int(mpi_comm_cols,kind=MPI_KIND) ,my_pcolMPI ,mpierr)
    call mpi_comm_size(int(mpi_comm_cols,kind=MPI_KIND) ,np_colsMPI ,mpierr)

    my_pe = int(my_peMPI, kind=c_int)
    n_pes = int(n_pesMPI, kind=c_int)
    my_prow = int(my_prowMPI, kind=c_int)
    np_rows = int(np_rowsMPI, kind=c_int)
    my_pcol = int(my_pcolMPI, kind=c_int)
    np_cols = int(np_colsMPI, kind=c_int)

    call obj%timer%stop("mpi_communication")

    na         = obj%na
    nev        = obj%nev
    nblk       = obj%nblk
    matrixCols = obj%local_ncols
    matrixRows = obj%local_nrows

    call obj%get("nbc_all_elpa2_main", non_blocking_collectives_all, error)
    if (error .ne. ELPA_OK) then
      write(error_unit,*) "ELPA2: Problem getting option for non blocking collectives. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

    endif

    if (non_blocking_collectives_all .eq. 1) then
      useNonBlockingCollectivesAll = .true.
    else
      useNonBlockingCollectivesAll = .false.
    endif

    ! openmp setting
    nrThreads = 1


    if (useGPU) then
      call obj%timer%start("check_for_gpu")
      if (check_for_gpu(obj, my_pe, numberOfGPUDevices, wantDebug=wantDebug)) then
        do_useGPU = .true.
        ! set the neccessary parameters
        call set_gpu_parameters()

      else
        write(error_unit,*) "ELPA2: GPUs are requested but not detected! Aborting..."
        call obj%timer%stop("check_for_gpu")
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

      endif
      call obj%timer%stop("check_for_gpu")

      if (nblk*(max(np_rows,np_cols)-1) >= na) then
        if (my_pe .eq. 0) then
          write(error_unit,*) "ELPA: Warning, block size too large for this matrix size and process grid!"
          write(error_unit,*) "Choose a smaller block size if possible.",nblk*(max(np_rows,np_cols)-1),na
          write(error_unit,*) "Disabling GPU usage! "
        endif

        do_useGPU = .false.
        if (kernel .eq. ELPA_2STAGE_REAL_NVIDIA_GPU) then
          if (userHasSetKernel) then
            ! user fixed inconsistent input.
            ! sadly, we do have to abort
            if (my_pe .eq. 0) then
              write(error_unit,*) "You set (fixed) the kernel to GPU, but GPUs cannot be used."
              write(error_unit,*) "Either adapt the block size or the process grid, or do not set the GPU kernel! Aborting..."
            endif
            stop 1
          else
            ! here we should set the default kernel
            kernel = ELPA_2STAGE_REAL_DEFAULT
          endif
        endif
      endif

    endif ! useGPU




    do_useGPU_bandred = do_useGPU
    do_useGPU_tridiag_band = .false.  ! not yet ported
    do_useGPU_solve_tridi = do_useGPU
    do_useGPU_trans_ev_tridi_to_band = do_useGPU
    do_useGPU_trans_ev_band_to_full = do_useGPU


   reDistributeMatrix = .false.


   allocate(aIntern(1:matrixRows,1:matrixCols))
   a       => aIntern(1:matrixRows,1:matrixCols)

   allocate(evIntern(1:obj%na))
   ev      => evIntern(1:obj%na)

   if (present(qExtern)) then
     allocate(qIntern(1:matrixRows,1:2*matrixCols))
   endif
   !TODO: intel gpu
   ! in case of devcice pointer _AND_ redistribute
   ! 1. copy aExtern to aIntern_dummy
   ! 2. redistribute aIntern_dummy to aIntern


   successGPU = gpu_memcpy(c_loc(aIntern(1,1)), aExtern, matrixRows*matrixCols*size_of_datatype, &
                             gpuMemcpyDeviceToHost)
   call check_memcpy_GPU_f("elpa2: aExtern -> aIntern", 548,  successGPU)


     a       => aIntern(1:matrixRows,1:matrixCols)
     if (present(qExtern)) then
       q       => qIntern(1:matrixRows,1:2*matrixCols)
     endif

   ev      => evIntern(1:obj%na)

   call obj%get("output_pinning_information", pinningInfo, error)
   if (error .ne. ELPA_OK) then
     write(error_unit,*) "ELPA2: Problem setting option for debug. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

   endif

   if (pinningInfo .eq. 1) then
     call init_thread_affinity(nrThreads)

     call check_thread_affinity()
     if (my_pe .eq. 0) call print_thread_affinity(my_pe)
     call cleanup_thread_affinity()
   endif

    success = .true.

    if (present(qExtern)) then
      obj%eigenvalues_only = .false.
    else
      obj%eigenvalues_only = .true.
    endif

   ! special case na = 1
   if (na .eq. 1) then
     ev(1) = a(1,1)
     if (.not.(obj%eigenvalues_only)) then
       q(1,1) = ONE
     endif

     ! restore original OpenMP settings

     call obj%timer%stop("elpa_solve_skew_evp_&
     &real&
     &_2stage_&
     &double&
     &")
     success = .true.
     return
   endif

   if (nev == 0) then
     nev = 1
     obj%eigenvalues_only = .true.
   endif

    !call obj%get("real_kernel", kernel, error)
    !if (error .ne. ELPA_OK) then
    !  print *,"Problem getting option for kernel settings. Aborting..."
    !  stop 1
    !endif

    !call obj%get("is_skewsymmetric",skewsymmetric,error)
    !if (error .ne. ELPA_OK) then
    !  print *,"Problem getting option for skewsymmetric settings. Aborting..."
    !  stop 1
    !endif
    !isSkewsymmetric = (skewsymmetric == 1)
    isSkewsymmetric = .true.

    ! only if we want (and can) use GPU in general, look what are the
    ! requirements for individual routines. Implicitly they are all set to 1, so
    ! unless specified otherwise by the user, GPU versions of all individual
    ! routines should be used
    if (do_useGPU) then
      call obj%get("gpu_bandred", gpu, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "ELPA2: Problem getting option gpu_bandred settings. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

      endif
      do_useGPU_bandred = (gpu == 1)

      ! not yet ported
      !call obj%get("gpu_tridiag_band", gpu, error)
      !if (error .ne. ELPA_OK) then
      !  print *,"Problem getting option for gpu_tridiag_band settings. Aborting..."
      !  stop 1
      !endif
      !do_useGPU_tridiag_band = (gpu == 1)

      call obj%get("gpu_solve_tridi", gpu, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "ELPA2: Problem getting option for gpu_solve_tridi settings. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

      endif
      do_useGPU_solve_tridi = (gpu == 1)

      call obj%get("gpu_trans_ev_tridi_to_band", gpu, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "ELPA2: Problem getting option for gpu_trans_ev_tridi_to_band settings. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

      endif
      do_useGPU_trans_ev_tridi_to_band = (gpu == 1)

      call obj%get("gpu_trans_ev_band_to_full", gpu, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "ELPA2: Problem getting option for gpu_trans_ev_band_to_full settings. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

      endif
      do_useGPU_trans_ev_band_to_full = (gpu == 1)
    endif

    ! check consistency between request for GPUs and defined kernel
    if (do_useGPU_trans_ev_tridi_to_band) then
      ! if the user has set explicitely a kernel before than honour this
      ! otherwise set GPU kernel
      if (userHasSetKernel) then
        if (kernel .ne. ELPA_2STAGE_REAL_NVIDIA_GPU) then
          write(error_unit,*) "ELPA: Warning, GPU usage has been requested but compute kernel is set by the user as non-GPU!"
          write(error_unit,*) "The compute kernel will be executed on CPUs!"
          do_useGPU_trans_ev_tridi_to_band = .false.
          kernel = ELPA_2STAGE_REAL_DEFAULT
        else
          good_nblk_gpu = .false.
        endif
      else ! userHasSetKernel
        !call obj%set("real_kernel", ELPA_2STAGE_REAL_NVIDIA_GPU, error)
        !if (error .ne. ELPA_OK) then
        !  write(error_unit,*) "Cannot set kernel to GPU kernel"
        !  stop 1
        !endif

        if (my_pe .eq. 0) write(error_unit,*) "You requested the GPU version, thus the GPU kernel is activated"
        good_nblk_gpu = .false.

        kernel = ELPA_2STAGE_REAL_NVIDIA_GPU
      endif ! userHasSetKernel

      ! Accepted values are 2,4,8,16,...,512
      do i = 1,10
        if (nblk == 2**i) then
          good_nblk_gpu = .true.
          exit
        endif
      enddo

      if (.not. good_nblk_gpu .and. do_useGPU_trans_ev_tridi_to_band) then
         write(error_unit,*) "ELPA: Warning, GPU kernel only works with block size 2^n (n = 1, 2, ..., 10)!"
         write(error_unit,*) "The compute kernel will be executed on CPUs!"
         write(error_unit,*) "We recommend changing the block size to 2^n"
         do_useGPU_trans_ev_tridi_to_band = .false.
         ! should be set
         kernel = ELPA_2STAGE_REAL_DEFAULT
      endif
    endif





    ! check again, now kernel and do_useGPU_trans_ev_tridi_to_band should be
    ! finally consistent
    if (do_useGPU_trans_ev_tridi_to_band) then
      !call obj%get("real_kernel", kernel, error)
      !if (error .ne. ELPA_OK) then
      !  write(error_unit,*) "Cannot get kernel to GPU kernel"
      !  stop 1
      !endif
      if (kernel .ne. ELPA_2STAGE_REAL_NVIDIA_GPU) then
        ! this should never happen, checking as an assert
        write(error_unit,*) "ELPA: INTERNAL ERROR setting GPU kernel!  Aborting..."
        stop 1
      endif
    else ! do not use GPU
      if (kernel .eq. ELPA_2STAGE_REAL_NVIDIA_GPU) then
        ! combination not allowed
        write(error_unit,*) "ELPA: Warning, GPU usage has NOT been requested but compute kernel &
                            &is defined as the GPU kernel!  Setting default kernel"
        kernel = ELPA_2STAGE_REAL_DEFAULT
        !TODO do error handling properly
      endif
    endif

    ! special case at the moment NO single precision kernels on POWER 8 -> set GENERIC for now
    if (kernel .eq. ELPA_2STAGE_REAL_VSX_BLOCK2 .or. &
        kernel .eq. ELPA_2STAGE_REAL_VSX_BLOCK4 .or. &
        kernel .eq. ELPA_2STAGE_REAL_VSX_BLOCK6        ) then
        write(error_unit,*) "ELPA: At the moment there exist no specific SINGLE precision kernels for POWER8"
        write(error_unit,*) "The GENERIC kernel will be used at the moment"
        kernel = ELPA_2STAGE_REAL_GENERIC
    endif
    ! special case at the moment NO single precision kernels on SPARC64 -> set GENERIC for now
    if (kernel .eq. ELPA_2STAGE_REAL_SPARC64_BLOCK2 .or. &
        kernel .eq. ELPA_2STAGE_REAL_SPARC64_BLOCK4 .or. &
        kernel .eq. ELPA_2STAGE_REAL_SPARC64_BLOCK6        ) then
        write(error_unit,*) "ELPA: At the moment there exist no specific SINGLE precision kernels for SPARC64"
        write(error_unit,*) "The GENERIC kernel will be used at the moment"
        kernel = ELPA_2STAGE_REAL_GENERIC
    endif


     !! consistency check: is user set kernel still identical with "kernel" or did
     !! we change it above? This is a mess and should be cleaned up
     !call obj%get("real_kernel",kernelByUser,error)
     !if (error .ne. ELPA_OK) then
     !  print *,"Problem getting option for user kernel settings. Aborting..."
     !  stop 1
     !endif

     !if (kernelByUser .ne. kernel) then
     !  call obj%set("real_kernel", kernel, error)
     !  if (error .ne. ELPA_OK) then
     !    print *,"Problem setting kernel. Aborting..."
     !    stop 1
     !  endif
     !endif


    call obj%get("qr",qr,error)
    if (error .ne. ELPA_OK) then
      print *,"ELPA2: Problem getting option for qr settings. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

    endif
    if (qr .eq. 1) then
      useQR = .true.
    else
      useQR = .false.
    endif

    useQRActual = .false.
    ! set usage of qr decomposition via API call
    if (useQR) useQRActual = .true.
    if (.not.(useQR)) useQRACtual = .false.

    if (useQRActual) then
      if (mod(na,2) .ne. 0) then
        if (wantDebug) then
          write(error_unit,*) "solve_evp_real_2stage: QR-decomposition: blocksize does not fit with matrixsize"
        endif
        write(error_unit,*) "Do not use QR-decomposition for this matrix and blocksize."
        success = .false.
        return
      endif
    endif

    if (.not. obj%eigenvalues_only) then
      q_actual => q(1:matrixRows,1:matrixCols)
    else
     allocate(q_dummy(1:matrixRows,1:matrixCols), stat=istat, errmsg=errorMessage)
     call check_allocate_f("elpa2_template: q_dummy", 998,  istat,  errorMessage)
     q_actual => q_dummy(1:matrixRows,1:matrixCols)
    endif

    ! set the default values for each of the 5 compute steps
    do_bandred        = .true.
    do_tridiag        = .true.
    do_solve_tridi    = .true.
    do_trans_to_band  = .true.
    do_trans_to_full  = .true.

    if (obj%eigenvalues_only) then
      do_trans_to_band  = .false.
      do_trans_to_full  = .false.
    endif

    if (obj%is_set("bandwidth") == 1) then
      ! bandwidth is set. That means, that the inputed matrix is actually banded and thus the
      ! first step of ELPA2 should be skipped
      call obj%get("bandwidth",nbw,error)
      if (nbw == 0) then
        if (wantDebug) then
          write(error_unit,*) "Specified bandwidth = 0; ELPA refuses to solve the eigenvalue problem ", &
                              "for a diagonal matrix! This is too simple"
          endif
          write(error_unit,*) "Specified bandwidth = 0; ELPA refuses to solve the eigenvalue problem ", &
                 "for a diagonal matrix! This is too simple"
        success = .false.
        return
      endif
      if (mod(nbw, nblk) .ne. 0) then
        ! treat matrix with an effective bandwidth slightly bigger than specified bandwidth
        ! such that effective bandwidth is a multiply of nblk. which is a prerequiste for ELPA
        nbw = nblk * ceiling(real(nbw,kind=c_double)/real(nblk,kind=c_double))

        ! just check that effective bandwidth is NOT larger than matrix size
        if (nbw .gt. na) then
          if (wantDebug) then
            write(error_unit,*) "Specified bandwidth ",nbw," leads internaly to a computed bandwidth ", &
                                "which is larger than the matrix size ",na," ! ELPA will abort! Try to", &
                                "solve your problem by not specifing a bandwidth"
          endif
          print *, "Specified bandwidth ",nbw," leads internaly to a computed bandwidth ", &
                                "which is larger than the matrix size ",na," ! ELPA will abort! Try to", &
                                "solve your problem by not specifing a bandwidth"
          success = .false.
          return
        endif
      endif
      do_bandred       = .false. ! we already have a banded matrix
      do_solve_tridi   = .true.  ! we also have to solve something :-)
      do_trans_to_band = .true.  ! and still we have to backsub to banded
      do_trans_to_full = .false. ! but not to full since we have a banded matrix
    else ! matrix is not banded, determine the intermediate bandwidth for full->banded->tridi
      !first check if the intermediate bandwidth was set by the user
      call obj%get("intermediate_bandwidth", nbw, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "Problem getting option for intermediate_bandwidth. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

      endif

      if(nbw == 0) then
        ! intermediate bandwidth was not specified, select one of the defaults

        ! Choose bandwidth, must be a multiple of nblk, set to a value >= 32
        ! On older systems (IBM Bluegene/P, Intel Nehalem) a value of 32 was optimal.
        ! For Intel(R) Xeon(R) E5 v2 and v3, better use 64 instead of 32!
        ! For IBM Bluegene/Q this is not clear at the moment. We have to keep an eye
        ! on this and maybe allow a run-time optimization here
        nbw = (63/nblk+1)*nblk
      else
        ! intermediate bandwidth has been specified by the user, check, whether correctly
        if (mod(nbw, nblk) .ne. 0) then
          print *, "Specified bandwidth ",nbw," has to be mutiple of the blocksize ", nblk, ". Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

        endif
      endif !nbw == 0

      num_blocks = (na-1)/nbw + 1

      ! tmat is needed only in full->band and band->full steps, so alocate here
      ! (not allocated for banded matrix on input)
      allocate(tmat(nbw,nbw,num_blocks), stat=istat, errmsg=errorMessage)
      call check_allocate_f("elpa2_template: tmat", 1085,  istat,  errorMessage)

      do_bandred       = .true.
      do_solve_tridi   = .true.
      do_trans_to_band = .true.
      do_trans_to_full = .true.
    endif  ! matrix not already banded on input

    ! start the computations in 5 steps
    if (do_bandred) then
      call obj%autotune_timer%start("full_to_band")
      call obj%timer%start("full_to_band")
      ! Reduction full -> band
      call bandred_&
      &real&
      &_&
      &double &
      (obj, na, a, &
      matrixRows, nblk, nbw, matrixCols, num_blocks, mpi_comm_rows, mpi_comm_cols, tmat, &
      wantDebug, do_useGPU_bandred, success, &
      useQRActual, &
       nrThreads, isSkewsymmetric)

      call obj%timer%stop("full_to_band")
      call obj%autotune_timer%stop("full_to_band")
  
      if (success) then
        success_int = 0
      else
        success_int = 1
      endif

      if (useNonBlockingCollectivesAll) then
        call mpi_iallreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), &
        allreduce_request2, mpierr)
        call mpi_wait(allreduce_request2, MPI_STATUS_IGNORE, mpierr)
      else
        call mpi_allreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), mpierr)
      endif
      if (success_int .eq. 1) then
        write(error_unit,*) "ELPA2: bandred returned an error. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

      endif
    endif

     ! Reduction band -> tridiagonal
     if (do_tridiag) then
       allocate(e(na), stat=istat, errmsg=errorMessage)
       call check_allocate_f("elpa2_template: e", 1143,  istat,  errorMessage)

       call obj%autotune_timer%start("band_to_tridi")
       call obj%timer%start("band_to_tridi")
       call tridiag_band_&
       &real&
       &_&
       &double&
       (obj, na, nbw, nblk, a, matrixRows, ev, e, matrixCols, hh_trans, mpi_comm_rows, mpi_comm_cols, mpi_comm_all, &
       do_useGPU_tridiag_band, wantDebug, nrThreads, isSkewsymmetric, success)
  
       if (success) then
         success_int = 0
       else
         success_int = 1
       endif

       if (useNonBlockingCollectivesAll) then
         call mpi_iallreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), &
         allreduce_request3, mpierr)
         call mpi_wait(allreduce_request3, MPI_STATUS_IGNORE, mpierr)
       else
         call mpi_allreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), mpierr)
       endif
       if (success_int .eq. 1) then
         write(error_unit,*) "Error in tridiag_band. Aborting..."
         return
       endif

       call obj%timer%start("mpi_communication")
       if (useNonBlockingCollectivesAll) then
         call mpi_ibcast(ev, int(na,kind=MPI_KIND), MPI_REAL8, 0_MPI_KIND, int(mpi_comm_all,kind=MPI_KIND), bcast_request1, mpierr)
         call mpi_ibcast(e, int(na,kind=MPI_KIND), MPI_REAL8, 0_MPI_KIND, int(mpi_comm_all,kind=MPI_KIND), bcast_request2, mpierr)

         call mpi_wait(bcast_request1, MPI_STATUS_IGNORE, mpierr)
         call mpi_wait(bcast_request2, MPI_STATUS_IGNORE, mpierr)
       else
         call mpi_bcast(ev, int(na,kind=MPI_KIND), MPI_REAL8, 0_MPI_KIND, int(mpi_comm_all,kind=MPI_KIND), mpierr)
         call mpi_bcast(e, int(na,kind=MPI_KIND), MPI_REAL8, 0_MPI_KIND, int(mpi_comm_all,kind=MPI_KIND), mpierr)
       endif
       call obj%timer%stop("mpi_communication")

       call obj%timer%stop("band_to_tridi")
       call obj%autotune_timer%stop("band_to_tridi")
     endif ! do_tridiag


     ! Solve tridiagonal system
     if (do_solve_tridi) then
       call obj%autotune_timer%start("solve")
       call obj%timer%start("solve")

       call solve_tridi_&
       &double &
       (obj, na, nev, ev, e, &
       q_actual, matrixRows,   &
       nblk, matrixCols, mpi_comm_all, mpi_comm_rows, mpi_comm_cols, do_useGPU_solve_tridi, wantDebug, &
               success, nrThreads)

       call obj%timer%stop("solve")
       call obj%autotune_timer%stop("solve")
  
       if (success) then
         success_int = 0
       else
         success_int = 1
       endif

       if (useNonBlockingCollectivesAll) then
         call mpi_iallreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), &
         allreduce_request4, mpierr)
         call mpi_wait(allreduce_request4, MPI_STATUS_IGNORE, mpierr)
       else
         call mpi_allreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), mpierr)
       endif

       if (success_int .eq. 1) then
         write(error_unit,*) "ELPA2: solve returned an error: Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

       endif
     endif ! do_solve_tridi

     deallocate(e, stat=istat, errmsg=errorMessage)
     call check_deallocate_f("elpa2_template: e", 1257,  istat,  errorMessage)

     if (obj%eigenvalues_only) then
       do_trans_to_band = .false.
       do_trans_to_full = .false.
     else
       call obj%get("check_pd",check_pd,error)
       if (error .ne. ELPA_OK) then
         write(error_unit,*) "Problem getting option for check_pd. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

       endif
       if (check_pd .eq. 1) then
         call obj%get("thres_pd_&
         &double&
         &",thres_pd,error)
         if (error .ne. ELPA_OK) then
            write(error_unit,*) "Problem getting option for thres_pd_&
            &double&
            &. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &double&
      &")
      success = .false.
      return

         endif

         check_pd = 0
         do i = 1, na
           if (ev(i) .gt. thres_pd) then
             check_pd = check_pd + 1
           endif
         enddo
         if (check_pd .lt. na) then
           ! not positiv definite => eigenvectors needed
           do_trans_to_band = .true.
           do_trans_to_full = .true.
         else
           do_trans_to_band = .false.
           do_trans_to_full = .false.
         endif
       endif
     endif ! eigenvalues only


       if (isSkewsymmetric) then
       ! Extra transformation step for skew-symmetric matrix. Multiplication with diagonal complex matrix D.
       ! This makes the eigenvectors complex.
       ! For now real part of eigenvectors is generated in first half of q, imaginary part in second part.
         q(1:matrixRows, matrixCols+1:2*matrixCols) = 0.0
         do i = 1, matrixRows
!          global_index = indxl2g(i, nblk, my_prow, 0, np_rows)
           global_index = np_rows*nblk*((i-1)/nblk) + MOD(i-1,nblk) + MOD(np_rows+my_prow-0, np_rows)*nblk + 1
           if (mod(global_index-1,4) .eq. 0) then
              ! do nothing
           end if
           if (mod(global_index-1,4) .eq. 1) then
              q(i,matrixCols+1:2*matrixCols) = q(i,1:matrixCols)
              q(i,1:matrixCols) = 0
           end if
           if (mod(global_index-1,4) .eq. 2) then
              q(i,1:matrixCols) = -q(i,1:matrixCols)
           end if
           if (mod(global_index-1,4) .eq. 3) then
              q(i,matrixCols+1:2*matrixCols) = -q(i,1:matrixCols)
              q(i,1:matrixCols) = 0
           end if
         end do
       endif

       ! Backtransform stage 1
     if (do_trans_to_band) then

       !debug
!#if defined(WITH_OPENMP_OFFLOAD_GPU_VERSION) || defined(WITH_SYCL_GPU_VERSION)
       !if (gpu_vendor() == OPENMP_OFFLOAD_GPU .or. gpu_vendor() == SYCL_GPU) then
       call obj%autotune_timer%start("tridi_to_band")
       call obj%timer%start("tridi_to_band")
       ! In the skew-symmetric case this transforms the real part
       call trans_ev_tridi_to_band_&
       &real&
       &_&
       &double &
       (obj, na, nev, nblk, nbw, q, &
       matrixRows, matrixCols, hh_trans, my_pe, mpi_comm_rows, mpi_comm_cols, &
       wantDebug, do_useGPU_trans_ev_tridi_to_band, &
       nrThreads, success=success, kernel=kernel)
       call obj%timer%stop("tridi_to_band")
       call obj%autotune_timer%stop("tridi_to_band")

       if (success) then
         success_int = 0
       else
         success_int = 1
       endif

       if (useNonBlockingCollectivesAll) then
         call mpi_iallreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), &
         allreduce_request5, mpierr)
         call mpi_wait(allreduce_request5, MPI_STATUS_IGNORE, mpierr)
       else
         call mpi_allreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), mpierr)
       endif

       if (success_int .eq. 1) then
         write(error_unit,*) "ELPA2: trans_ev_tridi_to_band returned an error. Aborting..."
         return
       endif

     endif ! do_trans_to_band

     ! the array q (currently) always resides on host even when using GPU

     if (do_trans_to_full) then
       call obj%autotune_timer%start("band_to_full")
       call obj%timer%start("band_to_full")
       ! Backtransform stage 2
       ! In the skew-symemtric case this transforms the real part
       call trans_ev_band_to_full_&
       &real&
       &_&
       &double &
       (obj, na, nev, nblk, nbw, a, &
       matrixRows, tmat, q,  &
       matrixRows, matrixCols, num_blocks, mpi_comm_rows, mpi_comm_cols, do_useGPU_trans_ev_band_to_full &
       , useQRActual  &
       , success)
       call obj%timer%stop("band_to_full")
       call obj%autotune_timer%stop("band_to_full")

       if (success) then
         success_int = 0
       else
         success_int = 1
       endif

       if (useNonBlockingCollectivesAll) then
         call mpi_iallreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), &
         allreduce_request6, mpierr)
         call mpi_wait(allreduce_request6, MPI_STATUS_IGNORE, mpierr)
       else
         call mpi_allreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), mpierr)
       endif
       if (success_int .eq. 1) then
         write(error_unit,*) "Error in trans_ev_band_to_full. Aborting..."
         return
       endif
     endif ! do_trans_to_full
! #ifdef 
!        call prmat(na,useGPU,q(1:matrixRows, 1:matrixCols),q_dev,matrixRows,matrixCols,nblk,my_prow,my_pcol,np_rows,np_cols,'R',1)
! #endif


     !skew symmetric imaginary part for tridi_to_band and band_to_full
     if (isSkewsymmetric) then
       if (do_trans_to_band) then
         call obj%autotune_timer%start("tridi_to_band")
         call obj%timer%start("skew_tridi_to_band")
         ! Transform imaginary part
         ! Transformation of real and imaginary part could also be one call of trans_ev_tridi acting on the n x 2n matrix.
         call trans_ev_tridi_to_band_&
         &real&
         &_&
         &double &
         (obj, na, nev, nblk, nbw, q(1:matrixRows, matrixCols+1:2*matrixCols), &
         matrixRows, matrixCols, hh_trans, my_pe, mpi_comm_rows, mpi_comm_cols, &
         wantDebug, do_useGPU_trans_ev_tridi_to_band, &
         nrThreads, success=success, kernel=kernel)

         call obj%timer%stop("skew_tridi_to_band")
         call obj%autotune_timer%stop("tridi_to_band")

         if (success) then
           success_int = 0
         else
           success_int = 1
         endif

         if (useNonBlockingCollectivesAll) then
           call mpi_iallreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), &
           allreduce_request7, mpierr)
           call mpi_wait(allreduce_request7, MPI_STATUS_IGNORE, mpierr)
         else
           call mpi_allreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), mpierr)
         endif
         if (success_int .eq. 1) then
          write(error_unit,*) "Error in trans_ev_tridi_to_band (imaginary part). Aborting..."
          return
         endif
       endif ! do_trans_tridi_to_band

       if (do_trans_to_full) then
       call obj%autotune_timer%start("band_to_full")
       call obj%timer%start("band_to_full")
         ! Transform imaginary part
         ! Transformation of real and imaginary part could also be one call of trans_ev_band_to_full_ acting on the n x 2n matrix.
         call trans_ev_band_to_full_&
         &real&
         &_&
         &double &
         (obj, na, nev, nblk, nbw, a, &
         matrixRows, tmat, q(1:matrixRows, matrixCols+1:2*matrixCols),  &
         matrixRows, matrixCols, num_blocks, mpi_comm_rows, mpi_comm_cols, do_useGPU_trans_ev_band_to_full, &
         useQRActual, &
         success)

         call obj%timer%stop("band_to_full")
         call obj%autotune_timer%stop("band_to_full")

         if (success) then
           success_int = 0
         else
           success_int = 1
         endif

         if (useNonBlockingCollectivesAll) then
           call mpi_iallreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), &
           allreduce_request8, mpierr)
           call mpi_wait(allreduce_request8, MPI_STATUS_IGNORE, mpierr)
         else
           call mpi_allreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), mpierr)
         endif
         if (success_int .eq. 1) then
          write(error_unit,*) "Error in trans_ev_band_to_full (imaginary part). Aborting..."
          return
         endif
       endif ! do_trans_to_full
     endif ! isSkewSymmetric


     ! We can now deallocate the stored householder vectors
     deallocate(hh_trans, stat=istat, errmsg=errorMessage)
     call check_deallocate_f("elpa2_template: hh_trans", 1537,  istat,  errorMessage)

     ! make sure tmat is deallocated when using check_pd
     if (allocated(tmat)) then
       deallocate(tmat, stat=istat, errmsg=errorMessage)
       call check_deallocate_f("elpa2_template: tmat", 1542,  istat,  errorMessage)
     endif

     if (obj%eigenvalues_only) then
       deallocate(q_dummy, stat=istat, errmsg=errorMessage)
       call check_deallocate_f("elpa2_template: q_dummy", 1547,  istat,  errorMessage)
     endif

     ! restore original OpenMP settings



   !copy qIntern and ev to provided device pointers
   if (present(qExtern)) then
   successGPU = gpu_memcpy(qExtern, c_loc(qIntern(1,1)), obj%local_nrows*obj%local_ncols*size_of_datatype, &
                             gpuMemcpyHostToDevice)
   endif
   call check_memcpy_GPU_f("elpa1: qIntern -> qExtern", 1607,  successGPU)
   successGPU = gpu_memcpy(evExtern, c_loc(ev(1)), obj%na*size_of_real_datatype, &
                             gpuMemcpyHostToDevice)
   call check_memcpy_GPU_f("elpa1: ev -> evExtern", 1610,  successGPU)


     deallocate(aIntern)
     !deallocate(evIntern)
     nullify(evIntern)
     if (present(qExtern)) then
       deallocate(qIntern)
     endif



   nullify(ev)
   nullify(a)
   nullify(q)

  nullify(q_actual)

     call obj%timer%stop("elpa_solve_skew_evp_&
     &real&
     &_2stage_&
     &double&
     &")
1    format(a,f10.3)

   end function

! vim: syntax=fortran



















!-------------------------------------------------------------------------------
!>  \brief elpa_solve_skew_evp_real_2stage_host_arrays_single_impl: Fortran function to solve the single-precision real skew-symmetric eigenvalue problem with a 2 stage approach
!>
!>  Parameters
!>
!>  \param na                                   Order of matrix a
!>
!>  \param nev                                  Number of eigenvalues needed
!>
!>  \param a(lda,matrixCols)                    Distributed matrix for which eigenvalues are to be computed.
!>                                              Distribution is like in Scalapack.
!>                                              The full matrix must be set (not only one half like in scalapack).
!>                                              Destroyed on exit (upper and lower half).
!>
!>  \param lda                                  Leading dimension of a
!>
!>  \param ev(na)                               On output: eigenvalues of a, every processor gets the complete set
!>
!>  \param q(ldq,matrixCols)                    On output: Eigenvectors of a
!>                                              Distribution is like in Scalapack.
!>                                              Must be always dimensioned to the full size (corresponding to (na,na))
!>                                              even if only a part of the eigenvalues is needed.
!>
!>  \param ldq                                  Leading dimension of q
!>
!>  \param nblk                                 blocksize of cyclic distribution, must be the same in both directions!
!>
!>  \param matrixCols                           local columns of matrix a and q
!>
!>  \param mpi_comm_rows                        MPI communicator for rows
!>  \param mpi_comm_cols                        MPI communicator for columns
!>  \param mpi_comm_all                         MPI communicator for the total processor set
!>
!>  \param kernel                               specify ELPA2 kernel to use
!>
!>  \param useQR (optional)                     use QR decomposition
!>  \param useGPU (optional)                    decide whether GPUs should be used or not
!>
!>  \result success                             logical, false if error occured
!-------------------------------------------------------------------------------


!cannot use "../src/elpa2/../general/error_checking.inc" because filename with path can be too long for gfortran (max line length)


 function elpa_solve_skew_evp_&
  &real&
  &_&
  &2stage_a_h_a_&
  &single&
  &_impl (obj, &
   aExtern, &
   evExtern, &
   qExtern) result(success)

   !use matrix_plot
   use elpa_abstract_impl
   use elpa_utilities
   use elpa1_compute
   use elpa2_compute
   use elpa_mpi
   use cuda_functions
   use hip_functions
   use elpa_gpu
   use mod_check_for_gpu
   use elpa_omp
   use solve_tridi
   use thread_affinity
   use, intrinsic :: iso_c_binding
   implicit none
!    Copyright 2011, A. Marek
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
!
  integer, parameter :: rk = C_FLOAT
  integer, parameter :: rck = C_FLOAT
  real(kind=rck), parameter      :: ZERO=0.0_rk, ONE = 1.0_rk

   class(elpa_abstract_impl_t), intent(inout)                         :: obj
   logical                                                            :: useGPU
   logical                                                            :: isSkewsymmetric
   logical                                                            :: useQR
   logical                                                            :: useQRActual
   integer(kind=c_int)                                                :: kernel, kernelByUser
   logical                                                            :: userHasSetKernel

   
!#ifdef REDISTRIBUTE_MATRIX

   real(kind=c_float), intent(inout), target         :: aExtern(obj%local_nrows,*)
   real(kind=c_float), optional, intent(out), target :: qExtern(obj%local_nrows,*)

!#else 
!
!#ifdef 1
!   real(kind=c_float), intent(inout)                 :: a(obj%local_nrows,*)
!   real(kind=c_float), optional, intent(out), target :: q(obj%local_nrows,*)
!#else
!   real(kind=c_float), intent(inout)                 :: a(obj%local_nrows,obj%local_ncols)
!#ifdef 
!   real(kind=c_float), optional, target, intent(out) :: q(obj%local_nrows,2*obj%local_ncols)
!#else
!   real(kind=c_float), optional, target, intent(out) :: q(obj%local_nrows,obj%local_ncols)
!#endif
!#endif
!
!#endif 


    real(kind=rck), pointer                                  :: a(:,:)
    real(kind=rck), pointer                                  :: q(:,:)
    real(kind=rk4), pointer                                  :: ev(:)

   real(kind=c_float), target, intent(inout)                  :: evExtern(obj%na)

   real(kind=c_float), allocatable                   :: hh_trans(:,:)

   integer(kind=c_int)                                                :: my_pe, n_pes, my_prow, my_pcol, np_rows, np_cols
   integer(kind=MPI_KIND)                                             :: my_peMPI, n_pesMPI, my_prowMPI, my_pcolMPI, &
                                                                         np_rowsMPI, np_colsMPI, mpierr
   integer(kind=c_int)                                                :: nbw, num_blocks
   real(kind=c_float), allocatable                   :: tmat(:,:,:)
   real(kind=c_float), allocatable                            :: e(:)
   real(kind=c_float), allocatable, target           :: q_dummy(:,:)
   real(kind=c_float), pointer                       :: q_actual(:,:)


   integer(kind=c_int)                                                :: i
   logical                                                            :: success, successGPU
   integer(kind=c_int)                                                :: success_int
   logical                                                            :: wantDebug
   integer(kind=c_int)                                                :: istat, gpu, skewsymmetric, debug, qr
   character(200)                                                     :: errorMessage
   logical                                                            :: do_useGPU, do_useGPU_bandred, &
                                                                         do_useGPU_tridiag_band, do_useGPU_solve_tridi, &
                                                                         do_useGPU_trans_ev_tridi_to_band, &
                                                                         do_useGPU_trans_ev_band_to_full
   integer(kind=c_int)                                                :: numberOfGPUDevices
   integer(kind=c_intptr_t), parameter                                :: size_of_datatype = size_of_&
                                                                                            &single&
                                                                                            &_&
                                                                                            &real
   integer(kind=c_intptr_t), parameter                                :: size_of_real_datatype = size_of_&
                                                                                                 &single&
                                                                                                 &_real
   integer(kind=ik)                                                   :: na, nev, nblk, matrixCols, &
                                                                         mpi_comm_rows, mpi_comm_cols,        &
                                                                         mpi_comm_all, check_pd, error, matrixRows
   real(kind=c_float)                                         :: thres_pd

   real(kind=rck), pointer                                   :: aIntern(:,:)
   real(kind=c_float), pointer                       :: qIntern(:,:)
   real(kind=rk4), pointer                                  :: evIntern(:)

   logical                                                            :: do_bandred, do_tridiag, do_solve_tridi,  &
                                                                         do_trans_to_band, do_trans_to_full
   logical                                                            :: good_nblk_gpu

   integer(kind=ik)                                                   :: nrThreads, limitThreads
   integer(kind=ik)                                                   :: global_index
   logical                                                            :: reDistributeMatrix, doRedistributeMatrix
   integer(kind=ik)                                                   :: pinningInfo

   integer(kind=MPI_KIND)                                             :: bcast_request1, bcast_request2, allreduce_request1, &
                                                                         allreduce_request2, allreduce_request3, &
                                                                         allreduce_request4, allreduce_request5, &
                                                                         allreduce_request6, allreduce_request7, &
                                                                         allreduce_request8
   logical                                                            :: useNonBlockingCollectivesAll
   integer(kind=ik)                                                   :: gpu_old, gpu_new
   integer(kind=ik)                                                   :: non_blocking_collectives_all













    call obj%timer%start("elpa_solve_skew_evp_&
    &real&
    &_2stage_&
    &single&
    &")

    call obj%get("debug",debug, error)
    if (error .ne. ELPA_OK) then
      write(error_unit,*) "ELPA2: Problem getting option for debug settings. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

    endif

    wantDebug = debug == 1

    ! check legacy GPU setings
    ! check legacy GPU setings
    if (obj%is_set("gpu") == 1) then
      write(error_unit,*) "You still use the deprecated option 'gpu', consider switching to 'nvidia-gpu'"
      call obj%get("gpu", gpu_old, error)     
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "GPU_SOLVER : Problem getting option for gpu. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_skew_evp_&
     &real&
     &_1stage_&
     &single&
     &")
     success = .false.
     return
      endif
      if (obj%is_set("nvidia-gpu") == 0) then
        ! set gpu and nvidia-gpu consistent
        call obj%set("nvidia-gpu", gpu_old, error)
        if (error .ne. ELPA_OK) then
          write(error_unit,*) "GPU_SOLVER : Problem setting option for nvidia-gpu. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_skew_evp_&
     &real&
     &_1stage_&
     &single&
     &")
     success = .false.
     return
        endif
        write(error_unit,*) "Will set the new keyword 'nvidia-gpu' now."
        write(error_unit,*) "And ignore the 'gpu' keyword from now on"
      else ! obj%is_set("nvidia-gpu") == 0
        call obj%get("nvidia-gpu", gpu_new, error)
        if (error .ne. ELPA_OK) then
          write(error_unit,*) "GPU_SOLVER : Problem getting option for nvidia-gpu. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_skew_evp_&
     &real&
     &_1stage_&
     &single&
     &")
     success = .false.
     return
        endif
        if (gpu_old .ne. gpu_new) then
                write(error_unit,*) "Please do not set 'gpu' but 'nvidia-gpu' instead"
          write(error_unit,*) "You cannot set gpu = ",gpu_old," and nvidia-gpu=",gpu_new,". Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_skew_evp_&
     &real&
     &_1stage_&
     &single&
     &")
     success = .false.
     return
        endif
      endif ! obj%is_set("nvidia-gpu") == 0
      if (obj%is_set("amd-gpu") == 0) then
        ! amd-gpu is not set, but gpu is set
        ! this is ok in anycase
      else ! obj%is_set("amd-gpu") == 0
        call obj%get("amd-gpu", gpu_new, error)
        if (error .ne. ELPA_OK) then
          write(error_unit,*) "GPU_SOLVER : Problem getting option for amd-gpu. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_skew_evp_&
     &real&
     &_1stage_&
     &single&
     &")
     success = .false.
     return
        endif
        ! this is ok, if gpu == 0 and amd-gpu == 1 or
        !             if gpu == 0 and amd-gpu == 0 or
        !             if gpu == 1 and amd-gpu == 0
        if (gpu_old .eq. 1 .and. gpu_new .eq. 1) then
          write(error_unit,*) "GPU_SOLVER : You cannot set gpu = 1 and amd-gpu = 1. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_skew_evp_&
     &real&
     &_1stage_&
     &single&
     &")
     success = .false.
     return
        endif
      endif ! amd-gpu
      if (obj%is_set("intel-gpu") == 0) then
        ! intel-gpu is not set, but gpu is set
        ! this is ok in anycase
      else ! obj%is_set("intel-gpu") == 0
        call obj%get("intel-gpu", gpu_new, error)
        if (error .ne. ELPA_OK) then
          write(error_unit,*) "GPU_SOLVER : Problem getting option for intel-gpu. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_skew_evp_&
     &real&
     &_1stage_&
     &single&
     &")
     success = .false.
     return
        endif
        ! this is ok, if gpu == 0 and intel-gpu == 1 or
        !             if gpu == 0 and intel-gpu == 0 or
        !             if gpu == 1 and intel-gpu == 0
        if (gpu_old .eq. 1 .and. gpu_new .eq. 1) then
          write(error_unit,*) "GPU_SOLVER : You cannot set gpu = 1 and intel-gpu = 1. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_skew_evp_&
     &real&
     &_1stage_&
     &single&
     &")
     success = .false.
     return
        endif
      endif ! intel-gpu
    else ! gpu not set
      ! nothing to do since the legacy option is not set
    endif ! gpu is set

    ! GPU settings
    if (gpu_vendor() == NVIDIA_GPU) then
      call obj%get("nvidia-gpu", gpu, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "GPU_SOLVER : Problem getting option for NVIDIA GPU. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_skew_evp_&
     &real&
     &_1stage_&
     &single&
     &")
     success = .false.
     return
      endif
    else if (gpu_vendor() == AMD_GPU) then
      call obj%get("amd-gpu", gpu, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "GPU_SOLVER : Problem getting option for AMD GPU. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_skew_evp_&
     &real&
     &_1stage_&
     &single&
     &")
     success = .false.
     return
      endif
    else if (gpu_vendor() == INTEL_GPU) then
      call obj%get("intel-gpu", gpu, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "GPU_SOLVER : Problem getting option for INTEL GPU. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_skew_evp_&
     &real&
     &_1stage_&
     &single&
     &")
     success = .false.
     return
      endif
    else ! no supported gpu
      gpu = 0
    endif

   if (gpu .eq. 1) then
     useGPU =.true.
   else
     useGPU = .false.
   endif


    do_useGPU = .false.

    ! get the kernel and check whether it has been set by the user
    if (obj%is_set("real_kernel") == 1) then
      userHasSetKernel = .true.
    else
      userHasSetKernel = .false.
    endif

    ! after this point you may _never_ call get for the kernel again, or set the
    ! kernel !! The reason is that we might have to adjust the kernel, which is
    ! passed as a variable
    call obj%get("real_kernel", kernel, error)
    if (error .ne. ELPA_OK) then
      write(error_unit,*) "ELPA2: Problem getting option for kernel settings. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

    endif

    ! to implement a possibiltiy to set this
    useNonBlockingCollectivesAll = .false.

    call obj%get("mpi_comm_rows",mpi_comm_rows, error)
    if (error .ne. ELPA_OK) then
      write(error_unit,*) "ELPA2: Problem getting option for mpi_comm_rows. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

    endif
    call obj%get("mpi_comm_cols",mpi_comm_cols,error)
    if (error .ne. ELPA_OK) then
      write(error_unit,*) "ELPA2: Problem getting option for mpi_comm_cols. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

    endif
    call obj%get("mpi_comm_parent",mpi_comm_all,error)
    if (error .ne. ELPA_OK) then
      write(error_unit,*) "ELPA2: Problem getting option for mpi_comm_parent. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

    endif

    call obj%timer%start("mpi_communication")
    call mpi_comm_rank(int(mpi_comm_all,kind=MPI_KIND) ,my_peMPI ,mpierr)
    call mpi_comm_size(int(mpi_comm_all,kind=MPI_KIND) ,n_pesMPI ,mpierr)

    call mpi_comm_rank(int(mpi_comm_rows,kind=MPI_KIND) ,my_prowMPI ,mpierr)
    call mpi_comm_size(int(mpi_comm_rows,kind=MPI_KIND) ,np_rowsMPI ,mpierr)
    call mpi_comm_rank(int(mpi_comm_cols,kind=MPI_KIND) ,my_pcolMPI ,mpierr)
    call mpi_comm_size(int(mpi_comm_cols,kind=MPI_KIND) ,np_colsMPI ,mpierr)

    my_pe = int(my_peMPI, kind=c_int)
    n_pes = int(n_pesMPI, kind=c_int)
    my_prow = int(my_prowMPI, kind=c_int)
    np_rows = int(np_rowsMPI, kind=c_int)
    my_pcol = int(my_pcolMPI, kind=c_int)
    np_cols = int(np_colsMPI, kind=c_int)

    call obj%timer%stop("mpi_communication")

    na         = obj%na
    nev        = obj%nev
    nblk       = obj%nblk
    matrixCols = obj%local_ncols
    matrixRows = obj%local_nrows

    call obj%get("nbc_all_elpa2_main", non_blocking_collectives_all, error)
    if (error .ne. ELPA_OK) then
      write(error_unit,*) "ELPA2: Problem getting option for non blocking collectives. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

    endif

    if (non_blocking_collectives_all .eq. 1) then
      useNonBlockingCollectivesAll = .true.
    else
      useNonBlockingCollectivesAll = .false.
    endif

    ! openmp setting
    nrThreads = 1


    if (useGPU) then
      call obj%timer%start("check_for_gpu")
      if (check_for_gpu(obj, my_pe, numberOfGPUDevices, wantDebug=wantDebug)) then
        do_useGPU = .true.
        ! set the neccessary parameters
        call set_gpu_parameters()

      else
        write(error_unit,*) "ELPA2: GPUs are requested but not detected! Aborting..."
        call obj%timer%stop("check_for_gpu")
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

      endif
      call obj%timer%stop("check_for_gpu")

      if (nblk*(max(np_rows,np_cols)-1) >= na) then
        if (my_pe .eq. 0) then
          write(error_unit,*) "ELPA: Warning, block size too large for this matrix size and process grid!"
          write(error_unit,*) "Choose a smaller block size if possible.",nblk*(max(np_rows,np_cols)-1),na
          write(error_unit,*) "Disabling GPU usage! "
        endif

        do_useGPU = .false.
        if (kernel .eq. ELPA_2STAGE_REAL_NVIDIA_GPU) then
          if (userHasSetKernel) then
            ! user fixed inconsistent input.
            ! sadly, we do have to abort
            if (my_pe .eq. 0) then
              write(error_unit,*) "You set (fixed) the kernel to GPU, but GPUs cannot be used."
              write(error_unit,*) "Either adapt the block size or the process grid, or do not set the GPU kernel! Aborting..."
            endif
            stop 1
          else
            ! here we should set the default kernel
            kernel = ELPA_2STAGE_REAL_DEFAULT
          endif
        endif
      endif

    endif ! useGPU




    do_useGPU_bandred = do_useGPU
    do_useGPU_tridiag_band = .false.  ! not yet ported
    do_useGPU_solve_tridi = do_useGPU
    do_useGPU_trans_ev_tridi_to_band = do_useGPU
    do_useGPU_trans_ev_band_to_full = do_useGPU


   reDistributeMatrix = .false.



   ! aIntern, qIntern, are normally pointers since no matrix redistribution is used
   ! point them to  the external arrays
   aIntern => aExtern(1:matrixRows,1:matrixCols)
   if (present(qExtern)) then
     qIntern => qExtern(1:matrixRows,1:2*matrixCols)
   endif

  ! whether a matrix redistribution or not is happening we still
  ! have to point ev
   evIntern => evExtern(1:obj%na)

     a       => aIntern(1:matrixRows,1:matrixCols)
     if (present(qExtern)) then
       q       => qIntern(1:matrixRows,1:2*matrixCols)
     endif

   ev      => evIntern(1:obj%na)

   call obj%get("output_pinning_information", pinningInfo, error)
   if (error .ne. ELPA_OK) then
     write(error_unit,*) "ELPA2: Problem setting option for debug. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

   endif

   if (pinningInfo .eq. 1) then
     call init_thread_affinity(nrThreads)

     call check_thread_affinity()
     if (my_pe .eq. 0) call print_thread_affinity(my_pe)
     call cleanup_thread_affinity()
   endif

    success = .true.

    if (present(qExtern)) then
      obj%eigenvalues_only = .false.
    else
      obj%eigenvalues_only = .true.
    endif

   ! special case na = 1
   if (na .eq. 1) then
     ev(1) = a(1,1)
     if (.not.(obj%eigenvalues_only)) then
       q(1,1) = ONE
     endif

     ! restore original OpenMP settings

     call obj%timer%stop("elpa_solve_skew_evp_&
     &real&
     &_2stage_&
     &single&
     &")
     success = .true.
     return
   endif

   if (nev == 0) then
     nev = 1
     obj%eigenvalues_only = .true.
   endif

    !call obj%get("real_kernel", kernel, error)
    !if (error .ne. ELPA_OK) then
    !  print *,"Problem getting option for kernel settings. Aborting..."
    !  stop 1
    !endif

    !call obj%get("is_skewsymmetric",skewsymmetric,error)
    !if (error .ne. ELPA_OK) then
    !  print *,"Problem getting option for skewsymmetric settings. Aborting..."
    !  stop 1
    !endif
    !isSkewsymmetric = (skewsymmetric == 1)
    isSkewsymmetric = .true.

    ! only if we want (and can) use GPU in general, look what are the
    ! requirements for individual routines. Implicitly they are all set to 1, so
    ! unless specified otherwise by the user, GPU versions of all individual
    ! routines should be used
    if (do_useGPU) then
      call obj%get("gpu_bandred", gpu, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "ELPA2: Problem getting option gpu_bandred settings. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

      endif
      do_useGPU_bandred = (gpu == 1)

      ! not yet ported
      !call obj%get("gpu_tridiag_band", gpu, error)
      !if (error .ne. ELPA_OK) then
      !  print *,"Problem getting option for gpu_tridiag_band settings. Aborting..."
      !  stop 1
      !endif
      !do_useGPU_tridiag_band = (gpu == 1)

      call obj%get("gpu_solve_tridi", gpu, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "ELPA2: Problem getting option for gpu_solve_tridi settings. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

      endif
      do_useGPU_solve_tridi = (gpu == 1)

      call obj%get("gpu_trans_ev_tridi_to_band", gpu, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "ELPA2: Problem getting option for gpu_trans_ev_tridi_to_band settings. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

      endif
      do_useGPU_trans_ev_tridi_to_band = (gpu == 1)

      call obj%get("gpu_trans_ev_band_to_full", gpu, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "ELPA2: Problem getting option for gpu_trans_ev_band_to_full settings. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

      endif
      do_useGPU_trans_ev_band_to_full = (gpu == 1)
    endif

    ! check consistency between request for GPUs and defined kernel
    if (do_useGPU_trans_ev_tridi_to_band) then
      ! if the user has set explicitely a kernel before than honour this
      ! otherwise set GPU kernel
      if (userHasSetKernel) then
        if (kernel .ne. ELPA_2STAGE_REAL_NVIDIA_GPU) then
          write(error_unit,*) "ELPA: Warning, GPU usage has been requested but compute kernel is set by the user as non-GPU!"
          write(error_unit,*) "The compute kernel will be executed on CPUs!"
          do_useGPU_trans_ev_tridi_to_band = .false.
          kernel = ELPA_2STAGE_REAL_DEFAULT
        else
          good_nblk_gpu = .false.
        endif
      else ! userHasSetKernel
        !call obj%set("real_kernel", ELPA_2STAGE_REAL_NVIDIA_GPU, error)
        !if (error .ne. ELPA_OK) then
        !  write(error_unit,*) "Cannot set kernel to GPU kernel"
        !  stop 1
        !endif

        if (my_pe .eq. 0) write(error_unit,*) "You requested the GPU version, thus the GPU kernel is activated"
        good_nblk_gpu = .false.

        kernel = ELPA_2STAGE_REAL_NVIDIA_GPU
      endif ! userHasSetKernel

      ! Accepted values are 2,4,8,16,...,512
      do i = 1,10
        if (nblk == 2**i) then
          good_nblk_gpu = .true.
          exit
        endif
      enddo

      if (.not. good_nblk_gpu .and. do_useGPU_trans_ev_tridi_to_band) then
         write(error_unit,*) "ELPA: Warning, GPU kernel only works with block size 2^n (n = 1, 2, ..., 10)!"
         write(error_unit,*) "The compute kernel will be executed on CPUs!"
         write(error_unit,*) "We recommend changing the block size to 2^n"
         do_useGPU_trans_ev_tridi_to_band = .false.
         ! should be set
         kernel = ELPA_2STAGE_REAL_DEFAULT
      endif
    endif





    ! check again, now kernel and do_useGPU_trans_ev_tridi_to_band should be
    ! finally consistent
    if (do_useGPU_trans_ev_tridi_to_band) then
      !call obj%get("real_kernel", kernel, error)
      !if (error .ne. ELPA_OK) then
      !  write(error_unit,*) "Cannot get kernel to GPU kernel"
      !  stop 1
      !endif
      if (kernel .ne. ELPA_2STAGE_REAL_NVIDIA_GPU) then
        ! this should never happen, checking as an assert
        write(error_unit,*) "ELPA: INTERNAL ERROR setting GPU kernel!  Aborting..."
        stop 1
      endif
    else ! do not use GPU
      if (kernel .eq. ELPA_2STAGE_REAL_NVIDIA_GPU) then
        ! combination not allowed
        write(error_unit,*) "ELPA: Warning, GPU usage has NOT been requested but compute kernel &
                            &is defined as the GPU kernel!  Setting default kernel"
        kernel = ELPA_2STAGE_REAL_DEFAULT
        !TODO do error handling properly
      endif
    endif

    ! special case at the moment NO single precision kernels on POWER 8 -> set GENERIC for now
    if (kernel .eq. ELPA_2STAGE_REAL_VSX_BLOCK2 .or. &
        kernel .eq. ELPA_2STAGE_REAL_VSX_BLOCK4 .or. &
        kernel .eq. ELPA_2STAGE_REAL_VSX_BLOCK6        ) then
        write(error_unit,*) "ELPA: At the moment there exist no specific SINGLE precision kernels for POWER8"
        write(error_unit,*) "The GENERIC kernel will be used at the moment"
        kernel = ELPA_2STAGE_REAL_GENERIC
    endif
    ! special case at the moment NO single precision kernels on SPARC64 -> set GENERIC for now
    if (kernel .eq. ELPA_2STAGE_REAL_SPARC64_BLOCK2 .or. &
        kernel .eq. ELPA_2STAGE_REAL_SPARC64_BLOCK4 .or. &
        kernel .eq. ELPA_2STAGE_REAL_SPARC64_BLOCK6        ) then
        write(error_unit,*) "ELPA: At the moment there exist no specific SINGLE precision kernels for SPARC64"
        write(error_unit,*) "The GENERIC kernel will be used at the moment"
        kernel = ELPA_2STAGE_REAL_GENERIC
    endif


     !! consistency check: is user set kernel still identical with "kernel" or did
     !! we change it above? This is a mess and should be cleaned up
     !call obj%get("real_kernel",kernelByUser,error)
     !if (error .ne. ELPA_OK) then
     !  print *,"Problem getting option for user kernel settings. Aborting..."
     !  stop 1
     !endif

     !if (kernelByUser .ne. kernel) then
     !  call obj%set("real_kernel", kernel, error)
     !  if (error .ne. ELPA_OK) then
     !    print *,"Problem setting kernel. Aborting..."
     !    stop 1
     !  endif
     !endif


    call obj%get("qr",qr,error)
    if (error .ne. ELPA_OK) then
      print *,"ELPA2: Problem getting option for qr settings. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

    endif
    if (qr .eq. 1) then
      useQR = .true.
    else
      useQR = .false.
    endif

    useQRActual = .false.
    ! set usage of qr decomposition via API call
    if (useQR) useQRActual = .true.
    if (.not.(useQR)) useQRACtual = .false.

    if (useQRActual) then
      if (mod(na,2) .ne. 0) then
        if (wantDebug) then
          write(error_unit,*) "solve_evp_real_2stage: QR-decomposition: blocksize does not fit with matrixsize"
        endif
        write(error_unit,*) "Do not use QR-decomposition for this matrix and blocksize."
        success = .false.
        return
      endif
    endif

    if (.not. obj%eigenvalues_only) then
      q_actual => q(1:matrixRows,1:matrixCols)
    else
     allocate(q_dummy(1:matrixRows,1:matrixCols), stat=istat, errmsg=errorMessage)
     call check_allocate_f("elpa2_template: q_dummy", 998,  istat,  errorMessage)
     q_actual => q_dummy(1:matrixRows,1:matrixCols)
    endif

    ! set the default values for each of the 5 compute steps
    do_bandred        = .true.
    do_tridiag        = .true.
    do_solve_tridi    = .true.
    do_trans_to_band  = .true.
    do_trans_to_full  = .true.

    if (obj%eigenvalues_only) then
      do_trans_to_band  = .false.
      do_trans_to_full  = .false.
    endif

    if (obj%is_set("bandwidth") == 1) then
      ! bandwidth is set. That means, that the inputed matrix is actually banded and thus the
      ! first step of ELPA2 should be skipped
      call obj%get("bandwidth",nbw,error)
      if (nbw == 0) then
        if (wantDebug) then
          write(error_unit,*) "Specified bandwidth = 0; ELPA refuses to solve the eigenvalue problem ", &
                              "for a diagonal matrix! This is too simple"
          endif
          write(error_unit,*) "Specified bandwidth = 0; ELPA refuses to solve the eigenvalue problem ", &
                 "for a diagonal matrix! This is too simple"
        success = .false.
        return
      endif
      if (mod(nbw, nblk) .ne. 0) then
        ! treat matrix with an effective bandwidth slightly bigger than specified bandwidth
        ! such that effective bandwidth is a multiply of nblk. which is a prerequiste for ELPA
        nbw = nblk * ceiling(real(nbw,kind=c_double)/real(nblk,kind=c_double))

        ! just check that effective bandwidth is NOT larger than matrix size
        if (nbw .gt. na) then
          if (wantDebug) then
            write(error_unit,*) "Specified bandwidth ",nbw," leads internaly to a computed bandwidth ", &
                                "which is larger than the matrix size ",na," ! ELPA will abort! Try to", &
                                "solve your problem by not specifing a bandwidth"
          endif
          print *, "Specified bandwidth ",nbw," leads internaly to a computed bandwidth ", &
                                "which is larger than the matrix size ",na," ! ELPA will abort! Try to", &
                                "solve your problem by not specifing a bandwidth"
          success = .false.
          return
        endif
      endif
      do_bandred       = .false. ! we already have a banded matrix
      do_solve_tridi   = .true.  ! we also have to solve something :-)
      do_trans_to_band = .true.  ! and still we have to backsub to banded
      do_trans_to_full = .false. ! but not to full since we have a banded matrix
    else ! matrix is not banded, determine the intermediate bandwidth for full->banded->tridi
      !first check if the intermediate bandwidth was set by the user
      call obj%get("intermediate_bandwidth", nbw, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "Problem getting option for intermediate_bandwidth. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

      endif

      if(nbw == 0) then
        ! intermediate bandwidth was not specified, select one of the defaults

        ! Choose bandwidth, must be a multiple of nblk, set to a value >= 32
        ! On older systems (IBM Bluegene/P, Intel Nehalem) a value of 32 was optimal.
        ! For Intel(R) Xeon(R) E5 v2 and v3, better use 64 instead of 32!
        ! For IBM Bluegene/Q this is not clear at the moment. We have to keep an eye
        ! on this and maybe allow a run-time optimization here
        nbw = (63/nblk+1)*nblk
      else
        ! intermediate bandwidth has been specified by the user, check, whether correctly
        if (mod(nbw, nblk) .ne. 0) then
          print *, "Specified bandwidth ",nbw," has to be mutiple of the blocksize ", nblk, ". Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

        endif
      endif !nbw == 0

      num_blocks = (na-1)/nbw + 1

      ! tmat is needed only in full->band and band->full steps, so alocate here
      ! (not allocated for banded matrix on input)
      allocate(tmat(nbw,nbw,num_blocks), stat=istat, errmsg=errorMessage)
      call check_allocate_f("elpa2_template: tmat", 1085,  istat,  errorMessage)

      do_bandred       = .true.
      do_solve_tridi   = .true.
      do_trans_to_band = .true.
      do_trans_to_full = .true.
    endif  ! matrix not already banded on input

    ! start the computations in 5 steps
    if (do_bandred) then
      call obj%autotune_timer%start("full_to_band")
      call obj%timer%start("full_to_band")
      ! Reduction full -> band
      call bandred_&
      &real&
      &_&
      &single &
      (obj, na, a, &
      matrixRows, nblk, nbw, matrixCols, num_blocks, mpi_comm_rows, mpi_comm_cols, tmat, &
      wantDebug, do_useGPU_bandred, success, &
      useQRActual, &
       nrThreads, isSkewsymmetric)

      call obj%timer%stop("full_to_band")
      call obj%autotune_timer%stop("full_to_band")
  
      if (success) then
        success_int = 0
      else
        success_int = 1
      endif

      if (useNonBlockingCollectivesAll) then
        call mpi_iallreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), &
        allreduce_request2, mpierr)
        call mpi_wait(allreduce_request2, MPI_STATUS_IGNORE, mpierr)
      else
        call mpi_allreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), mpierr)
      endif
      if (success_int .eq. 1) then
        write(error_unit,*) "ELPA2: bandred returned an error. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

      endif
    endif

     ! Reduction band -> tridiagonal
     if (do_tridiag) then
       allocate(e(na), stat=istat, errmsg=errorMessage)
       call check_allocate_f("elpa2_template: e", 1143,  istat,  errorMessage)

       call obj%autotune_timer%start("band_to_tridi")
       call obj%timer%start("band_to_tridi")
       call tridiag_band_&
       &real&
       &_&
       &single&
       (obj, na, nbw, nblk, a, matrixRows, ev, e, matrixCols, hh_trans, mpi_comm_rows, mpi_comm_cols, mpi_comm_all, &
       do_useGPU_tridiag_band, wantDebug, nrThreads, isSkewsymmetric, success)
  
       if (success) then
         success_int = 0
       else
         success_int = 1
       endif

       if (useNonBlockingCollectivesAll) then
         call mpi_iallreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), &
         allreduce_request3, mpierr)
         call mpi_wait(allreduce_request3, MPI_STATUS_IGNORE, mpierr)
       else
         call mpi_allreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), mpierr)
       endif
       if (success_int .eq. 1) then
         write(error_unit,*) "Error in tridiag_band. Aborting..."
         return
       endif

       call obj%timer%start("mpi_communication")
       if (useNonBlockingCollectivesAll) then
         call mpi_ibcast(ev, int(na,kind=MPI_KIND), MPI_REAL4, 0_MPI_KIND, int(mpi_comm_all,kind=MPI_KIND), bcast_request1, mpierr)
         call mpi_ibcast(e, int(na,kind=MPI_KIND), MPI_REAL4, 0_MPI_KIND, int(mpi_comm_all,kind=MPI_KIND), bcast_request2, mpierr)

         call mpi_wait(bcast_request1, MPI_STATUS_IGNORE, mpierr)
         call mpi_wait(bcast_request2, MPI_STATUS_IGNORE, mpierr)
       else
         call mpi_bcast(ev, int(na,kind=MPI_KIND), MPI_REAL4, 0_MPI_KIND, int(mpi_comm_all,kind=MPI_KIND), mpierr)
         call mpi_bcast(e, int(na,kind=MPI_KIND), MPI_REAL4, 0_MPI_KIND, int(mpi_comm_all,kind=MPI_KIND), mpierr)
       endif
       call obj%timer%stop("mpi_communication")

       call obj%timer%stop("band_to_tridi")
       call obj%autotune_timer%stop("band_to_tridi")
     endif ! do_tridiag


     ! Solve tridiagonal system
     if (do_solve_tridi) then
       call obj%autotune_timer%start("solve")
       call obj%timer%start("solve")

       call solve_tridi_&
       &single &
       (obj, na, nev, ev, e, &
       q_actual, matrixRows,   &
       nblk, matrixCols, mpi_comm_all, mpi_comm_rows, mpi_comm_cols, do_useGPU_solve_tridi, wantDebug, &
               success, nrThreads)

       call obj%timer%stop("solve")
       call obj%autotune_timer%stop("solve")
  
       if (success) then
         success_int = 0
       else
         success_int = 1
       endif

       if (useNonBlockingCollectivesAll) then
         call mpi_iallreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), &
         allreduce_request4, mpierr)
         call mpi_wait(allreduce_request4, MPI_STATUS_IGNORE, mpierr)
       else
         call mpi_allreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), mpierr)
       endif

       if (success_int .eq. 1) then
         write(error_unit,*) "ELPA2: solve returned an error: Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

       endif
     endif ! do_solve_tridi

     deallocate(e, stat=istat, errmsg=errorMessage)
     call check_deallocate_f("elpa2_template: e", 1257,  istat,  errorMessage)

     if (obj%eigenvalues_only) then
       do_trans_to_band = .false.
       do_trans_to_full = .false.
     else
       call obj%get("check_pd",check_pd,error)
       if (error .ne. ELPA_OK) then
         write(error_unit,*) "Problem getting option for check_pd. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

       endif
       if (check_pd .eq. 1) then
         call obj%get("thres_pd_&
         &single&
         &",thres_pd,error)
         if (error .ne. ELPA_OK) then
            write(error_unit,*) "Problem getting option for thres_pd_&
            &single&
            &. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

         endif

         check_pd = 0
         do i = 1, na
           if (ev(i) .gt. thres_pd) then
             check_pd = check_pd + 1
           endif
         enddo
         if (check_pd .lt. na) then
           ! not positiv definite => eigenvectors needed
           do_trans_to_band = .true.
           do_trans_to_full = .true.
         else
           do_trans_to_band = .false.
           do_trans_to_full = .false.
         endif
       endif
     endif ! eigenvalues only


       if (isSkewsymmetric) then
       ! Extra transformation step for skew-symmetric matrix. Multiplication with diagonal complex matrix D.
       ! This makes the eigenvectors complex.
       ! For now real part of eigenvectors is generated in first half of q, imaginary part in second part.
         q(1:matrixRows, matrixCols+1:2*matrixCols) = 0.0
         do i = 1, matrixRows
!          global_index = indxl2g(i, nblk, my_prow, 0, np_rows)
           global_index = np_rows*nblk*((i-1)/nblk) + MOD(i-1,nblk) + MOD(np_rows+my_prow-0, np_rows)*nblk + 1
           if (mod(global_index-1,4) .eq. 0) then
              ! do nothing
           end if
           if (mod(global_index-1,4) .eq. 1) then
              q(i,matrixCols+1:2*matrixCols) = q(i,1:matrixCols)
              q(i,1:matrixCols) = 0
           end if
           if (mod(global_index-1,4) .eq. 2) then
              q(i,1:matrixCols) = -q(i,1:matrixCols)
           end if
           if (mod(global_index-1,4) .eq. 3) then
              q(i,matrixCols+1:2*matrixCols) = -q(i,1:matrixCols)
              q(i,1:matrixCols) = 0
           end if
         end do
       endif

       ! Backtransform stage 1
     if (do_trans_to_band) then

       !debug
!#if defined(WITH_OPENMP_OFFLOAD_GPU_VERSION) || defined(WITH_SYCL_GPU_VERSION)
       !if (gpu_vendor() == OPENMP_OFFLOAD_GPU .or. gpu_vendor() == SYCL_GPU) then
       call obj%autotune_timer%start("tridi_to_band")
       call obj%timer%start("tridi_to_band")
       ! In the skew-symmetric case this transforms the real part
       call trans_ev_tridi_to_band_&
       &real&
       &_&
       &single &
       (obj, na, nev, nblk, nbw, q, &
       matrixRows, matrixCols, hh_trans, my_pe, mpi_comm_rows, mpi_comm_cols, &
       wantDebug, do_useGPU_trans_ev_tridi_to_band, &
       nrThreads, success=success, kernel=kernel)
       call obj%timer%stop("tridi_to_band")
       call obj%autotune_timer%stop("tridi_to_band")

       if (success) then
         success_int = 0
       else
         success_int = 1
       endif

       if (useNonBlockingCollectivesAll) then
         call mpi_iallreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), &
         allreduce_request5, mpierr)
         call mpi_wait(allreduce_request5, MPI_STATUS_IGNORE, mpierr)
       else
         call mpi_allreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), mpierr)
       endif

       if (success_int .eq. 1) then
         write(error_unit,*) "ELPA2: trans_ev_tridi_to_band returned an error. Aborting..."
         return
       endif

     endif ! do_trans_to_band

     ! the array q (currently) always resides on host even when using GPU

     if (do_trans_to_full) then
       call obj%autotune_timer%start("band_to_full")
       call obj%timer%start("band_to_full")
       ! Backtransform stage 2
       ! In the skew-symemtric case this transforms the real part
       call trans_ev_band_to_full_&
       &real&
       &_&
       &single &
       (obj, na, nev, nblk, nbw, a, &
       matrixRows, tmat, q,  &
       matrixRows, matrixCols, num_blocks, mpi_comm_rows, mpi_comm_cols, do_useGPU_trans_ev_band_to_full &
       , useQRActual  &
       , success)
       call obj%timer%stop("band_to_full")
       call obj%autotune_timer%stop("band_to_full")

       if (success) then
         success_int = 0
       else
         success_int = 1
       endif

       if (useNonBlockingCollectivesAll) then
         call mpi_iallreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), &
         allreduce_request6, mpierr)
         call mpi_wait(allreduce_request6, MPI_STATUS_IGNORE, mpierr)
       else
         call mpi_allreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), mpierr)
       endif
       if (success_int .eq. 1) then
         write(error_unit,*) "Error in trans_ev_band_to_full. Aborting..."
         return
       endif
     endif ! do_trans_to_full
! #ifdef DOUBLE_PRECISION_REAL
!        call prmat(na,useGPU,q(1:matrixRows, 1:matrixCols),q_dev,matrixRows,matrixCols,nblk,my_prow,my_pcol,np_rows,np_cols,'R',1)
! #endif


     !skew symmetric imaginary part for tridi_to_band and band_to_full
     if (isSkewsymmetric) then
       if (do_trans_to_band) then
         call obj%autotune_timer%start("tridi_to_band")
         call obj%timer%start("skew_tridi_to_band")
         ! Transform imaginary part
         ! Transformation of real and imaginary part could also be one call of trans_ev_tridi acting on the n x 2n matrix.
         call trans_ev_tridi_to_band_&
         &real&
         &_&
         &single &
         (obj, na, nev, nblk, nbw, q(1:matrixRows, matrixCols+1:2*matrixCols), &
         matrixRows, matrixCols, hh_trans, my_pe, mpi_comm_rows, mpi_comm_cols, &
         wantDebug, do_useGPU_trans_ev_tridi_to_band, &
         nrThreads, success=success, kernel=kernel)

         call obj%timer%stop("skew_tridi_to_band")
         call obj%autotune_timer%stop("tridi_to_band")

         if (success) then
           success_int = 0
         else
           success_int = 1
         endif

         if (useNonBlockingCollectivesAll) then
           call mpi_iallreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), &
           allreduce_request7, mpierr)
           call mpi_wait(allreduce_request7, MPI_STATUS_IGNORE, mpierr)
         else
           call mpi_allreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), mpierr)
         endif
         if (success_int .eq. 1) then
          write(error_unit,*) "Error in trans_ev_tridi_to_band (imaginary part). Aborting..."
          return
         endif
       endif ! do_trans_tridi_to_band

       if (do_trans_to_full) then
       call obj%autotune_timer%start("band_to_full")
       call obj%timer%start("band_to_full")
         ! Transform imaginary part
         ! Transformation of real and imaginary part could also be one call of trans_ev_band_to_full_ acting on the n x 2n matrix.
         call trans_ev_band_to_full_&
         &real&
         &_&
         &single &
         (obj, na, nev, nblk, nbw, a, &
         matrixRows, tmat, q(1:matrixRows, matrixCols+1:2*matrixCols),  &
         matrixRows, matrixCols, num_blocks, mpi_comm_rows, mpi_comm_cols, do_useGPU_trans_ev_band_to_full, &
         useQRActual, &
         success)

         call obj%timer%stop("band_to_full")
         call obj%autotune_timer%stop("band_to_full")

         if (success) then
           success_int = 0
         else
           success_int = 1
         endif

         if (useNonBlockingCollectivesAll) then
           call mpi_iallreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), &
           allreduce_request8, mpierr)
           call mpi_wait(allreduce_request8, MPI_STATUS_IGNORE, mpierr)
         else
           call mpi_allreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), mpierr)
         endif
         if (success_int .eq. 1) then
          write(error_unit,*) "Error in trans_ev_band_to_full (imaginary part). Aborting..."
          return
         endif
       endif ! do_trans_to_full
     endif ! isSkewSymmetric


     ! We can now deallocate the stored householder vectors
     deallocate(hh_trans, stat=istat, errmsg=errorMessage)
     call check_deallocate_f("elpa2_template: hh_trans", 1537,  istat,  errorMessage)

     ! make sure tmat is deallocated when using check_pd
     if (allocated(tmat)) then
       deallocate(tmat, stat=istat, errmsg=errorMessage)
       call check_deallocate_f("elpa2_template: tmat", 1542,  istat,  errorMessage)
     endif

     if (obj%eigenvalues_only) then
       deallocate(q_dummy, stat=istat, errmsg=errorMessage)
       call check_deallocate_f("elpa2_template: q_dummy", 1547,  istat,  errorMessage)
     endif

     ! restore original OpenMP settings



   nullify(aIntern)
   nullify(evIntern)
   if (present(qExtern)) then
     nullify(qIntern)
   endif

   nullify(ev)
   nullify(a)
   nullify(q)

  nullify(q_actual)

     call obj%timer%stop("elpa_solve_skew_evp_&
     &real&
     &_2stage_&
     &single&
     &")
1    format(a,f10.3)

   end function

! vim: syntax=fortran



















!-------------------------------------------------------------------------------
!>  \brief elpa_solve_skew_evp_real_2stage_d_ptr_single_impl: Fortran function to solve the single-precision real skew-symmetric eigenvalue problem with a 2 stage approach
!>
!>  Parameters
!>
!>  \param na                                   Order of matrix a
!>
!>  \param nev                                  Number of eigenvalues needed
!>
!>  \param a                                    Distributed matrix for which eigenvalues are to be computed.
!>                                              Distribution is like in Scalapack.
!>                                              The full matrix must be set (not only one half like in scalapack).
!>                                              Destroyed on exit (upper and lower half).
!>
!>  \param lda                                  Leading dimension of a
!>
!>  \param ev                                   On output: eigenvalues of a, every processor gets the complete set
!>
!>  \param q                                    On output: Eigenvectors of a
!>                                              Distribution is like in Scalapack.
!>                                              Must be always dimensioned to the full size (corresponding to (na,na))
!>                                              even if only a part of the eigenvalues is needed.
!>
!>  \param ldq                                  Leading dimension of q
!>
!>  \param nblk                                 blocksize of cyclic distribution, must be the same in both directions!
!>
!>  \param matrixCols                           local columns of matrix a and q
!>
!>  \param mpi_comm_rows                        MPI communicator for rows
!>  \param mpi_comm_cols                        MPI communicator for columns
!>  \param mpi_comm_all                         MPI communicator for the total processor set
!>
!>  \param kernel                               specify ELPA2 kernel to use
!>
!>  \param useQR (optional)                     use QR decomposition
!>  \param useGPU (optional)                    decide whether GPUs should be used or not
!>
!>  \result success                             logical, false if error occured
!-------------------------------------------------------------------------------


!cannot use "../src/elpa2/../general/error_checking.inc" because filename with path can be too long for gfortran (max line length)


 function elpa_solve_skew_evp_&
  &real&
  &_&
  &2stage_d_ptr_&
  &single&
  &_impl (obj, &
   aExtern, &
   evExtern, &
   qExtern) result(success)

   !use matrix_plot
   use elpa_abstract_impl
   use elpa_utilities
   use elpa1_compute
   use elpa2_compute
   use elpa_mpi
   use cuda_functions
   use hip_functions
   use elpa_gpu
   use mod_check_for_gpu
   use elpa_omp
   use solve_tridi
   use thread_affinity
   use, intrinsic :: iso_c_binding
   implicit none
!    Copyright 2011, A. Marek
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
!
  integer, parameter :: rk = C_FLOAT
  integer, parameter :: rck = C_FLOAT
  real(kind=rck), parameter      :: ZERO=0.0_rk, ONE = 1.0_rk

   class(elpa_abstract_impl_t), intent(inout)                         :: obj
   logical                                                            :: useGPU
   logical                                                            :: isSkewsymmetric
   logical                                                            :: useQR
   logical                                                            :: useQRActual
   integer(kind=c_int)                                                :: kernel, kernelByUser
   logical                                                            :: userHasSetKernel


!#ifdef REDISTRIBUTE_MATRIX
   type(c_ptr)                                                        :: aExtern
   type(c_ptr), optional                                              :: qExtern
!#else 
!   type(c_ptr)                                                        :: a, q
!#endif 


    real(kind=rck), pointer                                  :: a(:,:)
    real(kind=rck), pointer                                  :: q(:,:)
    real(kind=rk4), pointer                                  :: ev(:)

   type(c_ptr)                                                        :: evExtern

   real(kind=c_float), allocatable                   :: hh_trans(:,:)

   integer(kind=c_int)                                                :: my_pe, n_pes, my_prow, my_pcol, np_rows, np_cols
   integer(kind=MPI_KIND)                                             :: my_peMPI, n_pesMPI, my_prowMPI, my_pcolMPI, &
                                                                         np_rowsMPI, np_colsMPI, mpierr
   integer(kind=c_int)                                                :: nbw, num_blocks
   real(kind=c_float), allocatable                   :: tmat(:,:,:)
   real(kind=c_float), allocatable                            :: e(:)
   real(kind=c_float), allocatable, target           :: q_dummy(:,:)
   real(kind=c_float), pointer                       :: q_actual(:,:)


   integer(kind=c_int)                                                :: i
   logical                                                            :: success, successGPU
   integer(kind=c_int)                                                :: success_int
   logical                                                            :: wantDebug
   integer(kind=c_int)                                                :: istat, gpu, skewsymmetric, debug, qr
   character(200)                                                     :: errorMessage
   logical                                                            :: do_useGPU, do_useGPU_bandred, &
                                                                         do_useGPU_tridiag_band, do_useGPU_solve_tridi, &
                                                                         do_useGPU_trans_ev_tridi_to_band, &
                                                                         do_useGPU_trans_ev_band_to_full
   integer(kind=c_int)                                                :: numberOfGPUDevices
   integer(kind=c_intptr_t), parameter                                :: size_of_datatype = size_of_&
                                                                                            &single&
                                                                                            &_&
                                                                                            &real
   integer(kind=c_intptr_t), parameter                                :: size_of_real_datatype = size_of_&
                                                                                                 &single&
                                                                                                 &_real
   integer(kind=ik)                                                   :: na, nev, nblk, matrixCols, &
                                                                         mpi_comm_rows, mpi_comm_cols,        &
                                                                         mpi_comm_all, check_pd, error, matrixRows
   real(kind=c_float)                                         :: thres_pd

   real(kind=rck), pointer                                   :: aIntern(:,:)
   real(kind=c_float), pointer                       :: qIntern(:,:)
   real(kind=rk4), pointer                                  :: evIntern(:)

   logical                                                            :: do_bandred, do_tridiag, do_solve_tridi,  &
                                                                         do_trans_to_band, do_trans_to_full
   logical                                                            :: good_nblk_gpu

   integer(kind=ik)                                                   :: nrThreads, limitThreads
   integer(kind=ik)                                                   :: global_index
   logical                                                            :: reDistributeMatrix, doRedistributeMatrix
   integer(kind=ik)                                                   :: pinningInfo

   integer(kind=MPI_KIND)                                             :: bcast_request1, bcast_request2, allreduce_request1, &
                                                                         allreduce_request2, allreduce_request3, &
                                                                         allreduce_request4, allreduce_request5, &
                                                                         allreduce_request6, allreduce_request7, &
                                                                         allreduce_request8
   logical                                                            :: useNonBlockingCollectivesAll
   integer(kind=ik)                                                   :: gpu_old, gpu_new
   integer(kind=ik)                                                   :: non_blocking_collectives_all













    call obj%timer%start("elpa_solve_skew_evp_&
    &real&
    &_2stage_&
    &single&
    &")

    call obj%get("debug",debug, error)
    if (error .ne. ELPA_OK) then
      write(error_unit,*) "ELPA2: Problem getting option for debug settings. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

    endif

    wantDebug = debug == 1

    ! check legacy GPU setings
    ! check legacy GPU setings
    if (obj%is_set("gpu") == 1) then
      write(error_unit,*) "You still use the deprecated option 'gpu', consider switching to 'nvidia-gpu'"
      call obj%get("gpu", gpu_old, error)     
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "GPU_SOLVER : Problem getting option for gpu. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_skew_evp_&
     &real&
     &_1stage_&
     &single&
     &")
     success = .false.
     return
      endif
      if (obj%is_set("nvidia-gpu") == 0) then
        ! set gpu and nvidia-gpu consistent
        call obj%set("nvidia-gpu", gpu_old, error)
        if (error .ne. ELPA_OK) then
          write(error_unit,*) "GPU_SOLVER : Problem setting option for nvidia-gpu. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_skew_evp_&
     &real&
     &_1stage_&
     &single&
     &")
     success = .false.
     return
        endif
        write(error_unit,*) "Will set the new keyword 'nvidia-gpu' now."
        write(error_unit,*) "And ignore the 'gpu' keyword from now on"
      else ! obj%is_set("nvidia-gpu") == 0
        call obj%get("nvidia-gpu", gpu_new, error)
        if (error .ne. ELPA_OK) then
          write(error_unit,*) "GPU_SOLVER : Problem getting option for nvidia-gpu. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_skew_evp_&
     &real&
     &_1stage_&
     &single&
     &")
     success = .false.
     return
        endif
        if (gpu_old .ne. gpu_new) then
                write(error_unit,*) "Please do not set 'gpu' but 'nvidia-gpu' instead"
          write(error_unit,*) "You cannot set gpu = ",gpu_old," and nvidia-gpu=",gpu_new,". Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_skew_evp_&
     &real&
     &_1stage_&
     &single&
     &")
     success = .false.
     return
        endif
      endif ! obj%is_set("nvidia-gpu") == 0
      if (obj%is_set("amd-gpu") == 0) then
        ! amd-gpu is not set, but gpu is set
        ! this is ok in anycase
      else ! obj%is_set("amd-gpu") == 0
        call obj%get("amd-gpu", gpu_new, error)
        if (error .ne. ELPA_OK) then
          write(error_unit,*) "GPU_SOLVER : Problem getting option for amd-gpu. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_skew_evp_&
     &real&
     &_1stage_&
     &single&
     &")
     success = .false.
     return
        endif
        ! this is ok, if gpu == 0 and amd-gpu == 1 or
        !             if gpu == 0 and amd-gpu == 0 or
        !             if gpu == 1 and amd-gpu == 0
        if (gpu_old .eq. 1 .and. gpu_new .eq. 1) then
          write(error_unit,*) "GPU_SOLVER : You cannot set gpu = 1 and amd-gpu = 1. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_skew_evp_&
     &real&
     &_1stage_&
     &single&
     &")
     success = .false.
     return
        endif
      endif ! amd-gpu
      if (obj%is_set("intel-gpu") == 0) then
        ! intel-gpu is not set, but gpu is set
        ! this is ok in anycase
      else ! obj%is_set("intel-gpu") == 0
        call obj%get("intel-gpu", gpu_new, error)
        if (error .ne. ELPA_OK) then
          write(error_unit,*) "GPU_SOLVER : Problem getting option for intel-gpu. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_skew_evp_&
     &real&
     &_1stage_&
     &single&
     &")
     success = .false.
     return
        endif
        ! this is ok, if gpu == 0 and intel-gpu == 1 or
        !             if gpu == 0 and intel-gpu == 0 or
        !             if gpu == 1 and intel-gpu == 0
        if (gpu_old .eq. 1 .and. gpu_new .eq. 1) then
          write(error_unit,*) "GPU_SOLVER : You cannot set gpu = 1 and intel-gpu = 1. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_skew_evp_&
     &real&
     &_1stage_&
     &single&
     &")
     success = .false.
     return
        endif
      endif ! intel-gpu
    else ! gpu not set
      ! nothing to do since the legacy option is not set
    endif ! gpu is set

    ! GPU settings
    if (gpu_vendor() == NVIDIA_GPU) then
      call obj%get("nvidia-gpu", gpu, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "GPU_SOLVER : Problem getting option for NVIDIA GPU. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_skew_evp_&
     &real&
     &_1stage_&
     &single&
     &")
     success = .false.
     return
      endif
    else if (gpu_vendor() == AMD_GPU) then
      call obj%get("amd-gpu", gpu, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "GPU_SOLVER : Problem getting option for AMD GPU. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_skew_evp_&
     &real&
     &_1stage_&
     &single&
     &")
     success = .false.
     return
      endif
    else if (gpu_vendor() == INTEL_GPU) then
      call obj%get("intel-gpu", gpu, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "GPU_SOLVER : Problem getting option for INTEL GPU. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_skew_evp_&
     &real&
     &_1stage_&
     &single&
     &")
     success = .false.
     return
      endif
    else ! no supported gpu
      gpu = 0
    endif

   if (gpu .eq. 1) then
     useGPU =.true.
   else
     write(error_unit,*) "GPU_SOLVER : You used the interface for device pointers but did not specify GPU usage!. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

     call obj%timer%stop("elpa_solve_skew_evp_&
     &real&
     &_1stage_&
     &single&
     &")
     success = .false.
     return
     useGPU = .false.
   endif


    do_useGPU = .false.

    ! get the kernel and check whether it has been set by the user
    if (obj%is_set("real_kernel") == 1) then
      userHasSetKernel = .true.
    else
      userHasSetKernel = .false.
    endif

    ! after this point you may _never_ call get for the kernel again, or set the
    ! kernel !! The reason is that we might have to adjust the kernel, which is
    ! passed as a variable
    call obj%get("real_kernel", kernel, error)
    if (error .ne. ELPA_OK) then
      write(error_unit,*) "ELPA2: Problem getting option for kernel settings. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

    endif

    ! to implement a possibiltiy to set this
    useNonBlockingCollectivesAll = .false.

    call obj%get("mpi_comm_rows",mpi_comm_rows, error)
    if (error .ne. ELPA_OK) then
      write(error_unit,*) "ELPA2: Problem getting option for mpi_comm_rows. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

    endif
    call obj%get("mpi_comm_cols",mpi_comm_cols,error)
    if (error .ne. ELPA_OK) then
      write(error_unit,*) "ELPA2: Problem getting option for mpi_comm_cols. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

    endif
    call obj%get("mpi_comm_parent",mpi_comm_all,error)
    if (error .ne. ELPA_OK) then
      write(error_unit,*) "ELPA2: Problem getting option for mpi_comm_parent. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

    endif

    call obj%timer%start("mpi_communication")
    call mpi_comm_rank(int(mpi_comm_all,kind=MPI_KIND) ,my_peMPI ,mpierr)
    call mpi_comm_size(int(mpi_comm_all,kind=MPI_KIND) ,n_pesMPI ,mpierr)

    call mpi_comm_rank(int(mpi_comm_rows,kind=MPI_KIND) ,my_prowMPI ,mpierr)
    call mpi_comm_size(int(mpi_comm_rows,kind=MPI_KIND) ,np_rowsMPI ,mpierr)
    call mpi_comm_rank(int(mpi_comm_cols,kind=MPI_KIND) ,my_pcolMPI ,mpierr)
    call mpi_comm_size(int(mpi_comm_cols,kind=MPI_KIND) ,np_colsMPI ,mpierr)

    my_pe = int(my_peMPI, kind=c_int)
    n_pes = int(n_pesMPI, kind=c_int)
    my_prow = int(my_prowMPI, kind=c_int)
    np_rows = int(np_rowsMPI, kind=c_int)
    my_pcol = int(my_pcolMPI, kind=c_int)
    np_cols = int(np_colsMPI, kind=c_int)

    call obj%timer%stop("mpi_communication")

    na         = obj%na
    nev        = obj%nev
    nblk       = obj%nblk
    matrixCols = obj%local_ncols
    matrixRows = obj%local_nrows

    call obj%get("nbc_all_elpa2_main", non_blocking_collectives_all, error)
    if (error .ne. ELPA_OK) then
      write(error_unit,*) "ELPA2: Problem getting option for non blocking collectives. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

    endif

    if (non_blocking_collectives_all .eq. 1) then
      useNonBlockingCollectivesAll = .true.
    else
      useNonBlockingCollectivesAll = .false.
    endif

    ! openmp setting
    nrThreads = 1


    if (useGPU) then
      call obj%timer%start("check_for_gpu")
      if (check_for_gpu(obj, my_pe, numberOfGPUDevices, wantDebug=wantDebug)) then
        do_useGPU = .true.
        ! set the neccessary parameters
        call set_gpu_parameters()

      else
        write(error_unit,*) "ELPA2: GPUs are requested but not detected! Aborting..."
        call obj%timer%stop("check_for_gpu")
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

      endif
      call obj%timer%stop("check_for_gpu")

      if (nblk*(max(np_rows,np_cols)-1) >= na) then
        if (my_pe .eq. 0) then
          write(error_unit,*) "ELPA: Warning, block size too large for this matrix size and process grid!"
          write(error_unit,*) "Choose a smaller block size if possible.",nblk*(max(np_rows,np_cols)-1),na
          write(error_unit,*) "Disabling GPU usage! "
        endif

        do_useGPU = .false.
        if (kernel .eq. ELPA_2STAGE_REAL_NVIDIA_GPU) then
          if (userHasSetKernel) then
            ! user fixed inconsistent input.
            ! sadly, we do have to abort
            if (my_pe .eq. 0) then
              write(error_unit,*) "You set (fixed) the kernel to GPU, but GPUs cannot be used."
              write(error_unit,*) "Either adapt the block size or the process grid, or do not set the GPU kernel! Aborting..."
            endif
            stop 1
          else
            ! here we should set the default kernel
            kernel = ELPA_2STAGE_REAL_DEFAULT
          endif
        endif
      endif

    endif ! useGPU




    do_useGPU_bandred = do_useGPU
    do_useGPU_tridiag_band = .false.  ! not yet ported
    do_useGPU_solve_tridi = do_useGPU
    do_useGPU_trans_ev_tridi_to_band = do_useGPU
    do_useGPU_trans_ev_band_to_full = do_useGPU


   reDistributeMatrix = .false.


   allocate(aIntern(1:matrixRows,1:matrixCols))
   a       => aIntern(1:matrixRows,1:matrixCols)

   allocate(evIntern(1:obj%na))
   ev      => evIntern(1:obj%na)

   if (present(qExtern)) then
     allocate(qIntern(1:matrixRows,1:2*matrixCols))
   endif
   !TODO: intel gpu
   ! in case of devcice pointer _AND_ redistribute
   ! 1. copy aExtern to aIntern_dummy
   ! 2. redistribute aIntern_dummy to aIntern


   successGPU = gpu_memcpy(c_loc(aIntern(1,1)), aExtern, matrixRows*matrixCols*size_of_datatype, &
                             gpuMemcpyDeviceToHost)
   call check_memcpy_GPU_f("elpa2: aExtern -> aIntern", 548,  successGPU)


     a       => aIntern(1:matrixRows,1:matrixCols)
     if (present(qExtern)) then
       q       => qIntern(1:matrixRows,1:2*matrixCols)
     endif

   ev      => evIntern(1:obj%na)

   call obj%get("output_pinning_information", pinningInfo, error)
   if (error .ne. ELPA_OK) then
     write(error_unit,*) "ELPA2: Problem setting option for debug. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

   endif

   if (pinningInfo .eq. 1) then
     call init_thread_affinity(nrThreads)

     call check_thread_affinity()
     if (my_pe .eq. 0) call print_thread_affinity(my_pe)
     call cleanup_thread_affinity()
   endif

    success = .true.

    if (present(qExtern)) then
      obj%eigenvalues_only = .false.
    else
      obj%eigenvalues_only = .true.
    endif

   ! special case na = 1
   if (na .eq. 1) then
     ev(1) = a(1,1)
     if (.not.(obj%eigenvalues_only)) then
       q(1,1) = ONE
     endif

     ! restore original OpenMP settings

     call obj%timer%stop("elpa_solve_skew_evp_&
     &real&
     &_2stage_&
     &single&
     &")
     success = .true.
     return
   endif

   if (nev == 0) then
     nev = 1
     obj%eigenvalues_only = .true.
   endif

    !call obj%get("real_kernel", kernel, error)
    !if (error .ne. ELPA_OK) then
    !  print *,"Problem getting option for kernel settings. Aborting..."
    !  stop 1
    !endif

    !call obj%get("is_skewsymmetric",skewsymmetric,error)
    !if (error .ne. ELPA_OK) then
    !  print *,"Problem getting option for skewsymmetric settings. Aborting..."
    !  stop 1
    !endif
    !isSkewsymmetric = (skewsymmetric == 1)
    isSkewsymmetric = .true.

    ! only if we want (and can) use GPU in general, look what are the
    ! requirements for individual routines. Implicitly they are all set to 1, so
    ! unless specified otherwise by the user, GPU versions of all individual
    ! routines should be used
    if (do_useGPU) then
      call obj%get("gpu_bandred", gpu, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "ELPA2: Problem getting option gpu_bandred settings. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

      endif
      do_useGPU_bandred = (gpu == 1)

      ! not yet ported
      !call obj%get("gpu_tridiag_band", gpu, error)
      !if (error .ne. ELPA_OK) then
      !  print *,"Problem getting option for gpu_tridiag_band settings. Aborting..."
      !  stop 1
      !endif
      !do_useGPU_tridiag_band = (gpu == 1)

      call obj%get("gpu_solve_tridi", gpu, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "ELPA2: Problem getting option for gpu_solve_tridi settings. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

      endif
      do_useGPU_solve_tridi = (gpu == 1)

      call obj%get("gpu_trans_ev_tridi_to_band", gpu, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "ELPA2: Problem getting option for gpu_trans_ev_tridi_to_band settings. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

      endif
      do_useGPU_trans_ev_tridi_to_band = (gpu == 1)

      call obj%get("gpu_trans_ev_band_to_full", gpu, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "ELPA2: Problem getting option for gpu_trans_ev_band_to_full settings. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

      endif
      do_useGPU_trans_ev_band_to_full = (gpu == 1)
    endif

    ! check consistency between request for GPUs and defined kernel
    if (do_useGPU_trans_ev_tridi_to_band) then
      ! if the user has set explicitely a kernel before than honour this
      ! otherwise set GPU kernel
      if (userHasSetKernel) then
        if (kernel .ne. ELPA_2STAGE_REAL_NVIDIA_GPU) then
          write(error_unit,*) "ELPA: Warning, GPU usage has been requested but compute kernel is set by the user as non-GPU!"
          write(error_unit,*) "The compute kernel will be executed on CPUs!"
          do_useGPU_trans_ev_tridi_to_band = .false.
          kernel = ELPA_2STAGE_REAL_DEFAULT
        else
          good_nblk_gpu = .false.
        endif
      else ! userHasSetKernel
        !call obj%set("real_kernel", ELPA_2STAGE_REAL_NVIDIA_GPU, error)
        !if (error .ne. ELPA_OK) then
        !  write(error_unit,*) "Cannot set kernel to GPU kernel"
        !  stop 1
        !endif

        if (my_pe .eq. 0) write(error_unit,*) "You requested the GPU version, thus the GPU kernel is activated"
        good_nblk_gpu = .false.

        kernel = ELPA_2STAGE_REAL_NVIDIA_GPU
      endif ! userHasSetKernel

      ! Accepted values are 2,4,8,16,...,512
      do i = 1,10
        if (nblk == 2**i) then
          good_nblk_gpu = .true.
          exit
        endif
      enddo

      if (.not. good_nblk_gpu .and. do_useGPU_trans_ev_tridi_to_band) then
         write(error_unit,*) "ELPA: Warning, GPU kernel only works with block size 2^n (n = 1, 2, ..., 10)!"
         write(error_unit,*) "The compute kernel will be executed on CPUs!"
         write(error_unit,*) "We recommend changing the block size to 2^n"
         do_useGPU_trans_ev_tridi_to_band = .false.
         ! should be set
         kernel = ELPA_2STAGE_REAL_DEFAULT
      endif
    endif





    ! check again, now kernel and do_useGPU_trans_ev_tridi_to_band should be
    ! finally consistent
    if (do_useGPU_trans_ev_tridi_to_band) then
      !call obj%get("real_kernel", kernel, error)
      !if (error .ne. ELPA_OK) then
      !  write(error_unit,*) "Cannot get kernel to GPU kernel"
      !  stop 1
      !endif
      if (kernel .ne. ELPA_2STAGE_REAL_NVIDIA_GPU) then
        ! this should never happen, checking as an assert
        write(error_unit,*) "ELPA: INTERNAL ERROR setting GPU kernel!  Aborting..."
        stop 1
      endif
    else ! do not use GPU
      if (kernel .eq. ELPA_2STAGE_REAL_NVIDIA_GPU) then
        ! combination not allowed
        write(error_unit,*) "ELPA: Warning, GPU usage has NOT been requested but compute kernel &
                            &is defined as the GPU kernel!  Setting default kernel"
        kernel = ELPA_2STAGE_REAL_DEFAULT
        !TODO do error handling properly
      endif
    endif

    ! special case at the moment NO single precision kernels on POWER 8 -> set GENERIC for now
    if (kernel .eq. ELPA_2STAGE_REAL_VSX_BLOCK2 .or. &
        kernel .eq. ELPA_2STAGE_REAL_VSX_BLOCK4 .or. &
        kernel .eq. ELPA_2STAGE_REAL_VSX_BLOCK6        ) then
        write(error_unit,*) "ELPA: At the moment there exist no specific SINGLE precision kernels for POWER8"
        write(error_unit,*) "The GENERIC kernel will be used at the moment"
        kernel = ELPA_2STAGE_REAL_GENERIC
    endif
    ! special case at the moment NO single precision kernels on SPARC64 -> set GENERIC for now
    if (kernel .eq. ELPA_2STAGE_REAL_SPARC64_BLOCK2 .or. &
        kernel .eq. ELPA_2STAGE_REAL_SPARC64_BLOCK4 .or. &
        kernel .eq. ELPA_2STAGE_REAL_SPARC64_BLOCK6        ) then
        write(error_unit,*) "ELPA: At the moment there exist no specific SINGLE precision kernels for SPARC64"
        write(error_unit,*) "The GENERIC kernel will be used at the moment"
        kernel = ELPA_2STAGE_REAL_GENERIC
    endif


     !! consistency check: is user set kernel still identical with "kernel" or did
     !! we change it above? This is a mess and should be cleaned up
     !call obj%get("real_kernel",kernelByUser,error)
     !if (error .ne. ELPA_OK) then
     !  print *,"Problem getting option for user kernel settings. Aborting..."
     !  stop 1
     !endif

     !if (kernelByUser .ne. kernel) then
     !  call obj%set("real_kernel", kernel, error)
     !  if (error .ne. ELPA_OK) then
     !    print *,"Problem setting kernel. Aborting..."
     !    stop 1
     !  endif
     !endif


    call obj%get("qr",qr,error)
    if (error .ne. ELPA_OK) then
      print *,"ELPA2: Problem getting option for qr settings. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

    endif
    if (qr .eq. 1) then
      useQR = .true.
    else
      useQR = .false.
    endif

    useQRActual = .false.
    ! set usage of qr decomposition via API call
    if (useQR) useQRActual = .true.
    if (.not.(useQR)) useQRACtual = .false.

    if (useQRActual) then
      if (mod(na,2) .ne. 0) then
        if (wantDebug) then
          write(error_unit,*) "solve_evp_real_2stage: QR-decomposition: blocksize does not fit with matrixsize"
        endif
        write(error_unit,*) "Do not use QR-decomposition for this matrix and blocksize."
        success = .false.
        return
      endif
    endif

    if (.not. obj%eigenvalues_only) then
      q_actual => q(1:matrixRows,1:matrixCols)
    else
     allocate(q_dummy(1:matrixRows,1:matrixCols), stat=istat, errmsg=errorMessage)
     call check_allocate_f("elpa2_template: q_dummy", 998,  istat,  errorMessage)
     q_actual => q_dummy(1:matrixRows,1:matrixCols)
    endif

    ! set the default values for each of the 5 compute steps
    do_bandred        = .true.
    do_tridiag        = .true.
    do_solve_tridi    = .true.
    do_trans_to_band  = .true.
    do_trans_to_full  = .true.

    if (obj%eigenvalues_only) then
      do_trans_to_band  = .false.
      do_trans_to_full  = .false.
    endif

    if (obj%is_set("bandwidth") == 1) then
      ! bandwidth is set. That means, that the inputed matrix is actually banded and thus the
      ! first step of ELPA2 should be skipped
      call obj%get("bandwidth",nbw,error)
      if (nbw == 0) then
        if (wantDebug) then
          write(error_unit,*) "Specified bandwidth = 0; ELPA refuses to solve the eigenvalue problem ", &
                              "for a diagonal matrix! This is too simple"
          endif
          write(error_unit,*) "Specified bandwidth = 0; ELPA refuses to solve the eigenvalue problem ", &
                 "for a diagonal matrix! This is too simple"
        success = .false.
        return
      endif
      if (mod(nbw, nblk) .ne. 0) then
        ! treat matrix with an effective bandwidth slightly bigger than specified bandwidth
        ! such that effective bandwidth is a multiply of nblk. which is a prerequiste for ELPA
        nbw = nblk * ceiling(real(nbw,kind=c_double)/real(nblk,kind=c_double))

        ! just check that effective bandwidth is NOT larger than matrix size
        if (nbw .gt. na) then
          if (wantDebug) then
            write(error_unit,*) "Specified bandwidth ",nbw," leads internaly to a computed bandwidth ", &
                                "which is larger than the matrix size ",na," ! ELPA will abort! Try to", &
                                "solve your problem by not specifing a bandwidth"
          endif
          print *, "Specified bandwidth ",nbw," leads internaly to a computed bandwidth ", &
                                "which is larger than the matrix size ",na," ! ELPA will abort! Try to", &
                                "solve your problem by not specifing a bandwidth"
          success = .false.
          return
        endif
      endif
      do_bandred       = .false. ! we already have a banded matrix
      do_solve_tridi   = .true.  ! we also have to solve something :-)
      do_trans_to_band = .true.  ! and still we have to backsub to banded
      do_trans_to_full = .false. ! but not to full since we have a banded matrix
    else ! matrix is not banded, determine the intermediate bandwidth for full->banded->tridi
      !first check if the intermediate bandwidth was set by the user
      call obj%get("intermediate_bandwidth", nbw, error)
      if (error .ne. ELPA_OK) then
        write(error_unit,*) "Problem getting option for intermediate_bandwidth. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

      endif

      if(nbw == 0) then
        ! intermediate bandwidth was not specified, select one of the defaults

        ! Choose bandwidth, must be a multiple of nblk, set to a value >= 32
        ! On older systems (IBM Bluegene/P, Intel Nehalem) a value of 32 was optimal.
        ! For Intel(R) Xeon(R) E5 v2 and v3, better use 64 instead of 32!
        ! For IBM Bluegene/Q this is not clear at the moment. We have to keep an eye
        ! on this and maybe allow a run-time optimization here
        nbw = (63/nblk+1)*nblk
      else
        ! intermediate bandwidth has been specified by the user, check, whether correctly
        if (mod(nbw, nblk) .ne. 0) then
          print *, "Specified bandwidth ",nbw," has to be mutiple of the blocksize ", nblk, ". Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

        endif
      endif !nbw == 0

      num_blocks = (na-1)/nbw + 1

      ! tmat is needed only in full->band and band->full steps, so alocate here
      ! (not allocated for banded matrix on input)
      allocate(tmat(nbw,nbw,num_blocks), stat=istat, errmsg=errorMessage)
      call check_allocate_f("elpa2_template: tmat", 1085,  istat,  errorMessage)

      do_bandred       = .true.
      do_solve_tridi   = .true.
      do_trans_to_band = .true.
      do_trans_to_full = .true.
    endif  ! matrix not already banded on input

    ! start the computations in 5 steps
    if (do_bandred) then
      call obj%autotune_timer%start("full_to_band")
      call obj%timer%start("full_to_band")
      ! Reduction full -> band
      call bandred_&
      &real&
      &_&
      &single &
      (obj, na, a, &
      matrixRows, nblk, nbw, matrixCols, num_blocks, mpi_comm_rows, mpi_comm_cols, tmat, &
      wantDebug, do_useGPU_bandred, success, &
      useQRActual, &
       nrThreads, isSkewsymmetric)

      call obj%timer%stop("full_to_band")
      call obj%autotune_timer%stop("full_to_band")
  
      if (success) then
        success_int = 0
      else
        success_int = 1
      endif

      if (useNonBlockingCollectivesAll) then
        call mpi_iallreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), &
        allreduce_request2, mpierr)
        call mpi_wait(allreduce_request2, MPI_STATUS_IGNORE, mpierr)
      else
        call mpi_allreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), mpierr)
      endif
      if (success_int .eq. 1) then
        write(error_unit,*) "ELPA2: bandred returned an error. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

      endif
    endif

     ! Reduction band -> tridiagonal
     if (do_tridiag) then
       allocate(e(na), stat=istat, errmsg=errorMessage)
       call check_allocate_f("elpa2_template: e", 1143,  istat,  errorMessage)

       call obj%autotune_timer%start("band_to_tridi")
       call obj%timer%start("band_to_tridi")
       call tridiag_band_&
       &real&
       &_&
       &single&
       (obj, na, nbw, nblk, a, matrixRows, ev, e, matrixCols, hh_trans, mpi_comm_rows, mpi_comm_cols, mpi_comm_all, &
       do_useGPU_tridiag_band, wantDebug, nrThreads, isSkewsymmetric, success)
  
       if (success) then
         success_int = 0
       else
         success_int = 1
       endif

       if (useNonBlockingCollectivesAll) then
         call mpi_iallreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), &
         allreduce_request3, mpierr)
         call mpi_wait(allreduce_request3, MPI_STATUS_IGNORE, mpierr)
       else
         call mpi_allreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), mpierr)
       endif
       if (success_int .eq. 1) then
         write(error_unit,*) "Error in tridiag_band. Aborting..."
         return
       endif

       call obj%timer%start("mpi_communication")
       if (useNonBlockingCollectivesAll) then
         call mpi_ibcast(ev, int(na,kind=MPI_KIND), MPI_REAL4, 0_MPI_KIND, int(mpi_comm_all,kind=MPI_KIND), bcast_request1, mpierr)
         call mpi_ibcast(e, int(na,kind=MPI_KIND), MPI_REAL4, 0_MPI_KIND, int(mpi_comm_all,kind=MPI_KIND), bcast_request2, mpierr)

         call mpi_wait(bcast_request1, MPI_STATUS_IGNORE, mpierr)
         call mpi_wait(bcast_request2, MPI_STATUS_IGNORE, mpierr)
       else
         call mpi_bcast(ev, int(na,kind=MPI_KIND), MPI_REAL4, 0_MPI_KIND, int(mpi_comm_all,kind=MPI_KIND), mpierr)
         call mpi_bcast(e, int(na,kind=MPI_KIND), MPI_REAL4, 0_MPI_KIND, int(mpi_comm_all,kind=MPI_KIND), mpierr)
       endif
       call obj%timer%stop("mpi_communication")

       call obj%timer%stop("band_to_tridi")
       call obj%autotune_timer%stop("band_to_tridi")
     endif ! do_tridiag


     ! Solve tridiagonal system
     if (do_solve_tridi) then
       call obj%autotune_timer%start("solve")
       call obj%timer%start("solve")

       call solve_tridi_&
       &single &
       (obj, na, nev, ev, e, &
       q_actual, matrixRows,   &
       nblk, matrixCols, mpi_comm_all, mpi_comm_rows, mpi_comm_cols, do_useGPU_solve_tridi, wantDebug, &
               success, nrThreads)

       call obj%timer%stop("solve")
       call obj%autotune_timer%stop("solve")
  
       if (success) then
         success_int = 0
       else
         success_int = 1
       endif

       if (useNonBlockingCollectivesAll) then
         call mpi_iallreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), &
         allreduce_request4, mpierr)
         call mpi_wait(allreduce_request4, MPI_STATUS_IGNORE, mpierr)
       else
         call mpi_allreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), mpierr)
       endif

       if (success_int .eq. 1) then
         write(error_unit,*) "ELPA2: solve returned an error: Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

       endif
     endif ! do_solve_tridi

     deallocate(e, stat=istat, errmsg=errorMessage)
     call check_deallocate_f("elpa2_template: e", 1257,  istat,  errorMessage)

     if (obj%eigenvalues_only) then
       do_trans_to_band = .false.
       do_trans_to_full = .false.
     else
       call obj%get("check_pd",check_pd,error)
       if (error .ne. ELPA_OK) then
         write(error_unit,*) "Problem getting option for check_pd. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

       endif
       if (check_pd .eq. 1) then
         call obj%get("thres_pd_&
         &single&
         &",thres_pd,error)
         if (error .ne. ELPA_OK) then
            write(error_unit,*) "Problem getting option for thres_pd_&
            &single&
            &. Aborting..."
      write(error_unit,*) "Problem getting option for debug settings. Aborting..."
      call obj%timer%stop("elpa_solve_skew_evp_&
      &real&
      &_2stage_&
      &single&
      &")
      success = .false.
      return

         endif

         check_pd = 0
         do i = 1, na
           if (ev(i) .gt. thres_pd) then
             check_pd = check_pd + 1
           endif
         enddo
         if (check_pd .lt. na) then
           ! not positiv definite => eigenvectors needed
           do_trans_to_band = .true.
           do_trans_to_full = .true.
         else
           do_trans_to_band = .false.
           do_trans_to_full = .false.
         endif
       endif
     endif ! eigenvalues only


       if (isSkewsymmetric) then
       ! Extra transformation step for skew-symmetric matrix. Multiplication with diagonal complex matrix D.
       ! This makes the eigenvectors complex.
       ! For now real part of eigenvectors is generated in first half of q, imaginary part in second part.
         q(1:matrixRows, matrixCols+1:2*matrixCols) = 0.0
         do i = 1, matrixRows
!          global_index = indxl2g(i, nblk, my_prow, 0, np_rows)
           global_index = np_rows*nblk*((i-1)/nblk) + MOD(i-1,nblk) + MOD(np_rows+my_prow-0, np_rows)*nblk + 1
           if (mod(global_index-1,4) .eq. 0) then
              ! do nothing
           end if
           if (mod(global_index-1,4) .eq. 1) then
              q(i,matrixCols+1:2*matrixCols) = q(i,1:matrixCols)
              q(i,1:matrixCols) = 0
           end if
           if (mod(global_index-1,4) .eq. 2) then
              q(i,1:matrixCols) = -q(i,1:matrixCols)
           end if
           if (mod(global_index-1,4) .eq. 3) then
              q(i,matrixCols+1:2*matrixCols) = -q(i,1:matrixCols)
              q(i,1:matrixCols) = 0
           end if
         end do
       endif

       ! Backtransform stage 1
     if (do_trans_to_band) then

       !debug
!#if defined(WITH_OPENMP_OFFLOAD_GPU_VERSION) || defined(WITH_SYCL_GPU_VERSION)
       !if (gpu_vendor() == OPENMP_OFFLOAD_GPU .or. gpu_vendor() == SYCL_GPU) then
       call obj%autotune_timer%start("tridi_to_band")
       call obj%timer%start("tridi_to_band")
       ! In the skew-symmetric case this transforms the real part
       call trans_ev_tridi_to_band_&
       &real&
       &_&
       &single &
       (obj, na, nev, nblk, nbw, q, &
       matrixRows, matrixCols, hh_trans, my_pe, mpi_comm_rows, mpi_comm_cols, &
       wantDebug, do_useGPU_trans_ev_tridi_to_band, &
       nrThreads, success=success, kernel=kernel)
       call obj%timer%stop("tridi_to_band")
       call obj%autotune_timer%stop("tridi_to_band")

       if (success) then
         success_int = 0
       else
         success_int = 1
       endif

       if (useNonBlockingCollectivesAll) then
         call mpi_iallreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), &
         allreduce_request5, mpierr)
         call mpi_wait(allreduce_request5, MPI_STATUS_IGNORE, mpierr)
       else
         call mpi_allreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), mpierr)
       endif

       if (success_int .eq. 1) then
         write(error_unit,*) "ELPA2: trans_ev_tridi_to_band returned an error. Aborting..."
         return
       endif

     endif ! do_trans_to_band

     ! the array q (currently) always resides on host even when using GPU

     if (do_trans_to_full) then
       call obj%autotune_timer%start("band_to_full")
       call obj%timer%start("band_to_full")
       ! Backtransform stage 2
       ! In the skew-symemtric case this transforms the real part
       call trans_ev_band_to_full_&
       &real&
       &_&
       &single &
       (obj, na, nev, nblk, nbw, a, &
       matrixRows, tmat, q,  &
       matrixRows, matrixCols, num_blocks, mpi_comm_rows, mpi_comm_cols, do_useGPU_trans_ev_band_to_full &
       , useQRActual  &
       , success)
       call obj%timer%stop("band_to_full")
       call obj%autotune_timer%stop("band_to_full")

       if (success) then
         success_int = 0
       else
         success_int = 1
       endif

       if (useNonBlockingCollectivesAll) then
         call mpi_iallreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), &
         allreduce_request6, mpierr)
         call mpi_wait(allreduce_request6, MPI_STATUS_IGNORE, mpierr)
       else
         call mpi_allreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), mpierr)
       endif
       if (success_int .eq. 1) then
         write(error_unit,*) "Error in trans_ev_band_to_full. Aborting..."
         return
       endif
     endif ! do_trans_to_full
! #ifdef DOUBLE_PRECISION_REAL
!        call prmat(na,useGPU,q(1:matrixRows, 1:matrixCols),q_dev,matrixRows,matrixCols,nblk,my_prow,my_pcol,np_rows,np_cols,'R',1)
! #endif


     !skew symmetric imaginary part for tridi_to_band and band_to_full
     if (isSkewsymmetric) then
       if (do_trans_to_band) then
         call obj%autotune_timer%start("tridi_to_band")
         call obj%timer%start("skew_tridi_to_band")
         ! Transform imaginary part
         ! Transformation of real and imaginary part could also be one call of trans_ev_tridi acting on the n x 2n matrix.
         call trans_ev_tridi_to_band_&
         &real&
         &_&
         &single &
         (obj, na, nev, nblk, nbw, q(1:matrixRows, matrixCols+1:2*matrixCols), &
         matrixRows, matrixCols, hh_trans, my_pe, mpi_comm_rows, mpi_comm_cols, &
         wantDebug, do_useGPU_trans_ev_tridi_to_band, &
         nrThreads, success=success, kernel=kernel)

         call obj%timer%stop("skew_tridi_to_band")
         call obj%autotune_timer%stop("tridi_to_band")

         if (success) then
           success_int = 0
         else
           success_int = 1
         endif

         if (useNonBlockingCollectivesAll) then
           call mpi_iallreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), &
           allreduce_request7, mpierr)
           call mpi_wait(allreduce_request7, MPI_STATUS_IGNORE, mpierr)
         else
           call mpi_allreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), mpierr)
         endif
         if (success_int .eq. 1) then
          write(error_unit,*) "Error in trans_ev_tridi_to_band (imaginary part). Aborting..."
          return
         endif
       endif ! do_trans_tridi_to_band

       if (do_trans_to_full) then
       call obj%autotune_timer%start("band_to_full")
       call obj%timer%start("band_to_full")
         ! Transform imaginary part
         ! Transformation of real and imaginary part could also be one call of trans_ev_band_to_full_ acting on the n x 2n matrix.
         call trans_ev_band_to_full_&
         &real&
         &_&
         &single &
         (obj, na, nev, nblk, nbw, a, &
         matrixRows, tmat, q(1:matrixRows, matrixCols+1:2*matrixCols),  &
         matrixRows, matrixCols, num_blocks, mpi_comm_rows, mpi_comm_cols, do_useGPU_trans_ev_band_to_full, &
         useQRActual, &
         success)

         call obj%timer%stop("band_to_full")
         call obj%autotune_timer%stop("band_to_full")

         if (success) then
           success_int = 0
         else
           success_int = 1
         endif

         if (useNonBlockingCollectivesAll) then
           call mpi_iallreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), &
           allreduce_request8, mpierr)
           call mpi_wait(allreduce_request8, MPI_STATUS_IGNORE, mpierr)
         else
           call mpi_allreduce(mpi_in_place, success_int, 1_MPI_KIND, MPI_INTEGER, MPI_MAX, int(mpi_comm_all,kind=MPI_KIND), mpierr)
         endif
         if (success_int .eq. 1) then
          write(error_unit,*) "Error in trans_ev_band_to_full (imaginary part). Aborting..."
          return
         endif
       endif ! do_trans_to_full
     endif ! isSkewSymmetric


     ! We can now deallocate the stored householder vectors
     deallocate(hh_trans, stat=istat, errmsg=errorMessage)
     call check_deallocate_f("elpa2_template: hh_trans", 1537,  istat,  errorMessage)

     ! make sure tmat is deallocated when using check_pd
     if (allocated(tmat)) then
       deallocate(tmat, stat=istat, errmsg=errorMessage)
       call check_deallocate_f("elpa2_template: tmat", 1542,  istat,  errorMessage)
     endif

     if (obj%eigenvalues_only) then
       deallocate(q_dummy, stat=istat, errmsg=errorMessage)
       call check_deallocate_f("elpa2_template: q_dummy", 1547,  istat,  errorMessage)
     endif

     ! restore original OpenMP settings



   !copy qIntern and ev to provided device pointers
   if (present(qExtern)) then
   successGPU = gpu_memcpy(qExtern, c_loc(qIntern(1,1)), obj%local_nrows*obj%local_ncols*size_of_datatype, &
                             gpuMemcpyHostToDevice)
   endif
   call check_memcpy_GPU_f("elpa1: qIntern -> qExtern", 1607,  successGPU)
   successGPU = gpu_memcpy(evExtern, c_loc(ev(1)), obj%na*size_of_real_datatype, &
                             gpuMemcpyHostToDevice)
   call check_memcpy_GPU_f("elpa1: ev -> evExtern", 1610,  successGPU)


     deallocate(aIntern)
     !deallocate(evIntern)
     nullify(evIntern)
     if (present(qExtern)) then
       deallocate(qIntern)
     endif



   nullify(ev)
   nullify(a)
   nullify(q)

  nullify(q_actual)

     call obj%timer%stop("elpa_solve_skew_evp_&
     &real&
     &_2stage_&
     &single&
     &")
1    format(a,f10.3)

   end function

! vim: syntax=fortran




end module elpa2_impl
