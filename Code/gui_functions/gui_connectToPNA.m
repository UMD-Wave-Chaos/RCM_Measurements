function handles = gui_connectToPNA(handles)

handles.pnaConnection = false;

% Find the VNA instrument - first try a visa type
handles.pnaObj = instrfind('Type', 'visa-tcpip', 'RsrcName', 'TCPIP::169.254.82.72::INSTR', 'Tag', '');
if isempty(handles.pnaObj) % Create the visa TCPIP object if it does not exist
    handles.pnaObj = visa('agilent','TCPIP0::PNA::inst0::INSTR');
else
    fclose(handles.pnaObj);
end
%if the VISA connection works, use it
if ~isempty(handles.pnaObj)
    handles.pnaConnectionType = 'visa-tcpip';
    handles.pnaConnection = true;
    handles.pnaObj.InputBufferSize = 4194304; % increase the buffer size
    handles.pnaObj.Timeout = 15; % increase the timeout time to 15 sec
    fopen(handles.pnaObj);
%otherwise try the GPIB connection
else
    handles.pnaObj = instrfind('Type', 'gpib', 'BoardIndex', 32, 'PrimaryAddress', 16, 'Tag', '');

    % Create the GPIB object if it does not exist
    % otherwise use the object that was found.
    if isempty(handles.pnaObj)
        handles.pnaObj = gpib('AGILENT', 32, 16);
    else
        handles.pnaConnectionType = 'gpib';
        handles.pnaConnection = true;
        fclose(handles.pnaObj);
        handles.pnaObj = handles.pnaObj(1);
        % Configure instrument object.
        set(handles.pnaObj, 'InputBufferSize', 10000000);
        set(handles.pnaObj, 'OutputBufferSize', 10000000);

        % Connect to instrument object, obj1.
        fopen(handles.pnaObj);
    end
end
