

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!> Module for reducing matrices across processes.
MODULE MatrixReduceModule
  USE DataTypesModule, ONLY : NTREAL, MPINTREAL, NTCOMPLEX, MPINTCOMPLEX, &
       & MPINTINTEGER
  USE SMatrixAlgebraModule, ONLY : IncrementMatrix
  USE SMatrixModule, ONLY : Matrix_lsr, Matrix_lsc, ConstructEmptyMatrix, &
       & DestructMatrix, CopyMatrix
  USE NTMPIModule
  IMPLICIT NONE
  PRIVATE
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  !> A data structure to stores internal information about a reduce call.
  TYPE, PUBLIC :: ReduceHelper_t
     !> Number of processors involved in this gather.
     INTEGER :: comm_size
     !> A request object for gathering outer indices.
     INTEGER :: outer_request
     !> A request object for gathering inner indices.
     INTEGER :: inner_request
     !> A request object for gathering data.
     INTEGER :: data_request
     !> The error code after an MPI call.
     INTEGER :: error_code
     !> Number of values to gather from each process.
     INTEGER, DIMENSION(:), ALLOCATABLE :: values_per_process
     !> The displacements for where those gathered values should go.
     INTEGER, DIMENSION(:), ALLOCATABLE :: displacement

     !> For mpi backup, a list of request objets for outer indices.
     INTEGER, DIMENSION(:), ALLOCATABLE :: outer_send_request_list
     INTEGER, DIMENSION(:), ALLOCATABLE :: outer_recv_request_list
     !> For mpi backup, a list of request objects for inner indices.
     INTEGER, DIMENSION(:), ALLOCATABLE :: inner_send_request_list
     INTEGER, DIMENSION(:), ALLOCATABLE :: inner_recv_request_list
     !> For mpi backup, a list of request object for data.
     INTEGER, DIMENSION(:), ALLOCATABLE :: data_send_request_list
     INTEGER, DIMENSION(:), ALLOCATABLE :: data_recv_request_list

  END TYPE ReduceHelper_t
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  PUBLIC :: ReduceAndComposeMatrixSizes
  PUBLIC :: ReduceAndComposeMatrixData
  PUBLIC :: ReduceAndComposeMatrixCleanup
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  PUBLIC :: ReduceAndSumMatrixSizes
  PUBLIC :: ReduceAndSumMatrixData
  PUBLIC :: ReduceAndSumMatrixCleanup
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  PUBLIC :: TestReduceSizeRequest
  PUBLIC :: TestReduceInnerRequest
  PUBLIC :: TestReduceDataRequest
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  INTERFACE ReduceAndComposeMatrixSizes
     MODULE PROCEDURE ReduceAndComposeMatrixSizes_lsr
     MODULE PROCEDURE ReduceAndComposeMatrixSizes_lsc
  END INTERFACE
  INTERFACE ReduceAndComposeMatrixData
     MODULE PROCEDURE ReduceAndComposeMatrixData_lsr
     MODULE PROCEDURE ReduceAndComposeMatrixData_lsc
  END INTERFACE
  INTERFACE ReduceAndComposeMatrixCleanup
     MODULE PROCEDURE ReduceAndComposeMatrixCleanup_lsr
     MODULE PROCEDURE ReduceAndComposeMatrixCleanup_lsc
  END INTERFACE
  INTERFACE ReduceAndSumMatrixSizes
     MODULE PROCEDURE ReduceAndSumMatrixSizes_lsr
     MODULE PROCEDURE ReduceAndSumMatrixSizes_lsc
  END INTERFACE
  INTERFACE ReduceAndSumMatrixData
     MODULE PROCEDURE ReduceAndSumMatrixData_lsr
     MODULE PROCEDURE ReduceAndSumMatrixData_lsc
  END INTERFACE
  INTERFACE ReduceAndSumMatrixCleanup
     MODULE PROCEDURE ReduceAndSumMatrixCleanup_lsr
     MODULE PROCEDURE ReduceAndSumMatrixCleanup_lsc
  END INTERFACE
CONTAINS!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  !> The first routine to call, gathers the sizes of the data to be sent.
  SUBROUTINE ReduceAndComposeMatrixSizes_lsr(matrix, communicator, &
       & gathered_matrix, helper)
    !> The matrix to send.
    TYPE(Matrix_lsr), INTENT(IN)        :: matrix
    !> The matrix we are gathering.
    TYPE(Matrix_lsr), INTENT(INOUT)     :: gathered_matrix
    !> The communicator to send along.
    INTEGER, INTENT(INOUT)              :: communicator
    !> The  helper associated with this gather.
    TYPE(ReduceHelper_t), INTENT(INOUT) :: helper
  !! Local Data
  INTEGER :: grid_error
  INTEGER :: II
  INTEGER :: istart, isize, iend

  CALL MPI_Comm_size(communicator,helper%comm_size,grid_error)

  !! Build Storage
  CALL ConstructEmptyMatrix(gathered_matrix, &
       & matrix%rows,matrix%columns*helper%comm_size)
  gathered_matrix%outer_index(1) = 0

  ALLOCATE(helper%outer_send_request_list(helper%comm_size))
  ALLOCATE(helper%outer_recv_request_list(helper%comm_size))

  !! Send/Recv Outer Index
  DO II = 1, helper%comm_size
     !! Send/Recv Outer Index
     CALL MPI_ISend(matrix%outer_index(2:), matrix%columns, MPINTINTEGER, &
          & II-1, 3, communicator, helper%outer_send_request_list(II), &
          & grid_error)
     istart = (matrix%columns)*(II-1)+2
     isize = matrix%columns
     iend = istart + isize - 1
     CALL MPI_Irecv(gathered_matrix%outer_index(istart:iend), isize, &
          & MPINTINTEGER, II-1, 3, communicator, &
          & helper%outer_recv_request_list(II), grid_error)
  END DO
  END SUBROUTINE ReduceAndComposeMatrixSizes_lsr
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  !> The first routine to call, gathers the sizes of the data to be sent.
  SUBROUTINE ReduceAndComposeMatrixSizes_lsc(matrix, communicator, &
       & gathered_matrix, helper)
    !! The matrix to send.
    TYPE(Matrix_lsc), INTENT(IN)        :: matrix
    !> The matrix we are gathering.
    TYPE(Matrix_lsc), INTENT(INOUT)     :: gathered_matrix
    !! The communicator to send along.
    INTEGER, INTENT(INOUT)              :: communicator
    !! The helper associated with this gather.
    TYPE(ReduceHelper_t), INTENT(INOUT) :: helper
  !! Local Data
  INTEGER :: grid_error
  INTEGER :: II
  INTEGER :: istart, isize, iend

  CALL MPI_Comm_size(communicator,helper%comm_size,grid_error)

  !! Build Storage
  CALL ConstructEmptyMatrix(gathered_matrix, &
       & matrix%rows,matrix%columns*helper%comm_size)
  gathered_matrix%outer_index(1) = 0

  ALLOCATE(helper%outer_send_request_list(helper%comm_size))
  ALLOCATE(helper%outer_recv_request_list(helper%comm_size))

  !! Send/Recv Outer Index
  DO II = 1, helper%comm_size
     !! Send/Recv Outer Index
     CALL MPI_ISend(matrix%outer_index(2:), matrix%columns, MPINTINTEGER, &
          & II-1, 3, communicator, helper%outer_send_request_list(II), &
          & grid_error)
     istart = (matrix%columns)*(II-1)+2
     isize = matrix%columns
     iend = istart + isize - 1
     CALL MPI_Irecv(gathered_matrix%outer_index(istart:iend), isize, &
          & MPINTINTEGER, II-1, 3, communicator, &
          & helper%outer_recv_request_list(II), grid_error)
  END DO
  END SUBROUTINE ReduceAndComposeMatrixSizes_lsc
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  !> Second function to call, will gather the data and align it one matrix
  !! @param[inout]
  SUBROUTINE ReduceAndComposeMatrixData_lsr(matrix, communicator, &
       & gathered_matrix, helper)
    !> The matrix to send.
    TYPE(Matrix_lsr), INTENT(IN)        :: matrix
    !> The matrix we are gathering.
    TYPE(Matrix_lsr), INTENT(INOUT)     :: gathered_matrix
    !> The helper associated with this gather.
    TYPE(ReduceHelper_t), INTENT(INOUT) :: helper
    !> The communicator to send along.
    INTEGER, INTENT(INOUT)              :: communicator
  !! Local Data
  INTEGER :: grid_error
  INTEGER :: II
  INTEGER :: total_values
  INTEGER :: istart, iend, isize
  INTEGER :: idx

  !! Send Receive Buffers
  ALLOCATE(helper%inner_send_request_list(helper%comm_size))
  ALLOCATE(helper%inner_recv_request_list(helper%comm_size))
  ALLOCATE(helper%data_send_request_list(helper%comm_size))
  ALLOCATE(helper%data_recv_request_list(helper%comm_size))

  !! Compute values per process
  ALLOCATE(helper%values_per_process(helper%comm_size))
  DO II = 1, helper%comm_size
     idx = matrix%columns*II + 1
     helper%values_per_process(II) = gathered_matrix%outer_index(idx)
  END DO

  !! Build Displacement List
  ALLOCATE(helper%displacement(helper%comm_size))
  helper%displacement(1) = 0
  DO II = 2, SIZE(helper%displacement)
     helper%displacement(II) = helper%displacement(II-1) + &
          & helper%values_per_process(II-1)
  END DO

  !! Build Storage
  total_values = SUM(helper%values_per_process)
  ALLOCATE(gathered_matrix%values(total_values))
  ALLOCATE(gathered_matrix%inner_index(total_values))

  !! MPI Calls
  DO II = 1, helper%comm_size
     !! Send/Recv inner index
     CALL MPI_ISend(matrix%inner_index, SIZE(matrix%inner_index), MPINTINTEGER, &
          & II-1, 2, communicator, helper%inner_send_request_list(II), &
          & grid_error)
     istart = helper%displacement(II)+1
     isize = helper%values_per_process(II)
     iend = istart + isize - 1
     CALL MPI_Irecv(gathered_matrix%inner_index(istart:iend), isize, MPINTINTEGER, &
          & II-1, 2, communicator, &
          & helper%inner_recv_request_list(II), grid_error)
  END DO
    DO II = 1, helper%comm_size
       CALL MPI_ISend(matrix%values, SIZE(matrix%values), MPINTREAL, &
            & II-1, 4, communicator, helper%data_send_request_list(II), &
            & grid_error)
       istart = helper%displacement(II)+1
       isize = helper%values_per_process(II)
       iend = istart + isize - 1
       CALL MPI_Irecv(gathered_matrix%values(istart:iend), isize, MPINTREAL, &
            & II-1, 4, communicator, &
            & helper%data_recv_request_list(II), grid_error)
    END DO
  END SUBROUTINE ReduceAndComposeMatrixData_lsr
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  !> Second function to call, will gather the data and align it one matrix
  !! next to another.
  !! @param[in] matrix to send.
  !! @param[inout] communicator to send along.
  !! @param[inout] gathered_matrix the matrix we are gathering.
  !! @param[inout] helper a helper associated with this gather.
  SUBROUTINE ReduceAndComposeMatrixData_lsc(matrix, communicator, &
       & gathered_matrix, helper)
    !> The matrix to send.
    TYPE(Matrix_lsc), INTENT(IN)        :: matrix
    !> The matrix we are gathering.
    TYPE(Matrix_lsc), INTENT(INOUT)     :: gathered_matrix
    !> The helper associated with this gather.
    TYPE(ReduceHelper_t), INTENT(INOUT) :: helper
    !> The communicator to send along.
    INTEGER, INTENT(INOUT)              :: communicator
  !! Local Data
  INTEGER :: grid_error
  INTEGER :: II
  INTEGER :: total_values
  INTEGER :: istart, iend, isize
  INTEGER :: idx

  !! Send Receive Buffers
  ALLOCATE(helper%inner_send_request_list(helper%comm_size))
  ALLOCATE(helper%inner_recv_request_list(helper%comm_size))
  ALLOCATE(helper%data_send_request_list(helper%comm_size))
  ALLOCATE(helper%data_recv_request_list(helper%comm_size))

  !! Compute values per process
  ALLOCATE(helper%values_per_process(helper%comm_size))
  DO II = 1, helper%comm_size
     idx = matrix%columns*II + 1
     helper%values_per_process(II) = gathered_matrix%outer_index(idx)
  END DO

  !! Build Displacement List
  ALLOCATE(helper%displacement(helper%comm_size))
  helper%displacement(1) = 0
  DO II = 2, SIZE(helper%displacement)
     helper%displacement(II) = helper%displacement(II-1) + &
          & helper%values_per_process(II-1)
  END DO

  !! Build Storage
  total_values = SUM(helper%values_per_process)
  ALLOCATE(gathered_matrix%values(total_values))
  ALLOCATE(gathered_matrix%inner_index(total_values))

  !! MPI Calls
  DO II = 1, helper%comm_size
     !! Send/Recv inner index
     CALL MPI_ISend(matrix%inner_index, SIZE(matrix%inner_index), MPINTINTEGER, &
          & II-1, 2, communicator, helper%inner_send_request_list(II), &
          & grid_error)
     istart = helper%displacement(II)+1
     isize = helper%values_per_process(II)
     iend = istart + isize - 1
     CALL MPI_Irecv(gathered_matrix%inner_index(istart:iend), isize, MPINTINTEGER, &
          & II-1, 2, communicator, &
          & helper%inner_recv_request_list(II), grid_error)
  END DO
    DO II = 1, helper%comm_size
       CALL MPI_ISend(matrix%values, SIZE(matrix%values), MPINTCOMPLEX, &
            & II-1, 4, communicator, helper%data_send_request_list(II), &
            & grid_error)
       istart = helper%displacement(II)+1
       isize = helper%values_per_process(II)
       iend = istart + isize - 1
       CALL MPI_Irecv(gathered_matrix%values(istart:iend), isize, &
            & MPINTCOMPLEX, II-1, 4, communicator, &
            & helper%data_recv_request_list(II), grid_error)
    END DO
  END SUBROUTINE ReduceAndComposeMatrixData_lsc
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  !> Third function to call, finishes setting up the matrices.
  PURE SUBROUTINE ReduceAndComposeMatrixCleanup_lsr(matrix, gathered_matrix, &
       & helper)
    !> The matrix to send.
    TYPE(Matrix_lsr), INTENT(IN)    :: matrix
    !> The matrix we are gathering.
    TYPE(Matrix_lsr), INTENT(INOUT) :: gathered_matrix
    !> The helper associated with this gather.
    TYPE(ReduceHelper_t), INTENT(INOUT) :: helper

  !! Local Data
  INTEGER :: II, JJ
  INTEGER :: temp_offset

  !! Sum Up The Outer Indices
  DO II = 1, helper%comm_size - 1
     temp_offset = II*matrix%columns+1
     DO JJ = 1, matrix%columns
        gathered_matrix%outer_index(temp_offset+JJ) = &
             & gathered_matrix%outer_index(temp_offset) + &
             & gathered_matrix%outer_index(temp_offset+JJ)
     END DO
  END DO
  DEALLOCATE(helper%values_per_process)
  DEALLOCATE(helper%displacement)
    IF (ALLOCATED(helper%outer_send_request_list)) THEN
       DEALLOCATE(helper%outer_send_request_list)
    END IF
    IF (ALLOCATED(helper%outer_recv_request_list)) THEN
       DEALLOCATE(helper%outer_recv_request_list)
    END IF
    IF (ALLOCATED(helper%inner_send_request_list)) THEN
       DEALLOCATE(helper%inner_send_request_list)
    END IF
    IF (ALLOCATED(helper%inner_recv_request_list)) THEN
       DEALLOCATE(helper%inner_recv_request_list)
    END IF
    IF (ALLOCATED(helper%data_send_request_list)) THEN
       DEALLOCATE(helper%data_send_request_list)
    END IF
    IF (ALLOCATED(helper%data_recv_request_list)) THEN
       DEALLOCATE(helper%data_recv_request_list)
    END IF

  END SUBROUTINE ReduceAndComposeMatrixCleanup_lsr
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  !> Third function to call, finishes setting up the matrices.
  PURE SUBROUTINE ReduceAndComposeMatrixCleanup_lsc(matrix, gathered_matrix, &
       & helper)
    !> The matrix to send.
    TYPE(Matrix_lsc), INTENT(IN)    :: matrix
    !> The matrix we are gathering.
    TYPE(Matrix_lsc), INTENT(INOUT) :: gathered_matrix
    !> The helper associated with this gather.
    TYPE(ReduceHelper_t), INTENT(INOUT) :: helper

  !! Local Data
  INTEGER :: II, JJ
  INTEGER :: temp_offset

  !! Sum Up The Outer Indices
  DO II = 1, helper%comm_size - 1
     temp_offset = II*matrix%columns+1
     DO JJ = 1, matrix%columns
        gathered_matrix%outer_index(temp_offset+JJ) = &
             & gathered_matrix%outer_index(temp_offset) + &
             & gathered_matrix%outer_index(temp_offset+JJ)
     END DO
  END DO
  DEALLOCATE(helper%values_per_process)
  DEALLOCATE(helper%displacement)
    IF (ALLOCATED(helper%outer_send_request_list)) THEN
       DEALLOCATE(helper%outer_send_request_list)
    END IF
    IF (ALLOCATED(helper%outer_recv_request_list)) THEN
       DEALLOCATE(helper%outer_recv_request_list)
    END IF
    IF (ALLOCATED(helper%inner_send_request_list)) THEN
       DEALLOCATE(helper%inner_send_request_list)
    END IF
    IF (ALLOCATED(helper%inner_recv_request_list)) THEN
       DEALLOCATE(helper%inner_recv_request_list)
    END IF
    IF (ALLOCATED(helper%data_send_request_list)) THEN
       DEALLOCATE(helper%data_send_request_list)
    END IF
    IF (ALLOCATED(helper%data_recv_request_list)) THEN
       DEALLOCATE(helper%data_recv_request_list)
    END IF

  END SUBROUTINE ReduceAndComposeMatrixCleanup_lsc
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  !> The first routine to call, gathers the sizes of the data to be sent.
  SUBROUTINE ReduceAndSumMatrixSizes_lsr(matrix, communicator,  &
       & gathered_matrix, helper)
    !> The matrix to send.
    TYPE(Matrix_lsr), INTENT(IN)        :: matrix
    !> The matrix we are gathering.
    TYPE(Matrix_lsr), INTENT(INOUT)     :: gathered_matrix
    !> The communicator to send along.
    INTEGER, INTENT(INOUT)              :: communicator
    !> The  helper associated with this gather.
    TYPE(ReduceHelper_t), INTENT(INOUT) :: helper
  !! Local Data
  INTEGER :: grid_error
  INTEGER :: sum_outer_indices
  INTEGER :: II
  INTEGER :: istart, isize, iend

  CALL MPI_Comm_size(communicator,helper%comm_size,grid_error)

  !! Build Storage
  CALL DestructMatrix(gathered_matrix)
  sum_outer_indices = (matrix%columns+1)*helper%comm_size
  ALLOCATE(gathered_matrix%outer_index(sum_outer_indices+1))

  ALLOCATE(helper%outer_send_request_list(helper%comm_size))
  ALLOCATE(helper%outer_recv_request_list(helper%comm_size))

  !! Send/Recv Outer Index
  DO II = 1, helper%comm_size
     CALL MPI_ISend(matrix%outer_index, SIZE(matrix%outer_index), &
          & MPINTINTEGER, II-1, 3, communicator, &
          & helper%outer_send_request_list(II), grid_error)
     istart = (matrix%columns+1)*(II-1)+1
     isize = matrix%columns + 1
     iend = istart + isize - 1
     CALL MPI_Irecv(gathered_matrix%outer_index(istart:iend), isize, &
          & MPINTINTEGER, II-1, 3, communicator, &
          & helper%outer_recv_request_list(II), grid_error)
  END DO
  END SUBROUTINE ReduceAndSumMatrixSizes_lsr
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  !> The first routine to call, gathers the sizes of the data to be sent.
  SUBROUTINE ReduceAndSumMatrixSizes_lsc(matrix, communicator,  &
       & gathered_matrix, helper)
    !! The matrix to send.
    TYPE(Matrix_lsc), INTENT(IN)        :: matrix
    !> The matrix we are gathering.
    TYPE(Matrix_lsc), INTENT(INOUT)     :: gathered_matrix
    !! The communicator to send along.
    INTEGER, INTENT(INOUT)              :: communicator
    !! The helper associated with this gather.
    TYPE(ReduceHelper_t), INTENT(INOUT) :: helper
  !! Local Data
  INTEGER :: grid_error
  INTEGER :: sum_outer_indices
  INTEGER :: II
  INTEGER :: istart, isize, iend

  CALL MPI_Comm_size(communicator,helper%comm_size,grid_error)

  !! Build Storage
  CALL DestructMatrix(gathered_matrix)
  sum_outer_indices = (matrix%columns+1)*helper%comm_size
  ALLOCATE(gathered_matrix%outer_index(sum_outer_indices+1))

  ALLOCATE(helper%outer_send_request_list(helper%comm_size))
  ALLOCATE(helper%outer_recv_request_list(helper%comm_size))

  !! Send/Recv Outer Index
  DO II = 1, helper%comm_size
     CALL MPI_ISend(matrix%outer_index, SIZE(matrix%outer_index), &
          & MPINTINTEGER, II-1, 3, communicator, &
          & helper%outer_send_request_list(II), grid_error)
     istart = (matrix%columns+1)*(II-1)+1
     isize = matrix%columns + 1
     iend = istart + isize - 1
     CALL MPI_Irecv(gathered_matrix%outer_index(istart:iend), isize, &
          & MPINTINTEGER, II-1, 3, communicator, &
          & helper%outer_recv_request_list(II), grid_error)
  END DO
  END SUBROUTINE ReduceAndSumMatrixSizes_lsc
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  !> Second routine to call for gathering and summing up the data.
  SUBROUTINE ReduceAndSumMatrixData_lsr(matrix, gathered_matrix, communicator, &
       & helper)
    !> The matrix to send.
    TYPE(Matrix_lsr), INTENT(IN)        :: matrix
    !> The matrix we are gathering.
    TYPE(Matrix_lsr), INTENT(INOUT)     :: gathered_matrix
    !> The communicator to send along.
    INTEGER, INTENT(INOUT)              :: communicator
    !> The helper associated with this gather.
    TYPE(ReduceHelper_t), INTENT(INOUT) :: helper
  !! Local Data
  INTEGER :: grid_error
  INTEGER :: II
  INTEGER :: sum_total_values
  INTEGER :: istart, isize, iend
  INTEGER :: idx

  !! Send Receive Buffers
  ALLOCATE(helper%inner_send_request_list(helper%comm_size))
  ALLOCATE(helper%inner_recv_request_list(helper%comm_size))
  ALLOCATE(helper%data_send_request_list(helper%comm_size))
  ALLOCATE(helper%data_recv_request_list(helper%comm_size))

  !! Compute values per process
  ALLOCATE(helper%values_per_process(helper%comm_size))
  DO II = 1, helper%comm_size
     idx = (matrix%columns+1)*II
     helper%values_per_process(II) = gathered_matrix%outer_index(idx)
  END DO

  !! Build Displacement List
  ALLOCATE(helper%displacement(helper%comm_size))
  helper%displacement(1) = 0
  DO II = 2, SIZE(helper%displacement)
     helper%displacement(II) = helper%displacement(II-1) + &
          & helper%values_per_process(II-1)
  END DO

  !! Build Storage
  sum_total_values = SUM(helper%values_per_process)
  ALLOCATE(gathered_matrix%values(sum_total_values))
  ALLOCATE(gathered_matrix%inner_index(sum_total_values))

  !! MPI Calls
  DO II = 1, helper%comm_size
     !! Send/Recv inner index
     CALL MPI_ISend(matrix%inner_index, SIZE(matrix%inner_index), &
          & MPINTINTEGER, II-1, 2, communicator, &
          & helper%inner_send_request_list(II), grid_error)
     istart = helper%displacement(II)+1
     isize = helper%values_per_process(II)
     iend = istart + isize - 1
     CALL MPI_Irecv(gathered_matrix%inner_index(istart:iend), isize, &
          & MPINTINTEGER, II-1, 2, communicator, &
          & helper%inner_recv_request_list(II), grid_error)
  END DO
    DO II = 1, helper%comm_size
       CALL MPI_ISend(matrix%values, SIZE(matrix%values), MPINTREAL, &
            & II-1, 4, communicator, helper%data_send_request_list(II), &
            & grid_error)
       istart = helper%displacement(II)+1
       isize = helper%values_per_process(II)
       iend = istart + isize - 1
       CALL MPI_Irecv(gathered_matrix%values(istart:iend), isize, MPINTREAL, &
            & II-1, 4, communicator, &
            & helper%data_recv_request_list(II), grid_error)
    END DO
  END SUBROUTINE ReduceAndSumMatrixData_lsr
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  !> Second routine to call for gathering and summing up the data.
  !! @param[in] matrix to send.
  !! @param[inout] communicator to send along.
  !! @param[inout] helper a helper associated with this gather.
  SUBROUTINE ReduceAndSumMatrixData_lsc(matrix, gathered_matrix, communicator, &
       & helper)
    !> The matrix to send.
    TYPE(Matrix_lsc), INTENT(IN)    :: matrix
    !> The matrix we are gathering.
    TYPE(Matrix_lsc), INTENT(INOUT) :: gathered_matrix
    !> The communicator to send along.
    INTEGER, INTENT(INOUT)              :: communicator
    !> The helper associated with this gather.
    TYPE(ReduceHelper_t), INTENT(INOUT) :: helper
  !! Local Data
  INTEGER :: grid_error
  INTEGER :: II
  INTEGER :: sum_total_values
  INTEGER :: istart, isize, iend
  INTEGER :: idx

  !! Send Receive Buffers
  ALLOCATE(helper%inner_send_request_list(helper%comm_size))
  ALLOCATE(helper%inner_recv_request_list(helper%comm_size))
  ALLOCATE(helper%data_send_request_list(helper%comm_size))
  ALLOCATE(helper%data_recv_request_list(helper%comm_size))

  !! Compute values per process
  ALLOCATE(helper%values_per_process(helper%comm_size))
  DO II = 1, helper%comm_size
     idx = (matrix%columns+1)*II
     helper%values_per_process(II) = gathered_matrix%outer_index(idx)
  END DO

  !! Build Displacement List
  ALLOCATE(helper%displacement(helper%comm_size))
  helper%displacement(1) = 0
  DO II = 2, SIZE(helper%displacement)
     helper%displacement(II) = helper%displacement(II-1) + &
          & helper%values_per_process(II-1)
  END DO

  !! Build Storage
  sum_total_values = SUM(helper%values_per_process)
  ALLOCATE(gathered_matrix%values(sum_total_values))
  ALLOCATE(gathered_matrix%inner_index(sum_total_values))

  !! MPI Calls
  DO II = 1, helper%comm_size
     !! Send/Recv inner index
     CALL MPI_ISend(matrix%inner_index, SIZE(matrix%inner_index), &
          & MPINTINTEGER, II-1, 2, communicator, &
          & helper%inner_send_request_list(II), grid_error)
     istart = helper%displacement(II)+1
     isize = helper%values_per_process(II)
     iend = istart + isize - 1
     CALL MPI_Irecv(gathered_matrix%inner_index(istart:iend), isize, &
          & MPINTINTEGER, II-1, 2, communicator, &
          & helper%inner_recv_request_list(II), grid_error)
  END DO
    DO II = 1, helper%comm_size
       CALL MPI_ISend(matrix%values, SIZE(matrix%values), MPINTCOMPLEX, &
            & II-1, 4, communicator, helper%data_send_request_list(II), &
            & grid_error)
       istart = helper%displacement(II)+1
       isize = helper%values_per_process(II)
       iend = istart + isize - 1
       CALL MPI_Irecv(gathered_matrix%values(istart:iend), isize, &
            & MPINTCOMPLEX, II-1, 4, communicator, &
            & helper%data_recv_request_list(II), grid_error)
    END DO
  END SUBROUTINE ReduceAndSumMatrixData_lsc
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  !> Finally routine to sum up the matrices.
  PURE SUBROUTINE ReduceAndSumMatrixCleanup_lsr(matrix, gathered_matrix, &
       & threshold, helper)
    !> The matrix to send.
    TYPE(Matrix_lsr), INTENT(IN)        :: matrix
    !> The gathered_matrix the matrix being gathered.
    TYPE(Matrix_lsr), INTENT(INOUT)     :: gathered_matrix
    !> The threshold the threshold for flushing values.
    REAL(NTREAL), INTENT(IN)            :: threshold
    !> The helper associated with this gather.
    TYPE(ReduceHelper_t), INTENT(INOUT) :: helper
    !! Local Data
    TYPE(Matrix_lsr) :: temporary_matrix, sum_matrix

  !! Local Data
  INTEGER :: II
  INTEGER :: temporary_total_values

  !! Build Matrix Objects
  CALL ConstructEmptyMatrix(temporary_matrix,matrix%rows,matrix%columns)
  CALL ConstructEmptyMatrix(sum_matrix,matrix%rows,matrix%columns)

  !! Sum
  DO II = 1, helper%comm_size
     temporary_total_values = helper%values_per_process(II)
     ALLOCATE(temporary_matrix%values(temporary_total_values))
     ALLOCATE(temporary_matrix%inner_index(temporary_total_values))
     temporary_matrix%values = gathered_matrix%values( &
          & helper%displacement(II)+1: &
          & helper%displacement(II) + helper%values_per_process(II))
     temporary_matrix%inner_index = gathered_matrix%inner_index( &
          & helper%displacement(II)+1: &
          & helper%displacement(II) + helper%values_per_process(II))
     temporary_matrix%outer_index = gathered_matrix%outer_index(&
          & (matrix%columns+1)*(II-1)+1:(matrix%columns+1)*(II))
     IF (II .EQ. helper%comm_size) THEN
        CALL IncrementMatrix(temporary_matrix,sum_matrix,threshold_in=threshold)
     ELSE
        CALL IncrementMatrix(temporary_matrix,sum_matrix,&
             & threshold_in=REAL(0.0,NTREAL))
     END IF
     DEALLOCATE(temporary_matrix%values)
     DEALLOCATE(temporary_matrix%inner_index)
  END DO
  CALL CopyMatrix(sum_matrix, gathered_matrix)
  CALL DestructMatrix(sum_matrix)

  CALL DestructMatrix(temporary_matrix)
  DEALLOCATE(helper%values_per_process)
  DEALLOCATE(helper%displacement)
    IF (ALLOCATED(helper%outer_send_request_list)) THEN
       DEALLOCATE(helper%outer_send_request_list)
    END IF
    IF (ALLOCATED(helper%outer_recv_request_list)) THEN
       DEALLOCATE(helper%outer_recv_request_list)
    END IF
    IF (ALLOCATED(helper%inner_send_request_list)) THEN
       DEALLOCATE(helper%inner_send_request_list)
    END IF
    IF (ALLOCATED(helper%inner_recv_request_list)) THEN
       DEALLOCATE(helper%inner_recv_request_list)
    END IF
    IF (ALLOCATED(helper%data_send_request_list)) THEN
       DEALLOCATE(helper%data_send_request_list)
    END IF
    IF (ALLOCATED(helper%data_recv_request_list)) THEN
       DEALLOCATE(helper%data_recv_request_list)
    END IF
  END SUBROUTINE ReduceAndSumMatrixCleanup_lsr
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  !> Finally routine to sum up the matrices.
  PURE SUBROUTINE ReduceAndSumMatrixCleanup_lsc(matrix, gathered_matrix, &
       & threshold, helper)
    !> The matrix to send.
    TYPE(Matrix_lsc), INTENT(IN)        :: matrix
    !> The threshold the threshold for flushing values.
    TYPE(Matrix_lsc), INTENT(INOUT)     :: gathered_matrix
    !> The threshold the threshold for flushing values.
    REAL(NTREAL), INTENT(IN)            :: threshold
    !> The helper associated with this gather.
    TYPE(ReduceHelper_t), INTENT(INOUT) :: helper
    !! Local Data
    TYPE(Matrix_lsc) :: temporary_matrix, sum_matrix

  !! Local Data
  INTEGER :: II
  INTEGER :: temporary_total_values

  !! Build Matrix Objects
  CALL ConstructEmptyMatrix(temporary_matrix,matrix%rows,matrix%columns)
  CALL ConstructEmptyMatrix(sum_matrix,matrix%rows,matrix%columns)

  !! Sum
  DO II = 1, helper%comm_size
     temporary_total_values = helper%values_per_process(II)
     ALLOCATE(temporary_matrix%values(temporary_total_values))
     ALLOCATE(temporary_matrix%inner_index(temporary_total_values))
     temporary_matrix%values = gathered_matrix%values( &
          & helper%displacement(II)+1: &
          & helper%displacement(II) + helper%values_per_process(II))
     temporary_matrix%inner_index = gathered_matrix%inner_index( &
          & helper%displacement(II)+1: &
          & helper%displacement(II) + helper%values_per_process(II))
     temporary_matrix%outer_index = gathered_matrix%outer_index(&
          & (matrix%columns+1)*(II-1)+1:(matrix%columns+1)*(II))
     IF (II .EQ. helper%comm_size) THEN
        CALL IncrementMatrix(temporary_matrix,sum_matrix,threshold_in=threshold)
     ELSE
        CALL IncrementMatrix(temporary_matrix,sum_matrix,&
             & threshold_in=REAL(0.0,NTREAL))
     END IF
     DEALLOCATE(temporary_matrix%values)
     DEALLOCATE(temporary_matrix%inner_index)
  END DO
  CALL CopyMatrix(sum_matrix, gathered_matrix)
  CALL DestructMatrix(sum_matrix)

  CALL DestructMatrix(temporary_matrix)
  DEALLOCATE(helper%values_per_process)
  DEALLOCATE(helper%displacement)
    IF (ALLOCATED(helper%outer_send_request_list)) THEN
       DEALLOCATE(helper%outer_send_request_list)
    END IF
    IF (ALLOCATED(helper%outer_recv_request_list)) THEN
       DEALLOCATE(helper%outer_recv_request_list)
    END IF
    IF (ALLOCATED(helper%inner_send_request_list)) THEN
       DEALLOCATE(helper%inner_send_request_list)
    END IF
    IF (ALLOCATED(helper%inner_recv_request_list)) THEN
       DEALLOCATE(helper%inner_recv_request_list)
    END IF
    IF (ALLOCATED(helper%data_send_request_list)) THEN
       DEALLOCATE(helper%data_send_request_list)
    END IF
    IF (ALLOCATED(helper%data_recv_request_list)) THEN
       DEALLOCATE(helper%data_recv_request_list)
    END IF
  END SUBROUTINE ReduceAndSumMatrixCleanup_lsc
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  !> Test if a request for the size of the matrices is complete.
  FUNCTION TestReduceSizeRequest(helper) RESULT(request_completed)
    !> The gatherer helper structure.
    TYPE(ReduceHelper_t), INTENT(INOUT) :: helper
    !> True if the request is finished.
    LOGICAL :: request_completed
    LOGICAL :: send_request_completed, recv_request_completed
    CALL MPI_Testall(SIZE(helper%outer_send_request_list), &
         & helper%outer_send_request_list, send_request_completed, &
         & MPI_STATUSES_IGNORE, helper%error_code)
    CALL MPI_Testall(SIZE(helper%outer_recv_request_list), &
         & helper%outer_recv_request_list, recv_request_completed, &
         & MPI_STATUSES_IGNORE, helper%error_code)
    request_completed = send_request_completed .AND. recv_request_completed
  END FUNCTION TestReduceSizeRequest
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  !> Test if a request for the inner indices of the matrices is complete.
  FUNCTION TestReduceInnerRequest(helper) RESULT(request_completed)
    !> The gatherer helper structure.
    TYPE(ReduceHelper_t), INTENT(INOUT) :: helper
    !> True if the request is finished.
    LOGICAL :: request_completed
    LOGICAL :: send_request_completed, recv_request_completed
    CALL MPI_Testall(SIZE(helper%inner_send_request_list), &
         & helper%inner_send_request_list, send_request_completed, &
         & MPI_STATUSES_IGNORE, helper%error_code)
    CALL MPI_Testall(SIZE(helper%inner_recv_request_list), &
         & helper%inner_recv_request_list, recv_request_completed, &
         & MPI_STATUSES_IGNORE, helper%error_code)
    request_completed = send_request_completed .AND. recv_request_completed
  END FUNCTION TestReduceInnerRequest
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  !> Test if a request for the data of the matrices is complete.
  FUNCTION TestReduceDataRequest(helper) RESULT(request_completed)
    !> The gatherer helper structure.
    TYPE(ReduceHelper_t), INTENT(INOUT) :: helper
    !> True if the request is finished.
    LOGICAL :: request_completed
    LOGICAL :: send_request_completed, recv_request_completed
    CALL MPI_Testall(SIZE(helper%data_send_request_list), &
         & helper%data_send_request_list, send_request_completed, &
         & MPI_STATUSES_IGNORE, helper%error_code)
    CALL MPI_Testall(SIZE(helper%data_recv_request_list), &
         & helper%data_recv_request_list, recv_request_completed, &
         & MPI_STATUSES_IGNORE, helper%error_code)
    request_completed = send_request_completed .AND. recv_request_completed
  END FUNCTION TestReduceDataRequest
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
END MODULE MatrixReduceModule
