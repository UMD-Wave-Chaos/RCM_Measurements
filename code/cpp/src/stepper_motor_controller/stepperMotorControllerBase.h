/**
* @file stepperMotorControllerBase.h
* @brief Header File for the stepperMotorControllerBase class
* @details This is the base class for the stepper motor controller
* @author Ben Frazier
* @date 12/13/2018*/
#ifndef STEPPERMOTORCONTROLLER_BASE_H
#define STEPPERMOTORCONTROLLER_BASE_H

#include <string>

#include "stepperMotorControllerInterface.h"

class stepperMotorControllerBase: public stepperMotorControllerInterface
{
	public:
        stepperMotorControllerBase();
        virtual ~stepperMotorControllerBase();
		
        virtual int connectToStepperMotor(std::string portString) = 0;
        virtual bool closeConnection() = 0;
        virtual bool moveStepperMotor() = 0;
        virtual int getStepperMotorPosition() = 0;
        virtual std::string getCurrentPortInfo() = 0;
        virtual std::string getAvailablePorts() = 0;

        virtual bool getConnectionStatus(){return connected;}
        virtual int getConnectionErrors(){return cError;}
        virtual void setRunSpeed(int rs){runSpeed = rs;}
        virtual void setStepDistance(int sd){stepDistance = sd;}

     protected:
        int stepDistance;
        int runSpeed;
        int cError;
        bool connected;
};

#endif //STEPPERMOTORCONTROLLER_BASE_H
