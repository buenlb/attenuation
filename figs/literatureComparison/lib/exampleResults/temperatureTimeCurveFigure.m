% create a figure containing the bioheat and thermometry temperature traces


%% setup
addpath(genpath('M:\HAS-simulations\lib'));
addpath('M:\HAS-simulations\steve');

subject = '43214';
sonication = '09';

cmap = lines(2);

% load thermom data
thermomFilename = sprintf('%s %s thermom.mat', subject, sonication);
load(['data\exampleResults\1516944389_4ff3621\thermomAnalysis\', subject, '\', thermomFilename]);
if strcmp(subject, '43203');
    thermom(:,:,1:2) = [];
end

% load bioheat data
tempSliceFilename = sprintf('%s %s A MR space 3mm temp slice.mat', subject, sonication);
load(['data\exampleResults\1520915095_96382ca\002_tt_111\', subject, '\tSimSlice\', tempSliceFilename]);


%% thermom data
% create the time array for the thermom data
timePerFrame = 3.584;
timePts = [0, (0.5:size(thermom,3)-2) * timePerFrame];

% find which thermom pixel to grab
imgSize = size(ttd);
roiIndRange = [-2:2];
xInds = roiIndRange+imgSize(2)/2;
yInds = roiIndRange+imgSize(1)/2;
roi = ttd(yInds,xInds);
[maxTtd, maxTtdRoiInd] = max(roi(:));
[xInd, yInd] = roiInd2xyInds(xInds, yInds, maxTtdRoiInd);


%% bioheat data
% create the time array for the bioheat data
% sysBH.T = 20;                           % sec
% sysBH.dt = 100e-3;                      % 100 ms
% numStepsPerSec = 1/sysBH.dt;
% sysBH.Nt = sysBH.T * numStepsPerSec;    % number of time steps
t = linspace(0, sysBH.T, sysBH.Nt);

% find which bioheat pixel to grab
[~, ind] = max(max(roiTs,[], 2));


%% create figure
figure; hold on;
plot(timePts, squeeze(thermom(yInd,xInd,2:end)), 'o-', 'color', cmap(1,:), 'displayname', 'MR thermometry', 'linewidth', 1.5);
plot(t, roiTs(ind,:)'-37, 'color', cmap(2,:), 'displayname', 'Simulation', 'linewidth', 1.5);
% draw the timepoint lines
lineColor = [1,1,1]*0.2;
ylims = ylim;
for i = 1:3
    h = line([timepoints(i) timepoints(i)], ylim, 'color', lineColor);
    set(get(get(h,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
    h = text(timepoints(i)-0.7, ylims(1)+0.5, ['Timepoint ' num2str(i)], 'color', lineColor);
    set(h, 'rotation', 90);
end
grid on;
xlabel('Time (s)'); 
ylabel('Temperature rise (\circC)');
legend('show');
title('Temperature time curve');
