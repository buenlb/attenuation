% Plots attenuation as a function of HU
close all; clc;
if ~exist('atten500','var')
    runAttenuation
end
%% Use only the thick enough fragments
[~,~,~,fragsIdx500,fragsIdx1000,fragsIdx2250] = screenFragments(FragData);
%% correlate MR parameters to measurements at each frequency
zte = zeros(size(FragData'));
ute = zeros(size(FragData'));
t2 = zeros(size(FragData'));
for ii = 1:length(FragData)
    zte(ii) = FragData(ii).MR.ZTE;
    ute(ii) = FragData(ii).MR.UTE;
    t2(ii) = FragData(ii).MR.T2Star;
end
% 500 kHz
x500_zte = zte(fragsIdx500);
y500 = atten500(fragsIdx500,centerIdx500);
std500 = stdAtten500(fragsIdx500,centerIdx500);
[p500_zte,r500_zte,~,x2_500_zte,y2_500_zte,conf500ZTE] = myPolyFit(x500_zte,y500,'poly',1);

x500_ute = ute(fragsIdx500);
[p500_ute,r500_ute,~,x2_500_ute,y2_500_ute] = myPolyFit(x500_ute,y500,'poly',1);

x500_t2 = t2(fragsIdx500);
[p500_t2,r500_t2,~,x2_500_t2,y2_500_t2] = myPolyFit(x500_t2,y500,'poly',1);

% 1000 kHz
x1000_zte = zte(fragsIdx1000);
y1000 = atten1000(fragsIdx1000,centerIdx1000);
std1000 = stdAtten1000(fragsIdx1000,centerIdx1000);
[p1000_zte,r1000_zte,~,x2_1000_zte,y2_1000_zte,conf1000ZTE] = myPolyFit(x1000_zte,y1000,'poly',1);

x1000_ute = ute(fragsIdx1000);
[p1000_ute,r1000_ute,~,x2_1000_ute,y2_1000_ute] = myPolyFit(x1000_ute,y1000,'poly',1);

x1000_t2 = t2(fragsIdx1000);
[p1000_t2,r1000_t2,~,x2_1000_t2,y2_1000_t2] = myPolyFit(x1000_t2,y1000,'poly',1);

% 2250 kHz
x2250_zte = zte(fragsIdx2250);
y2250 = atten2250(fragsIdx2250,centerIdx2250);
std2250 = stdAtten2250(fragsIdx2250,centerIdx2250);
[p2250_zte,r2250_zte,~,x2_2250_zte,y2_2250_zte,conf2250ZTE] = myPolyFit(x2250_zte,y2250,'poly',1);

x2250_ute = ute(fragsIdx2250);
[p2250_ute,r2250_ute,~,x2_2250_ute,y2_2250_ute] = myPolyFit(x2250_ute,y2250,'poly',1);

x2250_t2 = t2(fragsIdx2250);
[p2250_t2,r2250_t2,~,x2_2250_t2,y2_2250_t2] = myPolyFit(x2250_t2,y2250,'poly',1);

%% Attenuation vs ZTE
h = figure;
hold on
ax = gca;
shadedErrorBar(x2_500_zte,y2_500_zte,conf500ZTE,'lineprops',{'--','color',ax.ColorOrder(1,:),'linewidth',2});
plt500 = errorbar(x500_zte,y500,std500/2,'o','linewidth',2,'markersize',8,'Color',ax.ColorOrder(1,:));
shadedErrorBar(x2_1000_zte,y2_1000_zte,conf1000ZTE,'lineprops',{'--','color',ax.ColorOrder(2,:),'linewidth',2});
plt1000 = errorbar(x1000_zte,y1000,std1000/2,'o','linewidth',2,'markersize',8,'Color',ax.ColorOrder(2,:));
shadedErrorBar(x2_2250_zte,y2_2250_zte,conf2250ZTE,'lineprops',{'--','color',ax.ColorOrder(3,:),'linewidth',2});
plt2250 = errorbar(x2250_zte,y2250,std2250/2,'o','linewidth',2,'markersize',8,'Color',ax.ColorOrder(3,:));

xlabel('ZTE Magnitude')
ylabel('Attenuation (Np/cm)')
grid on
lgd = legend([plt500(1),plt1000(1),plt2250(1)],['R^2=', num2str(r500_zte,2)],['R^2=', num2str(r1000_zte,2)],['R^2=', num2str(r2250_zte,2)],'location','northwest');
% set(lgd,'position',[ 0.6256    0.6270    0.3000    0.2476]);
axis([min(x2250_zte),max(x2250_zte),0,max(y2250)+max(std2250/2)])
makeFigureBig(h)

if exist('imgPath','var')
    print([imgPath, 'figs/zteVatten'], '-depsc')
end
%% Plot UTE and ZTE results
% 500
fSize = 24;
h = figure;
hold on
ax = gca;
plt500 = errorbar(x500_zte,y500,std500/2,'o','linewidth',2,'markersize',8);
ftPlot(1) = plot(x2_500_zte,y2_500_zte,'--','linewidth',2,'markersize',8,'Color',ax.ColorOrder(1,:));
plt500(2) = errorbar(x500_ute,y500,std500/2,'o','linewidth',2,'markersize',8,'Color',ax.ColorOrder(2,:));
ftPlot(2) = plot(x2_500_ute,y2_500_ute,'--','linewidth',2,'markersize',8,'Color',ax.ColorOrder(2,:));
grid on
lgd = legend(plt500,{'ZTE','UTE'},'location','northwest');
axis([0,1,0,20])

ah=axes('position',get(gca,'position'),'visible','off');
lgd2 = legend(ah,ftPlot,{['R^2: ',num2str(r500_zte,2)],['R^2: ',num2str(r500_ute,2)]},'location','southeast');
set(lgd2,'position',[0.5903    0.6773    0.2825    0.2250]);
% set(lgd2,'position',[0.6706    0.2388    0.2825    0.2164])
makeFigureBig(h,fSize,fSize);
axes(ax);
xlabel('Normalized Magnitude');
ylabel('Attenuation (Np/cm)')
makeFigureBig(h,fSize,fSize);
axes(ah);

if exist('imgPath','var')
    print([imgPath, 'figs/zteUteVatten500'], '-depsc')
end

% 1000
h = figure;
hold on
ax = gca;
plt1000 = errorbar(x1000_zte,y1000,std1000/2,'o','linewidth',2,'markersize',8);
ftPlot(1) = plot(x2_1000_zte,y2_1000_zte,'--','linewidth',2,'markersize',8,'Color',ax.ColorOrder(1,:));
plt1000(2) = errorbar(x1000_ute,y1000,std1000/2,'o','linewidth',2,'markersize',8,'Color',ax.ColorOrder(2,:));
ftPlot(2) = plot(x2_1000_ute,y2_1000_ute,'--','linewidth',2,'markersize',8,'Color',ax.ColorOrder(2,:));
grid on
lgd = legend(plt1000,{'ZTE','UTE'},'location','northwest');

ah=axes('position',get(gca,'position'),'visible','off');
lgd2 = legend(ah,ftPlot,{['R^2: ',num2str(r1000_zte,2)],['R^2: ',num2str(r1000_ute,2)]},'location','southeast');
set(lgd2,'position',[0.5903    0.6773    0.2825    0.2250]);
% set(lgd2,'position',[0.6706    0.2388    0.2825    0.2164])
makeFigureBig(h,fSize,fSize);
axes(ax);
axis([0,1,0,20])
xlabel('Normalized Magnitude');
ylabel('Attenuation (Np/cm)')
makeFigureBig(h,fSize,fSize);
axes(ah);

if exist('imgPath','var')
    print([imgPath, 'figs/zteUteVatten1000'], '-depsc')
end

% 2250
h = figure;
hold on
ax = gca;
plt2250 = errorbar(x2250_zte,y2250,std2250/2,'o','linewidth',2,'markersize',8);
ftPlot(1) = plot(x2_2250_zte,y2_2250_zte,'--','linewidth',2,'markersize',8,'Color',ax.ColorOrder(1,:));
plt2250(2) = errorbar(x2250_ute,y2250,std2250/2,'o','linewidth',2,'markersize',8,'Color',ax.ColorOrder(2,:));
ftPlot(2) = plot(x2_2250_ute,y2_2250_ute,'--','linewidth',2,'markersize',8,'Color',ax.ColorOrder(2,:));
grid on
lgd = legend(plt2250,{'ZTE','UTE'},'location','northwest');

ah=axes('position',get(gca,'position'),'visible','off');
lgd2 = legend(ah,ftPlot,{['R^2: ',num2str(r2250_zte,2)],['R^2: ',num2str(r2250_ute,2)]},'location','southeast');
set(lgd2,'position',[0.6706    0.2388    0.2825    0.2164])
makeFigureBig(h,fSize,fSize);
axes(ax);
axis([0,1,0,20])
xlabel('Normalized Magnitude');
ylabel('Attenuation (Np/cm)')
makeFigureBig(h,fSize,fSize);
axes(ah);

if exist('imgPath','var')
    print([imgPath, 'figs/zteUteVatten2250'], '-depsc')
end

%% T2*
% 500
fSize = 24;
h = figure;
hold on
ax = gca;
plt500 = errorbar(x500_t2,y500,std500/2,'o','linewidth',2,'markersize',8);
ftPlot(1) = plot(x2_500_t2,y2_500_t2,'--','linewidth',2,'markersize',8,'Color',ax.ColorOrder(1,:));
grid on
lgd = legend(ftPlot,{['R^2: ', num2str(r500_t2,2)]},'location','northeast');
ylabel('Attenuation (Np/cm)')
xlabel('T2* (ms)')
axis([0,3,0,20])
makeFigureBig(h,fSize,fSize);

if exist('imgPath','var')
    print([imgPath, 'figs/t2Vatten500'], '-depsc')
end

% 1000
fSize = 24;
h = figure;
hold on
ax = gca;
plt1000 = errorbar(x1000_t2,y1000,std1000/2,'o','linewidth',2,'markersize',8);
ftPlot(1) = plot(x2_1000_t2,y2_1000_t2,'--','linewidth',2,'markersize',8,'Color',ax.ColorOrder(1,:));
grid on
lgd = legend(ftPlot,{['R^2: ', num2str(r1000_t2,2)]},'location','northeast');
ylabel('Attenuation (Np/cm)')
xlabel('T2* (ms)')
axis([0,3,0,20])
makeFigureBig(h,fSize,fSize);

if exist('imgPath','var')
    print([imgPath, 'figs/t2Vatten1000'], '-depsc')
end

% 2250
fSize = 24;
h = figure;
hold on
ax = gca;
plt2250 = errorbar(x2250_t2,y2250,std2250/2,'o','linewidth',2,'markersize',8);
ftPlot(1) = plot(x2_2250_t2,y2_2250_t2,'--','linewidth',2,'markersize',8,'Color',ax.ColorOrder(1,:));
grid on
lgd = legend(ftPlot,{['R^2: ', num2str(r2250_t2,2)]},'location','southeast');
ylabel('Attenuation (Np/cm)')
xlabel('T2* (ms)')
axis([0,3,0,20])
makeFigureBig(h,fSize,fSize);

if exist('imgPath','var')
    print([imgPath, 'figs/t2Vatten2250'], '-depsc')
end