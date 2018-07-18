%% Barplots of R2

clc
close all
clear all

contr = {'SLA', 'ST', 'SP'};
ncontr=length(contr);

%% Load data
%R2 group, sub, cond
cPath = 'C:\Users\salat\OneDrive\Documents\MATLAB\Research\CoreL\Interference\Interf_study_AS\SaveDataForStata\Stata - Rate Measures\';

SMOOTHING = {'1_EXP','MONOTONIC_FIT', '1_EXP_CONSTR','2_EXP_CONSTR','2_EXP'};
nsm = length(SMOOTHING);

%% Parameters plot
ccol = [0.5 0.5 0.5]; %Bars color
scolor = [.7 .9 .7]; %Individual subject color

%% Main loop
for sm = 1:nsm
    
    ac=cell(1,ncontr);
    R2all = zeros(32,3) ;
    R2all_ca=cell(1,3);
    
    for i=1:3
        load([cPath contr{i} '_smoothed_all_kinds.mat']);
        R2temp = squeeze(R2s(:,:,:,sm)); %Select data relative to the current smoothing
        R2all(:,i) = R2temp(:);
        R2all_ca{i} = R2temp;
    end
    
    
    %% Compute means
    m = mean(R2all,1);
    se = my_se2(R2all,1);
    
    %% Plot data
    % new_fh=plot_bars_with_stderr2([], m, se, []);
    figure('Name',[SMOOTHING{sm} ' - R2 Values'],'NumberTitle','off')
    
    %% Plot bars
    xCenter = [1 2 3];
    hb = bar(xCenter,m);
    hold on
    
    %% Plot errorbars
    errorbar(xCenter, m, se,'k.');
    
    %% Plot individual subject data
    %     add_individual_data_R2()
    positionsOffs = [ -.3, +.15;... %row = group, col = cond.
        -.15, +.3] ;
    grNames = {'I','S'};
    condNames = {'A1', 'A2'};
    
    for i=1:3
        cc = xCenter(i);
        
        for group = 1:2
            for sub = 1:8
                for cond = 1:2
                    x = cc + positionsOffs(group,cond);
                    y = R2all_ca{i}(group, sub, cond);
                    mstring = [grNames{group} num2str(sub) '-' condNames{cond}];
                    hold on
                    text(x,y,mstring,'FontWeight','bold','BackgroundColor',scolor);
                end
            end
        end
        
        
        
        
        
        
        
    end
    
    %% Fancy up
    set(hb,'facecolor',ccol);
    set(gca,'XTickLabel',contr)
    ylabel('R^2')
    ylim([0 1.1])
    
    
end