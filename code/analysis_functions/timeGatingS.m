function [Sf,Zf,f] = timeGatingS(SCf,Srad,Freq,port,gateTime,varargin)

if nargin == 6
    maskType = varargin{1};
else
    maskType = 0;
end


%get the size of the frequency domain measurement
[Sf,f] = applyTimeGating(SCf(:,port,:),Freq,gateTime,maskType);
meanSf = mean(Sf,2);

Sc = getSParameterCorrectionFactor(SCf,port);
Sr1 = mean(Sc.*SCf(:,1,:),3);

Sdiff = abs(sum(Sf - mean(Srad(:,port,:),3)));
dString = sprintf('Signal Difference is %f',Sdiff);
disp(dString);

figure
plot(Freq/1e9,20*log10(abs(SCf(:,port,1))),'--b');
hold on
plot(Freq/1e9,20*log10(abs(mean(SCf(:,port,:),3))),'--m');
plot(Freq/1e9,20*log10(abs(Sr1)),'.g');
plot(f/1e9,20*log10(abs(meanSf)),'.r','LineWidth',2);

plot(Freq/1e9,20*log10(abs(mean(Srad(:,port,:),3))),'k','LineWidth',2);
grid on
xlabel('Frequency (GHz)')
ylabel('S Parameters (dB)')
set(gca,'LineWidth',2)
set(gca,'FontSize',12)
set(gca,'FontWeight','bold')

legend('Raw |S|','|<S>|','|<S_c>|','|<S_{gn}>|','|<S_{gm}>|')
