function [t, SCt, Freq, SCf, Srad] = measureData(obj1,s1, Settings,varargin)  
%[t, SCt, Freq, SCf, Srad] = measureData(obj1, s1, Settings) 
%[t, SCt, Freq, SCf, Srad] = measureData(obj1, s1, Settings, handles) 
% This function handles measuring the wave chaotic S parameters for a
% cavity
% Inputs:
% obj1 - connection to the PNA through the Matlab Instrumentation Toolbox,
% this can be either a VISA-TCPIP object or a GPIB object
% s1 - serial connection to the stepper motor
% Settings - structure containing Settings read in from the config file
% handles - optional input from the GUI 
% 
% Outputs:
% t - Time vector from the PNA taken during the SCt measurement, will be of
% size NOP x 1
% SCt - Scav measurements in the time domain, will be of size NOP
% x 4 x N
% Freq - Time vector from the PNA taken during the Srad measurement, will be of
% size NOP x 1
% SCf - Scav measurements in the frequency domain, will be of size NOP x 4
% x N
% Srad - Srad measurements in the frequency domain (gated), will be of size
% NOP x 4 x N x 10

%% check to see if the handles was passed in to indicate GUI operation
if (nargin == 4)
    useGUI = true;
    handles = varargin{1};
else
    useGUI = false;
end

%% get the inputs from the Settings object
NOP = Settigns.NOP;
N = Settings.N;
eCal = Settings.electronicCalibration;
fStart = Settings.fStart;
fStop = Settings.fStop;
transformStart = Settings.transformStart;
transformStop = Settings.transformStop;
direction = Settings.direction;
nStepsPerRevolution = Settings.nStepsPerRevolution;
Ngates = 10;

%% check to see if we need to perform the electric calibration
% normally the PNA will be manually calibrated
if (eCal == true)
    for k = 1:15
     cal_name = ['cal_for_',date,num2str(k)];
     calibratePNA(obj1,0.1E9+(k-1)*0.2E9,0.1E9+k*0.2E9,cal_name,NOP)
    end
end

%% initialize
% initialize the instrumentation
initializePNA(obj1,NOP,fStart,fStop);
startPos = getStepperMotorPosition(s1);

% initialize the variables 
SCf = zeros(NOP,4,N);
SCt = zeros(NOP,4,N);
Srad = zeros(NOP,4,N,Ngates);

% start the timer
tic;

%% Loop over the number of requested iterations
% take measurements at each stepper motor position

for iter = 1:N
    %% move the stepper motor
    stepDistance = direction*nStepsPerRevolution/N;
    waitTime = 10;
	lstring = sprintf('Moving mode stirrer for position %d of %d: Moving %d steps and pausing %0.3f seconds',iter, N,stepDistance,waitTime);
    logMessage(handles.jEditbox,lstring);

    %command parameters for I (index) are:
    %distance, run speed, start speed, end speed, accel rate, decel rate,
    %run current, hold current, accel current, delay, step mode
    fprintf(s1,['I',num2str(stepDistance),',100,0,0,500,500,1000,0,1000,1000,50,64']); 
    pause(waitTime);
    newPos = getStepperMotorPosition(s1);
    
    if newPos - startPos ~= stepDistance
        warning('Stepped %d steps, expected %d steps',newPos-startPos,stepDistance);
    end

    %% measure SCav in the frequency domain - this is an ungated measurement of the S parameters
    [Freq, SCf11, SCf12, SCf21, SCf22] = getUngatedSParametersFrequencyDomain(obj1,NOP);
    SCf(:,1,iter) = SCf11; 
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
	
    %% Loop over 10 iterations of gating times and measure Srad in the frequency domain
    for i = 1:Ngates
        lstring = sprintf('Measuring Srad in frequency domain at gate %d of %d', i,10);
        if (useGUI == true)
            logMessage(handles.jEditbox,lstring);
        else
            disp(lstring)
        end
        %measure SRad in the frequency domain - this is a gated measurement
        %of the S parameters
        [Freq, Srad11, Srad12, Srad21, Srad22] = getGatedSParametersFrequencyDomain(obj1,l*i,NOP); 
        Srad(:,1,iter,i) = Srad11;
        Srad(:,2,iter,i) = Srad12;
        Srad(:,3,iter,i) = Srad21;
        Srad(:,4,iter,i) = Srad22;   
    end 
   
    Time = toc;
    lstring = sprintf('Measuring Srad in frequency domain at position %d of %d, elapsed time = %0.3f', iter,N,Time);
    if (useGUI == true)
        logMessage(handles.jEditbox,lstring);
    else
        disp(lstring)
    end

    %% measure SCav in the time domain using the requested transform times
    [t,SCt11, SCt12, SCt21, SCt22] = getSParametersTimeDomain(obj1,NOP,transformStart,transformStop); 
    SCt(:,1,iter) = SCt11;
    SCt(:,2,iter) = SCt12;
    SCt(:,3,iter) = SCt21;
    SCt(:,4,iter) = SCt22;
    
    Time = toc;
	lstring = sprintf('Measuring Scav in time domain at position %d of %d, elapsed time = %0.3f', iter,N,Time);
    if (useGUI == true)
        logMessage(handles.jEditbox,lstring);
    else
        disp(lstring)
    end
    
    %% update elapsed time and predict time remaining to complete
    averagetime = Time/iter;
	predictedTime = averagetime*(N-iter);
    lstring = sprintf('Measurement Step %d of %d Completed, Predicted remaining time = %s s',iter,N,num2str(predictedTime));
    
    if (useGUI == true)
        logMessage(handles.jEditbox,lstring,'info');
    else
        disp(lstring)
    end
end