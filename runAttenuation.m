clear; close all; clc;

addpath('lib')

load FragData.mat;

t500 = FragData(1).Attenuation.kHz500.RawData.t;
dt500 = t500(2)-t500(1);

t1000 = FragData(1).Attenuation.kHz1000.RawData.t;
dt1000 = t1000(2)-t1000(1);

t2250 = FragData(1).Attenuation.kHz2250.RawData.t;
dt2250 = t2250(2)-t2250(1);

minThickness = 4e-3;

for ii = 1:length(FragData)
    if FragData(ii).thickness<minThickness
        continue
    end
    clear il500All il1000All il2250All
    for jj = 1:3
        [il500All(jj,:),f500] = insertionLoss(FragData(ii).Attenuation.kHz500.RawData.pb{1},FragData(ii).Attenuation.kHz500.RawData.pnb{1},dt500);
        [il1000All(jj,:),f1000] = insertionLoss(FragData(ii).Attenuation.kHz1000.RawData.pb{1},FragData(ii).Attenuation.kHz1000.RawData.pnb{1},dt1000);
        [il2250All(jj,:),f2250] = insertionLoss(FragData(ii).Attenuation.kHz2250.RawData.pb{1},FragData(ii).Attenuation.kHz2250.RawData.pnb{1},dt2250);
    end
    il500 = mean(il500All,1);
    il1000 = mean(il1000All,1);
    il2250 = mean(il2250All,1);
    
    gamma = estimateGamma(mean(FragData(ii).Velocity.measuredVelocity),...
        FragData(ii).density);
    
    atten500 = il2atten(il500,gamma,FragData(ii).thickness*1e2);
    atten1000 = il2atten(il1000,gamma,FragData(ii).thickness*1e2);
    atten2250 = il2atten(il2250,gamma,FragData(ii).thickness*1e2);
    
    h = figure(1);
    hold on
%     linType = 
    plot(f500,atten500,f1000,atten1000,f2250,atten2250,'linewidth',3);
    ax = gca;
    ax.ColorOrderIndex = 1;
    legend('500 kHz', '1 MHz', '2.25 MHz')
    xlabel('frequency (MHz)')
    ylabel('Attenuation (np/cm)')
    grid on
    makeFigureBig(h);
end