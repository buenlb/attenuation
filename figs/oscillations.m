%% This script creates figures to illustrate the oscillations in the 
% insertion loss caused by resonances (?) in the fragment. It creates the
% plots used in the discussion section to address this issue.
clear
if ~exist('acrylicFrags','var')
    clear; close all; clc;
    acrylic
end

idxToCompare = 6;
acrAttenuation = 0.15; % Np/cm/MHz from Selfridge, Approximate Material Properties in Isotropic Materials

%% Plot estimated and measured insertion loss
% Estimated
d0 = acrylicFrags(idxToCompare).thickness;
c = acrylicFrags(idxToCompare).c;
rho = acrylicFrags(idxToCompare).rho;
for ii = 1:length(f2250)
    [~,T(ii)] = estimateGamma3Layer(c,rho,d0,f2250(ii),f2250(ii)*acrAttenuation);
end

h = figure;
ax = gca;
plot(f2250,20*log10(il2250_all(idxToCompare,:)),'-',f2250,20*log10(abs(T)),'--','Color',[0,0,0],'linewidth',2)
% hold on
% [wvLocs,multiple] = findWaveLengthMultiples(f2250,d0,c*1e-3);
% for ii = 1:length(multiple)
%     plot([wvLocs(ii),wvLocs(ii)],[min(20*log10(il2250_all(idxToCompare,:))),max(20*log10(il2250_all(idxToCompare,:)))],'--')
% end
grid on
xlabel('Frequency (MHz)')
ylabel('IL (dB)')
lgd = legend('Measured','Simulated');
axis('tight')
makeFigureBig(h);
set(h,'position',[680   688   560   200]);
set(lgd,'position',[0.5381    0.6822    0.2643    0.2925]);
if exist('imgPath','var')
    print([imgPath, 'figs\limitationsIl'], '-depsc')
end

%% Plot Attenuation against Literature Values
h = figure;
hold on
ax = gca;
% plot(f2250,atten2250(acrIdx,:),'-',f2250,f2250*1.6/8.686,'--',f2250,f2250/mean(f2250)*mean(atten2250(acrIdx,:)),':','Color',[0,0,0],'linewidth',2)
plot(f2250,atten2250(idxToCompare,:),'-',f2250,f2250*acrAttenuation,':','Color',[0,0,0],'linewidth',2)
plot(f2250,mean(atten2250([3,4,6],:),1),'--','Color',[0,0,0],'linewidth',2)
% hold on
% [wvLocs,multiple] = findWaveLengthMultiples(f2250,d0,c*1e-3);
% for ii = 1:length(multiple)
%     plot([wvLocs(ii),wvLocs(ii)],[min(atten2250(acrIdx,:)),max(atten2250(acrIdx,:))],'--')
% end
grid on
xlabel('Frequency (MHz)')
ylabel('\alpha (Np/cm)')
% lgd = legend('Measured','Literature','Measured Avg. (\beta = 1)');
lgd = legend('Measured','Literature');
axis('tight')
makeFigureBig(h)
set(h,'position',[680   688   560   200]);
% set(lgd,'position',[0.2202    0.2671    0.4768    0.2966]);
set(lgd,'position',[0.5042    0.3053    0.2643    0.2925]);

if exist('imgPath','var')
    print([imgPath, 'figs\limitationsAtten'], '-depsc')
end