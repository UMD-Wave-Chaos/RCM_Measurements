function gui_mainWindow 

revString = 'RCM Measuremnt Gui, Revision 0.1, Modified 10/10/2018';


%add the javapath for the chart library
javaaddpath jfreechart-1.0.19/lib/

%import java gui utilities
import java.awt.BasicStroke;
import java.awt.BorderLayout;
import java.awt.Dimension;

import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.JSlider;
import javax.swing.event.ChangeEvent;
import javax.swing.event.ChangeListener;

gui_Width = 1000;
gui_Height = 1200;
buffer = 10;

%create the initial figure - force units to pixels to prevent control
%placement issues with normalized units
hfig = figure('Position',[20,50,gui_Width,gui_Height],'Units','pixels','NumberTitle','off','Name','RCM Measurement GUI');
%remove default menu bar
set(hfig,'menuBar','none');

%setup the guidata handles w/ general info
handles = guihandles(hfig);
handles.hfig = hfig;
handles.iconFolder = 'icons/';
handles.backgroundColor = java.awt.Color(61/255, 89/255, 171/255);
handles.panelColor = java.awt.Color(72/255, 118/255, 255/255);
handles.hPanelColor = [72/255, 118/255, 255/255];
handles.hStatusColor = 1/256*[192 192 192];
handles.windowsColor = java.awt.Color.lightGray;
handles.helpString = revString;
handles.mode = 'Initializing';

%save the handles to the guidata object
guidata(hfig,handles);

%create staus bar
handles = gui_CreateStatusBar(handles);
guidata(hfig,handles);

%create the section to house the plots
plotHeight = 800;
plotWidth = gui_Width-2*buffer;
plotX = buffer;
plotY = gui_Height - plotHeight - buffer;
handles = gui_createPlotSection(handles,plotX,plotY,plotWidth,plotHeight,buffer);
guidata(hfig,handles);

%create the section to house the status
statusHeight = 200;
statusWidth = gui_Width-2*buffer;
statusX = buffer;
statusY = plotY - statusHeight - buffer;
handles = gui_createStatusSection(handles,statusX,statusY,statusWidth,statusHeight,buffer);
guidata(hfig,handles);

%create the section to house the controls
controlWidth = gui_Width-2*buffer;
controlHeight = 160;
controlX = buffer;
controlY = statusY - controlHeight - buffer;
handles = gui_createControlSection(handles,controlX,controlY,controlWidth,controlHeight,buffer);
guidata(hfig,handles);

%attach callbacks to the controls
set(handles.statusBar,'Text','Initializing ... Callbacks ...');
%main figure
set(hfig,'CloseRequestFcn',{@closeRequest});
set(handles.runButton,'Callback',{@run_Callback});


set(handles.statusBar,'Text','Initializing ... GUI Timer ...');
handles.guiTimer = timer('Name','guiTimer');
handles.guiTimer.TimerFcn = {@guiTimerCallback,handles};
handles.guiTimer.Period = 0.1;
handles.guiTimer.ExecutionMode = 'fixedSpacing';
handles.guiTimer.UserData = handles.mode;
start(handles.guiTimer);

%complete and ready to go
set(handles.statusBar,'Text','Ready');
guidata(hfig,handles);

%define all the callback functions
%% closeRequest
function closeRequest(hObject,event)
handles = guidata(gcf);

handles = gui_UpdateMode('Closing',handles);

%closeRequest needs to do all cleanup and delete the figure
stop(handles.guiTimer);
delete(handles.guiTimer);

delete(handles.hfig);

%% run
function run_Callback(hObject,event)
handles = guidata(gcf);

handles = gui_UpdateMode('Running',handles);

disp(handles.mode)



%panel under the different interfaces
% set(handles.statusBar,'Text','Initializing ... Panels ...');
% jPanel = javacomponent(javax.swing.JPanel,[10,330,gui_Width - 2*buffer,600],hfig);
% hPanel = handle(jPanel);
% set(hPanel,'Background',handles.panelColor);