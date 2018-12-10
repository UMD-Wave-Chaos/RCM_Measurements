function saveData(time, SCt, Freq, SCf,Settings)

if exist(Settings.fileName,'file')
    delete(Settings.fileName);
end

%log the data

h5create(Settings.fileName,'/Measurements/SCf_real',size(SCf));
h5write(Settings.fileName,'/Measurements/SCf_real',real(SCf));
h5create(Settings.fileName,'/Measurements/SCf_imag',size(SCf));
h5write(Settings.fileName,'/Measurements/SCf_imag',imag(SCf));


h5create(Settings.fileName,'/Measurements/SCt_real',size(SCt));
h5write(Settings.fileName,'/Measurements/SCt_real',real(SCt));
h5create(Settings.fileName,'/Measurements/SCt_imag',size(SCt));
h5write(Settings.fileName,'/Measurements/SCt_imag',imag(SCt));

h5create(Settings.fileName,'/Measurements/Freq',size(Freq));
h5write(Settings.fileName,'/Measurements/Freq',Freq);

h5create(Settings.fileName,'/Measurements/time',size(time));
h5write(Settings.fileName,'/Measurements/time',time);

saveSettings(Settings);