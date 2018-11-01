function [Sf,f] = fftS(St,dt,fStart)
% [Sf,f] = fftS(St,dt,fStart)

%get the length of the vector
N = length(St);

%compute the frequency steps and generate a frequency vector that is offset
%in frequency
Fs = 1/dt;
f = Fs*(0:N-1)/N + fStart;

%compute the Fourier transform and divide by N
Sf = fftshift(fft(St));