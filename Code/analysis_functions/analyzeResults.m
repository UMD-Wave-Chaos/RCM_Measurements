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


%% read the specified file name and create the output data directory for plots
[t, SCt, Freq, SCf, Srad,V,l,N,NOP,nRCM] = loadData(filename);

[fpath,fname] = fileparts(filename);

foldername = fullfile(fpath,fname);
if exist(foldername,'dir')
    lstring = 'Directory exists, cleaning ...';
    rmdir(foldername,'s');
else
    lstring = 'Creating directory ...';
end

if (useGUI == true)
    logMessage(handles.jEditbox,lstring);
else
    disp(lstring)
end

mkdir(foldername);

analysisFile = fullfile(foldername,'analysisResults.h5');

%% Get the Corrected Srad
Srad = computeSrad(SCf,Freq);

%% Plot the ensembles
plotSParameters2(t,Freq,SCf,SCt,Srad,foldername);
plotScavEnsembles(t,Freq,SCt,SCf,foldername);

%% Get and plot the enhanced backscatter coefficient
eb = computeEnhancedBackscatter(SCf, Freq,foldername,1);

%% Get and plot the K factor
plotKFactor(SCf,Freq,1,foldername,1);
plotKFactor(SCf,Freq,2,foldername,1);
plotKFactor(SCf,Freq,3,foldername,1);
plotKFactor(SCf,Freq,4,foldername,1);

%% Step 3: Compute Tau, the 1/e fold energy decay time
lstring = 'Computing tau ...';
if (useGUI == true)
    logMessage(handles.jEditbox,lstring);
else
    disp(lstring)
end

for port = 1:4
     Tau(port) = computePowerDecayProfile(SCf,Freq,l,port,foldername,1);

end

lstring = sprintf('Tau: %0.3f ns %0.3f ns %0.3f ns %0.3f ns',Tau(1)*1e9,Tau(2)*1e9,Tau(3)*1e9,Tau(4)*1e9);
if (useGUI == true)
    logMessage(handles.jEditbox,lstring,'info');
else
    disp(lstring)
end

%% Step 4: Compute the loss parameter (alpha)
alpha = zeros(4,1);
Qcomp = zeros(4,1);
for param=1:4
    [alpha(param), Qcomp(param)] = getalpha(mean(Freq), Tau(param), V);                      %input parameters: the average operational frequency, the 1/e fold energy decay time,
end

lstring = sprintf('Alpha: %0.3f %0.3f %0.3f %0.3f',alpha(1),alpha(2),alpha(3),alpha(4));
if (useGUI == true)
    logMessage(handles.jEditbox,lstring,'info');
else
    disp(lstring)
end

lstring = sprintf('Q: %0.3f %0.3f %0.3f %0.3f',Qcomp(1),Qcomp(2),Qcomp(3),Qcomp(4));
if (useGUI == true)
    logMessage(handles.jEditbox,lstring,'info');
else
    disp(lstring)
end

h5create(analysisFile,'/Analysis/alpha',size(alpha));
h5write(analysisFile,'/Analysis/alpha',alpha);
h5create(analysisFile,'/Analysis/Q',size(Qcomp));
h5write(analysisFile,'/Analysis/Q',Qcomp);

%% Step 5: Transform the S parameters (both Srad and Scav) to the Z parameters using the bilinear equations. (~2 min for N = 200)
% [Zradf, Zcf] = transformStoZ(Srad2, SCf,Freq, handles);
Zcf = transformToZ2Port(SCf, handles);
Zradf = transformToZ2Port(Srad,handles);
h5create(analysisFile,'/Analysis/Zradf_real',size(Zradf));
h5write(analysisFile,'/Analysis/Zradf_real',real(Zradf));
h5create(analysisFile,'/Analysis/Zradf_imag',size(Zradf));
h5write(analysisFile,'/Analysis/Zradf_imag',imag(Zradf));

h5create(analysisFile,'/Analysis/Zcf_real',size(Zcf));
h5write(analysisFile,'/Analysis/Zcf_real',real(Zcf));
h5create(analysisFile,'/Analysis/Zcf_imag',size(Zcf));
h5write(analysisFile,'/Analysis/Zcf_imag',imag(Zcf));

%% Step 6: Normalize the frequency domain measurements using the computed Z parameters in Step 5 (~40 sec for N = 200)
Znormf = normalizeImpedance(Zcf ,Zradf, Freq, handles);

h5create(analysisFile,'/Analysis/Znormf_real',size(Znormf));
h5write(analysisFile,'/Analysis/Znormf_real',real(Znormf));
h5create(analysisFile,'/Analysis/Znormf_imag',size(Znormf));
h5write(analysisFile,'/Analysis/Znormf_imag',imag(Znormf));

%% Step 7: compute the distributions
computeDistributions(Znormf,alpha, handles.Settings.nBins,handles.Settings.nRCM, foldername, handles)
