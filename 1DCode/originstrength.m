% Function to correct for spot overlap causing a higher potential than
% wanted
% Despite being called originstrength, you can give optional parameters of
% a different position to use as the norm

function[strength] = originstrength(waist, centerlist, cx, cy)
 if ~exist('cx','var')
    % third parameter does not exist, so default it to origin
    cx = 0;
 end    

 if ~exist('cy','var')
    % fourth parameter does not exist, so default it to origin
    cy = 0;
 end  
 
    len = length(centerlist);
    strength = 0;
    for i = 1:len
        xi = centerlist(i, 1);
        yi = centerlist(i, 2);
        amp = centerlist(i, 3);
        dist2 = (xi-cx)^2 + (yi-cy)^2;
        strength = strength + amp * exp(-2 * dist2 / waist^2);
    end 
end