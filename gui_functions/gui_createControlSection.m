function handles = gui_createControlSection(handles,x,y,width,height,buffer)

set(handles.statusBar,'Text','Initializing ... Control Section ...');

handles.hControlPanel = uipanel('Parent',handles.hfig,'Units','pixels','Title','Control','FontSize',12,'BackgroundColor',handles.hStatusColor,...
                         'Position',[x y width  height], ...
                         'BorderType','beveledin','FontWeight','bold','BorderWidth',3);
                     
      
buttonHeight = 25;
buttonSpacing = 175;
buttonWidth = 175;

row1 = height - 2*buffer - buttonHeight;
row2 = row1 - buttonHeight - buffer;
row3 = row2 - buttonHeight - buffer;
row4 = row3 - buttonHeight - buffer;
row5 = row4 - buttonHeight - buffer;

col1 = buffer;
col2 = col1  + 2*buttonWidth + 2*buffer;
col3 = col2  + 2*buttonWidth + 2*buffer;
col4 = col3  + 2*buttonWidth + 2*buffer;

handles.runButton = uicontrol('Parent',handles.hControlPanel,'Style','pushbutton','String','Run','FontSize',12,'FontWeight','Bold',...
                            'Position',[col1+buffer row1 buttonWidth buttonHeight]);
                        
