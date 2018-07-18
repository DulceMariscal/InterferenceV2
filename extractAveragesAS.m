clc
close all
clear all

%% Parameters
% pathToData = 'C:\Users\salat\OneDrive\Documents\MATLAB\Research\CoreL\Interference\Interf_study_AS\subjectsData';
groups = 2;
conditions = 2;
subs = [8 9];
indSubs = {setdiff(1:9, 2), 1:9};
charGroups = {'I','S'};
gaitPar = 'stepLengthAsym';
wSize = 5;
% woSizes = zeros(groups,subs);
REMOVE_BASELINE = 1;
colors = distinguishable_colors(15);
nconds = [6 5];
INT=1; SAV=2;
slaS = cell(subs(SAV), nconds(SAV)); % 5 conditions in total
slaI = cell(subs(INT), nconds(INT)); % 6 conditions in total
stridesPerCond = {[150 600 600 750 600 150], [150 600 1350 600 150]};
slam = nan(groups, subs(2), sum(stridesPerCond{1}) ) ; %Each element is a matrix

indMatS = zeros(nconds(SAV),2); %Start and stop of each condition
indMatI = zeros(nconds(INT),2); %Start and stop of each condition

%% Main loop
figure
for gr = 1:groups
    for sub = 1:subs(gr)
        %% Load the data
        cname = [charGroups{gr} '00' num2str(indSubs{gr}(sub)) 'params.mat'];
        load(cname);
        
        %% Remove baseline
%         if REMOVE_BASELINE
%             if (indSubs{gr}(sub) <= 5)
%                 baseline_cond='Baseline';
%             else
%                 baseline_cond='TM base';
%             end
            [adaptData]=adaptData.removeBias;
%         end
        
        %% Get all conditions' names
        conditions = adaptData.metaData.conditionName;
        
        %% Extract all epochs
        for cond=1:nconds(gr)
            %             if gr==2 && sub==5 && cond==5
            %                 adaptData.getParamInCond(gaitPar, conditions{cond})
            %             end
            %% Extract current condition
            if (strcmp(adaptData.subData.ID,'I001') || strcmp(adaptData.subData.ID,'I008')) && cond==2
                load(['abrupt_A1_' adaptData.subData.ID '.mat'])
                cc = a1;
                warning(['Group = ' num2str(gr) ', Sub = ' num2str(sub) ', Cond = ' conditions{cond} ...
                    ' These data required further processing ']);
            else
                cc = adaptData.getParamInCond(gaitPar, conditions{cond});
            end
            cl = length(cc);
            cflag = (sum(isnan(cc)) >= 0.5*cl) || cl < 100; %Bad subjects
            if cflag == 1
                cc = [];
                warning(['Group = ' num2str(gr) ', Sub = ' num2str(sub) ', Cond = ' conditions{cond} ...
                    ' has been discarded because it contains more than 50% of nans ']);
            else
                %% Filter
                cc = medfilt1(cc,wSize);
                firstSamples = cc(1:wSize-1);
                cc = tsmovavg(cc,'s',wSize,1);
                cc(1:wSize-1) = firstSamples;
            end
            
            %% Store current condition
            if cond == 1
                indStart = 1;
            else
                indStart = indStop + 1;
                %indStart = stridesPerCond{gr}(cond-1) + 1;
            end
            indStop  =  indStart + stridesPerCond{gr}(cond) - 1;
            
            if gr == INT
                slaI{sub,cond} = cc;                %Store in ca
                indMatI(cond,:) = [indStart indStop];
            else
                slaS{sub,cond} = cc;
                indMatS(cond,:) = [indStart indStop];
            end
%             slam(gr,sub,indStart:indStop) = mynanPad(cc, stridesPerCond{gr}(cond)); %Store in a matrix
            %             woSizes(gr,sub) = length(cc);
            
            %             hold on
            %             if gr == 1
            %                 plot(cc,'r','Linewidth',1)
            %             else
            %                 plot(cc,'b','Linewidth',1)
            %             end
        end
    end
end
%%
slamavg = squeeze(nanmean(slam,2)); %Average across subjects
slamse  = nanse(slam,2);
x=1:2850;

%% Plot averages
% figure
% plot(mS)
% hold on
% plot(mI)
% hold on
figure
h = boundedline(x,slamavg(INT,:),slamse(INT,:),'r',x,slamavg(SAV,:),slamse(SAV,:),'b');
title('Whole Exp Adaptation')
legend(h, 'Interference','Savings')
axis tight
save(['SalatielloAllData'],'slaS','slaI' )
%% Save data for fitting
pertS = [ zeros(1,150) ones(1,600) zeros(1,1350) ones(1,600) zeros(1,150)];
pertI = [ zeros(1,150) ones(1,600) (-1)*ones(1,600) linspace(-1,0,600) zeros(1,150) ones(1,600) zeros(1,150)];
perturbations = [pertI; pertS];



adaptations = perturbations + slamavg;
figure, subplot(2,1,1), plot(adaptation(1,:)), hold on, plot(perturbations(1,:))
        subplot(2,1,2), plot(adaptation(2,:)), hold on, plot(perturbations(2,:))
        
%Cocatenated vectors
adaptation = adaptations(:);
perturbation = perturbations(:);

save('Data/DataForFitting.mat','adaptations','slamavg','slamse','perturbations','INT','SAV',...
    'adaptation','perturbation')

%Note: Plural forms are matrices. Singular forms are vectors

