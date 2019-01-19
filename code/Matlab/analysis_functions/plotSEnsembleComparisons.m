function plotSEnsembleComparisons(data, port)

figure
plot(data.Freq/1e9,squeeze(20*log10(abs(data.SCf(:,port,:)))))
hold on
plot(data.Freq/1e9,squeeze(20*log10(mean(abs(data.SCf(:,port,:)),3))),'k','LineWidth',2)

grid on
set(gca,'LineWidth',2)
set(gca,'FontSize',12)
set(gca,'FontWeight','bold')
xlabel('Frequency (GHz)')
ylabel('Log Magnitude (dB)')

if port == 1
    title ('S_{11}')
elseif port == 2
    title ('S_{12}')
elseif port == 3
    title ('S_{21}')
else
    title ('S_{22}')
end

figure
plot(data.time/1e-6,squeeze(20*log10(abs(data.SCt(:,port,:)))))
hold on
plot(data.time/1e-6,squeeze(20*log10(mean(abs(data.SCt(:,port,:)),3))),'k','LineWidth',2)

grid on
set(gca,'LineWidth',2)
set(gca,'FontSize',12)
set(gca,'FontWeight','bold')
xlabel('Time (\mu s)')
ylabel('Log Magnitude (dB)')

if port == 1
    title ('S_{11}')
elseif port == 2
    title ('S_{12}')
elseif port == 3
    title ('S_{21}')
else
    title ('S_{22}')
end
