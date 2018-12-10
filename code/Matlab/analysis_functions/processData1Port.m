function processData1Port(data,V,index)

f = mean(data.Freq);
lambda = 3e8./f;
Crc = 16*pi^2*V./(lambda.^3);

%split out the S-parameters
S = squeeze(data.SCf(:,index,:));

%get the unstirred energy
S_u = mean(S,2);

%get the stirred power
S_s2 = mean(abs(S - S_u ).^2,2);

%get the corrected power
S_fact = 1 - abs(mean(S,2)).^2;
S_s2c = S_s2./(S_fact.*S_fact);

S2 = abs(S).^2;

[Smax2,Smax2I] = max(S2,[],2);
[Smin2,Smin2I] = min(S2,[],2);
S2ratio = Smax2./Smin2;

figure
plot(data.Freq/1e9,10*log10(S2ratio),'LineWidth',2);
grid on
xlabel('Frequency (GHz)')
ylabel('Transmitted Power Ratio (dB)')
grid on
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');


figure
plot(data.Freq/1e9,10*log10(abs(S_u.^2)),'LineWidth',2)
hold on
plot(data.Freq/1e9,10*log10(S_s2),'LineWidth',2);
plot(data.Freq/1e9,10*log10(S_s2c),'LineWidth',2);
xlabel('Frequency (GHz)')
ylabel('Power (dB)')
legend('S^2_u','S_s^2','S^2_c')
grid on
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');

%get the time domain signals
[St,t] = ifftS(S,data.Freq(end) - data.Freq(1));

%get the pdp
pdp = mean(abs(St).^2,2);

%get time constants
tStart = 750e-9;
tStop = 2.5e-6;
tau_rc = computeTauRC(pdp,t,tStart,tStop);
% tau_rc = 613e-9;
close(gcf);
dispstring = sprintf('tau_rc = %0.3f ns',tau_rc*1e9);
disp(dispstring);

%get the antenna total efficiencies
eta_t = sqrt(Crc./(2*pi*f.*2).*(S_s2/tau_rc));

%get the antenna radiation efficiencies
eta_r = sqrt(Crc./(2*pi*f.*2).*(S_s2c/tau_rc));

figure
plot(data.Freq/1e9,eta_t,'LineWidth',2);
hold on
plot(data.Freq/1e9,eta_r,'LineWidth',2);
grid on
xlabel('Freqency (GHz)')
ylabel('\eta');
legend('Total Efficiency','Radiation Efficiency');
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');