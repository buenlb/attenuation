% a = 1;
% eccentricity = [0:0.2:0.8, 0.9:0.05:1];
% b = sqrt((1-eccentricity.^2)*a.^2);
% phi = linspace(0,2*pi,50);
% cosphi = cos(phi);
% sinphi = sin(phi);
% x = a*cosphi;
% y = b'*sinphi;
% figure; plot(x, y);
% axis equal
% legend(strsplit(num2str(eccentricity)));


eccentricities = [0, 0.5:0.05:0.95, 1]';
ellipses = cell(size(eccentricities));

[xGrid, yGrid] = meshgrid(-1:0.01:1, 0-1:0.01:1);
a = 1;
b = sqrt((1-eccentricities.^2)*a.^2);
for i = 1:length(eccentricities)
    tmp = xGrid.^2./a^2 + yGrid.^2./b(i)^2;
    tmp(isnan(tmp)) = 1;
    ellipses{i} = tmp <= 1;
end


[roundness, eccentricity, solidity] = deal(zeros(size(ellipses)));
axisLengthRatio = zeros(size(ellipses));
for ellipseNum = 1:length(ellipses)
    ellipseResized = imresize(ellipses{ellipseNum}, 1, 'nearest');
    props = regionprops(ellipseResized, 'area', 'perimeter', 'eccentricity', ...
        'solidity', 'MajorAxisLength', 'MinorAxisLength');
    roundness(ellipseNum) = (4*pi*props.Area)/(props.Perimeter^2);
    eccentricity(ellipseNum) = props.Eccentricity;
    solidity(ellipseNum) = props.Solidity;
    axisLengthRatio(ellipseNum) = props.MinorAxisLength / props.MajorAxisLength;
    % ellipse = ellipses{ellipseNum};
    % props = regionprops(ellipse, 'area', 'perimeter', 'eccentricity', 'solidity');
    eccentricity(ellipseNum) = props.Eccentricity;
end

figure; 
for ellipseNum = 1:length(ellipses)
    subplot(3,4,ellipseNum); imagesc(ellipses{ellipseNum});
    axis square;
    title(sprintf('Eccen = %0.2f', eccentricity(ellipseNum)));
end

figure; 
for ellipseNum = 1:length(ellipses)
    subplot(3,4,ellipseNum); imagesc(ellipses{ellipseNum});
    axis square;
    title(sprintf('Round = %0.2f', roundness(ellipseNum)));
end

figure;
for ellipseNum = 1:length(ellipses)
    subplot(3,4,ellipseNum); imagesc(ellipses{ellipseNum}, [0,1]); 
    axis square;
    title(sprintf('axisRatio = %0.2f', axisLengthRatio(ellipseNum)));
end




steveRoundness = 1-(10.^eccentricity/10);
figure; 
for ellipseNum = 1:length(ellipses)
    subplot(3,4,ellipseNum); imagesc(ellipses{ellipseNum});
    axis square;
    title(sprintf('SRound = %0.2f', steveRoundness(ellipseNum)));
end


metric2 = steveRoundness./axisLengthRatio;
figure; 
for ellipseNum = 1:length(ellipses)
    subplot(3,4,ellipseNum); imagesc(ellipses{ellipseNum});
    axis square;
    title(sprintf('SR/aRatio = %0.2f', metric2(ellipseNum)));
end









metric2 = roundness.*steveRoundness;
figure; 
for ellipseNum = 1:length(ellipses)
    subplot(3,4,ellipseNum); imagesc(ellipses{ellipseNum});
    axis square;
    title(sprintf('Round*SR = %0.2f', metric2(ellipseNum)));
end

metric2 = (1-eccentricity).*steveRoundness;
figure; 
for ellipseNum = 1:length(ellipses)
    subplot(3,4,ellipseNum); imagesc(ellipses{ellipseNum});
    axis square;
    title(sprintf('(1-Ecc)*SR = %0.2f', metric2(ellipseNum)));
end

