function compareCorrectedSParameters(SCf,Freq,port,varargin)

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
plot(Freq/1e9,20*log10(abs(mean(SCf(:,port,:),3))),'b','LineWidth',2);
plot(Freq/1e9,20*log10(abs(Sr1)),'k','LineWidth',1.5);
grid on
xlabel('Frequency (GHz)')
ylabel('|<S>| (dB)')
set(gca,'LineWidth',2)
set(gca,'FontSize',12)
set(gca,'FontWeight','bold')
legend('Raw','Corrected')
tstring = sprintf('S_{%s} Raw vs. Corrected Measurements',indString);
title(tstring);


figure
hold on
hold on
plot(Freq/1e9,angle(mean(SCf(:,port,:),3)),'b','LineWidth',2);
plot(Freq/1e9,angle(Sr1),'k','LineWidth',1.5);
grid on
xlabel('Frequency (GHz)')
ylabel('\angle <S> (rad)')
set(gca,'LineWidth',2)
set(gca,'FontSize',12)
set(gca,'FontWeight','bold')
legend('Raw','Corrected')
tstring = sprintf('S_{%s} Raw vs. Corrected Measurements',indString);
title(tstring);