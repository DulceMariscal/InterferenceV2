%% Comparison STEP-POSITION VS SLA
%% INPUT:  ALL_DATA, ALL_DATA_STEP_POS

clc
close all
clear all

%% Define paths
commonPath = 'C:\Users\salat\OneDrive\Documents\MATLAB\Research\CoreL\Interference\Interf_study_AS\SaveDataForStata\';
filesToLoad = {'ALL_DATA','ALL_DATA_STEP_POS_N2','ALL_DATA_STEP_TIME_N2'};
nfiles = length(filesToLoad);
nconds=2; %A1, A2
A1=1; A2=2; INT=1; SAV=2; DATA=1; FIT=2;

%% Plot parameters
f=figure;
set(groot,'defaultLineLineWidth',3)
set(0,'defaultAxesFontSize',20)
set(0,'defaultLegendLocation','southeast')
margins=[0.05 0.05];
lstyles = {'-','-'}; %Data, fit
mcolors = distinguishable_colors(2); %Int, sav
ylabels={'SLA','STEP POS','STEP TIME'};
samplingStride = 7;
YLIMS = [-0.3 0; -0.2 0.15 ; -0.04 0.17];
subplotPar = [3,2];

%% Main analysis-----------------------------------------------------------
for i=1:nfiles
    
    %% 0. Complete name
    cname = [commonPath filesToLoad{i} '.mat'];
    
    %% 1. Load files
    load(cname);
    
    %% 2. Rearrange in a better format
    all_curves = reformat_curves(INTERFERENCE_DATA,SAVINGS_DATA); %GROUP X SUBS X COND
    
    %% 3. Compute average curves
    [m_curves, SE] = average_curves_final(all_curves); %It's a 2 X 2 GROUP by CONDITION
    
    %% 4. Compute time constant of average curves
    [~, tau, fitCurves] = my_exp_fit_ca(m_curves, 'Increasing', 'Single');
    
    %% 5. Compute percent variations in time constants
    PV = percent_variation(tau);
%     
    %% 8. Plot computed curves
    figure(f)
    
    %% 8.1 A1 - Data and Fit
    indSubplot = (i-1)*nconds + 1;
    cylims = YLIMS(i,:);
    cylabel = ylabels{i};
    
    
    
    
    my_plot_curve_and_data2(m_curves,fitCurves,tau,PV,indSubplot,cylims,cylabel,... %These change at every iteration
        subplotPar,lstyles,mcolors,SAV,INT,A1,A2,DATA,FIT,samplingStride,margins,SE) %Fixed
    
    
    
    %% Interf and savinfs seem to be switched somehow
end

%% Stuff to add to the plot

subplot_tight(subplotPar(1),subplotPar(2),1,margins)
hold on
title('A1')

subplot_tight(subplotPar(1),subplotPar(2),2,margins)
hold on
title('A2')

%% Save figures
% pathToStore = 'C:\Users\salat\OneDrive\Documents\MATLAB\Individual Meetings Figures\Nov 1\';
% figureName = 'Comparison PV of SLA SP ST';
% completeName = [pathToStore figureName];
% extensions  = {'-depsc','-dpng'};
% ALSOFIG=1;
% my_print_figures([], fkeep , completeName, extensions, ALSOFIG)
% 
% 

