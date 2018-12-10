function [Sf,f] = checkTimeGateSettings(SCf,Freq,port,gateTime,varargin)

if nargin >= 5
    maskType = varargin{1};
else
    maskType = 0;
end

if nargin >= 6
    wVal = varargin{2};
else
    wVal = 2.5;
end

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
 
%get the size of the frequency domain measurement
[Sf,f,windowString] = applyTimeGating(SCf(:,port,:),Freq,gateTime,maskType,wVal);
meanSf = mean(Sf,2);

Sc = getSParameterCorrectionFactor(SCf,port);
Sr1 = mean(Sc.*SCf(:,port,:),3);

figure
hold on
plot(Freq/1e9,20*log10(abs(mean(SCf(:,port,:),3))),'--g','LineWidth',2);
plot(f/1e9,20*log10(abs(Sr1)),'b','LineWidth',2);
plot(f/1e9,20*log10(abs(meanSf)),'r','LineWidth',2);
grid on
xlabel('Frequency (GHz)')
ylabel('|<S>| (dB)')
set(gca,'LineWidth',2)
set(gca,'FontSize',12)
set(gca,'FontWeight','bold')
tstring = sprintf('S_{%s} with %0.2f ns %s',indString,1e9*gateTime, windowString);
title(tstring);
legend('Ungated Raw','Ungated Corrected','Gated')

figure
hold on
plot(Freq/1e9,angle(mean(SCf(:,port,:),3)),'--g','LineWidth',2);
plot(f/1e9,angle(Sr1),'b','LineWidth',2);
plot(f/1e9,angle(meanSf),'r','LineWidth',2);
grid on
xlabel('Frequency (GHz)')
ylabel('\angle <S> (rad)')
set(gca,'LineWidth',2)
set(gca,'FontSize',12)
set(gca,'FontWeight','bold')
tstring = sprintf('S_{%s} with %0.2f ns %s',indString,1e9*gateTime, windowString);
title(tstring);
legend('Ungated Raw','Ungated Corrected','Gated')