%% TIME RATE ANALYSIS ON INDIVIDUAL SUBJECTS
% 1. Smoothing ("monotonic fit" OR "continuos average")
% 2. Cross normalization
% 3. Compute number of strides ("time to rise" OR "strides to mid pert")

clc
close all
clear all

%% 0. Start from Smoothed data??
START_FROM_SMOOTHED = 1;
SAVE_DATA = 0;
CREATE_TABLE = 0;

%% Select parameter
npar = 1;
pars = {'', '_STEP_TIME_N2', '_STEP_POS_N2'}; %SLA, ST, SP


%% 1. Load the data
ppath='C:\Users\salat\OneDrive\Documents\MATLAB\Research\CoreL\Interference\Interf_study_AS\SaveDataForStata\';
load([ppath 'ALL_DATA' pars{npar} ])
pathToSmoothed = 'C:\Users\salat\OneDrive\Documents\MATLAB\Research\CoreL\Interference\Interf_study_AS\Intermediate data\';
selPar = pars{npar};
if npar==1
    selPar = 'SLA';
end
pars_short = {'SLA','ST','SP'};
selParShort = pars_short{npar};

%% 2. Define flags
GROUPS = {'INT','SAV'}; %INTERFERENCE=1 %SAVINGS=2
CONDS = {'A1','A2'};
% SMOOTHING     = {'1_EXP','MONOTONIC_FIT', 'C_AVG', '1_EXP_CONSTR','2_EXP_CONSTR','2_EXP'};
% SMOOTHING     = {'1_EXP_CONSTR'};
% SMOOTHING     = {'2_EXP'};
SMOOTHING     = {'1_EXP','MONOTONIC_FIT', '1_EXP_CONSTR','2_EXP_CONSTR','2_EXP'};
% SMOOTHING = {'MONOTONIC_FIT'};
TC_ESTIMATION = {'TIME_TO_RISE', 'NSTR_TO_MID_PERT'}; %I am currently not using this

ng=length(GROUPS);
nc=length(CONDS);
nsm=length(SMOOTHING);
ntce=length(TC_ESTIMATION);
ns=8;
PLOT_NC = 0; %To plot normalized curve
PLOT_INDIVIDUAL_SUBJECTS = 0;
PLOT_AVERAGE_CURVES = 1;
PLOT_TC_INDIV_SUBJS = 0;
% PLOT_ALL_A1_A2 = 1;

%% 3. Initialize structs
% all_curves = cell(ng,nos(1),nc); %This only works because we have the same number of subjects in each group
%For curves
all_curves_norm = cell(ng,nos(1),nc); %GROUP X SUBJECTS X CONDITIONS
all_curves_crossnorm = cell(ng,nos(1),nc);
all_curves_after_smoothing = cell(ng,nos(1),nc,nsm);

% glob_min=nan;
% glob_max=nan;
%For NOS
NOS=zeros(ng,ns,nc);
NOSnorm=zeros(ng,ns,nc);
NOScrossnorm=zeros(ng,ns,nc);

nsmp_raw = zeros(ng,ns,nc,nsm);
nsmp_norm = zeros(ng,ns,nc,nsm);
ttr_raw = zeros(ng,ns,nc,nsm);
ttr_norm = zeros(ng,ns,nc,nsm);
msrates = zeros(ng,ns,nc,nsm);

%% Parameters to set
percs = [0.1 0.9];
R2adjs = zeros(ng,ns,nc,nsm);
RMSEs = zeros(ng,ns,nc,nsm);
R2s = zeros(ng,ns,nc,nsm);

%% 4. Fill cell array
MERGED_DATA=cat(3,INTERFERENCE_DATA,SAVINGS_DATA);
all_curves = permute(MERGED_DATA,[3 2 1]); %NOw GROUP X SUBS X COND
all_curves = fix_struct(all_curves); %Make sure that every adaptation curve is stored as a column vector

if START_FROM_SMOOTHED == 0
    %% 5. Smooth curve. This has to be done this way because cross norm uses A1 and A2
    for gr=1:ng
        for sub=1:nos(gr)
            for cond=1:nc
                for smoothing=1:nsm
                    
                    %% Extract curve
                    ccurve = all_curves{gr,sub,cond};
                    
                    %% Perform appropriate smoothing
                    [ccurve, unsmoothedCurve, R2adj, R2, RMSE] = my_smoothing2(ccurve, SMOOTHING{smoothing});
                    %             figure, plot(ccurve,'-'), hold on, plot(unsmoothedCurve,'o')
                    
                    %% Store computed stuff
                    all_curves_after_smoothing{gr,sub,cond,smoothing} = ccurve;
                    R2adjs(gr,sub,cond,smoothing) = R2adj ;
                    R2s(gr,sub,cond,smoothing) = R2 ;
                    RMSEs(gr,sub,cond,smoothing) = RMSE;
                    sub
                end
            end
        end
    end
    
    
else
    %% Load SMOOTHED
    load([pathToSmoothed 'all_curves_after_smoothing.mat']);
    lPath = 'C:\Users\salat\OneDrive\Documents\MATLAB\Research\CoreL\Interference\Interf_study_AS\SaveDataForStata\Stata - Rate Measures\';
    load([lPath selParShort '_smoothed_all_kinds'])
end


%% Plot individual data
plot_data_and_fit_all_curves(all_curves, all_curves_after_smoothing, SMOOTHING, selPar, R2s, RMSEs)

%% Compute MS threshold
ms_thr = compute_ms_thresholds(all_curves_after_smoothing); %They are computed from the data
MS_DELTA = 0.025;

%% 6. Normalize and compute rate parameters
for gr=1:ng
    for sub=1:nos(gr)
        for cond=1:nc
            for smoothing=1:nsm
                %% 1. Extract curve
                ccurve = all_curves_after_smoothing{gr,sub,cond,smoothing};
                ccurveRaw = all_curves{gr,sub,cond};

                %% 2. Perform normalization
                % Cross normalization
                [glob_min, glob_max] = get_min_max(all_curves_after_smoothing(gr,sub,:,smoothing)) ;
                crossnorm_ccurve = normalize_curve(ccurve,PLOT_NC,glob_min,glob_max);
                crossnorm_ccurveR = normalize_curve(ccurveRaw,PLOT_NC,glob_min,glob_max);

                % Simple normalization
                norm_ccurve = normalize_curve(ccurve,PLOT_NC);
                norm_ccurveR = normalize_curve(ccurveRaw,PLOT_NC);

                
                %% 3. Compute rate parameters (both normalized and not)
                %% Number of strides to mid pert
                %                 nsmp_raw(gr,sub,cond,smoothing)  = find_nstrides_to_mid_pert(ccurve,'Increasing');
                nsmp_norm(gr,sub,cond,smoothing) = find_nstrides_to_mid_pert(crossnorm_ccurve,'Increasing');
                
                %% Time to rise
                %                 ttr_raw(gr,sub,cond,smoothing)  = my_time_to_rise(ccurve);
                ttr_norm(gr,sub,cond,smoothing) = my_time_to_rise(crossnorm_ccurve,percs);
                
                %% Compute MS rate
                %Not cross normalized
                msrates(gr,sub,cond,smoothing) = compute_ms_rate(ccurve, ms_thr(gr,sub), MS_DELTA);
            end
            % Store compute curves
            all_curves_norm{gr,sub,cond} = norm_ccurveR;
            all_curves_crossnorm{gr,sub,cond} = crossnorm_ccurveR;
        end
    end
end

%% Plot parameters

for smoothing=1:nsm
    NOS = squeeze(nsmp_norm(:,:,:,smoothing));
    plot_tc_contrasts(NOS);
    myname=[SMOOTHING{smoothing} ' - Mid pert' ];
    set(gcf,'NumberTitle','off');
    set(gcf,'name',myname);
    
end

for smoothing=1:nsm
    NOS = squeeze(ttr_norm(:,:,:,smoothing));
    plot_tc_contrasts(NOS);
    myname = [SMOOTHING{smoothing} ' - Time to rise' ];
    set(gcf,'NumberTitle','off');
    set(gcf,'name',myname);
end

for smoothing=1:nsm
    NOS = squeeze(msrates(:,:,:,smoothing));
    plot_tc_contrasts(NOS);
    myname = [SMOOTHING{smoothing} ' - MS threshold' ];
    set(gcf,'NumberTitle','off');
    set(gcf,'name',myname);
end

allRateMeas = cat(5,nsmp_norm, ttr_norm, msrates);
rateMeasDef = {'nsmp_norm','ttr_norm','msrates'};

%% Create table for stata
storePath = 'C:\Users\salat\OneDrive\Documents\MATLAB\Research\CoreL\Interference\Interf_study_AS\SaveDataForStata\Stata - Rate Measures\';
if CREATE_TABLE
    create_rate_table_stata(allRateMeas, rateMeasDef, SMOOTHING, storePath, selPar);
end
if SAVE_DATA
   save([storePath selPar '_smoothed_all_kinds'], 'all_curves', 'all_curves_norm', 'all_curves_crossnorm', 'all_curves_after_smoothing', 'SMOOTHING','R2s','RMSEs','R2adjs');
end

%             %% Perform normalization
%             % Cross normalization
%             [glob_min, glob_max] = get_min_max(all_curves(gr,sub,:)) ;
%             crossnorm_ccurve = normalize_curve(ccurve,PLOT_NC,glob_min,glob_max);
%
%
%             [nstrides_crossnorm, ~, ~] = find_nstrides_to_mid_pert(crossnorm_ccurve,'Increasing');
%
%             %% Store computed values
%             %Curves
%             all_curves_norm{gr,sub,cond} = norm_ccurve;
%             all_curves_crossnorm{gr,sub,cond} = crossnorm_ccurve;
%
%             %Number of strides
%             NOS(gr,sub,cond) = nstrides;
%             NOSnorm(gr,sub,cond) = nstrides_norm;
%             NOScrossnorm(gr,sub,cond) = nstrides_crossnorm;
%             end
%         end
%
%     end
% end

%% 5. Compute average curves

% average_curves = average_curves_final(all_curves); %It's a 2 X 2 GROUP by CONDITION
% norm_average_curves = average_curves_final(all_curves_norm); %It's a 2 X 2
% cross_norm_average_curves = average_curves_final(all_curves_crossnorm); %It's a 2 X 2
% 
% %% 6. Compute time constant of average curves
% [~, tau] = my_exp_fit_ca(average_curves, 'Increasing', 'Single');
% [~, tau_norm] = my_exp_fit_ca(norm_average_curves, 'Increasing', 'Single');
% [~, tau_cross_norm] = my_exp_fit_ca(cross_norm_average_curves, 'Increasing', 'Single');
% 
% %% 7. Compute percent variations in time constants
% PV = percent_variation(tau);
% PVnorm = percent_variation(tau_norm);
% PVcrossnorm = percent_variation(tau_cross_norm);
% 
% %What is the difference btw 2 and 3 pars exp??
% 
% %% 8. Plot computed curves
% %Set default parameters
% set(groot,'defaultLineLineWidth',2)
% set(0,'defaultAxesFontSize',20)
% 
% 
% if PLOT_INDIVIDUAL_SUBJECTS
%     %     plot_norm_curves_all_IC(all_curves,all_curves_norm,all_curves_crossnorm)
%     %     This only plots original curves VS normalized versions
%     
%     plot_norm_curves_all(all_curves, all_curves_norm, all_curves_crossnorm)
%     %This also contrasts between A1 and A2
%     
% end
% 
% if PLOT_AVERAGE_CURVES
%     plot_average_curves(average_curves, norm_average_curves, cross_norm_average_curves,...
%         tau, tau_norm, tau_cross_norm, PV, PVnorm, PVcrossnorm);
% end
% 
% 
% %% 9. Plot time constant individual subjects
% if PLOT_TC_INDIV_SUBJS
%     plot_tc_is(NOS,NOSnorm,NOScrossnorm);
% end
% % Does interference group become slower?
% x = NOS(INTERFERENCE,:,1); y=NOS(INTERFERENCE,:,2);
% [h1,p1] = ttest(x,y,0.05,'left'); %NO
% 
% % Does saving group become faster?
% x = NOS(SAVINGS,:,1); y=NOS(SAVINGS,:,2);
% [h2,p2] = ttest(x,y,0.05,'right'); %NO
% 
% %% 10. Contrast A1 and A2
% plot_tc_contrasts(NOS);
% 


