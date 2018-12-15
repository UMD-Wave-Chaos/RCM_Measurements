message("Configuring measurement control components")

set (measurementControlLibrary_SRCS
     measurementController.cpp
     measurementSettings.cpp
     )


set(measurementControlLibrary_HDRS
        measurementController.h
        measurementModes.h
        measurementSettings.h)

add_library(measurementControlLibrary ${measurementControlLibrary_HDRS} ${measurementControlLibrary_SRCS})
target_link_libraries(measurementControlLibrary ${GPERFTOOLS_LIBRARIES}
                                                 DataLogger
                                                 pnaControllerLibrary
                                                 stepperMotorControlLibrary
                                                 utilityLibrary)

add_subdirectory(tests)
