function Znormf = normalizeImpedance(Zcf ,Zradf,Freq, varargin)

if (nargin == 4)
    useGUI = true;
    handles = varargin{1};
else
    useGUI = false;
end  

lstring = sprintf('Normalizing Impedance');
if (useGUI == true)
    logMessage(handles.jEditbox,lstring);
else
    disp(lstring)
end
    
N = size(Zcf,3);
num_ports = 2;


Znormf = zeros(num_ports,num_ports,length(Freq),N);

ZradMatrix(1,1,:) = Zradf(:,1);
ZradMatrix(1,2,:) = Zradf(:,2);
ZradMatrix(2,1,:) = Zradf(:,3);
ZradMatrix(2,2,:) = Zradf(:,4);

ZCfMatrix(1,1,:,:) = Zcf(:,1,:);
ZCfMatrix(1,2,:,:) = Zcf(:,2,:);
ZCfMatrix(2,1,:,:) = Zcf(:,3,:);
ZCfMatrix(2,2,:,:) = Zcf(:,4,:);

tic; 
for incr = 1:N
   
    for j = 1:length(Freq)
        Znormf(:,:,j,incr) = ((real(ZradMatrix(:,:,j)))^(-0.5))*(ZCfMatrix(:,:,j,incr)-1j*imag(ZradMatrix(:,:,j)))*((real(ZradMatrix(:,:,j)))^(-0.5)); 
    end 
    time = toc; 
    
    if (useGUI == true)
         tString = sprintf('Normalized Z, realization %d of %d',incr,N);
        updateZPlots(Freq,Znormf(1,1,:,incr),Znormf(1,2,:,incr),Znormf(2,2,:,incr),tString,handles)
    end
	
	averagetime = time/incr;
	predictedTime = averagetime*(N-incr);
    lstring = sprintf('Normalizing realization %d of %d, time = %s s, predicted remaining time = %s s',incr,N,num2str(time), num2str(predictedTime));
    if (useGUI == true)
        logMessage(handles.jEditbox,lstring);
    else
        disp(lstring)
    end
end
Znormf = permute(shiftdim(reshape(Znormf,1,num_ports^2,length(Freq),N)),[2 1 3]);