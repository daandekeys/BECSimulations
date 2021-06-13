function[pot] = interference_spots2D(t, x, y, centerswith, centerswithout, waist, spottime)
    nwith = size(centerswith,2);
    if t < nwith*spottime % first period with phase imprint
        pot = spots2D(t, x, y, waist, spottime, centerswith);
    
    else % afterwards, only potential wall
        pot = spots2D(t, x, y, waist, spottime, centerswithout);
    end
end
    