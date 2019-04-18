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

    bool openConnection();
    bool closeConnection();
    std::string findClients();
    void setInstrumentConfiguration(double fStart,double fStop, std::string tcpAddress,unsigned int NOP);

    void sendCommand(std::string inputString);

    std::string getConnectionIpAddress(int count);

    std::string getIpAddress(){return ipAddress;}
    void getFrequencyRange(double &fStart, double &fStop){fStart = frequencyRange[0]; fStop = frequencyRange[1];}
    bool getConnected(){return connected;}
    bool getTestMode(){return testMode;}
    unsigned int getNumberOfPoints(){return numberOfPoints;}

    void getUngatedFrequencyDomainSParameters();
    void getGatedFrequencyDomainSParameters(double start_time, double stop_time);
    void getTimeDomainSParameters(double start_time, double stop_time);

    void getS11Data(std::vector<double> &inR, std::vector<double> &inI);
    void getS12Data(std::vector<double> &inR, std::vector<double> &inI);
    void getS21Data(std::vector<double> &inR, std::vector<double> &inI);
    void getS22Data(std::vector<double> &inR, std::vector<double> &inI);
    void getFrequencyData(std::vector<double> &inF);
    void getTimeData(std::vector<double> &inT);

    void calibrate();

    bool checkCalibration();
    std::string getCalibrationFile();
    std::string getInstrumentDeviceString(){return instDeviceString;}
private:
    void setFrequencyRange(double fStart,double fStop){frequencyRange[0] = fStart; frequencyRange[1] = fStop;}
    void setIpAddress(std::string address){ipAddress = address;}
    void setNumberOfPoints(unsigned int NOP) {numberOfPoints = NOP;}
    void initializeSizes();

    instrumentControllerInterface* instObj;
    double frequencyRange[2];
    std::string ipAddress;

    bool connected;
    bool testMode;
    unsigned int numberOfPoints;

    std::string instDeviceString;
    std::vector<double> freqData, timeData, S11R, S11I, S12R, S12I, S21R, S21I, S22R, S22I;

};

#endif //INSTRUMENT_WRAPPER_H
