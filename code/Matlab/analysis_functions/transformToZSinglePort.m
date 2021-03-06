function Z = transformToZSinglePort(S)

 N = size(S,2);

srZ0 = 50;
Z = zeros(size(S));

for i = 1:N
    Z(:,i) = srZ0*(1 + S(:,i))./(1-S(:,i));
end