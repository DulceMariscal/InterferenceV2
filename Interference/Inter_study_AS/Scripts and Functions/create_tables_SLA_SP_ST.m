%% THIS FILE COMPUTES THE BASIC TABLE FOR STATA (w/ which to perform RANOVA)
%% NOTES
%% 1. Unlike create_tables.m, it adds also SP and ST
%% 2. It does not add the regressors [TODO], therefore, it cannot be used to do ANCOVA

clc
close all
clear all

%% WHAT TO DO WITH THIS SCRIPT
SAVE_MAT_TAB = 1; %Save tables in .mat 
SAVE_STATA_TAB = 1; %Save table for Stata in .dat

%Path to load the data from
ppath='C:\Users\salat\OneDrive\Documents\MATLAB\Research\CoreL\Interference\Interf_study_AS\SaveDataForStata\';
nrows=32;
nRepPar=9; %Number of parameters that are repeated
outcome_variables_all_contributions={...
                    ...%SLA
                    'SLAdataPert1','SLAdataPert1_5','SLAdataRate6_30','SLAdataSSL30',...
                    'SLAfitPert1','SLAfitPert1_5','SLAfitRate6_30','SLAfitSSL30',...
                    'SLAstridesToAVGpert',...
                   ... %SP
                    'SPdataPert1','SPdataPert1_5','SPdataRate6_30','SPdataSSL30',...
                    'SPfitPert1','SPfitPert1_5','SPfitRate6_30','SPfitSSL30',...
                    'SPstridesToAVGpert',...
                    ...%ST
                    'STdataPert1','STdataPert1_5','STdataRate6_30','STdataSSL30',...
                    'STfitPert1','STfitPert1_5','STfitRate6_30','STfitSSL30',...
                    'STstridesToAVGpert',...
                   ... %OTHER
                    'group','subject','condition','ID',...
                    };
                
%% DEFINITION OF CONSTANTS
GROUPS={'INT','SAV'};
CONDS={'A1','A2'};
mstrings={'','_STEP_POS_N2','_STEP_TIME_N2'};
nsp = length(mstrings);
ncond=length(CONDS);
ngr=length(GROUPS);
ns=8;
CGROUP=10;
CCOND=12;


%% INITIALIZATIONS

num_ov=length(outcome_variables_all_contributions);
outcome_table_all_contributions=cell(nrows,num_ov);
outcome_table_diff_all_contributions=cell(nrows,num_ov);
MERGED_DATA_FULL = [];     %cell(ncond, ns, ngr, nsp); % cond, sub, group, stepParameters
MERGED_DATA_FIT_FULL =[];  %cell(ncond, ns, ngr, nsp); % cond, sub, group, stepParameters

for i=1:nsp
    %Select file to load
    mstring = mstrings{i};
    cpath = [ppath 'ALL_DATA' mstring '.mat'];
    
    %Load
    load(cpath)    
    
    %Put into cell arrays
    MERGED_DATA = cat(3,INTERFERENCE_DATA,SAVINGS_DATA);
    MERGED_DATA_FIT = cat(3,INTERFERENCE_FIT_DATA(:,:,1),SAVINGS_FIT_DATA(:,:,1)); %3rd dim. 1=fit, 2=derfit
    MERGED_DATA_FULL = cat(4,MERGED_DATA_FULL, MERGED_DATA);
    MERGED_DATA_FIT_FULL = cat(4,MERGED_DATA_FIT_FULL, MERGED_DATA);

end
id=1;

for par=1:nsp
    indRow = 1;
    indRow_diff = 1;
    
    for group=1:ngr
        G=GROUPS{group};
        
        for sub=1:nos(group)
            S=[G(1) num2str(sub)];
            
            
            %EXTRACT AND STORE SINGLE CONDITION RESULTS------------------------
            for cond=1:ncond
                
                cdata=MERGED_DATA_FULL{cond,sub,group,par};
                cdata_fit=MERGED_DATA_FIT_FULL{cond,sub,group,par};
                
                COND=CONDS{cond};
                
                %Data averages
                offs = nRepPar*(par-1);
                outcome_table_all_contributions{indRow,1 + offs }=cdata(1);
                outcome_table_all_contributions{indRow,2 + offs}=nanmean(cdata(1:5));
                outcome_table_all_contributions{indRow,3 + offs}=nanmean(cdata(6:30));
                outcome_table_all_contributions{indRow,4 + offs}=nanmean(cdata(end-30+1:end));
                
                %Fit averages
                outcome_table_all_contributions{indRow,5 + offs}=cdata_fit(1);
                outcome_table_all_contributions{indRow,6 + offs}=nanmean(cdata_fit(1:5));
                outcome_table_all_contributions{indRow,7 + offs}=nanmean(cdata_fit(6:30));
                outcome_table_all_contributions{indRow,8 + offs}=nanmean(cdata_fit(end-30+1:end));
                
                %Extra measures
                outcome_table_all_contributions{indRow,9 + offs}=PARAMETERS_ALL{group}(cond,STRIDES_TO_HALVE,sub);
                
                %Specify subject and group
                    outcome_table_all_contributions{indRow,num_ov - 3}=group;%G;
                    outcome_table_all_contributions{indRow,num_ov - 2}=S;
                    outcome_table_all_contributions{indRow,num_ov - 1}=cond;
                    
                    outcome_table_all_contributions{indRow,num_ov}=id;
                %Increment counter
                indRow=indRow+1;
            end
            
            %EXTRACT AND STORE DIFFERENCES A2-A1 ------------------------------
            cdata_A2=MERGED_DATA_FULL{2,sub,group,par};
            cdata_A1=MERGED_DATA_FULL{1,sub,group,par};
            cdata_A2_fit=MERGED_DATA_FIT_FULL{2,sub,group,par};
            cdata_A1_fit=MERGED_DATA_FIT_FULL{1,sub,group,par};
            
            %Data averages
            outcome_table_diff_all_contributions{indRow_diff,1 + offs}=cdata_A2(1)-cdata_A1(1);
            outcome_table_diff_all_contributions{indRow_diff,2 + offs}=nanmean(cdata_A2(1:5))-nanmean(cdata_A1(1:5));
            outcome_table_diff_all_contributions{indRow_diff,3 + offs}=nanmean(cdata_A2(6:30))-nanmean(cdata_A1(6:30));
            outcome_table_diff_all_contributions{indRow_diff,4 + offs}=nanmean(cdata_A2(end-30+1:end))-nanmean(cdata_A1(end-30+1:end));
            
            %Fit averages
            outcome_table_diff_all_contributions{indRow_diff,5 + offs}=cdata_A2_fit(1)-cdata_A1_fit(1);
            outcome_table_diff_all_contributions{indRow_diff,6 + offs}=nanmean(cdata_A2_fit(1:5))-nanmean(cdata_A1_fit(1:5));
            outcome_table_diff_all_contributions{indRow_diff,7 + offs}=nanmean(cdata_A2_fit(6:30))-nanmean(cdata_A1_fit(6:30));
            outcome_table_diff_all_contributions{indRow_diff,8 + offs}=nanmean(cdata_A2_fit(end-30+1:end))-nanmean(cdata_A1_fit(end-30+1:end));
            
            %Extra measures
            outcome_table_diff_all_contributions{indRow_diff,9 + offs}=PARAMETERS_ALL{group}(2,STRIDES_TO_HALVE,sub)-...
                PARAMETERS_ALL{group}(1,STRIDES_TO_HALVE,sub);
            
            %Specify subject and group
                outcome_table_diff_all_contributions{indRow_diff,num_ov - 3}=group;%G;
                outcome_table_diff_all_contributions{indRow_diff,num_ov - 2}=S;
                outcome_table_diff_all_contributions{indRow_diff,num_ov - 1}='A2-A1';
                outcome_table_diff_all_contributions{indRow_diff,num_ov}=id;
            %Increment counter
            indRow_diff=indRow_diff+1;
            id=id+1;
        end
        
    end
end

Table=cell2table(outcome_table_all_contributions,'VariableNames',outcome_variables_all_contributions);
Table_diff=cell2table(outcome_table_diff_all_contributions,'VariableNames',outcome_variables_all_contributions);

if SAVE_STATA_TAB
    writetable(Table,'stata_outcome_table_all_contributions_N2.dat');
    writetable(Table_diff,'stata_outcome_table_diff_all_contributions_N2.dat');
end

if SAVE_MAT_TAB %Save them in .mat file for matlab analyses
    save('outcome_table_diff_all_contributions_N2.mat', 'outcome_table_diff_all_contributions');
    save('outcome_table_all_contributions_N2.mat', 'outcome_table_all_contributions');
end


