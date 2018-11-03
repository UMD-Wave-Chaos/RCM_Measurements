function [OutputSignal,OutputF] = applyTimeGating(InputSignal,InputF,gateTime, varargin)

%[OutputSignal,OutputF] = applyTimeGating(InputSignal,InputF,gateTime)
%[OutputSignal,OutputF] = applyTimeGating(InputSignal,InputF,gateTime, maskType)

%% initialize
%get the mask type if specified
if nargin == 4
    maskType = varargin{1};
else
    maskType = 0;
end

%make sure to remove any singleton dimensions
InputSignal = squeeze(InputSignal);

%setup the window value (Kaiser, Gaussian, etc.)
wVal = 2.5;

%get the size of the input signal
[m,n] = size(InputSignal);

% get the initial frequency span and spacing
fSpan = InputF(end) - InputF(1);
df = fSpan/m;

%set up the pad length and the padded signal size vector
zPadLength = 0;%10000;
newLength = m + 2*zPadLength;
newFSpan = fSpan+2*df*zPadLength;
newStartFreq = InputF(1) - df*zPadLength;

%create the mask
mask = zeros(newLength,1);

%initialize vectors to hold the signals
SignalF = zeros(newLength,1); %temporary storage for the intermediate vectors
OutputSignal = zeros(m,n);%storage for the collection of vectors

%setup the time window to be symmetric about 0
timeWindow = [-1*gateTime 1*gateTime];

%% loop over the number of realizations and apply the gate
for cnt = 1:n
    
 %extract the current signal
 testSignal = InputSignal(:,cnt);
 
 %need to pad the signal in the frequency domain
 %hold the value at the edges
 SignalF(zPadLength+1:zPadLength+m) = testSignal;
 SignalF(1:zPadLength) = testSignal(1);
 SignalF(zPadLength+m+1:end) = testSignal(end);
 
 %now take the ifft to get the signal in time
 [SignalT,t] = ifftS(SignalF,newFSpan,1);
 
 %get the time spacing  
 dt = t(2) - t(1);

 %need to find the closest points to the specified stop and start gates
 indStart = find(abs(t-timeWindow(1)) == min(abs(t-timeWindow(1))),1);
 indStop = find(abs(t-timeWindow(2)) == min(abs(t-timeWindow(2))),1);

 %compute the number of points in the window
 nWindowPoints = indStop-indStart+1;

 %create the window for the mask
 switch maskType
     case 1
         w = window(@kaiser,nWindowPoints,wVal);
         windowString = sprintf('Kaiser, Beta = %f',wVal);
     case 2
         w = window(@blackmanharris,nWindowPoints);
         windowString = 'BlackmanHarris';
     case 3
         w = window(@gausswin,N,wVal);
         windowString = sprintf('Gaussian, Alpha = %f',wVal);
     case 4
         w = window(@hamming,nWindowPoints);
         windowString = 'Hamming';
     otherwise
         w = window(@rectwin,nWindowPoints);
         windowString = 'Rectangular';
 end
 
 mask(indStart:indStop) = w;

 %apply the mask
 SignalT= mask.*SignalT;
    
 %take the fft to get back to frequency domain
 [SignalF,f1] = fftS(SignalT,dt,newStartFreq);
 
 %remove the padded portion of the signals
 OutputSignal(:,cnt) = SignalF(zPadLength+1:zPadLength+m);
 OutputF = f1(zPadLength+1:zPadLength+m);
end

%output messages
dispString = sprintf('Time Gating completed, using %s window',windowString);
disp(dispString);
