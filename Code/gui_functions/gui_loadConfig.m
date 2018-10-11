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
 