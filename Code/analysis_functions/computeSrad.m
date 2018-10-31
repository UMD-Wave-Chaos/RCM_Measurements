function Srad = computeSrad(SCf)
[m,n,p] = size(SCf);
Srad = zeros(m,n);

for port = 1:4
    Sc = getSParameterCorrectionFactor(SCf,port);
    
%     Smean = mean(SCf(:,port,:),3);
%     Sval = reshape(SCf(:,port,:),[m p]);
%     Scor = Sval - Smean;
    
    Srad(:,port) = mean(Sc.*SCf(:,port,:),3);
%     Srad(:,port) = mean(Sc.*Scor,2);
end
