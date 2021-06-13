% This function cycles through the spots in a given list 'centerlist'
% The output will be a function that has been multiplied by nspots to
% account for time-averaging effects.

function [pot] = spots1D(t, x, waist, spottime, centerlist, norm)
%  illuminate spots from left to right for a time spottime each  
    nspots = size(centerlist,1);
    T = nspots * spottime; % scanning period
    tprime = mod(t, T);
    index = floor(tprime/spottime) + 1; % index we give to the points, +1 needed because matlab
    cx = centerlist(index, 1);
    scale = centerlist(index,3); % we use the same list as for 2D case but just ignore the y coordinate
    shape = exp(-2 * (x-cx).^2 / waist^2); % gaussian shape around 'center'
    
    if ~exist('norm','var') % norm is kinda optional and corrects for the overlap between gaussians
       norm = originstrength(waist, centerlist);
    end   
    
    pot = nspots*scale*shape / norm;
end
