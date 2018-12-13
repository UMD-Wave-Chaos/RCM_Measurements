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
    virtual void connectToInstrument();
    virtual void initialize(double fStart, double fStop, int NOP);
    virtual void getTimeDomainSParameters(double* time,
                                  double* S11,
                                  double* S12,
                                  double* S21,
                                  double* S22);

    virtual void getFrequencyDomainSParameters(double* freq,
                                        double* S11,
                                        double* S12,
                                        double* S21,
                                        double* S22);
    virtual void calibrate();
    virtual bool checkCalibration();

    virtual std::vector<double> getFrequencyRange(){return frequencyRange;}
    virtual bool getConnectionStatus() {return connected;}

private:
    void findConnections();
    void getSParameters();
    int numberOfPoints;
    std::vector<double> frequencyRange;
    bool connected;
    bool calibrated;
    std::string calibrationFileName;
    bool_t who_responded(struct sockaddr_in *addr);
    CLINK vxi_link;
    char rcvBuffer[100];
    char *dataBuffer;
};

#endif // PNACONTROLLER_H
