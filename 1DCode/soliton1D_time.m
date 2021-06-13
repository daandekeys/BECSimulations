Computation = 'Dynamic';
Ncomponents = 1;
Type = 'Relaxation';

Deltat = 1e-3;
Evolution_time = 40; % How long the simulation runs in ms
useSpots = 1;

Stop_crit = [];
Method = Method_Var1d(Computation, Ncomponents, Type, Deltat, Evolution_time, Stop_crit);

Physics1D = Physics1D_Var1d(Method, Delta, Beta);
Physics1D = Dispersion_Var1d(Method, Physics1D);

% set the external potential v_ext
if useSpots == 1
    Physics1D = TimePotential_Var1d(Method, Physics1D, ...
        @(t,x) .5*mRb*(2*pi*nuaxial)^2*x.^2/hbar + solitonPotentialSpots1D(x, t)/hbar);
else
    Physics1D = TimePotential_Var1d(Method, Physics1D, ...
        @(t,x) .5*mRb*(2*pi*nuaxial)^2*x.^2/hbar + solitonPotentialSmooth(x, t)/hbar);
end

Physics1D = Nonlinearity_Var1d(Method, Physics1D);

%% Setting the initial data
Phi_0{1}=Phi{1,1};

Outputs_iterations = 10; % Steps between generating an output
Solution_save = 1;
Outputs = OutputsINI_Var1d(Method,Outputs_iterations,Solution_save);
Printing = 1;
Evo = 1000; % Steps between printing
Draw = 1;
Print = Print_Var1d(Printing,Evo,Draw);

%-----------------------------------------------------------
% Launching simulation
%-----------------------------------------------------------

[Phi, Outputs] = GPELab1d(Phi_0,Method,Geometry1D,Physics1D,Outputs,[],Print);

Draw_Timesolution1d(Outputs,Method,Geometry1D,Figure_Var1d)
X=Geometry1D.X;