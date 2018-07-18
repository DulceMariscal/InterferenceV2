%% Comparison bootstrap CI with real data

clc
close all
clear all

%% Define paths
ppathCI=['C:\Users\salat\OneDrive\Documents\MATLAB\Research\CoreL\Interference\Interf_study_AS\Intermediate data\'];
pathDATA=['C:\Users\salat\OneDrive\Documents\MATLAB\Research\CoreL\Interference\Interf_study_AS\SaveDataForStata\Stata - Rate Measures\Last Shared Nov 12\Data\'];
allFiles = {'BootstrapData.mat', 'BootstrapData_cross_normalized.mat' };

%% Define cosntants
nf=length(allFiles); %Number of files (number of different versions of processed data analyzed)
INT=1; SAV=2; ng=2; %Int VS Sav
ns=8;
A1=1; A2=2; nc=2;

%% Initializations
CI = zeros(3,nf,ng); %(5 50 95 percentiles) X (raw data, cross normalized data) X (INT, SAV)
TAU = zeros(ng, ns, nc, nf);
PV = zeros(ng, ns, nf);
all_fits = cell(ng, ns, nc, nf);
all_belongs = zeros(nc, ns, nf);
all_belongsAVG = zeros(ng,nf);
all_fitsAVG = cell(ng, nc, nf);

%%

%% Load confidence interval data
for cf=1:nf
    
    %Load confidence intervals
    cpath=[ppathCI allFiles{cf} ];
    
    %Load INT ci
    load(cpath,'ci_pv_i');
    CI(:,cf,INT) = ci_pv_i;
    
    %Load SAV ci
    load(cpath,'ci_pv_s');
    CI(:,cf,SAV) = ci_pv_s*100;
    
end

%% Load adaptation data, compute percent variations, compute hwo good the
%% distribution is at describing the original data


for cf=1:nf
    
    %1. Load data
    load([pathDATA 'SLA_smoothed_all_kinds.mat'],'all_curves');
    
    %2. Compute percent variation
    [PVcf, TAUcf, fits] = compute_pv(all_curves);
    
    %3. Do PV of individual subjects belong to the CI ? YES or NO?
    maskBelongCI = belongToCi(PVcf,squeeze(CI(:,cf,:)));
    
    %4. What is the probability of observing a PV equal or more extreme than
    %the observed one?
    
    %5. Are the means likely to belong to the CI?
    %Compute means
    [avgc, SE] = average_curves_final(all_curves);
    
    %Compute PV
    [PVcfAVG, TAUcfAVG, avgFits] = compute_pv2(avgc);
    
    %Test PV
    maskAVG = belongToCi(PVcfAVG,squeeze(CI(:,cf,:)));
    
    %6. Store PV and TAUs
    PV(:, :, cf) = PVcf;
    TAU(:, :, :, cf) = TAUcf;
    all_fits(:,:,:,cf) = fits;
    all_fitsAVG(:,:,cf) = avgFits;
    all_belongs(:,:,cf) = maskBelongCI;
    all_belongsAVG(:,cf) = maskAVG;
end


%% Plot single subject data

% Define input parameters
valSingleCurve = {TAU}; % One parameter --> one cell
valCoupleCurve = {PV, all_belongs}; % One parameter --> one cell
dim4 = 'Kind of data';
dim4Names = {'Raw data','Cross Normalized Data'};
selContr = 'SLA';
namesSingleCurve = {'\tau'};
namesCoupleCurve = {'PV','BCI'};

%Plot
plot_data_and_fit_all_curves2(all_curves, all_fits, ...
    dim4, dim4Names,...
    selContr,...
    namesSingleCurve, valSingleCurve,...
    namesCoupleCurve, valCoupleCurve)










