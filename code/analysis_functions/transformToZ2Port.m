function [Z] = transformToZ2Port(S, varargin)

if (nargin == 2)
    useGUI = true;
    handles = varargin{1};
else
    useGUI = false;
end

lstring = sprintf('Transforming to Impedance');
if (useGUI == true)
    logMessage(handles.jEditbox,lstring);
else
    disp(lstring)
end

N = size(S,3);

Z0 = 50;

for i = 1:N
    deltaS = (1-S(:,1,i)).*(1-S(:,4,i)) - S(:,2,i).*S(:,3,i);
    Z(:,1,i) = Z0*((1+S(:,1,i)).*(1-S(:,4,i)) + S(:,2,i).*S(:,3,i))./deltaS;
    Z(:,2,i) = Z0*2*S(:,2,i)./deltaS;
    Z(:,3,i) = Z0*2*S(:,3,i)./deltaS;
    Z(:,4,i) = Z0*((1-S(:,1,i)).*(1+S(:,4,i)) - S(:,2,i).*S(:,3,i))./deltaS;
    
%     time = toc; 
    
%     if (useGUI == true)
%         tString = sprintf('Transformed Z, realization %d of %d',i,N);
%         updateZPlots(Freq,Zcf(1,1,:,i),Zcf(1,2,:,i),Zcf(2,2,:,i),tString,handles)
%     end
	
% 	averagetime = time/i;
% 	predictedTime = averagetime*(N-i);
%     lstring = sprintf('Transforming realization %d of %d, time = %s s, predicted remaining time = %s s',i,N,num2str(time), num2str(predictedTime));
% %     if (useGUI == true)
% %         logMessage(handles.jEditbox,lstring);
% %     else
%         disp(lstring)
%     end

end