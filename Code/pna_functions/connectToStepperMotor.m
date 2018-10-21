function s1 =  connectToStepperMotor(comPort)

s1 = serial(comPort, 'BaudRate', 57600,'Terminator', 'CR'); % Create serial port for the Stepper Motor
fopen(s1);

%make sure we can read the position
getStepperMotorPosition(s1);