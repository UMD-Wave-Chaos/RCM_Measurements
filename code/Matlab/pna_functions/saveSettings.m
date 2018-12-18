function saveSettings(Settings)

%check to see if the file exists, if not create it
if ~exist(Settings.fileName,'file')
    H5F.create(Settings.fileName);
end

%create the Settings group
H5G.create(Settings.fileName,'Settings',8)

%now write the Settings
h5writeatt(Settings.fileName,'/Settings','numberOfPoints',Settings.NOP);
h5writeatt(Settings.fileName,'/Settings','numberOfRealizations',Settings.N);
h5writeatt(Settings.fileName,'/Settings','COMPort',Settings.comPort);

h5writeatt(Settings.fileName,'/Settings','comments',Settings.Comments);
h5writeatt(Settings.fileName,'/Settings','cavityVolume',Settings.cavityVolume);

h5writeatt(Settings.fileName,'/Settings','fStart',Settings.fStart);
h5writeatt(Settings.fileName,'/Settings','fStop',Settings.fStop);
h5writeatt(Settings.fileName,'/Settings','numberOfStepsPerRevolution',Settings.nStepsPerRevolution);

h5writeatt(Settings.fileName,'/Settings','ipAddress',Settings.ipAddress);
h5writeatt(Settings.fileName,'/Settings','movementTime',Settings.movementTime);
h5writeatt(Settings.fileName,'/Settings','settlingTime',Settings.settlingTime);

h5writeatt(Settings.fileName,'/Settings','xformStartTime',Settings.xformStartTime);
h5writeatt(Settings.fileName,'/Settings','xformStopTime',Settings.xformStopTime);

if Settings.takeGatedMeasurement == true
    h5writeatt(Settings.fileName,'/Settings','gateStartTime',Settings.gateStartTime);
    h5writeatt(Settings.fileName,'/Settings','gateStopTime',Settings.gateStopTime);
    h5writeatt(Settings.fileName,'/Settings','takeGatedMeasurement','Yes');
else
    h5writeatt(Settings.fileName,'/Settings','takeGatedMeasurement','No');
end

h5writeatt(Settings.fileName,'/Settings','waitTime_ms',Settings.waitTime_ms);