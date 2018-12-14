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

    virtual void getUngatedFrequencyDomainSParameters(std::vector<double> &freq, std::vector<double> &S11R, std::vector<double> &S11I,
                                                      std::vector<double> &S12R, std::vector<double> &S12I, std::vector<double> &S21R,
                                                      std::vector<double> &S21I, std::vector<double> &S22R, std::vector<double> &S22I);
    virtual void getGatedFrequencyDomainSParameters(std::vector<double> &freq, std::vector<double> &S11R, std::vector<double> &S11I,
                                                    std::vector<double> &S12R, std::vector<double> &S12I, std::vector<double> &S21R,
                                                    std::vector<double> &S21I, std::vector<double> &S22R, std::vector<double> &S22I);
    virtual void getTimeDomainSParameters(std::vector<double> &time, std::vector<double> &S11R, std::vector<double> &S11I,
                                          std::vector<double> &S12R, std::vector<double> &S12I, std::vector<double> &S21R,
                                          std::vector<double> &S21I, std::vector<double> &S22R, std::vector<double> &S22I);
    virtual void calibrate(){calibrated = true;}
    virtual bool checkCalibration(){return calibrated;}
    virtual void initialize(double fStart, double fStop, int NOP);
    virtual void disconnect(){connected = false;}
    virtual void connectToInstrument(std::string tcpAddress){connected = true;}
    virtual bool getConnectionStatus(){return connected;}
    virtual void findConnections(){std::cout<<"Not Connected, Running in Test Mode";}

private:
    void getSParameters();
    void unpackSParameters(std::vector<double> &xData, std::vector<double> &S11R, std::vector<double> &S11I,
                           std::vector<double> &S12R, std::vector<double> &S12I, std::vector<double> &S21R,
                           std::vector<double> &S21I, std::vector<double> &S22R, std::vector<double> &S22I);
    bool connected;
    bool calibrated;
    double *dataBuffer;
    int bufferSize;

};
#endif // PNA_CONTROLLER_MOCK_H
