# CMake generated Testfile for 
# Source directory: /Users/benjaminfrazier/Projects/RCM_Measurement_GUI/src/data_logger/tests
# Build directory: /Users/benjaminfrazier/Projects/RCM_Measurement_GUI/build/src/data_logger/tests
# 
# This file includes the relevant testing commands required for 
# testing this directory and lists subdirectories to be tested as well.
add_test(Build_DataLoggerTest "/Applications/CMake.app/Contents/bin/cmake" "--build" "/Users/benjaminfrazier/Projects/RCM_Measurement_GUI/build" "--config" "" "--target" "DataLoggerHDF5Test")
add_test(Run_DataLoggerTest "/DataLoggerHDF5Test" "--gtest_output=xml:/Users/benjaminfrazier/Projects/RCM_Measurement_GUI/../bin/tests/tmp/DataLoggerHDF5Test_results.xml")
