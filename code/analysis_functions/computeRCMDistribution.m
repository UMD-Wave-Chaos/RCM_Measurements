function [Zhist_RCM,Zbin_RCM, Zphist_RCM,Zpbin_RCM] =  computeRCMDistribution(alpha,nRCM,varargin)

if (nargin == 3)
    useGUI = true;
    handles = varargin{1};
else
    useGUI = false;
end

BINS = 1000;
num_ports = 2;

lstring = sprintf('Generating RCM Distribution');
if (useGUI == true)
    logMessage(handles.jEditbox,lstring);
else
    disp(lstring)
end

tic;
for i = 1:num_ports^2;
    if (useGUI == true)
        [Znorm_RCM] =  genPMFrcm(alpha(i),num_ports, nRCM,handles);           % input parameters: loss parameter, number of bins, number of ports, number of samples
    else
        [Znorm_RCM] =  genPMFrcm(alpha(i),num_ports, nRCM);  
    end
    [Zhist_RCM(:,i), Zbin_RCM(:,i)] = hist(abs(Znorm_RCM(:,i)), 0.1*BINS);
    [Zphist_RCM(:,i), Zpbin_RCM(:,i)] = hist(angle(Znorm_RCM(:,i)), 0.1*BINS);
	time = toc; 
	
	averagetime = time/i;
	predictedTime = averagetime*(num_ports^2-i);
    lstring = sprintf('Computing RCM distribution %d of %d, time = %s s, predicted remaining time = %s s',i,num_ports^2,num2str(time), num2str(predictedTime));
    if (useGUI == true)
        logMessage(handles.jEditbox,lstring);
    else
        disp(lstring)
    end
end