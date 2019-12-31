% create a figure of the histogram-based total attenuation vs clinical efficiency


%% setup
% load data
[~,~,attenRaw] = xlsread('C:\Users\Steve\Steve\Stanford\Labs\KBP lab\Projects\Beam simulation\Aim 1 - validation\Paper 1\totalAttenuation_1507442710_fbf232b.xlsx');

subjects = attenRaw(2:end,1);
totalAtten = cell2mat(attenRaw(2:end,2));
clinicalEff = cell2mat(attenRaw(2:end,5));

% % create a fit line for a subset of the data
% inds = [1,4,5,6,9];
% mdl = fitlm(clinicalEff(inds), totalAtten(inds));
% x = (0:0.005:0.1)';
% y = predict(mdl, x);


%% create figure
figure; hold on;
plot(clinicalEff, totalAtten, 'x');
% plot(x, y, '--', 'color', [1,1,1]*0.6);
xlim([0 0.1]);
ylim([0 16e5]);
grid on;
ylabel('Histogram-based total attenuation (Np/cm * vox)');
xlabel('Clinical efficiency (\DeltaT/power)');
alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
for i = 1:length(subjects)
    text(clinicalEff(i)+0.002, totalAtten(i), alphabet(i));
    % text(clinicalEff(i)+0.002, totalAtten(i), sprintf('Patient %d', i));
    % text(clinicalEff(i)+0.002, totalAtten(i), num2str(subjects{i}));
end
