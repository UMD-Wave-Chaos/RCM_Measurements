function analyzeResults(filename,varargin)
%analyzeResults(filename)
%analyzeResults(filename,handles)

%% check the inputs to determine whether or not this was called from the gui
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
mData = loadData(filename);

SCf = mData.SCf;
Freq = mData.Freq;
Settings = mData.Settings;

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

h5create(analysisFile,'/Analysis/SCf_real',size(SCf));
h5write(analysisFile,'/Analysis/SCf_real',real(SCf));
h5create(analysisFile,'/Analysis/SCf_imag',size(SCf));
h5write(analysisFile,'/Analysis/SCf_imag',imag(SCf));
h5create(analysisFile,'/Analysis/f',size(Freq));
h5write(analysisFile,'/Analysis/f',Freq);

%% Determine Srad from the time gated measurements
Srad = computeSrad(SCf,Freq);

h5create(analysisFile,'/Analysis/Srad_real',size(Srad));
h5write(analysisFile,'/Analysis/Srad_real',real(Srad));
h5create(analysisFile,'/Analysis/Srad_imag',size(Srad));
h5write(analysisFile,'/Analysis/Srad_imag',imag(Srad));

%% Get the time domain signals
[SCt,t] = getTimeDomainSParameters(SCf,Freq);

h5create(analysisFile,'/Analysis/SCt_real',size(SCt));
h5write(analysisFile,'/Analysis/SCt_real',real(SCt));
h5create(analysisFile,'/Analysis/SCt_imag',size(SCt));
h5write(analysisFile,'/Analysis/SCt_imag',imag(SCt));
h5create(analysisFile,'/Analysis/t',size(t));
h5write(analysisFile,'/Analysis/t',t);

%% Plot the ensembles
plotSParameters(t,Freq,SCf,SCt,Srad,foldername);
plotScavEnsembles(t,Freq,SCt,SCf,foldername);
plotSrad(Freq,Srad,foldername);

%% Get and plot the enhanced backscatter coefficient
eb = computeEnhancedBackscatter(SCf, Freq,foldername);
h5create(analysisFile,'/Analysis/eb',size(eb));
h5write(analysisFile,'/Analysis/eb',eb);

%% Get and plot the K factor
K11 = plotKFactor(SCf,Freq,1,foldername);
K12 = plotKFactor(SCf,Freq,2,foldername);
K21 = plotKFactor(SCf,Freq,3,foldername);
K22 = plotKFactor(SCf,Freq,4,foldername);

h5create(analysisFile,'/Analysis/K11',size(K11));
h5write(analysisFile,'/Analysis/K11',K11);
h5create(analysisFile,'/Analysis/K12',size(K12));
h5write(analysisFile,'/Analysis/K12',K12);
h5create(analysisFile,'/Analysis/K21',size(K21));
h5write(analysisFile,'/Analysis/K21',K21);
h5create(analysisFile,'/Analysis/K22',size(K22));
h5write(analysisFile,'/Analysis/K22',K22);

%% get the Heisenberg Time
c = 2.99792458e8;
deltaOmega = pi^2*c^3/((2*pi*mean(Freq))^2*Settings.V);
Ht = 1/deltaOmega;

h5create(analysisFile,'/Analysis/Ht',size(Ht));
h5write(analysisFile,'/Analysis/Ht',Ht);

%% compute the PDP
pdp = computePowerDecayProfile(SCt,t,2,Ht,foldername);

h5create(analysisFile,'/Analysis/pdp',size(pdp));
h5write(analysisFile,'/Analysis/pdp',pdp);

%% Step 3: Compute Tau, the 1/e fold energy decay time
lstring = 'Computing tau ...';
if (useGUI == true)
    logMessage(handles.jEditbox,lstring);
else
    disp(lstring)
end

% setup the start and stop time to capture long time exponential decay of
% the cavity - need to measure far enough out to prevent short orbits from
% the wells interacting
% 11-14-2018 measurements indicate there are 2 long term decay times, the
% shorter time dominates until ~5.5 microseconds, and the longer term takes
% over until ~6.5 microseconds after which the time response flattens out
tStart = 5.5e-6;
tStop = 6.5e-6;
% measurements of tau_{RC} are taken from S_{12}
[Tau,pdpSection,timeSection] = computeTauRC(pdp,t,tStart,tStop,foldername);

lstring = sprintf('Tau: %0.3f  ns',Tau*1e9);
if (useGUI == true)
    logMessage(handles.jEditbox,lstring,'info');
else
    disp(lstring)
end

h5create(analysisFile,'/Analysis/tau',size(Tau));
h5write(analysisFile,'/Analysis/tau',Tau);
h5create(analysisFile,'/Analysis/pdpSection',size(pdpSection));
h5write(analysisFile,'/Analysis/pdpSection',pdpSection);
h5create(analysisFile,'/Analysis/timeSection',size(timeSection));
h5write(analysisFile,'/Analysis/timeSection',timeSection);

%% Step 4: Compute the loss parameter (alpha)
[alpha, Qcomp] = getalpha(mean(Freq), Tau, Settings.V);        

lstring = sprintf('Alpha: %0.3f',alpha);
if (useGUI == true)
    logMessage(handles.jEditbox,lstring,'info');
else
    disp(lstring)
end

lstring = sprintf('Q: %0.3f',Qcomp);
if (useGUI == true)
    logMessage(handles.jEditbox,lstring,'info');
else
    disp(lstring)
end

h5create(analysisFile,'/Analysis/alpha',size(alpha));
h5write(analysisFile,'/Analysis/alpha',alpha);
h5create(analysisFile,'/Analysis/Q',size(Qcomp));
h5write(analysisFile,'/Analysis/Q',Qcomp);

%% Step 5: Transform the S parameters (both Srad and Scav) to the Z parameters using the bilinear equations.
lstring = sprintf('Transforming S parameters to Z parameters');
if (useGUI == true)
    logMessage(handles.jEditbox,lstring,'info');
else
    disp(lstring)
end

Zcf = transformToZ2Port(SCf);
Zradf = transformToZ2Port(Srad);
plotZrad(Freq,Zradf,foldername);

h5create(analysisFile,'/Analysis/Zradf_real',size(Zradf));
h5write(analysisFile,'/Analysis/Zradf_real',real(Zradf));
h5create(analysisFile,'/Analysis/Zradf_imag',size(Zradf));
h5write(analysisFile,'/Analysis/Zradf_imag',imag(Zradf));

h5create(analysisFile,'/Analysis/Zcf_real',size(Zcf));
h5write(analysisFile,'/Analysis/Zcf_real',real(Zcf));
h5create(analysisFile,'/Analysis/Zcf_imag',size(Zcf));
h5write(analysisFile,'/Analysis/Zcf_imag',imag(Zcf));

%% Step 6: Normalize the frequency domain measurements using the computed Z parameters in Step 5
Znormf = normalizeImpedance(Zcf,Zradf, Freq, handles);

h5create(analysisFile,'/Analysis/Znormf_real',size(Znormf));
h5write(analysisFile,'/Analysis/Znormf_real',real(Znormf));
h5create(analysisFile,'/Analysis/Znormf_imag',size(Znormf));
h5write(analysisFile,'/Analysis/Znormf_imag',imag(Znormf));

%% Step 7: compute the distributions
Zrcm = computeDistributions(Znormf,alpha, 2000, 100000, foldername, handles); 

h5create(analysisFile,'/Analysis/Zrcm_real',size(Zrcm));
h5write(analysisFile,'/Analysis/Zrcm_real',real(Zrcm));

