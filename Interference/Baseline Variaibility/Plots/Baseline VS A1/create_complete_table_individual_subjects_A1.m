%% CREATE "stata_complete_table.dat" table for Stata analyses
%% PERFORM stepwise regression analysis with A1

clc
close all
clear all

%% PARS
SAVE_TABLE=0;
CREATE_SW_REPORT=1;
FILE_NAME='C:\Users\salat\OneDrive\Documents\MATLAB\MatlabFunctionExchangeApril6\Baseline Variaibility\Reports\step_wise_report_A1.txt'; %File to write report to

%% FLAGS
A1=1;
A2=2;

%% Load outcome tables
genFold='C:\Users\salat\OneDrive\Documents\MATLAB\MatlabFunctionExchangeApril6\Interf_study_AS\SaveDataForStata\';
compFold=[genFold 'outcome_table.mat'];
load(compFold);
% table_variables={'dataPert1','dataPert1_5','dataRate6_30','dataSSL30','fitPert1','fitPert1_5','fitRate6_30','fitSSL30','stridesToAVGpert','group','subject','condition','ID'};
indA1=[outcome_table{:,12}]==A1;
outcome_table_red=outcome_table(indA1,:); %Select only A1 data

table_variables={'SLA_A1_1','SLA_A1_1to5','SLA_A1_6to30','SLA_A1_L30','fitPert1','fitPert1_5','fitRate6_30','fitSSL30','stridesToAVGpert','Group','subject','condition','ID'};
% group: 1=Interference, 2=Savings


%% Load regressors
compFold=[genFold 'REGRESSORS'];
load(compFold);
regressors_strings={'age', 'weight', 'height', 'BMI', 'group', 'PERC_REC_VAR'};
%Remove duplicate group information
REGRESSORS(:,5)=[]; 
regressors_strings{5}=[];
regressors_strings=regressors_strings(~cellfun('isempty',regressors_strings));  
REGRESSORS_D = my_duplicate(REGRESSORS);

% group: 1=Interference, 2=Savings

%% Load baseline std
compFold=[genFold 'STD_BAS'];
load(compFold);
string_meas={'STD_IN','STD_FIN','STD_DIFF','STD_PERC_VAR'};
STD_BAS=STD_BAS';
STD_BAS_CORR=[STD_BAS(1:6,:); mean(STD_BAS); STD_BAS(7:end,:) ] ; %Inputing value for the subject without baseline
STD_BAS_CORR_D = my_duplicate(STD_BAS_CORR);

%% Create matrix
% mat_table=[outcome_table num2cell(REGRESSORS_D) num2cell(STD_BAS_CORR_D)];
mat_table=[outcome_table_red num2cell(REGRESSORS) num2cell(STD_BAS_CORR)];
var_names=[table_variables regressors_strings string_meas];

%% Create table
Table=cell2table(mat_table,'VariableNames',var_names);

%% Save Stata table
if SAVE_TABLE
    writetable(Table,'stata_complete_table.dat');
end

%% STEPWISE regression
% ystring = 'dataSSL30'; %Selected outocme variable
ystrings={'SLA_A1_1','SLA_A1_1to5','SLA_A1_6to30','SLA_A1_L30','stridesToAVGpert'};
nregressions=length(ystrings);
xstrings = {'Age', 'Weight', 'Height', 'BMI','STD_IN','STD_FIN','STD_DIFF','STD_PERC_VAR','Group'}; %All the possible regressors
% xstrings = {'Age', 'Weight', 'BMI','STD_IN','STD_DIFF','STD_PERC_VAR','Group'}; %All the possible regressors

Xsw = cell2mat(mat_table(:,my_strcmpi(var_names,xstrings)));

%Open file for report  
if(CREATE_SW_REPORT)
    fileID = fopen(FILE_NAME,'w');
end

%Main loop
for i=1:nregressions
    
    %Select current outcome
    ystring=ystrings{i};
    Ysw = cell2mat(mat_table(:,strcmpi(var_names,ystring)));
    
    %Fit best model
    [b,se,pval,inmodel,stats,nextstep,history] = stepwisefit(Xsw,Ysw);
    
    %Summarize results
    [model, model_info, reg_info] = my_sw_summary(stats, inmodel, ystring, xstrings);
    
    if(CREATE_SW_REPORT)
        fprintf(fileID,[model '\n' model_info '\n' reg_info '\n\n']);
    end
   
    
end

%Close file for report  
if(CREATE_SW_REPORT)
    fileID = fclose(fileID);
end

%% TEST SIMPLE REGRESSION
xstrings = {'STD_PERC_VAR'}; %All the possible regressors
Xsw = cell2mat(mat_table(:,my_strcmpi(var_names,xstrings)));
X = [ones(size(Xsw)) Xsw];
ystring={'SLA_A1_1to5'};
y = cell2mat(mat_table(:,strcmpi(var_names,ystring)));

[b,bint,r,rint,stats] = regress(y,X);    % Removes NaN data

% %% STEPWISE regression
% % ystring = 'dataSSL30'; %Selected outocme variable
% ystring = 'PERC_REC_VAR'; %Selected outocme variable
% 
% xstrings = {'dataPert1','dataPert1_5','dataRate6_30','age', 'weight', 'height', 'BMI','STD_IN','STD_FIN','STD_DIFF','STD_PERC_VAR'}; %All the possible regressors
% 
% Ysw = cell2mat(mat_table(:,strcmpi(var_names,ystring)));
% Xsw = cell2mat(mat_table(:,my_strcmpi(var_names,xstrings)));
% 
% [b,se,pval,inmodel,stats,nextstep,history] = stepwisefit(Xsw,Ysw);
% selected_variables={xstrings{inmodel}}