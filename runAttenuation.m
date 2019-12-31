% clear; close all; clc;

addpath('lib')
addpath('lib/generic')
addpath('..')

%% Load Fragment Data
load FragData.mat;

% One of the fragments doesn't have a density measurement. Remove it.
FragData = FragData([1:44,46:end]);

% Remove 2_120M
% FragData = FragData([1:67,69:end]);
%% Find dt for each frequency
t500 = FragData(1).Attenuation.kHz500.RawData.t;
dt500 = t500(2)-t500(1);

t1000 = FragData(1).Attenuation.kHz1000.RawData.t;
dt1000 = t1000(2)-t1000(1);

t2250 = FragData(1).Attenuation.kHz2250.RawData.t;
dt2250 = t2250(2)-t2250(1);

%% Find the valid indices for each frequency
% This are the indices into the Fourier transform at which there is
% sufficient signal to estimate the insertion loss
[~,f500,idx20dB_500] = insertionLoss(FragData(1).Attenuation.kHz500.RawData.pb{1},FragData(1).Attenuation.kHz500.RawData.pnb{1},dt500);
[~,f1000,idx20dB_1000] = insertionLoss(FragData(1).Attenuation.kHz1000.RawData.pb{1},FragData(1).Attenuation.kHz1000.RawData.pnb{1},dt1000);
[~,f2250,idx20dB_2250] = insertionLoss(FragData(1).Attenuation.kHz2250.RawData.pb{1},FragData(1).Attenuation.kHz2250.RawData.pnb{1},dt2250);

%% Find the center index (corresponding to 0.5, 1, and 2.25 MHz)
[~,centerIdx500] = min(abs(f500-0.5));
[~,centerIdx1000] = min(abs(f1000-1));
[~,centerIdx2250] = min(abs(f2250-2.250));

%% Set up variables
% Reflection and attenuation across frequencies
gamma500 = zeros(length(FragData),length(idx20dB_500));
gamma1000 = zeros(length(FragData),length(idx20dB_1000));
gamma2250 = zeros(length(FragData),length(idx20dB_2250));

T500 = zeros(length(FragData),length(idx20dB_500));
T1000 = zeros(length(FragData),length(idx20dB_1000));
T2250 = zeros(length(FragData),length(idx20dB_2250));

atten500 = zeros(length(FragData),length(idx20dB_500));
atten1000 = zeros(length(FragData),length(idx20dB_1000));
atten2250 = zeros(length(FragData),length(idx20dB_2250));

stdAtten500 = zeros(length(FragData),length(idx20dB_500));
stdAtten1000 = zeros(length(FragData),length(idx20dB_1000));
stdAtten2250 = zeros(length(FragData),length(idx20dB_2250));

% Attenuation at the center frequency
atten500C = zeros(length(FragData),1);
atten1000C = zeros(length(FragData),1);
atten2250C = zeros(length(FragData),1);
%% Find the attenuation in each fragment
if ~exist('SEMI_INFINITE','var')
    SEMI_INFINITE = 0; % 1 uses semi infinite space assumptions to compute gamma and zero uses a three layer assumption
end
for ii = 1:length(FragData)
    disp(['Fragment ', num2str(ii), ' of ', num2str(length(FragData))])
    
    c = mean(FragData(ii).Velocity.measuredVelocity);
%     c = 3.01e3;
    rho = FragData(ii).density;
    d = FragData(ii).thickness*1e3;
    % Insertion Loss
    tmp500 = zeros(3,length(idx20dB_500));
    tmp1000 = zeros(3,length(idx20dB_1000));
    tmp2250 = zeros(3,length(idx20dB_2250));
    for jj = 1:3
        tmp500(jj,:) = insertionLoss(FragData(ii).Attenuation.kHz500.RawData.pb{jj},FragData(ii).Attenuation.kHz500.RawData.pnb{jj},dt500,idx20dB_500);
        tmp1000(jj,:) = insertionLoss(FragData(ii).Attenuation.kHz1000.RawData.pb{jj},FragData(ii).Attenuation.kHz1000.RawData.pnb{jj},dt1000,idx20dB_1000);
        tmp2250(jj,:) = insertionLoss(FragData(ii).Attenuation.kHz2250.RawData.pb{jj},FragData(ii).Attenuation.kHz2250.RawData.pnb{jj},dt2250,idx20dB_2250);
    end
    
    % Save the average insertion loss values
    il500_all(ii,:) = mean(tmp500,1);
    il1000_all(ii,:) = mean(tmp1000,1);
    il2250_all(ii,:) = mean(tmp2250,1);
    
    % Compute attenuation for each insertion loss in order to get standard
    % deviation of attenuation.
    for expIter = 1:3
        if SEMI_INFINITE
            % Reflection coeficient
            gamma = estimateGamma(c,rho);
            % Attenuation
            for jj = 1:length(f500)
                tmpAtten500(expIter,jj) = il2atten(tmp500(expIter,jj),gamma,FragData(ii).thickness*1e2);
            end
            for jj = 1:length(f1000)
                tmpAtten1000(expIter,jj) = il2atten(tmp1000(expIter,jj),gamma,FragData(ii).thickness*1e2);
            end
            for jj = 1:length(f2250)
                tmpAtten2250(expIter,jj) = il2atten(tmp2250(expIter,jj),gamma,FragData(ii).thickness*1e2);
            end
        else
            for jj = 1:length(f500)
                tmpAtten500(expIter,jj) = estimateAttenuation3Layer(c,rho,d,f500(jj),tmp500(expIter,jj));
            end
            for jj = 1:length(f1000)
                tmpAtten1000(expIter,jj) = estimateAttenuation3Layer(c,rho,d,f1000(jj),tmp1000(expIter,jj));
            end
            for jj = 1:length(f2250)
                tmpAtten2250(expIter,jj) = estimateAttenuation3Layer(c,rho,d,f2250(jj),tmp2250(expIter,jj));
            end
        end
    end
    
    % Compute average attenuation values and standard deviations
    atten500(ii,:) = mean(tmpAtten500,1);
    stdAtten500(ii,:) = std(tmpAtten500,[],1);
    atten1000(ii,:) = mean(tmpAtten1000,1);
    stdAtten1000(ii,:) = std(tmpAtten1000,[],1);
    atten2250(ii,:) = mean(tmpAtten2250,1);
    stdAtten2250(ii,:) = std(tmpAtten2250,[],1);
    
    atten500C(ii) = atten500(ii,centerIdx500);
    atten1000C(ii) = atten1000(ii,centerIdx1000);
    atten2250C(ii) = atten2250(ii,centerIdx2250);
end



%% Plot the results
% Select a CT to compare to
ctIdx = find(strcmp(CtData.kernels,'Bone') & CtData.energies==120 & strcmp(CtData.vendor,'GE') & strcmp(CtData.reconMethod,'Standard'));
hu = zeros(size(FragData'));
for ii = 1:length(FragData)
    hu(ii) = FragData(ii).CT.HU(ctIdx);
end

[~,idx680] = min(abs(f500-0.68));
for ii = 1:length(FragData)
    d(ii) = FragData(ii).thickness;
end
atten = atten500(d>4.4e-3,idx680);
x = hu(d>4.4e-3);

[p,r,~,x2,y2] = myPolyFit(x,atten,'poly',1);


h = figure(1);
plot(x,atten,'^','linewidth',2,'markersize',8)
hold on
ax = gca;
ax.ColorOrderIndex = 1;
plot(x2,y2,'--','linewidth',3)
axis([min(x),max(x),0,max(atten)])
title(['R^2: ', num2str(r)])
xlabel('HU')
ylabel('Attenuation (np/cm)')
grid on
makeFigureBig(h);