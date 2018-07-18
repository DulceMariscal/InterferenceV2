%% ANALYSES BASED ON AVERAGE ACROSS SUBJECTS DATA---------------------------------------------------------------------------
% FIT AVERAGE ADAPTATION 2 CURVES AND PLOT WITH TIME CONSTANT-------------
clc
close all 
clear all


% load('netContributionPNormV9_median.mat')
load('netContributionPNormAllDataV9.mat')
% load('netContributionPNormAllDataV8_ALL.mat')

% load('netContributionPNormV8_ALLmedian.mat')
gait_par='netContributionPNormV9';
slaI=netContributionPNormINT;
slaS=netContributionPNormSAV;
% gait_par='netContributionPNormV8_{ALLmedian}';
% gait_par='netContributionPNormV9_{median}';

% % load('StridesToRemovenetContributionPNormAllDataV7.mat')
% % load('StridesToRemove.mat')


minNOSToRemove=ones(13,2);

% 
% load('ExtAdaptPNormAllDataV8_ALLmedian.mat')
% gait_par='ExtAdaptPNormAllDataV8_{ALLmedian}';

% load('ExtAdaptPNormV9_median.mat')
% gait_par='ExtAdaptPNormV9_{median}';

% load('ExtAdaptPNormAllDataV9.mat')
% gait_par='ExtAdaptPNormAllDataV9';
% % 
% slaI=ExtAdaptINT;
% slaS=ExtAdaptSAV;
% % load('StridesToRemovenetContributionPNormAllDataV6.mat')
% % param={'ExtAdaptPNormV8_ALL{median}'};

% load('spatialContributionPNormAllDataV8.mat')
% % load('StridesToRemovenetContributionPNormAllDataV7.mat')
% param={'spatialContributionPNormAllDataV8'};
% slaI=spatialContributionPNormINT;
% slaS=spatialContributionPNormSAV;
% gait_par='spatialContributionPNormAllDataV8';

% load('NoRemovingAnyStridesV7.mat')
% 

%
% % % load('stepLengthAsymAllData.mat')
% % % slaI=stepLengthAsymINT;
% % % slaS=stepLengthAsymSAV;

% load('SalatielloAllData.mat')

%for ExtAdaptaiton= SLA-SV
% load('ExtAdaptNorm2AllData.mat') 
% load('StridesToRemoveExtAdaptNorm2.mat')
% gait_par='ExtAdaptNorm2';
% slaI=ExtAdaptINT;
% slaS=ExtAdaptSAV;

%No hip 
% load('ExtAdaptPNormAllData.mat') 
% load('StridesToRemoveExtAdaptPNorm.mat')
% gait_par='ExtAdaptPNorm';
% slaI=ExtAdaptINT;
% slaS=ExtAdaptSAV;

%Shifted Data SLA 
%  load('stepLengthAsymShifted.mat')
% load('StridesToRemovestepLengthAsymShifted.mat')
% % param={'stepLengthAsymShifted'}; 
% gait_par='stepLengthAsymShifted';

%Shifted Data Ext Adapt Norm2 
% load('ExtAdaptNorm2Shifted.mat')
% load('StridesToRemoveExtAdaptNorm2.mat')
% gait_par='ExtAdaptNorm2Shifted';

% Shifted Data Ext Adapt PNorm
% load('ExtAdaptPNormShifted.mat')
% load('StridesToRemoveExtAdaptPNorm.mat')
% gait_par='ExtAdaptPNormShifted';



BOOTSTRAP=0;
% load('C:\Users\salat\OneDrive\Documents\MATLAB\MatlabFunctionExchangeApril6\Interf_study_AS\Intermediate data\PROCESSED_DATA_v1.mat')
%load('C:\Users\salat\OneDrive\Documents\MATLAB\Research\CoreL\Interference\Interf_study_AS\Intermediate data\PROCESSED_DATA_cross_normalized.mat')
charGroups = {'S','I'};
indSubs = {setdiff(1:11, []), setdiff(1:10, [])};
% indSubs = {setdiff(1:9, [9]), setdiff(1:8, [])};
nos =[length(indSubs{1}) , length(indSubs{2})];

% nos=[9 8];
cond_Inter=[2,5];
cond_Sav=[2,4];
for sub=1:nos(2)
   i=indSubs{2}(sub);
% i=sub;
%     data_A1_Inter=slaI{i,cond_Inter(1)}; 
    if sub==7
        
        data_A1_Inter=nan(1000,1); 
    else
        data_A1_Inter=slaI{i,cond_Inter(1)};
        if sub==1
        data_A1_Inter= [data_A1_Inter; nan(150,1)] ;
        end
    end
   INTERFERENCE_DATA{1,sub}=data_A1_Inter(minNOSToRemove(i,1):end,1);
   
   data_A2_Inter=slaI{i,cond_Inter(2)};
   INTERFERENCE_DATA{2,sub}=data_A2_Inter(minNOSToRemove(i,1):end,1);    
end 

for sub=1:nos(1)
   s=indSubs{1}(sub);
% s=sub;
   data_A1_Sav=slaS{s,cond_Sav(1)}; 
   SAVINGS_DATA{1,sub}=data_A1_Sav(minNOSToRemove(s,2):end,1);
   
   data_A2_Sav=slaS{s,cond_Sav(2)};
   SAVINGS_DATA{2,sub}=data_A2_Sav(minNOSToRemove(s,2):end,1);  
    
end


INCR_EXP=1;
SINGLE_EXP=1;
DOUBLE_EXP=2;
FIT_MODEL=2;
npar_fit=5;
initial_conditions_fit
INTERFERENCE=1;
SAVINGS=2;

% Adaptation 1-------------------------------------------------------------
[iA1m, iA1std] = average_curves(INTERFERENCE_DATA(1,:)); %avg_adapt_curve_int [iA1m,iA2std]
[sA1m, sA1std] = average_curves(SAVINGS_DATA(1,:)); %avg_adapt_curve_sav [sA1m,sA2std]
% iA1m=iA1m';
iA1m(:,any(isnan(iA1m),1)) = [];
iA1std(:,any(isnan(iA1std),1)) = [];
sA1m(:, any(isnan(sA1m), 1)) = [];
sA1std(:,any(isnan(sA1std),1)) = [];
stride_vec_iA1=1:length(iA1m);
stride_vec_sA1=1:length(sA1m);
my_exp=my_double_exp;

%2.Fit exponential
% [coeffs, dataFit, resid, J]= my_exp_fit2(iA1m,{'Increasing'},{'Double'})
[coeffs_int_1,a,resid,b,c,d,J]= lsqcurvefit(my_exp,x0,stride_vec_iA1,iA1m,lb,ub);
% [coeffs_int_1,~,resid,~,~,~,J]= lsqcurvefit(my_exp,x0,stride_vec_iA1,iA1m);
ci_i1 = nlparci(coeffs_int_1,resid,'jacobian',J);
[coeffs_sav_1,~,resid,~,~,~,J] = lsqcurvefit(my_exp,x0,stride_vec_sA1,sA1m,lb,ub);
% [coeffs_sav_1,~,resid,~,~,~,J] = lsqcurvefit(my_exp,x0,stride_vec_sA1,sA1m);
ci_s1 = nlparci(coeffs_sav_1,resid,'jacobian',J);

% Adaptation 2-------------------------------------------------------------
%1.Compute averages curves with nsamples=min(nsamples_curves)
[iA2m, iA2std] = average_curves(INTERFERENCE_DATA(2,:));
[sA2m, sA2std] = average_curves(SAVINGS_DATA(2,:));

iA2m(:,any(isnan(iA2m),1)) = [];
iA2std(:,any(isnan(iA2std),1)) = [];
sA2m(:,any(isnan(sA2m), 1)) = [];
sA2std(:,any(isnan(sA2std),1)) = [];

stride_vec_iA2=1:length(iA2m);
stride_vec_sA2=1:length(sA2m);





%2.Fit exponential
[coeffs_int_2,~,resid,~,~,~,J] = lsqcurvefit(my_exp,x0,stride_vec_iA2,iA2m,lb,ub);
% [coeffs_int_2,~,resid,~,~,~,J] = lsqcurvefit(my_exp,x0,stride_vec_iA2,iA2m);
ci_i2 = nlparci(coeffs_int_2,resid,'jacobian',J);
[coeffs_sav_2,~,resid,~,~,~,J] = lsqcurvefit(my_exp,x0,stride_vec_sA2,sA2m,lb,ub);
% [coeffs_sav_2,~,resid,~,~,~,J] = lsqcurvefit(my_exp,x0,stride_vec_sA2,sA2m);
ci_s2 = nlparci(coeffs_sav_2,resid,'jacobian',J);


%% PLOT DATA
margins=[0.07, 0.07];
%3.Plot data and fit
f1=figure;
[~,tau_index_sav_1]=max(coeffs_sav_1);
[~,tau_index_sav_2]=max(coeffs_sav_2);
[~,tau_index_int_1]=max(coeffs_int_1);
[~,tau_index_int_2]=max(coeffs_int_2);

subplot_tight(5,2,[1 3],margins)
% subplot_tight(2,2,[1 3],margins)
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
legend('A1_{data}',['A1_{fit} [tau = ' num2str(coeffs_sav_1(tau_index_sav_1)) ' ( ' num2str(ci_s1(tau_index_sav_1,:))  ' ) ] '],'A_2{data}',['A2_{fit} [tau = ' num2str(coeffs_sav_2(tau_index_sav_2)) ' ( ' num2str(ci_s2(tau_index_sav_2,:))  ' ) ]']);
grid on
pv_sav=(coeffs_sav_2(tau_index_sav_2)-coeffs_sav_1(tau_index_sav_1))/coeffs_sav_1(tau_index_sav_1);
title(['Savings group. Average curves. Percent variation = ' num2str(pv_sav*100) '%']);


subplot_tight(5,2,[2 4],margins)
% subplot_tight(2,2,[2 4],margins)
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
legend('A1_{data}',['A1_{fit} [tau = ' num2str(coeffs_int_1(tau_index_int_1)) ' ( ' num2str(ci_i1(tau_index_int_1,:))  ' ) ]'],'A_2{data}',['A2_{fit} [tau = ' num2str(coeffs_int_2(tau_index_int_2)) ' ( ' num2str(ci_i2(tau_index_int_2,:))  ' ) ]']);
pv_int=(coeffs_int_2(tau_index_int_2)-coeffs_int_1(tau_index_int_1))/coeffs_int_1(tau_index_int_1);
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
        iA1_coeff(sim,:) = lsqcurvefit(my_exp,x0,stride_vec_iA1,iA1_data_m);
%         iA1_coeff(sim,:) = lsqcurvefit(my_exp,x0,stride_vec_iA1,iA1_data_m,lb,ub);
        
        %Generate Interference subjects A2
        iA2_data = repmat(iA2m,nos(INTERFERENCE),1) + repmat(iA2std,nos(INTERFERENCE),1).*randn(nos(INTERFERENCE),ns_iA2);
        iA2_data_m = mean(iA2_data,1);
        iA2_coeff(sim,:) = lsqcurvefit(my_exp,x0,stride_vec_iA2,iA2_data_m);
%         iA2_coeff(sim,:) = lsqcurvefit(my_exp,x0,stride_vec_iA2,iA2_data_m,lb,ub);
        
        %Generate Savings subjects A1
        sA1_data = repmat(sA1m,nos(SAVINGS),1) + repmat(sA1std,nos(SAVINGS),1).*randn(nos(SAVINGS),ns_sA1);
        sA1_data_m = mean(sA1_data,1);
        sA1_coeff(sim,:) = lsqcurvefit(my_exp,x0,stride_vec_sA1,sA1_data_m);
%         sA1_coeff(sim,:) = lsqcurvefit(my_exp,x0,stride_vec_sA1,sA1_data_m,lb,ub);
        
        
        %Generate Savings sunjects A2
        sA2_data = repmat(sA2m,nos(SAVINGS),1) + repmat(sA2std,nos(SAVINGS),1).*randn(nos(SAVINGS),ns_sA2);
        sA2_data_m = mean(sA2_data,1);
        sA2_coeff(sim,:) = lsqcurvefit(my_exp,x0,stride_vec_sA2,sA2_data_m);
%         sA2_coeff(sim,:) = lsqcurvefit(my_exp,x0,stride_vec_sA2,sA2_data_m,lb,ub);
        
    end
    % figure, plot(iA1_data_m,'o'), hold on, plot(stride_vec_iA1,my_exp(iA1_coeff(end,:),stride_vec_iA1),'g','lineWidth',3)
    
    %% Plot distribution and compute confidence intervals---------------------
    f2=figure;
    tau_ind=5;
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
    xlabel('Percent variation (tauA2_Int-tauA2_Sav)');
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
 save([gait_par 'BootStrapDataW_S5'],'ci_pv_i','ci_pv_s','coeffs_int_1','coeffs_int_2','coeffs_sav_1','coeffs_sav_2','iA1m','iA2m','pv_int','pv_int_bs','sA1m','sA2m','stride_vec_iA1','stride_vec_iA2','stride_vec_sA1','stride_vec_sA1','stride_vec_sA2','tau_ind','pv_sav_bs','INTERFERENCE_DATA','SAVINGS_DATA')
   
end

