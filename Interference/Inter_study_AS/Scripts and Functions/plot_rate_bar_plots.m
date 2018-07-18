%% Plot Rate Barplots

clc
close all
clear all

%Select
selPar=1;

pars={'SLA','SP','ST'};
par=pars{selPar};

%Load
cpath = 'C:\Users\salat\OneDrive\Documents\MATLAB\Research\CoreL\Interference\Interf_study_AS\SaveDataForStata\Stata - Rate Measures\';
load(cpath)

%Plot
