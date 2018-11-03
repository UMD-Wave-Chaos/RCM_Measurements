function [Z1,Z2] = compareGatingPosition(SCf,Freq,port,gateTime,varargin)

%% initialization for the mask
if nargin >= 5
    maskType = varargin{1};
else   
    maskType = 0;
end

if nargin == 6
    wVal = varargin{2};
else
    wVal = 2.5;
end

%% first apply the time gating in S domain
[Sf,~] = applyTimeGating(SCf(:,port,:),Freq,gateTime,maskType,wVal);
%transform to Z
Zfg = squeeze(transformToZ(Sf,Freq));
%take the mean value - Z1 is the output signal that was gated in the S
%domain
 Z1 = mean(Zfg,2);

%% second apply the time gating in the Z domain
%need to make sure to size appropriately as a single port kind of
%measurement
Stest = squeeze(SCf(:,port,:));
%transform to Z
Zf1 = squeeze(transformToZ(Stest,Freq));
%now apply the time gating
[Zf1g,~,windowString] = applyTimeGating(Zf1,Freq,gateTime,maskType,wVal);
%take the mean value - Z2 is the output signal that was gated in the Z
%domain 
Z2 = mean(Zf1g,2);

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
 
 Zdiff = sum(abs(Z2 - Z1));
 zstring = sprintf('Z sum difference with %s and %0.3f ns Gating = %0.3f',windowString, 1e9*gateTime,Zdiff);
 disp(zstring);

 %% plot the results
figure
plot(Freq/1e9,20*log10(abs(mean(Zf1,2))),'LineWidth',2);
hold on
plot(Freq/1e9,20*log10(abs(Z1)),'LineWidth',2);
plot(Freq/1e9,20*log10(abs(Z2)),'LineWidth',2);
grid on
xlabel('Frequency (GHz)')
ylabel('|<Z>| (dB)');
tstring = sprintf('Z_{%s} with %0.2f ns %s',indString,1e9*gateTime, windowString);
title(tstring);
set(gca,'LineWidth',2)
set(gca,'FontSize',12)
set(gca,'FontWeight','bold')
legend('Ungated','Gated S','Gated Z')

figure
plot(Freq/1e9,angle(mean(Zf1,2)),'LineWidth',2);
hold on
plot(Freq/1e9,angle(Z1),'LineWidth',2);
plot(Freq/1e9,angle(Z2),'LineWidth',2);
grid on
xlabel('Frequency (GHz)')
ylabel('\angle <Z> (rad)');
tstring = sprintf('Z_{%s} with %0.2f ns %s',indString,1e9*gateTime, windowString);
title(tstring);
set(gca,'LineWidth',2)
set(gca,'FontSize',12)
set(gca,'FontWeight','bold')
legend('Ungated','Gated S','Gated Z')
