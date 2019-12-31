% create a figure of the transducer


%% setup
addpath(genpath('M:\HAS-simulations\lib'));
addpath('M:\HAS-simulations\steve');
addpath('M:\HAS-simulations\inSightec\headTx');

% load data
[us2usPlateTforms, plateElemLocsRot, plateElemLocs, plateElemAreas, plateElemInds] = generateERFAInputs;


%% create figure
figure;
hold on
for i = 1:7
    h = scatter3(plateElemLocs{i}(:,1)*1e3, plateElemLocs{i}(:,2)*1e3, plateElemLocs{i}(:,3)*1e3, 'o');
    set(h, 'displayname', sprintf('plate %d', i));
end
axis equal;
grid on;
view(-37.5, 30);
legend show
xlim([-150 150]); ylim([-150 150]);
xlabel('R (mm)'); ylabel('A (mm)'); zlabel('S (mm)');
set(gca, 'xtick', -100:50:100, 'ytick', -100:50:100);
set(gca, 'xtick', -150:50:150, 'ytick', -150:50:150);
