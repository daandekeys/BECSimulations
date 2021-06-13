% This function generate a list of centers forming an inverse parabola
% It also works for 1D case, as long as boxsizey argument is nonzero and y0
% is set to zero
% Symmetry is assumed 

function[centerlist] = generate_centers2D(x0, y0, boxsizex, boxsizey, distance)
    nx = -2 * x0 / distance; % number of spots
    ny = -2 * y0 / distance;
    centerlist = zeros(0,3);
    
    counter = 1;
    pos_x = x0:distance:-x0; % x0, y0 are negative
    pos_y = y0:distance:-y0;
    for i = 1:size(pos_x,2)
        cx = pos_x(i);
        for j = 1:size(pos_y,2)
            cy = pos_y(j);
            if 1 - cx^2 / boxsizex^2 - cy^2 / boxsizey^2 > 0 % only add points with 'positive strength'
                scale = 1 - cx^2 / boxsizex^2 - cy^2 / boxsizey^2;
                centerlist = [centerlist; [cx cy scale]];
                counter = counter + 1;
            end
        end
    end