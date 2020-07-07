cPlus = load('cPlus.mat');
cMinus= load('cMinus.mat');
rhoPlus = load('rhoPlus.mat');
rhoMinus = load('rhoMinus.mat');
noVar = load('noVar.mat');

h = figure;
ax = gca;
hold on
% plot(f2250,atten2250(acrIdx,:),'-',f2250,f2250*1.6/8.686,'--',f2250,f2250/mean(f2250)*mean(atten2250(acrIdx,:)),':','Color',[0,0,0],'linewidth',2)
plot(cPlus.f2250,noVar.atten2250(idxToCompare,:),'-','Color',ax.ColorOrder(1,:),'linewidth',2)
plot(cPlus.f2250,cPlus.atten2250(idxToCompare,:),'--','Color',ax.ColorOrder(2,:),'linewidth',2)
plot(cPlus.f2250,cMinus.atten2250(idxToCompare,:),'--','Color',ax.ColorOrder(3,:),'linewidth',2)
plot(noVar.f2250,noVar.f2250*noVar.acrAttenuation,':','Color',[0,0,0],'linewidth',2)
% hold on
% [wvLocs,multiple] = findWaveLengthMultiples(f2250,d0,c*1e-3);
% for ii = 1:length(multiple)
%     plot([wvLocs(ii),wvLocs(ii)],[min(atten2250(acrIdx,:)),max(atten2250(acrIdx,:))],'--')
% end
grid on
xlabel('Frequency (MHz)')
ylabel('\alpha (Np/cm)')
% lgd = legend('Measured','Literature','Measured Avg. (\beta = 1)');
lgd = legend('Measured','5% Higher Vel.', '5% Lower Vel.','Literature');
axis('tight')
makeFigureBig(h)
% set(h,'position',[680   688   560   200]);
% set(lgd,'position',[0.2202    0.2671    0.4768    0.2966]);
% set(lgd,'position',[0.5042    0.3053    0.2643    0.2925]);

%%
cPlus = load('cPlus.mat');
cMinus= load('cMinus.mat');
rhoPlus = load('rhoPlus.mat');
rhoMinus = load('rhoMinus.mat');
noVar = load('noVar.mat');

h = figure;
ax = gca;
hold on
% plot(f2250,atten2250(acrIdx,:),'-',f2250,f2250*1.6/8.686,'--',f2250,f2250/mean(f2250)*mean(atten2250(acrIdx,:)),':','Color',[0,0,0],'linewidth',2)
plot(cPlus.f2250,noVar.atten2250(idxToCompare,:),'-','Color',ax.ColorOrder(1,:),'linewidth',2)
plot(cPlus.f2250,rhoPlus.atten2250(idxToCompare,:),'--','Color',ax.ColorOrder(2,:),'linewidth',2)
plot(cPlus.f2250,rhoMinus.atten2250(idxToCompare,:),'--','Color',ax.ColorOrder(3,:),'linewidth',2)
plot(noVar.f2250,noVar.f2250*noVar.acrAttenuation,':','Color',[0,0,0],'linewidth',2)
% hold on
% [wvLocs,multiple] = findWaveLengthMultiples(f2250,d0,c*1e-3);
% for ii = 1:length(multiple)
%     plot([wvLocs(ii),wvLocs(ii)],[min(atten2250(acrIdx,:)),max(atten2250(acrIdx,:))],'--')
% end
grid on
xlabel('Frequency (MHz)')
ylabel('\alpha (Np/cm)')
% lgd = legend('Measured','Literature','Measured Avg. (\beta = 1)');
lgd = legend('Measured','5% Higher \rho', '5% Lower \rho','Literature');
axis('tight')
makeFigureBig(h)
% set(h,'position',[680   688   560   200]);
% set(lgd,'position',[0.2202    0.2671    0.4768    0.2966]);
% set(lgd,'position',[0.5042    0.3053    0.2643    0.2925]);