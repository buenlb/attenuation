% create figures to show the shape of ellipses with different eccentricities


%% several ellipses on one plot
eccentricities = [0, 0.7, 0.9, 1]';
a = 1;
b = sqrt((1-eccentricities.^2)*a.^2);

phi = linspace(0,2*pi,50);
cosphi = cos(phi);
sinphi = sin(phi);
x = a*cosphi;
y = b*sinphi;
figure; plot(x, y);
axis equal;
h = legend(cellfun(@num2str, mat2cell(eccentricities, length(eccentricities), 1), 'uniformoutput', false));
% title(h, 'Eccentricity');
grid on;
xlabel('x (mm)'); ylabel('y (mm)');
xlim([-1, 1]); ylim([-1, 1]);
set(gca, 'xtick', [-1:0.2:1]);


%% subplots of different eccentricities
eccentricities = [0:0.1:1]';
ellipses = cell(size(eccentricities));

[xGrid, yGrid] = meshgrid(-1:0.01:1, -1:0.01:1);
a = 1;
b = sqrt((1-eccentricities.^2)*a.^2);
for i = 1:length(eccentricities)
    tmp = xGrid.^2./a^2 + yGrid.^2./b(i)^2;
    tmp(isnan(tmp)) = 1;
    ellipses{i} = tmp <= 1;
end

figure;
for i = 1:length(eccentricities)
    subplot(3,4,i); 
    phi = linspace(0,2*pi,50);
    cosphi = cos(phi);
    sinphi = sin(phi);
    x = a*cosphi;
    y = b(i)*sinphi;
    plot(x, y);
    grid on;
    axis equal;
    xlim([-1,1]); ylim([-1,1]);
    set(gca, 'xticklabel', '');
    set(gca, 'yticklabel', '');
    title(sprintf('Eccentricity %0.1f', eccentricities(i)));
end

