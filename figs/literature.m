close all;
if ~exist('atten500','var')
    runAttenuation
end

ctIdx = find(strcmp(CtData.kernels,'Bone') & CtData.energies==120 & strcmp(CtData.vendor,'GE') & strcmp(CtData.reconMethod,'Standard'));
hu = zeros(size(FragData));
for ii = 1:length(FragData)
    hu(ii) = FragData(ii).CT.HU(ctIdx);
end

[~,~,~,fragsIdx500Layers,fragsIdx1000Layers,fragsIdx2250Layers] = screenFragments(FragData);

alpha500 = atten500(fragsIdx500Layers,centerIdx500);
alpha1000 = atten1000(fragsIdx1000Layers,centerIdx1000);
alpha2250 = atten2250(fragsIdx2250Layers,centerIdx2250);

beta1 = 1.1;
beta2 = 1.1;
beta3 = 1.1;

%% 500 kHz

% beta1 = 1.1;
% beta2 = 0.81;
% beta3 = 1.5;


curFreq = 0.5;

addpath('figs\acousticPropertiesAcrossStudies\')
addpath('figs\literatureComparison\lib\util\')
minAtten = mean(alpha2250(hu(fragsIdx2250Layers)>1900));
minAtten500 = minAtten*(curFreq/2.25)^beta1;
f1 = figure; hold on
ax = gca;
hold on

x = linspace(500,2.5e3,1e3);
y500 = atten500(fragsIdx500Layers,centerIdx500);
[p500,r500,~,x2_500,y2_500,conf] = myPolyFit(hu(fragsIdx500Layers),y500','poly',1);
y = p500(1)*x+p500(2);
y2_500(y2_500<minAtten500) = minAtten500;
conf(y2_500<=minAtten500) = 0;
shadedErrorBar(x2_500,y2_500,conf,'lineprops',{'--','linewidth',3})
plot(hu(fragsIdx500Layers),alpha500*(curFreq/0.5)^beta2,'o','color',ax.ColorOrder(1,:),'linewidth',2,'markersize',8,'displayname','Experimental Data')
plot(hu(fragsIdx2250Layers),alpha2250*(curFreq/2.25)^beta1,'.','color',ax.ColorOrder(1,:),'linewidth',2,'markersize',12,'displayname','Scaled 2.25 MHz Data')
ax.ColorOrderIndex = 1;
ax.ColorOrderIndex = 2;
% legend('show', 'location', 'eastoutside');

leung = bonePropertiesLeung2018(false,curFreq,beta2);
vyas = bonePropertiesVyas2016(false,curFreq,beta2);
pulkkinen = bonePropertiesPulkkinen2014(false,curFreq,beta2,270);
% aubryBeta = myLog(curFreq/1.5,(1/1.5)^beta3*(curFreq^beta2));
ctHdr.Manufacturer = 'siemens';
ctHdr.ConvolutionKernel = 'H60s';
ctHdr.KVP = 120;
aubry = bonePropertiesAubry2003(false,curFreq,beta1,1/2*CtData.energies(ctIdx));
mcdannold.hu = 0:10:2500;
[~,~,tmpAtten] = mcdannold2020(mcdannold.hu, 2000, ctHdr, 0.66e6);
mcdannold.atten = tmpAtten*(0.5/0.66)^beta1;
% frequencyScalar = (1/0.68)^2;
% f1 = figure; hold on;
plot(aubry.hu, aubry.atten, 'linewidth', 2, 'displayname', 'Aubry{\it et al.} 2003');
plot(leung.hu(6:end), leung.atten(6:end), 'linewidth', 2, 'displayname', 'Leung {\it et al.} 2019');
plot(pulkkinen.hu, pulkkinen.atten, 'linewidth', 2, 'displayname', 'Pichardo{\it et al.} 2011');
plot(vyas.hu(6:end), vyas.atten(6:end), 'linewidth', 2, 'displayname', 'Vyas{\it et al.} 2016');
plot(mcdannold.hu, mcdannold.atten, 'linewidth', 2, 'displayname', 'McDannold {\it et al.} 2020');
hold off;
makeFigureBig(f1,24,24)
xlim([0, 2500]);
ylim([0, 4]);
grid on;
xlabel('HU'); ylabel('\alpha (Np/cm)');
drawnow
if exist('imgPath','var')
    print([imgPath, '/figs/ctVatten500Lit'], '-depsc')
end

%% 1 MHz
f1 = figure; hold on
ax = gca;
hold on
x = linspace(500,2.5e3,1e3);
y1000 = atten1000(fragsIdx1000Layers,centerIdx1000);
[p1000,r1000,~,x2,y2,conf] = myPolyFit(hu(fragsIdx1000Layers),y1000','poly',1);
% y = p1000(1)*x+p1000(2);

minAtten1 = minAtten*(1/2.25)^beta3;
y2(y2<minAtten1) = minAtten1;
conf(y2<=minAtten1) = 0;
shadedErrorBar(x2,y2,conf,'lineprops',{'--','linewidth',3,'DisplayName','Proposed Model'})
plot(hu(fragsIdx1000Layers),alpha1000,'o','color',ax.ColorOrder(1,:),'linewidth',2,'markersize',8,'displayname','Experimental Data')
% plot(hu(fragsIdx2250Layers),alpha2250*(1/2.25)^beta3,'.','color',ax.ColorOrder(1,:),'linewidth',2,'markersize',12,'displayname','Scaled 2.25 MHz Data')
ax.ColorOrderIndex = 2;
% legend('show', 'location', 'eastoutside');

leung = bonePropertiesLeung2018(false,1,beta2);
vyas = bonePropertiesVyas2016(false,1,beta2);
pulkkinen = bonePropertiesPulkkinen2014(false,1,beta2,836);
aubry = bonePropertiesAubry2003(false,1,beta3,1/2*CtData.energies(ctIdx));
[~,~,tmpAtten] = mcdannold2020(mcdannold.hu, 2000, ctHdr, 1000e3);
mcdannold.atten = tmpAtten*(1/0.66)^beta1;

% frequencyScalar = (1/0.68)^2;
% f1 = figure; hold on;
plot(aubry.hu, aubry.atten, 'linewidth', 2, 'displayname', 'Aubry{\it et al.} 2003');
plot(leung.hu(6:end), leung.atten(6:end), 'linewidth', 2, 'displayname', 'Leung {\it et al.}');
plot(pulkkinen.hu, pulkkinen.atten, 'linewidth', 2, 'displayname', 'Pichardo{\it et al.} 2011');
plot(vyas.hu(6:end), vyas.atten(6:end), 'linewidth', 2, 'displayname', 'Vyas{\it et al.} 2016');
plot(mcdannold.hu, mcdannold.atten, 'linewidth', 2, 'displayname', 'McDannold {\it et al.} 2020');
hold off;
makeFigureBig(f1,24,24)
xlim([0, 2500]);
% ylim([0, 4]);
grid on;
xlabel('HU'); ylabel('\alpha (Np/cm)');

if exist('imgPath','var')
    print([imgPath, '\figs\ctVatten1Lit'], '-depsc')
end

%% 2250 kHz
freq = 2.25;

f1 = figure; hold on
f1.Units = 'inches';
f1.InvertHardcopy = 'off';
f1.PaperPositionMode = 'auto';

ax = gca;
hold on
x = linspace(500,2.5e3,1e3);
y2250 = atten2250(fragsIdx2250Layers,centerIdx2250);
[p2250,r2250,~,x2,y2,conf] = myPolyFit(hu(fragsIdx2250Layers),y2250','poly',1);
y2(y2<minAtten) = minAtten;
conf(y2<=minAtten) = 0;
shadedErrorBar(x2,y2,conf,'lineprops',{'--','linewidth',3,'DisplayName','Proposed Model'})
plot(hu(fragsIdx2250Layers),alpha2250,'o','color',ax.ColorOrder(1,:),'linewidth',2,'markersize',8,'displayname','Experimental Data')
plot(-1,-1,'.','color',ax.ColorOrder(1,:),'linewidth',2,'markersize',12,'displayname','Scaled 2.25 MHz Data')
ax.ColorOrderIndex = 1;

ax.ColorOrderIndex = 2;
% legend('show', 'location', 'eastoutside');

leung = bonePropertiesLeung2018(false,freq,beta1);
vyas = bonePropertiesVyas2016(false,freq,beta1);
pulkkinen = bonePropertiesPulkkinen2014(false,freq,beta3,1402);
aubry = bonePropertiesAubry2003(false,freq,beta3,1/2*CtData.energies(ctIdx));
[~,~,tmpAtten] = mcdannold2020(mcdannold.hu, 2000, ctHdr, 2250e3);
mcdannold.atten = tmpAtten*(2.25/0.66)^beta1;

% frequencyScalar = (1/0.68)^2;
% f1 = figure; hold on;
plot(aubry.hu, aubry.atten, 'linewidth', 2, 'displayname', 'Aubry{\it et al.} 2003');
plot(leung.hu(6:end), leung.atten(6:end), 'linewidth', 2, 'displayname', 'Leung {\it et al.} 2019');
plot(pulkkinen.hu, pulkkinen.atten, 'linewidth', 2, 'displayname', 'Pichardo{\it et al.} 2011');
plot(vyas.hu(6:end), vyas.atten(6:end), 'linewidth', 2, 'displayname', 'Vyas{\it et al.} 2016');
plot(mcdannold.hu, mcdannold.atten, 'linewidth', 2, 'displayname', 'McDannold {\it et al.} 2019');
hold off;
makeFigureBig(f1,24,24)
xlim([0, 2500]);
ylim([0, 25]);
grid on;
xlabel('HU'); ylabel('\alpha (Np/cm)');
legend('show', 'location', 'eastoutside');
set(f1,'Position',[3.8542    0.5313   10.8958    5.8333]);
if exist('imgPath','var')
    print([imgPath, '\figs\ctVatten225Lit'], '-depsc')
end

fid = fopen('C:\Users\Taylor\Documents\Stanford\Work\Papers\Attenuation\resultsMinAtten.tex','w');
writeNewCommand(fid,minAtten500,'satAlphaFive')
writeNewCommand(fid,minAtten1,'satAlphaOne')
writeNewCommand(fid,minAtten,'satAlphaTwoTwoFive')
% writeNewCommand(fid,aubryBeta,'beta1')
fclose(fid);