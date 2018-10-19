function [t,SCt11, SCt12, SCt21, SCt22] = getSCavTimeDomain(obj1,NOP,start_time,stop_time,handles)

fprintf(obj1, 'CALC:TRAN:TIME:STATE ON'); % ensure tranform is on
fprintf(obj1, 'CALC:FILT:TIME:STATE OFF'); % ensure gating is off
%start_time = -0.5E-6; stop_time = 10E-6; %set the start and stop time for transforming to time domain
fprintf(obj1, ['CALC:TRAN:TIME:START ', num2str(start_time)]);
fprintf(obj1, ['CALC:TRAN:TIME:STOP ', num2str(stop_time)]);

tstart = query(obj1, 'CALC:TRAN:TIME:STAR?');
tstop = query(obj1, 'CALC:TRAN:TIME:STOP?');

if (start_time < str2num(tstart))
    wstring = sprintf ('Requested start time %f is less than min PNA start time %s, setting to min PNA start time',start_time, tstart);
    logMessage(handles.jEditbox,wstring,'warn');
    fprintf(obj1, 'CALC:TRAN:TIME:START MIN');
end

if (stop_time > str2num(tstop))
    wstring = sprintf ('Requested stop time %f is greater than max PNA stop time %s, setting to max PNA stop time',stop_time, tstop);
    logMessage(handles.jEditbox,wstring,'warn');
    fprintf(obj1, 'CALC:TRAN:TIME:STOP MAX');
end

fprintf(obj1, 'DISP:WIND:Y:AUTO'); % Autoscale
fprintf(obj1, 'INIT:IMM'); % send trigger to initiate one sweep
fprintf(obj1, '*WAI'); % wait until sweep is complete
% Request frequency domain S paramter measurement in real and imaginary
fprintf(obj1, 'DISP:WIND:Y:AUTO'); % Autoscale
fprintf(obj1, ['CALC:DATA:SNP? ',2]); % Ask for S parameter data
X = binblockread(obj1, 'float64');
fprintf(obj1, '*WAI'); % wait until data tranfer is complete
t = X(1:(NOP));
        
%Importing the two port data
S11R = X(NOP+1:NOP+(NOP));
S11I = X(2*NOP+1:2*NOP+(NOP));
S21R = X(3*NOP+1:3*NOP+(NOP));     S21I = X(4*NOP+1:4*NOP+(NOP));
S12R = X(5*NOP+1:5*NOP+(NOP));     S12I = X(6*NOP+1:6*NOP+(NOP));
S22R = X(7*NOP+1:7*NOP+(NOP));     S22I = X(8*NOP+1:8*NOP+(NOP));
SCt11 = S11R + 1i*S11I; %One port line
SCt12 = S21R + 1i*S21I;
SCt21 = S12R + 1i*S12I;
SCt22 = S22R + 1i*S22I;    