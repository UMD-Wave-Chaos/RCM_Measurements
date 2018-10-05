function[zeta,Np] = computeNormalizedZetaRealizationGOE(alpha,varargin)
%[zeta,Np] = computeNormalizedZetaRealizationGOE(alpha)
%[zeta,Np] = computeNormalizedZetaRealizationGOE(alpha,N)
%[zeta,Np] = computeNormalizedZetaRealizationGOE(alpha,N,M)
%[zeta,Np] = computeNormalizedZetaRealizationGOE(alpha,N,M,seed)
%
%This function returns a realization for the normalized impedance matrix
%(zeta) for the GOE case.
%
%Inputs:
% alpha: loss parameter of the system
% N: number of eigenvalues (modes) to compute (if not specified defaults to
% 500)
% M: number of ports to use (if not specified, defaults to 1)
% seed: provides a specified seed for the random number generator to use
% (if not specified, the seed is not changed)
%
%Outputs:
% zeta: normalized impedance matrix
% Np: number of eigenvalues (modes) actually used - in many cases, the
% first and last eigenvalue are outliers and need to be stripped out

    N = 500;
    M = 1;

    %check input argument list
    if nargin == 2
        N = varargin{1};
    elseif nargin == 3
        N = varargin{1};
        M = varargin{2};
    elseif nargin == 4
        N = varargin{1};
        M = varargin{2};
        seed = varargin{3};
        rng(seed);
    end

    %generate a matrix of independent, identitcally distributed variables with
    %mean of 0 and standard deviation of 1
    A = randn(N);
    %Now convert to a symmetric matrix following the GOE distribution - the
    %conjugate operation only applies if A is complex (GUE case)
    AA = 1/2*(A + conj(A'));

    %determine the eigenvalues of the GOE matrix M
    E = eig(AA);
    %use Wigner's semi-circle law to normalize the eigenvalues and
    %distribute them uniformly
    Enorm=(N/(2*pi))*(pi+2*asin(E./sqrt(2*N))+2.*(E./sqrt(2*N)).*sqrt(2*N-E.^2)/sqrt(2*N))-N/2;
    %make sure the normalized eigenvalues are purely real - clip
    %eigenvalues that are outliers
    if (max(E.^2) > 2*N) %typically only the first and last eigenvalues will cause problems
        goodIndices = find(E.^2 < 2*N);
        Enorm = Enorm(goodIndices);
        Np = length(goodIndices);   
    else
        Np = N;
    end

    %The normalized impedance matrix depends on the inverse of a
    %diagonal matrix with real part given by the eigenvalues of a random
    %matrix (Enorm) and imaginary part given by alpha. This matrix can be
    %poorly conditioned and cause problems when evaluating it directly - to
    %get around numerical issues, we can work only with the diagonal part
    %and then force the result into a diagonal matrix.
    G = -1j/pi*1./(Enorm - 1j*alpha).*eye(Np);

    %generate the random coupling matrix
    W = randn(M,Np);

    %compute the normalized impedance matrix
    zeta = W*G*W';

end