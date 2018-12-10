function [Sf,f] = timeGatingS(SCf,Srad,Freq,port,gateTime,varargin)

if nargin >= 6
    maskType = varargin{1};
else
    maskType = 0;
end

if nargin >= 7
    wVal = varargin{2};
else
    wVal = 2.5;
end

if nargin >= 8
    SradIndex = varargin{3};
else
    SradIndex = 10;
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
Sr1 = mean(Sc.*SCf(:,1,:),3);

v1 = mean(Sf,2);
v2 = mean(Srad(:,port,:),3);

G = sum(abs(v2-v1))/sum(abs(v2+v1))*100;
dString = sprintf('Signal Difference is %f%%',G);
disp(dString);

figure
hold on
plot(Freq/1e9,20*log10(abs(mean(SCf(:,port,:),3))),'g','LineWidth',2);
plot(f/1e9,20*log10(abs(meanSf)),'r','LineWidth',2);
plot(Freq/1e9,20*log10(abs(mean(Srad(:,port,:),3))),'k','LineWidth',2);
grid on
xlabel('Frequency (GHz)')
ylabel('|<S>| (dB)')
set(gca,'LineWidth',2)
set(gca,'FontSize',12)
set(gca,'FontWeight','bold')
tstring = sprintf('S_{%s} with %0.2f ns %s, G = %0.2f%%',indString,1e9*gateTime, windowString, G);
title(tstring);
legend('Ungated','Gated in Processing','Gated in Measurement')


figure
hold on
plot(Freq/1e9,angle(mean(SCf(:,port,:),3)),'--g','LineWidth',2);
plot(f/1e9,angle(meanSf),'r','LineWidth',2);
plot(Freq/1e9,angle(mean(Srad(:,port,:),3)),'k','LineWidth',2);
grid on
xlabel('Frequency (GHz)')
ylabel('\angle <S> (rad)')
set(gca,'LineWidth',2)
set(gca,'FontSize',12)
set(gca,'FontWeight','bold')
tstring = sprintf('S_{%s} with %0.2f ns %s, G = %0.1f',indString,1e9*gateTime, windowString,G);
title(tstring);
legend('Ungated','Gated in Processing','Gated in Measurement')
