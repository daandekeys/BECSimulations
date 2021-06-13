%%% This file is an example of how to use GPELab (FFT version)

%% Ground state of a Gross-Pitaevskii equation with quadratic potential and cubic nonlinearity in 1D


%clear all;
%-----------------------------------------------------------
% Setting the data
%-----------------------------------------------------------

%% Setting the method and geometry
Computation = 'Dynamic';
Ncomponents = 1;
Type = 'Relaxation';
Deltat = 4e-3;
Stop_time = 25;
%Stop_time = 8;
Stop_crit = [];
Method = Method_Var2d(Computation, Ncomponents, Type, Deltat, Stop_time, Stop_crit);

spottime = 0.01; % time each spot is illuminated in ms
% 5 µs should be achieveable

centers = uniformspots(-25,0,-.4,.4,1.4); % generate equal spots in the left side
centers = change_centerorder(centers,2);

phaseImprint = pi/4;
phaseImprint = 0;
phaseTime = size(centers,1)*spottime;
nperiods = 8; % amount of times you go through the spot sequence
phaseStrength = phaseImprint*hbar / (phaseTime * nperiods); % potential needed to imprint the specified phase

%norm = originstrength(waist, centers);

Physics2D = Physics2D_Var2d(Method, Delta, Beta);
Physics2D = Dispersion_Var2d(Method, Physics2D);
%Physics1D = TimePotential_Var1d(Method, Physics1D, ...
 %   @(t,x)  (box/hbar)*(tanh((-x-50)/res)+1)/2 +((box-0*step))/hbar*(tanh((x-50)/res)+1)/2+...
  %  (step/hbar)*(tanh((x-startpos+v0*t)/(50*res))+1)/2);
Physics2D = TimePotential_Var2d(Method, Physics2D, ...
    @(t,x,y) .5*mRb*((2*pi*nuaxial)^2*x.^2 + (2*pi*nurad)^2*y.^2)/hbar + solitonImprint2D(t, x, y, 0,0,centers, spottime, waist, phaseStrength, nperiods)/hbar);
    
%@(t,x,y) .5*mRb*( (2*pi*nuaxial)^2*x.^2 + (2*pi*nurad)^2*y.^2) + height*( memoizedAvg(x,y,waist,centers)*(1-min(1,t/ramptime)) + min(1,t/ramptime) * spots2D(t,x,y,waist,spottime,centers)) );
    %@(t,x,y) 0.5*mRb*((2*pi*nuaxial)^2*x.^2 + (2*pi*nurad)^2*y.^2) + height*min([t/ramptime, 1])*spots2D(t, x, y, waist, spottime, centers));
    %@(t,x,y) potfull2D(t, x, y, waist, distance, spottime, x0, y0, boxsizex, boxsizey, nuaxial, nurad));
    %@(t,x,y) 0.5*mRb*harmonic2D(x,y,nuaxial,nurad) + height*min([t/ramptime, 1])*spots2D(t, x, y, waist, distance, spottime, x0, y0, boxsizex, boxsizey).');


     
Physics2D = Nonlinearity_Var2d(Method, Physics2D);
Physics2D = Gradientx_Var2d(Method, Physics2D); % adds the gradient into physics2D


%% Setting the initial data
Phi_0{1}=Phi{1,1};


%% Setting informations and outputs
Solution_save = 1;
Outputs_iterations = 50; % increase to reduce number of outputs
%Output_function{1} = @(Phi) sqrt(g1D*natoms*abs(Phi).^2/mRb);
%Output_function{1} =  2.*Phi{1,1};
%Output_name{1} = 'phononspeed';
Output_function = @(Phi, x, y, ksix, ksiy) hbar/mRb * angle(Physics2D.Gradientx_function{1,1}(x,y));
%Output_function{1} = @(Phi, x, y, ksi, ksib) hbar/mRb*angle(Phi{1,1}(2:end,:)./Phi{1,1}(1:end-1,:))/Geometry2D.dx;
%Output_function{1} = @(Phi, x, y, ksix, ksiy) speedx(Phi,x,y, ksix, ksiy);
Output_name = 'velocity x';

%Outputs = OutputsINI_Var2d(Method,Outputs_iterations,Solution_save,[],[],Output_function,Output_name);
Outputs = OutputsINI_Var2d(Method,Outputs_iterations,Solution_save);
Printing = 1;
Evo = 100;
Draw = 1;
Print = Print_Var2d(Printing,Evo,Draw);

%-----------------------------------------------------------
% Launching simulation
%-----------------------------------------------------------

[Phi, Outputs] = GPELab2d(Phi_0,Method,Geometry2D,Physics2D,Outputs,[],Print);

Draw_velocity2d(Outputs,Method,Geometry2D,hbar,mRb,-24,24,-2.8,2.8)

%Draw_Timesolution2d(Outputs,Method,Geometry2D,Figure_Var1d)
Draw_phase2db(Outputs, Method, Geometry2D, hbar, mRb, -24,24,-2.8,2.8);
MakeVideo2d(Method,Geometry2D,Outputs)
%MakeVideo2d(Method, Geometry2D, Outputs, Output_function, "velocityx")

%figure(3)
%Time = [0:0.1:Stop_time]; 
%plot(Time, Outputs.User_defined_local{1,1});
%xlabel('Time');
%ylabel('Position of Psi_1');
%figure(4)
%plot(Time, Outputs.User_defined_local{2,1});
%xlabel('Time');
%ylabel('Position of Psi_2');