function Settings = loadSettingsFromHDF5File(fileName)

Settings.fileName = fileName;
Settings.NOP = h5readatt(fileName,'/','Npoints');
Settings.N = h5readatt(fileName,'/','Nrealizations');
Settings.comPort = h5readatt(fileName,'/','ComPort');

Settings.Comments = strtrim(h5readatt(fileName,'/','Comments'));
Settings.V = h5readatt(fileName,'/','V');
Settings.l = h5readatt(fileName,'/','l');
Settings.nRCM = h5readatt(fileName,'/','nRCM');

Settings.fStart = h5readatt(fileName,'/','fStart');
Settings.fStop = h5readatt(fileName,'/','fStop');
Settings.nStepsPerRevolution = h5readatt(fileName,'/','nStepsPerRevolution');
Settings.direction = h5readatt(fileName,'/','direction');