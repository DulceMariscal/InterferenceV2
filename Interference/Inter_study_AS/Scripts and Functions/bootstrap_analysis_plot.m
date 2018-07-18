%% Plot results of bootstrap analysis

% clc
% close all
% clear all

STORE_FIG=0;
for fileToLoad = 1
    SINGLE_EXP=1;
    FIT_MODEL=SINGLE_EXP;
    INCR_EXP=1;
    %     ppath=['C:\Users\salat\OneDrive\Documents\MATLAB\Research\CoreL\Interference\Interf_study_AS\Intermediate data\'];
    ppath=['C:\Users\dum5\OneDrive\_Shared Drive - Interference Project - Alessandro - Dulce_\Params Files\subjectsData\'];
    
    
    %     allFiles = {'BootstrapData.mat', 'BootstrapData_cross_normalized.mat' };
    %       allFiles={'stepLengthAsymShiftedBootStrapData.mat'};
    %      allFiles = {'stepLengthAsymShiftedBootStrapData.mat'};
    %    allFiles = {'StepLengthAsymBootStrapData'};
    
    %       allFiles = {'stepLengthAsymBootStrapData_WOS9.mat'};
    %           allFiles = {'stepLengthAsymShiftedBootStrapDataW0_S5.mat'};
    %         allFiles={'netContributionPNormV8_{ALLmedian}.mat'}
%     allFiles={'netContributionPNormV8_{ALLmedian}BootStrapDataW_S5.mat'};
%     allFiles={'netContributionPNormAllDataV8_ALLBootStrapDataW_S5.mat'};
allFiles={'netContributionPNormV8_{ALLmedian}BootStrapDataW_S5.mat'};
    %       allFiles= {'stepLengthAsymBootStrapDataW_S5.mat'};
    %       allFiles= {'stepLengthAsymBootStrapDataWO_S5.mat'};
    
    %  allFiles = {'ExtAdaptNorm2BootStrapDataW0_S5.mat'};
    % allFiles = {'ExtAdaptNorm2ShiftedBootStrapDataW0_S5'};
    % allFiles = {'ExtAdaptPNormShiftedBootStrapDataW0_S5'};
    %       allFiles = {'ExtAdaptPNormBootStrapDataW0_S5.mat'};
    
    % fileToLoad = 2; % 1 Original, 2 Cross normalized
    %      allFiles = {'stepLengthAsymBootStrapData_WOS9.mat'};
    cpath=[ppath allFiles{fileToLoad} ];
    % cpath=[ppath 'BootstrapData_cross_normalized.mat' ]; %On cross normalized curves
    
    load(cpath)
    initial_conditions_fit
    SS=15;
    GROUPS={'INT','SAV'};
    CONDS={'A1','A2'};
    margins=[0.07 0.07];
    myColors2=[0.8500    0.3250    0.0980; 0    0.4470    0.7410]; %Interference, Savings
    myStylesFit={'-','--'}; % A1 solid, A2 dashed
    myStylesData={'o','*'};  % A1 circles, A2 squares
    % INTERFERENCE=1;
    % SAAVINGS=2;
    YLIM=[-0.3 0];
    figure
    
    %% SAVINGS
    subplot_tight(1,4,1,margins)
    group=2; cond=1;
    indSS=1:SS:length(sA1m); %indices subsampling
    p1=plot(indSS,sA1m(indSS),[myStylesData{cond}],'Color',myColors2(group,:));
    hold on
    p2=plot(stride_vec_sA1,my_exp(coeffs_sav_1,stride_vec_sA1),myStylesFit{cond},'Color',myColors2(group,:),'lineWidth',3);
    
    
    hold on
    group=2; cond=2;
    indSS=1:SS:length(sA2m); %indices subsampling
    p3=plot(indSS,sA2m(indSS),[myStylesData{cond}],'Color',myColors2(group,:));
    hold on
    p4=plot(stride_vec_sA2,my_exp(coeffs_sav_2,stride_vec_sA2),myStylesFit{cond},'Color',myColors2(group,:),'lineWidth',3);
    
    uistack(p4, 'top')
    l1=legend('Average A1','Fit A1','Average A2','Fit A2');
    yl(1)=ylabel('Step Length Asymmetry');
    xlabel('Strides')
    title('Average across subjects')
    ylim(YLIM);
    %% INTERFERENCE
    subplot_tight(1,4,3,margins)
    group=1; cond=1;
    indSS=1:SS:length(iA1m); %indices subsampling
    p1=plot(indSS,iA1m(indSS),[myStylesData{cond}],'Color',myColors2(group,:));
    hold on
    p2=plot(stride_vec_iA1,my_exp(coeffs_int_1,stride_vec_iA1),myStylesFit{cond},'Color',myColors2(group,:),'lineWidth',3);
    
    
    hold on
    group=1; cond=2;
    indSS=1:SS:length(iA2m); %indices subsampling
    p3=plot(indSS,iA2m(indSS),[myStylesData{cond}],'Color',myColors2(group,:));
    hold on
    p4=plot(stride_vec_iA2,my_exp(coeffs_int_2,stride_vec_iA2),myStylesFit{cond},'Color',myColors2(group,:),'lineWidth',3);
    
    uistack(p4, 'top')
    l1=legend('Average A1','Fit A1','Average A2','Fit A2');
    yl(1)=ylabel('Step Length Asymmetry');
    xlabel('Strides')
    title('Average across subjects')
    ylim(YLIM);
    
    nsim=10000;
    %% BOOTSTRAP SAVINGS
    subplot_tight(1,4,2,margins)
    histogram(pv_sav_bs*100,'Normalization','probability')
    xlabel('Percent variation (tau_{A2}-tau_{A1})*100/tau_{A1} %');
    ylabel(['Frequency (nsim = ' num2str(nsim) ' )' ]);
    % title('Histogram of percent variation')
    title(['Percentiles (5th 50th 95th) = ' num2str(100*ci_pv_s) ' %' ]);
    p_val_pv_sav_bs=sum(pv_sav_bs<0)/nsim;
    
    %% BOOTSTRAP INTERFERENCE
    % Percent variation Interference
    subplot_tight(1,4,4,margins)
    hh=histogram(pv_int_bs*100,'Normalization','probability');
    hh.FaceColor=myColors2(1,:);
    xlabel('Percent variation (tau_{A2}-tau_{A1})*100/tau_{A1} %');
    ylabel(['Frequency (nsim = ' num2str(nsim) ' )' ]);
    % title('Histogram of percent variation')
    title(['Percentiles (5th 50th 95th) = ' num2str(100*ci_pv_i) ' %' ]);
    p_val_pv_int_bs=sum(pv_int_bs<0)/nsim;
    
    %% TEST EQUAL DISTRIBUTION
    % [h,p] = kstest2(pv_sav_bs, pv_sav_bs); %If 1 the two ditributions are different
    [h,p,k] = kstest2(pv_sav_bs, pv_int_bs,'alpha',0.001); %If 1 the two ditributions are different
    figure
    nbins=30;
    histogram(100*pv_int_bs,nbins,'facealpha',.5,'edgecolor','none')
    hold on
    hist(100*pv_sav_bs,nbins,.5,'edgecolor','none')
    % histf(H3,-1.3:.01:1.3,'facecolor',map(3,:),'facealpha',.5,'edgecolor','none')
    box off
    axis tight
    % legalpha('PV Interference','PV Savings','location','northwest')
    legend boxoff
    hold on
    m1 = mean(100*pv_int_bs);
    m2 = mean(100*pv_sav_bs);
    YLIM=ylim();
    hold on
    line([m1 m1],[0 YLIM(2)])
    hold on
    line([m2 m2],[0 YLIM(2)])
    legend(['PV Interference [' num2str(ci_pv_i([1 3])*100) ']' ],...
        ['PV Savings [' num2str(ci_pv_s([1 3])*100) ']' ],...
        ['Mean PV Int [' num2str(ci_pv_i(2)*100) ']'],...
        ['Mean PV Sav [' num2str(ci_pv_s(2)*100) ']']);
    title(['KS test h= ' num2str(h), ';   p-value= ' num2str(p)])
    ylabel(allFiles{1}(1:end-17))
    %% PLOT CURVES - Data
    %     plot_experiment_matrix2(iA1m, iA2m, sA1m, sA2m)
    
    %% PLOT CURVES - Fit
    v = 1:600;
    fit_iA1m = my_exp(coeffs_int_1,v);
    fit_iA2m = my_exp(coeffs_int_2,v);
    fit_sA1m = my_exp(coeffs_sav_1,v);
    fit_sA2m = my_exp(coeffs_sav_2,v);
    plot_experiment_matrix2(iA1m, iA2m, sA1m, sA2m,fit_iA1m, fit_iA2m, fit_sA1m, fit_sA2m,tau_ind);
    
    %% Contrast Original VS Cross Normalized----------------------------------
    %% Constants definitions
    A1=1; A2=2; INT=1; SAV=2; DATA=1; FIT=2;
    set(groot,'defaultLineLineWidth',3)
    set(0,'defaultAxesFontSize',20)
    set(0,'defaultLegendLocation','southeast')
    margins=[0.05 0.05];
    lstyles = {'o','-'}; %Data, fit
    mcolors = distinguishable_colors(2); %Int, sav
    subplotPar = [2 2];
    CLIMS = [-0.3 0; 0 1];
    YLABELS = {'SLA Raw','SLA Cross-Norm'};
    cylim  = CLIMS(fileToLoad,:);
    cylabel  = YLABELS(fileToLoad);
    samplingStride = 7;
    
    % Control stuff
    if fileToLoad==1
        fkeep = figure;
    else
        figure(fkeep)
    end
    indexPlot = 2*(fileToLoad-1) + 1;
    % Plot
    fitCurves = my_fill_ca(fit_iA1m,fit_iA2m,fit_sA1m,fit_sA2m,A1,A2,INT,SAV); % 2X2 groupXcondition
    m_curves  = my_fill_ca(iA1m,iA2m,sA1m,sA2m,A1,A2,INT,SAV);
    tau = [coeffs_int_1(3), coeffs_int_2(3); coeffs_sav_1(3), coeffs_sav_2(3)];
    PV = percent_variation(tau);
    my_plot_curve_and_data(m_curves,fitCurves,tau,PV,indexPlot,cylim,cylabel,... %These change at every iteration
        subplotPar,lstyles,mcolors,SAV,INT,A1,A2,DATA,FIT,samplingStride,margins) %Fixed
    
    
end

%% Save figures
if STORE_FIG
    pathToStore = 'C:\Users\salat\OneDrive\Documents\MATLAB\Individual Meetings Figures\Nov 1\';
    figureName = 'Comparison PV Raw vs Cross-normalized';
    completeName = [pathToStore figureName];
    extensions  = {'-depsc','-dpng'};
    ALSOFIG=1;
    my_print_figures([], fkeep , completeName, extensions, ALSOFIG)
end
