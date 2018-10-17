function [Freq, Srad11, Srad12, Srad21, Srad22] = getSradFrequencyDomain(obj1,l,i,NOP)    
        fprintf(obj1, 'CALC:FILT:TIME:STATE ON'); % tunn on gating is on
        start_time = -l*i/(3E8); stop_time = l*i/(3E8); %set the start and stop time for transforming to time domain
        fprintf(obj1, ['CALC:FILT:TIME:START ', num2str(start_time)]);
        fprintf(obj1, ['CALC:FILT:TIME:STOP ', num2str(stop_time)]);
        fprintf(obj1, 'INIT:IMM'); % send trigger to initiate one sweep
        fprintf(obj1, '*WAI'); % wait until sweep is complete
        % Request frequency domain S paramter measurement in real and imaginary
        fprintf(obj1, 'DISP:WIND:Y:AUTO'); % Autoscale
        fprintf(obj1, ['CALC:DATA:SNP? ',2]); % Ask for S parameter data
        X = binblockread(obj1, 'float64');
        fprintf(obj1, '*WAI'); % wait until data tranfer is complete
        Freq = X(1:(NOP));
        S11R = X(NOP+1:NOP+(NOP));
        S11I = X(2*NOP+1:2*NOP+(NOP));
        %2 Port Data Collection
        S21R = X(3*NOP+1:3*NOP+(NOP));     S21I = X(4*NOP+1:4*NOP+(NOP));
        S12R = X(5*NOP+1:5*NOP+(NOP));     S12I = X(6*NOP+1:6*NOP+(NOP));
        S22R = X(7*NOP+1:7*NOP+(NOP));     S22I = X(8*NOP+1:8*NOP+(NOP));
        Srad11 = S11R + 1i*S11I; %2 Port Data Collected
        Srad12 = S12R + 1i*S12I;
        Srad21 = S21R + 1i*S21I;
        Srad22 = S22R + 1i*S22I;