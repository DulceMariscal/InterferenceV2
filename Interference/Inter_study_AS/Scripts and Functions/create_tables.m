%% THIS FILE COMPUTES THE BASIC TABLE FOR STATA (w/ which to perform RANOVA)

clc
close all
clear all


ppath='C:\Users\salat\OneDrive\Documents\MATLAB\MatlabFunctionExchangeApril6\Interf_study_AS\SaveDataForStata\';
load([ppath 'ALL_DATA' ])
nrows=sum(nos*2);

outcome_variables={'dataPert1','dataPert1_5','dataRate6_30','dataSSL30',...
    'fitPert1','fitPert1_5','fitRate6_30','fitSSL30',...
    'stridesToAVGpert',...
    'group','subject','condition','ID'};
CGROUP=10;
CCOND=12;
num_ov=length(outcome_variables);
outcome_table=cell(nrows,num_ov);
outcome_table_diff=cell(nrows,num_ov);
GROUPS={'INT','SAV'};
CONDS={'A1','A2'};
MERGED_DATA=cat(3,INTERFERENCE_DATA,SAVINGS_DATA);
MERGED_DATA_FIT=cat(3,INTERFERENCE_FIT_DATA(:,:,1),SAVINGS_FIT_DATA(:,:,1)); %3rd dim. 1=fit, 2=derfit
CREATE_TABLE=0;
indRow=1;
id=1;
indRow_diff=1;
SAVE_TABLES=1;

for group=1:2
    G=GROUPS{group};
    for sub=1:nos(group)
        S=[G(1) num2str(sub)];
        
        
        %EXTRACT AND STORE SINGLE CONDITION RESULTS------------------------
        for cond=1:2
            cdata=MERGED_DATA{cond,sub,group};
            cdata_fit=MERGED_DATA_FIT{cond,sub,group};
            
            COND=CONDS{cond};
            
            %Data averages
            outcome_table{indRow,1}=cdata(1);
            outcome_table{indRow,2}=nanmean(cdata(1:5));
            outcome_table{indRow,3}=nanmean(cdata(6:30));
            outcome_table{indRow,4}=nanmean(cdata(end-30+1:end));
            
            %Fit averages
            outcome_table{indRow,5}=cdata_fit(1);
            outcome_table{indRow,6}=nanmean(cdata_fit(1:5));
            outcome_table{indRow,7}=nanmean(cdata_fit(6:30));
            outcome_table{indRow,8}=nanmean(cdata_fit(end-30+1:end));
            
            %Extra measures
            outcome_table{indRow,9}=PARAMETERS_ALL{group}(cond,STRIDES_TO_HALVE,sub);
            
            %Specify subject and group
            outcome_table{indRow,10}=group;%G;
            outcome_table{indRow,11}=S;
            outcome_table{indRow,12}=cond;
            
            outcome_table{indRow,13}=id;
            %Increment counter
            indRow=indRow+1;
        end
        %EXTRACT AND STORE DIFFERENCES A2-A1 ------------------------------
        cdata_A2=MERGED_DATA{2,sub,group};
        cdata_A1=MERGED_DATA{1,sub,group};
        cdata_A2_fit=MERGED_DATA_FIT{2,sub,group};
        cdata_A1_fit=MERGED_DATA_FIT{1,sub,group};
        
        %Data averages
        outcome_table_diff{indRow_diff,1}=cdata_A2(1)-cdata_A1(1);
        outcome_table_diff{indRow_diff,2}=nanmean(cdata_A2(1:5))-nanmean(cdata_A1(1:5));
        outcome_table_diff{indRow_diff,3}=nanmean(cdata_A2(6:30))-nanmean(cdata_A1(6:30));
        outcome_table_diff{indRow_diff,4}=nanmean(cdata_A2(end-30+1:end))-nanmean(cdata_A1(end-30+1:end));
        
        %Fit averages
        outcome_table_diff{indRow_diff,5}=cdata_A2_fit(1)-cdata_A1_fit(1);
        outcome_table_diff{indRow_diff,6}=nanmean(cdata_A2_fit(1:5))-nanmean(cdata_A1_fit(1:5));
        outcome_table_diff{indRow_diff,7}=nanmean(cdata_A2_fit(6:30))-nanmean(cdata_A1_fit(6:30));
        outcome_table_diff{indRow_diff,8}=nanmean(cdata_A2_fit(end-30+1:end))-nanmean(cdata_A1_fit(end-30+1:end));
        
        %Extra measures
        outcome_table_diff{indRow_diff,9}=PARAMETERS_ALL{group}(2,STRIDES_TO_HALVE,sub)-...
            PARAMETERS_ALL{group}(1,STRIDES_TO_HALVE,sub);
        
        %Specify subject and group
        outcome_table_diff{indRow_diff,10}=group;%G;
        outcome_table_diff{indRow_diff,11}=S;
        outcome_table_diff{indRow_diff,12}='A2-A1';
        outcome_table_diff{indRow_diff,13}=id;
        
        %Increment counter
        indRow_diff=indRow_diff+1;
        id=id+1;
    end
    
end

Table=cell2table(outcome_table,'VariableNames',outcome_variables);
Table_diff=cell2table(outcome_table_diff,'VariableNames',outcome_variables);

if CREATE_TABLE
    
    writetable(Table,'stata_outcome_table.dat');
    writetable(Table_diff,'stata_outcome_table_diff.dat');

end

if SAVE_TABLES %Save them in .mat file for matlab analyses
    save('outcome_table_diff.mat', 'outcome_table_diff');
    save('outcome_table.mat', 'outcome_table');
end


%% Correlation and regression analysis-----------------------------------------------------
indCond1=[outcome_table{:,CCOND}]==1;
indCond2=[outcome_table{:,CCOND}]==2;
indGr1=[outcome_table{:,CGROUP}]==1;
indGr2=[outcome_table{:,CGROUP}]==2;

figure 

subplot(1,2,1)
c1g1=[outcome_table{indCond1&indGr1,9}]'; 
c2g1=[outcome_table{indCond2&indGr1,9}]';
scatter(c1g1,c2g1)
NR=length(c1g1);
b1=regress(c2g1,[ones(NR,1) c1g1]);
hold on, plot(c1g1,b1(1) + b1(2)*(c1g1))
xlabel('A1')
ylabel('A2')
[r1,p1]=corrcoef(c1g1,c2g1);
% title(['Interference Group, rho= ' num2str(r1) 'p= ' num2str(p1)   ])
axis equal
grid on

subplot(1,2,2)
c1g2=[outcome_table{indCond1&indGr2,9}]';
c2g2=[outcome_table{indCond2&indGr2,9}]';
scatter(c1g2,c2g2)
NR=length(c1g2);
b2=regress(c2g2,[ones(NR,1) c1g2]);
hold on, plot(c1g2,b2(1) + b2(2)*(c1g2))
xlabel('A1')
ylabel('A2')
[r2,p2]=corrcoef(c1g2,c2g2);
axis equal
grid on
% title(['Interference Group, rho= ' num2str(r2) 'p= ' num2str(p2)   ])
