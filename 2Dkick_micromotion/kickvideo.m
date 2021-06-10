%% This file makes a video of the velocities on time t
%  These have been calculated from the first order kick
%  Following the work of goldman and d'alibard
%  Typically, one would call this during or after a normal calculation
%  In that case, a Geometry2D and center list should already be defined
%  Otherwise, uncomment the following lines


xmin = -25; % x direction has the low trapping frequency
xmax = 25;
ymin = -3; % kleiner dan xmin omdat de potentiaal sterker is
ymax = 3;
Nx = 2^9+1;
Ny = 2^8+1; % kleiner aantal punten door kleinere range mag mss
%{
Geometry2D = Geometry2D_Var2d(xmin, xmax, ymin, ymax, Nx, Ny);

waist = 2; % width of the spots in µm, assumed round
distance = 0.7*waist; % cf. bell 2016 
boxsizex = 15; %half the size of the box in x direction (weak trapping)
offsetx = rem(boxsizex, distance); % distance between box edge and first spot in µm

boxsizey = boxsizex * nuaxial / nurad; % ensures the harmonics in x and y are the same height at the edge of the box
offsety = rem(boxsizey, distance); % distance between box edge and first spot in µm

centers = generate_centers2D(-boxsizex + offsetx, -boxsizey + offsety, boxsizex, boxsizey, distance);
spottime = 0.010; 

hbar=7.6381;
mRb=10.28;
waist=2;
%}


v = VideoWriter('kick.avi','Motion JPEG AVI');
open(v);

for t = 0:0.01:1
   kick = firstorderkick(t, centers, spottime, Geometry2D, hbar, mRb, waist, 1); 
   % x and y arguments have been removed, add these in Geometry2D 
   %surf(Geometry2D.X, Geometry2D.Y, kick);
   %view ([0 0 90]);
   currentframe = getframe(gcf);
   close;
   writeVideo(v,currentframe);

end

close(v);