% create a figure showing how attenuation can drastically affect simulated
% temperature
% simulations were performed with a constant attenuation curve to make it
% simpler to interpret

targetSubjects = {'43203'; '43211'; '43213'; '43214'; '43215'; ...
                  '43262'; '43263'; '43265'; '43267'};

% thermometry timepoint to use
targetTimepoints = [1; 2; 3];

%
metricsFiguresSetup;
whichSonicationsFigure;


% data filepaths
dataPath = 'data/constantAttenuation';
thermomFilepath = fullfile(dataPath, 'thermomMetrics_1534113905_924c0ab.csv');
bioheatNp1Filepath = fullfile(dataPath, 'bioheatMetrics_002_tt_111_MR_1535673849_931d22a_leung2018constantAtten1.csv');
bioheatNp2Filepath = fullfile(dataPath, 'bioheatMetrics_002_tt_111_MR_1535673849_931d22a_leung2018constantAtten2.csv');


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


%% load data
[thermom, thermomHeaders] = loadMetricsData(thermomFilepath, 'thermom', subjects, thirdTimepointFrame, numSonications, targetTimepoints);
[bioheatNp1, bioheatNp1Headers] = loadMetricsData(bioheatNp1Filepath, 'bioheat', subjects, thirdTimepointFrame, numSonications, targetTimepoints);
[bioheatNp2, bioheatNp2Headers] = loadMetricsData(bioheatNp2Filepath, 'bioheat', subjects, thirdTimepointFrame, numSonications, targetTimepoints);


% flag to determine whether to only use axial images
axialOnlyFlag = false;

%
tempExclude = cell(size(subjects));
tempExclude{1} = [];
tempExclude{2} = [];
tempExclude{3} = [];
tempExclude{4} = [];
tempExclude{5} = [];
tempExclude{6} = [];
tempExclude{7} = [];
tempExclude{8} = [];
tempExclude{9} = [3,5,6,16,8,19];
tempExclude{10} = [2,5,6,7,8];    % low SNR/swaths of noise


%% setup useful indexing arrays
tempExcludeInds = cell(size(subjects));
for i = 1:length(subjects)
    % find the rows that should be excluded from temp measurements
    tempExcludeInds{i} = false(numSonications(i),1);
    tempExcludeInds{i}(tempExclude{i}) = true;
end


%% perform individual fits per attenuation curve
numConstantAttenCurves = {'bioheatNp1', 'bioheatNp2'};
targetSubject = '43214';
subjectInd = find(ismember(subjects, targetSubject));

[targetIndsTemp, bioheatTemps, thermomTemps, mdlIndiv] = deal(cell(size(numConstantAttenCurves)));
[rSquared, rSquaredAdj, standardErrorsOfRegression, pValues, slopes, intercepts, smape] = deal(zeros(size(numConstantAttenCurves)));
for i = 1:length(numConstantAttenCurves)
    if axialOnlyFlag
        targetIndsTemp{i} = ~excludeInds{subjectInd} & axialScanPlaneInds{subjectInd} & ~tempExcludeInds{subjectInd};
    else
        % targetIndsTemp{i} = ~excludeInds{subjectInd} & ~peInSiInds{subjectInd} & ~tempExcludeInds{subjectInd};
        targetIndsTemp{i} = ~excludeInds{subjectInd} & ~peInSiInds{subjectInd};
    end
    bioheatTemps{i} = eval(['cell2mat(' numConstantAttenCurves{i} '{subjectInd}(targetIndsTemp{i},6))']);
    thermomTemps{i} = cell2mat(thermom{subjectInd}(targetIndsTemp{i},6));

    % % fit a linear model to the data
    % isnanInds = isnan(thermomTemps{i});
    % mdlIndiv{i} = fitlm(bioheatTemps{i}(~isnanInds), thermomTemps{i}(~isnanInds));
    
    % % grab the model parameters
    % rSquared(i) = mdlIndiv{i}.Rsquared.Ordinary;
    % rSquaredAdj(i) = mdlIndiv{i}.Rsquared.Adjusted;
    % pValues(i) = mdlIndiv{i}.anova.pValue(1);
    % slopes(i) = mdlIndiv{i}.Coefficients.Estimate(2);
    % intercepts(i) = mdlIndiv{i}.Coefficients.Estimate(1);

    % predTemps = predict(mdlIndiv{i}, bioheatTemps{i}(~isnanInds));
    % % symmetric mean absolute percentage error
    % smape(i) = mean(abs(predTemps-thermomTemps{i}(~isnanInds))./(abs(predTemps)+abs(thermomTemps{i}(~isnanInds)))) * 100;

    % % calculate the standard error of regression
    % standardErrorsOfRegression(i) = mdlIndiv{i}.RMSE;

    isnanInds{i} = isnan(thermomTemps{i});

    % robust regression
    [b{i}, stats{i}] = robustfit(bioheatTemps{i}(~isnanInds{i}), thermomTemps{i}(~isnanInds{i}));
    modelfun = @(b,x)(b(1)+b(2)*x);
    x = (0:maxFigTemp)';
    [y{i}, delta{i}] = nlpredci(modelfun, x, b{i}, stats{i}.resid, 'covar', stats{i}.covb, ...
        'MSE', stats{i}.s^2, 'SimOpt', 'on');
    lowerBound{i} = y{i} - delta{i};
    upperBound{i} = y{i} + delta{i};
end


%% create figures
% create temperature figure
figure; hold on;
linestyles = {'-', '--', ':'};
for i = 1:length(numConstantAttenCurves)
    tmp = mod(i-1,numColors);
    subjectColor = cmap(tmp+1,:);

    tmp2 = floor((i-1)/numColors);
    markerFormatSpec = {'linestyle', 'none', 'marker', 'o', 'color', subjectColor};
    lineFormatSpec = {'linestyle', linestyles{tmp2+1}};

    plot(bioheatTemps{i}, thermomTemps{i}, markerFormatSpec{:});
    
    % plot the fit line
    % x = (0:35)';
    % y = predict(mdlIndiv{i}, x);
    % h = plot(x, y, 'color', subjectColor, lineFormatSpec{:}, 'linewidth', 1.5);
    % set(get(get(h,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
    h1 = plot(x, y{i}, 'k', 'linewidth', 1.25, 'color', subjectColor, lineFormatSpec{:});
    excludeFromLegend(h1);
    h4 = patch([x; flipud(x)], [upperBound{i}; flipud(lowerBound{i})], [1,1,1]*0.7, 'facealpha', 0.4, 'edgecolor', 'none');
    excludeFromLegend(h4);
end
% wrap up
grid on;
axis equal;
xlim([0 35]);
ylim([0 35]);
% text(26, 8, sprintf('r^2 = %0.3f', rSquaredAdj(1)));
% text(26, 6, sprintf('S = %0.3f', standardErrorsOfRegression(1)));
% text(26, 4, sprintf('p = %0.3f', pValues(1)));
% text(4, 28, sprintf('r^2 = %0.3f', rSquaredAdj(2)));
% text(4, 26, sprintf('S = %0.3f', standardErrorsOfRegression(2)));
% text(4, 24, sprintf('p = %0.3f', pValues(2)));
ylabel('MR thermometry temperature rise (\circC)');
xlabel('Simulation temperature rise (\circC)');
line([0 35], [0 35], 'color', [1,1,1]*0.4);


% create attenuation figure
huBins = 200:5:2000;
figure; hold on;
plot(huBins, ones(size(huBins)), 'linewidth', 1.5);
plot(huBins, ones(size(huBins))*2, 'linewidth', 1.5);
xlim([0, 2000]);
ylim([0, 4]);
ylabel('Attenuation (Np/cm)');
xlabel('HU');
grid on;
