function plotZData(data)

Zf = transformToZ2Port(data.SCf);

figure

plot(data.Freq/1e9,squeeze(abs(mean(Zf(:,1,:),3))),'LineWidth',2);
hold on
plot(data.Freq/1e9,squeeze(abs(mean(Zf(:,4,:),3))),'LineWidth',2);
grid on
set(gca,'LineWidth',2)
set(gca,'FontSize',12)
set(gca,'FontWeight','bold')
xlabel('Frequency (GHz)')
ylabel('Magnitude (\Omega)')
legend('Z_{11}','Z_{22}')