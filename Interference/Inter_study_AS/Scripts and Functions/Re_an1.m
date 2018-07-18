%% Re-analysis Luis experiment: Savings VS Interference
clc
close all
clear all

cd('C:\Users\lz17\Documents\MATLAB\Interference_project\Interference subjects\All_subjects')

%Parameters
nsi=4; %nos interference
nss=4; %nos savings

%Get labels
load('I001params.mat')
labels=adaptData.data.labels;

%Find index desired label
desLab='stepLengthAsym';
selLab=find(strcmpi(desLab,labels));

%% Averages Interference data-------------------------------------------------
%Plot 
Interference_list={'I001params.mat','I003params.mat','I004params.mat','I005params.mat'};
[figHandle_I,allData_I]=adaptData.plotGroupedSubjectsBars(Interference_list,{desLab});
grid on;
set(figHandle_I,'Name','Interference group','numbertitle','off')
%get the title
h=get(gca,'Title');
ctitle=get(h,'String');
title(['Interference group: ' ctitle])

%VeryEarly-----------------------------------------------------------------
sla_veryEarly_means_interf=mean(allData_I{1,1}.veryEarly(:,:),2);
sla_veryEarly_stderr_interf=std(allData_I{1,1}.veryEarly(:,:),0,2)/sqrt(nsi);

%Early---------------------------------------------------------------------
sla_Early_means_interf=mean(allData_I{1,1}.early(:,:),2);
sla_Early_stderr_interf=std(allData_I{1,1}.early(:,:),0,2)/sqrt(nsi);

%Late----------------------------------------------------------------------
sla_late_means_interf=mean(allData_I{1,1}.late(:,:),2);
sla_late_stderr_interf=std(allData_I{1,1}.late(:,:),0,2)/sqrt(nsi);

%% Averages Savings data------------------------------------------------------
Savings_list={'S001params.mat','S002params.mat','S003params.mat','S004params.mat'};
[figHandle_S,allData_S]=adaptData.plotGroupedSubjectsBars(Savings_list,{desLab});
grid on;
set(figHandle_S,'Name','Savings group','numbertitle','off')
title(['Savings group: ' ctitle])

%VeryEarly-----------------------------------------------------------------
sla_veryEarly_means_sav=mean(allData_S{1,1}.veryEarly(:,:),2);
sla_veryEarly_stderr_sav=std(allData_S{1,1}.veryEarly(:,:),0,2)/sqrt(nss);

%Early---------------------------------------------------------------------
sla_Early_means_sav=mean(allData_S{1,1}.early(:,:),2);
sla_Early_stderr_sav=std(allData_S{1,1}.early(:,:),0,2)/sqrt(nss);

%Late----------------------------------------------------------------------
sla_late_means_sav=mean(allData_S{1,1}.late(:,:),2);
sla_late_stderr_sav=std(allData_S{1,1}.late(:,:),0,2)/sqrt(nss);


%% Plots
fh=figure;

%% Definition of labels
task_labels={'Adapt A (1st time)','Adapt A (2nd time)','Percent variation'};

%% Very Early (recall)---------------------------------------------------------------
sp1=subplot(2,2,1);

%Extraction of only adaptation 1 and 2 data
%Means
adapt_vE_means_S=sla_veryEarly_means_sav([2 4]);
adapt_vE_means_I=sla_veryEarly_means_interf([2 5]);
%Stderr
adapt_vE_stderr_S=sla_veryEarly_stderr_sav([2 4]);
adapt_vE_stderr_I=sla_veryEarly_stderr_interf([2 5]);

%Percentual variation
adapt_vE_means_S=[adapt_vE_means_S; percentage_variation(adapt_vE_means_S)/100 ];
adapt_vE_means_I=[adapt_vE_means_I; percentage_variation(adapt_vE_means_I)/100 ];
%%
hb=bar([adapt_vE_means_S adapt_vE_means_I],'hist');
% plot_bars_with_stderr(sp1,[adapt_vE_means_S adapt_vE_means_I],[adapt_vE_stderr_S adapt_vE_stderr_I],[])
addStd(fh, hb, [1 2 3], [1 2], [[adapt_vE_stderr_S; 0] [adapt_vE_stderr_I; 0]])
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
adapt_E_means_S=[adapt_E_means_S; percentage_variation(adapt_E_means_S)/100 ];
adapt_E_means_I=[adapt_E_means_I; percentage_variation(adapt_E_means_I)/100 ];
%%
hb=bar([adapt_E_means_S adapt_E_means_I],'hist');
% plot_bars_with_stderr(sp1,[adapt_vE_means_S adapt_vE_means_I],[adapt_vE_stderr_S adapt_vE_stderr_I],[])
addStd(fh, hb, [1 2 3], [1 2], [[adapt_E_stderr_S; 0] [adapt_E_stderr_I; 0]])
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
adapt_L_means_S=[adapt_L_means_S; percentage_variation(adapt_L_means_S)/100 ];
adapt_L_means_I=[adapt_L_means_I; percentage_variation(adapt_L_means_I)/100 ];
%%
hb=bar([adapt_L_means_S adapt_L_means_I],'hist');
% plot_bars_with_stderr(sp1,[adapt_vE_means_S adapt_vE_means_I],[adapt_vE_stderr_S adapt_vE_stderr_I],[])
addStd(fh, hb, [1 2 3], [1 2], [[adapt_L_stderr_S; 0] [adapt_L_stderr_I; 0]])
set(gca,'XTickLabel',task_labels)
legend('Savings gr','Interference gr')
grid on
title('Step length asymmetry. Late (last 20(-5) strides)')

%% Plot time courses
% out=adaptData.plotAvgTimeCourse({Interference_list,Savings_list},{desLab},{'Baseline','Adaptation 1','Adaptation 1(2nd time)'});
out=adaptData.plotAvgTimeCourse({Interference_list,Savings_list},{desLab},{'Adaptation 1(2nd time)'});

