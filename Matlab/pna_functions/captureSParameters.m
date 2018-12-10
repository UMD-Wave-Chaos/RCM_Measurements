function captureSParameters(obj1,NOP,fileName)

%get the ungated set
disp('Capturing Ungated S Parameters in Frequency Domain')
[Freq, S11, S12, S21, S22] = getUngatedSParametersFrequencyDomain(obj1,NOP);
S = packComponents(S11,S12,S21,S22);
saveComplexToHDF5(S,fileName,'/S_ungated_f')
h5create(fileName,'/f',size(Freq));
h5write(fileName,'/f',Freq);

%get the various gated signals
disp('Capturing Gated S Parameters in Frequency Domain')
gateTimes = [1.0 5.0 10.0 20.0 50.0 100.0 250.0 500.0 1000.0 5000.0 10000.0]*1e-9;
for counter = 1:length(gateTimes)
    dispstring = sprintf('Grabbing set %d of %d, %0.0f ns gating',counter,length(gateTimes),gateTimes(counter)*1e9);
    disp(dispstring);
    [~, S11, S12, S21, S22] = getGatedSParametersFrequencyDomain(obj1,gateTimes(counter),NOP);
    S = packComponents(S11,S12,S21,S22);
    varname = sprintf('/S_gated_f_%0.0f_ns',gateTimes(counter)*1e9);
    saveComplexToHDF5(S,fileName,varname)
end
    
disp('Capturing S Parameters in Time Domain');
start_time =  -(NOP-1)/(Freq(end)-Freq(1));
stop_time =  (NOP-1)/(Freq(end)-Freq(1));
[t,S11, S12, S21, S22] = getSParametersTimeDomain(obj1,NOP,start_time,stop_time);

S = packComponents(S11,S12,S21,S22);
saveComplexToHDF5(S,fileName,'/S_t')
h5create(fileName,'/t',size(t));
h5write(fileName,'/t',t);