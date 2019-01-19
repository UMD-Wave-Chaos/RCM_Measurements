c = 2.99792458e8;
port = 1;

omega = 2*pi*data.Freq;
k = omega/c;
dk = (k(end)-k(1))/length(k);
L = 2*pi/dk;

%get the single port measured data
%Sf is the raw scattering measurements
Sf = squeeze(data.SCf(:,port,:));

[Sct, t] = getTimeDomainSParameters(data.SCf,data.Freq);

St = squeeze(Sct(:,port,:));
Zt = abs(mean(transformToZSinglePort(St),2));



%Zavg is the average raw impedance measurements
Zavg = mean(transformToZSinglePort(Sf),2);

Zlabs = c*abs(ifft(Zavg)*length(Zavg));
L = (0:length(data.Freq)-1)*L/length(data.Freq);

figure
plot(L,Zlabs,'LineWidth',2);
grid on
xlabel('Length (m)')
ylabel('\epsilon(L)')
set(gca,'LineWidth',2)
set(gca,'FontSize',12)
set(gca,'FontWeight','bold')


figure
plot(t*c,Zt,'LineWidth',2);
grid on
xlabel('Length (m)')
ylabel('\epsilon(L)')
set(gca,'LineWidth',2)
set(gca,'FontSize',12)
set(gca,'FontWeight','bold')