% This script makes a figure of the variation in attenuation with
% frequency. The values are derived from runAttenuation which uses the raw
% recordings of measuremetns with and without a bone fragment present to
% measure the attenuation in each fragment.

clc;

if ~exist('FragData','var')
    clear; close all; clc;
    runAttenuation
end

% Ignore some of the fragments whose thickness is too small.
[~,~,~,idx500,idx1000,idx2250] = screenFragments(FragData);

[ot,med,it,uk] = fragmentLayers(FragData);
cort = [ot,it];

mdIdx = intersect(med,idx500);
corticalIdx = intersect(cort,idx500);
mdIdx1000 = intersect(med,idx1000);
corticalIdx1000 = intersect(cort,idx1000);
mdIdx2250 = intersect(med,idx2250);
corticalIdx2250 = intersect(cort,idx2250);

mean500Md = mean(atten500(mdIdx,:),1);
std500Md = std(atten500(mdIdx,:),[],1);%/length(mdIdx);

mean1000Md = mean(atten1000(mdIdx1000,:),1);
std1000Md = std(atten1000(mdIdx1000,:),[],1);%/length(mdIdx1000);

mean2250Md = mean(atten2250(mdIdx2250,:),1);
std2250Md = std(atten2250(mdIdx2250,:),[],1);%/length(mdIdx2250);

mean500Cort = mean(atten500(corticalIdx,:),1);
std500Cort = std(atten500(corticalIdx,:),[],1);%/length(corticalIdx);

mean1000Cort = mean(atten1000(corticalIdx1000,:),1);
std1000Cort = std(atten1000(corticalIdx1000,:),[],1);%/length(corticalIdx1000);

mean2250Cort = mean(atten2250(corticalIdx2250,:),1);
std2250Cort = std(atten2250(corticalIdx2250,:),[],1);%/length(corticalIdx2250);

mean500 = mean(atten500([mdIdx,corticalIdx],:));
mean1000 = mean(atten1000([mdIdx1000,corticalIdx1000],:));
mean2250 = mean(atten2250([mdIdx2250,corticalIdx2250],:));

h = figure;
shadedErrorBar(f500,mean500Md,std500Md,'lineprops',{'MarkerFaceColor',ax.ColorOrder(1,:),'linewidth',2})
hold on
shadedErrorBar(f1000,mean1000Md,std1000Md,'lineprops',{'MarkerFaceColor',ax.ColorOrder(2,:),'Color',ax.ColorOrder(2,:),'linewidth',2})
shadedErrorBar(f2250,mean2250Md,std2250Md,'lineprops',{'MarkerFaceColor',ax.ColorOrder(3,:),'Color',ax.ColorOrder(3,:),'linewidth',2})

ax = gca;
ax.ColorOrderIndex = 1;

plot(f500,mean500Cort,':','linewidth',2)
shadedErrorBar(f1000,mean1000Cort,std1000Cort,'lineprops',{':','MarkerFaceColor',ax.ColorOrder(2,:),'Color',ax.ColorOrder(2,:),'linewidth',2})
shadedErrorBar(f2250,mean2250Cort,std2250Cort,'lineprops',{':','MarkerFaceColor',ax.ColorOrder(3,:),'Color',ax.ColorOrder(3,:),'linewidth',2})

plt = plot(-1,-1,'k-','linewidth',2);
plt(2) = plot(-1,-1,'k:','linewidth',2);

ax.ColorOrderIndex = 1;
plt2 = plot(-1,-1,'linewidth',2);
plt2(2) = plot(-1,-1,'linewidth',2);
plt2(3) = plot(-1,-1,'linewidth',2);


axis([0.25,2.5,0,10])
title('Attenuation as a function of Frequency')
xlabel('Frequency (MHz)')
ylabel('Attenuation (Np/cm)')

% Legends
lgd1 = legend(plt,'Medullary Fragments','Cortical Fragments','location','southeast');
% set(lgd1, 'Position', [0.6250    0.6000    0.2911    0.3476]);
% axis([0,1,500,3e3])
ax = gca;

ah=axes('position',get(gca,'position'),'visible','off');
lgd2 = legend(ah,plt2,{'0.5 MHz','1 MHz', '2.25 MHz'},'location','northwest');
makeFigureBig(h);

axes(ax);
grid on
fSize = 18;
makeFigureBig(h,fSize,fSize)
axes(ah)
makeFigureBig(h,fSize,fSize)

if exist('imgPath','var')
    print([imgPath, 'figs\freqVatten'], '-depsc')
end

%% Measure Beta
% All Fragments
y = [mean500Md,mean1000Md,mean2250Md];
x = [f500,f1000,f2250];

[a,b,gof] = myNonlinearFit(x,y);

y = [mean500Cort,mean1000Cort,mean2250Cort];
[aCort,bCort,gofCort] = myNonlinearFit(x,y);

% By Transducer 500
y = [mean500Md];
x = [f500];

[a500,b500,gof500] = myNonlinearFit(x,y);

y = [mean500Cort];
[aCort500,bCort500,gofCort500] = myNonlinearFit(x,y);

% By Transducer 1000
y = [mean1000Md];
x = [f1000];

[a1000,b1000,gof1000] = myNonlinearFit(x,y);

y = [mean1000Cort];
[aCort1000,bCort1000,gofCort1000] = myNonlinearFit(x,y);

% By Transducer 2250
y = [mean2250Md];
x = [f2250];

[a2250,b2250,gof2250] = myNonlinearFit(x,y);

y = [mean2250Cort];
[aCort2250,bCort2250,gofCort2250] = myNonlinearFit(x,y);

% By Transducer 500 Both Types
y = [mean500];
x = [f500];

[a500all,b500all,gof500all] = myNonlinearFit(x,y);

% By Transducer 1000 Both Types
y = [mean1000];
x = [f1000];

[a1000all,b1000all,gof1000all] = myNonlinearFit(x,y);
% By Transducer 2250 Both Types
y = [mean2250];
x = [f2250];

[a2250all,b2250all,gof2250all] = myNonlinearFit(x,y);

% All Both Types
y = [mean500,mean1000,mean2250];
x = [f500,f1000,f2250];

[aall,ball,gofall] = myNonlinearFit(x,y);

%%
disp('Beta Results *****************************')
disp('  Medullary')
disp(['    All:      Alpha0: ', num2str(a,2),     ',   Beta: ', num2str(b,2)])
disp(['    500 kHz:  Alpha0: ', num2str(a500,2),  ',   Beta: ', num2str(b500,2)])
disp(['    2250 kHz: Alpha0: ', num2str(a1000,2), ',   Beta: ', num2str(b1000,2)])
disp(['    1000 kHz: Alpha0: ', num2str(a2250,2), ',   Beta: ', num2str(b2250,2)])

disp('  Cortical')
disp(['    All:      Alpha0: ', num2str(aCort,2),     ',   Beta: ', num2str(bCort,2)])
disp(['    500 kHz:  Alpha0: ', num2str(aCort500,2),  ',   Beta: ', num2str(bCort500,2)])
disp(['    2250 kHz: Alpha0: ', num2str(aCort1000,2), ',   Beta: ', num2str(bCort1000,2)])
disp(['    1000 kHz: Alpha0: ', num2str(aCort2250,2), ',   Beta: ', num2str(bCort2250,2)])

disp('  Both')
disp(['    All:      Alpha0: ', num2str(aall,2),     ',   Beta: ', num2str(ball,2)])
disp(['    500 kHz:  Alpha0: ', num2str(a500all,2),  ',   Beta: ', num2str(b500all,2)])
disp(['    2250 kHz: Alpha0: ', num2str(a1000all,2), ',   Beta: ', num2str(b1000all,2)])
disp(['    1000 kHz: Alpha0: ', num2str(a2250all,2), ',   Beta: ', num2str(b2250all,2)])