function [Znorm] = genPMFrcm(alpha, num_ports, dataN,varargin)
%%%%%%%%%%%%%%%%%%% Input parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Here input the number of data:
% dataN ---- is the total number of samples is in the order of this value
% Here input the smoothness threshold:
% sthre --- A smaller threshold makes the generated proballity distribution more smooth and finer
% A larger "dataN" or a smaller "sthre" makes the statistical result more
% accurate and also takes longer time. However, this is necessary for higher
% loss cases.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if (nargin == 4)
    useGUI = true;
    handles = varargin{1};
else
    useGUI = false;
end

% Here input the loss parameter:
LossP=alpha;
% Here input the smoothness threshold:
sthre=10/(LossP^2); % A smaller threshold makes the generated proballity distribution more smooth and finer

startTime = tic;
runTime = 0;
% Compute the joint PDF of T1 and T2
r=4*pi*LossP;  % r is the "gamma" parameter in Brouwer and Beenakker's paper
% Sameer and Henry have proved gamma = 4*pi*alpha

I=[1 0;0 1];
z11=zeros(1,dataN);
z12=zeros(1,dataN);
z21=zeros(1,dataN);
z22=zeros(1,dataN);
totalrun=0; % Because the probability < 1, the totalrun will be less than the number of generated samples
% In extreme cases (very high or low loss), a lot of "runs"
% will NOT generate any results.
count = 1;
while(count<=dataN)
    
    totalrun=totalrun+1;
    % randomly pick a point and then compute P(T1,T2) --------------
    %These are the port absorptions
    T1=rand(1);
    T2=rand(1);
    
    %implement equation 17a from Brouwer/Beenakker or Eq 7 from Sameer
    A=(1/8)*(T1^(-4))*(T2^(-4))*abs(T1-T2);
    B=exp((-1/2)*r*(1/T1 + 1/T2))*[2*(r^2)+(r^3)-6*(T1+T2)*r-4*(T1+T2)*(r^2)-(T1+T2)*(r^3)+24*T1*T2+18*T1*T2*r+6*T1*T2*(r^2)+T1*T2*(r^3)];
    C=exp(r*(1-(1/T1 + 1/T2)/2))*[-2*(r^2)+(r^3)+6*r*(T1+T2)-2*(r^2)*(T1+T2)-24*T1*T2+6*T1*T2*r];
    PTT=A*(B+C);
    
    % from the value of P(T1,T2), determine how many data to generate -----
    %Take random draws of the impedance at each point, with the number of
    %draws proportional to the probability at that point
    num=floor(PTT*sthre);
    if(mod(PTT*sthre,1)>=rand(1))
        num=num+1;
    end
    % start to generate ------
    %this loop makes sure we only draw a number of impedances proportional
    %to the probability at the specified point
    for n=1:num
        % generate the random unitary matrix -----
        theta = asin(sqrt(rand(1)));
        psi = rand(1)*2*pi;
        phi = rand(1)*2*pi;
        alpha = rand(1)*2*pi;
        
        u11 = cos(theta)*exp(1i*(psi))*exp(1i*alpha);
        u12 = sin(theta)*exp(1i*(phi))*exp(1i*alpha);
        u21 = -sin(theta)*exp(-1i*(phi))*exp(1i*alpha);
        u22 = cos(theta)*exp(-1i*(psi))*exp(1i*alpha);
        
        U=[u11 u12; u21 u22];
        Ut=U.'; % Transpose, for time-reversal symmetry case
        
        % generate S matrix, Z matrix, and the eigenvalue of Z
        % you may not need all of them
        S=U*[sqrt(1-T1) 0; 0 sqrt(1-T2)]*Ut;
        Z=(I+S)/(I-S);
%         Zeig=eig(Z);
            
        z11(count)=squeeze(Z(1,1));
        z12(count)=squeeze(Z(1,2));
        z21(count)=squeeze(Z(2,1));
        z22(count)=squeeze(Z(2,2));
        
        count=count+1;

        deltaTime = toc(startTime);
        
        if (deltaTime > 10)
            runTime = runTime + deltaTime;
            averagetime = runTime/(count - 1);
            predictedTime = averagetime*(dataN - (count-1));
            dispstring1 = sprintf('Populating Element %d of %d',count,dataN);
            dispstring2 = sprintf('Elapsed Time: %0.3f s, Predicted Remaining Time: %0.3f s',runTime,predictedTime);
            startTime = tic;
            
            if (useGUI == true)
                logMessage(handles.jEditbox,dispstring1);
                logMessage(handles.jEditbox,dispstring2);
            else
                disp(dispstring1)
                disp(dispstring2)
            end
        end
    end
end

Ls=count-1;
z11=z11(1:Ls)';
z12=z12(1:Ls)';
z21=z21(1:Ls)';
z22=z22(1:Ls)';
if num_ports == 2
    Znorm(:,1) = z11;
    Znorm(:,2) = z21;
    Znorm(:,3) = z12;
    Znorm(:,4) = z22;
else
    Znorm = z11;
end

end
