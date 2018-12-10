function plotScavEnsembles(t,Freq,SCt,SCf,varargin)
%plotScavEnsembles(t,Freq,SCt,SCf) 
%plotScavEnsembles(t,Freq,SCt,SCf,foldername) 

%% check inputs
if nargin == 5
    foldername = varargin{1};
    savePlots = 1;
else
    savePlots = 0;
end


N = size(SCf,2);
NOP = size(SCf,1);
meanSCt = zeros(NOP,N);
meanSCf = zeros(NOP,N);

for i = 1:N
    meanSCt = meanSCt + abs(SCt(:,:,i))/N;
    meanSCf = meanSCf + abs(SCf(:,:,i))/N;
end


%% plot
hh1 = figure('Position',[10 100 800 800]); 
subplot(2,2,1)
plot(t/1E-6,20*log10(abs(SCt(:,1,1))),'.-g', 'MarkerSize', 20)
hold on
plot(t*10^6,20*log10(abs(mean(SCt(:,1,:),3))),'r')
plot(t/1E-6,20*log10(meanSCt(:,1)),'k','LineWidth',2);
ylabel('Value (dB)');
xlabel('Time (\mus)');
title('|S_{11}|');
grid on
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');
legend('Single Realization', 'Mag. of Ensemble Avg','Ensemble Avg of Mag');

subplot(2,2,2)
plot(t/1E-6,20*log10(abs(SCt(:,2,1))),'.-g', 'MarkerSize', 20)
hold on
plot(t*10^6,20*log10(abs(mean(SCt(:,2,:),3))),'r')
plot(t/1E-6,20*log10(meanSCt(:,2)),'k','LineWidth',2);
ylabel('Value (dB)');
xlabel('Time (\mus)');
title('|S_{12}|');
grid on
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');
legend('Single Realization', 'Mag. of Ensemble Avg','Ensemble Avg of Mag');

subplot(2,2,3)
plot(t/1E-6,20*log10(abs(SCt(:,3,1))),'.-g', 'MarkerSize', 20)
hold on
plot(t*10^6,20*log10(abs(mean(SCt(:,3,:),3))),'r')
plot(t/1E-6,20*log10(meanSCt(:,3)),'k','LineWidth',2);
ylabel('Value (dB)');
xlabel('Time (\mus)');
title('|S_{21}|');
grid on
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');
legend('Single Realization', 'Mag. of Ensemble Avg','Ensemble Avg of Mag');

subplot(2,2,4)
plot(t/1E-6,20*log10(abs(SCt(:,4,1))),'.-g', 'MarkerSize', 20)
hold on
plot(t*10^6,20*log10(abs(mean(SCt(:,4,:),3))),'r')
plot(t/1E-6,20*log10(meanSCt(:,4)),'k','LineWidth',2);
ylabel('Value (dB)');
xlabel('Time (\mus)');
title('|S_{22}|');
grid on
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');
legend('Single Realization', 'Mag. of Ensemble Avg','Ensemble Avg of Mag');

hh2 = figure('Position',[10 100 800 800]);  
subplot(2,2,1)
plot(Freq/1E9,20*log10(abs(SCf(:,1,1))),'.g', 'MarkerSize', 12)
hold on;
plot(Freq/1E9,20*log10(abs(mean(SCf(:,1,:),3))),'r')
plot(Freq/1E9,20*log10(meanSCf(:,1)),'k','LineWidth',2);
xlabel('Frequency (GHz)'); 
ylabel('Value (dB)');
ylabel('|S_{11}| ');
grid on
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');
legend('Single Realization', 'Mag. of Ensemble Avg','Ensemble Avg of Mag');

subplot(2,2,2)
plot(Freq/1E9,20*log10(abs(SCf(:,2,1))),'.g', 'MarkerSize', 12)
hold on;
plot(Freq/1E9,20*log10(abs(mean(SCf(:,2,:),3))),'r')
plot(Freq/1E9,20*log10(meanSCf(:,2)),'k','LineWidth',2);
xlabel('Frequency (GHz)'); 
ylabel('Value (dB)');
ylabel('|S_{12}| ');
grid on
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');
legend('Single Realization', 'Mag. of Ensemble Avg','Ensemble Avg of Mag');

subplot(2,2,3)
plot(Freq/1E9,20*log10(abs(SCf(:,3,1))),'.g', 'MarkerSize', 12)
hold on;
plot(Freq/1E9,20*log10(abs(mean(SCf(:,3,:),3))),'r')
plot(Freq/1E9,20*log10(meanSCf(:,3)),'k','LineWidth',2);
xlabel('Frequency (GHz)'); 
ylabel('Value (dB)');
ylabel('|S_{21}| ');
grid on
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');
legend('Single Realization', 'Mag. of Ensemble Avg','Ensemble Avg of Mag');

subplot(2,2,4)
plot(Freq/1E9,20*log10(abs(SCf(:,4,1))),'.g', 'MarkerSize', 12)
hold on;
plot(Freq/1E9,20*log10(abs(mean(SCf(:,4,:),3))),'r')
plot(Freq/1E9,20*log10(meanSCf(:,4)),'k','LineWidth',2);
xlabel('Frequency (GHz)'); 
ylabel('Value (dB)');
ylabel('|S_{22}| ');
grid on
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');
legend('Single Realization', 'Mag. of Ensemble Avg','Ensemble Avg of Mag');

if savePlots
    saveas(hh1,fullfile(foldername,'Scav_time_ensembles'),'png');
    saveas(hh2,fullfile(foldername,'Scav_freq_ensembles'),'png');

    close(hh1)
    close(hh2)
end