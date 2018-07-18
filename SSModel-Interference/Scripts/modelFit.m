clc
close all
clear all

my_set_default(20,3,5);

load('C:\Users\salat\OneDrive\Documents\MATLAB\Research\CoreL\!!! Data Prep For Fitting !!!\Data\DataForFitting.mat')
load('C:\Users\salat\OneDrive\Documents\MATLAB\Research\CoreL\!!! Data Prep For Fitting !!!\defaultColors')

%% Initializations
gnames = {'Interference','Savings'};
grcols = [defaultColors(2,:); defaultColors(1,:)];
nsig = 3;
[ng, nt] = size(perturbations);
a1ind = [151:750];
a2ind = [2101:2700];
aeind = [2701:2850];
ainds = [a1ind; a2ind];
lstyles = {'o', '--'; 'o', '-'};  DATA=1; FIT=2; %Data, Fit
cols2   = [.5 .5 .5; 0 0 0]; %A1, A2
lwidths = [6, 3];
nmod = 2; %N models
X=zeros(nt, ng, nmod); E = X; XF = X; XS=X; XNE=X; XPE=X;

%% Fit Smith 2006 to each group
SM2006=1;
x0 = [0 0];
k0=[1 1 1 1]; klb = [0 0 0 0]; kub = [1 1 1 1];
Acond = [1 0 -1 0; 0 -1 0 1; 0 0 0 0; 0 0 0 0]; bcond = zeros(4,1);
figure('Name','Smith 2006 - Individual experiments fits','NumberTitle','off');

for gr=1:ng
    %Fit
    residFcn =  @(k)two_state_lsq2(k,adaptations(gr,:),x0,perturbations(gr,:),SM2006);
    [k_min, finalResid(gr)] = fmincon(residFcn, k0 , Acond , bcond , [], [], klb , kub);
    
    %Plot
    [xfit, efit, xf, xs]= two_state_evolve(k_min, perturbations(gr,:), x0);
    subplot(2,1,gr)
    plot(perturbations(gr,:),'k'), hold on, plot(adaptations(gr,:),'ko'), ...
        hold on, htop = plot(xfit,'Color',grcols(gr,:));
    hold on, plot(xf,'--','Color',grcols(gr,:));
    hold on, plot(xs,'-.','Color',grcols(gr,:));
    R2 = my_compute_R2adj(xfit,adaptations(gr,:),length(k_min),0,0);
    legend('Perturbation','Data','Fit','x_f','x_s')
    title([gnames{gr} '. a_f = ' num2str(k_min(1),nsig) ' b_f = ' num2str(k_min(2),nsig)...
        ' a_s = '  num2str(k_min(3),nsig) ' b_s = ' num2str(k_min(4),nsig)...
        ' R^2 = ' num2str(R2,nsig)]);
    uistack(htop, 'top')
    
end




%% Fit Smith 2006 simultaneously
f1 = figure('Name','Smith 2006 - Simultaneous fits','NumberTitle','off');
f2 = figure('Name','Smith 2006 - Simultaneous fits A1 vs A2','NumberTitle','off');

%Fit
residFcn =  @(k)two_state_lsq2(k,adaptations,x0,perturbations,SM2006);
[k_min, finalResidT] = fmincon(residFcn, k0 , Acond , bcond , [], [], klb , kub);

%Plot
for gr = 1:ng
    [xfit, efit, xf, xs]= two_state_evolve(k_min, perturbations(gr,:), x0);
    R2 = my_compute_R2adj(xfit,adaptations(gr,:),length(k_min),0,0);
    
    %Plot whole experiment
    figure(f1)
    subplot(2,1,gr)
    plot(perturbations(gr,:),'k'), hold on, plot(adaptations(gr,:),'ko'), ...
        hold on, htop = plot(xfit,'Color',grcols(gr,:));
    hold on, plot(xf,'--','Color',grcols(gr,:));
    hold on, plot(xs,'-.','Color',grcols(gr,:));
    legend('Perturbation','Data','Fit','x_f','x_s')
    title([gnames{gr} '. a_f = ' num2str(k_min(1),nsig) ' b_f = ' num2str(k_min(2),nsig)...
        ' a_s = '  num2str(k_min(3),nsig) ' b_s = ' num2str(k_min(4),nsig)...
        ' R^2 = ' num2str(R2,nsig)]);
    uistack(htop, 'top')
    
    %Plot A1 vs A2
    figure(f2)
    
    for cond = 1:2
        ci = ainds(cond,:); %Current indices
        subplot(1,2,gr)
        plot(adaptations(gr,ci),lstyles{cond,DATA},'Color',cols2(cond,:),'LineWidth',1), hold on;
        htops(cond) = plot(xfit(ci),lstyles{cond,FIT},'Color',cols2(cond,:),'LineWidth',lwidths(cond)); hold on;
        
        %         plot(xf(ci),'--','Color',cols(gr,:)), hold on;
        %         plot(xs(ci),'-.','Color',cols(gr,:));
        %         legend('Data^I','x^I','x_f^I','x_s^I',...
        %         title([gnames{gr} '. a_f = ' num2str(k_min(1),nsig) ' b_f = ' num2str(k_min(2),nsig)...
        %             ' a_s = '  num2str(k_min(3),nsig) ' b_s = ' num2str(k_min(4),nsig)...
        %             ' R^2 = ' num2str(R2,nsig)]);
    end
    legend('Data_{A_1}','Fit_{A_1}','Data_{A_2}','Fit_{A_2}')
    uistack(htops(1), 'top')
    title(gnames{gr})
    ylim([0 1])
    
    X(:,gr,1) = xfit;
end
BICS(1) = computeBIC(adaptations, X(:,:,1), 4);
R2s(1)  = my_compute_R2adj([X(:,1,1)' X(:,2,1)'],adaptations(:)',length(k_min),0,0);

%% Fit SSIM (State-Space Interference Model) simultaneously
SSIM = 2;
Acond = [1 0 0 -1 0 0 0 0 0;...
    0 0 0 1 0 0 0 -1 0;...
    0 -1 0 0 1 0 0 0 0;...
    0 0 0 0 -1 0 0 0 1;...
    zeros(5,9)];
klb = zeros(1,9); kub = ones(1,9);
bcond = zeros(9,1);
f1 = figure('Name','SSIM1 - Simultaneous fits','NumberTitle','off');
f2 = figure('Name','SSIM1 - Simultaneous fits A1 vs A2','NumberTitle','off');
f3 = figure('Name','SSIM1 - State evolution','NumberTitle','off');


%Fit
k0 = zeros(1,9)+0.5; x0=zeros(1,4);
residFcn =  @(k)two_state_lsq2(k,adaptations,x0,perturbations,SSIM);
[k_min, finalResidT] = fmincon(residFcn, k0 , Acond , bcond , [], [], klb , kub);

%Plot
for gr = 1:ng
    [xfit, efit, xf, xs, xpe, xne]= two_state_int_evolve1(k_min, perturbations(gr,:), x0);
    R2 = my_compute_R2adj(xfit,adaptations(gr,:),length(k_min),0,0);
    
    %Plot whole experiment
    figure(f1)
    subplot(2,1,gr)
    plot(perturbations(gr,:),'k'), hold on, plot(adaptations(gr,:),'ko'), ...
        hold on, htop = plot(xfit,'Color',grcols(gr,:));
    hold on, plot(xf,'--','Color',grcols(gr,:));
    hold on, plot(xs,'-.','Color',grcols(gr,:));
    legend('Perturbation','Data','Fit','x_f','x_s')
    title([gnames{gr} '. a_f = ' num2str(k_min(1),nsig) ' b_f = ' num2str(k_min(2),nsig)...
        ' a_s = '  num2str(k_min(3),nsig) ' b_s = ' num2str(k_min(4),nsig)...
        ' R^2 = ' num2str(R2,nsig)]);
    uistack(htop, 'top')
    
    %Plot A1 vs A2
    figure(f2)
    
    for cond = 1:2
        ci = ainds(cond,:); %Current indices
        subplot(1,2,gr)
        plot(adaptations(gr,ci),lstyles{cond,DATA},'Color',cols2(cond,:),'LineWidth',1), hold on;
        htops(cond) = plot(xfit(ci),lstyles{cond,FIT},'Color',cols2(cond,:),'LineWidth',lwidths(cond)); hold on;
        
        %         plot(xf(ci),'--','Color',cols(gr,:)), hold on;
        %         plot(xs(ci),'-.','Color',cols(gr,:));
        %         legend('Data^I','x^I','x_f^I','x_s^I',...
        %         title([gnames{gr} '. a_f = ' num2str(k_min(1),nsig) ' b_f = ' num2str(k_min(2),nsig)...
        %             ' a_s = '  num2str(k_min(3),nsig) ' b_s = ' num2str(k_min(4),nsig)...
        %             ' R^2 = ' num2str(R2,nsig)]);
    end
    legend('Data_{A_1}','Fit_{A_1}','Data_{A_2}','Fit_{A_2}')
    uistack(htops(1), 'top')
    title(gnames{gr})
    %            'Data^S','x^S','x_f^S','x_s^S')
    ylim([0 1])
    cmod = 2;
    X(:,gr,cmod) = xfit; E(:,gr,cmod) = efit; XF(:,gr,cmod)= xf; XS(:,gr,cmod)= xs; XPE(:,gr,cmod)= xpe; XNE(:,gr,cmod)= xne;
end
BICS(2) = computeBIC(adaptations, X(:,:,2), length(k_min));
R2s(2)  = my_compute_R2adj([X(:,1,2)' X(:,2,2)'],adaptations(:)',length(k_min),0,0);

%% Check that the fits are still able to reproduce the interesting characteristics of the data
%% 1. A1 vs A2 (Model fit or Raw Data with exponential fit)
% Conclusion: percent variation  effect is present in the row data but is
% not preserved in the model (state x)
figure
cmod = 2;
stridesToSkip = 15;
plotRawData   = 1; %Set to 2, to use fits instead
for gr=1:ng
    subplot(1,2,gr)
    for cond=1:2
        ci    = ainds(cond,:); %Current indices
        if plotRawData
            cdata = adaptations(gr,ci);
        else
            cdata = X(ci,gr,cmod);
        end
        cdata = cdata(stridesToSkip + 1 : end);
        [coeffs, expFit, resid, J] = my_exp_fit2(cdata,'Increasing','Single');
        plot(cdata,lstyles{cond,DATA},'Color',cols2(cond,:),'LineWidth',1), hold on;
        htops(cond) = plot(expFit,lstyles{cond,FIT},'Color',cols2(cond,:),'LineWidth',lwidths(cond));
        hold on;
        TAU(gr,cond) = coeffs(3);
    end
    PV = percent_variation(TAU);
    legend('ModFit_{A_1}','ExpFit_{A_1}','ModFit_{A_2}','ExpFit_{A_2}')
    uistack(htops(1), 'top')
    title(gnames{gr})
    text(0.6, 0.1,['PV = ' num2str(PV(gr)*100) '%'],'Units','normalized','FOntSIze',18)
    %            'Data^S','x^S','x_f^S','x_s^S')
    ylim([.6 1])
end

%% 2. A1 vs A2. Compute percent variation for all the states of the model (x, xs, xf)
figure
cmod = 2; nc=2; ns=3;
stridesToSkip = 0;
STATES = cat(4,X,XF,XS);
%colSt = [0 0 0; .7 .7 .7; .3 .3 .3];
colSt = [defaultColors(1:3, :)];

stSt = {'o', '--'; '*','-'}; %Row: A1, A2; Cols: data, fit
TAUST = zeros(ng, nc, ns);
offs=.1;
stSr = {'x','xf','xs'};
inrOrDecr = {'Increasing','Decreasing','Increasing'};
for gr=1:ng
    subplot(1,2,gr)
    for cond=1:2
        ci    = ainds(cond,:); %Current indices
        for state = 1:3
            cdata = STATES(ci,gr,cmod,state);
            cdata = cdata(stridesToSkip + 1 : end);
            [coeffs, expFit, resid, J] = my_exp_fit2(cdata,inrOrDecr{state},'Single');
            plot(cdata,stSt{cond,DATA},'Color',colSt(state,:),'LineWidth',1), hold on;
            htops(cond) = plot(expFit,stSt{cond,FIT},'Color',colSt(state,:),'LineWidth',3);
            hold on;
            TAUST(gr, cond, state) = coeffs(3);
        end
    end
    PVST = squeeze((TAUST(:,2,:) - TAUST(:,1,:))./(TAUST(:,1,:)));
    legend('x^{MOD}_{A_1}','x^{EXP}_{A_1}',...
        'xf^{MOD}_{A_1}','xf^{EXP}_{A_1}',...
        'xs^{MOD}_{A_1}','xs^{EXP}_{A_1}',...
        'x^{MOD}_{A_2}','x^{EXP}_{A_2}',...
        'xf^{MOD}_{A_2}','xf^{EXP}_{A_2}',...
        'xs^{MOD}_{A_2}','xs^{EXP}_{A_2}')
    
    for state=1:3
        text(0.6, 0.6-(state-1)*offs, ['PV_{' stSr{state} '} = ' num2str(PVST(gr,state)*100) ' %'],...
            'Units','normalized','FontSize',18, 'Color',colSt(state,:))
    end
    title(gnames{gr});
    xlim([-4 600])
end

%% After-effects - Pl. Compare Data and Model Fits
cmod = 2;
figure
for gr=1:ng
    ci = aeind;%Current indices
    
    % Data
    plot(adaptations(gr,ci),'o','Color',grcols(gr,:),'LineWidth',1), hold on;
    
    % Model Fits
    htops = plot(X(ci,gr,cmod),'-','Color',grcols(gr,:),'LineWidth',lwidths(cond)); hold on;
    uistack(htops, 'top')

end

legend('Data_{INT}', 'ModFits_{INT}','Data_{SAV}', 'ModFits_{SAV}')
title('AfterEffects')

BICdiff = BICS(1)-BICS(2)


