/**
* @file instrumentController.cpp
* @brief Implementation of the instrumentController class
* @details This class handles direct control of an abstract instrument through the vxi11 protocol
* @author Ben Frazier
* @date 04/17/2019*/
#include "instrumentController.h"

#include <functional>

/**
 * \brief constructor
 *
 * This is the primary constructor for the full pna class*/
instrumentController::instrumentController()
{

}

/**
 * \brief destructor
 *
 * This is the primary destructor for the full pna class*/
instrumentController::~instrumentController()
{
    if (connected == true)
        disconnect();

}

/**
 * \brief findConnections
 *
 * This function uses the vxi11 library to find instruments on the network*/
std::string instrumentController::findConnections()
{
    const size_t MAXSIZE = 100;
    char rcv[MAXSIZE];
    timeval t;
    t.tv_sec = 1;
    t.tv_usec = 0;


    vxi11::AddrMap clientMap = vxi11::find_vxi11_clients();

    vxi11::AddrMap::const_iterator iter;

    std::string outString = "Found " + std::to_string(clientMap.size()) + " vxi11 devices\n";

    for (iter=clientMap.begin();iter!= clientMap.end();iter++)
    {
        const vxi11::Ports& port = iter->second;
        outString += "ID: " + iter->first + " : TCP " + std::to_string(port.tcp_port) + " ; UDP " + std::to_string(port.udp_port) + "\n";
        CLINK vxi_link;
        rcv[0] = '\0';
        if ( vxi11_open_device(iter->first.c_str(), &vxi_link) < 0 ) continue;
        int found = vxi11_send_and_receive(&vxi_link, "*IDN?", rcv, MAXSIZE, 10);
        if (found > 0) rcv[found] = '\0';
        outString += " Output: ";
        outString += rcv;
    }

    return outString;
}

/**
 * \brief getConnectionIpAddress
 *
 * This function uses the vxi11 library to find an ip address for a specified instrument on the network*/
std::string instrumentController::getConnectionIpAddress(int count)
{
    const size_t MAXSIZE = 100;
    char rcv[MAXSIZE];
    timeval t;
    t.tv_sec = 1;
    t.tv_usec = 0;

    int testCounter = 0;
    std::string outString = "";

    vxi11::AddrMap clientMap = vxi11::find_vxi11_clients();

    if (count >= clientMap.size())
    {
        std::string eString = "Error, found " + std::to_string(clientMap.size()) +
                              " devices, but requested  index is" + std::to_string(count) +"\n";
        throw instrumentException(eString) ;
    }


    vxi11::AddrMap::const_iterator iter;

    for (iter=clientMap.begin();iter!= clientMap.end();iter++)
    {
        if (count == testCounter)
        {
            outString = iter->first;
        }

        else
        {
            testCounter++;
        }
    }

    return outString;

}

/**
 * \brief disconnect
 *
 * This function disconnects from an instrument*/
void instrumentController::disconnect()
{
    vxi11_close_device(ipAddress.c_str(), &vxi_link);
    connected = false;
}

/**
 * \brief sendCommand
 *
 * This function sends a command string to an instrument*/
void instrumentController::sendCommand(std::string inputString)
{
       vxi11_send(&vxi_link, inputString.c_str());
}

/**
 * \brief sendQuery
 *
 * This function sends a query string to an instrument*/
std::string instrumentController::sendQuery(std::string inputString)
{
    char rcvBuffer[50];
    vxi11_send_and_receive(&vxi_link,inputString.c_str(),rcvBuffer,50,1000);
    std::string outString = rcvBuffer;
    return outString;
}

/**
 * \brief getData
 *
 * This function gets measurement data from an instrument*/
void instrumentController::getData(double *buffer, unsigned int bufferSizeBytes, unsigned int measureDataTimeout)
{
    //receive the data block
    vxi11_receive_data_block(&vxi_link,(char*)buffer,bufferSizeBytes,measureDataTimeout);
}

/**
 * \brief connectToInstrument
 *
 * This function connects to the pna
 * @param tcpAddress the ipAddress to connect to*/
std::string instrumentController::connectToInstrument(std::string tcpAddress)
{
    ipAddress = tcpAddress;
     //establish the connection
    int testConnect = vxi11_open_device(tcpAddress.c_str(), &vxi_link);
    std::string deviceString;

    if (testConnect == 0)
    {
        connected = true;

        //get the device info string
        vxi11_send_and_receive(&vxi_link, "*IDN?", rcvBuffer, 100, 10);
        deviceString = rcvBuffer;

        //remove the newline character at the end of the device string
        if (!deviceString.empty() && deviceString[deviceString.length()-1] == '\n')
        {
            deviceString.erase(deviceString.length() - 1);
        }

    }
    else
    {
        connected = false;
        deviceString = "No connection available";
    }

    return deviceString;
}


/**
 * \brief initialize
 *
 * This function initializes the configuration of the PNA
 * @param fStart the start frequency of the sweep
 * @param fStop the stop frequency of the sweep
 * @param NOP the number of points to collect from the PNA*/
void instrumentController::initialize(double fStartIn, double fStopIn, unsigned int NOP)
{
    numberOfPoints = NOP;
    fStart = fStartIn;
    fStop = fStopIn;
    bufferSizeDoubles = numberOfPoints*9;
    bufferSizeBytes = bufferSizeDoubles*8;

    delete dataBuffer;
    dataBuffer = new double[bufferSizeDoubles];

if (connected == true)
{
    std::string tBuff = "SYSTem:PRESet";
    vxi11_send(&vxi_link, tBuff.c_str());

    vxi11_send_and_receive(&vxi_link, "*OPC?", rcvBuffer, 100, 1000);

    tBuff = "OUTP ON";
    vxi11_send(&vxi_link, tBuff.c_str());

    tBuff = "SENS:FREQ:STAR " + std::to_string(fStart);
    vxi11_send(&vxi_link, tBuff.c_str());

    tBuff = "SENS:FREQ:STOP " + std::to_string(fStop);
    vxi11_send(&vxi_link, tBuff.c_str());

    tBuff = "SENS:SWE:POINTS " + std::to_string(NOP);
    vxi11_send(&vxi_link, tBuff.c_str());

    tBuff = "DISP:WIND:Y:AUTO";
    vxi11_send(&vxi_link, tBuff.c_str());

    tBuff = "SENS1:AVER OFF";
    vxi11_send(&vxi_link, tBuff.c_str());

    tBuff = "SENS:SWE:MODE HOLD";
    vxi11_send(&vxi_link, tBuff.c_str());

    tBuff = "TRIG:SOUR MAN";
    vxi11_send(&vxi_link, tBuff.c_str());

    tBuff = "CALC:PAR:DEF CH1_S11,S11";
    vxi11_send(&vxi_link, tBuff.c_str());

    tBuff = "CALC:PAR:DEF CH1_S12,S12";
    vxi11_send(&vxi_link, tBuff.c_str());

    tBuff = "CALC:PAR:DEF CH1_S21,S21";
    vxi11_send(&vxi_link, tBuff.c_str());

    tBuff = "CALC:PAR:DEF CH1_S22,S22";
    vxi11_send(&vxi_link, tBuff.c_str());

    tBuff = "CALC:PAR:SEL CH1_S11";
    vxi11_send(&vxi_link, tBuff.c_str());

    tBuff = "CALC:TRAN:TIME:STATE OFF";
    vxi11_send(&vxi_link, tBuff.c_str());

    tBuff = "CALC:FILT:TIME:STATE OFF";
    vxi11_send(&vxi_link, tBuff.c_str());

    tBuff = "FORM:BORD SWAP";
    vxi11_send(&vxi_link, tBuff.c_str());

    tBuff = "FORM REAL,64";
    vxi11_send(&vxi_link, tBuff.c_str());

    tBuff = "MMEM:STOR:TRAC:FORM:SNP RI";
    vxi11_send(&vxi_link, tBuff.c_str());

    tBuff = "INIT:IMM";
    vxi11_send(&vxi_link, tBuff.c_str());

    tBuff = "*WAI";
    }
}

/**
 * \brief checkCalibration
 *
 * This function checks to see whether or not the pna has been calibrated */
bool instrumentController::checkCalibration()
{
    char rcvBuffer[50];
    vxi11_send_and_receive(&vxi_link,"SENSe:CORRection:CSET:DESC?",rcvBuffer,50,1000);
    calibrationFileName = rcvBuffer;

    std::string::size_type pos = 0;

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
 * \brief getTimeDomainSParameters
 *@param start_time The start time to use for the transform
 *@param stop_time The stop time to use for the transform
 * This function gets the S-parameters in the time domain*/
void instrumentController::getTimeDomainSParameters(double start_time, double stop_time)
{

    checkCalibration();

    //setup the PNA to take a gated frequency domain measurement
    std::string tBuff = "CALC:TRAN:TIME:STATE ON";
    vxi11_send(&vxi_link, tBuff.c_str());

    tBuff = "CALC:FILT:TIME:STATE OFF";
    vxi11_send(&vxi_link, tBuff.c_str());

    tBuff = "CALC:TRAN:TIME:START " + std::to_string(start_time);
    vxi11_send(&vxi_link, tBuff.c_str());

    tBuff = "CALC:TRAN:TIME:STOP " + std::to_string(stop_time);
    vxi11_send(&vxi_link, tBuff.c_str());

    //now get the S parameters
    getSParameters();

    //unpack
    unpackSParameters();
}

/**
 * \brief getUngatedFrequencyDomainSParameters
 *
 * This function gets the ungated S-parameters in the frequency domain*/
void instrumentController::getUngatedFrequencyDomainSParameters()
{
    checkCalibration();

    //setup the PNA to take an ungated (standard) frequency domain measurement
    std::string tBuff = "CALC:TRAN:TIME:STATE OFF";
    vxi11_send(&vxi_link, tBuff.c_str());

    tBuff = "CALC:FILT:TIME:STATE OFF";
    vxi11_send(&vxi_link, tBuff.c_str());

    //now get the S parameters
    getSParameters();

    //unpack
    unpackSParameters();
}

/**
 * \brief getGatedFrequencyDomainSParameters
 **@param start_time The start time to use for gating
 *@param stop_time The stop time to use for gating
 * This function gets the gated S-parameters in the frequency domain*/
void instrumentController::getGatedFrequencyDomainSParameters(double start_time, double stop_time)
{
    checkCalibration();

    //setup the PNA to take a gated frequency domain measurement
    std::string tBuff = "CALC:TRAN:TIME:STATE OFF";
    vxi11_send(&vxi_link, tBuff.c_str());

    tBuff = "CALC:FILT:TIME:STATE ON";
    vxi11_send(&vxi_link, tBuff.c_str());

    tBuff = "CALC:FILT:TIME:START " + std::to_string(start_time);
    vxi11_send(&vxi_link, tBuff.c_str());

    tBuff = "CALC:FILT:TIME:STOP " + std::to_string(stop_time);
    vxi11_send(&vxi_link, tBuff.c_str());

    //now get the S parameters
    getSParameters();

    //unpack
    unpackSParameters();
}

/**
 * \brief getSParameters
 *
 * This function retrives the values from the PNA*/
void instrumentController::getSParameters()
{

    std::string tBuff = "INIT:IMM";
    vxi11_send(&vxi_link, tBuff.c_str());

    tBuff = "*WAI";
    vxi11_send(&vxi_link, tBuff.c_str());

    tBuff = "DISP:WIND:Y:AUTO";
    vxi11_send(&vxi_link, tBuff.c_str());

    tBuff = "CALC:DATA:SNP? 2";
    vxi11_send(&vxi_link, tBuff.c_str());

    //receive the data block
    vxi11_receive_data_block(&vxi_link,(char*)dataBuffer,bufferSizeBytes,measureDataTimeout);

}

/**
 * \brief calibrate
 *
 * This function calibrates the PNA*/
void instrumentController::calibrate()
{
    std::string tBuff = "SENS:SWE:POINTS " + std::to_string(numberOfPoints);
    vxi11_send(&vxi_link, tBuff.c_str());

    tBuff = "SENS1:AVER:COUN 5";
    vxi11_send(&vxi_link, tBuff.c_str());

    tBuff = "SENS1:AVER ON";
    vxi11_send(&vxi_link, tBuff.c_str());

    tBuff = "SENS1:AVER:CLE";
    vxi11_send(&vxi_link, tBuff.c_str());

    tBuff = "SENS:CORR:PREF:CSET:SAVE USER";
    vxi11_send(&vxi_link, tBuff.c_str());

    tBuff = "SENS:CORR:Pref:cset:savu 1";
    vxi11_send(&vxi_link, tBuff.c_str());

    tBuff = "SENS:FREQ:STAR " + std::to_string(fStart);
    vxi11_send(&vxi_link, tBuff.c_str());

    tBuff = "SENS:FREQ:STOP " + std::to_string(fStop);
    vxi11_send(&vxi_link, tBuff.c_str());

    tBuff = "CALC:PAR:DEL:ALL";
    vxi11_send(&vxi_link, tBuff.c_str());

    tBuff = "calc:par:def ""test"", S11";
    vxi11_send(&vxi_link, tBuff.c_str());

    tBuff = "calc:par:sel ""test""";
    vxi11_send(&vxi_link, tBuff.c_str());

    tBuff = "DISPlay:WINDow1:TRACe1:FEED ""test""";
    vxi11_send(&vxi_link, tBuff.c_str());

    tBuff = "DISP:WIND:Y:AUTO";
    vxi11_send(&vxi_link, tBuff.c_str());

    tBuff = "SENSe:CORRection:COLL:Meth SPARSOLT";
    vxi11_send(&vxi_link, tBuff.c_str());

    tBuff = "SENSe:CORRection:COLL:ACQ ECAL1";
    vxi11_send(&vxi_link, tBuff.c_str());

    vxi11_send_and_receive(&vxi_link, "*OPC?", rcvBuffer, 100, 60000);

    checkCalibration();

    initialize(fStart, fStop, numberOfPoints);

}
