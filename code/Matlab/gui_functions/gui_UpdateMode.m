function handles = gui_UpdateMode(mode,handles)

handles.mode = mode;
%setfield(handles.guiTimer,'UserData', mode);
gui_updateStatusMessage(handles,'');

set(handles.modeText,'String',mode);
%get the background color for the mode
switch(mode)
    case('Idle')
        color = 'white';
    otherwise
        color = 'yellow';
end

set(handles.modeText,'BackgroundColor',color);
%pause to allow time for the gui to update
pause(0.1);
guidata(handles.hfig,handles);