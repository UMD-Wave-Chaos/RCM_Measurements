function Sxx = getSParameterPower2(SCf,index)

Sx = SCf(:,index,:);

Sxx = abs(mean(Sx,3)).^2;