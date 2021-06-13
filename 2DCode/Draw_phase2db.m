% Make a video of the phase. This function is seldom used because the phase
% plots are very noisy
% in order to combar the nausea caused by the phase videos, i take a point 
% near the origin and subtract its phase from all points for each frame.
% This at least causes some part of the frames to have a stable colour

function Draw_phase2db(Outputs, Method, Geometry2D,Hbar,MRb, left,right,down,up)
% FOR each component

if ~exist('left','var')
    left = Geometry2D.X(0);
end
if ~exist('right','var')
    left = Geometry2D.X(end);
end
if ~exist('down','var')
    left = Geometry2D.Y(0);
end
if ~exist('up','var')
    left = Geometry2D.Y(end);
end

relativePhase=1; % the global phase changes in time, causing a lot of changing colours 

n1=floor((left-Geometry2D.X(1,1))/Geometry2D.dx);
n2=Geometry2D.Nx-1-floor((Geometry2D.X(end)-right)/Geometry2D.dx);
nm=floor((n1+n2)/2); % should be around the origin

m1=floor((down-Geometry2D.Y(1,1))/Geometry2D.dy);
m2=Geometry2D.Ny-1-floor((Geometry2D.Y(end)-up)/Geometry2D.dy);
mm = floor((m1+m2)/2); % origin


Output_iterations = 100;
Deltat = 2e-3;

for n = 1:Method.Ncomponents
    %% Building matrix associated with the evolution of the wave function
    
    %[gridx, gridy] = meshgrid(Geometry2D.X(n1:n2), Geometry2D.Y(m1:m2));
    
    v = VideoWriter('phase.avi','Motion JPEG AVI');
    open(v)
    %draw the velocity x frames 
    
    for m = 1:Outputs.Iterations
        close all
        phase = angle(Outputs.Solution{m}{n}(m1:m2,n1:n2));
        phase = phase - relativePhase * angle(Outputs.Solution{m}{n}(mm,nm)); % subtract global evolution

        h = surf(Geometry2D.X(m1:m2,n1:n2), Geometry2D.Y(m1:m2,n1:n2), phase);
        set(h,'LineStyle','none');
        caxis manual;
        caxis([-pi,pi]);
        xlim([left,right]);
        ylim([down,up]);
        colormap('jet');
        colorbar;
        timenow = string(m*Output_iterations*Deltat);
        title("Time = " + timenow + " ms");
        view ([0 0 90])
        drawnow;
        currentframe = getframe(gcf);
        writeVideo(v,currentframe);
    end
    
    close(v)

end