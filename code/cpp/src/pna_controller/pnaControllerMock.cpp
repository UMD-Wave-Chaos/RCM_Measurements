/**
* @file pnaControllerMock.cpp
* @brief Implementation of the pnaControllerMock class
* @details This class mocks the class that controls the Agilent PNA for testing when the hardware is not present
* @author Ben Frazier
* @date 12/13/2018*/

#include "pnaControllerMock.h"
#include <random>

/**
 * \brief constructor
 *
 * primary constructor for the mock pna interface*/
pnaControllerMock::pnaControllerMock()
{

}

/**
 * \brief destructor
 *
 * primary destructor for the pna mock interface*/
pnaControllerMock::~pnaControllerMock()
{

    if (connected == true)
        disconnect();
}

/**
 * \brief getGatedFrequencyDomainSParameters
 *
 * This function gets a random set of S parameters
 * @param start_time the start time to use for indexing
 * @param stop_time the stop time to use for indexing*/
void pnaControllerMock::getGatedFrequencyDomainSParameters(double start_time, double stop_time)
{
    getSParameters();
    unpackSParameters();

    mType = FREQUENCY_MEASUREMENT;
}

/**
 * \brief getTimeDomainSParameters
 *
 * This function gets a random set of S parameters
 * @param start_time the start time to use for indexing
 * @param stop_time the stop time to use for indexing*/
void pnaControllerMock::getTimeDomainSParameters(double start_time, double stop_time)
{

    double tIncrement = (stop_time - start_time)/static_cast<double>(numberOfPoints - 1);
    getSParameters();


    for (unsigned int cnt = 0; cnt < numberOfPoints; cnt++)
    {
        dataBuffer[cnt] = start_time + tIncrement*cnt;
    }
    unpackSParameters();

    mType = TIME_MEASUREMENT;
}

/**
 * \brief getUngatedFrequencyDomainSParameters
 *
 * This function gets a random set of S parameters*/
void pnaControllerMock::getUngatedFrequencyDomainSParameters()
{
    getSParameters();
    unpackSParameters();

    mType = FREQUENCY_MEASUREMENT;
}

/**
 * \brief getSParameters
 *
 * This function gets a random set of S parameters*/
void pnaControllerMock::getSParameters()
{

    double fIncrement = (fStop - fStart)/static_cast<double>(numberOfPoints - 1);


    for (unsigned int cnt = 0; cnt < numberOfPoints; cnt++)
    {
        dataBuffer[cnt] = fStart + fIncrement*cnt;
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

/**
 * \brief initialize
 *
 * This function initializes the configuration of the PNA
 * @param fStart the start frequency of the sweep
 * @param fStop the stop frequency of the sweep
 * @param NOP the number of points to collect from the PNA*/
void pnaControllerMock::initialize(double fStartIn, double fStopIn, unsigned int NOP)
{
    numberOfPoints = NOP;
    bufferSizeDoubles = numberOfPoints*9;
    bufferSizeBytes = bufferSizeDoubles*8;

    fStart = fStartIn;
    fStop = fStopIn;
    delete dataBuffer;
    dataBuffer = new double[bufferSizeDoubles];
}

