%% Path Setup
if ~exist('setUpScopeForVelocityMeasurements.m', 'file')
    addpath('tools');
    addpath('../lib');
    addpath('../lib/generic');
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
end

%% Oscope Parameters
delay = 37e-6; % Oscope delay in seconds
nAves = 128; % Number of o-scope averages
yRange = [20e-3,5e-3]; % volts/division on y-axis
tPerDivision = 2/(.5e6);
scopeParams = struct('delay', delay, 'nAves', nAves, 'yRange', yRange,...
    'periodsPerDiv',tPerDivision);

tPerDivisionCW = 2.5*tPerDivision;

setUpScopeForVelocityMeasurements(scope, scopeParams.delay, scopeParams.nAves,...
    scopeParams.yRange(1), tPerDivision);

%% Run experiment
path = 'C:\Users\Taylor\Documents\Projects\Stanford\Attenuation\AcrylicData\20190917\500kHz\1\';
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
tmp = digitizeWaveform(scope,1);
newRange = [max(abs(tmp)/2),scopeParams.yRange(2)];

setUpScopeForVelocityMeasurements(scope, scopeParams.delay, scopeParams.nAves,...
    newRange(1), tPerDivision);
[pb,t] = digitizeWaveform(scope,1);

%%
input('Press Enter When Fragment is out of the way!')


%% Pulse Transmitted
setUpScopeForVelocityMeasurements(scope, scopeParams.delay, scopeParams.nAves,...
    scopeParams.yRange(1), tPerDivision);

tmp = digitizeWaveform(scope,1);
newRange = [1.2*max(abs(tmp)/4),scopeParams.yRange(2)];

setUpScopeForVelocityMeasurements(scope, scopeParams.delay, scopeParams.nAves,...
    newRange(1), tPerDivision);

pnb = digitizeWaveform(scope,1);

%%
if ~exist([path, fragName], 'dir')
    mkdir([path, fragName]);
end

save(saveName,'pb','pnb','t')

%% Plot Results
acrylicFrags = defineAcrylicFrags();
fragNo = str2double(fragName);

h = figure(1);
clf
subplot(411)
plot(t*1e6,pb*1e3,t*1e6,pnb*1e3,'linewidth',2)
legend('With Bone','Without')
grid on
ylabel('voltage (mV)')
xlabel('time (\mus)')

subplot(412)
dt = t(2)-t(1);
f = fftX(dt,length(pb))-1/(2*dt);

PB = abs(fftshift(fft(pb)));
PNB = abs(fftshift(fft(pnb)));
plot(1e-6*f,PB,1e-6*f,PNB,'linewidth',2)
legend('With Bone','Without')
grid on
axis([0,3,0,max(PNB)])
ylabel('voltage (mV)')
xlabel('frequency (MHz)')

subplot(413)
[il,f,idx20dB] = insertionLoss(pb-mean(pb),pnb-mean(pnb),dt);
plot(f,il,'linewidth',2)
grid on
xlabel('frequency (MHz)')
ylabel('IL (dB)')

subplot(414)
c = acrylicFrags(fragNo).c;
rho = acrylicFrags(fragNo).rho;
d = acrylicFrags(fragNo).thickness;
alpha = zeros(size(f));
for ii = 1:length(f)
    alpha(ii) = estimateAttenuation3Layer(c,rho,d,f(ii),il(ii));
end
plot(f,alpha,'linewidth',2)
grid on
xlabel('frequency (MHz)')
ylabel('Attenuation (Np/cm)')

clear fragName;