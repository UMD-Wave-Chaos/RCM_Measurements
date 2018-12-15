/**
* @file pnaControllerMock.h
* @brief Header File for the pnaControllerMock class
* @details This class mocks the class that controls the Agilent PNA for testing when the hardware is not present
* @author Ben Frazier
* @date 12/13/2018*/

#ifndef PNA_CONTROLLER_MOCK_H
#define PNA_CONTROLLER_MOCK_H

#include "pnaControllerBase.h"
#include <gmock/gmock.h>
  using ::testing::Eq;
#include <gtest/gtest.h>
  using ::testing::Test;

class pnaControllerMock : public pnaControllerBase
  {
  public:
    ~pnaControllerMock();
    pnaControllerMock();

    virtual void getUngatedFrequencyDomainSParameters();
    virtual void getGatedFrequencyDomainSParameters(double start_time, double stop_time);
    virtual void getTimeDomainSParameters(double start_time, double stop_time);
    virtual void calibrate(){calibrated = true;}
    virtual bool checkCalibration(){return calibrated;}
    virtual void disconnect(){connected = false;}
    virtual std::string connectToInstrument(std::string tcpAddress){connected = true; return "TestMode";}
    virtual std::string findConnections(){return "Not Connected, Running in Test Mode";}
    virtual void initialize(double fStart, double fStop, unsigned int NOP);

private:
   void getSParameters();

};
#endif // PNA_CONTROLLER_MOCK_H
