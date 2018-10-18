function plotSParameters(t,Freq,SCf,SCt,Srad,foldername)

hfs = figure('NumberTitle', 'off', 'Name', 'S-Parameters (cav) - Frequency Domain Response'); % handle for s parameter plot
hfsr = figure('NumberTitle', 'off', 'Name', 'S-Parameters (rad) - Frequency Domain Response'); % handle for s parameter plot
hts = figure('NumberTitle', 'off', 'Name', 'S-Parameters - Time Domain Response'); % handle for s parameter plot

num_ports = 2;
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