function [pnaObj,pnaConnection,pnaConnectionType] = connectToPNA()

pnaConnection = false;

% Find the VNA instrument - first try a visa type
pnaObj = instrfind('Type', 'visa-tcpip', 'RsrcName', 'TCPIP::169.254.82.72::INSTR', 'Tag', '');
if isempty(pnaObj) % Create the visa TCPIP object if it does not exist
    pnaObj = visa('agilent','TCPIP0::PNA::inst0::INSTR');
else
    fclose(pnaObj);
end
%if the VISA connection works, use it
if ~isempty(pnaObj)
    pnaConnectionType = 'visa-tcpip';
    pnaConnection = true;
    pnaObj.InputBufferSize = 4194304; % increase the buffer size
    pnaObj.Timeout = 15; % increase the timeout time to 15 sec
    fopen(pnaObj);
%otherwise try the GPIB connection
else
    pnaObj = instrfind('Type', 'gpib', 'BoardIndex', 32, 'PrimaryAddress', 16, 'Tag', '');

    % Create the GPIB object if it does not exist
    % otherwise use the object that was found.
    if isempty(pnaObj)
        pnaObj = gpib('AGILENT', 32, 16);
    else
        pnaConnectionType = 'gpib';
        pnaConnection = true;
        fclose(pnaObj);
        pnaObj = pnaObj(1);
        % Configure instrument object.
        set(pnaObj, 'InputBufferSize', 10000000);
        set(pnaObj, 'OutputBufferSize', 10000000);

        % Connect to instrument object, pnaObj.
        fopen(pnaObj);
    end
end