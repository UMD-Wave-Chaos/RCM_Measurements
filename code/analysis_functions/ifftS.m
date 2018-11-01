function [St,t] = ifftS(Sf,fSpan,varargin)
% [St,t] = ifftS(Sf,deltaF)
% [St,t] = ifftS(Sf,deltaF,upSampleFactor)


%get the length of the vector
N = length(Sf);

if nargin == 3
    upSampleFactor = varargin{1};
    Nsamples = N*upSampleFactor;
else
    upSample = false;
    Nsamples = N;
end


%compute the time steps and generate a time vector
T = 1/(upSampleFactor*fSpan);
t = (-Nsamples/2:Nsamples/2-1)*T;

%compute the inverse Fourier transform
St = ifftshift(ifft(ifftshift(Sf),Nsamples))*upSampleFactor;