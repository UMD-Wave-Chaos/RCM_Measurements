function Settings = gui_loadConfig()

 xDoc = xmlread('config.xml');
 
 %% load PNA settings
 pnaRoot = xDoc.getElementsByTagName('PNA_Settings');
 
 %get the number of points
 nPointsRoot = pnaRoot.item(0).getElementsByTagName('NumberOfPoints');
 nPointsElement = nPointsRoot.item(0);
 Settings.numberOfPoints =  str2num(nPointsElement.getFirstChild.getData);
 
 fstartRoot = pnaRoot.item(0).getElementsByTagName('FrequencySweepStart');
 fstartElement = fstartRoot.item(0);
 Settings.fStart =  str2num(fstartElement.getFirstChild.getData);
 
 fstopRoot = pnaRoot.item(0).getElementsByTagName('FrequencySweepStop');
 fstopElement = fstopRoot.item(0);
 Settings.fStop =  str2num(fstopElement.getFirstChild.getData);
 
 ipAddressRoot = pnaRoot.item(0).getElementsByTagName('IP_Address');
 ipAddressElement = ipAddressRoot.item(0);
 Settings.ipAddress = ipAddressElement.getFirstChild.getData;
 
 xFormStartRoot = pnaRoot.item(0).getElementsByTagName('TransformStartTime');
 xFormStartElement = xFormStartRoot.item(0);
 Settings.xformStart =  str2num(xFormStartElement.getFirstChild.getData);
 
 xformstopRoot = pnaRoot.item(0).getElementsByTagName('TransformStopTime');
 xformstopElement = xformstopRoot.item(0);
 Settings.xformStop =  str2num(xformstopElement.getFirstChild.getData);
 
 gatingStartRoot = pnaRoot.item(0).getElementsByTagName('GatingStartTime');
 gatingStartElement = gatingStartRoot.item(0);
 Settings.gateStartTime =  str2num(gatingStartElement.getFirstChild.getData);
 
 gatingstopRoot = pnaRoot.item(0).getElementsByTagName('GatingStopTime');
 gatingstopElement = gatingstopRoot.item(0);
 Settings.gateStopTime =  str2num(gatingstopElement.getFirstChild.getData);

  gmRoot = pnaRoot.item(0).getElementsByTagName('TakeGatedMeasurement');
  gmElement = gmRoot.item(0);
  gmString =  strtrim(char(gmElement.getFirstChild.getData));
  Settings.takeGatedMeasurement = gmString;
  if(strcmpi(gmString,'Yes') == true)
     gmBool = true;
  else
     gmBool = false;
  end
  
  Settings.takeGatedMeasurementBool = gmBool;

 %% get the experiment settings
 
 expRoot = xDoc.getElementsByTagName('Experiment_Settings');
  
   %get the number of realizations
 nRealRoot = expRoot.item(0).getElementsByTagName('NumberOfRealizations');
 nRealElement = nRealRoot.item(0);
 Settings.numberOfRealizations =  str2num(nRealElement.getFirstChild.getData);

 
 %get the cavity volume
 vRoot = expRoot.item(0).getElementsByTagName('CavityVolume');
 vElement = vRoot.item(0);
 Settings.cavityVolume =  str2num(vElement.getFirstChild.getData);
 
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
 Settings.COMPort =  strtrim(char(comElement.getFirstChild.getData));
 
 %get the number of steps per revolution
 nStepRoot = stepRoot.item(0).getElementsByTagName('NStepsPerRevolution');
 nStepElement = nStepRoot.item(0);
 Settings.numberOfStepsPerRevolution =  str2num(nStepElement.getFirstChild.getData);
 
  %get the direction
 dirRoot = stepRoot.item(0).getElementsByTagName('Direction');
 dirElement = dirRoot.item(0);
 Settings.direction =  str2num(dirElement.getFirstChild.getData);
 
 
 %% get any user comments
 commentRoot = xDoc.getElementsByTagName('Comments');
 commentElement = commentRoot.item(0);
 Settings.Comments =  strtrim(char(commentElement.getFirstChild.getData));
 
  
