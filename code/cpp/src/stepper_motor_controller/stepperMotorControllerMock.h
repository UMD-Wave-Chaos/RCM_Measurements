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

    stepperMotorControllerMock(int stepDistanceIn, int runSpeedIn, std::string portnum);
    ~stepperMotorControllerMock();

    MOCK_METHOD1(connectToStepperMotor,int(std::string));
    MOCK_METHOD0(closeConnection, bool());
    MOCK_METHOD0(moveStepperMotor, bool());
    MOCK_METHOD0(getStepperMotorPosition, int());
    MOCK_METHOD0(getAvailablePorts, std::string());
    MOCK_METHOD0(getConnectionStatus, bool());
    MOCK_METHOD0(getConnectionErrors, int());


};
#endif // STEPPER_MOTOR_CONTROLLER_MOCK_H
