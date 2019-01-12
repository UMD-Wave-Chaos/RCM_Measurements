function coef = correlateRealizations(data,port)

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

figure
plot(coef,'LineWidth',2);
grid on
xlabel('Realization')
ylabel('Correlation Coefficient')
tstring = sprintf('Correlation Coefficient for S_{%d}',portString);
title(tstring);