if ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "MSVC")
    # force this option to ON so that Google Test will use /MD instead of /MT
    # /MD is now the default for Visual Studio, so it should be our default, too
    option(gtest_force_shared_crt
           "Use shared (DLL) run-time lib even when Google Test is built as static lib."
           ON)
elseif (APPLE)
    add_definitions(-DGTEST_USE_OWN_TR1_TUPLE=1)
endif()

#create the instWrapper test suite

#first need to configure the executable test
set(EXE_NAME instrumentWrapperTest)

add_executable (${EXE_NAME} instrumentWrapper_test.cpp)
target_link_libraries (${EXE_NAME}  gmock_main ${GPERFTOOLS_LIBRARIES} instrumentInterfaceLibrary)

#make sure to include math defines for Windows Visual Studio
target_compile_definitions(${EXE_NAME} PRIVATE "-D_USE_MATH_DEFINES")
		   
#Now add the tests
#First is the Build Test
add_test(NAME Build_instWrapperTest
         COMMAND "${CMAKE_COMMAND}" --build ${CMAKE_BINARY_DIR} --config $<CONFIGURATION> --target ${EXE_NAME})
         
#Next is the Run Tests
add_test(NAME Run_instWrapperTest
         WORKING_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
         COMMAND ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${EXE_NAME}
	  --gtest_output=xml:${GPERF_TMP_DIRECTORY}/${EXE_NAME}_results.xml)

#Next is the Memory Test if gperftools were found
if(${GPERFTOOLS_FOUND})
add_test(NAME MemCheck_instWrapperTest 
         WORKING_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
         COMMAND ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${EXE_NAME})

set_property(
             TEST
	      MemCheck_instWrapperTest
	      PROPERTY
	      ENVIRONMENT HEAPPROFILE=${GPERF_TMP_DIRECTORY}/heapprof_inst_wrapper_test)
set_property(
             TEST
	      MemCheck_instWrapperTest
	      APPEND PROPERTY
	      ENVIRONMENT HEAPCHECK=1)
set_property(
             TEST
	      MemCheck_instWrapperTest
	      APPEND PROPERTY
	      ENVIRONMENT CPUPROFILE=${GPERF_TMP_DIRECTORY}/cpuprof_inst_wrapper_test)
set_property(
             TEST
	      MemCheck_instWrapperTest
	      APPEND PROPERTY
	      ENVIRONMENT MALLOCSTATS=4)
endif()
