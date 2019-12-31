% Find the mass density based on standard HU according to the Aubry method. 
% See equation (4) in "Experimental Demonstration of noninvasive transskull
% adaptive focusing based on prior CT scans"
% 
% @INPUTS
%   hu: Hounsfield Units
%   energy: Energy of the scan
% 
% @OUTPUTS
%   d: density
% 
% September 2016
% Taylor Webb

function density = aubryMassDensity(hu,energy)
phi = aubryPorosity(hu,energy);

% Density of water assumed to be 1000, density of bone assumed to be 2100
% based on the last paragraph of the section containing equation (4)
density = phi*1000+(1-phi)*2100;