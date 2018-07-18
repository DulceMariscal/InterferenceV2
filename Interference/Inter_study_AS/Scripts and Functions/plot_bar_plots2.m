%% USe this to reproduce barplots in the RIR poster

clc
close all
clear all

set(0,'defaultAxesFontSize',18)


cpath = 'C:\Users\salat\OneDrive\Documents\MATLAB\Research\CoreL\Interference\Interf_study_AS\SaveDataForStata\Only tables\';
load([cpath 'Int_proj_table2.mat' ]);
mtable=Intprojsfntable2;
outcome_table = table2cell(mtable);
headers = mtable.Properties.VariableNames;

%% Choose what to plot
pars={'SLA','SP','ST'};
SMOOTHING = {'1_EXP','MONOTONIC_FIT','1_EXP_CONSTR','2_EXP_CONSTR','2_EXP'};

np = length(pars);
nsm = length(SMOOTHING);


%% lO
% selPar=1;
%     ratePath = 'C:\Users\salat\OneDrive\Documents\MATLAB\Research\CoreL\Interference\Interf_study_AS\SaveDataForStata\Stata - Rate Measures\';
%     load([ratePath pars{selPar} '_stata_rate_table.mat']);
%     outcome_table = matTable;
%     IND_GROUP=1; IND_COND=3;
%     REPORT_PARS=[5 6 7]; %The script only supports 1x4 subplot
%     ylabels = {'Strides','Strides','Strides'};
%     report_strings={'Mono - Mid Pert', 'Mono - Time to Rise', 'Mono - SS threshold'};



%%
%% ANALYSIS FOR REPORT-----------------------------------------------------
%Initializations
INTERFERENCE=1; SAVINGS=2;
A1=1; A2=2;
colSav=[0    0.4470    0.7410];
colInt=[0.8500    0.3250    0.0980];
LineArray={ '-' , '--'};

% myColors2=[0.8500    0.3250    0.0980; 0    0.4470    0.7410]; %Interference, Savings

%Definition varaibles stores
% outcome_variables={'dataPert1','dataPert1_5','dataRate6_30','dataSSL30',...
%     'fitPert1','fitPert1_5','fitRate6_30','fitSSL30',...
%     'stridesToAVGpert',...
%     'group','subject','condition'};

% REPORT_PARS=find(strcmpi(outcome_variables,'dataPert1'));


IND_GROUP = 1; IND_COND = 3;
[A1_sav_m, A2_sav_m, A1_int_m, A2_int_m, A1_sav_se, A2_sav_se, A1_int_se, A2_int_se, matTable] = ...
    get_m_and_s(outcome_table,INTERFERENCE,SAVINGS,A1,A2,IND_GROUP,IND_COND);





%Plots
YLIMS=[];
npr = length(pars);
ylabels = {'Strides','Strides','Strides'};
report_strings = pars;
for sm=1:nsm
    
    fhr = figure('Name', ['Fit: ' SMOOTHING{sm} ' - Rate meas: nstmp'],'NumberTitle','off');
    
    %Select only data from the current smoothing
    indCol = get_ind_cols(headers,SMOOTHING{sm},pars); %Extract the indices of needed cols
    
    for i=1:npr %For each selected parameter
        cpr=indCol(i);
        subplot(1,npr,i)
        %     hb=bar([[A1_sav_m(cpr) A2_sav_m(cpr)]' [A1_int_m(cpr) A2_int_m(cpr)]'],'hist');
        hb1=bar([[A1_sav_m(cpr) 0]' [A1_int_m(cpr) 0]'],'hist');
        hold on
        hb2=bar([[0 A2_sav_m(cpr)]' [0 A2_int_m(cpr) ]'],'hist');
        
        addStd(fhr, hb1, 1:2, [1 2], [[A1_sav_se(cpr) 0]' [A1_int_se(cpr) 0]'] );
        addStd(fhr, hb2, 1:2, [1 2], [[0 A2_int_se(cpr)]' [0 A2_int_se(cpr)]'] );
        
        %     if ADD_INDIVIDUALS
        %        cparData = outcome_table
        %        add_individual_data(fhr, hb1, [[A1_sav_se(cpr) 0]' [A1_int_se(cpr) 0]']); %A1
        %        %A2
        %     end
        %     % Extract individual data
        %         sav_par=squeeze(PARAMETERS_SAVINGS(1:2,cpr,:));
        %         int_par=squeeze(PARAMETERS_INTERFERENCE(1:2,cpr,:));
        %         addInddividualData(fhr, hb, 1:2, [1 2], cat(3,sav_par,int_par),labels_savings,labels_interf);
        
        %Test differences and add results
        %     [cH, cP]=test_differences(sav_par,int_par,1,'unequal');
        %     [cH, cP]=test_differences(sav_par,int_par,1,'equal','left');
        
        %     addLineAsterisk_paired(fhr,hb,cH,cP)
        
        YLIM=ylim();
        YLIMS = [YLIMS; YLIM ];
        %     if i==1
        %     end
        %     if i<=3
        %         ylim(YLIM)
        %     end
        
        set(gca,'XTickLabel',{'A1','A2'})
        grid on
        
        set(hb1(1),'FaceColor',colSav);
        set(hb1(2),'FaceColor',colInt);
        set(hb2(1),'FaceColor',colSav);
        set(hb2(2),'FaceColor',colInt);
        
        yl(i)=ylabel(ylabels{i});
        
        xl(i)=xlabel('Adaptation');
        
        set(hb1(1),'LineStyle',LineArray{1},'LineWidth',3);
        set(hb1(2),'LineStyle',LineArray{1},'LineWidth',3);
        
        set(hb2(1),'LineStyle',LineArray{2},'LineWidth',3);
        set(hb2(2),'LineStyle',LineArray{2},'LineWidth',3);
        if i==npr
            hl=legend('Savings gr. (A1)','Interference gr. (A1)','Savings gr. (A2)','Interference gr. (A2)');
            mySetFontSize(hl,16);
        end
        title(report_strings{i})
        
    end
    mySetYlim(fhr, npr, YLIMS);
    
    
    mySetFontSize(xl,14);
    mySetFontSize(yl,16);
end


