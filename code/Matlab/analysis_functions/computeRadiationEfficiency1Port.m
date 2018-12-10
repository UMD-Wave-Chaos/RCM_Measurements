function [eta_r,eta_t] = computeRadiationEfficiency1Port(data,V,index)

f1 = mean(data.Freq);
f2 = data.Freq;
lambda = 3e8./f1;
Crc = 16*pi^2*V./(lambda.^3);

%split out the S-parameters
S = squeeze(data.SCf(:,index,:));

%get the unstirred energy
S_u = mean(S,2);


%get the stirred power
S_s2 = mean(abs(S - S_u ).^2,2);

%get the corrected power
S_fact = 1 - abs(mean(S,2)).^2;
S_s2c = S_s2./(S_fact);

%get the time domain signals
[St,t] = ifftS(S,data.Freq(end) - data.Freq(1));


%get the pdp
pdp = mean(abs(St).^2,2);

%get time constants
tStart = 750e-9;
tStop = 2.5e-6;
tau_rc = computeTauRC(pdp,t,tStart,tStop);
close(gcf);

%get the antenna total efficiencies
eta_t = sqrt(Crc./(2*pi*f2.*2).*(S_s2/tau_rc));

%get the antenna radiation efficiencies
eta_r = sqrt(Crc./(2*pi*f2.*2).*(S_s2c/tau_rc));

figure
plot(data.Freq/1e9,eta_r,'LineWidth',2);
hold on
plot(data.Freq/1e9,eta_t,'LineWidth',2);
grid on
xlabel('Freqency (GHz)')
ylabel('\eta');
legend('\eta_r','\eta_t');
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');
