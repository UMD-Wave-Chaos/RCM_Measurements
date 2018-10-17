function [Freq, SCf11, SCf12, SCf21, SCf22] = getSCavFrequencyDomain(obj1,NOP);

fprintf(obj1, 'CALC:TRAN:TIME:STATE OFF'); % turn off transfrom (to time domain)
fprintf(obj1, 'INIT:IMM'); % send trigger to initiate one sweep
fprintf(obj1, '*WAI'); % wait until sweep is complete
% Request frequency domain S paramter measurement in real and imaginary
fprintf(obj1, 'DISP:WIND:Y:AUTO'); % Autoscale
fprintf(obj1, ['CALC:DATA:SNP? ',2]); % Ask for S parameter data
X = binblockread(obj1, 'float64');
fprintf(obj1, '*WAI'); % wait until data tranfer is complete
Freq = X(1:(NOP));
%Importing the two port data
S11R = X(NOP+1:NOP+(NOP));
S11I = X(2*NOP+1:2*NOP+(NOP));
S21R = X(3*NOP+1:3*NOP+(NOP));     S21I = X(4*NOP+1:4*NOP+(NOP));
S12R = X(5*NOP+1:5*NOP+(NOP));     S12I = X(6*NOP+1:6*NOP+(NOP));
S22R = X(7*NOP+1:7*NOP+(NOP));     S22I = X(8*NOP+1:8*NOP+(NOP));
SCf11 = S11R + 1i*S11I; %One port line
SCf12 = S21R + 1i*S21I;
SCf21 = S12R + 1i*S12I;
SCf22 = S22R + 1i*S22I;