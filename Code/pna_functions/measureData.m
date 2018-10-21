function [t, SCt, Freq, SCf, Srad] = measureData(obj1,s1,NOP,N,eCal,l,fStart,fStop,transformStart,transformStop, handles)                                                                              
%if (nargin == 13)
    useGUI = true;
   % handles = varargin{1};
%else
 %   useGUI = false;
%end

%num_ports = 2;
DIRECTION = 1; % "Direction" is -1 for clockwise and 1 for counterclockwise for stepper motor rotation
tic;

%calibration step
if (eCal == true)
    for k = 1:15
     cal_name = ['cal_for_',date,num2str(k)];
     calibratePNA(obj1,0.1E9+(k-1)*0.2E9,0.1E9+k*0.2E9,cal_name,NOP)
    end
end

%% Compute and Capture S parameter Measurements
%fprintf(obj1, 'SYSTem:PRESet'); % preset to factory defined default settings
%ready = query(obj1, '*OPC?'); % Check if preset is complete
initializePNA(obj1,NOP,fStart,fStop);
% fprintf(obj1, ['SENS:SWE:POINTS ', num2str(NOP)]); % set number of points
% 
% fprintf(obj1, 'OUTP ON'); % turn RF power on
% fprintf(obj1, 'SENS1:AVER OFF'); % turn averaging off
% fprintf(obj1, 'SENS:SWE:MODE HOLD'); % set sweep mode to hold
% fprintf(obj1, 'TRIG:SOUR MAN'); % set triggering to manual
% DIRECTION = 1; % "Direction" is -1 for clockwise and 1 for counterclockwise for stepper motor rotation
meas_name(1,:) = 'CH1_S11';
% meas_name(2,:) = 'CH1_S12';
% meas_name(3,:) = 'CH1_S21';
% meas_name(4,:) = 'CH1_S22';
fprintf(obj1,['CALC:PAR:DEF ', meas_name(1,:),',S11']); %(S11) Define the measurement trace. 
% fprintf(obj1,['CALC:PAR:DEF ', meas_name(2,:),',S12']); %(S12) Define the measurement trace.
% fprintf(obj1,['CALC:PAR:DEF ', meas_name(3,:),',S21']); %(S21) Define the measurement trace.
% fprintf(obj1,['CALC:PAR:DEF ', meas_name(4,:),',S22']); %(S22) Define the measurement trace.
fprintf(obj1,['CALC:PAR:SEL ', meas_name(1,:)]); %(S11) Select the  measurement trace.
%fprintf(obj1,['CALC:PAR:SEL ', 'CH1_S11']);
% fprintf(obj1, 'CALC:TRAN:TIME:STATE OFF'); % turn off transfrom (to time domain)
% fprintf(obj1, 'CALC:FILT:TIME:STATE OFF'); % turn off time gating
% fprintf(obj1, 'DISP:WIND:Y:AUTO'); % Autoscale
% fprintf(obj1, 'FORM:BORD SWAP');
% fprintf(obj1, 'FORM REAL,64');
% fprintf(obj1, 'MMEM:STOR:TRAC:FORM:SNP RI');
% fprintf(obj1, 'INIT:IMM'); % send trigger to initiate one sweep
% fprintf(obj1, '*WAI'); % wait until sweep is complete
% fprintf(obj1, ['SENS:FREQ:STAR ' num2str(fStart)] ); %set the start frequency
% fprintf(obj1, ['SENS:FREQ:STOP ' num2str(fStop)]); %set the stop frequency

for iter = 1:N
    %% Record one sweep
    %% S cav - Frequency Domain
    %aerotech SM50 motor with Haydon PCM 4826 drive
    %200 full steps at 1.8 degress per step
    %drive can handle 1/64 steps --> 12800 steps per revolution
    stepDistance = DIRECTION*12800/N;
    waitTime = 10;
	lstring = sprintf('Moving mode stirrer for position %d of %d: Moving %d steps and pausing %0.3f seconds',iter, N,stepDistance,waitTime);
    logMessage(handles.jEditbox,lstring);

    %command parameters for I (index) are:
    %distance, run speed, start speed, end speed, accel rate, decel rate,
    %run current, hold current, accel current, delay, step mode
    fprintf(s1,['I',num2str(stepDistance),',100,0,0,500,500,1000,0,1000,1000,50,64']); pause(waitTime);
    %fprintf(s1,['I',num2str(DIRECTION*64*12000/N),',1700,0,0,5000,5000,1000,0,1000,1000,50,64']); pause(1+1/1700*60*(12000/N)); % move the steppermotor counterclockwise by 1.8 degrees (1.8*4 was replaced by 360/N to make the code adjust ensemble as the user sets it.
    
    [Freq, SCf11, SCf12, SCf21, SCf22] = getUngatedSParametersFrequencyDomain(obj1,NOP);
    SCf(:,1,iter) = SCf11; %One port line
    SCf(:,2,iter) = SCf12;
    SCf(:,3,iter) = SCf21;
    SCf(:,4,iter) = SCf22;
    Time = toc;
    
	lstring = sprintf('Measuring Scav in frequency domain at position %d of %d, elapsed time = %0.3f', iter,N,Time);
    if (useGUI == true)
        logMessage(handles.jEditbox,lstring);
    else
        disp(lstring)
    end
	
    %% S rad - Frequency Domain
    for i = 1:10
    lstring = sprintf('Measuring Srad in frequency domain at gate %d of %d', i,10);
    if (useGUI == true)
        logMessage(handles.jEditbox,lstring);
    else
        disp(lstring)
    end
        [Freq, Srad11, Srad12, Srad21, Srad22] = getGatedSParametersFrequencyDomain(obj1,l*i,NOP); 
        Srad(:,1,iter,i) = Srad11;
        Srad(:,2,iter,i) = Srad12;
        Srad(:,3,iter,i) = Srad21;
        Srad(:,4,iter,i) = Srad22;
        Time = toc;
    end
    lstring = sprintf('Measuring Srad in frequency domain at position %d of %d, elapsed time = %0.3f', iter,N,Time);
    if (useGUI == true)
        logMessage(handles.jEditbox,lstring);
    else
        disp(lstring)
    end
    
    [t,SCt11, SCt12, SCt21, SCt22] = getSParametersTimeDomain(obj1,NOP,transformStart,transformStop); 
    SCt(:,1,iter) = SCt11;
    SCt(:,2,iter) = SCt12;
    SCt(:,3,iter) = SCt21;
    SCt(:,4,iter) = SCt22;
    
    %% S cav - time domain
    Time = toc;
	lstring = sprintf('Measuring Scav in time domain at position %d of %d, elapsed time = %0.3f', iter,N,Time);
    if (useGUI == true)
        logMessage(handles.jEditbox,lstring);
    else
        disp(lstring)
    end
    
    averagetime = Time/iter;
	predictedTime = averagetime*(N-iter);
    lstring = sprintf('Measurement Step %d of %d Completed, Predicted remaining time = %s s',iter,N,num2str(predictedTime));
    
    if (useGUI == true)
        logMessage(handles.jEditbox,lstring,'info');
    else
        disp(lstring)
    end
end