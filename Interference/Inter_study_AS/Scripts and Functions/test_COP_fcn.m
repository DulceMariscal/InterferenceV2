%% TEST COP FUNCTION
clc
close all
clear all

%% PARAMS
gait_par='COPysym_MW';
baseline_condition='Baseline';
conditions_to_compare={'Adaptation 1','Adaptation 1(2nd time)'};

%% LOAD DATA
load('S001params.mat')

% all_labels=adaptData.data.labels;

% ind=find(strcmpi(all_labels,'COPsym'));
%% REMOVE BASELINE
% [adaptData]=adaptData.removeBias(baseline_condition);

%% GET SELECTED CONDITION
% cond=1;
% ccond=conditions_to_compare{cond};%Current condition
% [cdata,inds,auxLabel,origTrials]=adaptData.getParamInCond(gait_par,ccond);
% 
% %% DATA PLOT
% figure
% plot(cdata)

%% EXTRACT AND PLOT COP DATA-----------------------------------------------
%% HOW TO RESTORE COP SEQUENTIALITY
ccond=conditions_to_compare{2};
cop_y_events={'COPy_t1_vec', 'COPy_t12_vec', 'COPy_t2_vec', 'COPy_t23_vec', 'COPy_t3_vec', 'COPy_t34_vec', 'COPy_t4_vec', 'COPy_t45_vec'};
cop_x_events={'COPx_t1_vec', 'COPx_t12_vec', 'COPx_t2_vec', 'COPx_t23_vec', 'COPx_t3_vec', 'COPx_t34_vec', 'COPx_t4_vec', 'COPx_t45_vec'};
cop_events=[cop_x_events cop_y_events];
n_events=length(cop_events);
[COPdataX]=adaptData.getParamInCond(cop_x_events,ccond);
[COPdataY]=adaptData.getParamInCond(cop_y_events,ccond);
COPxvec=reshape(COPdataX',size(COPdataX,1)*size(COPdataX,2),1);
COPyvec=reshape(COPdataY',size(COPdataY,1)*size(COPdataY,2),1);
figure, plot(COPxvec,COPyvec,'-o'), set(gca, 'Xdir', 'reverse'); set(gca, 'Ydir', 'reverse')

% COP X
% COPx= [COPx_t1_vec', COPx_t12_vec', COPx_t2_vec',COPx_t23_vec', COPx_t3_vec', COPx_t34_vec' ,COPx_t4_vec',COPx_t45_vec'];
% COPx_sq=reshape(COPx',size(COPx,1)*size(COPx,2),1);
% % COP Y
% COPy= [COPy_t1_vec', COPy_t12_vec', COPy_t2_vec',COPy_t23_vec', COPy_t3_vec', COPy_t34_vec' ,COPy_t4_vec',COPy_t45_vec'];
% COPy_sq=reshape(COPy',size(COPy,1)*size(COPy,2),1);
% figure, plot(COPx_sq(9:17),COPy_sq(9:17),'-o'), set(gca, 'Xdir', 'reverse'); set(gca, 'Ydir', 'reverse')
% figure, plot(COPx',COPy','-o'), set(gca, 'Xdir', 'reverse'); set(gca, 'Ydir', 'reverse')
