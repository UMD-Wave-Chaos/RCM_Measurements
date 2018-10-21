function [pnaObj,pnaConnection,pnaConnectionType] = connectToPNA()

pnaConnection = false;

% Find the VNA instrument - first try a visa type
pnaObj = instrfind('Type', 'visa-tcpip', 'RsrcName', 'TCPIP::169.254.82.72::INSTR', 'Tag', '');
if isempty(pnaObj) % Create the visa TCPIP object if it does not exist
    pnaObj = visa('agilent','TCPIP0::PNA::inst0::INSTR');
else
    fclose(pnaObj);
end
%if the VISA connection works, use it
if ~isempty(pnaObj)
    pnaConnectionType = 'visa-tcpip';
    pnaConnection = true;
    pnaObj.InputBufferSize = 4194304; % increase the buffer size
    pnaObj.Timeout = 15; % increase the timeout time to 15 sec
    fopen(pnaObj);
%otherwise try the GPIB connection
else
    pnaObj = instrfind('Type', 'gpib', 'BoardIndex', 32, 'PrimaryAddress', 16, 'Tag', '');

    % Create the GPIB object if it does not exist
    % otherwise use the object that was found.
    if isempty(pnaObj)
        pnaObj = gpib('AGILENT', 32, 16);
    else
        pnaConnectionType = 'gpib';
        pnaConnection = true;
        fclose(pnaObj);
        pnaObj = pnaObj(1);
        % Configure instrument object.
        set(pnaObj, 'InputBufferSize', 10000000);
        set(pnaObj, 'OutputBufferSize', 10000000);

        % Connect to instrument object, pnaObj.
        fopen(pnaObj);
    end
end

%Call the System Preset: Deletes all traces, measurements, and windows and resets the analyzer to factory defined default setting
%This command creates a S11 measurement named "CH1_S11_1" but does not
%reset the calibration
fprintf(pnaObj, 'SYSTem:PRESet'); % preset to factory defined default settings
ready = query(pnaObj, '*OPC?'); % Check if preset is complete
fprintf(pnaObj, 'OUTP ON'); % turn RF power on
fprintf(pnaObj, 'SENS1:AVER OFF'); % turn averaging off
fprintf(pnaObj, 'SENS:SWE:MODE HOLD'); % set sweep mode to hold
fprintf(pnaObj, 'TRIG:SOUR MAN'); % set triggering to manual
meas_name(1,:) = 'CH1_S11';
meas_name(2,:) = 'CH1_S12';
meas_name(3,:) = 'CH1_S21';
meas_name(4,:) = 'CH1_S22';
fprintf(pnaObj,['CALC:PAR:DEF ', meas_name(1,:),',S11']); %(S11) Define the measurement trace. 
fprintf(pnaObj,['CALC:PAR:DEF ', meas_name(2,:),',S12']); %(S12) Define the measurement trace.
fprintf(pnaObj,['CALC:PAR:DEF ', meas_name(3,:),',S21']); %(S21) Define the measurement trace.
fprintf(pnaObj,['CALC:PAR:DEF ', meas_name(4,:),',S22']); %(S22) Define the measurement trace.
fprintf(pnaObj,['CALC:PAR:SEL ', meas_name(1,:)]); %(S11) Select the  measurement trace.
fprintf(pnaObj, 'CALC:TRAN:TIME:STATE OFF'); % turn off transfrom (to time domain)
fprintf(pnaObj, 'CALC:FILT:TIME:STATE OFF'); % turn off time gating
fprintf(pnaObj, 'DISP:WIND:Y:AUTO'); % Autoscale
fprintf(pnaObj, 'FORM:BORD SWAP');
fprintf(pnaObj, 'FORM REAL,64');
fprintf(pnaObj, 'MMEM:STOR:TRAC:FORM:SNP RI');
fprintf(pnaObj, 'INIT:IMM'); % send trigger to initiate one sweep
fprintf(pnaObj, '*WAI'); % wait until sweep is complete

