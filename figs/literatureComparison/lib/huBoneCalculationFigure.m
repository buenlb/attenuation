photonEnergyMassAttenuationCoefficient;

kvp = 80:10:180;
kvEff = kvp/2;
macBone = exp(polyval(bone.p, log(kvEff)));
macWater = exp(polyval(water.p, log(kvEff)));

rhoBone = 1920;
rhoWater = 1000;

muBone = macBone*rhoBone;
muWater = macWater*rhoWater;

hu = 1000*(muBone-muWater)./muWater;

figure; plot(kvEff, hu, '-o', 'linewidth', 1.5);
grid on;
xlabel('Effective photon energy (keV)');
ylabel('HU');


% convert HU from one kvp to another
photonEnergyMassAttenuationCoefficient;

rhoWater = 1000;    % kg/m^3

kvp1 = 80;
kvEff1 = kvp1/2;
macBone1 = exp(polyval(bone.p, log(kvEff1)));
macWater1 = exp(polyval(water.p, log(kvEff1)));
muWater1 = macWater1*rhoWater;

kvp2 = 120;
kvEff2 = kvp2/2;
macBone2 = exp(polyval(bone.p, log(kvEff2)));
macWater2 = exp(polyval(water.p, log(kvEff2)));
muWater2 = macWater2*rhoWater;

hu1 = -1000:10:4000;
rho = (hu1/1000*muWater1+muWater1)/macBone1;
hu2 = 1000*(macBone2*rho-muWater2)/muWater2;

figure; plot(hu1, rho);
grid on;
xlabel(sprintf('HU (%d kVp)', kvp1));
ylabel('Density (kg/m^3)');

figure; plot(hu1, hu2);
grid on;
xlabel(sprintf('HU (%d kVp)', kvp1));
ylabel(sprintf('HU (%d kVp)', kvp2));
