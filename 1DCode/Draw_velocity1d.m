% This code was written by Karel Van Acoleyen, not myself
% I also adapted my Draw_velocity2D from this file

function Draw_velocity1d(Outputs, Method, Geometry1D, Figure,Hbar,MRb,xleft,xright)
% FOR each component

n1=floor((xleft-Geometry1D.X(1))/Geometry1D.dx);
n2=Geometry1D.Nx-1-floor((Geometry1D.X(end)-xright)/Geometry1D.dx);

for n = 1:Method.Ncomponents
    %% Building matrix associated with the evolution of the wave function
    veloc = zeros(n2-n1+1,Outputs.Iterations);
    for m = 1:Outputs.Iterations
        veloc(:,m) = Hbar/MRb*angle(Outputs.Solution{m}{n}(n1+1:n2+1)./Outputs.Solution{m}{n}(n1:n2))/Geometry1D.dx;
    end
    Time = 0 : Method.Deltat*Outputs.Evo_outputs : Method.Stop_time;
    %% Printing the figure of the square of the modulus of wave function
    Figure.label = 2; % Number of the figure
    Figure.title = strcat('velocity',32,'of component ', 32, num2str(n)); % Storing title of the figure
    figure(Figure.label); % Setting the number of the figure
    clf(Figure.label); % Clear figure
    surf(Time,Geometry1D.X(n1:n2),veloc,'EdgeColor','none'); % Drawing function
    shading interp; % Setting shading
    colormap('jet'); % Setting colormap
    colorbar; % Setting colorbar
    ylabel(Figure.x); % Setting x-axis label
    xlabel('Time')
    title(Figure.title); % Setting title of the figure
    view(2)
    drawnow; % Drawing
end