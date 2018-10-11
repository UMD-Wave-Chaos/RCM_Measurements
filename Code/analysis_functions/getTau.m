function[Tau] = getTau(t,SC,START, STOP)
% Input: SC = the complex inverse tranformed a S parameter vector (time domain)
%         t = time domain vector corresponding to SC
%     START =  the begining of clear exponential decay due to uniform loss
%	  STOP  =  the end of clear exponential decay due to ohmic loss
% Output: Tau = the 1/e energy decay rate
fplot = 1;                                                                  % Set to 1 to plot, 0 to skip plot
b = find(abs(t-START) == min(abs(t-START)));                                % beginging index removing prompt reflection and possible short orbit
f = find(abs(t-STOP) == min(abs(t-STOP)));                                  % ending index stoppping at 2000 electric lengths
sf = 1000; af = 10000;                                                      % smoothing factor, amplitude factor
smoothBsf = af*smooth((abs(SC(b:f))),sf);

% Fit the data using an exponential.
fTYPE = fittype('exp1');
g11 = fit(t((b:f),1),smoothBsf, fTYPE);                                     % fit data to exponential

% Calculate tau, 1/e energy decay time
Tau = 1/(-2*g11.b);                                                         % 1/e 'energy' decay time

% Plot fitted curve in linear and log scale
if fplot == 1
    figure; %close all
    subplot(2,1,1)
    plot(t(b:f)/1E-6,abs(SC(b:f)),'y'); hold on; xlabel('Time (\mus)');
    plot(t(b:f)/1E-6,smoothBsf/af); axis tight;
    
    plot(t(b:f)/1E-6,(g11(t(b:f))/af), 'k'); xlabel('Time (\mus)');
    subplot(2,1,2)
    plot(t(b:f)/1E-6,20*log10(abs(SC(b:f))),'y'); hold on; xlabel('Time (\mus)');
    plot(t(b:f)/1E-6, 20*log10(g11(t(b:f))/af),'k');  axis tight; xlabel('Time (\mus)');
end
end
