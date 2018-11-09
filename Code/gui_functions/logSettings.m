function logSettings(handles)

logMessage(handles.jEditbox,'Configuration:','info')

sString = sprintf('Number of Points: %d',handles.Settings.NOP);
logMessage(handles.jEditbox,sString);

sString = sprintf('Number of Realizations: %d',handles.Settings.N);
logMessage(handles.jEditbox,sString);

sString = sprintf('COM Port: %s',handles.Settings.comPort);
logMessage(handles.jEditbox,sString);

sString = sprintf('File Name: %s',handles.Settings.fileName);
logMessage(handles.jEditbox,sString);

sString = sprintf('Antenna Electrical Length: %s',handles.Settings.l);
logMessage(handles.jEditbox,sString);

sString = sprintf('Cavity Volume: %s',handles.Settings.V);
logMessage(handles.jEditbox,sString);

sString = sprintf('Number of RCM Realizations: %d',handles.Settings.nRCM);
logMessage(handles.jEditbox,sString);

sString = sprintf('Frequency Sweep Start: %0.2f GHz',handles.Settings.fStart*1e-9);
logMessage(handles.jEditbox,sString);

sString = sprintf('Frequency Sweep Stop: %0.2f GHz',handles.Settings.fStop*1e-9);
logMessage(handles.jEditbox,sString);

sString = sprintf('Stepper Motor Number of Steps Per Revolution: %d',handles.Settings.nStepsPerRevolution);
logMessage(handles.jEditbox,sString);

sString = sprintf('Stepper Motor Direction: %d',handles.Settings.direction);
logMessage(handles.jEditbox,sString);