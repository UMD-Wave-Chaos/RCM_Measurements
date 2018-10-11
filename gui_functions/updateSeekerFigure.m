function updateSeekerFigure(seekerData, handles, varargin)

updateLimits = false;
if nargin == 3
    updateLimits = varargin{1};
end
%Receiver Data

set(handles.rdmPlot,'CData',seekerData.rdmData);
set(handles.mofnPlot,'CData',seekerData.mofnData);
set(handles.gate1Plot,'YData',seekerData.g1Data);
set(handles.gate2Plot,'YData',seekerData.g2Data);

%Gimbal Data
set(handles.azPlot,'YData',seekerData.azData);
set(handles.azPlot,'XData',seekerData.time);
set(handles.azErrorPlot,'YData',seekerData.azErrorData);
set(handles.azErrorPlot,'XData',seekerData.time);
set(handles.elPlot,'YData',seekerData.elData);
set(handles.elPlot,'XData',seekerData.time);
set(handles.elErrorPlot,'YData',seekerData.elErrorData);
set(handles.elErrorPlot,'XData',seekerData.time);
set(handles.azScatterPlot,'XData',seekerData.currentTime);
set(handles.azScatterPlot,'YData',seekerData.currentAz);
set(handles.azErrorScatterPlot,'XData',seekerData.currentTime);
set(handles.azErrorScatterPlot,'YData',seekerData.currentAzError);
set(handles.elScatterPlot,'XData',seekerData.currentTime);
set(handles.elScatterPlot,'YData',seekerData.currentEl);
set(handles.elErrorScatterPlot,'XData',seekerData.currentTime);
set(handles.elErrorScatterPlot,'YData',seekerData.currentElError);

%trajectory data
set(handles.altPlot,'YData',seekerData.altData);
set(handles.altPlot,'XData',seekerData.time);
set(handles.altScatterPlot,'XData',seekerData.currentTime);
set(handles.altScatterPlot,'YData',seekerData.currentAlt);
set(handles.trajectoryPlot,'XData',seekerData.trajXData);
set(handles.trajectoryPlot,'YData',seekerData.trajYData);
set(handles.trajectoryScatterPlot,'XData',seekerData.currentTrajX);
set(handles.trajectoryScatterPlot,'YData',seekerData.currentTrajY);
set(handles.expectedTargetScatterPlot,'XData',seekerData.currentExpectedTargetX);
set(handles.expectedTargetScatterPlot,'YData',seekerData.currentExpectedTargetY);

set(handles.squintPlot,'YData',seekerData.squintData);
set(handles.squintPlot,'XData',seekerData.time);
set(handles.squintScatterPlot,'XData',seekerData.currentTime);
set(handles.squintScatterPlot,'YData',seekerData.currentSquint);


if updateLimits == true
    set(handles.rdmAxis,'XLim',seekerData.rdmAxisXLimit);
    set(handles.rdmAxis,'YLim',seekerData.rdmAxisYLimit);
    set(handles.azAxis,'XLim',seekerData.azAxisXLimit);
    set(handles.azAxis,'YLim',seekerData.azAxisYLimit);
    set(handles.elAxis,'XLim',seekerData.elAxisXLimit);
    set(handles.elAxis,'YLim',seekerData.elAxisYLimit);
    set(handles.gate1Axis,'XLim',seekerData.g1AxisXLimit);
    set(handles.gate1Axis,'YLim',seekerData.g1AxisYLimit);
    set(handles.gate2Axis,'XLim',seekerData.g2AxisXLimit);
    set(handles.gate2Axis,'YLim',seekerData.g2AxisYLimit);
    set(handles.errorAxis,'XLim',seekerData.errorAxisXLimit);
    set(handles.errorAxis,'YLim',seekerData.errorAxisYLimit);
    set(handles.altAxis,'XLim',seekerData.altAxisXLimit);
    set(handles.altAxis,'YLim',seekerData.altAxisYLimit);
    set(handles.squintAxis,'XLim',seekerData.squintAxisXLimit);
    set(handles.squintAxis,'YLim',seekerData.squintAxisYLimit);
    set(handles.trajectoryAxis,'XLim',seekerData.trajAxisXLimit);
    set(handles.trajectoryAxis,'YLim',seekerData.trajAxisYLimit);
end

%Edit Text Windows
set(handles.timeText,'String',num2str(seekerData.currentTime));
set(handles.modeText,'String',seekerData.seekerMode);
set(handles.submodeText,'String',seekerData.seekerSubMode);

set(handles.azText,'String',num2str(seekerData.currentAz));
set(handles.elText,'String',num2str(seekerData.currentEl));
set(handles.azErrorText,'String',num2str(seekerData.currentAzError));
set(handles.elErrorText,'String',num2str(seekerData.currentElError));
set(handles.gimbalModeText,'String',seekerData.gimbalMode);

set(handles.targetRangeText,'String',num2str(seekerData.targetRangeData));
set(handles.targetDopplerText,'String',num2str(seekerData.targetDopplerData));
set(handles.targetAzText, 'String',num2str(seekerData.targetAzData));
set(handles.targetElText, 'String',num2str(seekerData.targetElData));

set(handles.rangeGateText, 'String',num2str(seekerData.rangeGatePos));
set(handles.ucRadiusText, 'String',num2str(seekerData.ucRadius));

set(handles.stcGainText, 'String',num2str(seekerData.stcGain));
set(handles.agcGainText, 'String',num2str(seekerData.agcGain));
set(handles.horizonText, 'String',num2str(seekerData.horizonRange));

set(handles.cv1Text, 'String',num2str(seekerData.cv1));
set(handles.cv2Text, 'String',num2str(seekerData.cv2));
set(handles.cv3Text, 'String',num2str(seekerData.cv3));
drawnow()