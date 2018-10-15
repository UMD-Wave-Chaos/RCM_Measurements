addpath(genpath('..')); num_ports = 2;                                      % one port measurement and analysis
l = 0.5;                                                                    %electrical length of the launching antenna (m)
V = 3.02;                                                                    % volume of the enclosure (m^3)
%Cylindrical Chamber Volume (m^3): 1.92
%Rectangular Chamber Volume (m^3): 3.02
N = 50;                                                                     % number of perturber positions (cavity realizations)
BINS = 1000;       % number of bins to be used in generating a distribution
datname = 'R_Brdantwd_Helix';
%The name scheme:
%<chambername>_<port1_antenna>_<port2_antenna>
%Chambernames: R- Rectangular C-Cylindrical
%Antennas names: 
%Brdantwd - Board antenna with dielectric, full FR-4 board
%Brdantnd - Board antenna without dielectric, FR-4 in the loop was removed
%Helix - Helix Antenna
%Wvgyd - Open ended rectangular waveguide
%Loop - The copper wire loop
%Horn - Horn antenna
%% Step 1 : Calibrate PNA
cal_name = ['cal_for_',date];
%CalNA_np_GPIB_2port(1.5E9,3.5E9, cal_name, num_ports); % input parameters :start freq, stop freq, cal set name

%% Step 2: Extract time domain and frequency domain ensemble average measurement of S paramenters (This step takes ~24 min. for N = 200)
%            [t, SCt, Freq, Scav, Srad] = PNA_single(cal_set_name,num_ports,N, l);  % input parameters : number of ports, number of perturber positions
PNA_single_2port_R;

%% Step 3: Compute Tau, the 1/e fold energy decay time
for param=1:4
    Tau(param) = getTau(t, mean(abs(SCt(:,param,:)),3), l);                                 % input parameters: the complex time domain S parameter measurements and corresponding time vector, the electrical length of the antenna(m).
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
    time = toc; display(['Time =',num2str(time),'seconds. i =', num2str(i)]);
    %++++++++++++++++++++++++++++++++++++++++++++++++++++
end
%% Step 6: Normalize the frequency domain measurements using the computed Z parameters in Step 5 (~40 sec for N = 200)
%Pick a gating time
gate = 1;
Znormf = zeros(num_ports,num_ports,length(Freq),N);
clear Zradf; Zradf = mean(Zcf,4);
% Znormf = zeros(length(Freq),num_ports^2,N);
tic; for incr = 1:N
    %Normalize Z11, Z12, Z21, and Z22 respectively
%     Znormf(:,:,incr) = normalizeZ(2, Zcf(:,:,incr), mean(Zradf(:,:,:,gate),3));   %input parameter: numer of ports, cavity impedance, and radition impeadance
    for j = 1:length(Freq); Znormf(:,:,j,incr) = ((real(Zradf(:,:,j)))^-0.5)*(Zcf(:,:,j,incr)-1j*imag(Zradf(:,:,j)))*((real(Zradf(:,:,j)))^-0.5); end 
    time = toc; display(['Time =',num2str(time),'seconds. incr=', num2str(incr)]);
end
Znormf = permute(shiftdim(reshape(Znormf,1,num_ports^2,length(Freq),N)),[2 1 3]);
%% Step 7: Generate a distribution of the normalized Z parameters from Step 6
tic;
EZnormf = Znormf(:,:,1);
for i = 2:N
    EZnormf = cat(1,EZnormf,Znormf(:,:,i));
    time = toc; display(['Time =',num2str(time),'seconds. i =', num2str(i)]);
end
for i = 1:num_ports^2; [Zhist_EXP(:,i), Zbin_EXP(:,i)] = hist(abs(EZnormf(:,i)), 0.1*BINS); end                         % input paramters: the data (normalized impedance), and the number of bins
for i = 1:num_ports^2; [Zphist_EXP(:,i), Zpbin_EXP(:,i)] = hist(angle(EZnormf(:,i)), 0.1*BINS); end
%% Step 8: Generate a distribution of Z parameters using random coupling model (RCM) using the loss parameter (alpha) computed in Step 4.
clear Znorm_RCM;
for i = 1:num_ports^2;
    [Znorm_RCM] =  genPMFrcm(alpha(i),num_ports, 50000);           % input parameters: loss parameter, number of bins, number of ports, number of samples
    [Zhist_RCM(:,i), Zbin_RCM(:,i)] = hist(abs(Znorm_RCM(:,i)), 0.1*BINS);
    [Zphist_RCM(:,i), Zpbin_RCM(:,i)] = hist(angle(Znorm_RCM(:,i)), 0.1*BINS);
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