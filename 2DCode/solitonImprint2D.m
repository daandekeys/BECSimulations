function [pot] = solitonImprint2D(t, x, y, cx, cy, centerlist, spottime, waist, phaseStrength, nperiods)
    hbar=7.6381; % have to define this again for some reason
    rampUp = 15;
    %rampUp=2;
    rampDown = 3;
    %rampDown = .4;
    dmdtime = spottime; % time between dimple potential and phase imprint
    dimpleStrength = 2; % Potential that creates local depletion in the BEC
    % In the paper by Spielman, this was characterised by a frequency
    % (this) times h. I copied this convention, although we work more with
    % hbar in the rest of the code. Origal paper had 0.78 but may be
    % tweaked depending on the magnetic potential
    dimpleSuppr = 1;
    phaseSuppr = 1;
    %phaseTime = 0.14; % how long the phase imprinting potential is used
    phaseTime=size(centerlist,1)*spottime*nperiods; % time period when the phase is getting imprinted
    rampOffStart = rampUp + phaseTime + 2 * spottime;
    rampOffEnd = rampUp + rampDown + phaseTime + 2 * spottime;
    
    %norm = originstrength(waist, centerlist,-12.5,0);
    
    dimple = exp(-2 * ( (x-cx).^2 + (y-cy).^2 )/ waist^2);
   
    % because we reuse the spots2D function for phase imprinting, an
    % awkward construction is used where we multiply the depletion here by
    % hbar and it is divided again in solitonImprintTime
    
    if (t < rampUp)
        pot = hbar*2*pi*dimple*t*dimpleStrength/(dimpleSuppr*rampUp);
    elseif (t > rampUp + dmdtime) && (t < rampUp + dmdtime + phaseTime)
        pot = spots2D(t,x,y,waist,spottime,centerlist)*phaseStrength/phaseSuppr;
    elseif (t > rampOffStart) && (t < rampOffEnd)
        pot = hbar*2*pi*dimple*(rampOffEnd-t)*dimpleStrength/(rampDown*dimpleSuppr);
    else
        pot = 0;
    end
end