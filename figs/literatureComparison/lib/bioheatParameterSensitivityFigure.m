% commit: 1514529828_53b9e70
% 43211, 8

tSimSlicePath = 'M:\SCRATCH\1514529828_53b9e70\002_tt_111\43211\tSimSlice'

subject = '43211';
sonication = 8;
scanPlane = 'A';
filename = sprintf('%s %02d %s MR space 3mm temp slice.mat', subject, sonication, scanPlane);
TR = 3.584;                         % sec
timepoints = (1:3)*TR - TR/2;       % sec

% load data
directory = 'conductivity0.51perfusion559';
c51p559 = load(fullfile(tSimSlicePath, directory, filename));
directory = 'conductivity0.49perfusion559';
c49p559 = load(fullfile(tSimSlicePath, directory, filename));
directory = 'conductivity0.54perfusion559';
c54p559 = load(fullfile(tSimSlicePath, directory, filename));
directory = 'conductivity0.51perfusion412';
c51p412 = load(fullfile(tSimSlicePath, directory, filename));
directory = 'conductivity0.51perfusion976';
c51p976 = load(fullfile(tSimSlicePath, directory, filename));


%% temp vs time figures
% conductivity figure
t = linspace(0, c49p559.sysBH.T, c49p559.sysBH.Nt+1);
figure; hold on;
[~,I] = max(c49p559.roiTs);
pixelInd = mode(I);
plot(t, [37, c49p559.roiTs(pixelInd,:)]-37, 'displayname', '0.49 W/m/\circC', 'linewidth', 1.5);
plot(t, [37, c51p559.roiTs(pixelInd,:)]-37, 'k', 'displayname', '0.51 W/m/\circC', 'linewidth', 1.5);
plot(t, [37, c54p559.roiTs(pixelInd,:)]-37, 'displayname', '0.54 W/m/\circC', 'linewidth', 1.5);
lh = legend('show');
grid on;
ylim([0 22]);
xlabel('Time (s)'); ylabel('Simulation temperature rise (\circC)');
title('Conductivity');
lineColor = [1,1,1]*0.2;
line([timepoints(3) timepoints(3)], ylim, 'color', 'k');
h = text(timepoints(3)-0.7, 0.5, 'Timepoint 3', 'color', lineColor);
set(h, 'rotation', 90);

% perfusion figure
t = linspace(0, c51p412.sysBH.T, c51p412.sysBH.Nt+1);
figure; hold on;
[~,I] = max(c51p412.roiTs);
pixelInd = mode(I);
plot(t, [37, c51p412.roiTs(pixelInd,:)]-37, 'displayname', '412 ml/kg/min', 'linewidth', 1.5);
plot(t, [37, c51p559.roiTs(pixelInd,:)]-37, 'k', 'displayname', '559 ml/kg/min', 'linewidth', 1.5);
plot(t, [37, c51p976.roiTs(pixelInd,:)]-37, 'displayname', '976 ml/kg/min', 'linewidth', 1.5);
lh = legend('show');
grid on;
xlabel('Time (s)'); ylabel('Simulation temperature rise (\circC)');
title('Perfusion');
ylim([0 22]);
lineColor = [1,1,1]*0.2;
line([timepoints(3) timepoints(3)], ylim, 'color', 'k');
h = text(timepoints(3)-0.7, 0.5, 'Timepoint 3', 'color', lineColor);
set(h, 'rotation', 90);


%% temp diff (compared to mean param values) vs time figures
% conductivity figure
t = linspace(0, c49p559.sysBH.T, c49p559.sysBH.Nt+1);
figure; hold on;
[~,I] = max(c49p559.roiTs);
pixelInd = mode(I);
plot(t, [0, c49p559.roiTs(pixelInd,:)-c51p559.roiTs(pixelInd,:)], 'displayname', '0.49 W/m/\circC', 'linewidth', 1.5);
plot(t, [0, c54p559.roiTs(pixelInd,:)-c51p559.roiTs(pixelInd,:)], 'displayname', '0.54 W/m/\circC', 'linewidth', 1.5);
lh = legend('show');
grid on;
ylims = [-1.2,1.2];
ylim(ylims);
set(gca, 'ytick', -1.2:0.2:1.2)
xlabel('Time (s)'); ylabel('Simulation temperature error (\circC)');
title('Potential conductivity error');
lineColor = [1,1,1]*0.2;
line([timepoints(3) timepoints(3)], ylim, 'color', 'k');
h = text(timepoints(3)-0.7, ylims(1)+0.05, 'Timepoint 3', 'color', lineColor);
set(h, 'rotation', 90);

% perfusion figure
t = linspace(0, c51p412.sysBH.T, c51p412.sysBH.Nt+1);
figure; hold on;
[~,I] = max(c51p412.roiTs);
pixelInd = mode(I);
plot(t, [0, c51p412.roiTs(pixelInd,:)-c51p559.roiTs(pixelInd,:)], 'displayname', '412 ml/kg/min', 'linewidth', 1.5);
plot(t, [0, c51p976.roiTs(pixelInd,:)-c51p559.roiTs(pixelInd,:)], 'displayname', '976 ml/kg/min', 'linewidth', 1.5);
lh = legend('show');
grid on;
ylims = [-1.2,1.2];
ylim(ylims);
set(gca, 'ytick', -1.2:0.2:1.2)
xlabel('Time (s)'); ylabel('Simulation temperature error (\circC)');
title('Potential perfusion error');
lineColor = [1,1,1]*0.2;
line([timepoints(3) timepoints(3)], ylim, 'color', 'k');
h = text(timepoints(3)-0.7, ylims(1)+0.05, 'Timepoint 3', 'color', lineColor);
set(h, 'rotation', 90);
