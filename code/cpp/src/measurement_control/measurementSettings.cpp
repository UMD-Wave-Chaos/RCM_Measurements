#include "measurementSettings.h"

measurementSettings::measurementSettings()
{
    numberOfRealizations = 50;
    numberOfPoints = 32001;
    fStart = 9.5e9;
    double fStop = 11e9;
    numberOfStepsPerRevolution = 12800;
    direction = 1;
    cavityVolume = 1.92;
    useDateStamp = true;
    smDirection = FWD;
    comments = "";
    COMport = "COM5";
    outputFileNamePrefix = "config_A";
    outputFileName = "";
}
