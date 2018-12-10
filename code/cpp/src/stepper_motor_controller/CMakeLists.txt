message("Configuring stepper motor control components")

set (stepperMotorControlLibrary_SRCS
     stepperMotorController.cpp
     )


set(stepperMotorControlLibrary_HDRS
    stepperMotorController.h
	)

add_library(stepperMotorControlLibrary ${stepperMotorControlLibrary_HDRS} ${stepperMotorControlLibrary_SRCS})
target_link_libraries(stepperMotorControlLibrary Qt5::SerialPort ${GPERFTOOLS_LIBRARIES})
