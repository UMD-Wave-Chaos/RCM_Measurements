#ifndef PNACONTROLLER_H
#define PNACONTROLLER_H
#include <vector>
#include <string>

#include "pnaControllerInterface.h"

class pnaController:public pnaControllerInterface
{
public:
    pnaController();

    //measurement functions
    virtual void connectToInstrument();
    virtual void initialize(double fStart, double fStop);
    virtual void getTimeDomainSParameters(double* time,
                                  double* S11,
                                  double* S12,
                                  double* S21,
                                  double* S22);

    virtual void getFrequencyDomainSParameters(double* freq,
                                        double* S11,
                                        double* S12,
                                        double* S21,
                                        double* S22);
    virtual void calibrate();
    virtual bool checkCalibration();

    virtual std::vector<double> getFrequencyRange(){return frequencyRange;}
    virtual bool getConnectionStatus() {return connected;}

private:
    std::vector<double> frequencyRange;
    bool connected;
    bool calibrated;
    std::string calibrationFileName;
};

#endif // PNACONTROLLER_H
