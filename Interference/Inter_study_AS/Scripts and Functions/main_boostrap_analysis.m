%% ANALYSES BASED ON AVERAGE ACROSS SUBJECTS DATA---------------------------------------------------------------------------
%% FIT AVERAGE ADAPTATION 2 CURVES AND PLOT WITH TIME CONSTANT-------------
clc
close all 
clear all

BOOTSTRAP=1;
INTERFERENCE=1; SAVINGS=2;

%% Load raw data
% load('C:\Users\salat\OneDrive\Documents\MATLAB\MatlabFunctionExchangeApril6\Interf_study_AS\Intermediate data\PROCESSED_DATA_v1.mat')

%% Load cross-normalized data
% load('C:\Users\salat\OneDrive\Documents\MATLAB\Research\CoreL\Interference\Interf_study_AS\Intermediate data\PROCESSED_DATA_cross_normalized.mat')

%% Load normalized data
loadPath = 'C:\Users\salat\OneDrive\Documents\MATLAB\Research\CoreL\Interference\Interf_study_AS\SaveDataForStata\Stata - Rate Measures\';
load([loadPath 'SLA_smoothed_all_kinds.mat' ]);
INTERFERENCE_DATA = squeeze(all_curves_norm(INTERFERENCE,:,:))';
SAVINGS_DATA = squeeze(all_curves_norm(SAVINGS,:,:))';

%% Start main processing
gait_par='StepLengthAsym';
INCR_EXP=1;
SINGLE_EXP=1;
FIT_MODEL=SINGLE_EXP;
npar_fit=3;
initial_conditions_fit
nos=[8 8];
% Adaptation 1-------------------------------------------------------------
[iA1m, iA1std] = average_curves(INTERFERENCE_DATA(1,:)); %avg_adapt_curve_int [iA1m,iA2std]
[sA1m, sA1std] = average_curves(SAVINGS_DATA(1,:)); %avg_adapt_curve_sav [sA1m,sA2std]
stride_vec_iA1=1:length(iA1m);
stride_vec_sA1=1:length(sA1m);

%2.Fit exponential
[coeffs_int_1,~,resid,~,~,~,J]= lsqcurvefit(my_exp,x0,stride_vec_iA1,iA1m,lb,ub);
ci_i1 = nlparci(coeffs_int_1,resid,'jacobian',J);
[coeffs_sav_1,~,resid,~,~,~,J] = lsqcurvefit(my_exp,x0,stride_vec_sA1,sA1m,lb,ub);
ci_s1 = nlparci(coeffs_sav_1,resid,'jacobian',J);

% Adaptation 2-------------------------------------------------------------
%1.Compute averages curves with nsamples=min(nsamples_curves)
[iA2m, iA2std] = average_curves(INTERFERENCE_DATA(2,:));
[sA2m, sA2std] = average_curves(SAVINGS_DATA(2,:));
stride_vec_iA2=1:length(iA2m);
stride_vec_sA2=1:length(sA2m);

%2.Fit exponential
[coeffs_int_2,~,resid,~,~,~,J] = lsqcurvefit(my_exp,x0,stride_vec_iA2,iA2m,lb,ub);
ci_i2 = nlparci(coeffs_int_2,resid,'jacobian',J);
[coeffs_sav_2,~,resid,~,~,~,J] = lsqcurvefit(my_exp,x0,stride_vec_sA2,sA2m,lb,ub);
ci_s2 = nlparci(coeffs_sav_2,resid,'jacobian',J);


%% PLOT DATA
margins=[0.07, 0.07];
%3.Plot data and fit
f1=figure;

subplot_tight(5,2,[1 3],margins)
%Savings A1
plot(stride_vec_sA1,sA1m, 'bo')
hold on
plot(stride_vec_sA1,my_exp(coeffs_sav_1,stride_vec_sA1),'g','lineWidth',3)
%Savings A2
plot(stride_vec_sA2,sA2m, 'ro')
hold on
plot(stride_vec_sA2,my_exp(coeffs_sav_2,stride_vec_sA2),'k','lineWidth',3)
hold on
xlabel('Strides');
ylabel(gait_par);
legend('A1_{data}',['A1_{fit} [tau = ' num2str(coeffs_sav_1(3)) ' ( ' num2str(ci_s1(3,:))  ' ) ] '],'A_2{data}',['A2_{fit} [tau = ' num2str(coeffs_sav_2(3)) ' ( ' num2str(ci_s2(3,:))  ' ) ]']);
grid on
pv_sav=(coeffs_sav_2(3)-coeffs_sav_1(3))/coeffs_sav_1(3);
title(['Savings group. Average curves. Percent variation = ' num2str(pv_sav*100) '%']);


subplot_tight(5,2,[2 4],margins)
%Interference 1
plot(stride_vec_iA1,iA1m, 'bo')
hold on
plot(stride_vec_iA1,my_exp(coeffs_int_1,stride_vec_iA1),'g','lineWidth',3)
grid on
%Interference 2
hold on
plot(stride_vec_iA2,iA2m, 'ro')
hold on
plot(stride_vec_iA2,my_exp(coeffs_int_2,stride_vec_iA2),'k','lineWidth',3)
grid on

xlabel('Strides');
ylabel(gait_par);
legend('A1_{data}',['A1_{fit} [tau = ' num2str(coeffs_int_1(3)) ' ( ' num2str(ci_i1(3,:))  ' ) ]'],'A_2{data}',['A2_{fit} [tau = ' num2str(coeffs_int_2(3)) ' ( ' num2str(ci_i2(3,:))  ' ) ]']);
pv_int=(coeffs_int_2(3)-coeffs_int_1(3))/coeffs_int_1(3);
title(['Interference group. Average curves. Percent variation = ' num2str(pv_int*100) '%'] );

%% BOOTSRAP TO ESTIMATE CONFIDENCE INTERVALS PARAMETERS FITTING-----------
if BOOTSTRAP
    %Number of simulations
    nsim = 10000;
    
    %Number of strides
    ns_iA1=length(iA1m);
    ns_iA2=length(iA2m);
    ns_sA1=length(sA1m);
    ns_sA2=length(sA2m);
    
    %Structure to store data
    iA1_coeff=zeros(nsim,npar_fit);
    iA2_coeff=zeros(nsim,npar_fit);
    sA1_coeff=zeros(nsim,npar_fit);
    sA2_coeff=zeros(nsim,npar_fit);
    
    for sim=1:nsim
        %Generate and fit Interference subjects A1
        iA1_data = repmat(iA1m,nos(INTERFERENCE),1) + repmat(iA1std,nos(INTERFERENCE),1).*randn(nos(INTERFERENCE),ns_iA1);
        iA1_data_m = mean(iA1_data,1);
        iA1_coeff(sim,:) = lsqcurvefit(my_exp,x0,stride_vec_iA1,iA1_data_m,lb,ub);
        
        %Generate Interference subjects A2
        iA2_data = repmat(iA2m,nos(INTERFERENCE),1) + repmat(iA2std,nos(INTERFERENCE),1).*randn(nos(INTERFERENCE),ns_iA2);
        iA2_data_m = mean(iA2_data,1);
        iA2_coeff(sim,:) = lsqcurvefit(my_exp,x0,stride_vec_iA2,iA2_data_m,lb,ub);
        
        %Generate Savings subjects A1
        sA1_data = repmat(sA1m,nos(SAVINGS),1) + repmat(sA1std,nos(SAVINGS),1).*randn(nos(SAVINGS),ns_sA1);
        sA1_data_m = mean(sA1_data,1);
        sA1_coeff(sim,:) = lsqcurvefit(my_exp,x0,stride_vec_sA1,sA1_data_m,lb,ub);
        
        
        %Generate Savings sunjects A2
        sA2_data = repmat(sA2m,nos(SAVINGS),1) + repmat(sA2std,nos(SAVINGS),1).*randn(nos(SAVINGS),ns_sA2);
        sA2_data_m = mean(sA2_data,1);
        sA2_coeff(sim,:) = lsqcurvefit(my_exp,x0,stride_vec_sA2,sA2_data_m,lb,ub);
        
    end
    % figure, plot(iA1_data_m,'o'), hold on, plot(stride_vec_iA1,my_exp(iA1_coeff(end,:),stride_vec_iA1),'g','lineWidth',3)
    
    %% Plot distribution and compute confidence intervals---------------------
    f2=figure;
    tau_ind=3;
    percentiles=[5 50 95];
    
    % iA1
    figure(f1)
    subplot_tight(5,2,6,margins)
    ci_iA1 = prctile(iA1_coeff(:,tau_ind), percentiles);
    histogram(iA1_coeff(:,tau_ind),'Normalization','probability')
    xlabel('tau_{A1}');
    ylabel(['Frequency (nsim = ' num2str(nsim) ' )' ]);
    title(['Percentiles (5th 50th 95th) = ' num2str(ci_iA1) ]);
    
    % iA2
    subplot_tight(5,2,8,margins)
    ci_iA2 = prctile(iA2_coeff(:,tau_ind), percentiles);
    histogram(iA2_coeff(:,tau_ind),'Normalization','probability')
    xlabel('tau_{A2}');
    ylabel(['Frequency (nsim = ' num2str(nsim) ' )' ]);
    title(['Percentiles (5th 50th 95th) = ' num2str(ci_iA2) ]);
    
    % Percent variation Interference
    subplot_tight(5,2,10,margins)
    pv_int_bs=(iA2_coeff(:,tau_ind)-iA1_coeff(:,tau_ind))./iA1_coeff(:,tau_ind);
    ci_pv_i = prctile(pv_int_bs, percentiles);
    histogram(pv_int_bs*100,'Normalization','probability')
    xlabel('Percent variation (tauA2-tauA1)*100/tauA1 %');
    ylabel(['Frequency (nsim = ' num2str(nsim) ' )' ]);
    title(['Percentiles (5th 50th 95th) = ' num2str(100*ci_pv_i) ' %' ]);
    p_val_pv_int_bs=sum(pv_int_bs<0)/nsim;
    
    % sA1
    subplot_tight(5,2,5,margins)
    ci_sA1 = prctile(sA1_coeff(:,tau_ind), percentiles);
    histogram(sA1_coeff(:,tau_ind),'Normalization','probability')
    xlabel('tau_{A1}');
    ylabel(['Frequency (nsim = ' num2str(nsim) ' )' ]);
    title(['Percentiles (5th 50th 95th) = ' num2str(ci_sA1) ]);
    
    % sA2
    subplot_tight(5,2,7,margins)
    ci_sA2 = prctile(sA2_coeff(:,tau_ind), percentiles);
    histogram(sA2_coeff(:,tau_ind),'Normalization','probability')
    xlabel('tau_{A2}');
    ylabel(['Frequency (nsim = ' num2str(nsim) ' )' ]);
    title(['Percentiles (5th 50th 95th) = ' num2str(ci_sA2) ]);
    
    
    % Percent variation Interference
    subplot_tight(5,2,9,margins)
    pv_sav_bs=(sA2_coeff(:,tau_ind)-sA1_coeff(:,tau_ind))./sA1_coeff(:,tau_ind);
    ci_pv_s = prctile(pv_sav_bs, percentiles);
    histogram(pv_sav_bs*100,'Normalization','probability')
    xlabel('Percent variation (tauA2-tauA1)*100/tauA1 %');
    ylabel(['Frequency (nsim = ' num2str(nsim) ' )' ]);
    title(['Percentiles (5th 50th 95th) = ' num2str(100*ci_pv_s) ' %' ]);
    
    % Difference in A1
    figure(f2);
    subplot(1,3,1)
    A1diff=iA1_coeff(:,tau_ind)-sA1_coeff(:,tau_ind);
    ci_A1diff = prctile(A1diff, percentiles);
    histogram(A1diff,'Normalization','probability')
    xlabel('Percent variation (tauA1_Int-tauA1_Sav)');
    ylabel(['Frequency (nsim = ' num2str(nsim) ' )' ]);
    title(['Percentiles (5th 50th 95th) = ' num2str(ci_A1diff) ' %' ]);
    

    % Differencein A2
    subplot(1,3,2)
    A2diff=iA2_coeff(:,tau_ind)-sA2_coeff(:,tau_ind);
    ci_A2diff = prctile(A2diff, percentiles);
    histogram(A2diff,'Normalization','probability')
    xlabel('Percent variation (tauA1_Int-tauA1_Sav)');
    ylabel(['Frequency (nsim = ' num2str(nsim) ' )' ]);
    title(['Percentiles (5th 50th 95th) = ' num2str(ci_A2diff) ' %' ]);
    
    % Difference in percent variation
    subplot(1,3,3)
    PVdiff=pv_int_bs-pv_sav_bs;
    ci_PVdiff = prctile(PVdiff, percentiles);
    histogram(PVdiff*100,'Normalization','probability')
    xlabel('Percent variation (tauA1_Int-tauA1_Sav)*100');
    ylabel(['Frequency (nsim = ' num2str(nsim) ' )' ]);
    title(['Percentiles (5th 50th 95th) = ' num2str(100*ci_PVdiff) ' %' ]);
    
end

