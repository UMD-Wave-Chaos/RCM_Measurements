function gui_mainWindow 

revString = 'RCM Measuremnt Gui, Revision 0.1, Modified 10/10/2018';

%add the javapath for the chart library
%javaaddpath jfreechart-1.0.19/lib/

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
handles.pnaConnection = false;
handles.mode = 'Initializing';

%save the handles to the guidata object
guidata(hfig,handles);

%create staus bar
%handles = gui_CreateStatusBar(handles);
%guidata(hfig,handles);


editWidth = 750;
editHeight = 200;
editX = buffer;
editY = buffer + 20;
gui_updateStatusMessage(handles,'Logging Display ...');
hEditbox = uicontrol('Style','Edit','Max',5,'Position',[editX,editY, editWidth, editHeight],'Parent',hfig);
pause(0.1);
jScrollPane = findjobj(hEditbox);
jViewport = jScrollPane.getViewport;
handles.jEditbox = jViewport.getComponent(0);
handles.jEditbox.setBorder(javax.swing.BorderFactory.createLineBorder(java.awt.Color.black));
handles.jEditbox.setBorder(javax.swing.BorderFactory.createEtchedBorder(javax.swing.border.EtchedBorder.LOWERED, ...
                                                              java.awt.Color.gray, ...
                                                              java.awt.Color.darkGray));    
                                                          
logMessage(handles.jEditbox,'Initializing ...');

%% Remaining initialization goes here

%load the configuration
logMessage(handles.jEditbox,'Loading configuration file ...')
handles.Settings = gui_loadConfig();
logSettings(handles);
guidata(hfig,handles);

%create the section to house the status
statusHeight = 150;
statusWidth = gui_Width-2*buffer;
statusX = buffer;
statusY = editY + buffer + editHeight;
handles = gui_createStatusSection(handles,statusX,statusY,statusWidth,statusHeight,buffer);
guidata(hfig,handles);

%create the section to house the plots
plotHeight = 300;
plotWidth = gui_Width-2*buffer;
plotX = buffer;
plotY = statusY + buffer + statusHeight;
handles = gui_createPlotSection(handles,plotX,plotY,plotWidth,plotHeight,buffer);
guidata(hfig,handles);

%create the section to house the controls
controlWidth = gui_Width-3*buffer-editWidth;
controlHeight = editHeight;
controlX = editX + buffer + editWidth;
controlY = editY;
handles = gui_createControlSection(handles,controlX,controlY,controlWidth,controlHeight,buffer);
guidata(hfig,handles);

%attach callbacks to the controls
gui_updateStatusMessage(handles,'Callbacks ...');
%main figure
set(hfig,'CloseRequestFcn',{@closeRequest});
set(handles.measureButton,'Callback',{@measure_Callback});
set(handles.analyzeButton,'Callback',{@analyze_Callback});
set(handles.reloadConfigButton,'Callback',{@reloadConfig_Callback});
set(handles.editConfigButton,'Callback',{@editConfig_Callback});
set(handles.calibrateConfigButton,'Callback',{@calibrate_Callback});

%connect to PNA
logMessage(handles.jEditbox,'Connecting to PNA ...');
try
    [handles.pnaObj,handles.pnaConnection,handles.pnaConnectionType] = connectToPNA();
catch err
     logMessage(handles.jEditbox,err.message,'error');
end
if(handles.pnaConnection == true)
    lstring = sprintf('Connected to PNA, type = %s',handles.pnaConnectionType);
    ltype = 'info';
    set(handles.pnaConnectionText,'String',handles.pnaConnectionType);
    set(handles.pnaConnectionText,'BackgroundColor','green');
else
    set(handles.pnaConnectionText,'String','Not Connected');
    set(handles.pnaConnectionText,'BackgroundColor','red');
    lstring = 'Unable to connect to PNA';
    ltype = 'error';
end
logMessage(handles.jEditbox,lstring,ltype);
guidata(hfig,handles);

%connect to Stepper Motor
try
    handles.sObj = connectToStepperMotor(handles.Settings.comPort);
    handles.sConnection = true;
catch err
    logMessage(handles.jEditbox,err.message,'error');
    handles.sConnection = false;
end
if handles.sConnection == true 
    lstring = 'Connected to stepper motor';
    ltype = 'info';
    set(handles.sConnectionText,'String','Connected');
    set(handles.sConnectionText,'BackgroundColor','green');
    pos = getStepperMotorPosition(handles.sConnection);
    set(handles.sPositionText,'String',num2str(pos));
else
    lstring = 'Unable to connect to stepper motor';
    ltype = 'error';
    set(handles.sConnectionText,'String','Not Connected');
    set(handles.sConnectionText,'BackgroundColor','red');
end
logMessage(handles.jEditbox,lstring,ltype);
guidata(hfig,handles);

%complete and ready to go
logMessage(handles.jEditbox,'Ready ...');
handles = gui_UpdateMode('Idle',handles);
guidata(hfig,handles);

%define all the callback functions
%% closeRequest
function closeRequest(hObject,event)
handles = guidata(gcf);

handles = gui_UpdateMode('Closing',handles);

%closeRequest needs to do all cleanup and delete the figure
%stop(handles.guiTimer);
%delete(handles.guiTimer);

if (handles.pnaConnection == true)
    fclose(handles.pnaObj);
end

if (handles.sConnection == true)
    fclose(handles.sObj);
end
delete(handles.hfig);

%% measure
function calibrate_Callback(hObject,event)
handles = guidata(gcf);

handles = gui_UpdateMode('Measuring',handles);
calName = 'calibrationTest';

try
    calibratePNA(handles.pnaObj,handles.Settings.fStart, handles.Settings.fStop, calName, handles.Settings.NOP,2);
 
catch err
     logError(handles.jEditbox,err);
end

handles = gui_UpdateMode('Idle',handles);
logMessage(handles.jEditbox,'Ready');

%% measure
function measure_Callback(hObject,event)
handles = guidata(gcf);

handles = gui_UpdateMode('Measuring',handles);

try
    [handles.t, handles.SCt, handles.Freq, handles.SCf, handles.Srad] = measureData(handles.pnaObj,...
                                                                                    handles.sObj,...
                                                                                    handles.Settings, ...
                                                                                    handles);
catch err
     logError(handles.jEditbox,err);
end

lstring = sprintf('Saving data to %s',handles.Settings.fileName);
logMessage(handles.jEditbox,lstring);
saveData(handles.t, handles.SCt, handles.Freq, handles.SCf, handles.Srad, handles.Settings);

clear(handles.t,handles.SCt,handles.Freq,handles.SCf,handles.Srad);

handles = gui_UpdateMode('Idle',handles);
logMessage(handles.jEditbox,'Ready');

%% Reload Config
function reloadConfig_Callback(hObject,event)
handles = guidata(gcf);
handles.Settings = gui_loadConfig();
logSettings(handles);
guidata(gcf,handles);

%%Edit Config
function editConfig_Callback(hObject,event)
handles = guidata(gcf);
edit('config.xml');
handles = gui_UpdateMode('Idle',handles);
logMessage(handles.jEditbox,'Make sure to reload the config file','warn');

%% analyze 
function analyze_Callback(hObject,event)
handles = guidata(gcf);

handles = gui_UpdateMode('Analyzing',handles);

[filename, pathname] = uigetfile('*.h5','Load an HDF5 file with RCM data');

if filename ~= 0
    fname = fullfile(pathname,filename);
    try
        analyzeResults(fname,handles);
    catch err
         logError(handles.jEditbox,err);
    end
end

handles = gui_UpdateMode('Idle',handles);
logMessage(handles.jEditbox,'Ready');
