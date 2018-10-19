function[Tau] = getTau(t,SC,l,index,foldername)
% Input: SC = the complex inverse tranformed a S parameter vector (time domain)
%         t = time domain vector corresponding to SC
%         l = approximate elctrical length of antenna (meters)       
%         index = S parameter index (1 == 11, 2 == 12, 3 == 21, 4 == 22)
% Output: Tau = the 1/e energy decay rate
       
fplot = 1;                                                                  % Set to 1 to plot, 0 to skip plot
b = find(abs(t-((l*500)/3E8)) == min(abs(t-((l*500)/3E8))));              % beginging index removing prompt reflection and possible short orbit (1000 electric lengths)
f = find(abs(t-((l*1500)/3E8)) == min(abs(t-((l*1500)/3E8))));              % ending index stoppping at 2000 electric lengths
m = ceil((b+(f-b)/2));                                                       % location of text on plot
sf = 1000; af = 10000;                                                      % smoothing factor, amplitude factor
smoothBsf = af*smooth((abs(SC(b:f))),sf);

% Fit the data using a superposition of two exponentials.
fTYPE = fittype('exp1');
g11 = fit(t((b:f),1),smoothBsf, fTYPE);                                     % fit data to exponential

% Calculate tau, 1/e energy decay time 
Tau = 1/(-2*g11.b);                                                         % 1/e 'energy' decay time

% Plot fitted curve in linear and log scale

    if fplot == 1
        
        if (index == 1)
            indstring = '11';
        elseif (index == 2)
            indstring = '12';
        elseif (index == 3)
            indstring = '21';
        elseif (index == 4)
            indstring = '22';
        end
        h =  figure; 
        subplot(2,1,1)
        plot(t(b:f)/1E-6,abs(SC(b:f)),'g'); 
        hold on; 
        xlabel('Time (\mus)');
        plot(t(b:f)/1E-6,smoothBsf/af,'--r','LineWidth',2);
        plot(t(b:f)/1E-6,(g11(t(b:f))/af), 'k','LineWidth',2);
        ystring = sprintf('<|S_{%s}> (V)',indstring);
        ylabel(ystring)
        grid on
        legend ('Measured','Smoothed','Fit');
        set(gca,'LineWidth',2);
        set(gca,'FontSize',12);
        set(gca,'FontWeight','bold');
    
        text(t(m)*1e6,1.2*max(smoothBsf)/af,{'g(x) = a*exp(b*x)';...
            [' a = ',num2str(g11.a/af)]; ...
            [' b = ',num2str(g11.b)]; ...
            },'FontSize',12,'FontWeight','bold');
        
        subplot(2,1,2)
        plot(t(b:f)/1E-6,20*log10(abs(SC(b:f))),'g'); 
        hold on;
        plot(t(b:f)/1E-6, 20*log10(smoothBsf/af),'--r','LineWidth',2);
        plot(t(b:f)/1E-6,20*log10(g11(t(b:f))/af), 'k','LineWidth',2);
        xlabel('Time (\mus)');
        ystring = sprintf('<|S_{%s}> (dB)',indstring);
        ylabel(ystring)
        legend ('Measured','Smoothed','Fit');
        grid on
        set(gca,'LineWidth',2);
        set(gca,'FontSize',12);
        set(gca,'FontWeight','bold');
        
        text(t(m)*1e6, 20*log10(smoothBsf(m-b)/af)+10,['\tau = ' num2str(Tau*1e6) '\mus'],'FontSize',12,'FontWeight','bold' );
        
        fname = sprintf('SCav%s_tau_estimate',indstring);
        saveas(h,fullfile(foldername,fname),'png')
        close(h)

    end
end