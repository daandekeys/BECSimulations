% This function generates a list of spots with equal strength in a certain
% square grid. Used mainly for phase imprinting situations

function[centerlist] = uniformspots(xmin, xmax, ymin, ymax, distance, waist)
    disty = ymax-ymin;
    distx = xmax - xmin;
    cx = (xmax + xmin) / 2; % center point for normalising
    cy = (ymax + ymin) / 2;
    ny = floor(disty / distance) + 1;
    nx = floor(distx / distance) + 1;
    xrange = -(nx-1) * distance / 2:distance:(nx-1)*distance / 2; % linspace
    yrange = -(ny-1) * distance / 2:distance:(ny-1)*distance/2;
    xrange = xrange + cx; % shift all by the center of the x and y range
    yrange = yrange + cy;
    centerlist = zeros(0, 3);
    
    for i = 1:size(xrange,2)
        for j = 1:size(yrange,2)
            centerlist = [centerlist; [xrange(i) yrange(j) 1]];
        end
    end
    scale = originstrength(waist, centerlist, cx, cy);
    % make the averaged potential of height 1 by compensating
    % for the overlap
    centerlist(:,3,:)=centerlist(:,3,:)./scale;
end
                