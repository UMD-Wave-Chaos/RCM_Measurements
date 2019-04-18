/**
* @file instrumentControllerBase.cpp
* @brief Implementation of the instrumentControllerBase class
* @details This is the base class for the abstract instrument controllers
* @author Ben Frazier
* @date 04/17/2019*/
#include "instrumentControllerBase.h"

#include <functional>

/**
 * \brief constructor
 *
 * This is the primary constructor for the base pna class*/
instrumentControllerBase::instrumentControllerBase()
{
   connected = false;
   calibrationFileName = "";
   calibrated = false;

   numberOfPoints = 32001;
   bufferSizeDoubles = numberOfPoints*9;
   bufferSizeBytes = bufferSizeDoubles*8;

   dataBuffer = new double[bufferSizeDoubles];

   //set the timeout for measurements to 15 seconds and calibration to 60 seconds
   measureDataTimeout = 15000;
   calibrationTimeout = 60000;
}

/**
 * \brief destructor
 *
 * This is the primary destructor for the base pna class*/
instrumentControllerBase::~instrumentControllerBase()
{

    delete dataBuffer;
}


/**
 * \brief unpackSParameters
 *
 * This function unpacks the S-parameters from the data buffer*/
void instrumentControllerBase::unpackSParameters()
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

    for (unsigned int cnt = 0; cnt < numberOfPoints; cnt++)
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
