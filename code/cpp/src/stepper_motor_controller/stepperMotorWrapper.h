/**
* @file stepperMotorWrapper.h
* @brief Header File for the stepperMotorWrapper class
* @details This is the highest level interface provided to interact with the stepper motor
* @author Ben Frazier
* @date 12/13/2018*/


#include "stepperMotorControllerInterface.h"
#include "stepperMotorControllerMock.h"
#include "stepperMotorController.h"
#include "stepperMotorExceptions.h"
#ifndef STEPPERMOTORWRAPPER_H
#define STEPPERMOTORWRAPPER_H
#include <QSerialPort>

#include "stepperMotorControllerInterface.h"

class stepperMotorWrapper
{
public:
    stepperMotorWrapper(bool mode);
    ~stepperMotorWrapper();

    bool openConnection();
    bool closeConnection();
    std::string listPorts();

    void setPortConfig(std::string port, int numStepsIn, int runSpeedIn);

    std::string getPort(){return comPort;}
    bool getConnected(){return connected;}
    bool getTestMode(){return testMode;}
    int getPosition();
    bool moveStepperMotor();
    std::string getPortName();
    int getRunSpeed(){return sObj->getRunSpeed();}
    int getStepDistance(){return sObj->getStepDistance();}

private:
    stepperMotorControllerInterface* sObj;
    std::string comPort;

    bool connected;
    bool testMode;

    int baudrate;
    int numberOfSteps;
    int stepRunSpeed;

};

#endif //STEPPERMOTORWRAPPER_H
