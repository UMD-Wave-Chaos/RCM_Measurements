function [t,S11,S12,S21,S22] = getSparametersTimeDomain(obj1,meas_name )
%[t,S11,S12,S21,S22] = getSparametersFrequencyDomain(obj1,meas_name)
%This function returns the S parameters for a 2 port measurement in the
%time domain
%Inputs: 
% obj1 - the GPIB object connected to the PNA
% meas_name - the defined measurement traces for the 4 traces in the PNA
%Outputs:
% t - the vector of times
% S11 - the vector of S11 measurements
% S12 - the vector of S12 measurements
% S21 - the vector of S21 measurements
% S22 - the vector of S22 measurements

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
    
    t = linspace(start_time,stop_time,length(SR))';
    if (port == 1)
        S11 = SR + 1j*SI;
    elseif (port == 2)
        S12 = SR + 1j*SI;
    elseif (port == 3)
        S21 = SR + 1j*SI;
    elseif (port == 4)
        S22 = SR + 1j*SI;
    end
end