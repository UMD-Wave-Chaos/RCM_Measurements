function [St,t] = ifftS(Sf,fSpan)
% [St,t] = ifftS(Sf,deltaF)

%get the length of the vector
N = length(Sf);

%compute the time steps and generate a time vector
T = 1/(fSpan);
t = (-N/2:N/2-1)*T;

%compute the inverse Fourier transform
St = ifftshift(ifft(ifftshift(Sf)));