%% CREATE "stata_complete_table_diff.dat" table for Stata analyses
%% PERFORM stepwise regression analysis on differences A2-A1

clc
close all
clear all

%% FLAGS
SAVE_TABLE=0;
CREATE_SW_REPORT=0;
COMPUTE_PVAL_ADJ=0;
NPERMS=10^4; %It takes forever to consider more than 10^4 simulations
CONSIDER_INTERACTIONS=0;
NREP=20;
FILE_NAME='C:\Users\salat\OneDrive\Documents\MATLAB\MatlabFunctionExchangeApril6\Baseline Variaibility\Reports\step_wise_report_A2_m_A1.txt'; %File to write report to
STEPWISE_FIT=1; %If set to 1 uses stepwise fit; otherwise uses "stepwiselm"

%Constants
INTERFERENCE=1;
SAVINGS=2;
alpha=0.05;

%% Load outcome tables
genFold='C:\Users\salat\OneDrive\Documents\MATLAB\MatlabFunctionExchangeApril6\Interf_study_AS\SaveDataForStata\';

compFold=[genFold 'outcome_table_diff.mat'];
load(compFold);
outcome_table_diff=outcome_table_diff(1:16,:); %Remove empty entries
outcome_table_diff(:,10)=num2cell(double([outcome_table_diff{:,10}]==SAVINGS)); %Set savings as referent group
table_variables={'SLA_DIFF_1','SLA_DIFF_1to5','SLA_DIFF_6to30','SLA_DIFF_L30','fitPert1','fitPert1_5','fitRate6_30','fitSSL30','stridesToAVGpert','Group','subject','condition','ID'};
% group: 1=Interference, 2=Savings
%----------- !!All these variables are differences A2-A1!!-----------------

%% Load SLA_PERC_IMPROVEMENT (SLA_A2-SLA_A1/|SLA_A1|) More positive values mean "bigger improvememts"
[percImprovsVals, percImprovsStrings, A1_pars_vals, A1_pars_strings] = compute_perc_improvement(1);


%% Load regressors
compFold=[genFold 'REGRESSORS'];
load(compFold);
regressors_strings={'Age', 'Weight', 'Height', 'BMI', 'Group', 'PERC_REC_VAR'};

%Remove duplicate group information
REGRESSORS(:,5)=[];
regressors_strings{5}=[];
regressors_strings=regressors_strings(~cellfun('isempty',regressors_strings));


% group: 1=Interference, 2=Savings

%% Load baseline std
compFold=[genFold 'STD_BAS'];
load(compFold);
string_meas={'STD_IN','STD_FIN','STD_DIFF','STD_PERC_VAR'};
STD_BAS=STD_BAS';
STD_BAS_CORR=[STD_BAS(1:6,:); mean(STD_BAS); STD_BAS(7:end,:) ] ; %Inputing value for the subject without baseline

%% Create matrix
mat_table=[outcome_table_diff num2cell(REGRESSORS) num2cell(STD_BAS_CORR) num2cell(percImprovsVals)...
           num2cell(A1_pars_vals)];
var_names=[table_variables regressors_strings string_meas percImprovsStrings A1_pars_strings];

%% Create table
Table_diff=cell2table(mat_table,'VariableNames',var_names);

%% Save Stata table
if SAVE_TABLE
    writetable(Table_diff,'stata_complete_table_diff.dat');
end

%% STEPWISE regression
% ystring = 'dataSSL30'; %Selected outocme variable
ystrings={'SLA_DIFF_1','SLA_DIFF_1to5','SLA_DIFF_6to30','SLA_DIFF_L30','stridesToAVGpert'};
ystrings=[ystrings percImprovsStrings];
nregressions=length(ystrings);
xstrings = {'Age', 'Weight', 'Height', 'BMI','STD_IN','STD_FIN','STD_DIFF','STD_PERC_VAR','Group'}; %All the possible regressors
% xstrings = {'STD_FIN'}; %All the possible regressors

% xstrings = {'SLA_DIFF_1'}; %Only independent regressors

Xsw = cell2mat(mat_table(:,my_strcmpi(var_names,xstrings,1)));

%Open file for report
if(CREATE_SW_REPORT)
    fileID = fopen(FILE_NAME,'w');
end

adj_pval=nan;

%Generate interactions
if CONSIDER_INTERACTIONS
    [Xsw, xstrings] = generate_interactions(Xsw,xstrings);
end

%Main loop
for i=1:nregressions
%     
%     %Select current outcome
%     ystring=ystrings{i};
%     Ysw = cell2mat(mat_table(:,strcmpi(var_names,ystring)));
%     
%     %Fit best model
%     [b,se,pval,inmodel,stats,nextstep,history] = stepwisefit(Xsw,Ysw,'display','off');
%     modelPval=stats.pval;
% 
%     %Compute adjusted p-value
%     if COMPUTE_PVAL_ADJ && modelPval <= alpha
%         [adj_pval, adj_pval_se, significant] = compute_adj_pval(Ysw, Xsw, NPERMS, modelPval, NREP, alpha); %"Significant" is 1 if the ttest (H0: p-val-adj >= 0.05 is rejected)
%     else
%         adj_pval=nan; adj_pval_se=nan; significant=0;
%     end
%     
%     %Summarize results
%     [model, model_info, model_info_adj, model_detailed_info, reg_info] = my_sw_summary(stats, inmodel, ystring, xstrings, adj_pval, adj_pval_se, NPERMS, NREP, significant);
% 
%     if(CREATE_SW_REPORT)
%         fprintf(fileID,[model '\n' model_info '\n' reg_info '\n' model_info_adj '\n' model_detailed_info '\n\n']);
%     end
%     
    %Select current outcome
    ystring=ystrings{i};
    Ysw = cell2mat(mat_table(:,strcmpi(var_names,ystring)));
        
    %Fit best model with the selected function
    if STEPWISE_FIT
        [~,~,~,inmodel,stats,~,~] = stepwisefit(Xsw,Ysw,'display','off');
        [modelPval, regressorsPvals, b]=extract_info_from_swfit(stats,inmodel);
    else
        mdll = stepwiselm(Xsw, Ysw, 'CategoricalVar', catVars,'Verbose',0);
        [modelPval, inmodel, regressorsPvals, b] = extract_info_from_mdl(mdll);
    end
    %Compute adjusted p-value
    if COMPUTE_PVAL_ADJ && modelPval <= alpha
        [adj_pval, adj_pval_se, significant] = compute_adj_pval(Ysw, Xsw, NPERMS, modelPval, NREP, alpha, catVars, STEPWISE_FIT); %"Significant" is 1 if the ttest (H0: p-val-adj >= 0.05 is rejected)
    else
        adj_pval=nan; adj_pval_se=nan; significant=0;
    end
    
    %Summarize results
    [model, model_info, model_info_adj, model_detailed_info, reg_info] = my_sw_summary(regressorsPvals, b, modelPval, inmodel, ystring, xstrings, adj_pval, adj_pval_se, NPERMS, NREP, significant);
    
    if(CREATE_SW_REPORT)
        fprintf(fileID,[model '\n' model_info '\n' reg_info '\n' model_info_adj '\n' model_detailed_info '\n\n']);
    end
end


%Close file for report
if(CREATE_SW_REPORT)
    fileID = fclose(fileID);
end
% ystring = 'PERC_REC_VAR'; %Selected outocme variable

%% Test hand picked model
% selX={'STD_PERC_VAR','STD_FIN'}; 
selX={'STD_PERC_VAR', 'SLA_A1_1' 'Group'}; 
selY={'SLA_PV_1'};
Xsel = cell2mat(mat_table(:,my_strcmpi(var_names,selX,1)));
Ysel = cell2mat(mat_table(:,strcmpi(var_names,selY)));
X=[ones(size(Xsel,1),1) Xsel];
[b,bint,r,rint,stats] = regress(Ysel,X);

% In this model, the regressor STD_PERC_VAR is still significant.
% Therefore, also controlling for STD_FIN, there is a significant
% association between STD_PERC_VAR and SLA_PV_1. In particular,
% the more you increase STD_VAR during baseline, the less you will 
% improve from 1 to 2.

%%
indSel=1;
figure, compute_and_plot_regression_line(Xsel(:,indSel),Ysel)
% xlabel('SLA\_A1\_1')
xlabel(selX{1})
ylabel(selY{1})


