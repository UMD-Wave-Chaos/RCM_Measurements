function Znormf = normalizeZ1(num_ports, Zc, Zrad)
% Normalizes the measured cavity impadance with the measured radiation
% impedance.
%      Input parameters: num_ports = number of active ports in the chamber/ expermiment
%                        Zc = measured and ensemble averaged cavity impeadance (frequency domain)
%                        Zrad = measured and ensemble averaged radiation impeadance (frequency domain)
%      Output parameter: Znormf = normalized impedance matrix/ vector using
%                                 equation (2) in [1]
% Ref: [1] = Hemmady, S.; Antonsen, T.M.; Ott, E.; Anlage, S.M., "Statistical Prediction and Measurement of Induced Voltages on Components Within Complicated Enclosures: A Wave-Chaotic Approach," Electromagnetic Compatibility, IEEE Transactions on , vol.54, no.4, pp.758,771, Aug. 2012

Znormf = zeros(size(Zc));                                                   % Allocate memory for Znormf            

for i = 1:length(Zrad)
    tZrad = (reshape(Zrad(i,:),num_ports,num_ports))';                      % format each Zrad vector/matrix into N X N where N = # of ports 
    tZc = (reshape(Zc(i,:),num_ports,num_ports))';                          % format each Zcav vector/matrix into N X N where N = # of ports 
    tZnorm = (tZc - 1i*imag(tZrad))/(real(tZrad));                          % normalize as in equation 2 in [1] 
    Znormf(i,:) = reshape(tZnorm',1,num_ports^2) ;                          % reshape/format back to plot friendly form ( length X # of ports squared) 
end
end