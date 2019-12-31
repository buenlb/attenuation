function pinton = bonePropertiesPinton2011(createFigFlag)
% Pinton 2011
% center frequency at 1 MHz

kvp = 120;
kvEff = kvp/2;
photonEnergyMassAttenuationCoefficient;
macBone = exp(polyval(bone.p, log(kvEff)));
macWater = exp(polyval(water.p, log(kvEff)));

% constants defined in paper
rhoBone = 2200;
rhoWater = 1000;
cMin = 1540;
cMax = 2900;

%
muBone = macBone*rhoBone;
muWater = macWater*rhoWater;

% acoustic property relationships are referenced from Aubry 2003
pinton.au = 0:0.01:1000;
pinton.hu = pinton.au * (muBone-muWater)/muWater;

pinton.kvp = kvp;
pinton.porosity = 1-pinton.au/1000;
pinton.rho = rhoWater*pinton.porosity + rhoBone*(1-pinton.porosity);
pinton.c = cMin + (cMax-cMin)*(1-pinton.porosity);

% attenuation at 1.5 MHz (Aubry 2003)
attenMin = 0.2*10/8.686;    % Np/cm
attenMax = 8*10/8.686;      % Np/cm
% attenuation at 0.68 MHz (assuming power law of 1)
freq = 0.68e6;
attenMin = 0.2*10/8.686/1.5e6*freq;   % Np/cm
attenMax = 8*10/8.686/1.5e6*freq;     % Np/cm
pinton.atten = attenMin + (attenMax-attenMin)*pinton.porosity.^3;

