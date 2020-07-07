% Defines a struct with the properties of the acrylic fragments. This is
% basically a database
% 
% @INPUTS
%   None
% 
% @OUTPUTS
%   acrylicFrags: struct defining the acrylic fragments with fields:
%       thickness: thickness in mm
%       c: velocity in m/s (currently this isn't the measured velocity - it
%           is taken from online)
%       rho: density in kg/m^3 (currently this isn't the measured velocity 
%           - it is taken from online
% 
% Taylor Webb
% Summer 2019

function acrylicFrags = defineAcrylicFrags(path)

%% Define Acrylic Fragments
kHz = struct('pb',[],'pnb',[],'t',[]);
Attenuation = struct('kHz500',kHz,'kHz1000',kHz,'kHz2250',kHz);
acrylicFrags0 = struct('thickness',[],'c',2750,'rho',1190,'Attenuation',Attenuation);
for ii = 1:12
    acrylicFrags(ii) = acrylicFrags0;
end
acrylicFrags(1).thickness = 1.32;
acrylicFrags(2).thickness = 2.0;
acrylicFrags(3).thickness = 2.38;
acrylicFrags(4).thickness = 3.33;
acrylicFrags(5).thickness = 6.57;
acrylicFrags(6).thickness = 7.0;
acrylicFrags(7).thickness = 1.87;
acrylicFrags(8).thickness = 3.85;
acrylicFrags(9).thickness = 6.08;
acrylicFrags(10).thickness = 1.65;
acrylicFrags(11).thickness = 3.47;
acrylicFrags(12).thickness = 5.86;

acrylicFrags(7).c = 1916;
acrylicFrags(8).c = 1916;
acrylicFrags(9).c = 1916;

acrylicFrags(10).c = 1568;
acrylicFrags(11).c = 1568;
acrylicFrags(12).c = 1568;

if nargin < 1
    warning('No Attenuation data provided, returning struct with only thickness, velocity, and rho')
    return
end

if path(end) ~= '/' && path(end) ~= '\'
    path(end+1) = '\';
end

path500 = [path,'500kHz\'];
path1000 = [path,'1000kHz\'];
path2250 = [path,'2250kHz\'];

%% 500 kHz
files = dir(path500);
if isempty(files)
    warning(['No Files Found in ', path500])
%     acrylicFrags.Attenuation.pb = [];
%     acrylicFrags.Attenuation.pnb = [];
%     acrylicFrags.Attenuation.t = [];
else
    curIdx = 1;
    for ii = 1:length(files)
        if files(ii).isdir && files(ii).name(1) ~= '.'
            
            fragments = dir([path500,files(ii).name]);
            for jj = 1:length(fragments)
                if fragments(jj).isdir && fragments(jj).name(1) ~= '.'
                    fragIdx = str2double(fragments(jj).name);
                    load([path500,files(ii).name,'\',fragments(jj).name,'\atten_1Measurements_000.mat'])
                    acrylicFrags(fragIdx).Attenuation.kHz500.pb{curIdx} = pb-mean(pb);
                    acrylicFrags(fragIdx).Attenuation.kHz500.pnb{curIdx} = pnb-mean(pnb);
                    acrylicFrags(fragIdx).Attenuation.kHz500.t = t;
                end
            end
            curIdx = curIdx+1;
        end
    end
end

%% 2250 kHz
files = dir(path2250);
if isempty(files)
    warning(['No Files Found in ', path2250])
    acrylicFrags.Attenuation.pb = [];
    acrylicFrags.Attenuation.pnb = [];
    acrylicFrags.Attenuation.t = [];
else
    curIdx = 1;
    for ii = 1:length(files)
        if files(ii).isdir && files(ii).name(1) ~= '.'
            
            fragments = dir([path2250,files(ii).name]);
            for jj = 1:length(fragments)
                if fragments(jj).isdir && fragments(jj).name(1) ~= '.'
                    fragIdx = str2double(fragments(jj).name);
                    load([path2250,files(ii).name,'\',fragments(jj).name,'\atten_1Measurements_000.mat'])
                    acrylicFrags(fragIdx).Attenuation.kHz2250.pb{curIdx} = pb-mean(pb);
                    acrylicFrags(fragIdx).Attenuation.kHz2250.pnb{curIdx} = pnb-mean(pnb);
                    acrylicFrags(fragIdx).Attenuation.kHz2250.t = t;
                end
            end
            curIdx = curIdx+1;
        end
    end
end