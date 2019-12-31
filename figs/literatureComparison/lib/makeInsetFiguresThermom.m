function makeInsetFiguresThermom(commitDir, varargin)
% Create a thermom figure at timepoint 3. Include a zoomed in portion of the
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

% load csv file containing information on which thermom frame is timepoint 3
T = readtable('timepoint3frameNumber.csv');
timepoint3info = table2cell(T);
subjectNames = cellfun(@num2str, timepoint3info(:,1), 'uniformoutput', false);
subjectSonications = cellfun(@num2str, timepoint3info(:,2), 'uniformoutput', false);

% iterate through each sonication
for i = 1:size(sonications,1)
    % setup the sys structure
    sys = systemDefs(getenv('PI_HOME'), getenv('SCRATCH'));
    sys.experiment.finalSimSpace = 'MR';
    sys.experiment.subjectName = sonications{i,1};
    sys.experiment.sonication = sonications{i,2};
    sonicationNum = str2double(sys.experiment.sonication(11:end));

    % setup the filepaths
    thermomPath = fullfile(sys.constants.saveRootPath, commitDir, 'thermomAnalysis', sys.experiment.subjectName);
    insetFigSavePath = fullfile(sys.constants.saveRootPath, commitDir, 'thermomAnalysis', sys.experiment.subjectName, 'thermom inset figures');
    mkdir(insetFigSavePath);

    %% thermom data
    % filter for mat files
    listing = dir(thermomPath);
    targetFileString = '.mat';
    excludeInds = cellfun(@isempty, strfind({listing.name}, targetFileString))';
    listing = listing(~excludeInds);

    % filter for the specific sonication
    targetFileString = sprintf('%s %02d', sys.experiment.subjectName, sonicationNum);
    excludeInds = cellfun(@isempty, strfind({listing.name}, targetFileString))';
    listing = listing(~excludeInds);

    % load the thermom mat file
    try
        thermomFile = fullfile(thermomPath, listing(1).name);
        thermomVars = load(thermomFile);
    catch
        continue;
    end

    % find timepoint 3 for this subject & sonication
    isSubject = ismember(subjectNames, sys.experiment.subjectName);
    isSonication = ismember(subjectSonications, sys.experiment.sonication(11:end));
    targetInd = find(isSubject & isSonication);
    timepoint3frameNumber = str2double(timepoint3info{targetInd,3});

    % get timepoint 3
    tempSlice = thermomVars.thermom(:,:,timepoint3frameNumber);
    maxTemp = max(tempSlice(thermomVars.yInd, thermomVars.xInd));
    if strcmp(figureType, 'normalized')
        tempSlice = tempSlice ./ maxTemp;
        maxTemp = 1;
    end


    %% create figure
    % thermometry image
    f1 = figure; 
    imagesc(thermomVars.thermomImgGrid.xGrid, thermomVars.thermomImgGrid.yGrid, tempSlice, [0 ceil(maxTemp)]);
    colormap(gray);
    h = colorbar;
    if strcmp(figureType, 'normalized')
        title(h, 'Normalized');
        h.TickLabels = cellfun(@(x) sprintf('%1.1f', x), mat2cell(0:0.1:1, 1, ones(1,11)), 'uniformoutput', false);
    else
        title(h, '\circC');
    end
    scanPlane = thermomVars.sys.experiment.thermomScanPlane;
    formatFigureACS(scanPlane, 'axes', 'lps');
    axis equal;
    xlim([thermomVars.thermomImgGrid.xGrid(1), thermomVars.thermomImgGrid.xGrid(end)]);
    titlestr = sprintf('%s %02d thermom timepoint 3', sys.experiment.subjectName, sonicationNum); 
    title(titlestr, 'interpreter', 'none');

    % zoomed in figure
    f2 = copyobj(f1, 0);
    title('');
    colorbar('off');
    indsRange = 15;
    inds = 128-indsRange:128+indsRange;
    xlim([thermomVars.thermomImgGrid.xGrid(inds(1)), thermomVars.thermomImgGrid.xGrid(inds(end))]);
    ylim(sort([thermomVars.thermomImgGrid.yGrid(inds(1)), thermomVars.thermomImgGrid.yGrid(inds(end))]));

    % create inset figure
    pause(0.01);
    f3 = insetFig(f1, f2, 'southwest');

    % save the figure
    saveName = sprintf('%s %02d thermom timepoint 3 with insets', ...
        sys.experiment.subjectName, sonicationNum);
    saveFile = fullfile(insetFigSavePath, saveName);
    exportFig(f3, saveFile, '-transparent', '-r300');
    close all;
end

warning on
