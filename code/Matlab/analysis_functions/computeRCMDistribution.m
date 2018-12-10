function [Zhist_RCM,Zbin_RCM, Zphist_RCM,Zpbin_RCM] =  computeRCMDistribution(alpha,nRCM,foldername,varargin)

if (nargin == 4)
    useGUI = true;
    handles = varargin{1};
else
    useGUI = false;
end

BINS = 1000;
num_ports = 2;

lstring = sprintf('Generating RCM Distribution');
if (useGUI == true)
    logMessage(handles.jEditbox,lstring);
else
    disp(lstring)
end

tic;
for i = 1:num_ports^2
    if (useGUI == true)
        [Znorm_RCM] =  genPMFrcm(alpha(i),num_ports, nRCM,handles);           % input parameters: loss parameter, number of bins, number of ports, number of samples
    else
        [Znorm_RCM] =  genPMFrcm(alpha(i),num_ports, nRCM);  
    end
    [Zhist_RCM(:,i), Zbin_RCM(:,i)] = hist(abs(Znorm_RCM(:,i)), 0.1*BINS);
    [Zphist_RCM(:,i), Zpbin_RCM(:,i)] = hist(angle(Znorm_RCM(:,i)), 0.1*BINS);
	time = toc; 
	
	averagetime = time/i;
	predictedTime = averagetime*(num_ports^2-i);
    lstring = sprintf('Computing RCM distribution %d of %d, time = %s s, predicted remaining time = %s s',i,num_ports^2,num2str(time), num2str(predictedTime));
    if (useGUI == true)
        logMessage(handles.jEditbox,lstring);
    else
        disp(lstring)
    end
end

%% plot the results

for i = 1:4
    Zpmf_RCM(:,i) = Zhist_RCM(:,i)./((Zbin_RCM(2,i)-Zbin_RCM(1,i))*sum(Zhist_RCM(:,i)));% Create a pmf from histogram for measurement of the normalized impedance
    Zppmf_RCM(:,i) = Zphist_RCM(:,i)./((Zpbin_RCM(2,i)-Zpbin_RCM(1,i))*sum(Zphist_RCM(:,i))); % Create a pmf from histogram for measurement of the normalized impedance
end

hh1 = figure('Position',[10 100 800 800],'NumberTitle', 'off', 'Name', 'Normalized Magnitude PMF from RCM');
subplot(2,2,1)
plot(Zbin_RCM(:,1),Zpmf_RCM(:,1),'*-k','MarkerSize',5);
ylabel('Probability Density Function');
title('PDF of |Z_{11}|');
grid on
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');

subplot(2,2,2)
plot(Zbin_RCM(:,2),Zpmf_RCM(:,2),'*-k','MarkerSize',5);
ylabel('Probability Density Function');
title('PDF of |Z_{12}|');
grid on
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');

 subplot(2,2,3)
plot(Zbin_RCM(:,3),Zpmf_RCM(:,3),'*-k','MarkerSize',5);
ylabel('Probability Density Function');
title('PDF of |Z_{21}|');
grid on
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');
 
subplot(2,2,4)
plot(Zbin_RCM(:,4),Zpmf_RCM(:,4),'*-k','MarkerSize',5);
ylabel('Probability Density Function');
title('PDF of |Z_{22}|');
grid on
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');

%
hh2 = figure('Position',[10 100 800 800],'NumberTitle', 'off', 'Name', 'Normalized Phase PMF from RCM');
subplot(2,2,1)
plot(Zpbin_RCM(:,1),Zppmf_RCM(:,1),'*-k','MarkerSize',5);
ylabel('Probability Density Function');
title('PDF of \angleZ_{11}');
grid on
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');

subplot(2,2,2)
plot(Zpbin_RCM(:,2),Zppmf_RCM(:,2),'*-k','MarkerSize',5);
ylabel('Probability Density Function');
title('PDF of \angle Z_{12}');
grid on
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');

subplot(2,2,3)
plot(Zpbin_RCM(:,3),Zppmf_RCM(:,3),'*-k','MarkerSize',5);
ylabel('Probability Density Function');
title('PDF of \angle Z_{21}');
grid on
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');
 
subplot(2,2,4)
plot(Zpbin_RCM(:,4),Zppmf_RCM(:,4),'*-k','MarkerSize',5);
ylabel('Probability Density Function');
title('PDF of \angle Z_{22}');
grid on
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');

if (useGUI == true)
    saveas(hh1,fullfile(foldername,'RCM_mag_pdf'),'png');
    saveas(hh2,fullfile(foldername,'RCM_phase_pdf'),'png');
    close(hh1)
    close(hh2)
end