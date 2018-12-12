#ifndef STEPPERMOTORCONTROLLER_H
#define STEPPERMOTORCONTROLLER_H
#include <QSerialPort>
#include <QTextStream>
#include <string>

#include "stepperMotorControllerInterface.h"

class stepperMotorController: public stepperMotorControllerInterface
{
	public:
        stepperMotorController(int stepDistanceIn, int runSpeedIn, std::string portnum);
        virtual ~stepperMotorController();
		
        virtual int connectToStepperMotor(std::string portString);
        virtual bool closeConnection();
        virtual bool moveStepperMotor();
        virtual int getStepperMotorPosition();

        virtual std::string getAvailablePorts();
        virtual bool getConnectionStatus(){return connectionStatus;}
        virtual int getConnectionErrors(){return cError;}

     private:
        QSerialPort serial;
        int stepDistance;
        int runSpeed;
        int cError;
        bool connectionStatus;
};

#endif //STEPPERMOTORCONTROLLER_H
