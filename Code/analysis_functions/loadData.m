function [Freq, SCf,Settings] = loadData(filename)

%load the data
Freq = h5read(filename,'/Measurements/Freq');

%get the real values
SCf_r = h5read(filename,'/Measurements/SCf_real');

%get the imaginary values
SCf_i = h5read(filename,'/Measurements/SCf_imag');

%convert to complex numbers
SCf = SCf_r + 1j*SCf_i;

Settings = loadSettingsFromHDF5File(filename);