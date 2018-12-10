function Sxx = getSParameterPower(SCf,index)

Sx = SCf(:,index,:);

Sxx = mean(abs(Sx).^2,3);
