
function [Sct, t] = getTimeDomainSParameters(SCf,Freq)

%get the time domain signal
[SC11,~] = ifftS(squeeze(SCf(:,1,:)),Freq(end) - Freq(1));
[SC12,~] = ifftS(squeeze(SCf(:,2,:)),Freq(end) - Freq(1));
[SC21,~] = ifftS(squeeze(SCf(:,3,:)),Freq(end) - Freq(1));
[SC22,t] = ifftS(squeeze(SCf(:,4,:)),Freq(end) - Freq(1));

Sct(:,1,:) = SC11;
Sct(:,2,:) = SC12;
Sct(:,3,:) = SC21;
Sct(:,4,:) = SC22;
