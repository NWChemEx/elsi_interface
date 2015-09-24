!> ELSI Interchange
!! 
!! Copyright of the original code rests with the authors inside the ELSI
!! consortium. The copyright of any additional modifications shall rest
!! with their original authors, but shall adhere to the licensing terms
!! distributed along with the original code in the file "COPYING".

module MPI_TOOLS

  use iso_c_binding

  use DIMENSIONS

  implicit none
  private

  integer, external :: numroc

  public :: elsi_initialize_mpi
  public :: elsi_initialize_blacs 
  public :: elsi_get_global_row
  public :: elsi_get_global_col
  public :: elsi_get_global_dimensions
  public :: elsi_get_local_dimensions
  public :: elsi_get_processor_grid
  public :: elsi_get_comm_grid
  public :: elsi_finalize_mpi
  public :: elsi_finalize_blacs

  contains

subroutine elsi_initialize_mpi(myid_out)

   implicit none
   include 'mpif.h'

   integer, intent(out) :: myid_out

   ! MPI Initialization

   call mpi_init(mpierr)
   if (mpierr /= 0) then
      write(*,'(a)') "MPI: Failed to initialize MPI."
      stop
   end if
   call mpi_comm_rank(mpi_comm_world, myid, mpierr)
   if (mpierr /= 0) then
      write(*,'(a)') "MPI: Failed to determine MPI rank."
      stop
   end if

   mpi_comm_global = mpi_comm_world

   call mpi_comm_size(mpi_comm_global, n_procs, mpierr)
   if (mpierr /= 0) then
      write(*,'(a)') "MPI: Failed to determine MPI size."
      stop
   end if

   myid_out = myid

end subroutine

subroutine elsi_finalize_mpi()

   implicit none
   include 'mpif.h'

   ! MPI Finalization

   call mpi_finalize(mpierr)
   if (mpierr /= 0) then
      write(*,'(a)') "MPI: Failed to finalize MPI."
      stop
   end if

end subroutine


subroutine elsi_initialize_blacs()

   implicit none

   include "mpif.h"

  ! Define blockcyclic setup
  do n_p_cols = NINT(SQRT(REAL(n_procs))),2,-1
     if(mod(n_procs,n_p_cols) == 0 ) exit
  enddo

  n_p_rows = n_procs / n_p_cols

  ! Set up BLACS and MPI communicators

  blacs_ctxt = mpi_comm_global
  call BLACS_Gridinit( blacs_ctxt, 'C', n_p_rows, n_p_cols )
  call BLACS_Gridinfo( blacs_ctxt, n_p_rows, n_p_cols, my_p_row, my_p_col )

  call mpi_comm_split(mpi_comm_global,my_p_col,my_p_row,mpi_comm_row,mpierr)

   if (mpierr /= 0) then
      write(*,'(a)') "ELPA: Failed to get ELPA row communicators."
      stop
   end if
 
  call mpi_comm_split(mpi_comm_global,my_p_row,my_p_col,mpi_comm_col,mpierr)

  if (mpierr /= 0) then
      write(*,'(a)') "ELPA: Failed to get ELPA column communicators."
      stop
   end if

  n_l_rows = numroc(n_g_rank, n_b_rows, my_p_row, 0, n_p_rows)
  n_l_cols = numroc(n_g_rank, n_b_cols, my_p_col, 0, n_p_cols)

  if(myid == 0) print *, 'Global matrixsize: ',n_g_rank, ' x ', n_g_rank
  if(myid == 0) print *, 'Blocksize: ',n_b_rows, ' x ', n_b_cols
  if(myid == 0) print *, 'Processor grid: ',n_p_rows, ' x ', n_p_cols
  if(myid == 0) print *, 'Local Matrixsize: ',n_l_rows, ' x ', n_l_cols
  call MPI_BARRIER(mpi_comm_global,mpierr)

  print *, myid," Id mpi_comm_global: ", mpi_comm_global
  print *, myid," Id ip_row/col: ", my_p_row, "/", my_p_col
  print *, myid," Id MPI_COMM_rows/cols: ", mpi_comm_row, "/", mpi_comm_col
  call MPI_BARRIER(mpi_comm_global,mpierr)

  call descinit( sc_desc, n_g_rank, n_g_rank, n_b_rows, n_b_cols, 0, 0, &
                 blacs_ctxt, MAX(1,n_l_rows), blacs_info )


end subroutine

subroutine elsi_finalize_blacs()

   implicit none

   call blacs_gridexit(blacs_ctxt)

end subroutine

subroutine elsi_get_global_row (global_idx, local_idx)

   implicit none

   integer, intent(out) :: global_idx  !< Global index 
   integer, intent(in)  :: local_idx   !< Local index

   integer :: block !< local block 
   integer :: idx   !< local index in block


   block = FLOOR( 1d0 * (local_idx - 1) / n_b_rows) 
   idx = local_idx - block * n_b_rows

   global_idx = my_p_row * n_b_rows + block * n_b_rows * n_p_rows + idx
  
end subroutine

subroutine elsi_get_global_col (global_idx, local_idx)

   implicit none

   integer, intent(out) :: global_idx   !< global index
   integer, intent(in)  :: local_idx    !< local index

   integer :: block !< local block
   integer :: idx   !< local index in block


   block = FLOOR( 1d0 * (local_idx - 1) / n_b_cols) 
   idx = local_idx - block * n_b_cols

   global_idx = my_p_col * n_b_cols + block * n_p_cols * n_b_cols + idx
  
end subroutine

subroutine elsi_get_global_dimensions (g_dim, g_block_rows, g_block_cols)

   implicit none

   integer, intent(out) :: g_dim   !< global rank
   integer, intent(out) :: g_block_rows !< global blocksize
   integer, intent(out) :: g_block_cols !< global blocksize

   g_dim   = n_g_rank 
   g_block_rows = n_b_rows
   g_block_cols = n_b_cols

end subroutine

subroutine elsi_get_local_dimensions (rows, cols)

   implicit none

   integer, intent(out) :: rows   !< output local rows
   integer, intent(out) :: cols   !< output local cols

   rows  = n_l_rows 
   cols  = n_l_cols

end subroutine

subroutine elsi_get_processor_grid (rows, cols)

   implicit none

   integer, intent(out) :: rows   !< output processor rows
   integer, intent(out) :: cols   !< output processor cols

   rows  = n_p_rows 
   cols  = n_p_cols

end subroutine

subroutine elsi_get_comm_grid (rows, cols)

   implicit none

   integer, intent(out) :: rows   !< output row communicator
   integer, intent(out) :: cols   !< output col communicator

   rows  = mpi_comm_row 
   cols  = mpi_comm_col

end subroutine


end module MPI_TOOLS
