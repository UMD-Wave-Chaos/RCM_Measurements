
function plotZEnsembleComparisons(data, port, gateTime1, gateTime2)

Zf = transformToZ2Port(data.SCf);

Zm = mean(Zf,3);

Sf1 = zeros(size(Zf));
Sf2 = zeros(size(Zf));
for count = 1:4
    [Sf1(:,count,:),~] = applyTimeGating(data.SCf(:,count,:),data.Freq,gateTime1,0,0.5);
    [Sf2(:,count,:),~] = applyTimeGating(data.SCf(:,count,:),data.Freq,gateTime2,0,0.5);
end
%transform to Z
Zfg1 = transformToZ2Port(Sf1);
Zgm1 = mean(Zfg1,3);

Zfg2 = transformToZ2Port(Sf2);
Zgm2 = mean(Zfg2,3);

figure
plot(data.Freq/1e9,squeeze(abs(Zf(:,port,:))))
hold on
plot(data.Freq/1e9,squeeze(abs(mean(Zm(:,port,:),3))),'k','LineWidth',2)
plot(data.Freq/1e9,squeeze(abs(mean(Zgm2(:,port,:),3))),'m','LineWidth',2)
plot(data.Freq/1e9,squeeze(abs(mean(Zgm1(:,port,:),3))),'g','LineWidth',2)

grid on
set(gca,'LineWidth',2)
set(gca,'FontSize',12)
set(gca,'FontWeight','bold')
xlabel('Frequency (GHz)')
ylabel('Magnitude (\Omega)')

if port == 1
    title ('Z_{11}')
elseif port == 2
    title ('Z_{12}')
elseif port == 3
    title ('Z_{21}')
else
    title ('Z_{22}')
end
