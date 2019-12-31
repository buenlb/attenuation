samePlotFlag = false;

pValueThresholds = 1*10.^(-10:-1);
cmap = lines(length(subjects));


%%
T = readtable('additionalPatientParameters.csv');
patientParameters = table2cell(T);

ages = cat(1, patientParameters{:,2});
numVoxels = cat(1, patientParameters{:,11});
sdrs = cat(1, patientParameters{:,5});


%% age
figure; hold on;
% plot(ages, slopes, 'o', 'linewidth', 1.25);
for i = 1:length(subjects)
    if i <= 7
        plot(ages(i), slopes(i), 'o', 'linewidth', 1.25, 'displayname', sprintf('Patient %s', subjectAliases{i}));
    else
        plot(ages(i), slopes(i), 'o', 'markerfacecolor', cmap(i,:), 'linewidth', 1.25, 'displayname', sprintf('Patient %s', subjectAliases{i}));
    end
end
grid on;
xlims = [60, 105];
ylims = [0, 3];
xlim(xlims);
ylim(ylims);
xlabel('Age (years)');
ylabel('Temperature slope');
ageModel = fitlm(ages, slopes);
ageModelRSquaredAdj = ageModel.Rsquared.Adjusted;
ageModelPValue = ageModel.anova.pValue(1);
x = (xlims(1):xlims(2))';
y = predict(ageModel, x);
h = plot(x, y, 'k', 'linewidth', 1.25);
excludeFromLegend(h);
legend('location', 'northeast');
%
text(0.05*diff(xlims)+xlims(1), 0.95*diff(ylims)+ylims(1), sprintf('r^2 = %0.3f', ageModelRSquaredAdj));
if ageModelPValue < 0.001
    pValueThresholdInd = find(ageModelPValue < pValueThresholds, 1);
    text(0.05*diff(xlims)+xlims(1), 0.9*diff(ylims)+ylims(1), sprintf('p < %1.0e', pValueThresholds(pValueThresholdInd)));
else
    text(0.05*diff(xlims)+xlims(1), 0.9*diff(ylims)+ylims(1), sprintf('p = %0.3f', ageModelPValue));
end


%% num voxels in skull
figure; hold on;
for i = 1:length(subjects)
    if i <= 7
        plot(numVoxels(i), slopes(i), 'o', 'linewidth', 1.25, 'displayname', sprintf('Patient %s', subjectAliases{i}));
    else
        plot(numVoxels(i), slopes(i), 'o', 'markerfacecolor', cmap(i,:), 'linewidth', 1.25, 'displayname', sprintf('Patient %s', subjectAliases{i}));
    end
end
grid on;
xlims = [2, 5]*1e5;
ylims = [0, 3];
xlim(xlims);
ylim(ylims);
xlabel('Number of skull voxels');
ylabel('Temperature slope');
numVoxelsModel = fitlm(numVoxels, slopes);
numVoxelsModelRSquaredAdj = numVoxelsModel.Rsquared.Adjusted;
numVoxelsModelPValue = numVoxelsModel.anova.pValue(1);
x = (xlims(1):xlims(2))';
y = predict(numVoxelsModel, x);
h = plot(x, y, 'k', 'linewidth', 1.25);
excludeFromLegend(h);
%
text(0.05*diff(xlims)+xlims(1), 0.95*diff(ylims)+ylims(1), sprintf('r^2 = %0.3f', numVoxelsModelRSquaredAdj));
if numVoxelsModelPValue < 0.001
    pValueThresholdInd = find(numVoxelsModelPValue < pValueThresholds, 1);
    text(0.05*diff(xlims)+xlims(1), 0.9*diff(ylims)+ylims(1), sprintf('p < %1.0e', pValueThresholds(pValueThresholdInd)));
else
    text(0.05*diff(xlims)+xlims(1), 0.9*diff(ylims)+ylims(1), sprintf('p = %0.3f', numVoxelsModelPValue));
end


%% SDR
figure; hold on;
for i = 1:length(subjects)
    if i <= 7
        plot(sdrs(i), slopes(i), 'o', 'linewidth', 1.25, 'displayname', sprintf('Patient %s', subjectAliases{i}));
    else
        plot(sdrs(i), slopes(i), 'o', 'markerfacecolor', cmap(i,:), 'linewidth', 1.25, 'displayname', sprintf('Patient %s', subjectAliases{i}));
    end
end
grid on;
xlims = [0.4, 0.8];
ylims = [0, 3];
xlim(xlims);
ylim(ylims);
xlabel('Skull density ratio (SDR)');
ylabel('Temperature slope');
sdrModel = fitlm(sdrs, slopes);
sdrModelRSquaredAdj = sdrModel.Rsquared.Adjusted;
sdrModelPValue = sdrModel.anova.pValue(1);
x = (xlims(1):0.1:xlims(2))';
y = predict(sdrModel, x);
h = plot(x, y, 'k', 'linewidth', 1.25);
excludeFromLegend(h);
%
text(0.05*diff(xlims)+xlims(1), 0.95*diff(ylims)+ylims(1), sprintf('r^2 = %0.3f', sdrModelRSquaredAdj));
if sdrModelPValue < 0.001
    pValueThresholdInd = find(sdrModelPValue < pValueThresholds, 1);
    text(0.05*diff(xlims)+xlims(1), 0.9*diff(ylims)+ylims(1), sprintf('p < %1.0e', pValueThresholds(pValueThresholdInd)));
else
    text(0.05*diff(xlims)+xlims(1), 0.9*diff(ylims)+ylims(1), sprintf('p = %0.3f', sdrModelPValue));
end
