function [St,t] = ifftS(Sf,fSpan)
% [St,t] = ifftS(Sf,fSpan)

%get the length of the vector
N = length(Sf);

%compute the spacing in frequency and then time
df = fSpan/(N-1);
dt = 1/(N*df);

padLength = 1000;

[m,n] = size(Sf);
paddedSf = zeros(m + padLength,n);
paddedSf(1:m,:) = Sf;


%compute the time steps and generate a time vector
% t = (-(N/2-1):N/2)*dt;
t = ((-(N/2):N/2-1)-0.5)*dt;
%compute the inverse Fourier transform
St = ifftshift(ifft(ifftshift(Sf)));

paddedSt = ifftshift(ifft(ifftshift(paddedSf)));

plot(mean(abs(paddedSt),2))