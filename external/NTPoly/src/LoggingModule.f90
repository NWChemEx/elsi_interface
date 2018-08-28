!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!> A module for writing data to the log file.
MODULE LoggingModule
  USE DataTypesModule, ONLY : NTReal
  IMPLICIT NONE
  PRIVATE
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  INTEGER :: CurrentLevel = 0
  LOGICAL :: IsActive = .FALSE.
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  PUBLIC :: ActivateLogger
  PUBLIC :: DeactivateLogger
  PUBLIC :: EnterSubLog
  PUBLIC :: WriteHeader
  PUBLIC :: WriteListElement
  PUBLIC :: WriteElement
  PUBLIC :: WriteCitation
  PUBLIC :: ExitSubLog
CONTAINS!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!> Activate the logger.
  SUBROUTINE ActivateLogger
    IsActive = .TRUE.
  END SUBROUTINE ActivateLogger
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!> Deactivate the logger.
  SUBROUTINE DeactivateLogger
    IsActive = .TRUE.
  END SUBROUTINE DeactivateLogger
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!> Call this subroutine when you enter into a section with verbose output
  SUBROUTINE EnterSubLog
    CurrentLevel = CurrentLevel + 1
  END SUBROUTINE EnterSubLog
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!> Call this subroutine when you exit a section with verbose output
  SUBROUTINE ExitSubLog
    CurrentLevel = CurrentLevel - 1
  END SUBROUTINE ExitSubLog
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!> Write out a header to the log.
  SUBROUTINE WriteHeader(header_value)
!> The text of the header.
    CHARACTER(LEN=*), INTENT(IN) :: header_value

    IF (IsActive) THEN
       CALL WriteIndent
       WRITE(*,'(A)',ADVANCE='no') header_value
       WRITE(*,'(A1)') ":"
    END IF
  END SUBROUTINE WriteHeader
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!> Write out a element.
  SUBROUTINE WriteElement(key, text_value_in, int_value_in, float_value_in, &
       & bool_value_in)
!> Some text to write.
    CHARACTER(LEN=*), INTENT(IN) :: key
!> A text value to write.
    CHARACTER(LEN=*), INTENT(IN), OPTIONAL :: text_value_in
!> An integer value to write.
    INTEGER, INTENT(IN), OPTIONAL :: int_value_in
!> A float value to write.
    REAL(NTReal), INTENT(IN), OPTIONAL :: float_value_in
!> A bool value to write.
    LOGICAL, INTENT(IN), OPTIONAL :: bool_value_in

    IF (IsActive) THEN
       CALL WriteIndent

       WRITE(*,'(A)',ADVANCE='no') key

       IF (PRESENT(text_value_in)) THEN
          WRITE(*,'(A)',ADVANCE='no') ": "
          WRITE(*,'(A)',ADVANCE='no') text_value_in
       END IF
       IF (PRESENT(int_value_in)) THEN
          WRITE(*,'(A)',ADVANCE='no') ": "
          WRITE(*,'(I10)',ADVANCE='no') int_value_in
       END IF
       IF (PRESENT(float_value_in)) THEN
          WRITE(*,'(A)',ADVANCE='no') ": "
          WRITE(*,'(ES22.14)',ADVANCE='no') float_value_in
       END IF
       IF (PRESENT(bool_value_in)) THEN
          IF (bool_value_in) THEN
             WRITE(*,'(A)',ADVANCE='no') ": True"
          ELSE
             WRITE(*,'(A)',ADVANCE='no') ": False"
          END IF
       END IF

       WRITE(*,*)
    END IF
  END SUBROUTINE WriteElement
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!> Write out a list element.
!> Only specify one of the kinds of values.
  SUBROUTINE WriteListElement(key, text_value_in, int_value_in, float_value_in,&
       bool_value_in)
!> Some text to write.
    CHARACTER(LEN=*), INTENT(IN) :: key
!> A text value to write.
    CHARACTER(LEN=*), INTENT(IN), OPTIONAL :: text_value_in
!> An integer value to write.
    INTEGER, INTENT(IN), OPTIONAL :: int_value_in
!> A float value to write.
    REAL(NTReal), INTENT(IN), OPTIONAL :: float_value_in
!> A bool value to write.
    LOGICAL, INTENT(IN), OPTIONAL :: bool_value_in

    IF (IsActive) THEN
       CALL WriteIndent

       WRITE(*,'(A)',ADVANCE='no') "- "
       WRITE(*,'(A)',ADVANCE='no') key

       IF (PRESENT(text_value_in)) THEN
          WRITE(*,'(A)',ADVANCE='no') ": "
          WRITE(*,'(A)',ADVANCE='no') text_value_in
       END IF
       IF (PRESENT(int_value_in)) THEN
          WRITE(*,'(A)',ADVANCE='no') ": "
          WRITE(*,'(I10)',ADVANCE='no') int_value_in
       END IF
       IF (PRESENT(float_value_in)) THEN
          WRITE(*,'(A)',ADVANCE='no') ": "
          WRITE(*,'(ES22.14)',ADVANCE='no') float_value_in
       END IF
       IF (PRESENT(bool_value_in)) THEN
          IF (bool_value_in) THEN
             WRITE(*,'(A)',ADVANCE='no') ": True"
          ELSE
             WRITE(*,'(A)',ADVANCE='no') ": False"
          END IF
       END IF

       WRITE(*,*)
    END IF
  END SUBROUTINE WriteListElement
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!> Write out a citation element.
  SUBROUTINE WriteCitation(citation_list)
!> A list of citations, separated by a space.
    CHARACTER(LEN=*), INTENT(IN) :: citation_list
    INTEGER :: pos1, pos2

    IF (IsActive) THEN
       CALL WriteIndent
       WRITE(*,'(A)') "Citations:"
       CALL EnterSubLog

       pos1 = 1
       pos2 = INDEX(citation_list(pos1:), ' ')
       DO WHILE(pos2 .NE. 0)
          CALL WriteIndent
          WRITE(*,'(A)') citation_list(pos1:pos1+pos2-1)
          pos1 = pos1 + pos2
          pos2 = INDEX(citation_list(pos1:), ' ')
       END DO
       CALL WriteIndent
       WRITE(*,'(A)') citation_list(pos1:)

       CALL ExitSubLog
    END IF
  END SUBROUTINE WriteCitation
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!> Writes out the indentation needed for this level
  SUBROUTINE WriteIndent
    INTEGER :: counter

    DO counter=1,CurrentLevel*2
       WRITE(*,'(A1)',ADVANCE='NO') " "
    END DO
  END SUBROUTINE WriteIndent
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
END MODULE LoggingModule
