samePlotFlag = false;
meanFlag = false;

%%
tempError = cell(length(subjects), 1);
for i = 1:length(subjects)
    tempError{i} = bioheatTempsAll{i} - thermomTempsAll{i};
    tempPercentError{i} = tempError{i} ./ thermomTempsAll{i} * 100;
end

meanTempsAll = cell(size(subjects));
for i = 1:length(subjects)
    meanTempsAll{i} = mean([bioheatTempsAll{i}, thermomTempsAll{i}], 2);
end


%%
equalAxesFlag = false;
xlims = [0, maxFigTemp];
ylims = [-15, 15];
xLabelStr = 'MR thermometry temperature rise (\circC)';
yLabelStr = 'Temperature error (\circC)';
samePlotFlag = false;
plotMetrics(subjects, hasMeThermom, thermomTempsAll, tempError, targetIndsTemp, equalAxesFlag, xlims, ylims, xLabelStr, yLabelStr, numFigRows, numFigCols, samePlotFlag)
if samePlotFlag
    h = patch([0, maxFigTemp, maxFigTemp, 0], [2, 2, -2, -2], [1,1,1]*0.7, 'facealpha', 0.4, 'edgecolor', 'none');
    % line([5,5], ylims, 'color', [1,1,1]*0.4);
    h = patch([0, 5, 5, 0], [ylims(2), ylims(2), ylims(1), ylims(1)], [1,1,1]*0.7, 'facealpha', 0.4, 'edgecolor', 'none');
else
    for i = 1:length(subjects)
        subplot(numFigRows, numFigCols, i);
        h = patch([0, maxFigTemp, maxFigTemp, 0], [2, 2, -2, -2], [1,1,1]*0.7, 'facealpha', 0.4, 'edgecolor', 'none');
        % line([5,5], ylims, 'color', [1,1,1]*0.4);
        h = patch([0, 5, 5, 0], [ylims(2), ylims(2), ylims(1), ylims(1)], [1,1,1]*0.7, 'facealpha', 0.4, 'edgecolor', 'none');
        if labelWithAliasesFlag
            title(sprintf('Patient %s', subjectAliases{i}));
        else
            title(subjects{i}, 'interpreter', 'none');
        end
    end
end


% %%
% equalAxesFlag = false;
% xlims = [0, 35];
% ylims = [-100, 100];
% xLabelStr = 'MR thermometry temperature rise (\circC)';
% yLabelStr = 'Temperature percent error (%)';
% samePlotFlag = false;
% plotMetrics(subjects, hasMeThermom, thermomTempsAll, tempPercentError, targetIndsTemp, equalAxesFlag, xlims, ylims, xLabelStr, yLabelStr, numFigRows, numFigCols, samePlotFlag)
% if samePlotFlag
%     h = patch([0, 35, 35, 0], [2, 2, -2, -2], [1,1,1]*0.7, 'facealpha', 0.4, 'edgecolor', 'none');
% else
%     for i = 1:length(subjects)
%         subplot(numFigRows, numFigCols, i);
%         h = patch([0, 35, 35, 0], [2, 2, -2, -2], [1,1,1]*0.7, 'facealpha', 0.4, 'edgecolor', 'none');
%     end
% end


% %%
% equalAxesFlag = false;
% xlims = [0, 35];
% ylims = [-15, 15];
% xLabelStr = 'Mean temperature rise (\circC)';
% yLabelStr = 'Temperature error (\circC)';
% samePlotFlag = false;
% plotMetrics(subjects, hasMeThermom, meanTempsAll, tempError, targetIndsTemp, equalAxesFlag, xlims, ylims, xLabelStr, yLabelStr, numFigRows, numFigCols, samePlotFlag)
% for i = 1:length(subjects)
%     subplot(numFigRows, numFigCols, i);
%     h = patch([0, 35, 35, 0], [2, 2, -2, -2], [1,1,1]*0.7, 'facealpha', 0.4, 'edgecolor', 'none');
% end
