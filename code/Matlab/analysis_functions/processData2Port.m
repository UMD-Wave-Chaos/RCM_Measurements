function processData1Port(data,V)

f1 = mean(data.Freq);
f2 = data.Freq;
lambda = 3e8./f1;
Crc = 16*pi^2*V./(lambda.^3);

%split out the S-parameters
S11 = squeeze(data.SCf(:,1,:));
S21 = squeeze(data.SCf(:,3,:));
S22 = squeeze(data.SCf(:,4,:));

% S11 = applyTimeGating(S11,data.Freq,1000e-9,0,0.5);
% S21 = applyTimeGating(S21,data.Freq,1000e-9,0,0.5);
% S22 = applyTimeGating(S22,data.Freq,10e-9,0,0.5);

[m,n] = size(S11);

%get the unstirred energy
S11_u = mean(S11,2);
S21_u = mean(S21,2);
S22_u = mean(S22,2);


%get the stirred power
S11_s2 = mean(abs(S11 - S11_u ).^2,2);
S21_s2 = mean(abs(S21 - S21_u ).^2,2);
S22_s2 = mean(abs(S22 - S22_u ).^2,2);

%get the corrected power
S11_fact = 1 - abs(mean(S11,2)).^2;
S11_s2c = S11_s2./(S11_fact);

S21_fact = 1 - abs(mean(S21,2)).^2;
S21_s2c = S21_s2./(S21_fact);

S22_fact = 1 - abs(mean(S22,2)).^2;
S22_s2c = S22_s2./(S22_fact);

figure
plot(data.Freq/1e9,10*log10(S11_s2),'LineWidth',2);
hold on
plot(data.Freq/1e9,10*log10(S11_s2c),'LineWidth',2);
plot(data.Freq/1e9,20*log10(abs(S11_u)),'LineWidth',2);
grid on
legend('S11','S11c','S11u')

figure
plot(data.Freq/1e9,10*log10(S22_s2),'LineWidth',2);
hold on
plot(data.Freq/1e9,10*log10(S22_s2c),'LineWidth',2);
plot(data.Freq/1e9,20*log10(abs(S22_u)),'LineWidth',2);
grid on
legend('S22','S22c','S22u')

figure
plot(data.Freq/1e9,10*log10(S21_s2),'LineWidth',2);
hold on
plot(data.Freq/1e9,10*log10(S21_s2c),'LineWidth',2);
plot(data.Freq/1e9,20*log10(abs(S21_u)),'LineWidth',2);
grid on
legend('S21','S21c','S21u')

%compute the enhanced backscatter
eb = sqrt(S11_s2.*S22_s2)./S21_s2;

eb = 2*ones(m,1);

%get the time domain signals
S11t = ifftS(S11,data.Freq(end) - data.Freq(1));
S21t = ifftS(S21,data.Freq(end) - data.Freq(1));
[S22t,t] = ifftS(S22,data.Freq(end) - data.Freq(1));

%get the pdp
pdp11 = mean(abs(S11t).^2,2);
pdp21 = mean(abs(S21t).^2,2);
pdp22 = mean(abs(S22t).^2,2);

%get time constants
tStart = 750e-9;
tStop = 2.5e-6;
tau11 = computeTauRC(pdp11,t,tStart,tStop);
close(gcf);

tau21 = computeTauRC(pdp21,t,tStart,tStop);
close(gcf);

tau22 = computeTauRC(pdp22,t,tStart,tStop);
close(gcf);

tau_rc = mean([tau11 tau21 tau22]);

%get the antenna total efficiencies
eta_a_t = sqrt(Crc./(2*pi*f2.*eb).*(S11_s2/tau_rc));
eta_b_t = sqrt(Crc./(2*pi*f2.*eb).*(S22_s2/tau_rc));

%get the antenna radiation efficiencies
eta_a_r = sqrt(Crc./(2*pi*f2.*eb).*(S11_s2c/tau_rc));
eta_b_r = sqrt(Crc./(2*pi*f2.*eb).*(S22_s2c/tau_rc));

figure
plot(data.Freq/1e9,eta_a_r,'LineWidth',2);
hold on
plot(data.Freq/1e9,eta_b_r,'LineWidth',2);
grid on
xlabel('Freqency (GHz)')
ylabel('\eta_r');
legend('Port 1','Port 2');
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');

figure
plot(data.Freq/1e9,eta_a_t,'LineWidth',2);
hold on
plot(data.Freq/1e9,eta_b_t,'LineWidth',2);
grid on
xlabel('Freqency (GHz)')
ylabel('\eta_t');
legend('Port 1','Port 2');
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');