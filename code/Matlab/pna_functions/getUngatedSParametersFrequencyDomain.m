function [Freq, S11, S12, S21, S22] = getUngatedSParametersFrequencyDomain(obj1,NOP)

%setup the PNA to take an ungated (standard) frequency domain measurement
fprintf(obj1, 'CALC:TRAN:TIME:STATE OFF'); % turn time transform off
fprintf(obj1, 'CALC:FILT:TIME:STATE OFF'); % turn time gating off

%now get the S parameters
[Freq,S11,S12,S21,S22] = getSParameters(obj1,NOP);