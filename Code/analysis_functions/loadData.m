function data = loadData(filename)

%load the data
data.Freq = h5read(filename,'/Measurements/Freq');

%get the real values
SCf_r = h5read(filename,'/Measurements/SCf_real');

%get the imaginary values
SCf_i = h5read(filename,'/Measurements/SCf_imag');

%convert to complex numbers
data.SCf = SCf_r + 1j*SCf_i;

data.Settings = loadSettingsFromHDF5File(filename);