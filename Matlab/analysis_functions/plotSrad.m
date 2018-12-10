function plotSrad(Freq,Srad,varargin)
%plotSrad(Freq,Srad)
%plotSrad(Freq,Srad,foldername)

%% check inputs
if nargin == 3
    foldername = varargin{1};
    savePlots = 1;
else
    savePlots = 0;
end

%% Srad - Real
hh1 = figure('Position',[10 100 800 800],'NumberTitle', 'off', 'Name', 'S-rad Real Component'); 
subplot(2,2,1)
plot(Freq/1E9,real(Srad(:,1)),'LineWidth',2);
ylabel('Value (V/V)');
xlabel('Frequency (GHz)');
title('Re\{S_{11}\}');
grid on
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');

subplot(2,2,2)

plot(Freq/1E9,real(Srad(:,2)),'LineWidth',2);
ylabel('Value (V/V)');
xlabel('Frequency (GHz)');
title('Re\{S_{12}\}');
grid on
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');

subplot(2,2,3)
plot(Freq/1E9,real(Srad(:,3)),'LineWidth',2);
ylabel('Value (V/V)');
xlabel('Frequency (GHz)');
title('Re\{S_{21}\}');
grid on
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');

subplot(2,2,4)
plot(Freq/1E9,real(Srad(:,4)),'LineWidth',2);
ylabel('Value (V/V)');
xlabel('Frequency (GHz)');
title('Re\{S_{22}\}');
grid on
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');

%% Srad - Real
hh2 = figure('Position',[10 100 800 800],'NumberTitle', 'off', 'Name', 'S-rad Imaginary Component'); 
subplot(2,2,1)
plot(Freq/1E9,imag(Srad(:,1)),'LineWidth',2);
ylabel('Value (V/V)');
xlabel('Frequency (GHz)');
title('Im\{S_{11}\}');
grid on
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');

subplot(2,2,2)

plot(Freq/1E9,imag(Srad(:,2)),'LineWidth',2);
ylabel('Value (V/V)');
xlabel('Frequency (GHz)');
title('Im\{S_{12}\}');
grid on
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');

subplot(2,2,3)
plot(Freq/1E9,imag(Srad(:,3)),'LineWidth',2);
ylabel('Value (V/V)');
xlabel('Frequency (GHz)');
title('Im\{S_{21}\}');
grid on
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');

subplot(2,2,4)
plot(Freq/1E9,imag(Srad(:,4)),'LineWidth',2);
ylabel('Value (V/V)');
xlabel('Frequency (GHz)');
title('Im\{S_{22}\}');
grid on
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');

%%
if (savePlots)

    saveas(hh1,fullfile(foldername,'Srad_real'),'png');
    saveas(hh2,fullfile(foldername,'Srad_imag'),'png');

    close (hh1)
    close(hh2)
end