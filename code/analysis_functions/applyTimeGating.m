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

%setup the pad length and get the size of the 1-sided signal
zPadLength = 0;
newLength1Sided = m + 2*zPadLength;

% get the initial frequency span and spacing
fSpan = InputF(end) - InputF(1);
df = fSpan/m; 

%need to increase the frequency span according to the pad length
newFSpan = fSpan+2*df*zPadLength;
newStartFreq = InputF(1) - df*zPadLength;

%create the mask
mask = zeros(2*newLength1Sided,1);

%initialize vectors to hold the signals
SignalF = zeros(2*newLength1Sided,1); %temporary storage for the intermediate vectors
OutputSignal = zeros(m,n);%storage for the collection of vectors

%setup the time window to be symmetric about 0
timeWindow = [-1*gateTime 1*gateTime];

%% loop over the number of realizations and apply the gate
for cnt = 1:n
    
    %create a temporary vector to contain the 1-sided signal
    testSignal = zeros(newLength1Sided,1);

    %extract the current signal
    testSignal(zPadLength+1:zPadLength+m) = InputSignal(:,cnt);

    %hold the values at the edges - pad the signal
    testSignal(1:zPadLength) = InputSignal(1,cnt);
    testSignal(zPadLength+m+1:end) = InputSignal(end,cnt);

    %need to convert to a 2-sided spectrum
    SignalF = [flipud(testSignal); testSignal];
 
    %now take the ifft to get the signal in time
    [SignalT,t] = ifftS(SignalF,newFSpan);
 
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
             w = window(@gausswin,nWindowPoints,wVal);
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
     %make sure to shift the spectrum back to the center to preserve phase
     [SignalF,f1] = fftS(fftshift(SignalT),dt,newStartFreq);

     %keep the 1-sided spectrum that is unpadded
     OutputSignal(:,cnt) = SignalF(zPadLength+1:zPadLength+m);
     OutputF = f1(zPadLength+1:zPadLength+m);
end

%output messages
dispString = sprintf('Time Gating completed, using %s window',windowString);
disp(dispString);