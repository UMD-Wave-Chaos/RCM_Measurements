
function updateSParametersPlots(Freq,SC11,SC12,SC22,tString,handles)

hold(handles.S11Axis,'off');

nReduction = 256;
x = decimate(Freq,floor(length(SC11)/nReduction))/1e9;
y1 = decimate(SC11,floor(length(SC11)/nReduction));
y2 = decimate(SC12,floor(length(SC12)/nReduction));
y3 = decimate(SC22,floor(length(SC12)/nReduction));

xlimit = [min(x) max(x)];
plot(handles.S11Axis,x,20*log10(abs(y1)),'LineWidth',2);
hold(handles.S11Axis,'on');
plot(handles.S11Axis,x,20*log10(abs(y2)),'--m','LineWidth',2);
plot(handles.S11Axis,x,20*log10(abs(y3)),'.k','LineWidth',2);
set(handles.S11Axis,'XLim',xlimit);
set(handles.S11Axis,'YLim',[-100 10]);
grid(handles.S11Axis,'on');
ylabel(handles.S11Axis,'|S| (dB)')
xlabel(handles.S11Axis,'Frequency (GHz)')
set(handles.S11Axis,'LineWidth',2);
set(handles.S11Axis,'FontSize',12);
set(handles.S11Axis,'FontWeight','bold');
legend(handles.S11Axis,'S_{11}','S_{12}','S_{22}')
title(handles.S11Axis,tString);


hold(handles.S12Axis,'off');
xlimit = [min(x) max(x)];
plot(handles.S12Axis,x,angle(y1),'LineWidth',2);
hold(handles.S12Axis,'on');
plot(handles.S12Axis,x,angle(y2),'--m','LineWidth',2);
plot(handles.S12Axis,x,angle(y3),'.k','LineWidth',2);
set(handles.S12Axis,'XLim',xlimit);
set(handles.S12Axis,'YLim',[-pi pi]);
grid(handles.S12Axis,'on');
ylabel(handles.S12Axis,'\angle S (rad)')
xlabel(handles.S12Axis,'Frequency (GHz)')
set(handles.S12Axis,'LineWidth',2);
set(handles.S12Axis,'FontSize',12);
set(handles.S12Axis,'FontWeight','bold');
legend(handles.S12Axis,'S_{11}','S_{12}','S_{22}')
title(handles.S12Axis,tString);

pause(0.1);