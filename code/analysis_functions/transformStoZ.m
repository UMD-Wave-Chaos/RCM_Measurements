function [Zradf, Zcf] = transformStoZ(Srad, Scav,Freq, varargin)

if (nargin == 4)
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

N = size(Scav,3);
num_ports = 2;

tic; 
Srad1 = Srad(:,:,:,6);
SradM = reshape(shiftdim(permute(Srad1,[2,1,3]),-1),num_ports,num_ports,length(Freq),N); 
SCfM = reshape(shiftdim(permute(Scav,[2,1,3]),-1),num_ports,num_ports,length(Freq),N);
srZ0 = sqrt(50)*eye(2);
Zradf = zeros(num_ports,num_ports,length(Freq),N);
Zcf = zeros(num_ports,num_ports,length(Freq),N);

for i = 1:N
    for j = 1:length(Freq)
            Zradf(:,:,j,i) = srZ0*(eye(2)+SradM(:,:,j,i))*inv(eye(2)-SradM(:,:,j,i))*srZ0;
            Zcf(:,:,j,i) = srZ0*(eye(2)+SCfM(:,:,j,i))*inv(eye(2)-SCfM(:,:,j,i))*srZ0;
    end
    time = toc; 
	
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