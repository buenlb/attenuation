% Converts insertion loss into an estimate of attenuation using the
% reflection coeficient, gamma, and the thickness of the fragment.
% 
% @INPUTS
%   il: insertion loss of the fragment. May be a scalar or 1D vector
%   gamma: reflection coefficient of the fragment. If it is a scalar then
%       it is assumed that the reflection coeficient is the same for each
%       insertion loss measurement. Otherwise it size(gamma) must be equal
%       to size(il)
%   thickness: thickness of the fragment. Units can be anything desired -
% @OUTPUTS:
%   atten: estimation of the attenuation for each il in nepers/length where
%       the units of length are set by the units of the input variable
%       thickness
% 
% Taylor Webb
% Stanford University
% Summer 2019
% taylor.webb@utah.edu

function atten = il2atten(il, gamma, thickness)

atten = -log(il./((1+gamma).*(1-gamma)))/thickness;