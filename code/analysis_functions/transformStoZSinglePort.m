function Z = transformStoZSinglePort(S, varargin)

[M,N] = size(S);
tic; 
srZ0 = 50;

Z = zeros(M,N);

for nCount = 1:N
    for fCount = 1:M
    
        Z(fCount,nCount) = srZ0*( 1 + S(fCount,nCount)) * inv(1 - S(fCount,nCount));
    end

    time = toc; 
    
%     if (useGUI == true)
%         tString = sprintf('Transformed Z, realization %d of %d',i,N);
%         updateZPlots(Freq,Z(1,1,:,i),Z(1,2,:,i),Z(2,2,:,i),tString,handles)
%     end
	
	averagetime = time/nCount;
	predictedTime = averagetime*(N-nCount);
    lstring = sprintf('Transforming realization %d of %d, time = %s s, predicted remaining time = %s s',i,N,num2str(time), num2str(predictedTime));
%     if (useGUI == true)
%         logMessage(handles.jEditbox,lstring);
%     else
        disp(lstring)
%     end
    %++++++++++++++++++++++++++++++++++++++++++++++++++++
end