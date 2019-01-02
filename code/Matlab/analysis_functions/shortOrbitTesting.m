Lb = 2.5;
Lp = 0;
c = 3e8;
Q =3.2302e+04;
port = 1;


Lb = [2.48 2.99 3.49];
nBounce = [1 2 3];

omega = 2*pi*data.Freq;
k = omega/c;

%get the single port measured data
%Sf is the raw scattering measurements
Sf = squeeze(data.SCf(:,port,:));
%Zavg is the average raw impedance measurements
Zavg = mean(transformToZSinglePort(Sf),2);

%get the gated results for the radiation scattering coefficient and
%impedance 
Srad = applyTimeGating(Sf,data.Freq,7e-9);
Zrad = mean(transformToZSinglePort(Srad),2); 

%the idea is that Zavg = Zrad + Zso - need to investigate Zso
Zso = Zavg - Zrad;

%get the propagation coefficient
Beta = k*(1 + 1j/(2*Q));

rho = zeros(size(k));
chi = zeros(size(k));

for count = 1:length(Lb)
    %compute the phase and the contributions
    phase = Beta*(Lp + Lb(count)) - pi/4 + nBounce(count)*pi;
    
    %TBD - need to compute the orbit stability coefficient
    Db = 1/(50*length(Lb));
    
    rho_contribution = sqrt(Db)*cos(phase);
    chi_contribution = sqrt(Db)*sin(phase);
    
    %sum up the contributions
    rho = rho + rho_contribution;
    chi = chi + chi_contribution;
end

Zso_p_re = real(Zrad).^(1/2).*rho.*real(Zrad).^(1/2);
Zso_p_im = real(Zrad).^(1/2).*chi.*real(Zrad).^(1/2);

Zsi_p = Zso_p_re + 1j*Zso_p_im;

Rso = real(Zsi_p);
Xso = imag(Zsi_p);

Ravg_p = real(Zrad) + real(Zrad).^(1/2).*rho.*real(Zrad).^(1/2);
Xavg_p = imag(Zrad) + real(Zrad).^(1/2).*chi.*real(Zrad).^(1/2);
Zavg_p = Ravg_p + 1j*Xavg_p;


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
