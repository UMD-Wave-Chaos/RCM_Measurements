% function [Z1,Z2] = compareGatingPosition(SCf,Freq,port,gateTime,varargin)

%% initialization for the mask
maskType = 1;
wVal = 2.5;

%% first apply the time gating in S domain
[Sf,f] = applyTimeGating(SCf(:,port,:),Freq,gateTime,maskType);
%transform to Z
Zf = squeeze(transformToZ(Sf,Freq));
%take the mean value - Z1 is the output signal that was gated in the S
%domain
 Z1 = mean(Zf,2);

%% second apply the time gating in the Z domain
%need to make sure to size appropriately as a single port kind of
%measurement
Stest = squeeze(SCf(:,port,:));
%transform to Z
Zf1 = squeeze(transformToZ(Stest,Freq));
%now apply the time gating
[Zf1,f] = applyTimeGating(Zf1,Freq,gateTime,maskType);
%take the mean value - Z2 is the output signal that was gated in the Z
%domain 
Z2 = mean(Zf1,2);

%% setup output strings
switch port
    case 1
        indString = '11';
    case 2
        indString = '12';
    case 3
        indString = '21';
    case 4
        indString = '22';
    otherwise
        indString = 'NA';
end

 switch maskType
     case 1
         windowString = sprintf('Kaiser, Beta = %f',wVal);
     case 2
         windowString = 'BlackmanHarris';
     case 3
         windowString = sprintf('Gaussian, Alpha = %f',wVal);
     case 4
         windowString = 'Hamming';
     otherwise
         windowString = 'Rectangular';
 end

 %% plot the results
figure
plot(Freq/1e9,20*log10(abs(Z1)),'LineWidth',2);
hold on
plot(Freq/1e9,20*log10(abs(Z2)),'LineWidth',2);
grid on
xlabel('Frequency (GHz)')
ylabel('Z log mag');
tstring = sprintf('Z_{%s} with %0.2f ns %s Time Window',indString,1e9*gateTime, windowString);
title(tstring);
set(gca,'LineWidth',2)
set(gca,'FontSize',12)
set(gca,'FontWeight','bold')
legend('Gated S','Gated Z')
