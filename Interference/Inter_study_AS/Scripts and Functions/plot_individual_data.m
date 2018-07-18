clc
close all
clear all

ppath='C:\Users\salat\OneDrive\Documents\MATLAB\Research\CoreL\Interference\Interf_study_AS\SaveDataForStata\';
load([ppath 'ALL_DATA' ])
GROUPS={'INT','SAV'};
CONDS={'A1','A2'};
MERGED_DATA=cat(3,INTERFERENCE_DATA,SAVINGS_DATA);
MERGED_DATA_FIT=cat(3,INTERFERENCE_FIT_DATA,SAVINGS_FIT_DATA);

% INTERFERENCE=1;
% SAAVINGS=2;
%%
isub=6;
nstr=PARAMETERS_ALL{SAVINGS}(1,STRIDES_TO_HALVE,isub);
YLIM=[-0.2 0.1];
XLIM=[0 600];


a1data=SAVINGS_DATA{1,isub};
a2data=SAVINGS_DATA{2,isub};
a1fit=SAVINGS_FIT_DATA{1,isub};
a2fit=SAVINGS_FIT_DATA{2,isub};


a1vec=1:length(a1data);
a1vecf=1:length(a1fit);

indData=1:5:length(a1data);

figure
subplot(1,2,2)
h1=plot(a1vec(indData),a1data(indData),'o');
hold on
h2=plot(a1fit,'LineWidth',2,'Color',[         0    0.4470    0.7410]);
hold on
h3=line([nstr nstr],YLIM,'LineWidth',2,'LineStyle','--');

hold on
line(XLIM,[a1fit(1) a1fit(1)],'Color',[0.5 0.5 0.5],'LineWidth',2,'LineStyle','--')
hold on
line(XLIM,[a1fit(end) a1fit(end)],'Color',[0.5 0.5 0.5],'LineWidth',2,'LineStyle','--')
hold on
avgp=(a1fit(1)+a1fit(end))/2;
h4=line(XLIM,[avgp avgp],'Color',[0 0 0],'LineWidth',2,'LineStyle','--')


ylim(YLIM); grid on;
l=legend([h1 h2 h4 h3],{'Data','Exp fit','Mid-Pert',['#strides to Mid-Pert' num2str(nstr)]});
yl=ylabel('Step Length Asymmetry');
xl=xlabel('Strides');
set(l,'FontSize',16); 
set(xl,'FontSize',16); 
set(yl,'FontSize',16);



subplot(1,2,1)
FIT_MODEL=1;
initial_conditions_fit
[coeffs,~,resid,~,~,~,J] = lsqcurvefit(my_exp,x0,[1:length(a1fit)],a1fit);
h1=plot(a1vec(indData),a1data(indData),'o');
hold on
h2=plot(a1fit,'LineWidth',2,'Color',[         0    0.4470    0.7410]);
hold on
h3=line([nstr nstr],YLIM,'LineWidth',2,'LineStyle','--');

