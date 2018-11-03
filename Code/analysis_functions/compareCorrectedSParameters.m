function [Sf,f] = compareCorrectedSParameters(SCf,Freq,port,varargin)

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
 
Sc = getSParameterCorrectionFactor(SCf,port);
Sr1 = mean(Sc.*SCf(:,1,:),3);

figure
hold on
plot(Freq/1e9,20*log10(abs(mean(SCf(:,port,:),3))),'--g','LineWidth',2);
plot(Freq/1e9,20*log10(abs(Sr1)),' ');
grid on
xlabel('Frequency (GHz)')
ylabel('|<S>| (dB)')
set(gca,'LineWidth',2)
set(gca,'FontSize',12)
set(gca,'FontWeight','bold')
tstring = sprintf('S_{%s} with %0.2f ns %s',indString,1e9*gateTime, windowString);
title(tstring);
legend('Raw','Corrected')

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
