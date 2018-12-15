/**
* @file measurementSettings.cpp
* @brief Implementation of the measurementSettings class
* @details This class provides storage for the various settings
* @author Ben Frazier
* @date 12/13/2018*/
#include "measurementSettings.h"

/**
 * \brief constructor
 *
 * This is the primary constructor for the measurement settings class*/
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
    COMport = "/dev/tty.usbserial-A600eOXn";
    outputFileNamePrefix = "config_A";
    outputFileName = "";
    ipAddress = "169.254.13.58";
    movementTime = 0.0;
    settlingTime = 0.0;
    xformStartTime = 0.0;
    xformStopTime = 0.0;
    gateStartTime = 0.0;
    gateStopTime = 0.0;
    takeGatedMeasurement = false;
}

/**
 * \brief operator <<
 *
 * This function overloads the << operator for the measurementSettings class*/
std::ostream & operator << (std::ostream &out, const measurementSettings &ms)
{
    out << "Output File Name: " << ms.outputFileName << std::endl;
    out << "Comments: " << ms.comments << std::endl;
    out << "PNA Settings: " << std::endl;
    out << "  Number of Points: " << ms.numberOfPoints << std::endl;
    out << "  Frequency Sweep Start: " << ms.fStart/1e9 << " GHz" << std::endl;
    out << "  Frequency Sweep Stop : " << ms.fStop/1e9 << " GHz" << std::endl;
    out << "  Time Domain Transform Start Time: " << ms.xformStartTime/1e-6 << " microseconds" << std::endl;
    out << "  Time Domain Transform Stop Time: " << ms.xformStopTime/1e-6 << " microseconds" << std::endl;
    out << "  Gating Start Time: " << ms.gateStartTime/1e-6 << " microseconds" << std::endl;
    out << "  Gating Stop Time: " << ms.gateStopTime/1e-6 << " microseconds" << std::endl;
    out << "  Take Gated Measurement: " << (ms.takeGatedMeasurement ? "Yes" : "No") << std::endl;
    out << "Stepper Motor Settings: " << std::endl;
    out << "  COM Port: " << ms.COMport << std::endl;
    out << "  Number of Steps Per Revolution: " << ms.numberOfStepsPerRevolution << std::endl;
    out << "  Direction : " << ms.direction << std::endl;
    out << "  Settling Time: " << ms.settlingTime << " seconds" << std::endl;
    out << "  Movement Time: " << ms.movementTime << " seconds" << std::endl;
    out << "Experiment Settings: " << std::endl;
    out << "  Number of Realizations: " << ms.numberOfRealizations << std::endl;
    out << "  Cavity Volume: " << ms.cavityVolume << " cubic meters" << std::endl;

    return out;
}
