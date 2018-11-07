function ZRCM = computeDistributions(Znormf,alpha, nBins,nRCM,varargin)

if nargin >= 5
    savePlots = true;
    foldername = varargin{1};
end

if (nargin == 6)
    useGUI = true;
    handles = varargin{2};
else
    useGUI = false;
end
tic;

hMagFigure = figure('Position',[10 100 800 800],'NumberTitle', 'off', 'Name', 'Normalized Magnitude PMF from Measurement');
hPhaseFigure = figure('Position',[10 100 800 800],'NumberTitle', 'off', 'Name', 'Normalized Phase PMF from Measurement');
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
    
    figure(hMagFigure);
    subplot(2,2,port)
    hzMagMeas(port) = histogram(abs(Zmeas),'normalization','pdf','DisplayStyle','stairs','LineWidth',2);
    set(hzMagMeas(port),'NumBins',nBins);
    hold on
    hzMagRCM(port) = histogram(abs(Zrcm),'normalization','pdf','LineStyle','-.','DisplayStyle','stairs','LineWidth',2);
    set(hzMagRCM(port),'NumBins',nBins);
    grid on
    set(gca,'LineWidth',2)
    set(gca,'FontSize',12)
    set(gca,'FontWeight','bold')
    lstring = sprintf('|Z_{%s}|',indstring{port});
    xlabel(lstring);
    ylabel('PDF');
    tstring = sprintf('PDF of |Z_{%s}|',indstring{port});
    title(tstring);
    legend('Measured','RCM');
    
    
    figure(hPhaseFigure)
    subplot(2,2,port)
    hzPhaseMeas(port) = histogram(angle(Zmeas),'normalization','pdf','DisplayStyle','stairs','LineWidth',2);
    set(hzPhaseMeas(port),'NumBins',nBins);
    hold on
    hzPhaseRCM(port) = histogram(angle(Zrcm),'normalization','pdf','LineStyle','-.','DisplayStyle','stairs','LineWidth',2);
    set(hzPhaseRCM(port),'NumBins',nBins);
    grid on
    set(gca,'LineWidth',2)
    set(gca,'FontSize',12)
    set(gca,'FontWeight','bold')
    lstring = sprintf('\\angleZ_{%s}',indstring{port});
    xlabel(lstring);
    ylabel('PDF');
    tstring = sprintf('PDF of \\angleZ_{%s}',indstring{port});
    title(tstring);
    legend('Measured','RCM');

    time = toc;

	averagetime = time/port;
	predictedTime = averagetime*(4-port);
    lstring = sprintf('Normalizing realization %d of %d, time = %s s, predicted remaining time = %s s',port,4,num2str(time), num2str(predictedTime));
    if (useGUI == true)
        logMessage(handles.jEditbox,lstring);
    else
        disp(lstring)
    end
end

if (savePlots == true)
    saveas(hMagFigure,fullfile(foldername,'PDF_Comparison_Mag'),'png');
    saveas(hPhaseFigure,fullfile(foldername,'PDF_Comparison_Phase'),'png');
    close(hPhaseFigure)
    close(hMagFigure)
end