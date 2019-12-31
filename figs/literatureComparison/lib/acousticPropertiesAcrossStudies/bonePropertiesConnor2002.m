function connor = bonePropertiesConnor2002(createFigFlag)
% Connor 2002
% Center frequency 0.74 MHz

huAir = -1000;
huWater = 0;

connor.hu = 0:10:2500;
connor.rho = 1000*(1/(huWater-huAir)*connor.hu + (-huAir/(huWater-huAir)));

% table 1
rho = [1000, 1100, 1200, 1300, 1400, 1500, 1600, 1700, 1800, 1900, 2000, 2100, 2200, 2300, 2400, 2500, 2600, 2700, 2800, 2900, 3000, 3100, 3200, 3300, 3400];
c = [1852.7, 2033, 2183.8, 2275.8, 2302.6, 2298.1, 2300.3, 2332.5, 2393.4, 2479, 2585.4, 2708.8, 2845.3, 2991.1, 3142.1, 3294.6, 3444.7, 3588.5, 3722.2, 3841.9, 3947.6, 4041.9, 4127.7, 4207.8, 4285.1];
connor.c = interp1(rho, c, connor.rho);

freq = 0.68e6;      % 680 kHz
attenTrabecular = (300/100) * (freq/1e6);       % Np/cm
attenCortical = (167/100) * (freq/1e6);      % Np/cm
connor.atten = ones(size(connor.rho)) * attenTrabecular;
connor.atten(1665<connor.rho) = attenCortical;

if createFigFlag
    figure; plot(connor.hu, connor.rho);
    xlabel('HU'); ylabel('density (kg/m^3)');
    grid on;
    ylim([0 4000]);
    figName = 'Connor 2002 bone density vs HU';
    title(figName);
    figPath = fullfile('C:/Users/Steve/Downloads', figName);
    exportFig(gcf, figPath, '-transparent');
end