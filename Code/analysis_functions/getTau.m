function[Tau] = getTau(t,SCt,l,foldername,varargin)
% Input: SC = the complex inverse tranformed a S parameter vector (time domain)
%         t = time domain vector corresponding to SC
%         l = approximate elctrical length of antenna (meters)       
% Output: Tau = the 1/e energy decay rate
      
if nargin == 5
    savePlots = varargin{1};
else
    savePlots = 0;
end

af = 10000;
sf = 1000;

for counter = 1:4
    
    SC = mean(abs(SCt(:,counter,:)),3);
    
    [Tau(counter), g11, smoothBsf, startIndex, stopIndex] = computeTau(t,SC,l, af, sf); 
    
    %plot the results
    %get the S parameter index
    if (counter == 1)
        indstring = '11';
    elseif (counter == 2)
        indstring = '12';
    elseif (counter == 3)
        indstring = '21';
    elseif (counter == 4)
        indstring = '22';
    end
    
    %get the midpoint
    m = ceil((startIndex + (stopIndex - startIndex)/2)); 
    
    % Plot fitted curve in linear and log scale
    h =  figure; 
    subplot(2,1,1)
    plot(t(startIndex:stopIndex)/1E-6,abs(SC(startIndex:stopIndex)),'g'); 
    hold on; 
    xlabel('Time (\mus)');
    plot(t(startIndex:stopIndex)/1E-6,smoothBsf/af,'--r','LineWidth',2);
    plot(t(startIndex:stopIndex)/1E-6,(g11(t(startIndex:stopIndex))/af), 'k','LineWidth',2);
    ystring = sprintf('<|S_{%s}> (V)',indstring);
    ylabel(ystring)
    grid on
    legend ('Measured','Smoothed','Fit');
    set(gca,'LineWidth',2);
    set(gca,'FontSize',12);
    set(gca,'FontWeight','bold');

    text(t(m)*1e6,1.6*smoothBsf(m-startIndex)/af,{'g(x) = a*exp(b*x)';...
        [' a = ',num2str(g11.a/af)]; ...
        [' b = ',num2str(g11.b)]; ...
        },'FontSize',12,'FontWeight','bold');

    subplot(2,1,2)
    plot(t(startIndex:stopIndex)/1E-6,20*log10(abs(SC(startIndex:stopIndex))),'g'); 
    hold on;
    plot(t(startIndex:stopIndex)/1E-6, 20*log10(smoothBsf/af),'--r','LineWidth',2);
    plot(t(startIndex:stopIndex)/1E-6,20*log10(g11(t(startIndex:stopIndex))/af), 'k','LineWidth',2);
    xlabel('Time (\mus)');
    ystring = sprintf('<|S_{%s}> (dB)',indstring);
    ylabel(ystring)
    legend ('Measured','Smoothed','Fit');
    grid on
    set(gca,'LineWidth',2);
    set(gca,'FontSize',12);
    set(gca,'FontWeight','bold');

    text(t(m)*1e6, 20*log10(smoothBsf(m-startIndex)/af)+5,['\tau = ' num2str(Tau(counter)*1e6) '\mus'],'FontSize',12,'FontWeight','bold' );

    if (savePlots == 1)
        fname = sprintf('SCav%s_tau_estimate',indstring);
        saveas(h,fullfile(foldername,fname),'png')
        close(h)
    end
end
end
