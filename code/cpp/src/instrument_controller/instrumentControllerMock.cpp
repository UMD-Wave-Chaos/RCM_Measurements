/**
* @file instrumentControllerMock.cpp
* @brief Implementation of the instrumentControllerMock class
* @details This class mocks the class that controls the abstract instrument for testing when the hardware is not present
* @author Ben Frazier
* @date 04/19/2019*/

#include "instrumentControllerMock.h"
#include <random>

/**
 * \brief constructor
 *
 * primary constructor for the mock pna interface*/
instrumentControllerMock::instrumentControllerMock()
{

}

/**
 * \brief destructor
 *
 * primary destructor for the pna mock interface*/
instrumentControllerMock::~instrumentControllerMock()
{

    if (connected == true)
        disconnect();
}

/**
 * \brief getData
 *
 * This function gets a random set of data in a buffer
 * @param buffer the buffer to fill
 * @param bufferSizeBytes the size of the buffer in bytes
 * @param measureDataTimeout the timeout to use in the non-mocked call */
void instrumentControllerMock::getData(double *buffer, unsigned int bufferSizeBytes, unsigned int measureDataTimeout)
{

    //assume we have data in the buffer as xData real1 imag1 ... real4 imag4
    int numberOfPoints = static_cast<int>(static_cast<double>(bufferSizeBytes)/(8.0*9.0));

    for (unsigned int cnt = 0; cnt < numberOfPoints; cnt++)
    {
        buffer[cnt] = cnt;
        buffer[cnt + numberOfPoints] = normal(generator);
        buffer[cnt + 2*numberOfPoints] = normal(generator);
        buffer[cnt + 3*numberOfPoints] = normal(generator);
        buffer[cnt + 4*numberOfPoints] = normal(generator);
        buffer[cnt + 5*numberOfPoints] = normal(generator);
        buffer[cnt + 6*numberOfPoints] = normal(generator);
        buffer[cnt + 7*numberOfPoints] = normal(generator);
        buffer[cnt + 8*numberOfPoints] = normal(generator);
    }

}
