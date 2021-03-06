% Calculate the kick in time using goldman and dalibard formalism

function[correction] = firstorderkick(t, centerlist, spottime, height, geometry, hbar, mrb, waist, drawveloc)
    % Function returns the meshgrid of the kick, as well as drawing a
    % figure
    % geometry is the gpelab geometry2D struct
    % x and y are typically meshgrids
    % height is the 'physical height' of the potentials. normally, they lie
    % between 0 and 1 
    
    %drawveloc=1; % parameter to draw velocities
    % if set to 0, draw kick itself
    
    x=geometry.X;
    y=geometry.Y;
    
    kick = zeros(size(x));
    velx = zeros(size(x));
    vely = zeros(size(x));
    
    dx = geometry.dx; % used in the matlab gradient function
    dy = geometry.dy;
    
    nspots = size(centerlist,1);
    period = nspots*spottime;
    
    coeffs = kickcoefficients(t, nspots, spottime, hbar);
    
    norm = originstrength(waist, centerlist);
    
    for i = 1:nspots
        cx = centerlist(i, 1); % coordinates of the beam center at this point in time
        cy = centerlist(i,2);
        scale = centerlist(i,3);
        vi = nspots * scale*exp(-2 * ( (x-cx).^2 + (y-cy).^2 )/ waist^2)/norm; % ith contribution to the potential
        vi = vi*height; % IMPORTANT
        % I forgot this at first, height is the 'physical height'
        % the potential lies between 0 and 1 by construction otherwise
        kick = kick + coeffs(i)*vi;
        [gradx, grady] = gradient(vi, dx, dy);
        velx = velx + hbar / mrb * coeffs(i)*gradx;
        vely = vely + hbar / mrb * coeffs(i)*grady;
    end
    
    if drawveloc
        % draw the velocities
        figure;
        title(t)

        subplot(2,1,1);
        h = surf(x, y, -velx); % minus sign to draw the micromotion velocity
        title('X velocity, t= ' +string(t) + ' ms');
        set(h, 'linestyle', 'none');
        colormap('jet');
        colorbar;
        %caxis([-.007,.007]);
        caxis([-.7 .7]);
        axis([-24 24 -2.8 2.8])
        
        view ([0 0 90])
        %drawnow;

        subplot(2,1,2);
        g = surf(x, y, -vely); % minus sign for the micromotion induced velocity
        title('y velocity');
        set(g, 'linestyle', 'none');
        colormap('jet');
        colorbar;
        axis([-24 24 -2.8 2.8])
        %caxis([-.007,.007])
        caxis([-.7 .7]);
        view ([0 0 90])
        drawnow;
    else
        figure;
        h = surf(x, y, kick);
        view ([0 0 90])
        title('Kick operator at t= ' +string(t) + ' ms');
        set(h, 'linestyle', 'none');
        colormap('jet');
        colorbar;
        drawnow;
    end
    
    correction = kick;
    micromotion = -kick;
    
end
    