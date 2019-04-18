/**
* @file instrumentWrapper.cpp
* @brief Implementation of the instrumentWrapper class
* @details This is the highest level interface provided to interact with an abstract instrument
* @author Ben Frazier
* @date 04/17/2019*/

#include "instrumentWrapper.h"

/**
 * \brief Constructor
 *
 * This constructor handles initialization of member variables and setup the pointer to either the full instrument controller or the mocked version
 * @param mode Boolean value to indicate if we are in test mode (if true, the mocked instrument controller is created. If false, the full instrument controller is created)*/
instrumentWrapper::instrumentWrapper(bool mode)
{
    connected = false;
    testMode = mode;

    instDeviceString = "Not Connected";

    //create the instController object
    if(testMode == true)
        instObj = new instrumentControllerMock();
    else
        instObj = new instrumentController();

    if (instObj == nullptr)
        throw instrumentException("Unable to create instance of instrumentController");

    numberOfPoints = 32001;
    initializeSizes();
}

/**
 * \brief Destructor
 *
 * This destructor handles clean up*/
instrumentWrapper::~instrumentWrapper()
{
    //remove the inst object
    if (instObj != nullptr)
        delete instObj;
}

/**
 * \brief setInstrumentConfiguration
 *
 * This function sets up the parameters for the instrument and opens the connection
 * @param fStart the start frequency of the sweep
 * @param fStop the stop frequency of the sweep
 * @param tcpAddress the ip address to use for connection
 * @param NOP the number of points to collect from the instrument*/
void instrumentWrapper::setInstrumentConfiguration(double fStart,double fStop, std::string tcpAddress,unsigned int NOP)
{

    if (connected)
        closeConnection();

    setFrequencyRange(fStart,fStop);
    setIpAddress(tcpAddress);
    setNumberOfPoints(NOP);
    openConnection();

   initializeSizes();
}

/**
 * \brief initializeSizes
 *
 * This function initializes the array sizes*/
void instrumentWrapper::initializeSizes()
{

}

/**
 * \brief openConnection
 *
 * This function opens the connection to the instrument and initializes it*/
bool instrumentWrapper::openConnection()
{
    if (connected == true)
        throw instrumentException("instrumentWrapper::openConnection. Cannot open a connection, already connected");

    instDeviceString = instObj->connectToInstrument(ipAddress);

    connected = instObj->getConnectionStatus();

    instObj->initialize(frequencyRange[0], frequencyRange[1],numberOfPoints);
    return connected;
}

/**
 * \brief sendCommand
 *
 * This function sends a command string to the instrument*/
 void instrumentWrapper::sendCommand(std::string inputString)
 {
     if (connected == false)
         throw instrumentException("instrumentWrapper::sendCommand(). Attempting to send a command to a connection that is closed");

     instObj->sendCommand(inputString);
 }

/**
 * \brief closeConnection
 *
 * This function closes the connection to the instrument*/
bool instrumentWrapper::closeConnection()
{
    if (connected == false)
        throw instrumentException("instrumentWrapper::closeConnection(). Attempting to close a connection that is already closed");

    instObj->disconnect();

    connected = instObj->getConnectionStatus();
    return connected;
}

/**
 * \brief findClients
 *
 * This function scans for connected clients and reports them*/
std::string instrumentWrapper::findClients()
{
    return instObj->findConnections();
}

/**
 * \brief getConnectionIpAddress
 *
 * This function gets the ip address of a specified instrument on the network*/
std::string instrumentWrapper::getConnectionIpAddress(int count)
{
    return instObj->getConnectionIpAddress(count);
}


/**
 * \brief checkCalibration
 *
 * This function checks the calibration status of the instrument*/
bool instrumentWrapper::checkCalibration()
{
    if (connected == false)
         throw instrumentException("instrumentWrapper::checkCalibration(). Attempting to query a connection that is closed");

    return instObj->checkCalibration();
}

/**
 * \brief calibrate
 *
 * This function runs the eCal unit on the instrument to calibrate*/
void instrumentWrapper::calibrate()
{
    if (connected == false)
        throw instrumentException("instrumentWrapper::calibrate(). Attempting to access a connection that is closed");

    instObj->calibrate();
}

/**
 * \brief getCalibrationFile
 *
 * This function checks the calibration status of the instrument and returns the calibration file name*/
std::string instrumentWrapper::getCalibrationFile()
{
    if (connected == false)
         throw instrumentException("instrumentWrapper::getCalibrationFile(). Attempting to query a connection that is closed");

    return instObj->getCalibrationFileName();
}


/**
 * \brief getUngatedFrequencyDomainSParameters
 *
 * This function gets the ungated S-parameters in the frequency domain*/
void instrumentWrapper::getUngatedFrequencyDomainSParameters()
{
    if (connected == false)
        throw instrumentException("instrumentWrapper::getUngatedFrequencyDomainSParameters(). Attempting to query a measurement for a connection that is closed");

    instObj->getUngatedFrequencyDomainSParameters();
    instObj->getXDataVector(freqData);
    instObj->getS11RVector(S11R);
    instObj->getS11IVector(S11I);
    instObj->getS12RVector(S12R);
    instObj->getS12IVector(S12I);
    instObj->getS21RVector(S21R);
    instObj->getS21IVector(S21I);
    instObj->getS22RVector(S22R);
    instObj->getS22IVector(S22I);
}

/**
 * \brief getGatedFrequencyDomainSParameters
 *
 * This function gets the gated S-parameters in the frequency domain*/
void instrumentWrapper::getGatedFrequencyDomainSParameters(double start_time, double stop_time)
{

    if (connected == false)
        throw instrumentException("instrumentWrapper::getGatedFrequencyDomainSParameters(). Attempting to query a measurement for a connection that is closed");

    instObj->getGatedFrequencyDomainSParameters(start_time,stop_time);
    instObj->getXDataVector(freqData);
    instObj->getS11RVector(S11R);
    instObj->getS11IVector(S11I);
    instObj->getS12RVector(S12R);
    instObj->getS12IVector(S12I);
    instObj->getS21RVector(S21R);
    instObj->getS21IVector(S21I);
    instObj->getS22RVector(S22R);
    instObj->getS22IVector(S22I);
}

/**
 * \brief getTimeDomainSParameters
 *
 * This function gets the S-parameters in the time domain*/
void instrumentWrapper::getTimeDomainSParameters(double start_time, double stop_time)
{

    if (connected == false)
        throw instrumentException("instrumentWrapper::getTimeDomainSParameters(). Attempting to query a measurement for a connection that is closed");

    instObj->getTimeDomainSParameters(start_time, stop_time);
    instObj->getXDataVector(timeData);
    instObj->getS11RVector(S11R);
    instObj->getS11IVector(S11I);
    instObj->getS12RVector(S12R);
    instObj->getS12IVector(S12I);
    instObj->getS21RVector(S21R);
    instObj->getS21IVector(S21I);
    instObj->getS22RVector(S22R);
    instObj->getS22IVector(S22I);

}

/**
 * \brief getS11Data
 *
 * This function gets the S11 values*/
 void instrumentWrapper::getS11Data(std::vector<double> &inR, std::vector<double> &inI)
{
    if (connected == false)
        throw instrumentException("instrumentWrapper::getS11Data. Attempting to get data from a connection that isn't open");
    inR = S11R;
    inI = S11I;
}

/**
 * \brief getS12Data
 *
 * This function gets the S12 values*/
void instrumentWrapper::getS12Data(std::vector<double> &inR, std::vector<double> &inI)
{
    if (connected == false)
        throw instrumentException("instrumentWrapper::getS12Data. Attempting to get data from a connection that isn't open");

    inR = S12R;
    inI = S12I;
}

/**
 * \brief getS21Data
 *
 * This function gets the S21 values*/
void instrumentWrapper::getS21Data(std::vector<double> &inR, std::vector<double> &inI)
{
    if (connected == false)
        throw instrumentException("instrumentWrapper::getS21Data. Attempting to get data from a connection that isn't open");

    inR = S21R;
    inI = S21I;
}

/**
 * \brief getS22Data
 *
 * This function gets the S22 values*/
void instrumentWrapper::getS22Data(std::vector<double> &inR, std::vector<double> &inI)
{
    if (connected == false)
        throw instrumentException("instrumentWrapper::getS22Data. Attempting to get data from a connection that isn't open");

    inR = S22R;
    inI = S22I;
}

/**
 * \brief getFrequencyData
 *
 * This function gets the frequency values*/
void instrumentWrapper::getFrequencyData(std::vector<double> &inF)
{
    if (connected == false)
        throw instrumentException("instrumentWrapper::getFrequencyData. Attempting to get data from a connection that isn't open");
    inF = freqData;
}

/**
 * \brief getTimeData
 *
 * This function gets the time values*/
void instrumentWrapper::getTimeData(std::vector<double> &inT)
{
    if (connected == false)
        throw instrumentException("instrumentWrapper::getTimeData. Attempting to get data from a connection that isn't open");

    inT = timeData;
}
