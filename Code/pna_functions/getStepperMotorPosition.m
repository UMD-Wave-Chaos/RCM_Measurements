function pos = getStepperMotorPosition(s1)

fprintf(s1,'l');

s1.BytesAvailable

if s1.BytesAvailable ~= 0
    pos = str2num(fscanf(s1));
else
    pos = -1;
    error('No response from stepper motor');
end