function [St,t] = ifftS(Sf,fSpan)
% [St,t] = ifftS(Sf,fSpan)

%get the length of the vector
N = length(Sf);

%compute the spacing in frequency and then time
df = fSpan/(N-1);
dt = 1/(N*df);

%compute the time steps and generate a time vector
t = (-(N/2-1):N/2)*dt;

%compute the inverse Fourier transform
St = ifftshift(ifft(ifftshift(Sf)));