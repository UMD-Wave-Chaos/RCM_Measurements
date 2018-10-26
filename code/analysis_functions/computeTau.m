function [Tau, g11, smoothBsf, startIndex, stopIndex] = computeTau(t,SC,l, af, sf)


%Need to prevent prompt reflections and short orbits from contributing,
%clip the start of the signal for processing at 500 electric lengths 
startOffset = l*500/3e8;
startIndex = find(abs(t - startOffset) == min(abs(t- startOffset)));

%Need to prevent cavity reflections from contributing,
%clip the end of the signal for processing at 1500 electric lengths
stopOffset = l*1500/3e8;
stopIndex = find(abs(t - stopOffset) == min(abs(t - stopOffset)));             

%smooth the signal
smoothBsf = af*smooth((abs(SC(startIndex:stopIndex))),sf);

% Fit the data using a superposition of two exponentials.
fTYPE = fittype('exp1');
g11 = fit(t((startIndex:stopIndex),1),smoothBsf, fTYPE);                                     % fit data to exponential

% Calculate tau, 1/e energy decay time 
Tau = 1/(-2*g11.b);                                                         % 1/e 'energy' decay time
