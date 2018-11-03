function plotKFactor(SCf,Freq,index)

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

plot(Freq/1e9,getKFactor(SCf,index),'LineWidth',2);
grid on
xlabel('Frequency (GHz)')
ylabel('K Factor')
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');
tstring = sprintf('K Factor for S_{%s}',indString);
title(tstring);