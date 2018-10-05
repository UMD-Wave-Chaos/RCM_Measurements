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
% Find a GPIB object.
obj1 = instrfind('Type', 'gpib', 'BoardIndex', 32, 'PrimaryAddress', 16, 'Tag', '');

% Create the GPIB object if it does not exist
% otherwise use the object that was found.
if isempty(obj1)
    obj1 = gpib('AGILENT', 32, 16);
else
    fclose(obj1);
    obj1 = obj1(1)
end
obj1.InputBufferSize = 4194304; % increase the buffer size
obj1.Timeout = 15; % increase the timeout time to 15 sec
s1 = serial('COM3', 'BaudRate', 57600,'Terminator', 'CR'); % Create serial port for the Stepper Motor
fopen(s1);
fopen(obj1);
NOP = 32001; % number of points
%% Compute and Capture S parameter Meausrements
fprintf(obj1, 'SYSTem:PRESet'); % preset to factory defined default settings
ready = query(obj1, '*OPC?'); % Check if preset is complete
fprintf(obj1,['SENS1:CORR:CSET:ACT "',cal_name ,'",1']); % switch to condition of last cal.
fprintf(obj1, 'OUTP ON'); % turn RF power on
fprintf(obj1, 'SENS1:AVER OFF'); % turn averaging off
fprintf(obj1, 'SENS:SWE:MODE HOLD'); % set sweep mode to hold
fprintf(obj1, 'TRIG:SOUR MAN'); % set triggering to manual
DIRECTION = 1; % "Direction" is -1 for clockwise and 1 for counterclockwise for stepper motor rotation
meas_name = 'CH1_S22_4, S22';
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
%     %% Record one sweep
%     %% S cav - Frequency Domain
    fprintf(s1,['I',num2str(DIRECTION*32*12000/360*1.8*4),',1700,0,0,5000,5000,1000,0,1000,1000,50,64']); pause(1); % move the steppermotor counterclockwise by 1.8 degrees
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
%     Time = toc;
%     display(['Step 2 FD - Scav Position : ',num2str(iter),'; Time: ',num2str(Time)]);
% %     %% S rad - Frequency Domain
% %     for i = 1:10
% %         fprintf(obj1, 'CALC:FILT:TIME:STATE ON'); % tunn on gating is on
% %         start_time = -l*i/(3E8); stop_time = l*i/(3E8); %set the start and stop time for transforming to time domain
% %         fprintf(obj1, ['CALC:FILT:TIME:START ', num2str(start_time)]);
% %         fprintf(obj1, ['CALC:FILT:TIME:STOP ', num2str(stop_time)]);
% %         fprintf(obj1, 'INIT:IMM'); % send trigger to initiate one sweep
% %         fprintf(obj1, '*WAI'); % wait until sweep is complete
% %         % Request frequency domain S paramter measurement in real and imaginary
% %         fprintf(obj1, 'DISP:WIND:Y:AUTO'); % Autoscale
% %         fprintf(obj1, ['CALC:DATA:SNP? ',num2str(num_ports)]); % Ask for S parameter data
% %         X = binblockread(obj1, 'float64');
% %         fprintf(obj1, '*WAI'); % wait until data tranfer is complete
% %         %ready = query(obj1, '*OPC?'); % Check for completion of data tranfer.
% %         Freq = X(1:(NOP));
% %         S11R = X(NOP+1:NOP+(NOP));
% %         S11I = X(2*NOP+1:2*NOP+(NOP));
% %         Srad(:,i,iter) = S11R + 1i*S11I;
% %         %     if num_ports == 2
% %         %         S21R = X(3*NOP+1:3*NOP+(NOP));     S21I = X(4*NOP+1:4*NOP+(NOP));
% %         %         S12R = X(5*NOP+1:5*NOP+(NOP));     S12I = X(6*NOP+1:6*NOP+(NOP));
% %         %         S22R = X(7*NOP+1:7*NOP+(NOP));     S22I = X(8*NOP+1:8*NOP+(NOP));
% %         %         Srad(:,2,iter) = S21R + 1i*S21I;
% %         %         Srad(:,3,iter) = S12R + 1i*S12I;
% %         %         Srad(:,4,iter) = S22R + 1i*S22I;
% %         %     end
% %         Time = toc;
% %     end
%     display(['Step 2 FD - Srad Position : ',num2str(iter),'; Time: ',num2str(Time)]);
    %% S cav - time domain
    fprintf(obj1, 'CALC:TRAN:TIME:STATE ON'); % ensure tranform is on
    fprintf(obj1, 'CALC:FILT:TIME:STATE OFF'); % ensure gating is off
    start_time = -0.5E-6; stop_time = 10E-6; %set the start and stop time for transforming to time domain
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
    display(['Step 2 TD Position : ',num2str(iter),'; Time: ',num2str(Time)]);

%% Plot the last realization of S parameters in frequency domain
% hold on;
% hfs = figure('NumberTitle', 'off', 'Name', 'S-Parameters (cav) - Frequency Domain Response'); % handle for s parameter plot
% hfsr = figure('NumberTitle', 'off', 'Name', 'S-Parameters (rad) - Frequency Domain Response'); % handle for s parameter plot
% hts = figure('NumberTitle', 'off', 'Name', 'S-Parameters - Time Domain Response'); % handle for s parameter plot
% for i = 1:(num_ports^2)
%     figure(hfs); subplot(num_ports,num_ports,i)
%     plot(Freq/1E9,20*log10(abs(SCf(:,i,iter)))); axis tight
%     xlabel('Frequency(GHz)'); ylabel('Log Mag (dB)'); title(['S',fliplr(num2str(str2double(dec2bin(i-1))+11))]); % label the plot
%     figure(hfsr); subplot(num_ports,num_ports,i)
%     plot(Freq/1E9,20*log10(abs(Srad(:,i,iter)))); axis tight
%     xlabel('Frequency(GHz)'); ylabel('Log Mag (dB)'); title(['Srad',fliplr(num2str(str2double(dec2bin(i-1))+11))]); % label the plot
%     figure(hts); subplot(num_ports,num_ports,i)
%     plot(t/1E-6,20*log10(abs(SCt(:,i,iter)))); axis tight
%     xlabel('Time(\mus)'); ylabel('Log Mag (dB)'); title(['Scav',fliplr(num2str(str2double(dec2bin(i-1))+11))]); % label the plot
% end

%%  Save the data in csv format for single port measurement
% tic
% for i = 1:N
%     a = [Freq,SCf(:,1,i)];
%     csvwrite(['..\Data Library\1 Port\1.5 GHz - 3.5 GHz\S22\Frequency Domain\Scav\Jan 31 2014\Helix Antenna Port\Position ',num2str(i),'.csv'],a);
%     for j = 1:10
%         r = [Freq,Srad(:,j,i)];
%         csvwrite(['..\Data Library\1 Port\1.5 GHz - 3.5 GHz\S22\Frequency Domain\Srad\Jan 31 2014\Helix Antenna Port\Position ',num2str(i),'-',num2str(j),'.csv'],r);
%     end
%     b = [t,SCt(:,1,i)];
%     csvwrite(['..\Data Library\1 Port\1.5 GHz - 3.5 GHz\S22\Time Domain\Jan 31 2014\Helix Antenna Port\Position ',num2str(i),'.csv'],b);
%     Time = toc;
%     display(['Step 2 TD Position : ',num2str(i),'; Time: ',num2str(Time)]);
% end
%% Create the ensemble S11 vector aand plot
if iter == 1
a = SCt(:,1,1);
% b = SCf(:,1,1);
close all; h1 = figure; plot(t(1200:3200)/1E-6,20*log10(abs(a(1200:3200))),'.-g', 'MarkerSize', 20)
% h2 = figure; plot(Freq/1E9,20*log10(abs(b)),'.g', 'MarkerSize', 12)
else

    a = abs(a) + abs(SCt(:,1,iter));
%     b = abs(b) + abs(SCf(:,1,i+1));
end
figure(h1); hold off;
plot(t(1200:3200)/1E-6,20*log10(abs(a(1200:3200)/iter)),'k'); xlabel('time (\mus)'); ylabel('S22 - Log Mag (dB)'); axis tight
text(5,-20,'single measurement (green)');
text(5,-30,'ensemble (black)');
axis tight;
% figure(h2); hold on;
% plot(Freq/1E9,20*log10(abs(b/N)),'k'); xlabel('Frequency (GHz)'); ylabel('|S_{22}^{cav}| log mag (dB)'); axis tight
% text(10.0,-15,'single measurement (green)');
% text(10.0,-15.5,'ensemble (black)');
end
%% Close the open instrument connections
fclose(obj1); delete(obj1);
fclose(s1); delete(s1);
% end