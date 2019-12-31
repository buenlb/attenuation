% Plots raw with and without fragment measurements
close all; clc;
if ~exist('atten500','var')
    runAttenuation
end

fragIdx = 33;
plotRawData(FragData,fragIdx,1,imgPath)

fragIdx = 83;
plotRawData(FragData,fragIdx,0,imgPath)

fragIdx = 62;
plotRawData(FragData,fragIdx,0,imgPath)

