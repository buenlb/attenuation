function marquet = bonePropertiesMarquet2009(createFigFlag)
% Marquet 2009 (very similar to Aubry 2003)

% kvp not provided. assumed to be 120 kvp
kvp = 120;
kvEff = kvp/2;
photonEnergyMassAttenuationCoefficient;
macBone = exp(polyval(bone.p, log(kvEff)));
macWater = exp(polyval(water.p, log(kvEff)));
rhoBone = 2200;
rhoWater = 1000;

cMin = 1500;
cMax = 3100;

marquet.kvp = kvp;
marquet.au = 0:10:1000;
marquet.porosity = 1-marquet.au/1000;
marquet.rho = rhoWater*marquet.porosity + rhoBone*(1-marquet.porosity);
marquet.c = cMin + (cMax-cMin)*(1-marquet.porosity);


muBone = macBone*rhoBone;
muWater = macWater*rhoWater;

marquet.hu = marquet.au * (muBone-muWater)/muWater;


%
marquet.huExtrap = -1000:10:2500;
marquet.porosityExtrap = 1-marquet.huExtrap/1000*muWater/(muBone-muWater);
marquet.rhoExtrap = rhoWater*marquet.porosityExtrap + rhoBone*(1-marquet.porosityExtrap);
marquet.cExtrap = cMin + (cMax-cMin)*(1-marquet.porosityExtrap);

if createFigFlag
    figure; plot(marquet.au, marquet.hu);
    xlabel('Aubry units'); ylabel('HU');
    grid on;
    figName = sprintf('Marquet 2009 HU vs AU (%d kV_{eff})', kvEff);
    title(figName);
    figPath = fullfile('C:/Users/Steve/Downloads', figName);
    exportFig(gcf, figPath, '-transparent');

    figure; plot(marquet.huExtrap, marquet.rhoExtrap, '--', 'color', [1,1,1]*0.5);
    hold on;
    plot(marquet.hu, marquet.rho, 'color', lines(1));
    xlabel('HU'); ylabel('density (kg/m^3)');
    grid on;
    xlim([-1000 2500]);
    ylim([0 4000]);
    figName = sprintf('Marquet 2009 density vs HU (%d kV_{eff})', kvEff);
    title(figName);
    figPath = fullfile('C:/Users/Steve/Downloads', figName);
    exportFig(gcf, figPath, '-transparent');

    figure; plot(marquet.rhoExtrap, marquet.cExtrap, '--', 'color', [1,1,1]*0.5);
    hold on;
    plot(marquet.rho, marquet.c, 'color', lines(1));
    xlabel('density (kg/m^3)'); ylabel('speed of sound (m/s)');
    grid on;
    xlim([1000 2800]);
    ylim([1500 4000]);
    figName = sprintf('Marquet 2009 sos vs density (%d kV_{eff})', kvEff);
    title(figName);
    figPath = fullfile('C:/Users/Steve/Downloads', figName);
    exportFig(gcf, figPath, '-transparent');

    figure; plot(marquet.huExtrap, marquet.cExtrap, '--', 'color', [1,1,1]*0.5);
    hold on;
    plot(marquet.hu, marquet.c, 'color', lines(1));
    xlabel('HU'); ylabel('speed of sound (m/s)');
    grid on;
    xlim([-1000 2500]);
    ylim([0 4000]);
    figName = sprintf('Marquet 2009 sos vs HU (%d kV_{eff})', kvEff);
    title(figName);
    figPath = fullfile('C:/Users/Steve/Downloads', figName);
    exportFig(gcf, figPath, '-transparent');
end
