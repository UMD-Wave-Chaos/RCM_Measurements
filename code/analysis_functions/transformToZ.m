function Z = transformToZ(S,Freq, varargin)

if (nargin == 3)
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

N = size(S,2);
num_ports = 1;

tic; 
SM = reshape(shiftdim(permute(S,[2,1,3]),-1),num_ports,num_ports,length(Freq),N);
srZ0 = 50;%*eye(num_ports);
% Z = zeros(num_ports,num_ports,length(Freq),N);

for i = 1:N
%     for j = 1:length(Freq)
%         Z(j,i) = srZ0*(1 + S(j,i))./(1-S(j,i));
% %             Z(:,:,j,i) = srZ0*(eye(num_ports)+SM(:,:,j))*inv(eye(num_ports)-SM(:,:,j));l%srZ0;
%     end
    
    Z(:,i) = srZ0*(1 + S(:,i))./(1-S(:,i));
    time = toc; 
    
    if (useGUI == true)
        tString = sprintf('Transformed Z, realization %d of %d',i,N);
        updateZPlots(Freq,Z(1,1,:,i),Z(1,2,:,i),Z(2,2,:,i),tString,handles)
    end
	
	averagetime = time/i;
	predictedTime = averagetime*(N-i);
    lstring = sprintf('Transforming realization %d of %d, time = %s s, predicted remaining time = %s s',i,N,num2str(time), num2str(predictedTime));
    if (useGUI == true)
        logMessage(handles.jEditbox,lstring);
    else
        disp(lstring)
    end
    %++++++++++++++++++++++++++++++++++++++++++++++++++++
end