function handles = gui_UpdateMode(mode,handles)

handles.mode = mode;
setfield(handles.guiTimer,'UserData', mode);
gui_updateStatusMessage(handles,'');
guidata(handles.hfig,handles);