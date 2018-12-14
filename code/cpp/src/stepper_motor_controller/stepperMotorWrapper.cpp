/**
* @file stepperMotorWrapper.cpp
* @brief Implementation of the stepperMotorWrapper class
* @details This is the highest level interface provided to interact with the Agilent PNA
* @author Ben Frazier
* @date 12/13/2018*/

#include "stepperMotorWrapper.h"

/**
 * \brief Constructor
 *
 * This constructor handles initialization of member variables and setup the pointer to either the full stepper motor controller or the mocked version
 * @param mode Boolean value to indicate if we are in test mode (if true, the mocked stepper motor controller is created. If false, the full stepper motor controller is created)*/
stepperMotorWrapper::stepperMotorWrapper(bool mode)
{
    connected = false;
    testMode = mode;

    //create the pnaController object
    if(testMode == true)
        sObj = new stepperMotorControllerMock();
    else
        sObj = new stepperMotorController();

    if (sObj == nullptr)
        throw stepperMotorException("stepperMotorWrapper::stepperMotorWrapper(bool mode). Unable to create instance of pnaController");
}

/**
 * \brief Destructor
 *
 * This destructor handles clean up*/
stepperMotorWrapper::~stepperMotorWrapper()
{
    //remove the pna object
    if (sObj != nullptr)
        delete sObj;
}

/**
 * \brief openConnection
 *
 * This function opens the connection to the PNA and initializes the instrument*/
bool stepperMotorWrapper::openConnection()
{
    if (connected == true)
        throw stepperMotorException("stepperMotorWrapper::openConnection(). Cannot open a connection, already connected");
    else
    {
        sObj->connectToStepperMotor(comPort);
    }

    connected = sObj->getConnectionStatus();

    return connected;
}

/**
 * \brief closeConnection
 *
 * This function closes the connection to the PNA*/
bool stepperMotorWrapper::closeConnection()
{
    if (connected == false)
        throw stepperMotorException("stepperMotorWrapper::closeConnection(). Attempting to close a connection that is already closed");
    else
    {
     sObj->closeConnection();
    }

    connected = sObj->getConnectionStatus();
    return connected;
}

/**
 * \brief getPortName
 *
 * This function closes the connection to the PNA*/
QString stepperMotorWrapper::getPortName()
{
   if (connected == false)
       throw stepperMotorException("stepperMotorWrapper::getPortName(). Attempting to query a connection that is not open");
   else
     return sObj->getCurrentPortInfo();
}

/**
 * \brief listPorts
 *
 * This function scans for available ports and reports them*/
bool stepperMotorWrapper::listPorts()
{
    std::string ports = sObj->getAvailablePorts();
    std::cout<<ports << std::endl;

    return true;
}
