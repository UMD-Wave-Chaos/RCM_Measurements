function  saveComplexToHDF5(var,filename,varname)

rname = sprintf('%s_real',varname);
iname = sprintf('%s_imag',varname);

h5create(filename,rname,size(real(var)));
h5write(filename,rname,real(var));
h5create(filename,iname,size(imag(var)));
h5write(filename,iname,imag(var));