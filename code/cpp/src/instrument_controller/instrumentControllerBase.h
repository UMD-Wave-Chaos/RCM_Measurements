/**
* @file instrumentControllerBase.h
* @brief Header File for the instrumentControllerBase class
* @details This is the base class for the abstract instrument controllers
* @author Ben Frazier
* @date 04/17/2019*/
#ifndef INSTRUMENT_CONTROLLER_BASE_H
#define INSTRUMENT_CONTROLLER_BASE_H
#include <vector>
#include <string>
#include <map>
#include "clnt_find_services.h"
#include <rpc/pmap_clnt.h>
#include <arpa/inet.h>
#include "vxi11_user.h"
#include "vxi11_wrapper.h"

#include "instrumentControllerInterface.h"

class instrumentControllerBase:public instrumentControllerInterface
{
public:
    instrumentControllerBase();
    ~instrumentControllerBase();

    //measurement functions
    virtual std::string connectToInstrument(std::string tcpAddress) = 0;
    virtual std::string findConnections() = 0;
    virtual void disconnect() = 0;
    virtual bool getConnectionStatus() {return connected;}

protected:
    bool connected;
    bool_t who_responded(struct sockaddr_in *addr);
    CLINK vxi_link;
    char rcvBuffer[100];
    std::string ipAddress;


};

#endif // INSTRUMENT_CONTROLLER_BASE_H
