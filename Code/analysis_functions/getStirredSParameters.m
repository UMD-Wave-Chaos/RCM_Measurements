function Sxx = getStirredSParameters(SCf,index)

%need to remove the "unstirred" components
Sx = SCf(:,index,:);
Sxx = mean(abs(Sx - mean(Sx,3)).^2,3);
