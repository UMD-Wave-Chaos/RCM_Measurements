Lb = 2.5;
Lp = 0;
c = 3e8;
Q =3.2302e+04;
port = 1;


f = mean(data.Freq);
omega = 2*pi*f;
k = omega/c;

Sf = squeeze(data.SCf(:,port,:));
Zf = mean(transformToZSinglePort(Sf),2);

Sfg = applyTimeGating(Sf,data.Freq,7e-9);
Zfg = mean(transformToZSinglePort(Sfg),2); 

Zso = Zf - Zfg;

Beta = k*(1 + 1j/(2*Q));

phase = Beta*(Lp + Lb) - pi/4;

rho = cos(phase);
chi = sin(phase);


Ra = real(Zfg) + real(Zfg).*rho;
Xa = imag(Zfg) + real(Zfg).*chi;

Za = Ra + 1j*Xa;

Rr = real(Za - Zfg);
Xr = imag(Za - Zfg);

figure
subplot(2,1,1)
plot(data.Freq/1e9,real(Zso),'LineWidth',2);
hold on
plot(data.Freq/1e9,Rr,'LineWidth',2);
grid on
xlabel('Frequency (GHz)')
ylabel('Real Part (ohms)')
legend('Measured','Calculated')

subplot(2,1,2)
plot(data.Freq/1e9,imag(Zso),'LineWidth',2);
hold on
plot(data.Freq/1e9,Xr,'LineWidth',2);
grid on
xlabel('Frequency (GHz)')
ylabel('Imaginary Part (ohms)')
legend('Measured','Calculated')

