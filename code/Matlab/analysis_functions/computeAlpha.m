function alpha = computeAlpha(data,tStart,tStop,index,V)

SCt = squeeze(data.SCt(:,index,:));

%compute the power decay profile
%PDP = <| IFT{SC}|^2>
pdp = mean(abs(SCt).^2,2);

%convert from time to indices
indStart = find(abs(data.time- tStart) == min(abs(data.time - tStart)),1);              
indStop = find(abs(data.time - tStop) == min(abs(data.time - tStop)),1);             

%get the sections
timeSection = data.time(indStart:indStop);

%set the amplitude and smoothing factors
af = 1;
sf = 250;

%smooth the data
smoothPDP = af*smooth(pdp,sf);
smoothPDPSection= smoothPDP(indStart:indStop);

%fit the data to an exponential term
gFit= fit(timeSection,smoothPDPSection, fittype('exp1'));

%get the time constant of the cavity
tau = -1/gFit.b;

f = mean(data.Freq);
Qcomp = 2*pi*f*tau;
k = 2*pi*f/(3E8); % k = w/c
alpha = (k^3*V)/(2*pi^2*Qcomp);
