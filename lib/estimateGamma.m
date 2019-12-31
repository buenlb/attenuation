% Estimates the reflection coefficient, gamma, using measurements of the
% velocity and density of the sample. Uses the assumptions of semi-infinite
% layers
% 
% @INPUT
%   c: acoustic velocity in the fragment. May be a scalar or a vector
%   rho: density of the fragment. Must be same size as c.
% 
% @OUTPUT
%   gamma: computed reflection coefficient
function gamma = estimateGamma(c,rho)
% Density and velocity in water
rhoW = 1e3;
cW = 1492;

if length(c) ~= length(rho)
    error('Velocity and density vectors must be the same size!')
end

gamma = (rho*c-rhoW*cW)./(rho*c+rhoW*cW);