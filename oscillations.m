% close all;
if ~exist('atten500','var')
    runAttenuation
end

[~,~,~,fragsIdx500Layers,fragsIdx1000Layers,fragsIdx2250Layers] = screenFragments(FragData);

idx = fragsIdx500Layers(4);

il = [il500_all(idx,:),il1000_all(idx,:),il2250_all(idx,:)];
f = [f500,f1000,f2250];

il500 = -20*log10(il500_all(idx,:));
il1000 = -20*log10(il1000_all(idx,:));
il2250 = -20*log10(il2250_all(idx,:));

h = figure;
hold on
plot(f500,atten500(idx,:),'-','linewidth',2)
plot(f1000,atten1000(idx,:),'-','linewidth',2)
plot(f2250,atten2250(idx,:),'-','linewidth',2)

xlabel('frequency (MHz)');
ylabel('\alpha (Np/cm)')
makeFigureBig(h);
pos = get(h,'position');
set(h,'position',[pos(1),pos(2),pos(3),1/2*pos(4)]);

if exist('imgPath','var')
    print([imgPath, 'figs/limitationsSingle'], '-depsc')
end

h = figure;
ax = gca;
hold on
a500 = mean(atten500,1);
a500Std = std(atten500,[],1);

a1000 = mean(atten1000,1);
a1000Std = std(atten1000,[],1);

a2250 = mean(atten2250,1);
a2250Std = std(atten2250,[],1);

shadedErrorBar(f500,a500,a500Std,'lineprops',{'-','color',ax.ColorOrder(1,:),'linewidth',2});
shadedErrorBar(f1000,a1000,a1000Std,'lineprops',{'-','color',ax.ColorOrder(2,:),'linewidth',2});
shadedErrorBar(f2250,a2250,a2250Std,'lineprops',{'-','color',ax.ColorOrder(3,:),'linewidth',2});

xlabel('frequency (MHz)');
ylabel('\alpha (Np/cm)')
makeFigureBig(h);
pos = get(h,'position');
set(h,'position',[pos(1),pos(2),pos(3),1/2*pos(4)]);
% plot2svg([imgPath, 'figs/limitationsAvg.svg'])
% if exist('imgPath','var')
%     print('-opengl',[imgPath, 'figs/limitationsAvg'], '-depsc')
% end