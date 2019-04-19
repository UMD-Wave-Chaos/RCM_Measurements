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
 * \brief openConnection
 *
 * This function opens the connection to the instrument and initializes it
  @param ipAddress The ip address of the instrument to open*/
std::string instrumentWrapper::openConnection(std::string address)
{
    std::string errString = "instrumentWrapper::openConnection. Cannot open a connection, already connected";
    if (connected == true)
        throw instrumentException(errString);

    ipAddress = address;

    instDeviceString = instObj->connectToInstrument(ipAddress);

    connected = instObj->getConnectionStatus();

    return instDeviceString;
}

/**
 * \brief sendCommand
 *
 * This function sends a command string to the instrument
 * @param inputString The input command to send to the instrument*/
 void instrumentWrapper::sendCommand(std::string inputString)
 {
     if (connected == false)
         throw instrumentException("instrumentWrapper::sendCommand(). Attempting to send a command to a connection that is closed");

     instObj->sendCommand(inputString);
 }

 /**
  * \brief sendQuery
  *
  * This function sends a query string to the instrument
  * @param inputString The input query to send to the instrument*/
 std::string instrumentWrapper::sendQuery(std::string inputString)
 {
     if (connected == false)
         throw instrumentException("instrumentWrapper::sendQuery(). Attempting to send a query to a connection that is closed");

     std::string outString = instObj->sendQuery(inputString);
     return outString;
 }

 /**
  * \brief getData
  *
  * This function gets measurement data from the instrument*/
void instrumentWrapper::getData(double *buffer, unsigned int bufferSizeBytes, unsigned int measureDataTimeout)
{
    instObj->getData(buffer, bufferSizeBytes, measureDataTimeout);
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
