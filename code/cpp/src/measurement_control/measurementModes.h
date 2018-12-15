/**
* @file measurementModes.h
* @brief Header File for the measurementModes class
* @details This class defines enumerations for the measurement controller
* @author Ben Frazier
* @date 12/13/2018*/
#ifndef MEASUREMENTMODES_H
#define MEASUREMENTMODES_H

enum measurementModes
{
    IDLE,
    CALIBRATING,
    MEASURING,
    INITIALIZING

};

enum stepperMotorDirection
{
    FWD = 1,
    REV = -1
};

#endif // MEASUREMENTMODES_H
