

%% Setting the method and geometry
Computation = 'Dynamic';
Ncomponents = 1;
Type = 'Relaxation';
Deltat = 2e-4;
Stop_time = 2;
Stop_crit = [];
Method = Method_Var2d(Computation, Ncomponents, Type, Deltat, Stop_time, Stop_crit);

%% Setting the experiment parameters
spottime = 0.008; % time each spot is illuminated in ms
% 5 µs should be achieveable
releasetime = .4; % time before the BEC is released and we study TOF
phasediff = pi/2; % Phase difference we want to imprint on the left cloud
barrierSpots = true; % Whether the barrier is made by spots or the average
phaseSpots = false; % Same but with the phase imprinting
spotsExclusive = false; % Can you project spots in the phase impringing and 
% the barrier at the same time (false) or not (true)
% I think experimentally this would be true since they have a different
% intensity?

%%
fh = @avgpot2D;
memoizedAvg = memoize(fh);

Physics2D = Physics2D_Var2d(Method, Delta, Beta);
Physics2D = Dispersion_Var2d(Method, Physics2D);
harmonic = @(x,y) .5*mRb*((2*pi*nuaxial)^2*x.^2 + (2*pi*nurad)^2*y.^2)/hbar;
harmonic = memoize(harmonic);


if barrierSpots
    barrier = @(t,x,y) heaviside(releasetime-t)*barrieramp*height*spots2D(t, x, y, waist, spottime, barriercenters,1)/hbar;
else
    barrier = @(t,x,y) heaviside(releasetime-t)*barrieramp*height*memoizedAvg(x,y, waist, barriercenters,1)/hbar;
end

phaseTime = size(phaseSpots,2)*spottime;
phaseStrength = phasediff / (hbar * phaseTime);
if phaseSpots
    phase = @(t,x,y) heaviside(phaseTime-t)*phaseStrength*spots2D(t,x,y,waist,spottime,phasecenters,1)/hbar;
else
    phase = @(t,x,y) heaviside(phaseTime-t)*phaseStrength*memoizedAvg(x,y,waist, phasecenters,1)/hbar;
end



timePotential = @(t,x,y) barrier(t,x,y) + harmonic(x,y) + phase(t,x,y);

Physics2D = TimePotential_Var2d(Method, Physics2D, timePotential);
       

Physics2D = Nonlinearity_Var2d(Method, Physics2D);
Physics2D = Gradientx_Var2d(Method, Physics2D); % adds the gradient into physics2D

%% Setting the initial data
Phi_0{1}=Phi{1,1};


%% Setting informations and outputs
Solution_save = 1;
Outputs_iterations = 100; % increase to reduce number of outputs
Output_function{1} = @(Phi,x,y) angle(Phi{1,1}(x,y));
Output_name = 'Phase';

%Outputs = OutputsINI_Var2d(Method,Outputs_iterations,Solution_save,[],[],Output_function,Output_name);
Outputs = OutputsINI_Var2d(Method,Outputs_iterations,Solution_save);
Printing = 1;
Evo = 1000;
Draw = 1;
Print = Print_Var2d(Printing,Evo,Draw);

%-----------------------------------------------------------
% Launching simulation
%-----------------------------------------------------------

[Phi, Outputs] = GPELab2d(Phi_0,Method,Geometry2D,Physics2D,Outputs,[],Print);

%Draw_velocity2d(Outputs,Method,Geometry2D,hbar,mRb,-25,25,-4,4)
Draw_phase2db(Outputs, Method, Geometry2D, hbar, mRb,-25,25,-4,4);
%Draw_Timesolution2d(Outputs,Method,Geometry2D,Figure_Var1d)

MakeVideo2d(Method,Geometry2D,Outputs);
