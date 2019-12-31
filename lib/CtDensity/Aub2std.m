% Aub2std converts from standard HUs to Aubry's verstion. See Equation (1)
% in "Experimental Demonstration of noninvasive transskull adaptive focusing
% based on prior CT scans"
% 
% @INPUTS
%   hu: Vector of standard HUs to be changed to Aubry's units
%   energy: Energy of the scan in kVp
% 
% @OUTPUTS
%   aHu: Vector of Aubry HUs
% 
% September 2016
% Taylor Webb

function hu = Aub2std(aHu,energy)
% Set up values for attenuation of bone, water, and air. Values taken from http://physics.nist.gov/PhysRefData/XrayMassCoef/tab4.html
[muA,muW,muB] = linearAtten(energy);

% Density of different materials. 
rhoB = 1920;
rhoW = 1e3;
rhoA = 0;

% Convert to Aubry HU
hu = aHu*(muB*rhoB-muW*rhoW)/(muW*rhoW-muA*rhoA);