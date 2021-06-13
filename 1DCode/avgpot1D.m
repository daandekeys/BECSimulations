% Given a centerlist, this function returns the time averaged potential
% from the spots specified in the list if the centerlist has not been
% normalised (aka corrected for overlap), you can default it to divide by
% the time-averaged strength at the origin. Otherwise, pass 1 to this
% function

function[pot] = avgpot1D(x, waist, centerlist, norm)
nspots = length(centerlist);
pot = 0;
for i = 1:nspots
    cx = centerlist(i,1);
    %cy = centerlist(i,2);
    scale = centerlist(i,3);
    shape = exp(-2 * (x-cx).^2/ waist^2); % gaussian beam
    pot = pot + shape * scale;
end

    if ~exist('norm','var')
       norm = originstrength(waist, centerlist);
    end 
%norm = originstrength(waist, centerlist); %overlap causes the sum to be higher than 1
pot = pot / norm; 
end