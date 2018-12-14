#ifndef STEPPER_MOTOR_CONTROLLER_MOCK_H
#define STEPPER_MOTOR_CONTROLLER_MOCK_H

#include "stepperMotorControllerInterface.h"
#include <gmock/gmock.h>
  using ::testing::Eq;
#include <gtest/gtest.h>
  using ::testing::Test;

class stepperMotorControllerMock : public stepperMotorControllerInterface
  {
  public:

    stepperMotorControllerMock();
    ~stepperMotorControllerMock();

    MOCK_METHOD0(moveStepperMotor, bool());
    MOCK_METHOD0(getStepperMotorPosition, int());
    MOCK_METHOD0(getConnectionErrors, int());

    virtual bool getConnectionStatus(){return connected;}
    virtual bool closeConnection(){connected = false; return connected;}
    virtual int connectToStepperMotor(std::string){connected = true; return 1;}
    virtual std::string getAvailablePorts() {return "Mock Interface for Testing, no Connections";}

    virtual QString getCurrentPortInfo(){return "Mock Interface for Testing, no Connections";}

private:
    bool connected;

};
#endif // STEPPER_MOTOR_CONTROLLER_MOCK_H
