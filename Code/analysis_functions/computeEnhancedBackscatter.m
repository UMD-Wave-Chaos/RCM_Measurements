function eb = computeEnhancedBackscatter(SCf, Freq,foldername,varargin)

if nargin == 4
    savePlots = varargin{1};
else
    savePlots = 0;
end

%need to remove the "unstirred" components

S11s = getStirredSParameterPower(SCf,1);
S21s = getStirredSParameterPower(SCf,3);
S22s = getStirredSParameterPower(SCf,4);

eb = sqrt(S11s.*S22s)./S22s;

%now plot

h1 = figure('Name', 'Enhanced Backscatter');

plot(Freq/1e9,eb,'LineWidth',2);
hold on
plot(Freq/1e9,2*ones(size(Freq)),'--k','LineWidth',2);
grid on
xlabel('Frequency (GHz)')
ylabel('Enhanced Backscatter Coefficient')
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
set(gca,'FontWeight','bold')


if (savePlots)
    saveas(h1,fullfile(foldername,'enhanced_backscatter_coefficient'),'png');
    close (h1)

end