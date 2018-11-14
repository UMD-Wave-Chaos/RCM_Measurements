function pdp = computePowerDecayProfile(SCt,index)

SCt = squeeze(SCt(:,index,:));

%compute the power decay profile
%PDP = <| IFT{SC}|^2>
pdp = mean(abs(SCt).^2,2);