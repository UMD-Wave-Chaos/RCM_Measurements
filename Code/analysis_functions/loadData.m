function [t, SCt, Freq, SCf, Srad,V,l,N,NOP,nRCM] = loadData(filename)

%log the data

Srad = h5read(filename,'/Measurements/Srad');
SCf = h5read(filename,'/Measurements/SCf');
SCt = h5read(filename,'/Measurements/SCt');
t = h5read(filename,'/Measurements/t');
Freq = h5read(filename,'/Measurements/Freq');
N = h5readatt(filename,'/','Nrealizations');
NOP = h5readatt(filename,'/','Npoints');
V = h5readatt(filename,'/','V');
l = h5readatt(filename,'/','l');
nRCM = h5readatt(filename,'/','nRCM');