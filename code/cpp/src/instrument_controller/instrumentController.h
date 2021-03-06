/**
* @file instrumentController.h
* @brief Header File for the instrumentController class
* @details This class handles direct control of an abstract instrument through the vxi11 protocol
* @author Ben Frazier
* @date 04/17/2019*/
#ifndef INSTRUMENT_CONTROLLER_H
#define INSTRUMENT_CONTROLLER_H
#include <vector>
#include <string>
#include <map>
#include "clnt_find_services.h"
#include <rpc/pmap_clnt.h>
#include <arpa/inet.h>
#include "vxi11_user.h"
#include "vxi11_wrapper.h"

#include "instrumentControllerBase.h"
#include "instrumentExceptions.h"

class instrumentController:public instrumentControllerBase
{
public:
    instrumentController();
    ~instrumentController();

    //measurement functions
    virtual std::string connectToInstrument(std::string tcpAddress);
    virtual std::string getConnectionIpAddress(int count);
    virtual std::string findConnections();
    virtual void disconnect();
    virtual void sendCommand(std::string inputString);
    virtual std::string sendQuery(std::string inputString);
    virtual void getData(double *buffer, unsigned int bufferSizeBytes, unsigned int measureDataTimeout);

};

#endif // INSTRUMENT_CONTROLLER_H
