% script to explore the position error relative to the electronically steered
% distance

metricsFiguresSetup;
whichSonicationsFigure;
positionFigure;


%% grab values for the different variables
% scan planes
scanPlanes = cell(length(subjects), 1);
for i = 1:length(subjects)
    scanPlanes{i} = cat(1, treatmentInfo{i}{:,6});
end
scanPlanesAll = cell2mat(scanPlanes);

% bioheat focal spot position
[tmp1, tmp2] = deal(cell(length(subjects), 1));
for i = 1:length(subjects)
    tmp1{i} = bioheatFocusX{i}(isTimepoint3{i});
    tmp2{i} = bioheatFocusY{i}(isTimepoint3{i});
end
bioheatFocusXAll = cell2mat(tmp1)*1e3;
bioheatFocusYAll = cell2mat(tmp2)*1e3;

% themom focal spot position
[tmp1, tmp2] = deal(cell(length(subjects), 1));
for i = 1:length(subjects)
    tmp1{i} = thermomFocusX{i}(isTimepoint3{i});
    tmp2{i} = thermomFocusY{i}(isTimepoint3{i});
end
thermomFocusXAll = cell2mat(tmp1);
thermomFocusYAll = cell2mat(tmp2);

% x & y error between bioheat and thermom positions
[tmp1, tmp2] = deal(cell(length(subjects), 1));
for i = 1:length(subjects)
    tmp1{i} = xError{i}(isTimepoint3{i});
    tmp2{i} = yError{i}(isTimepoint3{i});
end
xErrorAll = cell2mat(tmp1);
yErrorAll = cell2mat(tmp2);

% phase encode direction
[tmp1, tmp2] = deal(cell(length(subjects), 1));
for i = 1:length(subjects)
    tmp1{i} = peDir{i}(isTimepoint3{i});
end
peDirAll = cat(1, tmp1{:});

% targetIndsPos
[tmp] = deal(cell(length(subjects), 1));
for i = 1:length(subjects)
    tmp{i} = targetIndsPos{i}(isTimepoint3{i});
end
targetIndsPosAll = cell2mat(tmp);


%% MR coordinates of the electronic and geometric foci
geoFocusMrLps = xlsread('geoFocusMrLps_coordinates.csv');
eFocusMrLps = xlsread('eFocusMrLps_coordinates.csv');

% calculate the distance between the foci
[distance_eFocus_geoFocus] = deal(zeros(size(scanPlanesAll)));
for i = 1:length(scanPlanesAll)
    distance_eFocus_geoFocus(i) = sqrt(sum((eFocusMrLps(i,[1:3]+2) - geoFocusMrLps(i,[1:3]+2)).^2));
end

% 
% subjects = {'43203'; '43211'; '43213'; '43214'; '43215'; ...
%             '43262'; '43263'; '43265'; '43267'};
% numSonications = [25; 17; 12; 17; 19; 21; 19; 16; 17];

% tmp = cellfun(@str2double, subjects, 'uniformoutput', false);
% subjectNamesAll = cell2mat(repelem(tmp, numSonications));

% tmp = cell(length(subjectNamesAll), 1);
% for subjectNum = 1:length(subjects)
%     tmp{subjectNum} = (1:numSonications(subjectNum))';
% end
% sonicationsAll = cell2mat(tmp);

% position error
feErrorAllSonicationsAll = cell2mat(feErrorAllSonications);
peErrorAllSonicationsAll = cell2mat(peErrorAllSonications);

figure; plot(distance_eFocus_geoFocus(targetIndsPosAll), feErrorAllSonicationsAll(targetIndsPosAll), 'o');
axis equal;
grid on;
xlim([0, 5]);
ylim([-4, 4]);
% xlabel({'Distance from geometric focus'; 'due to electronic steering (mm)'});
xlabel('Electronic steering distance (mm)');
ylabel('Position error (mm)');
title('Frequency encode direction');
patch([0, 5, 5, 0], [1, 1, -1, -1]*1.094, [1,1,1]*0.7, 'facealpha', 0.4, 'edgecolor', 'none');


figure; plot(distance_eFocus_geoFocus(targetIndsPosAll), peErrorAllSonicationsAll(targetIndsPosAll), 'o');
axis equal;
grid on;
xlim([0, 5]);
ylim([-4, 4]);
xlabel('Electronic steering distance (mm)');
ylabel('Position error (mm)');
title('Phase encode direction');
patch([0, 5, 5, 0], [1, 1, -1, -1]*1.094*2, [1,1,1]*0.7, 'facealpha', 0.4, 'edgecolor', 'none');


% %% calculate distances between different pairs of foci
% % electronic and geometric foci
% [xDistance_eFocus_geoFocus, yDistance_eFocus_geoFocus] = deal(zeros(size(scanPlanesAll)));
% for i = 1:length(scanPlanesAll)
%     switch scanPlanesAll(i)
%     case 'A'
%         xDistance_eFocus_geoFocus(i) = eFocusMrLps(i,1+2) - geoFocusMrLps(i,1+2);
%         yDistance_eFocus_geoFocus(i) = eFocusMrLps(i,2+2) - geoFocusMrLps(i,2+2);
%     case 'C'
%         xDistance_eFocus_geoFocus(i) = eFocusMrLps(i,1+2) - geoFocusMrLps(i,1+2);
%         yDistance_eFocus_geoFocus(i) = eFocusMrLps(i,3+2) - geoFocusMrLps(i,3+2);
%     case 's'
%         xDistance_eFocus_geoFocus(i) = eFocusMrLps(i,2+2) - geoFocusMrLps(i,2+2);
%         yDistance_eFocus_geoFocus(i) = eFocusMrLps(i,3+2) - geoFocusMrLps(i,3+2);
%     end
% end

% % bioheat and geometric foci
% [xDistance_bioheat_geoFocus, yDistance_bioheat_geoFocus] = deal(zeros(size(scanPlanesAll)));
% for i = 1:length(scanPlanesAll)
%     switch scanPlanesAll(i)
%     case 'A'
%         xDistance_bioheat_geoFocus(i) = bioheatFocusXAll(i) - geoFocusMrLps(i,1+2);
%         yDistance_bioheat_geoFocus(i) = bioheatFocusYAll(i) - geoFocusMrLps(i,2+2);
%     case 'C'
%         xDistance_bioheat_geoFocus(i) = bioheatFocusXAll(i) - geoFocusMrLps(i,1+2);
%         yDistance_bioheat_geoFocus(i) = bioheatFocusYAll(i) - geoFocusMrLps(i,3+2);
%     case 's'
%         xDistance_bioheat_geoFocus(i) = bioheatFocusXAll(i) - geoFocusMrLps(i,2+2);
%         yDistance_bioheat_geoFocus(i) = bioheatFocusYAll(i) - geoFocusMrLps(i,3+2);
%     end
% end

% % thermom and geometric foci
% [xDistance_thermom_geoFocus, yDistance_thermom_geoFocus] = deal(zeros(size(scanPlanesAll)));
% for i = 1:length(scanPlanesAll)
%     switch scanPlanesAll(i)
%     case 'A'
%         xDistance_thermom_geoFocus(i) = thermomFocusXAll(i) - geoFocusMrLps(i,1+2);
%         yDistance_thermom_geoFocus(i) = thermomFocusYAll(i) - geoFocusMrLps(i,2+2);
%     case 'C'
%         xDistance_thermom_geoFocus(i) = thermomFocusXAll(i) - geoFocusMrLps(i,1+2);
%         yDistance_thermom_geoFocus(i) = thermomFocusYAll(i) - geoFocusMrLps(i,3+2);
%     case 's'
%         xDistance_thermom_geoFocus(i) = thermomFocusXAll(i) - geoFocusMrLps(i,2+2);
%         yDistance_thermom_geoFocus(i) = thermomFocusYAll(i) - geoFocusMrLps(i,3+2);
%     end
% end

% % bioheat and electronic foci
% [xDistance_bioheat_eFocus, yDistance_bioheat_eFocus] = deal(zeros(size(scanPlanesAll)));
% for i = 1:length(scanPlanesAll)
%     switch scanPlanesAll(i)
%     case 'A'
%         xDistance_bioheat_eFocus(i) = bioheatFocusXAll(i) - eFocusMrLps(i,1+2);
%         yDistance_bioheat_eFocus(i) = bioheatFocusYAll(i) - eFocusMrLps(i,2+2);
%     case 'C'
%         xDistance_bioheat_eFocus(i) = bioheatFocusXAll(i) - eFocusMrLps(i,1+2);
%         yDistance_bioheat_eFocus(i) = bioheatFocusYAll(i) - eFocusMrLps(i,3+2);
%     case 's'
%         xDistance_bioheat_eFocus(i) = bioheatFocusXAll(i) - eFocusMrLps(i,2+2);
%         yDistance_bioheat_eFocus(i) = bioheatFocusYAll(i) - eFocusMrLps(i,3+2);
%     end
% end

% % thermom and electronic foci
% [xDistance_thermom_eFocus, yDistance_thermom_eFocus] = deal(zeros(size(scanPlanesAll)));
% for i = 1:length(scanPlanesAll)
%     switch scanPlanesAll(i)
%     case 'A'
%         xDistance_thermom_eFocus(i) = thermomFocusXAll(i) - eFocusMrLps(i,1+2);
%         yDistance_thermom_eFocus(i) = thermomFocusYAll(i) - eFocusMrLps(i,2+2);
%     case 'C'
%         xDistance_thermom_eFocus(i) = thermomFocusXAll(i) - eFocusMrLps(i,1+2);
%         yDistance_thermom_eFocus(i) = thermomFocusYAll(i) - eFocusMrLps(i,3+2);
%     case 's'
%         xDistance_thermom_eFocus(i) = thermomFocusXAll(i) - eFocusMrLps(i,2+2);
%         yDistance_thermom_eFocus(i) = thermomFocusYAll(i) - eFocusMrLps(i,3+2);
%     end
% end


% %% sort the distances for freq and phase encode directions
% [feDistance_eFocus_geoFocus, peDistance_eFocus_geoFocus] = deal(zeros(size(scanPlanesAll)));
% for i = 1:length(scanPlanesAll)
%     if strcmp(peDirAll{i}, 'COL')
%         feDistance_eFocus_geoFocus(i) = xDistance_eFocus_geoFocus(i);
%         peDistance_eFocus_geoFocus(i) = yDistance_eFocus_geoFocus(i);
%     else
%         feDistance_eFocus_geoFocus(i) = yDistance_eFocus_geoFocus(i);
%         peDistance_eFocus_geoFocus(i) = xDistance_eFocus_geoFocus(i);
%     end
% end

% [feDistance_bioheat_geoFocus, peDistance_bioheat_geoFocus] = deal(zeros(size(scanPlanesAll)));
% for i = 1:length(scanPlanesAll)
%     if strcmp(peDirAll{i}, 'COL')
%         feDistance_bioheat_geoFocus(i) = xDistance_bioheat_geoFocus(i);
%         peDistance_bioheat_geoFocus(i) = yDistance_bioheat_geoFocus(i);
%     else
%         feDistance_bioheat_geoFocus(i) = yDistance_bioheat_geoFocus(i);
%         peDistance_bioheat_geoFocus(i) = xDistance_bioheat_geoFocus(i);
%     end
% end

% [feDistance_thermom_geoFocus, peDistance_thermom_geoFocus] = deal(zeros(size(scanPlanesAll)));
% for i = 1:length(scanPlanesAll)
%     if strcmp(peDirAll{i}, 'COL')
%         feDistance_thermom_geoFocus(i) = xDistance_thermom_geoFocus(i);
%         peDistance_thermom_geoFocus(i) = yDistance_thermom_geoFocus(i);
%     else
%         feDistance_thermom_geoFocus(i) = yDistance_thermom_geoFocus(i);
%         peDistance_thermom_geoFocus(i) = xDistance_thermom_geoFocus(i);
%     end
% end


% [feDistance_bioheat_eFocus, peDistance_bioheat_eFocus] = deal(zeros(size(scanPlanesAll)));
% for i = 1:length(scanPlanesAll)
%     if strcmp(peDirAll{i}, 'COL')
%         feDistance_bioheat_eFocus(i) = xDistance_bioheat_eFocus(i);
%         peDistance_bioheat_eFocus(i) = yDistance_bioheat_eFocus(i);
%     else
%         feDistance_bioheat_eFocus(i) = yDistance_bioheat_eFocus(i);
%         peDistance_bioheat_eFocus(i) = xDistance_bioheat_eFocus(i);
%     end
% end

% [feDistance_thermom_eFocus, peDistance_thermom_eFocus] = deal(zeros(size(scanPlanesAll)));
% for i = 1:length(scanPlanesAll)
%     if strcmp(peDirAll{i}, 'COL')
%         feDistance_thermom_eFocus(i) = xDistance_thermom_eFocus(i);
%         peDistance_thermom_eFocus(i) = yDistance_thermom_eFocus(i);
%     else
%         feDistance_thermom_eFocus(i) = yDistance_thermom_eFocus(i);
%         peDistance_thermom_eFocus(i) = xDistance_thermom_eFocus(i);
%     end
% end

% figure; plot(xDistance_eFocus_geoFocus, xErrorAll, 'o');
% axis equal;
% grid on;
% xlim([-4, 4]);
% ylim([-4, 4]);

% figure; plot(yDistance_eFocus_geoFocus, yErrorAll, 'o');
% axis equal;
% grid on;
% xlim([-4, 4]);
% ylim([-4, 4]);

% figure; plot(feDistance_eFocus_geoFocus, feErrorAllSonicationsAll, 'o');
% axis equal;
% grid on;
% xlim([-4, 4]);
% ylim([-4, 4]);
% xlabel('Freq encode distance (eFocus & geoFocus)');
% ylabel('Freq encode distance (bioheat & thermom)');

% figure; plot(peDistance_eFocus_geoFocus, peErrorAllSonicationsAll, 'o');
% axis equal;
% grid on;
% xlim([-4, 4]);
% ylim([-4, 4]);
% xlabel('Phase encode distance (eFocus & geoFocus)');
% ylabel('Phase encode distance (bioheat & thermom)');


% figure; plot(abs(feDistance_eFocus_geoFocus), abs(feErrorAllSonicationsAll), 'o');
% axis equal;
% grid on;
% xlim([-4, 4]);
% ylim([-4, 4]);
% xlabel('Freq encode distance (eFocus & geoFocus)');
% ylabel('Freq encode distance (bioheat & thermom)');

% figure; plot(abs(peDistance_eFocus_geoFocus), abs(peErrorAllSonicationsAll), 'o');
% axis equal;
% grid on;
% xlim([-4, 4]);
% ylim([-4, 4]);
% xlabel('Phase encode distance (eFocus & geoFocus)');
% ylabel('Phase encode distance (bioheat & thermom)');





% figure; plot(feDistance_eFocus_geoFocus, feDistance_bioheat_geoFocus, 'o');
% axis equal;
% grid on;
% xlim([-4, 4]);
% ylim([-4, 4]);

% figure; plot(peDistance_eFocus_geoFocus, peDistance_bioheat_geoFocus, 'o');
% axis equal;
% grid on;
% xlim([-4, 4]);
% ylim([-4, 4]);




% figure; plot(feDistance_thermom_geoFocus, feDistance_bioheat_geoFocus, 'o');
% axis equal;
% grid on;
% xlim([-4, 4]);
% ylim([-4, 4]);

% figure; plot(feDistance_thermom_eFocus, feDistance_bioheat_eFocus, 'o');
% axis equal;
% grid on;
% xlim([-4, 4]);
% ylim([-4, 4]);


% figure; plot(feDistance_eFocus_geoFocus, feDistance_thermom_geoFocus, 'o');
% axis equal;
% grid on;
% xlim([-4, 4]);
% ylim([-4, 4]);

% figure; plot(peDistance_eFocus_geoFocus, peDistance_thermom_geoFocus, 'o');
% axis equal;
% grid on;
% xlim([-4, 4]);
% ylim([-4, 4]);





% figure; hold on;
% plot(xDistance);
% plot(xErrorAll);

% figure; hold on;
% plot(abs(xDistance));
% plot(abs(xErrorAll));



% figure; hold on;
% plot(xDistance(targetIndsPosAll));
% plot(xErrorAll(targetIndsPosAll));

% figure; hold on;
% plot(abs(xDistance(targetIndsPosAll)));
% plot(abs(xErrorAll(targetIndsPosAll)));

% figure; hold on;
% plot(abs(yDistance(targetIndsPosAll)));
% plot(abs(yErrorAll(targetIndsPosAll)));