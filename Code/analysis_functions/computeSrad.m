function Srad2 = computeSrad(SCf,Freq)

Sc = getSParameterCorrectionFactor(SCf,1);
S1 = mean(Sc.*SCf(:,1,:),3);

% S1 = mean(checkTimeGateSettings(SCf,Freq,1,200e-9,0,0.75),2);
S4 = mean(checkTimeGateSettings(SCf,Freq,4,16e-9,0,0.75),2);

S2 = sqrt(S1.*S4);
S3 = S2;

% S1 = timeGatingS(SCf,Srad,Freq,1,100e-9);
% S2 = timeGatingS(SCf,Srad,Freq,2,100e-9);
% S3 = timeGatingS(SCf,Srad,Freq,3,100e-9);
% S4 = timeGatingS(SCf,Srad,Freq,4,16e-9);

Srad2(:,1) = S1;
Srad2(:,2) = S2;
Srad2(:,3) = S3;
Srad2(:,4) = S4;