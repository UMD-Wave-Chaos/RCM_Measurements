/**
* @file stepperMotorController.h
* @brief Header File for the stepperMotorController class
* @details This class handles direct control of a stepper motor through a serial port
* @author Ben Frazier
* @date 12/13/2018*/
#ifndef STEPPERMOTORCONTROLLER_H
#define STEPPERMOTORCONTROLLER_H
#include <QSerialPort>
#include <QTextStream>
#include <string>

#include "stepperMotorControllerBase.h"

class stepperMotorController: public stepperMotorControllerBase
{
	public:
        stepperMotorController();
        virtual ~stepperMotorController();
		
        virtual int connectToStepperMotor(std::string portString);
        virtual bool closeConnection();
        virtual bool moveStepperMotor();
        virtual int getStepperMotorPosition();
        virtual std::string getCurrentPortInfo();
        virtual std::string getAvailablePorts();


     private:
        QSerialPort serial;
};

#endif //STEPPERMOTORCONTROLLER_H
