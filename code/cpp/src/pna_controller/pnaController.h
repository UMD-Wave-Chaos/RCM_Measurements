/**
* @file pnaController.h
* @brief Header File for the pnaController class
* @details This class handles direct control of an Agilent PNA through the vxi11 protocol
* @author Ben Frazier
* @date 12/13/2018*/
#ifndef PNACONTROLLER_H
#define PNACONTROLLER_H
#include <vector>
#include <string>
#include <map>
#include "clnt_find_services.h"
#include <rpc/pmap_clnt.h>
#include <arpa/inet.h>
#include "vxi11_user.h"
#include "vxi11_wrapper.h"

#include "pnaControllerInterface.h"

class pnaController:public pnaControllerInterface
{
public:
    pnaController();
    ~pnaController();

    //measurement functions
    virtual void connectToInstrument(std::string tcpAddress);
    virtual void findConnections();
    virtual void disconnect();
    virtual void initialize(double fStart, double fStop, int NOP);
    virtual void getUngatedFrequencyDomainSParameters(std::vector<double> &freq, std::vector<double> &S11R, std::vector<double> &S11I,
                                                      std::vector<double> &S12R, std::vector<double> &S12I, std::vector<double> &S21R,
                                                      std::vector<double> &S21I, std::vector<double> &S22R, std::vector<double> &S22I);
    virtual void getGatedFrequencyDomainSParameters(std::vector<double> &freq, std::vector<double> &S11R, std::vector<double> &S11I,
                                                    std::vector<double> &S12R, std::vector<double> &S12I, std::vector<double> &S21R,
                                                    std::vector<double> &S21I, std::vector<double> &S22R, std::vector<double> &S22I);
    virtual void getTimeDomainSParameters(std::vector<double> &time, std::vector<double> &S11R, std::vector<double> &S11I,
                                          std::vector<double> &S12R, std::vector<double> &S12I, std::vector<double> &S21R,
                                          std::vector<double> &S21I, std::vector<double> &S22R, std::vector<double> &S22I);
    virtual void calibrate();
    virtual bool checkCalibration();

    virtual bool getConnectionStatus() {return connected;}

private:
    void getSParameters();
    void unpackSParameters(std::vector<double> &xData, std::vector<double> &S11R, std::vector<double> &S11I,
                           std::vector<double> &S12R, std::vector<double> &S12I, std::vector<double> &S21R,
                           std::vector<double> &S21I, std::vector<double> &S22R, std::vector<double> &S22I);
    bool connected;
    bool calibrated;
    std::string calibrationFileName;
    bool_t who_responded(struct sockaddr_in *addr);
    CLINK vxi_link;
    char rcvBuffer[100];
    double *dataBuffer;
    int bufferSize;
};

#endif // PNACONTROLLER_H
