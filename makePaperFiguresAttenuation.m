% This script generates the figures for the attenuation paper
close all; clc
if 1
    imgPath = 'C:\Users\Taylor\Documents\Stanford\Work\Papers\Attenuation2\';
end

addpath('..');
addpath('../..');
addpath('figs');
addpath('lib');

%% Thickness Histogram
thicknessHistogram;

%% vs HU
attenuationVsHu;

%% vs MR
attenuationVsMr
%% Results Tables
resultsTableMultiParam;
return
%% Fragment Table for appendix
fragmentTable;

%% Frequency
meanAttenuationVsFrequency;

%% Relationship Comparison to literature
literature;