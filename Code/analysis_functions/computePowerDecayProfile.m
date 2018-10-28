

pdp = mean(abs(SCt(:,3,:)).^2,3);

nPoints = 100;
stepSize = 25;
done = 0;

previousPDPSum = 0;
currentIndex = 1;
increasing = false;
decreasing = false;

index = 1;

val = [];

% while done ~= 3
%     
%     if (currentIndex + nPoints > length(pdp))
%         done = 3;
%         break;
%     end
%     
%     pdpSum =  sum(pdp(currentIndex:currentIndex + nPoints));
%     
%     if pdpSum > previousPDPSum
%         increasing = true;
%         decreasing = false;
%     elseif pdpSum < previousPDPSum && t(currentIndex) > 0
%         increasing = false;
%         decreasing = true;
% %         done = done + 1;
%         index = currentIndex + floor(nPoints/2);
%     end
%     val(currentIndex) = pdpSum;
%     previousPDPSum = pdpSum;
%     currentIndex = currentIndex + 1;
%        
% end

smoothPDP = af*smooth(pdp,sf);

testVal = 0;
for cnt = 1:length(smoothPDP) - nPoints
    
    pdpSum = sum(smoothPDP(cnt:cnt + nPoints));
    
    if pdpSum < previousPDPSum && t(cnt) > 0
        testVal = testVal + 1;
    end
    
    previousPDPSum = pdpSum;
    
    if (testVal > 3)
        index = cnt + floor(nPoints/2);
        break;
    end
end

tBreakLate = t(index) + 0.5e-6;
tBreakEarly = t(index)/2;


earlyStart = find(abs(t) == min(abs(t)));
earlyStop = find(abs(t- tBreakEarly) == min(abs(t-tBreakEarly)));  
lateStart = find(abs(t- tBreakLate) == min(abs(t-tBreakLate)));              
lateStop = find(abs(t-((l*1500)/3E8)) == min(abs(t-((l*1500)/3E8))));             

pdpEarly = pdp(earlyStart:earlyStop);
timeEarly = t(earlyStart:earlyStop);
pdpLate = pdp(lateStart:lateStop);
timeLate = t(lateStart:lateStop);

%get the "early time" and the "late time"
af = 10000;
sf = 1000;
smoothPDPEarly = af*smooth(pdpEarly,sf);
smoothPDPLate = af*smooth(pdpLate,sf);


figure;
plot(t*1e6,pdp);
hold on
plot(timeEarly*1e6,smoothPDPEarly/af,'LineWidth',2);
plot(timeLate*1e6,smoothPDPLate/af,'LineWidth',2);

gEarly = fit(timeEarly,smoothPDPEarly, fittype('exp2'));   
gLate = fit(timeLate,smoothPDPLate, fittype('exp1'));   

tau_e = -1/gEarly.b;
tau_rc = -1/gLate.b;

plot(timeEarly*1e6,gEarly(timeEarly)/af);
plot(timeLate*1e6,gLate(timeLate)/af);

