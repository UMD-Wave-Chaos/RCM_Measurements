function Srad = computeSrad(SCf)
[m,n,~] = size(SCf);
Srad = zeros(m,n);

for port = 1:4
    Sc = getSParameterCorrectionFactor(SCf,port);
    Srad(:,port) = mean(Sc.*SCf(:,port,:),3);
end
