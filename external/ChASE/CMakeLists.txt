OPTION(ENABLE_CHASE_NCCL "Enable NCCL support in ChASE" OFF)

include( FortranCInterface )
FortranCInterface_HEADER( ${CMAKE_BINARY_DIR}/fortran_mangle.h
  MACRO_NAMESPACE "FC_"
  SYMBOL_NAMESPACE "FC_"
  )

list(APPEND includePath ${CMAKE_BINARY_DIR} ${CMAKE_CURRENT_SOURCE_DIR}/src)
list(APPEND inc_install ${CMAKE_CURRENT_SOURCE_DIR}/src/ChASE-MPI ${CMAKE_CURRENT_SOURCE_DIR}/src/algorithm)

add_compile_definitions(HAS_SCALAPACK=1)
add_compile_definitions(USE_MPI=1)

option( CHASE_OUTPUT "ChASE will provide output at each iteration" OFF)
if( CHASE_OUTPUT )
  add_compile_definitions(CHASE_OUTPUT=1)
endif()

IF(USE_GPU_CUDA)
  MESSAGE(STATUS "Enabling GPU (CUDA) support in ChASE")
  enable_language(CUDA)
  add_library( chase_cuda "${CMAKE_CURRENT_LIST_DIR}/src/ChASE-MPI/kernels/shift.cu" )
  set_target_properties( chase_cuda 
	  		 PROPERTIES CUDA_RESOLVE_DEVICE_SYMBOLS ON)

  target_link_libraries( chase_cuda PUBLIC ${LIBS})
  add_compile_definitions(HAS_GPU=1)
  add_compile_definitions(HAS_CUDA=1)

  if(ENABLE_CHASE_NCCL)
     MESSAGE(STATUS "Enabling NCCL support in ChASE")	  
     add_compile_definitions(HAS_NCCL=1)
     add_compile_definitions(CUDA_AWARE=1)
   endif()
ENDIF()

LIST(APPEND chase_src
  src/interface/chase_c.cpp
  src/interface/chase_f.f90)

ADD_LIBRARY(chase ${chase_src})
set_target_properties(
  chase
  PROPERTIES Fortran_PREPROCESS ON
  POSITION_INDEPENDENT_CODE TRUE
)

TARGET_LINK_LIBRARIES(chase PRIVATE ${LIBS})
IF(USE_GPU_CUDA)
  TARGET_LINK_LIBRARIES(chase PRIVATE chase_cuda)
ENDIF()

#TARGET_LINK_LIBRARIES(chase_f PRIVATE chase_c)
TARGET_INCLUDE_DIRECTORIES(chase PRIVATE
  ${INC_PATHS}	
  "$<BUILD_INTERFACE:${includePath}>"
  $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>)

install(DIRECTORY ${inc_install} 
	DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
  	FILES_MATCHING
    		PATTERN "*.hpp"
    		PATTERN "*.inc"
)

install( FILES  ${CMAKE_BINARY_DIR}/fortran_mangle.h
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
  )

IF(USE_GPU_CUDA)
INSTALL(TARGETS chase chase_cuda
  EXPORT elsiConfig
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
  )
ELSE()
INSTALL(TARGETS chase
  EXPORT elsiConfig
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
  )
ENDIF()
