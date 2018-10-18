function saveData(t, SCt, Freq, SCf, Srad,Settings)

if exist(Settings.fileName)
    delete(Settings.fileName);
end
%log the data
h5create(Settings.fileName,'/Measurements/Srad_real',size(Srad));
h5write(Settings.fileName,'/Measurements/Srad_real',real(Srad));
h5create(Settings.fileName,'/Measurements/Srad_imag',size(Srad));
h5write(Settings.fileName,'/Measurements/Srad_imag',imag(Srad));

h5create(Settings.fileName,'/Measurements/SCf_real',size(SCf));
h5write(Settings.fileName,'/Measurements/SCf_real',real(SCf));
h5create(Settings.fileName,'/Measurements/SCf_imag',size(SCf));
h5write(Settings.fileName,'/Measurements/SCf_imag',imag(SCf));

h5create(Settings.fileName,'/Measurements/SCt_real',size(SCt));
h5write(Settings.fileName,'/Measurements/SCt_real',real(SCt));
h5create(Settings.fileName,'/Measurements/SCt_imag',size(SCt));
h5write(Settings.fileName,'/Measurements/SCt_imag',imag(SCt));

h5create(Settings.fileName,'/Measurements/t',size(t));
h5write(Settings.fileName,'/Measurements/t',t);

h5create(Settings.fileName,'/Measurements/Freq',size(Freq));
h5write(Settings.fileName,'/Measurements/Freq',Freq);

%log the Settings
h5writeatt(Settings.fileName,'/','Npoints',Settings.NOP);
h5writeatt(Settings.fileName,'/','Nrealizations',Settings.N);
h5writeatt(Settings.fileName,'/','ComPort',Settings.comPort);
if (Settings.electronicCalibration == true)
    h5writeatt(Settings.fileName,'/','ECal',1);
else
    h5writeatt(Settings.fileName,'/','ECal',1);
end
h5writeatt(Settings.fileName,'/','Comments',Settings.Comments);
h5writeatt(Settings.fileName,'/','V',Settings.V);
h5writeatt(Settings.fileName,'/','l',Settings.l);
h5writeatt(Settings.fileName,'/','nRCM',Settings.nRCM);



