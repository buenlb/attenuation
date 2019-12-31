maxFigTemp = 30;

%
labelSonicationsFlag = false;
labelWithAliasesFlag = true;
subjectSpecificColorsFlag = false;
individualPatientPlotsFlag = false;
residualFigFlag = false;

% individual patient figures
labelByEchoTypeFlag = false;
labelByTreatmentLocationFlag = true;

%
pValueThresholds = 1*10.^(-10:-1);

mrTypeCmap = lines(4);
mrTypeCmap(2:3,:) = [];

sdrs = [0.67; 0.54; 0.45; 0.47; 0.65; 0.5; 0.61; 0.63; 0.57];
% sdrs = zeros(size(subjects));
% for i = 1:length(subjects)
%     sdrs(i) = treatmentInfo{i}{1,35};
% end


%% setup useful indexing arrays
tempExcludeInds = cell(size(subjects));
for i = 1:length(subjects)
    % find the rows that should be excluded from temp measurements
    tempExcludeInds{i} = false(numSonicationRows(i),1);
    sonicationNums = repelem(1:numSonications(i), length(targetTimepoints));
    tmp = ismember(sonicationNums, tempExclude{i,2});
    tempExcludeInds{i}(tmp) = true;
end


%% perform individual fits per patient
[bioheatTempsAll, thermomTempsAll] = deal(cell(size(subjects)));
[targetIndsTemp, bioheatTemps, thermomTemps] = deal(cell(size(subjects)));
[isnanInds, mdlIndiv] = deal(cell(size(subjects)));
[rSquared, rSquaredAdj, standardErrorsOfRegression, pValues, slopes, intercepts, smape] = deal(zeros(size(subjects)));
[b, stats, y, delta, upperBound, lowerBound] = deal(cell(size(subjects)));
for i = 1:length(subjects)
    bioheatTempsAll{i} = cell2mat(bioheat{i}(:,6));
    thermomTempsAll{i} = cell2mat(thermom{i}(:,6));

    targetIndsTemp{i} = ~excludeInds{i} & ~peInSiInds{i} & ~tempExcludeInds{i};
    bioheatTemps{i} = cell2mat(bioheat{i}(targetIndsTemp{i},6));
    thermomTemps{i} = cell2mat(thermom{i}(targetIndsTemp{i},6));

    % fit a linear model to the data
    isnanInds{i} = isnan(thermomTemps{i});
    mdlIndiv{i} = fitlm(bioheatTemps{i}(~isnanInds{i}), thermomTemps{i}(~isnanInds{i}), 'robustopts', 'on');
    % mdlIndiv{i} = fitlm(bioheatTemps{i}(~isnanInds{i}), thermomTemps{i}(~isnanInds{i}));
    % mdlIndiv{i} = fitlm(bioheatTemps{i}(~isnanInds{i}), thermomTemps{i}(~isnanInds{i}), 'intercept', false);

    % grab the model parameters
    rSquared(i) = mdlIndiv{i}.Rsquared.Ordinary;
    rSquaredAdj(i) = mdlIndiv{i}.Rsquared.Adjusted;
    pValues(i) = mdlIndiv{i}.anova.pValue(1);
    slopes(i) = mdlIndiv{i}.Coefficients.Estimate(2);

    predTemps = predict(mdlIndiv{i}, bioheatTemps{i}(~isnanInds{i}));
    % symmetric mean absolute percentage error
    smape(i) = mean(abs(predTemps-thermomTemps{i}(~isnanInds{i}))./(abs(predTemps)+abs(thermomTemps{i}(~isnanInds{i})))) * 100;

    % calculate the standard error of regression
    standardErrorsOfRegression(i) = mdlIndiv{i}.RMSE;
    % these formulas are all equivalent
    % sqrt(sum((thermomTemps{i}-predTemps).^2)/(numel(thermomTemps{i})-2));
    % sqrt(1-rSquaredAdj(i))*std(thermomTemps{i})
    % sqrt((1-rSquared(i)) * sum((thermomTemps{i}-mean(thermomTemps{i})).^2) / (numel(thermomTemps{i})-2))
    % sqrt(1-rSquared(i)) * std(thermomTemps{i}) * sqrt((numel(thermomTemps{i})-1)/(numel(thermomTemps{i})-2))
    % mdlIndiv{i}.RMSE

    % robust regression
    [b{i}, stats{i}] = robustfit(bioheatTemps{i}(~isnanInds{i}), thermomTemps{i}(~isnanInds{i}));
    modelfun = @(b,x)(b(1)+b(2)*x);
    x = (0:maxFigTemp)';
    [y{i}, delta{i}] = nlpredci(modelfun, x, b{i}, stats{i}.resid, 'covar', stats{i}.covb, ...
        'MSE', stats{i}.s^2, 'SimOpt', 'on');
    lowerBound{i} = y{i} - delta{i};
    upperBound{i} = y{i} + delta{i};
end

[rSquaredRobustFit1, rSquaredRobustFit2] = deal(zeros(size(subjects)));
for i = 1:length(subjects)
    rSquaredRobustFit1(i) = corr(thermomTemps{i}(~isnanInds{i}), b{i}(1)+b{i}(2)*bioheatTemps{i}(~isnanInds{i}))^2;
    sse = stats{i}.dfe * stats{i}.robust_s^2;
    p_hat = b{i}(1) + b{i}(2)*x;
    ssr = norm(p_hat-mean(p_hat))^2;
    rSquaredRobustFit2(i) = 1 - sse / (sse + ssr);
end

[rmse, pValuesIntercept, pValuesSlope] = deal(zeros(size(subjects)));
for i = 1:length(subjects)
    rmse(i) = stats{i}.s;
    pValuesIntercept(i) = stats{i}.p(1);
    pValuesSlope(i) = stats{i}.p(2);
end


% y-intercept figure
for i = 1:length(subjects)
    yIntercepts(i) = y{i}(1);
    yInterceptsDeltas(i) = delta{i}(1);
end
figure; hold on;
errorbar(1:length(subjects), yIntercepts, yInterceptsDeltas, 'o', 'color', 'k');
for i = 1:length(subjects)
    if hasMeThermom(i)
        subjectColor = mrTypeCmap(2,:);
    else
        subjectColor = mrTypeCmap(1,:);
    end
    plot(i, yIntercepts(i), 'o', 'color', subjectColor, 'linewidth', 1.25);
end
line([0, length(subjects)+1], [0,0], 'color', [1,1,1]*0.4);
grid on;
if labelWithAliasesFlag
    set(gca, 'xtick', 0:length(subjects)+1, 'xticklabel', [{''}; subjectAliases; {''}]);
else
    set(gca, 'xtick', 0:length(subjects)+1, 'xticklabel', [{''}; subjects; {''}], 'xticklabelrotation', 45, 'ticklabelinterpreter', 'none');
end
xlabel('Patient');
ylabel('Temperature rise y-intercept (\circC)');
ylim([-5, 5]);


% %
% for i = 1:length(subjects)
%     lala(i) = b{i}(2);
% end
% figure; hold on
% plot(1:length(subjects), lala, 'o');
% line([0, length(subjects)+1], [1,1], 'color', [1,1,1]*0.4);
% grid on;
% if labelWithAliasesFlag
%     set(gca, 'xtick', 0:length(subjects)+1, 'xticklabel', [{''}; subjectAliases; {''}]);
% else
%     set(gca, 'xtick', 0:length(subjects)+1, 'xticklabel', [{''}; subjects; {''}], 'xticklabelrotation', 45, 'ticklabelinterpreter', 'none');
% end
% xlabel('Patient');
% ylabel('Temperature rise slope');


%% figure of individual patient fits
markers = {'o', '^', 's'};
linestyles = {'-', '--', ':'};
figure;
for i = 1:length(subjects)
    subplot(numFigRows,numFigCols,i); hold on;

    if subjectSpecificColorsFlag
        tmp = mod(i-1,numColors);
        subjectColor = cmap(tmp+1,:);

        tmp2 = floor((i-1)/numColors);
        markerFormatSpec = {'linestyle', 'none', 'marker', markers{tmp2+1}, 'color', subjectColor};
        lineFormatSpec = {'linestyle', linestyles{tmp2+1}};
    else
        subjectColor = mrTypeCmap(1,:);
        markerFormatSpec = {'linestyle', 'none', 'marker', 'o', 'color', subjectColor};
        lineFormatSpec = {'linestyle', '-'};
    end

    if hasMeThermom(i)
        subjectColor = mrTypeCmap(2,:);
        % markerFormatSpec = [markerFormatSpec, {'markerfacecolor', subjectColor, 'color', subjectColor, 'marker', '^'}];
        markerFormatSpec = [markerFormatSpec, {'color', subjectColor}];
        lineFormatSpec = [lineFormatSpec, {'color', subjectColor}];
    end

    % plot the points
    plot(bioheatTemps{i}, thermomTemps{i}, markerFormatSpec{:});
    % plot the fit line
    h1 = plot(x, y{i}, 'k', 'linewidth', 1.25, 'color', subjectColor, lineFormatSpec{:});
    excludeFromLegend(h1);
    % plot the confidence band
    h4 = patch([x; flipud(x)], [upperBound{i}; flipud(lowerBound{i})], [1,1,1]*0.7, 'facealpha', 0.4, 'edgecolor', 'none');
    excludeFromLegend(h4);
    % wrap up
    grid on;
    axis equal;
    xlim([0 maxFigTemp]);
    ylim([0 maxFigTemp]);
    %
    text(0.05*maxFigTemp, 0.9*maxFigTemp, sprintf('r^2 = %0.3f', rSquaredAdj(i)));
    if pValues(i) < 0.001
        pValueThresholdInd = find(pValues(i) < pValueThresholds, 1);
        text(0.05*maxFigTemp, 0.8*maxFigTemp, sprintf('p < %1.0e', pValueThresholds(pValueThresholdInd)));
    else
        text(0.05*maxFigTemp, 0.8*maxFigTemp, sprintf('p = %0.3f', pValues(i)));
    end
    text(0.05*maxFigTemp, 0.7*maxFigTemp, sprintf('SDR = %0.2f', sdrs(i)));
    %
    if hasMeThermom(i)
        text(0.975*maxFigTemp, 0.085*maxFigTemp, 'Multi echo', 'horizontalalignment', 'right');
    else
        text(0.975*maxFigTemp, 0.085*maxFigTemp, 'Single echo', 'horizontalalignment', 'right');
    end
    if labelWithAliasesFlag
        title(sprintf('Patient %s', subjectAliases{i}));
    else
        title(subjects{i}, 'interpreter', 'none');
    end
    ylabel({'MR thermometry', 'temperature rise (\circC)'}, 'fontsize', 9);
    xlabel('Simulation temperature rise (\circC)', 'fontsize', 9);
    line([0 maxFigTemp], [0 maxFigTemp], 'color', [1,1,1]*0.4);
    %
    if labelSonicationsFlag
        plottedSonications = find(targetIndsTemp{i});
        for j = 1:length(plottedSonications)
            text(bioheatTemps{i}(j)+0.5, thermomTemps{i}(j), num2str(plottedSonications(j)));
        end
    end
end


% % overlaid figure
% markers = {'o', '^', 's'};
% linestyles = {'-', '--', ':'};
% figure; hold on;
% for i = 1:length(subjects)
%     tmp = mod(i-1,numColors);
%     subjectColor = cmap(tmp+1,:);

%     tmp2 = floor((i-1)/numColors);
%     markerFormatSpec = {'linestyle', 'none', 'marker', markers{tmp2+1}, 'color', subjectColor};
%     lineFormatSpec = {'linestyle', linestyles{tmp2+1}};
%     if hasMeThermom(i)
%         markerFormatSpec = [markerFormatSpec, {'markerfacecolor', subjectColor}];
%     end

%     % plot the points
%     plot(bioheatTemps{i}, thermomTemps{i}, ...
%         markerFormatSpec{:}, 'displayname', sprintf('%s (r^2 = %0.3f, S = %0.3f)', ...
%             subjects{i}, rSquaredAdj(i), standardErrorsOfRegression(i)));
%     % plot the fit line
%     if subjectSpecificColorsFlag
%         x = (0:maxFigTemp)';
%         y = predict(mdlIndiv{i}, x);
%         h = plot(x, y, 'color', subjectColor, lineFormatSpec{:});
%         set(get(get(h,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
%     end
%     %
%     if labelSonicationsFlag
%         plottedSonications = find(targetIndsTemp{i});
%         for j = 1:length(plottedSonications)
%             text(bioheatTemps{i}(j)+0.5, thermomTemps{i}(j), num2str(plottedSonications(j)));
%         end
%     end
% end
% if ~subjectSpecificColorsFlag
%     mdlAll = fitlm(cell2mat(bioheatTemps), cell2mat(thermomTemps));
%     rSquaredAll = mdlAll.Rsquared.Ordinary;
%     rSquaredAdjAll = mdlAll.Rsquared.Adjusted;
%     pValueAll = mdlAll.anova.pValue(1);
%     slopeAll = mdlAll.Coefficients.Estimate(2);
%     x = (0:maxFigTemp)';
%     y = predict(mdlAll, x);
%     h = plot(x, y, 'color', 'k', 'linewidth', 1.25);
%     set(get(get(h,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
% end
% % wrap up
% grid on;
% axis equal;
% xlim([0 maxFigTemp]);
% ylim([0 maxFigTemp]);
% ylabel({'MR thermometry', 'temperature rise (\circC)'});
% xlabel('Simulation temperature rise (\circC)');
% line([0 maxFigTemp], [0 maxFigTemp], 'color', [1,1,1]*0.4);
% if labelWithAliasesFlag
%     fn = @(str) sprintf('Patient %s', str);
%     tmp = cellfun(fn, subjectAliases, 'uniformoutput', false);
%     legend(tmp, 'location', 'eastoutside', 'interpreter', 'none');
% else
%     legend(subjects, 'location', 'eastoutside', 'interpreter', 'none');
% end


% % overlaid figure (<10C rise)
% tempThresholdRise = cell(length(subjects), 1);
% for i = 1:length(subjects)
%     tempThresholdRise{i} = thermomTemps{i}<10;
% end
% markers = {'o', '^', 's'};
% linestyles = {'-', '--', ':'};
% figure; hold on;
% for i = 1:length(subjects)
%     tmp = mod(i-1,numColors);
%     subjectColor = cmap(tmp+1,:);

%     tmp2 = floor((i-1)/numColors);
%     markerFormatSpec = {'linestyle', 'none', 'marker', markers{tmp2+1}, 'color', subjectColor};
%     lineFormatSpec = {'linestyle', linestyles{tmp2+1}};
%     if hasMeThermom(i)
%         markerFormatSpec = [markerFormatSpec, {'markerfacecolor', subjectColor}];
%     end

%     % plot the points
%     plot(bioheatTemps{i}(tempThresholdRise{i}), thermomTemps{i}(tempThresholdRise{i}), ...
%         markerFormatSpec{:}, 'displayname', sprintf('%s (r^2 = %0.3f, S = %0.3f)', ...
%             subjects{i}, rSquaredAdj(i), standardErrorsOfRegression(i)));
%     % plot the fit line
%     if subjectSpecificColorsFlag
%         x = (0:maxFigTemp)';
%         y = predict(mdlIndiv{i}, x);
%         h = plot(x, y, 'color', subjectColor, lineFormatSpec{:});
%         set(get(get(h,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
%     end
%     %
%     if labelSonicationsFlag
%         plottedSonications = find(targetIndsTemp{i});
%         for j = 1:length(plottedSonications)
%             text(bioheatTemps{i}(j)+0.5, thermomTemps{i}(j), num2str(plottedSonications(j)));
%         end
%     end
% end
% if ~subjectSpecificColorsFlag
%     bioheatTempsAll2 = cell2mat(bioheatTemps);
%     thermomTempsAll2 = cell2mat(thermomTemps);
%     tempThresholdRiseAll2 = cell2mat(tempThresholdRise);
%     mdlAll = fitlm(bioheatTempsAll2(tempThresholdRiseAll2), thermomTempsAll2(tempThresholdRiseAll2));
%     rSquaredAll = mdlAll.Rsquared.Ordinary;
%     rSquaredAdjAll = mdlAll.Rsquared.Adjusted;
%     pValueAll = mdlAll.anova.pValue(1);
%     slopeAll = mdlAll.Coefficients.Estimate(2);
%     x = (0:maxFigTemp)';
%     y = predict(mdlAll, x);
%     h = plot(x, y, 'color', 'k', 'linewidth', 1.25);
%     set(get(get(h,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
% end
% % wrap up
% grid on;
% axis equal;
% xlim([0 maxFigTemp]);
% ylim([0 maxFigTemp]);
% ylabel({'MR thermometry', 'temperature rise (\circC)'});
% xlabel('Simulation temperature rise (\circC)');
% line([0 maxFigTemp], [0 maxFigTemp], 'color', [1,1,1]*0.4);
% if labelWithAliasesFlag
%     fn = @(str) sprintf('Patient %s', str);
%     tmp = cellfun(fn, subjectAliases, 'uniformoutput', false);
%     legend(tmp, 'location', 'eastoutside', 'interpreter', 'none');
% else
%     legend(subjects, 'location', 'eastoutside', 'interpreter', 'none');
% end



%% residuals figure
if residualFigFlag
    figure;
    for i = 1:length(subjects)
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

        subplot(numFigRows,numFigCols,i); hold on;

        % plot the residuals
        predTemp = predict(mdlIndiv{i}, bioheatTemps{i});
        plot(bioheatTemps{i}, thermomTemps{i}-predTemp, ...
            markerFormatSpec{:}, 'displayname', sprintf('%s (r^2 = %0.3f, S = %0.3f)', ...
                subjects{i}, rSquaredAdj(i), standardErrorsOfRegression(i)));
        % wrap up
        grid on;
        xlim([0, maxFigTemp]);
        ylim([-5, 5]);
        if labelWithAliasesFlag
            title(sprintf('Patient %s', subjectAliases{i}));
        else
            title(subjects{i}, 'interpreter', 'none');
        end
        line([0, maxFigTemp], [0, 0], 'color', 'k');
    end
end


if individualPatientPlotsFlag
    markers = {'o', '^', 's'};
    linestyles = {'-', '--', ':'};
    for i = 3%1:length(subjects)
        figure; hold on;

        if subjectSpecificColorsFlag
            tmp = mod(i-1,numColors);
            subjectColor = cmap(tmp+1,:);

            tmp2 = floor((i-1)/numColors);
            markerFormatSpec = {'linestyle', 'none', 'marker', markers{tmp2+1}, 'color', subjectColor};
            lineFormatSpec = {'linestyle', linestyles{tmp2+1}};
        else
            subjectColor = mrTypeCmap(1,:);
            markerFormatSpec = {'linestyle', 'none', 'marker', 'o'};
            lineFormatSpec = {'linestyle', '-', 'linewidth', 3};
        end

        if labelByEchoTypeFlag
            if hasMeThermom(i)
                subjectColor = mrTypeCmap(2,:);
                markerFormatSpec = [markerFormatSpec, {'markerfacecolor', subjectColor, 'color', subjectColor, 'marker', '^'}];
                lineFormatSpec = [lineFormatSpec, {'color', subjectColor}];
            end
        end

        if labelByTreatmentLocationFlag
            if sum(ismember(subjects{i}, '_')) > 1
                subjectColor = cmap(4,:);
                markerFormatSpec = [markerFormatSpec, {'color', subjectColor, 'marker', 'o'}];
                lineFormatSpec = [lineFormatSpec, {'color', subjectColor}];
            end
        end

        % plot the points
        plot(bioheatTemps{i}, thermomTemps{i}, ...
            markerFormatSpec{:}, 'displayname', sprintf('%s (r^2 = %0.3f, S = %0.3f)', ...
                subjects{i}, rSquaredAdj(i), standardErrorsOfRegression(i)));
        % plot the fit line
        x = (0:maxFigTemp)';
        y = predict(mdlIndiv{i}, x);
        h = plot(x, y, 'color', subjectColor, lineFormatSpec{:});
        set(get(get(h,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
        % wrap up
        grid on;
        axis equal;
        xlim([0 maxFigTemp]);
        ylim([0 maxFigTemp]);
        text(0.05*maxFigTemp, 0.9*maxFigTemp, sprintf('r^2 = %0.3f', rSquaredAdj(i)), 'fontsize', 12);
        if labelByEchoTypeFlag
            if hasMeThermom(i)
                text(0.85*maxFigTemp, 0.085*maxFigTemp, 'ME');
            else
                text(0.85*maxFigTemp, 0.085*maxFigTemp, 'SE');
            end
        end
        if labelWithAliasesFlag
            title(sprintf('Patient %s', subjectAliases{i}), 'fontsize', 16);
        else
            title(subjects{i}, 'interpreter', 'none', 'fontsize', 16);
        end
        ylabel({'MR thermometry', 'temperature rise (\circC)'}, 'fontsize', 16);
        xlabel('Simulation temperature rise (\circC)', 'fontsize', 16);
        line([0 maxFigTemp], [0 maxFigTemp], 'color', [1,1,1]*0.4);
        %
        if labelSonicationsFlag
            plottedSonications = find(targetIndsTemp{i});
            for j = 1:length(plottedSonications)
                text(bioheatTemps{i}(j)+0.5, thermomTemps{i}(j), num2str(plottedSonications(j)));
            end
        end
        % %
        % exportFig(gcf, sprintf('temperature %s 2018-05-08', subjects{i}), '-transparent', '-r300');
    end
end


% figure; hold on;
% plot(bioheatTemps{i}(isTimepoint1{i}(targetIndsTemp{i})), thermomTemps{i}(isTimepoint1{i}(targetIndsTemp{i})), 'o');
% plot(bioheatTemps{i}(isTimepoint2{i}(targetIndsTemp{i})), thermomTemps{i}(isTimepoint2{i}(targetIndsTemp{i})), 'o');
% plot(bioheatTemps{i}(isTimepoint3{i}(targetIndsTemp{i})), thermomTemps{i}(isTimepoint3{i}(targetIndsTemp{i})), 'o');
% axis equal;

if ~individualPatientPlotsFlag
    figure;
end
for i = 1:length(subjects)
    bioheatTimepoints = cat(1, bioheat{i}{:,6});
    bioheatTimepoints(~targetIndsTemp{i}) = NaN;
    bioheatTimepoints = reshape(bioheatTimepoints, length(targetTimepoints), []);
    thermomTimepoints = cat(1, thermom{i}{:,6});
    thermomTimepoints(~targetIndsTemp{i}) = NaN;
    thermomTimepoints = reshape(thermomTimepoints, length(targetTimepoints), []);
    set(groot, 'defaultAxesColorOrder', lines(5), 'defaultAxesLineStyleOrder', '-|--|:|-.');
    if individualPatientPlotsFlag
        figure; hold on;
    else
        subplot(numFigRows,numFigCols,i); hold on;
    end
    for sonNum = 1:numSonications(i)
        plot(bioheatTimepoints(:,sonNum), thermomTimepoints(:,sonNum), ...
            'marker', 'o', 'linewidth', 1.25, 'displayname', num2str(sonNum));
    end
    set(groot, 'defaultAxesColorOrder', 'remove', 'defaultAxesLineStyleOrder', 'remove');
    axis equal;
    grid on;
    xlim([0, maxFigTemp]);
    ylim([0, maxFigTemp]);
    h = line([0 maxFigTemp], [0 maxFigTemp], 'color', [1,1,1]*0.4);
    excludeFromLegend(h);
    ylabel({'MR thermometry', 'temperature rise (\circC)'});
    xlabel('Simulation temperature rise (\circC)');
    title(subjects{i});
    if individualPatientPlotsFlag
        h = legend('show', 'location', 'eastoutside');
    end
end
