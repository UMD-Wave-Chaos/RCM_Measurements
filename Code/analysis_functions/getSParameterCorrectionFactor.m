function Sc = getSParameterCorrectionFactor(SCf,index)

S1 = SCf(:,index,:);
Sx1 = abs(mean(S1,3)).^2;
Sc = (1-Sx1); 

