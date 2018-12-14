/**
* @file pnaWrapper.h
* @brief Header File for the pnaWrapper class
* @details This is the highest level interface provided to interact with the Agilent PNA
* @author Ben Frazier
* @date 12/13/2018*/

#ifndef PNA_WRAPPER_H
#define PNA_WRAPPER_H
#include "pnaControllerInterface.h"
#include "pnaControllerMock.h"
#include "pnaController.h"
#include "pnaExceptions.h"

#include <vector>
#include <string>

class pnaWrapper
{
public:
    pnaWrapper(bool mode);
    ~pnaWrapper();

    bool openConnection();
    bool closeConnection();
    bool listClients();
    void setPNAConfig(double fStart,double fStop, std::string tcpAddress,int NOP);

    std::string getIpAddress(){return ipAddress;}
    void getFrequencyRange(double &fStart, double &fStop){fStart = frequencyRange[0]; fStop = frequencyRange[1];}
    bool getConnected(){return connected;}
    bool getTestMode(){return testMode;}
    int getNumberOfPoints(){return numberOfPoints;}

    void getUngatedFrequencyDomainSParameters();
    void getGatedFrequencyDomainSParameters();
    void getTimeDomainSParameters();

    void getS11Data(std::vector<double> &inR, std::vector<double> &inI);
    void getS12Data(std::vector<double> &inR, std::vector<double> &inI);
    void getS21Data(std::vector<double> &inR, std::vector<double> &inI);
    void getS22Data(std::vector<double> &inR, std::vector<double> &inI);
    void getFrequencyData(std::vector<double> &inF);
    void getTimeData(std::vector<double> &inT);

private:
    void setFrequencyRange(double fStart,double fStop){frequencyRange[0] = fStart; frequencyRange[1] = fStop;}
    void setIpAddress(std::string address){ipAddress = address;}
    void setNumberOfPoints(int NOP) {numberOfPoints = NOP;}
    void initializeSizes();

    pnaControllerInterface* pnaObj;
    double frequencyRange[2];
    std::string ipAddress;

    bool connected;
    bool testMode;
    int numberOfPoints;

    std::vector<double> freqData, timeData, S11R, S11I, S12R, S12I, S21R, S21I, S22R, S22I;
};

#endif //PNA_WRAPPER_H
