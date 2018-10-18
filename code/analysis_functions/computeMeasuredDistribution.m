function [Zhist_EXP,Zbin_EXP,Zphist_EXP,Zpbin_EXP] = computeMeasuredDistribution(Znormf,foldername,varargin)   

if (nargin == 3)
    useGUI = true;
    handles = varargin{1};
else
    useGUI = false;
end

BINS = 1000;

num_ports = 2;
N = size(Znormf,3);

lstring = sprintf('Generating Measured Distribution');
if (useGUI == true)
    logMessage(handles.jEditbox,lstring);
else
    disp(lstring)
end
    
tic;
EZnormf = Znormf(:,:,1);
for i = 2:N
    EZnormf = cat(1,EZnormf,Znormf(:,:,i));
    time = toc; 
        lstring = sprintf('Generating Measured Distribution %d of %d, time = %s s',i,N,num2str(time));
    if (useGUI == true)
        logMessage(handles.jEditbox,lstring);
    else
        disp(lstring)
    end
end
for i = 1:num_ports^2
    [Zhist_EXP(:,i), Zbin_EXP(:,i)] = hist(abs(EZnormf(:,i)), 0.1*BINS); 
end                         % input paramters: the data (normalized impedance), and the number of bins
for i = 1:num_ports^2
    [Zphist_EXP(:,i), Zpbin_EXP(:,i)] = hist(angle(EZnormf(:,i)), 0.1*BINS);
end

%% plot the results

for i = 1:4
    Zpmf_EXP(:,i) = Zhist_EXP(:,i)./((Zbin_EXP(2,i)-Zbin_EXP(1,i))*sum(Zhist_EXP(:,i)));% Create a pmf from histogram for measurement of the normalized impedance
    Zppmf_EXP(:,i) = Zphist_EXP(:,i)./((Zpbin_EXP(2,i)-Zpbin_EXP(1,i))*sum(Zphist_EXP(:,i))); % Create a pmf from histogram for measurement of the normalized impedance
end

hh1 = figure('Position',[10 100 800 800],'NumberTitle', 'off', 'Name', 'Normalized Magnitude PMF');
subplot(2,2,1)
plot(Zbin_EXP(:,1),Zpmf_EXP(:,1),'*-k','MarkerSize',5);
ylabel('Probability Density Function');
title('PDF of |Z_{11}|');
grid on
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');

subplot(2,2,2)
plot(Zbin_EXP(:,2),Zpmf_EXP(:,2),'*-k','MarkerSize',5);
ylabel('Probability Density Function');
title('PDF of |Z_{12}|');
grid on
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');

 subplot(2,2,3)
plot(Zbin_EXP(:,3),Zpmf_EXP(:,3),'*-k','MarkerSize',5);
ylabel('Probability Density Function');
title('PDF of |Z_{21}|');
grid on
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');
 
subplot(2,2,4)
plot(Zbin_EXP(:,4),Zpmf_EXP(:,4),'*-k','MarkerSize',5);
ylabel('Probability Density Function');
title('PDF of |Z_{22}|');
grid on
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');

%
hh2 = figure('Position',[10 100 800 800],'NumberTitle', 'off', 'Name', 'Normalized Phase PMF');
subplot(2,2,1)
plot(Zpbin_EXP(:,1),Zppmf_EXP(:,1),'*-k','MarkerSize',5);
ylabel('Probability Density Function');
title('PDF of \angleZ_{11}');
grid on
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');

subplot(2,2,2)
plot(Zpbin_EXP(:,2),Zppmf_EXP(:,2),'*-k','MarkerSize',5);
ylabel('Probability Density Function');
title('PDF of \angle Z_{12}');
grid on
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');

subplot(2,2,3)
plot(Zpbin_EXP(:,3),Zppmf_EXP(:,3),'*-k','MarkerSize',5);
ylabel('Probability Density Function');
title('PDF of \angle Z_{21}');
grid on
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');
 
subplot(2,2,4)
plot(Zpbin_EXP(:,4),Zppmf_EXP(:,4),'*-k','MarkerSize',5);
ylabel('Probability Density Function');
title('PDF of \angle Z_{22}');
grid on
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');

saveas(hh1,fullfile(foldername,'Measured_mag_pdf'),'png');
saveas(hh2,fullfile(foldername,'Measured_phase_pdf'),'png');