function [efficiencyA, efficiencyB] = computeRadiationEfficiency(data,V,varargin)

%% check inputs
if nargin == 3
    foldername = varargin{1};
    savePlots = 1;
else
    savePlots = 0;
end

%get the cavity scale factor
lambda = 3e8./data.Freq;
Crc = 16*pi^2*V./lambda.^3;

%separate the S-parameters
S11 = squeeze(data.SCf(:,1,:));
S21 = squeeze(data.SCf(:,3,:));
S22 = squeeze(data.SCf(:,4,:));

%get the unstirred S-parameters
S11_u = mean(S11,2);
S21_u = mean(S21,2);
S22_u = mean(S22,2);

%get the stirred S-parameter power
S11_s2 = mean(abs(S11 - S11_u).^2,2);
S21_s2 = mean(abs(S21 - S21_u).^2,2);
S22_s2 = mean(abs(S22 - S22_u).^2,2);

%get the enhanced backscatter
eb = sqrt(S11_s2.*S22_s2)./S21_s2;

%get the corrected S-parameter power
S11_fact = 1 - abs(mean(S11,2)).^2;
S22_fact = 1 - abs(mean(S22,2)).^2;
S11_s2_corr = S11_s2./(S11_fact.*S11_fact);
S22_s2_corr = S22_s2./(S22_fact.*S22_fact);

figure
plot(data.Freq/1e9,S11_s2,'LineWidth',2);
hold on
plot(data.Freq/1e9,S11_s2_corr,'LineWidth',2);
grid on
legend('S11','S11c')


figure
plot(data.Freq/1e9,S22_s2,'LineWidth',2);
hold on
plot(data.Freq/1e9,S22_s2_corr,'LineWidth',2);
grid on
legend('S22','S22c')

%get the pdp

[St11,~] = ifftS(S11,data.Freq(end) - data.Freq(1));
[St21,~] = ifftS(S21,data.Freq(end) - data.Freq(1));
[St22,t] = ifftS(S22,data.Freq(end) - data.Freq(1));

pdp11 = mean(abs(St11).^2,2);
pdp21 = mean(abs(St21).^2,2);
pdp22 = mean(abs(St22).^2,2);

tStart = 750e-9;
tStop = 2.5e-6;

tau1 = computeTauRC(pdp11,t,tStart,tStop);
close(gcf);
tau2 = computeTauRC(pdp21,t,tStart,tStop);
close(gcf);
tau3 = computeTauRC(pdp22,t,tStart,tStop);
close(gcf);

tauRC = mean([tau1 tau2 tau3]);

efficiencyA = sqrt(Crc.*S11_s2_corr./(2*pi*data.Freq.*eb*tauRC));
efficiencyB = sqrt(Crc.*S22_s2_corr./(2*pi*data.Freq.*eb*tauRC));

figure
plot(data.Freq/1e9,efficiencyA,'LineWidth',2);
hold on
plot(data.Freq/1e9,efficiencyB,'LineWidth',2);
grid on
xlabel('Freqency (GHz)')
ylabel('\eta');
legend('Port 1','Port 2');
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');

if (savePlots)
    saveas(h1,fullfile(foldername,'Port_radiation_efficiency'),'png');
    close (h1)
end