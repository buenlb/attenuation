function leung = bonePropertiesLeung2018(createFigFlag,freq,beta)
%% Leung 2018

leung.hu = 0:10:2500;
boneFracMultiplier = 1/2000;

boneFraction = boneFracMultiplier * leung.hu;
boneFraction(boneFraction>1) = 1;

porosity = (1-boneFraction)*100;


% attenuation
poro = [0, 25, 40, 60, 85, 100];
atten = [0.522, 0.922, 2.136, 2.136, 0.1183, 0.04];
slope = diff(atten) ./ diff(poro);
intercept = atten(1:end-1) -slope.*poro(1:end-1);

leung.atten = zeros(size(leung.hu));
for i = 1:length(poro)-1
    inds = poro(i)<=porosity & porosity<poro(i+1);
    leung.atten(inds) = slope(i)*porosity(inds) + intercept(i);
end

leung.atten = leung.atten*(freq/0.68)^beta;

% density
leung.rho = 1920*boneFraction + 1000*(1-boneFraction);    % NIST bone density

% speed of sound
leung.c = 1320 + 0.75*leung.hu;
leung.c(boneFraction==1) = 1320 + 0.75*1/boneFracMultiplier;


if createFigFlag
    figure; plot(leung.rho, leung.atten);
    xlabel('Density (kg/m^3)'); ylabel('Attenuation (Np/cm)');
    grid on;
    ylim([0 4]);
    figName = 'Leung 2018 attenuation vs density';
    title(figName);
    figPath = fullfile('C:/Users/Steve/Downloads', figName);
    exportFig(gcf, figPath, '-transparent');
end