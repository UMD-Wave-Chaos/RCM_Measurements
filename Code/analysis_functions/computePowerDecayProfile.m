function [tau,pdp] = computePowerDecayProfile(SCt,t,l,index,foldername,varargin)

if nargin == 6
    savePlots = varargin{1};
else
    savePlots = 0;
end

%compute the power decay profile
%PDP = <| IFT{SC}|^2>
pdp = mean(abs(SCt(:,index,:)).^2,3);

%set the break points in time for the number of electrical lengths
%try 500 to 1500
tStart = l*500/3E8;
tStop = l*1500/3E8;
 
%convert from time to indices
indStart = find(abs(t- tStart) == min(abs(t-tStart)));              
indStop = find(abs(t - tStop) == min(abs(t - tStop)));             

%get the sections
pdpSection = pdp(indStart:indStop);
timeSection = t(indStart:indStop);

%get the "early time" and the "late time"
af = 10000;
sf = 1000;

%smooth the data
smoothPDPSection= af*smooth(pdpSection,sf);

%fit the data to an exponential term
gFit= fit(timeSection,smoothPDPSection, fittype('exp1'));

%get the time constant of the cavity
tau = -1/gFit.b;

%plot the results
%get the index string
if index == 1
    indString = '11';
elseif index == 2
    indString = '12';
elseif index == 3
    indString = '21';
else
    indString = '22';
end

tString = sprintf('S%s PDP',indString);
h1 = figure('Name', tString);
subplot(2,1,1)
plot(timeSection*1e6,pdpSection);
hold on
plot(timeSection*1e6,smoothPDPSection/af,'LineWidth',2);
plot(timeSection*1e6,gFit(timeSection)/af,'LineWidth',2);
grid on
xlabel('Time (\mus)')
ylabel('PDP(t)')
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');
legend('Raw','Smoothed','Fit');
tString = sprintf('S_{%s} Linear PDP',indString);
title(tString);

centerInd = indStart + floor((indStop-indStart)/2);
tString = sprintf('\\tau = %0.3f ns',tau*1e9);
text(t(centerInd)*1e6, gFit(t(centerInd))*2/af,tString,'FontWeight','bold','FontSize',12);

subplot(2,1,2)
plot(timeSection*1e6,20*log10(pdpSection));
hold on
plot(timeSection*1e6,20*log10(smoothPDPSection/af),'LineWidth',2);
plot(timeSection*1e6,20*log10(gFit(timeSection)/af),'LineWidth',2);
grid on
xlabel('Time (\mus)')
ylabel('PDP(t) (dB)')
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');
legend('Raw','Smoothed','Fit');
tString = sprintf('S_{%s} Log Mag PDP',indString);
title(tString);

if (savePlots)
    fname = sprintf('S%s_PDP',indString);
    saveas(h1,fullfile(foldername,fname),'png');
    close (h1)

end
