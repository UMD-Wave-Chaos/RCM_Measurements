function Znormf = normalizeSinglePortImpedance(Zcf,Zradf, varargin)
  
Znormf = zeros(size(Zcf));
N = size(Zcf,2);

for incr = 1:N
    Znormf(:,incr) = real(Zradf).^(-0.5) .* (Zcf(:,incr) -1j*imag(Zradf) ) .* real(Zradf).^(-0.5);
end