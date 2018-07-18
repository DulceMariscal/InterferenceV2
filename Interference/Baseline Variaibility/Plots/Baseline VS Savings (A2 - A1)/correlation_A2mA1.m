%% COMPUTE CORRELATION BETWEEN BASELINE VARIAIBLITY AND (LEARNING RATE, ...) and DIFFERENCES A2-A1

clc
close all
clear all

% Subjects to exclude
bad_subs=7; % Corresponds to I008 (Baseline before training was not recorded,
% an additional washout was performed to estimate baseline asymmetry)

% Fixed variables
INTERFERENCE=1;
SAVINGS=2;
A1=1;
A2=2;

% Parameters analysis
firstBad=5;
lastBad=5;
w=10; %Window runnign std


% Plot parameters
margins=[0.05 0.05];

%% Load outcome tables
genFold='C:\Users\salat\OneDrive\Documents\MATLAB\MatlabFunctionExchangeApril6\Interf_study_AS\SaveDataForStata\';
compFold=[genFold 'outcome_table_diff.mat'];
load(compFold);
table_variables={'dataPert1 DIFF','dataPert1-5 DIFF','dataRate6-30 DIFF','dataSSL30 DIFF','fitPert1 DIFF',...
    'fitPert1-5 DIFF','fitRate6-30 DIFF','fitSSL30 DIFF','stridesToAVGpert DIFF','group','subject','condition','ID'};
% group: 1=Interference, 2=Savings
outcome_table_diff=outcome_table_diff(1:16,:); %Remove empty entries

%% Load regressors
compFold=[genFold 'REGRESSORS'];
load(compFold);
regressors_strings={'age', 'weight', 'height', 'BMI', 'group', 'PERC_REC_VAR'};
% group: 1=Interference, 2=Savings

%% Load baseline data
compFold=[genFold 'BASELINE_DATA'];
load(compFold);
% order: Interference subjects - Savings subjects

%% Load number of initial strides removed from A1 (and A2)
compFold=[genFold 'minNOSToRemove'];
load(compFold);
nStridesRemoved=[minNOSToRemove(1,:) minNOSToRemove(2,:)];

%% Process baseline and compute std----------------------------------------
focusPars=[8 9];
nfp=length(focusPars);
data=BASELINE_DATA;
ns=length(data);
stdevs=zeros(1,ns);
legends={};
l=[];
f1=figure;
for csub=1:ns
    % 0 Extract data
    cdata=data{csub};
    % 1. Remove first and last strides
    %     cdata=cdata(firstBad+1:end-lastBad);
    cdata=cdata(end-lastBad-w+1:end-lastBad); %Last ten excluding last 5
    % 2. Filter out noise (Due to cameras, wrong interpolations, ..)
    
    % 3. Compute standard deviation
    stdevs(csub) = nanstd(cdata);
    
    % 4. Plot stdev
    subplot_tight(4,4,csub,margins);
    plot(cdata)
    hold on
    plot(cdata(1))
    
    % 5. Insert legend (value of parameter of interest)
%     for fp=1:nfp
%         cpar=focusPars(fp);
%         fp_str = [table_variables{cpar}];
%         allVals=[outcome_table{indA1,cpar}];
%         fp_val = allVals(csub);
%         legends{fp}=[fp_str ' = ' num2str(fp_val)];
%     end
%     
%     l(csub) = legend(legends);
    legends={};
    axis tight
end

%% PLOT CORRELATION ANALYSES----------------------------------------------
% indices_outliers=detect_outliers();

% Remove abnormal subjects
indOK=setdiff(1:16,bad_subs);

% Define outcomes
parameters_considered = [1:9] ; %All parameters contained in the table
npars=length(parameters_considered);


%Compute and plot
f2=figure;
for cpar=1:npars
    %Extract par data
    cpar_data=[outcome_table_diff{:,cpar}];
    
    %Compute correlation and plot
    subplot_tight(3,3,cpar,margins);
    
    compute_and_plot_regression_line(stdevs(indOK),cpar_data(indOK));
    
    %ind_high = intersect( find(nStridesRemoved > 6), indOK );%Indices of people from which more than 6 strides from A1 were removed
    %hold on
    %plot(stdevs(ind_high),cpar_data(ind_high),'*')
    
    xlabel('Baseline STD')
    ylabel(table_variables{cpar})
end


%% CORRELATION INITIAL PERTURBATION VS RATE
% f3=figure;
% par1_str='dataPert1';
% par2_str='dataSSL30'; %Significant!!! SLA variability during baseline  --- correlates with ---> SLA during first adaptation strides
% %SLA during first adaptation      --- correlates with ---> SLA at steady state
% % bivariate regression to test it
% 
% ind_first_par=strcmp(table_variables,  par1_str);
% ind_second_par=strcmp(table_variables, par2_str);
% 
% par1=[outcome_table{indA1,ind_first_par}];
% par2=[outcome_table{indA1,ind_second_par}];
% compute_and_plot_regression_line(par1(indOK),par2(indOK));
% xlabel(par1_str)
% ylabel(par2_str)

%% CORRELATION NUMBER OF STRIDES REMOVED WITH OTHER VARIABLES
%Compute and plot
f4=figure;
for cpar=1:npars
    %Extract par data
    if cpar==9 %Instead of the rate (non significan anyway),
        %I am plotting stdev VS number of strides removed
        cpar_data=stdevs;
        current_ylabel='Baseline STD';
    else
        cpar_data=[outcome_table_diff{:,cpar}];
        current_ylabel=table_variables{cpar};
    end
    %Plot
    subplot_tight(3,3,cpar,margins);
    
    compute_and_plot_regression_line(nStridesRemoved(indOK),cpar_data(indOK));
    xlabel('Number of Strides Removed')
    ylabel(current_ylabel)
end

%% RUNNING AVERAGE OF STD DURING BASELINE (HP: it increases in those who will be less perturbed)
figure
stdevs_in=[]; %Standard deviation over initial
stdevs_fin=[]; %Standard deviation over initial

for csub=1:ns
    % 0 Extract data
    cdata=data{csub};
    
    % 1. Remove first and last strides
    cdata=cdata(firstBad+1:end-lastBad);
    n=length(cdata);
    v=1:n;
    
    % 2. Filter out noise (Due to cameras, wrong interpolations, ..)
    
    % 3. Compute running standard deviation
    runningStd=compute_running_std(cdata,w);
    
    % 4. Plot baseline + overlapped standardDev
    subplot_tight(4,4,csub,margins);
    plot(cdata)
    hold on
    plot(w:n,runningStd,'*')
    
    % 5. Store initial and final stdev
    if any(csub==indOK) %Exclude bad subject
        stdevs_in  = [stdevs_in  runningStd(1)];
        stdevs_fin = [stdevs_fin runningStd(end)];
    end
    legend('Baseline','runningStd');
    
    %     % 5. Insert legend (value of parameter of interest)
    %     for fp=1:nfp
    %         cpar=focusPars(fp);
    %         fp_str = [table_variables{cpar}];
    %         allVals=[outcome_table{indA1,cpar}];
    %         fp_val = allVals(csub);
    %         legends{fp}=[fp_str ' = ' num2str(fp_val)];
    %     end
    %
    %     l(csub) = legend(legends);
    %     legends={};
    
end

%% TEST VARIATION IN BASELINE STANDARD DEVIATION
[H, P]          =   ttest(stdevs_fin - stdevs_in); %Two tailed paired ttest
variations      =  (stdevs_fin - stdevs_in)./stdevs_in ;
[sortedVariation, isort]=sort(variations);

figure(f2);
for cpar=1:npars
    %Extract par data
    cpar_data=[outcome_table_diff{:,cpar}];
    subplot_tight(3,3,cpar,margins);
    hold on
    
    %Select indices
    cpOK=cpar_data(indOK);
    stdOK=stdevs(indOK);
    for csub=1:15
        %Get rank current subj
        crank=find(sortedVariation==variations(csub));
        %Plot corespondent rank
        hold on
        text(stdOK(csub),cpOK(csub),num2str(crank));
    end
    
end

%% CORRELATION BETWEEN P1 (P15, P6_30 PL30 Prate) (AND P1) AND (1)initial std, (2)final std, (3)difference in std, (5)percent change in std, (6) age
figure
selected_pars=[1:4 9];
nsp=length(selected_pars); %Number of selected parameters
STD_BAS=[stdevs_in; stdevs_fin; (stdevs_fin - stdevs_in); (stdevs_fin - stdevs_in)./stdevs_in ];
nmeas=size(STD_BAS,1); %Numeber of selected measures based on std during baseline
string_meas={'STD IN','STD FIN','STD DIFF','STD PERC VAR'};
for cpar=1:nsp
    
    %Extract indices current parameter
    ind_cpar=selected_pars(cpar);
    
    %Extract par data
    cpar_data=[outcome_table_diff{:,ind_cpar}];
    cxlab=table_variables{ind_cpar};
    
    for cmeas=1:nmeas
        %Extract current measure
        cmeas_data=STD_BAS(cmeas,:);
        cylab=string_meas{cmeas};
        
        %Compute and plot correlation
        indsubplot=nsp*(cmeas-1)+cpar;
        subplot_tight(nmeas,nsp,indsubplot,margins);
        compute_and_plot_regression_line(cpar_data(indOK),cmeas_data);
        
        if cmeas==nmeas
            xlabel(cxlab);
        end
        if cpar==1
            ylabel(cylab);
        end
    end
    
    %Plot
    
end

%% CORRELATION BETWEEN P1 (P15, P6_30 PL30 Prate) (AND P1) AND DEMOGRAPHICS
figure
selected_pars=[1:4 9];
nsp=length(selected_pars); %Number of selected parameters
selected_dem=REGRESSORS(indOK,1:4)';
ndem=size(selected_dem,1); %Numeber of selected measures based on std during baseline
string_dem={'AGE','WEIGHT','HEIGHT','BMI'};
for cpar=1:nsp
    
    %Extract indices current parameter
    ind_cpar=selected_pars(cpar);
    
    %Extract par data
    cpar_data=[outcome_table_diff{:,ind_cpar}];
    cxlab=table_variables{ind_cpar};
    
    for cdem=1:ndem
        %Extract current measure
        cdem_data=selected_dem(cdem,:);
        cylab=string_dem{cdem};
        
        %Compute and plot correlation
        indsubplot=nsp*(cdem-1)+cpar;
        subplot_tight(ndem,nsp,indsubplot,margins);
        compute_and_plot_regression_line(cpar_data(indOK),cdem_data);
        
        if cdem==ndem
            xlabel(cxlab);
        end
        if cpar==1
            ylabel(cylab);
        end
    end
    
    %Plot
    
end

%% CORRELATION DEM (selected_dem) VS STD (STD_BASE)

figure
for cmeas=1:nmeas
    
    %Extract current measure
    cmeas_data=STD_BAS(cmeas,:);
    cxlab=string_meas{cmeas};
    
    
    for cdem=1:ndem
        %Extract current measure
        cdem_data=selected_dem(cdem,:);
        cylab=string_dem{cdem};
        
        %Compute and plot correlation
        indsubplot=nmeas*(cdem-1)+cmeas;
        subplot_tight(ndem,nmeas,indsubplot,margins);
        compute_and_plot_regression_line(cmeas_data,cdem_data);
        
        if cdem==ndem
            xlabel(cxlab);
        end
        if cmeas==1
            ylabel(cylab);
        end
    end
    
    %Plot
    
end


%% PLOT ST IN VS FIN
figure
v1=ones(1,15);
v2=2*v1;

scatter(v1,stdevs_in,'o');
hold on
scatter(v2,stdevs_fin,'o');

%Plot lines
for i=1:15
    cin=stdevs_in(i);
    cfin=stdevs_fin(i);
    cin_diff=cfin-cin;
    if cin_diff<0;
        ccolor='k';
    else
        ccolor='g';
    end
    line([1 2], [cin cfin],'Color',ccolor);
end

ylabel('STD (BASELINE SLA)')
xlabel('Epoch')
legend(['Initial AVG = ' num2str(mean(stdevs_in))], ['Final AVG = ' num2str(mean(stdevs_fin))]);
title(['p-value = ' num2str(P) '  (Two sided, paired t-test)'])
xlim([0.8 2.2]);

%% CORRELATION AGE VS OTHER STUFF
figure
%% 2 CLUSTERS IN SPACE STD VS INITIAL PERTURBATIO. Do they differ in BMI, height, something ?

%% REPEAT ANOVA ANALYSIS IN POSTER USING THIS NEW COVARIATE TO SHOW THAT P-VALUE DECREASE

%% SAVE BASELINE STDS
% save('STD_BAS.mat','STD_BAS');

%% INCREASE FONTS
mySetFontSize([l], 14);

% Plot all baseline

%
% ns=size(REGRESSORS,1);
% recall_pv=REGRESSORS(:,end);
% X=REGRESSORS(:,1:end-1);
%
% X(:,end) = X(:,end)==2; %In this way savings group is the baseline group
% y=recall_pv;
%
%
% % X=[ones(ns,1) X];%Add the constant term
% %[b,bint,r,rint,stats] = regress(y,X);
% [b,dev,st] = glmfit(X,y); %No need to add a column of ones
% %[b] are the regression coefficients

%[dev] is the deviance, a generalized version of sum of squares, normalized
%by number of parameters. You can compare the deviance of different models
%with different number of parameters

%[st.p] contains the p values of each coefficient
