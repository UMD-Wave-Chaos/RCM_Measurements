#include "pnaController.h"

pnaController::pnaController()
{
   connected = false;
   frequencyRange.reserve(2);
   calibrationFileName = "";
   calibrated = false;
}


void pnaController::connectToInstrument()
{
      //establish the connection

    //check whether or not we've been calibrated
    checkCalibration();
}

void pnaController::initialize(double fStart, double fStop)
{
    frequencyRange[0] = fStart;
    frequencyRange[1] = fStop;
    //establish the connection

    //initialize the PNA

    //check whether or not we've been calibrated
    checkCalibration();
}


bool pnaController::checkCalibration()
{
    //check whether or not we've been calibrated

    return calibrated;
}

void pnaController::getTimeDomainSParameters(double* time,
                                              double* S11,
                                              double* S12,
                                              double* S21,
                                              double* S22)
{

}

void pnaController::getFrequencyDomainSParameters(double* freq,
                                                   double* S11,
                                                   double* S12,
                                                   double* S21,
                                                   double* S22)
{

}


void pnaController::calibrate()
{

}
