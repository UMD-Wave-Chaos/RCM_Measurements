/**
* @file pnaControllerMock.cpp
* @brief Implementation of the pnaControllerMock class
* @details This class mocks the class that controls the Agilent PNA for testing when the hardware is not present
* @author Ben Frazier
* @date 12/13/2018*/

#include "pnaControllerMock.h"
#include <random>

pnaControllerMock::pnaControllerMock()
{
    connected = false;

    numberOfPoints = 32001;
    bufferSizeDoubles = numberOfPoints*9;
    bufferSizeBytes = bufferSizeDoubles*8;

    dataBuffer = new double[bufferSizeDoubles];

    calibrated = false;
}

pnaControllerMock::~pnaControllerMock()
{
    delete dataBuffer;
}


void pnaControllerMock::initialize(double fStart, double fStop, unsigned int NOP)
{
    numberOfPoints = NOP;
    bufferSizeDoubles = numberOfPoints*9;
    bufferSizeBytes = bufferSizeDoubles*8;

    delete dataBuffer;
    dataBuffer = new double[bufferSizeDoubles];
}

void pnaControllerMock::getGatedFrequencyDomainSParameters(double start_time, double stop_time)
{
    getSParameters();
    unpackSParameters();
}

void pnaControllerMock::getTimeDomainSParameters(double start_time, double stop_time)
{
    getSParameters();
    unpackSParameters();
}

void pnaControllerMock::getUngatedFrequencyDomainSParameters()
{
    getSParameters();
    unpackSParameters();
}

void pnaControllerMock::getSParameters()
{

    std::normal_distribution<double> normal;
    std::default_random_engine generator;

    for (int cnt = 0; cnt < numberOfPoints; cnt++)
    {
        dataBuffer[cnt] = static_cast<double>(cnt)/4.5e6;
        dataBuffer[cnt + numberOfPoints] = normal(generator);
        dataBuffer[cnt + 2*numberOfPoints] = normal(generator);
        dataBuffer[cnt + 3*numberOfPoints] = normal(generator);
        dataBuffer[cnt + 4*numberOfPoints] = normal(generator);
        dataBuffer[cnt + 5*numberOfPoints] = normal(generator);
        dataBuffer[cnt + 6*numberOfPoints] = normal(generator);
        dataBuffer[cnt + 7*numberOfPoints] = normal(generator);
        dataBuffer[cnt + 8*numberOfPoints] = normal(generator);
    }

}

void pnaControllerMock::unpackSParameters()
{
    xVec.clear();
    S11RVec.clear();
    S11IVec.clear();
    S12RVec.clear();
    S12IVec.clear();
    S21RVec.clear();
    S21IVec.clear();
    S22RVec.clear();
    S22IVec.clear();

    //TBD - fix sizing
    for (int cnt = 0; cnt < numberOfPoints; cnt++)
    {
        xVec.push_back(dataBuffer[cnt]);
        S11RVec.push_back(dataBuffer[cnt + numberOfPoints]);
        S11IVec.push_back(dataBuffer[cnt + 2*numberOfPoints]);
        S12RVec.push_back(dataBuffer[cnt + 3*numberOfPoints]);
        S12IVec.push_back(dataBuffer[cnt + 4*numberOfPoints]);
        S21RVec.push_back(dataBuffer[cnt + 5*numberOfPoints]);
        S21IVec.push_back(dataBuffer[cnt + 6*numberOfPoints]);
        S22RVec.push_back(dataBuffer[cnt + 7*numberOfPoints]);
        S22IVec.push_back(dataBuffer[cnt + 8*numberOfPoints]);
    }
}
