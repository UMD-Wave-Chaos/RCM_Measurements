/**
* @file instrumentWrapper.h
* @brief Header File for the instrumentWrapper class
* @details This is the highest level interface provided to interact with abstract instruments
* @author Ben Frazier
* @date 04/17/2019*/

#ifndef INSTRUMENT_WRAPPER_H
#define INSTRUMENT_WRAPPER_H
#include "instrumentControllerInterface.h"
#include "instrumentControllerMock.h"
#include "instrumentController.h"
#include "instrumentExceptions.h"

#include <vector>
#include <string>

class instrumentWrapper
{
public:
    instrumentWrapper(bool mode);
    ~instrumentWrapper();

    std::string openConnection(std::string ipAddress);
    bool closeConnection();
    std::string findClients();
    void setInstrumentConfiguration(double fStart,double fStop, std::string tcpAddress,unsigned int NOP);//TBD - remove

    void sendCommand(std::string inputString);
    std::string sendQuery(std::string inputString);
    void getData(double *buffer, unsigned int bufferSizeBytes, unsigned int measureDataTimeout);

    std::string getConnectionIpAddress(int count);

    std::string getIpAddress(){return ipAddress;}
    void getFrequencyRange(double &fStart, double &fStop){fStart = frequencyRange[0]; fStop = frequencyRange[1];}//TBD - remove
    bool getConnected(){return connected;}
    bool getTestMode(){return testMode;}
    unsigned int getNumberOfPoints(){return numberOfPoints;}//TBD - remove

    void getUngatedFrequencyDomainSParameters();//TBD - remove
    void getGatedFrequencyDomainSParameters(double start_time, double stop_time);//TBD - remove
    void getTimeDomainSParameters(double start_time, double stop_time);//TBD - remove

    void getS11Data(std::vector<double> &inR, std::vector<double> &inI);//TBD - remove
    void getS12Data(std::vector<double> &inR, std::vector<double> &inI);//TBD - remove
    void getS21Data(std::vector<double> &inR, std::vector<double> &inI);//TBD - remove
    void getS22Data(std::vector<double> &inR, std::vector<double> &inI);//TBD - remove
    void getFrequencyData(std::vector<double> &inF);//TBD - remove
    void getTimeData(std::vector<double> &inT);//TBD - remove

    void calibrate();//TBD - remove

    bool checkCalibration();//TBD - remove
    std::string getCalibrationFile();//TBD - remove
    std::string getInstrumentDeviceString(){return instDeviceString;}
private:
    void setFrequencyRange(double fStart,double fStop){frequencyRange[0] = fStart; frequencyRange[1] = fStop;}
    void setIpAddress(std::string address){ipAddress = address;}
    void setNumberOfPoints(unsigned int NOP) {numberOfPoints = NOP;}
    void initializeSizes(); //TBD - remove

    instrumentControllerInterface* instObj;
    double frequencyRange[2]; //TBD - remove
    std::string ipAddress;//TBD - remove

    bool connected;
    bool testMode;
    unsigned int numberOfPoints;//TBD - remove

    std::string instDeviceString;
    std::vector<double> freqData, timeData, S11R, S11I, S12R, S12I, S21R, S21I, S22R, S22I;//TBD - remove

};

#endif //INSTRUMENT_WRAPPER_H
