function data =  loadAnalysisFile(filename)

%load the data
data.f = h5read(filename,'/Analysis/f');
data.t = h5read(filename,'/Analysis/t');
data.eb = h5read(filename,'/Analysis/eb');
data.K11 = h5read(filename,'/Analysis/K11');
data.K12 = h5read(filename,'/Analysis/K12');
data.K21 = h5read(filename,'/Analysis/K21');
data.K22 = h5read(filename,'/Analysis/K22');
data.tau = h5read(filename,'/Analysis/tau');
data.alpha = h5read(filename,'/Analysis/alpha');
data.Q = h5read(filename,'/Analysis/Q');
data.pdp = h5read(filename,'Analysis/pdp');

%get the S parameters
SCf_r = h5read(filename,'/Analysis/SCf_real');
SCf_i = h5read(filename,'/Analysis/SCf_imag');
data.SCf = SCf_r + 1j*SCf_i;

Srad_r = h5read(filename,'/Analysis/Srad_real');
Srad_i = h5read(filename,'/Analysis/Srad_imag');
data.Srad = Srad_r + 1j*Srad_i;

SCt_r = h5read(filename,'/Analysis/SCt_real');
SCt_i = h5read(filename,'/Analysis/SCt_imag');
data.SCt = SCt_r + 1j*SCt_i;

%get the Z parameters
ZCf_r = h5read(filename,'/Analysis/Zcf_real');
ZCf_i = h5read(filename,'/Analysis/Zcf_imag');
data.ZCf = ZCf_r + 1j*ZCf_i;

Zrad_r = h5read(filename,'/Analysis/Zradf_real');
Zrad_i = h5read(filename,'/Analysis/Zradf_imag');
data.Zrad = Zrad_r + 1j*Zrad_i;

Znormf_r = h5read(filename,'/Analysis/Znormf_real');
Znormf_i = h5read(filename,'/Analysis/Znormf_imag');
data.Znormf = Znormf_r + 1j*Znormf_i;