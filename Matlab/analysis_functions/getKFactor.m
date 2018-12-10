function Sxx = getKFactor(SCf,index)
Snum = abs(mean(SCf(:,index,:),3)).^2;

Sden = mean(abs(SCf(:,index,:) - mean(SCf(:,index,:),3)).^2,3);

Sxx = Snum./Sden;