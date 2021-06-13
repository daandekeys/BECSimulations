% groundstate of a 2d system

clear all;
%-----------------------------------------------------------
% Setting the data
%-----------------------------------------------------------

%% Setting the method and geometry
Computation = 'Ground';
Ncomponents = 1;
Type = 'BESP';
Deltat = 1e-2;
Stop_time = [];
Stop_crit = {'MaxNorm',1e-5};
%Precond_type = ThomasFermi; % mogelijks zet dit de beginguess?
Method = Method_Var2d(Computation, Ncomponents, Type, Deltat, Stop_time, Stop_crit);
xmin = -25; % x direction has the low trapping frequency
xmax = 25;
ymin = -5; % kleiner dan xmin omdat de potentiaal sterker is
ymax = 5;
Nx = 2^8+1;
Ny = 2^7+1; % kleiner aantal punten door kleinere range mag mss
%global Geometry2D;
Geometry2D = Geometry2D_Var2d(xmin, xmax, ymin, ymax, Nx, Ny);

%% Setting the physical problem (units: nk,micron,ms,kb)
hbar=7.6381;
g3D=0.3698; %.352517
mRb=10.28; %10.4517
nurad=1; %radial trapping frequency is 1 kHz
nuaxial=0.05; % axial trapping zwakker, 50 Hz
natoms=20000;
g1D=g3D*mRb*nurad/hbar;
%g1D=g3D*mRb*nurad/(2*pi*hbar);
g2D = g3D*sqrt(mRb * nurad)/sqrt(hbar);
a = mRb*g3D/(4*pi*hbar^2);

%% specifying the beams' parameters
waist = 2; % width of the spots in µm, assumed round
distance = 0.7*waist; % cf. bell 2016 

barrierx = 5;
barriery = 0.3;
barrieramp = 50; % doesn't really matter, just make it high enough

barriercenters = uniformspots(-barrierx, barrierx, -barriery, barriery, distance);

phasestart = -25; % leftmost edge of the region we project the phase
phasecenters = uniformspots(phasestart,-barrierx, -barriery, barriery, distance);

%centerswith = interference_centers(barrierx, .3, 1, 10,.3,.01,distance);
%centerswithout = interference_centers(barrierx, .3, 1, 0,.3,.01,distance);
height = mRb*(2*pi*nuaxial)^2*barrierx^2*0.5; % the spots2D potential has no 'physical' height
% boxsizey and nurad should give the same number


fh = @avgpot2D;
memoizedAvg = memoize(fh); % reduces calculation time by buffering in memory

%%
Delta = 2.79107/hbar;%parameters in Hamiltonian divided by hbar, such that time has units ms
Beta = g2D*natoms/hbar;
Omega = 0; % rotation disabled atm

Physics2D = Physics2D_Var2d(Method, Delta, Beta);
Physics2D = Dispersion_Var2d(Method, Physics2D);
Physics2D = Potential_Var2d(Method, Physics2D, ...
    @(x,y) .5*mRb*((2*pi*nuaxial)^2*x.^2 + (2*pi*nurad)^2*y.^2)/hbar + barrieramp*height*memoizedAvg(x, y, waist, barriercenters)/hbar);
% start from averaged of the spots

%Physics2D = Potential_Var2d(Method, Physics2D, ...

%    %start from harmonic only
Physics2D = Nonlinearity_Var2d(Method, Physics2D);

%% Setting the initial data
InitialData_Choice = 1;
Phi_0 = InitialData_Var2d(Method, Geometry2D, Physics2D, InitialData_Choice,0,0,nuaxial,nurad);


%% Setting informations and outputs


Outputs = OutputsINI_Var2d(Method);
Printing = 1;
Evo = 15;
Draw = 1;
Print = Print_Var2d(Printing,Evo,Draw);

%-----------------------------------------------------------
% Launching simulation
%-----------------------------------------------------------
%%
[Phi, Outputs] = GPELab2d(Phi_0,Method,Geometry2D,Physics2D,Outputs,[],Print);

X=Geometry2D.X;
