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


%% Plot the last realization of S parameters in frequency domain
hfs = figure('NumberTitle', 'off', 'Name', 'S-Parameters (cav) - Frequency Domain Response'); % handle for s parameter plot
hfsr = figure('NumberTitle', 'off', 'Name', 'S-Parameters (rad) - Frequency Domain Response'); % handle for s parameter plot
hts = figure('NumberTitle', 'off', 'Name', 'S-Parameters - Time Domain Response'); % handle for s parameter plot
for i = 1:(num_ports^2)
    figure(hfs); subplot(num_ports,num_ports,i)
    plot(Freq/1E9,20*log10(abs(SCf(:,i,end)))); axis tight
    xlabel('Frequency(GHz)'); ylabel('Log Mag (dB)'); title(['S',fliplr(num2str(str2double(dec2bin(i-1))+11))]); % label the plot
    figure(hfsr); subplot(num_ports,num_ports,i)
    plot(Freq/1E9,20*log10(abs(Srad(:,i,end)))); axis tight
    xlabel('Frequency(GHz)'); ylabel('Log Mag (dB)'); title(['Srad',fliplr(num2str(str2double(dec2bin(i-1))+11))]); % label the plot
    figure(hts); subplot(num_ports,num_ports,i)
    plot(t/1E-6,20*log10(abs(SCt(:,i,end)))); axis tight
    xlabel('Time(\mus)'); ylabel('Log Mag (dB)'); title(['Scav',fliplr(num2str(str2double(dec2bin(i-1))+11))]); % label the plot
end

%% Create the ensemble S11 vector and plot
par = 2;
a = SCt(:,par,1);
b = SCf(:,par,1);
h1 = figure; plot(t/1E-6,20*log10(abs(a)),'.-g', 'MarkerSize', 20)
h2 = figure; plot(Freq/1E9,20*log10(abs(b)),'.g', 'MarkerSize', 12)

for i = 1:N-1
    a = abs(a) + abs(SCt(:,par,i+1));
    b = abs(b) + abs(SCf(:,par,i+1));
end
figure(h1); hold on;
plot(t*10^6,20*log10(abs(mean(SCt(:,par,:),3))),'r')
plot(t/1E-6,20*log10(abs(a/N)),'k'); xlabel('time (\mus)'); ylabel('S11 - Log Mag (dB)'); axis tight
legend('Single Realization', 'Mag. of Ensemble Avg.|<h>|','Ensemble Avg. of Mag.<|h|>');
figure(h2); hold on;
plot(Freq/1E9,20*log10(abs(b/N)),'k'); xlabel('Frequency (GHz)'); ylabel('|S_{22}^{cav}| log mag (dB)'); axis tight



%% Step 3: Compute Tau, the 1/e fold energy decay time
lstring = 'Computing tau ...';
if (useGUI == true)
    logMessage(handles.jEditbox,lstring);
else
    disp(lstring)
end
for param=1:4
    Tau(param) = getTau(t, mean(abs(SCt(:,param,:)),3), l,param);                                 % input parameters: the complex time domain S parameter measurements and corresponding time vector, the electrical length of the antenna(m).
end
%% Step 4: Compute the loss parameter (alpha)
for param=1:4
    [alpha(param) Qcomp(param)] = getalpha(mean(Freq), Tau(param), V);                      %input parameters: the average operational frequency, the 1/e fold energy decay time,
end
%% Step 5: Transform the S parameters (both Srad and Scav) to the Z parameters using the bilinear equations. (~2 min for N = 200)
%             b = find(abs(Freq-1.5E9) == min(abs(Freq-1.5E9)));              % index at 10 GHz
%             f = find(abs(Freq-3.5E9) == min(abs(Freq-3.5E9)));              % index at 10.5 GHz
%             SCfT = SCf((b:f),:,:);                                          % truncated cavity s paramater measurement from 9GHz - 11.5GHz to 10GHz - 10.5GHz
%             SradT = Srad((b:f),:,:);                                        % truncated ratiation s paramater measurement from 9GHz - 11.5GHz to 10GHz - 10.5GHz
%SCfT = SCf; SradT = Srad;
    lstring = sprintf('Transforming to Impedance');
    if (useGUI == true)
        logMessage(handles.jEditbox,lstring);
    else
        disp(lstring)
    end
tic; 
Srad1 = Srad(:,:,:,6);
SradM = reshape(shiftdim(permute(Srad1,[2,1,3]),-1),num_ports,num_ports,length(Freq),N); 
SCfM = reshape(shiftdim(permute(SCf,[2,1,3]),-1),num_ports,num_ports,length(Freq),N);
srZ0 = sqrt(50)*eye(2);
% Zradf = zeros(length(Freq),num_ports^2,N,10);
% Zcf = zeros(length(Freq),num_ports^2,N);
Zradf = zeros(num_ports,num_ports,length(Freq),N);
Zcf = zeros(num_ports,num_ports,length(Freq),N);
for i = 1:N
    %+++++Old Conversion code+++++
    %Zradf(:,:,i) = Sf2Zf(num_ports, SradT(:,:,i));    % input parameters: number of ports, and the S parameter vector/matrix
    %Zcf(:,:,i) = Sf2Zf(num_ports, SCfT(:,:,i));
    %Indices 1-4 are used to indicate different parameters.List:
    %1-(S/Z)11
    %2-(S/Z)12
    %3-(S/Z)21
    %4-(S/Z)22
    %%+++ Trasformation using (single) parameter-wise calculation +++++%:
    %+++++Frequency Domain Parameters+++++
%                d5 = ((1+Srad(:,1,i,:)).*(1-Srad(:,4,i,:))-Srad(:,2,i,:).*Srad(:,3,i,:))/50;
%                Zradf(:,1,i,:) = ((1-Srad(:,1,i,:)).*(1-Srad(:,4,i,:))+Srad(:,2,i,:).*Srad(:,3,i,:))./d5;
%                Zradf(:,2,i,:) = 2*Srad(:,2,i,:)./d5;
%                Zradf(:,3,i,:) = 2*Srad(:,3,i,:)./d5;
%                Zradf(:,4,i,:) = ((1-Srad(:,1,i,:)).*(1+Srad(:,4,i,:))+Srad(:,2,i,:).*Srad(:,3,i,:))./d5;
%                %+++++Time Domain Parameters+++++
%                d5 = ((1+SCf(:,1,i)).*(1-SCf(:,4,i))-SCf(:,2,i).*SCf(:,3,i))/50;
%                Zcf(:,1,i) = ((1-SCf(:,1,i)).*(1-SCf(:,4,i))+SCf(:,2,i).*SCf(:,3,i))./d5;
%                Zcf(:,2,i) = 2*SCf(:,2,i)./d5;
%                Zcf(:,3,i) = 2*SCf(:,3,i)./d5;
%                Zcf(:,4,i) = ((1-SCf(:,1,i)).*(1+SCf(:,4,i))+SCf(:,2,i).*SCf(:,3,i))./d5;
    %            time = toc; display(['Time =',num2str(time),'seconds. i =', num2str(i)]);
    %++++++++Tranformation using Matrix multication and divons
    for j = 1:length(Freq)
            Zradf(:,:,j,i) = srZ0*(eye(2)+SradM(:,:,j,i))*inv(eye(2)-SradM(:,:,j,i))*srZ0;
            Zcf(:,:,j,i) = srZ0*(eye(2)+SCfM(:,:,j,i))*inv(eye(2)-SCfM(:,:,j,i))*srZ0;
    end
    time = toc; 
	
	averagetime = time/i;
	predictedTime = time + averagetime*(N-i);
    lstring = sprintf('Transforming realization %d of %d, time = %s s, predicted end time = %s s',i,N,num2str(time), num2str(predictedTime));
    if (useGUI == true)
        logMessage(handles.jEditbox,lstring);
    else
        disp(lstring)
    end
    %++++++++++++++++++++++++++++++++++++++++++++++++++++
end
%% Step 6: Normalize the frequency domain measurements using the computed Z parameters in Step 5 (~40 sec for N = 200)
%Pick a gating time
    lstring = sprintf('Normalizing Impedance');
    if (useGUI == true)
        logMessage(handles.jEditbox,lstring);
    else
        disp(lstring)
    end
gate = 1;
Znormf = zeros(num_ports,num_ports,length(Freq),N);
clear Zradf; Zradf = mean(Zcf,4);
% Znormf = zeros(length(Freq),num_ports^2,N);
tic; for incr = 1:N
    %Normalize Z11, Z12, Z21, and Z22 respectively
%     Znormf(:,:,incr) = normalizeZ(2, Zcf(:,:,incr), mean(Zradf(:,:,:,gate),3));   %input parameter: numer of ports, cavity impedance, and radition impeadance
    for j = 1:length(Freq); Znormf(:,:,j,incr) = ((real(Zradf(:,:,j)))^-0.5)*(Zcf(:,:,j,incr)-1j*imag(Zradf(:,:,j)))*((real(Zradf(:,:,j)))^-0.5); end 
    time = toc; 
	
	averagetime = time/incr;
	predictedTime = time + averagetime*(N-incr);
    lstring = sprintf('Normalizing realization %d of %d, time = %s s, predicted end time = %s s',incr,N,num2str(time), num2str(predictedTime));
    if (useGUI == true)
        logMessage(handles.jEditbox,lstring);
    else
        disp(lstring)
    end
end
Znormf = permute(shiftdim(reshape(Znormf,1,num_ports^2,length(Freq),N)),[2 1 3]);

%% Step 7: Generate a distribution of the normalized Z parameters from Step 6
    lstring = sprintf('Generating Measured Distribution');
    if (useGUI == true)
        logMessage(handles.jEditbox,lstring);
    else
        disp(lstring)
    end
tic;
EZnormf = Znormf(:,:,1);
for i = 2:N
    EZnormf = cat(1,EZnormf,Znormf(:,:,i));
    time = toc; 
        lstring = sprintf('Generating Measured Distribution %d of %d, time = %s s',i,N,num2str(time));
    if (useGUI == true)
        logMessage(handles.jEditbox,lstring);
    else
        disp(lstring)
    end
end
for i = 1:num_ports^2; [Zhist_EXP(:,i), Zbin_EXP(:,i)] = hist(abs(EZnormf(:,i)), 0.1*BINS); end                         % input paramters: the data (normalized impedance), and the number of bins
for i = 1:num_ports^2; [Zphist_EXP(:,i), Zpbin_EXP(:,i)] = hist(angle(EZnormf(:,i)), 0.1*BINS); end
%% Step 8: Generate a distribution of Z parameters using random coupling model (RCM) using the loss parameter (alpha) computed in Step 4.
    lstring = sprintf('Generating RCM Distribution');
    if (useGUI == true)
        logMessage(handles.jEditbox,lstring);
    else
        disp(lstring)
    end
clear Znorm_RCM;
tic;
for i = 1:num_ports^2;
    if (useGUI == true)
        [Znorm_RCM] =  genPMFrcm(alpha(i),num_ports, nRCM,handles);           % input parameters: loss parameter, number of bins, number of ports, number of samples
    else
        [Znorm_RCM] =  genPMFrcm(alpha(i),num_ports, nRCM);  
    end
    [Zhist_RCM(:,i), Zbin_RCM(:,i)] = hist(abs(Znorm_RCM(:,i)), 0.1*BINS);
    [Zphist_RCM(:,i), Zpbin_RCM(:,i)] = hist(angle(Znorm_RCM(:,i)), 0.1*BINS);
	time = toc; 
	
	averagetime = time/i;
	predictedTime = time + averagetime*(num_ports^2-i);
    lstring = sprintf('Computing RCM distribution %d of %d, time = %s s, predicted end time = %s s',i,num_ports^2,num2str(time), num2str(predictedTime));
    if (useGUI == true)
        logMessage(handles.jEditbox,lstring);
    else
        disp(lstring)
    end
end
%% Step 9: Plot the pmf
figure(1); hold off; clear Zpmf_RCM; clear Zpmf_EXP;
paramlables = cellstr(['11';'12';'21';'22']);
for i = 1:num_ports^2; 
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
figure(2); hold off; clear Zppmf_RCM; clear Zppmf_EXP;
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