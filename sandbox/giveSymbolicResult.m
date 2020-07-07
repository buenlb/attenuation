% Takes the symbolic function defined by model and evaluates it at the
% values of HU and FREQ given as the first two arguments. These variables
% do not have to be the same size but model must be able to be solved with
% the sizes that are given. 
% 
% @INPUTS
%   HU: HU values at which to evaluate model
%   FREQ: Frequency values at which to evaluate model
%   model: String representing the function of HU and FREQ which estimates
%      attenuatino
%   fitResult: Struct with value of all coefficients in model
%   coeffs: Name of coefficients in model, must match the name of the
%      coefficients in the model string and the fitResult struct
% 
% @OUTPUTS
%   atten: Attenuation resulting from values of HU and FREQ
% 
% Taylor Webb
% University of Utah, Stanford University
% Spring 2020

function atten = giveSymbolicResult(HU,FREQ,model,fitResult,coeffs)

for ii = 1:length(coeffs)
    eval([coeffs{ii}, '= fitResult.',coeffs{ii},';']);
end

eval(['atten = ', model, ';']);