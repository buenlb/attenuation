function marsac = bonePropertiesMarsac2017(createFigFlag)
%% Marsac 2017
huMin = 0;      % HU
huMax = 2400;
% rhoMax = 2700 on page 5, 2800 on page 9
rhoMin = 1000;  % kg/m^3
rhoMax = 2800;  
cMin = 1500;    % m/s
cMax = 4000;

marsac.kvp = 80;
marsac.hu = -1000:100:2400;
marsac.rho = rhoMin + (rhoMax-rhoMin)*(marsac.hu-huMin)/(huMax-huMin);
marsac.c = cMin + (cMax-cMin)*(marsac.rho-rhoMin)/(rhoMax-rhoMin);

marsac.rhoExtrap = 1000:10:3500;
marsac.cExtrap = cMin + (cMax-cMin)*(marsac.rhoExtrap-rhoMin)/(rhoMax-rhoMin);

if createFigFlag
    % density vs HU figure
    figure; plot(marsac.hu, marsac.rho);
    xlabel('HU'); ylabel('density (kg/m^3)');
    grid on;
    ylim([0 4000]);
    figName = 'Marsac 2017 bone density vs HU';
    title(figName);
    figPath = fullfile('C:/Users/Steve/Downloads', figName);
    exportFig(gcf, figPath, '-transparent');

    % speed of sound vs density figure
    figure; plot(marsac.rho, marsac.c);
    xlabel('density (kg/m^3)'); ylabel('speed of sound (m/s)');
    grid on;
    ylim([1500 4000]);
    figName = 'Marsac 2017 sos vs bone density';
    title(figName);
    figPath = fullfile('C:/Users/Steve/Downloads', figName);
    exportFig(gcf, figPath, '-transparent');

    % speed of sound vs HU figure
    figure; plot(marsac.hu, marsac.c);
    xlabel('HU'); ylabel('speed of sound (m/s)');
    grid on;
    ylim([1500 4000]);
    figName = 'Marsac 2017 sos vs HU';
    title(figName);
    figPath = fullfile('C:/Users/Steve/Downloads', figName);
    exportFig(gcf, figPath, '-transparent');
end


% %% Marsac 2017 (with possible typo)
% huMin = -1024;  % HU
% huMax = 2400;
% % rhoMax = 2700 on page 5, 2800 on page 9
% rhoMin = 1000;  % kg/m^3
% rhoMax = 2800;  
% cMin = 1500;    % m/s
% cMax = 4000;

% huBins = -1000:100:2400;
% rho = rhoMin + (rhoMax-rhoMin)*(huBins-huMin)/(huMax-huMin);

% c = cMin + (cMax-cMin)*(rho-rhoMin)/(rhoMax-rhoMin);

% % density vs HU figure
% figure; plot(huBins, rho);
% xlabel('HU'); ylabel('density (kg/m^3)');
% grid on;
% ylim([0 3500]);
% figName = 'Marsac 2017 bone density vs HU';
% title(figName);
% figPath = fullfile('C:/Users/Steve/Downloads', figName);
% exportFig(gcf, figPath, '-transparent');

% % speed of sound vs density figure
% figure; plot(rho, c);
% xlabel('density (kg/m^3)'); ylabel('speed of sound (m/s)');
% grid on;
% ylim([1500 4000]);
% figName = 'Marsac 2017 sos vs bone density';
% title(figName);
% figPath = fullfile('C:/Users/Steve/Downloads', figName);
% exportFig(gcf, figPath, '-transparent');

% % speed of sound vs HU figure
% figure; plot(huBins, c);
% xlabel('HU'); ylabel('speed of sound (m/s)');
% grid on;
% ylim([1500 4000]);
% figName = 'Marsac 2017 sos vs HU';
% title(figName);
% figPath = fullfile('C:/Users/Steve/Downloads', figName);
% exportFig(gcf, figPath, '-transparent');

