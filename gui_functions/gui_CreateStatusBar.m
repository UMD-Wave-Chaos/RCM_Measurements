function handles = gui_CreateStatusBar(handles)

%create the status bar
%get the underlying java frame
jFrame = get(handle(handles.hfig),'JavaFrame');
%need to pause, otherwise the root pane function call fails
pause(0.1);
jRootPane = jFrame.fHG2Client.getWindow;
%create the status bar java object
statusbarObj = com.mathworks.mwswing.MJStatusBar;
%convert to Matlab HG handle
handles.statusBar = handle(statusbarObj);
%set the status bar
jRootPane.setStatusBar(statusbarObj);

%get the components to customize the status bar
statusBarTxt = statusbarObj.getComponent(0);
%convert to Matlab HG
handles.statusBarTxt = handle(statusBarTxt);

%get the Corner Grip
cornerGrip = statusbarObj.getParent.getComponent(0);
%hide the Corner Grip
cornerGrip.setVisible(false);
%set the border
set(handles.statusBar,'Border',javax.swing.BorderFactory.createLoweredBevelBorder());
set(handles.statusBar,'Text','Initializing ...');
set(handles.statusBarTxt,'Background',java.awt.Color.lightGray);
set(handles.statusBarTxt,'Foreground',java.awt.Color.black);