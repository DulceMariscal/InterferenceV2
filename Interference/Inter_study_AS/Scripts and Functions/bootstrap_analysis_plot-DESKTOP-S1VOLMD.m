%% Plot results of bootstrap analysis
%% Note: these curves look different from those in the 20th december report.
%% Here: 
    %1. Individual adaptation curves are normalized between 0 and 1
    %2. The average is taken
    %3. Data and exponential fit are plotted
    
%% 20th December:
    %1 


clc
close all
clear all

STORE_FIG=0;
fh = figure('NumberTitle', 'off', 'Name', [' Histograms Comparison ' ]);
YLIMS = [-0.3 0; 0 1; 0 1; 0 1];
strings = {'Raw', 'Norm' , 'Norm-constrFit' ,'Cross-Norm'};
for ftl = 1:4
    SINGLE_EXP=1;
    FIT_MODEL=SINGLE_EXP;
    INCR_EXP=1;
    ppath=['C:\Users\salat\OneDrive\Documents\MATLAB\Research\CoreL\Interference\Interf_study_AS\Intermediate data\'];
    
    allFiles = {'BootstrapData.mat', 'BootstrapData_normalized.mat', 'BootstrapData_normalized.mat' ,'BootstrapData_cross_normalized.mat' };
    % fileToLoad = 2; % 1 Original, 2 Cross normalized
    cpath=[ppath allFiles{ftl} ];
    % cpath=[ppath 'BootstrapData_cross_normalized.mat' ]; %On cross normalized curves
    
    load(cpath)
    initial_conditions_fit
    SS=15;
    GROUPS={'INT','SAV'};
    CONDS={'A1','A2'};
    margins=[0.07 0.07];
    myColors2=[0.8500    0.3250    0.0980; 0    0.4470    0.7410]; %Interference, Savings
    myStylesFit={'-','--'};  % A1 solid,   A2 dashed
    myStylesData={'o','*'};  % A1 circles, A2 stars
    % INTERFERENCE=1;
    % SAVINGS=2;
    

    
    figure('NumberTitle', 'off', 'Name', [strings{ftl} ' - Curves and Hists' ]);

    
    %% SAVINGS (DATA + FIT)
    % A1
    subplot_tight(1,4,1,margins)
    group=2; cond=1;
    indSS=1:SS:length(sA1m); %indices subsampling
    p1=plot(indSS,sA1m(indSS),[myStylesData{cond}],'Color',myColors2(group,:));
    hold on
    p2=plot(stride_vec_sA1,my_exp(coeffs_sav_1,stride_vec_sA1),myStylesFit{cond},'Color',myColors2(group,:),'lineWidth',3);
    
    % A2
    hold on
    group=2; cond=2;
    indSS=1:SS:length(sA2m); %indices subsampling
    p3=plot(indSS,sA2m(indSS),[myStylesData{cond}],'Color',myColors2(group,:));
    hold on
    p4=plot(stride_vec_sA2,my_exp(coeffs_sav_2,stride_vec_sA2),myStylesFit{cond},'Color',myColors2(group,:),'lineWidth',3);
    
    % Formatting
    uistack(p4, 'top')
%     l1=legend('Average A1','Fit A1','Average A2','Fit A2');
    yl(1)=ylabel('SLA');
    xlabel('Strides')
    title('AVGs')
    ylim(YLIMS(ftl,:));
    
    %% INTERFERENCE (DATA + FIT)
    % A1
    subplot_tight(1,4,3,margins)
    group=1; cond=1;
    indSS=1:SS:length(iA1m); %indices subsampling
    p1=plot(indSS,iA1m(indSS),[myStylesData{cond}],'Color',myColors2(group,:));
    hold on
    p2=plot(stride_vec_iA1,my_exp(coeffs_int_1,stride_vec_iA1),myStylesFit{cond},'Color',myColors2(group,:),'lineWidth',3);
    
    % A2
    hold on
    group=1; cond=2;
    indSS=1:SS:length(iA2m); %indices subsampling
    p3=plot(indSS,iA2m(indSS),[myStylesData{cond}],'Color',myColors2(group,:));
    hold on
    p4=plot(stride_vec_iA2,my_exp(coeffs_int_2,stride_vec_iA2),myStylesFit{cond},'Color',myColors2(group,:),'lineWidth',3);
    
    uistack(p4, 'top')
%     l1=legend('Average A1','Fit A1','Average A2','Fit A2');
    yl(1)=ylabel('SLA');
    xlabel('Strides')
    title('AVGs')
    ylim(YLIMS(ftl,:));
    
    nsim=10000;
    %% SAVINGS (HISTOGRAM)
    subplot_tight(1,4,2,margins)
    histogram(pv_sav_bs*100,'Normalization','probability')
    xlabel('PV');
    ylabel(['Frequency (nsim = ' num2str(nsim) ' )' ]);
    % title('Histogram of percent variation')
    title(['Perc (5th 50th 95th) = ' num2str(100*ci_pv_s,'%.2f') ' %' ]);
    p_val_pv_sav_bs=sum(pv_sav_bs<0)/nsim;
    
    %% INTERFERENCE (HISTOGRAM)
    % Percent variation Interference
    subplot_tight(1,4,4,margins)
    hh=histogram(pv_int_bs*100,'Normalization','probability');
    hh.FaceColor=myColors2(1,:);
    xlabel('PV');
    ylabel(['Frequency (nsim = ' num2str(nsim) ' )' ]);
    % title('Histogram of percent variation')
    title(['Perc (5th 50th 95th) = ' num2str(100*ci_pv_i,'%.2f') ' %' ]);
    p_val_pv_int_bs = sum(pv_int_bs<0)/nsim;
    
    %% TEST EQUAL DISTRIBUTIONS
    % [h,p] = kstest2(pv_sav_bs, pv_sav_bs); %If 1 the two ditributions are different
    [h,p,k] = kstest2(pv_sav_bs, pv_int_bs,'alpha',0.0001); %If 1 the two ditributions are different
    
    
    %% OVERLAPPING HISTOGRAMS
    if ftl
    figure(fh)
    nbins=30;
    subplot(1,3,ftl)
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
    xlabel('Percent \tau variation')
    ylabel('Absolute Frequency (nsim = 10000)')
    title(strings{ftl})
    
    %% PLOT CURVES - Data
%     plot_experiment_matrix(iA1m, iA2m, sA1m, sA2m, YLABELS{ftl})
    
    %% PLOT CURVES - Fit
    v = 1:600;
    if ftl ~=3
        fit_iA1m = my_exp(coeffs_int_1,v);
        fit_iA2m = my_exp(coeffs_int_2,v);
        fit_sA1m = my_exp(coeffs_sav_1,v);
        fit_sA2m = my_exp(coeffs_sav_2,v);
        tau = [coeffs_int_1(3), coeffs_int_2(3); coeffs_sav_1(3), coeffs_sav_2(3)]; %COND x GROUP
    else
        [fit_sA1m,~,~,~,~,coeffs_sav_1]  = my_smoothing2(sA1m, '1_EXP_CONSTR');
        [fit_sA2m,~,~,~,~,coeffs_sav_2]  = my_smoothing2(sA2m, '1_EXP_CONSTR');
        [fit_iA1m,~,~,~,~,coeffs_int_1]  = my_smoothing2(iA1m, '1_EXP_CONSTR');
        [fit_iA2m,~,~,~,~,coeffs_int_2]  = my_smoothing2(iA2m, '1_EXP_CONSTR');
        tau = [coeffs_int_1(2), coeffs_int_2(2); coeffs_sav_1(2), coeffs_sav_2(2)]; %COND x GROUP
    end
%     plot_experiment_matrix(fit_iA1m, fit_iA2m, fit_sA1m, fit_sA2m,YLABELS{ftl});

    PV = percent_variation(tau);
    
    %% PLOT DATA AND FITS
    plot_experiment_matrix2(iA1m, iA2m, sA1m, sA2m, fit_iA1m, fit_iA2m, fit_sA1m, fit_sA2m, strings{ftl}, tau, PV)
    
%     %% Contrast Original VS Cross Normalized----------------------------------
%     %% Constants definitions
%     A1=1; A2=2; INT=1; SAV=2; DATA=1; FIT=2;
%     set(0,'defaultLegendLocation','southeast')
%     my_set_default(20,3,10)
%     margins=[0.05 0.05];
%     lstyles = {'o','-'}; %Data, fit
%     mcolors = distinguishable_colors(2); %Int, sav
%     subplotPar = [2 2];
%     CLIMS = [-0.3 0; 0 1; 0 1];
%     cylim  = CLIMS(ftl,:);
%     cylabel  = YLABELS(ftl);
%     samplingStride = 7;
%     
%     % Control stuff
%     if ftl==1
%         fkeep = figure;
%     else
%         figure(fkeep)
%     end
%     indexPlot = 2*(ftl-1) + 1;
%     % Plot
%     fitCurves = my_fill_ca(fit_iA1m,fit_iA2m,fit_sA1m,fit_sA2m,A1,A2,INT,SAV); % 2X2 groupXcondition
%     m_curves  = my_fill_ca(iA1m,iA2m,sA1m,sA2m,A1,A2,INT,SAV);
%     tau = [coeffs_int_1(3), coeffs_int_2(3); coeffs_sav_1(3), coeffs_sav_2(3)];
%     PV = percent_variation(tau);
%     my_plot_curve_and_data(m_curves,fitCurves,tau,PV,indexPlot,cylim,cylabel,... %These change at every iteration
%         subplotPar,lstyles,mcolors,SAV,INT,A1,A2,DATA,FIT,samplingStride,margins) %Fixed
    
    
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
