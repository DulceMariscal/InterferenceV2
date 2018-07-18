%% Fit different models to the interference experiment data and compare them

clc
close all
clear all

if(1)
NORMPERT = 0;

%% Definition of datasets to upload
TRANSL_1 = 1;           % Here adaptation = sla + perturbation (-1,1)
DIFFERET_TRANSL = 2;    % Here adaptation = sla + perturbation (-1,1), but the interference group is shifted
TRANSL_MP = 3;          % Here adaptation = sla + perturbation (-mp:mp)
TRANSL_MA1P = 4;        % Here adaptation = sla + perturbation (-mp:mp during A1)
GELSY_PREP = 5;         % Here there is both a translation and and a 0-1 normalization
TRANSL_MA1P_SA = 6;     % This dataset also contains a simulated short abrupt
FourGroupsV1 = 7;

%% Selection of dataset
DATA_SET = FourGroupsV1;

%%
my_set_default(20,3,5);
pathToData = 'C:\Users\salat\Dropbox\Research_Pitt_AS\Code\!!! Data Prep For Fitting !!!\Data';
load([pathToData '\basStd.mat']);
switch DATA_SET
    case TRANSL_1
        load([pathToData '\DataForFitting.mat'])
        gYLIMS = [-1 1];
        aYLIMS = [.7 1];
        maxPA = 1*.6; %Max value primitives can assume
    case DIFFERET_TRANSL
        load([pathToData '\DataForFittingNormPert.mat'])
        maxPA = 1*.6; %Max value primitives can assume
    case TRANSL_MP
        load([pathToData '\DataForFittingMaxPert.mat'])
        maxPA = .6*.6; %Max value primitives can assume
    case TRANSL_MA1P
        load([pathToData '\DataForFittingMaxPertA1.mat'])
        gYLIMS = [-.36 .36];
        aYLIMS = [0 .36];
        maxPA = .35*.6;
    case TRANSL_MA1P_SA
        load([pathToData '\DataForFittingMaxPertA1_ShAb2.mat'])
        gYLIMS = [-.36 .36];
        aYLIMS = [0 .36];
        maxPA = .35*.6;
    case FourGroupsV1
        load([pathToData '\Int_Sav_ShAb_Gradual_v1.mat'])
        gYLIMS = [-.36 .36];
        aYLIMS = [0 .36];
        maxPA = mp;
end
load([pathToData '\defaultColors.mat'])

%% General Initializations
[ng, nt] = size(perturbations);
gnames = {'Interference','Savings','ShAb','Grad'};
grcols = [defaultColors(2,:); defaultColors(1,:); [0,191,255]/255; [0.4660    0.6740    0.1880]];
nc=2;
grCond = cell(ng,nc);
%Colors fro grCond: Groups X Conditions
for gr=1:ng
    %A1
    grCond{gr,1} = defaultColors(3,:);%Yellow
    
    %A2
    grCond{gr,2} = grcols(gr,:); %Red or Blue or Light Blue
    
end

% Indices definition
a1inds = {151:750,151:750,151:270,151:750};
a2inds = {2101:2700,2101:2700,1621:2220,2101:2700};
aeinds = {2701:2850, 2701:2850, 2221:2370, 2701:2850};
ainds = [a1inds; a2inds]'; %gr X cond

% Styles definition
lstyles = {'o', '--'; 'o', '-'};  DATA=1; FIT=2; %Data, Fit
cols2   = [.5 .5 .5; 0 0 0]; %A1, A2
lwidths = [6, 3];
myLineSpecs = {{':','--'};{':','--','-.','-.'};{'-.','-.'}};
etCols = [defaultColors(5,:); defaultColors(4,:)];
cX=1; cY=2; A1=1; A2=2;
nconds=2;
indok = ~isnan(adaptations); %CAREFUL! nan represents different things
% indok = cellfun(@(x) ~isnnan(x),adaptations);
modParams = initializeModParams(perturbations,nt,ng,nconds);
transitions = {[151 750 2101 2700]; [151 750 2101 2700]; [151 151+119 151+119+1351 151+119+1350+600]; [151 750 2101 2700]};

%% -------------------------------------------------------------------------
%% Select 3 models you want to compare
% SM2006 = 1, %SSIM = 2, %SSIM - CWSS = 7, %SSIM - ISE2 = 13
% modelsToCompare = [2 7 13];
% modelsToCompare = [2 13 15];
% modelsToCompare = [1 2 3];
modelsToCompare =   [20 21 23];
% modelsToCompare = [1 2 7];
%% -------------------------------------------------------------------------

%% Other initializations
paramsE6 = [.87 .88 .74 .17 0]; %Parameters experiment 6 ETM
%params = [alpha0 alpha180 beta0 beta180 c180];
nmods=length(modelsToCompare);
BICs=[];

seedVals = [0 0.5 1];
% seedVals = [0];

nseeds = length(seedVals);
minVals = zeros(1,nseeds);
INT=1; SAV=2;

%% Main Fitting loop
% model = 3;00
% gr = 1;
% [z, e, X] = my_model_evolution(model, modParams(model).kmin, modParams(model).input(gr,:,:), modParams(model).x0);

for imod=1:nmods
    model = modelsToCompare(imod);
    kmins = zeros(nseeds,modParams(model).npars);
    
    %Fit current model usind different seeds
    residFcn =  @(k)two_state_lsq2(k,adaptations,modParams(model).x0,modParams(model).input,model,basStd,maxPA);
    for inStep = 1:nseeds
        [kmins(inStep,:), minVals(inStep)] = fmincon(residFcn, modParams(model).k0 + seedVals(inStep), modParams(model).Acond,...
            modParams(model).bcond , [], [],modParams(model).klb,...
            modParams(model).kub);
        %     k_min = paramsE6;
    end
    
    [~, imin] = min(minVals);
    k_min = kmins(imin,:);
    
    %Retrieve best-fitting motor output for each group
    for gr = 1:ng
        [z, e, X, Xadd]= my_model_evolution(model,k_min, modParams(model).input(gr,:,:), modParams(model).x0, basStd, maxPA);
        modParams(model).z(gr,:,:) = z';
        modParams(model).e(gr,indok(gr,:,1)) = (adaptations(gr,indok(gr,:)) - z(1,indok(gr,:)))'; % This here is the fitting error
        modParams(model).X(gr,:,:) = X;
        modParams(model).Xadd(gr,:,:) = Xadd;
    end
    
    %Compute and store paramaters goodness of fit
    modParams(model).BIC = computeBIC(adaptations, modParams(model).z, modParams(model).npars);
    modParams(model).R2 = computeR2(adaptations, modParams(model).z);
    modParams(model).kmin = k_min;
    BICs = [BICs modParams(model).BIC];
end
[deltaBics, Ranking] = myComputeBICdiff(BICs);

%% Create strings parameters=value
nsig = 4;
for imod=1:nmods
    model = modelsToCompare(imod);
    modParams(model).summaryString = createString(modParams(model).parNames,modParams(model).kmin, nsig);
end

end
%% Plot whole eperiment results for each group-----------------------------
f1 = figure('Name','Data + Fits','NumberTitle','off');
XLIMS = [0 nt]; YLIMS = gYLIMS;
plot_df(f1,modParams,modelsToCompare,nmods,ng,adaptations,grcols,gnames,XLIMS,YLIMS); %Plots data and fits

%% Plot whole experiment results for each model(overlapping groups)
f2 = figure('Name','Fits - Groups contrasts','NumberTitle','off');
XLIMS = [0 nt]; YLIMS = gYLIMS;
plot_fgc(f2,modParams,modelsToCompare,nmods,ng,adaptations, Ranking, deltaBics, nsig, grcols,gnames,...
    XLIMS,YLIMS);

%% Plot A1 VS A2 - Data VS Fits
stridesToSkip = 0; %These strides will be removed to compute percent variations
f3 = figure('Name',['A1 vs A2 contrasts - Strides Removed For PV : ' num2str(stridesToSkip)  ],...
    'NumberTitle','off');
XLIMS = [0 600]; YLIMS = aYLIMS;
[PVdata, PVfit, TAUfit, TAUdata] = plot_contrasts(f3,modParams,modelsToCompare,nmods,ng,adaptations,...
    ainds, stridesToSkip, nsig, grCond, cols2, gnames, lstyles,lwidths,...
    XLIMS,YLIMS,FIT, DATA, SAV, INT);

%% Plot whole eperiment results for each group with individual states
f4 = figure('Name','Data + Fits + States','NumberTitle','off');
XLIMS = [0 nt]; YLIMS = gYLIMS;
OVERLAP_PROBABILITY = 1;
plot_states_evolution(f4,modParams,modelsToCompare,nmods,ng,adaptations,...
    ainds, stridesToSkip, nsig, grCond, grcols, gnames, lstyles,lwidths,...
    XLIMS,YLIMS,FIT, DATA, SAV, INT, OVERLAP_PROBABILITY);

%% COMPARE MODELS ERRORS
f5 = figure('Name','Models errors','NumberTitle','off');
XLIM = [0 nt]; YLIM1 = [-.05 .05]; YLIM2 = [0 60];
plot_errors(f5,modParams,modelsToCompare,nmods,ng,adaptations,...
    ainds, stridesToSkip, nsig, grCond, grcols, gnames, lstyles,lwidths,...
    XLIM, YLIM1,YLIM2, FIT, DATA, SAV, INT, Ranking, deltaBics, transitions);


%% Plot A1 VS A2 with individual states
f6 = figure('Name','States','NumberTitle','off');
XLIM = [0 600]; YLIM = gYLIMS;
statesToPlot = {[1:2],[1:2],[1:2]};
plot_states(f6,modParams,modelsToCompare,nmods,ng,adaptations,...
    ainds, stridesToSkip, nsig, grCond, grcols, gnames, lstyles,lwidths,...
    XLIM, YLIM, FIT, DATA, SAV, INT, Ranking, deltaBics, transitions,statesToPlot);

%% Analyze Behavior of additional variables

% model = modelsToCompare(end-1);
% if ~all(isnan(modParams(model).kmin))
%     
%     % Plot whole eperiment results for each group with individual states
%     f8 = figure('Name','Data + Fits + States + Xadd','NumberTitle','off');
%     M1=[1 2; 3 4];
%     
%     Coord = modParams(model).zcoord;
%     for gr=1:ng
%         subplot(2,2,M1(1,gr))
%         
%         % Add parameters values
%         if gr==1
%             text(-.35, 0.5, modParams(model).summaryString ,'Units','normalized','FontSIze',14,...
%                 'VerticalAlignment','middle','HorizontalAlignment','left',...
%                 'EdgeCOlor','b'); hold on;
%         end
%         
%         % Data
%         plot(adaptations(gr,:),'ko'); hold on;
%         
%         % Fit
%         plot(modParams(model).z(gr,:,Coord),'Color',grcols(gr,:)); hold on;
%         
%         % States
%         for cstate=1:modParams(model).nstates
%             %Plot
%             p = plot(squeeze(modParams(model).X(gr,cstate,:))'); hold on;
%             
%             %Retrieve plot properties
%             ccol = modParams(model).colors{cstate};
%             if isnan(ccol)
%                 ccol = grcols(gr,:);
%             end
%             clw = modParams(model).lw(cstate);
%             if isnan(clw)
%                 clw = 2; %Default line width
%             end
%             
%             %Set plot poperties
%             p.LineStyle = modParams(model).lineSpecs{cstate};
%             p.Color = ccol;
%             p.LineWidth = clw;
%         end
%         
%         % Additional variables
%         subplot(2,2,M1(2,gr))
%         Xadds = modParams(model).Xadd;
%         nas=size(Xadds,2);
%         for jj=1:nas
%             plot(squeeze(Xadds(gr,jj,:))); hold on;
%         end
%         
%         if gr==1
%             %             ylabel(modParams(model).name);
%             legend( modParams(model).avDescr)
%         end
%         if imod==1
%             title(gnames{gr});
%         end
%         xlim([0 nt]);
%         ylim([0 1]);
%     end
%     
%     
%     
% end
% 
% 








