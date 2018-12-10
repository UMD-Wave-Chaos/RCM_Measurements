function tau0 = computeTau0(PDP,t)

[m,~] = size(t);
[m1,~] = size(PDP);

if (m ~= m1)
    t = t';
end

tau0 = sum(t.*PDP)/sum(PDP);