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