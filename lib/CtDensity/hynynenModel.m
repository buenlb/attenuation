% hynynenModel returns the predicted speed of sound and hu values from
% Hynynen's paper. The hu cannot be selected by the user because the paper
% doesn't provide the underlying function - just a series of points. This
% function simply returns that series of points.
% 
% @INPUTS
%   hu: HU of voxel for which the estimate is desired
% 
% @OUTPUTS
%   c: estimated speed of sound
% 
% Taylor Webb
% June 2016

function [hu,c,rhoCT] = hynynenModel(method,freq)
%% CT Attenuation variables
muW = -4.93;
muA = -999;

% These constants are used to convert to apparent density. 
k1 = 1/(muW-muA)*1e3;
k0 = 1e3*(-muA/(muW-muA));

%% Set original function: Connor 2002
% Hynynen's paper doesn't provide the actual underlying function, rather it
% provides a series of estimates from the function at different apparent
% densities.
if strcmp(method, 'Connor')
    c = [1852.7 2033.0 2183.8 2275.8 2302.6 2298.1  2300.3  2332.5  2393.4...
        2479.0  2585.4  2708.8 2845.3 2991.1 3142.1 3294.6 3444.7 3588.5...
        3722.2 3841.9 3947.6 4041.9 4127.7 4207.8 4285.1];

    % Convert apparent densit to HU
    rhoCT = 1e3:100:3400;

%% Pichardo 2011
elseif strcmp(method, 'Pichardo')
    switch freq
        case 270
            c = [1677.8,1756.3,1852.4,1939.1,2025.1,2109.7,2194.2,2289.8,2410.5,2566.3,2734.0,2890.7,3039.2,3184.1,3329.9];
        case 836
            c = [1834.8 1959.4 2067 2152.3 2218.8 2278.9 2343.1 2414.4 2494.6 2585.5 2688.7 2805.9 2939.0 3089.5 3248.1];
    end
    rhoCT = 1.2e3:100:2.6e3;
else
    error([method, ' not a recongnized method'])
end

hu = (rhoCT-k0)/k1;
