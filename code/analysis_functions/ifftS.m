function [St,t] = ifftS(Sf,deltaF)
% [St,t] = ifftS(Sf,deltaF)

%get the length of the vector
N = length(Sf);

%compute the time steps and generate a time vector
dt = 1/(deltaF);
t = (-N/2:N/2-1)*dt;

%compute the inverse Fourier transform and scale by N
St = ifftshift(ifft(ifftshift(Sf)))*N;