function [percImprovsVals, percImprovsStrings, A1_pars_vals , A1_pars_strings] = compute_perc_improvement(PLOT)

%% Load values
genFold='C:\Users\salat\OneDrive\Documents\MATLAB\MatlabFunctionExchangeApril6\Interf_study_AS\SaveDataForStata\';
compFold=[genFold 'outcome_table.mat'];
load(compFold);

%% FLAGS
A1=1;
A2=2;
COND=12;
%% Define variables of interest
allVars     = {'SLA_A1_1','SLA_A1_1to5','SLA_A1_6to30','SLA_A1_L30','fitPert1','fitPert1_5','fitRate6_30','fitSSL30','stridesToAVGpert','Group','subject','condition','ID'};
selVars     = {'SLA_A1_1','SLA_A1_1to5','SLA_A1_6to30','SLA_A1_L30','stridesToAVGpert'};
indSelVars  = my_strcmpi(allVars,selVars,1);


%% Select A1 values
indA1=[outcome_table{:,COND}]==A1;
outcome_table_A1=cell2mat(outcome_table(indA1,indSelVars)); %Select only A1 data

%% Select A2 values
indA2=[outcome_table{:,COND}]==A2;
outcome_table_A2=cell2mat(outcome_table(indA2,indSelVars)); %Select only A2 data

%% Compute new var
percImprovsVals = (outcome_table_A2 - outcome_table_A1)./abs(outcome_table_A1) ;
percImprovsStrings = {'SLA_PV_1','SLA_PV_1to5','SLA_PV_6to30','SLA_PV_L30','stridesToAVGpert_PV'};


%% Plot new var
if PLOT==1
    margins=[.05 .05];
    figure
    for i=1:5
        
        subplot_tight(1,5,i,margins)
        bar([outcome_table_A1(:,i) outcome_table_A2(:,i) percImprovsVals(:,i)])
        % plot(outcome_table_A1(:,i),'o')
        % hold on
        % plot(outcome_table_A2(:,i),'o')
        % hold on
        % plot(percImprovsVals(:,i),'o')
        
        legend('A1','A2','PV')
        xlabel('Subjects');
        grid on
        
    end
end
A1_pars_vals=outcome_table_A1(:,1:end-1);
A1_pars_strings=selVars(1:end-1);

end