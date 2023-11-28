











module global_product
  use precision
  implicit none
  private

  public :: global_product_double
  public :: global_product_single

  contains

! real double precision first
















subroutine global_product_&
&double&
&(obj, z, n, mpi_comm_rows, mpi_comm_cols, npc_0, npc_n, success)
  ! This routine calculates the global product of z.
  use precision
  use elpa_abstract_impl
  use elpa_mpi
  use ELPA_utilities
  implicit none
  class(elpa_abstract_impl_t), intent(inout) :: obj
  integer(kind=ik), intent(in)               :: mpi_comm_cols, mpi_comm_rows
  integer(kind=ik), intent(in)               :: npc_0, npc_n
  integer(kind=ik)                           :: n, my_pcol, np_cols, np_rows
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

 call obj%get("nbc_row_global_product", non_blocking_collectives_rows, error)
 if (error .ne. ELPA_OK) then
   write(error_unit,*) "Problem setting option for non blocking collectives for rows in global_product. Aborting..."
   success = .false.
   return
 endif

 call obj%get("nbc_col_global_product", non_blocking_collectives_cols, error)
 if (error .ne. ELPA_OK) then
   write(error_unit,*) "Problem setting option for non blocking collectives for cols in global_product. Aborting..."
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
    z = tmp
    return
  endif

  ! We send all vectors to the first proc, do the product there
  ! and redistribute the result.

  if (my_pcol == npc_0) then
    z(1:n) = tmp(1:n)
    do np = npc_0+1, npc_0+npc_n-1
      tmp(1:n) = z(1:n)
      z(1:n) = z(1:n)*tmp(1:n)
    enddo
    do np = npc_0+1, npc_0+npc_n-1
    enddo
  else
    z(1:n) = tmp(1:n)

  endif
end subroutine global_product_&
        &double

! real single precision first


















subroutine global_product_&
&single&
&(obj, z, n, mpi_comm_rows, mpi_comm_cols, npc_0, npc_n, success)
  ! This routine calculates the global product of z.
  use precision
  use elpa_abstract_impl
  use elpa_mpi
  use ELPA_utilities
  implicit none
  class(elpa_abstract_impl_t), intent(inout) :: obj
  integer(kind=ik), intent(in)               :: mpi_comm_cols, mpi_comm_rows
  integer(kind=ik), intent(in)               :: npc_0, npc_n
  integer(kind=ik)                           :: n, my_pcol, np_cols, np_rows
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

 call obj%get("nbc_row_global_product", non_blocking_collectives_rows, error)
 if (error .ne. ELPA_OK) then
   write(error_unit,*) "Problem setting option for non blocking collectives for rows in global_product. Aborting..."
   success = .false.
   return
 endif

 call obj%get("nbc_col_global_product", non_blocking_collectives_cols, error)
 if (error .ne. ELPA_OK) then
   write(error_unit,*) "Problem setting option for non blocking collectives for cols in global_product. Aborting..."
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
    z = tmp
    return
  endif

  ! We send all vectors to the first proc, do the product there
  ! and redistribute the result.

  if (my_pcol == npc_0) then
    z(1:n) = tmp(1:n)
    do np = npc_0+1, npc_0+npc_n-1
      tmp(1:n) = z(1:n)
      z(1:n) = z(1:n)*tmp(1:n)
    enddo
    do np = npc_0+1, npc_0+npc_n-1
    enddo
  else
    z(1:n) = tmp(1:n)

  endif
end subroutine global_product_&
        &single

end module
