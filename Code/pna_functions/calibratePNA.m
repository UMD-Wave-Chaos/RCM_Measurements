function calFileName = calibratePNA(obj1,START, STOP, NAME, NOP,np,varargin) % np = number of ports
% % % % % % % % % % % %%  This function calibrates the network analyzer in the frequency range
% % % % % % % % % % % %  between START and STOP using maximum number of points, then saves the
% % % % % % % % % % % %  result in the cal set name - NAME.

if (nargin == 7)
    useGUI = true;
    handles = varargin{1};
else
    useGUI = false;
end

lstring = sprintf('Starting Calibration ...');
 if (useGUI == true)
     logMessage(handles.jEditbox,lstring);
 else
     disp(lstring)
 end
 
 %update the timeout because the calibration takes awhile
 timeout = get(obj1,'Timeout');
 set(obj1,'Timeout',60);

% Communicating with instrument object, obj1.
fprintf(obj1, ['SENS:SWE:POINTS ', num2str(NOP)]); % set number of points
fprintf(obj1, 'SENS1:AVER:COUN 5'); % set count to 5
fprintf(obj1, 'SENS1:AVER ON'); % turn (keep) averaging on
fprintf(obj1, 'SENS1:AVER:CLE');  % restart averaging
fprintf(obj1, 'SENS:CORR:PREF:CSET:SAVE USER');
%fprintf(obj1, 'SENS:CORR:Pref:cset:savu 1');
fprintf(obj1, ['SENS:FREQ:START ', num2str(START)]); % set start frequency 
fprintf(obj1, ['SENS:FREQ:STOP ', num2str(STOP)]); % set stop frequency
fprintf(obj1,'CALC:PAR:DEL:ALL');
fprintf(obj1, 'calc:par:def "test", S11');
fprintf(obj1, 'calc:par:sel "test"');
fprintf(obj1, 'DISPlay:WINDow1:TRACe1:FEED "test"');
fprintf(obj1, 'DISP:WIND:Y:AUTO'); % Autoscale
if np == 1 % Check if the calibration is 1 or 2 ports and set up accordingly
    fprintf(obj1, 'SENSe:CORRection:COLL:Meth REFL3');
else
    fprintf(obj1, 'SENSe:CORRection:COLL:Meth SPARSOLT');
end
fprintf(obj1, 'SENSe:CORRection:COLL:ACQ ECAL1'); % cal calibration data
Done = query(obj1,'*OPC?');

lstring = sprintf('Calibration Step Completed ...');
 if (useGUI == true)
     logMessage(handles.jEditbox,lstring);
 else
     disp(lstring)
 end

 %reset the timeout
  set(obj1,'Timeout',timeout);
  
G = query(obj1, ['SENS:CORR:CSET:CAT?']);
GC = strread(G, '%s', length(find(G == ','))+1, 'delimiter', ',');
N = query(obj1, ['SENS:CORR:CSET:CAT? NAME']);
NC = strread(N, '%s', length(find(N == ','))+1, 'delimiter', ',');
k = strfind(NC, NAME);
for l = 1:length(find(N == ','))+1
empt = isempty(cell2mat(k(l)));
if ~empt
    km = l;
end
end
if exist('km','var')
DELNAME = char(GC(km));
fprintf(obj1, ['SENS:CORR:CSET:DEL "',DELNAME,'"']);
end
fprintf(obj1, ['SENS:CORR:CSET:NAME "',NAME,'"']);

calFileName = query(obj1,'SENSe:CORRection:CSET:DESC?');