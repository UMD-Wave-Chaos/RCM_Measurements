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

}

/**
 * \brief destructor
 *
 * This is the primary destructor for the full pna class*/
pnaController::~pnaController()
{
    if (connected == true)
        disconnect();

}

/**
 * \brief findConnections
 *
 * This function uses the vxi11 library to find instruments on the network*/
std::string pnaController::findConnections()
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
        outString += "\n";
    }

    return outString;
}

/**
 * \brief disconnect
 *
 * This function disconnects from an instrument*/
void pnaController::disconnect()
{
    vxi11_close_device(ipAddress.c_str(), &vxi_link);
    connected = false;
}

/**
 * \brief connectToInstrument
 *
 * This function connects to the pna
 * @param tcpAddress the ipAddress to connect to*/
std::string pnaController::connectToInstrument(std::string tcpAddress)
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

        //check whether or not we've been calibrated
        checkCalibration();
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
void pnaController::initialize(double fStart, double fStop, unsigned int NOP)
{
    numberOfPoints = NOP;
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
bool pnaController::checkCalibration()
{
    //TBD - query for the cal file

    return calibrated;
}

/**
 * \brief getTimeDomainSParameters
 *@param start_time The start time to use for the transform
 *@param stop_time The stop time to use for the transform
 * This function gets the S-parameters in the time domain*/
void pnaController::getTimeDomainSParameters(double start_time, double stop_time)
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

    mType = TIME_MEASUREMENT;
}

/**
 * \brief getUngatedFrequencyDomainSParameters
 *
 * This function gets the ungated S-parameters in the frequency domain*/
void pnaController::getUngatedFrequencyDomainSParameters()
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

    mType = FREQUENCY_MEASUREMENT;
}

/**
 * \brief getGatedFrequencyDomainSParameters
 **@param start_time The start time to use for gating
 *@param stop_time The stop time to use for gating
 * This function gets the gated S-parameters in the frequency domain*/
void pnaController::getGatedFrequencyDomainSParameters(double start_time, double stop_time)
{
    checkCalibration();

    //setup the PNA to take a gated frequency domain measurement
    std::string tBuff = "CALC:TRAN:TIME:STATE OFF";
    vxi11_send(&vxi_link, tBuff.c_str());

    tBuff = "CALC:FILT:TIME:STATE ON";
    vxi11_send(&vxi_link, tBuff.c_str());

    tBuff = "CALC:FILT:TIME:START " + std::to_string(start_time);
    vxi11_send(&vxi_link, tBuff.c_str());

    tBuff = "CALC:FILT:TIME:STOP" + std::to_string(stop_time);
    vxi11_send(&vxi_link, tBuff.c_str());

    //now get the S parameters
    getSParameters();

    //unpack
    unpackSParameters();

    mType = FREQUENCY_MEASUREMENT;
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

    //receive the data block
    vxi11_receive_data_block(&vxi_link,(char*)dataBuffer,bufferSizeBytes,measureDataTimeout);

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
