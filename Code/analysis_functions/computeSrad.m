function Srad2 = computeSrad(SCf,Srad,Freq)


S1 = timeGatingS(SCf,Srad,Freq,1,100e-9);
S2 = timeGatingS(SCf,Srad,Freq,2,100e-9);
S3 = timeGatingS(SCf,Srad,Freq,3,100e-9);
S4 = timeGatingS(SCf,Srad,Freq,4,16e-9);

Srad2(:,1) = S1;
Srad2(:,2) = S2;
Srad2(:,3) = S3;
Srad2(:,4) = S4;