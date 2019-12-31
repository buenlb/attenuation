% std2Aub converts from standard HUs to Aubry's verstion. See Equation (1)
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

function [aHu,phi,rho,c] = std2Aub(hu,energy)
% Set up values for attenuation of bone, water, and air. Values taken from http://physics.nist.gov/PhysRefData/XrayMassCoef/tab4.html
[muA,muW,muB] = linearAtten(energy);

% Convert to kg/m^2


% Density of different materials. 
rhoB = 1920; % From NIST
rhoW = 1e3;
rhoA = 0;

% Convert to Aubry HU
aHu = hu*(muW*rhoW-muA*rhoA)/(muB*rhoB-muW*rhoW);

phi = 1-aHu/1e3;
rho = phi*1e3+(1-phi)*1.920e3; % Equation (4)
c = 1500+(2.9e3-1500)*(1-phi); % Equation (5)