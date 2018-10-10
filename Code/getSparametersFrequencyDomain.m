function [Freq, S11,S12,S21,S22] = getSparametersFrequencyDomain(obj1,NOP, varargin )
%[Freq, S11,S12,S21,S22] = getSparametersFrequencyDomain(obj1,NOP)
%[Freq, S11,S12,S21,S22] = getSparametersFrequencyDomain(obj1,NOP,timeGating) 
%[Freq, S11,S12,S21,S22] = getSparametersFrequencyDomain(obj1,NOP,timeGating,index,l)
%This function returns the S parameters for a 2 port measurement in the
%frequency domain
%Inputs: 
% obj1 - the GPIB object connected to the PNA
% NOP - the number of points the PNA is set to provide
% timeGating (optional) - boolean that indicates whether or not to enable time gating
% index (optional) - integer to indicate the index for time gating,
% required if timeGating is true
% l (optional) - electrical length of the antenna, required if timeGating
% is true
%Outputs:
% Freq - the vector of frequencies
% S11 - the vector of S11 measurements
% S12 - the vector of S12 measurements
% S21 - the vector of S21 measurements
% S22 - the vector of S22 measurements

%get the variable input arguments
if (nargin == 2)
    timeGating = false;
elseif (nargin == 3)
    timeGating = varargin{1};
else
    timeGating = varargin{1};
    index = varargin{2};
    l = varargin{3};
end

fprintf(obj1, 'CALC:TRAN:TIME:STATE OFF'); % turn off transfrom (to time domain)

if (timeGating == true)
    fprintf(obj1, 'CALC:FILT:TIME:STATE ON'); % turn on time gating
    start_time = -l*index/(3E8); stop_time = l*index/(3E8); %set the start and stop time for transforming to time domain
    fprintf(obj1, ['CALC:FILT:TIME:START ', num2str(start_time)]);
    fprintf(obj1, ['CALC:FILT:TIME:STOP ', num2str(stop_time)]);
else
    fprintf(obj1, 'CALC:FILT:TIME:STATE OFF'); % turn off time gating
end
fprintf(obj1, 'INIT:IMM'); % send trigger to initiate one sweep
fprintf(obj1, '*WAI'); % wait until sweep is complete
% Request frequency domain S paramter measurement in real and imaginary
fprintf(obj1, 'DISP:WIND:Y:AUTO'); % Autoscale
fprintf(obj1, 'CALC:DATA:SNP? 2'); % Ask for S parameter data
X = binblockread(obj1, 'float64');
fprintf(obj1, '*WAI'); % wait until data tranfer is complete
Freq = X(1:(NOP));
%Importing the two port data
S11 = X(1*NOP+1:1*NOP+(NOP)) + 1j*X(2*NOP+1:2*NOP+(NOP));  
S21 = X(3*NOP+1:3*NOP+(NOP)) + 1j*X(4*NOP+1:4*NOP+(NOP));
S12 = X(5*NOP+1:5*NOP+(NOP)) + 1j*X(6*NOP+1:6*NOP+(NOP));
S22 = X(7*NOP+1:7*NOP+(NOP)) + 1j*X(8*NOP+1:8*NOP+(NOP));