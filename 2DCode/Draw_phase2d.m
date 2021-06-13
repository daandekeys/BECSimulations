% Make a video of the phase. This function is seldom used because the phase
% plots are very noisy
% in order to combar the nausea caused by the phase videos, i take a point 
% near the origin and subtract its phase from all points for each frame.
% This at least causes some part of the frames to have a stable colour

function Draw_phase2d(Outputs, Method, Geometry2D,Hbar,MRb,xleft,xright,ydown,yup)
% FOR each component

relativePhase=1; % the global phase changes in time, causing a lot of changing colours 
% in these videos. Put this to 1 to subtract the phase of a central point
% this reduces flashing 

n1=floor((xleft-Geometry2D.X(1,1))/Geometry2D.dx);
n2=Geometry2D.Nx-1-floor((Geometry2D.X(end)-xright)/Geometry2D.dx);
nm=floor((n1+n2)/2); % reference point around the origin

m1=floor((ydown-Geometry2D.Y(1,1))/Geometry2D.dy);
m2=Geometry2D.Ny-1-floor((Geometry2D.Y(end)-yup)/Geometry2D.dy);
mm = floor((m1+m2)/2);

for n = 1:Method.Ncomponents
    %% Building matrix associated with the evolution of the wave function
    velocx = zeros(m2-m1+1,n2-n1+1, Outputs.Iterations); %3D matrix containing x velocities
    velocy = zeros(m2-m1+1,n2-n1+1, Outputs.Iterations);
    %[gridx, gridy] = meshgrid(Geometry2D.X(n1:n2), Geometry2D.Y(m1:m2));
    videoname = 'phase' + string(n) + '.avi';
    v = VideoWriter(videoname,'Motion JPEG AVI');
    open(v)
    %draw the velocity x frames 
    
    for m = 1:Outputs.Iterations
        close all
        phase = angle(Outputs.Solution{m}{n}(m1:m2,n1:n2));
        phase = phase - relativePhase * angle(Outputs.Solution{m}{n}(mm,nm)); % subtract phase at origin
        h = surf(Geometry2D.X(m1:m2,n1:n2), Geometry2D.Y(m1:m2,n1:n2), phase);
        set(h,'LineStyle','none');
        caxis manual;
        caxis([-pi, pi])
        xlim([xleft,xright]);
        ylim([ydown,yup]);
        colormap('jet');
        colorbar;
        view ([0 0 90])
        drawnow;
        currentframe = getframe(gcf);
        writeVideo(v,currentframe);
    end
    
    close(v)
    
    
    %{
    for m = 1:Outputs.Iterations
        velocy(:,:,m) = Hbar/MRb*angle(Outputs.Solution{m}{n}(m1+1:m2+1,n1:n2)./Outputs.Solution{m}{n}(m1:m2,n1:n2))/Geometry2D.dy;
        h = surf(Geometry2D.X(m1:m2,n1:n2), Geometry2D.Y(m1:m2,n1:n2), velocy(:,:,m));
        set(h,'LineStyle','none');
        colorbar;
        drawnow;
        

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
    %}
end