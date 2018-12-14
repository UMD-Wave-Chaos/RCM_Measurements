message("Configuring stepper motor control components")

set (stepperMotorControlLibrary_SRCS
     stepperMotorController.cpp
     stepperMotorControllerMock.cpp
     stepperMotorControllerInterface.cpp
     stepperMotorWrapper.cpp
     )


set(stepperMotorControlLibrary_HDRS
    stepperMotorController.h
    stepperMotorControllerMock.h
    stepperMotorControllerInterface.h
    stepperMotorWrapper.h
    stepperMotorExceptions.h
	)

add_library(stepperMotorControlLibrary ${stepperMotorControlLibrary_HDRS} ${stepperMotorControlLibrary_SRCS})
target_link_libraries(stepperMotorControlLibrary Qt5::SerialPort ${GPERFTOOLS_LIBRARIES} gmock_main)

add_subdirectory(tests)
