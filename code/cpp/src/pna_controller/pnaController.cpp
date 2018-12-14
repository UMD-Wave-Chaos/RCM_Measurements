/**
* @file pnaController.cpp
* @brief Implementation of the pnaController class
* @details This class handles direct control of an Agilent PNA through the vxi11 protocol
* @author Ben Frazier
* @date 12/13/2018*/
#include "pnaController.h"

#include <functional>

/**
 * \brief constructor
 *
 * This is the primary constructor for the full pna class*/
pnaController::pnaController()
{
   connected = false;
   calibrationFileName = "";
   calibrated = false;

   bufferSize = 32001*9;

   dataBuffer = new double[bufferSize];

}

/**
 * \brief destructor
 *
 * This is the primary destructor for the full pna class*/
pnaController::~pnaController()
{
 delete dataBuffer;
}

/**
 * \brief findConnections
 *
 * This function uses the vxi11 library to find instruments on the network*/
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

    vxi11::AddrMap::const_iterator iter;
    for (iter=clientMap.begin();iter!= clientMap.end();iter++) {
        const vxi11::Ports& port = iter->second;
        std::cout << " Found: " << iter->first << " : TCP " << port.tcp_port
             << "; UDP " << port.udp_port << std::endl;
        CLINK vxi_link;
        rcv[0] = '\0';
        if ( vxi11_open_device(iter->first.c_str(), &vxi_link) < 0 ) continue;
        int found = vxi11_send_and_receive(&vxi_link, "*IDN?", rcv, MAXSIZE, 10);
        if (found > 0) rcv[found] = '\0';
        std::cout << "  Output: " << rcv << std::endl;
    }

}

/**
 * \brief disconnect
 *
 * This function disconnects from an instrument*/
void pnaController::disconnect()
{
    //TBD - handle closing the device
    connected = false;
}

/**
 * \brief connectToInstrument
 *
 * This function connects to the pna
 * @param tcpAddress the ipAddress to connect to*/
void pnaController::connectToInstrument(std::string tcpAddress)
{
     //establish the connection
    int testConnect = vxi11_open_device(tcpAddress.c_str(), &vxi_link);
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


/**
 * \brief initialize
 *
 * This function initializes the configuration of the PNA
 * @param fStart the start frequency of the sweep
 * @param fStop the stop frequency of the sweep
 * @param NOP the number of points to collect from the PNA*/
void pnaController::initialize(double fStart, double fStop, int NOP)
{

    bufferSize = NOP*9;

    delete dataBuffer;
    dataBuffer = new double[bufferSize];

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

    double *f = new double[10];
    double *s1= new double[10];
    double *s2= new double[10];
    double *s3= new double[10];
    double *s4= new double[10];

    checkCalibration();
    }
}

/**
 * \brief checkCalibration
 *
 * This function checks to see whether or not the pna has been calibrated */
bool pnaController::checkCalibration()
{
    //TBD - query for the cal file

    return calibrated;
}

/**
 * \brief getTimeDomainSParameters
 *
 * This function gets the S-parameters in the time domain*/
void pnaController::getTimeDomainSParameters(std::vector<double> &time, std::vector<double> &S11R, std::vector<double> &S11I,
                                             std::vector<double> &S12R, std::vector<double> &S12I, std::vector<double> &S21R,
                                             std::vector<double> &S21I, std::vector<double> &S22R, std::vector<double> &S22I)
{

    checkCalibration();

/* Matlab implementation
    %setup the PNA to take time domain measurements
    fprintf(obj1, 'CALC:TRAN:TIME:STATE ON'); % turn time transform on
    fprintf(obj1, 'CALC:FILT:TIME:STATE OFF'); % turn time gating on

    %set the start and stop time for the gating
    fprintf(obj1, ['CALC:TRAN:TIME:START ', num2str(start_time)]);
    fprintf(obj1, ['CALC:TRAN:TIME:STOP ', num2str(stop_time)]);

    %check to make sure the start time is within the valid range of the PNA,
    %must be < (NOP-1)/delta Freq
    tstart = query(obj1, 'CALC:TRAN:TIME:STAR?');

    if (start_time < str2num(tstart))
        wstring = sprintf ('Requested start time %f is less than min PNA start time %s, setting to min PNA start time',start_time, tstart);
        warning(wstring);
        fprintf(obj1, 'CALC:TRAN:TIME:START MIN');
    end

    %check to make sure the stop time is within the valid range of the PNA,
    %must be > -(NOP-1)/delta Freq
    tstop = query(obj1, 'CALC:TRAN:TIME:STOP?');

    if (stop_time > str2num(tstop))
        wstring = sprintf ('Requested stop time %f is greater than max PNA stop time %s, setting to max PNA stop time',stop_time, tstop);
        warning(wstring);
        fprintf(obj1, 'CALC:TRAN:TIME:STOP MAX');
    end

    %now get the S parameters
    [t,SCt11,SCt12,SCt21,SCt22] = getSParameters(obj1,NOP);
      */
}

/**
 * \brief getUngatedFrequencyDomainSParameters
 *
 * This function gets the ungated S-parameters in the frequency domain*/
void pnaController::getUngatedFrequencyDomainSParameters(std::vector<double> &freq, std::vector<double> &S11R, std::vector<double> &S11I,
                                                         std::vector<double> &S12R, std::vector<double> &S12I, std::vector<double> &S21R,
                                                         std::vector<double> &S21I,std::vector<double> &S22R, std::vector<double> &S22I)
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
    unpackSParameters(freq, S11R, S11I, S12R, S12I, S21R, S21I, S22R, S22I);
}

/**
 * \brief getGatedFrequencyDomainSParameters
 *
 * This function gets the gated S-parameters in the frequency domain*/
void pnaController::getGatedFrequencyDomainSParameters(std::vector<double> &freq, std::vector<double> &S11R, std::vector<double> &S11I,
                                                       std::vector<double> &S12R, std::vector<double> &S12I, std::vector<double> &S21R,
                                                       std::vector<double> &S21I, std::vector<double> &S22R, std::vector<double> &S22I)
{
    checkCalibration();

    //setup the PNA to take a gated frequency domain measurement
    std::string tBuff = "CALC:TRAN:TIME:STATE OFF";
    vxi11_send(&vxi_link, tBuff.c_str());

    tBuff = "CALC:FILT:TIME:STATE OFF";
    vxi11_send(&vxi_link, tBuff.c_str());

    //now get the S parameters
    getSParameters();

    //unpack
    unpackSParameters(freq, S11R, S11I, S12R, S12I, S21R, S21I, S22R, S22I);
}

/**
 * \brief unpackSParameters
 *
 * This function unpacks the S-parameters from the data buffer*/
void pnaController::unpackSParameters(std::vector<double> &xData, std::vector<double> &S11R, std::vector<double> &S11I,
                                      std::vector<double> &S12R, std::vector<double> &S12I, std::vector<double> &S21R,
                                      std::vector<double> &S21I, std::vector<double> &S22R, std::vector<double> &S22I)
{

}


/**
 * \brief getSParameters
 *
 * This function retrives the values from the PNA*/
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

    //TBD - handle receive
    vxi11_receive_data_block(&vxi_link,(char*)dataBuffer,bufferSize*4,20);

    /* Matlab implementation
    X = binblockread(obj1, 'float64'); %read the data from the PNA
    fprintf(obj1, '*WAI'); % wait until data tranfer is complete

    %get the xAxis data (will be either frequency or time)
    xValue = X(1:(NOP));

    %Get the real and imaginary components of the S parameters
    S11R = X(NOP+1:NOP+(NOP));         S11I = X(2*NOP+1:2*NOP+(NOP));
    S21R = X(3*NOP+1:3*NOP+(NOP));     S21I = X(4*NOP+1:4*NOP+(NOP));
    S12R = X(5*NOP+1:5*NOP+(NOP));     S12I = X(6*NOP+1:6*NOP+(NOP));
    S22R = X(7*NOP+1:7*NOP+(NOP));     S22I = X(8*NOP+1:8*NOP+(NOP));

    */

}

/**
 * \brief calibrate
 *
 * This function calibrates the PNA*/
void pnaController::calibrate()
{
    /*Matlab implementation

 %update the timeout because the calibration takes awhile
 timeout = get(obj1,'Timeout');
 set(obj1,'Timeout',60);

% Communicating with instrument object, obj1.
fprintf(obj1, ['SENS:SWE:POINTS ', num2str(NOP)]); % set number of points
fprintf(obj1, 'SENS1:AVER:COUN 5'); % set count to 5
fprintf(obj1, 'SENS1:AVER ON'); % turn (keep) averaging on
fprintf(obj1, 'SENS1:AVER:CLE');  % restart averaging
fprintf(obj1, 'SENS:CORR:PREF:CSET:SAVE USER');
%fprintf(obj1, 'SENS:CORR:Pref:cset:savu 1');
fprintf(obj1, ['SENS:FREQ:START ', num2str(START)]); % set start frequency
fprintf(obj1, ['SENS:FREQ:STOP ', num2str(STOP)]); % set stop frequency
fprintf(obj1,'CALC:PAR:DEL:ALL');
fprintf(obj1, 'calc:par:def "test", S11');
fprintf(obj1, 'calc:par:sel "test"');
fprintf(obj1, 'DISPlay:WINDow1:TRACe1:FEED "test"');
fprintf(obj1, 'DISP:WIND:Y:AUTO'); % Autoscale
if np == 1 % Check if the calibration is 1 or 2 ports and set up accordingly
    fprintf(obj1, 'SENSe:CORRection:COLL:Meth REFL3');
else
    fprintf(obj1, 'SENSe:CORRection:COLL:Meth SPARSOLT');
end
fprintf(obj1, 'SENSe:CORRection:COLL:ACQ ECAL1'); % cal calibration data
Done = query(obj1,'*OPC?');

lstring = sprintf('Calibration Step Completed ...');
 if (useGUI == true)
     logMessage(handles.jEditbox,lstring);
 else
     disp(lstring)
 end

 %reset the timeout
  set(obj1,'Timeout',timeout);

G = query(obj1, ['SENS:CORR:CSET:CAT?']);
GC = strread(G, '%s', length(find(G == ','))+1, 'delimiter', ',');
N = query(obj1, ['SENS:CORR:CSET:CAT? NAME']);
NC = strread(N, '%s', length(find(N == ','))+1, 'delimiter', ',');
k = strfind(NC, NAME);
for l = 1:length(find(N == ','))+1
empt = isempty(cell2mat(k(l)));
if ~empt
    km = l;
end
end
if exist('km','var')
DELNAME = char(GC(km));
fprintf(obj1, ['SENS:CORR:CSET:DEL "',DELNAME,'"']);
end
fprintf(obj1, ['SENS:CORR:CSET:NAME "',NAME,'"']);

temp = strtrim(query(obj1,'SENSe:CORRection:CSET:DESC?'));
calFileName = temp(2:end-1);
     *
     * */
}
