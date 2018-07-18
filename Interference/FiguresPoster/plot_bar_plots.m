%% USe this to reproduce barplots in the RIR poster

clc
close all
clear all

set(0,'defaultAxesFontSize',18)


cpath='C:\Users\salat\OneDrive\Documents\MATLAB\Research\CoreL\Interference\Interf_study_AS\SaveDataForStata\';

%% Choose what to plot
selPar = 3; % 1-> SLA, 2->SP, 3->ST
pars={'SLA','SP','ST'};

REPRODUCE_POSTER=0; %RIR POSTER
TABLE_TO_LOAD = 2;
ADD_INDIVIDUALS = 1;

% Table 1 -> To reproduce RIR poster
% Table 2 -> To plot contributions
% Table 3 -> To plot rates

if TABLE_TO_LOAD==1
    %% To reproduce poster
    load([cpath 'Outcome_tables_v_May_9th.mat']); %Load these 2 to reproduce poster
    load([cpath 'outcome_variables_RIR.mat'])
    REPORT_PARS=[2 3 4 9]; %The script only supports 1x4 subplot
    ylabels={'Step Length Asymmetry','Step Length Asymmetry','Step Length Asymmetry','Strides'};
    IND_GROUP=10; IND_COND=12;
    report_strings={'Very Early Adaptation','Early Adaptation','Late Adaptation','#Strides to Mid-Pert'};

elseif TABLE_TO_LOAD==2
    %% To be able to plot all the contributions
    load([cpath 'outcome_table_all_contributions_N2.mat']) %Load this to plot SLA SP ST (Normalized)
    load([cpath 'outcome_variables_all_contributions.mat'])
    REPORT_PARS=[2 3 4]; %The script only supports 1x4 subplot
    %% Extract only data relative to the selected contribution
    outcome_table = extract_chosen_par(outcome_table_all_contributions, selPar);
    if selPar==1
        yls = 'Step Length Asymmetry';
    elseif selPar==2
        yls = 'Step Position';
    else
        yls = 'Step Time';
    end
    ylabels={yls,yls,yls};
    IND_GROUP=10; IND_COND=12;
    report_strings={'Very Early Adaptation','Early Adaptation','Late Adaptation','#Strides to Mid-Pert'};

elseif TABLE_TO_LOAD==3
    ratePath = 'C:\Users\salat\OneDrive\Documents\MATLAB\Research\CoreL\Interference\Interf_study_AS\SaveDataForStata\Stata - Rate Measures\';
    load([ratePath pars{selPar} '_stata_rate_table.mat']);
    outcome_table = matTable;
    IND_GROUP=1; IND_COND=3;
    REPORT_PARS=[5 6 7]; %The script only supports 1x4 subplot
    ylabels = {'Strides','Strides','Strides'};
    report_strings={'Mono - Mid Pert', 'Mono - Time to Rise', 'Mono - SS threshold'};

end


%%
%% ANALYSIS FOR REPORT-----------------------------------------------------
%Initializations
fhr=figure;
INTERFERENCE=1; SAVINGS=2;
A1=1; A2=2;
npr=length(REPORT_PARS);
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



[A1_sav_m, A2_sav_m, A1_int_m, A2_int_m, A1_sav_se, A2_sav_se, A1_int_se, A2_int_se] = ...
    get_m_and_s(outcome_table,INTERFERENCE,SAVINGS,A1,A2,IND_GROUP,IND_COND);





%Plots
YLIMS=[];
for i=1:npr %For each selected parameter
    cpr=REPORT_PARS(i);
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
