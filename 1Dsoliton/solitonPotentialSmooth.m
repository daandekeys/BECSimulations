function [pot] = solitonPotentialSmooth(x, t)
    hbar = 7.6381;
    waist = .6; % Width of the depleting beam
    pos = 5; % Position of the depleting beam
    dimple = exp(-2*((x-pos)/waist).^2); % Shape of the depleting potential, guassian
    dimpleStrength = .78*2*pi*hbar; % Like in spielman
    %dimpleStrength = dimpleStrength * 2; % Our stronger trap requires stronger depletion
    %dimpleStrength = 15; 
    sign = 1; % Which side gets the phase imprint
    
    rampUp = 15; % Ramp up time in ms
    rampDown = 3; % Ramp down time in ms
    dmdtime = 0.1; % Time between dimple potential and phase imprint (no instant switching possible)
    phaseTime = 0.23; % how long the phase imprinting potential is used
    phaseStrength = 5.5*pi*hbar;
    noDimple = 0.6; 
    noDimple = phaseTime + 2 * dmdtime; % time between ramp up and ramp down phase
    endTime = rampUp + rampDown + noDimple + 2 * dmdtime;
    
    if (t < rampUp) % depletion: linear ramp up
        pot = dimple*t*dimpleStrength/(rampUp);
    elseif (t > rampUp + dmdtime) && (t < rampUp + dmdtime + phaseTime) % phase imprint
        pot = tanh(sign*(x-pos)/0.1)*phaseStrength; 
    elseif (t > rampUp + noDimple) && (t < rampUp + rampDown + noDimple) % linear ramp down
        pot = dimple*(endTime-t)/rampDown*0.78/2*pi;
    else
        pot = 0;
    end
end