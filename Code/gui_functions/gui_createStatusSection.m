function handles = gui_createStatusSection(handles,x,y,width,height,buffer)
handles.hStatusPanel = uipanel('Parent',handles.hfig,'Units','pixels','Title','Status','FontSize',12,'BackgroundColor',handles.hStatusColor,...
                         'Position',[x y width  height], ...
                         'BorderType','beveledin','FontWeight','bold','BorderWidth',3);
                     
staticTextOffset = 175;
textWidth = 175;
staticTextWidth = 175;
textHeight = 25;

row1 = height - 3*buffer - textHeight;
row2 = row1 - textHeight - buffer;
row3 = row2 - textHeight - buffer;
row4 = row3 - textHeight - buffer;
row5 = row4 - textHeight - buffer;

col1 = buffer;
col2 = col1  + 2*textWidth + 2*buffer;
col3 = col2  + 2*textWidth + 2*buffer;
col4 = col3  + 2*textWidth + 2*buffer;


%1st column - general data (time, mode, submode)
pnaConnectionDisplay = uicontrol('Parent',handles.hStatusPanel,'Style','Text','String','PNA Connection:','FontSize',12,'FontWeight','Bold',...
                        'BackgroundColor',handles.hStatusColor,'Position',[col1 row1 staticTextWidth textHeight]);
handles.pnaConnectionText = uicontrol('Parent',handles.hStatusPanel,'Style','Edit','FontSize',12,'FontWeight','Bold',...
                        'Position',[col1+staticTextOffset row1 textWidth textHeight]);
sConnectionDisplay = uicontrol('Parent',handles.hStatusPanel,'Style','Text','String','Motor Connection:','FontSize',12,'FontWeight','Bold',...
                        'BackgroundColor',handles.hStatusColor,'Position',[col1 row2 staticTextWidth textHeight]);
handles.sConnectionText = uicontrol('Parent',handles.hStatusPanel,'Style','Edit','FontSize',12,'FontWeight','Bold',...
                            'Position',[col1+staticTextOffset row2 textWidth textHeight]);
modeDisplay = uicontrol('Parent',handles.hStatusPanel,'Style','Text','String','Mode:','FontSize',12,'FontWeight','Bold',...
                        'BackgroundColor',handles.hStatusColor,'Position',[col1 row3 staticTextWidth textHeight]);
handles.modeText = uicontrol('Parent',handles.hStatusPanel,'Style','Edit','FontSize',12,'FontWeight','Bold',...
                            'Position',[col1+staticTextOffset row3 textWidth textHeight]);
                        

sPositionDisplay = uicontrol('Parent',handles.hStatusPanel,'Style','Text','String','Motor Position:','FontSize',12,'FontWeight','Bold',...
                        'BackgroundColor',handles.hStatusColor,'Position',[col2 row2 staticTextWidth textHeight]);
handles.sPositionText = uicontrol('Parent',handles.hStatusPanel,'Style','Edit','FontSize',12,'FontWeight','Bold',...
                            'Position',[col2+staticTextOffset row2 textWidth textHeight]);
