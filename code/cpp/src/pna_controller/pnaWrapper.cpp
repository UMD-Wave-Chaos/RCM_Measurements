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
    mType = NO_MEASUREMENT;
    pnaDeviceString = "Not Connected";

    instObj = new instrumentWrapper(mode);

    if (instObj == nullptr)
        throw pnaException("Unable to create instance of pnaController");

    numberOfPoints = 32001;

    bufferSizeDoubles = numberOfPoints*9;
    bufferSizeBytes = bufferSizeDoubles*8;

    dataBuffer = new double[bufferSizeDoubles];

    //set the timeout for measurements to 15 seconds and calibration to 60 seconds
    measureDataTimeout = 15000;
    calibrationTimeout = 60000;
}

/**
 * \brief Destructor
 *
 * This destructor handles clean up*/
pnaWrapper::~pnaWrapper()
{

    if (instObj != nullptr)
        delete instObj;
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
}

/**
 * \brief initializePNA
 *
 * This function initializes the configuration of the PNA*/
void pnaWrapper::initializePNA()
{

    bufferSizeDoubles = numberOfPoints*9;
    bufferSizeBytes = bufferSizeDoubles*8;

    delete dataBuffer;
    dataBuffer = new double[bufferSizeDoubles];

   if (connected != true)
        throw pnaException("pnaWrapper::initializePNA. Cannot initialize the PNA since the connection is not open");


   instObj->sendCommand("SYSTem:PRESet");
   instObj->sendQuery("*OPC?");
   instObj->sendCommand("OUTP ON");

   std::string tBuff = "SENS:FREQ:STAR " + std::to_string(frequencyRange[0]);
   instObj->sendCommand(tBuff);

   tBuff = "SENS:FREQ:STOP " + std::to_string(frequencyRange[1]);
   instObj->sendCommand(tBuff);

   tBuff = "SENS:SWE:POINTS " + std::to_string(numberOfPoints);
   instObj->sendCommand(tBuff);

   instObj->sendCommand("DISP:WIND:Y:AUTO");
   instObj->sendCommand("SENS1:AVER OFF");
   instObj->sendCommand("SENS:SWE:MODE HOLD");
   instObj->sendCommand("TRIG:SOUR MAN");
   instObj->sendCommand("CALC:PAR:DEF CH1_S11,S11");
   instObj->sendCommand("CALC:PAR:DEF CH1_S12,S12");
   instObj->sendCommand("CALC:PAR:DEF CH1_S21,S21");
   instObj->sendCommand("CALC:PAR:DEF CH1_S22,S22");
   instObj->sendCommand("CALC:PAR:SEL CH1_S11");
   instObj->sendCommand("CALC:TRAN:TIME:STATE OFF");
   instObj->sendCommand("CALC:FILT:TIME:STATE OFF");
   instObj->sendCommand("FORM:BORD SWAP");
   instObj->sendCommand("FORM REAL,64");
   instObj->sendCommand("MMEM:STOR:TRAC:FORM:SNP RI");
   instObj->sendCommand("INIT:IMM");
   instObj->sendCommand("*WAI");
}


/**
 * \brief openConnection
 *
 * This function opens the connection to the PNA and initializes the instrument*/
bool pnaWrapper::openConnection()
{
    if (connected == true)
        throw pnaException("pnaWrapper::openConnection. Cannot open a connection, already connected");


    pnaDeviceString = instObj->openConnection(ipAddress);
    connected = instObj->getConnected();
    initializePNA();



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

    instObj->closeConnection();
    connected = instObj->getConnected();

    return connected;
}

/**
 * \brief findClients
 *
 * This function scans for connected clients and reports them*/
std::string pnaWrapper::findClients()
{
    return instObj->findClients();
}

/**
 * \brief checkCalibration
 *
 * This function checks the calibration status of the PNA*/
bool pnaWrapper::checkCalibration()
{
    if (connected == false)
         throw pnaException("pnaWrapper::checkCalibration(). Attempting to query a connection that is closed");

    calibrationFileName = instObj->sendQuery("SENSe:CORRection:CSET:DESC?");

    std::string::size_type pos = 0;
    bool calibrated = false;

    //keep only the string until the newline - remove the starting and ending quotation marks
    if ( (pos = calibrationFileName.find("\n")) != std::string::npos)
    {
        calibrationFileName = calibrationFileName.substr(1,pos-2);
    }

    if (calibrationFileName.compare("No Cal Set selected") == 0)
    {
        calibrated = false;
    }
    else
    {
        calibrated = true;
    }
    return calibrated;
}

/**
 * \brief calibrate
 *
 * This function runs the eCal unit on the PNA to calibrate*/
void pnaWrapper::calibrate()
{
    if (connected == false)
        throw pnaException("pnaWrapper::calibrate(). Attempting to access a connection that is closed");
}

/**
 * \brief getCalibrationFile
 *
 * This function checks the calibration status of the PNA and returns the calibration file name*/
std::string pnaWrapper::getCalibrationFile()
{
    if (connected == false)
         throw pnaException("pnaWrapper::getCalibrationFile(). Attempting to query a connection that is closed");

    bool calibrated = checkCalibration();

    std::string errString = "Not Calibrated";

    if (calibrated)
        return errString;
    else
        return calibrationFileName;
}
/**
 * \brief getSParameters
 *
 * This function retrives the values from the PNA*/
void pnaWrapper::getSParameters()
{
    instObj->sendCommand("INIT:IMM");
    instObj->sendCommand("*WAI");
    instObj->sendCommand("DISP:WIND:Y:AUTO");
    instObj->sendCommand("CALC:DATA:SNP? 2");

    instObj->getData(dataBuffer,bufferSizeBytes,measureDataTimeout);
}

/**
 * \brief unpackSParameters
 *
 * This function unpacks the S-parameters from the data buffer*/
void pnaWrapper::unpackSParameters()
{
    xVec.clear();
    S11R.clear();
    S11I.clear();
    S12R.clear();
    S12I.clear();
    S21R.clear();
    S21I.clear();
    S22R.clear();
    S22I.clear();

    for (unsigned int cnt = 0; cnt < numberOfPoints; cnt++)
    {
        xVec.push_back(dataBuffer[cnt]);
        S11R.push_back(dataBuffer[cnt + numberOfPoints]);
        S11I.push_back(dataBuffer[cnt + 2*numberOfPoints]);
        S12R.push_back(dataBuffer[cnt + 3*numberOfPoints]);
        S12I.push_back(dataBuffer[cnt + 4*numberOfPoints]);
        S21R.push_back(dataBuffer[cnt + 5*numberOfPoints]);
        S21I.push_back(dataBuffer[cnt + 6*numberOfPoints]);
        S22R.push_back(dataBuffer[cnt + 7*numberOfPoints]);
        S22I.push_back(dataBuffer[cnt + 8*numberOfPoints]);
    }

    if (mType == FREQUENCY_MEASUREMENT)
        freqData = xVec;
    else if (mType == TIME_MEASUREMENT)
        timeData = xVec;
    else
        throw pnaException("pnaWrapper::unpackSParameters(). No measurement type selected");
}


/**
 * \brief getUngatedFrequencyDomainSParameters
 *
 * This function gets the ungated S-parameters in the frequency domain*/
void pnaWrapper::getUngatedFrequencyDomainSParameters()
{
    if (connected == false)
        throw pnaException("pnaWrapper::getUngatedFrequencyDomainSParameters(). Attempting to query a measurement for a connection that is closed");

    mType = FREQUENCY_MEASUREMENT;
    checkCalibration();

    //setup the PNA to take an ungated (standard) frequency domain measurement
    instObj->sendCommand("CALC:TRAN:TIME:STATE OFF");
    instObj->sendCommand("CALC:FILT:TIME:STATE OFF");

    getSParameters();
    unpackSParameters();
}

/**
 * \brief getGatedFrequencyDomainSParameters
 *
 * This function gets the gated S-parameters in the frequency domain*/
void pnaWrapper::getGatedFrequencyDomainSParameters(double start_time, double stop_time)
{

    if (connected == false)
        throw pnaException("pnaWrapper::getGatedFrequencyDomainSParameters(). Attempting to query a measurement for a connection that is closed");

    mType = FREQUENCY_MEASUREMENT;
    checkCalibration();

    //setup the PNA to take a gated frequency domain measurement
    instObj->sendCommand("CALC:TRAN:TIME:STATE OFF");
    instObj->sendCommand("CALC:FILT:TIME:STATE ON");
    std::string tBuff = "CALC:FILT:TIME:START " + std::to_string(start_time);
    instObj->sendCommand(tBuff);
    tBuff = "CALC:FILT:TIME:STOP " + std::to_string(stop_time);
    instObj->sendCommand(tBuff);

    getSParameters();
    unpackSParameters();
}

/**
 * \brief getTimeDomainSParameters
 *
 * This function gets the S-parameters in the time domain*/
void pnaWrapper::getTimeDomainSParameters(double start_time, double stop_time)
{

    if (connected == false)
        throw pnaException("pnaWrapper::getTimeDomainSParameters(). Attempting to query a measurement for a connection that is closed");

    mType = TIME_MEASUREMENT;
    checkCalibration();

    //setup the PNA to take a gated time domain measurement
    instObj->sendCommand("CALC:TRAN:TIME:STATE ON");
    instObj->sendCommand("CALC:FILT:TIME:STATE OFF");

    std::string tBuff = "CALC:TRAN:TIME:START " + std::to_string(start_time);

    tBuff = "CALC:TRAN:TIME:STOP " + std::to_string(stop_time);
    instObj->sendCommand(tBuff);

    getSParameters();
    unpackSParameters();

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
