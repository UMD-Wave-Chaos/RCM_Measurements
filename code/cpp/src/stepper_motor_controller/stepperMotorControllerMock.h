/**
* @file stepperMotorControllerMock.h
* @brief Header File for the pnaControllerMock class
* @details This class mocks the class that controls the stepper motor for testing when the hardware is not present
* @author Ben Frazier
* @date 12/13/2018*/
#ifndef STEPPER_MOTOR_CONTROLLER_MOCK_H
#define STEPPER_MOTOR_CONTROLLER_MOCK_H

#include "stepperMotorControllerBase.h"
#include <gmock/gmock.h>
  using ::testing::Eq;
#include <gtest/gtest.h>
  using ::testing::Test;

class stepperMotorControllerMock : public stepperMotorControllerBase
  {
  public:

    stepperMotorControllerMock();
    ~stepperMotorControllerMock();

    MOCK_METHOD0(getConnectionErrors, int());

    virtual int getStepperMotorPosition();
    virtual bool moveStepperMotor();

    virtual bool getConnectionStatus(){return connected;}
    virtual bool closeConnection(){connected = false; return connected;}
    virtual int connectToStepperMotor(std::string){connected = true; return 1;}
    virtual std::string getAvailablePorts() {return "Mock Interface for Testing, no Connections";}

    virtual std::string getCurrentPortInfo(){return "Mock Interface for Testing, no Connections";}


private:
    int position;

};
#endif // STEPPER_MOTOR_CONTROLLER_MOCK_H
