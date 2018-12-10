function [G,tt,windowString] = testGatingPosition(data,port,varargin)
%[G,tt,windowString] = testGatingPosition(data,port,maskType,wVal,nTimes,generatePlots)

%% check the inputs
if nargin >= 3
    maskType = varargin{1};
else   
    maskType = 0;
end

if nargin >= 4
    wVal = varargin{2};
else
    wVal = 2.5;
end

if nargin >= 5
    nTimes = varargin{3};
else
    nTimes = 100;
end

if nargin == 6
    generatePlots = varargin{4};
else
    generatePlots = 1;
end


tt = zeros(nTimes,1);
G = zeros(nTimes,1);
for cnt = 1:100
 tt(cnt) = cnt*1e-9;   
 [Z1,Z2] = compareGatingPosition(data,port,tt(cnt),maskType,wVal,0);
 G(cnt) = 100*sum(abs(Z2 - Z1))/sum(abs(Z2 + Z1));
 disp('*****************************************************************');
 dispString = sprintf('Computing Gate Time %0.1f ns, # %d of %d',tt(cnt)*1e9,cnt,nTimes);
 disp(dispString);
end

switch port
    case 1
        indString = '11';
    case 2
        indString = '12';
    case 3
        indString = '21';
    case 4
        indString = '22';
    otherwise
        indString = 'NA';
end

 switch maskType
     case 1
         windowString = sprintf('Kaiser Window, Beta = %0.3f',wVal);
     case 2
         windowString = sprintf('BlackmanHarris Window');
     case 3
         windowString = sprintf('Gaussian Window, Alpha = %0.3f',wVal);
     case 4
         windowString = sprintf('Hamming Window');
     case 5
         windowString = sprintf('Bartlett Window');
     case 6
         windowString = sprintf('Chebyshev Window, Sidelobe Attenuation = %0.1f dB', wVal);
     otherwise
         windowString = sprintf('Rectangular Window');
 end

if generatePlots
    figure
    plot(tt*1e9,G,'LineWidth',2);
    hold on
    grid on
    xlabel('Gate Time (ns)')
    ylabel('Difference Metric');
    tstring = sprintf('Z_{%s} Difference Gating Z or S with %s',indString,windowString);
    title(tstring);
    set(gca,'LineWidth',2)
    set(gca,'FontSize',12)
    set(gca,'FontWeight','bold')
end