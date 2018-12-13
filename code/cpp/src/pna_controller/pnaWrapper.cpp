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

    //create the pnaController object
    if(testMode == true)
        pnaObj = new pnaControllerMock();
    else
        pnaObj = new pnaController();

    if (pnaObj == nullptr)
        throw pnaException("Unable to create instance of pnaController");
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
void pnaWrapper::setPNAConfig(double fStart,double fStop, std::string tcpAddress,int NOP)
{

    if (connected)
        closeConnection();

    setFrequencyRange(fStart,fStop);
    setIpAddress(tcpAddress);
    setNumberOfPoints(NOP);
    openConnection();
}

/**
 * \brief openConnection
 *
 * This function opens the connection to the PNA and initializes the instrument*/
bool pnaWrapper::openConnection()
{
    if (connected == true)
        throw pnaException("Cannot open a connection, already connected");
    else
    {
        pnaObj->connectToInstrument(ipAddress);
    }

    connected = pnaObj->getConnectionStatus();

    pnaObj->initialize(frequencyRange[0], frequencyRange[1],numberOfPoints);
    return pnaObj;
}

/**
 * \brief closeConnection
 *
 * This function closes the connection to the PNA*/
bool pnaWrapper::closeConnection()
{
    if (connected == false)
        throw pnaException("Attempting to close a connection that is already closed");
    else
    {
     pnaObj->disconnect();
    }

    connected = pnaObj->getConnectionStatus();
    return pnaObj;
}

/**
 * \brief listClients
 *
 * This function scans for connected clients and reports them*/
bool pnaWrapper::listClients()
{
    pnaObj->findConnections();
}
