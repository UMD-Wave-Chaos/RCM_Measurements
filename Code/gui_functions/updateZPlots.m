function updateZPlots(Freq,Z11,Z12,Z22,tString,handles)

hold(handles.S11Axis,'off');

nReduction = 256;
x = decimate(Freq,floor(length(Z11)/nReduction))/1e9;
y1 = decimate(Z11,floor(length(Z11)/nReduction));
y2 = decimate(Z12,floor(length(Z12)/nReduction));
y3 = decimate(Z22,floor(length(Z22)/nReduction));

xlimit = [min(x) max(x)];
semilogx(handles.S11Axis,x,20*log10(abs(y1)),'LineWidth',2);
hold(handles.S11Axis,'on');
semilogx(handles.S11Axis,x,20*log10(abs(y2)),'LineWidth',2);
semilogx(handles.S11Axis,x,20*log10(abs(y3)),'LineWidth',2);
set(handles.S11Axis,'XLim',xlimit);
set(handles.S11Axis,'YLim',[-50 50]);
grid(handles.S11Axis,'on');
ylabel(handles.S11Axis,'|Z| (dB)')
xlabel(handles.S11Axis,'Frequency (GHz)')
set(handles.S11Axis,'LineWidth',2);
set(handles.S11Axis,'FontSize',12);
set(handles.S11Axis,'FontWeight','bold');
legend(handles.S11Axis,'Z_{11}','Z_{12}','Z_{22}')
title(handles.S11Axis,tString);


hold(handles.S12Axis,'off');
xlimit = [min(x) max(x)];
semilogx(handles.S12Axis,x,angle(y1),'LineWidth',2);
hold(handles.S12Axis,'on');
semilogx(handles.S12Axis,x,angle(y2),'LineWidth',2);
semilogx(handles.S12Axis,x,angle(y3),'LineWidth',2);
set(handles.S12Axis,'XLim',xlimit);
set(handles.S12Axis,'YLim',[-pi pi]);
grid(handles.S12Axis,'on');
ylabel(handles.S12Axis,'\angle Z_{11} (rad)')
xlabel(handles.S12Axis,'Frequency (GHz)')
set(handles.S12Axis,'LineWidth',2);
set(handles.S12Axis,'FontSize',12);
set(handles.S12Axis,'FontWeight','bold');
legend(handles.S12Axis,'Z_{11}','Z_{12}','Z_{22}')
title(handles.S12Axis,tString);

pause(0.1);