function handles = gui_createPlotSection(handles,x,y,width,height,buffer)

set(handles.statusBar,'Text','Initializing ... S Parameters Axes ...');


handles.hPlotPanel = uipanel('Parent',handles.hfig,'Units','pixels','Title','S Parameters','FontSize',12,'BackgroundColor',handles.hPanelColor,...
                         'Position',[x y width  height], ...
                         'BorderType','beveledin','FontWeight','bold','BorderWidth',3);
                     
pWidth = floor((width-16*buffer)/2.0);
pHeight = floor((height-20*buffer)/2.0);

%create the axis for plotting S11
handles.S11Axis = axes('Units','pixels','Position',[5*buffer 14*buffer+pHeight pWidth pHeight],'Parent',handles.hPlotPanel);
handles.S11RealPlot = semilogx(handles.S11Axis,zeros(1,256),'b','LineWidth',2);
hold(handles.S11Axis,'on');
handles.S11ImagPlot = semilogx(handles.S11Axis,zeros(1,256),'r','LineWidth',2);
set(handles.S11Axis,'LineWidth',2)
set(handles.S11Axis,'FontSize',12)
set(handles.S11Axis,'FontWeight','bold')
title(handles.S11Axis,'S_{11}')
legend(handles.S11Axis,'Real','Imag')
xlabel(handles.S11Axis,'Frequency (Hz)')
ylabel(handles.S11Axis,'S')
grid(handles.S11Axis,'on')
set(handles.S11Axis,'XLim',[1 256]);
set(handles.S11Axis,'YLim',[-4 4]);

%create the axis for plotting S12
handles.S12Axis = axes('Units','pixels','Position',[12*buffer+pWidth 14*buffer+pHeight pWidth pHeight],'Parent',handles.hPlotPanel);
handles.S12RealPlot = semilogx(handles.S12Axis,zeros(1,256),'b','LineWidth',2);
hold(handles.S12Axis,'on');
handles.S12ImagPlot = semilogx(handles.S12Axis,zeros(1,256),'r','LineWidth',2);
set(handles.S12Axis,'LineWidth',2)
set(handles.S12Axis,'FontSize',12)
set(handles.S12Axis,'FontWeight','bold')
title(handles.S12Axis,'S_{12}')
legend(handles.S12Axis,'Real','Imag')
xlabel(handles.S12Axis,'Frequency (Hz)')
ylabel(handles.S12Axis,'S')
grid(handles.S12Axis,'on')
set(handles.S12Axis,'XLim',[1 256]);
set(handles.S12Axis,'YLim',[-4 4]);

%create the axis for plotting S21
handles.S21Axis = axes('Units','pixels','Position',[5*buffer 5*buffer pWidth pHeight],'Parent',handles.hPlotPanel);
handles.S21RealPlot = semilogx(handles.S21Axis,zeros(1,256),'b','LineWidth',2);
hold(handles.S21Axis,'on');
handles.S21ImagPlot = semilogx(handles.S21Axis,zeros(1,256),'r','LineWidth',2);
set(handles.S21Axis,'LineWidth',2)
set(handles.S21Axis,'FontSize',12)
set(handles.S21Axis,'FontWeight','bold')
title(handles.S21Axis,'S_{21}')
legend(handles.S21Axis,'Real','Imag')
xlabel(handles.S21Axis,'Frequency (Hz)')
ylabel(handles.S21Axis,'S')
grid(handles.S21Axis,'on')
set(handles.S21Axis,'XLim',[1 256]);
set(handles.S21Axis,'YLim',[-4 4]);

%create the axis for plotting S22
handles.S22Axis = axes('Units','pixels','Position',[12*buffer+pWidth 5*buffer pWidth pHeight],'Parent',handles.hPlotPanel);
handles.S22RealPlot = semilogx(handles.S22Axis,zeros(1,256),'b','LineWidth',2);
hold(handles.S22Axis,'on');
handles.S22ImagPlot = semilogx(handles.S22Axis,zeros(1,256),'r','LineWidth',2);
hold(handles.S22Axis,'on');
set(handles.S22Axis,'LineWidth',2)
set(handles.S22Axis,'FontSize',12)
set(handles.S22Axis,'FontWeight','bold')
title(handles.S22Axis,'S_{22}')
legend(handles.S22Axis,'Real','Imag')
xlabel(handles.S22Axis,'Frequency (Hz)')
ylabel(handles.S22Axis,'S')
grid(handles.S22Axis,'on')
set(handles.S22Axis,'XLim',[1 256]);
set(handles.S22Axis,'YLim',[-4 4]);

