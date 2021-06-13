%Combine x and y speed plots in a single video

function Draw_velocity2d_double(Outputs, Method, Geometry2D,Hbar,MRb,xleft,xright,ydown,yup)
% FOR each component

n1=floor((xleft-Geometry2D.X(1,1))/Geometry2D.dx);
n2=Geometry2D.Nx-1-floor((Geometry2D.X(end)-xright)/Geometry2D.dx);

m1=floor((ydown-Geometry2D.Y(1,1))/Geometry2D.dy);
m2=Geometry2D.Ny-1-floor((Geometry2D.Y(end)-yup)/Geometry2D.dy);

for n = 1:Method.Ncomponents
    %% Building matrix associated with the evolution of the wave function
    velocx = zeros(m2-m1+1,n2-n1+1, Outputs.Iterations); %3D matrix containing x velocities
    velocy = zeros(m2-m1+1,n2-n1+1, Outputs.Iterations);
    %[gridx, gridy] = meshgrid(Geometry2D.X(n1:n2), Geometry2D.Y(m1:m2));
    
    v = VideoWriter('speeds.avi','Motion JPEG AVI');
    open(v)
    %draw the velocity x frames 
    
    for m = 1:Outputs.Iterations
        close all
        subplot(2,1,1);
        
        velocx(:,:,m) = Hbar/MRb*angle(Outputs.Solution{m}{n}(m1:m2,n1+1:n2+1)./Outputs.Solution{m}{n}(m1:m2,n1:n2))/Geometry2D.dx;
        h = surf(Geometry2D.X(m1:m2,n1:n2), Geometry2D.Y(m1:m2,n1:n2), velocx(:,:,m));
        title('X velocity');
        set(h,'LineStyle','none');
        
        xlim([xleft,xright]);
        ylim([ydown,yup]);
        colormap('jet');
        colorbar;
        
        caxis([-.7 .7]);
        caxis manual;
        view ([0 0 90])
        %drawnow;
        
        subplot(2,1,2);
        velocy(:,:,m) = Hbar/MRb*angle(Outputs.Solution{m}{n}(m1+1:m2+1,n1:n2)./Outputs.Solution{m}{n}(m1:m2,n1:n2))/Geometry2D.dy;
        g = surf(Geometry2D.X(m1:m2,n1:n2), Geometry2D.Y(m1:m2,n1:n2), velocy(:,:,m));
        title('Y velocity');
        set(g, 'linestyle', 'none');
        
        xlim([xleft,xright]);
        ylim([ydown,yup]);
        colormap('jet');
        colorbar;
        
        caxis([-.7 .7]);
        caxis manual;
        view ([0 0 90])
        drawnow;
        
        currentframe = getframe(gcf);
        writeVideo(v,currentframe);
    end
end