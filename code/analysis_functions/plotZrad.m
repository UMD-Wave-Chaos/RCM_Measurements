function plotZrad(Freq,Zrad,varargin)
%plotZrad(Freq,Zrad)
%plotZrad(Freq,Zrad,foldername)

%% check inputs
if nargin == 3
    foldername = varargin{1};
    savePlots = 1;
else
    savePlots = 0;
end

%% Zrad - Real
hh1 = figure('Position',[10 100 800 800],'NumberTitle', 'off', 'Name', 'Z-rad Real Component'); 
subplot(2,2,1)
plot(Freq/1E9,real(Zrad(:,1)),'LineWidth',2);
ylabel('Value (V/V)');
xlabel('Frequency (GHz)');
title('Re\{Z_{11}\}');
grid on
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');

subplot(2,2,2)

plot(Freq/1E9,real(Zrad(:,2)),'LineWidth',2);
ylabel('Value (V/V)');
xlabel('Frequency (GHz)');
title('Re\{Z_{12}\}');
grid on
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');

subplot(2,2,3)
plot(Freq/1E9,real(Zrad(:,3)),'LineWidth',2);
ylabel('Value (V/V)');
xlabel('Frequency (GHz)');
title('Re\{Z_{21}\}');
grid on
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');

subplot(2,2,4)
plot(Freq/1E9,real(Zrad(:,4)),'LineWidth',2);
ylabel('Value (V/V)');
xlabel('Frequency (GHz)');
title('Re\{Z_{22}\}');
grid on
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');

%% Srad - Real
hh2 = figure('Position',[10 100 800 800],'NumberTitle', 'off', 'Name', 'Z-rad Imaginary Component'); 
subplot(2,2,1)
plot(Freq/1E9,imag(Zrad(:,1)),'LineWidth',2);
ylabel('Value (V/V)');
xlabel('Frequency (GHz)');
title('Im\{Z_{11}\}');
grid on
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');

subplot(2,2,2)

plot(Freq/1E9,imag(Zrad(:,2)),'LineWidth',2);
ylabel('Value (V/V)');
xlabel('Frequency (GHz)');
title('Im\{Z_{12}\}');
grid on
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');

subplot(2,2,3)
plot(Freq/1E9,imag(Zrad(:,3)),'LineWidth',2);
ylabel('Value (V/V)');
xlabel('Frequency (GHz)');
title('Im\{Z_{21}\}');
grid on
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');

subplot(2,2,4)
plot(Freq/1E9,imag(Zrad(:,4)),'LineWidth',2);
ylabel('Value (V/V)');
xlabel('Frequency (GHz)');
title('Im\{Z_{22}\}');
grid on
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');

%%
if (savePlots)

    saveas(hh1,fullfile(foldername,'Zrad_real'),'png');
    saveas(hh2,fullfile(foldername,'Zrad_imag'),'png');

    close (hh1)
    close(hh2)
end