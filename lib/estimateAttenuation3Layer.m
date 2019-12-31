% Estimates attenuation using a three layer model as defined in Folds D, 
% Loggins C. The Journal of the Acoustical Society of America. 
% 1977;62(5):1102–1109.
% 
% @INPUTS
%   c: Acoustic Velocity in m/s
%   rho: density in kg/m^3
%   d: thickness in mm
%   f: frequency in MHz
%   il: measured insertion loss
% 
% @OUTPUTS
%   attn: estimated attenuation in np/cm


function attn = estimateAttenuation3Layer(c,rho,d,f,il)

options = optimset('TolFun',1e-12);
[attn,cost] = fminsearch(@(attn)attenuationCost(c,rho,d,f,il,attn),1,options);

if abs(cost/il) > 0.05
    warning(['Poor match! f = ', num2str(f)])
end