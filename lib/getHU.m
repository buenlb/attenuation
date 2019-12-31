% Returns all the HU values found in the fragment struct
% 
% @INPUTS
%   FragData: Frag Struct
% 
% @OUTPUTS
%   HU: N_CT_SCANS x N_FRAGMENTS matrix with all the HU values in FragData
% 
% Taylor Webb
% Summer 2019
% taylor.webb@utah.edu

function HU = getHU(FragData)
HU = zeros(length(FragData(1).CT.HU),length(FragData));

for ii = 1:length(FragData(1).CT.HU)
    for jj = 1:length(FragData)
        HU(ii,jj) = FragData(jj).CT.HU(ii);
    end
end