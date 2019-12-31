% Find the porosity based on standard HU according to the Aubry method. See
% equation (3) in "Experimental Demonstration of noninvasive transskull
% adaptive focusing based on prior CT scans"
% 
% @INPUTS
%   hu: Hounsfield Units
%   energy: Energy of the scan
% 
% @OUTPUTS
%   phi: Porosity
% 
% September 2016
% Taylor Webb

function phi = aubryPorosity(hu,energy)
aHu = std2Aub(hu,energy);

phi = 1-aHu/1000;