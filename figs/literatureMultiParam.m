% close all;
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

%% 650 kHz
curFreq = 0.5;

addpath('figs\acousticPropertiesAcrossStudies\')
addpath('figs\literatureComparison\lib\util\')

huHat = linspace(0,2500,100);
[fitParams,gof,model,coeffs] = polynomialFit(FragData,CtData,hu',atten500,atten1000,atten2250,f500,f1000,f2250,'HU','Exponential',1);
[fitParamsHybrid,gofHybrid,modelHybrid,coeffsHybrid] = polynomialFit(FragData,CtData,hu',atten500,atten1000,atten2250,f500,f1000,f2250,'HU','Hybrid2',0);
% fitParams.ey1 = 1;
zHat = giveSymbolicResult(huHat,0.65,model,fitParams,coeffs);
zHatHybrid = giveSymbolicResult(huHat,0.65,modelHybrid,fitParamsHybrid,coeffsHybrid);

[~,idx650_500] = min(abs(f500-0.65));
[~,idx650_1000] = min(abs(f1000-0.65));
alpha650 = [atten500(fragsIdx500Layers,idx650_500);atten1000(fragsIdx1000Layers,idx650_1000)];
hu650 = [hu(fragsIdx500Layers),hu(fragsIdx1000Layers)];

% 95% confidence intervals
% ci = confint(fitParams);
% paramsPlus.a = ci(2,1);
% paramsPlus.b = ci(2,2);
% paramsPlus.c = ci(1,3);
% 
% paramsMinus.a = ci(1,1);
% paramsMinus.b = ci(1,2);
% paramsMinus.c = ci(2,3);
% 
% zHatPlus = giveSymbolicResult(huHat,0.65,model,paramsPlus,coeffs);
% zHatMinus = giveSymbolicResult(huHat,0.65,model,paramsMinus,coeffs);
% errbar = zHatPlus-zHat;
% errbar(2,:) = zHat-zHatMinus;

for ii = 1:length(huHat)
    predictionInterval = predint(fitParams,[huHat(ii),0.65],0.95,'observation');
    errbar(1,ii) = predictionInterval(2)-zHat(ii);
    errbar(2,ii) = zHat(ii)-predictionInterval(1);
end
%%
f1 = figure; hold on
ax = gca;
hold on
shadedErrorBar(huHat,zHat,errbar,'lineprops',{'--','color',ax.ColorOrder(1,:),'linewidth',2,'displayname','This Study'});
ax.ColorOrderIndex = 1;
% plot(huHat,zHat,'k-','linewidth',2,'displayname','Fit to Equation (4)')
plot(huHat,zHatHybrid,'k--','linewidth',2,'displayname','Fit to Equation (5)')
plot(hu650,alpha650,'k.','linewidth',2,'markersize',8,'displayname','Measured Attenuation')

leung = bonePropertiesLeung2018(false,curFreq,beta2);
vyas = bonePropertiesVyas2016(false,curFreq,beta2);
pulkkinen = bonePropertiesPulkkinen2014(false,curFreq,beta2,270);
% aubryBeta = myLog(curFreq/1.5,(1/1.5)^beta3*(curFreq^beta2));
ctHdr.Manufacturer = 'siemens';
ctHdr.ConvolutionKernel = 'H60s';
ctHdr.KVP = 120;
aubry = bonePropertiesAubry2003(false,curFreq,beta1,1/2*CtData.energies(ctIdx));
mcdannold.hu = 230:10:2500;
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
xlim([0, 2200]);
ylim([0, 5]);
grid on;
xlabel('HU'); ylabel('\alpha (Np/cm)');
legend('show', 'location', 'eastoutside');
set(f1,'position',[0.3466    0.1170    1.0440    0.4200]*1e3)
drawnow
if exist('imgPath','var')
    print([imgPath, '/figs/ctVatten650Lit'], '-depsc')
end

