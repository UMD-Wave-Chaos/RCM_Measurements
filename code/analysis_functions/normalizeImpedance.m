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
    
N = size(Zcf,4);
num_ports = 2;

gate = 1;
Znormf = zeros(num_ports,num_ports,length(Freq),N);
Zradf1 = mean(Zcf,4);

Zradf2 = mean(Zradf,4);

% tt1 = reshape(Zradf1(1,1,:),[1 32001]);
% tt2 = reshape(Zradf2(1,1,:),[1 32001]);
% 
% yy1 = reshape(Zradf1(1,2,:),[1 32001]);
% yy2 = reshape(Zradf2(1,2,:),[1 32001]);
% 
% xx1 = reshape(Zradf1(2,1,:),[1 32001]);
% xx2 = reshape(Zradf2(2,1,:),[1 32001]);
% 
% zz1 = reshape(Zradf1(2,2,:),[1 32001]);
% zz2 = reshape(Zradf2(2,2,:),[1 32001]);


Zradf = Zradf2;
tic; 
for incr = 1:N
   
    for j = 1:length(Freq)
        Znormf(:,:,j,incr) = ((real(Zradf(:,:,j)))^-0.5)*(Zcf(:,:,j,incr)-1j*imag(Zradf(:,:,j)))*((real(Zradf(:,:,j)))^-0.5); 
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