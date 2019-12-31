%% setup
subjectsShape = {'43266'};
subjectsShape = {'43203'; '43211'; '43213'; '43214'; '43215'; ...
                 '43262'; '43263'; '43265'; '43266'; '43267'};
subjectsShape = {'43203'; '43211'; '43213'; '43214'; '43215'; ...
                 '43262'; '43263'; '43265'; ''; '43267'; ...
                 '2017_08_25'; '2018_02_09'};

coronalOnlyFlag = false;
targetFrame = 5;

shapeExcludeInds = peInSiInds;
shapeExcludeInds{2}([1]) = true;               
shapeExcludeInds{6}([2,9]) = true;               
shapeExcludeInds{9}([1,2]) = true;              % low SNR
shapeExcludeInds{9}([3,6,16]) = true;           % swaths of noise
shapeExcludeInds{9}([8,19]) = true;             % aliasing in magnitude image
shapeExcludeInds{9}([11]) = true;               % sim focal spot looks weird
shapeExcludeInds{10}([2,8]) = true;               
shapeExcludeInds{11}([1]) = true;               

% create a row for each patient sonication
[thermomShape] = deal(cell(size(subjects)));
for i = 1:length(subjects)
    thermomShapeFillerCells = cell(numSonications(i), size(thermomData,2));
    thermomShapeFillerCells(:,1) = {str2double(subjects{i})};
    thermomShapeFillerCells(:,2) = mat2cell((1:numSonications(i))', ones(1,numSonications(i)));
    thermomShapeFillerCells(:,3:end) = {NaN};
    thermomShape{i} = thermomShapeFillerCells;
end


%% parse thermom data
subjectNames = cellfun(@num2str, thermomData(:,1), 'uniformoutput', false);
frameNum = cat(1, thermomData(:,4));
tmp = cellfun(@ischar, frameNum);
frameNum(tmp) = {0};
frameNum = cell2mat(frameNum);

for i = 1:length(subjects)
    % grab the rows for a particular subject
    subject = subjects{i};
    subjectInds = ismember(subjectNames, subject);
    % grab the rows
    timepointInds = frameNum == targetFrame;
    % trim the data
    subjectThermomData = thermomData(subjectInds & timepointInds,:);
    %
    for j = 1:size(subjectThermomData,1)
        sonicationNum = subjectThermomData{j,2};
        thermomShape{i}(sonicationNum,:) = subjectThermomData(j,:);
    end
end


%% setup useful indexing arrays
[snr] = deal(cell(size(subjects)));
for i = 1:length(subjects)
    snr{i} = cell2mat(thermomShape{i}(:,6)) ./ cell2mat(thermomShape{i}(:,8));
end

[bioheatMajAL, thermomMajAL] = deal(cell(size(subjects)));
[bioheatMinAL, thermomMinAL] = deal(cell(size(subjects)));
for i = 1:length(subjects)
    bioheatMajAL{i} = nan(numSonications(i), 1);
    thermomMajAL{i} = nan(numSonications(i), 1);
    bioheatMinAL{i} = nan(numSonications(i), 1);
    thermomMinAL{i} = nan(numSonications(i), 1);
end
[targetIndsShape] = deal(cell(size(subjects)));
for i = 1:length(subjects)
    if coronalOnlyFlag
        targetIndsShape{i} = ~excludeInds{i} & ~peInSiInds{i} & ~shapeExcludeInds{i} & isCoronal;
    else
        targetIndsShape{i} = ~excludeInds{i} & ~peInSiInds{i} & ~shapeExcludeInds{i};
    end
    %
    bioheatMajAL{i}(targetIndsShape{i}) = cell2mat(bioheat{i}(targetIndsShape{i},22));
    thermomMajAL{i}(targetIndsShape{i}) = cell2mat(thermomShape{i}(targetIndsShape{i},22));
    %
    bioheatMinAL{i}(targetIndsShape{i}) = cell2mat(bioheat{i}(targetIndsShape{i},23));
    thermomMinAL{i}(targetIndsShape{i}) = cell2mat(thermomShape{i}(targetIndsShape{i},23));
end


tempThresh = 0;
aboveThreshInds = cell(size(temps));
for i = 1:length(aboveThreshInds)
    aboveThreshInds{i} = temps{i}>tempThresh;
end
% subjectInds = ismember(subjects, subjectsShape);
% aboveThresh = cell2mat(aboveThreshInds(subjectInds));
% sum(aboveThresh & cell2mat(targetIndsShape(subjectInds)))


markers = {'o', '^', 's'};
linestyles = {'-', '--', ':'};


%% create figures
% major axis length
figure; 
% subplot(1,2,1); hold on;
for i = 1:length(subjects)
    subplot(3,4,i); hold on;
    shapeInd = find(ismember(subjectsShape, subjects{i}));
    if isempty(shapeInd)
        continue;
    end

    tmp = mod(i-1,numColors);
    subjectColor = cmap(tmp+1,:);

    tmp2 = floor((i-1)/numColors);
    markerFormatSpec = {'linestyle', 'none', 'marker', markers{tmp2+1}, 'color', subjectColor};
    lineFormatSpec = {'linestyle', linestyles{tmp2+1}};
    if ismember(subjects{i}, hasMeThermom)
        markerFormatSpec = [markerFormatSpec, {'markerfacecolor', subjectColor}];
    end

    % plot the points
    plot(bioheatMajAL{i}(aboveThreshInds{i}), thermomMajAL{i}(aboveThreshInds{i}), ...
        markerFormatSpec{:}, 'displayname', subjects{i});
    axis equal;
    grid on;
    xlim([0,14]);
    ylim([0,14]);
    ylabel('MR thermometry major axis length (mm)');
    xlabel('Simulation major axis length (mm)');
    title('Major axis length');
    xlims = xlim;



    shapeInd = find(ismember(subjectsShape, subjects{i}));
    if isempty(shapeInd)
        continue;
    end
    %
    tmp = 1:numSonications(i);
    plottedSonications = tmp(targetIndsShape{i} & aboveThreshInds{i});
    for j = plottedSonications
        text(bioheatMajAL{i}(j)+0.02*xlims(2), thermomMajAL{i}(j), num2str(j));
    end

    mdl = fitlm(bioheatMajAL{i}(aboveThreshInds{i}), thermomMajAL{i}(aboveThreshInds{i}));
    x = (0:xlims(2)/10:xlims(2))';
    y = predict(mdl, x);
    plot(x, y, 'k--', 'linewidth', 2);
    text(0.1*xlims(2), 0.80*xlims(2), sprintf('r^2 = %0.3f', mdl.Rsquared.Adjusted));
    text(0.1*xlims(2), 0.75*xlims(2), sprintf('S = %0.3f', mdl.RMSE));
    text(0.1*xlims(2), 0.70*xlims(2), sprintf('p = %0.3f', mdl.anova.pValue(1)));
end


% minor axis length
figure;
for i = 1:length(subjects)
    subplot(3,4,i); hold on;
    shapeInd = find(ismember(subjectsShape, subjects{i}));
    if isempty(shapeInd)
        continue;
    end

    tmp = mod(i-1,numColors);
    subjectColor = cmap(tmp+1,:);

    tmp2 = floor((i-1)/numColors);
    markerFormatSpec = {'linestyle', 'none', 'marker', markers{tmp2+1}, 'color', subjectColor};
    lineFormatSpec = {'linestyle', linestyles{tmp2+1}};
    if ismember(subjects{i}, hasMeThermom)
        markerFormatSpec = [markerFormatSpec, {'markerfacecolor', subjectColor}];
    end

    % plot the points
    plot(bioheatMinAL{i}(aboveThreshInds{i}), thermomMinAL{i}(aboveThreshInds{i}), ...
        markerFormatSpec{:}, 'displayname', subjects{i});


    axis equal;
    grid on;
    xlim([0,14]);
    ylim([0,14]);
    ylabel('MR thermometry minor axis length (mm)');
    xlabel('Simulation minor axis length (mm)');
    title('Minor axis length');
    xlims = xlim;


    shapeInd = find(ismember(subjectsShape, subjects{i}));
    if isempty(shapeInd)
        continue;
    end
    %
    tmp = 1:numSonications(i);
    plottedSonications = tmp(targetIndsShape{i} & aboveThreshInds{i});
    for j = plottedSonications
        text(bioheatMinAL{i}(j)+0.02*xlims(2), thermomMinAL{i}(j), num2str(j));
    end

    mdl = fitlm(bioheatMinAL{i}(aboveThreshInds{i}), thermomMinAL{i}(aboveThreshInds{i}));
    x = (0:xlims(2)/10:xlims(2))';
    y = predict(mdl, x);
    plot(x, y, 'k--', 'linewidth', 2);
    text(0.1*xlims(2), 0.80*xlims(2), sprintf('r^2 = %0.3f', mdl.Rsquared.Adjusted));
    text(0.1*xlims(2), 0.75*xlims(2), sprintf('S = %0.3f', mdl.RMSE));
    text(0.1*xlims(2), 0.70*xlims(2), sprintf('p = %0.3f', mdl.anova.pValue(1)));
end



% ratio of major to minor axis length
markers = {'o', '^', 's'};
linestyles = {'-', '--', ':'};
figure; hold on;
for i = 1:length(subjects)
    shapeInd = find(ismember(subjectsShape, subjects{i}));
    if isempty(shapeInd)
        continue;
    end

    tmp = mod(i-1,numColors);
    subjectColor = cmap(tmp+1,:);

    tmp2 = floor((i-1)/numColors);
    markerFormatSpec = {'linestyle', 'none', 'marker', markers{tmp2+1}, 'color', subjectColor};
    lineFormatSpec = {'linestyle', linestyles{tmp2+1}};
    if ismember(subjects{i}, hasMeThermom)
        markerFormatSpec = [markerFormatSpec, {'markerfacecolor', subjectColor}];
    end

    % plot the points
    plot(bioheatMajAL{i}./bioheatMinAL{i}, thermomMajAL{i}./thermomMinAL{i}, ...
        markerFormatSpec{:}, 'displayname', subjects{i});
end
axis equal;
grid on;
xlim([0,6]);
ylim([0,6]);
ylabel('MR thermometry major to minor axis ratio');
xlabel('Simulated major to minor axis ratio');
title('Major to minor axis ratio');
xlims = xlim;
for i = 1:length(subjects)
    shapeInd = find(ismember(subjectsShape, subjects{i}));
    if isempty(shapeInd)
        continue;
    end
    %
    tmp = 1:numSonications(i);
    plottedSonications = tmp(targetIndsShape{i});
    for j = plottedSonications
        text(bioheatMajAL{i}(j)./bioheatMinAL{i}(j)+0.02*xlims(2), thermomMajAL{i}(j)./thermomMinAL{i}(j), num2str(j));
    end
end
subjectInds = ismember(subjects, subjectsShape);
mdl = fitlm(cell2mat(bioheatMajAL(subjectInds))./cell2mat(bioheatMinAL(subjectInds)), cell2mat(thermomMajAL(subjectInds))./cell2mat(thermomMinAL(subjectInds)));
x = (0:xlims(2)/10:xlims(2))';
y = predict(mdl, x);
plot(x, y, 'k--', 'linewidth', 2);
text(0.1*xlims(2), 0.80*xlims(2), sprintf('r^2 = %0.3f', mdl.Rsquared.Adjusted));
text(0.1*xlims(2), 0.75*xlims(2), sprintf('S = %0.3f', mdl.RMSE));
text(0.1*xlims(2), 0.70*xlims(2), sprintf('p = %0.3f', mdl.anova.pValue(1)));




%%
% MR thermometry axis lengths
markers = {'o', '^', 's'};
linestyles = {'-', '--', ':'};
figure;
subplot(1,2,1); hold on;
for i = 1:length(subjects)
    shapeInd = find(ismember(subjectsShape, subjects{i}));
    if isempty(shapeInd)
        continue;
    end

    tmp = mod(i-1,numColors);
    subjectColor = cmap(tmp+1,:);

    tmp2 = floor((i-1)/numColors);
    markerFormatSpec = {'linestyle', 'none', 'marker', markers{tmp2+1}, 'color', subjectColor};
    lineFormatSpec = {'linestyle', linestyles{tmp2+1}};
    if ismember(subjects{i}, hasMeThermom)
        markerFormatSpec = [markerFormatSpec, {'markerfacecolor', subjectColor}];
    end

    % plot the points
    plot(thermomMajAL{i}(aboveThreshInds{i}), thermomMinAL{i}(aboveThreshInds{i}), ...
        markerFormatSpec{:}, 'displayname', subjects{i});
end
axis equal;
grid on;
xlim([0,14]);
ylim([0,14]);
ylabel('MR thermometry minor axis length');
xlabel('MR thermometry major axis length');
title('MR thermometry');
xlims = xlim;
for i = 1:length(subjects)
    shapeInd = find(ismember(subjectsShape, subjects{i}));
    if isempty(shapeInd)
        continue;
    end
    %
    tmp = 1:numSonications(i);
    plottedSonications = tmp(targetIndsShape{i} & aboveThreshInds{i});
    for j = plottedSonications
        text(thermomMajAL{i}(j)+0.02*xlims(2), thermomMinAL{i}(j), num2str(j));
    end
end
line([0 14], [0 14], 'color', [1,1,1]*0.5);


% simulated axis lengths
markers = {'o', '^', 's'};
linestyles = {'-', '--', ':'}; 
subplot(1,2,2); hold on;
for i = 1:length(subjects)
    shapeInd = find(ismember(subjectsShape, subjects{i}));
    if isempty(shapeInd)
        continue;
    end

    tmp = mod(i-1,numColors);
    subjectColor = cmap(tmp+1,:);

    tmp2 = floor((i-1)/numColors);
    markerFormatSpec = {'linestyle', 'none', 'marker', markers{tmp2+1}, 'color', subjectColor};
    lineFormatSpec = {'linestyle', linestyles{tmp2+1}};
    if ismember(subjects{i}, hasMeThermom)
        markerFormatSpec = [markerFormatSpec, {'markerfacecolor', subjectColor}];
    end

    % plot the points
    plot(bioheatMajAL{i}(aboveThreshInds{i}), bioheatMinAL{i}(aboveThreshInds{i}), ...
        markerFormatSpec{:}, 'displayname', subjects{i});
end
axis equal;
grid on;
xlim([0,14]);
ylim([0,14]);
ylabel('Simulation minor axis length');
xlabel('Simulation major axis length');
title('Simulation');
xlims = xlim;
for i = 1:length(subjects)
    shapeInd = find(ismember(subjectsShape, subjects{i}));
    if isempty(shapeInd)
        continue;
    end
    %
    tmp = 1:numSonications(i);
    plottedSonications = tmp(targetIndsShape{i} & aboveThreshInds{i});
    for j = plottedSonications
        text(bioheatMajAL{i}(j)+0.02*xlims(2), bioheatMinAL{i}(j), num2str(j));
    end
end
line([0 14], [0 14], 'color', [1,1,1]*0.5);
