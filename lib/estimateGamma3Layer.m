% Estimates the reflection coefficient, gamma, using measurements of the
% velocity and density of the sample. Uses layered media assumptions
% according to Folds D, Loggins C. The Journal of the Acoustical Society
% of America. 1977;62(5):1102–1109.
% 
% @INPUT
%   c: acoustic velocity in the fragment. May be a scalar or a vector
%   rho: density of the fragment. Must be same size as c.
%   thickness: element thickness in mm
%   f: frequency of acoustic radiation in MHz
%   attenuation: Optional. Attenuation in np/cm. Defaults to zero
% 
% @OUTPUT
%   gamma: computed reflection coefficient
%   T: estimated transmission coefficient
function [gamma,T] = estimateGamma3Layer(c,rho,thickness,f,attenuation)

if nargin < 5
    attenuation = 0;
else
    attenuation = attenuation*100; % Convert to np/m
end

thickness = thickness*1e-3; % convert to meters
f = f*1e6; % Convert to Hz
omega = 2*pi*f;

Zwater = 1e3*1492;

cShear = 900;
C = calcCTransMatrix(c,cShear,omega,0,thickness,rho,attenuation);

M22 = C(2,2)-C(2,1)*C(4,2)/C(4,1);
M32 = C(3,2)-C(3,1)*C(4,2)/C(4,1);
M23 = C(2,3)-C(2,1)*C(4,3)/C(4,1);
M33 = C(3,3)-C(3,1)*C(4,3)/C(4,1);

gamma = (M32+Zwater*M33-(M22+Zwater*M23)*Zwater)/(M32+Zwater*M33+(M22+Zwater*M23)*Zwater);
T = 2*Zwater/((M22+Zwater*M23)*Zwater+M32+Zwater*M33);