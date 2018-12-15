/**
* @file stepperMotorControllerMock.cpp
* @brief Implementation of the pnaControllerMock class
* @details This class mocks the class that controls the stepper motor for testing when the hardware is not present
* @author Ben Frazier
* @date 12/13/2018*/
#include "stepperMotorControllerMock.h"

/**
 * \brief constructor
 *
 * primary constructor for the mock stepper motor interface*/
stepperMotorControllerMock::stepperMotorControllerMock()
{
    position = 0;
}

/**
 * \brief destructor
 *
 * primary destructor for the mock stepper motor interface*/
stepperMotorControllerMock::~stepperMotorControllerMock()
{

}

/**
 * \brief getStepperMotorPosition
 *
 * This function gets the motor position for the mock interface*/
int stepperMotorControllerMock::getStepperMotorPosition()
{
    position += 10;
    return position;
}

/**
* \brief moveStepperMotor
*
* This function moves the motor position for the mock interface*/
bool stepperMotorControllerMock::moveStepperMotor()
{
  position += stepDistance;
   return true;
}
