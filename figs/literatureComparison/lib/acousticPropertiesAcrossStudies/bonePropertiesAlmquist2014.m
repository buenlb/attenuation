function almquist = bonePropertiesAlmquist2014(createFigFlag)
% Almquist 2014

almquist.hu = -1000:10:2500;
almquist.c = 2.85*almquist.hu + 1160;

if createFigFlag
    figure; plot(almquist.hu, almquist.c, 'color', lines(1));
    xlabel('HU'); ylabel('speed of sound (m/s)');
    grid on;
    xlim([-1000 2500]);
    ylim([0 4000]);
    figName = 'Almquist 2014 sos vs HU';
    title(figName);
    figPath = fullfile('C:/Users/Steve/Downloads', figName);
    exportFig(gcf, figPath, '-transparent');
end
