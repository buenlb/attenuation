%% Compare fits for each skull individually
close all; clc;
if ~exist('atten500','var')
    runAttenuation
end
%%
[~,~,~,fragsIdx500Layers,fragsIdx1000Layers,fragsIdx2250Layers,sk1,sk2] = screenFragments(FragData);
%%
sk1 = intersect(sk1,fragsIdx2250Layers);
sk2 = intersect(sk2,fragsIdx2250Layers);

%%
hu = zeros(length(FragData),length(FragData(1).CT.HU));
for ii = 1:length(FragData)
    hu(ii,:) = FragData(ii).CT.HU;
end
hu1 = (hu(sk1,:))';
hu2 = (hu(sk2,:))';
%% Perform Fits
y1 = atten2250(sk1,centerIdx2250);
[p1,r1,x1,y1,conf1] = fits(hu1,y1);
% y1 = y1(x1>min(hu1(:)) & x1<max(hu1(:)));
% conf1 = conf1(x1>min(hu1(:)) & x1<max(hu1(:)));
% x1 = x1(x1>min(hu1(:)) & x1<max(hu1(:)));

y2 = atten2250(sk2,centerIdx2250);
[p2,r2,x2,y2,conf2] = fits(hu2,y2);
% y2 = y2(x2>min(hu1(:)) & x2<max(hu1(:)));
% conf2 = conf2(x2>min(hu1(:)) & x2<max(hu1(:)));
% x2 = x2(x2>min(hu1(:)) & x2<max(hu1(:)));

%% Show the results
sk1Result = mean(p1);
sk2Result = mean(p2);
disp('Comparison of Skulls 1 and 2')
disp(['  Average Slope:          Sk1: ', num2str(sk1Result(1)), ',    Sk2: , ' num2str(sk2Result(1))])
disp(['  Average Y-Intercept:    Sk1: ', num2str(sk1Result(2)), ',    Sk2: , ' num2str(sk2Result(2))])

%% Plot 95% Confidence Intervals
h = figure;
ctIdx = find(strcmp(CtData.kernels,'Bone') & CtData.energies==120 & strcmp(CtData.vendor,'GE') & strcmp(CtData.reconMethod,'DE'));
ax = gca;
shadedErrorBar(x1(ctIdx,:),y1(ctIdx,:),conf1(ctIdx,:),'lineProps',{'-','Color',ax.ColorOrder(1,:)})
hold on
shadedErrorBar(x2(ctIdx,:),y2(ctIdx,:),conf1(ctIdx,:),'lineProps',{'-','Color',ax.ColorOrder(2,:)})
axis([200,1000,0,35])
xlabel('HU')
ylabel('Attenuation (Np/cm)')
title('Dual Energy (120 keV) Bone Kernel')
makeFigureBig(h)