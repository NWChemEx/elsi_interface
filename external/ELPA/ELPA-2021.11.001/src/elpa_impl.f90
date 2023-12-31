










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

!> \brief Fortran module which provides the actual implementation of the API. Do not use directly! Use the module "elpa"
module elpa_impl
  use precision
  use elpa2_impl
  use elpa1_impl
  use elpa1_auxiliary_impl
  use elpa_mpi
  use elpa_generated_fortran_interfaces
  use elpa_utilities, only : error_unit

  use elpa_abstract_impl
  use elpa_autotune_impl
  use, intrinsic :: iso_c_binding
  use iso_fortran_env
  implicit none

  private
  public :: elpa_impl_allocate

  integer(kind=c_int), private :: autotune_level, autotune_domain
  logical, private, save       :: autotune_substeps_done1stage(0:ELPA_NUMBER_OF_AUTOTUNE_LEVELS-1) = .false.
  logical, private, save       :: autotune_substeps_done2stage(0:ELPA_NUMBER_OF_AUTOTUNE_LEVELS-1) = .false.
  logical, private, save       :: do_autotune_2stage = .false., do_autotune_1stage = .false.
  logical, private, save       :: last_call_2stage = .false., last_call_1stage = .false.
  logical, private, save       :: autotune_api_set = .false.
  logical, private, save       :: new_autotune = .false.
  integer(kind=c_int), private :: consider_solver

!> \brief Definition of the extended elpa_impl_t type
  type, extends(elpa_abstract_impl_t) :: elpa_impl_t
   private
   integer :: communicators_owned

   !This object has been created through the legacy api.
   integer :: from_legacy_api

   !> \brief methods available with the elpa_impl_t type
   contains
     !> \brief the puplic methods
     ! con-/destructor
     procedure, public :: setup => elpa_setup                   !< a setup method: implemented in elpa_setup
     procedure, public :: destroy => elpa_destroy               !< a destroy method: implemented in elpa_destroy

     ! KV store
     procedure, public :: is_set => elpa_is_set             !< a method to check whether a key/value pair has been set : implemented
                                                            !< in elpa_is_set
     procedure, public :: can_set => elpa_can_set           !< a method to check whether a key/value pair can be set : implemented
                                                            !< in elpa_can_set

     ! call before setup if created from the legacy api
     ! remove this function completely after the legacy api is dropped
     procedure, public :: creating_from_legacy_api => elpa_creating_from_legacy_api

     ! timer
     procedure, public :: get_time => elpa_get_time
     procedure, public :: print_times => elpa_print_times
     procedure, public :: timer_start => elpa_timer_start
     procedure, public :: timer_stop => elpa_timer_stop


     !> \brief the implemenation methods

     procedure, public :: elpa_eigenvectors_all_host_arrays_d                  !< public methods to implement the solve step for real/complex
                                                                               !< double/single matrices
     procedure, public :: elpa_eigenvectors_all_host_arrays_f
     procedure, public :: elpa_eigenvectors_all_host_arrays_dc
     procedure, public :: elpa_eigenvectors_all_host_arrays_fc

     procedure, public :: elpa_eigenvectors_device_pointer_d 
     procedure, public :: elpa_eigenvectors_device_pointer_f
     procedure, public :: elpa_eigenvectors_device_pointer_dc
     procedure, public :: elpa_eigenvectors_device_pointer_fc

     procedure, public :: elpa_eigenvalues_all_host_arrays_d                   !< public methods to implement the solve step for real/complex
                                                                               !< double/single matrices; only the eigenvalues are computed
     procedure, public :: elpa_eigenvalues_all_host_arrays_f
     procedure, public :: elpa_eigenvalues_all_host_arrays_dc
     procedure, public :: elpa_eigenvalues_all_host_arrays_fc

     procedure, public :: elpa_eigenvalues_device_pointer_d 
     procedure, public :: elpa_eigenvalues_device_pointer_f
     procedure, public :: elpa_eigenvalues_device_pointer_dc
     procedure, public :: elpa_eigenvalues_device_pointer_fc

     procedure, public :: elpa_skew_eigenvectors_all_host_arrays_d             !< public methods to implement the solve step for real skew-symmetric
                                                                               !< double/single matrices
     procedure, public :: elpa_skew_eigenvectors_all_host_arrays_f

     procedure, public :: elpa_skew_eigenvalues_all_host_arrays_d              !< public methods to implement the solve step for real skew-symmetric
                                                                               !< double/single matrices; only the eigenvalues are computed
     procedure, public :: elpa_skew_eigenvalues_all_host_arrays_f

     procedure, public :: elpa_skew_eigenvectors_device_pointer_d 
     procedure, public :: elpa_skew_eigenvectors_device_pointer_f
     procedure, public :: elpa_skew_eigenvalues_device_pointer_d 
     procedure, public :: elpa_skew_eigenvalues_device_pointer_f

     procedure, public :: elpa_generalized_eigenvectors_d      !< public methods to implement the solve step for generalized
                                                               !< eigenproblem and real/complex double/single matrices
     procedure, public :: elpa_generalized_eigenvectors_f
     procedure, public :: elpa_generalized_eigenvectors_dc
     procedure, public :: elpa_generalized_eigenvectors_fc

     procedure, public :: elpa_generalized_eigenvalues_d      !< public methods to implement the solve step for generalized
                                                              !< eigenproblem and real/complex double/single matrices
     procedure, public :: elpa_generalized_eigenvalues_f
     procedure, public :: elpa_generalized_eigenvalues_dc
     procedure, public :: elpa_generalized_eigenvalues_fc

     procedure, public :: elpa_hermitian_multiply_d      !< public methods to implement a "hermitian" multiplication of matrices a and b
     procedure, public :: elpa_hermitian_multiply_f            !< for real valued matrices:   a**T * b
     procedure, public :: elpa_hermitian_multiply_dc           !< for complex valued matrices:   a**H * b
     procedure, public :: elpa_hermitian_multiply_fc

     procedure, public :: elpa_cholesky_d                      !< public methods to implement the cholesky factorisation of
                                                               !< real/complex double/single matrices
     procedure, public :: elpa_cholesky_f
     procedure, public :: elpa_cholesky_dc
     procedure, public :: elpa_cholesky_fc

     procedure, public :: elpa_invert_trm_d                    !< public methods to implement the inversion of a triangular
                                                               !< real/complex double/single matrix
     procedure, public :: elpa_invert_trm_f
     procedure, public :: elpa_invert_trm_dc
     procedure, public :: elpa_invert_trm_fc

     procedure, public :: elpa_solve_tridiagonal_d             !< public methods to implement the solve step for a real valued
     procedure, public :: elpa_solve_tridiagonal_f             !< double/single tridiagonal matrix

     procedure, public :: associate_int => elpa_associate_int  !< public method to set some pointers

     procedure, private :: elpa_transform_generalized_d
     procedure, private :: elpa_transform_back_generalized_d
     procedure, private :: elpa_transform_generalized_dc
     procedure, private :: elpa_transform_back_generalized_dc
     procedure, private :: elpa_transform_generalized_f
     procedure, private :: elpa_transform_back_generalized_f
     procedure, private :: elpa_transform_generalized_fc
     procedure, private :: elpa_transform_back_generalized_fc

     procedure, public :: print_settings => elpa_print_settings
     procedure, public :: store_settings => elpa_store_settings
     procedure, public :: load_settings => elpa_load_settings
     procedure, public :: autotune_setup => elpa_autotune_setup
     procedure, public :: autotune_set_api_version => elpa_autotune_set_api_version
     procedure, public :: autotune_step => elpa_autotune_step
     procedure, public :: autotune_step_worker => elpa_autotune_step_worker
     procedure, public :: autotune_set_best => elpa_autotune_set_best
     procedure, public :: autotune_print_best => elpa_autotune_print_best
     procedure, public :: autotune_print_state => elpa_autotune_print_state
     procedure, public :: autotune_save_state => elpa_autotune_save_state
     procedure, public :: autotune_load_state => elpa_autotune_load_state
     procedure, private :: construct_scalapack_descriptor => elpa_construct_scalapack_descriptor
  end type elpa_impl_t

  !> \brief the implementation of the generic methods
  contains


    !> \brief function to allocate an ELPA object
    !> Parameters
    !> \param   error      integer, optional to get an error code
    !> \result  obj        class(elpa_impl_t) allocated ELPA object
    function elpa_impl_allocate(error) result(obj)
      type(elpa_impl_t), pointer     :: obj
      integer, optional, intent(out) :: error
      integer                        :: error2, output_build_config

      allocate(obj, stat=error2)
      if (error2 .ne. 0) then
        write(error_unit, *) "elpa_allocate(): could not allocate object"
      endif

      obj%from_legacy_api = 0

      ! check whether init has ever been called
      if ( elpa_initialized() .ne. ELPA_OK) then
        write(error_unit, *) "elpa_allocate(): you must call elpa_init() once before creating instances of ELPA"
        if (present(error)) then
          error = ELPA_ERROR_API_VERSION
        endif
        return
      endif

      obj%index = elpa_index_instance_c()

      ! Associate some important integer pointers for convenience
      obj%na => obj%associate_int("na")
      obj%nev => obj%associate_int("nev")
      obj%local_nrows => obj%associate_int("local_nrows")
      obj%local_ncols => obj%associate_int("local_ncols")
      obj%nblk => obj%associate_int("nblk")

      if (present(error)) then
        error = ELPA_OK
      endif
    end function

    !c> 
    !c_no> #if OPTIONAL_C_ERROR_ARGUMENT != 1
    !c_no> elpa_t elpa_allocate(int *error);
    !c_no> #endif
    function elpa_impl_allocate_c(error) result(ptr) bind(C, name="elpa_allocate")
      integer(kind=c_int)        :: error
      type(c_ptr)                :: ptr
      type(elpa_impl_t), pointer :: obj

      obj => elpa_impl_allocate(error)
      ptr = c_loc(obj)
    end function

    !c> 
    !c_no> #if OPTIONAL_C_ERROR_ARGUMENT != 1
    !c_no> void elpa_deallocate(elpa_t handle, int *error);
    !c_no> #endif
    subroutine elpa_impl_deallocate_c(handle, error) bind(C, name="elpa_deallocate")
      type(c_ptr), value         :: handle
      type(elpa_impl_t), pointer :: self
      integer(kind=c_int)        :: error

      call c_f_pointer(handle, self)
      call self%destroy(error)
      deallocate(self)
    end subroutine


    !> \brief function to load all the parameters, which have been saved to a file
    !> Parameters
    !> \param   self        class(elpa_impl_t) the allocated ELPA object
    !> \param   file_name   string, the name of the file from which to load the parameters
    !> \param   error       integer, optional
    subroutine elpa_load_settings(self, file_name, error)
      implicit none
      class(elpa_impl_t), intent(inout) :: self
      character(*), intent(in)          :: file_name
      integer(kind=c_int), optional, intent(out)    :: error

      if (present(error)) then
        error = ELPA_OK
      endif
      if (elpa_index_load_settings_c(self%index, file_name // c_null_char) /= 1) then
        write(error_unit, *) "This should not happen (in elpa_load_settings())"

        if (present(error)) then
          error = ELPA_ERROR_CANNOT_OPEN_FILE
        endif
      endif
    end subroutine

    !c> 
    !c> void elpa_load_settings(elpa_t handle, const char *filename, int *error);
    subroutine elpa_load_settings_c(handle, filename_p, error) bind(C, name="elpa_load_settings")
      type(c_ptr), value         :: handle
      type(elpa_impl_t), pointer :: self

      integer(kind=c_int)        :: error
      type(c_ptr), intent(in), value :: filename_p
      character(len=elpa_strlen_c(filename_p)), pointer :: filename

      call c_f_pointer(handle, self)
      call c_f_pointer(filename_p, filename)
      call elpa_load_settings(self, filename, error)

    end subroutine

    !> \brief function to print all the parameters, that have been set
    !> Parameters
    !> \param   self            class(elpa_impl_t) the allocated ELPA object
    !> \param   error           optional, integer
    subroutine elpa_print_settings(self, error)
      implicit none
      class(elpa_impl_t), intent(inout) :: self
      integer(kind=c_int), optional, intent(out)    :: error

      if (present(error)) then
        error = ELPA_OK
      endif
      if (elpa_index_print_settings_c(self%index, c_null_char) /= 1) then
        write(error_unit, *) "This should not happen (in elpa_print_settings())"

        if (present(error)) then
          error = ELPA_ERROR_CRITICAL
        endif
      endif
    end subroutine

    !c> 
    !c> void elpa_print_settings(elpa_t handle, int *error);
    subroutine elpa_print_settings_c(handle, error) bind(C, name="elpa_print_settings")
      type(c_ptr), value         :: handle
      type(elpa_impl_t), pointer :: self

      integer(kind=c_int)        :: error

      call c_f_pointer(handle, self)
      call elpa_print_settings(self, error)

    end subroutine


    !> \brief function to save all the parameters, that have been set
    !> Parameters
    !> \param   self        class(elpa_impl_t) the allocated ELPA object
    !> \param   file_name   string, the name of the file where to save the parameters
    !> \param   error       integer, optional
    subroutine elpa_store_settings(self, file_name, error)
      implicit none
      class(elpa_impl_t), intent(inout) :: self
      character(*), intent(in)          :: file_name
      integer(kind=c_int), optional, intent(out)    :: error

      if (present(error)) then
        error = ELPA_OK
      endif
      if (elpa_index_print_settings_c(self%index, file_name // c_null_char) /= 1) then
        write(error_unit, *) "This should not happen (in elpa_store_settings())"

        if (present(error)) then
          error = ELPA_ERROR_CANNOT_OPEN_FILE
        endif
      endif
    end subroutine


    !c> 
    !c> void elpa_store_settings(elpa_t handle, const char *filename, int *error);
    subroutine elpa_store_settings_c(handle, filename_p, error) bind(C, name="elpa_store_settings")
      type(c_ptr), value         :: handle
      type(elpa_impl_t), pointer :: self
      type(c_ptr), intent(in), value :: filename_p
      character(len=elpa_strlen_c(filename_p)), pointer :: filename
      integer(kind=c_int)        :: error

      call c_f_pointer(handle, self)
      call c_f_pointer(filename_p, filename)
      call elpa_store_settings(self, filename, error)

    end subroutine


    !c> 
    !c_no> #if OPTIONAL_C_ERROR_ARGUMENT != 1
    !c_no> void elpa_autotune_deallocate(elpa_autotune_t handle, int *error);
    !c_no> #endif
    subroutine elpa_autotune_impl_deallocate( autotune_handle, error) bind(C, name="elpa_autotune_deallocate")
      type(c_ptr), value                  :: autotune_handle

      type(elpa_autotune_impl_t), pointer :: self
      integer(kind=c_int)                 :: error
      call c_f_pointer(autotune_handle, self)
      call self%destroy(error)
      deallocate(self)
    end subroutine


    !> \brief function to setup an ELPA object and to store the MPI communicators internally
    !> Parameters
    !> \param   self       class(elpa_impl_t), the allocated ELPA object
    !> \result  error      integer, the error code
    function elpa_setup(self) result(error)
      use elpa_scalapack_interfaces
      class(elpa_impl_t), intent(inout)   :: self
      integer                             :: error, timings, performance, build_config

      integer                             :: mpi_comm_parent, mpi_comm_rows, mpi_comm_cols, np_rows, np_cols, my_id, &
                                             process_row, process_col, mpi_string_length, &
                                             present_np_rows, present_np_cols, np_total
      integer(kind=MPI_KIND)              :: mpierr, mpierr2, my_idMPI, np_totalMPI, process_rowMPI, process_colMPI
      integer(kind=MPI_KIND)              :: mpi_comm_rowsMPI, mpi_comm_colsMPI, np_rowsMPI, np_colsMPI, &
                                             mpi_string_lengthMPI, my_pcolMPI, my_prowMPI, providedMPI
      character(len=MPI_MAX_ERROR_STRING) :: mpierr_string
      integer(kind=BLAS_KIND)             :: numroc_resultBLAS
      integer(kind=c_int)                 :: info, na, nblk, na_rows, my_pcol, my_prow, numroc_result
      character(*), parameter             :: MPI_CONSISTENCY_MSG = &
        "Provide mpi_comm_parent and EITHER process_row and process_col OR mpi_comm_rows and mpi_comm_cols. Aborting..."



      call self%get("timings",timings, error)
      call self%get("measure_performance",performance, error)
      if (check_elpa_get(error, ELPA_ERROR_SETUP)) return
      if (timings == 1) then
        call self%timer%enable()
        if (performance == 1) then
          call self%timer%measure_flops(.true.)
          call self%timer%set_print_options(print_flop_count=.true.,print_flop_rate=.true.)
        endif
      endif

      error = ELPA_OK

      ! In most cases, we actually need the parent communicator to be supplied,
      ! ELPA internally requires it when either GPU is enabled or when ELPA2 is
      ! used. It thus seems reasonable that we should ALLWAYS require it. It
      ! should then be accompanied by EITHER process_row and process_col
      ! indices, OR mpi_comm_rows and mpi_comm_cols communicators, but NOT both.
      ! This assumption will significanlty simplify the logic, avoid possible
      ! inconsistencies and is rather natural from the user point of view

      if (self%is_set("mpi_comm_parent") == 1) then
        call self%get("mpi_comm_parent", mpi_comm_parent, error)
        if (check_elpa_get(error, ELPA_ERROR_SETUP)) return

        call mpi_comm_rank(int(mpi_comm_parent,kind=MPI_KIND), my_idMPI, mpierr)
        my_id = int(my_idMPI, kind=c_int)
        call self%set("process_id", my_id, error)
        if (check_elpa_set(error, ELPA_ERROR_SETUP)) return

        call mpi_comm_size(int(mpi_comm_parent,kind=MPI_KIND), np_totalMPI, mpierr)
        np_total = int(np_totalMPI,kind=c_int)
        call self%set("num_processes", np_total, error)
        if (check_elpa_set(error, ELPA_ERROR_SETUP)) return
      else

        if (self%from_legacy_api .ne. 1) then
          write(error_unit,*) MPI_CONSISTENCY_MSG
          error = ELPA_ERROR
          return
        endif
      endif


      ! Create communicators ourselves
      if (self%is_set("process_row") == 1 .and. self%is_set("process_col") == 1) then

        if (self%is_set("mpi_comm_rows") == 1 .or. self%is_set("mpi_comm_cols") == 1) then
          write(error_unit,*) MPI_CONSISTENCY_MSG
          error = ELPA_ERROR
          return
        endif

        call self%get("process_row", process_row, error)
        if (check_elpa_get(error, ELPA_ERROR_SETUP)) return

        call self%get("process_col", process_col, error)
        if (check_elpa_get(error, ELPA_ERROR_SETUP)) return

        ! mpi_comm_rows is used for communicating WITHIN rows, i.e. all processes
        ! having the same column coordinate share one mpi_comm_rows.
        ! So the "color" for splitting is process_col and the "key" is my row coordinate.
        ! Analogous for mpi_comm_cols

        call mpi_comm_split(int(mpi_comm_parent,kind=MPI_KIND), int(process_col,kind=MPI_KIND), &
                            int(process_row,kind=MPI_KIND), mpi_comm_rowsMPI, mpierr)
        mpi_comm_rows = int(mpi_comm_rowsMPI,kind=c_int)
        if (mpierr .ne. MPI_SUCCESS) then
          call MPI_ERROR_STRING(mpierr, mpierr_string, mpi_string_lengthMPI, mpierr2)
          mpi_string_length = int(mpi_string_lengthMPI, kind=c_int)
          write(error_unit,*) "MPI ERROR occured during mpi_comm_split for row communicator: ", trim(mpierr_string)
          return
        endif

        call mpi_comm_split(int(mpi_comm_parent,kind=MPI_KIND), int(process_row,kind=MPI_KIND), &
                            int(process_col,kind=MPI_KIND), mpi_comm_colsMPI, mpierr)
        mpi_comm_cols = int(mpi_comm_colsMPI,kind=c_int)
        if (mpierr .ne. MPI_SUCCESS) then
          call MPI_ERROR_STRING(mpierr, mpierr_string, mpi_string_lengthMPI, mpierr2)
          mpi_string_length = int(mpi_string_lengthMPI, kind=c_int)
          write(error_unit,*) "MPI ERROR occured during mpi_comm_split for col communicator: ", trim(mpierr_string)
          return
        endif

        call self%set("mpi_comm_rows", mpi_comm_rows,error)
        if (check_elpa_set(error, ELPA_ERROR_SETUP)) return

        call self%set("mpi_comm_cols", mpi_comm_cols,error)
        if (check_elpa_set(error, ELPA_ERROR_SETUP)) return

        ! remember that we created those communicators and we need to free them later
        self%communicators_owned = 1

      ! Externally supplied communicators
      else if ( self%is_set("mpi_comm_rows") == 1 .and.  self%is_set("mpi_comm_cols") == 1) then

        if (self%is_set("process_row") == 1 .or. self%is_set("process_col") == 1) then
          write(error_unit,*) MPI_CONSISTENCY_MSG
          error = ELPA_ERROR
          return
        endif

        call self%get("mpi_comm_rows", mpi_comm_rows,error)
        if (check_elpa_get(error, ELPA_ERROR_SETUP)) return

        call self%get("mpi_comm_cols", mpi_comm_cols,error)
        if (check_elpa_get(error, ELPA_ERROR_SETUP)) return

        call mpi_comm_rank(int(mpi_comm_rows,kind=MPI_KIND), process_rowMPI, mpierr)
        process_row = int(process_rowMPI,kind=c_int)
        call self%set("process_row", process_row, error)
        if (check_elpa_set(error, ELPA_ERROR_SETUP)) return

        call mpi_comm_rank(int(mpi_comm_cols,kind=MPI_KIND), process_colMPI, mpierr)
        process_col = int(process_colMPI,kind=c_int)
        call self%set("process_col", process_col, error)
        if (check_elpa_set(error, ELPA_ERROR_SETUP)) return

        ! remember that we DID NOT created those communicators and we WILL NOT free them later
        self%communicators_owned = 0
      else
        ! Otherwise parameters are missing
        write(error_unit,*) MPI_CONSISTENCY_MSG
        error = ELPA_ERROR
        return
      endif

      ! set num_process_rows (and cols), if they are not supplied. Check them
      ! for consistency if they are. Maybe we could instead require, that they
      ! are never supplied?
      call mpi_comm_size(int(mpi_comm_rows,kind=MPI_KIND), np_rowsMPI, mpierr)
      np_rows = int(np_rowsMPI, kind=c_int)
      if (self%is_set("num_process_rows") == 1) then
        call self%get("num_process_rows", present_np_rows, error)
        if (check_elpa_get(error, ELPA_ERROR_SETUP)) return

        if (np_rows .ne. present_np_rows) then
          print *,"MPI row communicator not set correctly. Aborting..."
          stop
        endif
      else
        call self%set("num_process_rows", np_rows, error)
        if (check_elpa_set(error, ELPA_ERROR_SETUP)) return
      endif

      call mpi_comm_size(int(mpi_comm_cols,kind=MPI_KIND), np_colsMPI, mpierr)
      np_cols = int(np_colsMPI, kind=c_int)
      if (self%is_set("num_process_cols") == 1) then
        call self%get("num_process_cols", present_np_cols, error)
        if (check_elpa_get(error, ELPA_ERROR_SETUP)) return

        if (np_cols .ne. present_np_cols) then
          print *,"MPI column communicator not set correctly. Aborting..."
          stop
        endif
      else
        call self%set("num_process_cols", np_cols, error)
        if (check_elpa_set(error, ELPA_ERROR_SETUP)) return
      endif

      if (self%from_legacy_api .ne. 1) then
        if (np_total .ne. np_rows * np_cols) then
          print *,"MPI parent communicator and row/col communicators do not match. Aborting..."
          stop
        endif
      endif

      ! check first whether BLACS-GRID, which was setup by the user is reasonable. Too often this is _not_ done by the
      ! user and then there are complaints about "errors" in ELPA but the problem is in a misconfigured setup
      call mpi_comm_rank(int(mpi_comm_rows,kind=MPI_KIND) ,my_prowMPI ,mpierr)
      call mpi_comm_rank(int(mpi_comm_cols,kind=MPI_KIND) ,my_pcolMPI ,mpierr)

      my_prow = int(my_prowMPI, kind=c_int)
      my_pcol = int(my_pcolMPI, kind=c_int)

      call self%get("na", na, error)
      if (check_elpa_set(error, ELPA_ERROR_SETUP)) return

      call self%get("nblk", nblk, error)
      if (check_elpa_set(error, ELPA_ERROR_SETUP)) return

      call self%get("local_nrows", na_rows, error)
      if (check_elpa_set(error, ELPA_ERROR_SETUP)) return

      numroc_resultBLAS = numroc(int(na, kind=BLAS_KIND), int(nblk, kind=BLAS_KIND), int(my_prow, kind=BLAS_KIND), &
                                 0_BLAS_KIND, int(np_rows, kind=BLAS_KIND))
      numroc_result=int(numroc_resultBLAS, kind=c_int)
      info = 0
      if ( na < 0 ) then
        info = -2
      else if ( nblk < 1 ) then
        info = -4
      else if ( np_rows .eq. -1 ) then
        info = -8
      else if ( na_rows < max( 1, numroc_result ) ) then
        info = -9
      endif

      if (info .ne. 0) then
        print *,"ELPA_SETUP ERROR: your provided blacsgrid is not ok!"
        print *,"BLACS_GRIDINFO returned an error! Aborting..."
        error = ELPA_ERROR_SETUP
        return
      endif



      self%myGlobalId = my_id

    end function


    !c> 
    !c> int elpa_setup(elpa_t handle);
    function elpa_setup_c(handle) result(error) bind(C, name="elpa_setup")
      type(c_ptr), intent(in), value :: handle
      type(elpa_impl_t), pointer :: self
      integer(kind=c_int) :: error

      call c_f_pointer(handle, self)
      error = self%setup()
    end function

    function elpa_construct_scalapack_descriptor(self, sc_desc, rectangular_for_ev) result(error)
      class(elpa_impl_t), intent(inout)   :: self
      logical, intent(in)                 :: rectangular_for_ev
      integer                             :: error, blacs_ctx
      integer, intent(out)                :: sc_desc(SC_DESC_LEN)

      if (self%is_set("blacs_context") == 0) then
        print *,"BLACS context has not been set beforehand. Aborting..."
        stop
      endif
      call self%get("blacs_context", blacs_ctx, error)
      if (check_elpa_get(error, ELPA_ERROR_CRITICAL)) return

      sc_desc(1) = 1
      sc_desc(2) = blacs_ctx
      sc_desc(3) = self%na
      if (rectangular_for_ev) then
        sc_desc(4) = self%nev
      else
        sc_desc(4) = self%na
      endif
      sc_desc(5) = self%nblk
      sc_desc(6) = self%nblk
      sc_desc(7) = 0
      sc_desc(8) = 0
      sc_desc(9) = self%local_nrows
      error = ELPA_OK
    end function


    !c> 
    !c> void elpa_set_integer(elpa_t handle, const char *name, int value, int *error);
    subroutine elpa_set_integer_c(handle, name_p, value, error) bind(C, name="elpa_set_integer")
      type(c_ptr), intent(in), value                :: handle
      type(elpa_impl_t), pointer                    :: self
      type(c_ptr), intent(in), value                :: name_p
      character(len=elpa_strlen_c(name_p)), pointer :: name
      integer(kind=c_int), intent(in), value        :: value
      integer(kind=c_int) , intent(in)              :: error

      call c_f_pointer(handle, self)
      call c_f_pointer(name_p, name)
      call elpa_set_integer(self, name, value, error)
    end subroutine


    !c> 
    !c> void elpa_get_integer(elpa_t handle, const char *name, int *value, int *error);
    subroutine elpa_get_integer_c(handle, name_p, value, error) bind(C, name="elpa_get_integer")
      type(c_ptr), intent(in), value                :: handle
      type(elpa_impl_t), pointer                    :: self
      type(c_ptr), intent(in), value                :: name_p
      character(len=elpa_strlen_c(name_p)), pointer :: name
      integer(kind=c_int)                           :: value
      integer(kind=c_int), intent(inout)            :: error

      call c_f_pointer(handle, self)
      call c_f_pointer(name_p, name)
      call elpa_get_integer(self, name, value, error)
    end subroutine


    !> \brief function to check whether a key/value pair is set
    !> Parameters
    !> \param   self       class(elpa_impl_t) the allocated ELPA object
    !> \param   name       string, the key
    !> \result  state      integer, the state of the key/value pair
    function elpa_is_set(self, name) result(state)
      class(elpa_impl_t)       :: self
      character(*), intent(in) :: name
      integer                  :: state

      state = elpa_index_value_is_set_c(self%index, name // c_null_char)
    end function

    !> \brief function to check whether a key/value pair can be set
    !> Parameters
    !> \param   self       class(elpa_impl_t) the allocated ELPA object
    !> \param   name       string, the key
    !> \param   value      integer, value
    !> \result  error      integer, error code
    function elpa_can_set(self, name, value) result(error)
      class(elpa_impl_t)       :: self
      character(*), intent(in) :: name
      integer(kind=c_int), intent(in) :: value
      integer                  :: error

      error = elpa_index_int_is_valid_c(self%index, name // c_null_char, value)
    end function


    !> \brief function to convert a value to an human readable string
    !> Parameters
    !> \param   self        class(elpa_impl_t) the allocated ELPA object
    !> \param   option_name string: the name of the options, whose value should be converted
    !> \param   error       integer: errpr code
    !> \result  string      string: the humanreadable string
    function elpa_value_to_string(self, option_name, error) result(string)
      class(elpa_impl_t), intent(in) :: self
      character(kind=c_char, len=*), intent(in) :: option_name
      type(c_ptr) :: ptr
      integer, intent(out), optional :: error

      integer :: val, actual_error
      character(kind=c_char, len=elpa_index_int_value_to_strlen_c(self%index, option_name // C_NULL_CHAR)), pointer :: string

      nullify(string)

      call self%get(option_name, val, actual_error)
      if (actual_error /= ELPA_OK) then
        if (present(error)) then
          error = actual_error
        endif
        return
      endif

      actual_error = elpa_int_value_to_string_c(option_name // C_NULL_CHAR, val, ptr)
      if (c_associated(ptr)) then
        call c_f_pointer(ptr, string)
      endif

      if (present(error)) then
        error = actual_error
      endif
    end function


    !c> 
    !c> void elpa_set_float(elpa_t handle, const char *name, float value, int *error);
    subroutine elpa_set_float_c(handle, name_p, value, error) bind(C, name="elpa_set_float")
      type(c_ptr), intent(in), value                :: handle
      type(elpa_impl_t), pointer                    :: self
      type(c_ptr), intent(in), value                :: name_p
      character(len=elpa_strlen_c(name_p)), pointer :: name
      real(kind=c_float), intent(in), value        :: value
      integer(kind=c_int), intent(in)               :: error

      call c_f_pointer(handle, self)
      call c_f_pointer(name_p, name)
      call elpa_set_float(self, name, value, error)
    end subroutine


    !c> 
    !c> void elpa_get_float(elpa_t handle, const char *name, float *value, int *error);
    subroutine elpa_get_float_c(handle, name_p, value, error) bind(C, name="elpa_get_float")
      type(c_ptr), intent(in), value                :: handle
      type(elpa_impl_t), pointer                    :: self
      type(c_ptr), intent(in), value                :: name_p
      character(len=elpa_strlen_c(name_p)), pointer :: name
      real(kind=c_float)                           :: value
      integer(kind=c_int), intent(inout)            :: error

      call c_f_pointer(handle, self)
      call c_f_pointer(name_p, name)
      call elpa_get_float(self, name, value, error)
    end subroutine


    !c> 
    !c> void elpa_set_double(elpa_t handle, const char *name, double value, int *error);
    subroutine elpa_set_double_c(handle, name_p, value, error) bind(C, name="elpa_set_double")
      type(c_ptr), intent(in), value                :: handle
      type(elpa_impl_t), pointer                    :: self
      type(c_ptr), intent(in), value                :: name_p
      character(len=elpa_strlen_c(name_p)), pointer :: name
      real(kind=c_double), intent(in), value        :: value
      integer(kind=c_int), intent(in)               :: error

      call c_f_pointer(handle, self)
      call c_f_pointer(name_p, name)
      call elpa_set_double(self, name, value, error)
    end subroutine


    !c> 
    !c> void elpa_get_double(elpa_t handle, const char *name, double *value, int *error);
    subroutine elpa_get_double_c(handle, name_p, value, error) bind(C, name="elpa_get_double")
      type(c_ptr), intent(in), value                :: handle
      type(elpa_impl_t), pointer                    :: self
      type(c_ptr), intent(in), value                :: name_p
      character(len=elpa_strlen_c(name_p)), pointer :: name
      real(kind=c_double)                           :: value
      integer(kind=c_int), intent(inout)            :: error

      call c_f_pointer(handle, self)
      call c_f_pointer(name_p, name)
      call elpa_get_double(self, name, value, error)
    end subroutine


    !> \brief function to associate a pointer with an integer value
    !> Parameters
    !> \param   self        class(elpa_impl_t) the allocated ELPA object
    !> \param   name        string: the name of the entry
    !> \result  value       integer, pointer: the value for the entry
    function elpa_associate_int(self, name) result(value)
      class(elpa_impl_t)             :: self
      character(*), intent(in)       :: name
      integer(kind=c_int), pointer   :: value

      type(c_ptr)                    :: value_p

      value_p = elpa_index_get_int_loc_c(self%index, name // c_null_char)
      if (.not. c_associated(value_p)) then
        write(error_unit, '(a,a,a)') "ELPA: Warning, received NULL pointer for entry '", name, "'"
      endif
      call c_f_pointer(value_p, value)
    end function


    !> \brief function to querry the timing information at a certain level
    !> Parameters
    !> \param   self            class(elpa_impl_t) the allocated ELPA object
    !> \param   name1 .. name6  string: the string identifier for the timer region.
    !>                                  at the moment 6 nested levels can be queried
    !> \result  s               double: the timer metric for the region. Might be seconds,
    !>                                  or any other supported metric
    function elpa_get_time(self, name1, name2, name3, name4, name5, name6) result(s)
      class(elpa_impl_t), intent(in) :: self
      ! this is clunky, but what can you do..
      character(len=*), intent(in), optional :: name1, name2, name3, name4, name5, name6
      real(kind=c_double) :: s

      s = self%timer%get(name1, name2, name3, name4, name5, name6)
    end function


    !> \brief function to print the timing tree below at a certain level
    !> Parameters
    !> \param   self            class(elpa_impl_t) the allocated ELPA object
    !> \param   name1 .. name6  string: the string identifier for the timer region.
    !>                                  at the moment 4 nested levels can be specified
    subroutine elpa_print_times(self, name1, name2, name3, name4)
      class(elpa_impl_t), intent(in) :: self
      character(len=*), intent(in), optional :: name1, name2, name3, name4
      call self%timer%print(name1, name2, name3, name4)
    end subroutine


    !> \brief function to start the timing of a code region
    !> Parameters
    !> \param   self            class(elpa_impl_t) the allocated ELPA object
    !> \param   name            string: a chosen identifier name for the code region
    subroutine elpa_timer_start(self, name)
      class(elpa_impl_t), intent(inout) :: self
      character(len=*), intent(in) :: name
      call self%timer%start(name)
    end subroutine


    !> \brief function to stop the timing of a code region
    !> Parameters
    !> \param   self            class(elpa_impl_t) the allocated ELPA object
    !> \param   name            string: identifier name for the code region to stop
    subroutine elpa_timer_stop(self, name)
      class(elpa_impl_t), intent(inout) :: self
      character(len=*), intent(in) :: name
      call self%timer%stop(name)
    end subroutine


    !> \brief function to destroy an elpa object
    !> Parameters
    !> \param   self            class(elpa_impl_t) the allocated ELPA object
    !> \param   error           integer, optional error code
    subroutine elpa_destroy(self, error)
      integer                              :: mpi_comm_rows, mpi_comm_cols, &
                                              mpi_string_length
      integer(kind=MPI_KIND)               :: mpierr, mpierr2, mpi_string_lengthMPI, &
                                              mpi_comm_rowsMPI, mpi_comm_colsMPI
      character(len=MPI_MAX_ERROR_STRING)  :: mpierr_string
      class(elpa_impl_t)                   :: self
      integer, optional, intent(out)       :: error
      integer                              :: error2

      if (present(error)) then
        error = ELPA_OK
      endif


      if (self%communicators_owned == 1) then
        call self%get("mpi_comm_rows", mpi_comm_rows, error2)
        if (error2 .ne. ELPA_OK) then
          if (present(error)) then
            error = error2
          else
            write(error_unit, *) "Error in elpa_destroy but you do not check the error codes!"
          endif
          return
        endif ! error happend

        call self%get("mpi_comm_cols", mpi_comm_cols,error2)
        if (error2 .ne. ELPA_OK) then
          if (present(error)) then
            error = error2
          else
            write(error_unit, *) "Error in elpa_destroy but you do not check the error codes!"
          endif
          return
        endif ! error happend

        ! this is just for debugging ! do not leave in a relase
        !write(error_unit, '(A,2I13)') "FREE comms", mpi_comm_rows, mpi_comm_cols
        mpi_comm_rowsMPI = int(mpi_comm_rows,kind=MPI_KIND)
        call mpi_comm_free(mpi_comm_rowsMPI, mpierr)
        mpi_comm_rows = int(mpi_comm_rowsMPI,kind=c_int)
        if (mpierr .ne. MPI_SUCCESS) then
          call MPI_ERROR_STRING(mpierr, mpierr_string, mpi_string_lengthMPI, mpierr2)
          mpi_string_length = int(mpi_string_lengthMPI,kind=c_int)
          write(error_unit,*) "MPI ERROR occured during mpi_comm_free for row communicator: ", trim(mpierr_string)
          if (present(error)) then
            error = ELPA_ERROR_CRITICAL
          endif
          return
        endif ! mpierr happend
        call self%set("mpi_comm_cols", -12345, error2)
        if (error2 .ne. ELPA_OK) then
          if (present(error)) then
            error = error2
          else
            write(error_unit, *) "Error in elpa_destroy but you do not check the error codes!"
          endif
          return
        endif ! error happend
        mpi_comm_colsMPI = int(mpi_comm_cols,kind=MPI_KIND)
        call mpi_comm_free(mpi_comm_colsMPI, mpierr)
        mpi_comm_cols = int(mpi_comm_colsMPI, kind=c_int)
        if (mpierr .ne. MPI_SUCCESS) then
          call MPI_ERROR_STRING(mpierr, mpierr_string, mpi_string_lengthMPI, mpierr2)
          mpi_string_length = int(mpi_string_lengthMPI,kind=c_int)
          write(error_unit,*) "MPI ERROR occured during mpi_comm_free for col communicator: ", trim(mpierr_string)
          if (present(error)) then
            error = ELPA_ERROR_CRITICAL
          endif
          return
        endif ! mpierr happend
        call self%set("mpi_comm_rows", -12345,error2)
        if (error2 .ne. ELPA_OK) then
          if (present(error)) then
            error = error2
          else
            write(error_unit, *) "Error in elpa_destroy but you do not check the error codes!"
          endif
          return
        endif ! error happend
      endif

      call timer_free(self%timer)
      call timer_free(self%autotune_timer)
      call elpa_index_free_c(self%index)

    end subroutine

















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
    !>  \brief elpa_eigenvectors_d: class method to solve the eigenvalue problem
    !>
    !>  The dimensions of the matrix a (locally ditributed and global), the block-cyclic distribution
    !>  blocksize, the number of eigenvectors
    !>  to be computed and the MPI communicators are already known to the object and MUST be set BEFORE
    !>  with the class method "setup"
    !>
    !>  It is possible to change the behaviour of the method by setting tunable parameters with the
    !>  class method "set"
    !>
    !>  Parameters
    !>
    !>  \param a                                    Distributed matrix for which eigenvalues are to be computed.
    !>                                              Distribution is like in Scalapack.
    !>                                              The full matrix must be set (not only one half like in scalapack).
    !>                                              Destroyed on exit (upper and lower half).
    !>
    !>  \param ev                                   On output: eigenvalues of a, every processor gets the complete set
    !>
    !>  \param q                                    On output: Eigenvectors of a
    !>                                              Distribution is like in Scalapack.
    !>                                              Must be always dimensioned to the full size (corresponding to (na,na))
    !>                                              even if only a part of the eigenvalues is needed.
    !>
    !>  \param error                                integer, optional: returns an error code, which can be queried with elpa_strerr   

    subroutine elpa_eigenvectors_all_host_arrays_&
                    &d&
                    & (self, a, ev, q, error)
      class(elpa_impl_t)  :: self

      real(kind=c_double) :: a(self%local_nrows, *), q(self%local_nrows, *)
      real(kind=c_double) :: ev(self%na)

      integer, optional   :: error
      integer             :: error2
      integer(kind=c_int) :: solver
      logical             :: success_l

      success_l = .false.
      call self%get("solver", solver,error2)
      if (error2 .ne. ELPA_OK) then
        print *,"Problem setting solver. Aborting..."
        if (present(error)) then
          error = error2
        endif
        return
      endif
      if (solver .eq. ELPA_SOLVER_1STAGE) then
        call self%autotune_timer%start("accumulator")
        success_l = elpa_solve_evp_&
                &real&
                &_1stage_all_host_arrays_&
                &double&
                &_impl(self, a, ev, q)
        call self%autotune_timer%stop("accumulator")

      else if (solver .eq. ELPA_SOLVER_2STAGE) then
        call self%autotune_timer%start("accumulator")
        success_l = elpa_solve_evp_&
                &real&
                &_2stage_all_host_arrays_&
                &double&
                &_impl(self, a, ev, q)
        call self%autotune_timer%stop("accumulator")

      else
        print *,"unknown solver"
        stop
      endif

      if (present(error)) then
        if (success_l) then
          error = ELPA_OK
        else
          error = ELPA_ERROR
        endif
      else if (.not. success_l) then
        write(error_unit,'(a)') "ELPA: Error in eigenvectors() and you did not check for errors!"
      endif
    end subroutine 

    !>  \brief elpa_eigenvectors_device_pointer_d: class method to solve the eigenvalue problem
    !>
    !>  The dimensions of the matrix a (locally ditributed and global), the block-cyclic distribution
    !>  blocksize, the number of eigenvectors
    !>  to be computed and the MPI communicators are already known to the object and MUST be set BEFORE
    !>  with the class method "setup"
    !>
    !>  It is possible to change the behaviour of the method by setting tunable parameters with the
    !>  class method "set"
    !>
    !>  Parameters
    !>
    !>  \param a                                    Distributed matrix for which eigenvalues are to be computed.
    !>                                              Distribution is like in Scalapack.
    !>                                              The full matrix must be set (not only one half like in scalapack).
    !>                                              Destroyed on exit (upper and lower half).
    !>
    !>  \param ev                                   On output: eigenvalues of a, every processor gets the complete set
    !>
    !>  \param q                                    On output: Eigenvectors of a
    !>                                              Distribution is like in Scalapack.
    !>                                              Must be always dimensioned to the full size (corresponding to (na,na))
    !>                                              even if only a part of the eigenvalues is needed.
    !>
    !>  \param error                                integer, optional: returns an error code, which can be queried with elpa_strerr   

    subroutine elpa_eigenvectors_device_pointer_&
                    &d&
                    & (self, a, ev, q, error)
      use iso_c_binding

      implicit none
      class(elpa_impl_t)  :: self

      type(c_ptr)         :: a, q, ev

      integer, optional   :: error
      integer             :: error2
      integer(kind=c_int) :: solver
      logical             :: success_l

      success_l = .false.
      call self%get("solver", solver,error2)
      if (error2 .ne. ELPA_OK) then
        print *,"Problem setting solver. Aborting..."
        if (present(error)) then
          error = error2
        endif
        return
      endif
      if (solver .eq. ELPA_SOLVER_1STAGE) then
        call self%autotune_timer%start("accumulator")
        success_l = elpa_solve_evp_&
                &real&
                &_1stage_device_pointer_&
                &double&
                &_impl(self, a, ev, q)
        call self%autotune_timer%stop("accumulator")

      else if (solver .eq. ELPA_SOLVER_2STAGE) then
        call self%autotune_timer%start("accumulator")
        success_l = elpa_solve_evp_&
                &real&
                &_2stage_device_pointer_&
                &double&
                &_impl(self, a, ev, q)
        call self%autotune_timer%stop("accumulator")

      else
        print *,"unknown solver"
        stop
      endif

      if (present(error)) then
        if (success_l) then
          error = ELPA_OK
        else
          error = ELPA_ERROR
        endif
      else if (.not. success_l) then
        write(error_unit,'(a)') "ELPA: Error in eigenvectors() and you did not check for errors!"
      endif
    end subroutine 

    !c> void elpa_eigenvectors_all_host_arrays_d(elpa_t handle, double *a, double *ev, double *q, int *error);
    subroutine elpa_eigenvectors_all_host_arrays_&
                    &d&
                    &_c(handle, a_p, ev_p, q_p, error) &
                    bind(C, name="elpa_eigenvectors_all_host_arrays_d")
      type(c_ptr), intent(in), value            :: handle, a_p, ev_p, q_p
      integer(kind=c_int), optional, intent(in) :: error

      real(kind=c_double), pointer :: a(:, :), q(:, :)
      real(kind=c_double), pointer          :: ev(:)
      type(elpa_impl_t), pointer                   :: self

      call c_f_pointer(handle, self)
      call c_f_pointer(a_p, a, [self%local_nrows, self%local_ncols])
      call c_f_pointer(ev_p, ev, [self%na])
      call c_f_pointer(q_p, q, [self%local_nrows, self%local_ncols])

      call elpa_eigenvectors_all_host_arrays_&
              &d&
              & (self, a, ev, q, error)
    end subroutine    

    !c> void elpa_eigenvectors_device_pointer_d(elpa_t handle, double *a, double *ev, double *q, int *error);
    subroutine elpa_eigenvectors_device_pointer_&
                    &d&
                    &_c(handle, a_p, ev_p, q_p, error) &
                    bind(C, name="elpa_eigenvectors_device_pointer_d")
      type(c_ptr), intent(in), value            :: handle, a_p, ev_p, q_p
      integer(kind=c_int), optional, intent(in) :: error

      !real(kind=c_double), pointer :: a(:, :), q(:, :)
      !real(kind=c_double), pointer          :: ev(:)
      type(elpa_impl_t), pointer                   :: self

      !call c_f_pointer(handle, self)
      !call c_f_pointer(a_p, a, [self%local_nrows, self%local_ncols])
      !call c_f_pointer(ev_p, ev, [self%na])
      !call c_f_pointer(q_p, q, [self%local_nrows, self%local_ncols])

      call elpa_eigenvectors_device_pointer_&
              &d&
              & (self, a_p, ev_p, q_p, error)
    end subroutine

    !>  \brief elpa_skew_eigenvectors_d: class method to solve the real valued skew-symmetric eigenvalue problem
    !>
    !>  The dimensions of the matrix a (locally ditributed and global), the block-cyclic distribution
    !>  blocksize, the number of eigenvectors
    !>  to be computed and the MPI communicators are already known to the object and MUST be set BEFORE
    !>  with the class method "setup"
    !>
    !>  It is possible to change the behaviour of the method by setting tunable parameters with the
    !>  class method "set"
    !>
    !>  Parameters
    !>
    !>  \param a                                    Distributed matrix for which eigenvalues are to be computed.
    !>                                              Distribution is like in Scalapack.
    !>                                              The full matrix must be set (not only one half like in scalapack).
    !>                                              Destroyed on exit (upper and lower half).
    !>
    !>  \param ev                                   On output: eigenvalues of a, every processor gets the complete set
    !>
    !>  \param q                                    On output: Eigenvectors of a
    !>                                              Distribution is like in Scalapack.
    !>                                              Must be always dimensioned to the full size (corresponding to (na,na))
    !>                                              even if only a part of the eigenvalues is needed.
    !>
    !>  \param error                                integer, optional: returns an error code, which can be queried with elpa_strerr   

    subroutine elpa_skew_eigenvectors_all_host_arrays_&
                    &d&
                    & (self, a, ev, q, error)
      class(elpa_impl_t)  :: self

      real(kind=c_double) :: a(self%local_nrows, *), q(self%local_nrows, *)
      real(kind=c_double)          :: ev(self%na)

      integer, optional                   :: error
      integer                             :: error2
      integer(kind=c_int)                 :: solver
      logical                             :: success_l

      success_l = .false.
      call self%get("solver", solver,error2)
      !call self%set("is_skewsymmetric",1,error2)
      if (error2 .ne. ELPA_OK) then
        print *,"Problem setting is_skewsymmetric. Aborting..."
        if (present(error)) then
          error = error2
        endif
        return
      endif
      if (solver .eq. ELPA_SOLVER_1STAGE) then
        call self%autotune_timer%start("accumulator")
        success_l = elpa_solve_skew_evp_&
                &real&
                &_1stage_all_host_arrays_&
                &double&
                &_impl(self, a, ev, q)
        call self%autotune_timer%stop("accumulator")

      else if (solver .eq. ELPA_SOLVER_2STAGE) then
        call self%autotune_timer%start("accumulator")
        success_l = elpa_solve_skew_evp_&
                &real&
                &_2stage_all_host_arrays_&
                &double&
                &_impl(self, a, ev, q)
        call self%autotune_timer%stop("accumulator")

      else
        print *,"unknown solver"
        stop
      endif

      if (present(error)) then
        if (success_l) then
          error = ELPA_OK
        else
          error = ELPA_ERROR
        endif
      else if (.not. success_l) then
        write(error_unit,'(a)') "ELPA: Error in skew_eigenvectors() and you did not check for errors!"
      endif
    end subroutine

    !c> void elpa_skew_eigenvectors_all_host_arrays_d(elpa_t handle, double *a, double *ev, double *q, int *error);
    subroutine elpa_skew_eigenvectors_all_host_arrays_&
                    &d&
                    &_c(handle, a_p, ev_p, q_p, error) &
                    bind(C, name="elpa_skew_eigenvectors_all_host_arrays_d")

      type(c_ptr), intent(in), value            :: handle, a_p, ev_p, q_p
      integer(kind=c_int), optional, intent(in) :: error

      real(kind=c_double), pointer :: a(:, :), q(:, :)
      real(kind=c_double), pointer          :: ev(:)
      type(elpa_impl_t), pointer                   :: self

      call c_f_pointer(handle, self)
      call c_f_pointer(a_p, a, [self%local_nrows, self%local_ncols])
      call c_f_pointer(ev_p, ev, [self%na])
      call c_f_pointer(q_p, q, [self%local_nrows, self%local_ncols])

      call elpa_skew_eigenvectors_all_host_arrays_&
              &d&
              & (self, a, ev, q, error)
    end subroutine

    !>  \brief elpa_skew_eigenvectors_d: class method to solve the real valued skew-symmetric eigenvalue problem
    !>
    !>  The dimensions of the matrix a (locally ditributed and global), the block-cyclic distribution
    !>  blocksize, the number of eigenvectors
    !>  to be computed and the MPI communicators are already known to the object and MUST be set BEFORE
    !>  with the class method "setup"
    !>
    !>  It is possible to change the behaviour of the method by setting tunable parameters with the
    !>  class method "set"
    !>
    !>  Parameters
    !>
    !>  \param a                                    Distributed matrix for which eigenvalues are to be computed.
    !>                                              Distribution is like in Scalapack.
    !>                                              The full matrix must be set (not only one half like in scalapack).
    !>                                              Destroyed on exit (upper and lower half).
    !>
    !>  \param ev                                   On output: eigenvalues of a, every processor gets the complete set
    !>
    !>  \param q                                    On output: Eigenvectors of a
    !>                                              Distribution is like in Scalapack.
    !>                                              Must be always dimensioned to the full size (corresponding to (na,na))
    !>                                              even if only a part of the eigenvalues is needed.
    !>
    !>  \param error                                integer, optional: returns an error code, which can be queried with elpa_strerr   

    subroutine elpa_skew_eigenvectors_device_pointer_&
                    &d&
                    & (self, a, ev, q, error)
      use iso_c_binding
      implicit none
      class(elpa_impl_t)  :: self

      type(c_ptr)         :: a, q, ev

      integer, optional                   :: error
      integer                             :: error2
      integer(kind=c_int)                 :: solver
      logical                             :: success_l

      success_l = .false.
      call self%get("solver", solver,error2)
      !call self%set("is_skewsymmetric",1,error2)
      if (error2 .ne. ELPA_OK) then
        print *,"Problem setting is_skewsymmetric. Aborting..."
        if (present(error)) then
          error = error2
        endif
        return
      endif
      if (solver .eq. ELPA_SOLVER_1STAGE) then
        call self%autotune_timer%start("accumulator")
        success_l = elpa_solve_skew_evp_&
                &real&
                &_1stage_device_pointer_&
                &double&
                &_impl(self, a, ev, q)
        call self%autotune_timer%stop("accumulator")

      else if (solver .eq. ELPA_SOLVER_2STAGE) then
        call self%autotune_timer%start("accumulator")
        success_l = elpa_solve_skew_evp_&
                &real&
                &_2stage_device_pointer_&
                &double&
                &_impl(self, a, ev, q)
        call self%autotune_timer%stop("accumulator")

      else
        print *,"unknown solver"
        stop
      endif

      if (present(error)) then
        if (success_l) then
          error = ELPA_OK
        else
          error = ELPA_ERROR
        endif
      else if (.not. success_l) then
        write(error_unit,'(a)') "ELPA: Error in skew_eigenvectors() and you did not check for errors!"
      endif
    end subroutine

    !c> void elpa_skew_eigenvectors_device_pointer_d(elpa_t handle, double *a, double *ev, double *q, int *error);
    subroutine elpa_skew_eigenvectors_device_pointer_&
                    &d&
                    &_c(handle, a_p, ev_p, q_p, error) &
                    bind(C, name="elpa_skew_eigenvectors_device_pointer_d")

      type(c_ptr), intent(in), value            :: handle, a_p, ev_p, q_p
      integer(kind=c_int), optional, intent(in) :: error

      !real(kind=c_double), pointer :: a(:, :), q(:, :)
      !real(kind=c_double), pointer          :: ev(:)
      type(elpa_impl_t), pointer                   :: self

      !call c_f_pointer(handle, self)
      !call c_f_pointer(a_p, a, [self%local_nrows, self%local_ncols])
      !call c_f_pointer(ev_p, ev, [self%na])
      !call c_f_pointer(q_p, q, [self%local_nrows, self%local_ncols])

      call elpa_skew_eigenvectors_device_pointer_&
              &d&
              & (self, a_p, ev_p, q_p, error)
    end subroutine


    !>  \brief elpa_eigenvalues_d: class method to solve the eigenvalue problem
    !>
    !>  The dimensions of the matrix a (locally ditributed and global), the block-cyclic distribution
    !>  blocksize, the number of eigenvectors
    !>  to be computed and the MPI communicators are already known to the object and MUST be set BEFORE
    !>  with the class method "setup"
    !>
    !>  It is possible to change the behaviour of the method by setting tunable parameters with the
    !>  class method "set"
    !>
    !>  Parameters
    !>
    !>  \param a                                    Distributed matrix for which eigenvalues are to be computed.
    !>                                              Distribution is like in Scalapack.
    !>                                              The full matrix must be set (not only one half like in scalapack).
    !>                                              Destroyed on exit (upper and lower half).
    !>
    !>  \param ev                                   On output: eigenvalues of a, every processor gets the complete set
    !>
    !>  \param error                                integer, optional: returns an error code, which can be queried with elpa_strerr
    subroutine elpa_eigenvalues_all_host_arrays_&
                    &d&
                    & (self, a, ev, error)
      class(elpa_impl_t)  :: self
      real(kind=c_double) :: a(self%local_nrows, *)
      real(kind=c_double) :: ev(self%na)
      integer, optional   :: error
      integer             :: error2
      integer(kind=c_int) :: solver
      logical             :: success_l

      success_l = .false.
      call self%get("solver", solver,error2)
      if (error2 .ne. ELPA_OK) then
         print *,"Problem getting solver option. Aborting..."
         if (present(error)) then
           error = error2
         endif
         return
      endif

      if (solver .eq. ELPA_SOLVER_1STAGE) then
        call self%autotune_timer%start("accumulator")
        success_l = elpa_solve_evp_&
                &real&
                          &_1stage_all_host_arrays_&
                          &double&
                          &_impl(self, a, ev)
        call self%autotune_timer%stop("accumulator")

      else if (solver .eq. ELPA_SOLVER_2STAGE) then
        call self%autotune_timer%start("accumulator")
        success_l = elpa_solve_evp_&
                &real&
                                   &_2stage_all_host_arrays_&
                                   &double&
                                   &_impl(self, a, ev)
        call self%autotune_timer%stop("accumulator")

      else
        print *,"unknown solver"
        stop
      endif
      if (present(error)) then
        if (success_l) then
          error = ELPA_OK
        else
          error = ELPA_ERROR
        endif
      else if (.not. success_l) then
        write(error_unit,'(a)') "ELPA: Error in eigenvalues() and you did not check for errors!"
      endif
    end subroutine


    !>  \brief elpa_eigenvalues_d: class method to solve the eigenvalue problem
    !>
    !>  The dimensions of the matrix a (locally ditributed and global), the block-cyclic distribution
    !>  blocksize, the number of eigenvectors
    !>  to be computed and the MPI communicators are already known to the object and MUST be set BEFORE
    !>  with the class method "setup"
    !>
    !>  It is possible to change the behaviour of the method by setting tunable parameters with the
    !>  class method "set"
    !>
    !>  Parameters
    !>
    !>  \param a                                    Distributed matrix for which eigenvalues are to be computed.
    !>                                              Distribution is like in Scalapack.
    !>                                              The full matrix must be set (not only one half like in scalapack).
    !>                                              Destroyed on exit (upper and lower half).
    !>
    !>  \param ev                                   On output: eigenvalues of a, every processor gets the complete set
    !>
    !>  \param error                                integer, optional: returns an error code, which can be queried with elpa_strerr
    subroutine elpa_eigenvalues_device_pointer_&
                    &d&
                    & (self, a, ev, error)
      use iso_c_binding
      implicit none

      class(elpa_impl_t)  :: self
      type(c_ptr)         :: a, ev
      integer, optional   :: error
      integer             :: error2
      integer(kind=c_int) :: solver
      logical             :: success_l

      success_l = .false.
      call self%get("solver", solver,error2)
      if (error2 .ne. ELPA_OK) then
         print *,"Problem getting solver option. Aborting..."
         if (present(error)) then
           error = error2
         endif
         return
      endif

      if (solver .eq. ELPA_SOLVER_1STAGE) then
        call self%autotune_timer%start("accumulator")
        success_l = elpa_solve_evp_&
                &real&
                          &_1stage_device_pointer_&
                          &double&
                          &_impl(self, a, ev)
        call self%autotune_timer%stop("accumulator")

      else if (solver .eq. ELPA_SOLVER_2STAGE) then
        call self%autotune_timer%start("accumulator")
        success_l = elpa_solve_evp_&
                &real&
                                   &_2stage_device_pointer_&
                                   &double&
                                   &_impl(self, a, ev)
        call self%autotune_timer%stop("accumulator")

      else
        print *,"unknown solver"
        stop
      endif
      if (present(error)) then
        if (success_l) then
          error = ELPA_OK
        else
          error = ELPA_ERROR
        endif
      else if (.not. success_l) then
        write(error_unit,'(a)') "ELPA: Error in eigenvalues() and you did not check for errors!"
      endif
    end subroutine

    !c> void elpa_eigenvalues_all_host_arrays_d(elpa_t handle, double *a, double *ev, int *error);
    subroutine elpa_eigenvalues_all_host_arrays_&
                    &d&
                    &_c(handle, a_p, ev_p, error) &
                    bind(C, name="elpa_eigenvalues_all_host_arrays_d")

      type(c_ptr), intent(in), value :: handle, a_p, ev_p
      integer(kind=c_int), intent(in) :: error

      real(kind=c_double), pointer :: a(:, :)
      real(kind=c_double), pointer :: ev(:)
      type(elpa_impl_t), pointer  :: self

      call c_f_pointer(handle, self)
      call c_f_pointer(a_p, a, [self%local_nrows, self%local_ncols])
      call c_f_pointer(ev_p, ev, [self%na])

      call elpa_eigenvalues_all_host_arrays_&
              &d&
              & (self, a, ev, error)
    end subroutine    

    !c> void elpa_eigenvalues_device_pointer_d(elpa_t handle, double *a, double *ev, int *error);
    subroutine elpa_eigenvalues_device_pointer_&
                    &d&
                    &_c(handle, a_p, ev_p, error) &
                    bind(C, name="elpa_eigenvalues_device_pointer_d")

      type(c_ptr), intent(in), value :: handle, a_p, ev_p
      integer(kind=c_int), intent(in) :: error

      !real(kind=c_double), pointer :: a(:, :)
      !real(kind=c_double), pointer :: ev(:)
      type(elpa_impl_t), pointer  :: self

      !call c_f_pointer(handle, self)
      !call c_f_pointer(a_p, a, [self%local_nrows, self%local_ncols])
      !call c_f_pointer(ev_p, ev, [self%na])

      call elpa_eigenvalues_device_pointer_&
              &d&
              & (self, a_p, ev_p, error)
    end subroutine    

    !>  \brief elpa_skew_eigenvalues_d: class method to solve the real valued skew-symmetric eigenvalue problem
    !>
    !>  The dimensions of the matrix a (locally ditributed and global), the block-cyclic distribution
    !>  blocksize, the number of eigenvectors
    !>  to be computed and the MPI communicators are already known to the object and MUST be set BEFORE
    !>  with the class method "setup"
    !>
    !>  It is possible to change the behaviour of the method by setting tunable parameters with the
    !>  class method "set"
    !>
    !>  Parameters
    !>
    !>  \param a                                    Distributed matrix for which eigenvalues are to be computed.
    !>                                              Distribution is like in Scalapack.
    !>                                              The full matrix must be set (not only one half like in scalapack).
    !>                                              Destroyed on exit (upper and lower half).
    !>
    !>  \param ev                                   On output: eigenvalues of a, every processor gets the complete set
    !>
    !>  \param error                                integer, optional: returns an error code, which can be queried with elpa_strerr
    subroutine elpa_skew_eigenvalues_all_host_arrays_&
                    &d&
                    & (self, a, ev, error)
      class(elpa_impl_t)  :: self
      real(kind=c_double) :: a(self%local_nrows, *)
      real(kind=c_double)          :: ev(self%na)
      integer, optional                   :: error
      integer                             :: error2
      integer(kind=c_int)                 :: solver
      logical                             :: success_l

      success_l = .false.
      call self%get("solver", solver,error2)
      !call self%set("is_skewsymmetric",1,error2)
      if (error2 .ne. ELPA_OK) then
         print *,"Problem getting solver option. Aborting..."
         if (present(error)) then
           error = error2
         endif
         return
      endif

      if (solver .eq. ELPA_SOLVER_1STAGE) then
        call self%autotune_timer%start("accumulator")
        success_l = elpa_solve_skew_evp_&
                &real&
                          &_1stage_all_host_arrays_&
                          &double&
                          &_impl(self, a, ev)
        call self%autotune_timer%stop("accumulator")

      else if (solver .eq. ELPA_SOLVER_2STAGE) then
        call self%autotune_timer%start("accumulator")
        success_l = elpa_solve_skew_evp_&
                &real&
                                   &_2stage_all_host_arrays_&
                                   &double&
                                   &_impl(self, a, ev)
        call self%autotune_timer%stop("accumulator")

      else
        print *,"unknown solver"
        stop
      endif
      if (present(error)) then
        if (success_l) then
          error = ELPA_OK
        else
          error = ELPA_ERROR
        endif
      else if (.not. success_l) then
        write(error_unit,'(a)') "ELPA: Error in skew_eigenvalues() and you did not check for errors!"
      endif
    end subroutine

    !>  \brief elpa_skew_eigenvalues_d: class method to solve the real valued skew-symmetric eigenvalue problem
    !>
    !>  The dimensions of the matrix a (locally ditributed and global), the block-cyclic distribution
    !>  blocksize, the number of eigenvectors
    !>  to be computed and the MPI communicators are already known to the object and MUST be set BEFORE
    !>  with the class method "setup"
    !>
    !>  It is possible to change the behaviour of the method by setting tunable parameters with the
    !>  class method "set"
    !>
    !>  Parameters
    !>
    !>  \param a                                    Distributed matrix for which eigenvalues are to be computed.
    !>                                              Distribution is like in Scalapack.
    !>                                              The full matrix must be set (not only one half like in scalapack).
    !>                                              Destroyed on exit (upper and lower half).
    !>
    !>  \param ev                                   On output: eigenvalues of a, every processor gets the complete set
    !>
    !>  \param error                                integer, optional: returns an error code, which can be queried with elpa_strerr
    subroutine elpa_skew_eigenvalues_device_pointer_&
                    &d&
                    & (self, a, ev, error)
      use iso_c_binding
      implicit none
      class(elpa_impl_t)  :: self
      type(c_ptr)         :: a, ev
      integer, optional                   :: error
      integer                             :: error2
      integer(kind=c_int)                 :: solver
      logical                             :: success_l

      success_l = .false.
      call self%get("solver", solver,error2)
      !call self%set("is_skewsymmetric",1,error2)
      if (error2 .ne. ELPA_OK) then
         print *,"Problem getting solver option. Aborting..."
         if (present(error)) then
           error = error2
         endif
         return
      endif

      if (solver .eq. ELPA_SOLVER_1STAGE) then
        call self%autotune_timer%start("accumulator")
        success_l = elpa_solve_skew_evp_&
                &real&
                          &_1stage_device_pointer_&
                          &double&
                          &_impl(self, a, ev)
        call self%autotune_timer%stop("accumulator")

      else if (solver .eq. ELPA_SOLVER_2STAGE) then
        call self%autotune_timer%start("accumulator")
        success_l = elpa_solve_skew_evp_&
                &real&
                                   &_2stage_device_pointer_&
                                   &double&
                                   &_impl(self, a, ev)
        call self%autotune_timer%stop("accumulator")

      else
        print *,"unknown solver"
        stop
      endif
      if (present(error)) then
        if (success_l) then
          error = ELPA_OK
        else
          error = ELPA_ERROR
        endif
      else if (.not. success_l) then
        write(error_unit,'(a)') "ELPA: Error in skew_eigenvalues() and you did not check for errors!"
      endif
    end subroutine


    !c> void elpa_skew_eigenvalues_all_host_arrays_d(elpa_t handle, double *a, double *ev, int *error);
    subroutine elpa_skew_eigenvalues_all_host_arrays_&
                    &d&
                    &_c(handle, a_p, ev_p, error) &
                    bind(C, name="elpa_skew_eigenvalues_all_host_arrays_d")
      type(c_ptr), intent(in), value :: handle, a_p, ev_p
      integer(kind=c_int), intent(in) :: error

      real(kind=c_double), pointer :: a(:, :)
      real(kind=c_double), pointer :: ev(:)
      type(elpa_impl_t), pointer  :: self

      call c_f_pointer(handle, self)
      call c_f_pointer(a_p, a, [self%local_nrows, self%local_ncols])
      call c_f_pointer(ev_p, ev, [self%na])

      call elpa_skew_eigenvalues_all_host_arrays_&
              &d&
              & (self, a, ev, error)
    end subroutine

    !c> void elpa_skew_eigenvalues_device_pointer_d(elpa_t handle, double *a, double *ev, int *error);
    subroutine elpa_skew_eigenvalues_device_pointer_&
                    &d&
                    &_c(handle, a_p, ev_p, error) &
                    bind(C, name="elpa_skew_eigenvalues_device_pointer_d")
      type(c_ptr), intent(in), value :: handle, a_p, ev_p
      integer(kind=c_int), intent(in) :: error

      !real(kind=c_double), pointer :: a(:, :)
      !real(kind=c_double), pointer :: ev(:)
      type(elpa_impl_t), pointer  :: self

      !call c_f_pointer(handle, self)
      !call c_f_pointer(a_p, a, [self%local_nrows, self%local_ncols])
      !call c_f_pointer(ev_p, ev, [self%na])

      call elpa_skew_eigenvalues_device_pointer_&
              &d&
              & (self, a_p, ev_p, error)
    end subroutine

    !>  \brief elpa_generalized_eigenvectors_d: class method to solve the eigenvalue problem
    !>
    !>  The dimensions of the matrix a (locally ditributed and global), the block-cyclic distribution
    !>  blocksize, the number of eigenvectors
    !>  to be computed and the MPI communicators are already known to the object and MUST be set BEFORE
    !>  with the class method "setup"
    !>
    !>  It is possible to change the behaviour of the method by setting tunable parameters with the
    !>  class method "set"
    !>
    !>  Parameters
    !>
    !>  \param a                                    Distributed matrix for which eigenvalues are to be computed.
    !>                                              Distribution is like in Scalapack.
    !>                                              The full matrix must be set (not only one half like in scalapack).
    !>                                              Destroyed on exit (upper and lower half).
    !>
    !>  \param b                                    Distributed matrix, part of the generalized eigenvector problem, or the
    !>                                              product of a previous call to this function (see is_already_decomposed).
    !>                                              Distribution is like in Scalapack.
    !>                                              If is_already_decomposed is false, on exit replaced by the decomposition
    !>
    !>  \param ev                                   On output: eigenvalues of a, every processor gets the complete set
    !>
    !>  \param q                                    On output: Eigenvectors of a
    !>                                              Distribution is like in Scalapack.
    !>                                              Must be always dimensioned to the full size (corresponding to (na,na))
    !>                                              even if only a part of the eigenvalues is needed.
    !>
    !>  \param is_already_decomposed                has to be set to .false. for the first call with a given b and .true. for
    !>                                              each subsequent call with the same b, since b then already contains
    !>                                              decomposition and thus the decomposing step is skipped
    !>
    !>  \param error                                integer, optional: returns an error code, which can be queried with elpa_strerr 
    subroutine elpa_generalized_eigenvectors_&
                    &d&
                    & (self, a, b, ev, q, is_already_decomposed, error)
      use elpa2_impl
      use elpa1_impl
      use elpa_utilities, only : error_unit
      use, intrinsic :: iso_c_binding
      class(elpa_impl_t)  :: self

      real(kind=c_double) :: a(self%local_nrows, *), b(self%local_nrows, *), q(self%local_nrows, *)
      real(kind=c_double) :: ev(self%na)
      logical             :: is_already_decomposed

      integer, optional   :: error
      integer             :: error_l
      integer(kind=c_int) :: solver
      logical             :: success_l

      error_l   = -10
      success_l = .false.
      call self%elpa_transform_generalized_&
              &d&
              & (a, b, is_already_decomposed, error_l)
      if (present(error)) then
          error = error_l
      else if (error_l .ne. ELPA_OK) then
        write(error_unit,'(a)') "ELPA: Error in transform_generalized() and you did not check for errors!"
      endif

      call self%get("solver", solver,error_l)
      if (solver .eq. ELPA_SOLVER_1STAGE) then
        success_l = elpa_solve_evp_&
                &real&
                &_1stage_all_host_arrays_&
                &double&
                &_impl(self, a, ev, q)
      else if (solver .eq. ELPA_SOLVER_2STAGE) then
        success_l = elpa_solve_evp_&
                &real&
                &_2stage_all_host_arrays_&
                &double&
                &_impl(self, a, ev, q)
      else
        print *,"unknown solver"
        stop
      endif

      if (present(error)) then
        if (success_l) then
          error = ELPA_OK
        else
          error = ELPA_ERROR
        endif
      else if (.not. success_l) then
        write(error_unit,'(a)') "ELPA: Error in solve() and you did not check for errors!"
      endif

      call self%elpa_transform_back_generalized_&
              &d&
              & (b, q, error_l)
      if (present(error)) then
          error = error_l
      else if (error_l .ne. ELPA_OK) then
        write(error_unit,'(a)') "ELPA: Error in transform_back_generalized() and you did not check for errors!"
      endif
    end subroutine

    !c> void elpa_generalized_eigenvectors_d(elpa_t handle, double *a, double *b, double *ev, double *q,
    !c> int is_already_decomposed, int *error);
    subroutine elpa_generalized_eigenvectors_&
                    &d&
                    &_c(handle, a_p, b_p, ev_p, q_p, is_already_decomposed, error) &
                                                            bind(C, name="elpa_generalized_eigenvectors_d")
      type(c_ptr), intent(in), value :: handle, a_p, b_p, ev_p, q_p
      integer(kind=c_int), intent(in), value :: is_already_decomposed
      integer(kind=c_int), optional, intent(in) :: error
      real(kind=c_double), pointer :: a(:, :), b(:, :), q(:, :)
      real(kind=c_double), pointer :: ev(:)
      logical :: is_already_decomposed_fortran
      type(elpa_impl_t), pointer  :: self

      call c_f_pointer(handle, self)
      call c_f_pointer(a_p, a, [self%local_nrows, self%local_ncols])
      call c_f_pointer(b_p, b, [self%local_nrows, self%local_ncols])
      call c_f_pointer(ev_p, ev, [self%na])
      call c_f_pointer(q_p, q, [self%local_nrows, self%local_ncols])
      if(is_already_decomposed .eq. 0) then
        is_already_decomposed_fortran = .false.
      else
        is_already_decomposed_fortran = .true.
      end if

      call elpa_generalized_eigenvectors_&
              &d&
              & (self, a, b, ev, q, is_already_decomposed_fortran, error)
    end subroutine

    

    !>  \brief elpa_generalized_eigenvalues_d: class method to solve the eigenvalue problem
    !>
    !>  The dimensions of the matrix a (locally ditributed and global), the block-cyclic distribution
    !>  blocksize, the number of eigenvectors
    !>  to be computed and the MPI communicators are already known to the object and MUST be set BEFORE
    !>  with the class method "setup"
    !>
    !>  It is possible to change the behaviour of the method by setting tunable parameters with the
    !>  class method "set"
    !>
    !>  Parameters
    !>
    !>  \param a                                    Distributed matrix for which eigenvalues are to be computed.
    !>                                              Distribution is like in Scalapack.
    !>                                              The full matrix must be set (not only one half like in scalapack).
    !>                                              Destroyed on exit (upper and lower half).
    !>
    !>  \param b                                    Distributed matrix, part of the generalized eigenvector problem, or the
    !>                                              product of a previous call to this function (see is_already_decomposed).
    !>                                              Distribution is like in Scalapack.
    !>                                              If is_already_decomposed is false, on exit replaced by the decomposition
    !>
    !>  \param ev                                   On output: eigenvalues of a, every processor gets the complete set
    !>
    !>  \param is_already_decomposed                has to be set to .false. for the first call with a given b and .true. for
    !>                                              each subsequent call with the same b, since b then already contains
    !>                                              decomposition and thus the decomposing step is skipped
    !>
    !>  \param error                                integer, optional: returns an error code, which can be queried with elpa_strerr
    subroutine elpa_generalized_eigenvalues_&
                    &d&
                    & (self, a, b, ev, is_already_decomposed, error)
      use elpa2_impl
      use elpa1_impl
      use elpa_utilities, only : error_unit
      use, intrinsic :: iso_c_binding
      class(elpa_impl_t)  :: self

      real(kind=c_double) :: a(self%local_nrows, *), b(self%local_nrows, *)
      real(kind=c_double) :: ev(self%na)
      logical             :: is_already_decomposed

      integer, optional   :: error
      integer             :: error_l
      integer(kind=c_int) :: solver
      logical             :: success_l

      error_l = -10
      success_l = .false.
      call self%elpa_transform_generalized_&
              &d&
              & (a, b, is_already_decomposed, error_l)
      if (present(error)) then
          error = error_l
      else if (error_l .ne. ELPA_OK) then
        write(error_unit,'(a)') "ELPA: Error in transform_generalized() and you did not check for errors!"
      endif

      call self%get("solver", solver,error_l)
      if (solver .eq. ELPA_SOLVER_1STAGE) then
        success_l = elpa_solve_evp_&
                &real&
                &_1stage_all_host_arrays_&
                &double&
                &_impl(self, a, ev)
      else if (solver .eq. ELPA_SOLVER_2STAGE) then
        success_l = elpa_solve_evp_&
                &real&
                &_2stage_all_host_arrays_&
                &double&
                &_impl(self, a, ev)
      else
        print *,"unknown solver"
        stop
      endif

      if (present(error)) then
        if (success_l) then
          error = ELPA_OK
        else
          error = ELPA_ERROR
        endif
      else if (.not. success_l) then
        write(error_unit,'(a)') "ELPA: Error in solve() and you did not check for errors!"
      endif

    end subroutine

    !c> void elpa_generalized_eigenvalues_d(elpa_t handle, double *a, double *b, double *ev,
    !c> int is_already_decomposed, int *error);
    subroutine elpa_generalized_eigenvalues_&
                    &d&
                    &_c(handle, a_p, b_p, ev_p, is_already_decomposed, error) &
                                                            bind(C, name="elpa_generalized_eigenvalues_d")
      type(c_ptr), intent(in), value :: handle, a_p, b_p, ev_p
      integer(kind=c_int), intent(in), value :: is_already_decomposed
      integer(kind=c_int), optional, intent(in) :: error

      real(kind=c_double), pointer :: a(:, :), b(:, :)
      real(kind=c_double), pointer :: ev(:)
      logical :: is_already_decomposed_fortran
      type(elpa_impl_t), pointer  :: self

      call c_f_pointer(handle, self)
      call c_f_pointer(a_p, a, [self%local_nrows, self%local_ncols])
      call c_f_pointer(b_p, b, [self%local_nrows, self%local_ncols])
      call c_f_pointer(ev_p, ev, [self%na])
      if(is_already_decomposed .eq. 0) then
        is_already_decomposed_fortran = .false.
      else
        is_already_decomposed_fortran = .true.
      end if

      call elpa_generalized_eigenvalues_&
              &d&
              & (self, a, b, ev, is_already_decomposed_fortran, error)
    end subroutine


    !> \brief  elpa_hermitian_multiply_d: class method to perform C : = A**T * B
    !>         where   A is a square matrix (self%na,self%na) which is optionally upper or lower triangular
    !>                 B is a (self%na,ncb) matrix
    !>                 C is a (self%na,ncb) matrix where optionally only the upper or lower
    !>                   triangle may be computed
    !>
    !> the MPI commicators and the block-cyclic distribution block size are already known to the type.
    !> Thus the class method "setup" must be called BEFORE this method is used
    !>
    !> \details
    !>
    !> \param  self                 class(elpa_t), the ELPA object
    !> \param  uplo_a               'U' if A is upper triangular
    !>                              'L' if A is lower triangular
    !>                              anything else if A is a full matrix
    !>                              Please note: This pertains to the original A (as set in the calling program)
    !>                                           whereas the transpose of A is used for calculations
    !>                              If uplo_a is 'U' or 'L', the other triangle is not used at all,
    !>                              i.e. it may contain arbitrary numbers
    !> \param uplo_c                'U' if only the upper diagonal part of C is needed
    !>                              'L' if only the upper diagonal part of C is needed
    !>                              anything else if the full matrix C is needed
    !>                              Please note: Even when uplo_c is 'U' or 'L', the other triangle may be
    !>                                            written to a certain extent, i.e. one shouldn't rely on the content there!
    !> \param ncb                   Number of columns  of global matrices B and C
    !> \param a                     matrix a
    !> \param local_nrows           number of rows of local (sub) matrix a, set with class method set("local_nrows",value)
    !> \param local_ncols           number of columns of local (sub) matrix a, set with class method set("local_ncols",value)
    !> \param b                     matrix b
    !> \param nrows_b               number of rows of local (sub) matrix b
    !> \param ncols_b               number of columns of local (sub) matrix b
    !> \param c                     matrix c
    !> \param nrows_c               number of rows of local (sub) matrix c
    !> \param ncols_c               number of columns of local (sub) matrix c
    !> \param error                 optional argument, error code which can be queried with elpa_strerr
    subroutine elpa_hermitian_multiply_&
                   &d&
                   & (self, uplo_a, uplo_c, ncb, a, b, nrows_b, ncols_b, &
                                          c, nrows_c, ncols_c, error)
      class(elpa_impl_t)              :: self
      character*1                     :: uplo_a, uplo_c
      integer(kind=c_int), intent(in) :: nrows_b, ncols_b, nrows_c, ncols_c, ncb
      real(kind=c_double) :: a(self%local_nrows,*), b(nrows_b,*), c(nrows_c,*)
      integer, optional               :: error
      logical                         :: success_l
     
      success_l = .false.
      success_l = elpa_mult_at_b_&
              &real&
              &_&
              &double&
              &_impl(self, uplo_a, uplo_c, ncb, a, b, nrows_b, ncols_b, &
                                                  c, nrows_c, ncols_c)
      if (present(error)) then
        if (success_l) then
          error = ELPA_OK
        else
          error = ELPA_ERROR
        endif
      else if (.not. success_l) then
        write(error_unit,'(a)') "ELPA: Error in hermitian_multiply() and you did not check for errors!"
      endif
    end subroutine  

    !c> void elpa_hermitian_multiply_d(elpa_t handle, char uplo_a, char uplo_c, int ncb, double *a, double *b, int nrows_b, int ncols_b, double *c, int nrows_c, int ncols_c, int *error);
    subroutine elpa_hermitian_multiply_&
                    &d&
                    &_c(handle, uplo_a, uplo_c, ncb, a_p, b, nrows_b, &
                                           ncols_b, c, nrows_c, ncols_c, error)          &
                                           bind(C, name="elpa_hermitian_multiply_d")

      type(c_ptr), intent(in), value            :: handle, a_p
      character(1,C_CHAR), value                :: uplo_a, uplo_c
      integer(kind=c_int), value                :: ncb, nrows_b, ncols_b, nrows_c, ncols_c
      integer(kind=c_int), optional, intent(in) :: error
      real(kind=c_double), pointer              :: a(:, :)
      real(kind=c_double)                       :: b(nrows_b,*), c(nrows_c,*)
      type(elpa_impl_t), pointer                :: self

      call c_f_pointer(handle, self)
      call c_f_pointer(a_p, a, [self%local_nrows, self%local_ncols])

      call elpa_hermitian_multiply_&
              &d&
              & (self, uplo_a, uplo_c, ncb, a, b, nrows_b, &
                                     ncols_b, c, nrows_c, ncols_c, error)
    end subroutine


    !>  \brief elpa_cholesky_d: class method to do a cholesky factorization
    !>
    !>  The dimensions of the matrix a (locally ditributed and global), the block-cylic-distribution
    !>  block size, and the MPI communicators are already known to the object and MUST be set BEFORE
    !>  with the class method "setup"
    !>
    !>  It is possible to change the behaviour of the method by setting tunable parameters with the
    !>  class method "set"
    !>
    !>  Parameters
    !>
    !>  \param a                                    Distributed matrix for which eigenvalues are to be computed.
    !>                                              Distribution is like in Scalapack.
    !>                                              The full matrix must be set (not only one half like in scalapack).
    !>                                              Destroyed on exit (upper and lower half).
    !>
    !>  \param error                                integer, optional: returns an error code, which can be queried with elpa_strerr
    subroutine elpa_cholesky_&
                   &d&
                   & (self, a, error)
      class(elpa_impl_t)              :: self
      real(kind=c_double)                  :: a(self%local_nrows,*)
      integer, optional               :: error
      logical                         :: success_l

      success_l = .false.
      success_l = elpa_cholesky_&
              &real&
              &_&
              &double&
              &_impl (self, a)

      if (present(error)) then
        if (success_l) then
          error = ELPA_OK
        else
          error = ELPA_ERROR
        endif
      else if (.not. success_l) then
        write(error_unit,'(a)') "ELPA: Error in cholesky() and you did not check for errors!"
      endif
    end subroutine    

    !c> void elpa_cholesky_d(elpa_t handle, double *a, int *error);
    subroutine elpa_choleksy_&
                    &d&
                    &_c(handle, a_p, error) &
                    bind(C, name="elpa_cholesky_d")

      type(c_ptr), intent(in), value            :: handle, a_p
      integer(kind=c_int), optional, intent(in) :: error
      real(kind=c_double), pointer              :: a(:, :)
      type(elpa_impl_t), pointer                :: self

      call c_f_pointer(handle, self)
      call c_f_pointer(a_p, a, [self%local_nrows, self%local_ncols])

      call elpa_cholesky_&
              &d&
              & (self, a, error)
    end subroutine      


    !>  \brief elpa_invert_trm_d: class method to invert a triangular
    !>
    !>  The dimensions of the matrix a (locally ditributed and global), the block-cylic-distribution
    !>  block size, and the MPI communicators are already known to the object and MUST be set BEFORE
    !>  with the class method "setup"
    !>
    !>  It is possible to change the behaviour of the method by setting tunable parameters with the
    !>  class method "set"
    !>
    !>  Parameters
    !>
    !>  \param a                                    Distributed matrix for which eigenvalues are to be computed.
    !>                                              Distribution is like in Scalapack.
    !>                                              The full matrix must be set (not only one half like in scalapack).
    !>                                              Destroyed on exit (upper and lower half).
    !>
    !>  \param error                                integer, optional: returns an error code, which can be queried with elpa_strerr
    subroutine elpa_invert_trm_&
                   &d&
                  & (self, a, error)
      class(elpa_impl_t)              :: self
      real(kind=c_double)             :: a(self%local_nrows,*)
      integer, optional               :: error
      logical                         :: success_l

      success_l = .false.
      success_l = elpa_invert_trm_&
              &real&
              &_&
              &double&
              &_impl (self, a)

      if (present(error)) then
        if (success_l) then
          error = ELPA_OK
        else
          error = ELPA_ERROR
        endif
      else if (.not. success_l) then
        write(error_unit,'(a)') "ELPA: Error in invert_trm() and you did not check for errors!"
      endif
    end subroutine   



    !c> void elpa_invert_trm_d(elpa_t handle, double *a, int *error);
    subroutine elpa_invert_trm_&
                    &d&
                    &_c(handle, a_p, error) &
                    bind(C, name="elpa_invert_trm_d")

      type(c_ptr), intent(in), value            :: handle, a_p
      integer(kind=c_int), optional, intent(in) :: error
      real(kind=c_double), pointer              :: a(:, :)
      type(elpa_impl_t), pointer                :: self

      call c_f_pointer(handle, self)
      call c_f_pointer(a_p, a, [self%local_nrows, self%local_ncols])

      call elpa_invert_trm_&
              &d&
              & (self, a, error)
    end subroutine


    !>  \brief elpa_solve_tridiagonal_d: class method to solve the eigenvalue problem for a tridiagonal matrix a
    !>
    !>  The dimensions of the matrix a (locally ditributed and global), the block-cylic-distribution
    !>  block size, and the MPI communicators are already known to the object and MUST be set BEFORE
    !>  with the class method "setup"
    !>
    !>  It is possible to change the behaviour of the method by setting tunable parameters with the
    !>  class method "set"
    !>
    !>  Parameters
    !>
    !>  \param d        array d  on input diagonal elements of tridiagonal matrix, on
    !>                           output the eigenvalues in ascending order
    !>  \param e        array e on input subdiagonal elements of matrix, on exit destroyed
    !>  \param q        matrix  on exit : contains the eigenvectors
    !>  \param error    integer, optional: returns an error code, which can be queried with elpa_strerr 
    subroutine elpa_solve_tridiagonal_&
                   &d&
                   & (self, d, e, q, error)
      use solve_tridi
      implicit none
      class(elpa_impl_t)              :: self
      real(kind=c_double)                  :: d(self%na), e(self%na)
      real(kind=c_double)                  :: q(self%local_nrows,*)
      integer, optional               :: error
      logical                         :: success_l

      success_l = elpa_solve_tridi_&
              &double&
              &_impl(self, d, e, q)
      if (present(error)) then
        if (success_l) then
          error = ELPA_OK
        else
          error = ELPA_ERROR
        endif
      else if (.not. success_l) then
        write(error_unit,'(a)') "ELPA: Error in solve_tridiagonal() and you did not check for errors!"
      endif
    end subroutine   




















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
    !>  \brief elpa_eigenvectors_d: class method to solve the eigenvalue problem
    !>
    !>  The dimensions of the matrix a (locally ditributed and global), the block-cyclic distribution
    !>  blocksize, the number of eigenvectors
    !>  to be computed and the MPI communicators are already known to the object and MUST be set BEFORE
    !>  with the class method "setup"
    !>
    !>  It is possible to change the behaviour of the method by setting tunable parameters with the
    !>  class method "set"
    !>
    !>  Parameters
    !>
    !>  \param a                                    Distributed matrix for which eigenvalues are to be computed.
    !>                                              Distribution is like in Scalapack.
    !>                                              The full matrix must be set (not only one half like in scalapack).
    !>                                              Destroyed on exit (upper and lower half).
    !>
    !>  \param ev                                   On output: eigenvalues of a, every processor gets the complete set
    !>
    !>  \param q                                    On output: Eigenvectors of a
    !>                                              Distribution is like in Scalapack.
    !>                                              Must be always dimensioned to the full size (corresponding to (na,na))
    !>                                              even if only a part of the eigenvalues is needed.
    !>
    !>  \param error                                integer, optional: returns an error code, which can be queried with elpa_strerr   

    subroutine elpa_eigenvectors_all_host_arrays_&
                    &f&
                    & (self, a, ev, q, error)
      class(elpa_impl_t)  :: self

      real(kind=c_float) :: a(self%local_nrows, *), q(self%local_nrows, *)
      real(kind=c_float) :: ev(self%na)

      integer, optional   :: error
      integer             :: error2
      integer(kind=c_int) :: solver
      logical             :: success_l

      success_l = .false.
      call self%get("solver", solver,error2)
      if (error2 .ne. ELPA_OK) then
        print *,"Problem setting solver. Aborting..."
        if (present(error)) then
          error = error2
        endif
        return
      endif
      if (solver .eq. ELPA_SOLVER_1STAGE) then
        call self%autotune_timer%start("accumulator")
        success_l = elpa_solve_evp_&
                &real&
                &_1stage_all_host_arrays_&
                &single&
                &_impl(self, a, ev, q)
        call self%autotune_timer%stop("accumulator")

      else if (solver .eq. ELPA_SOLVER_2STAGE) then
        call self%autotune_timer%start("accumulator")
        success_l = elpa_solve_evp_&
                &real&
                &_2stage_all_host_arrays_&
                &single&
                &_impl(self, a, ev, q)
        call self%autotune_timer%stop("accumulator")

      else
        print *,"unknown solver"
        stop
      endif

      if (present(error)) then
        if (success_l) then
          error = ELPA_OK
        else
          error = ELPA_ERROR
        endif
      else if (.not. success_l) then
        write(error_unit,'(a)') "ELPA: Error in eigenvectors() and you did not check for errors!"
      endif
    end subroutine 

    !>  \brief elpa_eigenvectors_device_pointer_d: class method to solve the eigenvalue problem
    !>
    !>  The dimensions of the matrix a (locally ditributed and global), the block-cyclic distribution
    !>  blocksize, the number of eigenvectors
    !>  to be computed and the MPI communicators are already known to the object and MUST be set BEFORE
    !>  with the class method "setup"
    !>
    !>  It is possible to change the behaviour of the method by setting tunable parameters with the
    !>  class method "set"
    !>
    !>  Parameters
    !>
    !>  \param a                                    Distributed matrix for which eigenvalues are to be computed.
    !>                                              Distribution is like in Scalapack.
    !>                                              The full matrix must be set (not only one half like in scalapack).
    !>                                              Destroyed on exit (upper and lower half).
    !>
    !>  \param ev                                   On output: eigenvalues of a, every processor gets the complete set
    !>
    !>  \param q                                    On output: Eigenvectors of a
    !>                                              Distribution is like in Scalapack.
    !>                                              Must be always dimensioned to the full size (corresponding to (na,na))
    !>                                              even if only a part of the eigenvalues is needed.
    !>
    !>  \param error                                integer, optional: returns an error code, which can be queried with elpa_strerr   

    subroutine elpa_eigenvectors_device_pointer_&
                    &f&
                    & (self, a, ev, q, error)
      use iso_c_binding

      implicit none
      class(elpa_impl_t)  :: self

      type(c_ptr)         :: a, q, ev

      integer, optional   :: error
      integer             :: error2
      integer(kind=c_int) :: solver
      logical             :: success_l

      success_l = .false.
      call self%get("solver", solver,error2)
      if (error2 .ne. ELPA_OK) then
        print *,"Problem setting solver. Aborting..."
        if (present(error)) then
          error = error2
        endif
        return
      endif
      if (solver .eq. ELPA_SOLVER_1STAGE) then
        call self%autotune_timer%start("accumulator")
        success_l = elpa_solve_evp_&
                &real&
                &_1stage_device_pointer_&
                &single&
                &_impl(self, a, ev, q)
        call self%autotune_timer%stop("accumulator")

      else if (solver .eq. ELPA_SOLVER_2STAGE) then
        call self%autotune_timer%start("accumulator")
        success_l = elpa_solve_evp_&
                &real&
                &_2stage_device_pointer_&
                &single&
                &_impl(self, a, ev, q)
        call self%autotune_timer%stop("accumulator")

      else
        print *,"unknown solver"
        stop
      endif

      if (present(error)) then
        if (success_l) then
          error = ELPA_OK
        else
          error = ELPA_ERROR
        endif
      else if (.not. success_l) then
        write(error_unit,'(a)') "ELPA: Error in eigenvectors() and you did not check for errors!"
      endif
    end subroutine 

    !c> void elpa_eigenvectors_all_host_arrays_f(elpa_t handle, float *a, float *ev, float *q, int *error);
    subroutine elpa_eigenvectors_all_host_arrays_&
                    &f&
                    &_c(handle, a_p, ev_p, q_p, error) &
                    bind(C, name="elpa_eigenvectors_all_host_arrays_f")
      type(c_ptr), intent(in), value            :: handle, a_p, ev_p, q_p
      integer(kind=c_int), optional, intent(in) :: error

      real(kind=c_float), pointer :: a(:, :), q(:, :)
      real(kind=c_float), pointer          :: ev(:)
      type(elpa_impl_t), pointer                   :: self

      call c_f_pointer(handle, self)
      call c_f_pointer(a_p, a, [self%local_nrows, self%local_ncols])
      call c_f_pointer(ev_p, ev, [self%na])
      call c_f_pointer(q_p, q, [self%local_nrows, self%local_ncols])

      call elpa_eigenvectors_all_host_arrays_&
              &f&
              & (self, a, ev, q, error)
    end subroutine    

    !c> void elpa_eigenvectors_device_pointer_f(elpa_t handle, float *a, float *ev, float *q, int *error);
    subroutine elpa_eigenvectors_device_pointer_&
                    &f&
                    &_c(handle, a_p, ev_p, q_p, error) &
                    bind(C, name="elpa_eigenvectors_device_pointer_f")
      type(c_ptr), intent(in), value            :: handle, a_p, ev_p, q_p
      integer(kind=c_int), optional, intent(in) :: error

      !real(kind=c_float), pointer :: a(:, :), q(:, :)
      !real(kind=c_float), pointer          :: ev(:)
      type(elpa_impl_t), pointer                   :: self

      !call c_f_pointer(handle, self)
      !call c_f_pointer(a_p, a, [self%local_nrows, self%local_ncols])
      !call c_f_pointer(ev_p, ev, [self%na])
      !call c_f_pointer(q_p, q, [self%local_nrows, self%local_ncols])

      call elpa_eigenvectors_device_pointer_&
              &f&
              & (self, a_p, ev_p, q_p, error)
    end subroutine

    !>  \brief elpa_skew_eigenvectors_d: class method to solve the real valued skew-symmetric eigenvalue problem
    !>
    !>  The dimensions of the matrix a (locally ditributed and global), the block-cyclic distribution
    !>  blocksize, the number of eigenvectors
    !>  to be computed and the MPI communicators are already known to the object and MUST be set BEFORE
    !>  with the class method "setup"
    !>
    !>  It is possible to change the behaviour of the method by setting tunable parameters with the
    !>  class method "set"
    !>
    !>  Parameters
    !>
    !>  \param a                                    Distributed matrix for which eigenvalues are to be computed.
    !>                                              Distribution is like in Scalapack.
    !>                                              The full matrix must be set (not only one half like in scalapack).
    !>                                              Destroyed on exit (upper and lower half).
    !>
    !>  \param ev                                   On output: eigenvalues of a, every processor gets the complete set
    !>
    !>  \param q                                    On output: Eigenvectors of a
    !>                                              Distribution is like in Scalapack.
    !>                                              Must be always dimensioned to the full size (corresponding to (na,na))
    !>                                              even if only a part of the eigenvalues is needed.
    !>
    !>  \param error                                integer, optional: returns an error code, which can be queried with elpa_strerr   

    subroutine elpa_skew_eigenvectors_all_host_arrays_&
                    &f&
                    & (self, a, ev, q, error)
      class(elpa_impl_t)  :: self

      real(kind=c_float) :: a(self%local_nrows, *), q(self%local_nrows, *)
      real(kind=c_float)          :: ev(self%na)

      integer, optional                   :: error
      integer                             :: error2
      integer(kind=c_int)                 :: solver
      logical                             :: success_l

      success_l = .false.
      call self%get("solver", solver,error2)
      !call self%set("is_skewsymmetric",1,error2)
      if (error2 .ne. ELPA_OK) then
        print *,"Problem setting is_skewsymmetric. Aborting..."
        if (present(error)) then
          error = error2
        endif
        return
      endif
      if (solver .eq. ELPA_SOLVER_1STAGE) then
        call self%autotune_timer%start("accumulator")
        success_l = elpa_solve_skew_evp_&
                &real&
                &_1stage_all_host_arrays_&
                &single&
                &_impl(self, a, ev, q)
        call self%autotune_timer%stop("accumulator")

      else if (solver .eq. ELPA_SOLVER_2STAGE) then
        call self%autotune_timer%start("accumulator")
        success_l = elpa_solve_skew_evp_&
                &real&
                &_2stage_all_host_arrays_&
                &single&
                &_impl(self, a, ev, q)
        call self%autotune_timer%stop("accumulator")

      else
        print *,"unknown solver"
        stop
      endif

      if (present(error)) then
        if (success_l) then
          error = ELPA_OK
        else
          error = ELPA_ERROR
        endif
      else if (.not. success_l) then
        write(error_unit,'(a)') "ELPA: Error in skew_eigenvectors() and you did not check for errors!"
      endif
    end subroutine

    !c> void elpa_skew_eigenvectors_all_host_arrays_f(elpa_t handle, float *a, float *ev, float *q, int *error);
    subroutine elpa_skew_eigenvectors_all_host_arrays_&
                    &f&
                    &_c(handle, a_p, ev_p, q_p, error) &
                    bind(C, name="elpa_skew_eigenvectors_all_host_arrays_f")

      type(c_ptr), intent(in), value            :: handle, a_p, ev_p, q_p
      integer(kind=c_int), optional, intent(in) :: error

      real(kind=c_float), pointer :: a(:, :), q(:, :)
      real(kind=c_float), pointer          :: ev(:)
      type(elpa_impl_t), pointer                   :: self

      call c_f_pointer(handle, self)
      call c_f_pointer(a_p, a, [self%local_nrows, self%local_ncols])
      call c_f_pointer(ev_p, ev, [self%na])
      call c_f_pointer(q_p, q, [self%local_nrows, self%local_ncols])

      call elpa_skew_eigenvectors_all_host_arrays_&
              &f&
              & (self, a, ev, q, error)
    end subroutine

    !>  \brief elpa_skew_eigenvectors_d: class method to solve the real valued skew-symmetric eigenvalue problem
    !>
    !>  The dimensions of the matrix a (locally ditributed and global), the block-cyclic distribution
    !>  blocksize, the number of eigenvectors
    !>  to be computed and the MPI communicators are already known to the object and MUST be set BEFORE
    !>  with the class method "setup"
    !>
    !>  It is possible to change the behaviour of the method by setting tunable parameters with the
    !>  class method "set"
    !>
    !>  Parameters
    !>
    !>  \param a                                    Distributed matrix for which eigenvalues are to be computed.
    !>                                              Distribution is like in Scalapack.
    !>                                              The full matrix must be set (not only one half like in scalapack).
    !>                                              Destroyed on exit (upper and lower half).
    !>
    !>  \param ev                                   On output: eigenvalues of a, every processor gets the complete set
    !>
    !>  \param q                                    On output: Eigenvectors of a
    !>                                              Distribution is like in Scalapack.
    !>                                              Must be always dimensioned to the full size (corresponding to (na,na))
    !>                                              even if only a part of the eigenvalues is needed.
    !>
    !>  \param error                                integer, optional: returns an error code, which can be queried with elpa_strerr   

    subroutine elpa_skew_eigenvectors_device_pointer_&
                    &f&
                    & (self, a, ev, q, error)
      use iso_c_binding
      implicit none
      class(elpa_impl_t)  :: self

      type(c_ptr)         :: a, q, ev

      integer, optional                   :: error
      integer                             :: error2
      integer(kind=c_int)                 :: solver
      logical                             :: success_l

      success_l = .false.
      call self%get("solver", solver,error2)
      !call self%set("is_skewsymmetric",1,error2)
      if (error2 .ne. ELPA_OK) then
        print *,"Problem setting is_skewsymmetric. Aborting..."
        if (present(error)) then
          error = error2
        endif
        return
      endif
      if (solver .eq. ELPA_SOLVER_1STAGE) then
        call self%autotune_timer%start("accumulator")
        success_l = elpa_solve_skew_evp_&
                &real&
                &_1stage_device_pointer_&
                &single&
                &_impl(self, a, ev, q)
        call self%autotune_timer%stop("accumulator")

      else if (solver .eq. ELPA_SOLVER_2STAGE) then
        call self%autotune_timer%start("accumulator")
        success_l = elpa_solve_skew_evp_&
                &real&
                &_2stage_device_pointer_&
                &single&
                &_impl(self, a, ev, q)
        call self%autotune_timer%stop("accumulator")

      else
        print *,"unknown solver"
        stop
      endif

      if (present(error)) then
        if (success_l) then
          error = ELPA_OK
        else
          error = ELPA_ERROR
        endif
      else if (.not. success_l) then
        write(error_unit,'(a)') "ELPA: Error in skew_eigenvectors() and you did not check for errors!"
      endif
    end subroutine

    !c> void elpa_skew_eigenvectors_device_pointer_f(elpa_t handle, float *a, float *ev, float *q, int *error);
    subroutine elpa_skew_eigenvectors_device_pointer_&
                    &f&
                    &_c(handle, a_p, ev_p, q_p, error) &
                    bind(C, name="elpa_skew_eigenvectors_device_pointer_f")

      type(c_ptr), intent(in), value            :: handle, a_p, ev_p, q_p
      integer(kind=c_int), optional, intent(in) :: error

      !real(kind=c_float), pointer :: a(:, :), q(:, :)
      !real(kind=c_float), pointer          :: ev(:)
      type(elpa_impl_t), pointer                   :: self

      !call c_f_pointer(handle, self)
      !call c_f_pointer(a_p, a, [self%local_nrows, self%local_ncols])
      !call c_f_pointer(ev_p, ev, [self%na])
      !call c_f_pointer(q_p, q, [self%local_nrows, self%local_ncols])

      call elpa_skew_eigenvectors_device_pointer_&
              &f&
              & (self, a_p, ev_p, q_p, error)
    end subroutine


    !>  \brief elpa_eigenvalues_d: class method to solve the eigenvalue problem
    !>
    !>  The dimensions of the matrix a (locally ditributed and global), the block-cyclic distribution
    !>  blocksize, the number of eigenvectors
    !>  to be computed and the MPI communicators are already known to the object and MUST be set BEFORE
    !>  with the class method "setup"
    !>
    !>  It is possible to change the behaviour of the method by setting tunable parameters with the
    !>  class method "set"
    !>
    !>  Parameters
    !>
    !>  \param a                                    Distributed matrix for which eigenvalues are to be computed.
    !>                                              Distribution is like in Scalapack.
    !>                                              The full matrix must be set (not only one half like in scalapack).
    !>                                              Destroyed on exit (upper and lower half).
    !>
    !>  \param ev                                   On output: eigenvalues of a, every processor gets the complete set
    !>
    !>  \param error                                integer, optional: returns an error code, which can be queried with elpa_strerr
    subroutine elpa_eigenvalues_all_host_arrays_&
                    &f&
                    & (self, a, ev, error)
      class(elpa_impl_t)  :: self
      real(kind=c_float) :: a(self%local_nrows, *)
      real(kind=c_float) :: ev(self%na)
      integer, optional   :: error
      integer             :: error2
      integer(kind=c_int) :: solver
      logical             :: success_l

      success_l = .false.
      call self%get("solver", solver,error2)
      if (error2 .ne. ELPA_OK) then
         print *,"Problem getting solver option. Aborting..."
         if (present(error)) then
           error = error2
         endif
         return
      endif

      if (solver .eq. ELPA_SOLVER_1STAGE) then
        call self%autotune_timer%start("accumulator")
        success_l = elpa_solve_evp_&
                &real&
                          &_1stage_all_host_arrays_&
                          &single&
                          &_impl(self, a, ev)
        call self%autotune_timer%stop("accumulator")

      else if (solver .eq. ELPA_SOLVER_2STAGE) then
        call self%autotune_timer%start("accumulator")
        success_l = elpa_solve_evp_&
                &real&
                                   &_2stage_all_host_arrays_&
                                   &single&
                                   &_impl(self, a, ev)
        call self%autotune_timer%stop("accumulator")

      else
        print *,"unknown solver"
        stop
      endif
      if (present(error)) then
        if (success_l) then
          error = ELPA_OK
        else
          error = ELPA_ERROR
        endif
      else if (.not. success_l) then
        write(error_unit,'(a)') "ELPA: Error in eigenvalues() and you did not check for errors!"
      endif
    end subroutine


    !>  \brief elpa_eigenvalues_d: class method to solve the eigenvalue problem
    !>
    !>  The dimensions of the matrix a (locally ditributed and global), the block-cyclic distribution
    !>  blocksize, the number of eigenvectors
    !>  to be computed and the MPI communicators are already known to the object and MUST be set BEFORE
    !>  with the class method "setup"
    !>
    !>  It is possible to change the behaviour of the method by setting tunable parameters with the
    !>  class method "set"
    !>
    !>  Parameters
    !>
    !>  \param a                                    Distributed matrix for which eigenvalues are to be computed.
    !>                                              Distribution is like in Scalapack.
    !>                                              The full matrix must be set (not only one half like in scalapack).
    !>                                              Destroyed on exit (upper and lower half).
    !>
    !>  \param ev                                   On output: eigenvalues of a, every processor gets the complete set
    !>
    !>  \param error                                integer, optional: returns an error code, which can be queried with elpa_strerr
    subroutine elpa_eigenvalues_device_pointer_&
                    &f&
                    & (self, a, ev, error)
      use iso_c_binding
      implicit none

      class(elpa_impl_t)  :: self
      type(c_ptr)         :: a, ev
      integer, optional   :: error
      integer             :: error2
      integer(kind=c_int) :: solver
      logical             :: success_l

      success_l = .false.
      call self%get("solver", solver,error2)
      if (error2 .ne. ELPA_OK) then
         print *,"Problem getting solver option. Aborting..."
         if (present(error)) then
           error = error2
         endif
         return
      endif

      if (solver .eq. ELPA_SOLVER_1STAGE) then
        call self%autotune_timer%start("accumulator")
        success_l = elpa_solve_evp_&
                &real&
                          &_1stage_device_pointer_&
                          &single&
                          &_impl(self, a, ev)
        call self%autotune_timer%stop("accumulator")

      else if (solver .eq. ELPA_SOLVER_2STAGE) then
        call self%autotune_timer%start("accumulator")
        success_l = elpa_solve_evp_&
                &real&
                                   &_2stage_device_pointer_&
                                   &single&
                                   &_impl(self, a, ev)
        call self%autotune_timer%stop("accumulator")

      else
        print *,"unknown solver"
        stop
      endif
      if (present(error)) then
        if (success_l) then
          error = ELPA_OK
        else
          error = ELPA_ERROR
        endif
      else if (.not. success_l) then
        write(error_unit,'(a)') "ELPA: Error in eigenvalues() and you did not check for errors!"
      endif
    end subroutine

    !c> void elpa_eigenvalues_all_host_arrays_f(elpa_t handle, float *a, float *ev, int *error);
    subroutine elpa_eigenvalues_all_host_arrays_&
                    &f&
                    &_c(handle, a_p, ev_p, error) &
                    bind(C, name="elpa_eigenvalues_all_host_arrays_f")

      type(c_ptr), intent(in), value :: handle, a_p, ev_p
      integer(kind=c_int), intent(in) :: error

      real(kind=c_float), pointer :: a(:, :)
      real(kind=c_float), pointer :: ev(:)
      type(elpa_impl_t), pointer  :: self

      call c_f_pointer(handle, self)
      call c_f_pointer(a_p, a, [self%local_nrows, self%local_ncols])
      call c_f_pointer(ev_p, ev, [self%na])

      call elpa_eigenvalues_all_host_arrays_&
              &f&
              & (self, a, ev, error)
    end subroutine    

    !c> void elpa_eigenvalues_device_pointer_f(elpa_t handle, float *a, float *ev, int *error);
    subroutine elpa_eigenvalues_device_pointer_&
                    &f&
                    &_c(handle, a_p, ev_p, error) &
                    bind(C, name="elpa_eigenvalues_device_pointer_f")

      type(c_ptr), intent(in), value :: handle, a_p, ev_p
      integer(kind=c_int), intent(in) :: error

      !real(kind=c_float), pointer :: a(:, :)
      !real(kind=c_float), pointer :: ev(:)
      type(elpa_impl_t), pointer  :: self

      !call c_f_pointer(handle, self)
      !call c_f_pointer(a_p, a, [self%local_nrows, self%local_ncols])
      !call c_f_pointer(ev_p, ev, [self%na])

      call elpa_eigenvalues_device_pointer_&
              &f&
              & (self, a_p, ev_p, error)
    end subroutine    

    !>  \brief elpa_skew_eigenvalues_d: class method to solve the real valued skew-symmetric eigenvalue problem
    !>
    !>  The dimensions of the matrix a (locally ditributed and global), the block-cyclic distribution
    !>  blocksize, the number of eigenvectors
    !>  to be computed and the MPI communicators are already known to the object and MUST be set BEFORE
    !>  with the class method "setup"
    !>
    !>  It is possible to change the behaviour of the method by setting tunable parameters with the
    !>  class method "set"
    !>
    !>  Parameters
    !>
    !>  \param a                                    Distributed matrix for which eigenvalues are to be computed.
    !>                                              Distribution is like in Scalapack.
    !>                                              The full matrix must be set (not only one half like in scalapack).
    !>                                              Destroyed on exit (upper and lower half).
    !>
    !>  \param ev                                   On output: eigenvalues of a, every processor gets the complete set
    !>
    !>  \param error                                integer, optional: returns an error code, which can be queried with elpa_strerr
    subroutine elpa_skew_eigenvalues_all_host_arrays_&
                    &f&
                    & (self, a, ev, error)
      class(elpa_impl_t)  :: self
      real(kind=c_float) :: a(self%local_nrows, *)
      real(kind=c_float)          :: ev(self%na)
      integer, optional                   :: error
      integer                             :: error2
      integer(kind=c_int)                 :: solver
      logical                             :: success_l

      success_l = .false.
      call self%get("solver", solver,error2)
      !call self%set("is_skewsymmetric",1,error2)
      if (error2 .ne. ELPA_OK) then
         print *,"Problem getting solver option. Aborting..."
         if (present(error)) then
           error = error2
         endif
         return
      endif

      if (solver .eq. ELPA_SOLVER_1STAGE) then
        call self%autotune_timer%start("accumulator")
        success_l = elpa_solve_skew_evp_&
                &real&
                          &_1stage_all_host_arrays_&
                          &single&
                          &_impl(self, a, ev)
        call self%autotune_timer%stop("accumulator")

      else if (solver .eq. ELPA_SOLVER_2STAGE) then
        call self%autotune_timer%start("accumulator")
        success_l = elpa_solve_skew_evp_&
                &real&
                                   &_2stage_all_host_arrays_&
                                   &single&
                                   &_impl(self, a, ev)
        call self%autotune_timer%stop("accumulator")

      else
        print *,"unknown solver"
        stop
      endif
      if (present(error)) then
        if (success_l) then
          error = ELPA_OK
        else
          error = ELPA_ERROR
        endif
      else if (.not. success_l) then
        write(error_unit,'(a)') "ELPA: Error in skew_eigenvalues() and you did not check for errors!"
      endif
    end subroutine

    !>  \brief elpa_skew_eigenvalues_d: class method to solve the real valued skew-symmetric eigenvalue problem
    !>
    !>  The dimensions of the matrix a (locally ditributed and global), the block-cyclic distribution
    !>  blocksize, the number of eigenvectors
    !>  to be computed and the MPI communicators are already known to the object and MUST be set BEFORE
    !>  with the class method "setup"
    !>
    !>  It is possible to change the behaviour of the method by setting tunable parameters with the
    !>  class method "set"
    !>
    !>  Parameters
    !>
    !>  \param a                                    Distributed matrix for which eigenvalues are to be computed.
    !>                                              Distribution is like in Scalapack.
    !>                                              The full matrix must be set (not only one half like in scalapack).
    !>                                              Destroyed on exit (upper and lower half).
    !>
    !>  \param ev                                   On output: eigenvalues of a, every processor gets the complete set
    !>
    !>  \param error                                integer, optional: returns an error code, which can be queried with elpa_strerr
    subroutine elpa_skew_eigenvalues_device_pointer_&
                    &f&
                    & (self, a, ev, error)
      use iso_c_binding
      implicit none
      class(elpa_impl_t)  :: self
      type(c_ptr)         :: a, ev
      integer, optional                   :: error
      integer                             :: error2
      integer(kind=c_int)                 :: solver
      logical                             :: success_l

      success_l = .false.
      call self%get("solver", solver,error2)
      !call self%set("is_skewsymmetric",1,error2)
      if (error2 .ne. ELPA_OK) then
         print *,"Problem getting solver option. Aborting..."
         if (present(error)) then
           error = error2
         endif
         return
      endif

      if (solver .eq. ELPA_SOLVER_1STAGE) then
        call self%autotune_timer%start("accumulator")
        success_l = elpa_solve_skew_evp_&
                &real&
                          &_1stage_device_pointer_&
                          &single&
                          &_impl(self, a, ev)
        call self%autotune_timer%stop("accumulator")

      else if (solver .eq. ELPA_SOLVER_2STAGE) then
        call self%autotune_timer%start("accumulator")
        success_l = elpa_solve_skew_evp_&
                &real&
                                   &_2stage_device_pointer_&
                                   &single&
                                   &_impl(self, a, ev)
        call self%autotune_timer%stop("accumulator")

      else
        print *,"unknown solver"
        stop
      endif
      if (present(error)) then
        if (success_l) then
          error = ELPA_OK
        else
          error = ELPA_ERROR
        endif
      else if (.not. success_l) then
        write(error_unit,'(a)') "ELPA: Error in skew_eigenvalues() and you did not check for errors!"
      endif
    end subroutine


    !c> void elpa_skew_eigenvalues_all_host_arrays_f(elpa_t handle, float *a, float *ev, int *error);
    subroutine elpa_skew_eigenvalues_all_host_arrays_&
                    &f&
                    &_c(handle, a_p, ev_p, error) &
                    bind(C, name="elpa_skew_eigenvalues_all_host_arrays_f")
      type(c_ptr), intent(in), value :: handle, a_p, ev_p
      integer(kind=c_int), intent(in) :: error

      real(kind=c_float), pointer :: a(:, :)
      real(kind=c_float), pointer :: ev(:)
      type(elpa_impl_t), pointer  :: self

      call c_f_pointer(handle, self)
      call c_f_pointer(a_p, a, [self%local_nrows, self%local_ncols])
      call c_f_pointer(ev_p, ev, [self%na])

      call elpa_skew_eigenvalues_all_host_arrays_&
              &f&
              & (self, a, ev, error)
    end subroutine

    !c> void elpa_skew_eigenvalues_device_pointer_f(elpa_t handle, float *a, float *ev, int *error);
    subroutine elpa_skew_eigenvalues_device_pointer_&
                    &f&
                    &_c(handle, a_p, ev_p, error) &
                    bind(C, name="elpa_skew_eigenvalues_device_pointer_f")
      type(c_ptr), intent(in), value :: handle, a_p, ev_p
      integer(kind=c_int), intent(in) :: error

      !real(kind=c_float), pointer :: a(:, :)
      !real(kind=c_float), pointer :: ev(:)
      type(elpa_impl_t), pointer  :: self

      !call c_f_pointer(handle, self)
      !call c_f_pointer(a_p, a, [self%local_nrows, self%local_ncols])
      !call c_f_pointer(ev_p, ev, [self%na])

      call elpa_skew_eigenvalues_device_pointer_&
              &f&
              & (self, a_p, ev_p, error)
    end subroutine

    !>  \brief elpa_generalized_eigenvectors_d: class method to solve the eigenvalue problem
    !>
    !>  The dimensions of the matrix a (locally ditributed and global), the block-cyclic distribution
    !>  blocksize, the number of eigenvectors
    !>  to be computed and the MPI communicators are already known to the object and MUST be set BEFORE
    !>  with the class method "setup"
    !>
    !>  It is possible to change the behaviour of the method by setting tunable parameters with the
    !>  class method "set"
    !>
    !>  Parameters
    !>
    !>  \param a                                    Distributed matrix for which eigenvalues are to be computed.
    !>                                              Distribution is like in Scalapack.
    !>                                              The full matrix must be set (not only one half like in scalapack).
    !>                                              Destroyed on exit (upper and lower half).
    !>
    !>  \param b                                    Distributed matrix, part of the generalized eigenvector problem, or the
    !>                                              product of a previous call to this function (see is_already_decomposed).
    !>                                              Distribution is like in Scalapack.
    !>                                              If is_already_decomposed is false, on exit replaced by the decomposition
    !>
    !>  \param ev                                   On output: eigenvalues of a, every processor gets the complete set
    !>
    !>  \param q                                    On output: Eigenvectors of a
    !>                                              Distribution is like in Scalapack.
    !>                                              Must be always dimensioned to the full size (corresponding to (na,na))
    !>                                              even if only a part of the eigenvalues is needed.
    !>
    !>  \param is_already_decomposed                has to be set to .false. for the first call with a given b and .true. for
    !>                                              each subsequent call with the same b, since b then already contains
    !>                                              decomposition and thus the decomposing step is skipped
    !>
    !>  \param error                                integer, optional: returns an error code, which can be queried with elpa_strerr 
    subroutine elpa_generalized_eigenvectors_&
                    &f&
                    & (self, a, b, ev, q, is_already_decomposed, error)
      use elpa2_impl
      use elpa1_impl
      use elpa_utilities, only : error_unit
      use, intrinsic :: iso_c_binding
      class(elpa_impl_t)  :: self

      real(kind=c_float) :: a(self%local_nrows, *), b(self%local_nrows, *), q(self%local_nrows, *)
      real(kind=c_float) :: ev(self%na)
      logical             :: is_already_decomposed

      integer, optional   :: error
      integer             :: error_l
      integer(kind=c_int) :: solver
      logical             :: success_l

      error_l   = -10
      success_l = .false.
      call self%elpa_transform_generalized_&
              &f&
              & (a, b, is_already_decomposed, error_l)
      if (present(error)) then
          error = error_l
      else if (error_l .ne. ELPA_OK) then
        write(error_unit,'(a)') "ELPA: Error in transform_generalized() and you did not check for errors!"
      endif

      call self%get("solver", solver,error_l)
      if (solver .eq. ELPA_SOLVER_1STAGE) then
        success_l = elpa_solve_evp_&
                &real&
                &_1stage_all_host_arrays_&
                &single&
                &_impl(self, a, ev, q)
      else if (solver .eq. ELPA_SOLVER_2STAGE) then
        success_l = elpa_solve_evp_&
                &real&
                &_2stage_all_host_arrays_&
                &single&
                &_impl(self, a, ev, q)
      else
        print *,"unknown solver"
        stop
      endif

      if (present(error)) then
        if (success_l) then
          error = ELPA_OK
        else
          error = ELPA_ERROR
        endif
      else if (.not. success_l) then
        write(error_unit,'(a)') "ELPA: Error in solve() and you did not check for errors!"
      endif

      call self%elpa_transform_back_generalized_&
              &f&
              & (b, q, error_l)
      if (present(error)) then
          error = error_l
      else if (error_l .ne. ELPA_OK) then
        write(error_unit,'(a)') "ELPA: Error in transform_back_generalized() and you did not check for errors!"
      endif
    end subroutine

    !c> void elpa_generalized_eigenvectors_f(elpa_t handle, float *a, float *b, float *ev, float *q,
    !c> int is_already_decomposed, int *error);
    subroutine elpa_generalized_eigenvectors_&
                    &f&
                    &_c(handle, a_p, b_p, ev_p, q_p, is_already_decomposed, error) &
                                                            bind(C, name="elpa_generalized_eigenvectors_f")
      type(c_ptr), intent(in), value :: handle, a_p, b_p, ev_p, q_p
      integer(kind=c_int), intent(in), value :: is_already_decomposed
      integer(kind=c_int), optional, intent(in) :: error
      real(kind=c_float), pointer :: a(:, :), b(:, :), q(:, :)
      real(kind=c_float), pointer :: ev(:)
      logical :: is_already_decomposed_fortran
      type(elpa_impl_t), pointer  :: self

      call c_f_pointer(handle, self)
      call c_f_pointer(a_p, a, [self%local_nrows, self%local_ncols])
      call c_f_pointer(b_p, b, [self%local_nrows, self%local_ncols])
      call c_f_pointer(ev_p, ev, [self%na])
      call c_f_pointer(q_p, q, [self%local_nrows, self%local_ncols])
      if(is_already_decomposed .eq. 0) then
        is_already_decomposed_fortran = .false.
      else
        is_already_decomposed_fortran = .true.
      end if

      call elpa_generalized_eigenvectors_&
              &f&
              & (self, a, b, ev, q, is_already_decomposed_fortran, error)
    end subroutine

    

    !>  \brief elpa_generalized_eigenvalues_d: class method to solve the eigenvalue problem
    !>
    !>  The dimensions of the matrix a (locally ditributed and global), the block-cyclic distribution
    !>  blocksize, the number of eigenvectors
    !>  to be computed and the MPI communicators are already known to the object and MUST be set BEFORE
    !>  with the class method "setup"
    !>
    !>  It is possible to change the behaviour of the method by setting tunable parameters with the
    !>  class method "set"
    !>
    !>  Parameters
    !>
    !>  \param a                                    Distributed matrix for which eigenvalues are to be computed.
    !>                                              Distribution is like in Scalapack.
    !>                                              The full matrix must be set (not only one half like in scalapack).
    !>                                              Destroyed on exit (upper and lower half).
    !>
    !>  \param b                                    Distributed matrix, part of the generalized eigenvector problem, or the
    !>                                              product of a previous call to this function (see is_already_decomposed).
    !>                                              Distribution is like in Scalapack.
    !>                                              If is_already_decomposed is false, on exit replaced by the decomposition
    !>
    !>  \param ev                                   On output: eigenvalues of a, every processor gets the complete set
    !>
    !>  \param is_already_decomposed                has to be set to .false. for the first call with a given b and .true. for
    !>                                              each subsequent call with the same b, since b then already contains
    !>                                              decomposition and thus the decomposing step is skipped
    !>
    !>  \param error                                integer, optional: returns an error code, which can be queried with elpa_strerr
    subroutine elpa_generalized_eigenvalues_&
                    &f&
                    & (self, a, b, ev, is_already_decomposed, error)
      use elpa2_impl
      use elpa1_impl
      use elpa_utilities, only : error_unit
      use, intrinsic :: iso_c_binding
      class(elpa_impl_t)  :: self

      real(kind=c_float) :: a(self%local_nrows, *), b(self%local_nrows, *)
      real(kind=c_float) :: ev(self%na)
      logical             :: is_already_decomposed

      integer, optional   :: error
      integer             :: error_l
      integer(kind=c_int) :: solver
      logical             :: success_l

      error_l = -10
      success_l = .false.
      call self%elpa_transform_generalized_&
              &f&
              & (a, b, is_already_decomposed, error_l)
      if (present(error)) then
          error = error_l
      else if (error_l .ne. ELPA_OK) then
        write(error_unit,'(a)') "ELPA: Error in transform_generalized() and you did not check for errors!"
      endif

      call self%get("solver", solver,error_l)
      if (solver .eq. ELPA_SOLVER_1STAGE) then
        success_l = elpa_solve_evp_&
                &real&
                &_1stage_all_host_arrays_&
                &single&
                &_impl(self, a, ev)
      else if (solver .eq. ELPA_SOLVER_2STAGE) then
        success_l = elpa_solve_evp_&
                &real&
                &_2stage_all_host_arrays_&
                &single&
                &_impl(self, a, ev)
      else
        print *,"unknown solver"
        stop
      endif

      if (present(error)) then
        if (success_l) then
          error = ELPA_OK
        else
          error = ELPA_ERROR
        endif
      else if (.not. success_l) then
        write(error_unit,'(a)') "ELPA: Error in solve() and you did not check for errors!"
      endif

    end subroutine

    !c> void elpa_generalized_eigenvalues_f(elpa_t handle, float *a, float *b, float *ev,
    !c> int is_already_decomposed, int *error);
    subroutine elpa_generalized_eigenvalues_&
                    &f&
                    &_c(handle, a_p, b_p, ev_p, is_already_decomposed, error) &
                                                            bind(C, name="elpa_generalized_eigenvalues_f")
      type(c_ptr), intent(in), value :: handle, a_p, b_p, ev_p
      integer(kind=c_int), intent(in), value :: is_already_decomposed
      integer(kind=c_int), optional, intent(in) :: error

      real(kind=c_float), pointer :: a(:, :), b(:, :)
      real(kind=c_float), pointer :: ev(:)
      logical :: is_already_decomposed_fortran
      type(elpa_impl_t), pointer  :: self

      call c_f_pointer(handle, self)
      call c_f_pointer(a_p, a, [self%local_nrows, self%local_ncols])
      call c_f_pointer(b_p, b, [self%local_nrows, self%local_ncols])
      call c_f_pointer(ev_p, ev, [self%na])
      if(is_already_decomposed .eq. 0) then
        is_already_decomposed_fortran = .false.
      else
        is_already_decomposed_fortran = .true.
      end if

      call elpa_generalized_eigenvalues_&
              &f&
              & (self, a, b, ev, is_already_decomposed_fortran, error)
    end subroutine


    !> \brief  elpa_hermitian_multiply_d: class method to perform C : = A**T * B
    !>         where   A is a square matrix (self%na,self%na) which is optionally upper or lower triangular
    !>                 B is a (self%na,ncb) matrix
    !>                 C is a (self%na,ncb) matrix where optionally only the upper or lower
    !>                   triangle may be computed
    !>
    !> the MPI commicators and the block-cyclic distribution block size are already known to the type.
    !> Thus the class method "setup" must be called BEFORE this method is used
    !>
    !> \details
    !>
    !> \param  self                 class(elpa_t), the ELPA object
    !> \param  uplo_a               'U' if A is upper triangular
    !>                              'L' if A is lower triangular
    !>                              anything else if A is a full matrix
    !>                              Please note: This pertains to the original A (as set in the calling program)
    !>                                           whereas the transpose of A is used for calculations
    !>                              If uplo_a is 'U' or 'L', the other triangle is not used at all,
    !>                              i.e. it may contain arbitrary numbers
    !> \param uplo_c                'U' if only the upper diagonal part of C is needed
    !>                              'L' if only the upper diagonal part of C is needed
    !>                              anything else if the full matrix C is needed
    !>                              Please note: Even when uplo_c is 'U' or 'L', the other triangle may be
    !>                                            written to a certain extent, i.e. one shouldn't rely on the content there!
    !> \param ncb                   Number of columns  of global matrices B and C
    !> \param a                     matrix a
    !> \param local_nrows           number of rows of local (sub) matrix a, set with class method set("local_nrows",value)
    !> \param local_ncols           number of columns of local (sub) matrix a, set with class method set("local_ncols",value)
    !> \param b                     matrix b
    !> \param nrows_b               number of rows of local (sub) matrix b
    !> \param ncols_b               number of columns of local (sub) matrix b
    !> \param c                     matrix c
    !> \param nrows_c               number of rows of local (sub) matrix c
    !> \param ncols_c               number of columns of local (sub) matrix c
    !> \param error                 optional argument, error code which can be queried with elpa_strerr
    subroutine elpa_hermitian_multiply_&
                   &f&
                   & (self, uplo_a, uplo_c, ncb, a, b, nrows_b, ncols_b, &
                                          c, nrows_c, ncols_c, error)
      class(elpa_impl_t)              :: self
      character*1                     :: uplo_a, uplo_c
      integer(kind=c_int), intent(in) :: nrows_b, ncols_b, nrows_c, ncols_c, ncb
      real(kind=c_float) :: a(self%local_nrows,*), b(nrows_b,*), c(nrows_c,*)
      integer, optional               :: error
      logical                         :: success_l
     
      success_l = .false.
      success_l = elpa_mult_at_b_&
              &real&
              &_&
              &single&
              &_impl(self, uplo_a, uplo_c, ncb, a, b, nrows_b, ncols_b, &
                                                  c, nrows_c, ncols_c)
      if (present(error)) then
        if (success_l) then
          error = ELPA_OK
        else
          error = ELPA_ERROR
        endif
      else if (.not. success_l) then
        write(error_unit,'(a)') "ELPA: Error in hermitian_multiply() and you did not check for errors!"
      endif
    end subroutine  

    !c> void elpa_hermitian_multiply_df(elpa_t handle, char uplo_a, char uplo_c, int ncb, float *a, float *b, int nrows_b, int ncols_b, float *c, int nrows_c, int ncols_c, int *error);
    subroutine elpa_hermitian_multiply_&
                    &f&
                    &_c(handle, uplo_a, uplo_c, ncb, a_p, b, nrows_b, &
                                           ncols_b, c, nrows_c, ncols_c, error)          &
                                           bind(C, name="elpa_hermitian_multiply_f")

      type(c_ptr), intent(in), value            :: handle, a_p
      character(1,C_CHAR), value                :: uplo_a, uplo_c
      integer(kind=c_int), value                :: ncb, nrows_b, ncols_b, nrows_c, ncols_c
      integer(kind=c_int), optional, intent(in) :: error
      real(kind=c_float), pointer              :: a(:, :)
      real(kind=c_float)                       :: b(nrows_b,*), c(nrows_c,*)
      type(elpa_impl_t), pointer                :: self

      call c_f_pointer(handle, self)
      call c_f_pointer(a_p, a, [self%local_nrows, self%local_ncols])

      call elpa_hermitian_multiply_&
              &f&
              & (self, uplo_a, uplo_c, ncb, a, b, nrows_b, &
                                     ncols_b, c, nrows_c, ncols_c, error)
    end subroutine


    !>  \brief elpa_cholesky_d: class method to do a cholesky factorization
    !>
    !>  The dimensions of the matrix a (locally ditributed and global), the block-cylic-distribution
    !>  block size, and the MPI communicators are already known to the object and MUST be set BEFORE
    !>  with the class method "setup"
    !>
    !>  It is possible to change the behaviour of the method by setting tunable parameters with the
    !>  class method "set"
    !>
    !>  Parameters
    !>
    !>  \param a                                    Distributed matrix for which eigenvalues are to be computed.
    !>                                              Distribution is like in Scalapack.
    !>                                              The full matrix must be set (not only one half like in scalapack).
    !>                                              Destroyed on exit (upper and lower half).
    !>
    !>  \param error                                integer, optional: returns an error code, which can be queried with elpa_strerr
    subroutine elpa_cholesky_&
                   &f&
                   & (self, a, error)
      class(elpa_impl_t)              :: self
      real(kind=c_float)                  :: a(self%local_nrows,*)
      integer, optional               :: error
      logical                         :: success_l

      success_l = .false.
      success_l = elpa_cholesky_&
              &real&
              &_&
              &single&
              &_impl (self, a)

      if (present(error)) then
        if (success_l) then
          error = ELPA_OK
        else
          error = ELPA_ERROR
        endif
      else if (.not. success_l) then
        write(error_unit,'(a)') "ELPA: Error in cholesky() and you did not check for errors!"
      endif
    end subroutine    

    !c> void elpa_cholesky_f(elpa_t handle, float *a, int *error);
    subroutine elpa_choleksy_&
                    &f&
                    &_c(handle, a_p, error) &
                    bind(C, name="elpa_cholesky_f")

      type(c_ptr), intent(in), value            :: handle, a_p
      integer(kind=c_int), optional, intent(in) :: error
      real(kind=c_float), pointer              :: a(:, :)
      type(elpa_impl_t), pointer                :: self

      call c_f_pointer(handle, self)
      call c_f_pointer(a_p, a, [self%local_nrows, self%local_ncols])

      call elpa_cholesky_&
              &f&
              & (self, a, error)
    end subroutine      


    !>  \brief elpa_invert_trm_d: class method to invert a triangular
    !>
    !>  The dimensions of the matrix a (locally ditributed and global), the block-cylic-distribution
    !>  block size, and the MPI communicators are already known to the object and MUST be set BEFORE
    !>  with the class method "setup"
    !>
    !>  It is possible to change the behaviour of the method by setting tunable parameters with the
    !>  class method "set"
    !>
    !>  Parameters
    !>
    !>  \param a                                    Distributed matrix for which eigenvalues are to be computed.
    !>                                              Distribution is like in Scalapack.
    !>                                              The full matrix must be set (not only one half like in scalapack).
    !>                                              Destroyed on exit (upper and lower half).
    !>
    !>  \param error                                integer, optional: returns an error code, which can be queried with elpa_strerr
    subroutine elpa_invert_trm_&
                   &f&
                  & (self, a, error)
      class(elpa_impl_t)              :: self
      real(kind=c_float)             :: a(self%local_nrows,*)
      integer, optional               :: error
      logical                         :: success_l

      success_l = .false.
      success_l = elpa_invert_trm_&
              &real&
              &_&
              &single&
              &_impl (self, a)

      if (present(error)) then
        if (success_l) then
          error = ELPA_OK
        else
          error = ELPA_ERROR
        endif
      else if (.not. success_l) then
        write(error_unit,'(a)') "ELPA: Error in invert_trm() and you did not check for errors!"
      endif
    end subroutine   



    !c> void elpa_invert_trm_f(elpa_t handle, float *a, int *error);
    subroutine elpa_invert_trm_&
                    &f&
                    &_c(handle, a_p, error) &
                    bind(C, name="elpa_invert_trm_f")

      type(c_ptr), intent(in), value            :: handle, a_p
      integer(kind=c_int), optional, intent(in) :: error
      real(kind=c_float), pointer              :: a(:, :)
      type(elpa_impl_t), pointer                :: self

      call c_f_pointer(handle, self)
      call c_f_pointer(a_p, a, [self%local_nrows, self%local_ncols])

      call elpa_invert_trm_&
              &f&
              & (self, a, error)
    end subroutine


    !>  \brief elpa_solve_tridiagonal_d: class method to solve the eigenvalue problem for a tridiagonal matrix a
    !>
    !>  The dimensions of the matrix a (locally ditributed and global), the block-cylic-distribution
    !>  block size, and the MPI communicators are already known to the object and MUST be set BEFORE
    !>  with the class method "setup"
    !>
    !>  It is possible to change the behaviour of the method by setting tunable parameters with the
    !>  class method "set"
    !>
    !>  Parameters
    !>
    !>  \param d        array d  on input diagonal elements of tridiagonal matrix, on
    !>                           output the eigenvalues in ascending order
    !>  \param e        array e on input subdiagonal elements of matrix, on exit destroyed
    !>  \param q        matrix  on exit : contains the eigenvectors
    !>  \param error    integer, optional: returns an error code, which can be queried with elpa_strerr 
    subroutine elpa_solve_tridiagonal_&
                   &f&
                   & (self, d, e, q, error)
      use solve_tridi
      implicit none
      class(elpa_impl_t)              :: self
      real(kind=c_float)                  :: d(self%na), e(self%na)
      real(kind=c_float)                  :: q(self%local_nrows,*)
      integer, optional               :: error
      logical                         :: success_l

      success_l = elpa_solve_tridi_&
              &single&
              &_impl(self, d, e, q)
      if (present(error)) then
        if (success_l) then
          error = ELPA_OK
        else
          error = ELPA_ERROR
        endif
      else if (.not. success_l) then
        write(error_unit,'(a)') "ELPA: Error in solve_tridiagonal() and you did not check for errors!"
      endif
    end subroutine   




















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
    !>  \brief elpa_eigenvectors_d: class method to solve the eigenvalue problem
    !>
    !>  The dimensions of the matrix a (locally ditributed and global), the block-cyclic distribution
    !>  blocksize, the number of eigenvectors
    !>  to be computed and the MPI communicators are already known to the object and MUST be set BEFORE
    !>  with the class method "setup"
    !>
    !>  It is possible to change the behaviour of the method by setting tunable parameters with the
    !>  class method "set"
    !>
    !>  Parameters
    !>
    !>  \param a                                    Distributed matrix for which eigenvalues are to be computed.
    !>                                              Distribution is like in Scalapack.
    !>                                              The full matrix must be set (not only one half like in scalapack).
    !>                                              Destroyed on exit (upper and lower half).
    !>
    !>  \param ev                                   On output: eigenvalues of a, every processor gets the complete set
    !>
    !>  \param q                                    On output: Eigenvectors of a
    !>                                              Distribution is like in Scalapack.
    !>                                              Must be always dimensioned to the full size (corresponding to (na,na))
    !>                                              even if only a part of the eigenvalues is needed.
    !>
    !>  \param error                                integer, optional: returns an error code, which can be queried with elpa_strerr   

    subroutine elpa_eigenvectors_all_host_arrays_&
                    &dc&
                    & (self, a, ev, q, error)
      class(elpa_impl_t)  :: self

      complex(kind=c_double) :: a(self%local_nrows, *), q(self%local_nrows, *)
      real(kind=c_double) :: ev(self%na)

      integer, optional   :: error
      integer             :: error2
      integer(kind=c_int) :: solver
      logical             :: success_l

      success_l = .false.
      call self%get("solver", solver,error2)
      if (error2 .ne. ELPA_OK) then
        print *,"Problem setting solver. Aborting..."
        if (present(error)) then
          error = error2
        endif
        return
      endif
      if (solver .eq. ELPA_SOLVER_1STAGE) then
        call self%autotune_timer%start("accumulator")
        success_l = elpa_solve_evp_&
                &complex&
                &_1stage_all_host_arrays_&
                &double&
                &_impl(self, a, ev, q)
        call self%autotune_timer%stop("accumulator")

      else if (solver .eq. ELPA_SOLVER_2STAGE) then
        call self%autotune_timer%start("accumulator")
        success_l = elpa_solve_evp_&
                &complex&
                &_2stage_all_host_arrays_&
                &double&
                &_impl(self, a, ev, q)
        call self%autotune_timer%stop("accumulator")

      else
        print *,"unknown solver"
        stop
      endif

      if (present(error)) then
        if (success_l) then
          error = ELPA_OK
        else
          error = ELPA_ERROR
        endif
      else if (.not. success_l) then
        write(error_unit,'(a)') "ELPA: Error in eigenvectors() and you did not check for errors!"
      endif
    end subroutine 

    !>  \brief elpa_eigenvectors_device_pointer_d: class method to solve the eigenvalue problem
    !>
    !>  The dimensions of the matrix a (locally ditributed and global), the block-cyclic distribution
    !>  blocksize, the number of eigenvectors
    !>  to be computed and the MPI communicators are already known to the object and MUST be set BEFORE
    !>  with the class method "setup"
    !>
    !>  It is possible to change the behaviour of the method by setting tunable parameters with the
    !>  class method "set"
    !>
    !>  Parameters
    !>
    !>  \param a                                    Distributed matrix for which eigenvalues are to be computed.
    !>                                              Distribution is like in Scalapack.
    !>                                              The full matrix must be set (not only one half like in scalapack).
    !>                                              Destroyed on exit (upper and lower half).
    !>
    !>  \param ev                                   On output: eigenvalues of a, every processor gets the complete set
    !>
    !>  \param q                                    On output: Eigenvectors of a
    !>                                              Distribution is like in Scalapack.
    !>                                              Must be always dimensioned to the full size (corresponding to (na,na))
    !>                                              even if only a part of the eigenvalues is needed.
    !>
    !>  \param error                                integer, optional: returns an error code, which can be queried with elpa_strerr   

    subroutine elpa_eigenvectors_device_pointer_&
                    &dc&
                    & (self, a, ev, q, error)
      use iso_c_binding

      implicit none
      class(elpa_impl_t)  :: self

      type(c_ptr)         :: a, q, ev

      integer, optional   :: error
      integer             :: error2
      integer(kind=c_int) :: solver
      logical             :: success_l

      success_l = .false.
      call self%get("solver", solver,error2)
      if (error2 .ne. ELPA_OK) then
        print *,"Problem setting solver. Aborting..."
        if (present(error)) then
          error = error2
        endif
        return
      endif
      if (solver .eq. ELPA_SOLVER_1STAGE) then
        call self%autotune_timer%start("accumulator")
        success_l = elpa_solve_evp_&
                &complex&
                &_1stage_device_pointer_&
                &double&
                &_impl(self, a, ev, q)
        call self%autotune_timer%stop("accumulator")

      else if (solver .eq. ELPA_SOLVER_2STAGE) then
        call self%autotune_timer%start("accumulator")
        success_l = elpa_solve_evp_&
                &complex&
                &_2stage_device_pointer_&
                &double&
                &_impl(self, a, ev, q)
        call self%autotune_timer%stop("accumulator")

      else
        print *,"unknown solver"
        stop
      endif

      if (present(error)) then
        if (success_l) then
          error = ELPA_OK
        else
          error = ELPA_ERROR
        endif
      else if (.not. success_l) then
        write(error_unit,'(a)') "ELPA: Error in eigenvectors() and you did not check for errors!"
      endif
    end subroutine 

    !c> void elpa_eigenvectors_all_host_arrays_dc(elpa_t handle, double complex *a, double *ev, double complex *q, int *error);
    subroutine elpa_eigenvectors_all_host_arrays_&
                    &dc&
                    &_c(handle, a_p, ev_p, q_p, error) &
                    bind(C, name="elpa_eigenvectors_all_host_arrays_dc")
      type(c_ptr), intent(in), value            :: handle, a_p, ev_p, q_p
      integer(kind=c_int), optional, intent(in) :: error

      complex(kind=c_double), pointer :: a(:, :), q(:, :)
      real(kind=c_double), pointer          :: ev(:)
      type(elpa_impl_t), pointer                   :: self

      call c_f_pointer(handle, self)
      call c_f_pointer(a_p, a, [self%local_nrows, self%local_ncols])
      call c_f_pointer(ev_p, ev, [self%na])
      call c_f_pointer(q_p, q, [self%local_nrows, self%local_ncols])

      call elpa_eigenvectors_all_host_arrays_&
              &dc&
              & (self, a, ev, q, error)
    end subroutine    

    !c> void elpa_eigenvectors_device_pointer_dc(elpa_t handle, double complex *a, double *ev, double complex *q, int *error);
    subroutine elpa_eigenvectors_device_pointer_&
                    &dc&
                    &_c(handle, a_p, ev_p, q_p, error) &
                    bind(C, name="elpa_eigenvectors_device_pointer_dc")
      type(c_ptr), intent(in), value            :: handle, a_p, ev_p, q_p
      integer(kind=c_int), optional, intent(in) :: error

      !complex(kind=c_double), pointer :: a(:, :), q(:, :)
      !real(kind=c_double), pointer          :: ev(:)
      type(elpa_impl_t), pointer                   :: self

      !call c_f_pointer(handle, self)
      !call c_f_pointer(a_p, a, [self%local_nrows, self%local_ncols])
      !call c_f_pointer(ev_p, ev, [self%na])
      !call c_f_pointer(q_p, q, [self%local_nrows, self%local_ncols])

      call elpa_eigenvectors_device_pointer_&
              &dc&
              & (self, a_p, ev_p, q_p, error)
    end subroutine


    !>  \brief elpa_eigenvalues_d: class method to solve the eigenvalue problem
    !>
    !>  The dimensions of the matrix a (locally ditributed and global), the block-cyclic distribution
    !>  blocksize, the number of eigenvectors
    !>  to be computed and the MPI communicators are already known to the object and MUST be set BEFORE
    !>  with the class method "setup"
    !>
    !>  It is possible to change the behaviour of the method by setting tunable parameters with the
    !>  class method "set"
    !>
    !>  Parameters
    !>
    !>  \param a                                    Distributed matrix for which eigenvalues are to be computed.
    !>                                              Distribution is like in Scalapack.
    !>                                              The full matrix must be set (not only one half like in scalapack).
    !>                                              Destroyed on exit (upper and lower half).
    !>
    !>  \param ev                                   On output: eigenvalues of a, every processor gets the complete set
    !>
    !>  \param error                                integer, optional: returns an error code, which can be queried with elpa_strerr
    subroutine elpa_eigenvalues_all_host_arrays_&
                    &dc&
                    & (self, a, ev, error)
      class(elpa_impl_t)  :: self
      complex(kind=c_double) :: a(self%local_nrows, *)
      real(kind=c_double) :: ev(self%na)
      integer, optional   :: error
      integer             :: error2
      integer(kind=c_int) :: solver
      logical             :: success_l

      success_l = .false.
      call self%get("solver", solver,error2)
      if (error2 .ne. ELPA_OK) then
         print *,"Problem getting solver option. Aborting..."
         if (present(error)) then
           error = error2
         endif
         return
      endif

      if (solver .eq. ELPA_SOLVER_1STAGE) then
        call self%autotune_timer%start("accumulator")
        success_l = elpa_solve_evp_&
                &complex&
                          &_1stage_all_host_arrays_&
                          &double&
                          &_impl(self, a, ev)
        call self%autotune_timer%stop("accumulator")

      else if (solver .eq. ELPA_SOLVER_2STAGE) then
        call self%autotune_timer%start("accumulator")
        success_l = elpa_solve_evp_&
                &complex&
                                   &_2stage_all_host_arrays_&
                                   &double&
                                   &_impl(self, a, ev)
        call self%autotune_timer%stop("accumulator")

      else
        print *,"unknown solver"
        stop
      endif
      if (present(error)) then
        if (success_l) then
          error = ELPA_OK
        else
          error = ELPA_ERROR
        endif
      else if (.not. success_l) then
        write(error_unit,'(a)') "ELPA: Error in eigenvalues() and you did not check for errors!"
      endif
    end subroutine


    !>  \brief elpa_eigenvalues_d: class method to solve the eigenvalue problem
    !>
    !>  The dimensions of the matrix a (locally ditributed and global), the block-cyclic distribution
    !>  blocksize, the number of eigenvectors
    !>  to be computed and the MPI communicators are already known to the object and MUST be set BEFORE
    !>  with the class method "setup"
    !>
    !>  It is possible to change the behaviour of the method by setting tunable parameters with the
    !>  class method "set"
    !>
    !>  Parameters
    !>
    !>  \param a                                    Distributed matrix for which eigenvalues are to be computed.
    !>                                              Distribution is like in Scalapack.
    !>                                              The full matrix must be set (not only one half like in scalapack).
    !>                                              Destroyed on exit (upper and lower half).
    !>
    !>  \param ev                                   On output: eigenvalues of a, every processor gets the complete set
    !>
    !>  \param error                                integer, optional: returns an error code, which can be queried with elpa_strerr
    subroutine elpa_eigenvalues_device_pointer_&
                    &dc&
                    & (self, a, ev, error)
      use iso_c_binding
      implicit none

      class(elpa_impl_t)  :: self
      type(c_ptr)         :: a, ev
      integer, optional   :: error
      integer             :: error2
      integer(kind=c_int) :: solver
      logical             :: success_l

      success_l = .false.
      call self%get("solver", solver,error2)
      if (error2 .ne. ELPA_OK) then
         print *,"Problem getting solver option. Aborting..."
         if (present(error)) then
           error = error2
         endif
         return
      endif

      if (solver .eq. ELPA_SOLVER_1STAGE) then
        call self%autotune_timer%start("accumulator")
        success_l = elpa_solve_evp_&
                &complex&
                          &_1stage_device_pointer_&
                          &double&
                          &_impl(self, a, ev)
        call self%autotune_timer%stop("accumulator")

      else if (solver .eq. ELPA_SOLVER_2STAGE) then
        call self%autotune_timer%start("accumulator")
        success_l = elpa_solve_evp_&
                &complex&
                                   &_2stage_device_pointer_&
                                   &double&
                                   &_impl(self, a, ev)
        call self%autotune_timer%stop("accumulator")

      else
        print *,"unknown solver"
        stop
      endif
      if (present(error)) then
        if (success_l) then
          error = ELPA_OK
        else
          error = ELPA_ERROR
        endif
      else if (.not. success_l) then
        write(error_unit,'(a)') "ELPA: Error in eigenvalues() and you did not check for errors!"
      endif
    end subroutine

    !c> void elpa_eigenvalues_all_host_arrays_dc(elpa_t handle, double complex *a, double *ev, int *error);
    subroutine elpa_eigenvalues_all_host_arrays_&
                    &dc&
                    &_c(handle, a_p, ev_p, error) &
                    bind(C, name="elpa_eigenvalues_all_host_arrays_dc")

      type(c_ptr), intent(in), value :: handle, a_p, ev_p
      integer(kind=c_int), intent(in) :: error

      complex(kind=c_double), pointer :: a(:, :)
      real(kind=c_double), pointer :: ev(:)
      type(elpa_impl_t), pointer  :: self

      call c_f_pointer(handle, self)
      call c_f_pointer(a_p, a, [self%local_nrows, self%local_ncols])
      call c_f_pointer(ev_p, ev, [self%na])

      call elpa_eigenvalues_all_host_arrays_&
              &dc&
              & (self, a, ev, error)
    end subroutine    

    !c> void elpa_eigenvalues_device_pointer_dc(elpa_t handle, double complex *a, double *ev, int *error);
    subroutine elpa_eigenvalues_device_pointer_&
                    &dc&
                    &_c(handle, a_p, ev_p, error) &
                    bind(C, name="elpa_eigenvalues_device_pointer_dc")

      type(c_ptr), intent(in), value :: handle, a_p, ev_p
      integer(kind=c_int), intent(in) :: error

      !complex(kind=c_double), pointer :: a(:, :)
      !real(kind=c_double), pointer :: ev(:)
      type(elpa_impl_t), pointer  :: self

      !call c_f_pointer(handle, self)
      !call c_f_pointer(a_p, a, [self%local_nrows, self%local_ncols])
      !call c_f_pointer(ev_p, ev, [self%na])

      call elpa_eigenvalues_device_pointer_&
              &dc&
              & (self, a_p, ev_p, error)
    end subroutine    


    !>  \brief elpa_generalized_eigenvectors_d: class method to solve the eigenvalue problem
    !>
    !>  The dimensions of the matrix a (locally ditributed and global), the block-cyclic distribution
    !>  blocksize, the number of eigenvectors
    !>  to be computed and the MPI communicators are already known to the object and MUST be set BEFORE
    !>  with the class method "setup"
    !>
    !>  It is possible to change the behaviour of the method by setting tunable parameters with the
    !>  class method "set"
    !>
    !>  Parameters
    !>
    !>  \param a                                    Distributed matrix for which eigenvalues are to be computed.
    !>                                              Distribution is like in Scalapack.
    !>                                              The full matrix must be set (not only one half like in scalapack).
    !>                                              Destroyed on exit (upper and lower half).
    !>
    !>  \param b                                    Distributed matrix, part of the generalized eigenvector problem, or the
    !>                                              product of a previous call to this function (see is_already_decomposed).
    !>                                              Distribution is like in Scalapack.
    !>                                              If is_already_decomposed is false, on exit replaced by the decomposition
    !>
    !>  \param ev                                   On output: eigenvalues of a, every processor gets the complete set
    !>
    !>  \param q                                    On output: Eigenvectors of a
    !>                                              Distribution is like in Scalapack.
    !>                                              Must be always dimensioned to the full size (corresponding to (na,na))
    !>                                              even if only a part of the eigenvalues is needed.
    !>
    !>  \param is_already_decomposed                has to be set to .false. for the first call with a given b and .true. for
    !>                                              each subsequent call with the same b, since b then already contains
    !>                                              decomposition and thus the decomposing step is skipped
    !>
    !>  \param error                                integer, optional: returns an error code, which can be queried with elpa_strerr 
    subroutine elpa_generalized_eigenvectors_&
                    &dc&
                    & (self, a, b, ev, q, is_already_decomposed, error)
      use elpa2_impl
      use elpa1_impl
      use elpa_utilities, only : error_unit
      use, intrinsic :: iso_c_binding
      class(elpa_impl_t)  :: self

      complex(kind=c_double) :: a(self%local_nrows, *), b(self%local_nrows, *), q(self%local_nrows, *)
      real(kind=c_double) :: ev(self%na)
      logical             :: is_already_decomposed

      integer, optional   :: error
      integer             :: error_l
      integer(kind=c_int) :: solver
      logical             :: success_l

      error_l   = -10
      success_l = .false.
      call self%elpa_transform_generalized_&
              &dc&
              & (a, b, is_already_decomposed, error_l)
      if (present(error)) then
          error = error_l
      else if (error_l .ne. ELPA_OK) then
        write(error_unit,'(a)') "ELPA: Error in transform_generalized() and you did not check for errors!"
      endif

      call self%get("solver", solver,error_l)
      if (solver .eq. ELPA_SOLVER_1STAGE) then
        success_l = elpa_solve_evp_&
                &complex&
                &_1stage_all_host_arrays_&
                &double&
                &_impl(self, a, ev, q)
      else if (solver .eq. ELPA_SOLVER_2STAGE) then
        success_l = elpa_solve_evp_&
                &complex&
                &_2stage_all_host_arrays_&
                &double&
                &_impl(self, a, ev, q)
      else
        print *,"unknown solver"
        stop
      endif

      if (present(error)) then
        if (success_l) then
          error = ELPA_OK
        else
          error = ELPA_ERROR
        endif
      else if (.not. success_l) then
        write(error_unit,'(a)') "ELPA: Error in solve() and you did not check for errors!"
      endif

      call self%elpa_transform_back_generalized_&
              &dc&
              & (b, q, error_l)
      if (present(error)) then
          error = error_l
      else if (error_l .ne. ELPA_OK) then
        write(error_unit,'(a)') "ELPA: Error in transform_back_generalized() and you did not check for errors!"
      endif
    end subroutine

    !c> void elpa_generalized_eigenvectors_dc(elpa_t handle, double complex *a, double complex *b, double *ev, double complex *q,
    !c> int is_already_decomposed, int *error);
    subroutine elpa_generalized_eigenvectors_&
                    &dc&
                    &_c(handle, a_p, b_p, ev_p, q_p, is_already_decomposed, error) &
                                                            bind(C, name="elpa_generalized_eigenvectors_dc")
      type(c_ptr), intent(in), value :: handle, a_p, b_p, ev_p, q_p
      integer(kind=c_int), intent(in), value :: is_already_decomposed
      integer(kind=c_int), optional, intent(in) :: error
      complex(kind=c_double), pointer :: a(:, :), b(:, :), q(:, :)
      real(kind=c_double), pointer :: ev(:)
      logical :: is_already_decomposed_fortran
      type(elpa_impl_t), pointer  :: self

      call c_f_pointer(handle, self)
      call c_f_pointer(a_p, a, [self%local_nrows, self%local_ncols])
      call c_f_pointer(b_p, b, [self%local_nrows, self%local_ncols])
      call c_f_pointer(ev_p, ev, [self%na])
      call c_f_pointer(q_p, q, [self%local_nrows, self%local_ncols])
      if(is_already_decomposed .eq. 0) then
        is_already_decomposed_fortran = .false.
      else
        is_already_decomposed_fortran = .true.
      end if

      call elpa_generalized_eigenvectors_&
              &dc&
              & (self, a, b, ev, q, is_already_decomposed_fortran, error)
    end subroutine

    

    !>  \brief elpa_generalized_eigenvalues_d: class method to solve the eigenvalue problem
    !>
    !>  The dimensions of the matrix a (locally ditributed and global), the block-cyclic distribution
    !>  blocksize, the number of eigenvectors
    !>  to be computed and the MPI communicators are already known to the object and MUST be set BEFORE
    !>  with the class method "setup"
    !>
    !>  It is possible to change the behaviour of the method by setting tunable parameters with the
    !>  class method "set"
    !>
    !>  Parameters
    !>
    !>  \param a                                    Distributed matrix for which eigenvalues are to be computed.
    !>                                              Distribution is like in Scalapack.
    !>                                              The full matrix must be set (not only one half like in scalapack).
    !>                                              Destroyed on exit (upper and lower half).
    !>
    !>  \param b                                    Distributed matrix, part of the generalized eigenvector problem, or the
    !>                                              product of a previous call to this function (see is_already_decomposed).
    !>                                              Distribution is like in Scalapack.
    !>                                              If is_already_decomposed is false, on exit replaced by the decomposition
    !>
    !>  \param ev                                   On output: eigenvalues of a, every processor gets the complete set
    !>
    !>  \param is_already_decomposed                has to be set to .false. for the first call with a given b and .true. for
    !>                                              each subsequent call with the same b, since b then already contains
    !>                                              decomposition and thus the decomposing step is skipped
    !>
    !>  \param error                                integer, optional: returns an error code, which can be queried with elpa_strerr
    subroutine elpa_generalized_eigenvalues_&
                    &dc&
                    & (self, a, b, ev, is_already_decomposed, error)
      use elpa2_impl
      use elpa1_impl
      use elpa_utilities, only : error_unit
      use, intrinsic :: iso_c_binding
      class(elpa_impl_t)  :: self

      complex(kind=c_double) :: a(self%local_nrows, *), b(self%local_nrows, *)
      real(kind=c_double) :: ev(self%na)
      logical             :: is_already_decomposed

      integer, optional   :: error
      integer             :: error_l
      integer(kind=c_int) :: solver
      logical             :: success_l

      error_l = -10
      success_l = .false.
      call self%elpa_transform_generalized_&
              &dc&
              & (a, b, is_already_decomposed, error_l)
      if (present(error)) then
          error = error_l
      else if (error_l .ne. ELPA_OK) then
        write(error_unit,'(a)') "ELPA: Error in transform_generalized() and you did not check for errors!"
      endif

      call self%get("solver", solver,error_l)
      if (solver .eq. ELPA_SOLVER_1STAGE) then
        success_l = elpa_solve_evp_&
                &complex&
                &_1stage_all_host_arrays_&
                &double&
                &_impl(self, a, ev)
      else if (solver .eq. ELPA_SOLVER_2STAGE) then
        success_l = elpa_solve_evp_&
                &complex&
                &_2stage_all_host_arrays_&
                &double&
                &_impl(self, a, ev)
      else
        print *,"unknown solver"
        stop
      endif

      if (present(error)) then
        if (success_l) then
          error = ELPA_OK
        else
          error = ELPA_ERROR
        endif
      else if (.not. success_l) then
        write(error_unit,'(a)') "ELPA: Error in solve() and you did not check for errors!"
      endif

    end subroutine

    !c> void elpa_generalized_eigenvalues_dc(elpa_t handle, double complex *a, double complex *b, double *ev,
    !c> int is_already_decomposed, int *error);
    subroutine elpa_generalized_eigenvalues_&
                    &dc&
                    &_c(handle, a_p, b_p, ev_p, is_already_decomposed, error) &
                                                            bind(C, name="elpa_generalized_eigenvalues_dc")
      type(c_ptr), intent(in), value :: handle, a_p, b_p, ev_p
      integer(kind=c_int), intent(in), value :: is_already_decomposed
      integer(kind=c_int), optional, intent(in) :: error

      complex(kind=c_double), pointer :: a(:, :), b(:, :)
      real(kind=c_double), pointer :: ev(:)
      logical :: is_already_decomposed_fortran
      type(elpa_impl_t), pointer  :: self

      call c_f_pointer(handle, self)
      call c_f_pointer(a_p, a, [self%local_nrows, self%local_ncols])
      call c_f_pointer(b_p, b, [self%local_nrows, self%local_ncols])
      call c_f_pointer(ev_p, ev, [self%na])
      if(is_already_decomposed .eq. 0) then
        is_already_decomposed_fortran = .false.
      else
        is_already_decomposed_fortran = .true.
      end if

      call elpa_generalized_eigenvalues_&
              &dc&
              & (self, a, b, ev, is_already_decomposed_fortran, error)
    end subroutine


    !> \brief  elpa_hermitian_multiply_d: class method to perform C : = A**T * B
    !>         where   A is a square matrix (self%na,self%na) which is optionally upper or lower triangular
    !>                 B is a (self%na,ncb) matrix
    !>                 C is a (self%na,ncb) matrix where optionally only the upper or lower
    !>                   triangle may be computed
    !>
    !> the MPI commicators and the block-cyclic distribution block size are already known to the type.
    !> Thus the class method "setup" must be called BEFORE this method is used
    !>
    !> \details
    !>
    !> \param  self                 class(elpa_t), the ELPA object
    !> \param  uplo_a               'U' if A is upper triangular
    !>                              'L' if A is lower triangular
    !>                              anything else if A is a full matrix
    !>                              Please note: This pertains to the original A (as set in the calling program)
    !>                                           whereas the transpose of A is used for calculations
    !>                              If uplo_a is 'U' or 'L', the other triangle is not used at all,
    !>                              i.e. it may contain arbitrary numbers
    !> \param uplo_c                'U' if only the upper diagonal part of C is needed
    !>                              'L' if only the upper diagonal part of C is needed
    !>                              anything else if the full matrix C is needed
    !>                              Please note: Even when uplo_c is 'U' or 'L', the other triangle may be
    !>                                            written to a certain extent, i.e. one shouldn't rely on the content there!
    !> \param ncb                   Number of columns  of global matrices B and C
    !> \param a                     matrix a
    !> \param local_nrows           number of rows of local (sub) matrix a, set with class method set("local_nrows",value)
    !> \param local_ncols           number of columns of local (sub) matrix a, set with class method set("local_ncols",value)
    !> \param b                     matrix b
    !> \param nrows_b               number of rows of local (sub) matrix b
    !> \param ncols_b               number of columns of local (sub) matrix b
    !> \param c                     matrix c
    !> \param nrows_c               number of rows of local (sub) matrix c
    !> \param ncols_c               number of columns of local (sub) matrix c
    !> \param error                 optional argument, error code which can be queried with elpa_strerr
    subroutine elpa_hermitian_multiply_&
                   &dc&
                   & (self, uplo_a, uplo_c, ncb, a, b, nrows_b, ncols_b, &
                                          c, nrows_c, ncols_c, error)
      class(elpa_impl_t)              :: self
      character*1                     :: uplo_a, uplo_c
      integer(kind=c_int), intent(in) :: nrows_b, ncols_b, nrows_c, ncols_c, ncb
      complex(kind=c_double) :: a(self%local_nrows,*), b(nrows_b,*), c(nrows_c,*)
      integer, optional               :: error
      logical                         :: success_l
     
      success_l = .false.
      success_l = elpa_mult_ah_b_&
              &complex&
              &_&
              &double&
              &_impl(self, uplo_a, uplo_c, ncb, a, b, nrows_b, ncols_b, &
                                                  c, nrows_c, ncols_c)
      if (present(error)) then
        if (success_l) then
          error = ELPA_OK
        else
          error = ELPA_ERROR
        endif
      else if (.not. success_l) then
        write(error_unit,'(a)') "ELPA: Error in hermitian_multiply() and you did not check for errors!"
      endif
    end subroutine  

    !c> void elpa_hermitian_multiply_dc(elpa_t handle, char uplo_a, char uplo_c, int ncb, double complex *a, double complex *b, int nrows_b, int ncols_b, double complex *c, int nrows_c, int ncols_c, int *error);
    subroutine elpa_hermitian_multiply_&
                    &dc&
                    &_c(handle, uplo_a, uplo_c, ncb, a_p, b, nrows_b, &
                                           ncols_b, c, nrows_c, ncols_c, error)          &
                                           bind(C, name="elpa_hermitian_multiply_dc")

      type(c_ptr), intent(in), value            :: handle, a_p
      character(1,C_CHAR), value                :: uplo_a, uplo_c
      integer(kind=c_int), value                :: ncb, nrows_b, ncols_b, nrows_c, ncols_c
      integer(kind=c_int), optional, intent(in) :: error
      complex(kind=c_double), pointer              :: a(:, :)
      complex(kind=c_double)                       :: b(nrows_b,*), c(nrows_c,*)
      type(elpa_impl_t), pointer                :: self

      call c_f_pointer(handle, self)
      call c_f_pointer(a_p, a, [self%local_nrows, self%local_ncols])

      call elpa_hermitian_multiply_&
              &dc&
              & (self, uplo_a, uplo_c, ncb, a, b, nrows_b, &
                                     ncols_b, c, nrows_c, ncols_c, error)
    end subroutine


    !>  \brief elpa_cholesky_d: class method to do a cholesky factorization
    !>
    !>  The dimensions of the matrix a (locally ditributed and global), the block-cylic-distribution
    !>  block size, and the MPI communicators are already known to the object and MUST be set BEFORE
    !>  with the class method "setup"
    !>
    !>  It is possible to change the behaviour of the method by setting tunable parameters with the
    !>  class method "set"
    !>
    !>  Parameters
    !>
    !>  \param a                                    Distributed matrix for which eigenvalues are to be computed.
    !>                                              Distribution is like in Scalapack.
    !>                                              The full matrix must be set (not only one half like in scalapack).
    !>                                              Destroyed on exit (upper and lower half).
    !>
    !>  \param error                                integer, optional: returns an error code, which can be queried with elpa_strerr
    subroutine elpa_cholesky_&
                   &dc&
                   & (self, a, error)
      class(elpa_impl_t)              :: self
      complex(kind=c_double)                  :: a(self%local_nrows,*)
      integer, optional               :: error
      logical                         :: success_l

      success_l = .false.
      success_l = elpa_cholesky_&
              &complex&
              &_&
              &double&
              &_impl (self, a)

      if (present(error)) then
        if (success_l) then
          error = ELPA_OK
        else
          error = ELPA_ERROR
        endif
      else if (.not. success_l) then
        write(error_unit,'(a)') "ELPA: Error in cholesky() and you did not check for errors!"
      endif
    end subroutine    

    !c> void elpa_cholesky_dc(elpa_t handle, double complex *a, int *error);
    subroutine elpa_choleksy_&
                    &dc&
                    &_c(handle, a_p, error) &
                    bind(C, name="elpa_cholesky_dc")

      type(c_ptr), intent(in), value            :: handle, a_p
      integer(kind=c_int), optional, intent(in) :: error
      complex(kind=c_double), pointer              :: a(:, :)
      type(elpa_impl_t), pointer                :: self

      call c_f_pointer(handle, self)
      call c_f_pointer(a_p, a, [self%local_nrows, self%local_ncols])

      call elpa_cholesky_&
              &dc&
              & (self, a, error)
    end subroutine      


    !>  \brief elpa_invert_trm_d: class method to invert a triangular
    !>
    !>  The dimensions of the matrix a (locally ditributed and global), the block-cylic-distribution
    !>  block size, and the MPI communicators are already known to the object and MUST be set BEFORE
    !>  with the class method "setup"
    !>
    !>  It is possible to change the behaviour of the method by setting tunable parameters with the
    !>  class method "set"
    !>
    !>  Parameters
    !>
    !>  \param a                                    Distributed matrix for which eigenvalues are to be computed.
    !>                                              Distribution is like in Scalapack.
    !>                                              The full matrix must be set (not only one half like in scalapack).
    !>                                              Destroyed on exit (upper and lower half).
    !>
    !>  \param error                                integer, optional: returns an error code, which can be queried with elpa_strerr
    subroutine elpa_invert_trm_&
                   &dc&
                  & (self, a, error)
      class(elpa_impl_t)              :: self
      complex(kind=c_double)             :: a(self%local_nrows,*)
      integer, optional               :: error
      logical                         :: success_l

      success_l = .false.
      success_l = elpa_invert_trm_&
              &complex&
              &_&
              &double&
              &_impl (self, a)

      if (present(error)) then
        if (success_l) then
          error = ELPA_OK
        else
          error = ELPA_ERROR
        endif
      else if (.not. success_l) then
        write(error_unit,'(a)') "ELPA: Error in invert_trm() and you did not check for errors!"
      endif
    end subroutine   



    !c> void elpa_invert_trm_dc(elpa_t handle, double complex *a, int *error);
    subroutine elpa_invert_trm_&
                    &dc&
                    &_c(handle, a_p, error) &
                    bind(C, name="elpa_invert_trm_dc")

      type(c_ptr), intent(in), value            :: handle, a_p
      integer(kind=c_int), optional, intent(in) :: error
      complex(kind=c_double), pointer              :: a(:, :)
      type(elpa_impl_t), pointer                :: self

      call c_f_pointer(handle, self)
      call c_f_pointer(a_p, a, [self%local_nrows, self%local_ncols])

      call elpa_invert_trm_&
              &dc&
              & (self, a, error)
    end subroutine


    !>  \brief elpa_solve_tridiagonal_d: class method to solve the eigenvalue problem for a tridiagonal matrix a
    !>
    !>  The dimensions of the matrix a (locally ditributed and global), the block-cylic-distribution
    !>  block size, and the MPI communicators are already known to the object and MUST be set BEFORE
    !>  with the class method "setup"
    !>
    !>  It is possible to change the behaviour of the method by setting tunable parameters with the
    !>  class method "set"
    !>
    !>  Parameters
    !>
    !>  \param d        array d  on input diagonal elements of tridiagonal matrix, on
    !>                           output the eigenvalues in ascending order
    !>  \param e        array e on input subdiagonal elements of matrix, on exit destroyed
    !>  \param q        matrix  on exit : contains the eigenvectors
    !>  \param error    integer, optional: returns an error code, which can be queried with elpa_strerr 
    subroutine elpa_solve_tridiagonal_&
                   &dc&
                   & (self, d, e, q, error)
      use solve_tridi
      implicit none
      class(elpa_impl_t)              :: self
      real(kind=c_double)                  :: d(self%na), e(self%na)
      real(kind=c_double)                  :: q(self%local_nrows,*)
      integer, optional               :: error
      logical                         :: success_l

      success_l = elpa_solve_tridi_&
              &double&
              &_impl(self, d, e, q)
      if (present(error)) then
        if (success_l) then
          error = ELPA_OK
        else
          error = ELPA_ERROR
        endif
      else if (.not. success_l) then
        write(error_unit,'(a)') "ELPA: Error in solve_tridiagonal() and you did not check for errors!"
      endif
    end subroutine   



















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
    !>  \brief elpa_eigenvectors_d: class method to solve the eigenvalue problem
    !>
    !>  The dimensions of the matrix a (locally ditributed and global), the block-cyclic distribution
    !>  blocksize, the number of eigenvectors
    !>  to be computed and the MPI communicators are already known to the object and MUST be set BEFORE
    !>  with the class method "setup"
    !>
    !>  It is possible to change the behaviour of the method by setting tunable parameters with the
    !>  class method "set"
    !>
    !>  Parameters
    !>
    !>  \param a                                    Distributed matrix for which eigenvalues are to be computed.
    !>                                              Distribution is like in Scalapack.
    !>                                              The full matrix must be set (not only one half like in scalapack).
    !>                                              Destroyed on exit (upper and lower half).
    !>
    !>  \param ev                                   On output: eigenvalues of a, every processor gets the complete set
    !>
    !>  \param q                                    On output: Eigenvectors of a
    !>                                              Distribution is like in Scalapack.
    !>                                              Must be always dimensioned to the full size (corresponding to (na,na))
    !>                                              even if only a part of the eigenvalues is needed.
    !>
    !>  \param error                                integer, optional: returns an error code, which can be queried with elpa_strerr   

    subroutine elpa_eigenvectors_all_host_arrays_&
                    &fc&
                    & (self, a, ev, q, error)
      class(elpa_impl_t)  :: self

      complex(kind=c_float) :: a(self%local_nrows, *), q(self%local_nrows, *)
      real(kind=c_float) :: ev(self%na)

      integer, optional   :: error
      integer             :: error2
      integer(kind=c_int) :: solver
      logical             :: success_l

      success_l = .false.
      call self%get("solver", solver,error2)
      if (error2 .ne. ELPA_OK) then
        print *,"Problem setting solver. Aborting..."
        if (present(error)) then
          error = error2
        endif
        return
      endif
      if (solver .eq. ELPA_SOLVER_1STAGE) then
        call self%autotune_timer%start("accumulator")
        success_l = elpa_solve_evp_&
                &complex&
                &_1stage_all_host_arrays_&
                &single&
                &_impl(self, a, ev, q)
        call self%autotune_timer%stop("accumulator")

      else if (solver .eq. ELPA_SOLVER_2STAGE) then
        call self%autotune_timer%start("accumulator")
        success_l = elpa_solve_evp_&
                &complex&
                &_2stage_all_host_arrays_&
                &single&
                &_impl(self, a, ev, q)
        call self%autotune_timer%stop("accumulator")

      else
        print *,"unknown solver"
        stop
      endif

      if (present(error)) then
        if (success_l) then
          error = ELPA_OK
        else
          error = ELPA_ERROR
        endif
      else if (.not. success_l) then
        write(error_unit,'(a)') "ELPA: Error in eigenvectors() and you did not check for errors!"
      endif
    end subroutine 

    !>  \brief elpa_eigenvectors_device_pointer_d: class method to solve the eigenvalue problem
    !>
    !>  The dimensions of the matrix a (locally ditributed and global), the block-cyclic distribution
    !>  blocksize, the number of eigenvectors
    !>  to be computed and the MPI communicators are already known to the object and MUST be set BEFORE
    !>  with the class method "setup"
    !>
    !>  It is possible to change the behaviour of the method by setting tunable parameters with the
    !>  class method "set"
    !>
    !>  Parameters
    !>
    !>  \param a                                    Distributed matrix for which eigenvalues are to be computed.
    !>                                              Distribution is like in Scalapack.
    !>                                              The full matrix must be set (not only one half like in scalapack).
    !>                                              Destroyed on exit (upper and lower half).
    !>
    !>  \param ev                                   On output: eigenvalues of a, every processor gets the complete set
    !>
    !>  \param q                                    On output: Eigenvectors of a
    !>                                              Distribution is like in Scalapack.
    !>                                              Must be always dimensioned to the full size (corresponding to (na,na))
    !>                                              even if only a part of the eigenvalues is needed.
    !>
    !>  \param error                                integer, optional: returns an error code, which can be queried with elpa_strerr   

    subroutine elpa_eigenvectors_device_pointer_&
                    &fc&
                    & (self, a, ev, q, error)
      use iso_c_binding

      implicit none
      class(elpa_impl_t)  :: self

      type(c_ptr)         :: a, q, ev

      integer, optional   :: error
      integer             :: error2
      integer(kind=c_int) :: solver
      logical             :: success_l

      success_l = .false.
      call self%get("solver", solver,error2)
      if (error2 .ne. ELPA_OK) then
        print *,"Problem setting solver. Aborting..."
        if (present(error)) then
          error = error2
        endif
        return
      endif
      if (solver .eq. ELPA_SOLVER_1STAGE) then
        call self%autotune_timer%start("accumulator")
        success_l = elpa_solve_evp_&
                &complex&
                &_1stage_device_pointer_&
                &single&
                &_impl(self, a, ev, q)
        call self%autotune_timer%stop("accumulator")

      else if (solver .eq. ELPA_SOLVER_2STAGE) then
        call self%autotune_timer%start("accumulator")
        success_l = elpa_solve_evp_&
                &complex&
                &_2stage_device_pointer_&
                &single&
                &_impl(self, a, ev, q)
        call self%autotune_timer%stop("accumulator")

      else
        print *,"unknown solver"
        stop
      endif

      if (present(error)) then
        if (success_l) then
          error = ELPA_OK
        else
          error = ELPA_ERROR
        endif
      else if (.not. success_l) then
        write(error_unit,'(a)') "ELPA: Error in eigenvectors() and you did not check for errors!"
      endif
    end subroutine 

    !c> void elpa_eigenvectors_all_host_arrays_fc(elpa_t handle, float complex *a, float *ev, float complex *q, int *error);
    subroutine elpa_eigenvectors_all_host_arrays_&
                    &fc&
                    &_c(handle, a_p, ev_p, q_p, error) &
                    bind(C, name="elpa_eigenvectors_all_host_arrays_fc")
      type(c_ptr), intent(in), value            :: handle, a_p, ev_p, q_p
      integer(kind=c_int), optional, intent(in) :: error

      complex(kind=c_float), pointer :: a(:, :), q(:, :)
      real(kind=c_float), pointer          :: ev(:)
      type(elpa_impl_t), pointer                   :: self

      call c_f_pointer(handle, self)
      call c_f_pointer(a_p, a, [self%local_nrows, self%local_ncols])
      call c_f_pointer(ev_p, ev, [self%na])
      call c_f_pointer(q_p, q, [self%local_nrows, self%local_ncols])

      call elpa_eigenvectors_all_host_arrays_&
              &fc&
              & (self, a, ev, q, error)
    end subroutine    

    !c> void elpa_eigenvectors_device_pointer_fc(elpa_t handle, float complex *a, float *ev, float complex *q, int *error);
    subroutine elpa_eigenvectors_device_pointer_&
                    &fc&
                    &_c(handle, a_p, ev_p, q_p, error) &
                    bind(C, name="elpa_eigenvectors_device_pointer_fc")
      type(c_ptr), intent(in), value            :: handle, a_p, ev_p, q_p
      integer(kind=c_int), optional, intent(in) :: error

      !complex(kind=c_float), pointer :: a(:, :), q(:, :)
      !real(kind=c_float), pointer          :: ev(:)
      type(elpa_impl_t), pointer                   :: self

      !call c_f_pointer(handle, self)
      !call c_f_pointer(a_p, a, [self%local_nrows, self%local_ncols])
      !call c_f_pointer(ev_p, ev, [self%na])
      !call c_f_pointer(q_p, q, [self%local_nrows, self%local_ncols])

      call elpa_eigenvectors_device_pointer_&
              &fc&
              & (self, a_p, ev_p, q_p, error)
    end subroutine


    !>  \brief elpa_eigenvalues_d: class method to solve the eigenvalue problem
    !>
    !>  The dimensions of the matrix a (locally ditributed and global), the block-cyclic distribution
    !>  blocksize, the number of eigenvectors
    !>  to be computed and the MPI communicators are already known to the object and MUST be set BEFORE
    !>  with the class method "setup"
    !>
    !>  It is possible to change the behaviour of the method by setting tunable parameters with the
    !>  class method "set"
    !>
    !>  Parameters
    !>
    !>  \param a                                    Distributed matrix for which eigenvalues are to be computed.
    !>                                              Distribution is like in Scalapack.
    !>                                              The full matrix must be set (not only one half like in scalapack).
    !>                                              Destroyed on exit (upper and lower half).
    !>
    !>  \param ev                                   On output: eigenvalues of a, every processor gets the complete set
    !>
    !>  \param error                                integer, optional: returns an error code, which can be queried with elpa_strerr
    subroutine elpa_eigenvalues_all_host_arrays_&
                    &fc&
                    & (self, a, ev, error)
      class(elpa_impl_t)  :: self
      complex(kind=c_float) :: a(self%local_nrows, *)
      real(kind=c_float) :: ev(self%na)
      integer, optional   :: error
      integer             :: error2
      integer(kind=c_int) :: solver
      logical             :: success_l

      success_l = .false.
      call self%get("solver", solver,error2)
      if (error2 .ne. ELPA_OK) then
         print *,"Problem getting solver option. Aborting..."
         if (present(error)) then
           error = error2
         endif
         return
      endif

      if (solver .eq. ELPA_SOLVER_1STAGE) then
        call self%autotune_timer%start("accumulator")
        success_l = elpa_solve_evp_&
                &complex&
                          &_1stage_all_host_arrays_&
                          &single&
                          &_impl(self, a, ev)
        call self%autotune_timer%stop("accumulator")

      else if (solver .eq. ELPA_SOLVER_2STAGE) then
        call self%autotune_timer%start("accumulator")
        success_l = elpa_solve_evp_&
                &complex&
                                   &_2stage_all_host_arrays_&
                                   &single&
                                   &_impl(self, a, ev)
        call self%autotune_timer%stop("accumulator")

      else
        print *,"unknown solver"
        stop
      endif
      if (present(error)) then
        if (success_l) then
          error = ELPA_OK
        else
          error = ELPA_ERROR
        endif
      else if (.not. success_l) then
        write(error_unit,'(a)') "ELPA: Error in eigenvalues() and you did not check for errors!"
      endif
    end subroutine


    !>  \brief elpa_eigenvalues_d: class method to solve the eigenvalue problem
    !>
    !>  The dimensions of the matrix a (locally ditributed and global), the block-cyclic distribution
    !>  blocksize, the number of eigenvectors
    !>  to be computed and the MPI communicators are already known to the object and MUST be set BEFORE
    !>  with the class method "setup"
    !>
    !>  It is possible to change the behaviour of the method by setting tunable parameters with the
    !>  class method "set"
    !>
    !>  Parameters
    !>
    !>  \param a                                    Distributed matrix for which eigenvalues are to be computed.
    !>                                              Distribution is like in Scalapack.
    !>                                              The full matrix must be set (not only one half like in scalapack).
    !>                                              Destroyed on exit (upper and lower half).
    !>
    !>  \param ev                                   On output: eigenvalues of a, every processor gets the complete set
    !>
    !>  \param error                                integer, optional: returns an error code, which can be queried with elpa_strerr
    subroutine elpa_eigenvalues_device_pointer_&
                    &fc&
                    & (self, a, ev, error)
      use iso_c_binding
      implicit none

      class(elpa_impl_t)  :: self
      type(c_ptr)         :: a, ev
      integer, optional   :: error
      integer             :: error2
      integer(kind=c_int) :: solver
      logical             :: success_l

      success_l = .false.
      call self%get("solver", solver,error2)
      if (error2 .ne. ELPA_OK) then
         print *,"Problem getting solver option. Aborting..."
         if (present(error)) then
           error = error2
         endif
         return
      endif

      if (solver .eq. ELPA_SOLVER_1STAGE) then
        call self%autotune_timer%start("accumulator")
        success_l = elpa_solve_evp_&
                &complex&
                          &_1stage_device_pointer_&
                          &single&
                          &_impl(self, a, ev)
        call self%autotune_timer%stop("accumulator")

      else if (solver .eq. ELPA_SOLVER_2STAGE) then
        call self%autotune_timer%start("accumulator")
        success_l = elpa_solve_evp_&
                &complex&
                                   &_2stage_device_pointer_&
                                   &single&
                                   &_impl(self, a, ev)
        call self%autotune_timer%stop("accumulator")

      else
        print *,"unknown solver"
        stop
      endif
      if (present(error)) then
        if (success_l) then
          error = ELPA_OK
        else
          error = ELPA_ERROR
        endif
      else if (.not. success_l) then
        write(error_unit,'(a)') "ELPA: Error in eigenvalues() and you did not check for errors!"
      endif
    end subroutine

    !c> void elpa_eigenvalues_all_host_arrays_fc(elpa_t handle, float complex *a, float *ev, int *error);
    subroutine elpa_eigenvalues_all_host_arrays_&
                    &fc&
                    &_c(handle, a_p, ev_p, error) &
                    bind(C, name="elpa_eigenvalues_all_host_arrays_fc")

      type(c_ptr), intent(in), value :: handle, a_p, ev_p
      integer(kind=c_int), intent(in) :: error

      complex(kind=c_float), pointer :: a(:, :)
      real(kind=c_float), pointer :: ev(:)
      type(elpa_impl_t), pointer  :: self

      call c_f_pointer(handle, self)
      call c_f_pointer(a_p, a, [self%local_nrows, self%local_ncols])
      call c_f_pointer(ev_p, ev, [self%na])

      call elpa_eigenvalues_all_host_arrays_&
              &fc&
              & (self, a, ev, error)
    end subroutine    

    !c> void elpa_eigenvalues_device_pointer_fc(elpa_t handle, float complex *a, float *ev, int *error);
    subroutine elpa_eigenvalues_device_pointer_&
                    &fc&
                    &_c(handle, a_p, ev_p, error) &
                    bind(C, name="elpa_eigenvalues_device_pointer_fc")

      type(c_ptr), intent(in), value :: handle, a_p, ev_p
      integer(kind=c_int), intent(in) :: error

      !complex(kind=c_float), pointer :: a(:, :)
      !real(kind=c_float), pointer :: ev(:)
      type(elpa_impl_t), pointer  :: self

      !call c_f_pointer(handle, self)
      !call c_f_pointer(a_p, a, [self%local_nrows, self%local_ncols])
      !call c_f_pointer(ev_p, ev, [self%na])

      call elpa_eigenvalues_device_pointer_&
              &fc&
              & (self, a_p, ev_p, error)
    end subroutine    


    !>  \brief elpa_generalized_eigenvectors_d: class method to solve the eigenvalue problem
    !>
    !>  The dimensions of the matrix a (locally ditributed and global), the block-cyclic distribution
    !>  blocksize, the number of eigenvectors
    !>  to be computed and the MPI communicators are already known to the object and MUST be set BEFORE
    !>  with the class method "setup"
    !>
    !>  It is possible to change the behaviour of the method by setting tunable parameters with the
    !>  class method "set"
    !>
    !>  Parameters
    !>
    !>  \param a                                    Distributed matrix for which eigenvalues are to be computed.
    !>                                              Distribution is like in Scalapack.
    !>                                              The full matrix must be set (not only one half like in scalapack).
    !>                                              Destroyed on exit (upper and lower half).
    !>
    !>  \param b                                    Distributed matrix, part of the generalized eigenvector problem, or the
    !>                                              product of a previous call to this function (see is_already_decomposed).
    !>                                              Distribution is like in Scalapack.
    !>                                              If is_already_decomposed is false, on exit replaced by the decomposition
    !>
    !>  \param ev                                   On output: eigenvalues of a, every processor gets the complete set
    !>
    !>  \param q                                    On output: Eigenvectors of a
    !>                                              Distribution is like in Scalapack.
    !>                                              Must be always dimensioned to the full size (corresponding to (na,na))
    !>                                              even if only a part of the eigenvalues is needed.
    !>
    !>  \param is_already_decomposed                has to be set to .false. for the first call with a given b and .true. for
    !>                                              each subsequent call with the same b, since b then already contains
    !>                                              decomposition and thus the decomposing step is skipped
    !>
    !>  \param error                                integer, optional: returns an error code, which can be queried with elpa_strerr 
    subroutine elpa_generalized_eigenvectors_&
                    &fc&
                    & (self, a, b, ev, q, is_already_decomposed, error)
      use elpa2_impl
      use elpa1_impl
      use elpa_utilities, only : error_unit
      use, intrinsic :: iso_c_binding
      class(elpa_impl_t)  :: self

      complex(kind=c_float) :: a(self%local_nrows, *), b(self%local_nrows, *), q(self%local_nrows, *)
      real(kind=c_float) :: ev(self%na)
      logical             :: is_already_decomposed

      integer, optional   :: error
      integer             :: error_l
      integer(kind=c_int) :: solver
      logical             :: success_l

      error_l   = -10
      success_l = .false.
      call self%elpa_transform_generalized_&
              &fc&
              & (a, b, is_already_decomposed, error_l)
      if (present(error)) then
          error = error_l
      else if (error_l .ne. ELPA_OK) then
        write(error_unit,'(a)') "ELPA: Error in transform_generalized() and you did not check for errors!"
      endif

      call self%get("solver", solver,error_l)
      if (solver .eq. ELPA_SOLVER_1STAGE) then
        success_l = elpa_solve_evp_&
                &complex&
                &_1stage_all_host_arrays_&
                &single&
                &_impl(self, a, ev, q)
      else if (solver .eq. ELPA_SOLVER_2STAGE) then
        success_l = elpa_solve_evp_&
                &complex&
                &_2stage_all_host_arrays_&
                &single&
                &_impl(self, a, ev, q)
      else
        print *,"unknown solver"
        stop
      endif

      if (present(error)) then
        if (success_l) then
          error = ELPA_OK
        else
          error = ELPA_ERROR
        endif
      else if (.not. success_l) then
        write(error_unit,'(a)') "ELPA: Error in solve() and you did not check for errors!"
      endif

      call self%elpa_transform_back_generalized_&
              &fc&
              & (b, q, error_l)
      if (present(error)) then
          error = error_l
      else if (error_l .ne. ELPA_OK) then
        write(error_unit,'(a)') "ELPA: Error in transform_back_generalized() and you did not check for errors!"
      endif
    end subroutine

    !c> void elpa_generalized_eigenvectors_fc(elpa_t handle, float complex *a, float complex *b, float *ev, float complex *q,
    !c> int is_already_decomposed, int *error);
    subroutine elpa_generalized_eigenvectors_&
                    &fc&
                    &_c(handle, a_p, b_p, ev_p, q_p, is_already_decomposed, error) &
                                                            bind(C, name="elpa_generalized_eigenvectors_fc")
      type(c_ptr), intent(in), value :: handle, a_p, b_p, ev_p, q_p
      integer(kind=c_int), intent(in), value :: is_already_decomposed
      integer(kind=c_int), optional, intent(in) :: error
      complex(kind=c_float), pointer :: a(:, :), b(:, :), q(:, :)
      real(kind=c_float), pointer :: ev(:)
      logical :: is_already_decomposed_fortran
      type(elpa_impl_t), pointer  :: self

      call c_f_pointer(handle, self)
      call c_f_pointer(a_p, a, [self%local_nrows, self%local_ncols])
      call c_f_pointer(b_p, b, [self%local_nrows, self%local_ncols])
      call c_f_pointer(ev_p, ev, [self%na])
      call c_f_pointer(q_p, q, [self%local_nrows, self%local_ncols])
      if(is_already_decomposed .eq. 0) then
        is_already_decomposed_fortran = .false.
      else
        is_already_decomposed_fortran = .true.
      end if

      call elpa_generalized_eigenvectors_&
              &fc&
              & (self, a, b, ev, q, is_already_decomposed_fortran, error)
    end subroutine

    

    !>  \brief elpa_generalized_eigenvalues_d: class method to solve the eigenvalue problem
    !>
    !>  The dimensions of the matrix a (locally ditributed and global), the block-cyclic distribution
    !>  blocksize, the number of eigenvectors
    !>  to be computed and the MPI communicators are already known to the object and MUST be set BEFORE
    !>  with the class method "setup"
    !>
    !>  It is possible to change the behaviour of the method by setting tunable parameters with the
    !>  class method "set"
    !>
    !>  Parameters
    !>
    !>  \param a                                    Distributed matrix for which eigenvalues are to be computed.
    !>                                              Distribution is like in Scalapack.
    !>                                              The full matrix must be set (not only one half like in scalapack).
    !>                                              Destroyed on exit (upper and lower half).
    !>
    !>  \param b                                    Distributed matrix, part of the generalized eigenvector problem, or the
    !>                                              product of a previous call to this function (see is_already_decomposed).
    !>                                              Distribution is like in Scalapack.
    !>                                              If is_already_decomposed is false, on exit replaced by the decomposition
    !>
    !>  \param ev                                   On output: eigenvalues of a, every processor gets the complete set
    !>
    !>  \param is_already_decomposed                has to be set to .false. for the first call with a given b and .true. for
    !>                                              each subsequent call with the same b, since b then already contains
    !>                                              decomposition and thus the decomposing step is skipped
    !>
    !>  \param error                                integer, optional: returns an error code, which can be queried with elpa_strerr
    subroutine elpa_generalized_eigenvalues_&
                    &fc&
                    & (self, a, b, ev, is_already_decomposed, error)
      use elpa2_impl
      use elpa1_impl
      use elpa_utilities, only : error_unit
      use, intrinsic :: iso_c_binding
      class(elpa_impl_t)  :: self

      complex(kind=c_float) :: a(self%local_nrows, *), b(self%local_nrows, *)
      real(kind=c_float) :: ev(self%na)
      logical             :: is_already_decomposed

      integer, optional   :: error
      integer             :: error_l
      integer(kind=c_int) :: solver
      logical             :: success_l

      error_l = -10
      success_l = .false.
      call self%elpa_transform_generalized_&
              &fc&
              & (a, b, is_already_decomposed, error_l)
      if (present(error)) then
          error = error_l
      else if (error_l .ne. ELPA_OK) then
        write(error_unit,'(a)') "ELPA: Error in transform_generalized() and you did not check for errors!"
      endif

      call self%get("solver", solver,error_l)
      if (solver .eq. ELPA_SOLVER_1STAGE) then
        success_l = elpa_solve_evp_&
                &complex&
                &_1stage_all_host_arrays_&
                &single&
                &_impl(self, a, ev)
      else if (solver .eq. ELPA_SOLVER_2STAGE) then
        success_l = elpa_solve_evp_&
                &complex&
                &_2stage_all_host_arrays_&
                &single&
                &_impl(self, a, ev)
      else
        print *,"unknown solver"
        stop
      endif

      if (present(error)) then
        if (success_l) then
          error = ELPA_OK
        else
          error = ELPA_ERROR
        endif
      else if (.not. success_l) then
        write(error_unit,'(a)') "ELPA: Error in solve() and you did not check for errors!"
      endif

    end subroutine

    !c> void elpa_generalized_eigenvalues_fc(elpa_t handle, float complex *a, float complex *b, float *ev,
    !c> int is_already_decomposed, int *error);
    subroutine elpa_generalized_eigenvalues_&
                    &fc&
                    &_c(handle, a_p, b_p, ev_p, is_already_decomposed, error) &
                                                            bind(C, name="elpa_generalized_eigenvalues_fc")
      type(c_ptr), intent(in), value :: handle, a_p, b_p, ev_p
      integer(kind=c_int), intent(in), value :: is_already_decomposed
      integer(kind=c_int), optional, intent(in) :: error

      complex(kind=c_float), pointer :: a(:, :), b(:, :)
      real(kind=c_float), pointer :: ev(:)
      logical :: is_already_decomposed_fortran
      type(elpa_impl_t), pointer  :: self

      call c_f_pointer(handle, self)
      call c_f_pointer(a_p, a, [self%local_nrows, self%local_ncols])
      call c_f_pointer(b_p, b, [self%local_nrows, self%local_ncols])
      call c_f_pointer(ev_p, ev, [self%na])
      if(is_already_decomposed .eq. 0) then
        is_already_decomposed_fortran = .false.
      else
        is_already_decomposed_fortran = .true.
      end if

      call elpa_generalized_eigenvalues_&
              &fc&
              & (self, a, b, ev, is_already_decomposed_fortran, error)
    end subroutine


    !> \brief  elpa_hermitian_multiply_d: class method to perform C : = A**T * B
    !>         where   A is a square matrix (self%na,self%na) which is optionally upper or lower triangular
    !>                 B is a (self%na,ncb) matrix
    !>                 C is a (self%na,ncb) matrix where optionally only the upper or lower
    !>                   triangle may be computed
    !>
    !> the MPI commicators and the block-cyclic distribution block size are already known to the type.
    !> Thus the class method "setup" must be called BEFORE this method is used
    !>
    !> \details
    !>
    !> \param  self                 class(elpa_t), the ELPA object
    !> \param  uplo_a               'U' if A is upper triangular
    !>                              'L' if A is lower triangular
    !>                              anything else if A is a full matrix
    !>                              Please note: This pertains to the original A (as set in the calling program)
    !>                                           whereas the transpose of A is used for calculations
    !>                              If uplo_a is 'U' or 'L', the other triangle is not used at all,
    !>                              i.e. it may contain arbitrary numbers
    !> \param uplo_c                'U' if only the upper diagonal part of C is needed
    !>                              'L' if only the upper diagonal part of C is needed
    !>                              anything else if the full matrix C is needed
    !>                              Please note: Even when uplo_c is 'U' or 'L', the other triangle may be
    !>                                            written to a certain extent, i.e. one shouldn't rely on the content there!
    !> \param ncb                   Number of columns  of global matrices B and C
    !> \param a                     matrix a
    !> \param local_nrows           number of rows of local (sub) matrix a, set with class method set("local_nrows",value)
    !> \param local_ncols           number of columns of local (sub) matrix a, set with class method set("local_ncols",value)
    !> \param b                     matrix b
    !> \param nrows_b               number of rows of local (sub) matrix b
    !> \param ncols_b               number of columns of local (sub) matrix b
    !> \param c                     matrix c
    !> \param nrows_c               number of rows of local (sub) matrix c
    !> \param ncols_c               number of columns of local (sub) matrix c
    !> \param error                 optional argument, error code which can be queried with elpa_strerr
    subroutine elpa_hermitian_multiply_&
                   &fc&
                   & (self, uplo_a, uplo_c, ncb, a, b, nrows_b, ncols_b, &
                                          c, nrows_c, ncols_c, error)
      class(elpa_impl_t)              :: self
      character*1                     :: uplo_a, uplo_c
      integer(kind=c_int), intent(in) :: nrows_b, ncols_b, nrows_c, ncols_c, ncb
      complex(kind=c_float) :: a(self%local_nrows,*), b(nrows_b,*), c(nrows_c,*)
      integer, optional               :: error
      logical                         :: success_l
     
      success_l = .false.
      success_l = elpa_mult_ah_b_&
              &complex&
              &_&
              &single&
              &_impl(self, uplo_a, uplo_c, ncb, a, b, nrows_b, ncols_b, &
                                                  c, nrows_c, ncols_c)
      if (present(error)) then
        if (success_l) then
          error = ELPA_OK
        else
          error = ELPA_ERROR
        endif
      else if (.not. success_l) then
        write(error_unit,'(a)') "ELPA: Error in hermitian_multiply() and you did not check for errors!"
      endif
    end subroutine  

    !c> void elpa_hermitian_multiply_fc(elpa_t handle, char uplo_a, char uplo_c, int ncb, float complex *a, float complex *b, int nrows_b, int ncols_b, float complex *c, int nrows_c, int ncols_c, int *error);
    subroutine elpa_hermitian_multiply_&
                    &fc&
                    &_c(handle, uplo_a, uplo_c, ncb, a_p, b, nrows_b, &
                                           ncols_b, c, nrows_c, ncols_c, error)          &
                                           bind(C, name="elpa_hermitian_multiply_fc")

      type(c_ptr), intent(in), value            :: handle, a_p
      character(1,C_CHAR), value                :: uplo_a, uplo_c
      integer(kind=c_int), value                :: ncb, nrows_b, ncols_b, nrows_c, ncols_c
      integer(kind=c_int), optional, intent(in) :: error
      complex(kind=c_float), pointer              :: a(:, :)
      complex(kind=c_float)                       :: b(nrows_b,*), c(nrows_c,*)
      type(elpa_impl_t), pointer                :: self

      call c_f_pointer(handle, self)
      call c_f_pointer(a_p, a, [self%local_nrows, self%local_ncols])

      call elpa_hermitian_multiply_&
              &fc&
              & (self, uplo_a, uplo_c, ncb, a, b, nrows_b, &
                                     ncols_b, c, nrows_c, ncols_c, error)
    end subroutine


    !>  \brief elpa_cholesky_d: class method to do a cholesky factorization
    !>
    !>  The dimensions of the matrix a (locally ditributed and global), the block-cylic-distribution
    !>  block size, and the MPI communicators are already known to the object and MUST be set BEFORE
    !>  with the class method "setup"
    !>
    !>  It is possible to change the behaviour of the method by setting tunable parameters with the
    !>  class method "set"
    !>
    !>  Parameters
    !>
    !>  \param a                                    Distributed matrix for which eigenvalues are to be computed.
    !>                                              Distribution is like in Scalapack.
    !>                                              The full matrix must be set (not only one half like in scalapack).
    !>                                              Destroyed on exit (upper and lower half).
    !>
    !>  \param error                                integer, optional: returns an error code, which can be queried with elpa_strerr
    subroutine elpa_cholesky_&
                   &fc&
                   & (self, a, error)
      class(elpa_impl_t)              :: self
      complex(kind=c_float)                  :: a(self%local_nrows,*)
      integer, optional               :: error
      logical                         :: success_l

      success_l = .false.
      success_l = elpa_cholesky_&
              &complex&
              &_&
              &single&
              &_impl (self, a)

      if (present(error)) then
        if (success_l) then
          error = ELPA_OK
        else
          error = ELPA_ERROR
        endif
      else if (.not. success_l) then
        write(error_unit,'(a)') "ELPA: Error in cholesky() and you did not check for errors!"
      endif
    end subroutine    

    !c> void elpa_cholesky_fc(elpa_t handle, float complex *a, int *error);
    subroutine elpa_choleksy_&
                    &fc&
                    &_c(handle, a_p, error) &
                    bind(C, name="elpa_cholesky_fc")

      type(c_ptr), intent(in), value            :: handle, a_p
      integer(kind=c_int), optional, intent(in) :: error
      complex(kind=c_float), pointer              :: a(:, :)
      type(elpa_impl_t), pointer                :: self

      call c_f_pointer(handle, self)
      call c_f_pointer(a_p, a, [self%local_nrows, self%local_ncols])

      call elpa_cholesky_&
              &fc&
              & (self, a, error)
    end subroutine      


    !>  \brief elpa_invert_trm_d: class method to invert a triangular
    !>
    !>  The dimensions of the matrix a (locally ditributed and global), the block-cylic-distribution
    !>  block size, and the MPI communicators are already known to the object and MUST be set BEFORE
    !>  with the class method "setup"
    !>
    !>  It is possible to change the behaviour of the method by setting tunable parameters with the
    !>  class method "set"
    !>
    !>  Parameters
    !>
    !>  \param a                                    Distributed matrix for which eigenvalues are to be computed.
    !>                                              Distribution is like in Scalapack.
    !>                                              The full matrix must be set (not only one half like in scalapack).
    !>                                              Destroyed on exit (upper and lower half).
    !>
    !>  \param error                                integer, optional: returns an error code, which can be queried with elpa_strerr
    subroutine elpa_invert_trm_&
                   &fc&
                  & (self, a, error)
      class(elpa_impl_t)              :: self
      complex(kind=c_float)             :: a(self%local_nrows,*)
      integer, optional               :: error
      logical                         :: success_l

      success_l = .false.
      success_l = elpa_invert_trm_&
              &complex&
              &_&
              &single&
              &_impl (self, a)

      if (present(error)) then
        if (success_l) then
          error = ELPA_OK
        else
          error = ELPA_ERROR
        endif
      else if (.not. success_l) then
        write(error_unit,'(a)') "ELPA: Error in invert_trm() and you did not check for errors!"
      endif
    end subroutine   



    !c> void elpa_invert_trm_fc(elpa_t handle, float complex *a, int *error);
    subroutine elpa_invert_trm_&
                    &fc&
                    &_c(handle, a_p, error) &
                    bind(C, name="elpa_invert_trm_fc")

      type(c_ptr), intent(in), value            :: handle, a_p
      integer(kind=c_int), optional, intent(in) :: error
      complex(kind=c_float), pointer              :: a(:, :)
      type(elpa_impl_t), pointer                :: self

      call c_f_pointer(handle, self)
      call c_f_pointer(a_p, a, [self%local_nrows, self%local_ncols])

      call elpa_invert_trm_&
              &fc&
              & (self, a, error)
    end subroutine


    !>  \brief elpa_solve_tridiagonal_d: class method to solve the eigenvalue problem for a tridiagonal matrix a
    !>
    !>  The dimensions of the matrix a (locally ditributed and global), the block-cylic-distribution
    !>  block size, and the MPI communicators are already known to the object and MUST be set BEFORE
    !>  with the class method "setup"
    !>
    !>  It is possible to change the behaviour of the method by setting tunable parameters with the
    !>  class method "set"
    !>
    !>  Parameters
    !>
    !>  \param d        array d  on input diagonal elements of tridiagonal matrix, on
    !>                           output the eigenvalues in ascending order
    !>  \param e        array e on input subdiagonal elements of matrix, on exit destroyed
    !>  \param q        matrix  on exit : contains the eigenvectors
    !>  \param error    integer, optional: returns an error code, which can be queried with elpa_strerr 
    subroutine elpa_solve_tridiagonal_&
                   &fc&
                   & (self, d, e, q, error)
      use solve_tridi
      implicit none
      class(elpa_impl_t)              :: self
      real(kind=c_float)                  :: d(self%na), e(self%na)
      real(kind=c_float)                  :: q(self%local_nrows,*)
      integer, optional               :: error
      logical                         :: success_l

      success_l = elpa_solve_tridi_&
              &single&
              &_impl(self, d, e, q)
      if (present(error)) then
        if (success_l) then
          error = ELPA_OK
        else
          error = ELPA_ERROR
        endif
      else if (.not. success_l) then
        write(error_unit,'(a)') "ELPA: Error in solve_tridiagonal() and you did not check for errors!"
      endif
    end subroutine   


















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

! using elpa internal Hermitian multiply is faster then scalapack multiply, but we need an extra
! temporary matrix.
! using cannon algorithm should be the fastest. After this is verified, the other options should be removed
! however, we need the extra temporary matrix as well.

   subroutine elpa_transform_generalized_&
            &d&
            &(self, a, b, is_already_decomposed, error)
     use precision
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

     class(elpa_impl_t)  :: self
     real(kind=rck) :: a(self%local_nrows, *), b(self%local_nrows, *)
     integer                :: error
     logical                :: is_already_decomposed
     integer                :: sc_desc(SC_DESC_LEN)
     integer(kind=ik)       :: my_p, my_prow, my_pcol, np_rows, np_cols, mpi_comm_rows, mpi_comm_cols, mpi_comm_all
     integer(kind=MPI_KIND) :: my_pMPI, my_prowMPI, my_pcolMPI, np_rowsMPI, np_colsMPI
     integer(kind=ik)       :: BuffLevelInt, use_cannon
     integer(kind=MPI_KIND) :: mpierr

     real(kind=rck) :: tmp(self%local_nrows, self%local_ncols)

     call self%get("mpi_comm_rows",mpi_comm_rows,error)
     call self%get("mpi_comm_cols",mpi_comm_cols,error)
     call self%get("mpi_comm_parent", mpi_comm_all,error)

     call mpi_comm_rank(int(mpi_comm_all,kind=MPI_KIND), my_pMPI, mpierr)
     call mpi_comm_rank(int(mpi_comm_rows,kind=MPI_KIND),my_prowMPI, mpierr)
     call mpi_comm_size(int(mpi_comm_rows,kind=MPI_KIND),np_rowsMPI, mpierr)
     call mpi_comm_rank(int(mpi_comm_cols,kind=MPI_KIND),my_pcolMPI, mpierr)
     call mpi_comm_size(int(mpi_comm_cols,kind=MPI_KIND),np_colsMPI, mpierr)

     my_p = int(my_pMPI, kind=c_int)
     my_prow = int(my_prowMPI, kind=c_int)
     np_rows = int(np_rowsMPI, kind=c_int)
     my_pcol = int(my_pcolMPI, kind=c_int)
     np_cols = int(np_colsMPI, kind=c_int)

     call self%timer_start("transform_generalized()")
     call self%get("cannon_for_generalized",use_cannon,error)


     if (mod(np_cols, np_rows) /= 0) then
       if(my_p == 0) then
         write(*,*) "To use Cannons algorithm, np_cols must be a multiple of np_rows."
         write(*,*) "Switching to elpa Hermitian and scalapack"
       end if
       use_cannon = 0
     endif

     error = self%construct_scalapack_descriptor(sc_desc, .false.)
     if(error .NE. ELPA_OK) return

     if (.not. is_already_decomposed) then
       ! B = U^T*U, B<-U
       call self%elpa_cholesky_&
           &d&
           &(b, error)
       if(error .NE. ELPA_OK) return
       ! B <- inv(U)
       call self%elpa_invert_trm_&
           &d&
           &(b, error)
       if(error .NE. ELPA_OK) return
     end if

     if(use_cannon == 1) then
       call self%get("cannon_buffer_size",BuffLevelInt,error)
       call self%timer_start("cannons_reduction")
       ! BEWARE! even though tmp is output from the routine, it has to be zero on input!
       tmp = 0.0_rck
       call cannons_reduction_&
         &d&
         &(a, b, self%local_nrows, self%local_ncols, &
           int(sc_desc,kind=BLAS_KIND), tmp, int(BuffLevelInt,kind=MPI_KIND),                    &
           int(mpi_comm_rows,kind=MPI_KIND), int(mpi_comm_cols,kind=MPI_KIND))
       call self%timer_stop("cannons_reduction")

       a(1:self%local_nrows, 1:self%local_ncols) = tmp(1:self%local_nrows, 1:self%local_ncols)

     else  ! do not use cannon algorithm, use elpa hermitian multiply and scalapack instead
       ! tmp <- inv(U^T) * A (we have to use temporary variable)
       call self%elpa_hermitian_multiply_&
           &d&
           &('U','F', self%na, b, a, self%local_nrows, self%local_ncols, tmp, &
                                 self%local_nrows, self%local_ncols, error)
       if(error .NE. ELPA_OK) return

       ! A <- inv(U)^T * A
       a(1:self%local_nrows, 1:self%local_ncols) = tmp(1:self%local_nrows, 1:self%local_ncols)

       ! A <- inv(U)^T * A * inv(U)
       ! For this multiplication we do not have internal function in ELPA,
       ! so we have to call scalapack
       call self%timer_start("scalapack multiply A * inv(U)")
       call p&
           &D&
           &trmm("R", "U", "N", "N", int(self%na,kind=BLAS_KIND), int(self%na,kind=BLAS_KIND), &
                 ONE, b, 1_BLAS_KIND, 1_BLAS_KIND, int(sc_desc,kind=BLAS_KIND), &
                 a, 1_BLAS_KIND, 1_BLAS_KIND, int(sc_desc,kind=BLAS_KIND))
       call self%timer_stop("scalapack multiply A * inv(U)")
     endif ! use_cannon

     !write(*, *) my_prow, my_pcol, "A(2,3)", a(2,3)

     call self%timer_stop("transform_generalized()")
    end subroutine


    subroutine elpa_transform_back_generalized_&
            &d&
            &(self, b, q, error)
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

        class(elpa_impl_t)  :: self
      real(kind=rck) :: b(self%local_nrows, *), q(self%local_nrows, *)
     integer(kind=ik)       :: my_p, my_prow, my_pcol, np_rows, np_cols, mpi_comm_rows, mpi_comm_cols, mpi_comm_all
     integer(kind=MPI_KIND) :: mpierr, my_pMPI, my_prowMPI, my_pcolMPI, np_rowsMPI, np_colsMPI
     integer                :: error
     integer                :: sc_desc(SC_DESC_LEN)
     integer                :: sc_desc_ev(SC_DESC_LEN)
     integer(kind=ik)       :: use_cannon

     real(kind=rck) :: tmp(self%local_nrows, self%local_ncols)

     call self%get("mpi_comm_rows",mpi_comm_rows,error)
     call self%get("mpi_comm_cols",mpi_comm_cols,error)
     call self%get("mpi_comm_parent", mpi_comm_all,error)

     call mpi_comm_rank(int(mpi_comm_all,kind=MPI_KIND), my_pMPI,mpierr)
     call mpi_comm_rank(int(mpi_comm_rows,kind=MPI_KIND),my_prowMPI,mpierr)
     call mpi_comm_size(int(mpi_comm_rows,kind=MPI_KIND),np_rowsMPI,mpierr)
     call mpi_comm_rank(int(mpi_comm_cols,kind=MPI_KIND),my_pcolMPI,mpierr)
     call mpi_comm_size(int(mpi_comm_cols,kind=MPI_KIND),np_colsMPI,mpierr)

     my_p = int(my_pMPI,kind=c_int)
     my_prow = int(my_prowMPI,kind=c_int)
     np_rows = int(np_rowsMPI,kind=c_int)
     my_pcol = int(my_pcolMPI,kind=c_int)
     np_cols = int(np_colsMPI,kind=c_int)

     call self%timer_start("transform_back_generalized()")
     call self%get("cannon_for_generalized",use_cannon,error)


     if (mod(np_cols, np_rows) /= 0) then
       use_cannon = 0
     endif

     error = self%construct_scalapack_descriptor(sc_desc, .false.)
     error = self%construct_scalapack_descriptor(sc_desc_ev, .true.)
     if(error .NE. ELPA_OK) return

     if(use_cannon == 1) then
       call self%timer_start("cannons_triang_rectangular")
       call cannons_triang_rectangular_&
         &d&
         &(b, q, self%local_nrows, self%local_ncols, &
           int(sc_desc,kind=BLAS_KIND), int(sc_desc_ev,kind=BLAS_KIND), tmp,  &
           int(mpi_comm_rows,kind=MPI_KIND), int(mpi_comm_cols,kind=MPI_KIND) );
       call self%timer_stop("cannons_triang_rectangular")

       q(1:self%local_nrows, 1:self%local_ncols) = tmp(1:self%local_nrows, 1:self%local_ncols)
     else
       call self%timer_start("scalapack multiply inv(U) * Q")
       ! Q <- inv(U) * Q
       call p&
           &D&
           &trmm("L", "U", "N", "N", int(self%na,kind=BLAS_KIND), int(self%nev,kind=BLAS_KIND), &
                 ONE, b, 1_BLAS_KIND, 1_BLAS_KIND, int(sc_desc,kind=BLAS_KIND),  &
                 q, 1_BLAS_KIND, 1_BLAS_KIND, int(sc_desc,kind=BLAS_KIND))
       call self%timer_stop("scalapack multiply inv(U) * Q")
     endif
     call self%timer_stop("transform_back_generalized()")

    end subroutine




















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

! using elpa internal Hermitian multiply is faster then scalapack multiply, but we need an extra
! temporary matrix.
! using cannon algorithm should be the fastest. After this is verified, the other options should be removed
! however, we need the extra temporary matrix as well.

   subroutine elpa_transform_generalized_&
            &f&
            &(self, a, b, is_already_decomposed, error)
     use precision
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

     class(elpa_impl_t)  :: self
     real(kind=rck) :: a(self%local_nrows, *), b(self%local_nrows, *)
     integer                :: error
     logical                :: is_already_decomposed
     integer                :: sc_desc(SC_DESC_LEN)
     integer(kind=ik)       :: my_p, my_prow, my_pcol, np_rows, np_cols, mpi_comm_rows, mpi_comm_cols, mpi_comm_all
     integer(kind=MPI_KIND) :: my_pMPI, my_prowMPI, my_pcolMPI, np_rowsMPI, np_colsMPI
     integer(kind=ik)       :: BuffLevelInt, use_cannon
     integer(kind=MPI_KIND) :: mpierr

     real(kind=rck) :: tmp(self%local_nrows, self%local_ncols)

     call self%get("mpi_comm_rows",mpi_comm_rows,error)
     call self%get("mpi_comm_cols",mpi_comm_cols,error)
     call self%get("mpi_comm_parent", mpi_comm_all,error)

     call mpi_comm_rank(int(mpi_comm_all,kind=MPI_KIND), my_pMPI, mpierr)
     call mpi_comm_rank(int(mpi_comm_rows,kind=MPI_KIND),my_prowMPI, mpierr)
     call mpi_comm_size(int(mpi_comm_rows,kind=MPI_KIND),np_rowsMPI, mpierr)
     call mpi_comm_rank(int(mpi_comm_cols,kind=MPI_KIND),my_pcolMPI, mpierr)
     call mpi_comm_size(int(mpi_comm_cols,kind=MPI_KIND),np_colsMPI, mpierr)

     my_p = int(my_pMPI, kind=c_int)
     my_prow = int(my_prowMPI, kind=c_int)
     np_rows = int(np_rowsMPI, kind=c_int)
     my_pcol = int(my_pcolMPI, kind=c_int)
     np_cols = int(np_colsMPI, kind=c_int)

     call self%timer_start("transform_generalized()")
     call self%get("cannon_for_generalized",use_cannon,error)


     if (mod(np_cols, np_rows) /= 0) then
       if(my_p == 0) then
         write(*,*) "To use Cannons algorithm, np_cols must be a multiple of np_rows."
         write(*,*) "Switching to elpa Hermitian and scalapack"
       end if
       use_cannon = 0
     endif

     error = self%construct_scalapack_descriptor(sc_desc, .false.)
     if(error .NE. ELPA_OK) return

     if (.not. is_already_decomposed) then
       ! B = U^T*U, B<-U
       call self%elpa_cholesky_&
           &f&
           &(b, error)
       if(error .NE. ELPA_OK) return
       ! B <- inv(U)
       call self%elpa_invert_trm_&
           &f&
           &(b, error)
       if(error .NE. ELPA_OK) return
     end if

     if(use_cannon == 1) then
       call self%get("cannon_buffer_size",BuffLevelInt,error)
       call self%timer_start("cannons_reduction")
       ! BEWARE! even though tmp is output from the routine, it has to be zero on input!
       tmp = 0.0_rck
       call cannons_reduction_&
         &f&
         &(a, b, self%local_nrows, self%local_ncols, &
           int(sc_desc,kind=BLAS_KIND), tmp, int(BuffLevelInt,kind=MPI_KIND),                    &
           int(mpi_comm_rows,kind=MPI_KIND), int(mpi_comm_cols,kind=MPI_KIND))
       call self%timer_stop("cannons_reduction")

       a(1:self%local_nrows, 1:self%local_ncols) = tmp(1:self%local_nrows, 1:self%local_ncols)

     else  ! do not use cannon algorithm, use elpa hermitian multiply and scalapack instead
       ! tmp <- inv(U^T) * A (we have to use temporary variable)
       call self%elpa_hermitian_multiply_&
           &f&
           &('U','F', self%na, b, a, self%local_nrows, self%local_ncols, tmp, &
                                 self%local_nrows, self%local_ncols, error)
       if(error .NE. ELPA_OK) return

       ! A <- inv(U)^T * A
       a(1:self%local_nrows, 1:self%local_ncols) = tmp(1:self%local_nrows, 1:self%local_ncols)

       ! A <- inv(U)^T * A * inv(U)
       ! For this multiplication we do not have internal function in ELPA,
       ! so we have to call scalapack
       call self%timer_start("scalapack multiply A * inv(U)")
       call p&
           &S&
           &trmm("R", "U", "N", "N", int(self%na,kind=BLAS_KIND), int(self%na,kind=BLAS_KIND), &
                 ONE, b, 1_BLAS_KIND, 1_BLAS_KIND, int(sc_desc,kind=BLAS_KIND), &
                 a, 1_BLAS_KIND, 1_BLAS_KIND, int(sc_desc,kind=BLAS_KIND))
       call self%timer_stop("scalapack multiply A * inv(U)")
     endif ! use_cannon

     !write(*, *) my_prow, my_pcol, "A(2,3)", a(2,3)

     call self%timer_stop("transform_generalized()")
    end subroutine


    subroutine elpa_transform_back_generalized_&
            &f&
            &(self, b, q, error)
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

        class(elpa_impl_t)  :: self
      real(kind=rck) :: b(self%local_nrows, *), q(self%local_nrows, *)
     integer(kind=ik)       :: my_p, my_prow, my_pcol, np_rows, np_cols, mpi_comm_rows, mpi_comm_cols, mpi_comm_all
     integer(kind=MPI_KIND) :: mpierr, my_pMPI, my_prowMPI, my_pcolMPI, np_rowsMPI, np_colsMPI
     integer                :: error
     integer                :: sc_desc(SC_DESC_LEN)
     integer                :: sc_desc_ev(SC_DESC_LEN)
     integer(kind=ik)       :: use_cannon

     real(kind=rck) :: tmp(self%local_nrows, self%local_ncols)

     call self%get("mpi_comm_rows",mpi_comm_rows,error)
     call self%get("mpi_comm_cols",mpi_comm_cols,error)
     call self%get("mpi_comm_parent", mpi_comm_all,error)

     call mpi_comm_rank(int(mpi_comm_all,kind=MPI_KIND), my_pMPI,mpierr)
     call mpi_comm_rank(int(mpi_comm_rows,kind=MPI_KIND),my_prowMPI,mpierr)
     call mpi_comm_size(int(mpi_comm_rows,kind=MPI_KIND),np_rowsMPI,mpierr)
     call mpi_comm_rank(int(mpi_comm_cols,kind=MPI_KIND),my_pcolMPI,mpierr)
     call mpi_comm_size(int(mpi_comm_cols,kind=MPI_KIND),np_colsMPI,mpierr)

     my_p = int(my_pMPI,kind=c_int)
     my_prow = int(my_prowMPI,kind=c_int)
     np_rows = int(np_rowsMPI,kind=c_int)
     my_pcol = int(my_pcolMPI,kind=c_int)
     np_cols = int(np_colsMPI,kind=c_int)

     call self%timer_start("transform_back_generalized()")
     call self%get("cannon_for_generalized",use_cannon,error)


     if (mod(np_cols, np_rows) /= 0) then
       use_cannon = 0
     endif

     error = self%construct_scalapack_descriptor(sc_desc, .false.)
     error = self%construct_scalapack_descriptor(sc_desc_ev, .true.)
     if(error .NE. ELPA_OK) return

     if(use_cannon == 1) then
       call self%timer_start("cannons_triang_rectangular")
       call cannons_triang_rectangular_&
         &f&
         &(b, q, self%local_nrows, self%local_ncols, &
           int(sc_desc,kind=BLAS_KIND), int(sc_desc_ev,kind=BLAS_KIND), tmp,  &
           int(mpi_comm_rows,kind=MPI_KIND), int(mpi_comm_cols,kind=MPI_KIND) );
       call self%timer_stop("cannons_triang_rectangular")

       q(1:self%local_nrows, 1:self%local_ncols) = tmp(1:self%local_nrows, 1:self%local_ncols)
     else
       call self%timer_start("scalapack multiply inv(U) * Q")
       ! Q <- inv(U) * Q
       call p&
           &S&
           &trmm("L", "U", "N", "N", int(self%na,kind=BLAS_KIND), int(self%nev,kind=BLAS_KIND), &
                 ONE, b, 1_BLAS_KIND, 1_BLAS_KIND, int(sc_desc,kind=BLAS_KIND),  &
                 q, 1_BLAS_KIND, 1_BLAS_KIND, int(sc_desc,kind=BLAS_KIND))
       call self%timer_stop("scalapack multiply inv(U) * Q")
     endif
     call self%timer_stop("transform_back_generalized()")

    end subroutine





















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

! using elpa internal Hermitian multiply is faster then scalapack multiply, but we need an extra
! temporary matrix.
! using cannon algorithm should be the fastest. After this is verified, the other options should be removed
! however, we need the extra temporary matrix as well.

   subroutine elpa_transform_generalized_&
            &dc&
            &(self, a, b, is_already_decomposed, error)
     use precision
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
     class(elpa_impl_t)  :: self
     complex(kind=rck) :: a(self%local_nrows, *), b(self%local_nrows, *)
     integer                :: error
     logical                :: is_already_decomposed
     integer                :: sc_desc(SC_DESC_LEN)
     integer(kind=ik)       :: my_p, my_prow, my_pcol, np_rows, np_cols, mpi_comm_rows, mpi_comm_cols, mpi_comm_all
     integer(kind=MPI_KIND) :: my_pMPI, my_prowMPI, my_pcolMPI, np_rowsMPI, np_colsMPI
     integer(kind=ik)       :: BuffLevelInt, use_cannon
     integer(kind=MPI_KIND) :: mpierr

     complex(kind=rck) :: tmp(self%local_nrows, self%local_ncols)

     call self%get("mpi_comm_rows",mpi_comm_rows,error)
     call self%get("mpi_comm_cols",mpi_comm_cols,error)
     call self%get("mpi_comm_parent", mpi_comm_all,error)

     call mpi_comm_rank(int(mpi_comm_all,kind=MPI_KIND), my_pMPI, mpierr)
     call mpi_comm_rank(int(mpi_comm_rows,kind=MPI_KIND),my_prowMPI, mpierr)
     call mpi_comm_size(int(mpi_comm_rows,kind=MPI_KIND),np_rowsMPI, mpierr)
     call mpi_comm_rank(int(mpi_comm_cols,kind=MPI_KIND),my_pcolMPI, mpierr)
     call mpi_comm_size(int(mpi_comm_cols,kind=MPI_KIND),np_colsMPI, mpierr)

     my_p = int(my_pMPI, kind=c_int)
     my_prow = int(my_prowMPI, kind=c_int)
     np_rows = int(np_rowsMPI, kind=c_int)
     my_pcol = int(my_pcolMPI, kind=c_int)
     np_cols = int(np_colsMPI, kind=c_int)

     call self%timer_start("transform_generalized()")
     call self%get("cannon_for_generalized",use_cannon,error)


     if (mod(np_cols, np_rows) /= 0) then
       if(my_p == 0) then
         write(*,*) "To use Cannons algorithm, np_cols must be a multiple of np_rows."
         write(*,*) "Switching to elpa Hermitian and scalapack"
       end if
       use_cannon = 0
     endif

     error = self%construct_scalapack_descriptor(sc_desc, .false.)
     if(error .NE. ELPA_OK) return

     if (.not. is_already_decomposed) then
       ! B = U^T*U, B<-U
       call self%elpa_cholesky_&
           &dc&
           &(b, error)
       if(error .NE. ELPA_OK) return
       ! B <- inv(U)
       call self%elpa_invert_trm_&
           &dc&
           &(b, error)
       if(error .NE. ELPA_OK) return
     end if

     if(use_cannon == 1) then
       call self%get("cannon_buffer_size",BuffLevelInt,error)
       call self%timer_start("cannons_reduction")
       ! BEWARE! even though tmp is output from the routine, it has to be zero on input!
       tmp = 0.0_rck
       call cannons_reduction_&
         &dc&
         &(a, b, self%local_nrows, self%local_ncols, &
           int(sc_desc,kind=BLAS_KIND), tmp, int(BuffLevelInt,kind=MPI_KIND),                    &
           int(mpi_comm_rows,kind=MPI_KIND), int(mpi_comm_cols,kind=MPI_KIND))
       call self%timer_stop("cannons_reduction")

       a(1:self%local_nrows, 1:self%local_ncols) = tmp(1:self%local_nrows, 1:self%local_ncols)

     else  ! do not use cannon algorithm, use elpa hermitian multiply and scalapack instead
       ! tmp <- inv(U^T) * A (we have to use temporary variable)
       call self%elpa_hermitian_multiply_&
           &dc&
           &('U','F', self%na, b, a, self%local_nrows, self%local_ncols, tmp, &
                                 self%local_nrows, self%local_ncols, error)
       if(error .NE. ELPA_OK) return

       ! A <- inv(U)^T * A
       a(1:self%local_nrows, 1:self%local_ncols) = tmp(1:self%local_nrows, 1:self%local_ncols)

       ! A <- inv(U)^T * A * inv(U)
       ! For this multiplication we do not have internal function in ELPA,
       ! so we have to call scalapack
       call self%timer_start("scalapack multiply A * inv(U)")
       call p&
           &Z&
           &trmm("R", "U", "N", "N", int(self%na,kind=BLAS_KIND), int(self%na,kind=BLAS_KIND), &
                 ONE, b, 1_BLAS_KIND, 1_BLAS_KIND, int(sc_desc,kind=BLAS_KIND), &
                 a, 1_BLAS_KIND, 1_BLAS_KIND, int(sc_desc,kind=BLAS_KIND))
       call self%timer_stop("scalapack multiply A * inv(U)")
     endif ! use_cannon

     !write(*, *) my_prow, my_pcol, "A(2,3)", a(2,3)

     call self%timer_stop("transform_generalized()")
    end subroutine


    subroutine elpa_transform_back_generalized_&
            &dc&
            &(self, b, q, error)
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
        class(elpa_impl_t)  :: self
      complex(kind=rck) :: b(self%local_nrows, *), q(self%local_nrows, *)
     integer(kind=ik)       :: my_p, my_prow, my_pcol, np_rows, np_cols, mpi_comm_rows, mpi_comm_cols, mpi_comm_all
     integer(kind=MPI_KIND) :: mpierr, my_pMPI, my_prowMPI, my_pcolMPI, np_rowsMPI, np_colsMPI
     integer                :: error
     integer                :: sc_desc(SC_DESC_LEN)
     integer                :: sc_desc_ev(SC_DESC_LEN)
     integer(kind=ik)       :: use_cannon

     complex(kind=rck) :: tmp(self%local_nrows, self%local_ncols)

     call self%get("mpi_comm_rows",mpi_comm_rows,error)
     call self%get("mpi_comm_cols",mpi_comm_cols,error)
     call self%get("mpi_comm_parent", mpi_comm_all,error)

     call mpi_comm_rank(int(mpi_comm_all,kind=MPI_KIND), my_pMPI,mpierr)
     call mpi_comm_rank(int(mpi_comm_rows,kind=MPI_KIND),my_prowMPI,mpierr)
     call mpi_comm_size(int(mpi_comm_rows,kind=MPI_KIND),np_rowsMPI,mpierr)
     call mpi_comm_rank(int(mpi_comm_cols,kind=MPI_KIND),my_pcolMPI,mpierr)
     call mpi_comm_size(int(mpi_comm_cols,kind=MPI_KIND),np_colsMPI,mpierr)

     my_p = int(my_pMPI,kind=c_int)
     my_prow = int(my_prowMPI,kind=c_int)
     np_rows = int(np_rowsMPI,kind=c_int)
     my_pcol = int(my_pcolMPI,kind=c_int)
     np_cols = int(np_colsMPI,kind=c_int)

     call self%timer_start("transform_back_generalized()")
     call self%get("cannon_for_generalized",use_cannon,error)


     if (mod(np_cols, np_rows) /= 0) then
       use_cannon = 0
     endif

     error = self%construct_scalapack_descriptor(sc_desc, .false.)
     error = self%construct_scalapack_descriptor(sc_desc_ev, .true.)
     if(error .NE. ELPA_OK) return

     if(use_cannon == 1) then
       call self%timer_start("cannons_triang_rectangular")
       call cannons_triang_rectangular_&
         &dc&
         &(b, q, self%local_nrows, self%local_ncols, &
           int(sc_desc,kind=BLAS_KIND), int(sc_desc_ev,kind=BLAS_KIND), tmp,  &
           int(mpi_comm_rows,kind=MPI_KIND), int(mpi_comm_cols,kind=MPI_KIND) );
       call self%timer_stop("cannons_triang_rectangular")

       q(1:self%local_nrows, 1:self%local_ncols) = tmp(1:self%local_nrows, 1:self%local_ncols)
     else
       call self%timer_start("scalapack multiply inv(U) * Q")
       ! Q <- inv(U) * Q
       call p&
           &Z&
           &trmm("L", "U", "N", "N", int(self%na,kind=BLAS_KIND), int(self%nev,kind=BLAS_KIND), &
                 ONE, b, 1_BLAS_KIND, 1_BLAS_KIND, int(sc_desc,kind=BLAS_KIND),  &
                 q, 1_BLAS_KIND, 1_BLAS_KIND, int(sc_desc,kind=BLAS_KIND))
       call self%timer_stop("scalapack multiply inv(U) * Q")
     endif
     call self%timer_stop("transform_back_generalized()")

    end subroutine



















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

! using elpa internal Hermitian multiply is faster then scalapack multiply, but we need an extra
! temporary matrix.
! using cannon algorithm should be the fastest. After this is verified, the other options should be removed
! however, we need the extra temporary matrix as well.

   subroutine elpa_transform_generalized_&
            &fc&
            &(self, a, b, is_already_decomposed, error)
     use precision
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
     class(elpa_impl_t)  :: self
     complex(kind=rck) :: a(self%local_nrows, *), b(self%local_nrows, *)
     integer                :: error
     logical                :: is_already_decomposed
     integer                :: sc_desc(SC_DESC_LEN)
     integer(kind=ik)       :: my_p, my_prow, my_pcol, np_rows, np_cols, mpi_comm_rows, mpi_comm_cols, mpi_comm_all
     integer(kind=MPI_KIND) :: my_pMPI, my_prowMPI, my_pcolMPI, np_rowsMPI, np_colsMPI
     integer(kind=ik)       :: BuffLevelInt, use_cannon
     integer(kind=MPI_KIND) :: mpierr

     complex(kind=rck) :: tmp(self%local_nrows, self%local_ncols)

     call self%get("mpi_comm_rows",mpi_comm_rows,error)
     call self%get("mpi_comm_cols",mpi_comm_cols,error)
     call self%get("mpi_comm_parent", mpi_comm_all,error)

     call mpi_comm_rank(int(mpi_comm_all,kind=MPI_KIND), my_pMPI, mpierr)
     call mpi_comm_rank(int(mpi_comm_rows,kind=MPI_KIND),my_prowMPI, mpierr)
     call mpi_comm_size(int(mpi_comm_rows,kind=MPI_KIND),np_rowsMPI, mpierr)
     call mpi_comm_rank(int(mpi_comm_cols,kind=MPI_KIND),my_pcolMPI, mpierr)
     call mpi_comm_size(int(mpi_comm_cols,kind=MPI_KIND),np_colsMPI, mpierr)

     my_p = int(my_pMPI, kind=c_int)
     my_prow = int(my_prowMPI, kind=c_int)
     np_rows = int(np_rowsMPI, kind=c_int)
     my_pcol = int(my_pcolMPI, kind=c_int)
     np_cols = int(np_colsMPI, kind=c_int)

     call self%timer_start("transform_generalized()")
     call self%get("cannon_for_generalized",use_cannon,error)


     if (mod(np_cols, np_rows) /= 0) then
       if(my_p == 0) then
         write(*,*) "To use Cannons algorithm, np_cols must be a multiple of np_rows."
         write(*,*) "Switching to elpa Hermitian and scalapack"
       end if
       use_cannon = 0
     endif

     error = self%construct_scalapack_descriptor(sc_desc, .false.)
     if(error .NE. ELPA_OK) return

     if (.not. is_already_decomposed) then
       ! B = U^T*U, B<-U
       call self%elpa_cholesky_&
           &fc&
           &(b, error)
       if(error .NE. ELPA_OK) return
       ! B <- inv(U)
       call self%elpa_invert_trm_&
           &fc&
           &(b, error)
       if(error .NE. ELPA_OK) return
     end if

     if(use_cannon == 1) then
       call self%get("cannon_buffer_size",BuffLevelInt,error)
       call self%timer_start("cannons_reduction")
       ! BEWARE! even though tmp is output from the routine, it has to be zero on input!
       tmp = 0.0_rck
       call cannons_reduction_&
         &fc&
         &(a, b, self%local_nrows, self%local_ncols, &
           int(sc_desc,kind=BLAS_KIND), tmp, int(BuffLevelInt,kind=MPI_KIND),                    &
           int(mpi_comm_rows,kind=MPI_KIND), int(mpi_comm_cols,kind=MPI_KIND))
       call self%timer_stop("cannons_reduction")

       a(1:self%local_nrows, 1:self%local_ncols) = tmp(1:self%local_nrows, 1:self%local_ncols)

     else  ! do not use cannon algorithm, use elpa hermitian multiply and scalapack instead
       ! tmp <- inv(U^T) * A (we have to use temporary variable)
       call self%elpa_hermitian_multiply_&
           &fc&
           &('U','F', self%na, b, a, self%local_nrows, self%local_ncols, tmp, &
                                 self%local_nrows, self%local_ncols, error)
       if(error .NE. ELPA_OK) return

       ! A <- inv(U)^T * A
       a(1:self%local_nrows, 1:self%local_ncols) = tmp(1:self%local_nrows, 1:self%local_ncols)

       ! A <- inv(U)^T * A * inv(U)
       ! For this multiplication we do not have internal function in ELPA,
       ! so we have to call scalapack
       call self%timer_start("scalapack multiply A * inv(U)")
       call p&
           &C&
           &trmm("R", "U", "N", "N", int(self%na,kind=BLAS_KIND), int(self%na,kind=BLAS_KIND), &
                 ONE, b, 1_BLAS_KIND, 1_BLAS_KIND, int(sc_desc,kind=BLAS_KIND), &
                 a, 1_BLAS_KIND, 1_BLAS_KIND, int(sc_desc,kind=BLAS_KIND))
       call self%timer_stop("scalapack multiply A * inv(U)")
     endif ! use_cannon

     !write(*, *) my_prow, my_pcol, "A(2,3)", a(2,3)

     call self%timer_stop("transform_generalized()")
    end subroutine


    subroutine elpa_transform_back_generalized_&
            &fc&
            &(self, b, q, error)
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
        class(elpa_impl_t)  :: self
      complex(kind=rck) :: b(self%local_nrows, *), q(self%local_nrows, *)
     integer(kind=ik)       :: my_p, my_prow, my_pcol, np_rows, np_cols, mpi_comm_rows, mpi_comm_cols, mpi_comm_all
     integer(kind=MPI_KIND) :: mpierr, my_pMPI, my_prowMPI, my_pcolMPI, np_rowsMPI, np_colsMPI
     integer                :: error
     integer                :: sc_desc(SC_DESC_LEN)
     integer                :: sc_desc_ev(SC_DESC_LEN)
     integer(kind=ik)       :: use_cannon

     complex(kind=rck) :: tmp(self%local_nrows, self%local_ncols)

     call self%get("mpi_comm_rows",mpi_comm_rows,error)
     call self%get("mpi_comm_cols",mpi_comm_cols,error)
     call self%get("mpi_comm_parent", mpi_comm_all,error)

     call mpi_comm_rank(int(mpi_comm_all,kind=MPI_KIND), my_pMPI,mpierr)
     call mpi_comm_rank(int(mpi_comm_rows,kind=MPI_KIND),my_prowMPI,mpierr)
     call mpi_comm_size(int(mpi_comm_rows,kind=MPI_KIND),np_rowsMPI,mpierr)
     call mpi_comm_rank(int(mpi_comm_cols,kind=MPI_KIND),my_pcolMPI,mpierr)
     call mpi_comm_size(int(mpi_comm_cols,kind=MPI_KIND),np_colsMPI,mpierr)

     my_p = int(my_pMPI,kind=c_int)
     my_prow = int(my_prowMPI,kind=c_int)
     np_rows = int(np_rowsMPI,kind=c_int)
     my_pcol = int(my_pcolMPI,kind=c_int)
     np_cols = int(np_colsMPI,kind=c_int)

     call self%timer_start("transform_back_generalized()")
     call self%get("cannon_for_generalized",use_cannon,error)


     if (mod(np_cols, np_rows) /= 0) then
       use_cannon = 0
     endif

     error = self%construct_scalapack_descriptor(sc_desc, .false.)
     error = self%construct_scalapack_descriptor(sc_desc_ev, .true.)
     if(error .NE. ELPA_OK) return

     if(use_cannon == 1) then
       call self%timer_start("cannons_triang_rectangular")
       call cannons_triang_rectangular_&
         &fc&
         &(b, q, self%local_nrows, self%local_ncols, &
           int(sc_desc,kind=BLAS_KIND), int(sc_desc_ev,kind=BLAS_KIND), tmp,  &
           int(mpi_comm_rows,kind=MPI_KIND), int(mpi_comm_cols,kind=MPI_KIND) );
       call self%timer_stop("cannons_triang_rectangular")

       q(1:self%local_nrows, 1:self%local_ncols) = tmp(1:self%local_nrows, 1:self%local_ncols)
     else
       call self%timer_start("scalapack multiply inv(U) * Q")
       ! Q <- inv(U) * Q
       call p&
           &C&
           &trmm("L", "U", "N", "N", int(self%na,kind=BLAS_KIND), int(self%nev,kind=BLAS_KIND), &
                 ONE, b, 1_BLAS_KIND, 1_BLAS_KIND, int(sc_desc,kind=BLAS_KIND),  &
                 q, 1_BLAS_KIND, 1_BLAS_KIND, int(sc_desc,kind=BLAS_KIND))
       call self%timer_stop("scalapack multiply inv(U) * Q")
     endif
     call self%timer_stop("transform_back_generalized()")

    end subroutine



!    function use_cannons_algorithm(self) result(use_cannon, do_print)
!      class(elpa_impl_t), intent(inout), target :: self
!      logical                                   :: use_cannon
!      logical, intent(in)                       :: do_print
!    end function
!




    !> \brief procedure to set the api version used for ELPA autotuning
    !> Parameters
    !> \param   self            the allocated ELPA object
    !> \param   api_version     integer: the api_version
    !> \param   error           integer: error code
    subroutine elpa_autotune_set_api_version(self, api_version, error)
      class(elpa_impl_t), intent(inout), target :: self
      integer, intent(in)                       :: api_version
      integer(kind=c_int), optional             :: error

      autotune_api_set = .true.

      if (api_version .ge. 20211125) then
        new_autotune = .true.
      else
        new_autotune = .false.
      endif

      if (present(error)) then
        error = ELPA_OK
      endif

    end subroutine

    !> \brief function to setup the ELPA autotuning and create the autotune object
    !> Parameters
    !> \param   self            the allocated ELPA object
    !> \param   level           integer: the "thoroughness" of the planed autotuning
    !> \param   domain          integer: the domain (real/complex) which should be tuned
    !> \result  tune_state      the created autotuning object
    function elpa_autotune_setup(self, level, domain, error) result(tune_state)
      class(elpa_impl_t), intent(inout), target :: self
      integer, intent(in)                       :: level, domain
      type(elpa_autotune_impl_t), pointer       :: ts_impl
      class(elpa_autotune_t), pointer           :: tune_state
      integer(kind=c_int), optional             :: error
      integer(kind=c_int)                       :: sublevel, solver
      integer(kind=c_int)                       :: gpu_old, gpu_new

      if (present(error)) then
        error = ELPA_OK
      endif

      if (elpa_get_api_version() < 20171201) then
        write(error_unit, "(a,i0,a)") "ELPA: Error API version: Autotuning does not support ", elpa_get_api_version()
        if (present(error)) then
          error = ELPA_ERROR_AUTOTUNE_API_VERSION
        endif
        return
      endif

      allocate(ts_impl)
      if (new_autotune) then
        ts_impl%new_stepping = 1
      else
        ts_impl%new_stepping = 0
      endif

      ts_impl%parent => self
      ts_impl%level = level
      ts_impl%domain = domain

      ts_impl%current = -1
      ts_impl%min_loc = -1

      if (ts_impl%new_stepping == 1) then
        if (self%is_set("solver") == 1) then
          call self%get("solver", solver, error)
          if (solver == ELPA_SOLVER_2STAGE) then
                  ! why ?
            ts_impl%sublevel_part1stage(level) = ELPA_AUTOTUNE_PART_ELPA1
            ts_impl%sublevel_part2stage(level) = ELPA_AUTOTUNE_PART_ELPA2
          else if (solver == ELPA_SOLVER_1STAGE) then
            ts_impl%sublevel_part1stage(level) = ELPA_AUTOTUNE_PART_ELPA1
            ts_impl%sublevel_part2stage(level) = ELPA_AUTOTUNE_PART_ELPA2
          else
            print *,"ELPA_AUTOTUNE_SETUP: Unknown solver"
            stop
          endif        
        else ! no solver set, anyways ...
          ts_impl%sublevel_part1stage(level) = ELPA_AUTOTUNE_PART_ELPA1
          ts_impl%sublevel_part2stage(level) = ELPA_AUTOTUNE_PART_ELPA2
        endif

        !ts_impl%cardinality = elpa_index_autotune_cardinality_new_stepping_c(self%index, level, domain, &
        !                                                                     ts_impl%sublevel_part(level))

        !ts_impl%cardinality = elpa_index_autotune_cardinality_new_stepping_c(self%index, level, domain, &
        !                                                                     ts_impl%sublevel_part(level))
      else ! new_stepping
        ts_impl%cardinality = elpa_index_autotune_cardinality_c(self%index, level, domain)
      endif ! new_stepping

      if (ts_impl%new_stepping == 1) then
        autotune_level  = level
        autotune_domain = domain
        ts_impl%sublevel_current1stage(:) = -1
        ts_impl%total_current_1stage = -1
        ts_impl%sublevel_current2stage(:) = -1
        ts_impl%total_current_2stage = -1
        ts_impl%sublevel_cardinality1stage(:) = 0
        ts_impl%sublevel_cardinality2stage(:) = 0
        ts_impl%sublevel_min_val1stage(:) = 0.0_C_DOUBLE
        ts_impl%sublevel_min_val2stage(:) = 0.0_C_DOUBLE
        ts_impl%sublevel_min_loc1stage(:) = -1
        ts_impl%sublevel_min_loc2stage(:) = -1

        ! get cardinality of all sublevels
        do sublevel=1, autotune_level
          if (self%is_set("solver") == 1) then
            call self%get("solver", solver, error)
            if (solver == ELPA_SOLVER_2STAGE) then
              ts_impl%sublevel_part1stage(sublevel) = ELPA_AUTOTUNE_PART_ELPA1
              ts_impl%sublevel_part2stage(sublevel) = ELPA_AUTOTUNE_PART_ELPA2
            else if (solver == ELPA_SOLVER_1STAGE) then
              ts_impl%sublevel_part1stage(sublevel) = ELPA_AUTOTUNE_PART_ELPA1
              ts_impl%sublevel_part2stage(sublevel) = ELPA_AUTOTUNE_PART_ELPA2
            else
              print *,"ELPA_AUTOTUNE_SETUP: Unknown solver"
              stop
            endif        
          else 
            ts_impl%sublevel_part1stage(sublevel) = ELPA_AUTOTUNE_PART_ELPA1
            ts_impl%sublevel_part2stage(sublevel) = ELPA_AUTOTUNE_PART_ELPA2
          endif

          if (sublevel .eq. 1) then
            ts_impl%sublevel_cardinality1stage(sublevel) = elpa_index_autotune_cardinality_new_stepping_c&
                                                           (self%index, sublevel, ts_impl%domain, &
                                                           ts_impl%sublevel_part1stage(level))

            ts_impl%sublevel_cardinality2stage(sublevel) = elpa_index_autotune_cardinality_new_stepping_c&
                                                           (self%index, sublevel, ts_impl%domain, &
                                                           ts_impl%sublevel_part2stage(level))
          else
            ts_impl%sublevel_cardinality1stage(sublevel) = elpa_index_autotune_cardinality_new_stepping_c&
                                                           (self%index, sublevel, ts_impl%domain, &
                                                           ts_impl%sublevel_part1stage(level)) &
                                                           - sum(ts_impl%sublevel_cardinality1stage(1:sublevel-1))

            ts_impl%sublevel_cardinality2stage(sublevel) = elpa_index_autotune_cardinality_new_stepping_c&
                                                           (self%index, sublevel, ts_impl%domain, &
                                                           ts_impl%sublevel_part2stage(level)) &
                                                           - sum(ts_impl%sublevel_cardinality2stage(1:sublevel-1))
          endif
    
          if (ts_impl%sublevel_cardinality1stage(sublevel) .eq. 0) then
            autotune_substeps_done1stage(sublevel) = .true.
          endif
          if (ts_impl%sublevel_cardinality2stage(sublevel) .eq. 0) then
            autotune_substeps_done2stage(sublevel) = .true.
          endif

        enddo
      endif ! new-stepping

      tune_state => ts_impl

      ! check consistency between "gpu" and "nvidia-gpu"
      if (self%is_set("gpu") == 1) then
        call self%get("gpu", gpu_old, error)
        if (error .ne. ELPA_OK) then
          print *,"ELPA_AUTOTUNE_SETUP: cannot get gpu option. Aborting..."
          stop
        endif
        if (self%is_set("nvidia-gpu") == 1) then
         call self%get("nvidia-gpu", gpu_new, error)
         if (error .ne. ELPA_OK) then
           print *,"ELPA_AUTOTUNE_SETUP: cannot get nvidia-gpu option. Aborting..."
           stop
         endif
         if (gpu_old .ne. gpu_new) then
           print *,"ELPA_AUTOTUNE_SETUP: you cannot set gpu =",gpu_old," and nvidia-gpu =",gpu_new," Aborting..."
           stop
         endif
        else ! nvidia-gpu not set
          call self%set("nvidia-gpu", gpu_old, error)
          if (error .ne. ELPA_OK) then
            print *,"ELPA_AUTOTUNE_SETUP: cannot set nvidia-gpu option. Aborting..."
            stop
          endif
        endif ! nvidia-gpu
      else ! gpu not set
        ! nothing to do
        !if (self%is_set("nvidia-gpu") == 1) then
         !call self%get("nvidia-gpu", gpu_new, error)
         !if (error .ne. ELPA_OK) then
         !  print *,"ELPA_AUTOTUNE_SETUP: cannot get nvidia-gpu option. Aborting..."
         !  stop
         !endif
         !call self%set("gpu", gpu_new, error)
         !if (error .ne. ELPA_OK) then
         !  print *,"ELPA_AUTOTUNE_SETUP: cannot set gpu option. Aborting..."
         !  stop
         !endif
        !else !nvidia not set
        !endif
      endif ! gpu set

      call self%autotune_timer%enable()
    end function

    !c> 
    !c> void elpa_autotune_set_api_version(elpa_t handle, int api_version, int *error);
    subroutine elpa_autotune_set_api_version_c(handle, api_version, error) bind(C, name="elpa_autotune_set_api_version")
      type(c_ptr), intent(in), value         :: handle
      type(elpa_impl_t), pointer             :: self
      integer(kind=c_int), intent(in), value :: api_version
      integer(kind=c_int) , intent(in)       :: error

      call c_f_pointer(handle, self)

      call self%autotune_set_api_version(api_version, error)

    end subroutine


    !c> 
    !c> elpa_autotune_t elpa_autotune_setup(elpa_t handle, int level, int domain, int *error);
    function elpa_autotune_setup_c(handle ,level, domain, error) result(ptr) bind(C, name="elpa_autotune_setup")
      type(c_ptr), intent(in), value         :: handle
      type(elpa_impl_t), pointer             :: self
      class(elpa_autotune_t), pointer        :: tune_state
      type(elpa_autotune_impl_t), pointer    :: obj
      integer(kind=c_int), intent(in), value :: level
      integer(kind=c_int), intent(in), value :: domain
      type(c_ptr)                            :: ptr
      integer(kind=c_int) , intent(in)       :: error

      call c_f_pointer(handle, self)

      tune_state => self%autotune_setup(level, domain, error)
      select type(tune_state)
        type is (elpa_autotune_impl_t)
          obj => tune_state
        class default
          print *, "ELPA_AUTOTUNE_SETUP_C ERROR: This should not happen"
          stop
      end select
      ptr = c_loc(obj)

    end function

    !> \brief function to do the work an autotunig step
    !> Parameters
    !> \param   self            class(elpa_impl_t) the allocated ELPA object
    !> \param   tune_state      class(elpa_autotune_t): the autotuning object
    !> \result  unfinished      logical: describes the state of the autotuning (completed/uncompleted)
    function elpa_autotune_step(self, tune_state, error) result(unfinished)
      implicit none
      class(elpa_impl_t), intent(inout)             :: self
      class(elpa_autotune_t), intent(inout), target :: tune_state
      type(elpa_autotune_impl_t), pointer           :: ts_impl
      integer(kind=c_int), optional, intent(out)    :: error
      logical                                       :: unfinished
      logical                                       :: unfinished_1stage, unfinished_2stage, compare_solvers
      logical, save                                 :: firstCall = .true.
      integer(kind=c_int)                           :: solver, debug

      if (present(error)) then
        error = ELPA_OK
      endif
      select type(tune_state)
        type is (elpa_autotune_impl_t)
          ts_impl => tune_state
        class default
          print *, "ELPA_AUTOTUNE_STEP ERROR: This should not happen"
          if (present(error)) then
            error = ELPA_ERROR
          endif
      end select

      unfinished        = .false.
      call self%get("debug", debug, error)
      if (error .ne. ELPA_OK) then
        print *,"ELPA_AUTOTUNE_STEP: cannot get debug option. Aborting..."
        stop
      endif

      if (ts_impl%new_stepping == 1) then
        ! check whether the user fixed the solver. 
        ! if not this routine will add a loop over the solvers, such
        ! that first with fixed SOLVER_1STAGE the tuning is done,
        ! then with SOLVER_2STAGE, and last the best of both tuning results is
        ! chosen
        ! we can only check this at the first call since afterwards we
        ! set the solver :-)
        if (firstCall) then
          if (self%is_set("solver") == 1) then
            call self%get("solver", solver, error)
            if (error .ne. ELPA_OK) then
              print *,"ELPA_AUTOTUNE_STEP: cannot get solver. Aborting..."
              stop
            endif
            if (solver == ELPA_SOLVER_2STAGE) then
              do_autotune_2stage = .true.
              do_autotune_1stage = .false.
              compare_solvers    = .false.
            else if (solver == ELPA_SOLVER_1STAGE) then
              do_autotune_2stage = .false.
              do_autotune_1stage = .true.
              compare_solvers    = .false.
            else
              print *,"ELPA_AUTOTUNE_STEP: Unknown solver"
              stop
            endif        
          else 
            do_autotune_2stage = .true.
            do_autotune_1stage = .true.
            compare_solvers    = .true.
          endif
          firstCall = .false.
        endif

        if (do_autotune_1stage) then
          consider_solver = ELPA_SOLVER_1STAGE
          call self%set("solver", ELPA_SOLVER_1STAGE, error)
          if (error .ne. ELPA_OK) then
            !if (debug == 1) print *,"ELPA_AUTOTUNE_STEP: cannot set ELPA_SOLVER_1STAGE for tuning"
            stop
          endif
          unfinished_1stage = self%autotune_step_worker(tune_state, ELPA_SOLVER_1STAGE, error)
          if (unfinished_1stage) then
            !if (debug == 1) print *,"Tuning for ELPA_SOLVER_1STAGE NOT DONE"
            unfinished = unfinished_1stage
            return
          else
            !print *,"Tuning for ELPA_SOLVER_1STAGE DONE",do_autotune_2stage
            do_autotune_1stage = .false.
            last_call_1stage = .true.
            if (do_autotune_2stage) then
              if (self%myGlobalId .eq. 0) write(error_unit, "(a)") "Tuning of ELPA 1stage done: Doing one last call for 1stage"
              unfinished = .true.
              return
            else
              unfinished = unfinished_1stage
              ts_impl%best_solver = ELPA_SOLVER_1STAGE
              return
            endif
          endif
        endif

        if (do_autotune_2stage) then
          consider_solver = ELPA_SOLVER_2STAGE
          call self%set("solver", ELPA_SOLVER_2STAGE, error)
          if (error .ne. ELPA_OK) then
            print *,"ELPA_AUTOTUNE_STEP: cannot set ELPA_SOLVER_2STAGE for tuning"
            stop
          endif
          unfinished_2stage = self%autotune_step_worker(tune_state, ELPA_SOLVER_2STAGE, error)
          if (unfinished_2stage) then
            !if (debug == 1) print *,"Tuning for ELPA_SOLVER_2STAGE NOT DONE"
            unfinished = unfinished_2stage
            return
          else
            if (self%myGlobalId .eq. 0) write(error_unit, "(a)") "Tuning of ELPA 2stage done"
            !if (debug == 1) print *,"Tuning for ELPA_SOLVER_2STAGE DONE"
            do_autotune_2stage = .false.
            last_call_2stage = .true.
            if (do_autotune_1stage) then
              ! this case should never be possible
              print *,"PANIC in elpa_autotune_step"
              stop
              unfinished = .true.
              return
            else
              if (.not.(unfinished_2stage) .and. (compare_solvers)) then
                ! we are done compare which solver was the best
                if (ts_impl%best_val1stage .lt. ts_impl%best_val2stage) then
                  ts_impl%best_solver = ELPA_SOLVER_1STAGE
                else
                  ts_impl%best_solver = ELPA_SOLVER_2STAGE
                endif
              endif
              unfinished = unfinished_2stage
              return
            endif
          endif
        endif
      else ! new_stepping
          unfinished = self%autotune_step_worker(tune_state, ELPA_SOLVER_2STAGE, error)
      endif ! new_stepping
    end function    

    !> \brief function to do the work of an autotunig step
    !> Parameters
    !> \param   self            class(elpa_impl_t) the allocated ELPA object
    !> \param   tune_state      class(elpa_autotune_t): the autotuning object
    !> \result  unfinished      logical: describes the state of the autotuning (completed/uncompleted)
    function elpa_autotune_step_worker(self, tune_state, solver, error) result(unfinished)
      implicit none
      class(elpa_impl_t), intent(inout)             :: self
      class(elpa_autotune_t), intent(inout), target :: tune_state
      type(elpa_autotune_impl_t), pointer           :: ts_impl
      integer(kind=c_int), optional, intent(out)    :: error
      integer(kind=c_int), intent(in)               :: solver
      integer(kind=c_int)                           :: error2, error3
      integer                                       :: mpi_comm_parent, mpi_string_length, np_total
      integer(kind=MPI_KIND)                        :: mpierr, mpierr2, mpi_string_lengthMPI
      logical                                       :: unfinished
      integer                                       :: i
      real(kind=C_DOUBLE)                           :: time_spent(2), sendbuf(2), recvbuf(2)
      character(len=MPI_MAX_ERROR_STRING)           :: mpierr_string
       integer(kind=MPI_KIND)                       :: allreduce_request1
       logical                                      :: useNonBlockingCollectivesAll
       integer(kind=c_int)                          :: sublevel, current, level

       logical                                      :: use1stage, use2stage

       useNonBlockingCollectivesAll = .true.
      if (present(error)) then
        error = ELPA_OK
      endif
      select type(tune_state)
        type is (elpa_autotune_impl_t)
          ts_impl => tune_state
        class default
          print *, "ELPA_AUTOTUNE_STEP_WORKER ERROR: This should not happen"
          if (present(error)) then
            error = ELPA_ERROR
          endif
      end select

      unfinished = .false.

      if (ts_impl%new_stepping == 1) then
        if (solver .eq. ELPA_SOLVER_1STAGE) then
          use1stage = .true.
          use2stage = .false.
        endif
        if (solver .eq. ELPA_SOLVER_2STAGE) then
          use1stage = .false.
          use2stage = .true.
        endif
      endif
  
      if (ts_impl%new_stepping == 1) then
        if (use1stage) then
          ! check on which sublevel we should currently work on
          do sublevel = 1, autotune_level
            if (.not.(autotune_substeps_done1stage(sublevel))) then
              exit
            endif
          enddo
          if (sublevel .le. autotune_level) then
            ! do nothing
          else if (sublevel .eq. autotune_level +1) then
            sublevel = autotune_level
          else
            print *,"Problem setting level in elpa_autotune_step"
            stop 
          endif
        endif
        if (use2stage) then
          ! check on which sublevel we should currently work on
          do sublevel = 1, autotune_level
            if (.not.(autotune_substeps_done2stage(sublevel))) then
              exit
            endif
          enddo
          if (sublevel .le. autotune_level) then
            ! do nothing
          else if (sublevel .eq. autotune_level +1) then
            sublevel = autotune_level
          else
            print *,"Problem setting level in elpa_autotune_step"
            stop 
          endif
        endif
      endif ! new_stepping

      if (ts_impl%new_stepping == 1) then
        if (use1stage) then
          current = ts_impl%sublevel_current1stage(sublevel)
          !ts_impl%total_current_1stage = current
        endif
        if (use2stage) then
          current = ts_impl%sublevel_current2stage(sublevel)
          !ts_impl%total_current_2stage = current
        endif
      else
        current = ts_impl%current
      endif

      ! check here whether this is the last round call if yes update
      ! if yes update and reset current...      ! if yes update and reset current...

      if (current >= 0) then
        if (ts_impl%new_stepping == 1) then
          time_spent(2) = self%autotune_timer%get("accumulator")
          select case (sublevel)
            case (ELPA_AUTOTUNE_TRANSPOSE_VECTORS)
              if (solver == ELPA_SOLVER_2STAGE) then
                time_spent(1) = self%autotune_timer%get("accumulator","full_to_band")
              else if (solver == ELPA_SOLVER_1STAGE) then
                time_spent(1) = self%autotune_timer%get("accumulator","full_to_tridi")
              else
                print *,"elpa_autotune_step: unknown solver"
                stop
              endif
            case (ELPA2_AUTOTUNE_FULL_TO_BAND)
              time_spent(1) = self%autotune_timer%get("accumulator","full_to_band")
            case (ELPA2_AUTOTUNE_BAND_TO_TRIDI)
              time_spent(1) = self%autotune_timer%get("accumulator","band_to_tridi")
            case (ELPA_AUTOTUNE_SOLVE)
              time_spent(1) = self%autotune_timer%get("accumulator","solve")
            case (ELPA2_AUTOTUNE_TRIDI_TO_BAND)
              time_spent(1) = self%autotune_timer%get("accumulator","tridi_to_band")
            case (ELPA2_AUTOTUNE_BAND_TO_FULL)
              time_spent(1) = self%autotune_timer%get("accumulator","band_to_full")
            case (ELPA1_AUTOTUNE_FULL_TO_TRIDI)
              time_spent(1) = self%autotune_timer%get("accumulator","full_to_tridi")
            case (ELPA1_AUTOTUNE_TRIDI_TO_FULL)
              time_spent(1) = self%autotune_timer%get("accumulator","tridi_to_full")
            case (ELPA2_AUTOTUNE_KERNEL)
              time_spent(1) = self%autotune_timer%get("accumulator","tridi_to_band")
            case (ELPA_AUTOTUNE_OPENMP)
              time_spent(1) = self%autotune_timer%get("accumulator")
            case (ELPA2_AUTOTUNE_BAND_TO_FULL_BLOCKING)
              time_spent(1) = self%autotune_timer%get("accumulator","band_to_full")
            case (ELPA1_AUTOTUNE_MAX_STORED_ROWS)
              time_spent(1) = self%autotune_timer%get("accumulator","tridi_to_full")
            case (ELPA2_AUTOTUNE_TRIDI_TO_BAND_STRIPEWIDTH)
              time_spent(1) = self%autotune_timer%get("accumulator","tridi_to_band")
            case default
              time_spent(1) = self%autotune_timer%get("accumulator")
          end select
        else
          time_spent(1) = self%autotune_timer%get("accumulator")
        endif

        ! find the average time spent .. we need a unique value on all ranks
        call self%get("mpi_comm_parent", mpi_comm_parent, error2)
        call self%get("num_processes", np_total, error3)
        if ((error2 .ne. ELPA_OK) .or. (error3 .ne. ELPA_OK)) then
          print *, "Parent communicator is not set properly. Aborting..."
          if (present(error)) then
            error = ELPA_ERROR_CRITICAL
          endif
          return
        endif

        sendbuf(1:2) = time_spent(1:2)
        if (useNonBlockingCollectivesAll) then
          call mpi_iallreduce(sendbuf, recvbuf, 2_MPI_KIND, MPI_REAL8, MPI_SUM, int(mpi_comm_parent,kind=MPI_KIND), &
                            allreduce_request1, mpierr)
          call mpi_wait(allreduce_request1, MPI_STATUS_IGNORE, mpierr)
        else
          call mpi_allreduce(sendbuf, recvbuf, 2_MPI_KIND, MPI_REAL8, MPI_SUM, int(mpi_comm_parent,kind=MPI_KIND), &
                             mpierr)
        endif
        if (mpierr .ne. MPI_SUCCESS) then
          call MPI_ERROR_STRING(mpierr, mpierr_string, mpi_string_lengthMPI, mpierr2)
          mpi_string_length = int(mpi_string_lengthMPI,kind=c_int)
          write(error_unit,*) "MPI ERROR occured during elpa_autotune_step: ", trim(mpierr_string)
          return
        endif
        time_spent(1) = recvbuf(1) / np_total
        time_spent(2) = recvbuf(2) / np_total

        if (ts_impl%new_stepping == 1) then
          if (use1stage) then
            if (ts_impl%best_solver .lt. 0) ts_impl%best_solver = ELPA_SOLVER_1STAGE
            if (ts_impl%sublevel_min_loc1stage(sublevel) == -1 .or. (time_spent(1) < ts_impl%sublevel_min_val1stage(sublevel))) then
              ts_impl%min_val = time_spent(1)
              ts_impl%min_loc = ts_impl%current
              ts_impl%sublevel_min_val1stage(sublevel) = time_spent(1)
              ts_impl%sublevel_min_loc1stage(sublevel) = ts_impl%sublevel_current1stage(sublevel)
              ts_impl%best_val1stage = time_spent(2)
              !print *,"WORKER best 1stage: ",ts_impl%min_val
            end if
          endif
          if (use2stage) then
            if (ts_impl%best_solver .lt. 0) ts_impl%best_solver = ELPA_SOLVER_2STAGE
            if (ts_impl%sublevel_min_loc2stage(sublevel) == -1 .or. (time_spent(1) < ts_impl%sublevel_min_val2stage(sublevel))) then
              ts_impl%min_val = time_spent(1)
              ts_impl%min_loc = ts_impl%current
              ts_impl%sublevel_min_val2stage(sublevel) = time_spent(1)
              ts_impl%sublevel_min_loc2stage(sublevel) = ts_impl%sublevel_current2stage(sublevel)
              ts_impl%best_val2stage = time_spent(2)
              !print *,"WORKER best 2stage: ",ts_impl%min_val
            end if
          endif
        else ! new stepping
          if (ts_impl%min_loc == -1 .or. (time_spent(1) < ts_impl%min_val)) then
            ts_impl%min_val = time_spent(1)
            ts_impl%min_loc = ts_impl%current
          end if
        endif ! new stepping
        call self%autotune_timer%free()
      endif ! (current >= 0)

      if (ts_impl%new_stepping == 1) then
        if (use1stage) then
          !print *,"step:",sublevel, ts_impl%sublevel_cardinality1stage(sublevel),"for 1stage"
          !check whether we have to switch to new sublevel
          if (ts_impl%sublevel_current1stage(sublevel) .eq. ts_impl%sublevel_cardinality1stage(sublevel)-1 ) then
            !current = -1
            autotune_substeps_done1stage(sublevel) = .true.
            if (sublevel .lt. autotune_level) then
              ! we can go to the next sublevel _with_ cardinality != 0
              do level = sublevel+1, autotune_level
                !print *,"Checking level",level,"for 1stage"
                if (ts_impl%sublevel_cardinality1stage(level) .ne. 0) then
                  exit
                endif
              enddo
              !print *,"choosing level",level,"for 1stage"
              sublevel=level
              !sublevel = sublevel +1
            else if (sublevel .eq. autotune_level) then
              ! we are already at the last level
            else
              print *,"Panic in autotune step"
              stop
            endif
          endif

          if (all(autotune_substeps_done1stage(:))) then
            return
          endif
        endif ! 1stage
        if (use2stage) then
          !print *,"step:",sublevel, ts_impl%sublevel_cardinality2stage(sublevel),"for 2stage"
          !check whether we have to switch to new sublevel
          if (ts_impl%sublevel_current2stage(sublevel) .eq. ts_impl%sublevel_cardinality2stage(sublevel)-1 ) then
            !current = -1
            autotune_substeps_done2stage(sublevel) = .true.
            if (sublevel .lt. autotune_level) then
              ! we can go to the next sublevel _with_ cardinality != 0
              do level = sublevel+1, autotune_level
                !print *,"Checking level",level,"for 2stage"
                if (ts_impl%sublevel_cardinality2stage(level) .ne. 0) then
                  exit
                endif
              enddo
              !print *,"choosing level",level,"for 2stage"
              sublevel=level
              !sublevel = sublevel +1
            else if (sublevel .eq. autotune_level) then
              ! we are already at the last level
            else
              print *,"Panic in autotune step"
              stop
            endif
          endif

          if (all(autotune_substeps_done2stage(:))) then
            return
          endif
        endif ! 1stage
      endif ! new stepping
     
      if (ts_impl%new_stepping == 1) then
        ! check whether solver is set, if yes we can pass t
        if (use1stage) then
          !print *,"Working on sublevel=",sublevel,ts_impl%sublevel_cardinality1stage(sublevel),"for 1stage"
          do while (ts_impl%sublevel_current1stage(sublevel) < ts_impl%sublevel_cardinality1stage(sublevel)-1)
            ts_impl%current = ts_impl%current + 1
            ts_impl%sublevel_current1stage(sublevel) = ts_impl%sublevel_current1stage(sublevel) + 1
            ts_impl%total_current_1stage = ts_impl%total_current_1stage + 1
            !print *,"Updating current1stage", ts_impl%total_current_1stage
            if (elpa_index_set_autotune_parameters_new_stepping_c(self%index, sublevel, ts_impl%domain, &
                ts_impl%sublevel_part1stage(sublevel), &
                ts_impl%sublevel_current1stage(sublevel)) == 1) then
              unfinished = .true.
              return
            end if
          end do

          if (ts_impl%sublevel_current1stage(sublevel) .ne. ts_impl%sublevel_cardinality1stage(sublevel)-1 ) then
             print *,"PANIC in autotune_step 1stage"
             print *,ts_impl%sublevel_current1stage(sublevel),ts_impl%sublevel_cardinality1stage(sublevel) 
             stop
          endif
        endif ! 1stage
        if (use2stage) then
          !print *,"Working on sublevel=",sublevel,ts_impl%sublevel_cardinality2stage(sublevel),"for 2stage"
          do while (ts_impl%sublevel_current2stage(sublevel) < ts_impl%sublevel_cardinality2stage(sublevel)-1)
            ts_impl%current = ts_impl%current + 1
            ts_impl%sublevel_current2stage(sublevel) = ts_impl%sublevel_current2stage(sublevel) + 1
            ts_impl%total_current_2stage = ts_impl%total_current_2stage + 1
            if (elpa_index_set_autotune_parameters_new_stepping_c(self%index, sublevel, ts_impl%domain, &
                ts_impl%sublevel_part2stage(sublevel), &
                ts_impl%sublevel_current2stage(sublevel)) == 1) then
              unfinished = .true.
              return
            end if
          end do

          if (ts_impl%sublevel_current2stage(sublevel) .ne. ts_impl%sublevel_cardinality2stage(sublevel)-1 ) then
             print *,"PANIC in autotune_step 2stage"
             print *,ts_impl%sublevel_current2stage(sublevel),ts_impl%sublevel_cardinality2stage(sublevel) 
             stop
          endif
        endif ! 2stage
      else ! new_stepping
        do while (ts_impl%current < ts_impl%cardinality - 1)
          ts_impl%current = ts_impl%current + 1
          if (elpa_index_set_autotune_parameters_c(self%index, ts_impl%level, ts_impl%domain, ts_impl%current) == 1) then
            unfinished = .true.
            return
          end if
        end do
      endif ! new stepping

    end function



    !c> 
    !c> int elpa_autotune_step(elpa_t handle, elpa_autotune_t autotune_handle, int *error);
    function elpa_autotune_step_c(handle, autotune_handle, &
                    error) result(unfinished) bind(C, name="elpa_autotune_step")
      type(c_ptr), intent(in), value       :: handle
      type(c_ptr), intent(in), value       :: autotune_handle
      type(elpa_impl_t), pointer           :: self
      type(elpa_autotune_impl_t), pointer  :: tune_state
      logical                              :: unfinished_f
      integer(kind=c_int)                  :: unfinished
      integer(kind=c_int)                  :: error

      call c_f_pointer(handle, self)
      call c_f_pointer(autotune_handle, tune_state)

      unfinished_f = self%autotune_step(tune_state, error)
      if (unfinished_f) then
        unfinished = 1
      else
        unfinished = 0
      endif

    end function

    !> \brief function to set the up-to-now best options of the autotuning
    !> Parameters
    !> \param   self            class(elpa_impl_t) the allocated ELPA object
    !> \param   tune_state      class(elpa_autotune_t): the autotuning object
    !> \param   error code      optional, integer
    subroutine elpa_autotune_set_best(self, tune_state, error)
      use elpa_mpi
      implicit none
      class(elpa_impl_t), intent(inout)          :: self
      class(elpa_autotune_t), intent(in), target :: tune_state
      type(elpa_autotune_impl_t), pointer        :: ts_impl
      integer(kind=ik), optional, intent(out)    :: error
      integer(kind=c_int)                        :: sublevel, level, solver
      integer(kind=c_int)                        :: myid, mpi_comm_parent
      integer(kind=MPI_KIND)                     :: myidMPI, mpierr

      if (present(error)) then
        error = ELPA_OK
      endif
      select type(tune_state)
        type is (elpa_autotune_impl_t)
          ts_impl => tune_state
        class default
          write(error_unit, *) "This should not happen! Critical error"
          if (present(error)) then
            error = ELPA_ERROR_CRITICAL
          endif
      end select

      if (ts_impl%new_stepping == 1) then

        call self%get("mpi_comm_parent",mpi_comm_parent, error)
        if (error .ne. ELPA_OK) then
          print *,"ELPA_AUTOTUNE_SET_BEST: cannot get mpi_comm_parent"
          stop
        endif
        call mpi_comm_rank(int(mpi_comm_parent,kind=MPI_KIND) ,myidMPI ,mpierr)
        myid = int(myidMPI, kind=c_int)

        ! check on which sublevel we should currently work on
        if (ts_impl%best_solver == ELPA_SOLVER_1STAGE) then
          do sublevel = 1, autotune_level
            if (.not.(autotune_substeps_done1stage(sublevel))) then
              exit
            endif
          enddo
          if (sublevel .le. autotune_level) then
            ! do nothing
          else if (sublevel .eq. autotune_level +1) then
            sublevel = autotune_level
          else
            print *,"Problem setting level in elpa_autotune_step"
            stop 
          endif
        endif
        if (ts_impl%best_solver == ELPA_SOLVER_2STAGE) then
          do sublevel = 1, autotune_level
            if (.not.(autotune_substeps_done2stage(sublevel))) then
              exit
            endif
          enddo
          if (sublevel .le. autotune_level) then
            ! do nothing
          else if (sublevel .eq. autotune_level +1) then
            sublevel = autotune_level
          else
            print *,"Problem setting level in elpa_autotune_step"
            stop 
          endif
        endif
      endif

      if (ts_impl%new_stepping == 1) then
        ! should be already set!
        !if (self%is_set("solver") == 1) then
        !  call self%get("solver", solver, errddor)
        !  if (solver == ELPA_SOLVER_2STAGE) then
        !    ts_impl%sublevel_part(sublevel) = ELPA_AUTOTUNE_PART_ELPA2
        !  else if (solver == ELPA_SOLVER_1STAGE) then
        !    ts_impl%sublevel_part(sublevel) = ELPA_AUTOTUNE_PART_ELPA1
        !  else
        !    print *,"ELPA_AUTOTUNE_STEP: Unknown solver"
        !    stop
        !  endif        
        !else 
        !  ts_impl%sublevel_part(sublevel) = ELPA_AUTOTUNE_PART_ANY
        !endif
        ! loop over sublevels
        if (ts_impl%best_solver .eq. ELPA_SOLVER_1STAGE) then
          if (myid .eq. 0) print *,"ELPA_SOLVER_1STAGE is the best solver: setting tuned values"
          call self%set("solver", ELPA_SOLVER_1STAGE, error)
          if (error .ne. ELPA_OK) then
            print *,"ELPA_AUTOTUNE_SET_BEST: cannot set ELPA_SOLVER_1STAGE for tuning"
            stop
          endif
          do level=1, sublevel
            if (ts_impl%sublevel_cardinality1stage(level) .eq. 0) then
              cycle
            endif
            !print *,"level=",level,ts_impl%sublevel_cardinality1stage(level)
            if (elpa_index_set_autotune_parameters_new_stepping_c(self%index, level, ts_impl%domain, &
                    ts_impl%sublevel_part1stage(level), &
                    ts_impl%sublevel_min_loc1stage(level)) /= 1) then
              write(error_unit, *) "This should not happen (in elpa_autotune_set_best())"
              if (present(error)) then
                error = ELPA_ERROR_AUTOTUNE_OBJECT_CHANGED
              endif
            endif
          enddo
        endif ! 1stage
        if (ts_impl%best_solver .eq. ELPA_SOLVER_2STAGE) then
          if (myid .eq. 0) print *,"ELPA_SOLVER_2STAGE is the best solver: setting tuned values"
          call self%set("solver", ELPA_SOLVER_2STAGE, error)
          if (error .ne. ELPA_OK) then
            print *,"ELPA_AUTOTUNE_SET_BEST: cannot set ELPA_SOLVER_2STAGE for tuning"
            stop
          endif
          do level=1, sublevel
            if (ts_impl%sublevel_cardinality2stage(level) .eq. 0) then
              cycle
            endif
            if (elpa_index_set_autotune_parameters_new_stepping_c(self%index, level, ts_impl%domain, &
                    ts_impl%sublevel_part2stage(level), &
                    ts_impl%sublevel_min_loc2stage(level)) /= 1) then
              write(error_unit, *) "This should not happen (in elpa_autotune_set_best())"
              if (present(error)) then
                error = ELPA_ERROR_AUTOTUNE_OBJECT_CHANGED
              endif
            endif
          enddo
        endif ! 2stage
      else ! new_steppimg
        if (elpa_index_set_autotune_parameters_c(self%index, ts_impl%level, ts_impl%domain, ts_impl%min_loc) /= 1) then
          write(error_unit, *) "This should not happen (in elpa_autotune_set_best())"
          if (present(error)) then
            error = ELPA_ERROR_AUTOTUNE_OBJECT_CHANGED
          endif
        endif
      endif ! new stepping

    end subroutine


    !> \brief function to print the up-to-now best options of the autotuning
    !> Parameters
    !> \param   self            class(elpa_impl_t) the allocated ELPA object
    !> \param   tune_state      class(elpa_autotune_t): the autotuning object
    !> \param   error           integer, optional

    subroutine elpa_autotune_print_best(self, tune_state, error)
      implicit none
      class(elpa_impl_t), intent(inout)          :: self
      class(elpa_autotune_t), intent(in), target :: tune_state
      type(elpa_autotune_impl_t), pointer        :: ts_impl
      integer(kind=c_int), optional, intent(out) :: error
      integer(kind=c_int)                        :: sublevel, level, solver

      if (present(error)) then
        error = ELPA_OK
      endif
      select type(tune_state)
        type is (elpa_autotune_impl_t)
          ts_impl => tune_state
        class default
          write(error_unit, *) "This should not happen! Critical error"
          if (present(error)) then
            error = ELPA_ERROR_CRITICAL
          endif
      end select

      if (ts_impl%new_stepping == 1) then
        if (consider_solver == ELPA_SOLVER_1STAGE) then
          ! check on which sublevel we should currently work on
          do sublevel = 1, autotune_level
            if (.not.(autotune_substeps_done1stage(sublevel))) then
              exit
            endif
          enddo
          if (sublevel .le. autotune_level) then
            ! do nothing
          else if (sublevel .eq. autotune_level +1) then
            sublevel = autotune_level
          else
            print *,"Problem setting level in elpa_autotune_print_best"
            stop 
          endif
        endif ! 1 stage
        if (consider_solver == ELPA_SOLVER_2STAGE) then
          ! check on which sublevel we should currently work on
          do sublevel = 1, autotune_level
            if (.not.(autotune_substeps_done2stage(sublevel))) then
              exit
            endif
          enddo
          if (sublevel .le. autotune_level) then
            ! do nothing
          else if (sublevel .eq. autotune_level +1) then
            sublevel = autotune_level
          else
            print *,"Problem setting level in elpa_autotune_print_best"
            stop 
          endif
        endif ! 2 stage
      endif ! new stepping

      flush(output_unit)
      if (ts_impl%new_stepping == 1) then

        ! should already be set
        !if (self%is_set("solver") == 1) then
        !  call self%get("solver", solver, error)
        !  if (solver == ELPA_SOLVER_2STAGE) then
        !    ts_impl%sublevel_part(sublevel) = ELPA_AUTOTUNE_PART_ELPA2
        !  else if (solver == ELPA_SOLVER_1STAGE) then
        !    ts_impl%sublevel_part(sublevel) = ELPA_AUTOTUNE_PART_ELPA1
        !  else
        !    print *,"ELPA_AUTOTUNE_STEP: Unknown solver"
        !    stop
        !  endif        
        !else 
        !  ts_impl%sublevel_part(sublevel) = ELPA_AUTOTUNE_PART_ANY
        !endif

        ! loop over sublevels
        if (consider_solver == ELPA_SOLVER_1STAGE) then
          do level=1, sublevel
            if (ts_impl%sublevel_cardinality1stage(level) .eq. 0) then
              cycle
            endif
            if (elpa_index_print_autotune_parameters_new_stepping_c(self%index, level, &
                    ts_impl%domain, ts_impl%sublevel_part1stage(level)) /= 1) then
              write(error_unit, *) "This should not happen (in elpa_autotune_print_best())"
              if (present(error)) then
                error = ELPA_ERROR_AUTOTUNE_OBJECT_CHANGED
              endif
            endif
          enddo
        endif ! 1stage
        if (consider_solver == ELPA_SOLVER_2STAGE) then
          do level=1, sublevel
            if (ts_impl%sublevel_cardinality2stage(level) .eq. 0) then
              cycle
            endif
            if (elpa_index_print_autotune_parameters_new_stepping_c(self%index, level, &
                    ts_impl%domain, ts_impl%sublevel_part2stage(level)) /= 1) then
              write(error_unit, *) "This should not happen (in elpa_autotune_print_best())"
              if (present(error)) then
                error = ELPA_ERROR_AUTOTUNE_OBJECT_CHANGED
              endif
            endif
          enddo
        endif ! 2stage
      else ! new stepping
        if (elpa_index_print_autotune_parameters_c(self%index, ts_impl%level, ts_impl%domain) /= 1) then
          write(error_unit, *) "This should not happen (in elpa_autotune_print_best())"
          if (present(error)) then
            error = ELPA_ERROR_AUTOTUNE_OBJECT_CHANGED
          endif
        endif
      endif ! new stepping
    end subroutine



    !> \brief function to print the state of the autotuning
    !> Parameters
    !> \param   self            class(elpa_impl_t) the allocated ELPA object
    !> \param   tune_state      class(elpa_autotune_t): the autotuning object
    !> \param   error           integer, optional
    subroutine elpa_autotune_print_state(self, tune_state, error)
      implicit none
      class(elpa_impl_t), intent(inout)          :: self
      class(elpa_autotune_t), intent(in), target :: tune_state
      type(elpa_autotune_impl_t), pointer        :: ts_impl
      integer(kind=c_int), optional, intent(out) :: error
      integer(kind=c_int)                        :: level, sublevel, solver

      if (present(error)) then
        error = ELPA_OK
      endif
      select type(tune_state)
        type is (elpa_autotune_impl_t)
          ts_impl => tune_state
        class default
          write(error_unit, *) "This should not happen! Critical erro"
          if (present(error)) then
            error = ELPA_ERROR_CRITICAL
          endif
      end select

      !print *,"print_state: consider_solver",consider_solver
      if (ts_impl%new_stepping == 1) then
        if (consider_solver == ELPA_SOLVER_1STAGE) then
          do sublevel = 1, autotune_level
            if (.not.(autotune_substeps_done1stage(sublevel))) then
              exit
            endif
          enddo
          if (sublevel .le. autotune_level) then
            ! do nothing
          else if (sublevel .eq. autotune_level +1) then
            sublevel = autotune_level
          else
            print *,"Problem setting level in elpa_autotune_print_state"
            stop 
          endif

          ! check
          if (sublevel .gt. 1) then
            !if (sum(ts_impl%sublevel_cardinality1stage(0:sublevel-1)) .gt. ts_impl%current) then
            !if (sum(ts_impl%sublevel_cardinality1stage(0:sublevel-1)) .gt. &
            !        ts_impl%sublevel_current1stage(sublevel)) then
            if (sum(ts_impl%sublevel_cardinality1stage(0:sublevel-1)) .gt. &
                    ts_impl%total_current_1stage+1) then
              print *,"something wrong in print state for 1stage 1", &
                      sublevel, autotune_substeps_done1stage(sublevel), &
                      sum(ts_impl%sublevel_cardinality1stage(0:sublevel-1)), &
                      ts_impl%total_current_1stage
                      !ts_impl%sublevel_current1stage(sublevel)
              stop 
            endif
          else
            !if (ts_impl%sublevel_cardinality1stage(sublevel) .lt. ts_impl%current) then
            !if (ts_impl%sublevel_cardinality1stage(sublevel) .lt. &
            !        ts_impl%sublevel_current1stage(sublevel)) then
            if (ts_impl%sublevel_cardinality1stage(sublevel) .lt. &
                    ts_impl%total_current_1stage) then
              print *,"something wrong in print state 1stage 2"
              stop 
            endif
          endif

          ! should already be done
          !if (self%is_set("solver") == 1) then
          !  call self%get("solver", solver, error)
          !  if (solver == ELPA_SOLVER_2STAGE) then
          !    ts_impl%sublevel_part(sublevel) = ELPA_AUTOTUNE_PART_ELPA2
          !  else if (solver == ELPA_SOLVER_1STAGE) then
          !    ts_impl%sublevel_part(sublevel) = ELPA_AUTOTUNE_PART_ELPA1
          !  else
          !    print *,"ELPA_AUTOTUNE_STEP: Unknown solver"
          !    stop
          !  endif        
          !else 
          !  ts_impl%sublevel_part(sublevel) = ELPA_AUTOTUNE_PART_ANY
          !endif
        endif ! 1 stage
        if (consider_solver == ELPA_SOLVER_2STAGE) then
          do sublevel = 1, autotune_level
            if (.not.(autotune_substeps_done2stage(sublevel))) then
              exit
            endif
          enddo
          if (sublevel .le. autotune_level) then
            ! do nothing
          else if (sublevel .eq. autotune_level +1) then
            sublevel = autotune_level
          else
            print *,"Problem setting level in elpa_autotune_print_state"
            stop 
          endif

          ! check
          if (sublevel .gt. 1) then
            !if (sum(ts_impl%sublevel_cardinality2stage(0:sublevel-1)) .gt. ts_impl%current) then
            !if (sum(ts_impl%sublevel_cardinality2stage(0:sublevel-1)) .gt. &
            !        ts_impl%sublevel_current2stage(sublevel)) then
            if (sum(ts_impl%sublevel_cardinality2stage(0:sublevel-1)) .gt. &
                    ts_impl%total_current_2stage) then
              print *,"something wrong in print state 2stage 1", &
                      sum(ts_impl%sublevel_cardinality2stage(0:sublevel-1)), &
                      ts_impl%current
              stop 
            endif
          else
            !if (ts_impl%sublevel_cardinality2stage(sublevel) .lt. ts_impl%current) then
            !if (ts_impl%sublevel_cardinality2stage(sublevel) .lt. &
            !        ts_impl%sublevel_current2stage(sublevel)) then
            if (ts_impl%sublevel_cardinality2stage(sublevel) .lt. &
                    ts_impl%total_current_2stage) then
              print *,"something wrong in print state 2stage 2", &
                      ts_impl%sublevel_cardinality2stage(sublevel),&
                       ts_impl%current
              stop 
            endif
          endif

          ! should already be done
          !if (self%is_set("solver") == 1) then
          !  call self%get("solver", solver, error)
          !  if (solver == ELPA_SOLVER_2STAGE) then
          !    ts_impl%sublevel_part(sublevel) = ELPA_AUTOTUNE_PART_ELPA2
          !  else if (solver == ELPA_SOLVER_1STAGE) then
          !    ts_impl%sublevel_part(sublevel) = ELPA_AUTOTUNE_PART_ELPA1
          !  else
          !    print *,"ELPA_AUTOTUNE_STEP: Unknown solver"
          !    stop
          !  endif        
          !else 
          !  ts_impl%sublevel_part(sublevel) = ELPA_AUTOTUNE_PART_ANY
          !endif
        endif ! 2 stage
      endif

      if (ts_impl%new_stepping == 1) then
        if (consider_solver == ELPA_SOLVER_1STAGE) then
          ! loop over sublevels
          do level=1, sublevel
            if (ts_impl%sublevel_cardinality1stage(level) .eq. 0) then
              cycle
            endif
            if (elpa_index_print_autotune_state_new_stepping_c(self%index, level, ts_impl%domain, &
                    ts_impl%sublevel_part1stage(level), &
                    ts_impl%sublevel_min_loc1stage(level), &
                      ts_impl%sublevel_min_val1stage(level), ts_impl%sublevel_current1stage(level), &
                      ts_impl%sublevel_cardinality1stage(level), &
                      ELPA_SOLVER_1STAGE, &
                      c_null_char) /= 1) then
              write(error_unit, *) "This should not happen (in elpa_autotune_print_state())"
              if (present(error)) then
                error = ELPA_ERROR_AUTOTUNE_OBJECT_CHANGED
              endif
            endif
          enddo
        endif ! 1 stage
        if (consider_solver == ELPA_SOLVER_2STAGE) then
          ! loop over sublevels
          do level=1, sublevel
            if (ts_impl%sublevel_cardinality2stage(level) .eq. 0) then
              cycle
            endif
            if (elpa_index_print_autotune_state_new_stepping_c(self%index, level, ts_impl%domain, &
                    ts_impl%sublevel_part2stage(level), &
                    ts_impl%sublevel_min_loc2stage(level), &
                      ts_impl%sublevel_min_val2stage(level), ts_impl%sublevel_current2stage(level), &
                      ts_impl%sublevel_cardinality2stage(level), &
                      ELPA_SOLVER_2STAGE, &
                      c_null_char) /= 1) then
              write(error_unit, *) "This should not happen (in elpa_autotune_print_state())"
              if (present(error)) then
                error = ELPA_ERROR_AUTOTUNE_OBJECT_CHANGED
              endif
            endif
          enddo
        endif ! 2 stage
      else ! new stepping
        if (elpa_index_print_autotune_state_c(self%index, ts_impl%level, ts_impl%domain, ts_impl%min_loc, &
                  ts_impl%min_val, ts_impl%current, &
                  ts_impl%cardinality, c_null_char) /= 1) then
          write(error_unit, *) "This should not happen (in elpa_autotune_print_state())"
          if (present(error)) then
            error = ELPA_ERROR_AUTOTUNE_OBJECT_CHANGED
          endif
        endif
      endif ! new stepping

    end subroutine


    !c> 
    !c> void elpa_autotune_print_state(elpa_t handle, elpa_autotune_t autotune_handle, int *error);
    subroutine elpa_autotune_print_state_c(handle, autotune_handle, error) bind(C, name="elpa_autotune_print_state")
      type(c_ptr), intent(in), value       :: handle
      type(c_ptr), intent(in), value       :: autotune_handle
      type(elpa_impl_t), pointer           :: self
      type(elpa_autotune_impl_t), pointer  :: tune_state
      integer(kind=c_int)                  :: error

      call c_f_pointer(handle, self)
      call c_f_pointer(autotune_handle, tune_state)

      call self%autotune_print_state(tune_state, error)

    end subroutine



    !> \brief function to save the state of the autotuning
    !> Parameters
    !> \param   self            class(elpa_impl_t) the allocated ELPA object
    !> \param   tune_state      class(elpa_autotune_t): the autotuning object
    !> \param   file_name       string, the name of the file where to save the state
    !> \param   error           integer, optional
    subroutine elpa_autotune_save_state(self, tune_state, file_name, error)
      implicit none
      class(elpa_impl_t), intent(inout)          :: self
      class(elpa_autotune_t), intent(in), target :: tune_state
      type(elpa_autotune_impl_t), pointer        :: ts_impl
      character(*), intent(in)                   :: file_name
      integer(kind=c_int), optional, intent(out) :: error
      integer(kind=c_int)                        :: sublevel, level, solver

      if (present(error)) then
        error = ELPA_OK
      endif
      select type(tune_state)
        type is (elpa_autotune_impl_t)
          ts_impl => tune_state
        class default
          write(error_unit, *) "This should not happen! Critical error"
          if (present(error)) then
            error = ELPA_ERROR_CRITICAL
          endif
      end select

      if (ts_impl%new_stepping == 1) then
        if (consider_solver == ELPA_SOLVER_1STAGE) then
          do sublevel = 1, autotune_level
            if (.not.(autotune_substeps_done1stage(sublevel))) then
              exit
            endif
          enddo
          if (sublevel .le. autotune_level) then
            ! do nothing
          else if (sublevel .eq. autotune_level +1) then
            sublevel = autotune_level
          else
            print *,"Problem setting level in elpa_autotune_save_state"
            stop 
          endif
        endif ! 1 stage
        if (consider_solver == ELPA_SOLVER_2STAGE) then
          do sublevel = 1, autotune_level
            if (.not.(autotune_substeps_done2stage(sublevel))) then
              exit
            endif
          enddo
          if (sublevel .le. autotune_level) then
            ! do nothing
          else if (sublevel .eq. autotune_level +1) then
            sublevel = autotune_level
          else
            print *,"Problem setting level in elpa_autotune_save_state"
            stop 
          endif
        endif ! 2 stage
      endif


      if (ts_impl%new_stepping == 1) then

        ! should already be set
        ! 
        !if (self%is_set("solver") == 1) then
        !  call self%get("solver", solver, error)
        !  if (solver == ELPA_SOLVER_2STAGE) then
        !    ts_impl%sublevel_part(sublevel) = ELPA_AUTOTUNE_PART_ELPA2
        !  else if (solver == ELPA_SOLVER_1STAGE) then
        !    ts_impl%sublevel_part(sublevel) = ELPA_AUTOTUNE_PART_ELPA1
        !  else
        !    print *,"ELPA_AUTOTUNE_STEP: Unknown solver"
        !    stop
        !  endif        
        !else 
        !  ts_impl%sublevel_part(sublevel) = ELPA_AUTOTUNE_PART_ANY
        !endif


        ! loop over sublevels
        if (consider_solver == ELPA_SOLVER_1STAGE) then
          do level=1, sublevel
            if (ts_impl%sublevel_cardinality1stage(level) .eq. 0) then
              cycle
            endif
            if (elpa_index_print_autotune_state_new_stepping_c(self%index, level, ts_impl%domain, &
                    ts_impl%sublevel_part1stage(level), &
                    ts_impl%sublevel_min_loc1stage(level), &
                      ts_impl%sublevel_min_val1stage(level), ts_impl%sublevel_current1stage(level), &
                      ts_impl%sublevel_cardinality1stage(level), &
                      ELPA_SOLVER_1STAGE, &
                      file_name // c_null_char) /= 1) then
              write(error_unit, *) "This should not happen (in elpa_autotune_save_state())"
              if (present(error)) then
                error = ELPA_ERROR_CANNOT_OPEN_FILE
              endif
            endif
          enddo
        endif ! 1 stage
        if (consider_solver == ELPA_SOLVER_2STAGE) then
          do level=1, sublevel
            if (ts_impl%sublevel_cardinality2stage(level) .eq. 0) then
              cycle
            endif
            if (elpa_index_print_autotune_state_new_stepping_c(self%index, level, ts_impl%domain, &
                    ts_impl%sublevel_part2stage(level), &
                    ts_impl%sublevel_min_loc2stage(level), &
                      ts_impl%sublevel_min_val2stage(level), ts_impl%sublevel_current2stage(level), &
                      ts_impl%sublevel_cardinality2stage(level), &
                      ELPA_SOLVER_2STAGE, &
                      file_name // c_null_char) /= 1) then
              write(error_unit, *) "This should not happen (in elpa_autotune_save_state())"
              if (present(error)) then
                error = ELPA_ERROR_CANNOT_OPEN_FILE
              endif
            endif
          enddo
        endif ! 2 stage
      else ! new stepping
        if (elpa_index_print_autotune_state_c(self%index, ts_impl%level, ts_impl%domain, ts_impl%min_loc, &
                  ts_impl%min_val, ts_impl%current, &
                  ts_impl%cardinality, file_name // c_null_char) /= 1) then
          write(error_unit, *) "This should not happen (in elpa_autotune_save_state())"
          if (present(error)) then
            error = ELPA_ERROR_CANNOT_OPEN_FILE
          endif
        endif
      endif ! new stepping

    end subroutine



    !c> 
    !c> void elpa_autotune_save_state(elpa_t handle, elpa_autotune_t autotune_handle, const char *filename, int *error);
    subroutine elpa_autotune_save_state_c(handle, autotune_handle, filename_p, error) bind(C, name="elpa_autotune_save_state")
      type(c_ptr), intent(in), value       :: handle
      type(c_ptr), intent(in), value       :: autotune_handle
      type(elpa_impl_t), pointer           :: self
      type(elpa_autotune_impl_t), pointer  :: tune_state
      type(c_ptr), intent(in), value       :: filename_p
      character(len=elpa_strlen_c(filename_p)), pointer :: filename
      integer(kind=c_int)                  :: error

      call c_f_pointer(handle, self)
      call c_f_pointer(filename_p, filename)
      call c_f_pointer(autotune_handle, tune_state)

      call self%autotune_save_state(tune_state, filename, error)

    end subroutine



    !> \brief function to load the state of the autotuning
    !> Parameters
    !> \param   self            class(elpa_impl_t) the allocated ELPA object
    !> \param   tune_state      class(elpa_autotune_t): the autotuning object
    !> \param   file_name       string, the name of the file from which to load the state
    !> \param   error           integer, optional
!TODO
    subroutine elpa_autotune_load_state(self, tune_state, file_name, error)
      implicit none
      class(elpa_impl_t), intent(inout)          :: self
      class(elpa_autotune_t), intent(in), target :: tune_state
      type(elpa_autotune_impl_t), pointer        :: ts_impl
      character(*), intent(in)                   :: file_name
      integer(kind=c_int), optional, intent(out) :: error

      if (present(error)) then
        error = ELPA_OK
      endif
      select type(tune_state)
        type is (elpa_autotune_impl_t)
          ts_impl => tune_state
        class default
          write(error_unit, *) "This should not happen! Critical error"
          if (present(error)) then
            error = ELPA_ERROR_CRITICAL
          endif
      end select

      if (ts_impl%new_stepping == 1) then
        write(error_unit, *) "elpa_autotune_load_state currently ",&
                 "not implemented for new stepping"
        stop
        !if (elpa_index_load_autotune_state_new_stepping_c(self%index, ts_impl%level, ts_impl%domain, ts_impl%min_loc, &
        !          ts_impl%min_val, ts_impl%current, ts_impl%cardinality, file_name // c_null_char) /= 1) then
        !   write(error_unit, *) "This should not happen (in elpa_autotune_load_state())"
        !   if (present(error)) then
        !     error = ELPA_ERROR_CANNOT_OPEN_FILE
        !   endif
        !endif
      else
        if (elpa_index_load_autotune_state_c(self%index, ts_impl%level, ts_impl%domain, ts_impl%min_loc, &
                  ts_impl%min_val, ts_impl%current, ts_impl%cardinality, file_name // c_null_char) /= 1) then
           write(error_unit, *) "This should not happen (in elpa_autotune_load_state())"
           if (present(error)) then
             error = ELPA_ERROR_CANNOT_OPEN_FILE
           endif
        endif
      endif
    end subroutine



    !c> 
    !c> void elpa_autotune_load_state(elpa_t handle, elpa_autotune_t autotune_handle, const char *filename, int *error);
    subroutine elpa_autotune_load_state_c(handle, autotune_handle, filename_p, error) bind(C, name="elpa_autotune_load_state")
      type(c_ptr), intent(in), value       :: handle
      type(c_ptr), intent(in), value       :: autotune_handle
      type(elpa_impl_t), pointer           :: self
      type(elpa_autotune_impl_t), pointer  :: tune_state
      type(c_ptr), intent(in), value       :: filename_p
      character(len=elpa_strlen_c(filename_p)), pointer :: filename
      integer(kind=c_int)                  :: error

      call c_f_pointer(handle, self)
      call c_f_pointer(filename_p, filename)
      call c_f_pointer(autotune_handle, tune_state)

      call self%autotune_load_state(tune_state, filename, error)

    end subroutine


    !c> 
    !c> void elpa_autotune_set_best(elpa_t handle, elpa_autotune_t autotune_handle, int *error);
    subroutine elpa_autotune_set_best_c(handle, autotune_handle, error) bind(C, name="elpa_autotune_set_best")
      type(c_ptr), intent(in), value       :: handle
      type(c_ptr), intent(in), value       :: autotune_handle
      type(elpa_impl_t), pointer           :: self
      type(elpa_autotune_impl_t), pointer  :: tune_state
      integer(kind=c_int)                  :: error

      call c_f_pointer(handle, self)
      call c_f_pointer(autotune_handle, tune_state)

      call self%autotune_set_best(tune_state, error)

    end subroutine


    !c> 
    !c> void elpa_autotune_print_best(elpa_t handle, elpa_autotune_t autotune_handle, int *error);
    subroutine elpa_autotune_print_best_c(handle, autotune_handle, error) bind(C, name="elpa_autotune_print_best")
      type(c_ptr), intent(in), value       :: handle
      type(c_ptr), intent(in), value       :: autotune_handle
      type(elpa_impl_t), pointer           :: self
      type(elpa_autotune_impl_t), pointer  :: tune_state
      integer(kind=c_int)                  :: error

      call c_f_pointer(handle, self)
      call c_f_pointer(autotune_handle, tune_state)

      call self%autotune_print_best(tune_state, error)

    end subroutine


    function check_elpa(error, str, new_error) result(res)
      integer, intent(inout) :: error
      integer, intent(in)    :: new_error
      character(*)  :: str
      logical :: res
      if (error .ne. ELPA_OK) then
        print *, trim(str)
        res = .true.
        error = new_error
        return
      endif
      res = .false.
    end function

    function check_elpa_get(error, new_error) result(res)
      integer, intent(inout) :: error
      integer, intent(in)    :: new_error
      logical :: res
      res = check_elpa(error, "Problem getting option. Aborting...", new_error)
      return
    end function

    function check_elpa_set(error, new_error) result(res)
      integer, intent(inout) :: error
      integer, intent(in)    :: new_error
      logical :: res
      res = check_elpa(error, "Problem setting option. Aborting...", new_error)
      return
    end function

    subroutine elpa_creating_from_legacy_api(self)
      implicit none
      class(elpa_impl_t), intent(inout)          :: self

      self%from_legacy_api = 1
    end subroutine
end module
