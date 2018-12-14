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
    bool listPorts();

    /**
     * \brief setPortConfig
     *
     * This function sets up the parameters for the stepper motor and opens the connection
     * @param port the string containing the port to connect to
     * @param numStepsIn the number of steps to move for each realization
     * @param stepRunSpeed the run speed at which to execute each step */
    void setPortConfig(std::string port, int numStepsIn, int runSpeedIn){comPort = port; numberOfSteps = numStepsIn; stepRunSpeed = runSpeedIn;}

    std::string getPort(){return comPort;}
    bool getConnected(){return connected;}
    bool getTestMode(){return testMode;}
    int getPosition();
    bool moveStepperMotor();
    QString getPortName();


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
