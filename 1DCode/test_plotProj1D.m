% This is a test function, written to get a feel of what the potentials
% look like in 1D. This code is not used in any simulations
% However, it was used to make figure 4.2

clear all;

nuaxial = .05; 

waist = 2; % width of the spots
box = 14; %box goes from -box to box
distance = 0.7*waist; % cf. bell 2016

spottime = .2; % This doesn't matter
mRb = 10.28;
height = mRb*(2*pi*nuaxial)^2*box^2*.5; % physical scale of the spots2D potential

X = linspace(-20,20, 2^9+1);

offsetx = rem(box, distance); % Assures symmetry
x0 = -box + offsetx;

centers = generate_centers2D(x0,0, box, 0.1, distance);

nspots = size(centers,1);
T = 0:spottime:(nspots)*spottime;

figure; hold on % Plot all the spots on one figure

spota = height*spots1D(0, X, waist, spottime, centers);
plot(X,spota, 'b');

%surfa = amp*height*potfull2D(0, gridx, gridy, waist, distance, spottime, x0, y0, box, boxsizey, nuaxial, nurad);
for n = 2:nspots
    t = T(n);
    %surfa = surfa + amp*height*spots2D(t, X, Y, waist, spottime, centers); 
    new = height*spots1D(t, X, waist, spottime, centers);
    plot(X, new, 'b');
    spota = spota + new;
    %surfa = surfa + amp*height*potfull2D(t, gridx, gridy, waist, distance, spottime, x0, y0, box, boxsizey, nuaxial, nurad);
end

avgfunc = avgpot2D(X, 0, waist, centers);

harmonic = mRb * .5 *(2*pi*nuaxial)^2 * X.^2;
ampharmonic = 1; % Put to zero if you want to turn of the magnetic trap
%ampspots = distance^2/2;
ampspots=1;
%ampspots=1/distance;
plot(X, spota, 'k', 'LineWidth', 2); % total sum of spots
plot(X, harmonic, 'g', 'LineWidth', 2); 
plot(X, spota + harmonic, 'r', 'LineWidth', 2); % final potential
xlabel('x position (µm)');
ylabel('Potential');

hold off