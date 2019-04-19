/**
* @file instrumentControllerInterface.h
* @brief Header File for the instrumentControllerInterface class
* @details This is the abstract interface class for the abstract instrument controllers
* @author Ben Frazier
* @date 12/13/2018*/

#ifndef INSTRUMENT_CONTROLLER_INTERFACE_H
#define INSTRUMENT_CONTROLLER_INTERFACE_H

#include <vector>
#include <iostream>

class instrumentControllerInterface
{
public:

    virtual ~instrumentControllerInterface() = 0;
    //measurement functions
    virtual std::string connectToInstrument(std::string tcpAddress) = 0;
    virtual std::string findConnections() = 0;
    virtual std::string getConnectionIpAddress(int count)=0;
    virtual void disconnect() = 0;
    virtual void sendCommand(std::string inputString) = 0;
    virtual std::string sendQuery(std::string inputString) = 0;
    virtual void getData(double *buffer, unsigned int bufferSizeBytes, unsigned int measureDataTimeout) = 0;

    virtual bool getConnectionStatus() = 0;

};

#endif // INSTRUMENT_CONTROLLER_INTERFACE_H
