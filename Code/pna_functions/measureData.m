function [t, SCt, Freq, SCf, Srad] = measureData(obj1,s1, Settings,varargin)  

if (nargin == 4)
    useGUI = true;
    handles = varargin{1};
else
    useGUI = false;
end

%get the inputs from the Settings object
NOP = Settigns.NOP;
N = Settings.N;
eCal = Settings.electronicCalibration;
fStart = Settings.fStart;
fStop = Settings.fStop;
transformStart = Settings.transformStart;
transformStop = Settings.transformStop;
direction = Settings.direction;
nStepsPerRevolution = Settings.nStepsPerRevolution;

tic;

%calibration step
if (eCal == true)
    for k = 1:15
     cal_name = ['cal_for_',date,num2str(k)];
     calibratePNA(obj1,0.1E9+(k-1)*0.2E9,0.1E9+k*0.2E9,cal_name,NOP)
    end
end

%% initialize the instruments

initializePNA(obj1,NOP,fStart,fStop);
startPos = getStepperMotorPosition(s1);

for iter = 1:N
    %% Record one sweep
    %% S cav - Frequency Domain
    stepDistance = direction*nStepsPerRevolution/N;
    waitTime = 10;
	lstring = sprintf('Moving mode stirrer for position %d of %d: Moving %d steps and pausing %0.3f seconds',iter, N,stepDistance,waitTime);
    logMessage(handles.jEditbox,lstring);

    %command parameters for I (index) are:
    %distance, run speed, start speed, end speed, accel rate, decel rate,
    %run current, hold current, accel current, delay, step mode
    fprintf(s1,['I',num2str(stepDistance),',100,0,0,500,500,1000,0,1000,1000,50,64']); pause(waitTime);
    newPos = getStepperMotorPosition(s1);
    
    if newPos - startPos ~= stepDistance
        warnStr = sprintf('Stepped %d steps, expected %d steps',newPos-startPos,stepDistance);
        warning(warnStr);
    end

    %measure SCav in the frequency domain - this is an ungated measurement of the S parameters
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
	
    %% S rad - Frequency Domain
    for i = 1:10
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

    %measure SCav in the time domain using the requested transform times
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