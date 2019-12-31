function vyas = bonePropertiesVyas2016(createFigFlag,freq,beta)
% Vyas 2016
% Center frequency 680 kHz

vyas.kvp = 120;
boneFractionMultiplier = 0.000321;      % from Urvi's code

vyas.hu = 0:10:2000;
vyas.boneFraction = vyas.hu * boneFractionMultiplier;
vyas.rho = 1000 + (3000-1000)*vyas.boneFraction;          % assuming density of bone is 3000 kg/m^3 (hydroxyapatite)
vyas.c = 1460 + 0.7096*vyas.hu;

% boneFractionExtrap = -0.4:0.01:1;
% vyas.huExtrap = boneFractionExtrap/boneFractionMultiplier;
% vyas.rhoExtrap = 1000 + (3000-1000)*boneFractionExtrap;
% vyas.cExtrap = 1460 + 0.7096*vyas.huExtrap;

vyas.absorption = 0.04 + (1-0.04)*vyas.boneFraction;

maxBoneFraction = vyas.boneFraction(end);
vyas.porosity = ((maxBoneFraction-vyas.boneFraction)/maxBoneFraction)*100 + 5;
scatter1 = 0.0243*vyas.porosity - 0.1908;
scatter2 = 0.171*vyas.porosity - 3.74;
scatter3 = -0.1601*vyas.porosity + 12.87;

% lower bound on porosity is exclusive
% vyas.scattering = zeros(size(vyas.porosity));
% vyas.scattering(vyas.porosity<=25) = scatter1(vyas.porosity<=25);
% vyas.scattering(25<vyas.porosity & vyas.porosity<=40) = scatter2(25<vyas.porosity & vyas.porosity<=40);
% vyas.scattering(40<vyas.porosity & vyas.porosity<=60) = 3.2;
% vyas.scattering(60<vyas.porosity) = scatter3(60<vyas.porosity);
% vyas.scattering(75<vyas.porosity) = 0;

% lower bound on porosity is inclusive
vyas.scattering = zeros(size(vyas.porosity));
vyas.scattering( 5<=vyas.porosity & vyas.porosity<25) = scatter1( 5<=vyas.porosity & vyas.porosity<25);
vyas.scattering(25<=vyas.porosity & vyas.porosity<40) = scatter2(25<=vyas.porosity & vyas.porosity<40);
vyas.scattering(40<=vyas.porosity & vyas.porosity<60) = 3.2;
vyas.scattering(60<=vyas.porosity) = scatter3(60<=vyas.porosity);
vyas.scattering(75<=vyas.porosity) = 0;


vyas.atten = vyas.absorption + vyas.scattering;
vyas.atten = vyas.atten*(freq/0.68)^beta;

if createFigFlag
    figure; plot(vyas.hu, vyas.rho);
    xlabel('HU'); ylabel('density (kg/m^3)');
    grid on;
    ylim([0 4000]);
    xlim([-1000 2500]);
    figName = 'Vyas 2016 density vs HU';
    title(figName);
    figPath = fullfile('C:/Users/Steve/Downloads', figName);
    exportFig(gcf, figPath, '-transparent');

    figure; plot(vyas.rhoExtrap, vyas.cExtrap, '--', 'color', [1,1,1]*0.5);
    hold on;
    plot(vyas.rho, vyas.c, 'color', lines(1));
    xlabel('density (kg/m^3)'); ylabel('speed of sound (m/s)');
    grid on;
    xlim([1000 2800]);
    ylim([0 4000]);
    figName = 'Vyas 2016 sos vs density';
    title(figName);
    figPath = fullfile('C:/Users/Steve/Downloads', figName);
    exportFig(gcf, figPath, '-transparent');

    figure; plot(vyas.hu, vyas.c);
    xlabel('HU'); ylabel('speed of sound (m/s)');
    grid on;
    xlim([-1000 2500]);
    ylim([0 4000]);
    figName = 'Vyas 2016 sos vs HU';
    title(figName);
    figPath = fullfile('C:/Users/Steve/Downloads', figName);
    exportFig(gcf, figPath, '-transparent');

    figure; plot(vyas.hu, vyas.absorption+vyas.scattering);
    xlabel('HU'); ylabel('attenuation (Np/cm)');
    grid on;
    xlim([-1000 2500]);
    ylim([0 4]);
    figName = 'Vyas 2016 attenuation vs HU';
    title(figName);
    figPath = fullfile('C:/Users/Steve/Downloads', figName);
    exportFig(gcf, figPath, '-transparent');
end
