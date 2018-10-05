function Z = Sf2Zf(num_ports, S)
% Converts 1 or 2 ports S parameters into Z parameters
%   Input : num_ports --- number of active ports in the chamber/ experiment
%                   S --- S parameters in (# of frequencies X # of ports squared)
%  Output :  Z --- Z parameters

% Check matrix format
S = reshape(S,length(S), num_ports^2);

% Allocate memory for Z
Z = zeros(size(S));

Z0 = 50*eye(num_ports);
for i = 1:length(S)
    tS = (reshape(S(i,:),num_ports,num_ports))';
    tZ =  (inv(eye(num_ports)-tS))*(eye(num_ports)+tS)*(Z0);
    Z(i,:) = reshape(tZ',1,num_ports^2) ;
end
end