INCLUDE(ptscotch)

IF(SUPERLU_INC AND SUPERLU_LIB)
  MESSAGE(STATUS "Using external SuperLU_DIST")
  MESSAGE(STATUS "${GREEN}SUPERLU_LIB${COLORRESET}: ${SUPERLU_LIB}")
  MESSAGE(STATUS "${GREEN}SUPERLU_INC${COLORRESET}: ${SUPERLU_INC}")

  FOREACH(usr_lib ${SUPERLU_LIB})
    IF(NOT EXISTS ${usr_lib})
      MESSAGE(FATAL_ERROR "${MAGENTA}User provided SuperLU_DIST library not found: ${usr_lib}${COLORRESET}")
    ENDIF()
  ENDFOREACH()

  FOREACH(usr_dir ${SUPERLU_INC})
    IF(NOT EXISTS ${usr_dir})
      MESSAGE(FATAL_ERROR "${MAGENTA}User provided SuperLU_DIST include path not found: ${usr_dir}${COLORRESET}")
    ENDIF()

    SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -I${usr_dir}")
    SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -I${usr_dir}")
  ENDFOREACH()

  SET(SUPERLU_FOUND TRUE)
ELSE()
  MESSAGE(STATUS "Enabling internal SuperLU_DIST")

  SET(SUPERLU_FOUND FALSE)
  INCLUDE_DIRECTORIES(${CMAKE_SOURCE_DIR}/external/SuperLU_DIST/src)
ENDIF()