close all;
if ~exist('atten500','var')
    runAttenuation
end

ctIdx = find(strcmp(CtData.kernels,'Bone') & CtData.energies==120 & strcmp(CtData.vendor,'GE') & strcmp(CtData.reconMethod,'Standard'));
hu = zeros(size(FragData));
for ii = 1:length(FragData)
    hu(ii) = FragData(ii).CT.HU(ctIdx);
end

[~,~,~,fragsIdx500Layers,fragsIdx1000Layers,fragsIdx2250Layers,sk1,sk2,it,ot,md] = screenFragments(FragData);

alpha500 = atten500(fragsIdx500Layers,centerIdx500);
hu500 = hu(fragsIdx500Layers);

alpha1000 = atten1000(fragsIdx1000Layers,centerIdx1000);
hu1000 = hu(fragsIdx1000Layers);

alpha2250 = atten2250(fragsIdx2250Layers,centerIdx2250);
hu2250 = hu(fragsIdx2250Layers);

figure; hold on
plot(hu2250,alpha2250,'*')

% [p,r,~,x2,y2] = myPolyFit(hu2250.',alpha2250,'Exp');

% Set up fittype and options.
%% Exponent with different 1
ft = fittype( 'exp(HU*x1+x0)', 'independent', 'HU', 'dependent', 'z' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
lowerLimits = [-inf,-inf];
upperLimits = [inf,0];
initialValue = [3.6,-1e-3];

%% Exp1
% ft = fittype( 'a*exp(HU*x1)', 'independent', 'HU', 'dependent', 'z' );
% opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
% opts.Display = 'Off';
% lowerLimits = [0,-inf];
% upperLimits = [inf,0];
% initialValue = [1,0];

%% Compute fit
opts.Lower = lowerLimits;
opts.Upper = upperLimits;
opts.StartPoint = initialValue;

for ii = 1:length(f500)
% Fit model to data.
    [fitresult, gof] = fit( hu500.', atten500(fragsIdx500Layers,ii), ft, opts );
    p = myPolyFit(hu500.',atten500(fragsIdx500Layers,ii),'poly',2);

    onePt500(ii) = -fitresult.x0/fitresult.x1;
    onePt500Poly(ii) = -p(2)/(2*p(1));
end


for ii = 1:length(f1000)
% Fit model to data.
    [fitresult, gof] = fit( hu1000.', atten1000(fragsIdx1000Layers,ii), ft, opts );
    p = myPolyFit(hu1000.',atten1000(fragsIdx1000Layers,ii),'poly',2);
    
    onePt1000(ii) = -fitresult.x0/fitresult.x1;
    onePt1000Poly(ii) = -p(2)/(2*p(1));
end

for ii = 1:length(f2250)
% Fit model to data.
    [fitresult, gof] = fit( hu2250.', atten2250(fragsIdx2250Layers,ii), ft, opts );
    p = myPolyFit(hu2250.',atten2250(fragsIdx2250Layers,ii),'poly',2);
    
    onePt2250(ii) = -fitresult.x0/fitresult.x1;
    onePt2250Poly(ii) = -p(2)/(2*p(1));
end

x2 = linspace(500,3e3,1e2);
% y2 = fitresult.a*exp(fitresult.x1*x2+fitresult.x0);
y2 = exp(fitresult.x1*x2+fitresult.x0);

plot(x2,y2);
axis([min(hu2250),max(hu2250),min(alpha2250),max(alpha2250)])

figure
hold on
ax = gca;
plot(f500,onePt500,'*',f1000,onePt1000,'*',f2250,onePt2250,'*','linewidth',2,'markersize',10)
ax.ColorOrderIndex = 1;
plot(f500,onePt500Poly,'^',f1000,onePt1000Poly,'^',f2250,onePt2250Poly,'^','linewidth',2,'markersize',10)
plt1 = plot(-1,-1,'k*','linewidth',2,'markersize',10);
plt2 = plot(-1,-1,'k^','linewidth',2,'markersize',10);
xlabel('Frequency')
ylabel('HU Value')
legend([plt1,plt2],'HU value at which the exponent is zero')
axis([0,3,1e3,3.5e3])
makeFigureBig(4)