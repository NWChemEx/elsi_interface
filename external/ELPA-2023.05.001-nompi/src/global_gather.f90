











module global_gather
  use precision
  implicit none
  private

  public :: global_gather_double
  public :: global_gather_single

  contains

! real double precision first
















subroutine global_gather_&
&double&
&(obj, z, n, mpi_comm_rows, mpi_comm_cols, npc_n, np_prev, np_next, &
  success)
  ! This routine sums up z over all processors.
  ! It should only be used for gathering distributed results,
  ! i.e. z(i) should be nonzero on exactly 1 processor column,
  ! otherways the results may be numerically different on different columns
  use precision
  use elpa_abstract_impl
  use elpa_mpi
  use ELPA_utilities
  implicit none
  class(elpa_abstract_impl_t), intent(inout) :: obj
  integer(kind=ik), intent(in)               :: mpi_comm_cols, mpi_comm_rows
  integer(kind=ik), intent(in)               :: npc_n, np_prev, np_next
  integer(kind=ik)                           :: n, np_rows, np_cols
  real(kind=rk8)                   :: z(n)
  real(kind=rk8)                   :: tmp(n)
  integer(kind=ik)                           :: np
  integer(kind=MPI_KIND)                     :: allreduce_request1, allreduce_request2
  logical                                    :: useNonBlockingCollectivesCols
  logical                                    :: useNonBlockingCollectivesRows
  integer(kind=c_int)                        :: non_blocking_collectives_rows, error, &
                                                non_blocking_collectives_cols
  logical                                    :: success

  success = .true.

  call obj%get("nbc_row_global_gather", non_blocking_collectives_rows, error)
  if (error .ne. ELPA_OK) then
    write(error_unit,*) "Problem getting option for non blocking collectives for rows in global_gather. Aborting..."
    success = .false.
    return
  endif

  call obj%get("nbc_col_global_gather", non_blocking_collectives_cols, error)
  if (error .ne. ELPA_OK) then
    write(error_unit,*) "Problem getting option for non blocking collectives for cols in global_gather. Aborting..."
    success = .false.
    return
  endif

  if (non_blocking_collectives_rows .eq. 1) then
    useNonBlockingCollectivesRows = .true.
  else
    useNonBlockingCollectivesRows = .false.
  endif

  if (non_blocking_collectives_cols .eq. 1) then
    useNonBlockingCollectivesCols = .true.
  else
    useNonBlockingCollectivesCols = .false.
  endif

  if (npc_n==1 .and. np_rows==1) return ! nothing to do

  ! Do an mpi_allreduce over processor rows
  tmp = z
  ! If only 1 processor column, we are done
  if (npc_n==1) then
    z(:) = tmp(:)
    return
  endif

  ! If all processor columns are involved, we can use mpi_allreduce
  if (npc_n==np_cols) then
    tmp = z

    return
  endif

  ! Do a ring send over processor columns
  z(:) = 0
  do np = 1, npc_n
    z(:) = z(:) + tmp(:)
  enddo
end subroutine global_gather_&
        &double

! real single precision first


















subroutine global_gather_&
&single&
&(obj, z, n, mpi_comm_rows, mpi_comm_cols, npc_n, np_prev, np_next, &
  success)
  ! This routine sums up z over all processors.
  ! It should only be used for gathering distributed results,
  ! i.e. z(i) should be nonzero on exactly 1 processor column,
  ! otherways the results may be numerically different on different columns
  use precision
  use elpa_abstract_impl
  use elpa_mpi
  use ELPA_utilities
  implicit none
  class(elpa_abstract_impl_t), intent(inout) :: obj
  integer(kind=ik), intent(in)               :: mpi_comm_cols, mpi_comm_rows
  integer(kind=ik), intent(in)               :: npc_n, np_prev, np_next
  integer(kind=ik)                           :: n, np_rows, np_cols
  real(kind=rk4)                   :: z(n)
  real(kind=rk4)                   :: tmp(n)
  integer(kind=ik)                           :: np
  integer(kind=MPI_KIND)                     :: allreduce_request1, allreduce_request2
  logical                                    :: useNonBlockingCollectivesCols
  logical                                    :: useNonBlockingCollectivesRows
  integer(kind=c_int)                        :: non_blocking_collectives_rows, error, &
                                                non_blocking_collectives_cols
  logical                                    :: success

  success = .true.

  call obj%get("nbc_row_global_gather", non_blocking_collectives_rows, error)
  if (error .ne. ELPA_OK) then
    write(error_unit,*) "Problem getting option for non blocking collectives for rows in global_gather. Aborting..."
    success = .false.
    return
  endif

  call obj%get("nbc_col_global_gather", non_blocking_collectives_cols, error)
  if (error .ne. ELPA_OK) then
    write(error_unit,*) "Problem getting option for non blocking collectives for cols in global_gather. Aborting..."
    success = .false.
    return
  endif

  if (non_blocking_collectives_rows .eq. 1) then
    useNonBlockingCollectivesRows = .true.
  else
    useNonBlockingCollectivesRows = .false.
  endif

  if (non_blocking_collectives_cols .eq. 1) then
    useNonBlockingCollectivesCols = .true.
  else
    useNonBlockingCollectivesCols = .false.
  endif

  if (npc_n==1 .and. np_rows==1) return ! nothing to do

  ! Do an mpi_allreduce over processor rows
  tmp = z
  ! If only 1 processor column, we are done
  if (npc_n==1) then
    z(:) = tmp(:)
    return
  endif

  ! If all processor columns are involved, we can use mpi_allreduce
  if (npc_n==np_cols) then
    tmp = z

    return
  endif

  ! Do a ring send over processor columns
  z(:) = 0
  do np = 1, npc_n
    z(:) = z(:) + tmp(:)
  enddo
end subroutine global_gather_&
        &single

end module
