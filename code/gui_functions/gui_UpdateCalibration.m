function handles = gui_UpdateCalibration(pnaObj,handles)

calFileName = query(pnaObj,'SENSe:CORRection:CSET:DESC?');

if isempty(calFileName)
    color = 'red';
    statusString = 'Not Calibrated';
else
    color = 'green';
    statusString = calFileName;
end
    

set(handles.calibrationText,'BackgroundColor',color);
set(handles.calibrationText,'Text',statusString);

%pause to allow time for the gui to update
pause(0.1);
guidata(handles.hfig,handles);