function Sxx = getCorrectedSParameterPower(SCf,index)

Ss = getStirredSParameterPower(SCf,index);

Sx = SCf(:,index,:);
Sp = abs(mean(Sx,3)).^2;

Sxx = Ss./((1 - Sp).*(1 - Sp));