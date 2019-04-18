function plotLengthDomainSParameters(data,port,varargin)
c = 2.99792458e8;


% check inputs
if nargin == 3
    foldername = varargin{1};
    savePlots = 1;
else
    savePlots = 0;
end



if port == 1
    portString = 11;
elseif port == 2
    portString = 12;
elseif port == 3
    portString = 21;
elseif port == 4
    portString = 22;
end

St = squeeze(data.SCt(:,port,:));
St0 = max(mean(abs(St(data.time >= 0,:)),2));
%St0 = 1;
Zt = transformToZSinglePort(St);


hh1 = figure;
plot(c*data.time,abs(St)/St0);
hold on
plot(c*data.time,mean(abs(St),2)/St0,'k','LineWidth',2);
grid on
xlabel('Length (m)')
ylabel('|IFT\{S\}|')
set(gca,'FontSize',12)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',2)
xlim([0 15])
tstring = sprintf('S_{%d}',portString);
title(tstring);

hh2 = figure;
plot(c*data.time,abs(Zt));
hold on
plot(c*data.time,mean(abs(Zt),2),'k','LineWidth',2);
grid on
xlabel('Length (m)')
ylabel('|IFT\{Z\}|')
set(gca,'FontSize',12)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',2)
xlim([0 15])
tstring = sprintf('Z_{%d}',portString);
title(tstring);

if savePlots
    
    fString1 = sprintf('S_length_%d',portString);
    fString2 = sprintf('Z_length_%d',portString);
    saveas(hh1,fullfile(foldername,fString1),'png');
    saveas(hh2,fullfile(foldername,fString2),'png');

    close(hh1)
    close(hh2)
end
