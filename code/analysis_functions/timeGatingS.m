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

if nargin == 8
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

Sdiff = sum(abs(mean(Sf,2) - mean(Srad(:,port,:,SradIndex),3)));
dString = sprintf('Signal Difference is %f',Sdiff);
disp(dString);

figure
% plot(Freq/1e9,20*log10(abs(SCf(:,port,1))),'--b');
hold on
plot(Freq/1e9,20*log10(abs(mean(SCf(:,port,:),3))),'--g','LineWidth',2);
% plot(Freq/1e9,20*log10(abs(Sr1)),'.g');
plot(f/1e9,20*log10(abs(meanSf)),'r','LineWidth',2);
plot(Freq/1e9,20*log10(abs(mean(Srad(:,port,:,SradIndex),3))),'k','LineWidth',2);
grid on
xlabel('Frequency (GHz)')
ylabel('|<S>| (dB)')
set(gca,'LineWidth',2)
set(gca,'FontSize',12)
set(gca,'FontWeight','bold')
tstring = sprintf('S_{%s} with %0.2f ns %s',indString,1e9*gateTime, windowString);
title(tstring);
legend('Ungated','Gated in Processing','Gated in Measurement')

% legend('Raw |S|','|<S>|','|<S_c>|','|<S_{gn}>|','|<S_{gm}>|')

figure
hold on
plot(Freq/1e9,angle(mean(SCf(:,port,:),3)),'--g','LineWidth',2);
plot(f/1e9,angle(meanSf),'r','LineWidth',2);
plot(Freq/1e9,angle(mean(Srad(:,port,:,SradIndex),3)),'k','LineWidth',2);
grid on
xlabel('Frequency (GHz)')
ylabel('\angle <S> (rad)')
set(gca,'LineWidth',2)
set(gca,'FontSize',12)
set(gca,'FontWeight','bold')
tstring = sprintf('S_{%s} with %0.2f ns %s',indString,1e9*gateTime, windowString);
title(tstring);
legend('Ungated','Gated in Processing','Gated in Measurement')
