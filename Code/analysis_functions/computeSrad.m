function Srad2 = computeSrad(SCf,Freq)


S1 = mean(applyTimeGating(SCf(:,1,:),Freq,100e-9,0,0.5),2);
S2 = mean(applyTimeGating(SCf(:,2,:),Freq,250e-9,0,0.5),2);
S3 = mean(applyTimeGating(SCf(:,3,:),Freq,250e-9,0,0.5),2);
S4 = mean(applyTimeGating(SCf(:,4,:),Freq,10e-9,0,0.5),2);


Sc = getSParameterCorrectionFactor(SCf,2);
S2 = Sc.*mean(SCf(:,2,:),3);

Sc = getSParameterCorrectionFactor(SCf,3);
S3 = Sc.*mean(SCf(:,3,:),3);


Srad2(:,1) = S1;
Srad2(:,2) = S2;
Srad2(:,3) = S3;
Srad2(:,4) = S4;