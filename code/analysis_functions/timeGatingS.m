function [Sf,f] = timeGatingS(SCf,Srad,Freq,port,gateTime)


fSpan = Freq(end) - Freq(1);

for cnt = 1:50
    [St,t] = ifftS(SCf(:,port,cnt),fSpan,1);

    dt = t(2) - t(1);


%     timeWindow = [-1.6667e-08  1.6667e-08];

%  timeWindow = [-10e-6 10e-6];

timeWindow = [-1*gateTime 1*gateTime];

    indStart = find(abs(t-timeWindow(1)) == min(abs(t-timeWindow(1))),1);


    indStop = find(abs(t-timeWindow(2)) == min(abs(t-timeWindow(2))),1);

    nPoints = indStop-indStart+1;
    dispString = sprintf('Time Gate, keeping %d points', nPoints);
    disp(dispString);

    St(1:indStart-1) = 0;
    St(indStop:end) = 0;
    
    w = window(@kaiser,nPoints,2.5);

    St(indStart:indStop) = w.*St(indStart:indStop);

    [Sf(:,cnt),f] = fftS(St,dt,Freq(1));
    dispString = sprintf('Iteration %d of %d',cnt,50);
    disp(dispString);
end

Sf = mean(Sf,2);

Sc = getSParameterCorrectionFactor(SCf,port);
Sr1 = mean(Sc.*SCf(:,1,:),3);


Sc1 = getSParameterCorrectionFactor(Sf,1);
Sr2 = Sc.*Sf;

figure
plot(Freq/1e9,20*log10(abs(SCf(:,port,1))));
hold on
plot(Freq/1e9,20*log10(abs(mean(SCf(:,port,:),3))));
plot(f/1e9,20*log10(abs(Sr1)),'.');
plot(f/1e9,20*log10(abs(Sf)),'LineWidth',2);

plot(f/1e9,20*log10(abs(Sr2)),'--g','LineWidth',2);

plot(f/1e9,20*log10(abs(mean(Srad(:,port,:,6),3))),'k','LineWidth',2);


legend('SCf','mean SCf','Sr1','mean Sf','Sr2','Srad')

% 

%apply the gate
% timeWindow = [1e-9 50e-6];

% indStart = find(abs(t-timeWindow(1)) == min(abs(t-timeWindow(1))),1);
% 
% indStop = find(abs(t-timeWindow(2)) == min(abs(t-timeWindow(2))),1);
% 
% % Sst = zeros(St);
% % Sst(indStart:indStop) = St(indStart:indStop);
% 
% St(1:indStart-1) = 0;
% St(indStop+1:end) = 0;

% [Sf,f] = fftS(St,dt,Freq(1));
