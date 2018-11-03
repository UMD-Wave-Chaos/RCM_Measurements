function plotSParameters2(t,Freq,SCf,SCt,Srad,foldername,varargin)

savePlots = 1;
if nargin == 8
    savePlots = varargin{1};
end
N = size(SCf,2);
NOP = size(SCf,1);
meanSCt = zeros(NOP,N);
meanSCf = zeros(NOP,N);

for i = 1:N
    meanSCt = meanSCt + abs(SCt(:,:,i))/N;
    meanSCf = meanSCf + abs(SCf(:,:,i))/N;
end

%% SCav - frequency
hh1 = figure('Position',[10 100 800 800],'NumberTitle', 'off', 'Name', 'S-cav Frequency Domain Response'); 
subplot(2,2,1)
plot(Freq/1E9,20*log10(abs(SCf(:,1,end))),'LineWidth',2);
hold on
plot(Freq/1E9,20*log10(mean(abs(SCf(:,1,:)),3)),'r');
plot(Freq/1E9,20*log10(abs(Srad(:,1))),'--m','LineWidth',2);
ylabel('Value (dB)');
xlabel('Frequency (GHz)');
title('|S_{11}|');
grid on
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');
legend('|S|','<|S|>','Srad')

subplot(2,2,2)
plot(Freq/1E9,20*log10(abs(SCf(:,2,end))),'LineWidth',2);
hold on
plot(Freq/1E9,20*log10(mean(abs(SCf(:,2,:)),3)),'r');
plot(Freq/1E9,20*log10(abs(Srad(:,2))),'--m','LineWidth',2);
ylabel('Value (dB)');
xlabel('Frequency (GHz)');
title('|S_{12}|');
grid on
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');
legend('|S|','<|S|>','Srad')

subplot(2,2,3)
plot(Freq/1E9,20*log10(abs(SCf(:,3,end))),'LineWidth',2);
hold on
plot(Freq/1E9,20*log10(mean(abs(SCf(:,3,:)),3)),'r');
plot(Freq/1E9,20*log10(abs(Srad(:,3))),'--m','LineWidth',2);
ylabel('Value (dB)');
xlabel('Frequency (GHz)');
title('|S_{21}|');
grid on
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');
legend('|S|','<|S|>','Srad')

subplot(2,2,4)
plot(Freq/1E9,20*log10(abs(SCf(:,4,end))),'LineWidth',2);
hold on
plot(Freq/1E9,20*log10(mean(abs(SCf(:,4,:)),3)),'r');
plot(Freq/1E9,20*log10(abs(Srad(:,4))),'--m','LineWidth',2);
ylabel('Value (dB)');
xlabel('Frequency (GHz)');
title('|S_{22}|');
grid on
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');
legend('|S|','<|S|>','Srad')

%% SCav - time
hh2 = figure('Position',[10 100 800 800],'NumberTitle', 'off', 'Name', 'S-cav Time Domain Response'); 
subplot(2,2,1)
plot(t/1E-6,20*log10(abs(SCt(:,1,end))),'LineWidth',2);
hold on
plot(t/1E-6,20*log10(mean(abs(SCt(:,1,:)),3)),'r');
ylabel('Value (dB)');
xlabel('Time (\mus)');
title('|S_{11}|');
grid on
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');

subplot(2,2,2)
plot(t/1E-6,20*log10(abs(SCt(:,2,end))),'LineWidth',2);
hold on
plot(t/1E-6,20*log10(mean(abs(SCt(:,2,:)),3)),'r');
ylabel('Value (dB)');
xlabel('Time (\mus)');
title('|S_{12}|');
grid on
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');

subplot(2,2,3)
plot(t/1E-6,20*log10(abs(SCt(:,3,end))),'LineWidth',2);
hold on
plot(t/1E-6,20*log10(mean(abs(SCt(:,3,:)),3)),'r');
ylabel('Value (dB)');
xlabel('Time (\mus)');
title('|S_{21}|');
grid on
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');

subplot(2,2,4)
plot(t/1E-6,20*log10(abs(SCt(:,4,end))),'LineWidth',2);
hold on
plot(t/1E-6,20*log10(mean(abs(SCt(:,4,:)),3)),'r');
ylabel('Value (dB)');
xlabel('Time (\mus)');
title('|S_{22}|');
grid on
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');

%% Srad - frequency
hh3 = figure('Position',[10 100 800 800],'NumberTitle', 'off', 'Name', 'S-rad Frequency Domain Response'); 
subplot(2,2,1)
plot(Freq/1E9,20*log10(abs(Srad(:,1))),'LineWidth',2);
ylabel('Value (dB)');
xlabel('Frequency (GHz)');
title('|S_{11}|');
grid on
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');

subplot(2,2,2)

plot(Freq/1E9,20*log10(abs(Srad(:,2))),'LineWidth',2);
ylabel('Value (dB)');
xlabel('Frequency (GHz)');
title('|S_{12}|');
grid on
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');

subplot(2,2,3)
plot(Freq/1E9,20*log10(abs(Srad(:,3))),'LineWidth',2);
ylabel('Value (dB)');
xlabel('Frequency (GHz)');
title('|S_{21}|');
grid on
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');

subplot(2,2,4)
plot(Freq/1E9,20*log10(abs(Srad(:,4))),'LineWidth',2);
ylabel('Value (dB)');
xlabel('Frequency (GHz)');
title('|S_{22}|');
grid on
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');

if (savePlots)

    saveas(hh1,fullfile(foldername,'Scav_freq_parameters'),'png');
    saveas(hh2,fullfile(foldername,'Scav_time_parameters'),'png');
    saveas(hh3,fullfile(foldername,'Srad_freq_parameters'),'png');

    close (hh1)
    close(hh2)
    close (hh3)
end