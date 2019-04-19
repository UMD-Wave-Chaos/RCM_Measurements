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
        int found = static_cast<int>(vxi11_send_and_receive(&vxi_link, "*IDN?", rcv, MAXSIZE, 10));
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
    timeval t;
    t.tv_sec = 1;
    t.tv_usec = 0;

    int testCounter = 0;
    std::string outString = "";

    vxi11::AddrMap clientMap = vxi11::find_vxi11_clients();

    if (count >= static_cast<int>(clientMap.size()))
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
