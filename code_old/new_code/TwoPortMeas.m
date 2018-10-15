function [t, SCt, Freq, SCf, Srad] = TwoPortMeas(cal_name,gt,st,et, N)
% Input: cal_name: the name of the calibration set with the appropriate measurement frequency range
%        gt: the gating time in seconds. The gating window covers -gt to gt
%        seconds
%        st,  et: start and stop time, respectively. If applicable, t will
%        span p-st to et.
%        N: number of realization
% Output: t -- array of corresponding time values
%         SCt  -- complex time domain s parameter responses
%         Freq -- array of corresponding frequency values
%         SCf -- complex frequency domain s parameter responses
%         Srad -- time gated complex frequency domain s parameter responses
%% Find a VISA-TCPIP object and the serial port.
tic; display('Measuring and storing S(freq.) ...');
% Find the VNA instrument.
obj1 = instrfind('Type', 'visa-tcpip', 'RsrcName', 'TCPIP::169.254.82.72::INSTR', 'Tag', '');
if isempty(obj1) % Create the visa TCPIP object if it does not exist
    obj1 = visa('agilent','TCPIP0::PNA::inst0::INSTR');
else
    fclose(obj1);
end
obj1.InputBufferSize = 4194304; % increase the buffer size
obj1.Timeout = 15; % increase the timeout time to 15 sec
s1 = serial('COM5', 'BaudRate', 57600,'Terminator', 'CR'); % Create serial port for the Stepper Motor
fopen(obj1);
fopen(s1);
NOP = 32001; % number of points
Srad = zeros(NOP,N,4);
SCf = zeros(NOP,N,4);
SCt = zeros(NOP,N,4);
for i = 1:N
    %% Rotate the mode stirrer (1/50) * 360 degrees
    DIRECTION = 1;
    fprintf(s1,['I',num2str(DIRECTION*64*4),',1000,0,0,5000,5000,1000,0,1000,1000,50,64']); pause(0.5); % move the steppermotor counterclockwise by 1.8 degrees
    %% Compute and Capture S parameter Measurements
    fprintf(obj1, 'SYSTem:PRESet'); % preset to factory defined default settings
    ready = query(obj1, '*OPC?'); % Check if preset is complete
    %fprintf(obj1,['SENS1:CORR:CSET:ACT "',cal_name ,'",1']); % switch to condition of last cal.
    fprintf(obj1, ['SENS:SWE:POINTS ', num2str(NOP)]); % set number of points
    fprintf(obj1, 'SENS1:AVER OFF'); % turn averaging off
    fprintf(obj1, 'SENS:SWE:MODE HOLD'); % set sweep mode to hold
    fprintf(obj1, 'TRIG:SOUR MAN'); % set triggering to manual
    fprintf(obj1,'CALC:PAR:DEF CH1_S11,S11'); %(S11) Define the measurement trace.
    fprintf(obj1,'CALC:PAR:SEL CH1_S11'); %(S11) Select the  measurement trace.
    fprintf(obj1, 'CALC:TRAN:TIME:STATE OFF'); % turn off transfrom (to time domain)
    fprintf(obj1, 'CALC:FILT:TIME:STATE OFF'); % turn off time gating
    fprintf(obj1, 'DISP:WIND:Y:AUTO'); % Autoscale
    fprintf(obj1, 'FORM:BORD SWAP');
    fprintf(obj1, 'FORM REAL,64');
    fprintf(obj1, 'MMEM:STOR:TRAC:FORM:SNP RI');
    fprintf(obj1, 'INIT:IMM'); % send trigger to initiate one sweep
    fprintf(obj1, '*WAI'); % wait until sweep is complete
    fprintf(obj1, 'CALC:DATA:SNP? 2'); % Ask for S parameter data
    X = binblockread(obj1, 'float64');
    fprintf(obj1, '*WAI'); % wait until data tranfer is complete
    Freq = X(1:(NOP));
    %Importing the two port data
    S11R = X(NOP+1:NOP+(NOP));         S11I = X(2*NOP+1:2*NOP+(NOP));
    S21R = X(3*NOP+1:3*NOP+(NOP));     S21I = X(4*NOP+1:4*NOP+(NOP));
    S12R = X(5*NOP+1:5*NOP+(NOP));     S12I = X(6*NOP+1:6*NOP+(NOP));
    S22R = X(7*NOP+1:7*NOP+(NOP));     S22I = X(8*NOP+1:8*NOP+(NOP));
    SCf(:,i,1) = S11R + 1i*S11I; %S11
    SCf(:,i,2) = S21R + 1i*S21I; %S21
    SCf(:,i,3) = S12R + 1i*S12I; %S12
    SCf(:,i,4) = S22R + 1i*S22I; %S22
    Time = toc;
    fprintf(['Measure and store SCf at position: ',num2str(i),' - Done. Elapsed Time: ',num2str(Time),'\n']);
    %% S rad - Frequency Domain
    fprintf(obj1, 'CALC:FILT:TIME:STATE ON'); % tunn on gating is on
    start_time = -gt; stop_time = gt; %set the start and stop time for transforming to time domain
    fprintf(obj1, ['CALC:FILT:TIME:START ', num2str(start_time)]);
    fprintf(obj1, ['CALC:FILT:TIME:STOP ', num2str(stop_time)]);
    fprintf(obj1, 'INIT:IMM'); % send trigger to initiate one sweep
    fprintf(obj1, '*WAI'); % wait until sweep is complete
    % Request frequency domain S paramter measurement in real and imaginary
    fprintf(obj1, 'DISP:WIND:Y:AUTO'); % Autoscale
    fprintf(obj1, 'CALC:DATA:SNP? 2'); % Ask for S parameter data
    X = binblockread(obj1, 'float64');
    fprintf(obj1, '*WAI'); % wait until data tranfer is complete
    Freq = X(1:(NOP));
    S11R = X(NOP+1:NOP+(NOP));         S11I = X(2*NOP+1:2*NOP+(NOP));
    S21R = X(3*NOP+1:3*NOP+(NOP));     S21I = X(4*NOP+1:4*NOP+(NOP));
    S12R = X(5*NOP+1:5*NOP+(NOP));     S12I = X(6*NOP+1:6*NOP+(NOP));
    S22R = X(7*NOP+1:7*NOP+(NOP));     S22I = X(8*NOP+1:8*NOP+(NOP));
    Srad(:,i,1) = S11R + 1i*S11I; %S11
    Srad(:,i,2) = S21R + 1i*S21I; %S21
    Srad(:,i,3) = S12R + 1i*S12I; %S12
    Srad(:,i,4) = S22R + 1i*S22I; %S22
    Time = toc; 
    fprintf(['Measure and store Srad at position: ',num2str(i),' - Done. Elapsed Time: ',num2str(Time),'\n']);
    %% S cav - time domain
    meas_name(1,:) = 'CH1_S11,S11'; meas_name(2,:) = 'CH1_S12,S12';
    meas_name(3,:) = 'CH1_S21,S21'; meas_name(4,:) = 'CH1_S22,S22';
    for snum = 1:4
        fprintf(obj1,['CALC:PAR:SEL ', meas_name(snum,:)]); %(Select the  measurement trace.
        fprintf(obj1, 'CALC:TRAN:TIME:STATE ON'); % ensure tranform is on
        fprintf(obj1, 'CALC:FILT:TIME:STATE OFF'); % ensure gating is off
        start_time = st; stop_time = et; %set the start and stop time for transforming to time domain
        fprintf(obj1, ['CALC:TRAN:TIME:START ', num2str(start_time)]);
        fprintf(obj1, ['CALC:TRAN:TIME:STOP ', num2str(stop_time)]);
        fprintf(obj1, 'DISP:WIND:Y:AUTO'); % Autoscale
        fprintf(obj1, 'CALC:FORM REAL'); % Set format to get REAL data
        fprintf(obj1, 'DISP:WIND:Y:AUTO'); % Autoscale
        fprintf(obj1, 'CALC:DATA? FDATA'); % Request data
        SR = binblockread(obj1, 'float64'); % Read data
        fprintf(obj1, 'CALC:FORM IMAG'); % Set format to get IMAGINARY data
        fprintf(obj1, 'DISP:WIND:Y:AUTO'); % Autoscale
        fprintf(obj1, 'CALC:DATA? FDATA'); % Request data
        SI = binblockread(obj1, 'float64'); % Read data
        SCt(:,i,snum) = SR + 1i*SI; % Combine the real and imaginary parts of time domain
        t = linspace(start_time,stop_time,length(SCt))';
    end
    Time = toc; 
    fprintf(['Measure and store SCt at position: ',num2str(i),' - Done. Elapsed Time: ',num2str(Time),'\n']);
    end
%% Close the open instrument connections
fclose(obj1); delete(obj1);
fclose(s1); delete(s1);
end