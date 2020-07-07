function [acousticVelocity, density, attenuation, absorption, scattering, ...
    boneFraction, porosity] = mcdannold2020(huBinCenters, huBone, ctHdr, transducerFreq)
% McDannold 2020
% center frequency at 0.660 MHz
% TODO: implement attenuation scaling


% inputs:
% huBinCenters          HU
% huBone                HU
% ctHdr                 
% transducerFreq        Hz

% outputs:
% acousticVelocity      m/s
% density               kg/m^3
% attenuation           Np/cm
% absorption            Np/cm
% scattering            Np/cm
% boneFraction          fraction
% porosity              %


%% setup
disp('calculating acoustic properties');
% constants defined in paper
huAir = -1000;
huWater = 0;
warning off
attenT = readtable('mcdannold2020_attenuation_curve.csv');
acousticVelocityT = readtable('mcdannold2020_acoustic_velocity_curve.csv');
warning on
attenModel_x = attenT{:,1};                             % attenuation vs density
attenModel_y = attenT{:,2};
acousticVelocityModel_x = acousticVelocityT{:,1};       % acoustic velocity vs density
acousticVelocityModel_y = acousticVelocityT{:,2};


%% density
density = 1000*(1/(huWater-huAir)*huBinCenters + (-huAir/(huWater-huAir)));


%% acoustic velocity
acousticVelocity = interp1(acousticVelocityModel_x, acousticVelocityModel_y, density);
% there may be NaNs at both ends because extrapolation cannot be done. set the
% nan to be the closest valid value
nanIndsAcousticVelocity = find(isnan(acousticVelocity));
notNanIndsAcousticVelocity = find(~isnan(acousticVelocity));
for ind = 1:numel(nanIndsAcousticVelocity)
    [~, indClosest] = min(abs(nanIndsAcousticVelocity(ind)-notNanIndsAcousticVelocity));
    acousticVelocity(nanIndsAcousticVelocity(ind)) = acousticVelocity(notNanIndsAcousticVelocity(indClosest));
end


%% loss
% attenuation
attenuation = interp1(attenModel_x, attenModel_y, density);
% there may be NaNs at both ends because extrapolation cannot be done. set the
% nan to be the closest valid value
nanIndsAttenuation = find(isnan(attenuation));
notNanIndsAttenuation = find(~isnan(attenuation));
for ind = 1:numel(nanIndsAttenuation)
    [~, indClosest] = min(abs(nanIndsAttenuation(ind)-notNanIndsAttenuation));
    attenuation(nanIndsAttenuation(ind)) = attenuation(notNanIndsAttenuation(indClosest));
end


%% unused properties
absorption = zeros(size(attenuation));
scattering = zeros(size(attenuation));
boneFraction = zeros(size(huBinCenters));
porosity = zeros(size(huBinCenters));
