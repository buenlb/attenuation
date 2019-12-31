% Script to compare the sonication powers reported by the ACT and
% the SkullHeating files

%% load the data
[~,~,treatmentSummRaw] = xlsread('treatment_summary_sonication_powers.csv');
[~,~,skullHeatingRaw] = xlsread('skullheating_sonication_powers.csv');
[~,~,actRaw] = xlsread('act_sonication_powers.csv');

subjectNames = cellfun(@num2str, treatmentSummRaw(1,2:end), 'uniformoutput', false);

% 1st dimension is sonications, 2nd dimension is subjects
treatmentSumm = cell2mat(treatmentSummRaw(2:end, 2:end));
skullHeating = cell2mat(skullHeatingRaw(2:end, 2:end));
act = cell2mat(actRaw(2:end, 2:end));


%% figure setup
cmap = lines(5);
uniqueColors = unique(cmap, 'rows');
numColors = size(uniqueColors,1);
markers = {'o', '^', 's'};
linestyles = {'-', '--', ':'};

% organization of figure displays
% a = length(subjects)
% [a, sqrt(a), ceil(sqrt(a)), ceil(a./ceil(sqrt(a)))]
numSubjects = length(subjectNames);
numFigCols = ceil(sqrt(numSubjects));
numFigRows = ceil(numSubjects./numFigCols);


%% subjects displayed in individual axes
% SkullHeating vs treatment summary
figure;
for i = 1:size(treatmentSumm,2)
    subplot(numFigRows, numFigCols, i);

    tmp = mod(i-1,numColors);
    subjectColor = cmap(tmp+1,:);

    tmp2 = floor((i-1)/numColors);
    markerFormatSpec = {'linestyle', 'none', 'marker', markers{tmp2+1}, 'color', subjectColor};
    lineFormatSpec = {'linestyle', linestyles{tmp2+1}};

    plot(treatmentSumm(:,i), skullHeating(:,i), markerFormatSpec{:});
    grid on;
    axis equal;
    xlim([0, 2000]);
    set(gca, 'xtick', 0:500:2000);
    ylim([0, 2000]);
    line([0, 2000], [0, 2000], 'color', [1,1,1]*0.4);
    title(subjectNames{i}, 'interpreter', 'none');
    xlabel('Treatment summary power');
    ylabel('Skullheating file power');
end

% ACT vs treatment summary
figure;
for i = 1:size(treatmentSumm,2)
    subplot(numFigRows, numFigCols, i);

    tmp = mod(i-1,numColors);
    subjectColor = cmap(tmp+1,:);

    tmp2 = floor((i-1)/numColors);
    markerFormatSpec = {'linestyle', 'none', 'marker', markers{tmp2+1}, 'color', subjectColor};
    lineFormatSpec = {'linestyle', linestyles{tmp2+1}};

    plot(treatmentSumm(:,i), act(:,i), markerFormatSpec{:});
    grid on;
    axis equal;
    xlim([0, 2000]);
    set(gca, 'xtick', 0:500:2000);
    ylim([0, 2000]);
    line([0, 2000], [0, 2000], 'color', [1,1,1]*0.4);
    title(subjectNames{i}, 'interpreter', 'none');
    xlabel('Treatment summary power');
    ylabel('ACT file power');
end
