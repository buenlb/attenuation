function aubry = bonePropertiesAubry2003(createFigFlag,freq,beta,kvEff)
% Aubry 2003
% center frequency at 1.5 MHz

% kvp = 120;
% kvEff = kvp*2/3;
photonEnergyMassAttenuationCoefficient;
macBone = exp(polyval(bone.p, log(kvEff)));
macWater = exp(polyval(water.p, log(kvEff)));

% constants defined in paper
rhoBone = 2100;
rhoWater = 1000;
cMin = 1500;
cMax = 2900;

%
muBone = macBone*rhoBone;
muWater = macWater*rhoWater;

%
aubry.au = 0:0.01:1000;
aubry.hu = aubry.au * (muBone-muWater)/muWater;

% aubry.kvp = kvp;
aubry.porosity = 1-aubry.au/1000;
aubry.rho = rhoWater*aubry.porosity + rhoBone*(1-aubry.porosity);
aubry.c = cMin + (cMax-cMin)*(1-aubry.porosity);

% atteunation at 1.5 MHz
attenMin = 0.2*10/8.686;    % Np/cm
attenMax = 8*10/8.686;      % Np/cm
% attenuation at 0.68 MHz (assuming frequency dependence power law of 1)
% freq = 0.68e6;
% attenMin = 0.2*10/8.686/1.5e6*freq;   % Np/cm
% attenMax = 8*10/8.686/1.5e6*freq;     % Np/cm
% aubry.atten = attenMin + (attenMax-attenMin)*(sign(aubry.porosity).*abs(aubry.porosity.^(0.5)));    % returns the real root
aubry.atten = attenMin + (attenMax-attenMin)*sqrt(aubry.porosity);    % returns the real root

aubry.atten = aubry.atten*(freq/1.5)^beta;
%
aubry.huExtrap = -1000:10:2500;
aubry.porosityExtrap = 1-aubry.huExtrap/1000*muWater/(muBone-muWater);
aubry.rhoExtrap = rhoWater*aubry.porosityExtrap + rhoBone*(1-aubry.porosityExtrap);
aubry.cExtrap = cMin + (cMax-cMin)*(1-aubry.porosityExtrap);

if createFigFlag
    figure; plot(aubry.au, aubry.hu);
    xlabel('Aubry units'); ylabel('HU');
    grid on;
    figName = sprintf('Aubry 2003 HU vs AU (%d kV_{eff})', kvEff);
    title(figName);
    figPath = fullfile('C:/Users/Steve/Downloads', figName);
    exportFig(gcf, figPath, '-transparent');

    figure; plot(aubry.huExtrap, aubry.rhoExtrap, '--', 'color', [1,1,1]*0.5);
    hold on;
    plot(aubry.hu, aubry.rho, 'color', lines(1));
    xlabel('HU'); ylabel('density (kg/m^3)');
    grid on;
    xlim([-1000 2500]);
    ylim([0 4000]);
    figName = sprintf('Aubry 2003 density vs HU (%d kV_{eff})', kvEff);
    title(figName);
    figPath = fullfile('C:/Users/Steve/Downloads', figName);
    exportFig(gcf, figPath, '-transparent');

    figure; plot(aubry.rhoExtrap, aubry.cExtrap, '--', 'color', [1,1,1]*0.5);
    hold on;
    plot(aubry.rho, aubry.c, 'color', lines(1));
    xlabel('density (kg/m^3)'); ylabel('speed of sound (m/s)');
    grid on;
    xlim([1000 2800]);
    ylim([1500 4000]);
    figName = sprintf('Aubry 2003 sos vs density (%d kV_{eff})', kvEff);
    title(figName);
    figPath = fullfile('C:/Users/Steve/Downloads', figName);
    exportFig(gcf, figPath, '-transparent');

    figure; plot(aubry.huExtrap, aubry.cExtrap, '--', 'color', [1,1,1]*0.5);
    hold on;
    plot(aubry.hu, aubry.c, 'color', lines(1));
    xlabel('HU'); ylabel('speed of sound (m/s)');
    grid on;
    xlim([-1000 2500]);
    ylim([0 4000]);
    figName = sprintf('Aubry 2003 sos vs HU (%d kV_{eff})', kvEff);
    title(figName);
    figPath = fullfile('C:/Users/Steve/Downloads', figName);
    exportFig(gcf, figPath, '-transparent');
end
