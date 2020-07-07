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
std500 = std(atten500([mdIdx,corticalIdx],:),[],1);%/length(corticalIdx2250);
mean1000 = mean(atten1000([mdIdx1000,corticalIdx1000],:));
std1000 = std(atten1000([mdIdx1000,corticalIdx1000],:),[],1);%/length(corticalIdx2250);
mean2250 = mean(atten2250([mdIdx2250,corticalIdx2250],:));
std2250 = std(atten2250([mdIdx2250,corticalIdx2250],:),[],1);%/length(corticalIdx2250);

% All Fragments
h = figure;
fSize = 26;
ax = gca;

shadedErrorBar(f500,mean500,std500,'lineprops',{'-','MarkerFaceColor',ax.ColorOrder(1,:),'Color',ax.ColorOrder(1,:),'linewidth',2})
hold on
shadedErrorBar(f1000,mean1000,std1000,'lineprops',{'-','MarkerFaceColor',ax.ColorOrder(2,:),'Color',ax.ColorOrder(2,:),'linewidth',2})
shadedErrorBar(f2250,mean2250,std2250,'lineprops',{'-','MarkerFaceColor',ax.ColorOrder(3,:),'Color',ax.ColorOrder(3,:),'linewidth',2})
axis([0.25,2.5,0,10])
xlabel('Frequency (MHz)')
ylabel('Attenuation (Np/cm)')

lgd = legend('0.5 MHz','1 MHz', '2.25 MHz','location','northwest');
grid on
makeFigureBig(h,fSize,fSize);

if exist('imgPath','var')
    print('-opengl',[imgPath, 'figs\freqVattenAll'], '-depsc')
end

% Medullary Fragments
h = figure;
ax = gca;
shadedErrorBar(f500,mean500Md,std500Md,'lineprops',{'MarkerFaceColor',ax.ColorOrder(1,:),'Color',ax.ColorOrder(1,:),'linewidth',2})
hold on
shadedErrorBar(f1000,mean1000Md,std1000Md,'lineprops',{'MarkerFaceColor',ax.ColorOrder(2,:),'Color',ax.ColorOrder(2,:),'linewidth',2})
shadedErrorBar(f2250,mean2250Md,std2250Md,'lineprops',{'MarkerFaceColor',ax.ColorOrder(3,:),'Color',ax.ColorOrder(3,:),'linewidth',2})
axis([0.25,2.5,0,10])
grid on
xlabel('Frequency (MHz)')
ylabel('Attenuation (Np/cm)')
makeFigureBig(h,fSize,fSize);

if exist('imgPath','var')
    print('-opengl',[imgPath, 'figs\freqVattenMed'], '-depsc')
end

% Cortical Fragments
h = figure;
plot(f500,mean500Cort,'-','linewidth',2)
shadedErrorBar(f1000,mean1000Cort,std1000Cort,'lineprops',{'-','MarkerFaceColor',ax.ColorOrder(2,:),'Color',ax.ColorOrder(2,:),'linewidth',2})
shadedErrorBar(f2250,mean2250Cort,std2250Cort,'lineprops',{'-','MarkerFaceColor',ax.ColorOrder(3,:),'Color',ax.ColorOrder(3,:),'linewidth',2})
axis([0.25,2.5,0,10])
grid on
xlabel('Frequency (MHz)')
ylabel('Attenuation (Np/cm)')
makeFigureBig(h,fSize,fSize)

if exist('imgPath','var')
    print('-opengl',[imgPath, 'figs\freqVattenCort'], '-depsc')
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

% Rolling beta
% [xRolling,idx] = sort(x);
% yRolling = y(idx);
% for ii = 1:(length(y)-1)
%     a1 = yRolling(ii);
%     a2 = yRolling(ii+1);
%     f1 = xRolling(ii);
%     f2 = xRolling(ii+1);
%     ratAtten(ii) = a1/a2;
%     ratF(ii) = f1/f2;
%     betaRolling(ii) = myLog(f2/f1,a2/a1);
% end
% betaRolling(betaRolling>10) = nan;
% figure
% plot(xRolling(2:end),betaRolling,'*')
% axis([min(x),max(x),0,2])

%%
disp('Beta Results *****************************')
disp('  Medullary')
disp(['    All:      Alpha0: ', num2str(a,2),     ',   Beta: ', num2str(b,2)])
disp(['    500 kHz:  Alpha0: ', num2str(a500,2),  ',   Beta: ', num2str(b500,2)])
disp(['    1000 kHz: Alpha0: ', num2str(a1000,2), ',   Beta: ', num2str(b1000,2)])
disp(['    2250 kHz: Alpha0: ', num2str(a2250,2), ',   Beta: ', num2str(b2250,2)])

disp('  Cortical')
disp(['    All:      Alpha0: ', num2str(aCort,2),     ',   Beta: ', num2str(bCort,2)])
disp(['    500 kHz:  Alpha0: ', num2str(aCort500,2),  ',   Beta: ', num2str(bCort500,2)])
disp(['    1000 kHz: Alpha0: ', num2str(aCort1000,2), ',   Beta: ', num2str(bCort1000,2)])
disp(['    2250 kHz: Alpha0: ', num2str(aCort2250,2), ',   Beta: ', num2str(bCort2250,2)])

disp('  Both')
disp(['    All:      Alpha0: ', num2str(aall,2),     ',   Beta: ', num2str(ball,2)])
disp(['    500 kHz:  Alpha0: ', num2str(a500all,2),  ',   Beta: ', num2str(b500all,2)])
disp(['    1000 kHz: Alpha0: ', num2str(a1000all,2), ',   Beta: ', num2str(b1000all,2)])
disp(['    2250 kHz: Alpha0: ', num2str(a2250all,2), ',   Beta: ', num2str(b2250all,2)])

%% Beta in individual fragments at 2.25 MHz
all2250 = atten2250([mdIdx2250,corticalIdx2250],:);
hu2250 = hu([mdIdx2250,corticalIdx2250]);
clear b2250All
x = f2250;
for ii = 1:size(all2250,1)
    y = all2250(ii,:);   
    [a2250All(ii),b2250All(ii),g(ii)] = myNonlinearFit(x,y);
end

b2250All([g.rsquare]<0.90) = nan;
figure
plot(hu2250,b2250All,'*')