function saveData(time, SCt, Freq, SCf,Settings)

if exist(Settings.fileName,'file')
    delete(Settings.fileName);
end

%log the data
%break out the components
S11 = squeeze(SCf(:,1,:));
S12 = squeeze(SCf(:,2,:));
S21 = squeeze(SCf(:,3,:));
S22 = squeeze(SCf(:,4,:));

h5create(Settings.fileName,'/S11f_real',size(S11));
h5write(Settings.fileName,'/S11f_real',real(S11));
h5create(Settings.fileName,'/S11f_imag',size(S11));
h5write(Settings.fileName,'/S11f_imag',real(S11));

h5create(Settings.fileName,'/S12f_real',size(S12));
h5write(Settings.fileName,'/S12f_real',real(S12));
h5create(Settings.fileName,'/S12f_imag',size(S12));
h5write(Settings.fileName,'/S12f_imag',real(S12));

h5create(Settings.fileName,'/S21f_real',size(S21));
h5write(Settings.fileName,'/S21f_real',real(S21));
h5create(Settings.fileName,'/S21f_imag',size(S21));
h5write(Settings.fileName,'/S21f_imag',real(S21));

h5create(Settings.fileName,'/S22f_real',size(S22));
h5write(Settings.fileName,'/S22f_real',real(S22));
h5create(Settings.fileName,'/S22f_imag',size(S22));
h5write(Settings.fileName,'/S22f_imag',real(S22));

%now the time domain
S11 = squeeze(SCt(:,1,:));
S12 = squeeze(SCt(:,2,:));
S21 = squeeze(SCt(:,3,:));
S22 = squeeze(SCt(:,4,:));

h5create(Settings.fileName,'/S11t_real',size(S11));
h5write(Settings.fileName,'/S11t_real',real(S11));
h5create(Settings.fileName,'/S11t_imag',size(S11));
h5write(Settings.fileName,'/S11t_imag',real(S11));

h5create(Settings.fileName,'/S12t_real',size(S12));
h5write(Settings.fileName,'/S12t_real',real(S12));
h5create(Settings.fileName,'/S12t_imag',size(S12));
h5write(Settings.fileName,'/S12t_imag',real(S12));

h5create(Settings.fileName,'/S21t_real',size(S21));
h5write(Settings.fileName,'/S21t_real',real(S21));
h5create(Settings.fileName,'/S21t_imag',size(S21));
h5write(Settings.fileName,'/S21t_imag',real(S21));

h5create(Settings.fileName,'/S22f_real',size(S22));
h5write(Settings.fileName,'/S22f_real',real(S22));
h5create(Settings.fileName,'/S22f_imag',size(S22));
h5write(Settings.fileName,'/S22f_imag',real(S22));
h5create(Settings.fileName,'/Measurements/Freq',size(Freq));
h5write(Settings.fileName,'/Measurements/Freq',Freq);

h5create(Settings.fileName,'/Measurements/time',size(time));
h5write(Settings.fileName,'/Measurements/time',time);

saveSettings(Settings);