function saveSettings(Settings)

h5writeatt(Settings.fileName,'/','Npoints',Settings.NOP);
h5writeatt(Settings.fileName,'/','Nrealizations',Settings.N);
h5writeatt(Settings.fileName,'/','ComPort',Settings.comPort);

h5writeatt(Settings.fileName,'/','Comments',Settings.Comments);
h5writeatt(Settings.fileName,'/','V',Settings.V);
h5writeatt(Settings.fileName,'/','l',Settings.l);
h5writeatt(Settings.fileName,'/','nRCM',Settings.nRCM);
h5writeatt(Settings.fileName,'/','nBins',Settings.nBins);

h5writeatt(Settings.fileName,'/','fStart',Settings.fStart);
h5writeatt(Settings.fileName,'/','fStop',Settings.fStop);
h5writeatt(Settings.fileName,'/','nStepsPerRevolution',Settings.nStepsPerRevolution);
h5writeatt(Settings.fileName,'/','direction',Settings.direction);