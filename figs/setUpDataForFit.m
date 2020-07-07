clear x y z; close all
% x = [hu(fragsIdx500Layers),hu(fragsIdx1000Layers),hu(fragsIdx2250Layers)];
% y = [f500,f1000,f2250];
[~,~,~,fragsIdx500Layers,fragsIdx1000Layers,fragsIdx2250Layers] = screenFragments(FragData,0,1);
n500 = length(fragsIdx500Layers);
n1000 = length(fragsIdx1000Layers);
n2250 = length(fragsIdx2250Layers);

nf500 = length(f500);
nf1000 = length(f1000);
nf2250 = length(f2250);

hu = getHU(FragData);
idx = find(CtData.energies == 120 & strcmp(CtData.kernels,'Bone') & strcmp(CtData.vendor,'GE') & strcmp(CtData.reconMethod,'Standard'));
hu = hu(idx,:);
% hu = zte;

figure(99); hold on;
idx = 1;
%%
for ii = 1:n500
    for jj = 1:nf500
        x(idx) = hu(fragsIdx500Layers(ii));
        y(idx) = f500(jj);
        z(idx) = atten500(fragsIdx500Layers(ii),jj);
        idx = idx+1;
    end
end
%%
for ii = 1:n1000
    for jj = 1:nf1000
        x(idx) = hu(fragsIdx1000Layers(ii));
        y(idx) = f1000(jj);
        z(idx) = atten1000(fragsIdx1000Layers(ii),jj);
        idx = idx+1;
    end
end
%%
for ii = 1:n2250
    for jj = 1:nf2250
        x(idx) = hu(fragsIdx2250Layers(ii));
        y(idx) = f2250(jj);
        z(idx) = atten2250(fragsIdx2250Layers(ii),jj);
        idx = idx+1;
    end
end

% simultaneousFit = simultaneousFitToFreqHu(x,y,z,'y1*y+x1*x+x2*x^2+xy*x*y',4);
simultaneousFit = simultaneousFitToFreqHu(x,y,z,'a*FREQ^b+x1*HU+x2*HU.^2+xy*HU*FREQ+x0',6);
%%
xHat = linspace(200,2e3,50);
yHat = 0.25:0.05:3;
[X,Y] = meshgrid(xHat,yHat);

% zHat = simultaneousFit.x1*X+simultaneousFit.x2*X.^2+simultaneousFit.xy*X.*Y+simultaneousFit.y1*Y;
zHat = simultaneousFit.x1*X+simultaneousFit.x2*X.^2+simultaneousFit.xy*X.*Y+simultaneousFit.a*Y.^simultaneousFit.b+simultaneousFit.x0;

% satIdx = find(X>(-simultaneousFit.x1-simultaneousFit.xy*Y)./(2*simultaneousFit.x2));
% curX = (-simultaneousFit.x1-simultaneousFit.xy*Y(satIdx))./(2*simultaneousFit.x2);
% zHat(satIdx) = simultaneousFit.x1*curX+simultaneousFit.x2*curX.^2+simultaneousFit.xy*curX.*Y(satIdx)+simultaneousFit.a*Y(satIdx).^simultaneousFit.b+simultaneousFit.x0;

h = figure;
surf(xHat,yHat,zHat)
hold on
plot3(x,y,z,'k.','markersize',8)
xlabel('HU')
ylabel('f (MHz)')
ylabel('frequency (MHz)')
title('Simultaneous Fit')
axis('tight')
makeFigureBig(h);

[~,center650] = min(abs(f500-0.65));
[~,center1000] = min(abs(f1000-1));
[~,center2250] = min(abs(f2250-2.25));

huHat = hu(fragsIdx500Layers);
attenHat = simultaneousFit.x1*huHat+simultaneousFit.x2*huHat.^2+simultaneousFit.xy*huHat.*0.65+simultaneousFit.a*0.65.^simultaneousFit.b+simultaneousFit.x0;
r650 = rSquared(atten500(fragsIdx500Layers,center650),attenHat.');

huHat = hu(fragsIdx1000Layers);
attenHat = simultaneousFit.x1*huHat+simultaneousFit.x2*huHat.^2+simultaneousFit.xy*huHat.*1+simultaneousFit.a*1.^simultaneousFit.b+simultaneousFit.x0;
r1000 = rSquared(atten1000(fragsIdx1000Layers,center1000),attenHat.');

huHat = hu(fragsIdx2250Layers);
attenHat = simultaneousFit.x1*huHat+simultaneousFit.x2*huHat.^2+simultaneousFit.xy*huHat.*2.25+simultaneousFit.a*2.25.^simultaneousFit.b+simultaneousFit.x0;
r2250 = rSquared(atten2250(fragsIdx2250Layers,center2250),attenHat.');

h = figure;
subplot(121)
ax = gca;
plot(xHat,zHat(9,:),xHat,zHat(16,:),xHat,zHat(41,:),'linewidth',2)
hold on
ax.ColorOrderIndex = 1;
plot(hu(fragsIdx500Layers),atten500(fragsIdx500Layers,center650),'*')
plot(hu(fragsIdx1000Layers),atten1000(fragsIdx1000Layers,center1000),'*')
plot(hu(fragsIdx2250Layers),atten2250(fragsIdx2250Layers,center2250),'*')
xlabel('HU')
ylabel('attenuation (Np/cm)')
title('Individual Frequencies')
grid on
legend(['0.65 MHz, r=', num2str(r650)],['1 MHz, r=', num2str(r1000)],['2.25 MHz, r=', num2str(r2250)])
makeFigureBig(h)

[~,hu1000Idx] = min(abs(hu(fragsIdx500Layers)-1e3));
[~,hu1500Idx] = min(abs(hu(fragsIdx500Layers)-1.5e3));
[~,hu2000Idx] = min(abs(hu(fragsIdx500Layers)-2e3));

hu1000 = hu(fragsIdx500Layers(hu1000Idx));
hu1500 = hu(fragsIdx500Layers(hu1500Idx));
hu2000 = hu(fragsIdx500Layers(hu2000Idx));

% z1 = simultaneousFit.x1*hu1000+simultaneousFit.x2*hu1000.^2+simultaneousFit.xy*hu1000*yHat+simultaneousFit.y1*yHat;
% z2 = simultaneousFit.x1*hu1500+simultaneousFit.x2*hu1500.^2+simultaneousFit.xy*hu1500*yHat+simultaneousFit.y1*yHat;
% z3 = simultaneousFit.x1*hu2000+simultaneousFit.x2*hu2000.^2+simultaneousFit.xy*hu2000*yHat+simultaneousFit.y1*yHat;

z1 = simultaneousFit.x1*hu1000+simultaneousFit.x2*hu1000.^2+simultaneousFit.xy*hu1000*yHat+simultaneousFit.a*yHat.^simultaneousFit.b+simultaneousFit.x0;
z2 = simultaneousFit.x1*hu1500+simultaneousFit.x2*hu1500.^2+simultaneousFit.xy*hu1500*yHat+simultaneousFit.a*yHat.^simultaneousFit.b+simultaneousFit.x0;
z3 = simultaneousFit.x1*hu2000+simultaneousFit.x2*hu2000.^2+simultaneousFit.xy*hu2000*yHat+simultaneousFit.a*yHat.^simultaneousFit.b+simultaneousFit.x0;

subplot(122);
ax = gca;
% plot(yHat,zHat(:,18),yHat,zHat(:,34),yHat,zHat(:,50),'linewidth',2);
plot(yHat,z1,yHat,z2,yHat,z3,'linewidth',2);
hold on
ax.ColorOrderIndex = 1;
plot([f500,f1000,f2250],[atten500(fragsIdx500Layers(hu1000Idx),:),atten1000(fragsIdx500Layers(hu1000Idx),:),atten2250(fragsIdx500Layers(hu1000Idx),:)],'*')
plot([f500,f1000,f2250],[atten500(fragsIdx500Layers(hu1500Idx),:),atten1000(fragsIdx500Layers(hu1500Idx),:),atten2250(fragsIdx500Layers(hu1500Idx),:)],'*')
plot([f500,f1000,f2250],[atten500(fragsIdx500Layers(hu2000Idx),:),atten1000(fragsIdx500Layers(hu2000Idx),:),atten2250(fragsIdx500Layers(hu2000Idx),:)],'*')
xlabel('frequency (MHz)')
ylabel('attenuation (Np/cm)')
title('Individual HU values')
legend(['HU = ', num2str(hu1000,3)],['HU = ', num2str(hu1500,3)],['HU = ', num2str(hu2000,3)],'location','northwest')
grid on
makeFigureBig(h)
pos = get(h,'position');
set(h,'position',[pos(1),pos(2),2*pos(3),pos(4)])

data.hu = x;
data.f = y;
data.atten = z;

definitions.hu = 'Average Hounsfield unit of sample for each measurement';
definitions.f = 'Frequency of each measurement';
definitions.atten = 'Measured attenuation';

save('C:\Users\Taylor\Documents\Projects\Stanford\Attenuation\figs\fullDataSet.mat','data','definitions','simultaneousFit');
