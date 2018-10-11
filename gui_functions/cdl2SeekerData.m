function seekerData = cdl2SeekerData(data,seekerData,index)

%need to set the update to true for event crossings
%only set this true, do NOT set it to false
eventCrossing = false;
if eventCrossing == true
    seekerData.updateLimits = true;
end

%populate fields from CDL file at the corresponding index
seekerData.currentTime = index/60;

%receiver data
seekerData.rdmData = 20*log10((1e-1*randn(256,64)).^2);
seekerData.mofnData = 20*log10((1e-1*randn(256,64)).^2);
seekerData.g1Data = 20*log10((1e-1*randn(256,1)).^2);
seekerData.g2Data = 20*log10((1e-1*randn(256,1)).^2);

%trajectory data
seekerData.currentAlt = randn(1,1);
seekerData.currentTrajX = randn(1,1);
seekerData.currentTrajY = randn(1,1);
seekerData.currentExpectedTargetX = randn(1,1);
seekerData.currentExpectedTargetY = randn(1,1);
seekerData.currentSquint = randn(1,1);

%gimbal data
seekerData.currentAz = randn(1,1);
seekerData.currentEl = randn(1,1);
seekerData.currentAzError = randn(1,1);
seekerData.currentElError = randn(1,1);

%target data
seekerData.targetAzData = randn(1,1);
seekerData.targetElData = randn(1,1);
seekerData.targetRangeData = randn(1,1);
seekerData.targetDopplerData = randn(1,1);

%tracker data
seekerData.rangeGatePos = randn(1,1);
seekerData.ucRadius = randn(1,1);
seekerData.stcGain = randn(1,1);
seekerData.agcGain = randn(1,1);
seekerData.horizonRange = randn(1,1);

seekerData.cv1 = 20*log10((1e-1*randn(1,1)).^2);
seekerData.cv2 = 20*log10((1e-1*randn(1,1)).^2);
seekerData.cv3 = 20*log10((1e-1*randn(1,1)).^2);

%general data
seekerData.gimbalMode = 'test mode 2';
seekerData.seekerMode = 'test mode';
seekerData.seekerSubMode = 'test sub mode';

%compute limits
seekerData.rdmAxisXLimit = [1 256];
seekerData.rdmAxisYLimit = [1 64];
 
seekerData.azAxisYLimit = [-4 4];   
seekerData.elAxisYLimit = [-4 4];
seekerData.g1AxisXLimit = [1 256];
seekerData.g1AxisYLimit = [-80 0];
seekerData.g2AxisXLimit = [1 256];
seekerData.g2AxisYLimit = [-80 0];
seekerData.errorAxisYLimit = [-4 4];
seekerData.errorAxisYLimit = [-4 4];
seekerData.altAxisYLimit = [-4 4];
seekerData.squintAxisYLimit = [-4 4];

seekerData.trajAxisXLimit = [-4 4];
seekerData.trajAxisYLimit = [-4 4];
end

