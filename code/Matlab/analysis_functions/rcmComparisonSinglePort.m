function rcmComparisonSinglePort(SCf, Freq, port,alpha,gateTime,nRCM,nBins,maskType,wVal)


[Sf,~] = applyTimeGating(SCf(:,port,:),Freq,gateTime,maskType,wVal);
%transform to Z
Zfg = transformToZSinglePort(Sf);
%take the mean value - Z1 is the output signal that was gated in the S
%domain
Z1 = mean(Zfg,2);

Sf = squeeze(SCf(:,port,:));
Zf = transformToZSinglePort(Sf);

Z1norm = normalizeSinglePortImpedance(Zf,Z1);
Zavg = mean(Zf,2);

 Zrcm  =  genPMFrcm(alpha,1, nRCM);
 
 indstring = {'11','12','21','22'};
 
 switch maskType
     case 1
         windowString = sprintf('Kaiser Window, Beta = %0.3f',wVal);
     case 2
         windowString = sprintf('BlackmanHarris Window');
     case 3
         windowString = sprintf('Gaussian Window, Alpha = %0.3f',wVal);
     case 4
         windowString = sprintf('Hamming Window');
     case 5
         windowString = sprintf('Bartlett Window');
     case 6
         windowString = sprintf('Chebyshev Window, Sidelobe Attenuation = %0.1f dB', wVal);
     otherwise
         windowString = sprintf('Rectangular Window');
 end

 fname = sprintf('Gate Time = %0.3f ns, %s',gateTime*1e9,windowString);
 
 hh1 = figure('name',fname);
 subplot(1,2,1)
  hzMagRCM = histogram(real(Zrcm),'normalization','pdf','LineStyle','-.','DisplayStyle','stairs','LineWidth',2);
 set(hzMagRCM,'NumBins',nBins);
 hold on
 hz1MagMeas = histogram(real(Z1norm),'normalization','pdf','DisplayStyle','stairs','LineWidth',2);
 set(hz1MagMeas,'NumBins',nBins);
 grid on
 set(gca,'LineWidth',2)
 set(gca,'FontSize',12)
 set(gca,'FontWeight','bold')
 lstring = sprintf('Re\\{z_{%s}\\}',indstring{port});
 xlabel(lstring);
 ylabel('PDF');
 tstring = sprintf('PDF of Re\\{z_{%s}\\}',indstring{port});
 title(tstring);
 legend('Predicted','Measured');

  
 subplot(1,2,2)
  hzPhaseRCM = histogram(imag(Zrcm),'normalization','pdf','LineStyle','-.','DisplayStyle','stairs','LineWidth',2);
 set(hzPhaseRCM,'NumBins',nBins);
  hold on
 hz1PhaseMeas = histogram(imag(Z1norm),'normalization','pdf','DisplayStyle','stairs','LineWidth',2);
 set(hz1PhaseMeas,'NumBins',nBins);
 grid on
 set(gca,'LineWidth',2)
 set(gca,'FontSize',12)
 set(gca,'FontWeight','bold')
 lstring = sprintf('Im\\{z_{%s}\\}',indstring{port});
 xlabel(lstring);
 ylabel('PDF');
 tstring = sprintf('PDF of Im\\{z{%s}\\}',indstring{port});
 title(tstring);
 legend('Predicted','Measured');

