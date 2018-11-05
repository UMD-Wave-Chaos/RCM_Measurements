function [Freq, SCf, V,l,N,NOP,nRCM,Settings] = loadData(filename)

%load the data
Freq = h5read(filename,'/Measurements/Freq');
N = h5readatt(filename,'/','Nrealizations');
NOP = h5readatt(filename,'/','Npoints');
V = h5readatt(filename,'/','V');
l = h5readatt(filename,'/','l');
nRCM = h5readatt(filename,'/','nRCM');

%get the real values
SCf_r = h5read(filename,'/Measurements/SCf_real');

%get the imaginary values
SCf_i = h5read(filename,'/Measurements/SCf_imag');

%convert to complex numbers
SCf = SCf_r + 1j*SCf_i;

Settings = loadSettingsFromHDF5File(filename);