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

#include "stringUtilities.h"

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

    void measureTimeDomainSParameters(double start_time, double stop_time);
    void measureUngatedFrequencyDomainSParameters();
    void measureGatedFrequencyDomainSParameters(double start_time, double stop_time);
    void establishConnections();
    void closeConnections();

    int getStepperMotorPosition(){return sm->getPosition();};

    void moveStepperMotor();
    bool getConnected(){return (pnaConnected && smConnected);}
    bool getTestMode(){return testMode;}

    void logSettings();
    void printSettings(){std::cout<<Settings;}

    void captureNextRealization();

    bool getStepperMotorConnected(){return smConnected;}
    bool getPNAConnected(){return pnaConnected;}

    std::string getStepperMotorInfoString(){return sm->getPortName();}
    std::string getPNAInfoString(){return pna->getPNADeviceString();}
    std::string getFileName(){return Settings.outputFileName;}
    unsigned int getNumberOfRealizations(){return Settings.numberOfRealizations;}

private:
    pnaWrapper *pna;
    stepperMotorWrapper *sm;
    DataLoggerHDF5 dataLogger;
    bool testMode;
    bool initialized;
    bool pnaConnected;
    bool smConnected;
    measurementSettings Settings;
    std::string settingsFileName;
    unsigned int delayTime_ms;

    bool fileValid;
    bool loggedFrequencyData;
    bool loggedTimeData;

    void writeSParameters();
};

#endif // MEASUREMENTCONTROLLER_H
