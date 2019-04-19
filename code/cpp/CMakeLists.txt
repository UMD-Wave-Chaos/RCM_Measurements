#Primary CMakeLists.txt file for RCM Measurement GUI
#Currently Tested for Unix Makefiles
cmake_minimum_required(VERSION 3.2.2)
project(RMGUI CXX)
enable_testing()

set(EXE_NAME RMGUI)

message("EXE_NAME: " ${EXE_NAME})
message("CMAKE_BUILD_TYPE: " ${CMAKE_BUILD_TYPE})

# Find includes in corresponding build directories
set(CMAKE_INCLUDE_CURRENT_DIR ON)
# Instruct CMake to run moc automatically when needed
set(CMAKE_AUTOMOC ON)
# Create code from a list of Qt designer ui files
set(CMAKE_AUTOUIC ON)
#create code from resources
set(CMAKE_AUTORCC ON)

#Ensure C++11 standard is used - may need to roll this into specific generators for other platforms
SET( CMAKE_CXX_FLAGS  "${CMAKE_CXX_FLAGS} -std=c++11")

#set the source directory (trunk/src) and module path to the current directory (trunk)
set(SOURCE_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/src)
set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR})

#set the bin directory and set a command to create it during the build process
set(BINARY_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/bin)
add_custom_target(build-time-make-bin-directory ALL
    COMMAND ${CMAKE_COMMAND} -E make_directory ${BINARY_DIRECTORY})

#set the test directory and create it during the build process
set(BINARY_TEST_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/bin/tests)
add_custom_target(build-time-make-bin-test-directory ALL
    COMMAND ${CMAKE_COMMAND} -E make_directory ${BINARY_TEST_DIRECTORY})

#set the policy - needed for Qt with “::” in the macros
 if(COMMAND cmake_policy)
      cmake_policy(SET CMP0003 NEW)
    endif(COMMAND cmake_policy)


#########################################################################################
#determine build platform
if (APPLE)
    message("Building on Mac OS ...")

endif()

##########################################################################################
#find the additional libraries needed
#HDF5 - used for data logging
find_package (HDF5 COMPONENTS CXX)
message( "HDF5 Found: " ${HDF5_FOUND})

#QT5 - for the GUI
find_package(Qt5 COMPONENTS Core Widgets Network Charts SerialPort REQUIRED)
message( "QT5 Core Found: " ${Qt5Core_FOUND})
message( "QT5 Widgets Found: " ${Qt5Widgets_FOUND})
message( "QT5 Charts Found: " ${Qt5Charts_FOUND})
message( "QT5 Network Found: " ${Qt5Network_FOUND})
message( "QT5 Serial Port Found: " ${Qt5SerialPort_FOUND})

#Doxygen - used to generate code documentation
find_package(Doxygen)
message("Doxygen found: " ${DOXYGEN_FOUND})

#Gperftools
find_package(Gperftools)
message("GPerftools found: " ${GPERFTOOLS_FOUND})
if(${GPERFTOOLS_FOUND})
#set the tmp  directory and set a command to create it during the build process
set(GPERF_TMP_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/../bin/tests/tmp)
add_custom_target(build-time-make-gperf-directory ALL
    COMMAND ${CMAKE_COMMAND} -E make_directory ${GPERF_TMP_DIRECTORY})   
else()
  set(GPERFTOOLS_LIBRARIES "")
endif()

#FFTW
find_package (FFTW)
message("FFTW Found: " ${FFTW_FOUND})

find_package(GRPC REQUIRED)

#include the subdirectories for the headers
include_directories(${SOURCE_DIRECTORY}/GUI)
include_directories(${SOURCE_DIRECTORY}/pna_controller)
include_directories(${SOURCE_DIRECTORY}/measurement_control)
include_directories(${SOURCE_DIRECTORY}/data_logger)
include_directories(${SOURCE_DIRECTORY}/stepper_motor_controller)
include_directories(${SOURCE_DIRECTORY}/utilities)
include_directories(${SOURCE_DIRECTORY}/instrument_controller)
include_directories(${SOURCE_DIRECTORY}/instrument_controller/vxi11)

##########################################################################################
#add additional sub directories

#3rd party software
add_subdirectory(3rdParty)
message("GTEST_INCLUDE_DIR: " ${GTEST_INCLUDE_DIR})
message("GMOCK_INCLUDE_DIR: " ${GMOCK_INCLUDE_DIR})

#add the additional include directories
include_directories(${HDF5_INCLUDE_DIR} ${GTEST_INCLUDE_DIR} ${GMOCK_INCLUDE_DIR} ${CMAKE_CURRENT_SOURCE_DIR})

include_directories(3rdParty/rapidxml-1.13)

#add the src subdirectory
add_subdirectory(${SOURCE_DIRECTORY})

###########################################################################################
#redirect the runtime output directory to the desired location - this should occur after adding the src subdirectory so that the test binaries are not generated in the same folder
set (CMAKE_RUNTIME_OUTPUT_DIRECTORY ${BINARY_DIRECTORY})

# Populate a CMake variable with the sources for the main program
set(main_SRCS
	main.cpp
)

# add the primary executable
if(APPLE)
    #tell CMake where to find and install the file itself
    set(myApp_ICON ${CMAKE_CURRENT_SOURCE_DIR}/src/GUI/icons/umdlogo.icns)
    set_source_files_properties(${myApp_ICON} PROPERTIES
               MACOSX_PACKAGE_LOCATION "Resources")

    add_executable(${EXE_NAME} MACOSX_BUNDLE ${myApp_ICON} ${main_SRCS})
    set_target_properties(${EXE_NAME} PROPERTIES MACOSX_BUNDLE_INFO_PLIST ${CMAKE_CURRENT_SOURCE_DIR}/CMakeModules/MacOsBundle.plist.in)
else()
    add_executable(${EXE_NAME} ${main_SRCS})
endif()

# Use the Widgets module from Qt 5
target_link_libraries(${EXE_NAME} RMGUILibrary)

#make sure to include math defines for Windows Visual Studio
target_compile_definitions(${EXE_NAME} PRIVATE "-D_USE_MATH_DEFINES")

###########################################################################################
# add a target to generate API documentation with Doxygen
if(DOXYGEN_FOUND)
  configure_file(${CMAKE_CURRENT_SOURCE_DIR}/../../Doxyfile.in ${CMAKE_CURRENT_BINARY_DIR}/Doxyfile @ONLY)
  add_custom_target(doc
                    ${DOXYGEN_EXECUTABLE} ${CMAKE_CURRENT_BINARY_DIR}/Doxyfile
                    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
                    COMMENT "Generating API documentation with Doxygen" VERBATIM
                  )
   add_custom_target(pdfdoc
                     make
		     WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/latex
		     COMMENT "Generating PDF documentation" VERBATIM
                    )

   #set the bin directory and set a command to create it during the build process
   set(DOCS_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/../docs)
   add_custom_target(build-time-make-docs-directory ALL
    		   COMMAND ${CMAKE_COMMAND} -E make_directory ${DOCS_DIRECTORY})
   add_custom_target(build-time-make-docs-images-directory ALL
                      COMMAND ${CMAKE_COMMAND} -E make_directory ${DOCS_DIRECTORY}/images)

  #copy docs to docs directory
  add_custom_command(
        TARGET pdfdoc POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy
                ${CMAKE_CURRENT_BINARY_DIR}/latex/refman.pdf
                ${DOCS_DIRECTORY})

 add_custom_command(TARGET doc POST_BUILD
                    COMMAND ${CMAKE_COMMAND} -E copy_directory
                    ${CMAKE_CURRENT_SOURCE_DIR}../../images
                    ${CMAKE_CURRENT_BINARY_DIR}/html/images)

  add_custom_command(TARGET doc POST_BUILD
                   COMMAND ${CMAKE_COMMAND} -E copy_directory
                   ${CMAKE_CURRENT_BINARY_DIR}/html
		   ${DOCS_DIRECTORY}/html)


		    
endif(DOXYGEN_FOUND)
