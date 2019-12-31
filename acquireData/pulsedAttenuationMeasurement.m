%% Path Setup
if ~exist('setUpScopeForVelocityMeasurements.m', 'file')
    addpath('tools');
end
VERBOSE = 1;
tic
%% Fragment name
% fragName = '100';

%%
if ~exist('scope', 'var')
    % Create a VISA-USB object.
    interfaceObj = instrfind('Type', 'visa-usb', 'RsrcName', 'USB0::0x0699::0x0364::C057567::0::INSTR', 'Tag', '');

    % Create the VISA-USB object if it does not exist
    % otherwise use the object that was found.
    if isempty(interfaceObj)
        interfaceObj = visa('TEK', 'USB0::0x0699::0x0364::C057567::0::INSTR');
    else
        fclose(interfaceObj);
        interfaceObj = interfaceObj(1);
    end

    % Create a device object. 
    scope = icdevice('tektronix_tds2002.mdd', interfaceObj);

    % Connect device object to hardware.
    connect(scope);
    
%     fg = visa('USB0::0x0957::0x4807::MY53301327::0::INSTR');
end

% if strcmp(fg.Status, 'closed')
%     fopen(fg);
% end

%% Oscope Parameters
delay = 28.74e-6; % Oscope delay in seconds
nAves = 16; % Number of o-scope averages
yRange = [50e-3,5e-3]; % volts/division on y-axis
tPerDivision = 2e-6;
scopeParams = struct('delay', delay, 'nAves', nAves, 'yRange', yRange,...
    'periodsPerDiv',tPerDivision);

scopeParamsReflected = struct('delay', 23.74e-6, 'nAves', nAves, 'yRange', yRange,...
    'periodsPerDiv',tPerDivision);
delayRef2 = 28.74e-6;

tPerDivisionCW = 2.5*tPerDivision;
%% FG Parameters
amplitude = 250e-3; % Amplitude of signal in volts
period = 0.5e-3; % Burst period in seconds
nCycles = 1; % Number of cycles in each burst
fgParams = struct('amp',amplitude,'per', period,'nCyc',nCycles);
centerFreq = 2.25e6;

%% Run experiment
path = 'C:\Users\Taylor\Documents\Projects\Stanford\Attenuation\AcrylicData\20190910\2250kHz\1';
if ~exist('fragName', 'var')
    fragName = input('Fragment: ', 's');
    clear data t ptE ptF envAmpBone
end

nMeasurements = 1;

saveName = [path,fragName,'\atten_', num2str(nMeasurements),'Measurements_000.mat'];
fileIdx = 0;
while exist(saveName,'file')
    saveName = [path,fragName,'\atten_', num2str(nMeasurements),'Measurements_',num2str(fileIdx,'%03d'),'.mat'];
    fileIdx = fileIdx+1;
end
if fileIdx > 0
    cnt = input(['I have seen this fragment ', num2str(fileIdx), 'times before! Continue (0/1)?']);
    if ~cnt
        return
    end
end

clear r_pb r_pnb

%% Pulse Transmited
setUpScopeForVelocityMeasurements(scope, scopeParams.delay, scopeParams.nAves,...
    scopeParams.yRange(1), tPerDivision);
% setFgBurstMode(fg,centerFreq,fgParams.amp,fgParams.per,fgParams.nCyc);

tmp = digitizeWaveform(scope,1);
newRange = [1.2*max(abs(tmp)/4),scopeParams.yRange(2)];

setUpScopeForVelocityMeasurements(scope, scopeParams.delay, scopeParams.nAves,...
    newRange, tPerDivision);
[pb,t,header] = digitizeWaveform(scope,1);

%% CW Transmitted
% setUpScopeForVelocityMeasurements(scope, scopeParams.delay, scopeParams.nAves,...
%     newRange, tPerDivisionCW);
% setFgBurstMode(fg,centerFreq,fgParams.amp,fgParams.per,15);
% 
% tmp = digitizeWaveform(scope,1);
% newRange = [1.2*max(abs(tmp)/4),scopeParams.yRange(2)];
% 
% setUpScopeForVelocityMeasurements(scope, scopeParams.delay, scopeParams.nAves,...
%     newRange, tPerDivisionCW);
% 
% [cw_pb,cw_t,cw_header] = digitizeWaveform(scope,1);

%% CW Reflected
% setUpScopeForVelocityMeasurements(scope, scopeParamsReflected.delay, scopeParams.nAves,...
%     [scopeParams.yRange(1), 2*scopeParams.yRange(2)], 2*tPerDivisionCW);
% setFgBurstMode(fg,centerFreq,fgParams.amp,fgParams.per,15);
% 
% tmp = digitizeWaveform(scope,2);
% newRange = [scopeParams.yRange(1),1.2*max(abs(tmp)/4),];
% 
% setUpScopeForVelocityMeasurements(scope, scopeParamsReflected.delay, 1024,...
%     newRange, 2*tPerDivisionCW);
% 
% [cw_r_pb,cw_r_t,cw_r_header] = digitizeWaveform(scope,2);

%% Pulse Reflected
% setFgBurstMode(fg,centerFreq,fgParams.amp,fgParams.per,fgParams.nCyc);
setUpScopeForVelocityMeasurements(scope, scopeParamsReflected.delay, 512,...
    scopeParamsReflected.yRange, scopeParamsReflected.periodsPerDiv);

tmp = digitizeWaveform(scope,2);
newRange = [scopeParams.yRange(1),1.2*max(abs(tmp)/4),];

setUpScopeForVelocityMeasurements(scope, scopeParamsReflected.delay, 2048,...
    newRange, scopeParamsReflected.periodsPerDiv);

for ii = 1:1
    [r_pb(ii,:),r_t,r_header1] = digitizeWaveform(scope,2);
end
r_pb1 = mean(r_pb,1);

setUpScopeForVelocityMeasurements(scope, delayRef2, 2048,...
    newRange, scopeParamsReflected.periodsPerDiv);

% r_header2='';
% r_pb2 = 0;
% r_t2 = 0;
for ii = 1:1
    [r_pb(ii,:),r_t2,r_header2] = digitizeWaveform(scope,2);
end
r_pb2 = mean(r_pb,1);
%%
input('Press Enter When Fragment is out of the way!')

%% Pulse Reflected
setUpScopeForVelocityMeasurements(scope, scopeParamsReflected.delay, 2048,...
    newRange, scopeParamsReflected.periodsPerDiv);

for ii = 1:1
    [r_pnb(ii,:),r_t1,header] = digitizeWaveform(scope,2);
end
r_pnb1 = mean(r_pnb,1);
setUpScopeForVelocityMeasurements(scope, delayRef2, 2048,...
    newRange, scopeParamsReflected.periodsPerDiv);

% r_pnb2 = 0;
for ii = 1:1
    [r_pnb(ii,:),r_t2,header] = digitizeWaveform(scope,2);
end
r_pnb2 = mean(r_pnb,1);

%% CW Transmitted
% setUpScopeForVelocityMeasurements(scope, scopeParams.delay, scopeParams.nAves,...
%     scopeParams.yRange, 2*tPerDivisionCW);
% setFgBurstMode(fg,centerFreq,fgParams.amp,fgParams.per,15);
% 
% tmp = digitizeWaveform(scope,1);
% newRange = [1.2*max(abs(tmp)/4),scopeParams.yRange(2)];
% 
% setUpScopeForVelocityMeasurements(scope, scopeParams.delay, scopeParams.nAves,...
%     newRange, 2*tPerDivisionCW);
% 
% cw_pnb = digitizeWaveform(scope,1);

%% CW Reflected
% setUpScopeForVelocityMeasurements(scope, scopeParamsReflected.delay, scopeParams.nAves,...
%     [scopeParams.yRange(1), 2*scopeParams.yRange(2)], tPerDivisionCW);
% setFgBurstMode(fg,centerFreq,fgParams.amp,fgParams.per,15);
% 
% tmp = digitizeWaveform(scope,2);
% newRange = [scopeParams.yRange(1),1.2*max(abs(tmp)/4),];
% 
% setUpScopeForVelocityMeasurements(scope, scopeParamsReflected.delay, 1024,...
%     newRange, tPerDivisionCW);
% 
% cw_r_pnb = digitizeWaveform(scope,2);
% % 
%% Pulse Transmitted
setFgBurstMode(fg,centerFreq,fgParams.amp,fgParams.per,fgParams.nCyc);
setUpScopeForVelocityMeasurements(scope, scopeParams.delay, scopeParams.nAves,...
    scopeParams.yRange, tPerDivision);

tmp = digitizeWaveform(scope,1);
newRange = [1.2*max(abs(tmp)/4),scopeParams.yRange(2)];

setUpScopeForVelocityMeasurements(scope, scopeParams.delay, scopeParams.nAves,...
    newRange, tPerDivision);

pnb = digitizeWaveform(scope,1);

%%
if ~exist([path, fragName], 'dir')
    mkdir([path, fragName]);
end

save(saveName,'pb','r_pb1','pnb','r_pnb1','t','r_t1','r_pb2','r_pnb2','r_t2','header','cw_pb','cw_pnb','cw_r_pb','cw_r_pnb','cw_r_t','cw_r_header','cw_t','cw_header','r_header1','r_header2')
clear fragName;
%%
h = figure(1);
clf
dt = t(2)-t(1);
fs = 1/dt;

pb = pb-mean(pb);
pnb = pnb-mean(pnb);
nfft = length(pb);

f = 0:fs/nfft:5e6;
freq = [500,1500]*1e3;
% fIdx = find(f>freq(1) & f<freq(2));
fIdx = find(f>0 & f<5e6);

PB = (fft(pb));
PNB = (fft(pnb));
subplot(511)
plot(f,20*log10(abs(PB(1:length(f)))),'-',f,20*log10(abs(PNB(1:length(f)))),'-')
axis([0,5e6,-80,60])
grid on
subplot(512)
plot(f,20*log10(abs(PB(1:length(f)))./abs(PNB(1:length(f)))),'--');
axis([0,5e6,-80,1])
grid on

subplot(513)
plot(t,pb,t,pnb)
xlabel('time (s)')
ylabel('Voltage (v)')
title('Transmitted Pulse')

subplot(514)
plot(r_t1,r_pb1,r_t1,r_pnb1)
hold on
plot(r_t2,r_pb2,r_t2,r_pnb2)
xlabel('time (s)')
ylabel('Voltage (V)')
title('Reflection')

subplot(515)
plot(cw_t,cw_pb,cw_t,cw_pnb)
hold on
plot(cw_r_t,cw_r_pb*max(cw_pb)/max(cw_r_pb),cw_r_t,cw_r_pnb*max(cw_pb)/max(cw_r_pb))
% axis([0,8e-5,-3,3])
xlabel('time (s)')
ylabel('Voltage (V)')
title('CW')
tLoss = abs(PB)./abs(PNB);


set(h,'Position',[1,41,1280,908])
toc
return
h = figure;
dt = r_t(2)-r_t(1);
fs = 1/dt;

refWave = r_pb2-r_pnb2;

incWave = r_pnb1;
nfft1 = length(incWave);

f1 = 0:fs/nfft1:2e6;
freq = [500,1500]*1e3;

PB = (fft(refWave));
PNB = (fft(incWave));
subplot(211)
plot(f1,20*log10(abs(PB(1:length(f1)))),'-',f1,20*log10(abs(PNB(1:length(f1)))),'-')
axis([250e3,1750e3,-80,max(20*log10(abs(PNB(fIdx))))])
grid on
subplot(212)
plot(f1,20*log10(abs(PB(1:length(f1)))./abs(PNB(1:length(f1)))),'--');
axis([250e3,1.75e6,-40,0])
grid on

refLoss = abs(PB)./abs(PNB);
refLoss = (1+refLoss).*(1-refLoss);
attenLoss = tLoss(1:2:end)./refLoss;

figure
plot(f1,attenLoss(1:length(f1)))
%%
clear fragName;