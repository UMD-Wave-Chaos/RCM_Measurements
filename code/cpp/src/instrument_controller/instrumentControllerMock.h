/**
* @file instrumentControllerMock.h
* @brief Header File for the instrumentControllerMock class
* @details This class mocks the class that controls the abstract instrument testing when the hardware is not present
* @author Ben Frazier
* @date 04/17/2019*/

#ifndef INSTRUMENT_CONTROLLER_MOCK_H
#define INSTRUMENT_CONTROLLER_MOCK_H

#include "instrumentControllerBase.h"
#include <gmock/gmock.h>
  using ::testing::Eq;
#include <gtest/gtest.h>
  using ::testing::Test;
#include <random>

class instrumentControllerMock : public instrumentControllerBase
  {
  public:
    ~instrumentControllerMock();
    instrumentControllerMock();

    virtual std::string getConnectionIpAddress(int count){return "Not Connected, Running in Test Mode";}
    virtual void getUngatedFrequencyDomainSParameters();
    virtual void getGatedFrequencyDomainSParameters(double start_time, double stop_time);
    virtual void getTimeDomainSParameters(double start_time, double stop_time);
    virtual void calibrate(){calibrated = true;}
    virtual bool checkCalibration(){return calibrated;}
    virtual void disconnect(){connected = false;}
    virtual void sendCommand(std::string inputString){;}
    virtual std::string sendQuery(std::string inputString){return "Not Connected, Running in Test Mode";}
    virtual void getData(double *buffer, unsigned int bufferSizeBytes, unsigned int measureDataTimeout){;};

    virtual std::string connectToInstrument(std::string tcpAddress){connected = true; return "TestMode";}
    virtual std::string findConnections(){return "Not Connected, Running in Test Mode";}
    virtual void initialize(double fStart, double fStop, unsigned int NOP);

private:
   void getSParameters();

   std::normal_distribution<double> normal;
   std::default_random_engine generator;
};
#endif // INSTRUMENT_CONTROLLER_MOCK_H
