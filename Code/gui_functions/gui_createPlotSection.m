function handles = gui_createPlotSection(handles,x,y,width,height,buffer)
handles.hPlotPanel = uipanel('Parent',handles.hfig,'Units','pixels','Title','S Parameters','FontSize',12,'BackgroundColor',handles.hPanelColor,...
                         'Position',[x y width  height], ...
                         'BorderType','beveledin','FontWeight','bold','BorderWidth',3);
                     
pWidth = floor((width-18*buffer)/2.0);
pHeight = floor(height-12*buffer);

%create the axis for plotting S11
handles.S11Axis = axes('Units','pixels','Position',[6*buffer 5*buffer pWidth pHeight],'Parent',handles.hPlotPanel);
handles.S11RealPlot = semilogx(handles.S11Axis,linspace(10e6,13.5e9,256),zeros(1,256),'b','LineWidth',2);
hold(handles.S11Axis,'on');
handles.S11ImagPlot = semilogx(handles.S11Axis,linspace(10e6,13.5e9,256),zeros(1,256),'r','LineWidth',2);
set(handles.S11Axis,'LineWidth',2)
set(handles.S11Axis,'FontSize',12)
set(handles.S11Axis,'FontWeight','bold')
title(handles.S11Axis,'S_{11}')
legend(handles.S11Axis,'Real','Imag')
xlabel(handles.S11Axis,'Frequency (Hz)')
ylabel(handles.S11Axis,'S')
grid(handles.S11Axis,'on')
set(handles.S11Axis,'XLim',[10e6 13.5e9]);
set(handles.S11Axis,'YLim',[-80 10]);

%create the axis for plotting S12
handles.S12Axis = axes('Units','pixels','Position',[16*buffer+pWidth 5*buffer pWidth pHeight],'Parent',handles.hPlotPanel);
handles.S12RealPlot = semilogx(handles.S12Axis,linspace(10e6,13.5e9,256),zeros(1,256),'b','LineWidth',2);
hold(handles.S12Axis,'on');
handles.S12ImagPlot = semilogx(handles.S12Axis,linspace(10e6,13.5e9,256),zeros(1,256),'r','LineWidth',2);
set(handles.S12Axis,'LineWidth',2)
set(handles.S12Axis,'FontSize',12)
set(handles.S12Axis,'FontWeight','bold')
title(handles.S12Axis,'S_{12}')
legend(handles.S12Axis,'Real','Imag')
xlabel(handles.S12Axis,'Frequency (Hz)')
ylabel(handles.S12Axis,'S')
grid(handles.S12Axis,'on')
set(handles.S12Axis,'XLim',[10e6 13.5e9]);
set(handles.S12Axis,'YLim',[-80 10]);


