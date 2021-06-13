% Time evolution of the 2D system. Several potentials are present, choose
% them on line 17

%-----------------------------------------------------------
% Setting the data
%-----------------------------------------------------------

%% Setting the method and geometry
Computation = 'Dynamic';
Ncomponents = 1;
Type = 'Relaxation';
Deltat = 1e-4 ;
Stop_time = 5;
Stop_crit = [];
Method = Method_Var2d(Computation, Ncomponents, Type, Deltat, Stop_time, Stop_crit);

potential = 1;
% 1 = project spots normally, 'abrupt start'
% 2 = adiabatic switching from average to spots
% 3 = ramp up the spots (when groundstate is harmonic only)

spottime = 0.01; % time each spot is illuminated in ms
% 5 µs should be achieveable
ramptime = 3;
adiabaticTime = 10; % timescale for adiabatic ramping of spots


fh = @avgpot2D;
memoizedAvg = memoize(fh);

norm = originstrength(waist, centers);

Physics2D = Physics2D_Var2d(Method, Delta, Beta);
Physics2D = Dispersion_Var2d(Method, Physics2D);

if potential == 1
Physics2D = TimePotential_Var2d(Method, Physics2D, ...
        @(t,x,y) .5*mRb*((2*pi*nuaxial)^2*x.^2 + (2*pi*nurad)^2*y.^2)/hbar + height*spots2D(t, x, y, waist, spottime, centers)/hbar);
elseif potential == 2
        Physics2D = TimePotential_Var2d(Method, Physics2D, ...
            @(t,x,y) .5*mRb*((2*pi*nuaxial)^2*x.^2 + (2*pi*nurad)^2*y.^2)/hbar + height/hbar*((max(0,1-t/adiabaticTime)*memoizedAvg(x, y, waist, centers) + min(1, t/adiabaticTime) * spots2D(t,x,y,waist,spottime,centers))));
elseif potential == 3
    Physics2D = TimePotential_Var2d(Method, Physics2D, ...
    @(t,x,y) 0.5*mRb*((2*pi*nuaxial)^2*x.^2 + (2*pi*nurad)^2*y.^2) + height*min([t/ramptime, 1])*spots2D(t, x, y, waist, spottime, centers));
end
%@(t,x,y) .5*mRb*( (2*pi*nuaxial)^2*x.^2 + (2*pi*nurad)^2*y.^2) + height*( memoizedAvg(x,y,waist,centers)*(1-min(1,t/ramptime)) + min(1,t/ramptime) * spots2D(t,x,y,waist,spottime,centers)) );
    %;
    %@(t,x,y) potfull2D(t, x, y, waist, distance, spottime, x0, y0, boxsizex, boxsizey, nuaxial, nurad));
    %@(t,x,y) 0.5*mRb*harmonic2D(x,y,nuaxial,nurad) + height*min([t/ramptime, 1])*spots2D(t, x, y, waist, distance, spottime, x0, y0, boxsizex, boxsizey).');

Physics2D = Nonlinearity_Var2d(Method, Physics2D);
Physics2D = Gradientx_Var2d(Method, Physics2D); % adds the gradient into physics2D

%% Setting the initial data
Phi_0{1}=Phi{1,1};


%% Setting informations and outputs
Solution_save = 1;
Outputs_iterations = 100; % number of timesteps between writing an output

Outputs = OutputsINI_Var2d(Method,Outputs_iterations,Solution_save);
Printing = 1;
Evo = 1000; % number of timesteps between printing to console
Draw = 1;
Print = Print_Var2d(Printing,Evo,Draw);

%-----------------------------------------------------------
% Launching simulation
%-----------------------------------------------------------

[Phi, Outputs] = GPELab2d(Phi_0,Method,Geometry2D,Physics2D,Outputs,[],Print);

Draw_velocity2d(Outputs,Method,Geometry2D,hbar,mRb,-24,24,-2.8,2.8)
MakeVideo2d(Method,Geometry2D,Outputs)
