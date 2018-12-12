#ifndef STEPPER_MOTOR_CONTROLLER_INTERFACE_H
#define STEPPER_MOTOR_CONTROLLER_INTERFACE_H

#include <string>
#include <iostream>

class stepperMotorControllerInterface
{
public:
    virtual ~stepperMotorControllerInterface() = 0;
    virtual int connectToStepperMotor(std::string portString) = 0;
    virtual bool closeConnection() = 0;
    virtual bool moveStepperMotor() = 0;
    virtual int getStepperMotorPosition() = 0;

    virtual std::string getAvailablePorts() = 0;
    virtual bool getConnectionStatus() = 0;
    virtual int getConnectionErrors() = 0;
};

#endif // STEPPER_MOTOR_CONTROLLER_INTERFACE_H
