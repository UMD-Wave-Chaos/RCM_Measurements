function Znormf = normalizeImpedance(Zcf ,Freq, varargin)

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
Zradf = mean(Zcf,4);

tic; 
for incr = 1:N
   
    for j = 1:length(Freq)
        Znormf(:,:,j,incr) = ((real(Zradf(:,:,j)))^-0.5)*(Zcf(:,:,j,incr)-1j*imag(Zradf(:,:,j)))*((real(Zradf(:,:,j)))^-0.5); 
    end 
    time = toc; 
	
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