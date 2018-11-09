function [Freq, SCf] = measureData(obj1,s1, Settings,varargin)  
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
NOP = Settings.NOP;
N = Settings.N;
direction = Settings.direction;
nStepsPerRevolution = Settings.nStepsPerRevolution;
Ngates = 10;

%% initialize the motor position
startPos = getStepperMotorPosition(s1);

% initialize the variables 
SCf = zeros(NOP,4,N);

% start the timer
tic;

%% Loop over the number of requested iterations
% take measurements at each stepper motor position

for iter = 1:N
    
    if (useGUI == true)
        gui_UpdateCalibration(handles.pnaObj,handles);
    end
    %% move the stepper motor
    stepDistance = direction*nStepsPerRevolution/N;
    waitTime = 15;
    
    runSpeed = ceil(stepDistance/10);

	lstring = sprintf('Moving mode stirrer for position %d of %d: Moving %d steps at %d steps/second',iter, N,stepDistance,runSpeed);
    
    if (useGUI == true)
        logMessage(handles.jEditbox,lstring);
    else
        disp(lstring);
    end

    %command parameters for I (index) are:
    %distance, run speed, start speed, end speed, accel rate, decel rate,
    %run current, hold current, accel current, delay, step mode
    fprintf(s1,['I',num2str(stepDistance),',',num2str(runSpeed),',0,0,500,500,1000,0,1000,1000,50,64']); 
    
    %now we need to pause and make sure the moder stirrer has settled
    lstring = sprintf('Pausing %0.1f seconds to settle mode stirrer',waitTime);
    if (useGUI == true)
        logMessage(handles.jEditbox,lstring);
    else
        disp(lstring);
    end
    
    pause(waitTime);

    %get the new stepper motor position and check to make sure we moved the
    %expected amount
    newPos = getStepperMotorPosition(s1); 
    
    if newPos - startPos ~= stepDistance
        warning('Stepped %d steps, expected %d steps',newPos-startPos,stepDistance);
    end
    
    %reset the start position for the next comparison
    startPos = newPos;
    
    %update the motor position on the GUI
    if (useGUI)
        set(handles.sPositionText,'String',num2str(newPos));
    end
    

    %% measure SCav in the frequency domain - this is an ungated measurement of the S parameters
    [Freq, SCf11, SCf12, SCf21, SCf22] = getUngatedSParametersFrequencyDomain(obj1,NOP);
    SCf(:,1,iter) = SCf11; 
    SCf(:,2,iter) = SCf12;
    SCf(:,3,iter) = SCf21;
    SCf(:,4,iter) = SCf22;
    Time = toc;
    
    if (useGUI == true)
        tString = sprintf('Measured S, realization %d of %d',iter,N);
        updateSParametersPlots(Freq,SCf11,SCf12,SCf22, tString,handles);
    end
    
	lstring = sprintf('Measuring Scav in frequency domain at position %d of %d, elapsed time = %0.3f s', iter,N,Time);
    if (useGUI == true)
        logMessage(handles.jEditbox,lstring);
    else
        disp(lstring)
    end
     
    %% update elapsed time and predict time remaining to complete
    averagetime = Time/iter;
	predictedTime = averagetime*(N-iter);
    predictedTimeMin = predictedTime/60;
    lstring = sprintf('Measurement Step %d of %d Completed, Predicted remaining time = %s s (%s min)',iter,N,num2str(predictedTime),num2str(predictedTimeMin));
    
    if (useGUI == true)
        logMessage(handles.jEditbox,lstring,'info');
    else
        disp(lstring)
    end
end