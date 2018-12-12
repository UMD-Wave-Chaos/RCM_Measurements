#ifndef PNA_CONTROLLER_INTERFACE_H
#define PNA_CONTROLLER_INTERFACE_H

#include <vector>
#include <iostream>

class pnaControllerInterface
{
public:

    virtual ~pnaControllerInterface() = 0;
    //measurement functions
    virtual void connectToInstrument() = 0;
    virtual void initialize(double fStart, double fStop, int NOP) = 0;
    virtual void getTimeDomainSParameters(double* time,
                                  double* S11,
                                  double* S12,
                                  double* S21,
                                  double* S22) = 0;

    virtual void getFrequencyDomainSParameters(double* freq,
                                        double* S11,
                                        double* S12,
                                        double* S21,
                                        double* S22) = 0;
    virtual void calibrate() = 0;
    virtual bool checkCalibration() = 0;

    virtual std::vector<double> getFrequencyRange() = 0;
    virtual bool getConnectionStatus() = 0;
};

#endif // PNA_CONTROLLER_INTERFACE_H
