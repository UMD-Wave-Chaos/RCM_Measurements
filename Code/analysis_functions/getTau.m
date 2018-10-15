function[Tau] = getTau(t,SC,l)
% Input: SC = the complex inverse tranformed a S parameter vector (time domain)
%         t = time domain vector corresponding to SC
%         l = approximate elctrical length of antenna (meters)       
% Output: Tau = the 1/e energy decay rate
       
fplot = 1;                                                                  % Set to 1 to plot, 0 to skip plot
b = find(abs(t-((l*500)/3E8)) == min(abs(t-((l*500)/3E8))));              % beginging index removing prompt reflection and possible short orbit (1000 electric lengths)
f = find(abs(t-((l*1500)/3E8)) == min(abs(t-((l*1500)/3E8))));              % ending index stoppping at 2000 electric lengths
m = ceil((b+(f-b)/2));                                                       % location of text on plot
sf = 1000; af = 10000;                                                      % smoothing factor, amplitude factor
smoothBsf = af*smooth((abs(SC(b:f))),sf);
if fplot == 1
    figure; %close all
    subplot(2,1,1)
    plot(t(b:f)/1E-6,abs(SC(b:f)),'y'); hold on; xlabel('Time (\mus)');
    plot(t(b:f)/1E-6,smoothBsf/af); axis tight; 
end

% Fit the data using a superposition of two exponentials.
fTYPE = fittype('exp1');
g11 = fit(t((b:f),1),smoothBsf, fTYPE);                                     % fit data to exponential

% Calculate tau, 1/e energy decay time 
Tau = 1/(-2*g11.b);                                                         % 1/e 'energy' decay time

% Plot fitted curve in linear and log scale
if fplot == 1       
    text(t(m),0.9*max(smoothBsf)/af,{'g11(x) = a*exp(b*x)';...
        [' a = ',num2str(g11.a/af)]; ...
        [' b = ',num2str(g11.b)]; ...
        });
    plot(t(b:f)/1E-6,(g11(t(b:f))/af), 'k'); xlabel('Time (\mus)');
    subplot(2,1,2)
    plot(t(b:f)/1E-6,20*log10(abs(SC(b:f))),'y'); hold on; xlabel('Time (\mus)');
    plot(t(b:f)/1E-6, 20*log10(g11(t(b:f))/af),'k');  axis tight; xlabel('Time (\mus)');
end
end