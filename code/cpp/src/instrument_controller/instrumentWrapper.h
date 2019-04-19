/**
* @file instrumentWrapper.h
* @brief Header File for the instrumentWrapper class
* @details This is the highest level interface provided to interact with abstract instruments
* @author Ben Frazier
* @date 04/17/2019*/

#ifndef INSTRUMENT_WRAPPER_H
#define INSTRUMENT_WRAPPER_H
#include "instrumentControllerInterface.h"
#include "instrumentControllerMock.h"
#include "instrumentController.h"
#include "instrumentExceptions.h"

#include <vector>
#include <string>

class instrumentWrapper
{
public:
    instrumentWrapper(bool mode);
    ~instrumentWrapper();

    std::string openConnection(std::string address);
    bool closeConnection();
    std::string findClients();
    void sendCommand(std::string inputString);
    std::string sendQuery(std::string inputString);
    void getData(double *buffer, unsigned int bufferSizeBytes, unsigned int measureDataTimeout);
    std::string getConnectionIpAddress(int count);
    std::string getIpAddress(){return ipAddress;}
    bool getConnected(){return connected;}
    bool getTestMode(){return testMode;}
    std::string getInstrumentDeviceString(){return instDeviceString;}

private:
    void setIpAddress(std::string address){ipAddress = address;}

    instrumentControllerInterface* instObj;
    std::string ipAddress;

    bool connected;
    bool testMode;
    std::string instDeviceString;


};

#endif //INSTRUMENT_WRAPPER_H
