function out = getComplexFromHDF5(filename,varname)

%load the data
rString = sprintf('%s_real',varname);
iString = sprintf('%s_imag',varname);

realPart = h5read(filename,rString);
imagPart = h5read(filename,iString);

out = realPart + 1j*imagPart;