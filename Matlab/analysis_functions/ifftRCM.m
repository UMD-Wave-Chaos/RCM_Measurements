function [OutputSignal,OutputT] = ifftRCM(InputSignal,InputF)

%[OutputSignal,OutputF] = applyTimeGating(InputSignal,InputF,)


%% initialize

%make sure to remove any singleton dimensions
InputSignal = squeeze(InputSignal);

%get the size of the input signal
[m,n] = size(InputSignal);

%setup the pad length and get the size of the 1-sided signal
zPadLength = 1000;
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
% OutputSignal = zeros(m,n);%storage for the collection of vectors


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

     %keep the 1-sided spectrum that is unpadded
     OutputSignal(:,cnt) = SignalT;
     OutputT = t;
end
