function handles = gui_createStatusSection(handles,x,y,width,height,buffer)

set(handles.statusBar,'Text','Initializing ... Status Section ...');

handles.hStatusPanel = uipanel('Parent',handles.hfig,'Units','pixels','Title','Status','FontSize',12,'BackgroundColor',handles.hStatusColor,...
                         'Position',[x y width  height], ...
                         'BorderType','beveledin','FontWeight','bold','BorderWidth',3);
                     
staticTextOffset = 175;
textWidth = 175;
staticTextWidth = 175;
textHeight = 25;

row1 = height - 2*buffer - textHeight;
row2 = row1 - textHeight - buffer;
row3 = row2 - textHeight - buffer;
row4 = row3 - textHeight - buffer;
row5 = row4 - textHeight - buffer;

col1 = buffer;
col2 = col1  + 2*textWidth + 2*buffer;
col3 = col2  + 2*textWidth + 2*buffer;
col4 = col3  + 2*textWidth + 2*buffer;


%1st column - general data (time, mode, submode)
timeDisplay = uicontrol('Parent',handles.hStatusPanel,'Style','Text','String','Time (s):','FontSize',12,'FontWeight','Bold',...
                        'BackgroundColor',handles.hStatusColor,'Position',[col1 row1 staticTextWidth textHeight]);
handles.timeText = uicontrol('Parent',handles.hStatusPanel,'Style','Edit','FontSize',12,'FontWeight','Bold',...
                        'Position',[col1+staticTextOffset row1 textWidth textHeight]);
modeDisplay = uicontrol('Parent',handles.hStatusPanel,'Style','Text','String','Seeker Mode:','FontSize',12,'FontWeight','Bold',...
                        'BackgroundColor',handles.hStatusColor,'Position',[col1 row2 staticTextWidth textHeight]);
handles.modeText = uicontrol('Parent',handles.hStatusPanel,'Style','Edit','FontSize',12,'FontWeight','Bold',...
                            'Position',[col1+staticTextOffset row2 textWidth textHeight]);
submodeDisplay = uicontrol('Parent',handles.hStatusPanel,'Style','Text','String','Seeker SubMode:','FontSize',12,'FontWeight','Bold',...
                        'BackgroundColor',handles.hStatusColor,'Position',[col1 row3 staticTextWidth textHeight]);
handles.submodeText = uicontrol('Parent',handles.hStatusPanel,'Style','Edit','FontSize',12,'FontWeight','Bold',...
                            'Position',[col1+staticTextOffset row3 textWidth textHeight]);
ucRadiusDisplay = uicontrol('Parent',handles.hStatusPanel,'Style','Text','String','Uncertainty Radius (km):','FontSize',12,'FontWeight','Bold',...
                        'BackgroundColor',handles.hStatusColor,'Position',[col1 row4 staticTextWidth textHeight]);
handles.ucRadiusText = uicontrol('Parent',handles.hStatusPanel,'Style','Edit','FontSize',12,'FontWeight','Bold',...
                        'Position',[col1+staticTextOffset row4 textWidth textHeight]);
horizonDisplay = uicontrol('Parent',handles.hStatusPanel,'Style','Text','String','Distance to Horizon (km):','FontSize',12,'FontWeight','Bold',...
                        'BackgroundColor',handles.hStatusColor,'Position',[col1 row5 staticTextWidth textHeight]);
handles.horizonText = uicontrol('Parent',handles.hStatusPanel,'Style','Edit','FontSize',12,'FontWeight','Bold',...
                        'Position',[col1+staticTextOffset row5 textWidth textHeight]);