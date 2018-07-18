clc
close all
clear all

set(0,'defaultAxesFontSize',20)
set(groot,'defaultLineLineWidth',2)


%Load mat table
fp = ['C:\Users\salat\OneDrive\Documents\MATLAB\Research\CoreL\Interference\Interf_study_AS\SaveDataForStata\Stata - Rate Measures\Last Shared Nov 12\Data\'];
tableName = 'Int_proj_table2';
load([fp tableName '.mat']);
T = Intprojsfntable2;
var_names = T.Properties.VariableNames;
mat_table = table2cell( T );
%Plot regression lines

% Select x and y

xstr = 'height';
% xstr = 'STD_FIN' ;
% xstr = 'STD_PERC_VAR';

ystr = 'STdataPert1';
% ystr = 'SPdataPert1_5';
% ystr = 'SPdataRate6_30';
% ystr = 'SPdataSSL30';


%% Extract x and y
[x, y] = extractXandY2(mat_table, var_names, xstr, ystr);

%% Plot regression
compute_and_plot_regression_line(x,y,xstr,ystr)

%% Store the figure
ppath2=['C:\Users\salat\OneDrive\Documents\MATLAB\Research\CoreL\Interference\Interf_study_AS\Figures SFN poster\'];
name = [xstr ' VS ' ystr];
figName = [ppath2 name];
% my_print_figures([], gcf, figName, [], 1);