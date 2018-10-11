function handles = gui_UpdateMode(mode,handles)

handles.mode = mode;
setfield(handles.guiTimer,'UserData', mode);

guidata(handles.hfig,handles);