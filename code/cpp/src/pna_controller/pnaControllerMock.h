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

    MOCK_METHOD3(initialize,void(double fStart, double fStop, int NOP));
    MOCK_METHOD5(getTimeDomainSParameters, void (double* time,double* S11,double* S12,double* S21, double* S22));
    MOCK_METHOD5(getFrequencyDomainSParameters, void (double* freq,double* S11,double* S12,double* S21,double* S22));
    MOCK_METHOD0(calibrate, void());
    MOCK_METHOD0(checkCalibration, bool());

    virtual void disconnect(){connected = false;}
    virtual void connectToInstrument(std::string tcpAddress){connected = true;}
    virtual bool getConnectionStatus(){return connected;}
    virtual void findConnections(){std::cout<<"Not Connected, Running in Test Mode";}

private:
    bool connected;

};
#endif // PNA_CONTROLLER_MOCK_H
