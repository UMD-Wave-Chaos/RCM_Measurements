function compareLengthDomainSParameters(data1,data2,port)
c = 2.99792458e8;


if port == 1
    portString = 11;
elseif port == 2
    portString = 12;
elseif port == 3
    portString = 21;
elseif port == 4
    portString = 22;
end

St1 = squeeze(data1.SCt(:,port,:));
St10 = max(mean(abs(St1(data1.time >= 0,:)),2));

St2 = squeeze(data2.SCt(:,port,:));
St20 = max(mean(abs(St2(data2.time >= 0,:)),2));

St0 = max(St10,St20);

Zt1 = transformToZSinglePort(St1);
Zt2 = transformToZSinglePort(St2);


figure
plot(c*data1.time,mean(abs(St1),2)/St0,'LineWidth',2);
hold on
plot(c*data2.time,mean(abs(St2),2)/St0,'LineWidth',2);
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
plot(c*data1.time,mean(abs(Zt1),2),'LineWidth',2);
hold on
plot(c*data2.time,mean(abs(Zt2),2),'LineWidth',2);
grid on
xlabel('Length (m)')
ylabel('|IFT\{Z\}|')
set(gca,'FontSize',12)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',2)
xlim([0 15])
tstring = sprintf('Z_{%d}',portString);
title(tstring);
