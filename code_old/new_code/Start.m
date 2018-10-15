%% The is parent module for rest of code

%% Calibrate Network Analyzer
for k = 1:15
 cal_name = ['cal_for_',date,num2str(k)];
  %  CalNA_np(0.1E9+(k-1)*0.2E9,0.1E9+k*0.2E9,cal_name,1)
end
%% Measure and store one port S-parameters
[t, SCt, Freq, SCf, Srad] = TwoPortMeas(cal_name,5E-9,-1E-6,5E-6, 50);

%% Compute Alpha (Loss Parameter) from Impulse response
V = 1.92; %cubed meters (Volume of the enclosure)
k = 2*pi*mean(Freq)/(3E8); % k = w/c
Tau = zeros(4,1); Qcomp = zeros(4,1); alpha = zeros(4,1);
a = (mean(abs(SCt),3)); % average impulse response over all realizations
for snum = 1:4
    Tau(snum) = getTau(t,a(:,snum),1E-6, 4E-6); % Compute 1/e ensemble energy decay time
    Qcomp(snum) = 2*pi*mean(Freq)*Tau(snum); % Compute composite Q from Tau.
    alpha(snum) = (k^3*V)/(2*pi^2*Qcomp(snum));
end
%% Compute Measured Xi (Normalized Impedance)
% etaI = interp1(FreqEta, eta2, Freq/1E9); % interpolate the radiation efficiency data
etaI = 1; N = 50; % number of realizations
tic;
Zm = zeros(length(Freq),4,N);
Zlo = zeros(length(Freq),4,N);
for i = 1:N
    %%+++ Trasformation using element-wise (rather that matrix) calculation +++++%:
    %+++++Scav to Zcav+++++
    df = ((1-SCf(:,1,i)).*(1-SCf(:,4,i))-SCf(:,2,i).*SCf(:,3,i))/50;
    dr = ((1-Srad(:,1,i)).*(1-Srad(:,4,i))-Srad(:,2,i).*Srad(:,3,i))/50;    
    Zm(:,1,i) = ((1+SCf(:,1,i)).*(1-SCf(:,4,i))+SCf(:,2,i).*SCf(:,3,i))./df;
    Zlo(:,1,i) = ((1+Srad(:,1,i)).*(1-Srad(:,4,i))+Srad(:,2,i).*Srad(:,3,i))./dr;    
    Zm(:,2,i) = 2*SCf(:,2,i)./df;
    Zlo(:,2,i) = 2*Srad(:,2,i)./dr;
    Zm(:,3,i) = 2*SCf(:,3,i)./df;
    Zlo(:,3,i) = 2*Srad(:,3,i)./dr;
    Zm(:,4,i) = ((1-SCf(:,1,i)).*(1+SCf(:,4,i))+SCf(:,2,i).*SCf(:,3,i))./df;
    Zlo(:,4,i) = ((1-Srad(:,1,i)).*(1+Srad(:,4,i))+Srad(:,2,i).*Srad(:,3,i))./dr;
    RL(:,:,i) = (1-etaI).*real(Zlo(:,:,i)); % define the loss resistance Rlo = RL + RD
    RD(:,:,i) = etaI.*real(Zlo(:,:,i)); % define the radiation resistance
    XiM(:,:,i) = (Zm(:,1,i) - RL(:,1,i) - 1i*imag(Zlo(:,1,i)))./RD(:,1,i);
    %++++++Srad to Zrad+++++
    d5 = ((1-SCf(:,1,i)).*(1-SCf(:,4,i))-SCf(:,2,i).*SCf(:,3,i))/50;
    Zcf(:,1,i) = ((1+SCf(:,1,i)).*(1-SCf(:,4,i))+SCf(:,2,i).*SCf(:,3,i))./d5;
    Zcf(:,2,i) = 2*SCf(:,2,i)./d5;
    Zcf(:,3,i) = 2*SCf(:,3,i)./d5;
    Zcf(:,4,i) = ((1-SCf(:,1,i)).*(1+SCf(:,4,i))+SCf(:,2,i).*SCf(:,3,i))./d5;
    time = toc; display(['Time =',num2str(time),'seconds. i =', num2str(i)]);
    %++++++++++++++++++++++++++++++++++++++++++++++++++++
end
%% Generate Xi using RMT
XiC = T_method_generator_JenHao(alpha,N*length(Freq));

%% Compare distribution XiM adn XiC (Computed and Measured Normaline
XiMe = reshape(squeeze(XiM),N*length(Freq),1);
[countsMe,centersMe] = hist(real(XiMe),1000);
[countsC,centersC] = hist(real(XiC),1000);
close all; Me = stairs(centersMe,countsMe/sum((centersMe(2)-centersMe(1))*countsMe),'r');
hold on; C = stairs(centersC,countsC/sum((centersC(2)-centersC(1))*countsC),'g');
% Set the color, line width, axis label, legend and title of plot
set(Me,'Color' , 'g', 'LineWidth', 1);
set(C,'Color' , 'r', 'LineWidth', 1);
hTitle  = title ('Distributions of \xi for Monopople Antenna');
hXLabel = xlabel('Frequency (GHz)');
hYLabel = ylabel('CDF(\xi)');
hLegend = legend([Me,C],'Measurement','Monte Carlo Simulation','location','SouthEast');
%%
set( gca                       , ...
    'FontName'   , 'Helvetica' );
set([hTitle, hXLabel, hYLabel], ...
    'FontName'   , 'AvantGarde');%%
set([hXLabel, hYLabel]  , ...
    'FontSize'   , 10          );
set( hTitle                    , ...
    'FontSize'   , 12          , ...
    'FontWeight' , 'bold'      );
set([hLegend, gca]             , ...
    'FontName' , 'Arial','FontSize'   , 8           );
%%
set(gca, ...
    'Box'         , 'off'     , ...
    'TickDir'     , 'out'     , ...
    'TickLength'  , [.02 .02] , ...
    'XMinorTick'  , 'on'      , ...
    'YMinorTick'  , 'on'      , ...
    'YGrid'       , 'on'      , ...
    'XGrid'       , 'on'      , ...
    'XColor'      , [.3 .3 .3], ...
    'YColor'      , [.3 .3 .3], ...
    'YTick'       , -1:0.1:2, ...
    'XTick'       , 0:0.5:6, ...
    'LineWidth'   , 1         );
%%
set(gcf, 'PaperPositionMode', 'auto');
print -depsc2 Comparison_of_xi_Monopole.eps
