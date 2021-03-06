clear all;

% Integration grid
xmin = -30;
xmax = 30;
Nx = 2^10+1;

% Experiment properties
nurad=1; %radial trapping frequency in kHz
nuaxial=0.05;
natoms=10000;

%% Setting the method and geometry
Computation = 'Ground';
Ncomponents = 1;
Type = 'BESP';
Deltat = 5e-1;
Stop_time = [];
Stop_crit = {'MaxNorm',1e-5};
Method = Method_Var1d(Computation, Ncomponents, Type, Deltat, Stop_time, Stop_crit);
Geometry1D = Geometry1D_Var1d(xmin,xmax,Nx);

%% Setting the physical problem (units: nk,micron,ms,kb)
hbar=7.6381;
g3D=0.3698; 
mRb=10.28; 
g1D=g3D*mRb*nurad/hbar;
a = mRb*g3D/(4*pi*hbar^2);

%%

Delta = 2.79107/hbar;%parameters in Hamiltonian divided by hbar, such that time has units ms
Beta = g1D*natoms/hbar;

Physics1D = Physics1D_Var1d(Method, Delta, Beta);
Physics1D = Dispersion_Var1d(Method, Physics1D);
Physics1D = Potential_Var1d(Method, Physics1D, ...
    @(x) 0.5*mRb*(2*pi*nuaxial)^2*x.^2/hbar); % harmonic ground state
Physics1D = Nonlinearity_Var1d(Method, Physics1D);

%% Setting the initial data
InitialData_Choice = 2;
Phi_0 = InitialData_Var1d(Method, Geometry1D, Physics1D, InitialData_Choice);

%% Setting informations and outputs

Outputs = OutputsINI_Var1d(Method);
Printing = 1;
Evo = 15;
Draw = 1;
Print = Print_Var1d(Printing,Evo,Draw);

%-----------------------------------------------------------
% Launching simulation
%-----------------------------------------------------------
%%
[Phi, Outputs] = GPELab1d(Phi_0,Method,Geometry1D,Physics1D,Outputs,[],Print);

X=Geometry1D.X;
