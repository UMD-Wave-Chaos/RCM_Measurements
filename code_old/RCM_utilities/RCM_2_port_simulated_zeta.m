function [z11,z12,z21,z22] = RCM_2_port_simulated_zeta(alpha,varargin)
%RCM_2_port_simulated_zeta(alpha)
%RCM_2_port_simulated_zeta(alpha,numIterations)
%RCM_2_port_simulated_zeta(alpha,numIterations,fileName)
%RCM_2_port_simulated_zeta(alpha,numIterations,fileName,N)
%RCM_2_port_simulated_zeta(alpha,numIterations,fileName,N, seed)
%
%This function computes a simulated normalized impedance matrix for the 2
%port case from the RCM and writes it to an HDF5 file
%
%Inputs:
% alpha: loss parameter of the system
% numIterations: number of iterations to use (if not specified, defaults to 1000)
% fileName: file name to write to (if not specified, defaults to 'zeta.h5')
% N: number of eigenvalues (modes) to compute (if not specified defaults to
% 500)
% seed: provides a specified seed for the random number generator to use
% (if not specified, the seed is not changed)
%
%Outputs:
% z11, z12, z21, z22: realizations of the components of zeta

N = 1000;
M = 2; %2 ports
fileName = 'zeta.h5';
numIterations = 1000;


%check inputs
if nargin == 2
    numIterations = varargin{1};
elseif nargin == 3
    numIterations = varargin{1};
    fileName = varargin{2};
elseif nargin == 4
    numIterations = varargin{1};
    fileName = varargin{2};
    N = varargin{3};
elseif nargin == 5
    numIterations = varargin{1};
    fileName = varargin{2};
    N = varargin{3};
    seed = varagin{4};
    rng(seed);
end

%remove the file if it already exists
if exist(fileName,'file')
    delete(fileName);
end
    
%create the hdf5 file and datasets
h5create(fileName,'/z11_real',[1 numIterations]);
h5create(fileName,'/z12_real',[1 numIterations]);
h5create(fileName,'/z21_real',[1 numIterations]);
h5create(fileName,'/z22_real',[1 numIterations]);
h5create(fileName,'/z11_imag',[1 numIterations]);
h5create(fileName,'/z12_imag',[1 numIterations]);
h5create(fileName,'/z21_imag',[1 numIterations]);
h5create(fileName,'/z22_imag',[1 numIterations]);

%main loop       
for (iteration = 1: numIterations)
    %print out the current iteration periodically
    if (mod(iteration, 10) == 0)
       dispstring = sprintf('Evaluating Iteration %d of %d',iteration,numIterations);
       disp(dispstring);
    end
   
    %get zeta
    zeta = computeNormalizedZetaRealizationGOE(alpha,N,M);
    
    %store the impedance realizations
    z11(iteration) = zeta(1,1);
    z12(iteration) = zeta(1,2);
    z21(iteration) = zeta(2,1);
    z22(iteration) = zeta(2,2);
end

%write out to the HDF5 file
h5write(fileName, '/z11_real', real(z11));
h5write(fileName, '/z12_real', real(z12));
h5write(fileName, '/z21_real', real(z21));
h5write(fileName, '/z22_real', real(z22));
h5write(fileName, '/z11_imag', imag(z11));
h5write(fileName, '/z12_imag', imag(z12));
h5write(fileName, '/z21_imag', imag(z21));
h5write(fileName, '/z22_imag', imag(z22));

%plot the PDFs
figure
subplot(2,2,1)
histogram(real(z11),'Normalization','pdf');
grid on
title('Re\{z_{11}\}')
set(gca,'LineWidth',2)
set(gca,'FontSize',12)
set(gca,'FontWeight','bold')

subplot(2,2,2)
histogram(imag(z11),'Normalization','pdf');
grid on
title('Im\{z_{11}\}')
set(gca,'LineWidth',2)
set(gca,'FontSize',12)
set(gca,'FontWeight','bold')

subplot(2,2,3)
histogram(real(z12),'Normalization','pdf');
grid on
title('Re\{z_{12}\}')
set(gca,'LineWidth',2)
set(gca,'FontSize',12)
set(gca,'FontWeight','bold')

subplot(2,2,4)
histogram(imag(z12),'Normalization','pdf');
grid on
title('Im\{z_{12}\}')
set(gca,'LineWidth',2)
set(gca,'FontSize',12)
set(gca,'FontWeight','bold')
