function testRCMNormalizationGating(SCf, Freq, port,alpha,gateTime,maskType,wVal)

%get the 
[Z1,Z2] = compareGatingPosition(SCf,Freq,port,gateTime,maskType,wVal,0);
 
Sc = getSParameterCorrectionFactor(SCf,port);
S3 = mean(Sc.*SCf(:,port,:),3);
Z3 = transformToZ(S3);
 
 Sf = squeeze(SCf(:,port,:));
 Zf = transformToZ(Sf);
 Zavg = mean(Zf,2);
 
 Z1norm = normalizeSinglePortImpedance(Zf,Z1);
 Z2norm = normalizeSinglePortImpedance(Zf,Z2);
 Z3norm = normalizeSinglePortImpedance(Zf,Z3);
 Z4norm = normalizeSinglePortImpedance(Zf,Zavg);
 
 nRCM = 100000;
 nBins = 1000;
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
 subplot(2,1,1)
 hz1MagMeas = histogram(abs(Z1norm),'normalization','pdf','DisplayStyle','stairs','LineWidth',2);
 set(hz1MagMeas,'NumBins',nBins);
 hold on
 hz2MagMeas = histogram(abs(Z1norm),'normalization','pdf','DisplayStyle','stairs','LineWidth',2);
 set(hz2MagMeas,'NumBins',nBins);
 hz3MagMeas = histogram(abs(Z3norm),'normalization','pdf','DisplayStyle','stairs','LineWidth',2);
 set(hz3MagMeas,'NumBins',nBins);
 hz4MagMeas = histogram(abs(Z4norm),'normalization','pdf','DisplayStyle','stairs','LineWidth',2);
 set(hz4MagMeas,'NumBins',nBins);
 hzMagRCM = histogram(abs(Zrcm),'normalization','pdf','LineStyle','-.','DisplayStyle','stairs','LineWidth',2);
 set(hzMagRCM,'NumBins',nBins);
 grid on
 set(gca,'LineWidth',2)
 set(gca,'FontSize',12)
 set(gca,'FontWeight','bold')
 lstring = sprintf('|Z_{%s}|',indstring{port});
 xlabel(lstring);
 ylabel('PDF');
 tstring = sprintf('PDF of |Z_{%s}|',indstring{port});
 title(tstring);
  legend('Gated S','Gated Z','Ungated <Z>','Ungated <Z_c>','RCM');
  
 subplot(2,1,2)
 hz1PhaseMeas = histogram(angle(Z1norm),'normalization','pdf','DisplayStyle','stairs','LineWidth',2);
 set(hz1PhaseMeas,'NumBins',nBins);
 hold on
 hz2PhaseMeas = histogram(angle(Z2norm),'normalization','pdf','DisplayStyle','stairs','LineWidth',2);
 set(hz2PhaseMeas,'NumBins',nBins);
 hz3PhaseMeas = histogram(angle(Z3norm),'normalization','pdf','DisplayStyle','stairs','LineWidth',2);
 set(hz3PhaseMeas,'NumBins',nBins);
 hz4PhaseMeas = histogram(angle(Z4norm),'normalization','pdf','DisplayStyle','stairs','LineWidth',2);
 set(hz4PhaseMeas,'NumBins',nBins);
 hzPhaseRCM = histogram(angle(Zrcm),'normalization','pdf','LineStyle','-.','DisplayStyle','stairs','LineWidth',2);
 set(hzPhaseRCM,'NumBins',nBins);
 grid on
 set(gca,'LineWidth',2)
 set(gca,'FontSize',12)
 set(gca,'FontWeight','bold')
 lstring = sprintf('\\angleZ_{%s}',indstring{port});
 xlabel(lstring);
 ylabel('PDF');
 tstring = sprintf('PDF of \\angleZ_{%s}',indstring{port});
 title(tstring);
 legend('Gated S','Gated Z','Ungated <Z>','Ungated <Z_c>','RCM');
