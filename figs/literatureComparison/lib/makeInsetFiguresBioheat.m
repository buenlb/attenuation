function makeInsetFiguresBioheat(commitDir, varargin)
% Create a bioheat figure at timepoint 3. Include a zoomed in portion of the
% figure as an inset

warning off

% specify the subjects and sonications
if isempty(varargin)
    sonications = querySubjectsAndSonications();
else
    sonications = querySubjectsAndSonications(varargin{1});
end

% specify whether to use temperature or normalized units
normalizedUnitsFlag = '';
while ~ismember(normalizedUnitsFlag, {'y', 'n'})
    normalizedUnitsFlag = input('use normalized units? (y/n): ', 's');
end
if strcmp(normalizedUnitsFlag, 'y')
    figureType = 'normalized';
else
    figureType = 'temp';
end

% iterate through each sonication
for i = 1:size(sonications,1)
    % setup the sys structure
    sys = systemDefs(getenv('PI_HOME'), getenv('SCRATCH'));
    sys.experiment.finalSimSpace = 'MR';
    sys.experiment.subjectName = sonications{i,1};
    sys.experiment.sonication = sonications{i,2};
    sonicationNum = str2double(sys.experiment.sonication(11:end));

    % setup the filepaths
    simSetupPath = fullfile(sys.constants.saveRootPath, commitDir, 'simSetup', sys.experiment.subjectName);
    tSimSlicePath = fullfile(sys.constants.saveRootPath, commitDir, '002_tt_111', sys.experiment.subjectName, 'tSimSlice');
    insetFigSavePath = fullfile(sys.constants.saveRootPath, commitDir, '002_tt_111', sys.experiment.subjectName, 'tSimSlice inset figures');
    mkdir(insetFigSavePath);

    %% bioheat data
    % filter for mat files
    listing = dir(tSimSlicePath);
    targetFileString = '.mat';
    excludeInds = cellfun(@isempty, strfind({listing.name}, targetFileString))';
    listing = listing(~excludeInds);

    % filter for the specific sonication
    targetFileString = sprintf('%s %02d', sys.experiment.subjectName, sonicationNum);
    excludeInds = cellfun(@isempty, strfind({listing.name}, targetFileString))';
    listing = listing(~excludeInds);

    % load the tSimSlice mat file
    try
        tSimSliceFile = fullfile(tSimSlicePath, listing(1).name);
        tSimSliceVars = load(tSimSliceFile);
    catch
        continue;
    end

    % get timepoint 3
    tempSlice = tSimSliceVars.timepointTs(:,:,3) - 37;
    maxTemp = max(tempSlice(:));


    %% CT data
    % load the simSetup mat file
    simSetupFilename = sprintf('%s simSetup.mat', sys.experiment.subjectName);
    simSetupFile = fullfile(simSetupPath, simSetupFilename);
    simSetupVars = load(simSetupFile);
    
    % pull the appropriate slice from the CT volume
    ctSkullModel = double(simSetupVars.ctSkullModel);
    sys.experiment.thermomScanPlane = tSimSliceVars.sys.experiment.thermomScanPlane;
    [ctSliceUp, tempSliceUp] = upsampleCtSlice(sys, ctSkullModel, simSetupVars.ctSkullRef, tempSlice, tSimSliceVars.iSimSliceGrid, tSimSliceVars.iSimSliceImgGrid);

    % combine several labels to make the figure look better
    ctSliceUp(ctSliceUp<4) = 0;
    nonSkullMask = ctSliceUp<4;


    %% create figure
    % beam profile overlaid on CT
    threshLevel = 0.01;
    f1 = beamOverlay(tempSliceUp.*nonSkullMask, ctSliceUp, tSimSliceVars.iSimSliceImgGrid.xGrid*1e3, tSimSliceVars.iSimSliceImgGrid.yGrid*1e3, ...
        maxTemp, threshLevel, figureType, 'gray');
    scanPlane = tSimSliceVars.sys.experiment.thermomScanPlane;
    formatFigureACS(scanPlane, 'axes', 'lps');
    titlestr = sprintf('%s %02d sim timepoint 3', sys.experiment.subjectName, sonicationNum); 
    title(titlestr, 'interpreter', 'none');

    % zoomed in image
    f2 = copyobj(f1, 0);
    title('');
    colorbar('off');
    indsRange = 15;
    inds = 128-indsRange:128+indsRange;
    xlim([tSimSliceVars.iSimSliceImgGrid.xGrid(inds(1)), tSimSliceVars.iSimSliceImgGrid.xGrid(inds(end))]*1e3);
    ylim([tSimSliceVars.iSimSliceImgGrid.yGrid(inds(1)), tSimSliceVars.iSimSliceImgGrid.yGrid(inds(end))]*1e3);

    % create inset figure
    pause(0.01);
    f3 = insetFig(f1, f2, 'southwest');

    % save the figure
    saveName = sprintf('%s %02d MR space 3mm temp slice timepoint 3 with insets', ...
        sys.experiment.subjectName, sonicationNum);
    saveFile = fullfile(insetFigSavePath, saveName);
    exportFig(f3, saveFile, '-transparent', '-r300');
    close all;
end

warning on
