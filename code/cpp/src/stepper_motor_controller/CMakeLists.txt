message("Configuring stepper motor control components")

set (stepperMotorControlLibrary_SRCS
     stepperMotorController.cpp
     stepperMotorControllerMock.cpp
     )


set(stepperMotorControlLibrary_HDRS
    stepperMotorController.h
    stepperMotorControllerMock.h
    stepperMotorControllerInterface.h
	)

add_library(stepperMotorControlLibrary ${stepperMotorControlLibrary_HDRS} ${stepperMotorControlLibrary_SRCS})
target_link_libraries(stepperMotorControlLibrary Qt5::SerialPort ${GPERFTOOLS_LIBRARIES})
