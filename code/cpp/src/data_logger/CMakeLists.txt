set(Data_Logger_SRCS         DataLogger_HDF5.h
                             DataLoggerInterface.h
                             DataLogger_HDF5.cpp
                             DataLogger_HDF5_Vector.cpp
                             DataLogger_HDF5_Double.cpp)

add_library(DataLogger ${Data_Logger_SRCS})
source_group("HDF5"            FILES ${Data_Logger_SRCS})
					   
target_link_libraries(DataLogger ${HDF5_LIBRARIES} ${GPERFTOOLS_LIBRARIES})

add_subdirectory(tests)
