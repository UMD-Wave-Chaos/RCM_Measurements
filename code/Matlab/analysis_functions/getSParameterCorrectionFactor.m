function Sc = getSParameterCorrectionFactor(SCf,index)

S1 = squeeze(SCf(:,index,:));
Sx1 = abs(mean(S1,2)).^2;
Sc = (1-Sx1); 

