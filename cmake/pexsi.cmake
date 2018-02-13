include(superlu)
if(NOT EXTERNAL_SUPERLU)
  message(FATAL_ERROR "Not yet supported!!")
  message(STATUS "Enabling internal version of PtScotch")
  message(STATUS "Enabling internal version of SuperLU_DIST")
  add_subdirectory(${ptscotch_dir})
  add_subdirectory(${superlu_dir})
endif()
