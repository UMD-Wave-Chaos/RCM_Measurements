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

    bufferSize = 32001*9;

    dataBuffer = new double[bufferSize];

    calibrated = false;
}

pnaControllerMock::~pnaControllerMock()
{
    delete dataBuffer;
}


void pnaControllerMock::initialize(double fStart, double fStop, int NOP)
{
    bufferSize = NOP*9;

    delete dataBuffer;
    dataBuffer = new double[bufferSize];
}

void pnaControllerMock::getGatedFrequencyDomainSParameters(std::vector<double> &freq, std::vector<double> &S11R, std::vector<double> &S11I,
                                                           std::vector<double> &S12R, std::vector<double> &S12I, std::vector<double> &S21R,
                                                           std::vector<double> &S21I, std::vector<double> &S22R, std::vector<double> &S22I)
{
    getSParameters();
    unpackSParameters(freq, S11R, S11I, S12R, S12I, S21R, S21I, S22R, S22I);
}

void pnaControllerMock::getTimeDomainSParameters(std::vector<double> &time, std::vector<double> &S11R, std::vector<double> &S11I,
                                                 std::vector<double> &S12R, std::vector<double> &S12I, std::vector<double> &S21R,
                                                 std::vector<double> &S21I, std::vector<double> &S22R, std::vector<double> &S22I)
{
    getSParameters();
    unpackSParameters(time, S11R, S11I, S12R, S12I, S21R, S21I, S22R, S22I);
}

void pnaControllerMock::getUngatedFrequencyDomainSParameters(std::vector<double> &freq, std::vector<double> &S11R, std::vector<double> &S11I,
                                                             std::vector<double> &S12R, std::vector<double> &S12I, std::vector<double> &S21R,
                                                             std::vector<double> &S21I, std::vector<double> &S22R, std::vector<double> &S22I)
{
    getSParameters();
    unpackSParameters(freq, S11R, S11I, S12R, S12I, S21R, S21I, S22R, S22I);
}

void pnaControllerMock::getSParameters()
{
    int variableSize = static_cast<int>(floor(static_cast<double>(bufferSize)/9.0));

    std::normal_distribution<double> normal;
    std::default_random_engine generator;

    for (int cnt = 0; cnt < variableSize; cnt++)
    {
        dataBuffer[cnt] = static_cast<double>(cnt)/4.5e6;
        dataBuffer[cnt + variableSize] = normal(generator);
        dataBuffer[cnt + 2*variableSize] = normal(generator);
        dataBuffer[cnt + 3*variableSize] = normal(generator);
        dataBuffer[cnt + 4*variableSize] = normal(generator);
        dataBuffer[cnt + 5*variableSize] = normal(generator);
        dataBuffer[cnt + 6*variableSize] = normal(generator);
        dataBuffer[cnt + 7*variableSize] = normal(generator);
        dataBuffer[cnt + 8*variableSize] = normal(generator);
    }

}

void pnaControllerMock::unpackSParameters(std::vector<double> &xData, std::vector<double> &S11R, std::vector<double> &S11I,
                                          std::vector<double> &S12R, std::vector<double> &S12I, std::vector<double> &S21R,
                                          std::vector<double> &S21I, std::vector<double> &S22R, std::vector<double> &S22I)
{
    int variableSize = static_cast<int>(floor(static_cast<double>(bufferSize)/9.0));

    for (int cnt = 0; cnt < variableSize; cnt++)
    {
        xData[cnt] = dataBuffer[cnt];
        S11R[cnt] = dataBuffer[cnt + variableSize];
        S11I[cnt] = dataBuffer[cnt + 2*variableSize];
        S12R[cnt] = dataBuffer[cnt + 3*variableSize];
        S12I[cnt] = dataBuffer[cnt + 4*variableSize];
        S21R[cnt] = dataBuffer[cnt + 5*variableSize];
        S21I[cnt] = dataBuffer[cnt + 6*variableSize];
        S22R[cnt] = dataBuffer[cnt + 7*variableSize];
        S22I[cnt] = dataBuffer[cnt + 8*variableSize];
    }
}
