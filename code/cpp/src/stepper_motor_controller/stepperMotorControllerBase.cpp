#include "stepperMotorController.h"
#include <QSerialPortInfo>
#include <iostream>

#include "stepperMotorControllerBase.h"

stepperMotorControllerBase::stepperMotorControllerBase()
{
    cError = 0;
    connected = false;
}

stepperMotorControllerBase::~stepperMotorControllerBase()
{

}


