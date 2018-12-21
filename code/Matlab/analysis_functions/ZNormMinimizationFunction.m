function y = ZNormMinimizationFunction(beta, Zc, Zavg_bar, Zavg)
%y = ZNormMinimizationFunction(beta, Zc, Zavg_bar Zavg)
%Function to minimize normalization in Z domain
%Inputs:
%beta: scalar gain to optimize over
%Zc: Raw cavity measurement for a single realization
%Zavg_bar: Ensemble average that excludes oscillations
%Zavg: Ensemble average that includes oscillations
%
%Outputs:
%y: results of cost function

y = sum(abs(Zc - 1j*(beta*imag(Zavg_bar) + (1-beta)*imag(Zavg))).^2)/length(Zc)^2;

