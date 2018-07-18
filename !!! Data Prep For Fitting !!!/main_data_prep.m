clc
close all
clear all

%% Parameters
pathToData = 'C:\Users\salat\OneDrive\Documents\MATLAB\Research\CoreL\Interference\Interf_study_AS\subjectsData';
groups = 2;
conditions = 2;
subs = 8;
indSubs = {setdiff(1:9, 2), 1:8};
charGroups = {'I','S'};
aec = cell(groups, subs); %Will contain aftereffects
aeName = 'Washout';
gaitPar = 'stepLengthAsym';
wSize = 5;
woSizes = zeros(groups,subs);
REMOVE_BASELINE = 1;
INT=1; SAV=2;
colors = distinguishable_colors(15);

%% Main loop
figure
for gr = 1:groups
    for sub = 1:subs
        
        if gr==2 && sub==5 %For this subjects we did not record the aftereffects
            aec{gr, sub} = nan(150,1);
            
        else
            
            %% Load the data
            cname = [charGroups{gr} '00' num2str(indSubs{gr}(sub)) 'params.mat'];
            load(cname);
            
            %% Remove baseline
            if REMOVE_BASELINE
                if (indSubs{gr}(sub) <= 5)
                    baseline_cond='Baseline';
                else
                    baseline_cond='TM base';
                end
                [adaptData]=adaptData.removeBias(baseline_cond);
            end
            
            %% Extract after-effects
            ae = adaptData.getParamInCond(gaitPar, aeName);
            
            %% Filter
            ae = medfilt1(ae,wSize);
            firstSamples = ae(1:wSize-1);
            ae = tsmovavg(ae,'s',wSize,1);
            ae(1:wSize-1) = firstSamples;
            
            %% Store after-effects
            aec{gr,sub} = ae;
            woSizes(gr,sub) = length(ae);
            
            hold on
            if gr == 1
                plot(ae,'r','Linewidth',1)
            else
                plot(ae,'b','Linewidth',1)
            end
        end
    end
end

%% Average accross subjects
[mI, seI ] = average_ca(aec(INT,:));
[mS, seS ] = average_ca(aec(SAV,:));
avgDiffs = [mI; mS]; seDiffs = [seI; seS];

%% Plot averages
% figure
% plot(mS)
% hold on
% plot(mI)
% hold on
x = [1:150];
h = boundedline(x,avgDiffs(INT,:),seDiffs(INT,:),'r',x,avgDiffs(SAV,:),seDiffs(SAV,:),'b');
title('After-effects')
legend(h, 'Interference','Savings')


