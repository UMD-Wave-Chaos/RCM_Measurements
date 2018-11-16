
function  saveComplexToHDF5(var,filename,varname)

rname = sprintf('%s_real',varname);
iname = sprintf('%s_imag',varname);

h5create(filename,varname,size(real(var)));
h5write(filename,varname,real(var));
h5create(filename,varname,size(imag(var)));
h5write(filename,varname,imag(var));