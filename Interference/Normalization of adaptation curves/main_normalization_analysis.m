clc
close all
clear all

%% 1. Load the data
ppath='C:\Users\salat\OneDrive\Documents\MATLAB\Research\CoreL\Interference\Interf_study_AS\SaveDataForStata\';
load([ppath 'ALL_DATA' ])
% load([ppath 'ALL_DATA_STEP_POS' ])

%% 2. Define flags
GROUPS={'INT','SAV'}; %INTERFERENCE=1 %SAVINGS=2
CONDS={'A1','A2'};
ng=length(GROUPS);
nc=length(CONDS);
ns=8;
PLOT_NC = 0; %To plot normalized curve
PLOT_INDIVIDUAL_SUBJECTS = 0;
PLOT_AVERAGE_CURVES = 1;
PLOT_TC_INDIV_SUBJS = 1;
% PLOT_ALL_A1_A2 = 1;

%% 3. Initialize structs
% all_curves = cell(ng,nos(1),nc); %This only works because we have the same number of subjects in each group
%For curves
all_curves_norm = cell(ng,nos(1),nc);
all_curves_crossnorm = cell(ng,nos(1),nc);
% glob_min=nan;
% glob_max=nan;
%For NOS
NOS=zeros(ng,ns,nc);
NOSnorm=zeros(ng,ns,nc);
NOScrossnorm=zeros(ng,ns,nc);

%% 4. Fill cell array
MERGED_DATA=cat(3,INTERFERENCE_DATA,SAVINGS_DATA);
all_curves = permute(MERGED_DATA,[3 2 1]); %NOw GROUP X SUBS X COND
all_curves = fix_struct(all_curves); %Make sure that every adaptation curve is stored as a column vector

%% 5. Normalize curves + findNumberOfStrides
for gr=1:ng
    for sub=1:nos(gr)
        for cond=1:nc
            
            %% Extract curve
            ccurve = all_curves{gr,sub,cond};
            
            %% Compute number of strides
            %i) No normalization
            [nstrides, ~, ~] = find_nstrides_to_mid_pert(ccurve,'Increasing');
            
            %ii) Simple normalization
            norm_ccurve = normalize_curve(ccurve,PLOT_NC);
            [nstrides_norm, ~, ~] = find_nstrides_to_mid_pert(norm_ccurve,'Increasing');
            
            %iii) Cross normalization
            [glob_min, glob_max] = get_min_max(all_curves(gr,sub,:)) ;
            crossnorm_ccurve = normalize_curve(ccurve,PLOT_NC,glob_min,glob_max);
            [nstrides_crossnorm, ~, ~] = find_nstrides_to_mid_pert(crossnorm_ccurve,'Increasing');
            
            %% Store computed values
            %Curves
            all_curves_norm{gr,sub,cond} = norm_ccurve;
            all_curves_crossnorm{gr,sub,cond} = crossnorm_ccurve;
            
            %Number of strides
            NOS(gr,sub,cond) = nstrides;
            NOSnorm(gr,sub,cond) = nstrides_norm;
            NOScrossnorm(gr,sub,cond) = nstrides_crossnorm;
        end
        
    end
end

%% 5. Compute average curves

average_curves = average_curves_final(all_curves); %It's a 2 X 2 GROUP by CONDITION 
norm_average_curves = average_curves_final(all_curves_norm); %It's a 2 X 2
cross_norm_average_curves = average_curves_final(all_curves_crossnorm); %It's a 2 X 2

%% 6. Compute time constant of average curves
[~, tau] = my_exp_fit_ca(average_curves, 'Increasing', 'Single');
[~, tau_norm] = my_exp_fit_ca(norm_average_curves, 'Increasing', 'Single');
[~, tau_cross_norm] = my_exp_fit_ca(cross_norm_average_curves, 'Increasing', 'Single');

%% 7. Compute percent variations in time constants
PV = percent_variation(tau); 
PVnorm = percent_variation(tau_norm); 
PVcrossnorm = percent_variation(tau_cross_norm);

%What is the difference btw 2 and 3 pars exp??

%% 8. Plot computed curves
%Set default parameters
set(groot,'defaultLineLineWidth',2)
set(0,'defaultAxesFontSize',20)


if PLOT_INDIVIDUAL_SUBJECTS
%     plot_norm_curves_all_IC(all_curves,all_curves_norm,all_curves_crossnorm)
%     This only plots original curves VS normalized versions

    plot_norm_curves_all(all_curves, all_curves_norm, all_curves_crossnorm) 
    %This also contrasts between A1 and A2    
    
end

if PLOT_AVERAGE_CURVES
    plot_average_curves(average_curves, norm_average_curves, cross_norm_average_curves,...
                        tau, tau_norm, tau_cross_norm, PV, PVnorm, PVcrossnorm);    
end


%% 9. Plot time constant individual subjects
if PLOT_TC_INDIV_SUBJS
  plot_tc_is(NOS,NOSnorm,NOScrossnorm);
end
% Does interference group become slower?
x = NOS(INTERFERENCE,:,1); y=NOS(INTERFERENCE,:,2);
[h1,p1] = ttest(x,y,0.05,'left'); %NO

% Does saving group become faster?
x = NOS(SAVINGS,:,1); y=NOS(SAVINGS,:,2);
[h2,p2] = ttest(x,y,0.05,'right'); %NO

%% 10. Contrast A1 and A2
plot_tc_contrasts(NOS);



