

function [pot] = spots2D(t, x, y, waist, spottime, centerlist, norm)
%  iterate through centerlist
    nspots = size(centerlist,1);
    T = nspots * spottime; % scanning period
    tprime = mod(t, T); % time since the start of this period
    index = floor(tprime/spottime) + 1; % index we give to the points, +1 needed because matlab
    cx = centerlist(index, 1); % coordinates of the beam center at this point in time
    cy = centerlist(index,2);
    scale = centerlist(index,3);
    
    shape = exp(-2 * ( (x-cx).^2 + (y-cy).^2 )/ waist^2); % gaussian shape
    
    if ~exist('norm','var')
       norm = originstrength(waist, centerlist); % normalise the spots for overlap
    end    
   
    pot = nspots * scale * shape / norm; % will be multiplied by physical height in scan2D
end