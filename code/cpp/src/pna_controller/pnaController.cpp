#include "pnaController.h"

#include <functional>

pnaController::pnaController()
{
   connected = false;
   frequencyRange.reserve(2);
   calibrationFileName = "";
   calibrated = false;

   dataBuffer = new char[320001*4*2*4];

   connectToInstrument();
}

pnaController::~pnaController()
{
 delete dataBuffer;
}

void pnaController::findConnections()
{

    enum clnt_stat clnt_stat;
    const size_t MAXSIZE = 100;
    char rcv[MAXSIZE];
    timeval t;
    t.tv_sec = 1;
    t.tv_usec = 0;

    struct sockaddr_in test;

     vxi11::AddrMap clientMap = vxi11::find_vxi11_clients();

    //bool_t (pnaController::*func)(struct sockaddr_in*);
   // func = &pnaController::who_responded;

    //std::function<bool_t(struct sockaddr_in *)> callback = this->who_responded (&test);

    //callback = std::bind(&pnaController::who_responded));


    // Why 6 for the protocol for the VXI-11 devices?  Not sure, but the devices
    // will otherwise not respond.
   // clnt_stat = clnt_find_services(DEVICE_CORE, DEVICE_CORE_VERSION, 6, &t,
     //                                                         this->*func);
/*
    AddrMap::const_iterator iter;
    for (iter=gfFoundDevs.begin();iter!= gfFoundDevs.end();iter++) {
        const Ports& port = iter->second;
        std::cout << " Found: " << iter->first << " : TCP " << port.tcp_port
             << "; UDP " << port.udp_port << std::endl;
        CLINK vxi_link;
        rcv[0] = '\0';
        if ( vxi11_open_device(iter->first.c_str(), &vxi_link) < 0 ) continue;
        int found = vxi11_send_and_receive(&vxi_link, "*IDN?", rcv, MAXSIZE, 10);
        if (found > 0) rcv[found] = '\0';
        std::cout << "  Output: " << rcv << std::endl;
    }*/

}

/*bool_t pnaController::who_responded(struct sockaddr_in *addr)
{
  char str[INET_ADDRSTRLEN];
  const char* an_addr = inet_ntop(AF_INET, &(addr->sin_addr), str, INET_ADDRSTRLEN);
  if ( gfFoundDevs.find( std::string(an_addr) ) != gfFoundDevs.end() ) return 0;
  int port_T = pmap_getport(addr, DEVICE_CORE, DEVICE_CORE_VERSION, IPPROTO_TCP);
  int port_U = pmap_getport(addr, DEVICE_CORE, DEVICE_CORE_VERSION, IPPROTO_UDP);
  gfFoundDevs[ std::string( an_addr ) ] = Ports(port_T, port_U);
  return 0;
}*/

void pnaController::connectToInstrument()
{
     //establish the connection
    std::string tcpString = "169.254.13.58";
    int testConnect = vxi11_open_device(tcpString.c_str(), &vxi_link);
    std::cout<<"Test Connect: " << testConnect << std::endl;
    if (testConnect == 0)
    {
        connected = true;
        int found = vxi11_send_and_receive(&vxi_link, "*IDN?", rcvBuffer, 100, 10);
        if (found > 0) rcvBuffer[found] = '\0';
            std::cout << "  Output: " << rcvBuffer << std::endl;
    }
    else
    {
        connected = false;
        std::cout << "Not Connected" << std::endl;
    }

    //check whether or not we've been calibrated
    checkCalibration();
}

void pnaController::initialize(double fStart, double fStop, int NOP)
{
    frequencyRange[0] = fStart;
    frequencyRange[1] = fStop;
    numberOfPoints = NOP;

if (connected == true)
{
    std::string tBuff = "SYSTem:PRESet";
    vxi11_send(&vxi_link, tBuff.c_str());

    int ready = vxi11_send_and_receive(&vxi_link, "*OPC?", rcvBuffer, 100, 10);

    tBuff = "OUTP ON";
    vxi11_send(&vxi_link, tBuff.c_str());

    tBuff = "SENS:FREQ:STAR " + std::to_string(fStart);
    vxi11_send(&vxi_link, tBuff.c_str());

    tBuff = "SENS:FREQ:STOP " + std::to_string(fStop);
    vxi11_send(&vxi_link, tBuff.c_str());

    tBuff = "SENS:SWE:POINTS " + std::to_string(numberOfPoints);
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

    double *f = new double[10];
    double *s1= new double[10];
    double *s2= new double[10];
    double *s3= new double[10];
    double *s4= new double[10];

    getFrequencyDomainSParameters(f,s1,s2,s3,s4);

    /*
    fprintf(obj1,['CALC:PAR:DEF ', 'CH1_S11',',S11']); %(S11) Define the measurement trace.
    fprintf(obj1,['CALC:PAR:DEF ', 'CH1_S12',',S12']); %(S12) Define the measurement trace.
    fprintf(obj1,['CALC:PAR:DEF ', 'CH1_S21',',S21']); %(S21) Define the measurement trace.
    fprintf(obj1,['CALC:PAR:DEF ', 'CH1_S22',',S22']); %(S22) Define the measurement trace.


    */
    checkCalibration();
}
else
{

}

}


bool pnaController::checkCalibration()
{
    //check whether or not we've been calibrated

    return calibrated;
}

void pnaController::getTimeDomainSParameters(double* time,
                                              double* S11,
                                              double* S12,
                                              double* S21,
                                              double* S22)
{

}

void pnaController::getFrequencyDomainSParameters(double* freq,
                                                   double* S11,
                                                   double* S12,
                                                   double* S21,
                                                   double* S22)
{

    //setup the PNA to take an ungated (standard) frequency domain measurement

    std::string tBuff = "CALC:TRAN:TIME:STATE OFF";
    vxi11_send(&vxi_link, tBuff.c_str());

    tBuff = "CALC:FILT:TIME:STATE OFF";
    vxi11_send(&vxi_link, tBuff.c_str());

    //now get the S parameters

    getSParameters();

}

void pnaController::getSParameters()
{

    std::string tBuff = "INIT:IMM";
    vxi11_send(&vxi_link, tBuff.c_str());

    tBuff = "*WAI";
    vxi11_send(&vxi_link, tBuff.c_str());

    tBuff = "DISP:WIND:Y:AUTO";
    vxi11_send(&vxi_link, tBuff.c_str());

    tBuff = "CALC:DATA:SNP? 2";
    vxi11_send(&vxi_link, tBuff.c_str());

    vxi11_receive_data_block(&vxi_link,dataBuffer,numberOfPoints*(4*2+1)*4,20);

    /*
    X = binblockread(obj1, 'float64'); %read the data from the PNA
    fprintf(obj1, '*WAI'); % wait until data tranfer is complete

    %get the xAxis data (will be either frequency or time)
    xValue = X(1:(NOP));

    %Get the real and imaginary components of the S parameters
    S11R = X(NOP+1:NOP+(NOP));         S11I = X(2*NOP+1:2*NOP+(NOP));
    S21R = X(3*NOP+1:3*NOP+(NOP));     S21I = X(4*NOP+1:4*NOP+(NOP));
    S12R = X(5*NOP+1:5*NOP+(NOP));     S12I = X(6*NOP+1:6*NOP+(NOP));
    S22R = X(7*NOP+1:7*NOP+(NOP));     S22I = X(8*NOP+1:8*NOP+(NOP));

    %convert to complex variables
    S11 = S11R + 1i*S11I;
    S12 = S21R + 1i*S21I;
    S21 = S12R + 1i*S12I;
    S22 = S22R + 1i*S22I;
    */

}

void pnaController::calibrate()
{

}
