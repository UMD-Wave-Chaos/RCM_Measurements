function coef = correlateRealizations(data,port,varargin)

%% check inputs
if nargin == 3
    foldername = varargin{1};
    savePlots = 1;
else
    savePlots = 0;
end

comparisonIndex = 1;

Scompare = squeeze(data.SCf(:,port,comparisonIndex));

for currentIndex = 1:size(data.SCf,3)
    
    Stest = squeeze(data.SCf(:,port,currentIndex));
    coef(currentIndex)  = abs(corr(Stest,Scompare));
end


if port == 1
    portString = 11;
elseif port == 2
    portString = 12;
elseif port == 3
    portString = 21;
elseif port == 4
    portString = 22;
end

hh1 = figure;
plot(coef,'LineWidth',2);
grid on
xlabel('Realization')
ylabel('Correlation Coefficient')
tstring = sprintf('Correlation Coefficient for S_{%d}',portString);
title(tstring);
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');

if savePlots
    fString = sprintf('correlation_coefficient_%d',portString);
    saveas(hh1,fullfile(foldername,fString),'png');

    close(hh1)
end