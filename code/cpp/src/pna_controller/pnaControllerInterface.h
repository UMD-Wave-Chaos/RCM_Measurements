/**
* @file pnaControllerInterface.h
* @brief Header File for the pnaControllerInterface class
* @details This is the base class for the PNA controllers
* @author Ben Frazier
* @date 12/13/2018*/

#ifndef PNA_CONTROLLER_INTERFACE_H
#define PNA_CONTROLLER_INTERFACE_H

#include <vector>
#include <iostream>

class pnaControllerInterface
{
public:

    virtual ~pnaControllerInterface() = 0;
    //measurement functions
    virtual void connectToInstrument(std::string tcpAddress) = 0;
    virtual void findConnections() = 0;
    virtual void disconnect() = 0;
    virtual void initialize(double fStart, double fStop, int NOP) = 0;
    virtual void getUngatedFrequencyDomainSParameters(std::vector<double> &freq, std::vector<double> &S11R, std::vector<double> &S11I,
                                                      std::vector<double> &S12R, std::vector<double> &S12I, std::vector<double> &S21R,
                                                      std::vector<double> &S21I, std::vector<double> &S22R, std::vector<double> &S22I) = 0;
    virtual void getGatedFrequencyDomainSParameters(std::vector<double> &freq, std::vector<double> &S11R, std::vector<double> &S11I,
                                                    std::vector<double> &S12R, std::vector<double> &S12I, std::vector<double> &S21R,
                                                    std::vector<double> &S21I, std::vector<double> &S22R, std::vector<double> &S22I) = 0;
    virtual void getTimeDomainSParameters(std::vector<double> &time, std::vector<double> &S11R, std::vector<double> &S11I,
                                          std::vector<double> &S12R, std::vector<double> &S12I, std::vector<double> &S21R,
                                          std::vector<double> &S21I, std::vector<double> &S22R, std::vector<double> &S22I) = 0;
    virtual void calibrate() = 0;
    virtual bool checkCalibration() = 0;

    virtual bool getConnectionStatus() = 0;
};

#endif // PNA_CONTROLLER_INTERFACE_H
