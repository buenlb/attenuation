binEdges = 200-25:50:2500;
binCenters = binEdges(1:end-1)+25;

load('M:\SCRATCH\1520894116_4050268\simSetup\2017_08_25\2017_08_25 ctSkull.mat');
histCounts1 = histcounts(ctSkull(:), binEdges);

load('M:\SCRATCH\1520894116_4050268\simSetup\2018_02_09\2018_02_09 ctSkull.mat');
histCounts2 = histcounts(ctSkull(:), binEdges);

load('M:\SCRATCH\1507442710_fbf232b\simSetup\43214\43214 ctSkull.mat');
sys.experiment.dx = 1e-3;
sys.experiment.dy = 1e-3;
sys.experiment.dz = 1e-3;
sys.experiment.desiredFOV = 40e-2;
xGrid = single(createGrid(sys.experiment.desiredFOV, sys.experiment.dx));
yGrid = single(createGrid(sys.experiment.desiredFOV, sys.experiment.dy));
zGrid = single(createGrid(round(ctSkullRef.ZWorldLimits,3), sys.experiment.dz));
% perform teh resampling
[ctSkullXGrid, ctSkullYGrid, ctSkullZGrid] = imref2dims(ctSkullRef);
tmpF = griddedInterpolant({ctSkullYGrid, ctSkullXGrid, ctSkullZGrid}, ...
    ctSkull, 'nearest', 'none');
[xGrid3, yGrid3, zGrid3] = meshgrid(xGrid, yGrid, zGrid);
ctSkullResamp = tmpF(yGrid3, xGrid3, zGrid3);
histCounts3 = histcounts(ctSkullResamp(:), binEdges);


load('M:\SCRATCH\1520894116_4050268\simSetup\2018_02_09\2018_02_09 tissueProperties Vyas2016.mat');

cmap = lines(5);


figure; hold on;
[axs, h1, h3] = plotyy(binCenters, histCounts1, huBinCenters, props.attenuation(4:end));
xlim(axs(1), [0, 2000]);
xlim(axs(2), [0, 2000]);
h2 = plot(binCenters, histCounts2);
set(h3, 'color', 'k');
xlabel('HU');
set(axs(1), 'ycolor', [1,1,1]*0.15);
set(axs(2), 'ycolor', [1,1,1]*0.15);
ylabel(axs(1), 'Histogram counts');
ylabel(axs(2), 'Attenuation (Np/cm)');
set(h1, 'color', cmap(5,:), 'linestyle', '--', 'linewidth', 2, 'displayname', 'Patient J');
set(h2, 'color', cmap(1,:), 'linestyle', ':', 'linewidth', 2, 'displayname', 'Patient K');
set(h3, 'linewidth', 1.5, 'displayname', 'Attenuation');
legend('show');
set(axs(1), 'ytick', (0:0.5:4)*1e4);
set(axs(2), 'ytick', 0:0.5:4);
grid on;

figure; hold on;
[axs, ph3, ah] = plotyy(binCenters, histCounts3, huBinCenters, props.attenuation(4:end));
xlim(axs(1), [0, 2000]);
xlim(axs(2), [0, 2000]);
ph1 = plot(binCenters, histCounts1);
ph2 = plot(binCenters, histCounts2);
set(ah, 'color', 'k');
xlabel('HU');
set(axs(1), 'ycolor', [1,1,1]*0.15);
set(axs(2), 'ycolor', [1,1,1]*0.15);
ylabel(axs(1), 'Histogram counts');
ylabel(axs(2), 'Attenuation (Np/cm)');
set(ph3, 'color', cmap(4,:), 'linestyle', '-', 'linewidth', 2, 'displayname', 'Patient D');
set(ph1, 'color', cmap(5,:), 'linestyle', '--', 'linewidth', 2, 'displayname', 'Patient J');
set(ph2, 'color', cmap(1,:), 'linestyle', ':', 'linewidth', 2, 'displayname', 'Patient K');
set(ah, 'linewidth', 1.5, 'displayname', 'Attenuation');
legend('show');
ylim(axs(1), [0, 8e4]);
ylim(axs(2), [0, 4]);
set(axs(1), 'ytick', (0:0.5:8)*1e4);
set(axs(2), 'ytick', 0:0.5:4);
grid on;


plot(binCenters, histCounts2);
grid on;
yyaxis right;
plot(huBinCenters, props.attenuation(4:end));
