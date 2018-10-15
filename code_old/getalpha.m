function [alpha Qcomp] = getalpha(f, Tau, V)
% Input: f = average frequency (GHz)
%      Tau = 1/e fold energy decay time
% Output: alpha = the loss parameter  = (k^3*V)/(2*pi^2*Qcomp) 

Qcomp = 2*pi*f*Tau;
k = 2*pi*f/(3E8); % k = w/c
alpha = (k^3*V)/(2*pi^2*Qcomp);

end