%% Visualize normalized curve and number of strides for each subject
my_set_default(20,3,20)

clc
close all
clear all

%% What to do with the script
PLOT_NC = 0;
RAW_DATA = 1; FIT_DATA = 2; HY_DATA=3; HY_DATA_CROP=4;
fh = figure;

%% Initializations
exp_values = zeros(2,8,2,2);  % [ng, ns, nc, nvalues], nvalues = initial + final
NPR = 1;

for SEL_DATA = 1:NPR
    
    %% Load data
%     loadPath = 'C:\Users\salat\OneDrive\Documents\MATLAB\Research\CoreL\Interference\Interf_study_AS\SaveDataForStata\Stata - Rate Measures\';
%     load([loadPath 'SLA_smoothed_all_kinds.mat' ]);
%     load([loadPath 'defCols.mat']);
    load( 'SLA_smoothed_all_kinds.mat');
    load(['defCols.mat']);
    if SEL_DATA == FIT_DATA
        all_ncurves = all_curves_after_smoothing(:,:,:,1); %Exponential fits
    elseif SEL_DATA == RAW_DATA
        all_ncurves = all_curves; % Raw data
    elseif SEL_DATA == HY_DATA || SEL_DATA == HY_DATA_CROP
        all_ncurves = all_curves; % Raw data.  Will be normalized using exp fits as initial and final values
    end
    
    [ng, ns, nc] = size(all_ncurves);
    
    %% Initializations
    NSTRIDES = zeros(ng,ns,nc);
    A1=1; A2=2; INT=1; SAV=2;
    
    
    %% Main analysis
    margins=[0.05 0.03];
    cols = [0.25 0.25 0.25; 0.75 0.75 0.75];
    myGroupColors = [0.8500    0.3250    0.0980; 0    0.4470    0.7410]; %Interference, Savings
    
    
    % Crop curves
    all_ncurves = crop_curves(all_ncurves);
    nmin = size(all_ncurves,4); x=1:nmin; zx=zeros(1,nmin);
    NORM_CURVES = zeros(ng,ns,nc,nmin);
    NORM_CURVES_ALL = []; %zeros(ng,ns,nc,nmin,NPR);
    DIFF_CURVES = zeros(ng,ns,nmin);
    DIFF_AREAS = zeros(ng, ns);
    figure
    for gr=1:ng
        for sub=1:ns
            for cond=1:nc
                
                ccurve = squeeze(all_ncurves(gr,sub,cond,:))';  %Extracted curve
                if SEL_DATA == HY_DATA || SEL_DATA == HY_DATA_CROP
                    ncurve = normalize_curve(ccurve,PLOT_NC, exp_values(gr,sub,cond,1),exp_values(gr,sub,cond,end));       %Normalized curve using exponential fit values
                else
                    ncurve = normalize_curve(ccurve,PLOT_NC);       %Normalized curve
                end
                
                if SEL_DATA == HY_DATA_CROP %Se to nan values below 0 and above 1
                    iabove0 = ncurve >= 0; ibelow1 = ncurve <= 1; iok = iabove0 & ibelow1; 
                    ncurve(~iok) = nan;
                end
                
                nstrides = compute_nstmp(ncurve);
                
                %Store
                NSTRIDES(gr,sub,cond) = nstrides;
                NORM_CURVES(gr,sub,cond,:) = ncurve;
                
                %Store initial and final value of exponential fit
                if SEL_DATA == FIT_DATA
                    exp_values(gr,sub,cond,:) = [ccurve(1); ccurve(end)] ;
                end
            end
            %Compute and store diff
            cdiff = squeeze(NORM_CURVES(gr,sub,A2,:) - NORM_CURVES(gr,sub,A1,:));
            DIFF_CURVES(gr,sub,:) = cdiff;
            DIFF_AREAS(gr,sub) = mean(cdiff);
            
            %Plot------------------------
            subplot_tight(ng, ns, sub + (gr-1)*ns,margins)
            if cdiff(2) < 0 %Slower
                ccol = cols(1,:);
                y2 = zx;
                y1 = cdiff';
            else
                ccol = cols(2,:);
                y1 = zx;
                y2 = cdiff';
            end
            
            plot(squeeze(DIFF_CURVES(gr,sub,:)));
            hold on
            my_fill(x,y1,y2,ccol,0,0)
            xlim([0 length(ccurve)]);
        end
    end
    
    %% Compute averages
    avgDiffs = squeeze(nanmean(DIFF_CURVES,2));
    seDiffs  =  squeeze(nanstd(DIFF_CURVES,0,2)./sqrt(ns));
    mnc = squeeze(nanmean(NORM_CURVES,2)); %Average across subjects
    
    figure(fh);
    
    % SAV (Average of normalized curves)
    subplot(NPR,3,(SEL_DATA - 1)*3 + 1)
    
    
    plot(squeeze(mnc(SAV,A1,:)),'-','Color',defCols(1,:));
    hold on
    plot(squeeze(mnc(SAV,A2,:)),'-.','Color',defCols(6,:));

    if SEL_DATA==HY_DATA
        axis tight
    else
        ylim([0 1])
    end
    xlim([1 nmin]);
    
    switch SEL_DATA
        case 1
            title('SAVINGS')
            ylabel('Data')
            legend('A1','A2')
        case 2
            ylabel('Fit')
        case 3
            ylabel('Hyb-Norm')
        case 4
            ylabel('Hyb-Norm-Crop')
    end
    
    % INT means
    subplot(NPR,3,(SEL_DATA - 1)*3 + 2)
    plot(squeeze(mnc(INT,A1,:)),'-','Color',defCols(2,:));
    hold on
    plot(squeeze(mnc(INT,A2,:)),'-.','Color',defCols(7,:));
    if SEL_DATA==1
        title('INTERFERENCE')
        legend('A1','A2')
    end
    
    if SEL_DATA==HY_DATA
        axis tight
    else
        ylim([0 1])
    end
    xlim([1 nmin]);

    % Diff means
    subplot(NPR,3,(SEL_DATA - 1)*3 + 3)
    
    h = boundedline(x,avgDiffs(INT,:),seDiffs(INT,:),'r',x,avgDiffs(SAV,:),seDiffs(SAV,:),'b');
    if SEL_DATA==1
        title('Differences')
        legend('se I','se S','Interference','Savings')
    end
    ylim([-0.5 0.5]);
    xlim([1 nmin]);

    %% Are differences significantly different between groups?
    [h, p, ci, stats] = ttest2(DIFF_AREAS(INT,:),DIFF_AREAS(SAV,:),'tail','left'); %Tests whether Mint<Msav
    
    NORM_CURVES_ALL = cat(5,NORM_CURVES_ALL, NORM_CURVES);
end

%% Plot barlplot of average number of strides
%% NOTE: it  only uses the values stored with the very last ananlysis of the cycle
fhr = figure;
absdiff = (NSTRIDES(:,:,A2) - NSTRIDES(:,:,A1));

nsd = absdiff ./ ((NSTRIDES(:,:,A1)));
% nsd = absdiff;

% Compute averages, se. Plot barplots
mSAV = mean(nsd(SAV,:)); seSAV = std(nsd(SAV,:))/sqrt(8);
mINT = mean(nsd(INT,:)); seINT = std(nsd(INT,:))/sqrt(8);
% barwitherr([seSAV seINT], [mSAV mINT]);    % Plot with errorbars
hb1 = bar([mSAV 0]);
hold on
hb2 = bar([0 mINT]);

set(hb1,'facecolor',defCols(1,:))
set(hb2,'facecolor',defCols(2,:))

x = get(hb1,'Xdata');
y = get(hb1,'Ydata');
errorbar(x(1),y(1),seSAV,'k.','LineWidth',2)

x = get(hb2,'Xdata');
y = get(hb2,'Ydata');
errorbar(x(2),y(2),seINT,'k.','LineWidth',2)
legend('Savings','Interference')
% title('Percent Variation')
title('Variation')

[h, p, ci, stats] = ttest2(nsd(SAV,:), nsd(INT,:),'tail','left');
% addStd(fhr, hb1, 1:2, [1 2], [seSAV 0]' );

% set(hb1(1),'FaceColor',colSav);
% set(hb1(2),'FaceColor',colInt);
%
% legend('Savings','Interference')
% title('Percent Variations')

%
% for i=1:npr %For each selected parameter
%     cpr=indCol(i);
%     subplot(1,npr,i)
%     %     hb=bar([[A1_sav_m(cpr) A2_sav_m(cpr)]' [A1_int_m(cpr) A2_int_m(cpr)]'],'hist');
%     hb1=bar([[A1_sav_m(cpr) 0]' [A1_int_m(cpr) 0]'],'hist');
%     hold on
%     hb2=bar([[0 A2_sav_m(cpr)]' [0 A2_int_m(cpr) ]'],'hist');
%
%     addStd(fhr, hb1, 1:2, [1 2], [[A1_sav_se(cpr) 0]' [A1_int_se(cpr) 0]'] );
%     addStd(fhr, hb2, 1:2, [1 2], [[0 A2_int_se(cpr)]' [0 A2_int_se(cpr)]'] );
%
%     %     if ADD_INDIVIDUALS
%     %        cparData = outcome_table
%     %        add_individual_data(fhr, hb1, [[A1_sav_se(cpr) 0]' [A1_int_se(cpr) 0]']); %A1
%     %        %A2
%     %     end
%     %     % Extract individual data
%     %         sav_par=squeeze(PARAMETERS_SAVINGS(1:2,cpr,:));
%     %         int_par=squeeze(PARAMETERS_INTERFERENCE(1:2,cpr,:));
%     %         addInddividualData(fhr, hb, 1:2, [1 2], cat(3,sav_par,int_par),labels_savings,labels_interf);
%
%     %Test differences and add results
%     %     [cH, cP]=test_differences(sav_par,int_par,1,'unequal');
%     %     [cH, cP]=test_differences(sav_par,int_par,1,'equal','left');
%
%     %     addLineAsterisk_paired(fhr,hb,cH,cP)
%
%     YLIM=ylim();
%     YLIMS = [YLIMS; YLIM ];
%     %     if i==1
%     %     end
%     %     if i<=3
%     %         ylim(YLIM)
%     %     end
%
%     set(gca,'XTickLabel',{'A1','A2'})
%     grid on
%
%     set(hb1(1),'FaceColor',colSav);
%     set(hb1(2),'FaceColor',colInt);
%     set(hb2(1),'FaceColor',colSav);
%     set(hb2(2),'FaceColor',colInt);
%
%     yl(i)=ylabel(ylabels{i});
%
%     xl(i)=xlabel('Adaptation');
%
%     set(hb1(1),'LineStyle',LineArray{1},'LineWidth',3);
%     set(hb1(2),'LineStyle',LineArray{1},'LineWidth',3);
%
%     set(hb2(1),'LineStyle',LineArray{2},'LineWidth',3);
%     set(hb2(2),'LineStyle',LineArray{2},'LineWidth',3);
%     if i==npr
%         hl=legend('Savings gr. (A1)','Interference gr. (A1)','Savings gr. (A2)','Interference gr. (A2)');
%         mySetFontSize(hl,16);
%     end
%     title(report_strings{i})
%
% end