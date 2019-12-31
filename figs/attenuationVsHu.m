% Plots attenuation as a function of HU
close all; clc;
if ~exist('atten500','var')
    runAttenuation
end
%% Use only the thick enough fragments
[fragsIdx500,fragsIdx1000,fragsIdx2250,fragsIdx500Layers,fragsIdx1000Layers,fragsIdx2250Layers] = screenFragments(FragData);
%% Plot all the fragments vs HU
ctIdx = find(strcmp(CtData.kernels,'Soft Tissue') & CtData.energies==120 & strcmp(CtData.vendor,'GE') & strcmp(CtData.reconMethod,'MBIR'));
ctIdx = ctIdx(1);
hu = zeros(size(FragData'));
for ii = 1:length(FragData)
    hu(ii) = FragData(ii).CT.HU(ctIdx);
end
% 500 kHz
x500 = hu(fragsIdx500);
y500 = atten500(fragsIdx500,centerIdx500);
std500 = stdAtten500(fragsIdx500,centerIdx500);
[p500,r500,~,x2_500,y2_500] = myPolyFit(x500,y500,'poly',1);

x1000 = hu(fragsIdx1000);
y1000 = atten1000(fragsIdx1000,centerIdx1000);
x1000 = x1000(~isnan(y1000));
y1000 = y1000(~isnan(y1000));
std1000 = stdAtten1000(fragsIdx1000,centerIdx1000);
[p1000,r1000,~,x2_1000,y2_1000] = myPolyFit(x1000,y1000,'poly',1);

x2250 = hu(fragsIdx2250);
y2250 = atten2250(fragsIdx2250,centerIdx2250);
std2250 = stdAtten2250(fragsIdx2250,centerIdx2250);
[p2250,r2250,~,x2_2250,y2_2250] = myPolyFit(x2250,y2250,'poly',1);

%% Compare With and Without fragments from an unknown layer
% Get results that exclude unknown fragments
% 500 kHz
x500 = hu(fragsIdx500Layers);
y500 = atten500(fragsIdx500Layers,centerIdx500);
std500 = stdAtten500(fragsIdx500Layers,centerIdx500);
[p500Layers,r500Layers,~,x2_500Layers,y2_500Layers,conf500Layers] = myPolyFit(x500,y500,'poly',1);

x1000 = hu(fragsIdx1000Layers);
y1000 = atten1000(fragsIdx1000Layers,centerIdx1000);
x1000 = x1000(~isnan(y1000));
y1000 = y1000(~isnan(y1000));
std1000 = stdAtten1000(fragsIdx1000Layers,centerIdx1000);
[p1000Layers,r1000Layers,~,x2_1000Layers,y2_1000Layers,conf1000Layers] = myPolyFit(x1000,y1000,'poly',1);

x2250 = hu(fragsIdx2250Layers);
y2250 = atten2250(fragsIdx2250Layers,centerIdx2250);
std2250 = stdAtten2250(fragsIdx2250Layers,centerIdx2250);
[p2250Layers,r2250Layers,~,x2_2250Layers,y2_2250Layers,conf2250Layers] = myPolyFit(x2250,y2250,'poly',1);

% Compare R-squared Values
disp('           -----------------------------Results-----------------------------')
disp('                      --Including Unknowns--        --Excluding--')
disp('500 kHz')
disp(['  R^2                           ', num2str(mean(r500),2), '                       ', num2str(mean(r500Layers),2)])
disp('1000 kHz')
disp(['  R^2                           ', num2str(mean(r1000),2), '                       ', num2str(mean(r1000Layers),2)])
disp('2250 kHz')
disp(['  R^2                           ', num2str(mean(r2250),2), '                       ', num2str(mean(r2250Layers),2)])

% Plote the comparison
h = figure;
plot(x2_500,y2_500,x2_1000,y2_1000,x2_2250,y2_2250,'linewidth',2)
ax = gca;
ax.ColorOrderIndex = 1;
hold on
plot(x2_500Layers,y2_500Layers,'--',x2_1000Layers,y2_1000Layers,'--',x2_2250Layers,y2_2250Layers,'--','linewidth',2)
grid on
xlabel('HU')
ylabel('Attenuation (np/cm)')
axis([min(x2250),max(x2250),0,max(y2250)])
title('Comparing Without Unknown Fragments')
makeFigureBig(h)
keyboard
%% Plot vs HU
h = figure;
hold on
ax = gca;
shadedErrorBar(x2_500Layers,y2_500Layers,conf500Layers,'lineprops',{'--','color',ax.ColorOrder(1,:),'linewidth',2});
plt500 = errorbar(x500,y500,std500/2,'o','linewidth',2,'markersize',8,'Color',ax.ColorOrder(1,:));
shadedErrorBar(x2_1000Layers,y2_1000Layers,conf1000Layers,'lineprops',{'--','color',ax.ColorOrder(2,:),'linewidth',2 });
plt1000 = errorbar(x1000,y1000,std1000/2,'o','linewidth',2,'markersize',8,'Color',ax.ColorOrder(2,:));
shadedErrorBar(x2_2250Layers,y2_2250Layers,conf2250Layers,'lineprops',{'--','color',ax.ColorOrder(3,:),'linewidth',2 });
plt2250 = errorbar(x2250,y2250,std2250/2,'o','linewidth',2,'markersize',8,'Color',ax.ColorOrder(3,:));
xlabel('HU')
ylabel('Attenuation (Np/cm)')
grid on
lgd = legend([plt500(1),plt1000(1),plt2250(1)],['R^2=', num2str(r500Layers,2)],['R^2=', num2str(r1000Layers,2)],['R^2=', num2str(r2250Layers,2)]);
% set(lgd,'position',[ 0.6256    0.6270    0.3000    0.2476]);
axis([min(x2250),max(x2250),0,max(y2250)+max(std2250/2)])
makeFigureBig(h)

if exist('imgPath','var')
    print([imgPath, 'figs/ctVatten'], '-depsc')
end
keyboard
%% Include 2_120M in the fits
% 500 kHz
[~,~,~,fragsIdx500_120,fragsIdx1000_120,fragsIdx2250_120] = screenFragments(FragData,1);
x500_120 = hu(fragsIdx500_120);
y500_120 = atten500(fragsIdx500_120,centerIdx500);
std500_120 = stdAtten500(fragsIdx500_120,centerIdx500);
[p500_120,r500_120,~,x2_500_120,y2_500_120] = myPolyFit(x500_120,y500_120,'poly',1);

x1000_120 = hu(fragsIdx1000_120);
y1000_120 = atten1000(fragsIdx1000_120,centerIdx1000);
std1000_120 = stdAtten1000(fragsIdx1000_120,centerIdx1000);
[p1000_120,r1000_120,~,x2_1000_120,y2_1000_120] = myPolyFit(x1000_120,y1000_120,'poly',1);

x2250_120 = hu(fragsIdx2250_120);
y2250_120 = atten2250(fragsIdx2250_120,centerIdx2250);
std2250_120 = stdAtten2250(fragsIdx2250_120,centerIdx2250);
[p2250_120,r2250_120,~,x2_2250_120,y2_2250_120] =myPolyFit(x2250_120,y2250_120,'poly',1);

%% Plot vs HU
h = figure;
hold on
ax = gca;
plt500 = errorbar(x500_120,y500_120,std500_120/2,'o','linewidth',2,'markersize',8);
plot(x2_500_120,y2_500_120,'--','linewidth',2,'markersize',8,'Color',ax.ColorOrder(1,:));
plt1000 = errorbar(x1000_120,y1000_120,std1000_120/2,'o','linewidth',2,'markersize',8,'Color',ax.ColorOrder(2,:));
plot(x2_1000_120,y2_1000_120,'--','linewidth',2,'markersize',8,'Color',ax.ColorOrder(2,:));
plt2250 = errorbar(x2250_120,y2250_120,std2250_120/2,'o','linewidth',2,'markersize',8,'Color',ax.ColorOrder(3,:));
plot(x2_2250_120,y2_2250_120,'--','linewidth',2,'markersize',8,'Color',ax.ColorOrder(3,:));
xlabel('HU')
ylabel('Attenuation (Np/cm)')
grid on
lgd = legend([plt500(1),plt1000(1),plt2250(1)],['R^2=', num2str(r500_120,2)],['R^2=', num2str(r1000_120,2)],['R^2=', num2str(r2250_120,2)]);
% set(lgd,'position',[ 0.6256    0.6270    0.3000    0.2476]);
axis([min(x2250),max(x2250),0,max(y2250)+max(std2250/2)])
makeFigureBig(h)

if exist('imgPath','var')
    print([imgPath, 'figs/ctVattenW120M'], '-depsc')
end

%% cortical vs medullary
[ot,med,it,uk] = fragmentLayers(FragData);
cort = [ot,it];
cort2250 = intersect(cort,fragsIdx2250Layers);
x2250Cort = hu(cort2250);
y2250Cort = atten2250(cort2250,centerIdx2250);
std2250 = stdAtten2250(cort2250,centerIdx2250);
[pCort2250,rCort2250,~,x2_cort2250,y2_cort2250,confCort] = myPolyFit(x2250Cort,y2250Cort,'poly',1);

med2250 = intersect(med,fragsIdx2250Layers);
x2250Med = hu(med2250);
y2250Med = atten2250(med2250,centerIdx2250);
std2250 = stdAtten2250(med2250,centerIdx2250);
[pMed2250,rMed2250,~,x2_med2250,y2_med2250,confMed] = myPolyFit(x2250Med,y2250Med,'poly',1);

h = figure;
ax = gca;
shadedErrorBar(x2_cort2250,y2_cort2250,confCort,'lineprops',{'--','color',ax.ColorOrder(1,:),'linewidth',2 });
hold on
shadedErrorBar(x2_med2250,y2_med2250,confMed,'lineprops',{'--','color',ax.ColorOrder(2,:),'linewidth',2 });
ax.ColorOrderIndex = 1;
hold on
plot(x2250Cort,y2250Cort,'^',x2250Med,y2250Med,'o','linewidth',2,'markersize',8)
xlabel('HU')
ylabel('attenuation (Np/cm)')
grid on
legend('Cortical', 'Medullary','location','NorthEast')
makeFigureBig(h)
axis([min(x2250),max(x2250),0,max(y2250Med)+max(std2250/2)])