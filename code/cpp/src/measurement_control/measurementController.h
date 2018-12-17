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
#include "pnaExceptions.h"
#include "stepperMotorExceptions.h"
#include "measurementExceptions.h"

#include <map>
#include <string>
#include <iostream>
#include <vector>
#include <map>
#include <rpc/pmap_clnt.h>
#include <arpa/inet.h>

#include "vxi11_user.h"

#include "stringUtilities.h"
#include "vectorSignalUtilities.h"

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

    int getStepperMotorPosition(){return sm->getPosition();}

    void moveStepperMotor();
    void moveStepperMotorNoWait();
    bool getConnected(){return (pnaConnected && smConnected);}
    bool getTestMode(){return testMode;}

    void logSettings();
    void printSettings(){std::cout<<Settings;}

    bool getStepperMotorConnected(){return smConnected;}
    bool getPNAConnected(){return pnaConnected;}

    std::string getStepperMotorInfoString(){return sm->getPortName();}
    std::string getPNAInfoString(){return pna->getPNADeviceString();}
    std::string getFileName(){return Settings.outputFileName;}
    unsigned int getNumberOfRealizations(){return Settings.numberOfRealizations;}

    int getStepDistance(){return sm->getStepDistance();}
    int getRunSpeed(){return sm->getRunSpeed();}

    bool prepareLogging();
    bool closeLogFile();
    std::string getCalibrationInfo();
    bool getCalibrated();

    void calibratePNA() {pna->calibrate();}
    std::string getVXI11Clients(){return pna->findClients();}
    std::string getSerialClients(){return sm->listPorts();}

    void getS11Decimated (std::vector<double> &SR, std::vector<double> &SI){SR = S11R_decimated; SI = S11I_decimated;}
    void getS12Decimated (std::vector<double> &SR, std::vector<double> &SI){SR = S12R_decimated; SI = S12I_decimated;}
    void getS21Decimated (std::vector<double> &SR, std::vector<double> &SI){SR = S21R_decimated; SI = S21I_decimated;}
    void getS22Decimated (std::vector<double> &SR, std::vector<double> &SI){SR = S22R_decimated; SI = S22I_decimated;}
    void getFreqDecimated(std::vector<double> &f){f = freq_decimated;}

private:

    bool downsampleSParameters();
    bool updateTimeStamp();

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

    std::vector<double> S11R_decimated, S11I_decimated, S12R_decimated, S12I_decimated;
    std::vector<double> S21R_decimated, S21I_decimated, S22R_decimated, S22I_decimated;
    std::vector<double> freq_decimated;

    unsigned int maxPlotLength;

    void writeSParameters();
    void decimateSParameters(std::vector<double> &S11R, std::vector<double> &S11I, std::vector<double> &S12R, std::vector<double> &S12I,
                             std::vector<double> &S21R, std::vector<double> &S21I, std::vector<double> &S22R, std::vector<double> &S22I,
                             std::vector<double> &freq);
};

#endif // MEASUREMENTCONTROLLER_H
