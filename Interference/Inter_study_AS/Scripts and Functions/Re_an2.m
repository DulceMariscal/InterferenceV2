%% Re-analysis Luis experiment: Savings VS Interference
clc
close all
clear all

REMOVE_BASELINE=1;
BIN_WIDTH=3;

cd('C:\Users\lz17\Documents\MATLAB\Interference_project\Interference subjects\All_subjects')

%Parameters
nsi=4; %Number of subjects interference
nss=4; %Number of subjects savings

%Get labels
load('I001params.mat')
labels=adaptData.data.labels;

%Find index desired label
desLab='stepLengthAsym';
selLab=find(strcmpi(desLab,labels));

%% (1) Averages ***Interference*** data-------------------------------------------------------------------------------------------------------------------------
%Plot 
Interference_list={'I001params.mat','I003params.mat','I004params.mat','I005params.mat'};
[figHandle_I,allData_I]=adaptData.plotGroupedSubjectsBars(Interference_list,{desLab},REMOVE_BASELINE);
grid on;
set(figHandle_I,'Name','Interference group','numbertitle','off')
%get the title
h=get(gca,'Title');
ctitle=get(h,'String');
title(['Interference group: ' ctitle])
conditions_interference=adaptData.metaData.conditionName;
indAdaptA1_I=find(strcmpi(conditions_interference,'Adaptation 1'));
indAdaptA2_I=find(strcmpi(conditions_interference,'Adaptation 1(2nd time)'));

%% (1.1) Compute means across subjects
%VeryEarly-----------------------------------------------------------------
sla_veryEarly_means_interf=mean(allData_I{1,1}.veryEarly(:,:),2);
sla_veryEarly_stderr_interf=std(allData_I{1,1}.veryEarly(:,:),0,2)/sqrt(nsi);

%Early---------------------------------------------------------------------
sla_Early_means_interf=mean(allData_I{1,1}.early(:,:),2);
sla_Early_stderr_interf=std(allData_I{1,1}.early(:,:),0,2)/sqrt(nsi);

%Late----------------------------------------------------------------------
sla_late_means_interf=mean(allData_I{1,1}.late(:,:),2);
sla_late_stderr_interf=std(allData_I{1,1}.late(:,:),0,2)/sqrt(nsi);

%% Extract values first subject
garb=allData_I{1,1}.veryEarly([indAdaptA1_I,indAdaptA2_I],2);

%% (1.2) Compute percent variations

%VeryEarly-----------------------------------------------------------------
[sla_veryEarly_pv_interf, sla_veryEarly_pv_interf_AVG, sla_veryEarly_pv_interf_sderr, sla_veryEarly_diff_interf, sla_veryEarly_diff_interf_AVG, sla_veryEarly_diff_interf_sderr] = ...
    compute_percent_variation(allData_I{1,1}.veryEarly(:,:),indAdaptA1_I,indAdaptA2_I);

%Early---------------------------------------------------------------------
[sla_Early_pv_interf, sla_Early_pv_interf_AVG, sla_Early_pv_interf_sderr, sla_Early_diff_interf, sla_Early_diff_interf_AVG, sla_Early_diff_interf_sderr] = ...
    compute_percent_variation(allData_I{1,1}.early(:,:),indAdaptA1_I,indAdaptA2_I);

%Late----------------------------------------------------------------------
[sla_late_pv_interf, sla_late_pv_interf_AVG, sla_late_pv_interf_sderr,sla_diff_pv_interf, sla_late_diff_interf_AVG, sla_late_diff_interf_sderr] = ...
    compute_percent_variation(allData_I{1,1}.late(:,:),indAdaptA1_I,indAdaptA2_I);

%% (2) Averages ***Savings*** data------------------------------------------------------
load('S001params.mat')
Savings_list={'S001params.mat','S002params.mat','S003params.mat','S004params.mat'};
[figHandle_S,allData_S]=adaptData.plotGroupedSubjectsBars(Savings_list,{desLab},REMOVE_BASELINE);
grid on;
set(figHandle_S,'Name','Savings group','numbertitle','off')
title(['Savings group: ' ctitle])
conditions_savings=adaptData.metaData.conditionName;
indAdaptA1_S=find(strcmpi(conditions_savings,'Adaptation 1'));
indAdaptA2_S=find(strcmpi(conditions_savings,'Adaptation 1(2nd time)'));

%% (2.1) Compute means across subjects
%VeryEarly-----------------------------------------------------------------
sla_veryEarly_means_sav=mean(allData_S{1,1}.veryEarly(:,:),2);
sla_veryEarly_stderr_sav=std(allData_S{1,1}.veryEarly(:,:),0,2)/sqrt(nss);

%Early---------------------------------------------------------------------
sla_Early_means_sav=mean(allData_S{1,1}.early(:,:),2);
sla_Early_stderr_sav=std(allData_S{1,1}.early(:,:),0,2)/sqrt(nss);

%Late----------------------------------------------------------------------
sla_late_means_sav=mean(allData_S{1,1}.late(:,:),2);
sla_late_stderr_sav=std(allData_S{1,1}.late(:,:),0,2)/sqrt(nss);

%% (2.2) Compute percent variations 

%VeryEarly-----------------------------------------------------------------
[sla_veryEarly_pv_sav, sla_veryEarly_pv_sav_AVG, sla_veryEarly_pv_sav_sderr, sla_veryEarly_diff_sav, sla_veryEarly_diff_sav_AVG, sla_veryEarly_diff_sav_sderr] = ...
    compute_percent_variation(allData_S{1,1}.veryEarly(:,:),indAdaptA1_S,indAdaptA2_S);

%Early---------------------------------------------------------------------
[sla_Early_pv_sav, sla_Early_pv_sav_AVG, sla_Early_pv_sav_sderr, sla_Early_diff_sav, sla_Early_diff_sav_AVG, sla_Early_diff_sav_sderr] = ...
    compute_percent_variation(allData_S{1,1}.early(:,:),indAdaptA1_S,indAdaptA2_S);

%Late----------------------------------------------------------------------
[sla_late_pv_sav, sla_late_pv_sav_AVG, sla_late_pv_sav_sderr, sla_late_diff_sav, sla_late_diff_sav_AVG, sla_late_diff_sav_sderr] = ...
    compute_percent_variation(allData_S{1,1}.late(:,:),indAdaptA1_S,indAdaptA2_S);


%% Plots
fh=figure;

%% Definition of labels
task_labels={'Adapt A (1st time)','Adapt A (2nd time)','PV [(2nd-1st)/abs(1st)]','DIFF [(2nd-1st)]'};

%% Very Early (recall)---------------------------------------------------------------
sp1=subplot(2,2,1);

%Extraction of only adaptation 1 and 2 data
%Means
adapt_vE_means_S=sla_veryEarly_means_sav([2 4]);
adapt_vE_means_I=sla_veryEarly_means_interf([2 5]);
%Stderr
adapt_vE_stderr_S=sla_veryEarly_stderr_sav([2 4]);
adapt_vE_stderr_I=sla_veryEarly_stderr_interf([2 5]);

% Vectors
adapt_vE_means_S=[adapt_vE_means_S; sla_veryEarly_pv_sav_AVG; sla_veryEarly_diff_sav_AVG ];
adapt_vE_means_I=[adapt_vE_means_I;  sla_veryEarly_pv_interf_AVG; sla_veryEarly_diff_interf_AVG];
%%
hb=bar([adapt_vE_means_S adapt_vE_means_I],'hist');
% plot_bars_with_stderr(sp1,[adapt_vE_means_S adapt_vE_means_I],[adapt_vE_stderr_S adapt_vE_stderr_I],[])
addStd(fh, hb, [1 2 3 4], [1 2], [[adapt_vE_stderr_S; sla_veryEarly_pv_sav_sderr; sla_veryEarly_diff_sav_sderr]...
                                [adapt_vE_stderr_I; sla_veryEarly_pv_interf_sderr; sla_veryEarly_diff_interf_sderr]])
set(gca,'XTickLabel',task_labels)
legend('Savings gr','Interference gr')
grid on
title('Step length asymmetry. Very early (1-3 strides)')

%% Early (re-learning) -  rate of adaptation------------------------------
sp2=subplot(2,2,2);

%Extraction of only adaptation 1 and 2 data
%Means
adapt_E_means_S=sla_Early_means_sav([2 4]);
adapt_E_means_I=sla_Early_means_interf([2 5]);
%Stderr
adapt_E_stderr_S=sla_Early_stderr_sav([2 4]);
adapt_E_stderr_I=sla_Early_stderr_interf([2 5]);

%Percentual variation
adapt_E_means_S=[adapt_E_means_S; sla_Early_pv_sav_AVG; sla_Early_diff_sav_AVG ];
adapt_E_means_I=[adapt_E_means_I; sla_Early_pv_interf_AVG; sla_Early_diff_interf_AVG ];
%%
hb=bar([adapt_E_means_S adapt_E_means_I],'hist');
% plot_bars_with_stderr(sp1,[adapt_vE_means_S adapt_vE_means_I],[adapt_vE_stderr_S adapt_vE_stderr_I],[])
addStd(fh, hb, [1 2 3 4], [1 2], [[adapt_E_stderr_S; sla_Early_pv_sav_sderr; sla_Early_diff_sav_sderr ]...
                                [adapt_E_stderr_I; sla_Early_pv_interf_sderr; sla_Early_diff_interf_sderr]])
set(gca,'XTickLabel',task_labels)
legend('Savings gr','Interference gr')
grid on
title('Step length asymmetry. Early (1-5 strides)')

%% Late (performance)  -  success of adaptation
sp3=subplot(2,2,3);

%Extraction of only adaptation 1 and 2 data
%Means
adapt_L_means_S=sla_late_means_sav([2 4]);
adapt_L_means_I=sla_late_means_interf([2 5]);
%Stderr
adapt_L_stderr_S=sla_late_stderr_sav([2 4]);
adapt_L_stderr_I=sla_late_stderr_interf([2 5]);

%Percent variation
adapt_L_means_S=[adapt_L_means_S; sla_late_pv_sav_AVG; sla_late_diff_sav_AVG ];
adapt_L_means_I=[adapt_L_means_I; sla_late_pv_interf_AVG; sla_late_diff_interf_AVG ];
%% PLOT BARS
hb=bar([adapt_L_means_S adapt_L_means_I],'hist');
% plot_bars_with_stderr(sp1,[adapt_vE_means_S adapt_vE_means_I],[adapt_vE_stderr_S adapt_vE_stderr_I],[])
addStd(fh, hb, [1 2 3 4], [1 2], [[adapt_L_stderr_S; sla_late_pv_sav_sderr; sla_late_diff_sav_sderr ]...
                                [adapt_L_stderr_I; sla_late_pv_interf_sderr; sla_late_diff_interf_sderr]])
set(gca,'XTickLabel',task_labels)
legend('Savings gr','Interference gr')
grid on
title('Step length asymmetry. Late (last 20(-5) strides)')

%% Plot time courses
% out=adaptData.plotAvgTimeCourse({Interference_list,Savings_list},{desLab},{'Baseline','Adaptation 1','Adaptation 1(2nd time)'});
out=adaptData.plotAvgTimeCourse({Interference_list,Savings_list},{desLab},{'Adaptation 1(2nd time)'},BIN_WIDTH,[],[],[],[],[],REMOVE_BASELINE);

