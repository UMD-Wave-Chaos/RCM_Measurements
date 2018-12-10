function plotSParametersRealImag(t,Freq,SCf,SCt,Srad,foldername,varargin)

savePlots = 1;
if nargin == 7
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
hh1 = figure('Position',[10 100 800 800],'NumberTitle', 'off', 'Name', 'S-cav Frequency Domain Response Real'); 
subplot(2,2,1)
plot(Freq/1E9,real(SCf(:,1,end)),'LineWidth',2);
hold on
plot(Freq/1E9,mean(real(SCf(:,1,:)),3),'r');
ylabel('Value (dB)');
xlabel('Frequency (GHz)');
title('RE\{S_{11}\}');
grid on
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');

subplot(2,2,2)
plot(Freq/1E9,real(SCf(:,2,end)),'LineWidth',2);
hold on
plot(Freq/1E9,mean(real(SCf(:,2,:)),3),'r');
ylabel('Value (dB)');
xlabel('Frequency (GHz)');
title('RE\{S_{12}\}');
grid on
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');

subplot(2,2,3)
plot(Freq/1E9,real(SCf(:,3,end)),'LineWidth',2);
hold on
plot(Freq/1E9,mean(real(SCf(:,3,:)),3),'r');
ylabel('Value (dB)');
xlabel('Frequency (GHz)');
title('RE\{S_{21}\}');
grid on
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');

subplot(2,2,4)
plot(Freq/1E9,real(SCf(:,4,end)),'LineWidth',2);
hold on
plot(Freq/1E9,mean(real(SCf(:,3,:)),3),'r');
ylabel('Value (dB)');
xlabel('Frequency (GHz)');
title('RE\{S_{22}\}');
grid on
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');

%% SCav - time
hh2 = figure('Position',[10 100 800 800],'NumberTitle', 'off', 'Name', 'S-cav Time Domain Response Real'); 
subplot(2,2,1)
plot(t/1E-6,real(SCt(:,1,end)),'LineWidth',2);
ylabel('Value (dB)');
xlabel('Time (\mus)');
title('RE\{S_{11}\}');
grid on
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');

subplot(2,2,2)
plot(t/1E-6,real(SCt(:,2,end)),'LineWidth',2);
ylabel('Value (dB)');
xlabel('Time (\mus)');
title('RE\{S_{12}\}');
grid on
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');

subplot(2,2,3)
plot(t/1E-6,real(SCt(:,3,end)),'LineWidth',2);
ylabel('Value (dB)');
xlabel('Time (\mus)');
title('RE\{S_{21}\}');
grid on
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');

subplot(2,2,4)
plot(t/1E-6,real(SCt(:,4,end)),'LineWidth',2);
ylabel('Value (dB)');
xlabel('Time (\mus)');
title('RE\{S_{22}\}');
grid on
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');

%% Srad - frequency
hh3 = figure('Position',[10 100 800 800],'NumberTitle', 'off', 'Name', 'S-rad Frequency Domain Response Real'); 
subplot(2,2,1)
plot(Freq/1E9,real(Srad(:,2,end)),'LineWidth',2);
hold on
plot(Freq/1E9,real(mean(SCf(:,3,:),3)),'r');
ylabel('Value (dB)');
xlabel('Frequency (GHz)');
title('RE\{S_{11}\}');
grid on
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');

subplot(2,2,2)
plot(Freq/1E9,real(Srad(:,2,end)),'LineWidth',2);
ylabel('Value (dB)');
xlabel('Frequency (GHz)');
title('RE\{S_{12}\}');
grid on
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');

subplot(2,2,3)
plot(Freq/1E9,real(Srad(:,3,end)),'LineWidth',2);
ylabel('Value (dB)');
xlabel('Frequency (GHz)');
title('RE\{S_{21}\}');;
grid on
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');

subplot(2,2,4)
plot(Freq/1E9,real(Srad(:,4,end)),'LineWidth',2);
ylabel('Value (dB)');
xlabel('Frequency (GHz)');
title('RE\{S_{22}\}');
grid on
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');

%% SCav - frequency imag
hh4 = figure('Position',[10 100 800 800],'NumberTitle', 'off', 'Name', 'S-cav Frequency Domain Response Imag'); 
subplot(2,2,1)
plot(Freq/1E9,imag(SCf(:,1,end)),'LineWidth',2);
hold on
plot(Freq/1E9,mean(imag(SCf(:,1,:)),3),'r');
ylabel('Value (dB)');
xlabel('Frequency (GHz)');
title('IM\{S_{11}\}');
grid on
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');

subplot(2,2,2)
plot(Freq/1E9,imag(SCf(:,2,end)),'LineWidth',2);
hold on
plot(Freq/1E9,mean(imag(SCf(:,2,:)),3),'r');
ylabel('Value (dB)');
xlabel('Frequency (GHz)');
title('IM\{S_{12}\}');
grid on
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');

subplot(2,2,3)
plot(Freq/1E9,imag(SCf(:,3,end)),'LineWidth',2);
hold on
plot(Freq/1E9,mean(imag(SCf(:,3,:)),3),'r');
ylabel('Value (dB)');
xlabel('Frequency (GHz)');
title('IM\{S_{21}\}');
grid on
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');

subplot(2,2,4)
plot(Freq/1E9,imag(SCf(:,4,end)),'LineWidth',2);
hold on
plot(Freq/1E9,mean(imag(SCf(:,4,:)),3),'r');
ylabel('Value (dB)');
xlabel('Frequency (GHz)');
title('IM\{S_{22}\}');
grid on
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');

%% SCav - time
hh4 = figure('Position',[10 100 800 800],'NumberTitle', 'off', 'Name', 'S-cav Time Domain Response Imag'); 
subplot(2,2,1)
plot(t/1E-6,imag(SCt(:,1,end)),'LineWidth',2);
ylabel('Value (dB)');
xlabel('Time (\mus)');
title('IM\{S_{11}\}');
grid on
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');

subplot(2,2,2)
plot(t/1E-6,imag(SCt(:,2,end)),'LineWidth',2);
ylabel('Value (dB)');
xlabel('Time (\mus)');
title('IM\{S_{12}\}');
grid on
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');

subplot(2,2,3)
plot(t/1E-6,imag(SCt(:,3,end)),'LineWidth',2);
ylabel('Value (dB)');
xlabel('Time (\mus)');
title('IM\{S_{21}\}');
grid on
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');

subplot(2,2,4)
plot(t/1E-6,imag(SCt(:,4,end)),'LineWidth',2);
ylabel('Value (dB)');
xlabel('Time (\mus)');
title('IM\{S_{22}\}');
grid on
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');

%% Srad - frequency
hh5 = figure('Position',[10 100 800 800],'NumberTitle', 'off', 'Name', 'S-rad Frequency Domain Response Imag'); 
subplot(2,2,1)
plot(Freq/1E9,imag(Srad(:,2,end)),'LineWidth',2);
ylabel('Value (dB)');
xlabel('Frequency (GHz)');
title('IM\{S_{11}\}');
grid on
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');

subplot(2,2,2)
plot(Freq/1E9,imag(Srad(:,2,end)),'LineWidth',2);
ylabel('Value (dB)');
xlabel('Frequency (GHz)');
title('IM\{S_{12}\}');
grid on
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');

subplot(2,2,3)
plot(Freq/1E9,imag(Srad(:,3,end)),'LineWidth',2);
ylabel('Value (dB)');
xlabel('Frequency (GHz)');
title('IM\{S_{21}\}');
grid on
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');

subplot(2,2,4)
plot(Freq/1E9,imag(Srad(:,4,end)),'LineWidth',2);
ylabel('Value (dB)');
xlabel('Frequency (GHz)');
title('IM\{S_{22}\}');
grid on
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');

if (savePlots)

    saveas(hh1,fullfile(foldername,'Scav_freq_parameters_real'),'png');
    saveas(hh2,fullfile(foldername,'Scav_time_parameters_real'),'png');
    saveas(hh3,fullfile(foldername,'Srad_freq_parameters_real'),'png');
    saveas(hh4,fullfile(foldername,'Scav_freq_parameters_imag'),'png');
    saveas(hh5,fullfile(foldername,'Scav_time_parameters_imag'),'png');
    saveas(hh6,fullfile(foldername,'Srad_freq_parameters_imag'),'png');

    close (hh1)
    close (hh2)
    close (hh3)
    close (hh4)
    close (hh5)
    close (hh6)
end