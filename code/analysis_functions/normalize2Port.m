function Znormf = normalize2Port(Zcf ,Zradf,Freq, varargin)

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


% Znormf = zeros(num_ports,num_ports,length(Freq),N);
% Zradf1 = mean(Zcf,4);
% 
% Zradf = mean(Zradf,4);
% 
% Zradf = Zradf1;
% Zradf(1,1,:) = Zradf1(1,1,:);
% Zradf(2,2,:) = Zradf2(2,2,:);

% tic; 
for incr = 1:N
    
    Znormf = real(Zradf).^(-0.5).*( Zcf(:,:,incr) - 1j*imag(Zradf)).*real(Zradf).^(-0.5);
   
%     for j = 1:length(Freq)
%         Znormf(:,:,j,incr) = ((real(Zradf(:,:,j)))^-0.5)*(Zcf(:,:,j,incr)-1j*imag(Zradf(:,:,j)))*((real(Zradf(:,:,j)))^-0.5); 
%     end 
%     time = toc; 
%     
%     if (useGUI == true)
%          tString = sprintf('Normalized Z, realization %d of %d',incr,N);
%         updateZPlots(Freq,Znormf(1,1,:,incr),Znormf(1,2,:,incr),Znormf(2,2,:,incr),tString,handles)
%     end
% 	
% 	averagetime = time/incr;
% 	predictedTime = averagetime*(N-incr);
%     lstring = sprintf('Normalizing realization %d of %d, time = %s s, predicted remaining time = %s s',incr,N,num2str(time), num2str(predictedTime));
%     if (useGUI == true)
%         logMessage(handles.jEditbox,lstring);
%     else
%         disp(lstring)
%     end
end
% Znormf = permute(shiftdim(reshape(Znormf,1,num_ports^2,length(Freq),N)),[2 1 3]);