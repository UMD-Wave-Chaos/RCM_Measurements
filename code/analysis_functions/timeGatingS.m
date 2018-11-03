function [Sf,f] = timeGatingS(SCf,Srad,Freq,port,gateTime,varargin)

if nargin == 6
    maskType = varargin{1};
else
    maskType = 0;
end
wVal = 2.5;

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
         windowString = sprintf('Kaiser, Beta = %0.3f',wVal);
     case 2
         windowString = 'BlackmanHarris';
     case 3
         windowString = sprintf('Gaussian, Alpha = %0.3f',wVal);
     case 4
         windowString = 'Hamming';
     otherwise
         windowString = 'Rectangular';
 end
 
%get the size of the frequency domain measurement
[Sf,f] = applyTimeGating(SCf(:,port,:),Freq,gateTime,maskType);
meanSf = mean(Sf,2);

Sc = getSParameterCorrectionFactor(SCf,port);
Sr1 = mean(Sc.*SCf(:,1,:),3);

Sdiff = sum(abs(mean(Sf,2) - mean(Srad(:,port,:,10),3)));
dString = sprintf('Signal Difference is %f',Sdiff);
disp(dString);

figure
% plot(Freq/1e9,20*log10(abs(SCf(:,port,1))),'--b');
hold on
plot(Freq/1e9,20*log10(abs(mean(SCf(:,port,:),3))),'--g','LineWidth',2);
% plot(Freq/1e9,20*log10(abs(Sr1)),'.g');
plot(f/1e9,20*log10(abs(meanSf)),'r','LineWidth',2);

plot(Freq/1e9,20*log10(abs(mean(Srad(:,port,:,10),3))),'k','LineWidth',2);
grid on
xlabel('Frequency (GHz)')
ylabel('S Parameters (dB)')
set(gca,'LineWidth',2)
set(gca,'FontSize',12)
set(gca,'FontWeight','bold')
tstring = sprintf('S_{%s} with %0.2f ns %s Time Window',indString,1e9*gateTime, windowString);
title(tstring);

legend('Ungated','Gated in Processing','Gated in Measurement')

% legend('Raw |S|','|<S>|','|<S_c>|','|<S_{gn}>|','|<S_{gm}>|')
