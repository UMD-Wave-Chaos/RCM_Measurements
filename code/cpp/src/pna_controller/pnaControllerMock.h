/**
* @file pnaControllerMock.h
* @brief Header File for the pnaControllerMock class
* @details This class mocks the class that controls the Agilent PNA for testing when the hardware is not present
* @author Ben Frazier
* @date 12/13/2018*/

#ifndef PNA_CONTROLLER_MOCK_H
#define PNA_CONTROLLER_MOCK_H

#include "pnaControllerInterface.h"
#include <gmock/gmock.h>
  using ::testing::Eq;
#include <gtest/gtest.h>
  using ::testing::Test;

class pnaControllerMock : public pnaControllerInterface
  {
  public:
    ~pnaControllerMock();
    pnaControllerMock();

    virtual void getUngatedFrequencyDomainSParameters();
    virtual void getGatedFrequencyDomainSParameters(double start_time, double stop_time);
    virtual void getTimeDomainSParameters(double start_time, double stop_time);
    virtual void calibrate(){calibrated = true;}
    virtual bool checkCalibration(){return calibrated;}
    virtual void initialize(double fStart, double fStop, unsigned int NOP);
    virtual void disconnect(){connected = false;}
    virtual std::string connectToInstrument(std::string tcpAddress){connected = true; return "TestMode";}
    virtual bool getConnectionStatus(){return connected;}
    virtual void findConnections(){std::cout<<"Not Connected, Running in Test Mode";}

    virtual void getXDataVector(std::vector<double> & xData) {xData = xVec; }
    virtual void getS11RVector(std::vector<double> & SR){ SR = S11RVec;}
    virtual void getS11IVector(std::vector<double> & SI){ SI = S11RVec;}
    virtual void getS12RVector(std::vector<double> & SR){ SR = S12RVec;}
    virtual void getS12IVector(std::vector<double> & SI){ SI = S12RVec;}
    virtual void getS21RVector(std::vector<double> & SR){ SR = S21RVec;}
    virtual void getS21IVector(std::vector<double> & SI){ SI = S21RVec;}
    virtual void getS22RVector(std::vector<double> & SR){ SR = S22RVec;}
    virtual void getS22IVector(std::vector<double> & SI){ SI = S22RVec;}

private:
    void getSParameters();
    void unpackSParameters();
    bool connected;
    bool calibrated;
    double *dataBuffer;
    unsigned int numberOfPoints;
    unsigned int bufferSizeDoubles;
    unsigned int bufferSizeBytes;
    std::vector<double> xVec, S11RVec, S11IVec, S12RVec, S12IVec, S21RVec, S21IVec, S22RVec, S22IVec;
};
#endif // PNA_CONTROLLER_MOCK_H
