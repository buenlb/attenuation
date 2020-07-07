% Response to Steve's e-mail about scaling attenuation curves

% Plots attenuation as a function of HU
close all; clc;
if ~exist('atten500','var')
    runAttenuation
end
%% Use only the thick enough fragments
[~,~,~,fragsIdx500Layers,fragsIdx1000Layers,fragsIdx2250Layers] = screenFragments(FragData);
%% Plot all the fragments vs HU
ctIdx = find(strcmp(CtData.kernels,'Bone') & CtData.energies==120 & strcmp(CtData.vendor,'GE') & strcmp(CtData.reconMethod,'Standard'));
ctIdx = ctIdx(1);
hu = zeros(size(FragData'));
for ii = 1:length(FragData)
    hu(ii) = FragData(ii).CT.HU(ctIdx);
end

%% Create curves
% 500 kHz
x500 = hu(fragsIdx500Layers);
y500 = atten500(fragsIdx500Layers,centerIdx500);
std500 = stdAtten500(fragsIdx500Layers,centerIdx500);
[p500Layers,r500Layers,~,x2_500,y2_500,conf500] = myPolyFit(x500,y500,'poly',1);

% 1000 kHz
x1000 = hu(fragsIdx1000Layers);
y1000 = atten1000(fragsIdx1000Layers,centerIdx1000);
x1000 = x1000(~isnan(y1000));
y1000 = y1000(~isnan(y1000));
std1000 = stdAtten1000(fragsIdx1000Layers,centerIdx1000);
[p1000Layers,r1000Layers,~,x2_1000,y2_1000,conf1000] = myPolyFit(x1000,y1000,'poly',1);

% 2250 kHz
x2250 = hu(fragsIdx2250Layers);
y2250 = atten2250(fragsIdx2250Layers,centerIdx2250);
std2250 = stdAtten2250(fragsIdx2250Layers,centerIdx2250);
[p2250Layers,r2250Layers,~,x2_2250,y2_2250,conf2250] = myPolyFit(x2250,y2250,'poly',1);

%% Try to scale curves
% Original Curves
figure(1)
clf;
hold on
ax = gca;
plot(x2_500,y2_500,x2_1000,y2_1000,x2_2250,y2_2250,'linewidth',2)

% Scale to 1MHz
y2_500Scaled = y2_500*0.5^(-1);
y2_2250Scaled = y2_2250*2.25^(-1.2);

y2_2250ScaledMed = y2_2250*2.25^(-1.3);

figure(1)
ax.ColorOrderIndex = 1;
plot(x2_500,y2_500Scaled,'--','linewidth',2);
ax.ColorOrderIndex = 3;
plot(x2_2250,y2_2250Scaled,'--','linewidth',2)
legend('500','1000','2250','500Scaled','2250Scaled')
axis([min(x2250),max(x2250),0,max(y2250)+max(std2250/2)])
grid on
xlabel('HU')
ylabel('\alpha')
makeFigureBig(1)
title('Scaling to 1 MHz')