% create a figure showing the temperature roll-off phenomenon


%% load treatment info data
% dirPath = 'C:\Users\Steve\Steve\Stanford\Labs\KBP lab\Projects\Beam simulation\Aim 1 - validation\Paper 1';
% [treatmentInfoRaw, treatmentInfo] = deal(cell(size(subjects)));
% for i = 1:length(subjects)
%     subject = subjects{i};
%     if sum(ismember(subject, '_')) == 3
%         subject = subjects{i}(1:end-2);
%     end
%     [~,~,treatmentInfoRaw{i}] = xlsread(fullfile(dirPath, 'ET treatment info 2018-04-24.xlsx'), subject);
%     treatmentInfo{i} = treatmentInfoRaw{i}(2:end,:);
% end
% treatmentInfoHeaders = treatmentInfoRaw{i}(1,:)';
load('treatment_info_lucas');


%%
isAlignmentSonication = cell(size(subjects));
for i = 1:length(subjects)
    isAlignmentSonication{i} = false(numSonications(i),1);
    isAlignmentSonication{i}(1:calcSlopeStartSonication(i)-1) = true;
    isAlignmentSonication{i} = repelem(isAlignmentSonication{i}, length(targetTimepoints));
end


%% calculate the experimental efficiencies
[powers, temps, expEfficiencies] = deal(cell(size(subjects)));
for i = 1:length(subjects)
    powers{i} = cell2mat(repelem(treatmentInfo{i}(:,8), length(targetTimepoints)));
    temps{i} = cell2mat(thermom{i}(:,6));
    expEfficiencies{i} = temps{i}./powers{i};
end


%% calculate the standard deviation of noise
noises = cell(size(subjects));
noiseStds = zeros(size(subjects));
for i = 1:length(subjects)
    noises{i} = cat(1, thermom{i}{:,8});
    % keep only certain sonications
    noiseStds(i) = mean(noises{i}(~peInSiInds{i} & ~isnan(noises{i})));
end


%% determine the experimental efficiency
expEfficiencyMean = zeros(size(subjects));
for i = 1:length(subjects)
    tmp = expEfficiencies{i}(isTimepoint3{i});
    tmp(1:calcSlopeStartSonication(i)-1) = 0;
    % tmp(powers{i}(isTimepoint3{i})<250) = 0;
    tmp2 = sort(tmp, 'descend');
    tmp2(isnan(tmp2)) = [];
    expEfficiencyMean(i) = mean(tmp2(1:2));
end

excludeInds = cell(size(subjects));
[x, y, yUB, yLB] = deal(cell(size(subjects)));
for i = 1:length(subjects)
    % determine which sonications fall in the inclusion band (2x noise std dev)
    noiseStd = noiseStds(i);
    noiseRange = 3*noiseStd;
    % excludeInds{i} = false(numSonications(i),1);
    % % exclude the first alignment sonications
    % excludeInds{i}(1) = true;
    % for j = 1:numSonications(i)
    %     sonicationPower = powers{i}(j);
    %     sonicationTemp = temps{i}(j);
    %     expectedTemp = expEfficiencyMean(i)*sonicationPower;
    %     % if abs(sonicationTemp-expectedTemp)>noiseRange || thermomSnr{i}(j)<1
    %     if abs(sonicationTemp-expectedTemp)>noiseRange
    %         excludeInds{i}(j) = true;
    %     end
    % end
    tmp = false(numSonications(i),1);
    % exclude the first alignment sonications
    tmp(1) = true;
    powersTmp = powers{i}(isTimepoint3{i});
    tempsTmp = temps{i}(isTimepoint3{i});
    for j = 1:numSonications(i)
        sonicationPower = powersTmp(j);
        sonicationTemp = tempsTmp(j);
        expectedTemp = expEfficiencyMean(i)*sonicationPower;
        % if abs(sonicationTemp-expectedTemp)>noiseRange || thermomSnr{i}(j)<1
        if abs(sonicationTemp-expectedTemp)>noiseRange
            tmp(j) = true;
        end
    end
    excludeInds{i} = repelem(tmp, length(targetTimepoints));
    % values of the inclusion band
    x{i} = 0:1:2000;
    y{i} = expEfficiencyMean(i)*x{i};
    yUB{i} = y{i} + noiseRange;
    yLB{i} = y{i} - noiseRange;    
end


%% multi-panel figure for which sonications
isTimepointN = isTimepoint3;
maxFigPower = 1700;
maxFigTemp = 35;
colors = lines(2);
figure;
for i = 1:length(subjects)
    % plot the figure
    subplot(numFigRows,numFigCols,i); hold on;
    % inclusion band
    h = patch([x{i}(1), x{i}(1), x{i}(end), x{i}(end)], [yUB{i}(1), yLB{i}(1), yLB{i}(end), yUB{i}(end)], ...
        [1,1,1]*0.7, 'facealpha', 0.4, 'edgecolor', 'none');
    set(get(get(h,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
    h = plot(x{i}, y{i}, '--', 'color', [1,1,1]*0.5);
    set(get(get(h,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
    % sonications
    plot(powers{i}(~excludeInds{i}&isTimepointN{i}), temps{i}(~excludeInds{i}&isTimepointN{i}), 'o', ...
        'color', colors(1,:), 'displayname', 'Included sonications', 'linewidth', 1.25);
    plot(powers{i}(excludeInds{i}&isTimepointN{i}), temps{i}(excludeInds{i}&isTimepointN{i}), 'o', ...
        'color', colors(2,:), 'displayname', 'Excluded sonications', 'linewidth', 1.25);
    h = plot(powers{i}(~excludeInds{i}&isTimepointN{i}&isAlignmentSonication{i}), temps{i}(~excludeInds{i}&isTimepointN{i}&isAlignmentSonication{i}), 'o', ...
        'color', colors(1,:), 'markerfacecolor', colors(1,:), 'linewidth', 1.25);
    excludeFromLegend(h);
    h = plot(powers{i}(excludeInds{i}&isTimepointN{i}&isAlignmentSonication{i}), temps{i}(excludeInds{i}&isTimepointN{i}&isAlignmentSonication{i}), 'o', ...
        'color', colors(2,:), 'markerfacecolor', colors(2,:), 'linewidth', 1.25);
    excludeFromLegend(h);
    xlim([0,maxFigPower]);
    ylim([0,maxFigTemp]);
    grid on;
    xlabel('Power (W)');
    ylabel({'MR thermometry', 'temperature rise (\circC)'});
    title(subjects{i}, 'interpreter', 'none');
    % legend('show', 'location', 'northwest');
    labels = thermom{i}(isTimepointN{i},2);
    labelPoints(gca, powers{i}(isTimepointN{i}), temps{i}(isTimepointN{i}), labels);
    %
    text(0.05*maxFigPower, 0.9*maxFigTemp, sprintf('Exp efficiency: %0.4f', expEfficiencyMean(i)));
end


%% figure for a single subject
subject = '43214';
i = find(ismember(subjects, subject));
if ~isempty(i)
    figure('name', subjects{i}); hold on;
    h = patch([x{i}(1), x{i}(1), x{i}(end), x{i}(end)], [yUB{i}(1), yLB{i}(1), yLB{i}(end), yUB{i}(end)], ...
        [1,1,1]*0.7, 'facealpha', 0.4, 'edgecolor', 'none');
    set(get(get(h,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
    h = plot(x{i}, y{i}, '--', 'color', [1,1,1]*0.5, 'linewidth', 1.5);
    set(get(get(h,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
    % sonications
    plot(powers{i}(~excludeInds{i}&isTimepointN{i}), temps{i}(~excludeInds{i}&isTimepointN{i}), 'o', ...
        'color', colors(1,:), 'displayname', 'Included sonications', 'linewidth', 1.25);
    plot(powers{i}(excludeInds{i}&isTimepointN{i}), temps{i}(excludeInds{i}&isTimepointN{i}), 'o', ...
        'color', colors(2,:), 'displayname', 'Excluded sonications', 'linewidth', 1.25);
    h = plot(powers{i}(~excludeInds{i}&isTimepointN{i}&isAlignmentSonication{i}), temps{i}(~excludeInds{i}&isTimepointN{i}&isAlignmentSonication{i}), 'o', ...
        'color', colors(1,:), 'markerfacecolor', colors(1,:), 'linewidth', 1.25);
    excludeFromLegend(h);
    h = plot(powers{i}(excludeInds{i}&isTimepointN{i}&isAlignmentSonication{i}), temps{i}(excludeInds{i}&isTimepointN{i}&isAlignmentSonication{i}), 'o', ...
        'color', colors(2,:), 'markerfacecolor', colors(2,:), 'linewidth', 1.25);
    excludeFromLegend(h);
    plot(1500, 30, 'o', 'color', [1,1,1]*0.3, 'markerfacecolor', [1,1,1]*0.3, 'displayname', 'Alignment sonications');
    xlim([0,1100]);
    ylim([0,20]);
    grid on;
    xlabel('Power (W)');
    ylabel('MR thermometry temperature rise (\circC)');
    legend('show', 'location', 'northwest');
    labels = thermom{i}(isTimepointN{i},2);
    labelPoints(gca, powers{i}(isTimepointN{i}), temps{i}(isTimepointN{i}), labels);
end
