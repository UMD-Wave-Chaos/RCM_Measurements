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

    sObj->connectToStepperMotor(comPort);

    connected = sObj->getConnectionStatus();

    if (connected)
    {
        sObj->setRunSpeed(stepRunSpeed);
        sObj->setStepDistance(numberOfSteps);
    }
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

    sObj->closeConnection();
    connected = sObj->getConnectionStatus();
    return connected;
}

/**
 * \brief setPortConfig
 *
 * This function sets up the parameters for the stepper motor and opens the connection
 * @param port the string containing the port to connect to
 * @param numStepsIn the number of steps to move for each realization
 * @param stepRunSpeed the run speed at which to execute each step */
void stepperMotorWrapper::setPortConfig(std::string port, int numStepsIn, int runSpeedIn)
{
    if (connected == true)
        closeConnection();

    comPort = port;
    numberOfSteps = numStepsIn;
    stepRunSpeed = runSpeedIn;

    openConnection();
}

/**
 * \brief getPortName
 *
 * This function closes the connection to the PNA*/
std::string stepperMotorWrapper::getPortName()
{
   if (connected == false)
       throw stepperMotorException("stepperMotorWrapper::getPortName(). Attempting to query a connection that is not open");

   return sObj->getCurrentPortInfo();
}

/**
 * \brief listPorts
 *
 * This function scans for available ports and reports them*/
std::string stepperMotorWrapper::listPorts()
{
    return sObj->getAvailablePorts();
}

/**
 * \brief moveStepperMotor
 *
 * This function moves the stepper motor*/
bool stepperMotorWrapper::moveStepperMotor()
{
    if (connected == false)
        throw stepperMotorException("stepperMotorWrapper::moveStepperMotor(). Attempting to move a connection that is not open");

   return  sObj->moveStepperMotor();
}

/**
 * \brief getPosition
 *
 * This function gets the position of the stepper motor*/
int stepperMotorWrapper::getPosition()
{
    if (connected == false)
        throw stepperMotorException("stepperMotorWrapper::getPosition(). Attempting to query a connection that is not open");

    return sObj->getStepperMotorPosition();
}
