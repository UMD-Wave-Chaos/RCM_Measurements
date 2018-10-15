% function [t, SCt, Freq, SCf, Srad] = PNA_single(cal_name,num_ports, N, l)
% Input: num_ports : the number of active ports in the chamber/ experiment
%        N: if function is being called from a loop, this is # of iteration else it should be set to 1.
%        cal_name: the name of the calibration set with the appropriate measurement frequency range
%        l: the electrical lenth of the antenna (m)
% Output: t -- array of corresponding time values
%         SCt  -- complex time domain s parameter responses
%         Freq -- array of corresponding frequency values
%         SCf -- complex frequency domain s parameter responses
%% Find a VISA-TCPIP object and the serial port.
tic; obj = instrfind;
if ~isempty(obj) % close and delete all open ports and connection
    for i = 1:length(obj); fclose(obj(i)); delete(obj(i)); end
end
obj1 = visa('AGILENT', 'TCPIP0::PNA::inst0::INSTR'); % Create the VISA-TCPIP object
obj1.InputBufferSize = 4194304; % increase the buffer size
obj1.Timeout = 15; % increase the timeout time to 15 sec
s1 = serial('COM5', 'BaudRate', 57600,'Terminator', 'CR'); % Create serial port for the Stepper Motor
fopen(s1);
fopen(obj1);
NOP = 32001; % number of points
%% Compute and Capture S parameter Meausrements
fprintf(obj1, 'SYSTem:PRESet'); % preset to factory defined default settings
ready = query(obj1, '*OPC?'); % Check if preset is complete
fprintf(obj1,['SENS1:CORR:CSET:ACT "', cal_name,'",1']); % switch to condition of last cal.
fprintf(obj1, 'OUTP ON'); % turn RF power on
fprintf(obj1, 'SENS1:AVER OFF'); % turn averaging off
fprintf(obj1, 'SENS:SWE:MODE HOLD'); % set sweep mode to hold
fprintf(obj1, 'TRIG:SOUR MAN'); % set triggering to manual
DIRECTION = 1; % "Direction" is -1 for clockwise and 1 for counterclockwise for stepper motor rotation
meas_name = 'CH1_S11_4, S11';
fprintf(obj1,['CALC:PAR:DEF ', meas_name]); % Define the measurement trace.
fprintf(obj1,['CALC:PAR:SEL ', meas_name(1:length(meas_name)-5)]); % Select the  measurement trace.
fprintf(obj1, 'CALC:TRAN:TIME:STATE OFF'); % turn off transfrom (to time domain)
fprintf(obj1, 'CALC:FILT:TIME:STATE OFF'); % turn off time gating
fprintf(obj1, 'DISP:WIND:Y:AUTO'); % Autoscale
fprintf(obj1, 'FORM:BORD SWAP');
fprintf(obj1, 'FORM REAL,64');
fprintf(obj1, 'MMEM:STOR:TRAC:FORM:SNP RI');
fprintf(obj1, 'INIT:IMM'); % send trigger to initiate one sweep
fprintf(obj1, '*WAI'); % wait until sweep is complete
for iter = 1:N
    %% Record one sweep
    %% S cav - Frequency Domain
    fprintf(s1,['I',num2str(DIRECTION*64*4),',1000,0,0,5000,5000,1000,0,1000,1000,50,64']); pause(0.5); % move the steppermotor counterclockwise by 1.8 degrees
    fprintf(obj1, 'CALC:TRAN:TIME:STATE OFF'); % turn off transfrom (to time domain)
    fprintf(obj1, 'INIT:IMM'); % send trigger to initiate one sweep
    fprintf(obj1, '*WAI'); % wait until sweep is complete
    % Request frequency domain S paramter measurement in real and imaginary
    fprintf(obj1, 'DISP:WIND:Y:AUTO'); % Autoscale
    fprintf(obj1, ['CALC:DATA:SNP? ',num2str(num_ports)]); % Ask for S parameter data
    X = binblockread(obj1, 'float64');
    fprintf(obj1, '*WAI'); % wait until data tranfer is complete
    %ready = query(obj1, '*OPC?'); % Check for completion of data tranfer.
    Freq = X(1:(NOP));
    S11R = X(NOP+1:NOP+(NOP));
    S11I = X(2*NOP+1:2*NOP+(NOP));
    SCf(:,1,iter) = S11R + 1i*S11I;
    if num_ports == 2
        S21R = X(3*NOP+1:3*NOP+(NOP));     S21I = X(4*NOP+1:4*NOP+(NOP));
        S12R = X(5*NOP+1:5*NOP+(NOP));     S12I = X(6*NOP+1:6*NOP+(NOP));
        S22R = X(7*NOP+1:7*NOP+(NOP));     S22I = X(8*NOP+1:8*NOP+(NOP));
        SCf(:,2,iter) = S21R + 1i*S21I;
        SCf(:,3,iter) = S12R + 1i*S12I;
        SCf(:,4,iter) = S22R + 1i*S22I;
    end
    Time = toc;
    display(['Step 2 FD - Scav Position : ',num2str(iter),'; Time: ',num2str(Time)]);
    %% S rad - Frequency Domain
    fprintf(obj1, 'CALC:FILT:TIME:STATE ON'); % tunn on gating is on
    start_time = -l*25/(3E8); stop_time = l*25/(3E8); %set the start and stop time for transforming to time domain
    fprintf(obj1, ['CALC:FILT:TIME:START ', num2str(start_time)]);
    fprintf(obj1, ['CALC:FILT:TIME:STOP ', num2str(stop_time)]);
    fprintf(obj1, 'INIT:IMM'); % send trigger to initiate one sweep
    fprintf(obj1, '*WAI'); % wait until sweep is complete
    % Request frequency domain S paramter measurement in real and imaginary
    fprintf(obj1, 'DISP:WIND:Y:AUTO'); % Autoscale
    fprintf(obj1, ['CALC:DATA:SNP? ',num2str(num_ports)]); % Ask for S parameter data
    X = binblockread(obj1, 'float64');
    fprintf(obj1, '*WAI'); % wait until data tranfer is complete
    %ready = query(obj1, '*OPC?'); % Check for completion of data tranfer.
    Freq = X(1:(NOP));
    S11R = X(NOP+1:NOP+(NOP));
    S11I = X(2*NOP+1:2*NOP+(NOP));
    Srad(:,2,iter) = S11R + 1i*S11I;
    if num_ports == 2
        S21R = X(3*NOP+1:3*NOP+(NOP));     S21I = X(4*NOP+1:4*NOP+(NOP));
        S12R = X(5*NOP+1:5*NOP+(NOP));     S12I = X(6*NOP+1:6*NOP+(NOP));
        S22R = X(7*NOP+1:7*NOP+(NOP));     S22I = X(8*NOP+1:8*NOP+(NOP));
        Srad(:,2,iter) = S21R + 1i*S21I;
        Srad(:,3,iter) = S12R + 1i*S12I;
        Srad(:,4,iter) = S22R + 1i*S22I;
    end
    Time = toc;
    
    display(['Step 2 FD - Srad Position : ',num2str(iter),'; Time: ',num2str(Time)]);
    %% S cav - time domain
    fprintf(obj1, 'CALC:TRAN:TIME:STATE ON'); % ensure tranform is on
    fprintf(obj1, 'CALC:FILT:TIME:STATE OFF'); % ensure gating is off
    start_time = -0.5E-6; stop_time = 6.4E-6; %set the start and stop time for transforming to time domain
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
    SCt(:,1,iter) = SR + 1i*SI; % Combine the real and imaginary parts of time domain
    t = linspace(start_time,stop_time,length(SCt))';
    Time = toc;
    display(['Step 2 TD Position : ',num2str(iter),'; Time: ',num2str(Time),' seconds.']);
    
    %%  Save the data in csv format for single port measurement
    display(['Saving data for Mode Stirrer Position ',num2str(iter),' ...']);
    a = [Freq,SCf(:,1,iter)];
    csvwrite(['..\Data Library\One Port Measurements\In Cylindrical Chamber\At Port 3\With Horn Antenna\Data Set 3 - wider f band\S_cav\Position ',num2str(iter),'.csv'],a);
    for j = 1
        r = [Freq,Srad(:,j,iter)];
        csvwrite(['..\Data Library\One Port Measurements\In Cylindrical Chamber\At Port 3\With Horn Antenna\Data Set 3 - wider f band\S_rad\Position ',num2str(iter),'-',num2str(j),'.csv'],r);
    end
    b = [t,SCt(:,1,iter)];
    csvwrite(['..\Data Library\One Port Measurements\In Cylindrical Chamber\At Port 3\With Horn Antenna\Data Set 3 - wider f band\S_t\Position ',num2str(iter),'.csv'],b);
    Time1 = toc;
    display(['Done. It took ',num2str(Time1-Time),' seconds.']);
end

%% Create the ensemble S11 vector aand plot
a = SCt(:,1,1);
b = SCf(:,1,1);
close all; h1 = figure; plot(t/1E-6,20*log10(abs(a)),'.-g', 'MarkerSize', 12)
h2 = figure; hold on; plot(Freq/1E9,20*log10(abs(b)),'.-g', 'MarkerSize', 12);
plot(10.5,2.5+min(20*log10(abs(b))),'.g','MarkerSize', 12);text(10.55,2.5+min(20*log10(abs(b))),'single measurement');
plot(10.5,2+min(20*log10(abs(b))),'.k','MarkerSize', 12);text(10.55,2+min(20*log10(abs(b))),'ensemble average');
for i = 1:N-1
    a = abs(a) + abs(SCt(:,1,i+1));
    b = abs(b) + abs(SCf(:,1,i+1));
end
figure(h1); hold on;
plot(t/1E-6,20*log10(abs(a/N)),'k'); xlabel('time (\mus)'); ylabel('S_{22} - Log Mag (dB)'); axis tight
plot(5,-10+max(20*log10(abs(a/N))),'.g','MarkerSize', 12);text(5.2,-10+max(20*log10(abs(a/N))),'single measurement');
plot(5,-15+max(20*log10(abs(a/N))),'.k','MarkerSize', 12);text(5.2,-15+max(20*log10(abs(a/N))),'ensemble average');
figure(h2); hold on;
plot(Freq/1E9,20*log10(abs(b/N)),'k'); xlabel('Frequency (GHz)'); ylabel('|S_{22}^{cav}| log mag (dB)'); axis tight

%% Close the open instrument connections
fclose(obj1); delete(obj1);
fclose(s1); delete(s1);
% end