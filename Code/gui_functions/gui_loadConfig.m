function Settings = gui_loadConfig()

 xDoc = xmlread('config.xml');
 
 %% load PNA settings
 pnaRoot = xDoc.getElementsByTagName('PNA_Settings');
 
 %get the number of points
 nPointsRoot = pnaRoot.item(0).getElementsByTagName('NumberOfPoints');
 nPointsElement = nPointsRoot.item(0);
 Settings.NOP =  str2num(nPointsElement.getFirstChild.getData);
 
 fstartRoot = pnaRoot.item(0).getElementsByTagName('FrequencySweepStart');
 fstartElement = fstartRoot.item(0);
 Settings.fStart =  str2num(fstartElement.getFirstChild.getData);
 
 fstopRoot = pnaRoot.item(0).getElementsByTagName('FrequencySweepStop');
 fstopElement = fstopRoot.item(0);
 Settings.fStop =  str2num(fstopElement.getFirstChild.getData);
 
 xformstartRoot = pnaRoot.item(0).getElementsByTagName('TimeTransformStartTime');
 xformstartElement = xformstartRoot.item(0);
 Settings.transformStart =  str2num(xformstartElement.getFirstChild.getData);
 
 xformstopRoot = pnaRoot.item(0).getElementsByTagName('TimeTransformStopTime');
 xformstopElement = xformstopRoot.item(0);
 Settings.transformStop =  str2num(xformstopElement.getFirstChild.getData);
 
 %get the ecal boolean
 ecalRoot = pnaRoot.item(0).getElementsByTagName('UseElectronicCalibrationKit');
 ecalElement = ecalRoot.item(0);
 ecalString =  strtrim(char(ecalElement.getFirstChild.getData));
 if(strcmpi(ecalString,'Yes') == true)
  Settings.electronicCalibration = true;
 else
  Settings.electronicCalibration = false;
 end

 %% get the experiment settings
 
 expRoot = xDoc.getElementsByTagName('Experiment_Settings');
  
   %get the number of realizations
 nRealRoot = expRoot.item(0).getElementsByTagName('NumberOfRealizations');
 nRealElement = nRealRoot.item(0);
 Settings.N =  str2num(nRealElement.getFirstChild.getData);
 
  %get the antenna electrical length
 lRoot = expRoot.item(0).getElementsByTagName('AntennaElectrialLength');
 lElement = lRoot.item(0);
 Settings.l =  str2num(lElement.getFirstChild.getData);
 
 %get the cavity volume
 vRoot = expRoot.item(0).getElementsByTagName('CavityVolume');
 vElement = vRoot.item(0);
 Settings.V =  str2num(vElement.getFirstChild.getData);
 
  %get the datestamp boolean
  dsRoot = expRoot.item(0).getElementsByTagName('TimeDateStamp');
  dsElement = dsRoot.item(0);
  dsString =  strtrim(char(dsElement.getFirstChild.getData));
  if(strcmpi(dsString,'Yes') == true)
     dsBool = true;
  else
     dsBool = false;
  end
 
 %get the file name prefix
 fnRoot = expRoot.item(0).getElementsByTagName('FileNamePrefix');
 fnElement = fnRoot.item(0);
 fnPrefix =  strtrim(char(fnElement.getFirstChild.getData));
 
 if dsBool == true
     Settings.fileName = sprintf('%s_%s.h5',fnPrefix,datestr(now,30)); 
 else
     Settings.fileName = sprintf('%s.h5',fnPrefix); 
 end
 
 
 %% get the stepper motor settings
 
 stepRoot = xDoc.getElementsByTagName('StepperMotor_Settings');
 
 %get the COM port
 comRoot = stepRoot.item(0).getElementsByTagName('COMport');
 comElement = comRoot.item(0);
 Settings.comPort =  strtrim(char(comElement.getFirstChild.getData));
 
 %get the number of steps per revolution
 nStepRoot = stepRoot.item(0).getElementsByTagName('NStepsPerRevolution');
 nStepElement = nStepRoot.item(0);
 Settings.nStepsPerRevolution =  str2num(nStepElement.getFirstChild.getData);
 
  %get the direction
 dirRoot = stepRoot.item(0).getElementsByTagName('Direction');
 dirElement = dirRoot.item(0);
 Settings.direction =  str2num(dirElement.getFirstChild.getData);
 
 %% get the analysis settings
  analRoot = xDoc.getElementsByTagName('Analysis_Settings');

 %get the number of RCM realizations
 nRCMRoot = analRoot.item(0).getElementsByTagName('NumberOfRCMRealizations');
 nRCMElement = nRCMRoot.item(0);
 Settings.nRCM =  str2double(nRCMElement.getFirstChild.getData);
 
  %get the number of bins
 nbinRoot = analRoot.item(0).getElementsByTagName('NumberOfBinsForHistograms');
 nbinElement = nbinRoot.item(0);
 Settings.nBins =  str2double(nbinElement.getFirstChild.getData);
 
 
 
 %% get any user comments
 commentRoot = xDoc.getElementsByTagName('Comments');
 commentElement = commentRoot.item(0);
 Settings.Comments =  strtrim(char(commentElement.getFirstChild.getData));
 
  
