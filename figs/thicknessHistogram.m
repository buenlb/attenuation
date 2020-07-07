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

%% Show fragments considered good enough.
[~,~,~,fragsIdx500Layers,fragsIdx1000Layers,fragsIdx2250Layers,sk1,sk2,it,ot,md] = screenFragments(FragData);
disp('Thick Enough Fragments:')
disp('  500 kHz')
disp(['    Total: ', num2str(length(fragsIdx500Layers)), ', OT: ', num2str(length(intersect(fragsIdx500Layers,ot))),...
    ', MD: ', num2str(length(intersect(fragsIdx500Layers,md))), ', IT: ', num2str(length(intersect(fragsIdx500Layers,it)))])

disp('  1000 kHz')
disp(['    Total: ', num2str(length(fragsIdx1000Layers)), ', OT: ', num2str(length(intersect(fragsIdx1000Layers,ot))),...
    ', MD: ', num2str(length(intersect(fragsIdx1000Layers,md))), ', IT: ', num2str(length(intersect(fragsIdx1000Layers,it)))])

disp('  2250 kHz')
disp(['    Total: ', num2str(length(fragsIdx2250Layers)), ', OT: ', num2str(length(intersect(fragsIdx2250Layers,ot))),...
    ', MD: ', num2str(length(intersect(fragsIdx2250Layers,md))), ', IT: ', num2str(length(intersect(fragsIdx2250Layers,it)))])