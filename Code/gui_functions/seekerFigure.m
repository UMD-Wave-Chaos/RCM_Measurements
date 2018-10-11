function handles = seekerFigure(varargin)

%% check for a parent input - this is TBD for future analysis GUI
parent = [];
if nargin == 1
    parent = varargin{1};
end
%% setup the overall figure
width = 1640;
height = 1300;

if (isempty(parent))
    hfig = figure('Position',[100,100,width, height],'Units','pixels','NumberTitle','off','Name','ATEP-1 V4.0 Seeker Data');
else
    hfig = parent;
end
%remove default menu bar
set(hfig,'menuBar','none');

%initialize the handles
handles = guihandles(hfig);
handles.hfig = hfig;
handles.backgroundColor = [0.9400 0.9400 0.9400];
handles.panelColor = 1/256*[192 192 192];

%% Initialize some default sizes, buffers, and offsets
% 'Position' is entered in [left bottom width height]
%setup default positional values
bigWidth = 400;
bigHeight = 400;
smallWidth = 400;
smallHeight = 150;
buffer = 100;
topLimit = height - buffer; %entered relative to the bottom
borderBuffer = 50;

%% setup the panel and axes for the recevier data
panelWidth = 2*bigWidth + smallWidth + 3*buffer + borderBuffer;
panelHeight = bigHeight + buffer;
panelBottom = topLimit - bigHeight - 20;
panelLeft = borderBuffer;
handles.hReceiverPanel = uipanel('Parent',handles.hfig,'Units','pixels','Title','Receiver Data','FontSize',12,'BackgroundColor',handles.panelColor,...
                         'Position',[panelLeft panelBottom panelWidth  panelHeight], ...
                         'BorderType','beveledin','FontWeight','bold','BorderWidth',3);
         
%rdm axis
handles.rdmAxis = axes('Units','pixels','Position',[buffer borderBuffer bigWidth bigHeight],'Parent',handles.hReceiverPanel);
handles.rdmPlot = imagesc(handles.rdmAxis,[1:256],[1:64],zeros(256,64),[-80 0]);
set(handles.rdmAxis,'LineWidth',2)
set(handles.rdmAxis,'FontSize',12)
set(handles.rdmAxis,'FontWeight','bold')
title('Range Doppler Map')
xlabel('Range Bin')
ylabel('Doppler Bin')
grid(handles.rdmAxis,'on')
set(handles.rdmAxis,'XLim',[1 256]);
set(handles.rdmAxis,'YLim',[1 64]);
colormap(handles.rdmAxis,jet(256));
cbh = colorbar(handles.rdmAxis);
tcbh = get(cbh,'Label');
tcbh.String = 'dB';

%mofn axis
handles.mofnAxis = axes('Units','pixels','Position',[2*buffer + bigWidth borderBuffer bigWidth bigHeight],'Parent',handles.hReceiverPanel);
handles.mofnPlot = imagesc(handles.mofnAxis,[1:256],[1:64],zeros(256,64),[-80 0]);
set(handles.mofnAxis,'LineWidth',2)
set(handles.mofnAxis,'FontSize',12)
set(handles.mofnAxis,'FontWeight','bold')
title('M of N Map')
xlabel('Range Bin')
ylabel('Doppler Bin')
grid(handles.mofnAxis,'on')
set(handles.mofnAxis,'XLim',[1 256]);
set(handles.mofnAxis,'YLim',[1 64]);
colormap(handles.mofnAxis,jet(256));
cbh = colorbar(handles.mofnAxis);
tcbh = get(cbh,'Label');
tcbh.String = 'dB';

%gate 1 axis
handles.gate1Axis = axes('Units','pixels','Position',[3*buffer + 2*bigWidth borderBuffer + buffer + smallHeight smallWidth smallHeight],'Parent',handles.hReceiverPanel);
handles.gate1Plot = plot(handles.gate1Axis,zeros(1,256),'LineWidth',2);
title('Gate 1')
xlabel('Range Bin')
ylabel('Power (dB)')
set(handles.gate1Axis,'XLim',[1 256]);
set(handles.gate1Axis,'YLim',[-80 0]);
grid(handles.gate1Axis,'on')
set(handles.gate1Axis,'LineWidth',2)
set(handles.gate1Axis,'FontSize',12)
set(handles.gate1Axis,'FontWeight','bold')

%gate 2 axis
handles.gate2Axis = axes('Units','pixels','Position',[3*buffer + 2*bigWidth borderBuffer smallWidth smallHeight],'Parent',handles.hReceiverPanel);
handles.gate2Plot = plot(handles.gate2Axis,zeros(1,256),'LineWidth',2);
title('Gate 2')
xlabel('Range Bin')
ylabel('Power (dB)')
set(handles.gate2Axis,'XLim',[1 256]);
set(handles.gate2Axis,'YLim',[-80 0]);
grid(handles.gate2Axis,'on')
set(handles.gate2Axis,'LineWidth',2)
set(handles.gate2Axis,'FontSize',12)
set(handles.gate2Axis,'FontWeight','bold')

%% setup the panel and axes for the gimbal data
panelHeight = smallHeight + buffer;
panelBottom = panelBottom - 3*buffer + 40;

handles.hGimbalPanel = uipanel('Parent',handles.hfig,'Units','pixels','Title','Gimbal Data','FontSize',12,'BackgroundColor',handles.panelColor,...
                         'Position',[panelLeft panelBottom panelWidth  panelHeight], ...
                         'BorderType','beveledin','FontWeight','bold','BorderWidth',3);
                     
%gimbal az axis
handles.azAxis = axes('Units','pixels','Position',[buffer borderBuffer smallWidth smallHeight],'Parent',handles.hGimbalPanel);
handles.azPlot = plot(handles.azAxis,zeros(1,256),'b','LineWidth',2);
hold(handles.azAxis,'on');
handles.azScatterPlot = scatter(handles.azAxis,0,0,70,'b','filled');
set(handles.azAxis,'LineWidth',2)
set(handles.azAxis,'FontSize',12)
set(handles.azAxis,'FontWeight','bold')
title(handles.azAxis,'Gimbal Az')
xlabel(handles.azAxis,'Time (s)')
ylabel(handles.azAxis,'Value (deg)')
grid(handles.azAxis,'on')
set(handles.azAxis,'XLim',[1 256]);
set(handles.azAxis,'YLim',[-4 4]);

%gimbal el axis
handles.elAxis = axes('Units','pixels','Position',[2*buffer + smallWidth borderBuffer smallWidth smallHeight],'Parent',handles.hGimbalPanel);
handles.elPlot = plot(handles.elAxis,zeros(1,256),'b','LineWidth',2);
hold(handles.elAxis,'on');
handles.elScatterPlot = scatter(handles.elAxis,0,0,70,'b','filled');
set(handles.elAxis,'LineWidth',2)
set(handles.elAxis,'FontSize',12)
set(handles.elAxis,'FontWeight','bold')
title('Gimbal El')
xlabel('Time (s)')
ylabel('Value (deg)')
grid(handles.elAxis,'on')
set(handles.elAxis,'XLim',[1 256]);
set(handles.elAxis,'YLim',[-4 4]);

%gimbal error axis
handles.errorAxis = axes('Units','pixels','Position',[3*buffer + 2*bigWidth borderBuffer smallWidth smallHeight],'Parent',handles.hGimbalPanel);
handles.azErrorPlot = plot(handles.errorAxis,zeros(1,256),'b','LineWidth',2);
hold(handles.errorAxis,'on');
handles.elErrorPlot = plot(handles.errorAxis,zeros(1,256),'r','LineWidth',2);
handles.azErrorScatterPlot = scatter(handles.errorAxis,0,0,70,'r','filled');
handles.elErrorScatterPlot = scatter(handles.errorAxis,0,0,70,'r','filled');
set(handles.errorAxis,'LineWidth',2)
set(handles.errorAxis,'FontSize',12)
set(handles.errorAxis,'FontWeight','bold')
title('Gimbal Errors')
xlabel('Time (s)')
ylabel('Value (deg)')
grid(handles.errorAxis,'on')
set(handles.errorAxis,'XLim',[1 256]);
set(handles.errorAxis,'YLim',[-4 4]);
legend(handles.errorAxis,'Az','El','Location','NorthWest');

%% setup the panel and axes for the trajectory data
panelHeight = smallHeight + buffer - 10;
panelBottom = panelBottom - panelHeight - 10;

handles.hTrajectoryPanel = uipanel('Parent',handles.hfig,'Units','pixels','Title','Trajectory Data','FontSize',12,'BackgroundColor',handles.panelColor,...
                                   'Position',[panelLeft panelBottom panelWidth  panelHeight], ...
                                   'BorderType','beveledin','FontWeight','bold','BorderWidth',3);
                               
%altitude axis
handles.altAxis = axes('Units','pixels','Position',[buffer borderBuffer smallWidth smallHeight],'Parent',handles.hTrajectoryPanel);
handles.altPlot = plot(handles.altAxis,zeros(1,256),'b','LineWidth',2);
hold(handles.altAxis,'on');
handles.altScatterPlot = scatter(handles.altAxis,0,0,70,'b','filled');
set(handles.altAxis,'LineWidth',2)
set(handles.altAxis,'FontSize',12)
set(handles.altAxis,'FontWeight','bold')
title(handles.altAxis,'Altitude')
xlabel(handles.altAxis,'Time (s)')
ylabel(handles.altAxis,'Altitude (m)')
grid(handles.altAxis,'on')
set(handles.altAxis,'XLim',[1 256]);
set(handles.altAxis,'YLim',[-4 4]);

%trajectory axis
handles.trajectoryAxis = axes('Units','pixels','Position',[2*buffer + smallWidth borderBuffer smallWidth smallHeight],'Parent',handles.hTrajectoryPanel);
handles.trajectoryPlot = plot(handles.trajectoryAxis,zeros(1,256),'b','LineWidth',2);
hold(handles.trajectoryAxis,'on');
handles.trajectoryScatterPlot = scatter(handles.trajectoryAxis,0,0,70,'b','filled');
handles.expectedTargetScatterPlot = scatter(handles.trajectoryAxis,0,0,90,'rx');
set(handles.trajectoryAxis,'LineWidth',2)
set(handles.trajectoryAxis,'FontSize',12)
set(handles.trajectoryAxis,'FontWeight','bold')
title(handles.trajectoryAxis,'Trajectory')
xlabel(handles.trajectoryAxis,'Lattitude (deg)')
ylabel(handles.trajectoryAxis,'Longitude (deg)')
zlabel(handles.trajectoryAxis,'Altitude (m)')
grid(handles.trajectoryAxis,'on')
set(handles.trajectoryAxis,'XLim',[1 256]);
set(handles.trajectoryAxis,'YLim',[-4 4]);

%squint axis
handles.squintAxis = axes('Units','pixels','Position',[3*buffer + 2*bigWidth borderBuffer smallWidth smallHeight],'Parent',handles.hTrajectoryPanel);
handles.squintPlot = plot(handles.squintAxis,zeros(1,256),'b','LineWidth',2);
hold(handles.squintAxis,'on');
handles.squintScatterPlot = scatter(handles.squintAxis,0,0,70,'b','filled');
set(handles.squintAxis,'LineWidth',2)
set(handles.squintAxis,'FontSize',12)
set(handles.squintAxis,'FontWeight','bold')
title(handles.squintAxis,'Squint Angle')
xlabel(handles.squintAxis,'Time (s)')
ylabel(handles.squintAxis,'Squint Angle (deg)')
grid(handles.squintAxis,'on')
set(handles.squintAxis,'XLim',[1 256]);
set(handles.squintAxis,'YLim',[-4 4]);
                     
%% setup the panel and text windows for status display
panelHeight = smallHeight + buffer - 10;
panelBottom = panelBottom - panelHeight - 10;
staticTextOffset = 175;
textWidth = 175;
staticTextWidth = 175;
textHeight = 25;
colBuffer = 25;

handles.hStatusPanel = uipanel('Parent',handles.hfig,'Units','pixels','Title','Status','FontSize',12,'BackgroundColor',handles.panelColor,...
                         'Position',[panelLeft panelBottom panelWidth  panelHeight], ...
                         'BorderType','beveledin','FontWeight','bold','BorderWidth',3);
row5 = 15;
row4 = row5 + textHeight + 10;
row3 = row4 + textHeight + 10;
row2 = row3 + textHeight + 10;
row1 = row2 + textHeight + 10;
col1 = 10;
col2 = col1 + 10 + 2*textWidth + colBuffer;
col3 = col2 + 10 + 2*textWidth + colBuffer;
col4 = col3 + 10 + 2*textWidth + colBuffer;

%1st column - general data (time, mode, submode)
infoDisplay = uicontrol('Parent',handles.hStatusPanel,'Style','Text','String','General Info:','FontSize',12,'FontWeight','Bold',...
                        'BackgroundColor',handles.panelColor,'Position',[col1 + textWidth row1 + textHeight + 10 staticTextWidth textHeight]);
timeDisplay = uicontrol('Parent',handles.hStatusPanel,'Style','Text','String','Time (s):','FontSize',12,'FontWeight','Bold',...
                        'BackgroundColor',handles.panelColor,'Position',[col1 row1 staticTextWidth textHeight]);
handles.timeText = uicontrol('Parent',handles.hStatusPanel,'Style','Edit','FontSize',12,'FontWeight','Bold',...
                        'Position',[col1+staticTextOffset row1 textWidth textHeight]);
modeDisplay = uicontrol('Parent',handles.hStatusPanel,'Style','Text','String','Seeker Mode:','FontSize',12,'FontWeight','Bold',...
                        'BackgroundColor',handles.panelColor,'Position',[col1 row2 staticTextWidth textHeight]);
handles.modeText = uicontrol('Parent',handles.hStatusPanel,'Style','Edit','FontSize',12,'FontWeight','Bold',...
                            'Position',[col1+staticTextOffset row2 textWidth textHeight]);
submodeDisplay = uicontrol('Parent',handles.hStatusPanel,'Style','Text','String','Seeker SubMode:','FontSize',12,'FontWeight','Bold',...
                        'BackgroundColor',handles.panelColor,'Position',[col1 row3 staticTextWidth textHeight]);
handles.submodeText = uicontrol('Parent',handles.hStatusPanel,'Style','Edit','FontSize',12,'FontWeight','Bold',...
                            'Position',[col1+staticTextOffset row3 textWidth textHeight]);
ucRadiusDisplay = uicontrol('Parent',handles.hStatusPanel,'Style','Text','String','Uncertainty Radius (km):','FontSize',12,'FontWeight','Bold',...
                        'BackgroundColor',handles.panelColor,'Position',[col1 row4 staticTextWidth textHeight]);
handles.ucRadiusText = uicontrol('Parent',handles.hStatusPanel,'Style','Edit','FontSize',12,'FontWeight','Bold',...
                        'Position',[col1+staticTextOffset row4 textWidth textHeight]);
horizonDisplay = uicontrol('Parent',handles.hStatusPanel,'Style','Text','String','Distance to Horizon (km):','FontSize',12,'FontWeight','Bold',...
                        'BackgroundColor',handles.panelColor,'Position',[col1 row5 staticTextWidth textHeight]);
handles.horizonText = uicontrol('Parent',handles.hStatusPanel,'Style','Edit','FontSize',12,'FontWeight','Bold',...
                        'Position',[col1+staticTextOffset row5 textWidth textHeight]);
                    
% 2nd column - Gimbal data (Gimbal mode, Az, Az Error, El, El Error)
gimbalDisplay = uicontrol('Parent',handles.hStatusPanel,'Style','Text','String','Gimbal Info:','FontSize',12,'FontWeight','Bold',...
                        'BackgroundColor',handles.panelColor,'Position',[col2 + textWidth row1 + textHeight + 10 staticTextWidth textHeight]);
gimbalModeDisplay = uicontrol('Parent',handles.hStatusPanel,'Style','Text','String','Gimbal Mode:','FontSize',12,'FontWeight','Bold',...
                        'BackgroundColor',handles.panelColor,'Position',[col2 row1 staticTextWidth textHeight]);
handles.gimbalModeText = uicontrol('Parent',handles.hStatusPanel,'Style','Edit','FontSize',12,'FontWeight','Bold',...
                        'Position',[col2+staticTextOffset row1 textWidth textHeight]);
azDisplay = uicontrol('Parent',handles.hStatusPanel,'Style','Text','String','Gimbal Az (deg):','FontSize',12,'FontWeight','Bold',...
                        'BackgroundColor',handles.panelColor,'Position',[col2 row2 staticTextWidth textHeight]);
handles.azText = uicontrol('Parent',handles.hStatusPanel,'Style','Edit','FontSize',12,'FontWeight','Bold',...
                            'Position',[col2+staticTextOffset row2 textWidth textHeight]);
azErrorDisplay = uicontrol('Parent',handles.hStatusPanel,'Style','Text','String','Gimbal Az Error (deg):','FontSize',12,'FontWeight','Bold',...
                        'BackgroundColor',handles.panelColor,'Position',[col2 row3 staticTextWidth textHeight]);
handles.azErrorText = uicontrol('Parent',handles.hStatusPanel,'Style','Edit','FontSize',12,'FontWeight','Bold',...
                            'Position',[col2+staticTextOffset row3 textWidth textHeight]);
elDisplay = uicontrol('Parent',handles.hStatusPanel,'Style','Text','String','Gimbal El (deg):','FontSize',12,'FontWeight','Bold',...
                        'BackgroundColor',handles.panelColor,'Position',[col2 row4 staticTextWidth textHeight]);
handles.elText = uicontrol('Parent',handles.hStatusPanel,'Style','Edit','FontSize',12,'FontWeight','Bold',...
                            'Position',[col2+staticTextOffset row4 textWidth textHeight]);
elErrorDisplay = uicontrol('Parent',handles.hStatusPanel,'Style','Text','String','Gimbal El Error (deg):','FontSize',12,'FontWeight','Bold',...
                        'BackgroundColor',handles.panelColor,'Position',[col2 row5 staticTextWidth textHeight]);
handles.elErrorText = uicontrol('Parent',handles.hStatusPanel,'Style','Edit','FontSize',12,'FontWeight','Bold',...
                            'Position',[col2+staticTextOffset row5 textWidth textHeight]);
                        
% 3rd column - Receiver data (Az, El, Range, Doppler)
receiverDisplay = uicontrol('Parent',handles.hStatusPanel,'Style','Text','String','Receiver Info:','FontSize',12,'FontWeight','Bold',...
                        'BackgroundColor',handles.panelColor,'Position',[col3 + textWidth row1 + textHeight + 10 staticTextWidth textHeight]);                  
agcGainDisplay = uicontrol('Parent',handles.hStatusPanel,'Style','Text','String','AGC Gain (dB):','FontSize',12,'FontWeight','Bold',...
                        'BackgroundColor',handles.panelColor,'Position',[col3 row1 staticTextWidth textHeight]);
handles.agcGainText = uicontrol('Parent',handles.hStatusPanel,'Style','Edit','FontSize',12,'FontWeight','Bold',...
                        'Position',[col3+staticTextOffset row1 textWidth textHeight]);
stcGainDisplay = uicontrol('Parent',handles.hStatusPanel,'Style','Text','String','STC Gain (dB):','FontSize',12,'FontWeight','Bold',...
                        'BackgroundColor',handles.panelColor,'Position',[col3 row2 staticTextWidth textHeight]);
handles.stcGainText = uicontrol('Parent',handles.hStatusPanel,'Style','Edit','FontSize',12,'FontWeight','Bold',...
                        'Position',[col3+staticTextOffset row2 textWidth textHeight]);
cv1Display = uicontrol('Parent',handles.hStatusPanel,'Style','Text','String','CV1 (dB):','FontSize',12,'FontWeight','Bold',...
                        'BackgroundColor',handles.panelColor,'Position',[col3 row3 staticTextWidth textHeight]);
handles.cv1Text = uicontrol('Parent',handles.hStatusPanel,'Style','Edit','FontSize',12,'FontWeight','Bold',...
                        'Position',[col3+staticTextOffset row3 textWidth textHeight]);
cv2Display = uicontrol('Parent',handles.hStatusPanel,'Style','Text','String','CV2 (dB):','FontSize',12,'FontWeight','Bold',...
                        'BackgroundColor',handles.panelColor,'Position',[col3 row4 staticTextWidth textHeight]);
handles.cv2Text = uicontrol('Parent',handles.hStatusPanel,'Style','Edit','FontSize',12,'FontWeight','Bold',...
                        'Position',[col3+staticTextOffset row4 textWidth textHeight]);
cv3Display = uicontrol('Parent',handles.hStatusPanel,'Style','Text','String','CV3 (dB):','FontSize',12,'FontWeight','Bold',...
                        'BackgroundColor',handles.panelColor,'Position',[col3 row5 staticTextWidth textHeight]);
handles.cv3Text = uicontrol('Parent',handles.hStatusPanel,'Style','Edit','FontSize',12,'FontWeight','Bold',...
                        'Position',[col3+staticTextOffset row5 textWidth textHeight]);                   
%4th column - Tracker data (Range Gate position, UC Radius, Target Az, El,
%Range
trackerDisplay = uicontrol('Parent',handles.hStatusPanel,'Style','Text','String','Tracker Info:','FontSize',12,'FontWeight','Bold',...
                        'BackgroundColor',handles.panelColor,'Position',[col4 + textWidth row1 + textHeight + 10 staticTextWidth textHeight]);
trackerRangeGateDisplay = uicontrol('Parent',handles.hStatusPanel,'Style','Text','String','Range Gate (us):','FontSize',12,'FontWeight','Bold',...
                        'BackgroundColor',handles.panelColor,'Position',[col4 row1 staticTextWidth textHeight]);
handles.rangeGateText = uicontrol('Parent',handles.hStatusPanel,'Style','Edit','FontSize',12,'FontWeight','Bold',...
                        'Position',[col4+staticTextOffset row1 textWidth textHeight]);                   
targetAzDisplay = uicontrol('Parent',handles.hStatusPanel,'Style','Text','String','Target Az (deg):','FontSize',12,'FontWeight','Bold',...
                        'BackgroundColor',handles.panelColor,'Position',[col4 row2 staticTextWidth textHeight]);
handles.targetAzText = uicontrol('Parent',handles.hStatusPanel,'Style','Edit','FontSize',12,'FontWeight','Bold',...
                        'Position',[col4+staticTextOffset row2 textWidth textHeight]);
targetElDisplay = uicontrol('Parent',handles.hStatusPanel,'Style','Text','String','Target El (deg):','FontSize',12,'FontWeight','Bold',...
                        'BackgroundColor',handles.panelColor,'Position',[col4 row3 staticTextWidth textHeight]);
handles.targetElText = uicontrol('Parent',handles.hStatusPanel,'Style','Edit','FontSize',12,'FontWeight','Bold',...
                            'Position',[col4+staticTextOffset row3 textWidth textHeight]);
targetRangeDisplay = uicontrol('Parent',handles.hStatusPanel,'Style','Text','String','Target Range (km):','FontSize',12,'FontWeight','Bold',...
                        'BackgroundColor',handles.panelColor,'Position',[col4 row4 staticTextWidth textHeight]);
handles.targetRangeText = uicontrol('Parent',handles.hStatusPanel,'Style','Edit','FontSize',12,'FontWeight','Bold',...
                            'Position',[col4+staticTextOffset row4 textWidth textHeight]);
targetDopplerDisplay = uicontrol('Parent',handles.hStatusPanel,'Style','Text','String','Target Doppler (Hz):','FontSize',12,'FontWeight','Bold',...
                        'BackgroundColor',handles.panelColor,'Position',[col4 row5 staticTextWidth textHeight]);
handles.targetDopplerText = uicontrol('Parent',handles.hStatusPanel,'Style','Edit','FontSize',12,'FontWeight','Bold',...
                            'Position',[col4+staticTextOffset row5 textWidth textHeight]);
%%
%save the handles to the guidata object
guidata(hfig,handles);

