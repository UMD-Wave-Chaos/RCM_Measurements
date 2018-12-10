function S = packComponents(S11,S12,S21,S22);

S(:,1,:) = S11;
S(:,2,:) = S12;
S(:,3,:) = S21;
S(:,4,:) = S22;