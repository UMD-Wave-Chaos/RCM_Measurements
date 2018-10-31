function [Sf,f] = timeGatingS(SCt,Freq,NOP)


Stest = SCt(:,1,1);
df = (Freq(end) - Freq(1))/NOP;
dt = 1/df;

[St,t] = ifftS(Stest,df);

[Sf,f] = fftS(Stest,dt,Freq(1));


%apply the gate
timeWindow = [1e-9 50e-6];

% indStart = find(abs(t-timeWindow(1)) == min(abs(t-timeWindow(1))),1);
% 
% indStop = find(abs(t-timeWindow(2)) == min(abs(t-timeWindow(2))),1);
% 
% % Sst = zeros(St);
% % Sst(indStart:indStop) = St(indStart:indStop);
% 
% St(1:indStart-1) = 0;
% St(indStop+1:end) = 0;

[Sf,f] = fftS(St,dt,Freq(1));


figure
subplot(2,1,1)
plot(t,20*log10(abs(St)),'LineWidth',2);
grid on

subplot(2,1,2)
plot(Freq/1e9,20*log10(abs(Stest)),'b.');
hold on
plot(f/1e9,20*log10(abs(Sf)),'r.');
grid on