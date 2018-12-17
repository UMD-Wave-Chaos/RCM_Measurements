#include "stepperMotorController.h"
#include <QSerialPortInfo>
#include <iostream>

#include "stepperMotorControllerBase.h"

stepperMotorControllerBase::stepperMotorControllerBase()
{
    cError = 0;
    connected = false;
    runSpeed = 0;
    stepDistance = 0;
    deviceString = "Not Connected";
}

stepperMotorControllerBase::~stepperMotorControllerBase()
{

}

