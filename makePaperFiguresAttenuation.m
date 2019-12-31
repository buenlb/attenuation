% This script generates the figures for the attenuation paper
close all; clc
if 1
    imgPath = 'C:\Users\Taylor\Documents\Stanford\Work\Papers\Attenuation\';
end

addpath('..');
addpath('../..');
addpath('figs');

%% Thickness Histogram
thicknessHistogram;

%% vs HU
attenuationVsHu;

%% vs MR
attenuationVsMr
%% Results Tables
resultsTable;

%% Fragment Table for appendix
fragmentTable;

%% Frequency
meanAttenuationVsFrequency;

%% Relationship Comparison to literature
literature;