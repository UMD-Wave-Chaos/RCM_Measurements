function Settings = gui_loadConfig()

 xDoc = xmlread('config.xml');
 
 %get the number of points
 nPointsRoot = xDoc.getElementsByTagName('NumberOfPoints');
 nPointsElement = nPointsRoot.item(0);
 Settings.NOP =  str2num(nPointsElement.getFirstChild.getData);
 
 %get the number of realizations
 nRealRoot = xDoc.getElementsByTagName('NumberOfRealizations');
 nRealElement = nRealRoot.item(0);
 Settings.N =  str2num(nRealElement.getFirstChild.getData);
 
 %get the COM port
 comRoot = xDoc.getElementsByTagName('COMport');
 comElement = comRoot.item(0);
 Settings.comPort =  strtrim(char(comElement.getFirstChild.getData));
 
 %get the boolean for manual/electronic calibration
 calRoot = xDoc.getElementsByTagName('ElectronicCalibration');
 calElement = calRoot.item(0);
 calString =  strtrim(char(calElement.getFirstChild.getData));
 if(strcmpi(calString,'Yes') == true)
     Settings.electronicCalibration = true;
 else
     Settings.electronicCalibration = false;
 end
 
 %get the antenna electrical length
 lRoot = xDoc.getElementsByTagName('AntennaElectrialLength');
 lElement = lRoot.item(0);
 Settings.l =  str2num(lElement.getFirstChild.getData);
 
 %get the cavity volume
 vRoot = xDoc.getElementsByTagName('CavityVolume');
 vElement = vRoot.item(0);
 Settings.V =  str2num(vElement.getFirstChild.getData);
 
  %get the boolean for manual/electronic calibration
 dsRoot = xDoc.getElementsByTagName('TimeDateStamp');
 dsElement = dsRoot.item(0);
 dsString =  strtrim(char(dsElement.getFirstChild.getData));
 if(strcmpi(dsString,'Yes') == true)
     dsBool = true;
 else
     dsBool = false;
 end
 
 %get the file name prefix
 fnRoot = xDoc.getElementsByTagName('FileNamePrefix');
 fnElement = fnRoot.item(0);
 fnPrefix =  strtrim(char(fnElement.getFirstChild.getData));
 
 if dsBool == true
     Settings.fileName = sprintf('%s%s.h5',fnPrefix,datestr(now,30)); 
 else
     Settings.fileName = sprintf('%s.h5',fnPrefix); 
 end
 
 %get any user comments
 commentRoot = xDoc.getElementsByTagName('Comments');
 commentElement = commentRoot.item(0);
 Settings.Comments =  char(commentElement.getFirstChild.getData);
 
  %get the number of RCM realizations
 nRCMRoot = xDoc.getElementsByTagName('NumberOfRCMRealizations');
 nRCMElement = nRCMRoot.item(0);
 Settings.nRCM =  str2num(nRCMElement.getFirstChild.getData);
 