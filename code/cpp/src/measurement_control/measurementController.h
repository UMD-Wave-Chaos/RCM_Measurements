/**
* @file measurementController.h
* @brief Header File for the measurementController class
* @details This class handles high level control and interface with the pna and stepper motor
* @author Ben Frazier
* @date 12/13/2018*/
#ifndef MEASUREMENTCONTROLLER_H
#define MEASUREMENTCONTROLLER_H

#include "pnaWrapper.h"
#include "DataLogger_HDF5.h"
#include "rapidxml.hpp"
#include "rapidxml_utils.hpp"
#include "measurementSettings.h"
#include "stepperMotorWrapper.h"

#include <map>
#include <string>
#include <iostream>
#include <vector>
#include <map>
#include <rpc/pmap_clnt.h>
#include <arpa/inet.h>

#include "vxi11_user.h"

#include <fstream>
#include <ctime>

using namespace rapidxml;

class measurementController
{
public:
    measurementController(bool mode);
    ~measurementController();

    bool updateSettings(std::string filename);

    measurementSettings getSettings() {return Settings;}

    void measureTimeDomainSParameters();
    void measureUngatedFrequencyDomainSParameters();
    void measureGatedFrequencyDomainSParameters();
    void establishConnections();
    void closeConnections();

private:
    pnaWrapper *pna;
    stepperMotorWrapper *sm;
    DataLoggerHDF5 dataLogger;
    bool testMode;
    bool initialized;
    measurementSettings Settings;
    std::string settingsFileName;
};

#endif // MEASUREMENTCONTROLLER_H
