%% This script is meant to merge tables

clc
close all
clear all

tablePath = 'C:\Users\salat\OneDrive\Documents\MATLAB\Research\CoreL\Interference\Interf_study_AS\SaveDataForStata\Only tables\';

defaultDrop = {'group','subject','condition', 'ID'};
outcome_drop={'dataPert1','dataPert1_5','dataRate6_30','dataSSL30',...
    'fitPert1','fitPert1_5','fitRate6_30','fitSSL30',...
    'stridesToAVGpert',...
    'group','subject','condition','ID'};

contributionsDrop={...
    ...%SLA
    'SLAfitPert1','SLAfitPert1_5','SLAfitRate6_30','SLAfitSSL30',...
    'SLAstridesToAVGpert',...
    ... %SP
    'SPfitPert1','SPfitPert1_5','SPfitRate6_30','SPfitSSL30',...
    'SPstridesToAVGpert',...
    ...%ST
    'STfitPert1','STfitPert1_5','STfitRate6_30','STfitSSL30',...
    'STstridesToAVGpert',...
    ... %OTHER
    'group','subject','condition','ID',...
    };
%% Rate tables
% Contain rate measure computed on the monotonic mit
t1 = 'SLA_stata_rate_table.dat'; d1 = [];             a1 = 'SLA_';
t2 = 'ST_stata_rate_table.dat';  d2 = defaultDrop;    a2 = 'ST_' ;
t3 = 'SP_stata_rate_table.dat';  d3 = defaultDrop;    a3 = 'SP_' ;

%% Complete table
%Contains averages of data for SLA + Demographics + Baseline measures
t4 = 'stata_complete_table.dat'; d4 = outcome_drop; a4='';

%% Contributions table
%Contains averages of data for SLA + ST + SP (but not covariates)
t5 = 'stata_outcome_table_all_contributions_N2.dat'; d5=contributionsDrop; a5='';

tables = {t1,t2,t3,t4,t5};
drops  = {d1,d2,d3,d4,d5};
adds   = {a1,a2,a3,a4,a5};

nt=length(tables);
newT=[];
for i=1:nt
    T = readtable(tables{i});
    dr = drops{i};
    nd = length(dr);
    
    % Delete columns
    for j=1:nd
        eval(['T.' dr{j} '=[];']);
    end
    
    %Rename col
    oldNames = T.Properties.VariableNames; 
 
    newNames = strcat(adds{i},oldNames);
    if i==1
        newNames(1:4) = oldNames(1:4);
    end
    T.Properties.VariableNames=newNames;    
    
    newT=[newT T];
end

writetable(newT,[tablePath 'Int_proj_sfn_table_2.dat']);

