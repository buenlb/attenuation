labelWithAliasesFlag = true;
colorByEchoTypeFlag = true;


%% setup useful indexing arrays
positionExcludeInds = cell(size(subjects));
for i = 1:length(subjects)
    % find the rows that should be excluded from temp measurements
    positionExcludeInds{i} = false(numSonicationRows(i),1);
    sonicationNums = repelem(1:numSonications(i), length(targetTimepoints));
    tmp = ismember(sonicationNums, tempExclude{i,2});
    positionExcludeInds{i}(tmp) = true;
end


%% calculate position error
[feError, peError, distanceError] = deal(cell(size(subjects)));
for i = 1:length(subjects)
    feError{i} = zeros(numSonicationRows(i),1);
    peError{i} = zeros(numSonicationRows(i),1);
    distanceError{i} = zeros(numSonicationRows(i),1);
end

% calculate position error for every sonication
[thermomFocusX, thermomFocusY, bioheatFocusX, bioheatFocusY] = deal(cell(length(subjects), 1));
[xError, yError] = deal(cell(length(subjects), 1));
for i = 1:length(subjects)
    %
    thermomFocusX{i} = cat(1, thermom{i}{:,9});
    thermomFocusY{i} = cat(1, thermom{i}{:,10});
    bioheatFocusX{i} = cat(1, bioheat{i}{:,9});
    bioheatFocusY{i} = cat(1, bioheat{i}{:,10});
    xError{i} = thermomFocusX{i} - bioheatFocusX{i}*1e3;
    yError{i} = thermomFocusY{i} - bioheatFocusY{i}*1e3;

    for j = 1:size(thermomFocusX{i},1);
        if strcmp(peDir{i}{j}, 'COL')
            feError{i}(j) = xError{i}(j);
            peError{i}(j) = yError{i}(j);
        else
            feError{i}(j) = yError{i}(j);
            peError{i}(j) = xError{i}(j);
        end
        distanceError{i}(j) = sqrt(xError{i}(j)^2 + yError{i}(j)^2);
    end
end

% calculate statistics of position error
targetIndsPos = cell(size(subjects));
[roMeanError, roStdDev, roStdError] = deal(zeros(size(subjects)));
[peMeanError, peStdDev, peStdError] = deal(zeros(size(subjects)));
[feErrorAllSonications, peErrorAllSonications] = deal(cell(size(subjects)));
[feErrorFiltered, feErrorFilteredNoNan] = deal(cell(size(subjects)));
[peErrorFiltered, peErrorFilteredNoNan] = deal(cell(size(subjects)));
for i = 1:length(subjects)
    targetIndsPos{i} = ~excludeInds{i} & ~peInSiInds{i} & ~positionExcludeInds{i};

    %
    feErrorAllSonications{i} = feError{i}(isTimepoint3{i});
    peErrorAllSonications{i} = peError{i}(isTimepoint3{i});    

    feErrorFiltered{i} = feError{i}(targetIndsPos{i} & isTimepoint3{i});
    peErrorFiltered{i} = peError{i}(targetIndsPos{i} & isTimepoint3{i});
    
    % remove NaN values because they mess up the calculation of summary statistics
    feErrorFilteredNoNan{i} = feErrorFiltered{i};
    peErrorFilteredNoNan{i} = peErrorFiltered{i};
    feErrorFilteredNoNan{i}(isnan(feErrorFiltered{i})) = [];
    peErrorFilteredNoNan{i}(isnan(peErrorFiltered{i})) = [];

    % calculate statistics for absolute readout error
    roMeanError(i) = mean(abs(feErrorFilteredNoNan{i}));
    roStdDev(i) = std(abs(feErrorFilteredNoNan{i}));
    roStdError(i) = roStdDev(i)/sqrt(length(feErrorFilteredNoNan{i}));

    % calculate statistics for absolute phase encode error
    peMeanError(i) = mean(abs(peErrorFilteredNoNan{i}));
    peStdDev(i) = std(abs(peErrorFilteredNoNan{i}));
    peStdError(i) = peStdDev(i)/sqrt(length(peErrorFilteredNoNan{i}));
end
roMeanErrorTotal = mean(abs(cat(1,feErrorFilteredNoNan{:})));
peMeanErrorTotal = mean(abs(cat(1,peErrorFilteredNoNan{:})));
fprintf('freq encode mean error: %f\n', roMeanErrorTotal);
fprintf('phase encode mean error: %f\n', peMeanErrorTotal);
%
tmp = cellfun(@length, feErrorFilteredNoNan);
cumulativeSonications = [0; cumsum(tmp)];
roStdDevTotal = std(abs(cat(1,feErrorFilteredNoNan{:})));
peStdDevTotal = std(abs(cat(1,peErrorFilteredNoNan{:})));
roStdErrorTotal = roStdDevTotal / cumulativeSonications(end);
peStdErrorTotal = peStdDevTotal / cumulativeSonications(end);
fprintf('total # sonications: %d\n', cumulativeSonications(end));
fprintf('freq encode std error: %f\n', roStdErrorTotal);
fprintf('phase encode std error: %f\n', peStdErrorTotal);

%
feErrorAll = cell2mat(feErrorFilteredNoNan);
peErrorAll = cell2mat(peErrorFilteredNoNan);
tmp = cellfun(@length, feErrorFilteredNoNan);
cumulativeSonications = [0; cumsum(tmp)];
echoes = repmat('      ', length(feErrorAll), 1);
for i = 1:length(subjects)
    if hasMeThermom(i)
        echoType = 'multi ';
    else
        echoType = 'single';
    end
    startInd = cumulativeSonications(i)+1;
    endInd = cumulativeSonications(i+1);
    for n = startInd:endInd
        echoes(n,:) = echoType;
    end
end
pFE = anovan(feErrorAll, {echoes});
pPE = anovan(peErrorAll, {echoes});
fprintf('freq encode p value: %f\n', pFE);
fprintf('phase encode p value: %f\n', pPE);

% calculate statistics of distance error
[distanceMeanError, distanceStdDev, distanceStdError] = deal(zeros(size(subjects)));
numSonsPositionError = zeros(size(subjects));
[distanceErrorFiltered, distanceErrorFilteredNoNan] = deal(cell(size(subjects)));
for i = 1:length(subjects)
    distanceErrorFiltered{i} = distanceError{i}(targetIndsPos{i});

    % count number of analyzed sonications 
    numSonsPositionError(i) = numel(feErrorFilteredNoNan{i});
    
    % remove NaN values because they mess up the calculation of summary statistics
    distanceErrorFilteredNoNan{i} = distanceErrorFiltered{i};
    distanceErrorFilteredNoNan{i}(isnan(distanceErrorFiltered{i})) = [];

    % calculate statisitics for distance error
    distanceMeanError(i) = mean(abs(distanceErrorFilteredNoNan{i}));
    distanceStdDev(i) = std(abs(distanceErrorFilteredNoNan{i}));
    distanceStdError(i) = distanceStdDev(i)/sqrt(length(distanceErrorFilteredNoNan{i}));
end
distanceMeanErrorTotal = mean(abs(cat(1,distanceErrorFilteredNoNan{:})));


%% figures
if colorByEchoTypeFlag
    tmpCmap = lines(4);
    tmpCmap(2:3,:) = [];
    seMeFirstInds = [1,6];
    numSonsTextColor = [1,1,1];
    meanErrorLineColor = [1,1,1]*0.6;
else
    tmpCmap = repmat([1,1,1]*0.5, 2, 1);
    seMeFirstInds = [];
    numSonsTextColor = [1,1,1];
    meanErrorLineColor = [1,1,1]*0.4;
end

% roToleranceInds = roMeanError < 0.01;
% roMeanError(roToleranceInds) = 0;
% roStdError(roToleranceInds) = 0;

% readout direction
roFig = figure; hold on;
% remove tick marks from xticks in case the error is ever 0
hAxes = gca;
set(hAxes, 'xtick', [0, length(subjects)+1]);
xlim([0, length(subjects)+1]);
hAxes(2) = axes('position', get(hAxes, 'position')');   % overlay a 2nd axes 
xlim([0, length(subjects)+1]);
%
set(hAxes(1), 'xticklabel', []);                    % turn off labels on 1st axes
if labelWithAliasesFlag
    set(hAxes(2), 'xtick', 0:length(subjects)+1, 'xticklabel', [{''}; subjectAliases; {''}]);
else
    set(hAxes(2), 'xtick', 0:length(subjects)+1, 'xticklabel', [{''}; subjects; {''}], 'xticklabelrotation', 45, 'ticklabelinterpreter', 'none');
end
set(hAxes(2), 'ticklength', [0,0]);                 % set ticks to zero length on the 2nd axes
set(hAxes(2), 'ytick', []);                         % get rid of duplicate y axes
xlabel('Patient');    
axes(hAxes(1));                                     % place 1st axes back on top
ylabel('Position error (mm)');
% plot the error
for i = 1:length(roMeanError)
    barH = bar(i, roMeanError(i), 'facecolor', tmpCmap(1,:), 'displayname', 'Single echo');
    if hasMeThermom(i)
        set(barH, 'facecolor', tmpCmap(2,:), 'displayname', 'Multi echo');
    end
    if ~ismember(i, seMeFirstInds)
        set(get(get(barH,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
    end
end
errorbarH = errorbar(1:length(subjects), roMeanError, roStdError, 'k.');
set(get(get(barH,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
set(get(get(errorbarH,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
for i = 1:length(roMeanError)
    if roMeanError(i) <= 0.01
        text(i, 0.1, num2str(numSonsPositionError(i)), 'horizontalalignment', 'center');
    else
        text(i, 0.1, num2str(numSonsPositionError(i)), 'horizontalalignment', 'center', 'color', numSonsTextColor);
    end
end
%
% xlabel('Patient'); ylabel('Position error (mm)');
title('Frequency encode direction');
% if labelWithAliasesFlag
%     set(gca, 'xtick', 0:length(subjects)+1, 'xticklabel', [{''}; subjectAliases; {''}]);
% else
%     set(gca, 'xtick', 0:length(subjects)+1, 'xticklabel', [{''}; subjects; {''}], 'xticklabelrotation', 45, 'ticklabelinterpreter', 'none');
% end
% text(1:length(subjects), 0.1*ones(size(subjects)), ...
%     cellfun(@num2str, num2cell(numSonsPositionError), 'uniformoutput', false), ...
%     'horizontalalignment', 'center', 'color', numSonsTextColor);
xlim([0, length(subjects)+1]);
ylim([0, 3]);
grid on;
line([0 length(subjects)+1], [1,1]*1.1, 'linestyle', '--', ...
    'linewidth', 2, 'color', 'k', 'displayname', 'MR thermometry resolution');
line([0 length(subjects)+1], [1,1]*roMeanErrorTotal, 'linestyle', '-.', ...
    'linewidth', 2, 'color', meanErrorLineColor, 'displayname', 'Average across patients');
legend('show');

% phase encode direction
peFig = figure; hold on;
% remove tick marks from xticks in case the error is ever 0
hAxes = gca;
set(hAxes, 'xtick', [0, length(subjects)+1]);
xlim([0, length(subjects)+1]);
hAxes(2) = axes('position', get(hAxes, 'position')');   % overlay a 2nd axes 
xlim([0, length(subjects)+1]);
%
set(hAxes(1), 'xticklabel', []);                    % turn off labels on 1st axes
if labelWithAliasesFlag
    set(hAxes(2), 'xtick', 0:length(subjects)+1, 'xticklabel', [{''}; subjectAliases; {''}]);
else
    set(hAxes(2), 'xtick', 0:length(subjects)+1, 'xticklabel', [{''}; subjects; {''}], 'xticklabelrotation', 45, 'ticklabelinterpreter', 'none');
end
set(hAxes(2), 'ticklength', [0,0]);                 % set ticks to zero length on the 2nd axes
set(hAxes(2), 'ytick', []);                         % get rid of duplicate y axes
xlabel('Patient');    
axes(hAxes(1));                                     % place 1st axes back on top
ylabel('Position error (mm)');
% plot the error
for i = 1:length(peMeanError)
    barH = bar(i, peMeanError(i), 'facecolor', tmpCmap(1,:), 'displayname', 'Single echo');
    if hasMeThermom(i)
        set(barH, 'facecolor', tmpCmap(2,:), 'displayname', 'Multi echo');
    end
    if ~ismember(i, seMeFirstInds)
        set(get(get(barH,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
    end
end
errorbarH = errorbar(1:length(subjects), peMeanError, peStdError, 'k.');
set(get(get(barH,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
set(get(get(errorbarH,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
for i = 1:length(peMeanError)
    if peMeanError(i) <= 0.01
        text(i, 0.1, num2str(numSonsPositionError(i)), 'horizontalalignment', 'center');
    else
        text(i, 0.1, num2str(numSonsPositionError(i)), 'horizontalalignment', 'center', 'color', numSonsTextColor);
    end
end
%
% xlabel('Patient'); ylabel('Position error (mm)');
title('Phase encode direction');
% if labelWithAliasesFlag
%     set(gca, 'xtick', 0:length(subjects)+1, 'xticklabel', [{''}; subjectAliases; {''}]);
% else
%     set(gca, 'xtick', 0:length(subjects)+1, 'xticklabel', [{''}; subjects; {''}], 'xticklabelrotation', 45, 'ticklabelinterpreter', 'none');
% end
% text(1:length(subjects), 0.1*ones(size(subjects)), ...
%     cellfun(@num2str, num2cell(numSonsPositionError), 'uniformoutput', false), ...
%     'horizontalalignment', 'center', 'color', numSonsTextColor);
xlim([0, length(subjects)+1]);
ylim([0, 3]);
grid on;
line([0 length(subjects)+1], [1,1]*2.2, 'linestyle', '--', ...
    'linewidth', 2, 'color', 'k', 'displayname', 'MR thermometry resolution');
line([0 length(subjects)+1], [1,1]*peMeanErrorTotal, 'linestyle', '-.', ...
    'linewidth', 2, 'color', meanErrorLineColor, 'displayname', 'Average across patients');
legend('show');

% % distance
% distanceFig = figure; hold on;
% for i = 1:length(peMeanError)
%     barH = bar(i, distanceMeanError(i), 'facecolor', tmpCmap(1,:), 'displayname', 'SE');
%     if hasMeThermom(i)
%         set(barH, 'facecolor', tmpCmap(2,:), 'displayname', 'ME');
%     end
%     if ~ismember(i, [1,6])
%         set(get(get(barH,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
%     end
% end
% errorbarH = errorbar(1:length(subjects), distanceMeanError, distanceStdError, 'k.');
% set(get(get(barH,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
% set(get(get(errorbarH,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
% %
% xlabel('Patient'); ylabel('Position error (mm)');
% title('Distance');
% set(gca, 'xtick', 0:length(subjects)+1, 'xticklabel', [{''}; subjectAliases; {''}]);
% % set(gca, 'xtick', 0:length(subjects)+1, 'xticklabel', [{''}; subjects; {''}], 'xticklabelrotation', 45);
% text(1:length(subjects), 0.1*ones(size(subjects)), ...
%     cellfun(@num2str, num2cell(numSonsPositionError), 'uniformoutput', false), ...
%     'horizontalalignment', 'center', 'color', [1,1,1]);
% xlim([0, length(subjects)+1]);
% ylim([0, 3]);
% grid on;
% line([0 length(subjects)+1], [1,1]*distanceMeanErrorTotal, 'linestyle', '--', ...
%     'linewidth', 2, 'color', [1,1,1]*0.6, 'displayname', 'Average across patients');
% legend('show');

% %
% tmp = (0:1:5)';
% binEdges = [flipud(-tmp(2:end)); tmp];
% figure('name', 'feError');
% for i = 1:length(subjects)
%     subplot(3,4,i); hold on;
%     histogram(feErrorFiltered{i}, binEdges);
%     grid on;
%     xlim([-5 5]);
%     ylim([0 10]);
%     title(subjects{i});
% end
% figure('name', 'peError');
% for i = 1:length(subjects)
%     subplot(3,4,i); hold on;
%     histogram(peErrorFiltered{i}, binEdges);
%     grid on;
%     xlim([-5 5]);
%     ylim([0 10]);
%     title(subjects{i});
% end

% figure('name', 'abs(feError)');
% for i = 1:length(subjects)
%     subplot(3,4,i); hold on;
%     histogram(abs(feErrorFiltered{i}), tmp);
%     grid on;
%     xlim([0 5]);
%     ylim([0 10]);
%     title(subjects{i});
% end
% figure('name', 'abs(peError)');
% for i = 1:length(subjects)
%     subplot(3,4,i); hold on;
%     histogram(abs(peErrorFiltered{i}), tmp);
%     grid on;
%     xlim([0 5]);
%     ylim([0 10]);
%     title(subjects{i});
% end
% figure('name', 'distanceError');
% for i = 1:length(subjects)
%     subplot(3,4,i); hold on;
%     histogram(distanceErrorFiltered{i}, tmp);
%     grid on;
%     xlim([0 5]);
%     ylim([0 10]);
%     title(subjects{i});
% end
