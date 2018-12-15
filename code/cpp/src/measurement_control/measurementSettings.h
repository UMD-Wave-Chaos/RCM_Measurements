/**
* @file measurementSettings.h
* @brief Header File for the measurementSettings class
* @details This class provides storage for the various settings
* @author Ben Frazier
* @date 12/13/2018*/

#ifndef MEASUREMENTSETTINGS_H
#define MEASUREMENTSETTINGS_H

#include "measurementModes.h"
#include <string>
#include <iostream>

class measurementSettings
{
public:
    measurementSettings();

    std::string comments;
    unsigned int numberOfRealizations;
    unsigned int numberOfPoints;
    double fStart;
    double fStop;
    std::string COMport;
    int numberOfStepsPerRevolution;
    int direction;
    double cavityVolume;
    bool useDateStamp;
    std::string outputFileNamePrefix;
    stepperMotorDirection smDirection;
    std::string outputFileName;
    std::string ipAddress;
    double movementTime;
    double settlingTime;
    double xformStartTime;
    double xformStopTime;
    double gateStartTime;
    double gateStopTime;
    bool takeGatedMeasurement;

    friend std::ostream & operator << (std::ostream &out, const measurementSettings &ms);

};

#endif // MEASUREMENTSETTINGS_H
