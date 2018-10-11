function gui_updateStatusMessage(handles,message)

message = sprintf('%s ... %s',handles.mode,message);
set(handles.statusBar,'Text',message);