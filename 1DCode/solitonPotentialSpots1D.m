% Full soliton imprinting process using the time-dependent imprinting potential

function [pot] = solitonPotentialSpots1D(x, t)
    hbar = 7.6381;
    
    waist = .6; % Width of the depleting beam
    pos = 0; % Position of the depleting beam
    dimple = exp(-2*((x-pos)/waist).^2); % Shape of the depleting potential, guassian
    dimpleStrength = .78*2*pi*hbar*3; % Similar to spielman
    
    rampUp = 15; % Ramp up time in ms
    rampDown = 3; % Ramp down time in ms
    dmdtime = 0.1; % Time between dimple potential and phase imprint (no instant switching possible)
    
    waistPhase = .4; % Width of the phase imprinting beams
    spotsmin = -20; % Left edge of phase imprinting region
    spotsmax = 0; % Right edge
    distance = .7*waistPhase; % Inter spot distance
    
    spottime = 0.005;
    centers = uniformspots(spotsmin, spotsmax, 0, 0, distance, waist);
    change_centerorder(centers,1);
    nspots = size(centers,1);
    nperiods = 1;% Let the sequence go an integer amount of times
    
    phaseDiff = 2*pi; % Phase difference to imprint
    phaseTime = nspots*nperiods*spottime;
    phaseStrength = hbar*phaseDiff / phaseTime; % Too small?
    
    noDimple = phaseTime + 2 * dmdtime; % time between ramp up and ramp down phase
    endTime = rampUp + rampDown + noDimple + 2 * dmdtime;
    
    if (t < rampUp) % depletion: linear ramp up
        pot = dimple*t*dimpleStrength/(rampUp);
    elseif (t > rampUp + dmdtime) && (t < rampUp + dmdtime + phaseTime) % phase imprint
        pot = phaseStrength*spots1D(t, x, waistPhase, spottime, centers, 1); 
    elseif (t > rampUp + noDimple) && (t < rampUp + rampDown + noDimple) % linear ramp down
        pot = dimple*(endTime-t)/rampDown*0.78/2*pi;
    else
        pot = 0;
    end
end