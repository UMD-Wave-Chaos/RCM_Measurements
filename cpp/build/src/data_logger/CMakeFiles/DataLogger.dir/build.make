# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.13

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list


# Suppress display of executed commands.
$(VERBOSE).SILENT:


# A target that is always out of date.
cmake_force:

.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /Applications/CMake.app/Contents/bin/cmake

# The command to remove a file.
RM = /Applications/CMake.app/Contents/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /Users/benjaminfrazier/Projects/RCM_Measurements/cpp

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /Users/benjaminfrazier/Projects/RCM_Measurements/cpp/build

# Include any dependencies generated for this target.
include src/data_logger/CMakeFiles/DataLogger.dir/depend.make

# Include the progress variables for this target.
include src/data_logger/CMakeFiles/DataLogger.dir/progress.make

# Include the compile flags for this target's objects.
include src/data_logger/CMakeFiles/DataLogger.dir/flags.make

src/data_logger/CMakeFiles/DataLogger.dir/DataLogger_HDF5.cpp.o: src/data_logger/CMakeFiles/DataLogger.dir/flags.make
src/data_logger/CMakeFiles/DataLogger.dir/DataLogger_HDF5.cpp.o: ../src/data_logger/DataLogger_HDF5.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/Users/benjaminfrazier/Projects/RCM_Measurements/cpp/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object src/data_logger/CMakeFiles/DataLogger.dir/DataLogger_HDF5.cpp.o"
	cd /Users/benjaminfrazier/Projects/RCM_Measurements/cpp/build/src/data_logger && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/DataLogger.dir/DataLogger_HDF5.cpp.o -c /Users/benjaminfrazier/Projects/RCM_Measurements/cpp/src/data_logger/DataLogger_HDF5.cpp

src/data_logger/CMakeFiles/DataLogger.dir/DataLogger_HDF5.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/DataLogger.dir/DataLogger_HDF5.cpp.i"
	cd /Users/benjaminfrazier/Projects/RCM_Measurements/cpp/build/src/data_logger && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /Users/benjaminfrazier/Projects/RCM_Measurements/cpp/src/data_logger/DataLogger_HDF5.cpp > CMakeFiles/DataLogger.dir/DataLogger_HDF5.cpp.i

src/data_logger/CMakeFiles/DataLogger.dir/DataLogger_HDF5.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/DataLogger.dir/DataLogger_HDF5.cpp.s"
	cd /Users/benjaminfrazier/Projects/RCM_Measurements/cpp/build/src/data_logger && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /Users/benjaminfrazier/Projects/RCM_Measurements/cpp/src/data_logger/DataLogger_HDF5.cpp -o CMakeFiles/DataLogger.dir/DataLogger_HDF5.cpp.s

src/data_logger/CMakeFiles/DataLogger.dir/DataLogger_HDF5_Vector.cpp.o: src/data_logger/CMakeFiles/DataLogger.dir/flags.make
src/data_logger/CMakeFiles/DataLogger.dir/DataLogger_HDF5_Vector.cpp.o: ../src/data_logger/DataLogger_HDF5_Vector.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/Users/benjaminfrazier/Projects/RCM_Measurements/cpp/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Building CXX object src/data_logger/CMakeFiles/DataLogger.dir/DataLogger_HDF5_Vector.cpp.o"
	cd /Users/benjaminfrazier/Projects/RCM_Measurements/cpp/build/src/data_logger && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/DataLogger.dir/DataLogger_HDF5_Vector.cpp.o -c /Users/benjaminfrazier/Projects/RCM_Measurements/cpp/src/data_logger/DataLogger_HDF5_Vector.cpp

src/data_logger/CMakeFiles/DataLogger.dir/DataLogger_HDF5_Vector.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/DataLogger.dir/DataLogger_HDF5_Vector.cpp.i"
	cd /Users/benjaminfrazier/Projects/RCM_Measurements/cpp/build/src/data_logger && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /Users/benjaminfrazier/Projects/RCM_Measurements/cpp/src/data_logger/DataLogger_HDF5_Vector.cpp > CMakeFiles/DataLogger.dir/DataLogger_HDF5_Vector.cpp.i

src/data_logger/CMakeFiles/DataLogger.dir/DataLogger_HDF5_Vector.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/DataLogger.dir/DataLogger_HDF5_Vector.cpp.s"
	cd /Users/benjaminfrazier/Projects/RCM_Measurements/cpp/build/src/data_logger && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /Users/benjaminfrazier/Projects/RCM_Measurements/cpp/src/data_logger/DataLogger_HDF5_Vector.cpp -o CMakeFiles/DataLogger.dir/DataLogger_HDF5_Vector.cpp.s

src/data_logger/CMakeFiles/DataLogger.dir/DataLogger_HDF5_Double.cpp.o: src/data_logger/CMakeFiles/DataLogger.dir/flags.make
src/data_logger/CMakeFiles/DataLogger.dir/DataLogger_HDF5_Double.cpp.o: ../src/data_logger/DataLogger_HDF5_Double.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/Users/benjaminfrazier/Projects/RCM_Measurements/cpp/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_3) "Building CXX object src/data_logger/CMakeFiles/DataLogger.dir/DataLogger_HDF5_Double.cpp.o"
	cd /Users/benjaminfrazier/Projects/RCM_Measurements/cpp/build/src/data_logger && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/DataLogger.dir/DataLogger_HDF5_Double.cpp.o -c /Users/benjaminfrazier/Projects/RCM_Measurements/cpp/src/data_logger/DataLogger_HDF5_Double.cpp

src/data_logger/CMakeFiles/DataLogger.dir/DataLogger_HDF5_Double.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/DataLogger.dir/DataLogger_HDF5_Double.cpp.i"
	cd /Users/benjaminfrazier/Projects/RCM_Measurements/cpp/build/src/data_logger && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /Users/benjaminfrazier/Projects/RCM_Measurements/cpp/src/data_logger/DataLogger_HDF5_Double.cpp > CMakeFiles/DataLogger.dir/DataLogger_HDF5_Double.cpp.i

src/data_logger/CMakeFiles/DataLogger.dir/DataLogger_HDF5_Double.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/DataLogger.dir/DataLogger_HDF5_Double.cpp.s"
	cd /Users/benjaminfrazier/Projects/RCM_Measurements/cpp/build/src/data_logger && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /Users/benjaminfrazier/Projects/RCM_Measurements/cpp/src/data_logger/DataLogger_HDF5_Double.cpp -o CMakeFiles/DataLogger.dir/DataLogger_HDF5_Double.cpp.s

src/data_logger/CMakeFiles/DataLogger.dir/DataLogger_autogen/mocs_compilation.cpp.o: src/data_logger/CMakeFiles/DataLogger.dir/flags.make
src/data_logger/CMakeFiles/DataLogger.dir/DataLogger_autogen/mocs_compilation.cpp.o: src/data_logger/DataLogger_autogen/mocs_compilation.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/Users/benjaminfrazier/Projects/RCM_Measurements/cpp/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_4) "Building CXX object src/data_logger/CMakeFiles/DataLogger.dir/DataLogger_autogen/mocs_compilation.cpp.o"
	cd /Users/benjaminfrazier/Projects/RCM_Measurements/cpp/build/src/data_logger && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/DataLogger.dir/DataLogger_autogen/mocs_compilation.cpp.o -c /Users/benjaminfrazier/Projects/RCM_Measurements/cpp/build/src/data_logger/DataLogger_autogen/mocs_compilation.cpp

src/data_logger/CMakeFiles/DataLogger.dir/DataLogger_autogen/mocs_compilation.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/DataLogger.dir/DataLogger_autogen/mocs_compilation.cpp.i"
	cd /Users/benjaminfrazier/Projects/RCM_Measurements/cpp/build/src/data_logger && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /Users/benjaminfrazier/Projects/RCM_Measurements/cpp/build/src/data_logger/DataLogger_autogen/mocs_compilation.cpp > CMakeFiles/DataLogger.dir/DataLogger_autogen/mocs_compilation.cpp.i

src/data_logger/CMakeFiles/DataLogger.dir/DataLogger_autogen/mocs_compilation.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/DataLogger.dir/DataLogger_autogen/mocs_compilation.cpp.s"
	cd /Users/benjaminfrazier/Projects/RCM_Measurements/cpp/build/src/data_logger && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /Users/benjaminfrazier/Projects/RCM_Measurements/cpp/build/src/data_logger/DataLogger_autogen/mocs_compilation.cpp -o CMakeFiles/DataLogger.dir/DataLogger_autogen/mocs_compilation.cpp.s

# Object files for target DataLogger
DataLogger_OBJECTS = \
"CMakeFiles/DataLogger.dir/DataLogger_HDF5.cpp.o" \
"CMakeFiles/DataLogger.dir/DataLogger_HDF5_Vector.cpp.o" \
"CMakeFiles/DataLogger.dir/DataLogger_HDF5_Double.cpp.o" \
"CMakeFiles/DataLogger.dir/DataLogger_autogen/mocs_compilation.cpp.o"

# External object files for target DataLogger
DataLogger_EXTERNAL_OBJECTS =

src/data_logger/libDataLogger.a: src/data_logger/CMakeFiles/DataLogger.dir/DataLogger_HDF5.cpp.o
src/data_logger/libDataLogger.a: src/data_logger/CMakeFiles/DataLogger.dir/DataLogger_HDF5_Vector.cpp.o
src/data_logger/libDataLogger.a: src/data_logger/CMakeFiles/DataLogger.dir/DataLogger_HDF5_Double.cpp.o
src/data_logger/libDataLogger.a: src/data_logger/CMakeFiles/DataLogger.dir/DataLogger_autogen/mocs_compilation.cpp.o
src/data_logger/libDataLogger.a: src/data_logger/CMakeFiles/DataLogger.dir/build.make
src/data_logger/libDataLogger.a: src/data_logger/CMakeFiles/DataLogger.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/Users/benjaminfrazier/Projects/RCM_Measurements/cpp/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_5) "Linking CXX static library libDataLogger.a"
	cd /Users/benjaminfrazier/Projects/RCM_Measurements/cpp/build/src/data_logger && $(CMAKE_COMMAND) -P CMakeFiles/DataLogger.dir/cmake_clean_target.cmake
	cd /Users/benjaminfrazier/Projects/RCM_Measurements/cpp/build/src/data_logger && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/DataLogger.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
src/data_logger/CMakeFiles/DataLogger.dir/build: src/data_logger/libDataLogger.a

.PHONY : src/data_logger/CMakeFiles/DataLogger.dir/build

src/data_logger/CMakeFiles/DataLogger.dir/clean:
	cd /Users/benjaminfrazier/Projects/RCM_Measurements/cpp/build/src/data_logger && $(CMAKE_COMMAND) -P CMakeFiles/DataLogger.dir/cmake_clean.cmake
.PHONY : src/data_logger/CMakeFiles/DataLogger.dir/clean

src/data_logger/CMakeFiles/DataLogger.dir/depend:
	cd /Users/benjaminfrazier/Projects/RCM_Measurements/cpp/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /Users/benjaminfrazier/Projects/RCM_Measurements/cpp /Users/benjaminfrazier/Projects/RCM_Measurements/cpp/src/data_logger /Users/benjaminfrazier/Projects/RCM_Measurements/cpp/build /Users/benjaminfrazier/Projects/RCM_Measurements/cpp/build/src/data_logger /Users/benjaminfrazier/Projects/RCM_Measurements/cpp/build/src/data_logger/CMakeFiles/DataLogger.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : src/data_logger/CMakeFiles/DataLogger.dir/depend

