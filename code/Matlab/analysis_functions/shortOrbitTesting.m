function shortOrbitTesting(data)
Lb = 2.5;
Lp = 0;
c = 2.99792458e8;
Q =3.2302e+04;
port = 1;

% Lb = [c/128e6 c/.9e6];


if port == 1
    portString = 11;
elseif port == 2
    portString = 12;
elseif port == 3
    portString = 21;
elseif port == 4
    portString = 22;
end

t0Ind = find( abs(data.time) == min(abs(data.time)));
St = squeeze(data.SCt(:,port,:));
St0 = max(mean(abs(St(data.time >= 0,:)),2));
%St0 = 1;
Zt = transformToZSinglePort(St);

Lb = [5.321 6.446 4.759 5.827 2.342 2.679];

nBounce = [1 1 1 1 1 1];

%get the scale factors
sf = zeros(size(Lb));
for count = 1:length(Lb)
    ind = find(abs(c*data.time - Lb(count)) == min(abs(c*data.time - Lb(count))));
    sf(count) = mean(abs(St(ind,:)),2)/St0;
end
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
Srad = applyTimeGating(Sf,data.Freq,9e-9);
Zrad = mean(transformToZSinglePort(Srad),2); 

%the idea is that Zavg = Zrad + Zso - need to investigate Zso
Zso = Zavg - Zrad;

%get the propagation coefficient
Beta = k*(1 + 1j/(2*Q));

rho = zeros(size(k));
chi = zeros(size(k));

for count = 1:length(Lb)
    %compute the phase and the contributions
    phase = Beta*(Lp + Lb(count)) + nBounce(count)*pi;
    
    %TBD - need to compute the orbit stability coefficient
    Db = 1;%/(Lb(count));
    
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

Ravg_p = real(Zrad) + real(Zrad).^(1/2).*rho.*real(Zrad).^(1/2);
Xavg_p = imag(Zrad) + real(Zrad).^(1/2).*chi.*real(Zrad).^(1/2);
Zavg_p = Ravg_p + 1j*Xavg_p;

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
