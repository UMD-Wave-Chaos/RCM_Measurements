function [t,SCt11, SCt12, SCt21, SCt22] = getSParametersTimeDomain(obj1,NOP,start_time,stop_time)

%setup the PNA to take time domain measurements
fprintf(obj1, 'CALC:TRAN:TIME:STATE ON'); % turn time transform on
fprintf(obj1, 'CALC:FILT:TIME:STATE OFF'); % turn time gating on

%set the start and stop time for the gating
fprintf(obj1, ['CALC:TRAN:TIME:START ', num2str(start_time)]);
fprintf(obj1, ['CALC:TRAN:TIME:STOP ', num2str(stop_time)]);

%check to make sure the start time is within the valid range of the PNA,
%must be < (NOP-1)/delta Freq
tstart = query(obj1, 'CALC:TRAN:TIME:STAR?');

if (start_time < str2num(tstart))
    wstring = sprintf ('Requested start time %f is less than min PNA start time %s, setting to min PNA start time',start_time, tstart);
    warning(wstring);
    fprintf(obj1, 'CALC:TRAN:TIME:START MIN');
end

%check to make sure the stop time is within the valid range of the PNA,
%must be > -(NOP-1)/delta Freq
tstop = query(obj1, 'CALC:TRAN:TIME:STOP?');

if (stop_time > str2num(tstop))
    wstring = sprintf ('Requested stop time %f is greater than max PNA stop time %s, setting to max PNA stop time',stop_time, tstop);
    warning(wstring);
    fprintf(obj1, 'CALC:TRAN:TIME:STOP MAX');
end

%now get the S parameters
[t,SCt11,SCt12,SCt21,SCt22] = getSParameters(obj1,NOP);
  