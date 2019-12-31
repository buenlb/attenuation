subjects = {'43265'};
thirdTimepointFrame = 5;
numSonications = 16;
targetTimepoint = 3;


desktopPath = 'C:\Users\Steve\Steve\Stanford\Labs\KBP lab\Projects\Beam simulation\Aim 1 - validation\Paper 1';
[~,~,thermomRaw] = xlsread(fullfile(desktopPath, 'thermomMetrics_1509486402_91e8614.xlsx'));

%% setup for data parsing
thermomHeaders = thermomRaw(1,:);
thermomData = thermomRaw(2:end,:);

% create a row for each patient sonication
[thermom] = deal(cell(size(subjects)));
for i = 1:length(subjects)
    thermomFillerCells = cell(numSonications(i), size(thermomData,2));
    thermomFillerCells(:,1) = {str2double(subjects{i})};
    thermomFillerCells(:,2) = mat2cell((1:numSonications(i))', ones(1,numSonications(i)));
    thermomFillerCells(:,3:end) = {NaN};
    thermom{i} = thermomFillerCells;
end


%% parse thermom data
subjectNames = cellfun(@num2str, thermomData(:,1), 'uniformoutput', false);
frameNum = cat(1, thermomData{:,4});

for i = 1:length(subjects)
    % grab the rows for a particular subject
    subject = subjects{i};
    subjectInds = ismember(subjectNames, subject);
    % grab the rows for timepoint 3
    timepoint = frameNum-thirdTimepointFrame(i)+3;
    timepointInds = timepoint == targetTimepoint;
    % trim the data to only timepoint 3
    subjectThermomData = thermomData(subjectInds & timepointInds,:);
    %
    for j = 1:size(subjectThermomData,1)
        sonicationNum = subjectThermomData{j,2};
        thermom{i}(sonicationNum,:) = subjectThermomData(j,:);
    end
end


commitPath = 'M:\SCRATCH\1510259676_37d4fc1';
listing = dir(commitPath);
inds = [4,7,8,9]+2; %3:length(listing)
[bioheat43265, atten] = deal(cell(length(inds)-2,1));
for num = 1:length(inds)
    [~,~,bioheatRaw] = xlsread(fullfile(commitPath, listing(inds(num)).name, '002_tt_111\bioheatMetrics_002_tt_111_MR_37d4fc1.xlsx'));

    bioheatHeaders = bioheatRaw(1,:);
    bioheatData = bioheatRaw(2:end,:);

    % create a row for each patient sonication
    [bioheat] = deal(cell(size(subjects)));
    for i = 1:length(subjects)
        bioheatFillerCells = cell(numSonications(i), size(bioheatData,2));
        bioheatFillerCells(:,1) = {str2double(subjects{i})};
        bioheatFillerCells(:,2) = mat2cell((1:numSonications(i))', ones(1,numSonications(i)));
        bioheatFillerCells(:,3:end) = {NaN};
        bioheat{i} = bioheatFillerCells;
    end

    %% parse bioheat data
    subjectNames = cellfun(@num2str, bioheatData(:,1), 'uniformoutput', false);

    % grab the rows for timepoint 3
    frameNum = cat(1, bioheatData{:,4});
    timepoint = frameNum-2;
    timepointInds = timepoint == targetTimepoint;

    for i = 1:length(subjects)
        % grab the rows for a particular subject
        subject = subjects{i};
        subjectInds = ismember(subjectNames, subject);
        % trim the data to only timepoint 3
        subjectBioheatData = bioheatData(subjectInds & timepointInds,:);
        % 
        for j = 1:size(subjectBioheatData,1)
            sonicationNum = subjectBioheatData{j,2};
            bioheat{i}(sonicationNum,:) = subjectBioheatData(j,:);
        end
    end

    bioheat43265{num} = bioheat{1};

    %%
    m = load(fullfile(commitPath, listing(inds(num)).name, 'simSetup\43265\43265 tissueProperties Vyas2016.mat'));
    atten{num} = m.props.attenuation;
end



cmap = lines(5);
numColors = 5;
[rSquared, rSquaredAdj, standardErrorsOfRegression, pValues, slopes, intercepts] = deal(zeros(length(bioheat43265),1));
figure; hold on;
for i = 1:length(bioheat43265)
    tmp = mod(i,numColors);
    if tmp == 0
        tmp = numColors;
    end
    subjectColor = cmap(tmp,:);

    if i <= numColors
        markerFormatSpec = {'linestyle', 'none', 'marker', 'o', 'color', subjectColor};
        lineFormatSpec = {'linestyle', '-'};
    else
        markerFormatSpec = {'linestyle', 'none', 'marker', 'o', 'color', subjectColor, 'markerfacecolor', subjectColor};
        lineFormatSpec = {'linestyle', '--'};
    end
    
    bioheatTemps = cell2mat(bioheat43265{i}(:,6));
    thermomTemps = cell2mat(thermom{1}(:,6));
    plot(bioheatTemps, thermomTemps, markerFormatSpec{:}, 'displayname', listing(inds(i)).name);
    mdl{i} = fitlm(bioheatTemps, thermomTemps);
    x = (0:35)';
    y = predict(mdl{i}, x);
    h = plot(x, y, 'color', subjectColor, lineFormatSpec{:});
    set(get(get(h,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
    %
    rSquared(i) = mdl{i}.Rsquared.Ordinary;
    rSquaredAdj(i) = mdl{i}.Rsquared.Adjusted;
    pValues(i) = mdl{i}.anova.pValue(1);
    slopes(i) = mdl{i}.Coefficients.Estimate(2);
    intercepts(i) = mdl{i}.Coefficients.Estimate(1);

    % calculate the standard error of regression
    standardErrorsOfRegression(i) = mdl{i}.RMSE;
end
grid on;
axis equal;
xlim([0 35]);
ylim([0 35]);
legend('show', 'location', 'southeast');
% text(2, 32, sprintf('r^2 = %0.3f', rSquaredAdj(i)));
% text(2, 28, sprintf('S = %0.3f', standardErrorsOfRegression(i)));
% text(2, 24, sprintf('p = %0.3f', pValues(i)));
% title(subjects{i});
ylabel('Clinical temperature rise (\circC)');
xlabel('Simulated temperature rise (\circC)');
line([0 35], [0 35], 'color', [1,1,1]*0.4);
