function [K,Su,Ss] = plotKFactor(SCf,Freq,index,varargin)

%% check inputs
if nargin == 4
    foldername = varargin{1};
    savePlots = 1;
else
    savePlots = 0;
end


switch index
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

[K,Su,Ss] = getKFactor(SCf,index);
h1 = figure;
plot(Freq/1e9,K,'LineWidth',2);
grid on
xlabel('Frequency (GHz)')
ylabel('K Factor')
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');
tstring = sprintf('K Factor for S_{%s}',indString);
title(tstring);

if (savePlots)
    fname = sprintf('Port_%s_K-factor',indString);
    saveas(h1,fullfile(foldername,fname),'png');
    close (h1)
end