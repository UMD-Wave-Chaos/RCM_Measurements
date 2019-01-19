function plotStirredUnstirred(data,port)

[~,Sus,Ss] = getKFactor(data.SCf,port);

figure
plot(data.Freq/1e9,10*log10(Sus),'LineWidth',2);
hold on
plot(data.Freq/1e9,10*log10(Ss),'LineWidth',2);
grid on
legend('Unstirred','Stirred')
set(gca,'LineWidth',2)
set(gca,'FontSize',12)
set(gca,'FontWeight','bold')
xlabel('Frequency (GHz)')
ylabel('Log Magnitude (dB)')
