

baseSeed = 56898134;

alpha = [0, 0.1, 0.25, 0.5, 1.0, 2.0, 5.0, 10.0];
N = 750;
numIterations = 100000;

for counter = 1:length(alpha)
    dispstring = sprintf('Running case %d of %d, alpha = %0.1f',counter,length(alpha),alpha(counter));
    disp(dispstring)
    fileName = sprintf('alpha_%0.1f.h5',alpha(counter));
    rng(baseSeed);
    RCM_2_port_simulated_zeta(alpha(counter),numIterations,fileName,N);
end