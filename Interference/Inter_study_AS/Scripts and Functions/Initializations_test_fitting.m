%% Re-analysis Luis experiment: Savings VS Interference


% cd('C:\Users\lz17\Documents\MATLAB\Interference_project\Interference subjects\All_subjects')
% cd('C:\Users\ALS414\Documents\MATLAB\Pilot\S2')
%% Parameters analysis
%To define-----------------------------------------------------------------
% gait_par='spatialContribution';
gait_par='stepLengthAsym';
% gait_par='stepTimeContributionNorm2';
% gait_par='COPysym_MW';
% gait_par='SLA-Adaptation';
% gait_par='spatialContributionNorm2';
%adaptData.plotParamTimeCourse({'netContribution','spatialContribution','stepTimeContribution','velocityContribution'})
if strcmpi(gait_par,'stepLengthAsym') || strcmpi(gait_par,'SLA-Adaptation') || strcmpi(gait_par,'spatialContribution') || strcmpi(gait_par,'stepTimeContribution')
    INCR_EXP=1;
elseif strcmpi(gait_par,'COPysym_MW')
    INCR_EXP=0;
end
SUBTRACT_BASELINE=1; %Small differences
conditions_to_compare={'Adaptation 1','Adaptation 1(2nd time)'};
last_stides_to_ignore=5;
% first_strides_to_ignore=5;
% first_strides_to_ignore=15; %Subject I007 was not able to make normal steps until 15 strides or so
outliers_thr=10;
MEDIAN_FILTER=1;
RUNNING_AVERAGE=1;
wSize=5; %Window size
ncons=10; %Number of consecutive strides above(below) threshold (e.g. 0.63 SS)
FIRST_SAMPLES = 10; %Number of strides to average to compute first value for trend signal
LAST_STRIDE_REC = 20;
LAST_STRIDE_SLOPE = 20;
BOOTSTRAP=0;

% Y_LINE_RANGE=[-0.7 0.05];

%Fitting parameters
SINGLE_EXP=1;
DOUBLE_EXP=2;
MONOTONIC_FIT=3;
ADAPTIVE_FIT=4;

FIT_MODEL=SINGLE_EXP;

%Load IC for fitting
initial_conditions_fit

%Last derivetive to constrain (MONOTONIC_FIT)
ldc=2;

%Parameters reduced fit
ind_last_lin_fit=100;
ind_last_exp_fit=100;

%Initial condition two-state model
x0_2sm=[0 0]; %Initial estimate
k0_2sm=[1 0 1 0]; 
k0_ext=[x0_2sm k0_2sm];

%Derived-----------------------------------------------------------------
nconds=length(conditions_to_compare);

%% Parameters experiment
%To define-----------------------------------------------------------------
INTERFERENCE=1;
SAVINGS=2;
group_labels={'I00','S00'};
% indices_interference=[1 3 4 5];
% indices_interference=[1 3 4 5 6 7 8 9];
 indices_interference=[1 3 4 5 6 7 8 9];
% indices_interference=[];
% indices_savings=[1:8];
indices_savings=[1 3 4 5 6 7 8 9];
% indices_savings=[];
% indices_savings=[1 2 3 4];
labels_interf=create_labels('I',indices_interference);
labels_savings=create_labels('S',indices_savings);
labels_tot={labels_interf,labels_savings};
TRANSLATE_FLAG=0;
MAWASE_COMP=0;
%Derived-----------------------------------------------------------------
ngr=length(group_labels);
indices_subjects={indices_interference,indices_savings};
nos=cellfun(@length,indices_subjects); %Number of subjects in each group

%% Data structures to store the results
%Parameters exponential fit
npar_fit=length(x0);
FIRST_STRIDE=1; EARLY_CHANGE=2; PLATEAU=3; NSTRIDES=4;
 %C1r=9; C2r=10; C3r=11; A=12; B=13;
NSTRIDES_TREND=5; %LR=7; %=slope-c2/c3;
RECALL_data=6; PERFORMANCE_data=7; SLOPE_data=8; RECALL_fit=9; 
PERFORMANCE_fit=10; SLOPE_fit=11; STRIDES_TO_HALVE=12;
AVERAGE_RATE_FIT=13;

n_parameters=13;
parameters_strings={'First str','Initial str','Plateau','#str to 0.63*SS','#str to 0.63*SS trend','Recall data',...
                    'Perf D','Slope D','Recall F','Perf F','Slope fit','#str to 0.5*SLA','Avg rate'};

ind_pert=1; ind_relearning=2:30; ind_perf=30; ss_perc = 1-exp(-1); %0.6321
LOST_STRIDES_S8=42;
PARAMETERS_INTERFERENCE=zeros(nconds,n_parameters,nos(INTERFERENCE));
PARAMETERS_SAVINGS=zeros(nconds,n_parameters,nos(SAVINGS));
PARAMETERS_ALL={PARAMETERS_INTERFERENCE,PARAMETERS_SAVINGS};
INTERFERENCE_DATA=cell(nconds,nos(INTERFERENCE));
SAVINGS_DATA=cell(nconds,nos(SAVINGS));
INTERFERENCE_FIT_DATA=cell(nconds,nos(INTERFERENCE),2); %In the last dimension are stored 1->fit, 2->d{fit}/dt
SAVINGS_FIT_DATA=cell(nconds,nos(SAVINGS),2);
CI_SAV=zeros(nconds,nos(SAVINGS),npar_fit,2);
CI_INT=zeros(nconds,nos(INTERFERENCE),npar_fit,2);
tableData=zeros(1,2*npar_fit);
PERC_STRIDES_TO_HALVE=0.5;
LAST_STRIDE_DERIVATIVE=100;
percentages=fliplr([0.4:0.1:1]); nsteps=length(percentages);
STRIDES_TO_PERCENTAGE={zeros(nconds,nsteps,nos(INTERFERENCE)),zeros(nconds,nsteps,nos(SAVINGS))};

% Structure for fitting parameters
field1 = 'selectedModel';  value1 ='Model';
field2 = 'coefficients';  value2 = 0;
field3 = 'R2_adj';  value3 = 0;
field4 = 'ci';  value4 = 0;
field5 = 'R2_adj_all_models';  value5 = 0;
fittingStruct = struct(field1,value1,field2,value2,field3,value3,field4,value4,field5,value5);
INT_FIT_PAR=repmat(fittingStruct,nconds,nos(INTERFERENCE));
SAV_FIT_PAR=repmat(fittingStruct,nconds,nos(SAVINGS));
FITTING_STRUCTS={INT_FIT_PAR,SAV_FIT_PAR};
FITTING_STRUCTS_RED_EXP={INT_FIT_PAR,SAV_FIT_PAR};
FITTING_STRUCTS_RED_LIN={INT_FIT_PAR,SAV_FIT_PAR};


%% PLOT PARAMETERS
f1=figure; %Plot data + (exponential) fits
f2=figure; %Plot data + reduced fits
f3=figure; %Plot data + trend
f4=figure; %Print confidence interval table
f5=figure; %Plot data + two-state model fit
mycolors={'b','g','m';'r','k','y'}; %Cond1; cond2
subplot_offset=0;
%outcome_meas_strings={'Recall' ,'Re-learning','Performance','#str','Tc exp','Tc exp red','Slope','#str_{trend}','SLOPE','LR' };
%outcome_meas_strings={'Recall' ,'Re-learning','Performance','#str','Tc exp','Tc exp red','Slope','#str_{trend}','SLOPE','LR' };

margins=[0.05,0.05];
dim_head=10;
dim_cell=9;
TABLE_ON_DATA=0;
PLOT_LINES=STRIDES_TO_HALVE; %Will plot a line for the selected parameter (e.g. STRIDES_TO_HALVE, NSTRIDES). Set to 0 for no lines
% ZOOM_ON_FIRST=[1 20]; %Default [0 600];
ZOOM_ON_FIRST=[0 600];

%Path to folder containing data
% mainPath='C:\Users\salat\OneDrive\Documents\MATLAB\MatlabFunctionExchangeApril6\Interf_study_AS\';
% mainPath='C:\Users\salat\OneDrive\Documents\MATLAB\Research\CoreL\Interference\Interf_study_AS\'
mainPath='C:\Users\dum5\OneDrive\_Shared Drive - Interference Project - Alessandro - Dulce_\Params Files\'
dataFolder=[mainPath '\subjectsData\'];

ADAPTIVE_FIRST_STRIDES_REMOVAL=1; %If set to 0 ignore a fixed number of strides,
                                  %if set to 1, try to find the best number
                                  %of strides to ignore

NUM_COND=5; %Number of minumum consecutive strides with increasing (decreasing) sla (COP_adapt,..) to start considering the data
ifp=zeros(2,2,8); %group * cond * subj

% load([mainPath 'Intermediate data\minNOSToRemove.mat'])
% load([mainPath 'Intermediate data\initialPertI008_A1_alt'])
% load([mainPath 'minNOSToRemove.mat'])
load('minNOSToRemove.mat')

REGRESSORS=[];
BASELINE_DATA=cell(nos(INTERFERENCE) + nos(SAVINGS),1); %Interference subjects - Savings subjects