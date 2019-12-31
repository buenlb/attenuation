%% load data
subject = '43214';
simSetupPath = fullfile('M:\SCRATCH\1525629021_e289390\simSetup', subject);

fileName = sprintf('%s tissueProperties Vyas2016.mat', subject);
filePath = fullfile(simSetupPath, fileName);
data = load(filePath);


%% create figures
% acoustic velocity and density figure
figure;
subplot(2,1,1); plot(data.huBinCenters, data.props.c(4:end), 'k', 'linewidth', 1.5);
grid on;
xlim([0, 2000]);
ylim([1000, 3000]);
ylabel('m/s');
title('Acoustic velocity');
subplot(2,1,2); plot(data.huBinCenters, data.props.rho(4:end), 'k', 'linewidth', 1.5);
grid on;
xlim([0, 2000]);
ylim([1000, 3000]);
ylabel('kg/m^3');
xlabel('HU');
title('Density');

% attenuation figure
figure; plot(data.huBinCenters, data.props.attenuation(4:end), 'k', 'linewidth', 1.5);
grid on;
xlim([0, 2000]);
ylim([0, 4]);
ylabel('Np/cm');
xlabel('HU');
title('Attenuation');
