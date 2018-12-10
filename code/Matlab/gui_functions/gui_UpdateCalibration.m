function [handles,validCal] = gui_UpdateCalibration(pnaObj,handles)

calFileName = strtrim(query(pnaObj,'SENSe:CORRection:CSET:DESC?'));
tString = calFileName(2:end-1);

if (strcmpi('No Cal Set selected',tString))
    color = 'red';
    validCal = false;
else
    color = 'green';
    validCal = true;
end
    

set(handles.calibrationText,'BackgroundColor',color);
set(handles.calibrationText,'String',tString);

%pause to allow time for the gui to update
pause(0.1);
guidata(handles.hfig,handles);
