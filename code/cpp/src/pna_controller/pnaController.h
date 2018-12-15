/**
* @file pnaController.h
* @brief Header File for the pnaController class
* @details This class handles direct control of an Agilent PNA through the vxi11 protocol
* @author Ben Frazier
* @date 12/13/2018*/
#ifndef PNACONTROLLER_H
#define PNACONTROLLER_H
#include <vector>
#include <string>
#include <map>
#include "clnt_find_services.h"
#include <rpc/pmap_clnt.h>
#include <arpa/inet.h>
#include "vxi11_user.h"
#include "vxi11_wrapper.h"

#include "pnaControllerBase.h"

class pnaController:public pnaControllerBase
{
public:
    pnaController();
    ~pnaController();

    //measurement functions
    virtual std::string connectToInstrument(std::string tcpAddress);
    virtual std::string findConnections();
    virtual void disconnect();
    virtual void getUngatedFrequencyDomainSParameters();
    virtual void getGatedFrequencyDomainSParameters(double start_time, double stop_time);
    virtual void getTimeDomainSParameters(double start_time, double stop_time);
    virtual void calibrate();
    virtual bool checkCalibration();
    virtual void initialize(double fStart, double fStop, unsigned int NOP);

private:
    void getSParameters();
};

#endif // PNACONTROLLER_H
