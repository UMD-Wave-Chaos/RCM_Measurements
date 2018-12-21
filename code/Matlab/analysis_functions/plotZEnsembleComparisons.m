
function plotZEnsembleComparisons(Freq,Z,Zgm, Zgc,index)

figure
plot(Freq/1e9,squeeze(20*log10(abs(Z(:,index,:)))))
hold on
plot(Freq/1e9,squeeze(20*log10(abs(mean(Zgm(:,index,:),3)))),'k','LineWidth',2)
plot(Freq/1e9,20*log10(abs(Zgc)),'g','LineWidth',2)
grid on
set(gca,'LineWidth',2)
set(gca,'FontSize',12)
set(gca,'FontWeight','bold')
xlabel('Frequency (GHz)')
ylabel('Log Magnitude (dB)')

if index == 1
    title ('Z_{11}')
elseif index == 2
    title ('Z_{12}')
elseif index == 2
    title ('Z_{21}')
else
    title ('Z_{22}')
end
