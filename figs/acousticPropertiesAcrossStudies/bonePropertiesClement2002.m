function clement = bonePropertiesClement2002(createFigFlag)
% Clement 2002
% Center frequency 0.54 MHz

rhoMin = 1820;
rhoMax = 2450;

clement.rho = rhoMin:10:rhoMax;
clement.c = 2.06*clement.rho-1540;

clement.rhoExtrap = 1000:10:2800;
clement.cExtrap = 2.06*clement.rhoExtrap-1540;

if createFigFlag
    figure; plot(clement.rhoExtrap, clement.cExtrap, '--', 'color', [1,1,1]*0.5);
    hold on;
    plot(clement.rho, clement.c, 'color', lines(1));
    hold off;
    xlabel('density (kg/m^3)'); ylabel('speed of sound (m/s)');
    grid on;
    xlim([1000 2800]);
    ylim([0 4000]);
    figName = 'Clement 2002 sos vs bone density';
    title(figName);
    figPath = fullfile('C:/Users/Steve/Downloads', figName);
    exportFig(gcf, figPath, '-transparent');
end
