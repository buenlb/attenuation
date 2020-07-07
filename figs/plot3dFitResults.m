% Plot the 3d fits for each imaging parameter.
close all;
if ~exist('atten500','var')
    addpath('figs\acousticPropertiesAcrossStudies\')
    addpath('figs\literatureComparison\lib\util\')
    runAttenuation
end

ctIdx = find(strcmp(CtData.kernels,'Bone') & CtData.energies==120 & strcmp(CtData.vendor,'GE') & strcmp(CtData.reconMethod,'Standard'));
hu = zeros(size(FragData));
for ii = 1:length(FragData)
    hu(ii) = FragData(ii).CT.HU(ctIdx);
end

zte = zeros(size(FragData'));
ute = zeros(size(FragData'));
t2 = zeros(size(FragData'));
for ii = 1:length(FragData)
    zte(ii) = FragData(ii).MR.ZTE;
    ute(ii) = FragData(ii).MR.UTE;
    t2(ii) = FragData(ii).MR.T2Star;
end

[~,~,~,fragsIdx500Layers,fragsIdx1000Layers,fragsIdx2250Layers] = screenFragments(FragData);

huHat = linspace(0,2500,100);
fitType = 'Exponential';
polynomialFit(FragData,CtData,hu',atten500,atten1000,atten2250,f500,f1000,f2250,'HU',fitType,1);

polynomialFit(FragData,CtData,zte,atten500,atten1000,atten2250,f500,f1000,f2250,'ZTE',fitType,1);
return
polynomialFit(FragData,CtData,ute,atten500,atten1000,atten2250,f500,f1000,f2250,'UTE',fitType,1);

polynomialFit(FragData,CtData,t2,atten500,atten1000,atten2250,f500,f1000,f2250,'T2*',fitType,1);