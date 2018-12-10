function gatePositionDriver(data, port,varargin)
%gatePositionDriver(data, port)
%gatePositionDriver(data, port,savePlots)
%gatePositionDriver(data, port,savePlots,foldername)

%setup default variables
savePlots = 0;
foldername = pwd;

%check the inputs
if nargin > 2
    savePlots = varargin{1};
end

if nargin > 3
    foldername = varargin{2};
end

%first compute the metric with a Kaiser window
maskType = 1;
wVal = 0.75;
[G1,tt1,windowString1] = testGatingPosition(data,port,maskType,wVal,100,0);

%now compute the metric with a rectangular window
maskType = 0;
[G2,tt2,windowString2] = testGatingPosition(data,port,maskType,wVal,100,0);

%third compute the metric with a Gaussian window
maskType = 3;
wVal = 0.5;
[G3,tt3,windowString3] = testGatingPosition(data,port,maskType,wVal,100,0);


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

hh1 = figure;
plot(tt1*1e9,G1,'LineWidth',2);
hold on
plot(tt2*1e9,G2,'LineWidth',2);
plot(tt3*1e9,G3,'LineWidth',2);
grid on
xlabel('Gate Time (ns)')
ylabel('Difference Metric (%)');
tstring = sprintf('Z_{%s} Difference Gating Z or S',indString);
title(tstring);
set(gca,'LineWidth',2)
set(gca,'FontSize',12)
set(gca,'FontWeight','bold')
lstring1 = sprintf('%s',windowString1);
lstring2 = sprintf('%s',windowString2);
lstring3 = sprintf('%s',windowString3);
legend(lstring1,lstring2,lstring3);

if savePlots
    fname = sprintf('Gating_Difference_port_%d',port);
    saveas(hh1,fullfile(foldername,fname),'png');
    close (hh1)
end
