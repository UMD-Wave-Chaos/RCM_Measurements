#ifndef STEPPERMOTORCONTROLLER_H
#define STEPPERMOTORCONTROLLER_H
#include <QSerialPort>
#include <QTextStream>
#include <string>

class stepperMotorController
{
	public:
        stepperMotorController(int stepDistanceIn, int runSpeedIn, std::string portnum);
        ~stepperMotorController();
		
        int connectToStepperMotor(std::string portString);
        bool closeConnection();
		bool moveStepperMotor();
		int getStepperMotorPosition();

        std::string getAvailablePorts();
        bool getConnectionStatus(){return connectionStatus;}
        int getConnectionErrors(){return cError;}

     private:
        QSerialPort serial;
        int stepDistance;
        int runSpeed;
        int cError;
        bool connectionStatus;
};

#endif //STEPPERMOTORCONTROLLER_H
