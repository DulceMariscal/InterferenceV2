%% PLOT ADAPATATION OF COP
clc
close all
clear all

cd('C:\Users\lz17\Documents\MATLAB\Interference_project\Interference subjects\All_subjects')

%% PARAMETERS ANALYSIS--------------------------------------------------
%TO DEFINE--------------------------------------------------------------
gait_par='COPysym_MW';
cop_y_events={'COPy_t1_vec', 'COPy_t12_vec', 'COPy_t2_vec', 'COPy_t23_vec', 'COPy_t3_vec', 'COPy_t34_vec', 'COPy_t4_vec', 'COPy_t45_vec'};
cop_x_events={'COPx_t1_vec', 'COPx_t12_vec', 'COPx_t2_vec', 'COPx_t23_vec', 'COPx_t3_vec', 'COPx_t34_vec', 'COPx_t4_vec', 'COPx_t45_vec'};
cop_events=[cop_x_events cop_y_events];
n_events=length(cop_events);
SUBTRACT_BASELINE=0; %Small differences
MEDIAN_FILTER=0;
baseline_condition='Baseline';
conditions_to_compare={'Adaptation 1','Adaptation 1(2nd time)'};
last_stides_to_ignore=5;
first_strides_to_ignore=5;

% Plot params
stridesToSkip=15;
OFFSET=400;
%DERIVED --------------------------------------------------------------
nconds=length(conditions_to_compare);

%% PARAMETERS EXPERIMENT-----------------------------------------------
%To define-----------------------------------------------------------------
INTERFERENCE=1;
SAVINGS=2;
group_labels={'I00','S00'};
indices_interference=[1 3 4 5];
indices_savings=[1 2 3 4];
labels_interf=create_labels('I',indices_interference);
labels_savings=create_labels('S',indices_savings);
labels_tot={labels_interf,labels_savings};

%Derived-----------------------------------------------------------------
ngr=length(group_labels);
indices_subjects={indices_interference,indices_savings};
nos=cellfun(@length,indices_subjects); %Number of subjects in each group

%% Data structures to store the results--------------------------------

%% CREATE FIGURES------------------------------------------------------
fcop=figure;
% fy=figure;
subplot_offset=0;
outcome_meas_strings={'Recall' ,'Re-learning','Performance','# strides to 0.63*SS','Time constant exp','Time constant exp red','Slope linear fit' };
margins=[0.06,0.06];
%For each group (INTERFERENCE vs SAVINGS)---------------------------------
for group=1:ngr
    ns_cg=nos(group); %Number of subjects in the current group
    ind_sub=indices_subjects(group);
    label_cg=group_labels{group};
    
    if group==2
        subplot_offset=4;
    end
    %For each subject------------------------------------------------------
    for subject=1:ns_cg
        %1.Upload subject data
        subToLoad=indices_subjects{group}(subject);
        string_sub=[label_cg num2str(subToLoad) 'params.mat'];
        load(string_sub);
        
        %2.Remove baseline
        if SUBTRACT_BASELINE
            [adaptData]=adaptData.removeBias(baseline_condition);
        end
        
        %For each condition (A1 vs A2)-------------------------------
        for cond=1:nconds
            %3.Retrieve data
            ccond=conditions_to_compare{cond};%Current condition
            [COPdataX]=adaptData.getParamInCond(cop_x_events,ccond);
            [COPdataY]=adaptData.getParamInCond(cop_y_events,ccond); 
    
            %4.Ignore first and last 5 strides
            COPdataX=COPdataX(first_strides_to_ignore+1:end-last_stides_to_ignore,:);
            COPdataY=COPdataY(first_strides_to_ignore+1:end-last_stides_to_ignore,:);
            nstrides=size(COPdataX,1);
            nevents=size(COPdataX,2);
            strideVec=[1:nstrides]';
            %5. Impute missing data
%             if group==INTERFERENCE & cond==1 & subject==1
%                 cdata=[cdata; normrnd(nanmean(cdata(end-10+1:end)),0.03,150,1)]; %For the first interference subject only 450 strides are reported
%             end

%             [colormap]=flipud(cbrewer('div', 'RdBu', nstrides));
            [colormap]=cbrewer('seq', 'YlOrRd', nstrides);
            ind_subplot = subject + subplot_offset;
            subplot_tight(2,4,ind_subplot,margins)
            if cond==1
                coffs=0;
            else
                coffs=OFFSET;
            end
            for stride=1:15:nstrides
                hold on
                plot(COPdataX(stride,:)-coffs,COPdataY(stride,:),'Color',colormap(stride,:),'LineWidth',3);
            end
            set(gca, 'Xdir', 'reverse'); set(gca, 'Ydir', 'reverse')
%             axis equal
            axis tight
            grid on
            %6. Reshape extracted data to perform filtering
          
%             COPxvec=reshape(COPdataX',nstrides*nevents,1);
%             COPyvec=reshape(COPdataY',nstrides*nevents,1);
%             figure, plot(COPxvec,COPyvec,'-o'), set(gca, 'Xdir', 'reverse'); set(gca, 'Ydir', 'reverse')
%             
            %5.Interpolate outliers and Nan
            
            %5_alternative Identify outliers and nan which will be ignored
            %             cmean=nanmean(cdata); cstd=nanstd(cdata);
            %             outliers_inds=(cdata<cmean-outliers_thr*cstd)|(cdata>cmean+outliers_thr*cstd);
            %             cdata(outliers_inds)=nan;
%             if MEDIAN_FILTER
%                 COPxvec = medfilt1(COPxvec,5);
%                 COPyvec = medfilt1(COPxvec,5);
%             end
%             indnan=isnan(cdata);
            
            %Find extrema for line plot
%             if DECR_EXP
%                 if cond==1
%                     Y_MIN=min(cdata(1:10));
%                 elseif cond==2
%                     Y_MAX=max(cdata(end-10-1:end));
%                 end
%             else
%                 if cond==1
%                     Y_MAX=max(cdata(1:10));
%                 elseif cond==2
%                     Y_MIN=min(cdata(end-10-1:end));
%                 end
%             end
        end
        if ind_subplot==1 || ind_subplot==5
            ylabel('COP_y')
        end
        ind_xlabel=5:8;
        if any(ind_xlabel==ind_subplot)
            xlabel('COP_x')
        end
        title(labels_tot{group}(subject));
    end
end
% cond=1;
% ccond=conditions_to_compare{cond};%Current condition
% [cdata,inds,auxLabel,origTrials]=adaptData.getParamInCond(gait_par,ccond);
%
% %% DATA PLOT
% figure
% plot(cdata)

%% EXTRACT AND PLOT COP DATA-----------------------------------------------
%% HOW TO RESTORE COP SEQUENTIALITY
% ccond=conditions_to_compare{2};
% cop_y_events={'COPy_t1_vec', 'COPy_t12_vec', 'COPy_t2_vec', 'COPy_t23_vec', 'COPy_t3_vec', 'COPy_t34_vec', 'COPy_t4_vec', 'COPy_t45_vec'};
% cop_x_events={'COPx_t1_vec', 'COPx_t12_vec', 'COPx_t2_vec', 'COPx_t23_vec', 'COPx_t3_vec', 'COPx_t34_vec', 'COPx_t4_vec', 'COPx_t45_vec'};
% cop_events=[cop_x_events cop_y_events];
% n_events=length(cop_events);
% [COPdataX]=adaptData.getParamInCond(cop_x_events,ccond);
% [COPdataY]=adaptData.getParamInCond(cop_y_events,ccond);
% COPxvec=reshape(COPdataX',size(COPdataX,1)*size(COPdataX,2),1);
% COPyvec=reshape(COPdataY',size(COPdataY,1)*size(COPdataY,2),1);
% figure, plot(COPxvec,COPyvec,'-o'), set(gca, 'Xdir', 'reverse'); set(gca, 'Ydir', 'reverse')

% COP X
% COPx= [COPx_t1_vec', COPx_t12_vec', COPx_t2_vec',COPx_t23_vec', COPx_t3_vec', COPx_t34_vec' ,COPx_t4_vec',COPx_t45_vec'];
% COPx_sq=reshape(COPx',size(COPx,1)*size(COPx,2),1);
% % COP Y
% COPy= [COPy_t1_vec', COPy_t12_vec', COPy_t2_vec',COPy_t23_vec', COPy_t3_vec', COPy_t34_vec' ,COPy_t4_vec',COPy_t45_vec'];
% COPy_sq=reshape(COPy',size(COPy,1)*size(COPy,2),1);
% figure, plot(COPx_sq(9:17),COPy_sq(9:17),'-o'), set(gca, 'Xdir', 'reverse'); set(gca, 'Ydir', 'reverse')
% figure, plot(COPx',COPy','-o'), set(gca, 'Xdir', 'reverse'); set(gca, 'Ydir', 'reverse')
