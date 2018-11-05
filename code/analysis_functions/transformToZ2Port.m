function Z = transformToZ2Port(S, varargin)

%% check to see whether or not this was called from the GUI
if (nargin == 2)
    useGUI = true;
    handles = varargin{1};
else
    useGUI = false;
end

lstring = sprintf('Transforming to Impedance');
if (useGUI == true)
    logMessage(handles.jEditbox,lstring);
else
    disp(lstring)
end

%% convert the S-parameters to Z-parameters
%assume N is of size nFreq x nPorts x nRealizations, need the number of
%realizations
N = size(S,3);
Z = zeros(size(S,1),4,N);
%assume 50 ohm load
Z0 = 50;

for i = 1:N
    deltaS = (1-S(:,1,i)).*(1-S(:,4,i)) - S(:,2,i).*S(:,3,i);
    Z(:,1,i) = Z0*((1+S(:,1,i)).*(1-S(:,4,i)) + S(:,2,i).*S(:,3,i))./deltaS;
    Z(:,2,i) = Z0*2*S(:,2,i)./deltaS;
    Z(:,3,i) = Z0*2*S(:,3,i)./deltaS;
    Z(:,4,i) = Z0*((1-S(:,1,i)).*(1+S(:,4,i)) - S(:,2,i).*S(:,3,i))./deltaS;

end