% Coefficients used in calculation of the kick (eq. 3.7)

function[coeffs] = kickcoefficients(t, ncenters, spottime, hbar)
    % generate the c_n vector from equation (3)
    % t is time is µs
    % ncenters is the amount of spots
    % tau is the scanning period (ncenters*spottime)
    
    coeffs = zeros(ncenters,1);
    scale = spottime / (2 * hbar);
    
    for index = 1:ncenters
        
        a = mod(index - t / spottime, ncenters); % first term in eq (3)
        b = mod(index - t / spottime - 1, ncenters);
        coeffs(index) = scale * (b - a + (a*a - b*b) / ncenters);
        
    end
end