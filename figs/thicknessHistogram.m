% Plots attenuation as a function of HU
close all; clc;
if ~exist('atten500','var')
    runAttenuation
end
%% Sort the thicknesses
thT = [];
itT = [];
otT = [];
thIdx = [];
itIdx = [];
otIdx = [];

for ii = 1:length(FragData)
    if strcmp('Trabecular',FragData(ii).Layer)
        thIdx(end+1) = ii;
        thT(end+1) = FragData(ii).thickness;
    elseif strcmp('Inner Table', FragData(ii).Layer)
        itT(end+1) = FragData(ii).thickness;
        itIdx(end+1) = ii;
    elseif strcmp('Outer Table', FragData(ii).Layer)
        otT(end+1) = FragData(ii).thickness;
        otIdx(end+1) = ii;
    end
end
corTh = [otT,itT]*1e3;
corIdx = [otIdx,itIdx];
thT = thT*1e3;
%% Plot a histogram
h = figure;
ax = gca;
histogram(thT, 'BinWidth', 1);
hold on
histogram(corTh, 'BinWidth', 1);

xlabel('Thickness (mm)')
ylabel('# Fragments')
legend('Trabecular','Cortical','location','northeast')
makeFigureBig(h);
set(h, 'position', [488.0000  342.0000  560.0000  267.8000]);

if exist('imgPath','var')
    print([imgPath, 'figs/thicknessHist'], '-depsc')
end