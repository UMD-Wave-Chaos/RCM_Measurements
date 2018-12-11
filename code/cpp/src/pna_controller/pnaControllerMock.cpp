#include "pnaControllerMock.h"

#include <random>

pnaControllerMock::pnaControllerMock()
{
   connected = false;
   frequencyRange.reserve(2);
   calibrationFileName = "";
   calibrated = false;
}

pnaControllerMock::~pnaControllerMock()
{
    if (S11R!= nullptr)
        delete S11R;
    if (S12R!= nullptr)
        delete S12R;
    if (S21R!= nullptr)
        delete S21R;
    if (S22R!= nullptr)
        delete S22R;
    if (S11I!= nullptr)
        delete S11I;
    if (S12I!= nullptr)
        delete S12I;
    if (S21I!= nullptr)
        delete S21I;
    if (S22I!= nullptr)
        delete S22I;
    if (timeData!= nullptr)
        delete timeData;
    if (freqData!= nullptr)
        delete freqData;
}

bool pnaControllerMock::initialize(double fStart, double fStop)
{
    connected = true;
    calibrated = true;
    calibrationFileName = "fakeCalFile";
    return true;
}

bool pnaControllerMock::getTimeDomainSParameters(double* time,double* S11R,double* S12R,double* S21R, double* S22R, double* S11I,double* S12I,double* S21I, double* S22I,size_t nPoints)
{

    std::normal_distribution<double> distribution(0,5);

    for(size_t val = 0; val < nPoints; val++)
    {
        time[val] = static_cast<double>(val)*1.0e-6/1.234;
        S11R[val] = distribution(generator);
        S12R[val] = distribution(generator);
        S21R[val] = distribution(generator);
        S22R[val] = distribution(generator);
        S11I[val] = distribution(generator);
        S12I[val] = distribution(generator);
        S21I[val] = distribution(generator);
        S22I[val] = distribution(generator);
    }
    return true;
}

bool pnaControllerMock::getFrequencyDomainSParameters (double* freq,double* S11R,double* S12R,double* S21R, double* S22R, double* S11I,double* S12I,double* S21I, double* S22I,size_t nPoints)
{
    std::normal_distribution<double> distribution(0,5);

    for(size_t val = 0; val < nPoints; val++)
    {
        freq[val] = static_cast<double>(val)*4.0e6+ 9.5e9;
        S11R[val] = distribution(generator);
        S12R[val] = distribution(generator);
        S21R[val] = distribution(generator);
        S22R[val] = distribution(generator);
        S11I[val] = distribution(generator);
        S12I[val] = distribution(generator);
        S21I[val] = distribution(generator);
        S22I[val] = distribution(generator);
    }
    return true;
}

bool pnaControllerMock::resizeArrays(int numberOfPoints)
{
    if (S11R!= nullptr)
        delete S11R;
    if (S12R!= nullptr)
        delete S12R;
    if (S21R!= nullptr)
        delete S21R;
    if (S22R!= nullptr)
        delete S22R;
    if (S11I!= nullptr)
        delete S11I;
    if (S12I!= nullptr)
        delete S12I;
    if (S21I!= nullptr)
        delete S21I;
    if (S22I!= nullptr)
        delete S22I;
    if (timeData!= nullptr)
        delete timeData;
    if (freqData!= nullptr)
        delete freqData;

    S11R = new double[numberOfPoints];
    S12R = new double[numberOfPoints];
    S21R = new double[numberOfPoints];
    S22R = new double[numberOfPoints];
    S11I = new double[numberOfPoints];
    S12I = new double[numberOfPoints];
    S21I = new double[numberOfPoints];
    S22I = new double[numberOfPoints];
    timeData = new double[numberOfPoints];
    freqData = new double[numberOfPoints];

    return true;
}
