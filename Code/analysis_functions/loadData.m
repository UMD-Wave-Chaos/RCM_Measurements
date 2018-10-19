function [t, SCt, Freq, SCf, Srad,V,l,N,NOP,nRCM] = loadData(filename)

%load the data

%Srad = h5read(filename,'/Measurements/Srad');
%SCf = h5read(filename,'/Measurements/SCf');
%SCt = h5read(filename,'/Measurements/SCt');
t = h5read(filename,'/Measurements/t');
Freq = h5read(filename,'/Measurements/Freq');
N = h5readatt(filename,'/','Nrealizations');
NOP = h5readatt(filename,'/','Npoints');
V = h5readatt(filename,'/','V');
l = h5readatt(filename,'/','l');
nRCM = h5readatt(filename,'/','nRCM');


Srad_r = h5read(filename,'/Measurements/Srad_real');
SCf_r = h5read(filename,'/Measurements/SCf_real');
SCt_r = h5read(filename,'/Measurements/SCt_real');
% 
Srad_i = h5read(filename,'/Measurements/Srad_imag');
SCf_i = h5read(filename,'/Measurements/SCf_imag');
SCt_i = h5read(filename,'/Measurements/SCt_imag');
% 
Srad = Srad_r + 1j*Srad_i;
SCf = SCf_r + 1j*SCf_i;
SCt = SCt_r + 1j*SCt_i;