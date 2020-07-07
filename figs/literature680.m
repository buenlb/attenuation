close all;
if ~exist('atten500','var')
    runAttenuation
end
addpath('figs\acousticPropertiesAcrossStudies\')
addpath('figs\literatureComparison\lib\util\')

ctIdx = find(strcmp(CtData.kernels,'Bone') & CtData.energies==120 & strcmp(CtData.vendor,'GE') & strcmp(CtData.reconMethod,'Standard'));
hu = zeros(size(FragData));
for ii = 1:length(FragData)
    hu(ii) = FragData(ii).CT.HU(ctIdx);
end

[~,~,~,fragsIdx500Layers,fragsIdx1000Layers,fragsIdx2250Layers] = screenFragments(FragData);

beta1 = 1.1;
beta2 = 1.1;
beta3 = 1.1;

%% 680 kHz

curFreq = 0.65;

f1 = figure; hold on
f1.Units = 'inches';
f1.InvertHardcopy = 'off';
f1.PaperPositionMode = 'auto';
ax = gca;

[~,centerIdx650] = min(abs(f500-0.65));
[~,centerIdx650_1000] = min(abs(f1000-0.65));

% 650 kHz Data including from 0.5 MHz transducer
x = linspace(500,2.5e3,1e3);
% y650 = [atten500(fragsIdx500Layers,centerIdx650); mean([atten1000(fragsIdx500Layers,centerIdx650_1000),atten1000(fragsIdx500Layers,centerIdx650_1000+1)],2)];
y650 = atten500(fragsIdx500Layers,centerIdx650);
% [p650,r650,~,x2_650,y2_650,conf] = myPolyFit([hu(fragsIdx500Layers),hu(fragsIdx500Layers)],y650','poly',1);
[p650,r650_500,~,x2_650,y2_650,conf] = myPolyFit(hu(fragsIdx500Layers),y650','poly',1);
y = p650(1)*x+p650(2);
% y2_650(y2_650<minAtten650) = minAtten650;
% conf(y2_650<=minAtten650) = 0;
shadedErrorBar(x2_650,y2_650,conf,'lineprops',{'--','linewidth',3,'displayname','650 kHz Data (0.5 MHz Tx)'})
ax.ColorOrderIndex = 2;

% 650 kHz Data including from 1 MHz transducer
x = linspace(500,2.5e3,1e3);
% y650 = [atten500(fragsIdx500Layers,centerIdx650); mean([atten1000(fragsIdx500Layers,centerIdx650_1000),atten1000(fragsIdx500Layers,centerIdx650_1000+1)],2)];
y650 = atten1000(fragsIdx1000Layers,centerIdx650_1000);
% [p650,r650,~,x2_650,y2_650,conf] = myPolyFit([hu(fragsIdx500Layers),hu(fragsIdx500Layers)],y650','poly',1);
[p650,r650_1000,~,x2_650,y2_650,conf] = myPolyFit(hu(fragsIdx1000Layers),y650','poly',1);
y = p650(1)*x+p650(2);
% y2_650(y2_650<minAtten650) = minAtten650;
% conf(y2_650<=minAtten650) = 0;
shadedErrorBar(x2_650,y2_650,conf,'lineprops',{'--','linewidth',3,'displayname','650 kHz Data (1 MHz Tx)'})
ax.ColorOrderIndex = 3;

% Scaled 2250 kHz Data
y2250 = atten2250(fragsIdx2250Layers,centerIdx2250);
[p2250,r2250,~,x2,y2,conf] = myPolyFit(hu(fragsIdx2250Layers),(curFreq/2.25)^beta1*y2250','poly',1);
% y2(y2<minAtten) = minAtten;
% plot(x2,y2*(curFreq/2.25)^beta1,'--','linewidth',3, 'displayname', 'Scaled fit to 2.25 MHz data')
shadedErrorBar(x2,y2,conf,'lineprops',{'--','linewidth',3,'displayname','Scaled 2.25 MHz data'})
ax.ColorOrderIndex = 4;

% Literature Values
leung = bonePropertiesLeung2018(false,.680,beta2);

vyas = bonePropertiesVyas2016(false,0.68,beta2);

pulkkinen = bonePropertiesPulkkinen2014(false,curFreq,beta2,836);

aubry = bonePropertiesAubry2003(false,curFreq,beta1,1/2*CtData.energies(ctIdx));

ctHdr.Manufacturer = 'siemens';
ctHdr.ConvolutionKernel = 'H60s';
ctHdr.KVP = 120;
mcdannold.hu = 230:10:2500;
[~,~,tmpAtten] = mcdannold2020(mcdannold.hu, 2000, ctHdr, 0.66e6);
mcdannold.atten = tmpAtten;

% Put it all together
plot(aubry.hu, aubry.atten, 'linewidth', 2, 'displayname', 'Aubry 2003 (1 MHz)');
plot(leung.hu(6:end), leung.atten(6:end), 'linewidth', 2, 'displayname', 'Leung 2019 (600 kHz)');
plot(pulkkinen.hu, pulkkinen.atten, 'linewidth', 2, 'displayname', 'Pichardo 2011 (836 kHz)');
plot(vyas.hu(6:end), vyas.atten(6:end), 'linewidth', 2, 'displayname', 'Vyas 2016 (600 kHz)');
plot(mcdannold.hu, mcdannold.atten, 'k','linewidth', 2, 'displayname', 'McDannold 2019 (680 kHz)');
hold off;
makeFigureBig(f1,24,24)
lgd = legend('show', 'location', 'northeast');
xlim([0, 2000]);
ylim([0, 8]);
grid on;
xlabel('HU'); ylabel('\alpha (Np/cm)');
set(f1,'Position',[ 6.8333    2.4271    8.8647    7.3958]);
set(lgd,'position',[0.4276    0.5563    0.5591    0.4171]);
drawnow
if exist('imgPath','var')
    print([imgPath, '/figs/ctVatten650Lit'], '-depsc')
end

%% 3D Fit
setUpDataForFit

h = figure;
h.Units = 'inches';
h.InvertHardcopy = 'off';
h.PaperPositionMode = 'auto';
hold on
ax = gca;

% 650 kHz Data including from 0.5 MHz transducer
x = linspace(500,2.5e3,1e3);
% y650 = [atten500(fragsIdx500Layers,centerIdx650); mean([atten1000(fragsIdx500Layers,centerIdx650_1000),atten1000(fragsIdx500Layers,centerIdx650_1000+1)],2)];
y650 = atten500(fragsIdx500Layers,centerIdx650);
% [p650,r650,~,x2_650,y2_650,conf] = myPolyFit([hu(fragsIdx500Layers),hu(fragsIdx500Layers)],y650','poly',1);
[p650,r650_500,~,x2_650,y2_650,conf] = myPolyFit(hu(fragsIdx500Layers),y650','poly',1);
y = p650(1)*x+p650(2);
% y2_650(y2_650<minAtten650) = minAtten650;
% conf(y2_650<=minAtten650) = 0;
shadedErrorBar(x2_650,y2_650,conf,'lineprops',{'--','linewidth',3,'displayname','This study, single linear fit'})
ax.ColorOrderIndex = 2;


[~,idx650] = min(abs(yHat-curFreq));
clear confInterval
for ii = 1:length(xHat)
    confInterval(ii,:) = predint(simultaneousFit,[xHat(ii),curFreq],0.95,'functional');
end

confInterval(:,1) = zHat(idx650,:)-confInterval(:,1).';
confInterval(:,2) = -zHat(idx650,:)+confInterval(:,2).';    
confInterval(xHat>(-simultaneousFit.x1-simultaneousFit.xy*curFreq)./(2*simultaneousFit.x2),:) = 0;

shadedErrorBar(xHat,zHat(idx650,:),confInterval,'lineprops',{'--','linewidth',3,'displayname','This Study'});
ax.ColorOrderIndex = 2;
plot(hu(fragsIdx500Layers),atten500(fragsIdx500Layers,center650),'*','displayName','Measured Attenuation')
plot(aubry.hu, aubry.atten, 'linewidth', 2, 'displayname', 'Aubry 2003 (1 MHz)');
plot(leung.hu(6:end), leung.atten(6:end), 'linewidth', 2, 'displayname', 'Leung 2019 (600 kHz)');
plot(pulkkinen.hu, pulkkinen.atten, 'linewidth', 2, 'displayname', 'Pichardo 2011 (836 kHz)');
plot(vyas.hu(6:end), vyas.atten(6:end), 'linewidth', 2, 'displayname', 'Vyas 2016 (600 kHz)');
plot(mcdannold.hu, mcdannold.atten, 'k','linewidth', 2, 'displayname', 'McDannold 2019 (680 kHz)');
hold off;
makeFigureBig(h,24,24)
lgd = legend('show', 'location', 'northeast');
xlim([0, 2000]);
ylim([0, 8]);
grid on;
xlabel('HU'); ylabel('\alpha (Np/cm)');
set(h,'Position',[ 6.8333    2.4271    8.8647    7.3958]);
set(lgd,'position',[0.4276    0.5563    0.5591    0.4171]);
drawnow
return
%% Separate out scaled vs not scaled results: Not scaled
f1 = figure; hold on
f1.Units = 'inches';
f1.InvertHardcopy = 'off';
f1.PaperPositionMode = 'auto';
ax = gca;

[~,centerIdx650] = min(abs(f500-0.65));
[~,centerIdx650_1000] = min(abs(f1000-0.65));

% 650 kHz Data including from 1 MHz transducer
x = linspace(500,2.5e3,1e3);
y650_1000 = atten1000(fragsIdx500Layers,centerIdx650_1000);
[p650,r650,~,x2_650,y2_650,conf] = myPolyFit(hu(fragsIdx500Layers),y650','poly',1);
y = p650(1)*x+p650(2);
% y2_650(y2_650<minAtten650) = minAtten650;
% conf(y2_650<=minAtten650) = 0;
shadedErrorBar(x2_650,y2_650,conf,'lineprops',{'--','linewidth',3,'displayname','This study'})
ax.ColorOrderIndex = 2;

% Literature Values
leung = bonePropertiesLeung2018(false,.680,beta2);

ctHdr.Manufacturer = 'siemens';
ctHdr.ConvolutionKernel = 'H60s';
ctHdr.KVP = 120;
mcdannold.hu = 0:10:2500;
[~,~,tmpAtten] = mcdannold2020(mcdannold.hu, 2000, ctHdr, 0.66e6);
mcdannold.atten = tmpAtten;

% Put it all together
plot(leung.hu(6:end), leung.atten(6:end), 'linewidth', 2, 'displayname', 'Leung 2019');
plot(mcdannold.hu, mcdannold.atten, 'linewidth', 2, 'displayname', 'McDannold  2020');
hold off;
makeFigureBig(f1,24,24)
lgd = legend('show', 'location', 'northeast');
% set(lgd,'position',[0.6534    0.6814    0.3124    0.2638]);
xlim([0, 2000]);
ylim([0, 8]);
grid on;
xlabel('HU'); ylabel('\alpha (Np/cm)');
set(f1,'Position',[4.9896    4.4896    7.9167    5.6875]);
drawnow
if exist('imgPath','var')
    print([imgPath, '/figs/ctVatten650LitUnscaled'], '-depsc')
end

%% Separate out scaled vs not scaled results: Scaled
f1 = figure; hold on
f1.Units = 'inches';
f1.InvertHardcopy = 'off';
f1.PaperPositionMode = 'auto';
ax = gca;

% 650 kHz Data including from 1 MHz transducer
x = linspace(500,2.5e3,1e3);
y650_1000 = atten1000(fragsIdx500Layers,centerIdx650_1000);
[p650,r650,~,x2_650,y2_650,conf] = myPolyFit(hu(fragsIdx500Layers),y650','poly',1);
y = p650(1)*x+p650(2);
shadedErrorBar(x2_650,y2_650,conf,'lineprops',{'--','linewidth',3,'displayname','Fit to 650 kHz Data'})
ax.ColorOrderIndex = 2;

% Scaled 1 MHz data
% y1000 = atten1000(fragsIdx1000Layers,centerIdx1000);
% [p1000,r1000,~,x2,y2,conf] = myPolyFit(hu(fragsIdx1000Layers),y1000','poly',1);
% plot(x2,y2*(curFreq/1)^beta1,'--','linewidth',3,'displayname','Scaled 1 MHz');

% Scaled 2250 kHz Data
y2250 = atten2250(fragsIdx2250Layers,centerIdx2250);
[p2250,r2250,~,x2,y2,conf] = myPolyFit(hu(fragsIdx2250Layers),y2250','poly',1);
plot(x2,y2*(curFreq/2.25)^beta1,'--','linewidth',3, 'displayname', 'Scaled 2.25 MHz')

% Literature Values
vyas = bonePropertiesVyas2016(false,0.68,beta2);

pulkkinen = bonePropertiesPulkkinen2014(false,curFreq,beta2,836);

aubry = bonePropertiesAubry2003(false,curFreq,beta1,1/2*CtData.energies(ctIdx));

plot(pulkkinen.hu, pulkkinen.atten, 'linewidth', 2, 'displayname', 'Pichardo 2011');
plot(vyas.hu(6:end), vyas.atten(6:end), 'linewidth', 2, 'displayname', 'Vyas 2016');
plot(aubry.hu, aubry.atten, 'linewidth', 2, 'displayname', 'Aubry 2003');

hold off;
makeFigureBig(f1,24,24)
lgd = legend('show', 'location', 'northeast');
% set(lgd,'position',[0.6534    0.6814    0.3124    0.2638]);
xlim([0, 2000]);
ylim([0, 8]);
grid on;
xlabel('HU'); ylabel('\alpha (Np/cm)');
set(f1,'Position',[4.9896    4.4896    7.9167    5.6875]);
drawnow
if exist('imgPath','var')
    print([imgPath, '/figs/ctVatten650LitScaled'], '-depsc')
end

