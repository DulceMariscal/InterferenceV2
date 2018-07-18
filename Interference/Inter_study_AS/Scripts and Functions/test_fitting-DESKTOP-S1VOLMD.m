%% PREPROCESS AND EXTRACT RELEVANT DATA
STORE_DATA=0;

%Initialize variables and structures
Initializations_test_fitting %Here the parameter to consider is defined
ind_bas_data=1;
noise_info=zeros(2,8,2,6);

%For each group (INTERFERENCE (1) vs SAVINGS(2))----------------------------------
for group=1:ngr
    ns_cg=nos(group); %Number of subjects in the current group
    ind_sub=indices_subjects{group};
    label_cg=group_labels{group};
    
    if group==2
        subplot_offset=8;
    end
    %For each subject------------------------------------------------------
    for subject=1:ns_cg
        
        %0. Determine baseline condition
        if ( (group==1) && (ind_sub(subject)<=5)) || ((group==2) && (ind_sub(subject)<=5))
            baseline_cond='Baseline';
        else
            baseline_cond='TM base';
        end
        
        %1.Upload subject data
        subToLoad=indices_subjects{group}(subject);
        
        if group==1 && subToLoad==7 %TODO: IGNORE AT LEAST 5 STRIDES OR MORE UNTILE SLA STARTS INCREASING
            first_strides_to_ignore=20;
        else
            first_strides_to_ignore=5;
        end
        %         first_strides_to_ignore=0;
        
        string_sub=[label_cg num2str(subToLoad) 'params.mat'];
        
        load([dataFolder string_sub]);
        
        % load('C:\Users\ALS414\Documents\MATLAB\Pilot\S2\I1params.mat')
        % load('C:\Users\ALS414\Documents\MATLAB\MatlabFunctionExchangeApril6\Interf_study_AS\S007params.mat')
        
        %1'. Extract and store baseline condition without any further
        %processing
        [bas_data]=adaptData.getParamInCond('stepLengthAsym',baseline_cond);
        BASELINE_DATA{ind_bas_data}=bas_data;
        ind_bas_data=ind_bas_data+1;
        
        %2.Remove baseline
        if SUBTRACT_BASELINE
            [adaptData]=adaptData.removeBias(baseline_cond);
            %              [adaptData]=adaptData.emoveBias();
        end
        
        %For each condition (A1 vs A2)
        for cond=1:nconds
            if group==1 && subToLoad==8 && cond==1
                first_strides_to_ignore=0;
            end
            %3.Retrieve data
            ccond=conditions_to_compare{cond};%Current condition
            
            if strcmpi(gait_par,'SLA-Adaptation')
                gait_par_upload='stepLengthAsym';
                TRANSLATE_FLAG=1;
            else
                gait_par_upload=gait_par;
            end
            
            %Get adaptation data
            [cdata,inds,auxLabel,origTrials]=adaptData.getParamInCond(gait_par_upload,ccond);
            
            
            if TRANSLATE_FLAG
                cdata = cdata + 1;
            end
            
            if subToLoad==2 && cond==1 && group==1
                garb(1)=mean(cdata(1:3));
            end
            if subToLoad==2 && cond==2 && group==1
                garb(2)=mean(cdata(1:3));
            end
            
            %4.Ignore fixed number of strides first and last 5 strides
            if (ADAPTIVE_FIRST_STRIDES_REMOVAL==0) %Does not do this when such flag is 1
                cdata=cdata(first_strides_to_ignore+1:end-last_stides_to_ignore);
            end
            
            if group==INTERFERENCE & cond==1 & subToLoad==1
                cdata=[cdata; normrnd(nanmean(cdata(end-10+1:end)),0.03,150,1)]; %For the first interference subject only 450 strides are reported
            end
            
            
            
            %5.Interpolate outliers and Nan
            
            %5_alternative Identify outliers and nan which will be ignored
            %             cmean=nanmean(cdata); cstd=nanstd(cdata);
            %             outliers_inds=(cdata<cmean-outliers_thr*cstd)|(cdata>cmean+outliers_thr*cstd);
            %             cdata(outliers_inds)=nan;
            if MEDIAN_FILTER
                cdata = medfilt1(cdata,wSize);
            end
            if RUNNING_AVERAGE
                firstSamples=cdata(1:wSize-1);
                cdata = tsmovavg(cdata,'s',wSize,1);
                cdata(1:wSize-1)=firstSamples;
            end
            
            %ADAPTIVE DISMISSAL OF INITIAL STRIDES
            if (ADAPTIVE_FIRST_STRIDES_REMOVAL)
                %                 index_first_point = find_strides_to_ignore(cdata,NUM_COND,INCR_EXP);
                index_first_point=minNOSToRemove(group,subject); %Use precomputed value, the same for both A1 and A2
                %                 index_first_point=max(minNOSToRemove(:));
                cdata=cdata(index_first_point:end-last_stides_to_ignore);
            end
            %             ifp(group,cond,subject)=index_first_point;
            indnan=isnan(cdata);
            %Find extrema for line plot
            if INCR_EXP
                if cond==1
                    Y_MIN=min(cdata(1:10));
                elseif cond==2
                    Y_MAX=max(cdata(end-10-1:end));
                end
            else
                if cond==1
                    Y_MAX=max(cdata(1:10));
                elseif cond==2
                    Y_MIN=min(cdata(end-10-1:end));
                end
            end
            
            nstrides_trial=length(cdata);
            % Set data I008
            if group==1 && subToLoad==8 && cond==1 %Estimate missing data (they are interpolated with a regression line based on other subjects)
                [cdata,indnan,strideVec]=fixI008(cdata,initialPertI008_A1_alt,LOST_STRIDES_S8,INCR_EXP);
                nstrides_trial=length(cdata);
            else
                strideVec=[1:nstrides_trial]';
            end
            
            
            % cdata
            % fitdata
            % indnan
            
            
            %6. Fitting
            %6.1 Fit exponential to the whole data
            if FIT_MODEL==SINGLE_EXP
                [coeffs,~,resid,~,~,~,J] = lsqcurvefit(my_exp,x0,strideVec(~indnan),cdata(~indnan),lb,ub);
                
                %                 if group==1 && subToLoad==8 && cond==1 %Estimate missing data
                %                     cdata=[nan(LOST_STRIDES_S8,1); cdata]';
                %                     strideVecFit=[linspace(-LOST_STRIDES_S8+1,0,LOST_STRIDES_S8)'; strideVec];
                %                     cdata(1)=-0.3433;
                %                     dataFit=my_exp(coeffs,strideVecFit);
                %                     indnan=isnan(cdata);
                %                     nstrides_trial=nstrides_trial+LOST_STRIDES_S8;
                %                     strideVec=1:nstrides_trial;
                %                 else
                dataFit=my_exp(coeffs,strideVec);
                %                 end
                
                ci = nlparci(coeffs,resid,'jacobian',J);
                modelName='Single Exp';
                R2adj=rsquared(cdata(~indnan),resid,3,1);
                R2adj_all_models=[];
            elseif  FIT_MODEL==DOUBLE_EXP
                [coeffs,~,resid,~,~,~,J] = lsqcurvefit(my_double_exp,x0,strideVec(~indnan),cdata(~indnan),lb,ub);
                dataFit=my_exp(coeffs,strideVec);
                ci = nlparci(coeffs,resid,'jacobian',J);
                modelName='Double Exp';
                R2adj=rsquared(cdata(~indnan),resid,5,1);
                R2adj_all_models=[]; ci=[];
            elseif FIT_MODEL==MONOTONIC_FIT
                dataFit= monoLS(cdata(~indnan),[],ldc,2);
                dataFit_temp=cdata; dataFit_temp(~indnan)=dataFit; dataFit=nan_interp(dataFit_temp,[]);
                coeffs=zeros(1,3); ci=zeros(3,2);
                modelName='Monotonic';
                R2adj=[]; R2adj_all_models=[]; ci=[];
                %                 strideVec=strideVec(~indnan); %TODO: Is this ok???? %% In order to have a fit value also where nans are, copy vector and interpolate!
            elseif FIT_MODEL==ADAPTIVE_FIT
                
                %                 if group==1 && subToLoad==8 && cond==1
                %                     x0 = [1 -0.5 20]; %Initial parameters exponential fitting
                %                     if (INCR_EXP) %1-exp(-a*t)
                %                         lb = [-10^10,  -10^10,     1  ]; %Imposing that the time constant cannot be bigger than 200, we have estimates with smaller confidence intervals and significant differences between groups
                %                         ub = [+10^10,     0,       10^10];
                %                     else          %exp(-a*t)
                %                         lb = [-10^10,         0,         1  ];
                %                         ub = [+10^10,     10^10,       10^10];
                %                     end
                %                     [coeffs,~,resid,~,~,~,J] = lsqcurvefit(my_exp,x0,strideVec(~indnan),cdata(~indnan),lb,ub);
                %                     cdata=[nan(LOST_STRIDES_S8,1); cdata]';
                %                     nstrides_trial=nstrides_trial+LOST_STRIDES_S8;
                %                     strideVec=1:nstrides_trial;
                %                     dataFit=my_exp(coeffs,strideVec);
                %                     indnan=isnan(cdata);
                %                 else
                [dataFit, coeffs, R2adj, ci, modelName, R2adj_all_models] = my_best_fit(strideVec,cdata,indnan);
                %                 end
                
            end
            
            der_dataFit=diff(dataFit); %Proportional to the first derivative
            %6.2 Fit model to the first strides
            %             ind_reduced_exp_fit= setdiff([first_strides_to_ignore + 1: ind_last_exp_fit],indnan);
            ind_reduced_fit=setdiff([1:ind_last_exp_fit],find(indnan));
            if FIT_MODEL==SINGLE_EXP
                coeffs_red = lsqcurvefit(my_exp,x0,strideVec(ind_reduced_fit),cdata(ind_reduced_fit),lb,ub);
                dataFitRed=my_exp(coeffs_red,strideVec(ind_reduced_fit));
                modelName_red='Single Exp';
            elseif  FIT_MODEL==DOUBLE_EXP
                coeffs_red = lsqcurvefit(my_double_exp,x0,strideVec(ind_reduced_fit),cdata(ind_reduced_fit),lb,ub);
                dataFitRed=my_exp(coeffs_red,strideVec(ind_reduced_fit));
                modelName_red='Double Exp';
            elseif FIT_MODEL==MONOTONIC_FIT
                dataFitRed= monoLS(cdata(ind_reduced_fit),[],ldc,2);
                coeffs_red=zeros(1,3);
                modelName_red='Monotonic';
            elseif FIT_MODEL==ADAPTIVE_FIT
                [dataFitRed, coeffs_red, R2adj_red, ci_red, modelName_red]  = my_best_fit(strideVec(ind_reduced_fit),cdata(ind_reduced_fit),~ind_reduced_fit);
            end
            % coeffs_exp_red = lsqcurvefit(my_exp,x0,strideVec(ind_reduced_exp_fit),cdata(ind_reduced_exp_fit),lb,ub);
            
            %6.3 Fit line to the first strides
            ind_reduced_lin_fit=setdiff([1:ind_last_lin_fit],find(indnan));
            coeffs_lin_red = lsqcurvefit(my_line,[0 0],strideVec(ind_reduced_lin_fit),cdata(ind_reduced_lin_fit));
            
            %6B. Fit two state model (The main code is currently commented)
            %2nd version. x0 not known
            perturbation=ones(size(strideVec(~indnan)));
            %[k_ext_min]=fminsearch(@two_state_lsq_noIC,k0_ext,[],strideVec(~indnan),cdata(~indnan)+perturbation,cdata(~indnan));
            k_ext_min=[];
            %6C. Plot two state model
            figure(f5);
            ind_subplot=subplot_offset + subject;
            hold on
            subplot_tight(2,4,ind_subplot,margins)
            plot(strideVec(~indnan),cdata(~indnan)+perturbation,[mycolors{cond,1} 'o'])
            hold on
            %plot_two_state_model(f5,k_ext_min,strideVec(~indnan),cdata(~indnan));
            grid on
            
            if ind_subplot==1 || ind_subplot==5
                ylabel(gait_par)
            end
            %             ind_xlabel=5:8;
            ind_xlabel=9:16;
            
            if any(ind_xlabel==ind_subplot)
                xlabel('Strides');
            end
            
            xlim(ZOOM_ON_FIRST);
            %             title(labels_tot{group}(subject));
            
            
            %7. Other Plots
            %7.1 Plot exp fit and data
            figure(f1);
            ind_subplot=subplot_offset + subject;
            hold on
            subplot_tight(2,8,ind_subplot,margins)
            plot(strideVec(~indnan),cdata(~indnan),[mycolors{cond,1} 'o'])
            
            noise_info(group,subject,cond,:) = is_bad_subject(cdata,subject);
            
            hold on
            plot(strideVec,dataFit,[mycolors{cond,2}],'lineWidth',3) %TODO: MAKE ADAPTIVE FIT, FIT ALL THE DATA, NOT ONLY NAN
            grid on
            
            %Highlight first point that woul dbe cosidered if
            %find_strides_to_ignore is used
            %hold on
            %plot(index_first_point,cdata(index_first_point),'m*','MarkerSize',3);
            
            if ind_subplot==1 || ind_subplot==8
                ylabel(gait_par)
            end
            ind_xlabel=9:16;
            if any(ind_xlabel==ind_subplot)
                xlabel('Strides');
            end
            
            xlim(ZOOM_ON_FIRST);
            %             title(labels_tot{group}(subject));
            
            %7.2 Plot reduced exp fit, linear fit and data
            figure(f2);
            ind_subplot=subplot_offset + subject;
            hold on
            subplot_tight(2,4,ind_subplot,margins)
            plot(strideVec(ind_reduced_fit),cdata(ind_reduced_fit),[mycolors{cond,1},'o']) %To plot only the data to which the model has been fit
            %           plot(strideVec(~indnan),cdata(~indnan),[mycolors{cond,1} 'o'])
            hold on
            plot(strideVec(ind_reduced_fit),dataFitRed,[mycolors{cond,2}],'lineWidth',3)
            hold on
            plot(strideVec(ind_reduced_lin_fit),my_line(coeffs_lin_red,strideVec(ind_reduced_lin_fit)),[mycolors{cond,3}],'lineWidth',3)
            grid on
            
            if ind_subplot==1 || ind_subplot==5
                ylabel(gait_par)
            end
            ind_xlabel=9:16;
            if any(ind_xlabel==ind_subplot)
                xlabel('Strides');
            end
            
            title(labels_tot{group}(subject));
            
            
            %9.Store data-------------------------------------------------
            if group==INTERFERENCE
                %Filtered data
                INTERFERENCE_DATA{cond,subject}=cdata;
                INTERFERENCE_FIT_DATA{cond,subject,1} = dataFit; %my_exp(coeffs,strideVec);
                INTERFERENCE_FIT_DATA{cond,subject,2} = der_dataFit; %my_exp(coeffs,strideVec);
                %                 CI_INT(cond,subject,:,:)=ci;
            else
                %Filtered data
                SAVINGS_DATA{cond,subject}=cdata;
                SAVINGS_FIT_DATA{cond,subject,1}= dataFit; %my_exp(coeffs,strideVec);
                SAVINGS_FIT_DATA{cond,subject,2} = der_dataFit; %my_exp(coeffs,strideVec);
                %                 CI_SAV(cond,subject,:,:)=ci;
            end
            
            %Parameters exponential model
            %             PARAMETERS_ALL{group}(cond,C1,subject)=coeffs(1);
            %             PARAMETERS_ALL{group}(cond,C2,subject)=coeffs(2);
            %
            %             PARAMETERS_ALL{group}(cond,C3,subject)=coeffs(3); %Time constants!
            %             PARAMETERS_ALL{group}(cond,SLOPE,subject)=-coeffs(2)/coeffs(3);
            
            %Parameters reduced exponential model
            %             PARAMETERS_ALL{group}(cond,C1r,subject)=coeffs_exp_red(1);
            %             PARAMETERS_ALL{group}(cond,C2r,subject)=coeffs_exp_red(2);
            %             PARAMETERS_ALL{group}(cond,C3r,subject)=coeffs_exp_red(3);
            
            %Parameters reduced linear model
            %             PARAMETERS_ALL{group}(cond,A,subject)=coeffs_lin_red(1);
            %             PARAMETERS_ALL{group}(cond,B,subject)=coeffs_lin_red(2);
            
            %Data averages
            PARAMETERS_ALL{group}(cond,FIRST_STRIDE,subject)=cdata(ind_pert);  %OK version
            %                 PARAMETERS_INTERFERENCE(cond,FIRST_STRIDE,subject)=nanmean(cdata(1:3)); % Old version
            
            PARAMETERS_ALL{group}(cond,EARLY_CHANGE,subject)=nanmean(cdata(ind_relearning));
            %Number of strides to reach "ss_perc" of steady state value
            steady_state_val=nanmean(cdata(end-ind_perf+1:end));
            %                 figure,plot([1:30]',cdata(end-ind_perf+1:end),[1:30]',ones(30,1)*nanmean(cdata(end-ind_perf+1:end)));
            PARAMETERS_ALL{group}(cond,PLATEAU,subject)=steady_state_val;
            nstrides=find_nstrides_to_perc_ss(cdata,steady_state_val,ss_perc,INCR_EXP,ncons);
            PARAMETERS_ALL{group}(cond,NSTRIDES,subject)=nstrides;
            [nstrides_trend, ytrend] = find_nstrides_trend(cdata,'linear',FIRST_SAMPLES,[],ss_perc,INCR_EXP,ncons,ind_perf);
            PARAMETERS_ALL{group}(cond,NSTRIDES_TREND,subject)=nstrides_trend;
            %             PARAMETERS_ALL{group}(cond,LR,subject)=1/coeffs(3);
            
            %Report parameters
            PARAMETERS_ALL{group}(cond,RECALL_data,subject) = nanmean(cdata(1:LAST_STRIDE_REC));
            PARAMETERS_ALL{group}(cond,PERFORMANCE_data,subject) = steady_state_val;
            PARAMETERS_ALL{group}(cond,SLOPE_data,subject) = (cdata(LAST_STRIDE_SLOPE) - cdata(1))/(LAST_STRIDE_SLOPE - 1);
            current_recall_fit=nanmean(dataFit(1:LAST_STRIDE_REC));
            PARAMETERS_ALL{group}(cond,RECALL_fit,subject)= current_recall_fit;
            current_performance_fit=nanmean(dataFit(end-ind_perf+1:end));
            PARAMETERS_ALL{group}(cond,PERFORMANCE_fit,subject) = current_performance_fit;
            PARAMETERS_ALL{group}(cond,SLOPE_fit,subject) = (dataFit(LAST_STRIDE_SLOPE) - dataFit(1))/(LAST_STRIDE_SLOPE -  1);
            %thr_val=current_recall_fit * PERC_STRIDES_TO_HALVE; %It makes
            %more sense to consider the fist value of the fit instead of
            %the average of the first strides
            %                 thr_val=0.5*(current_recall_fit + current_performance_fit);
            thr_val=0.5*(dataFit(1) + dataFit(end));
            %                   thr_val=0.3*dataFit(1);
            if INCR_EXP
                PARAMETERS_ALL{group}(cond,STRIDES_TO_HALVE,subject) = find(dataFit >= thr_val, 1);
            else
                PARAMETERS_ALL{group}(cond,STRIDES_TO_HALVE,subject) = find(dataFit <= thr_val, 1);
            end
            STRIDES_TO_PERCENTAGE{group}(cond,:,subject)=find_nstrides_to_perc(dataFit,percentages,INCR_EXP);
            
            
            PARAMETERS_ALL{group}(cond,AVERAGE_RATE_FIT,subject) = nanmean(der_dataFit(1:LAST_STRIDE_DERIVATIVE));
            
            %Store parameters fitting
            FITTING_STRUCTS{group}(cond,subject).selectedModel=modelName;
            FITTING_STRUCTS{group}(cond,subject).coefficients=coeffs;
            FITTING_STRUCTS{group}(cond,subject).R2_adj=R2adj;
            FITTING_STRUCTS{group}(cond,subject).ci=ci;
            FITTING_STRUCTS{group}(cond,subject).R2_adj_all_models=R2adj_all_models;
            %Store parameters reduced fitting
            FITTING_STRUCTS_RED_EXP{group}(cond,subject).selectedModel=modelName_red;
            FITTING_STRUCTS_RED_EXP{group}(cond,subject).coefficients=coeffs_red;
            
            %Store parameters reduced line fitting
            FITTING_STRUCTS_RED_LIN{group}(cond,subject).coefficients=coeffs_lin_red;
            
            
            
            %Plot data + trend (fit + derivative)---------------------------------------------
            figure(f3)
            hold on
            subplot_tight(2,4,ind_subplot,margins)
            %             plot(strideVec(~indnan),cdata(~indnan),[mycolors{cond,1} 'o'])
            %             plot(strideVec,dataFit,[mycolors{cond,1} '-'],'lineWidth',2)
            hold on
            %             plot(strideVec,ytrend,[mycolors{cond,2}],'lineWidth',3)
            plot(strideVec(1:end-1),der_dataFit,[mycolors{cond,2}],'lineWidth',2)
            hold on
            plot(strideVec(1:LAST_STRIDE_DERIVATIVE),PARAMETERS_ALL{group}(cond,AVERAGE_RATE_FIT,subject)*ones(1,LAST_STRIDE_DERIVATIVE),[mycolors{cond,2} 'o'],'lineWidth',2);
            grid on
            
            if ind_subplot==1 || ind_subplot==9
                ylabel(gait_par)
            end
            ind_xlabel=9:16;
            if any(ind_xlabel==ind_subplot)
                xlabel('Strides');
            end
            xlim(ZOOM_ON_FIRST);
            axis tight
            
            
            %Display confidence interval data
            %             if FIT_MODEL ~= MONOTONIC_FIT
            if FIT_MODEL == SINGLE_EXP
                
                figure(f4)
                sph=subplot_tight(2,4,ind_subplot,[0.01 0.01]);
                pos = get(sph,'Position'); un = get(sph,'Units'); %delete(sph);
                
                dev = [diff(ci')/2]';
                estim = ci(:,2) - dev;
                tableData(1:2:end)=estim'; tableData(2:2:end)=dev';
                cellTableData=con2seq(tableData);
                cellTableData=cellfun(@(x) sprintf('%.2f',x), cellTableData, 'UniformOutput', false);
                if cond==1
                    if FIT_MODEL==SINGLE_EXP
                        t=uitable('Data',cellTableData, 'ColumnName', {'A', 'A_{dev}','B','B_{dev}','TAU','TAU_{dev}'},'Units',un, 'Position', pos);
                        set(t,'ColumnWidth',{70},'FontSize',12,'RowName',{'A1','A2'});
                    elseif FIT_MODEL==DOUBLE_EXP
                        t=uitable('Data',cellTableData, 'ColumnName', {'A', 'A_{dev}','B_{1}','B_{1}_{dev}','TAU_1','TAU_1_{dev}','B_{2}_{dev}','TAU_2','TAU_2_{dev}'},'Units',un, 'Position', pos);
                        set(t,'ColumnWidth',{60},'FontSize',12,'RowName',{'A1','A2'});
                    end
                else
                    oldData = get(t,'Data');
                    newData = [oldData; cellTableData];
                    set(t,'Data',newData)
                end
            end
            
        end
        
        %9 Add lines
        if PLOT_LINES
            for cond=1:nconds
                figure(f1)
                nstrides = PARAMETERS_ALL{group}(cond,STRIDES_TO_HALVE,subject);
                subplot_tight(2,8,ind_subplot,margins)
                line([nstrides nstrides],[Y_MIN Y_MAX],'Color',[mycolors{cond,1}],'LineWidth',2,'LineStyle','--');
                
                figure(f3)
                %                 nstridest=PARAMETERS_ALL{group}(cond,NSTRIDES_TREND,subject);
                %                 subplot_tight(2,4,ind_subplot,margins)
                %                 line([nstridest nstridest],[Y_MIN Y_MAX],'Color',[mycolors{cond,2}],'LineWidth',2,'LineStyle','--');
            end
        end
        %
        %10.1 Add legends and titles
        figure(f1)
        %         legend('Adap_{data}','Adapt_{fit}','Re-adapt_{data}','Re-adapt_{fit}');
        title([labels_tot{group}{subject} ' | A1 fit = ' FITTING_STRUCTS{group}(1,subject).selectedModel ...
            ' | A2 fit = ' FITTING_STRUCTS{group}(2,subject).selectedModel  ]...
            ,'FontSize', 8);
        if subject==1 && group==1
            legend('A1','A1_{fit}','A2','A2_{fit}','A1_{#str}','A2_{#str}'); %Add legend only for first subject
        end
        firstFit = findobj(gca, 'Color', 'g');
        uistack(firstFit, 'top')
        
        %10.1 Add legends (reduced plot)
        figure(f2)
        %         legend('Adap_{data}','Adapt_{exp fit}','Adapt_{lin fit}','Re-adapt_{data}','Re-adapt_{exp fit}','Re-adapt_{lin fit}');
        if subject==1 && group==1
            legend('A1','A1_{exp fit}','A1_{lin fit}','A2','A2_{exp fit}','A2_{lin fit}');
        end
        firstFit = findobj(gca, 'Color', 'g');
        uistack(firstFit, 'top')
        
        figure(f3)
        title([labels_tot{group}{subject}]);
        legend('dA1/dt','avg(dA1/dt)','dA2/dt','avg(dA2/dt)')
        
        %Fill regression matrix
        BMI=getbmi(adaptData.subData.weight,adaptData.subData.height);
        PERC_REC_VAR= (PARAMETERS_ALL{group}(2,FIRST_STRIDE,subject) - PARAMETERS_ALL{group}(1,FIRST_STRIDE,subject))/PARAMETERS_ALL{group}(1,FIRST_STRIDE,subject); %Percent recall variation
        REGRESSORS=[REGRESSORS; adaptData.subData.age adaptData.subData.weight adaptData.subData.height BMI group PERC_REC_VAR];
    end
end
REGRESSORS=fixRegressors(REGRESSORS); %Correct data Luis did not input correctly
PARAMETERS_SAVINGS=PARAMETERS_ALL{SAVINGS};
PARAMETERS_INTERFERENCE=PARAMETERS_ALL{INTERFERENCE};
% save('BASELINE_DATA.mat', 'BASELINE_DATA');

%% Compute averages--------------------------------------------------------
%% MAWASE COMP.------------------------------------------------------------
%% SAVINGS---------
%AVERAGES----------
A1_sav_m=mean(PARAMETERS_SAVINGS(1,:,:),3); %A1
A2_sav_m=mean(PARAMETERS_SAVINGS(2,:,:),3); %A2
if MAWASE_COMP
    A1_sav_m_lr=mean(1./PARAMETERS_SAVINGS(1,C3,:),3);
    A2_sav_m_lr=mean(1./PARAMETERS_SAVINGS(2,C3,:),3);
    A1_sav_stderr_lr=std(1./PARAMETERS_SAVINGS(1,C3,:),0,3)/sqrt(nos(SAVINGS));
    A2_sav_stderr_lr=std(1./PARAMETERS_SAVINGS(2,C3,:),0,3)/sqrt(nos(SAVINGS));
    A1_int_m_lr=mean(1./PARAMETERS_INTERFERENCE(1,C3,:),3);
    A2_int_m_lr=mean(1./PARAMETERS_INTERFERENCE(2,C3,:),3);
    A1_int_stderr_lr=std(1./PARAMETERS_INTERFERENCE(1,C3,:),0,3)/sqrt(nos(INTERFERENCE));
    A2_int_stderr_lr=std(1./PARAMETERS_INTERFERENCE(2,C3,:),0,3)/sqrt(nos(INTERFERENCE));
end
%SDERR-------------
A1_sav_stderr=std(PARAMETERS_SAVINGS(1,:,:),0,3)/sqrt(nos(SAVINGS)); %A1
A2_sav_stderr=std(PARAMETERS_SAVINGS(2,:,:),0,3)/sqrt(nos(SAVINGS)); %A2

%% INTERFERENCE---------
%AVERAGES----------
A1_int_m=mean(PARAMETERS_INTERFERENCE(1,:,:),3); %A1
A2_int_m=mean(PARAMETERS_INTERFERENCE(2,:,:),3); %A2
%SDERR-------------
A1_int_stderr=std(PARAMETERS_INTERFERENCE(1,:,:),0,3)/sqrt(nos(INTERFERENCE)); %A1
A2_int_stderr=std(PARAMETERS_INTERFERENCE(2,:,:),0,3)/sqrt(nos(INTERFERENCE)); %A2
%% ------------------------------------------------------------------------
%DIFFERENCES BETWEEN CONDITIONS (A2-A1)
PARS_DIFF_INT=PARAMETERS_INTERFERENCE(2,:,:)-PARAMETERS_INTERFERENCE(1,:,:);
PARS_DIFF_SAV=PARAMETERS_SAVINGS(2,:,:)-PARAMETERS_SAVINGS(1,:,:);
%AVERAGE DIFFERENCES
AVG_PERF_DIFF_INT=mean(PARS_DIFF_INT,3);
AVG_PERF_DIFF_SAV=mean(PARS_DIFF_SAV,3);
%STANDARD ERRORS OF DIFFERENCES
STDERR_PERF_DIFF_INT=std(PARS_DIFF_INT,0,3)/sqrt(nos(INTERFERENCE));
STDERR_PERF_DIFF_SAV=std(PARS_DIFF_SAV,0,3)/sqrt(nos(SAVINGS));

%Build vectors to plot bars for the two groups
% outcome_meas_strings={['Recall (Strides:' num2str(ind_pert) ')'],['Re-learning (Strides:' num2str(ind_relearning) ')'],['Performance: (Last' num2str(ind_perf) 'strides; last num2str() excluded) '],'# strides to 0.63*SS (scaled by 10^-3)'};

%INTERFERENCE
% outcome_parameters=[FIRST_STRIDE EARLY_CHANGE PLATEAU NSTRIDES C3 C3r B NSTRIDES_TREND SLOPE LR]; %C3 and C3r are the time constants; B is the slope
outcome_parameters=[1:n_parameters]; %[FIRST_STRIDE EARLY_CHANGE PLATEAU NSTRIDES NSTRIDES_TREND]; %C3 and C3r are the time constants; B is the slope

avg_outcome_meas_int=AVG_PERF_DIFF_INT(outcome_parameters);
stderr_outcome_meas_int=STDERR_PERF_DIFF_INT(outcome_parameters);
outcome_meas_indiv_int=squeeze(PARS_DIFF_INT(:,outcome_parameters,:));

%SAVINGS
avg_outcome_meas_sav=AVG_PERF_DIFF_SAV(outcome_parameters);
stderr_outcome_meas_sav=STDERR_PERF_DIFF_SAV(outcome_parameters);
outcome_meas_indiv_sav=squeeze(PARS_DIFF_SAV(:,outcome_parameters,:));

%% INSERT SUBJECT DATA INTO PLOTS------------------------------------------
if (TABLE_ON_DATA)
    subplot_offset=0;
    col_head1={'Rec','Re-l','Perf','#str','tc'};
    col_head2={'tc','Slope'};
    col_head3={'tc','#str',' #str_{t}'};
    row_head={'A1','A2','A2-A1'};
    if INCR_EXP
        pos1=[.2 .35];
        pos2=[.6 .35];
    else
        pos1=[0 1];
        pos2=[.3 1];
    end
    for group=1:ngr
        ns_cg=nos(group); %Number of subjects in the current group
        if group==2
            %             subplot_offset=4;
            subplot_offset=8;
        end
        for subject=1:ns_cg
            ind_subplot=subplot_offset + subject;
            
            %Whole adaptation data---------------------------------------------
            figure(f1);
            hold on
            op1=[FIRST_STRIDE EARLY_CHANGE PLATEAU NSTRIDES C3];
            subplot_tight(2,8,ind_subplot,margins)
            if group==INTERFERENCE
                data_table=[PARAMETERS_INTERFERENCE(1:2,op1,subject); PARS_DIFF_INT(:,op1,subject)];
            else
                data_table=[PARAMETERS_SAVINGS(1:2,op1,subject); PARS_DIFF_SAV(:,op1,subject)];
            end
            print_table(col_head1,row_head,data_table,pos1,'f',dim_head,dim_cell)
            
            %Early adaptatation data-------------------------------------------
            figure(f2);
            hold on
            op2=[C3r B];
            subplot_tight(2,4,ind_subplot,margins)
            if group==INTERFERENCE
                data_table=[PARAMETERS_INTERFERENCE(1:2,op2,subject); PARS_DIFF_INT(:,op2,subject)];
            else
                data_table=[PARAMETERS_SAVINGS(1:2,op2,subject); PARS_DIFF_SAV(:,op2,subject)];
            end
            print_table(col_head2,row_head,data_table,pos2,'e',dim_head,dim_cell)
            
            %Trend data--------------------------------------------------------
            figure(f3);
            hold on
            op3 = [C3 NSTRIDES NSTRIDES_TREND];%Parameters to be displayed in the table
            subplot_tight(2,4,ind_subplot,margins)
            if group==INTERFERENCE
                data_table=[PARAMETERS_INTERFERENCE(1:2,op3,subject); PARS_DIFF_INT(:,op3,subject)];
            else
                data_table=[PARAMETERS_SAVINGS(1:2,op3,subject); PARS_DIFF_SAV(:,op3,subject)];
            end
            print_table(col_head3,row_head,data_table,pos2,'f',dim_head,dim_cell)
            
        end
    end
end
%% PLOT BARS---------------------------------------------------------------
fh=figure;
% title([gait_par 'A2-A1 for Iterference and Savings groups' ]);
%scale_factors=[1 1 1 10^-3 10^-4 10^-5 10^2 10^-3 10 10]';
scale_factors=ones(n_parameters,1);
scale_factors([NSTRIDES NSTRIDES_TREND STRIDES_TO_HALVE])=10^-3;
scale_factors([SLOPE_data SLOPE_fit AVERAGE_RATE_FIT])=10;

%Create bars
% outcome_meas_strings_app=append_scale_factors(parameters_strings,scale_factors);
outcome_meas_strings_app=parameters_strings;
n_outcome_meas=length(outcome_meas_strings_app);


scal_mat1=repmat(scale_factors,1,2);
scale_mat_sav=repmat(scale_factors,1,nos(SAVINGS));
scale_mat_int=repmat(scale_factors,1,nos(INTERFERENCE));

hb=bar([avg_outcome_meas_sav' avg_outcome_meas_int'].*scal_mat1,'hist');
addStd(fh, hb, 1:n_outcome_meas, [1 2], [stderr_outcome_meas_sav' stderr_outcome_meas_int'].*scal_mat1);
%addInddividualData(fh, hb, 1:n_outcome_meas, [1 2], cat(3,outcome_meas_indiv_sav.*scale_mat_sav, outcome_meas_indiv_int.*scale_mat_int),labels_savings,labels_interf);
set(gca,'XTickLabel',outcome_meas_strings_app)
% set(gca, 'XTickLabelRotation', -45); %Only works with recent Matlab
% versions
legend('Savings group','Interference group')
grid on
% title('Step length asymmetry. Late (last 20(-5) strides)')

%% STATISTICAL ANALYSIS----------------------------------------------------
%% A. Test differences between groups--------------------------------------
% A1. Test normality
[Hsav,Psav]=test_normality(outcome_meas_indiv_sav,1); %H=1 if not normal (5%)
[Hint,Pint]=test_normality(outcome_meas_indiv_int,1);

% A2. Test equality of variances
[Hvar,Pvar]=test_eq_variances(outcome_meas_indiv_int,outcome_meas_indiv_sav,1); %H=1 if different variances

% A3. Test differences (Normality and equal variances fail only for 2nd to last and 3rd to last parameters)
[Hdiff1, Pdiff1]=test_differences(outcome_meas_indiv_int,outcome_meas_indiv_sav,1,'equal'); %H=1 if different means
%[Hdiff2, Pdiff2]=test_differences([outcome_meas_indiv_int],[outcome_meas_indiv_sav ],1,'unequal');
%[Hdiff3, Pdiff3]=test_differences([outcome_meas_indiv_int outcome_meas_indiv_int  outcome_meas_indiv_int],[outcome_meas_indiv_sav outcome_meas_indiv_sav outcome_meas_indiv_sav ],1,'nonpar');

% NOTE. Non parametrical test: doubling the data, tests 2,4,5 are rejected. Triplicating the
% data, also the number 1 and 3 are.

%% B. Test differences between first and second adaptation (in each group)----------------
%(Repeated measures => paired t-test or non parametric )
%B1. Test normality (already done in part A)-------------------------------

%B2. Test difference from 0 (Paired t-test)
[Hsav01,Psav01]=ttest(outcome_meas_indiv_sav'); %Performs a t-test for each column
[Hint01,Pint01]=ttest(outcome_meas_indiv_int'); %Performs a t-test for each column

%B3. Test difference from 0 (Wilcoxon Signed-Rank Test)
%[Hsav02,Psav02]=my_signrank(outcome_meas_indiv_sav',2); %Performs a test for each column
%[Hint02,Pint02]=my_signrank(outcome_meas_indiv_int',2); %Performs a test for each column

%% ADD TESTS RESULTS ON THE BARPLOTS
YLIM=ylim();
ylim([YLIM(1) YLIM(2)*1.1] );
%Paired
addLineAsterisk_paired(fh,hb,Hdiff1,Pdiff1)

%From 0
addLineAsterisk_single_bar(fh,hb,[Hsav01; Hint01]',[Psav01; Pint01]')

%% ANALYSIS FOR REPORT-----------------------------------------------------
%Initializations
fhr=figure;
REPORT_PARS=[RECALL_data PERFORMANCE_data SLOPE_data STRIDES_TO_HALVE];
% REPORT_PARS=[RECALL_fit PERFORMANCE_fit SLOPE_fit STRIDES_TO_HALVE];

report_strings={'Recall','Steady state','Slope','Strides to halve'};
npr=length(REPORT_PARS);
colSav=[0.5 0.5 0.5];
colInt=[0 0 0];

for i=1:npr %For each selected parameter
    cpr=REPORT_PARS(i);
    subplot(1,4,i)
    hb=bar([[A1_sav_m(cpr) A2_sav_m(cpr)]' [A1_int_m(cpr) A2_int_m(cpr)]'],'hist');
    addStd(fhr, hb, 1:2, [1 2], [[A1_sav_stderr(cpr) A2_sav_stderr(cpr)]' [A1_int_stderr(cpr) A2_int_stderr(cpr)]'] );
    
    %Extract individual data
    sav_par=squeeze(PARAMETERS_SAVINGS(1:2,cpr,:));
    int_par=squeeze(PARAMETERS_INTERFERENCE(1:2,cpr,:));
    addInddividualData(fhr, hb, 1:2, [1 2], cat(3,sav_par,int_par),labels_savings,labels_interf);
    
    %Test differences and add results
    %     [cH, cP]=test_differences(sav_par,int_par,1,'unequal');
    [cH, cP]=test_differences(sav_par,int_par,1,'equal','left');
    
    addLineAsterisk_paired(fhr,hb,cH,cP)
    
    
    set(gca,'XTickLabel',{'A1','A2'})
    legend('Savings group','Interference group')
    grid on
    set(hb(1),'FaceColor',colSav);
    set(hb(2),'FaceColor',colInt);
    ylabel(report_strings{i});
    xlabel('Adaptation')
    
end
%%

APP_INT=squeeze(PARAMETERS_ALL{INTERFERENCE}(:,STRIDES_TO_HALVE,:));
APP_SAV=squeeze(PARAMETERS_ALL{SAVINGS}(:,STRIDES_TO_HALVE,:));
STRIDES_TO_PERC_MOD=STRIDES_TO_PERCENTAGE;
STRIDES_TO_PERC_MOD{INTERFERENCE}(1:2,end+1,:) = APP_INT;
STRIDES_TO_PERC_MOD{SAVINGS}(1:2,end+1,:) = APP_SAV;

plot_strides_to_percentages(STRIDES_TO_PERC_MOD,[percentages 0],colInt,colSav,labels_savings,labels_interf,nos,INTERFERENCE,SAVINGS);


%% SAVE DATA
if STORE_DATA
    storePath='C:\Users\salat\OneDrive\Documents\MATLAB\Research\CoreL\Interference\Interf_study_AS\SaveDataForStata\';
    completePath=[storePath 'ALL_DATA_STEP_POS_N2.mat'];
    save(completePath,'SAVINGS_DATA','INTERFERENCE_DATA','INTERFERENCE_FIT_DATA','nos','INTERFERENCE',...
        'SAVINGS', 'PARAMETERS_ALL', 'STRIDES_TO_HALVE', 'SAVINGS_FIT_DATA' );
end





































