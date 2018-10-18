function [Zhist_EXP,Zbin_EXP,Zphist_EXP,Zpbin_EXP] = computeMeasuredDistribution(Znormf,varargin)   

if (nargin == 2)
    useGUI = true;
    handles = varargin{1};
else
    useGUI = false;
end

BINS = 1000;

num_ports = 2;
N = size(Znormf,3);

lstring = sprintf('Generating Measured Distribution');
if (useGUI == true)
    logMessage(handles.jEditbox,lstring);
else
    disp(lstring)
end
    
tic;
EZnormf = Znormf(:,:,1);
for i = 2:N
    EZnormf = cat(1,EZnormf,Znormf(:,:,i));
    time = toc; 
        lstring = sprintf('Generating Measured Distribution %d of %d, time = %s s',i,N,num2str(time));
    if (useGUI == true)
        logMessage(handles.jEditbox,lstring);
    else
        disp(lstring)
    end
end
for i = 1:num_ports^2
    [Zhist_EXP(:,i), Zbin_EXP(:,i)] = hist(abs(EZnormf(:,i)), 0.1*BINS); 
end                         % input paramters: the data (normalized impedance), and the number of bins
for i = 1:num_ports^2
    [Zphist_EXP(:,i), Zpbin_EXP(:,i)] = hist(angle(EZnormf(:,i)), 0.1*BINS);
end