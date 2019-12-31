%% user specified parameters that could change
% select which subjects to analyze
targetSubjects = {'43203'; '43211'; '43213'; '43214'; '43215'; ...
                  '43262'; '43263'; '43265'; '43267'};

% thermometry timepoint to use
targetTimepoints = [1; 2; 3];

% data filepaths
desktopPath = 'C:\Users\Steve\Steve\Stanford\Labs\KBP lab\Projects\Beam simulation\Aim 1 - validation\Paper 1';
bioheatFilepath = fullfile(desktopPath, 'bioheatMetrics_002_tt_111_MR_1533365387_98da655.csv');
thermomFilepath = fullfile(desktopPath, 'thermomMetrics_1534113905_924c0ab.csv');


%% setup
% load the MR info
% column names: subject, thirdTimepointFrame, numSonications, firstMediumSonication
warning off
subjectsAllTable = readtable('subjectMrInfo.csv');
subjectsAll = table2cell(subjectsAllTable);
warning on

% grab the relevant information from the targeted subjects
targetSubjectsInds = ismember(subjectsAll(:,1), targetSubjects);
subjects = subjectsAll(targetSubjectsInds,1);
thirdTimepointFrame = cell2mat(subjectsAll(targetSubjectsInds,2));
numSonications = cell2mat(subjectsAll(targetSubjectsInds,3));
firstMediumSonication = cell2mat(subjectsAll(targetSubjectsInds,4));
hasMeThermom = cell2mat(subjectsAll(targetSubjectsInds,5));
positionExclude = [subjects, cellfun(@str2num, subjectsAll(targetSubjectsInds,6), 'uniformoutput', false)];
tempExclude = [subjects, cellfun(@str2num, subjectsAll(targetSubjectsInds,7), 'uniformoutput', false)];
calcSlopeStartSonication = cell2mat(cellfun(@str2num, subjectsAll(targetSubjectsInds,8), 'uniformoutput', false));

% plot colors
cmap = lines(5);
uniqueColors = unique(cmap, 'rows');
numColors = size(uniqueColors,1);

% organization of figure displays
numSubjects = length(subjects);
numFigCols = ceil(sqrt(numSubjects));
numFigRows = ceil(numSubjects./numFigCols);
% a = length(subjects)
% [a, sqrt(a), ceil(sqrt(a)), ceil(a./ceil(sqrt(a)))]

% aliases
alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
subjectAliases = mat2cell(alphabet(1:length(subjects))', ones(size(subjects)), 1);


%% load data
[bioheat, bioheatHeaders] = loadMetricsData(bioheatFilepath, 'bioheat', subjects, thirdTimepointFrame, numSonications, targetTimepoints);
[thermom, thermomHeaders] = loadMetricsData(thermomFilepath, 'thermom', subjects, thirdTimepointFrame, numSonications, targetTimepoints);


%% setup useful indexing arrays
numSonicationRows = zeros(size(subjects));
[axialScanPlaneInds, tempExcludeInds] = deal(cell(size(subjects)));
[isAxial, isCoronal, isSagittal] = deal(cell(size(subjects)));
[peDir, peInYInds, peInSiInds, isME] = deal(cell(size(subjects)));
[isTimepoint1, isTimepoint2, isTimepoint3] = deal(cell(size(subjects)));
for i = 1:length(subjects)
    numSonicationRows(i) = size(thermom{i},1);
    % find the rows that have axial scan plane
    scanPlane = cellfun(@num2str, thermom{i}(:,3), 'uniformoutput', false);
    axialScanPlaneInds{i} = ismember(scanPlane, 'A');
    isAxial{i} = ismember(scanPlane, 'A');
    isCoronal{i} = ismember(scanPlane, 'C');
    isSagittal{i} = ismember(scanPlane, 'S');
    % find the rows that have phase encode in image Y and SI directions
    peDir{i} = thermom{i}(:,5);
    peDir{i}(~cellfun(@isstr, peDir{i})) = {'N/A'};
    peInYInds{i} = ismember(peDir{i}, 'COL');
    peInSiInds{i} = peInYInds{i} & ~axialScanPlaneInds{i};
    % 
    timepoints = cat(1, thermom{i}{:,4});
    isTimepoint1{i} = timepoints == thirdTimepointFrame(i)-2;
    isTimepoint2{i} = timepoints == thirdTimepointFrame(i)-1;
    isTimepoint3{i} = timepoints == thirdTimepointFrame(i);
end

% calculate SNR
[bioheatSnr, thermomSnr] = deal(cell(size(subjects)));
for i = 1:length(subjects)
    bioheatSnr{i} = cell2mat(bioheat{i}(:,7)) ./ cell2mat(bioheat{i}(:,8));
    thermomSnr{i} = cell2mat(thermom{i}(:,7)) ./ cell2mat(thermom{i}(:,8));
end

% 
[thermomFocusAreas, thermomFocusMajAxLens] = deal(cell(size(subjects)));
[bioheatFocusAreas, bioheatFocusMajAxLens] = deal(cell(size(subjects)));
for i = 1:length(subjects)
    thermomFocusAreas{i} = cell2mat(thermom{i}(:,15));
    thermomFocusMajAxLens{i} = cell2mat(thermom{i}(:,22));
    bioheatFocusAreas{i} = cell2mat(bioheat{i}(:,15));
    bioheatFocusMajAxLens{i} = cell2mat(bioheat{i}(:,22));
end
