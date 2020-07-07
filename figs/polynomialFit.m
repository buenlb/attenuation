% Does a fit of z to x and y. Plots the results.
function [fitParams,gof,model,coeffs] = polynomialFit(FragData,CtData,imgParam,atten500,atten1000,atten2250,f500,f1000,f2250,imgParamName,modelType,PLOTRESULTS)
switch imgParamName
    case 'HU'
        axLabel = 'HU';
        xHat = linspace(500,2000,50);
    case 'ZTE'
        xHat = linspace(0.1,0.9,50);
        axLabel = 'ZTE';
    case 'UTE'
        xHat = linspace(0,1,50);
        axLabel = 'UTE';
    case 'T2*'
        xHat = linspace(0,2.5,50);
        axLabel = 'T2* (ms)';
    otherwise
        error([imgParamName, ' not a recognized imaging parameter']);
end

yHat = 0.35:0.05:3;

% x = [hu(fragsIdx500Layers),hu(fragsIdx1000Layers),hu(fragsIdx2250Layers)];
% y = [f500,f1000,f2250];
[~,~,~,fragsIdx500Layers,fragsIdx1000Layers,fragsIdx2250Layers] = screenFragments(FragData,0,1);
n500 = length(fragsIdx500Layers);
n1000 = length(fragsIdx1000Layers);
n2250 = length(fragsIdx2250Layers);

nf500 = length(f500);
nf1000 = length(f1000);
nf2250 = length(f2250);

if PLOTRESULTS
    h = figure; hold on;
end
idx = 1;
for ii = 1:n500
    for jj = 1:nf500
        x(idx) = imgParam(fragsIdx500Layers(ii));
        y(idx) = f500(jj);
        z(idx) = atten500(fragsIdx500Layers(ii),jj);
        idx = idx+1;
    end
end
if PLOTRESULTS
    marker = '^';
    markerSize = 4;
    linewidth = 1;
    plot(x,y,marker,'markersize',markerSize,'linewidth',linewidth);
    idx1000 = idx;
end

for ii = 1:n1000
    for jj = 1:nf1000
        x(idx) = imgParam(fragsIdx1000Layers(ii));
        y(idx) = f1000(jj);
        z(idx) = atten1000(fragsIdx1000Layers(ii),jj);
        idx = idx+1;
    end
end
if PLOTRESULTS
    plot(x(idx1000+1:end),y(idx1000+1:end),marker,'markersize',markerSize,'linewidth',linewidth);
    idx2250 = idx;
end

for ii = 1:n2250
    for jj = 1:nf2250
        x(idx) = imgParam(fragsIdx2250Layers(ii));
        y(idx) = f2250(jj);
        z(idx) = atten2250(fragsIdx2250Layers(ii),jj);
        idx = idx+1;
    end
end
if PLOTRESULTS
    plot(x(idx2250+1:end),y(idx2250+1:end),marker,'markersize',markerSize,'linewidth',linewidth);
    xlabel(axLabel)
    ylabel('frequency (MHz)')
    axis([min(x),max(x),min(y),max(y)])
    makeFigureBig(h,26,26)

    if 1
        if contains(imgParamName,'*')
            svName = imgParamName(1:2);
        else
            svName = imgParamName;
        end
        ax.Position = [0.1957    0.2408    0.7093    0.6842];
        print(['C:\Users\Taylor\Documents\Stanford\Work\Papers\attenuation2\figs\','sampling',svName], '-depsc')
    end
end
%%
clear model coeffs lowerLimits upperLimits initialValue

% plotResultsPolynomialFit(x,y,z,f500,f1000,f2250,atte)
addpath('sandbox\')
if ~exist('atten500','var')
    setUpDataForFit
end
switch modelType
%% Theoretical
    case 'Theoretical'
        model = 'x0+a*FREQ.^(b+c4./HU)+alpha_a0*(1-exp(-HU/c2))-c3*log(1-c1*FREQ.^4./HU.^3)';
        coeffs = {'a','alpha_a0','b','c1','c2','c3','c4','x0'};
        lowerLimits = [-inf,0,-inf,0,0,-inf,-inf,-inf];
        upperLimits = [inf,inf,inf,200^3/4^4,inf,inf,inf,inf];
        initialValue = [2,2,1,10,1e3,1,0,0];
%% Hybrid 1
    case 'Hybrid1'
        model = 'x0+a*FREQ.^(b+b1./HU)+x1*HU+x2*HU.^2';
        coeffs = {'x0','x1','x2','a','b','b1'};
%% Hybrid 2
    case 'Hybrid2'
        model = 'a*FREQ.^b+x0+x1*HU+x2*HU.^2+xy*HU.*FREQ';
        coeffs = {'a','b','x0','x1','x2','xy'};
        lowerLimits = [-inf,0,-inf,-inf,-inf,-inf];
        upperLimits = [inf,inf,inf,inf,inf,inf];
        % initialValue = randn(1,6)+100;
        initialValue = [2,1,10,10,10,1];
%%  Exponential % modelLabel = 'hybridExponential2';
    case 'Exponential'
        model = '(a.*FREQ.^b).*exp(c*HU)';
        lowerLimits = [-inf,   -inf,  -inf];
        upperLimits = [inf, inf, inf];
        % initialValue = randn(1,6)+100;
        initialValue = [1,1,-1.e-3];
        coeffs = {'a','b','c'};
%% Proportional
    case 'Proportional'
        model = '(a*FREQ.^b)./(HU.^c)';

        lowerLimits = [-inf,0, 0];
        upperLimits = [inf, 5, 5];
        initialValue = [1,1,1];
        coeffs = {'a','b','c'};
%% Polynomial
    case 'Polynomial'
        model = 'x0+y1*FREQ+y2*FREQ.^2+x1*HU+x2*HU.^2+xy11*HU.*FREQ';
        coeffs = {'x0','x1','x2','xy11','y1','y2'};
    otherwise
        error(['Model ', modelType, ' is not recognized.'])
end

if exist('lowerLimits','var')
    [fitParams,gof] = simultaneousFitToFreqHu(x,y,z,model,length(coeffs),lowerLimits,upperLimits,initialValue);
else
    [fitParams,gof] = simultaneousFitToFreqHu(x,y,z,model,length(coeffs));
end

if ~PLOTRESULTS
    return
end

[X,Y] = meshgrid(xHat,yHat);

zHat = giveSymbolicResult(X,Y,model,fitParams,coeffs);

h = figure;
h.Units = 'inches';
h.InvertHardcopy = false;

ax = gca;
clim(1) = min(min(zHat(:,xHat>min(x) & xHat<max(x))));
clim(2) = max(max(zHat(:,xHat>min(x) & xHat<max(x))));
imagesc(xHat,yHat,zHat,clim)
xlabel(axLabel)
ylabel('frequency (MHz)')
axis('tight')
c = colorbar;
set(get(c,'label'),'string','Attenuation (Np/cm)','fontsize',26);
makeFigureBig(h,26,26);
axis([min(x),max(x),min(y),max(y)])
% ax.Position = [0.1476    0.2109    0.6544    0.7141];
% set(h,'position',[23.5000    2.4833    7.7167    5.0083])
if 1
    if contains(imgParamName,'*')
        svName = imgParamName(1:2);
    else
        svName = imgParamName;
    end
    print(['C:\Users\Taylor\Documents\Stanford\Work\Papers\attenuation2\figs\','fit',svName], '-depsc')
%     export_fig(['C:\Users\Taylor\Documents\Stanford\Work\Papers\attenuation2\figs\','fit',svName], '-eps')
end

[~,center650] = min(abs(f500-0.65));
[~,center650_1000] = min(abs(f1000-0.65));
[~,center1000] = min(abs(f1000-1));
[~,center2250] = min(abs(f2250-2.25));

huHat = imgParam(fragsIdx500Layers);
attenHat = giveSymbolicResult(huHat,0.65,model,fitParams,coeffs);
huHat2 = imgParam(fragsIdx1000Layers);
attenHat2 = giveSymbolicResult(huHat2,0.65,model,fitParams,coeffs);
s650 = standardErrorOfRegression([atten500(fragsIdx500Layers,center650);atten1000(fragsIdx1000Layers,center650_1000)],[attenHat;attenHat2],length(coeffs));

huHat = imgParam(fragsIdx1000Layers);
attenHat = giveSymbolicResult(huHat,1,model,fitParams,coeffs);
s1000 = standardErrorOfRegression(atten1000(fragsIdx1000Layers,center1000),attenHat,length(coeffs));

huHat = imgParam(fragsIdx2250Layers);
attenHat = giveSymbolicResult(huHat,2.25,model,fitParams,coeffs);
s2250 = standardErrorOfRegression(atten2250(fragsIdx2250Layers,center2250),attenHat,length(coeffs));

h = figure;
ax = gca;
% shadedErrorBar(xHat,zHat(9,:),ones(size(xHat))*s650,'lineprops',{'--','color',ax.ColorOrder(1,:),'linewidth',2})
% shadedErrorBar(xHat,zHat(16,:),ones(size(xHat))*s1000,'lineprops',{'--','color',ax.ColorOrder(2,:),'linewidth',2})
% shadedErrorBar(xHat,zHat(41,:),ones(size(xHat))*s2250,'lineprops',{'--','color',ax.ColorOrder(3,:),'linewidth',2})
plot(xHat,zHat(9,:),xHat,zHat(16,:),xHat,zHat(41,:),'linewidth',2)
hold on
ax.ColorOrderIndex = 1;

plot([imgParam(fragsIdx500Layers);imgParam(fragsIdx1000Layers)],[atten500(fragsIdx500Layers,center650);atten1000(fragsIdx1000Layers,center650_1000)],'*')
plot(imgParam(fragsIdx1000Layers),atten1000(fragsIdx1000Layers,center1000),'*')
plot(imgParam(fragsIdx2250Layers),atten2250(fragsIdx2250Layers,center2250),'*')
xlabel(axLabel)
ylabel('attenuation (Np/cm)')
% title('Individual Frequencies')
% axis([0,2500,0,30])
axis('tight')
grid on
legend(['0.65 MHz, s=', num2str(s650,2)],['1 MHz, s=', num2str(s1000,2)],['2.25 MHz, s=', num2str(s2250,2)])
makeFigureBig(h)

if 1
    if contains(imgParamName,'*')
        svName = imgParamName(1:2);
    else
        svName = imgParamName;
    end
    print(['C:\Users\Taylor\Documents\Stanford\Work\Papers\attenuation2\figs\','freqFit',svName], '-depsc')
end

%% Select fragments from across HU spectrum
ctIdx = find(strcmp(CtData.kernels,'Bone') & CtData.energies==120 & strcmp(CtData.vendor,'GE') & strcmp(CtData.reconMethod,'Standard'));
hu = zeros(size(FragData));
for ii = 1:length(FragData)
    hu(ii) = FragData(ii).CT.HU(ctIdx);
end

[~,hu1000Idx] = min(abs(hu(fragsIdx2250Layers)-1e3));
[~,hu1500Idx] = min(abs(hu(fragsIdx2250Layers)-1.5e3));
[~,hu2000Idx] = min(abs(hu(fragsIdx2250Layers)-1.8019e3));

hu1000 = imgParam(fragsIdx2250Layers(hu1000Idx));
hu1500 = imgParam(fragsIdx2250Layers(hu1500Idx));
hu2000 = imgParam(fragsIdx2250Layers(hu2000Idx));

% z1 = fitParams.x1*hu1000+fitParams.x2*hu1000.^2+fitParams.xy*hu1000*yHat+fitParams.y1*yHat;
% z2 = fitParams.x1*hu1500+fitParams.x2*hu1500.^2+fitParams.xy*hu1500*yHat+fitParams.y1*yHat;
% z3 = fitParams.x1*hu2000+fitParams.x2*hu2000.^2+fitParams.xy*hu2000*yHat+fitParams.y1*yHat;

z1 = giveSymbolicResult(hu1000,yHat,model,fitParams,coeffs);
% r_hu1000 = rSquared([atten500(fragsIdx500Layers(hu1000Idx),:),atten1000(fragsIdx500Layers(hu1000Idx),:),atten2250(fragsIdx500Layers(hu1000Idx),:)],attenHat);
if ismember(fragsIdx2250Layers(hu1000Idx),fragsIdx500Layers)
    yMeasured1000 = [atten500(fragsIdx2250Layers(hu1000Idx),:),atten1000(fragsIdx2250Layers(hu1000Idx),:),atten2250(fragsIdx2250Layers(hu1000Idx),:)];
    fHu1000 = [f500,f1000,f2250];
elseif ismember(fragsIdx2250Layers(hu1000Idx),fragsIdx1000Layers)
    yMeasured1000 = [atten1000(fragsIdx2250Layers(hu1000Idx),:),atten2250(fragsIdx2250Layers(hu1000Idx),:)];
    fHu1000 = [f1000,f2250];
else
    yMeasured1000 = atten2250(fragsIdx2250Layers(hu1000Idx),:);
    fHu1000 = f2250;
end
attenHat = giveSymbolicResult(hu1000,fHu1000,model,fitParams,coeffs);
s_hu1000 = standardErrorOfRegression(yMeasured1000,attenHat,length(coeffs));

z2 = giveSymbolicResult(hu1500,yHat,model,fitParams,coeffs);
if ismember(fragsIdx2250Layers(hu1500Idx),fragsIdx500Layers)
    yMeasured1500 = [atten500(fragsIdx2250Layers(hu1500Idx),:),atten1000(fragsIdx2250Layers(hu1500Idx),:),atten2250(fragsIdx2250Layers(hu1500Idx),:)];
    fHu1500 = [f500,f1000,f2250];
elseif ismember(fragsIdx2250Layers(hu1500Idx),fragsIdx1000Layers)
    yMeasured1500 = [atten1000(fragsIdx2250Layers(hu1500Idx),:),atten2250(fragsIdx2250Layers(hu1500Idx),:)];
    fHu1500 = [f1000,f2250];
else
    yMeasured1500 = atten2250(fragsIdx2250Layers(hu1500Idx),:);
    fHu1500 = f2250;
end
attenHat = giveSymbolicResult(hu1500,fHu1500,model,fitParams,coeffs);
% r_hu1500 = rSquared([atten500(fragsIdx500Layers(hu1500Idx),:),atten1000(fragsIdx500Layers(hu1500Idx),:),atten2250(fragsIdx500Layers(hu1500Idx),:)],attenHat);
s_hu1500 = standardErrorOfRegression(yMeasured1500,attenHat,length(coeffs));

z3 = giveSymbolicResult(hu2000,yHat,model,fitParams,coeffs);
if ismember(fragsIdx2250Layers(hu2000Idx),fragsIdx500Layers)
    yMeasured2000 = [atten500(fragsIdx2250Layers(hu2000Idx),:),atten1000(fragsIdx2250Layers(hu2000Idx),:),atten2250(fragsIdx2250Layers(hu2000Idx),:)];
    fHu2000 = [f500,f1000,f2250];
elseif ismember(fragsIdx2250Layers(hu2000Idx),fragsIdx1000Layers)
    yMeasured2000 = [atten1000(fragsIdx2250Layers(hu2000Idx),:),atten2250(fragsIdx2250Layers(hu2000Idx),:)];
    fHu2000 = [f1000,f2250];
else
    yMeasured2000 = atten2250(fragsIdx2250Layers(hu2000Idx),:);
    fHu2000 = f2250;
end
attenHat = giveSymbolicResult(hu2000,fHu2000,model,fitParams,coeffs);
% r_hu2000 = rSquared([atten500(fragsIdx500Layers(hu2000Idx),:),atten1000(fragsIdx500Layers(hu2000Idx),:),atten2250(fragsIdx500Layers(hu2000Idx),:)],attenHat);
s_hu2000 = standardErrorOfRegression(yMeasured2000,attenHat,length(coeffs));

h = figure;
% subplot(122)
ax = gca;
% shadedErrorBar(yHat,zHat(:,18),ones(size(yHat))*s_hu1000,'lineprops',{'--','color',ax.ColorOrder(1,:),'linewidth',2})
% shadedErrorBar(yHat,zHat(:,34),ones(size(yHat))*s_hu1500,'lineprops',{'--','color',ax.ColorOrder(2,:),'linewidth',2})
% shadedErrorBar(yHat,zHat(:,50),ones(size(yHat))*s_hu2000,'lineprops',{'--','color',ax.ColorOrder(3,:),'linewidth',2})
plot(yHat,z1,yHat,z2,yHat,z3,'linewidth',2);
% plot(yHat,z1,yHat,z2,yHat,z3,'linewidth',2);
hold on
ax.ColorOrderIndex = 1;
plot(fHu1000,yMeasured1000,'*')
plot(fHu1500,yMeasured1500,'*')
plot(fHu2000,yMeasured2000,'*')
xlabel('frequency (MHz)')
ylabel('attenuation (Np/cm)')
% title('Individual Parameter values')
legend([imgParamName, ' = ', num2str(hu1000,2), ', s=',num2str(s_hu1000,2)],[imgParamName, ' = ', num2str(hu1500,2), ', s=',num2str(s_hu1500,4)],[imgParamName ' = ', num2str(hu2000,2), ', s=',num2str(s_hu2000,2)],'location','northwest')
axis('tight')
% axis([0,3,0,30])
grid on
makeFigureBig(h)
pos = get(h,'position');
% set(h,'position',[pos(1),pos(2),2*pos(3),pos(4)])

disp(['Overall s=', num2str(gof.rmse)])

if 1
    if contains(imgParamName,'*')
        svName = imgParamName(1:2);
    else
        svName = imgParamName;
    end
    print(['C:\Users\Taylor\Documents\Stanford\Work\Papers\attenuation2\figs\','imgParamFit',svName], '-depsc')
end

data.hu = x;
data.f = y;
data.atten = z;

definitions.hu = 'Average Hounsfield unit of sample for each measurement';
definitions.f = 'Frequency of each measurement';
definitions.atten = 'Measured attenuation';
save('C:\Users\Taylor\Documents\Projects\Stanford\Attenuation\figs\fullDataSet.mat','data','definitions','fitParams');