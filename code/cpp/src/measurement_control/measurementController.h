#ifndef MEASUREMENTCONTROLLER_H
#define MEASUREMENTCONTROLLER_H

#include "pnaControllerInterface.h"
#include "pnaControllerMock.h"
#include "pnaController.h"
#include "DataLogger_HDF5.h"
#include "rapidxml.hpp"
#include "rapidxml_utils.hpp"
#include "measurementSettings.h"
#include "stepperMotorController.h"

#include <fstream>
#include <ctime>

using namespace rapidxml;

class measurementController
{
public:
    measurementController();
    ~measurementController();
    bool measureData();

    bool updateSettings(std::string filename);

    measurementSettings getSettings() {return Settings;}

private:
    pnaControllerInterface* pnaObj;
    //stepperMotorController* sObj;
    DataLoggerHDF5 dataLogger;
    bool testMode;
    bool initialized;
    measurementSettings Settings;
    std::string settingsFileName;
};

#endif // MEASUREMENTCONTROLLER_H
