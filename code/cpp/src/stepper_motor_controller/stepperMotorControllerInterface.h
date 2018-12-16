/**
* @file stepperMotorInterface.h
* @brief Header File for the stepperMotorInterface class
* @details This is the abstract interface class for the stepper motor controllers
* @author Ben Frazier
* @date 12/13/2018*/
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
    virtual std::string getCurrentPortInfo() = 0;
    virtual bool getConnectionStatus() = 0;
    virtual int getConnectionErrors() = 0;
    virtual void setRunSpeed(int rs) = 0;
    virtual void setStepDistance(int sd) = 0;

    virtual int getStepDistance() = 0;
    virtual int getRunSpeed() = 0;

};

#endif // STEPPER_MOTOR_CONTROLLER_INTERFACE_H
