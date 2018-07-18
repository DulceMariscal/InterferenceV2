clc
close all
clear all

my_set_default(20,3,10)

%% bLoad data
ppath='C:\Users\salat\OneDrive\Documents\MATLAB\Research\CoreL\Interference\Interf_study_AS\Figures SFN poster\Scripts\';
% tpath=[ppath 'DataForRegressionsA1.mat'];
tpath=[ppath 'DataForRegressionsDIFF.mat']; %A2-A1

load(tpath);

%% Select x and y
% xstr  = 'Height';
% xstr = 'STD_FIN';
xstr = 'STD_PERC_VAR';
% ystr = 'SLA_A1_1';
ystr = 'PERC_REC_VAR';


%% Extract x and y
[x, y] = extractXandY(mat_table, var_names, xstr, ystr);
EXCLUDE_OUTLIERS = 1 ;

if EXCLUDE_OUTLIERS
    %% Exclude outliers
    allInds = 1:16;
    XLIM = [-1 1];
    YLIM = [-.4 1];
    for i = 1:3
        [x, y] = extractXandY(mat_table, var_names, xstr, ystr);
        if i==1
            toExclude = [];
        elseif i==2
            toExclude = [4];
        elseif i==3
            toExclude = [4 15];
        end
        indOk = setdiff(allInds,toExclude);
        
        x = x(indOk);
        y = y(indOk);
        
        if strcmp(ystr, 'PERC_REC_VAR');
            y = -y; %This is so that this parameter keeps the same sign as the (unnormalized) difference A2-A1
        end
        
        %% Plot regression
        subplot(1,3,i)
        compute_and_plot_regression_line(x,y,'Baseline Variability - % Increase','Amt of Pert - % Reduction')
        title(['Subjects excluded = ' num2str(length(toExclude))])
        
%         if i==1
%             XLIM = xlim();
%             YLIM = ylim();
%         else
            xlim(XLIM);
            ylim(YLIM);
%         end
    end
else
    %Plot regression
    compute_and_plot_regression_line(x,y,xstr,ystr)
    
end
%% Store the figure
ppath2=['C:\Users\salat\OneDrive\Documents\MATLAB\Research\CoreL\Interference\Interf_study_AS\Figures SFN poster\'];
name = [xstr ' VS ' ystr];
figName = [ppath2 name];
my_print_figures([], gcf, figName, [], 1);
