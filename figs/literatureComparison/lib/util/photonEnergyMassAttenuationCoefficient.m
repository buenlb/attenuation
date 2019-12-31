% photon energy and mass attenuation coefficient

% mass attenuation coefficient units: m^2/kg

energyBounds = [20,300];
energies = energyBounds(1):5:energyBounds(2);

%% bone
bone.energy = [1, 1.03542, 1.0721, 1.0721, 1.18283, 1.305, 1.305, 1.5, 2, 2.1455, 2.1455, 2.30297, 2.472, 2.472, 3, 4, 4.0381, 4.0381, 5, 6, 8, 10, 15, 20, 30, 40, 50, 60, 80, 100, 150, 200, 300, 400, 500, 600, 800, 1000, 1250, 1500, 2000, 3000, 4000, 5000, 6000, 8000, 10000, 15000, 20000];
bone.mac = [378.1, 345.2, 315, 315.6, 243.4, 187.3, 188.3, 129.5, 58.69, 48.24, 71.14, 59.16, 49.07, 49.62, 29.58, 13.31, 12.96, 33.32, 19.17, 11.71, 5.323, 2.851, 0.9032, 0.4001, 0.1331, 0.06655, 0.04242, 0.03148, 0.02229, 0.01855, 0.0148, 0.01309, 0.01113, 0.009908, 0.009022, 0.008332, 0.007308, 0.006566, 0.005871, 0.005346, 0.004607, 0.003745, 0.003257, 0.002946, 0.002734, 0.002467, 0.002314, 0.002132, 0.002068];

inds = energyBounds(1)<bone.energy & bone.energy<energyBounds(2);
bone.p = polyfit(log(bone.energy(inds)), log(bone.mac(inds)), 4);

% figure; loglog(bone.energy, bone.mac);
% hold on;
% plot(energies, exp(polyval(bone.p, log(energies))));
% xlabel('photon energy (keV)'); ylabel('\mu/\rho');
% title('cortical bone (ICRU-44)');
% grid on;


%% water
water.energy = [1, 1.5, 2, 3, 4, 5, 6, 8, 10, 15, 20, 30, 40, 50, 60, 80, 100, 150, 200, 300, 400, 500, 600, 800, 1000, 1250, 1500, 2000, 3000, 4000, 5000, 6000, 8000, 10000, 15000, 20000];
water.mac = [407.8, 137.6, 61.73, 19.29, 8.278, 4.258, 2.464, 1.037, 0.5329, 0.1673, 0.08096, 0.03756, 0.02683, 0.02269, 0.02059, 0.01837, 0.01707, 0.01505, 0.0137, 0.01186, 0.01061, 0.009687, 0.008956, 0.007865, 0.007072, 0.006323, 0.005754, 0.004942, 0.003969, 0.003403, 0.003031, 0.00277, 0.002429, 0.002219, 0.001941, 0.001813];

inds = energyBounds(1)<water.energy & water.energy<energyBounds(2);
water.p = polyfit(log(water.energy(inds)), log(water.mac(inds)), 3);

% % figure; loglog(water.energy, water.mac);
% % hold on;
% % plot(energies, exp(polyval(water.p, log(energies))));
% % xlabel('photon energy (keV)'); ylabel('\mu/\rho');
% % title('liquid water');
% % grid on;

% figure; loglog(bone.energy, bone.mac, 'displayname', 'cortical bone');
% hold on;
% loglog(water.energy, water.mac, 'displayname', 'water');
% hbf = plot(energies, exp(polyval(bone.p, log(energies))));
% hwf = plot(energies, exp(polyval(water.p, log(energies))));
% set(get(get(hbf,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
% set(get(get(hwf,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
% xlabel('photon energy (keV)'); ylabel('\mu/\rho (m^2/kg)');
% title('\mu/\rho vs keV');
% grid on;
% legend('show', 'location', 'northeast');
