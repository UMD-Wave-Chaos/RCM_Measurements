#ifndef MEASUREMENTSETTINGS_H
#define MEASUREMENTSETTINGS_H

#include "measurementModes.h"
#include <string>

class measurementSettings
{
public:
    measurementSettings();

    std::string comments;
    int numberOfRealizations;
    int numberOfPoints;
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

};

#endif // MEASUREMENTSETTINGS_H
