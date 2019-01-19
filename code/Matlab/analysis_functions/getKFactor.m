function [Sxx,Sus,Ss] = getKFactor(SCf,index)
Sus = abs(mean(SCf(:,index,:),3)).^2;

Ss = mean(abs(SCf(:,index,:) - mean(SCf(:,index,:),3)).^2,3);

Sxx = Sus./Ss;