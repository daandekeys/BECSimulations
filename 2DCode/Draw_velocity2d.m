% Make a video of the veolicities

function Draw_velocity2d(Outputs, Method, Geometry2D,Hbar,MRb,xleft,xright,ydown,yup)
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
    
    v = VideoWriter('speedx.avi','Motion JPEG AVI');
    open(v)
    %draw the velocity x frames 
    
    for m = 1:Outputs.Iterations
        close all
        velocx(:,:,m) = Hbar/MRb*angle(Outputs.Solution{m}{n}(m1:m2,n1+1:n2+1)./Outputs.Solution{m}{n}(m1:m2,n1:n2))/Geometry2D.dx;
        h = surf(Geometry2D.X(m1:m2,n1:n2), Geometry2D.Y(m1:m2,n1:n2), velocx(:,:,m));
        set(h,'LineStyle','none');
        caxis manual;
        caxis([-.5,.5])
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
    
    u = VideoWriter('speedy.avi','Motion JPEG AVI');
    open(u)
    %draw the velocity x frames 
    
    for m = 1:Outputs.Iterations
        close all
        velocy(:,:,m) = Hbar/MRb*angle(Outputs.Solution{m}{n}(m1+1:m2+1,n1:n2)./Outputs.Solution{m}{n}(m1:m2,n1:n2))/Geometry2D.dy;
        h = surf(Geometry2D.X(m1:m2,n1:n2), Geometry2D.Y(m1:m2,n1:n2), velocy(:,:,m));
        set(h,'LineStyle','none');
        xlim([xleft,xright]);
        ylim([ydown,yup]);
        caxis manual;
        caxis([-.5,.5])
        colormap('jet');
        colorbar;
        view ([0 0 90])
        drawnow;
        currentframe = getframe(gcf);
        writeVideo(u,currentframe);
    end
    
    close(u)
    
    v = VideoWriter('speednorm.avi','Motion JPEG AVI');
    open(v)
    %draw the velocity x frames 
    velocnorm = sqrt(velocx.^2 + velocy.^2);
    for m = 1:Outputs.Iterations
        close all
        
        h = surf(Geometry2D.X(m1:m2,n1:n2), Geometry2D.Y(m1:m2,n1:n2), velocnorm(:,:,m));
        set(h,'LineStyle','none');
        xlim([xleft,xright]);
        ylim([ydown,yup]);
        caxis manual;
        caxis([0,1])
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