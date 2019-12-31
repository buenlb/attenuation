% create figure showing that timepoint 3 is the latest timepoint across
% sonications where FUS is on


%% setup
addpath(genpath('M:\HAS-simulations\lib'));
addpath('M:\HAS-simulations\steve');

subject = '43214';
sonication = {'08'; '10'};

% load the data
dirPath = fullfile('M:\SCRATCH\1534113905_924c0ab\thermomAnalysis', subject);
data = cell(size(sonication));
for i = 1:length(sonication)
    thermomFilename = sprintf('%s %s thermom.mat', subject, sonication{i});
    data{i} = load(fullfile(dirPath, thermomFilename));
end


%% create the figure
time = cell(size(sonication));
figure; hold on
% plot the temperature for each timepoint
% for i = 1:length(sonication)
%     timePerFrame = 3.584;
%     time{i} = [0, (0.5:size(data{i}.thermom,3)-2) * timePerFrame];
%     plot(time{i}, squeeze(data{i}.thermom(data{i}.yInd, data{i}.xInd, 2:end)), ...
%         'o-', 'displayname', sprintf('Sonication %s', num2str(str2double(sonication{i}))), 'linewidth', 1.5);
% end
timePerFrame = 3.584;
i=1;
time{i} = [0, (0.5:size(data{i}.thermom,3)-2) * timePerFrame];
plot(time{i}, squeeze(data{i}.thermom(data{i}.yInd, data{i}.xInd, 2:end)), ...
    'o-', 'displayname', sprintf('Sonication %s', num2str(str2double(sonication{i}))), 'linewidth', 1.5);
i=2;
time{i} = [0, (0.5:size(data{i}.thermom,3)-2) * timePerFrame];
plot(time{i}, squeeze(data{i}.thermom(data{i}.yInd, data{i}.xInd, 2:end)), ...
    'o--', 'color', lines(1), 'displayname', sprintf('Sonication %s', num2str(str2double(sonication{i}))), 'linewidth', 1.5);
xlim([0,30]);
ylim([0,25]);
% add the timepoint lines
timepoints = (0.5:3) * timePerFrame;
lineColor = [1,1,1]*0.2;
for i = 1:3
    h = line([timepoints(i) timepoints(i)], ylim, 'color', lineColor);
    set(get(get(h,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
    textH = text(timepoints(i)-0.7, 0.5, ['Timepoint ' num2str(i)], 'color', lineColor);
    set(textH, 'rotation', 90);
end
grid on;
xlabel('Time (s)'); 
ylabel('MR thermometry temperature rise (\circC)');
legend('show');
reorderLegend([4,5]);
