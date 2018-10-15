function logSettings(handles)

logMessage(handles.jEditbox,'Configuration:')

sString = sprintf('Number of Points: %d',handles.Settings.NOP);
logMessage(handles.jEditbox,sString);

sString = sprintf('Number of Realizations: %d',handles.Settings.N);
logMessage(handles.jEditbox,sString);

sString = sprintf('COM Port: %s',handles.Settings.comPort);
logMessage(handles.jEditbox,sString);

if (handles.Settings.electronicCalibration == true)
    result = 'true';
else
    result = 'false';
end
sString = sprintf('Use Electronic Calibration: %s',result);
logMessage(handles.jEditbox,sString);

sString = sprintf('File Name: %s',handles.Settings.fileName);
logMessage(handles.jEditbox,sString);

sString = sprintf('Antenna Electrical Length: %s',handles.Settings.l);
logMessage(handles.jEditbox,sString);

sString = sprintf('Cavity Volume: %s',handles.Settings.V);
logMessage(handles.jEditbox,sString);

sString = sprintf('Number of RCM Realizations: %d',handles.Settings.nRCM);
logMessage(handles.jEditbox,sString);