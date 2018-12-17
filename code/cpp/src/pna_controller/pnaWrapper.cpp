/**
* @file pnaWrapper.cpp
* @brief Implementation of the pnaWrapper class
* @details This is the highest level interface provided to interact with the Agilent PNA
* @author Ben Frazier
* @date 12/13/2018*/

#include "pnaWrapper.h"

/**
 * \brief Constructor
 *
 * This constructor handles initialization of member variables and setup the pointer to either the full pna controller or the mocked version
 * @param mode Boolean value to indicate if we are in test mode (if true, the mocked pna controller is created. If false, the full pna controller is created)*/
pnaWrapper::pnaWrapper(bool mode)
{
    connected = false;
    testMode = mode;

    pnaDeviceString = "Not Connected";

    //create the pnaController object
    if(testMode == true)
        pnaObj = new pnaControllerMock();
    else
        pnaObj = new pnaController();

    if (pnaObj == nullptr)
        throw pnaException("Unable to create instance of pnaController");

    numberOfPoints = 32001;
    initializeSizes();
}

/**
 * \brief Destructor
 *
 * This destructor handles clean up*/
pnaWrapper::~pnaWrapper()
{
    //remove the pna object
    if (pnaObj != nullptr)
        delete pnaObj;
}

/**
 * \brief setPNAConfig
 *
 * This function sets up the parameters for the PNA and opens the connection
 * @param fStart the start frequency of the sweep
 * @param fStop the stop frequency of the sweep
 * @param tcpAddress the ip address to use for connection
 * @param NOP the number of points to collect from the PNA*/
void pnaWrapper::setPNAConfig(double fStart,double fStop, std::string tcpAddress,unsigned int NOP)
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
void pnaWrapper::initializeSizes()
{

}

/**
 * \brief openConnection
 *
 * This function opens the connection to the PNA and initializes the instrument*/
bool pnaWrapper::openConnection()
{
    if (connected == true)
        throw pnaException("pnaWrapper::openConnection. Cannot open a connection, already connected");

    pnaDeviceString = pnaObj->connectToInstrument(ipAddress);

    connected = pnaObj->getConnectionStatus();

    pnaObj->initialize(frequencyRange[0], frequencyRange[1],numberOfPoints);
    return connected;
}

/**
 * \brief closeConnection
 *
 * This function closes the connection to the PNA*/
bool pnaWrapper::closeConnection()
{
    if (connected == false)
        throw pnaException("pnaWrapper::closeConnection(). Attempting to close a connection that is already closed");

    pnaObj->disconnect();

    connected = pnaObj->getConnectionStatus();
    return connected;
}

/**
 * \brief findClients
 *
 * This function scans for connected clients and reports them*/
std::string pnaWrapper::findClients()
{
    return pnaObj->findConnections();
}

/**
 * \brief checkCalibration
 *
 * This function checks the calibration status of the PNA*/
bool pnaWrapper::checkCalibration()
{
    if (connected == false)
         throw pnaException("pnaWrapper::checkCalibration(). Attempting to query a connection that is closed");

    return pnaObj->checkCalibration();
}

/**
 * \brief calibrate
 *
 * This function runs the eCal unit on the PNA ot calibrated*/
void pnaWrapper::calibrate()
{
    if (connected == false)
        throw pnaException("pnaWrapper::calibrate(). Attempting to access a connection that is closed");

    pnaObj->calibrate();
}

/**
 * \brief getCalibrationFile
 *
 * This function checks the calibration status of the PNA and returns the calibration file name*/
std::string pnaWrapper::getCalibrationFile()
{
    if (connected == false)
         throw pnaException("pnaWrapper::getCalibrationFile(). Attempting to query a connection that is closed");

    return pnaObj->getCalibrationFileName();
}


/**
 * \brief getUngatedFrequencyDomainSParameters
 *
 * This function gets the ungated S-parameters in the frequency domain*/
void pnaWrapper::getUngatedFrequencyDomainSParameters()
{
    if (connected == false)
        throw pnaException("pnaWrapper::getUngatedFrequencyDomainSParameters(). Attempting to query a measurement for a connection that is closed");

    pnaObj->getUngatedFrequencyDomainSParameters();
    pnaObj->getXDataVector(freqData);
    pnaObj->getS11RVector(S11R);
    pnaObj->getS11IVector(S11I);
    pnaObj->getS12RVector(S12R);
    pnaObj->getS12IVector(S12I);
    pnaObj->getS21RVector(S21R);
    pnaObj->getS21IVector(S21I);
    pnaObj->getS22RVector(S22R);
    pnaObj->getS22IVector(S22I);
}

/**
 * \brief getGatedFrequencyDomainSParameters
 *
 * This function gets the gated S-parameters in the frequency domain*/
void pnaWrapper::getGatedFrequencyDomainSParameters(double start_time, double stop_time)
{

    if (connected == false)
        throw pnaException("pnaWrapper::getGatedFrequencyDomainSParameters(). Attempting to query a measurement for a connection that is closed");

    pnaObj->getGatedFrequencyDomainSParameters(start_time,stop_time);
    pnaObj->getXDataVector(freqData);
    pnaObj->getS11RVector(S11R);
    pnaObj->getS11IVector(S11I);
    pnaObj->getS12RVector(S12R);
    pnaObj->getS12IVector(S12I);
    pnaObj->getS21RVector(S21R);
    pnaObj->getS21IVector(S21I);
    pnaObj->getS22RVector(S22R);
    pnaObj->getS22IVector(S22I);
}

/**
 * \brief getTimeDomainSParameters
 *
 * This function gets the S-parameters in the time domain*/
void pnaWrapper::getTimeDomainSParameters(double start_time, double stop_time)
{

    if (connected == false)
        throw pnaException("pnaWrapper::getTimeDomainSParameters(). Attempting to query a measurement for a connection that is closed");

    pnaObj->getTimeDomainSParameters(start_time, stop_time);
    pnaObj->getXDataVector(timeData);
    pnaObj->getS11RVector(S11R);
    pnaObj->getS11IVector(S11I);
    pnaObj->getS12RVector(S12R);
    pnaObj->getS12IVector(S12I);
    pnaObj->getS21RVector(S21R);
    pnaObj->getS21IVector(S21I);
    pnaObj->getS22RVector(S22R);
    pnaObj->getS22IVector(S22I);

}

/**
 * \brief getS11Data
 *
 * This function gets the S11 values*/
 void pnaWrapper::getS11Data(std::vector<double> &inR, std::vector<double> &inI)
{
    if (connected == false)
        throw pnaException("pnaWrapper::getS11Data. Attempting to get data from a connection that isn't open");
    inR = S11R;
    inI = S11I;
}

/**
 * \brief getS12Data
 *
 * This function gets the S12 values*/
void pnaWrapper::getS12Data(std::vector<double> &inR, std::vector<double> &inI)
{
    if (connected == false)
        throw pnaException("pnaWrapper::getS12Data. Attempting to get data from a connection that isn't open");

    inR = S12R;
    inI = S12I;
}

/**
 * \brief getS21Data
 *
 * This function gets the S21 values*/
void pnaWrapper::getS21Data(std::vector<double> &inR, std::vector<double> &inI)
{
    if (connected == false)
        throw pnaException("pnaWrapper::getS21Data. Attempting to get data from a connection that isn't open");

    inR = S21R;
    inI = S21I;
}

/**
 * \brief getS22Data
 *
 * This function gets the S22 values*/
void pnaWrapper::getS22Data(std::vector<double> &inR, std::vector<double> &inI)
{
    if (connected == false)
        throw pnaException("pnaWrapper::getS22Data. Attempting to get data from a connection that isn't open");

    inR = S22R;
    inI = S22I;
}

/**
 * \brief getFrequencyData
 *
 * This function gets the frequency values*/
void pnaWrapper::getFrequencyData(std::vector<double> &inF)
{
    if (connected == false)
        throw pnaException("pnaWrapper::getFrequencyData. Attempting to get data from a connection that isn't open");
    inF = freqData;
}

/**
 * \brief getTimeData
 *
 * This function gets the time values*/
void pnaWrapper::getTimeData(std::vector<double> &inT)
{
    if (connected == false)
        throw pnaException("pnaWrapper::getTimeData. Attempting to get data from a connection that isn't open");

    inT = timeData;
}
