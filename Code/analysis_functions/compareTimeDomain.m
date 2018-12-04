function compareTimeDomain(data,index)
%Assumes frequency domain and time domain measured data are present in the
%data structure passed in


Sf = squeeze(data.SCf(:,index,:));
[N,M] = size(Sf);

fSpan = data.Freq(end) - data.Freq(1);
df = fSpan/(N-1);

zPadLength = 2000;%ceil(N/2);
zN = N + 2*zPadLength;

Sf1 = zeros(zN,M);
Sf1(1:zPadLength) = Sf(1);
Sf1(zPadLength+N+1:end) = Sf(end);
Sf1(zPadLength+1: zPadLength+N,:) = Sf;

% 
Sf1 = [flipud(Sf1);Sf1];
zFspan = 2*fSpan + 2*zPadLength*df;
% 
zFspan = 2*(fSpan + 2*zPadLength*df);


%for(counter = 1:M)
[SCt,t] = ifftS(Sf1,zFspan);
%end

SCt = SCt*1.25*zN/N*2;

%[SCt,t] = ifftS(Sf1,data.Freq(end) - data.Freq(1));

% [SCt,t] = getTimeDomainSParameters(data.SCf,data.Freq);

pData1 = mean(abs(SCt),2);
pData2 = mean(abs(data.SCt(:,index,:)),3);

semilogy(t,abs(pData1));
hold on
semilogy(data.t,abs(pData2));

