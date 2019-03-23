function shortOrbitTesting(data,port)

% for the single port case, set the port phase to 0
Lp = 0; 
%need to include speed of light
c = 2.99792458e8;

%% Offline inputs
%*************************************************************************
%**************************************************************************
%need the Q factor that was determined offline
Q = 29547.648;% 32301.699;
%Lb and the bounce phases were determined offline
Lb = [4.759 5.321 5.827 6.446];% 7.345 8.919 9.312 10.1 10.61 10.89 11.84 12.01 12.35 12.97 13.13 15.95 16.28 16.96 17.63 18.19 18.59 19.49 21.4]% 867.7/2 911.1/2 929.9/2 983.8/2];
nBounce = [0 0 0 0 1 1 0 0 1 0 0 0 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0];
%**************************************************************************
%**************************************************************************
%%

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
Zt = transformToZSinglePort(St);

%get the scale factors
sf = zeros(size(Lb));
for count = 1:length(Lb)
    ind = abs(c*data.time - Lb(count)) == min(abs(c*data.time - Lb(count)));
    sf(count) = mean(abs(St(ind,:)),2)/St0;% (1/(Lb(count)))^(1/4);
end


% for cnt = length(Lb) - 3:length(Lb)
% sf(cnt) = 1/Lb(cnt)^(1/4);
% end

%scale factor in S domain is in voltage, we will need to apply the scale
%factor in the Z domain and need to convert to power by squaring it
sf = sf.^2;

omega = 2*pi*data.Freq;
k = omega/c;

%get the single port measured data
%Sf is the raw scattering measurements
Sf = squeeze(data.SCf(:,port,:));
%Zavg is the average raw impedance measurements
Zavg = mean(transformToZSinglePort(Sf),2);

Zf = transformToZSinglePort(Sf);
Zf = mean(abs(Zf),2);

%get the gated results for the radiation scattering coefficient and
%impedance 
Srad = applyTimeGating(Sf,data.Freq,10e-9);
Zrad = mean(transformToZSinglePort(Srad),2); 

% Zrad = mean(transformToZSinglePort(squeeze(data.SCfg(:,port,:))),2);

%the idea is that Zavg = Zrad + Zso - need to investigate Zso
Zso = Zavg - Zrad;
%get the propagation coefficient
Beta = k*(1 + 1j/(2*Q));

rho = zeros(size(k));
chi = zeros(size(k));

for count = 1:length(Lb)
    %compute the phase and the contributions
    phase = Beta*(Lp + Lb(count)) + nBounce(count)*pi;
    
    %compute the orbit stability coefficient
    %using the scale factor from the IFT includes the Db term as well as
    %the antenna gain as a function of angle and the probability of path
    %existance over the ensemble
    Db = 1;%/sqrt(Lb(count));
    
    rho_contribution = sf(count)*Db*cos(phase);
    chi_contribution = sf(count)*Db*sin(phase);
    
    %sum up the contributions
    rho = rho + rho_contribution;
    chi = chi + chi_contribution;
end
disp(count)

Zso_p_re = real(Zrad).^(1/2).*rho.*real(Zrad).^(1/2);
Zso_p_im = real(Zrad).^(1/2).*chi.*real(Zrad).^(1/2);

Zsi_p = Zso_p_re + 1j*Zso_p_im;

Rso = real(Zsi_p);
Xso = imag(Zsi_p);

Ravg_p = real(Zrad) + Zso_p_re;
Xavg_p = imag(Zrad) + Zso_p_im;
Zavg_p = Ravg_p + 1j*Xavg_p;

[Zsot,t] = ifftS(Zso,data.Freq(end) - data.Freq(1));

figure
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

figure
subplot(2,1,1)
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

subplot(2,1,2)
plot(c*data.time,angle(St));
hold on
plot(c*data.time,mean(angle(St),2),'k','LineWidth',2);
grid on
xlabel('Length (m)')
ylabel('Phase(IFT\{S\}) (rad)')
set(gca,'FontSize',12)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',2)
xlim([0 15])
tstring = sprintf('S_{%d}',portString);
title(tstring);



figure
plot(data.Freq/1e9,Zf,'LineWidth',2);
grid on
xlabel('Frequency (GHz)')
ylabel('|Z| (\Omega)')
set(gca,'FontSize',12)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',2)
tstring = sprintf('<|Z_{%d}|>',portString);
title(tstring);

figure
plot(data.Freq/1e9,20*log10(mean(abs(Sf),2)),'LineWidth',2);
grid on
xlabel('Frequency (GHz)')
ylabel('|S| (dB)')
set(gca,'FontSize',12)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',2)
tstring = sprintf('<|S_{%d}|>',portString);
title(tstring);


figure
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

figure
plot(data.Freq/1e9,abs(Zso),'LineWidth',2);
hold on
plot(data.Freq/1e9,abs(Rso + 1j*Xso)+2,'LineWidth',2);
grid on
xlabel('Frequency (GHz)')
ylabel('Real Part (ohms)')
legend('Measured','Calculated')
title('Magnitude of Short Orbit Contribution')

figure
subplot(2,1,1)
plot(data.Freq/1e9,real(Zso),'LineWidth',2);
hold on
plot(data.Freq/1e9,Rso,'LineWidth',2);
grid on
xlabel('Frequency (GHz)')
ylabel('Real Part (ohms)')
legend('Measured','Calculated')
title('Real Part of Short Orbit Contribution')

subplot(2,1,2)
plot(data.Freq/1e9,imag(Zso),'LineWidth',2);
hold on
plot(data.Freq/1e9,Xso,'LineWidth',2);
grid on
xlabel('Frequency (GHz)')
ylabel('Imaginary Part (ohms)')
legend('Measured','Calculated')
title('Imaginary Part of Short Orbit Contribution')

figure
plot(data.Freq/1e9,abs(Zavg),'LineWidth',2);
hold on
plot(data.Freq/1e9,abs(Zavg_p),'LineWidth',2);
grid on
xlabel('Frequency (GHz)')
ylabel('Real Part (ohms)')
legend('Measured','Calculated')
title('Magnitude of Z Average')

figure
subplot(2,1,1)
plot(data.Freq/1e9,real(Zavg),'LineWidth',2);
hold on
plot(data.Freq/1e9,real(Zavg_p),'LineWidth',2);
grid on
xlabel('Frequency (GHz)')
ylabel('Real Part (ohms)')
legend('Measured','Calculated')
title('Real Part of Z Average')

subplot(2,1,2)
plot(data.Freq/1e9,imag(Zavg),'LineWidth',2);
hold on
plot(data.Freq/1e9,imag(Zavg_p),'LineWidth',2);
grid on
xlabel('Frequency (GHz)')
ylabel('Imaginary Part (ohms)')
legend('Measured','Calculated')
title('Imaginary Part of Z Average')

figure
plot(c*t,abs(Zsot),'LineWidth',2);
grid on
xlabel('Length (m)')
ylabel('|IFT\{Z_{so}\}|')
set(gca,'FontSize',12)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',2)
xlim([0 25])

