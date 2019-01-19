function beta = minZNormalization(port, alpha,data,gateTime)
% minZNormalization(port, alpha,data)

beta0 = 1.2;

Zf = transformToZ2Port(data.SCf);

[Sf,~] = applyTimeGating(data.SCf(:,port,:),data.Freq,gateTime,0,0.5);
%transform to Z
Zfg = transformToZSinglePort(Sf);
%take the mean value - Z1 is the output signal that was gated in the S
%domain
Z1 = mean(Zfg,2);
 
period = .110; %in GHz
nPointsPerGHz = length(Zf)/(data.Freq(end) - data.Freq(1))*1e9;
m = nPointsPerGHz * period*2;
Zavg = squeeze(mean(Zf(:,port,:),3));
Zavg_bar = movmean(Zavg,m);

figure
plot(data.Freq/1e9,abs(Zavg),'LineWidth',2);
hold on
plot(data.Freq/1e9,abs(Zavg_bar),'LineWidth',2);
plot(data.Freq/1e9,abs(Z1),'LineWidth',2);
legend('Zn','Zw','Zg');
grid on
xlabel('Frequency (GHz)')
ylabel('Magnitude (ohms)')

beta = zeros(50,1);
fval = zeros(50,1);
zeta = zeros(length(Zf),50);
for cnt = 1:50
Zc = squeeze(Zf(:,port,cnt));

%f = @(beta)ZNormMinimizationFunction(beta, Zc, Zavg_bar, Zavg);
f = @(beta)ZNormMinimizationFunction(beta, Zc, Z1, Zavg);

options = optimoptions('fminunc','Algorithm','quasi-newton','Display','off');
[beta(cnt), fval(cnt)] = fminunc(f,beta0,options);



%normalize the impedance
zeta(:,cnt) = real(Zavg).^(-0.5) .* (Zc -1j*(beta(cnt)*imag(Z1) + (1-beta(cnt)) * imag(Zavg))).* real(Zavg).^(-0.5);

end

figure
plot(1:50,beta,'LineWidth',2);
xlabel('Realization')
ylabel('\beta (unitless)')
grid on
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');
set(gca,'LineWidth',2);

dispstring = sprintf('Beta: Mean: %0.4f, Max: %0.4f, Min: %0.4f',mean(beta),max(beta),min(beta));
disp(dispstring);

dispstring = sprintf('fVal: Mean: %0.4f, Max: %0.4f, Min: %0.4f',mean(fval),max(fval),min(fval));
disp(dispstring);

 nRCM = 100000;
 nBins = 1000;
 Zrcm  =  genPMFrcm(alpha,1, nRCM);
 
 indstring = {'11','12','21','22'};
 
 hh1 = figure;
 subplot(2,1,1)
 hzMagRCM = histogram(real(Zrcm),'normalization','pdf','LineStyle','-.','DisplayStyle','stairs','LineWidth',2);
 set(hzMagRCM,'NumBins',nBins);
 hold on
 hz1MagMeas = histogram(real(zeta),'normalization','pdf','DisplayStyle','stairs','LineWidth',2);
 set(hz1MagMeas,'NumBins',nBins);
 grid on
 set(gca,'LineWidth',2)
 set(gca,'FontSize',12)
 set(gca,'FontWeight','bold')
 lstring = sprintf('Re\\{Z_{%s}\\}',indstring{port});
 xlabel(lstring);
 ylabel('PDF');
 tstring = sprintf('PDF of Re\\{Z_{%s}\\}',indstring{port});
 title(tstring);
 legend('RCM','Measurement');
 
 subplot(2,1,2)
 hzPhaseRCM = histogram(imag(Zrcm),'normalization','pdf','LineStyle','-.','DisplayStyle','stairs','LineWidth',2);
 set(hzPhaseRCM,'NumBins',nBins);
 hold on
 hz1PhaseMeas = histogram(imag(zeta),'normalization','pdf','DisplayStyle','stairs','LineWidth',2);
 set(hz1PhaseMeas,'NumBins',nBins);
 hold on
 grid on
 set(gca,'LineWidth',2)
 set(gca,'FontSize',12)
 set(gca,'FontWeight','bold')
 lstring = sprintf('Im\\{Z_{%s}\\}',indstring{port});
 xlabel(lstring);
 ylabel('PDF');
 tstring = sprintf('PDF of Im\\{Z_{%s}\\}',indstring{port});
 title(tstring);
 legend('RCM','Measurement');
 