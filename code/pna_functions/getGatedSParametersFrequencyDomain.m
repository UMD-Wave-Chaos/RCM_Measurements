function [Freq, S11, S12, S21, S22] = getGatedSParametersFrequencyDomain(obj1,tValue,NOP) 

%set up the PNA to allow a time gated measurement
fprintf(obj1, 'CALC:TRAN:TIME:STATE OFF'); % turn time transform off
fprintf(obj1, 'CALC:FILT:TIME:STATE ON'); % turn time gating on
start_time = -tValue;
stop_time = tValue;
%start_time = -tValue/(3E8); stop_time = tValue/(3E8); %set the start and stop time for transforming to time domain
fprintf(obj1, ['CALC:FILT:TIME:START ', num2str(start_time)]);
fprintf(obj1, ['CALC:FILT:TIME:STOP ', num2str(stop_time)]);

%now get the S parameters
[Freq,S11,S12,S21,S22] = getSParameters(obj1,NOP);