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

    virtual void initialize(double fStart, double fStop, unsigned int NOP) = 0;
    virtual void getUngatedFrequencyDomainSParameters() = 0;
    virtual void getGatedFrequencyDomainSParameters(double start_time, double stop_time) = 0;
    virtual void getTimeDomainSParameters(double start_time, double stop_time) = 0;
    virtual void getXDataVector(std::vector<double> & xData) = 0;
    virtual void getS11RVector(std::vector<double> & SR) = 0;
    virtual void getS11IVector(std::vector<double> & SI) = 0;
    virtual void getS12RVector(std::vector<double> & SR) = 0;
    virtual void getS12IVector(std::vector<double> & SI) = 0;
    virtual void getS21RVector(std::vector<double> & SR) = 0;
    virtual void getS21IVector(std::vector<double> & SI) = 0;
    virtual void getS22RVector(std::vector<double> & SR) = 0;
    virtual void getS22IVector(std::vector<double> & SI) = 0;
    virtual void calibrate() = 0;
    virtual bool checkCalibration() = 0;
    virtual std::string getCalibrationFileName() = 0;

    virtual bool getConnectionStatus() = 0;

};

#endif // INSTRUMENT_CONTROLLER_INTERFACE_H
