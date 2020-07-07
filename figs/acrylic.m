% This script outputs the results of the acrylic experiment - a validation
% for the rest of the data
clear; close all; clc;

acrylicFrags = defineAcrylicFrags('C:\Users\Taylor\Documents\Projects\Stanford\Attenuation\AcrylicData\20200406_hodgpodge\');
% acrylicFrags = defineAcrylicFrags('C:\Users\Taylor\Documents\Projects\Stanford\Attenuation\AcrylicData\20190917\');
%% Find the 20dB idx so it is consistent
tmpIdx = 2;
if ~isempty(acrylicFrags(tmpIdx).Attenuation.kHz500.pb)
    kHz500Data = 1;
else
    kHz500Data = 0;
end

dt2250 = acrylicFrags(tmpIdx).Attenuation.kHz2250.t(2)-acrylicFrags(tmpIdx).Attenuation.kHz2250.t(1);
if kHz500Data
    dt500 = acrylicFrags(tmpIdx).Attenuation.kHz500.t(2)-acrylicFrags(tmpIdx).Attenuation.kHz500.t(1);
end

[~,f2250,idx20dB_2250] = insertionLoss(acrylicFrags(tmpIdx).Attenuation.kHz2250.pb{1},acrylicFrags(tmpIdx).Attenuation.kHz2250.pnb{1},dt2250);
if kHz500Data
    [~,f500,idx20dB_500] = insertionLoss(acrylicFrags(tmpIdx).Attenuation.kHz500.pb{1},acrylicFrags(tmpIdx).Attenuation.kHz500.pnb{1},dt500);
end

SEMI_INFINITE = 0;
validIdx = [];
%%
for ii = 1:length(acrylicFrags)
    c = acrylicFrags(ii).c;
    rho = acrylicFrags(ii).rho;
    d = acrylicFrags(ii).thickness;
    thLabel{ii} = [num2str(d),'mm'];
    if isempty(acrylicFrags(ii).Attenuation.kHz2250.pb)
        thLabel{ii} = [num2str(d),'mm'];
        continue
    end
    validIdx(end+1) = ii;
    
    for jj = 1:length(acrylicFrags(ii).Attenuation.kHz2250.pb)
        if kHz500Data
            tmp500(jj,:) = insertionLoss(acrylicFrags(ii).Attenuation.kHz500.pb{jj},acrylicFrags(ii).Attenuation.kHz500.pnb{jj},dt500,idx20dB_500);
        end
%         tmp1000(jj,:) = insertionLoss(acrylicFrags(ii).Attenuation.kHz1000.RawData.pb{jj},acrylicFrags(ii).Attenuation.kHz1000.RawData.pnb{jj},dt1000,idx20dB_1000);
        [tmp2250(jj,:),f] = insertionLoss(acrylicFrags(ii).Attenuation.kHz2250.pb{jj},acrylicFrags(ii).Attenuation.kHz2250.pnb{jj},dt2250,idx20dB_2250);
    end
    if kHz500Data
        il500 = mean(tmp500,1);
        il500_all(ii,:) = il500;
    end
%     il1000 = mean(tmp1000,1);
    il2250 = mean(tmp2250,1);
    il2250Std(ii,:) = std(tmp2250,[],1);
%     il1000_all(ii,:) = il1000;
    il2250_all(ii,:) = il2250;
    
    if SEMI_INFINITE
        % Reflection coeficient
        gamma = estimateGamma(mean(acrylicFrags(ii).Velocity.measuredVelocity),...
            acrylicFrags(ii).density);
        % Attenuation
        atten500(ii,:) = il2atten(il500,gamma,acrylicFrags(ii).thickness*1e2);
        atten1000(ii,:) = il2atten(il1000,gamma,acrylicFrags(ii).thickness*1e2);
        atten2250(ii,:) = il2atten(il2250,gamma,acrylicFrags(ii).thickness*1e2);
    else
        if kHz500Data
            for jj = 1:length(f500)
                atten500(ii,jj) = estimateAttenuation3Layer(c,rho,d,f500(jj),il500(jj));
            end
        end
%         for jj = 1:length(f1000)
%             atten1000(ii,jj) = estimateAttenuation3Layer(c,rho,d,f1000(jj),il1000(jj));
%         end
        for jj = 1:length(f2250)
            atten2250(ii,jj) = estimateAttenuation3Layer(c,rho,d,f2250(jj),il2250(jj));
        end
    end
end

%% Plot Results
validIdx = [6];
figure
hold on
for ii = 1:length(validIdx)
    errorbar(f2250,il2250_all(validIdx(ii),:),il2250Std(validIdx(ii),:)/2,'linewidth',2)
end
grid on
xlabel('frequency (MHz)')
ylabel('Insertion Loss')
legend(thLabel{validIdx})

%% Acrylic Results
% validIdx = [9,12];
validIdx = [2:6];

[~,centerIdx] = min(abs(f2250-2.25));

h = figure;
clf
ax = gca;
plt = plot(f2250,atten2250(validIdx,:),'linewidth',2);
xlabel('frequency (MHz)')
ylabel('attenuation (Np/cm)')
grid on
hold on

% Plot wavelength markers to understand potential resonance
c = acrylicFrags(validIdx(1)).c;
mts = 1:10;
% for ii = 1:length(mts)
%     x = c*1e-3/(1/mts(ii)*acrylicFrags(validIdx(1)).thickness);
%     if x > 1.5 && x < 3
%         plot([x,x],[0,max(max(atten2250(validIdx,:)))],'--','Color',ax.ColorOrder(1,:))
%         text(x,7,[num2str(ii),'\lambda'],'Color',ax.ColorOrder(1,:))
%     end
%     
%     x = c*1e-3/(1/mts(ii)*acrylicFrags(validIdx(2)).thickness);
%     if x > 1.5 && x < 3
%         plot([x,x],[0,max(max(atten2250(validIdx,:)))],'--','Color',ax.ColorOrder(2,:))
%         text(x,7,[num2str(ii),'\lambda'],'Color',ax.ColorOrder(2,:))
%     end
%     
%     x = c*1e-3/(1/mts(ii)*acrylicFrags(validIdx(3)).thickness);
%     if x > 1.5 && x < 3
%         plot([x,x],[0,max(max(atten2250(validIdx,:)))],'--','Color',ax.ColorOrder(3,:))
%         text(x,7,[num2str(ii),'\lambda'],'Color',ax.ColorOrder(3,:))
%     end
% end
lgd = legend(plt,thLabel{validIdx});
set(lgd,'position',[0.7113    0.2408    0.2321    0.3007])
makeFigureBig(h);
axis([1.5,3,0,max(max(atten2250(validIdx,:)))])
set(h,'position',[680   200   560   286]);
% imgPath = 'C:\Users\Taylor\Documents\Stanford\Work\Papers\Attenuation\figs\';
if exist('imgPath','var')
    print([imgPath, 'figs\printedFrags'], '-depsc')
end

% disp(['Measured Attenuation: ',num2str(acrylicFrags(validIdx(1)).thickness), ' mm:', num2str(atten2250(validIdx(1),centerIdx)), '; ', num2str(acrylicFrags(validIdx(2)).thickness), ' mm:', num2str(atten2250(validIdx(2),centerIdx))])

%% Compare simulation and measurement
idxToCompare = 6;
% Estimated
d0 = acrylicFrags(idxToCompare).thickness;
c = acrylicFrags(idxToCompare).c;
rho = acrylicFrags(idxToCompare).rho;
for ii = 1:length(f2250)
    [~,T(ii)] = estimateGamma3Layer(c,rho,d0,f2250(ii),f2250(ii)/f2250(ceil(length(f2250)/2))*mean(atten2250(idxToCompare,:)));
end

figure
plot(f2250,il2250_all(idxToCompare,:),'-',f2250,abs(T),'--')