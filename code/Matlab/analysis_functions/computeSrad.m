function Srad2 = computeSrad(SCf,Freq)

gt1 = 250e-9;
gt2 = 250e-9;
gt3 = 250e-9;
gt4 = 250e-9;

S1 = mean(applyTimeGating(SCf(:,1,:),Freq,gt1,0,0.5),2);
S2 = mean(applyTimeGating(SCf(:,2,:),Freq,gt2,0,0.5),2);
S3 = mean(applyTimeGating(SCf(:,3,:),Freq,gt3,0,0.5),2);
S4 = mean(applyTimeGating(SCf(:,4,:),Freq,gt4,0,0.5),2);

Srad2(:,1) = S1;
Srad2(:,2) = S2;
Srad2(:,3) = S3;
Srad2(:,4) = S4;