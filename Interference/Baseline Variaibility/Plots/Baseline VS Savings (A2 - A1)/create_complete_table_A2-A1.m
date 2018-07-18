%% CREATE "stata_complete_table_diff.dat" table for Stata analyses
%% PERFORM stepwise regression analysis on differences A2-A1

clc
close all
clear all

%% FLAGS
SAVE_TABLE=0;
CREATE_SW_REPORT=1;
FILE_NAME='C:\Users\salat\OneDrive\Documents\MATLAB\MatlabFunctionExchangeApril6\Baseline Variaibility\Reports\step_wise_report.txt'; %File to write report to
INTERFERENCE=1;
SAVINGS=2;

%% Load outcome tables
genFold='C:\Users\salat\OneDrive\Documents\MATLAB\MatlabFunctionExchangeApril6\Interf_study_AS\SaveDataForStata\';

compFold=[genFold 'outcome_table_diff.mat'];
load(compFold);
outcome_table_diff=outcome_table_diff(1:16,:); %Remove empty entries
outcome_table_diff(:,10)=num2cell(double([outcome_table_diff{:,10}]==SAVINGS)); %Set savings as referent group
table_variables={'SLA_A1_1','SLA_A1_1to5','SLA_A1_6to30','SLA_A1_L30','fitPert1','fitPert1_5','fitRate6_30','fitSSL30','stridesToAVGpert','Group','subject','condition','ID'};
% group: 1=Interference, 2=Savings
%----------- !!All these variables are differences A2-A1!!-----------------

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
mat_table=[outcome_table_diff num2cell(REGRESSORS) num2cell(STD_BAS_CORR)];
var_names=[table_variables regressors_strings string_meas];

%% Create table
Table_diff=cell2table(mat_table,'VariableNames',var_names);

%% Save Stata table
if SAVE_TABLE
    writetable(Table_diff,'stata_complete_table_diff.dat');
end

%% STEPWISE regression
% ystring = 'dataSSL30'; %Selected outocme variable
ystrings={'SLA_A1_1','SLA_A1_1to5','SLA_A1_6to30','SLA_A1_L30','stridesToAVGpert'};
nregressions=length(ystrings);
%xstrings = {'Age', 'Weight', 'Height', 'BMI','STD_IN','STD_FIN','STD_DIFF','STD_PERC_VAR','Group'}; %All the possible regressors
xstrings = {'Age', 'Weight', 'Height', 'BMI','STD_IN','STD_DIFF','STD_PERC_VAR','Group'}; %All the possible regressors
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
% ystring = 'PERC_REC_VAR'; %Selected outocme variable



