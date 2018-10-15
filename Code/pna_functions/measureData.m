function [t, SCt, Freq, SCf, Srad] = measureData(obj1,s1,NOP,N,eCal,l,num_ports,meas_name, varargin)

if (nargin == 9)
    useGUI = true;
    handles = varargin{1};
else
    useGUI = false;
end

DIRECTION = 1; % "Direction" is -1 for clockwise and 1 for counterclockwise for stepper motor rotation
tic;

%calibration step
if (eCal == true)
    for k = 1:15
     cal_name = ['cal_for_',date,num2str(k)];
     calibratePNA(obj1,0.1E9+(k-1)*0.2E9,0.1E9+k*0.2E9,cal_name,NOP)
    end
end

for iter = 1:N
       %% Record one sweep
    %% S cav - Frequency Domain
    lstring = sprintf('Moving mode stirrer for position %d of %d',iter, N);
    if (useGUI == true)
        logMessage(handles.jEditbox,lstring);
    else
        disp(lstring)
    end
    fprintf(s1,['I',num2str(DIRECTION*64*12000/N),',1700,0,0,5000,5000,1000,0,1000,1000,50,64']); pause(1+1/1700*60*(12000/N)); % move the steppermotor counterclockwise by 1.8 degrees (1.8*4 was replaced by 360/N to make the code adjust ensemble as the user sets it.
    fprintf(obj1, ['SENS:SWE:POINTS ', num2str(NOP)]); % set number of points
    fprintf(obj1, 'CALC:TRAN:TIME:STATE OFF'); % turn off transfrom (to time domain)
    fprintf(obj1, 'INIT:IMM'); % send trigger to initiate one sweep
    fprintf(obj1, '*WAI'); % wait until sweep is complete
    % Request frequency domain S paramter measurement in real and imaginary
    fprintf(obj1, 'DISP:WIND:Y:AUTO'); % Autoscale
    fprintf(obj1, ['CALC:DATA:SNP? ',num_ports]); % Ask for S parameter data
    X = binblockread(obj1, 'float64');
    fprintf(obj1, '*WAI'); % wait until data tranfer is complete
    Freq = X(1:(NOP));
    %Importing the two port data
    S11R = X(NOP+1:NOP+(NOP));
    S11I = X(2*NOP+1:2*NOP+(NOP));
    S21R = X(3*NOP+1:3*NOP+(NOP));     S21I = X(4*NOP+1:4*NOP+(NOP));
    S12R = X(5*NOP+1:5*NOP+(NOP));     S12I = X(6*NOP+1:6*NOP+(NOP));
    S22R = X(7*NOP+1:7*NOP+(NOP));     S22I = X(8*NOP+1:8*NOP+(NOP));
    SCf(:,1,iter) = S11R + 1i*S11I; %One port line
    SCf(:,2,iter) = S21R + 1i*S21I;
    SCf(:,3,iter) = S12R + 1i*S12I;
    SCf(:,4,iter) = S22R + 1i*S22I;
    Time = toc;
    lstring = sprintf(['Step 2 FD - Scav position: ',num2str(iter),'. Elapsed Time: ',num2str(Time),'\n']);
    if (useGUI == true)
        logMessage(handles.jEditbox,lstring);
    else
        disp(lstring)
    end
        %% S rad - Frequency Domain
    for i = 1:10
        fprintf(obj1, 'CALC:FILT:TIME:STATE ON'); % tunn on gating is on
        start_time = -l*i/(3E8); stop_time = l*i/(3E8); %set the start and stop time for transforming to time domain
        fprintf(obj1, ['CALC:FILT:TIME:START ', num2str(start_time)]);
        fprintf(obj1, ['CALC:FILT:TIME:STOP ', num2str(stop_time)]);
        fprintf(obj1, 'INIT:IMM'); % send trigger to initiate one sweep
        fprintf(obj1, '*WAI'); % wait until sweep is complete
        % Request frequency domain S paramter measurement in real and imaginary
        fprintf(obj1, 'DISP:WIND:Y:AUTO'); % Autoscale
        fprintf(obj1, ['CALC:DATA:SNP? ',num2str(num_ports)]); % Ask for S parameter data
        X = binblockread(obj1, 'float64');
        fprintf(obj1, '*WAI'); % wait until data tranfer is complete
        Freq = X(1:(NOP));
        S11R = X(NOP+1:NOP+(NOP));
        S11I = X(2*NOP+1:2*NOP+(NOP));
        %2 Port Data Collection
        S21R = X(3*NOP+1:3*NOP+(NOP));     S21I = X(4*NOP+1:4*NOP+(NOP));
        S12R = X(5*NOP+1:5*NOP+(NOP));     S12I = X(6*NOP+1:6*NOP+(NOP));
        S22R = X(7*NOP+1:7*NOP+(NOP));     S22I = X(8*NOP+1:8*NOP+(NOP));
        Srad(:,2,iter) = S21R + 1i*S21I;
        Srad(:,3,iter) = S12R + 1i*S12I;
        Srad(:,4,iter) = S22R + 1i*S22I;
        Srad(:,1,iter,i) = S11R + 1i*S11I; %2 Port Data Collected
        Srad(:,2,iter,i) = S12R + 1i*S12I;
        Srad(:,3,iter,i) = S21R + 1i*S21I;
        Srad(:,4,iter,i) = S22R + 1i*S22I;
        Time = toc;
    end
    lstring = sprintf(['Step 2 FD - Srad position: ',num2str(iter),'. Elapsed Time: ',num2str(Time),'\n']);
    if (useGUI == true)
        logMessage(handles.jEditbox,lstring);
    else
        disp(lstring)
    end
    
        %% S cav - time domain
    for port=1:4
        fprintf(obj1,['CALC:PAR:SEL ', meas_name(port,:)]); %(Select the  measurement trace.
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
        SCt(:,port,iter) = SR + 1i*SI; % Combine the real and imaginary parts of time domain
        t = linspace(start_time,stop_time,length(SCt))';
    end
    Time = toc;
    
        lstring = sprintf(['Step 2 TD - Srad position: ',num2str(iter),'. Elapsed Time: ',num2str(Time),'\n']);
    if (useGUI == true)
        logMessage(handles.jEditbox,lstring);
    else
        disp(lstring)
    end
end