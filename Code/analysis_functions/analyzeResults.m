function analyzeResults(filename,varargin)

if (nargin == 2)
    useGUI = true;
    handles = varargin{1};
else
    useGUI = false;
end

lstring = 'Starting analysis ...';
if (useGUI == true)
    logMessage(handles.jEditbox,lstring);
else
    disp(lstring)
end

num_ports = 2;

BINS = 1000;       % number of bins to be used in generating a distribution

[t, SCt, Freq, SCf, Srad,V,l,N,NOP,nRCM] = loadData(filename);

[fpath,fname] = fileparts(filename);

foldername = fullfile(fpath,fname);
if exist(foldername,'dir')
    lstring = 'Directory exists, cleaning ...';
    rmdir(fname,'s');
else
    lstring = 'Creating directory ...';
end

if (useGUI == true)
    logMessage(handles.jEditbox,lstring);
else
    disp(lstring)
end

mkdir(fname);



%% Plot the last realization of S parameters in frequency domain

plotSParameters(t,Freq,SCf,SCt,Srad,foldername);

% hfs = figure('NumberTitle', 'off', 'Name', 'S-Parameters (cav) - Frequency Domain Response'); % handle for s parameter plot
% hfsr = figure('NumberTitle', 'off', 'Name', 'S-Parameters (rad) - Frequency Domain Response'); % handle for s parameter plot
% hts = figure('NumberTitle', 'off', 'Name', 'S-Parameters - Time Domain Response'); % handle for s parameter plot
% for i = 1:(num_ports^2)
%     figure(hfs); subplot(num_ports,num_ports,i)
%     plot(Freq/1E9,20*log10(abs(SCf(:,i,end)))); axis tight
%     xlabel('Frequency(GHz)'); ylabel('Log Mag (dB)'); title(['S',fliplr(num2str(str2double(dec2bin(i-1))+11))]); % label the plot
%     figure(hfsr); subplot(num_ports,num_ports,i)
%     plot(Freq/1E9,20*log10(abs(Srad(:,i,end)))); axis tight
%     xlabel('Frequency(GHz)'); ylabel('Log Mag (dB)'); title(['Srad',fliplr(num2str(str2double(dec2bin(i-1))+11))]); % label the plot
%     figure(hts); subplot(num_ports,num_ports,i)
%     plot(t/1E-6,20*log10(abs(SCt(:,i,end)))); axis tight
%     xlabel('Time(\mus)'); ylabel('Log Mag (dB)'); title(['Scav',fliplr(num2str(str2double(dec2bin(i-1))+11))]); % label the plot
% end

plotScavEnsembles(t,Freq,SCt,SCf,foldername);

%% Step 3: Compute Tau, the 1/e fold energy decay time
lstring = 'Computing tau ...';
if (useGUI == true)
    logMessage(handles.jEditbox,lstring);
else
    disp(lstring)
end
for param=1:4
    Tau(param) = getTau(t, mean(abs(SCt(:,param,:)),3), l,param,foldername);                                 % input parameters: the complex time domain S parameter measurements and corresponding time vector, the electrical length of the antenna(m).
end
%% Step 4: Compute the loss parameter (alpha)
alpha = zeros(4,1);
Qcomp = zeros(4,1);
for param=1:4
    [alpha(param), Qcomp(param)] = getalpha(mean(Freq), Tau(param), V);                      %input parameters: the average operational frequency, the 1/e fold energy decay time,
end
%% Step 5: Transform the S parameters (both Srad and Scav) to the Z parameters using the bilinear equations. (~2 min for N = 200)

[Zradf, Zcf] = transformStoZ(Srad, SCf,Freq, handles);

%% Step 6: Normalize the frequency domain measurements using the computed Z parameters in Step 5 (~40 sec for N = 200)

Znormf = normalizeImpedance(Zcf ,Freq, handles);

%% Step 7: Generate a distribution of the normalized Z parameters from Step 6

[Zhist_EXP,Zbin_EXP,Zphist_EXP,Zpbin_EXP] = computeMeasuredDistribution(Znormf,handles);

%% Step 8: Generate a distribution of Z parameters using random coupling model (RCM) using the loss parameter (alpha) computed in Step 4.

[Zhist_RCM,Zbin_RCM, Zphist_RCM,Zpbin_RCM] = computeRCMDistribution(alpha,nRCM,handles);

%% Step 9: Plot the pmf
figure; hold off; clear Zpmf_RCM; clear Zpmf_EXP;
paramlables = cellstr(['11';'12';'21';'22']);
for i = 1:num_ports^2
    p= 10;         
    subplot(num_ports,num_ports,i);
    Zpmf_RCM(:,i) = Zhist_RCM(:,i)./((Zbin_RCM(2,i)-Zbin_RCM(1,i))*sum(Zhist_RCM(:,i))); % Create a pmf from histogram for RCM prediction of the normalized impedance
    Zpmf_EXP(:,i) = Zhist_EXP(:,i)./((Zbin_EXP(2,i)-Zbin_EXP(1,i))*sum(Zhist_EXP(:,i))); % Create a pmf from histogram for measurement of the normalized impedance
    plot(Zbin_RCM(:,i),Zpmf_RCM(:,i),'o-g','MarkerSize',2); hold on;             %Plot the pmf (divide by the area under curve) of the RCM predicted normalized impedance
    plot(Zbin_EXP(:,i),Zpmf_EXP(:,i),'*-k','MarkerSize',5);       %Plot the pmf (divide by the area under curve) of the measured normalized impedance
    %              set(gca, 'XTickLabel', '', 'YTickLabel', '');
    legend('RCM Prediction','Measurement')
    xlabel(strcat('Normalized |Z_{',char(paramlables{i}),'}|')); ylabel('Probability Density Function'); title(['PDF of |Z_{',char(paramlables{i}),'}^{norm}| for Cylindrical Chamber with Q_{comp} = ',...
        num2str(round(Qcomp(i))),', \alpha = ',num2str(round(alpha(i))),', GT=',num2str(floor(p*(5/3))+0.01*round(mod(p*100*(5/3),100))),'ns']);
    axis tight
end
figure; hold off; clear Zppmf_RCM; clear Zppmf_EXP;
for i = 1:num_ports^2; 
    p= 10;         
    subplot(num_ports,num_ports,i);
    Zppmf_RCM(:,i) = Zphist_RCM(:,i)./((Zpbin_RCM(2,i)-Zpbin_RCM(1,i))*sum(Zphist_RCM(:,i))); % Create a pmf from histogram for RCM prediction of the normalized impedance
    Zppmf_EXP(:,i) = Zphist_EXP(:,i)./((Zpbin_EXP(2,i)-Zpbin_EXP(1,i))*sum(Zphist_EXP(:,i))); % Create a pmf from histogram for measurement of the normalized impedance
    plot(Zpbin_RCM(:,i),Zppmf_RCM(:,i),'o-g','MarkerSize',2); hold on;             %Plot the pmf (divide by the area under curve) of the RCM predicted normalized impedance
    plot(Zpbin_EXP(:,i),Zppmf_EXP(:,i),'*-k','MarkerSize',5);       %Plot the pmf (divide by the area under curve) of the measured normalized impedance
    %              set(gca, 'XTickLabel', '', 'YTickLabel', '');
    legend('RCM Prediction','Measurement')  
    xlabel(strcat('Normalized |Z_{',char(paramlables{i}),'}|')); ylabel('Probability Density Function'); title(['PDF of phase(Z_{',char(paramlables{i}),'}^{norm}) for Cylindrical Chamber with Q_{comp} = ',...
        num2str(round(Qcomp(i))),', \alpha = ',num2str(round(alpha(i))),', GT=',num2str(floor(p*(5/3))+0.01*round(mod(p*100*(5/3),100))),'ns']);
    axis tight
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%