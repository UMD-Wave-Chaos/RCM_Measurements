function logSettings(handles)

logMessage(handles.jEditbox,'Configuration:','info')

sString = sprintf('Number of Points: %d',handles.Settings.numberOfPoints);
logMessage(handles.jEditbox,sString);

sString = sprintf('Number of Realizations: %d',handles.Settings.numberOfRealizations);
logMessage(handles.jEditbox,sString);

sString = sprintf('COM Port: %s',handles.Settings.COMPort);
logMessage(handles.jEditbox,sString);

sString = sprintf('File Name: %s',handles.Settings.fileName);
logMessage(handles.jEditbox,sString);

sString = sprintf('Cavity Volume: %s',handles.Settings.cavityVolume);
logMessage(handles.jEditbox,sString);

sString = sprintf('Frequency Sweep Start: %0.2f GHz',handles.Settings.fStart*1e-9);
logMessage(handles.jEditbox,sString);

sString = sprintf('Frequency Sweep Stop: %0.2f GHz',handles.Settings.fStop*1e-9);
logMessage(handles.jEditbox,sString);

sString = sprintf('Stepper Motor Number of Steps Per Revolution: %d',handles.Settings.numberOfStepsPerRevolution);
logMessage(handles.jEditbox,sString);
