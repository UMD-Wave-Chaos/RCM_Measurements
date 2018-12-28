function Settings = loadSettingsFromHDF5File(fileName)

Settings.fileName = fileName;
Settings.NOP = h5readatt(fileName,'/Settings','numberOfPoints');
Settings.N = h5readatt(fileName,'/Settings','numberOfRealizations');
Settings.comPort = h5readatt(fileName,'/Settings','COMPort');

Settings.Comments = strtrim(h5readatt(fileName,'/Settings','comments') );
Settings.V = h5readatt(fileName,'/Settings','cavityVolume');

Settings.fStart = h5readatt(fileName,'/Settings','fStart');
Settings.fStop = h5readatt(fileName,'/Settings','fStop');
Settings.nStepsPerRevolution = h5readatt(fileName,'/Settings','numberOfStepsPerRevolution');