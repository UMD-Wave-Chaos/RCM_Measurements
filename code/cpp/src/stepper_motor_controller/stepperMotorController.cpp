/**
* @file stepperMotorController.cpp
* @brief Implementation of the stepperMotorController class
* @details This class handles direct control of a stepper motor through a serial port
* @author Ben Frazier
* @date 12/13/2018*/

#include "stepperMotorController.h"
#include <QSerialPortInfo>
#include <iostream>

#include "stepperMotorController.h"

stepperMotorController::stepperMotorController()
{
}

stepperMotorController::~stepperMotorController()
{
    if (connected == true)
     closeConnection();
}

bool stepperMotorController::closeConnection()
{
    if (serial.isOpen())
        serial.close();

    return true;
}

std::string stepperMotorController::getCurrentPortInfo()
{

    return serial.portName().toStdString();
}


std::string stepperMotorController::getAvailablePorts()
{
    std::string rString;
    std::string yString = "Yes";
    std::string nString = "No";

    const auto serialPortInfos = QSerialPortInfo::availablePorts();
    rString = "Total number of ports available: " + std::to_string(serialPortInfos.count()) + "\n";

    const QString blankString = "N/A";
    QString description;
    QString manufacturer;
    QString serialNumber;
    int counter = 1;

    for (const QSerialPortInfo &serialPortInfo : serialPortInfos)
    {
        description = serialPortInfo.description();
        manufacturer = serialPortInfo.manufacturer();
        serialNumber = serialPortInfo.serialNumber();

        rString += "Port: " + std::to_string(counter) + " " +  serialPortInfo.portName().toStdString() + "     ";
        rString += "Location: " + serialPortInfo.systemLocation().toStdString() + "     ";
        rString += "Description: " +  (!description.isEmpty() ? description.toStdString() : blankString.toStdString()) + "     ";
        rString += "Manufacturer: " + (!manufacturer.isEmpty() ? manufacturer.toStdString()  : blankString.toStdString() ) + "     ";
        rString += "Serial number: "  + (!serialNumber.isEmpty() ? serialNumber.toStdString()  : blankString.toStdString() ) +"     ";
        rString +=  "Vendor Identifier: "  + (serialPortInfo.hasVendorIdentifier()
                                         ? QByteArray::number(serialPortInfo.vendorIdentifier(), 16).toStdString()
                                         : blankString.toStdString() ) + "     ";
        rString += "Product Identifier: " + (serialPortInfo.hasProductIdentifier()
                                          ? QByteArray::number(serialPortInfo.productIdentifier(), 16).toStdString()
                                          : blankString.toStdString() ) + "     ";
        rString += "Busy: " + (serialPortInfo.isBusy() ? yString: nString)+ "\n";

        counter++;
      }

    return rString;

}
		
int stepperMotorController::connectToStepperMotor(std::string portString)
{
    QString qPortString = QString::fromUtf8(portString.c_str());
    serial.setPortName(qPortString);
    serial.setBaudRate(QSerialPort::Baud57600);
    serial.setDataBits(QSerialPort::Data8);
    serial.setParity(QSerialPort::NoParity);
    serial.setStopBits(QSerialPort::OneStop);
    serial.setFlowControl(QSerialPort::NoFlowControl);

    if (!serial.open(QIODevice::ReadWrite))
    {
        connected = false;
    }
    else
    {
        connected = true;
    }

    getStepperMotorPosition();



    return serial.error();
}

bool stepperMotorController::moveStepperMotor()
{

    /*command parameters for I (index) are:
    %distance, run speed, start speed, end speed, accel rate, decel rate,
    %run current, hold current, accel current, delay, step mode*/

    std::string sString = "I " + std::to_string(stepDistance) + ","+ std::to_string(runSpeed);
    sString += ",0,0,500,500,1000,0,1000,1000,50,64\r";

    serial.write(sString.c_str());
    serial.flush();
    serial.waitForBytesWritten(1000);

	return true;
}

int stepperMotorController::getStepperMotorPosition()
{
    serial.write("l\r");
    serial.flush();
    serial.waitForBytesWritten(10);
    serial.waitForReadyRead(10);
    QByteArray requestData = serial.readAll();
    std::string dataStringFull = requestData.toStdString();

    std::size_t found_l = dataStringFull.find("l");
    std::size_t found_r = dataStringFull.find("\r");
    std::string dataString = dataStringFull.substr(found_l+1,found_r-found_l);
    return atoi(dataString.c_str());
}
