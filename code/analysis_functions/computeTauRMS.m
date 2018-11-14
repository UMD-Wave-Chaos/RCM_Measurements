function tauRMS = computeTauRMS(PDP,t,tau0)

[m,~] = size(t);
[m1,~] = size(PDP);

if (m ~= m1)
    t = t';
end

tauRMS = sqrt (sum( (t-tau0).^2.*PDP) / sum(PDP));