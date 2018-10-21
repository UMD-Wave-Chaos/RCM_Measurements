function initializePNA(NOP,fStart,fStop)

fprintf(obj1, ['SENS:SWE:POINTS ', num2str(NOP)]); % set number of points

fprintf(obj1, 'OUTP ON'); % turn RF power on
fprintf(obj1, 'SENS1:AVER OFF'); % turn averaging off
fprintf(obj1, 'SENS:SWE:MODE HOLD'); % set sweep mode to hold
fprintf(obj1, 'TRIG:SOUR MAN'); % set triggering to manual
DIRECTION = 1; % "Direction" is -1 for clockwise and 1 for counterclockwise for stepper motor rotation
% meas_name(1,:) = 'CH1_S11';
% meas_name(2,:) = 'CH1_S12';
% meas_name(3,:) = 'CH1_S21';
% meas_name(4,:) = 'CH1_S22';
% fprintf(obj1,['CALC:PAR:DEF ', meas_name(1,:),',S11']); %(S11) Define the measurement trace. 
% fprintf(obj1,['CALC:PAR:DEF ', meas_name(2,:),',S12']); %(S12) Define the measurement trace.
% fprintf(obj1,['CALC:PAR:DEF ', meas_name(3,:),',S21']); %(S21) Define the measurement trace.
% fprintf(obj1,['CALC:PAR:DEF ', meas_name(4,:),',S22']); %(S22) Define the measurement trace.
% fprintf(obj1,['CALC:PAR:SEL ', meas_name(1,:);]) %(S11) Select the  measurement trace.
fprintf(obj1, 'CALC:TRAN:TIME:STATE OFF'); % turn off transform (to time domain)
fprintf(obj1, 'CALC:FILT:TIME:STATE OFF'); % turn off time gating
fprintf(obj1, 'DISP:WIND:Y:AUTO'); % Autoscale
fprintf(obj1, 'FORM:BORD SWAP');
fprintf(obj1, 'FORM REAL,64');
fprintf(obj1, 'MMEM:STOR:TRAC:FORM:SNP RI');
fprintf(obj1, 'INIT:IMM'); % send trigger to initiate one sweep
fprintf(obj1, '*WAI'); % wait until sweep is complete
fprintf(obj1, ['SENS:FREQ:STAR ' num2str(fStart)] ); %set the start frequency
fprintf(obj1, ['SENS:FREQ:STOP ' num2str(fStop)]); %set the stop frequency