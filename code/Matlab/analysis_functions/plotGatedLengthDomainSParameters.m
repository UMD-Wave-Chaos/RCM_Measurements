function plotGatedLengthDomainSParameters(data,port,gateTime)
c = 2.99792458e8;


if port == 1
    portString = 11;
elseif port == 2
    portString = 12;
elseif port == 3
    portString = 21;
elseif port == 4
    portString = 22;
end

%gate the frequency domain measurements
[Sf,~] = applyTimeGating(data.SCf(:,port,:),data.Freq,gateTime,0,0.1);
[St,t]= ifftS(Sf,data.Freq(end) - data.Freq(1));
t = t - 1e-9;
St0 = max(mean(abs(St(data.time >= 0,:)),2));


St1 = squeeze(data.SCt(:,port,:));
St01 = max(mean(abs(St1(data.time >= 0,:)),2));

figure
plot(c*data.time,abs(St1)/St01,'HandleVisibility','off');
hold on
plot(c*data.time,mean(abs(St1),2)/St01,'k','LineWidth',2);
plot(c*t,mean(abs(St),2)/St0,'b','LineWidth',2);
grid on
xlabel('Length (m)')
ylabel('|IFT\{S\}|')
set(gca,'FontSize',12)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',2)
xlim([0 15])
tstring = sprintf('S_{%d}',portString);
title(tstring);
lstring = sprintf('%0.2f ns Gating',gateTime*1e9);
legend('No Gating',lstring);

% figure
% plot(c*data.time,abs(Zt));
% hold on
% plot(c*data.time,mean(abs(Zt),2),'k','LineWidth',2);
% grid on
% xlabel('Length (m)')
% ylabel('|IFT\{Z\}|')
% set(gca,'FontSize',12)
% set(gca,'FontWeight','bold')
% set(gca,'LineWidth',2)
% xlim([0 15])
% tstring = sprintf('Z_{%d}',portString);
% title(tstring);