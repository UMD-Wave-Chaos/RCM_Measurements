function ZRCM = computeDistributions(Znormf,alpha, nBins,nRCM,varargin)

if nargin >= 5
    savePlots = true;
    foldername = varargin{1};
else
    savePlots = false;
end

if (nargin == 6)
    useGUI = true;
    handles = varargin{2};
else
    useGUI = false;
end
tic;

hRealFigure = figure('Position',[10 100 800 800],'NumberTitle', 'off', 'Name', 'Normalized Real PMF from Measurement');
hImagFigure = figure('Position',[10 100 800 800],'NumberTitle', 'off', 'Name', 'Normalized Imag PMF from Measurement');
indstring = {'11','12','21','22'};

for port = 1:4
    
    lstring = sprintf('Computing RCM distribution for port %d',port);
    if (useGUI == true)
        logMessage(handles.jEditbox,lstring);
    else
        disp(lstring)
    end
    
    Zmeas = Znormf(:,port,:);
    Zmeas = Zmeas(:);
    ZRCM_2port =  genPMFrcm(alpha(port),2, nRCM);
    Zrcm = ZRCM_2port(:,port);
    
    ZRCM(:,port) = Zrcm(1:nRCM);
    
    figure(hRealFigure);
    subplot(2,2,port)
    hzRealMeas(port) = histogram(real(Zmeas),'normalization','pdf','DisplayStyle','stairs','LineWidth',2);
    set(hzRealMeas(port),'NumBins',nBins);
    hold on
    hzRealRCM(port) = histogram(real(Zrcm),'normalization','pdf','LineStyle','-.','DisplayStyle','stairs','LineWidth',2);
    set(hzRealRCM(port),'NumBins',nBins);
    grid on
    set(gca,'LineWidth',2)
    set(gca,'FontSize',12)
    set(gca,'FontWeight','bold')
    lstring = sprintf('Re\{Z_{%s}\}',indstring{port});
    xlabel(lstring);
    ylabel('PDF');
    tstring = sprintf('PDF of Re\{Z_{%s}\}',indstring{port});
    title(tstring);
    legend('Measured','RCM');
    
    figure(hImagFigure)
    subplot(2,2,port)
    hzImagMeas(port) = histogram(imag(Zmeas),'normalization','pdf','DisplayStyle','stairs','LineWidth',2);
    set(hzImagMeas(port),'NumBins',nBins);
    hold on
    hzImagRCM(port) = histogram(imag(Zrcm),'normalization','pdf','LineStyle','-.','DisplayStyle','stairs','LineWidth',2);
    set(hzImagRCM(port),'NumBins',nBins);
    grid on
    set(gca,'LineWidth',2)
    set(gca,'FontSize',12)
    set(gca,'FontWeight','bold')
    lstring = sprintf('Im\{Z_{%s}\}',indstring{port});
    xlabel(lstring);
    ylabel('PDF');
    tstring = sprintf('PDF of Im\{Z_{%s}\}',indstring{port});
    title(tstring);
    legend('Measured','RCM');

    time = toc;

	averagetime = time/port;
	predictedTime = averagetime*(5-port);
    lstring = sprintf('Normalizing realization %d of %d, time = %s s, predicted remaining time = %s s',port,4,num2str(time), num2str(predictedTime));
    if (useGUI == true)
        logMessage(handles.jEditbox,lstring);
    else
        disp(lstring)
    end
end

if (savePlots == true)
    saveas(hRealFigure,fullfile(foldername,'PDF_Comparison_Real'),'png');
    saveas(hImagFigure,fullfile(foldername,'PDF_Comparison_Imag'),'png');
    close(hRealFigure)
    close(hImagFigure)
end