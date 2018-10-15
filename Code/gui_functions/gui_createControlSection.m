function handles = gui_createControlSection(handles,x,y,width,height,buffer)

handles.hControlPanel = uipanel('Parent',handles.hfig,'Units','pixels','Title','Control','FontSize',12,'BackgroundColor',handles.hStatusColor,...
                         'Position',[x y width  height], ...
                         'BorderType','beveledin','FontWeight','bold','BorderWidth',3);
                     
      
buttonHeight = 25;
buttonSpacing = 175;
buttonWidth = 175;

row1 = height - 3*buffer - buttonHeight;
row2 = row1 - buttonHeight - buffer;
row3 = row2 - buttonHeight - buffer;
row4 = row3 - buttonHeight - buffer;
row5 = row4 - buttonHeight - buffer;

col1 = buffer;
col2 = col1  + 2*buttonWidth + 2*buffer;
col3 = col2  + 2*buttonWidth + 2*buffer;
col4 = col3  + 2*buttonWidth + 2*buffer;

handles.measureButton = uicontrol('Parent',handles.hControlPanel,'Style','pushbutton','String','Measure Data','FontSize',12,'FontWeight','Bold',...
                            'Position',[col1+buffer row1 buttonWidth buttonHeight]);
handles.analyzeButton = uicontrol('Parent',handles.hControlPanel,'Style','pushbutton','String','Analyze Data','FontSize',12,'FontWeight','Bold',...
                            'Position',[col1+buffer row2 buttonWidth buttonHeight]);                    
handles.reloadConfigButton = uicontrol('Parent',handles.hControlPanel,'Style','pushbutton','String','Reload Config','FontSize',12,'FontWeight','Bold',...
                            'Position',[col1+buffer row3 buttonWidth buttonHeight]);
handles.editConfigButton = uicontrol('Parent',handles.hControlPanel,'Style','pushbutton','String','Edit Config','FontSize',12,'FontWeight','Bold',...
                            'Position',[col1+buffer row4 buttonWidth buttonHeight]);