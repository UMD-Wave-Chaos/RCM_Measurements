function pos = getStepperMotorPosition(s1)

fprintf(s1,'l');
pause(1.0);

if s1.BytesAvailable ~= 0
    posString = fscanf(s1,'%s',s1.BytesAvailable);
    pos = str2double(posString(3:end));
    
    %get the 'l#' left over
    fscanf(s1);
else
    pos = -1;
    error('No response from stepper motor');
end