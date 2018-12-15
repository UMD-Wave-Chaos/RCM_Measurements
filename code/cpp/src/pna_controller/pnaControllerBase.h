/**
* @file pnaControllerBase.h
* @brief Header File for the pnaControllerBase class
* @details This is the base class for the PNA controllers
* @author Ben Frazier
* @date 12/13/2018*/
#ifndef PNACONTROLLER_BASE_H
#define PNACONTROLLER_BASE_H
#include <vector>
#include <string>
#include <map>
#include "clnt_find_services.h"
#include <rpc/pmap_clnt.h>
#include <arpa/inet.h>
#include "vxi11_user.h"
#include "vxi11_wrapper.h"

#include "pnaControllerInterface.h"

class pnaControllerBase:public pnaControllerInterface
{
public:
    pnaControllerBase();
    ~pnaControllerBase();

    //measurement functions
    virtual std::string connectToInstrument(std::string tcpAddress) = 0;
    virtual std::string findConnections() = 0;
    virtual void disconnect() = 0;
    virtual void getUngatedFrequencyDomainSParameters() = 0;
    virtual void getGatedFrequencyDomainSParameters(double start_time, double stop_time) = 0;
    virtual void getTimeDomainSParameters(double start_time, double stop_time) = 0;
    virtual void calibrate() = 0;
    virtual bool checkCalibration() = 0;

    virtual void initialize(double fStart, double fStop, unsigned int NOP) = 0;
    virtual bool getConnectionStatus() {return connected;}
    virtual void getXDataVector(std::vector<double> & xData) {xData = xVec; }
    virtual void getS11RVector(std::vector<double> & SR){ SR = S11RVec;}
    virtual void getS11IVector(std::vector<double> & SI){ SI = S11RVec;}
    virtual void getS12RVector(std::vector<double> & SR){ SR = S12RVec;}
    virtual void getS12IVector(std::vector<double> & SI){ SI = S12RVec;}
    virtual void getS21RVector(std::vector<double> & SR){ SR = S21RVec;}
    virtual void getS21IVector(std::vector<double> & SI){ SI = S21RVec;}
    virtual void getS22RVector(std::vector<double> & SR){ SR = S22RVec;}
    virtual void getS22IVector(std::vector<double> & SI){ SI = S22RVec;}
    virtual MeasurementType getMeasurementType(){return mType;}

protected:
    virtual void getSParameters() = 0;
    void unpackSParameters();
    bool connected;
    bool calibrated;
    std::string calibrationFileName;
    bool_t who_responded(struct sockaddr_in *addr);
    CLINK vxi_link;
    char rcvBuffer[100];
    double *dataBuffer;
    unsigned int numberOfPoints;
    unsigned int bufferSizeDoubles;
    unsigned int bufferSizeBytes;
    unsigned int measureDataTimeout;
    unsigned int calibrationTimeout;
    std::string ipAddress;
    double fStart, fStop;
    MeasurementType mType;

    std::vector<double> xVec, S11RVec, S11IVec, S12RVec, S12IVec, S21RVec, S21IVec, S22RVec, S22IVec;
};

#endif // PNACONTROLLER_BASE_H
