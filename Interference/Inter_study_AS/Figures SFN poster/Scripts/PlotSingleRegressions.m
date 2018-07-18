clc
close all
clear all

%% bLoad data
ppath='C:\Users\salat\OneDrive\Documents\MATLAB\Research\CoreL\Interference\Interf_study_AS\Figures SFN poster\Scripts\';
% tpath=[ppath 'DataForRegressionsA1.mat'];
tpath=[ppath 'DataForRegressionsDIFF.mat']; %A2-A1

load(tpath);

%% Select x and y
% xstr  = 'Height';
% xstr = 'STD_FIN';
xstr = 'STD_PERC_VAR';
ystr = 'SLA_A1_1';

%% Extract x and y
[x, y] = extractXandY(mat_table, var_names, xstr, ystr);

%% Plot regression
compute_and_plot_regression_line(x,y,xstr,'SLA_A1_DIFF')

%% Store the figure
ppath2=['C:\Users\salat\OneDrive\Documents\MATLAB\Research\CoreL\Interference\Interf_study_AS\Figures SFN poster\'];
name = [xstr ' VS ' ystr];
figName = [ppath2 name];
my_print_figures([], gcf, figName, [], 1);
