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

    MOCK_METHOD2(initialize,void(double fStart, double fStop));
    MOCK_METHOD0(connectToInstrument,void());
    MOCK_METHOD5(getTimeDomainSParameters, void (double* time,double* S11,double* S12,double* S21, double* S22));
    MOCK_METHOD5(getFrequencyDomainSParameters, void (double* freq,double* S11,double* S12,double* S21,double* S22));
    MOCK_METHOD0(calibrate, void());
    MOCK_METHOD0(checkCalibration, bool());
    MOCK_METHOD0(getFrequencyRange,std::vector<double>());
    MOCK_METHOD0(getConnectionStatus, bool());

};
#endif // PNA_CONTROLLER_MOCK_H
