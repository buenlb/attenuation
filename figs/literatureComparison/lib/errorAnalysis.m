samePlotFlag = false;

%%
tempError = cell(length(subjects), 1);
for i = 1:length(subjects)
    tempError{i} = bioheatTempsAll{i} - thermomTempsAll{i};
end


%%
T = readtable('additionalPatientParameters.csv');
patientParameters = table2cell(T);
[ages, sdrs, genders, sides] = deal(cell(size(subjects)));
for i = 1:length(subjects)
    ages{i} = ones(size(tempError{i})) * patientParameters{i,2};
    sdrs{i} = ones(size(tempError{i})) * patientParameters{i,5};
    gender = patientParameters{i,3};
    if strcmp(gender, 'M')
        genders{i} = ones(size(tempError{i}));
    else
        genders{i} = ones(size(tempError{i})) * 2;
    end
    % genders{i} = repmat(patientParameters{i,3}, size(tempError{i}));
    side = patientParameters{i,4};
    if strcmp(side, 'L')
        sides{i} = ones(size(tempError{i}));
    else
        sides{i} = ones(size(tempError{i})) * 2;
    end
    huMeans{i} = ones(size(tempError{i})) * patientParameters{i,7};
    huStds{i} = ones(size(tempError{i})) * patientParameters{i,8};
    huModes{i} = ones(size(tempError{i})) * patientParameters{i,9};
    numVoxels{i} = ones(size(tempError{i})) * patientParameters{i,11};
end


%% phase encode vs freq encode offset
equalAxesFlag = true;
xlims = [-4, 4];
ylims = [-4, 4];
xLabelStr = 'Frequency encode offset (mm)';
yLabelStr = 'Phase encode offset (mm)';
% samePlotFlag = true;
plotMetrics(subjects, hasMeThermom, feError, peError, targetIndsTemp, equalAxesFlag, xlims, ylims, xLabelStr, yLabelStr, numFigRows, numFigCols, samePlotFlag)


%% P dimension vs L dimension error
equalAxesFlag = true;
xlims = [-4, 4];
ylims = [-4, 4];
xLabelStr = 'L dimension offset (mm)';
yLabelStr = 'P dimension offset (mm)';
% samePlotFlag = true;
targetInds = cell(length(subjects),1);
for i = 1:length(subjects)
    targetInds{i} = isAxial{i} & targetIndsTemp{i};
end
plotMetrics(subjects, hasMeThermom, xError, yError, targetInds, equalAxesFlag, xlims, ylims, xLabelStr, yLabelStr, numFigRows, numFigCols, samePlotFlag)


%% temp error vs freq encode offset
equalAxesFlag = false;
xlims = [-4, 4];
ylims = [-15, 15];
xLabelStr = 'Frequency encode offset (mm)';
yLabelStr = 'Temperature error (\circC)';
% samePlotFlag = true;
plotMetrics(subjects, hasMeThermom, feError, tempError, targetIndsTemp, equalAxesFlag, xlims, ylims, xLabelStr, yLabelStr, numFigRows, numFigCols, samePlotFlag)


%% temp error vs phase encode offset
equalAxesFlag = false;
xlims = [-4, 4];
ylims = [-15, 15];
xLabelStr = 'Phase encode offset (mm)';
yLabelStr = 'Temperature error (\circC)';
% samePlotFlag = true;
plotMetrics(subjects, hasMeThermom, peError, tempError, targetIndsTemp, equalAxesFlag, xlims, ylims, xLabelStr, yLabelStr, numFigRows, numFigCols, samePlotFlag)

%%-----------------------

%%
equalAxesFlag = false;
xlims = [60, 100];
ylims = [-15, 15];
xLabelStr = 'Age (year)';
yLabelStr = 'Temperature error (\circC)';
samePlotFlag = true;
plotMetrics(subjects, hasMeThermom, ages, tempError, targetIndsTemp, equalAxesFlag, xlims, ylims, xLabelStr, yLabelStr, numFigRows, numFigCols, samePlotFlag)

%%
equalAxesFlag = false;
xlims = [0, 1];
ylims = [-15, 15];
xLabelStr = 'SDR';
yLabelStr = 'Temperature error (\circC)';
samePlotFlag = true;
plotMetrics(subjects, hasMeThermom, sdrs, tempError, targetIndsTemp, equalAxesFlag, xlims, ylims, xLabelStr, yLabelStr, numFigRows, numFigCols, samePlotFlag)

%%
equalAxesFlag = false;
xlims = [0, 3];
ylims = [-15, 15];
xLabelStr = 'VIM side';
yLabelStr = 'Temperature error (\circC)';
samePlotFlag = true;
plotMetrics(subjects, hasMeThermom, sides, tempError, targetIndsTemp, equalAxesFlag, xlims, ylims, xLabelStr, yLabelStr, numFigRows, numFigCols, samePlotFlag)
set(gca, 'xtick', [1,2], 'xticklabel', {'L', 'R'});

%%
equalAxesFlag = false;
xlims = [0, 3];
ylims = [-15, 15];
xLabelStr = 'Gender';
yLabelStr = 'Temperature error (\circC)';
samePlotFlag = true;
plotMetrics(subjects, hasMeThermom, genders, tempError, targetIndsTemp, equalAxesFlag, xlims, ylims, xLabelStr, yLabelStr, numFigRows, numFigCols, samePlotFlag)
set(gca, 'xtick', [1,2], 'xticklabel', {'M', 'F'});

%%
equalAxesFlag = false;
xlims = [1000, 1500];
ylims = [-15, 15];
xLabelStr = 'HU mean';
yLabelStr = 'Temperature error (\circC)';
samePlotFlag = true;
plotMetrics(subjects, hasMeThermom, huMeans, tempError, targetIndsTemp, equalAxesFlag, xlims, ylims, xLabelStr, yLabelStr, numFigRows, numFigCols, samePlotFlag)

%%
equalAxesFlag = false;
xlims = [200, 500];
ylims = [-15, 15];
xLabelStr = 'HU standard deviation';
yLabelStr = 'Temperature error (\circC)';
samePlotFlag = true;
plotMetrics(subjects, hasMeThermom, huStds, tempError, targetIndsTemp, equalAxesFlag, xlims, ylims, xLabelStr, yLabelStr, numFigRows, numFigCols, samePlotFlag)

%%
equalAxesFlag = false;
xlims = [0, 2000];
ylims = [-15, 15];
xLabelStr = 'HU mode';
yLabelStr = 'Temperature error (\circC)';
samePlotFlag = true;
plotMetrics(subjects, hasMeThermom, huModes, tempError, targetIndsTemp, equalAxesFlag, xlims, ylims, xLabelStr, yLabelStr, numFigRows, numFigCols, samePlotFlag)

%%
equalAxesFlag = false;
xlims = [200000, 500000];
ylims = [-15, 15];
xLabelStr = 'Number of skull voxels';
yLabelStr = 'Temperature error (\circC)';
samePlotFlag = true;
plotMetrics(subjects, hasMeThermom, numVoxels, tempError, targetIndsTemp, equalAxesFlag, xlims, ylims, xLabelStr, yLabelStr, numFigRows, numFigCols, samePlotFlag)

%%
equalAxesFlag = false;
xlims = [3e5, 8e5];
ylims = [-15, 15];
xLabelStr = 'Histogram-based total attenuation';
yLabelStr = 'Temperature error (\circC)';
samePlotFlag = true;
plotMetrics(subjects, hasMeThermom, hta, tempError, targetIndsTemp, equalAxesFlag, xlims, ylims, xLabelStr, yLabelStr, numFigRows, numFigCols, samePlotFlag)

%%
equalAxesFlag = false;
xlims = [0, 2];
ylims = [-15, 15];
xLabelStr = 'Histogram-based total attenuation';
yLabelStr = 'Temperature error (\circC)';
samePlotFlag = true;
plotMetrics(subjects, hasMeThermom, hta2, tempError, targetIndsTemp, equalAxesFlag, xlims, ylims, xLabelStr, yLabelStr, numFigRows, numFigCols, samePlotFlag)




%%
agesCell = cat(1, patientParameters(:,2));
slopesCell = mat2cell(slopes-1, ones(size(subjects)), 1);
targetIndsCell = mat2cell(true(size(subjects)), ones(size(subjects)), 1);
equalAxesFlag = false;
xlims = [60, 100];
ylims = [-1, 1];
xLabelStr = 'Age (year)';
yLabelStr = 'Slope error';
samePlotFlag = true;
plotMetrics(subjects, hasMeThermom, agesCell, slopesCell, targetIndsCell, equalAxesFlag, xlims, ylims, xLabelStr, yLabelStr, numFigRows, numFigCols, samePlotFlag)


%%
sdrsCell = cat(1, patientParameters(:,5));
slopesCell = mat2cell(slopes-1, ones(size(subjects)), 1);
targetIndsCell = mat2cell(true(size(subjects)), ones(size(subjects)), 1);
equalAxesFlag = false;
xlims = [0, 1];
ylims = [-1, 1];
xLabelStr = 'SDR';
yLabelStr = 'Slope error';
samePlotFlag = true;
plotMetrics(subjects, hasMeThermom, sdrsCell, slopesCell, targetIndsCell, equalAxesFlag, xlims, ylims, xLabelStr, yLabelStr, numFigRows, numFigCols, samePlotFlag)
