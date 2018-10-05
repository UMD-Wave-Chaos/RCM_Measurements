addpath(genpath('..')); num_ports = 1;                                      % one port measurement and analysis
l = 0.5;                                                                  % electrical length of the launching antenna (m)
V = 1.9;                                                                    % volume of the enclosure (m^3)
N = 50;                                                                      % number of perturber positions (cavity realizations)
BINS = 1000;                                                                % number of bins to be used in generating a distribution
portnum = 4;                                                                 %Specify the port parameter if taking 2 port measurements
%% Step 1 : Calibrate PNA
            cal_name = 'cal_for_2_5';
            CalNA_np_GPIB(1.5E9,3.5E9, cal_name, num_ports); % input parameters :start freq, stop freq, cal set name

%% Step 2: Extract time domain and frequency domain ensemble average measurement of S paramenters (This step takes ~24 min. for N = 200)          
%           [t, SCt, Freq, Scav, Srad] = PNA_single(cal_set_name,num_ports,N, l);  % input parameters : number of ports, number of perturber positions             
            PNA_single; 
             
%% Step 3: Compute Tau, the 1/e fold energy decay time
            Tau = getTau(t, mean(abs(SCt(:,4,:,:)),3), l);                                 % input parameters: the complex time domain S parameter measurements and corresponding time vector, the electrical length of the antenna(m).
           
%% Step 4: Compute the loss parameter (alpha) 
           [alpha Qcomp] = getalpha(mean(Freq), Tau, V);                      %input parameters: the average operational frequency, the 1/e fold energy decay time,                                     
            
%% Step 5: Transform the S parameters (both Srad and Scav) to the Z parameters using the bilinear equations. (~2 min for N = 200) 
            b = find(abs(Freq-1.5E9) == min(abs(Freq-1.5E9)));                % index at 10 GHz
            f = find(abs(Freq-3.5E9) == min(abs(Freq-3.5E9)));            % index at 10.5 GHz
%             SCfT = SCf((b:f),:,:);                                          % truncated cavity s paramater measurement from 9GHz - 11.5GHz to 10GHz - 10.5GHz
%             SradT = Srad((b:f),:,:);                                        % truncated ratiation s paramater measurement from 9GHz - 11.5GHz to 10GHz - 10.5GHz            
            SCfT = SCf; SradT = Srad;
            tic; for i = 1:N
            gate=1;
           Zradf(:,1,i) = Sf2Zf(num_ports, SradT(:,4,i,gate));    % input parameters: number of ports, and the S parameter vector/matrix
           Zcf(:,:,i) = Sf2Zf(num_ports, SCfT(:,4,i));
           time = toc; display(['Time =',num2str(time),'seconds. i =', num2str(i)]);
        end
%% Step 6: Normalize the frequency domain measurements using the computed Z parameters in Step 5 (~40 sec for N = 200)  
           tic; for i = 1:N
            Znormf(:,:,i) = normalizeZ1(num_ports, Zcf(:,:,i)-7, mean(Zradf(:,:,:),3)-7);                      % input parameter: numer of ports, cavity impedance, and radition impeadance
            time = toc; display(['Time =',num2str(time),'seconds. i =', num2str(i)]);
           end
%% Step 7: Generate and a distribution of the normalized Z parameters from Step 6  
           tic; 
            EZnormf = Znormf(:,:,1);
             for i = 2:N
                EZnormf = cat(1,EZnormf,Znormf(:,:,i));
                time = toc; display(['Time =',num2str(time),'seconds. i =', num2str(i)]);
             end
             for i = 1:num_ports; [Zhist_EXP(:,i), Zbin_EXP(:,i)] = hist(abs(EZnormf), 0.1*BINS); end                         % input paramters: the data (normalized impedance), and the number of bins             
%% Step 8: Generate and a distribution of Z parameters using random coupling model (RCM) using the loss parameter (alpha) computed in Step 4. 
                 clear Znorm_RCM;
                [Znorm_RCM] =  genPMFrcm(alpha,num_ports, 250000);           % input parameters: loss parameter, number of bins, number of ports, number of samples     
                 for i = 1:num_ports; [Zhist_RCM(:,i), Zbin_RCM(:,i)] = hist(abs(Znorm_RCM(:,i)), 1*BINS); end 
%% Step 9: Plot the pmf
            figure(1); hold off; clear Zpmf_RCM; clear Zpmf_EXP;
           for i = 1:num_ports; p= 10;
               subplot(num_ports,num_ports,i);
               Zpmf_RCM(:,i) = Zhist_RCM(:,i)./((Zbin_RCM(2,i)-Zbin_RCM(1,i))*sum(Zhist_RCM(:,i))); % Create a pmf from histogram for RCM prediction of the normalized impedance
               Zpmf_EXP(:,i) = Zhist_EXP(:,i)./((Zbin_EXP(2,i)-Zbin_EXP(1,i))*sum(Zhist_EXP(:,i))); % Create a pmf from histogram for measurement of the normalized impedance
               plot(Zbin_RCM(:,i),Zpmf_RCM(:,i),'o-g','MarkerSize',2); hold on;             %Plot the pmf (divide by the area under curve) of the RCM predicted normalized impedance
               plot(Zbin_EXP(:,i),Zpmf_EXP(:,i),'*-k','MarkerSize',5    );       %Plot the pmf (divide by the area under curve) of the measured normalized impedance               
%                set(gca, 'XTickLabel', '', 'YTickLabel', '');
               xmin = 0.6; xmax = 1.7; ymin = 0; ymax = 5;
               plot(0.75*xmax,0.75*ymax,'og','MarkerSize',2); text(0.77*xmax,0.75*ymax,'RCM Prediction'); 
               plot(0.75*xmax,0.8*ymax,'*k', 'MarkerSize',5); text(0.77*xmax,0.8*ymax,'Measurement');
               xlabel('Normalized |Z_{11}|'); ylabel('Probability Density Function'); title(['PDF of Norm.|Z_{11}| for Cylindrical Chamber with Q_{comp} = ',... 
                   num2str(round(Qcomp)),' \alpha = ',num2str(round(alpha)),', GT=',num2str(floor(p*(5/3))+0.01*round(mod(p*100*(5/3),100))),'ns']); 
               %xlim([0.6,1.7]); ylim([0,9]); grid off; 
           end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%               