function pdp = computePowerDecayProfile(SCt,t,index,Ht,varargin)

%% check inputs
if nargin == 5
    foldername = varargin{1};
    savePlots = 1;
else
    savePlots = 0;
end

SCt = squeeze(SCt(:,index,:));

%compute the power decay profile
%PDP = <| IFT{SC}|^2>
pdp = mean(abs(SCt).^2,2);

hh1 = figure('Position',[10 100 800 800],'NumberTitle', 'off', 'Name', 'PDP'); 
subplot(2,1,1)
plot(t*1e6,10*log10(pdp),'LineWidth',2);
hold on
extent = get(gca,'YLim');
yline = linspace(extent(1),extent(2),100);
plot(ones(100,1)*Ht*1e6,yline,'--k','LineWidth',2);
ylabel('PDP (dB)');
xlabel('Time (\mus)');
title('Power Decay Profile');
grid on
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');

subplot(2,1,2)
semilogy(t*1e6,pdp,'LineWidth',2);
hold on
extent = get(gca,'YLim');
yline = linspace(extent(1),extent(2),100);
plot(ones(100,1)*Ht*1e6,yline,'--k','LineWidth',2);
ylabel('PDP (W)');
xlabel('Time (\mus)');
title('Power Decay Profile');
grid on
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');

if (savePlots)

    saveas(hh1,fullfile(foldername,'power_decay_profile'),'png');

    close (hh1)
end