%% Plot regression lines for Interference experiment

clc
close all
clear all

%% 1. Load the file
ppath='C:\Users\salat\OneDrive\Documents\MATLAB\Research\CoreL\Interference\Interf_study_AS\SaveDataForStata\';
tpath = [ ppath 'outcome_table_all_contributions.mat'];
load(tpath);

%% 2. Select x and y
x = 'Height'

y = 'SLAdataPert1';

%% 3. Exclude subject

%% 2. Plot regression lines
ONLY_PLOT_REGRESSION = 1;

%% Load data
% pathToData=['C:\Users\salat\OneDrive\Documents\MATLAB\Speeds Computation\Data\Preprocessed Data\'];
pathToData=['C:\Users\salat\OneDrive\Documents\MATLAB\Research\CoreL\Meta-analysis including other studies\Data\Preprocessed Data\'];

load([pathToData 'Data_Exps_1_to_7.mat']);

%% Select data
selExps = [3 4];
maskSelSubjects = get_indices_selected_subjects(pars(getInd.expID,:),selExps);
% maskSelSubjects = exclude_subjects(maskSelSubjects, pars, getInd, {'BMI > 35' });

selPars = pars(:,maskSelSubjects);
appendixString = append_experiments(selExps,'Report_exps');

%% Does std(SLA) decrease during baseline 1?
[h1, p1] = ttest(selPars(getInd.STD_DIFF_1B,:),0,'Tail','left'); %Tail: left tests for H0>=0
%YES
%% Does std(SLA) decrease during baseline 2?
[h2, p2] = ttest(selPars(getInd.STD_DIFF_2B,:),0,'Tail','left');
%YES

% my_strcmpi(dataStrings,'STD_DIFF'),:)')



%% CONSIDER SELECTED MODELS
% xVars={'Height','STD_FIN_1B','Dspeed','firstSplit','STD_IN_1B'};
% xVars={'tmStrides','Weight'};
% xVars={'SLA_A1_1'};

% xVars={'STD_FIN_1B'};
xVars={'STD_PERC_VAR'};


% xVars={'Height'};
yVar={'SLA_A1_DIFF'};



X = selPars(my_strcmpi(dataStrings,xVars,1),:)';
Y = selPars(my_strcmpi(dataStrings,yVar,1),:)';

Xext=[ones(size(X,1),1) X];
[b,bint,r,rint,stats] = regress(Y,Xext);

% In this model, the regressor STD_PERC_VAR is still significant.
% Therefore, also controlling for STD_FIN, there is a significant
% association between STD_PERC_VAR and SLA_PV_1. In particular,
% the more you increase STD_VAR during baseline, the less you will
% improve from 1 to 2.

mdl = fitlm((X),Y)

%% Plot regression line
indSel=1;
figure
compute_and_plot_regression_line(X(:,indSel),Y);
% xlabel('SLA\_A1\_1')
xlabel(xVars{indSel})
% xlabel('STD_FIN')
% ylabel(yVar{1})
ylabel('Amount of Perturbation')



if ONLY_PLOT_REGRESSION == 0
    %% PLOT CORRELATION MATRIX
    nTypes=5;
    corrVarStr=cell(nTypes,1);
    corrVarStr{1} = {'SLA_A1_1','SLA_A1_1to5','SLA_A1_6to30','SLA_A1_L30','stridesToAVGpert'};
    corrVarStr{2} = {'Age', 'Weight', 'Height', 'BMI'};
    corrVarStr{3} = {'STD_IN_1B','STD_FIN_1B','STD_DIFF_1B','STD_PERC_VAR_1B'};
    corrVarStr{4} = {'Dspeed' , 'NDspeed', 'speedDiff', 'speedRatio'};
    corrVarStr{5} = {'B1Speed'};
    interestingCouples = [1 1; 1 2; 1 3; 1 4; 2 3; 3 5];
    ncouples=size(interestingCouples,2);
    %
    % for i=1:ncouples
    %     figure
    %     xvars =
    %     yvars =
    %
    % end
    
    
    for i=1:nTypes
        %Find vars
    end
    %%
    % corrVarStr = {'SLA_A1_1','SLA_A1_1to5','SLA_A1_6to30','SLA_A1_L30','stridesToAVGpert',...
    %     'Age', 'Weight', 'Height', 'BMI',...
    %     'STD_IN_1B','STD_FIN_1B','STD_DIFF_1B','STD_PERC_VAR_1B'};
    corrVarStr = {'SLA_A1_1','SLA_A1_1to5','SLA_A1_6to30','SLA_A1_L30','stridesToAVGpert',...
        'Age', 'Weight', 'Height', 'BMI',...
        'STD_IN_2B','STD_FIN_2B','STD_DIFF_2B','STD_PERC_VAR_2B'};
    
    %                  'Dspeed' , 'NDspeed', 'speedDiff', 'speedRatio'};
    corrVar = selPars(my_strcmpi(dataStrings,corrVarStr,1),:)';
    corrVarStrShort = {'S1','S1t5','S6t30','SS','NS',...
        'Age', 'WGT', 'HGT', 'BMI',...
        'VI','VF','VD','VP'};
    corrVarTab = array2table(corrVar,'VariableNames',corrVarStrShort);
    set(0,'DefaultAxesFontSize',10)
    [R, PV] = corrplot(corrVarTab,'testR','on');
    
    fh=gcf;
    rotAngle=0;
    rotate_all_ylabels(fh,rotAngle);
    % add_pvalues(fh,PV);
    %%
    % figure
    % imagesc(R);
    % colormap('jet');
    % colorbar;
    
    % get(gca,'YLabel')
    % set(get(gca,'YLabel'),'Rotation',0)
    % set(get(gca,'YLabel'),'Rotation',-90);
    % figure('DefaultLegendFontSize',22,'DefaultLegendFontSizeMode','manual')
    
    mycorrplot_1(corrVar,corrVarStrShort);%,type, colorbaron,textin)
    
    
end

