function Z = transformToZ2Port(S)

%% convert the S-parameters to Z-parameters
%assume N is of size nFreq x nPorts x nRealizations, need the number of
%realizations
N = size(S,3);
Z = zeros(size(S,1),4,N);
%assume 50 ohm load
Z0 = 50;

%% for speed, vectorize operations
for i = 1:N
    deltaS = (1-S(:,1,i)).*(1-S(:,4,i)) - S(:,2,i).*S(:,3,i);
    Z(:,1,i) = Z0*((1+S(:,1,i)).*(1-S(:,4,i)) + S(:,2,i).*S(:,3,i))./deltaS;
    Z(:,2,i) = Z0*2*S(:,2,i)./deltaS;
    Z(:,3,i) = Z0*2*S(:,3,i)./deltaS;
    Z(:,4,i) = Z0*((1-S(:,1,i)).*(1+S(:,4,i)) - S(:,2,i).*S(:,3,i))./deltaS;
end