% create figures for the simulated and clinical focal spots


%% setup
addpath(genpath('M:\HAS-simulations\lib'));
addpath('M:\HAS-simulations');
addpath('M:\HAS-simulations\steve');
addpath('M:\HAS-simulations\inSightec\headTx');
rootPath = 'M:\SCRATCH';
bioheatCommitDir = '1507442710_fbf232b';
thermomCommitDir = '1516944389_4ff3621';

% subject and sonication
subject = '43214';
sonication = '09';


%% clinical focal spot figure
% load thermom data
thermomFilename = sprintf('%s %s thermom.mat', subject, sonication);
load(fullfile(rootPath, thermomCommitDir, 'thermomAnalysis', subject, thermomFilename));

if strcmp(subject, '43203')
    thermom(:,:,1:2) = [];
end

% create figure
thermomFrame = thermom(:,:,5);
maxVal = ceil(thermomFrame(yInd,xInd));
if mod(maxVal,2)
    maxVal = maxVal+1;
end
tempFig1 = figure; imagesc(thermomImgGrid.xGrid, thermomImgGrid.yGrid, thermomFrame, [0 maxVal]);
colormap(gray);
axis equal;
xlim([thermomImgGrid.xGrid(1) thermomImgGrid.xGrid(end)]); 
ylim([thermomImgGrid.yGrid(1) thermomImgGrid.yGrid(end)]);
units = '\circC';
h = colorbar;
title(h, units);
formatFigureACS(sys.experiment.thermomScanPlane, 'axes', 'LPS');
title('MR thermometry');

% zoomed in figure
tempFig2 = copyobj(tempFig1, 0);
title('');
colorbar('off');
indsRange = 15;
inds = 128-indsRange:128+indsRange;
xlim([thermomImgGrid.xGrid(inds(1)), thermomImgGrid.xGrid(inds(end))]);
ylim([thermomImgGrid.yGrid(inds(1)), thermomImgGrid.yGrid(inds(end))]);

pause(0.01);

f3 = insetFig(tempFig1, tempFig2, 'southwest');



%% simulated focal spot figure
% load simulated data
simSetupFilename = sprintf('%s simSetup.mat', subject);
load(fullfile(rootPath, bioheatCommitDir, 'simSetup', subject, simSetupFilename));
ctSkullModel = double(ctSkullModel);

tempSliceFilename = sprintf('%s %s A MR space 3mm temp slice.mat', subject, sonication);
load(fullfile(rootPath, bioheatCommitDir, '002_tt_111', subject, 'tSimSlice', tempSliceFilename));

% upsample the CT image
sys.constants.dataRootPath = 'M:\PI_HOME';
sys.constants.ctPath= 'M:\PI_HOME\CTs';
sys.constants.erfaPath= 'M:\PI_HOME\ERFAs';
sys.constants.thermometryPath= 'M:\PI_HOME\thermometry';
sys.constants.treatmentSummaryPath= 'M:\PI_HOME\treatmentSummaries';
sys.constants.saveRootPath= 'M:\SCRATCH';
dbstop in viewSimSliceUpsampled at 107
viewSimSliceUpsampled;

% upsample the simulated data
timepoint = 3;
tSimSlice = timepointTs(:,:,timepoint)-37;
% create a gridded interpolant object
tSimSliceF = griddedInterpolant({iSimSliceImgGrid.yGrid, iSimSliceImgGrid.xGrid}, ...
    tSimSlice, 'nearest', 'none');
% perform the upsampling
[xGridImg2, yGridImg2, zGridImg2] = ...
    meshgrid(iSimSliceImgGridUp.xGrid, iSimSliceImgGridUp.yGrid, iSimSliceImgGridUp.zGrid);
tSimSliceUp = tSimSliceF(yGridImg2, xGridImg2);
% get rid of artifacts
tSimSliceUp(1:10,:) = 0;
tSimSliceUp(end-9:end,:) = 0;
tSimSliceUp(:,1:10) = 0;
tSimSliceUp(:,end-9:end) = 0;

% create the figure
threshLevel = 0.01;
ctSliceUp2 = ctSliceUp;
ctSliceUp2(ctSliceUp2<4) = 0;
tFig1 = beamOverlay(tSimSliceUp, ctSliceUp2, ...
    iSimSliceImgGridUp.xGrid*1e3, iSimSliceImgGridUp.yGrid*1e3, ...
    maxVal, threshLevel, 'temp', 'gray');
formatFigureACS(scanPlane, 'axes', 'LPS');
title('Simulation');

% zoomed in figure
tFig2 = copyobj(tFig1, 0);
title('');
colorbar('off');
indsRange = 15;
inds = 128-indsRange:128+indsRange;
xlim([thermomImgGrid.xGrid(inds(1)), thermomImgGrid.xGrid(inds(end))]);
ylim([thermomImgGrid.yGrid(inds(1)), thermomImgGrid.yGrid(inds(end))]);

pause(0.01);

f4 = insetFig(tFig1, tFig2, 'southwest');

