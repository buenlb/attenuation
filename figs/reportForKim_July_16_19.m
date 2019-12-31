clear; close all; clc;
SEMI_INFINITE = 1;
runAttenuation;

atten500Si = atten500;
atten1000Si = atten1000;
atten2250Si = atten2250;

SEMI_INFINITE = 0;
runAttenuation;

%% Vs HU
% Select a CT to compare to
% ctIdx = find(strcmp(CtData.kernels,'Bone') & CtData.energies==120 & strcmp(CtData.vendor,'GE') & strcmp(CtData.reconMethod,'Standard'));
ctIdx = find(strcmp(CtData.kernels,'Soft Tissue') & CtData.energies==120 & strcmp(CtData.vendor,'GE') & strcmp(CtData.reconMethod,'MBIR'));
hu = getHU(FragData);

[~,idx500] = min(abs(f500-0.5));
[~,idx1000] = min(abs(f1000-1));
[~,idx2250] = min(abs(f2250-2.25));
d = [FragData.thickness];

[~,~,~,fragsIdx500,fragsIdx1000,fragsIdx2250] = screenFragments(FragData);

% fragsIdx500 = 1:length(FragData);
% fragsIdx1000 = 1:length(FragData);
% fragsIdx2250 = 1:length(FragData);

y500 = atten500(fragsIdx500,idx500);
x500 = hu(:,fragsIdx500);
[p500,r500,x2_500,y2_500] = fits(x500,y500);

y1000 = atten1000(fragsIdx1000,idx1000);
x1000 = hu(:,fragsIdx1000);
[p1000,r1000,x2_1000,y2_1000] = fits(x1000,y1000);

y2250 = atten2250(fragsIdx2250,idx2250);
x2250 = hu(:,fragsIdx2250);
[p2250,r2250,x2_2250,y2_2250] = fits(x2250,y2250);

y500Si = atten500Si(fragsIdx500,idx500);
x500Si = hu(:,fragsIdx500);
[p500Si,r500Si,x2_500Si,y2_500Si] = fits(x500Si,y500Si);

y1000Si = atten1000Si(fragsIdx1000,idx1000);
x1000Si = hu(:,fragsIdx1000);
[p1000Si,r1000Si,x2_1000Si,y2_1000Si] = fits(x1000Si,y1000Si);

y2250Si = atten2250Si(fragsIdx2250,idx2250);
x2250Si = hu(:,fragsIdx2250);
[p2250Si,r2250Si,x2_2250Si,y2_2250Si] = fits(x2250Si,y2250Si);

h = figure(1); clf;
% plot(x500,y500,'^',x1000,y1000,'^',x2250,y2250,'^','linewidth',2,'markersize',8)
hold on
ax = gca;
plot(x2_500(ctIdx,:),y2_500(ctIdx,:),'-',x2_1000(ctIdx,:),y2_1000(ctIdx,:),'-',x2_2250(ctIdx,:),y2_2250(ctIdx,:),'-','linewidth',3);
ax.ColorOrderIndex = 1;
plot(x2_500Si(ctIdx,:),y2_500Si(ctIdx,:),'--',x2_1000Si(ctIdx,:),y2_1000Si(ctIdx,:),'--',x2_2250Si(ctIdx,:),y2_2250Si(ctIdx,:),'--','linewidth',3);
plt4 = plot(-1,-1,'k-',-1,-1,'k--','linewidth',2);

ax.ColorOrderIndex = 1;
plt2 = plot(-1,-1,'linewidth',2);
plt2(2) = plot(-1,-1,'linewidth',2);
plt2(3) = plot(-1,-1,'linewidth',2);

% Legends
legend(plt4,'Layered','Semi-Inifinte','location','northeast')
% set(lgd1, 'Position', [0.6250    0.6000    0.2911    0.3476]);
% axis([0,1,500,3e3])
ax = gca;
axis([min(x2250(ctIdx,:)),max(x2250(ctIdx,:)),0,max(y2250(:))])

ah=axes('position',get(gca,'position'),'visible','off');
lgd2 = legend(ah,plt2,{'0.5 MHz','1 MHz', '2.25 MHz'},'location','northwest');
set(lgd2,'Position',[0.6173    0.5460    0.2571    0.2048]);
makeFigureBig(h);

axes(ax);
% legend(plt2,['0.5, R:', num2str(r500)],['1, R:', num2str(r1000)],['2.25, R:', num2str(r2250)],'location', 'northeast')
xlabel('HU')
ylabel('Attenuation (np/cm)')
grid on

makeFigureBig(h);
axes(ah);
makeFigureBig(h);

clc
disp('           -----------------------------Results-----------------------------')
disp('                      --Semi-Infinite--        --Layered--')
disp('500 kHz')
disp(['  R^2                        ', num2str(mean(r500),2), '                 ', num2str(mean(r500Si),2)])
disp(['  Slope (mnp/HU)             ', num2str(1e3*mean(squeeze(p500(:,1))),2), '                 ', num2str(1e3*mean(squeeze(p500Si(:,1))),2)])
disp(['  Intercept (np/cm)          ', num2str(mean(squeeze(p500(:,2))),2), '                  ', num2str(mean(squeeze(p500Si(:,2))),2)])
disp('1000 kHz')
disp(['  R^2                        ', num2str(mean(r1000),2), '                 ', num2str(mean(r1000Si),2)])
disp(['  Slope (mnp/HU)             ', num2str(1e3*mean(squeeze(p1000(:,1))),2), '                   ', num2str(1e3*mean(squeeze(p1000Si(:,1))),2)])
disp(['  Intercept (np/cm)          ', num2str(mean(squeeze(p1000(:,2))),2), '                     ', num2str(mean(squeeze(p1000Si(:,2))),2)])
disp('2250 kHz')
disp(['  R^2                        ', num2str(mean(r2250),2), '                 ', num2str(mean(r2250Si),2)])
disp(['  Slope (mnp/HU)             ', num2str(1e3*mean(squeeze(p2250(:,1))),2), '                   ', num2str(1e3*mean(squeeze(p2250Si(:,1))),2)])
disp(['  Intercept (np/cm)          ', num2str(mean(squeeze(p2250(:,2))),2), '                     ', num2str(mean(squeeze(p2250Si(:,2))),2)])

%% Vs Frequency
idx = find(d>4.4e-3);
fragNo = 3;

h = figure(99);
clf
hold on
ax = gca;
plot(f500,atten500Si(idx(fragNo),:),'--','Color',ax.ColorOrder(1,:),'linewidth',3)
plot(f1000,atten1000Si(idx(fragNo),:),'--','Color',ax.ColorOrder(2,:),'linewidth',3)
plot(f2250,atten2250Si(idx(fragNo),:),'--','Color',ax.ColorOrder(3,:),'linewidth',3)
plt1 = plot(-1,-1,'k--','linewidth',2);

ax = gca;
plot(f500,atten500(idx(fragNo),:),'-','Color',ax.ColorOrder(1,:),'linewidth',3)
plot(f1000,atten1000(idx(fragNo),:),'-','Color',ax.ColorOrder(2,:),'linewidth',3)
plot(f2250,atten2250(idx(fragNo),:),'-','Color',ax.ColorOrder(3,:),'linewidth',3)
plt2 = plot(-1,-1,'k-','linewidth',2);
xlabel('Frequency (MHz)')
ylabel('Attenuation (np/cm)')
title('Attenuation')
axis([min(f500),2.5,0,max(atten2250(idx(fragNo),:))])
legend([plt1,plt2],{'Semi-infinite','3-layer'},'location','southeast')
grid on
makeFigureBig(h)

% Understanding variation in insertion loss in low frequency range
h = figure;
ax = gca;

% Measured
plot(f500,il500_all(idx(fragNo),:),'linewidth',2)
hold on
% ax.ColorOrderIndex = 1;
% plot(f1000,il1000_all(idx(1),:),'linewidth',2)
% ax.ColorOrderIndex = 1;
% plot(f2250,il2250_all(idx(1),:),'linewidth',2)

% Estimated
d0 = FragData(idx(fragNo)).thickness*1e3;
c = mean(FragData(idx(fragNo)).Velocity.measuredVelocity);
rho = FragData(idx(fragNo)).density;
for ii = 1:length(f500)
    [~,T(ii)] = estimateGamma3Layer(c,rho,d0,f500(ii),mean(atten500(idx(fragNo),:)));
    [~,T2(ii)] = estimateGamma3Layer(c,rho,d0,f500(ii));
end

gamma = estimateGamma(c,rho);
tSi = (1+gamma)*(1-gamma)*exp(-mean(atten500(idx(fragNo),:))*d0/10);
% ax.ColorOrderIndex = 1;
plot(f500,abs(T),'--','linewidth',2)
% ax.ColorOrderIndex = 1;
plot(f500,ones(size(f500))*tSi,'-.','linewidth',2)
% ax.ColorOrderIndex = 1;
% plot(f500,abs(T2),'-^','linewidth',2)
legend('Measured Insertion Loss','Simulated 3-Layer','Simulated Semi-infinite','location','southeast')
grid on
title('Insertion Loss')
makeFigureBig(h)
pos = get(ax,'position');

h = figure;
hold on
ax = gca;
ax.ColorOrderIndex = 2;
plot(f500,atten500(idx(fragNo),:),'--','linewidth',2)
plot(f500,atten500Si(idx(fragNo),:),'-.','linewidth',2)
title('Attenuation')
legend('3-layer','Semi-infinite','location','northeast')
grid on
makeFigureBig(h)
pos2 = get(ax,'position');
% set(ax,'position',[pos2(1:2),pos(3:4)]);