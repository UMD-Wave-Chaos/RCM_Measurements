function z11 = T_method_generator_JenHao(LossP, dataN)
%%%%%%%%%%%%%%%%%%% Input parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
% Loss parameter: LossP  
% The number of data: dataN=1000000; % the total number of samples is in the order of this value
% Here input the smoothness threshold: 
sthre=10/(LossP^2); % A smaller threshold makes the generated proballity distribution more smooth and finer

% A larger "dataN" or a smaller "sthre" makes the statistical result more
% accurate and also takes longer time. However, this is necessary for higher
% loss cases.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Compute the joint PDF of T1 and T2
r=4*pi*LossP;  % r is the "gamma" parameter in Brouwer and Beenakker's paper
               % Sameer and Henry have proved gamma = 4*pi*alpha 

I=[1 0;0 1];
s11=zeros(1,dataN);
s12=zeros(1,dataN);
s22=zeros(1,dataN);
z11=zeros(1,dataN);
z12=zeros(1,dataN);
z22=zeros(1,dataN);

reso=1000; % these two lines is for plotting the joint PDF of T1 and T2 for checking, not really necessary
PDFofT=zeros(reso+1,reso+1); %

totalrun=0; % Because the probability < 1, the totalrun will be less than the number of generated samples
            % In extreme cases (very high or low loss), a lot of "runs"
            % will NOT generate any results.
count=1;
while(count<=dataN)
    
    totalrun=totalrun+1;
    % randomly pick a point and then compute P(T1,T2) --------------
    T1=rand(1);
    T2=rand(1);
    
    A=(1/8)*(T1^(-4))*(T2^(-4))*abs(T1-T2);
    B=exp((-1/2)*r*(1/T1 + 1/T2))*[2*(r^2)+(r^3)-6*(T1+T2)*r-4*(T1+T2)*(r^2)-(T1+T2)*(r^3)+24*T1*T2+18*T1*T2*r+6*T1*T2*(r^2)+T1*T2*(r^3)];
    C=exp(r*(1-(1/T1 + 1/T2)/2))*[-2*(r^2)+(r^3)+6*r*(T1+T2)-2*(r^2)*(T1+T2)-24*T1*T2+6*T1*T2*r];
    PTT=A*(B+C);
    
    % from the value of P(T1,T2), determine how many data to generate -----
    num=floor(PTT*sthre);
    if(mod(PTT*sthre,1)>=rand(1))
        num=num+1;
    end
    
    % start to generate ------
    for n=1:num
        % generate the random unitary matrix -----
        theta = asin(sqrt(rand(1)));
        psi = rand(1)*2*pi;
        phi = rand(1)*2*pi;
        alpha = rand(1)*2*pi;

        u11 = cos(theta)*exp(i*(psi))*exp(i*alpha);
        u12 = sin(theta)*exp(i*(phi))*exp(i*alpha);
        u21 = -sin(theta)*exp(-i*(phi))*exp(i*alpha);
        u22 = cos(theta)*exp(-i*(psi))*exp(i*alpha);

        U=[u11 u12; u21 u22];
        Ut=U.'; % Transpose, for time-reversal symmetry case
        
        % generate S matrix, Z matrix, and the eigenvalue of Z
        % you may not need all of them
        S=U*[sqrt(1-T1) 0; 0 sqrt(1-T2)]*Ut;
        Z=(I+S)/(I-S);
        % Zeig=eig(Z);
        
%         s11(count)=squeeze(S(1,1));
%         s12(count)=squeeze(S(1,2));
%         s22(count)=squeeze(S(2,2));
%         
        z11(count)=squeeze(Z(1,1));
        z12(count)=squeeze(Z(1,2));
        z22(count)=squeeze(Z(2,2));
        
        count=count+1;
        PDFofT(round(reso*T1)+1,round(reso*T2)+1)=PDFofT(round(reso*T1)+1,round(reso*T2)+1)+1;
        if(mod(count,dataN/100)==0)
            count
        end              
    end    
end

Ls=count-1;

% s11=s11(1:Ls);
% s12=s12(1:Ls);
% s22=s22(1:Ls);

z11=z11(1:Ls);
z12=z12(1:Ls);
z22=z22(1:Ls);

% save(strcat('RMT_S_Z_',num2str(LossP),'.mat'),'s11','s12','s22','z11','z12','z22','Ls');
end