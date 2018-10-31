function Sc = getSParameterCorrectionFactor(SCf,index)


% if index == 1
   
% if (index == 2 || index == 3)
        S1 = SCf(:,3,:);
        Sx1 = abs(mean(S1,3)).^2;
%         S2 = SCf(:,2,:);
%         Sx2 = abs(mean(S2,3)).^2;
% else
%         S1 = SCf(:,index,:);
%         Sx1 = abs(mean(S1,3)).^2;
%         S2 = SCf(:,index,:);
%         Sx2 = abs(mean(S2,3)).^2;
% end
        Sc = (1-Sx1);   
%     else
%         S1 = SCf(:,1,:);
%         Sx1 = abs(mean(S1,3)).^2;
%         Sc = 1./(1-Sx1);
%     end
    
    
% else
%     S2 = SCf(:,2,:);
%     Sx2 = abs(mean(S2,3)).^2;
%     Sc = sqrt(1./((1-Sx1).*(1-Sx2)));   
% 
% end
