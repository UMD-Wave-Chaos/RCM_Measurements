add_library(DataLogger DataLogger_HDF5.h
                       DataLoggerInterface.h
					   DataLogger_HDF5.cpp
					   DataLogger_HDF5_Vector.cpp
					   DataLogger_HDF5_Double.cpp)
					   
target_link_libraries(DataLogger ${HDF5_LIBRARIES} ${GPERFTOOLS_LIBRARIES})

add_subdirectory(tests)
