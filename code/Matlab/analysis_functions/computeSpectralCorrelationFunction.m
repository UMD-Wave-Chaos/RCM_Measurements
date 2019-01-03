% function [rho,dF] = computeSpectralCorrelationFunction(data,port)
%[rho,dF] = computeSpectralCorrelationFunction(data,port)
%
%This function computes and plots the spectral correlation function of the
%S parameters for a given port index
%
%Inputs:
%data - the data structure that contains the frequency domain cavity S
%parameter measurements (data.SCf is an nFrequencies x n^2 ports x
%nRealizations matrix)
%port - the port index to compute the spectral correlation function for, 1
%is S11, 2 is S12, 3 is S21, and 4 is S22
%
%Outputs:
%rho - the spectral correlation function
%dF - the normalized frequency in units of deltaF/deltaF_Weyl

%preset values - expect the cavity volume to be 1.92 m^3 and set the speed
%of light (c). Also limit the number of points to be evaluated
V = 1.92;
c = 2.99792458e8;
stopdF = 500;
stopInd = 300;

startIndex = floor(mean(1:length(data.Freq)));

meanF = mean(data.Freq);

%get the comparison frequency of the measurements
f0 = data.Freq(startIndex);

%get the S parameter we are interested in
Sp = squeeze(data.SCf(:,port,:));



%compute the normalized frequency 
%delta_F is just the spacing between samples in frequency
deltaF = data.Freq(2) - data.Freq(1);
%delta_F_Weyl is then computed based on the given formulas
deltaFWeyl = c^3/(4*f0^2*V);
%the ratio becomes a scale factor
sf = deltaF/deltaFWeyl;
%create a running index and scale to get the normalized frequency vector
dF = sf*(1:length(data.Freq));

%create the empty vector for the spectral correlation function
rho = zeros(1,length(data.Freq));

%set the reference S parameter to the specified starting frequency
S0 = abs(Sp(startIndex,:));

%loop over the frequency indices, these act as 
for counter = 1:stopInd
   
   %get the value of the S parameter at f0 + deltaF
   Sdf = abs(Sp(startIndex + counter - 1,:));
   
   %compute the numerator
   num = mean(S0.*Sdf,2) - mean(S0,2)*mean(Sdf,2);
   %compute the denominator
   den = std(S0)*std(Sdf);
   %compute the spectral correlation function at the current frequency
   %index
   rho(counter) = num/den;

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
plot(dF,rho,'LineWidth',2)
xlim([0 dF(stopInd)]);
xlabel('\delta_f/\Delta_{f Weyl}')
ylabel('\rho')
grid on
hold on
plot(dF,zeros(size(dF)),'--k','LineWidth',2)

sstring2 = sprintf('\\Delta_{f Weyl} = %0.2f kHz',deltaFWeyl/1e3);
sstring3 = sprintf('\\delta_f = %0.2f kHz',deltaF/1e3);
sstring1 = sprintf('f_0 = %0.2f GHz',f0/1e9);
text(dF(floor(stopInd/2)),0.75,sstring1,'FontSize',12,'FontWeight','bold');
text(dF(floor(stopInd/2)),0.65,sstring2,'FontSize',12,'FontWeight','bold');
text(dF(floor(stopInd/2)),0.55,sstring3,'FontSize',12,'FontWeight','bold');
set(gca,'FontWeight','bold');
set(gca,'FontSize',12)
set(gca,'LineWidth',2)
tstring = sprintf('Spectral Correlation Coefficient for S_{%d}',portString);
title(tstring);