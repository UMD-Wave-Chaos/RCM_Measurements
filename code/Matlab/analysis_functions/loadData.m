function data = loadData(filename,varargin)

if nargin == 2
    version = varargin{1};
else
    version = 2;
end

if version == 1
    data.Freq = h5read(filename,'/Measurements/Freq');
    %get the real values
    SCf_r = h5read(filename,'/Measurements/SCf_real');

    %get the imaginary values
    SCf_i = h5read(filename,'/Measurements/SCf_imag');

    %convert to complex numbers
    data.SCf = SCf_r + 1j*SCf_i;

    data.Settings = loadSettingsFromHDF5File(filename);
else
    
    %load the frequency data
    data.Freq = h5read(filename,'/freq');

    S11 = getComplexFromHDF5(filename,'/S11f');
    S12 = getComplexFromHDF5(filename,'/S12f');
    S21 = getComplexFromHDF5(filename,'/S21f');
    S22 = getComplexFromHDF5(filename,'/S22f');
    
    data.SCf(:,1,:) = S11;
    data.SCf(:,2,:) = S12;
    data.SCf(:,3,:) = S21;
    data.SCf(:,4,:) = S22;
    
    %get the time gated data
    S11 = getComplexFromHDF5(filename,'/S11f_gated');
    S12 = getComplexFromHDF5(filename,'/S12f_gated');
    S21 = getComplexFromHDF5(filename,'/S21f_gated');
    S22 = getComplexFromHDF5(filename,'/S22f_gated');
    
    data.SCfg(:,1,:) = S11;
    data.SCfg(:,2,:) = S12;
    data.SCfg(:,3,:) = S21;
    data.SCfg(:,4,:) = S22;
    
    
    %load the time data
    data.time = h5read(filename,'/time');

    S11 = getComplexFromHDF5(filename,'/S11t');
    S12 = getComplexFromHDF5(filename,'/S12t');
    S21 = getComplexFromHDF5(filename,'/S21t');
    S22 = getComplexFromHDF5(filename,'/S22t');
    
    data.SCt(:,1,:) = S11;
    data.SCt(:,2,:) = S12;
    data.SCt(:,3,:) = S21;
    data.SCt(:,4,:) = S22;

    data.Settings = loadSettingsFromHDF5File(filename);
end