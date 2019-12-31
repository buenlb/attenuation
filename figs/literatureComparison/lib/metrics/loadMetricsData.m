function [data, dataHeaders] = loadMetricsData(filepath, filepathType, subjects, thirdTimepointFrame, numSonications, targetTimepoints)


numTargetTimepoints = length(targetTimepoints);

%% setup for data parsing
[~,~,dataRaw] = xlsread(filepath);
dataHeaders = dataRaw(1,:);
dataRaw = dataRaw(2:end,:);

% create a row for each patient sonication
data = cell(size(subjects));
for i = 1:length(subjects)
    numRows = numSonications(i)*numTargetTimepoints;
    dataFillerCells = cell(numRows, size(dataRaw,2));
    dataFillerCells(:,1) = {str2double(subjects{i})};
    rowSonicationVals = repelem((1:numSonications(i))', numTargetTimepoints);
    dataFillerCells(:,2) = mat2cell(rowSonicationVals, ones(numRows,1));
    dataFillerCells(:,3:end) = {NaN};
    data{i} = dataFillerCells;
end


%% parse the data
subjectNames = cellfun(@num2str, dataRaw(:,1), 'uniformoutput', false);

% do some preprocessing
switch filepathType
case 'bioheat'
    frameNum = cat(1, dataRaw{:,4});    % frameNum will always be a numeric array
    thirdTimepointFrame = ones(size(subjects))*5;
case 'thermom'
    frameNum = cat(1, dataRaw(:,4));
    tmp = cellfun(@ischar, frameNum);
    frameNum(tmp) = {0};                % frameNum sometimes contains strings. temporary hardcoded fix
    frameNum = cell2mat(frameNum);
    % there may sometimes be subjects with _2, _3, etc. appended to the end of
    % the name. this is when multiple CTs are being tested. however, the thermom
    % doesn't change. therefore need to remove the appended _N from the name in
    % order to grab the correct rows (assume that N < 10)
    for i = 1:length(subjects)
        if strcmp(subjects{i}(end-1), '_')
            subjects{i} = subjects{i}(1:end-2);
        end
    end
end

% populate the data array
for i = 1:length(subjects)
    % grab the rows for a particular subject
    subject = subjects{i};
    subjectInds = ismember(subjectNames, subject);
    
    timepoint = frameNum-thirdTimepointFrame(i)+3;
    for j = 1:numTargetTimepoints
        targetTimepoint = targetTimepoints(j);
        % grab the rows for the target timepoints
        timepointInds = ismember(timepoint, targetTimepoint);
        % trim the data to only the target timepoints
        subjectData = dataRaw(subjectInds & timepointInds,:);
        % populate the data array
        for k = 1:size(subjectData,1)
            sonicationNum = subjectData{k,2};
            rowNum = (sonicationNum-1) * numTargetTimepoints + j;
            data{i}(rowNum,:) = subjectData(k,:);
        end
    end
end


%% cleanup
% add frame numbers for missing sonications
for i = 1:length(subjects)
    frameNums = data{i}(1:length(targetTimepoints),4);
    data{i}(:,4) = repmat(frameNums, numSonications(i), 1);
end
