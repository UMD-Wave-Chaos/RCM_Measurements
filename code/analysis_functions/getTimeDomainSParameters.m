
function [t,Sct] = getTimeDomainSParameters(SCf,Freq)

%get the time domain signal
[SC11,t] = ifftS(squeeze(SCf(:,1,:)),Freq(end) - Freq(1));
[SC12,t] = ifftS(squeeze(SCf(:,1,:)),Freq(end) - Freq(1));
[SC21,t] = ifftS(squeeze(SCf(:,1,:)),Freq(end) - Freq(1));
[SC22,t] = ifftS(squeeze(SCf(:,1,:)),Freq(end) - Freq(1));

Sct(:,1,:) = SC11;
Sct(:,2,:) = SC12;
Sct(:,3,:) = SC21;
Sct(:,4,:) = SC22;
