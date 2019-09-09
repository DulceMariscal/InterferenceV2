%With S009
% pathToData= 'C:\Users\dum5\OneDrive\_Shared Drive - Interference Project - Alessandro - Dulce_\Params Files\ForceParams';
clear all
close all
clc

% pathToData= 'C:\Users\dum5\OneDrive\_Shared Drive - Interference Project - Alessandro - Dulce_\Params Files\subjectsData';
poster_colors;
colorOrder=[p_red; p_orange; p_fade_green; p_fade_blue; p_plum; p_green; p_blue; p_fade_red; p_lime; p_yellow; [0 0 0]; [0.1 0.1 0.1];[0.2 0.2 0.2]; [0.3 0.3 0.3];[0.4 0.4 0.4]];




% load('ExtAdaptPNormAllDataV9.mat')
% % % load('StridesToRemovenetContributionPNormAllDataV7.mat')
% param={'ExtAdaptPNormV9'};
% % 
% slaI=ExtAdaptINT;
% slaS=ExtAdaptSAV;

% load('spatialContributionPNormAllSubjectsData.mat')
% load('NoRemovingAnyStrides.mat')

% load('netContributionPNormV9_nan.mat')

% load('StridesToRemovenetContributionPNormAllDataV7.mat')
% load('netContributionPNormV9ALL_badstridesRemoved.mat')

%SML data analysis 
% load('netContributionPNormV10.mat')
% param={'netContributionPNormV10'};
% gaitPar='netContributionPNorm';
% slaI=netContributionPNormINT;
% slaS=netContributionPNormSAV;

%  load('ExtAdaptPNormV10.mat')
%  param={'ExtAdaptPNormV10'};
% slaI=ExtAdaptINT;
% slaS=ExtAdaptSAV;

%Data to address Bastian's commnet 
% load('netContributionPNormV10_WO1stStride.mat')
% param={'netContributionPNormV10_{WO1stStride}'};
% gaitPar='netContributionPNorm';
% slaI=netContributionPNormINT;
% slaS=netContributionPNormSAV;


load('ExtAdaptPNormV10_WO1stStride.mat')
 param={'ExtAdaptPNormV10_{WO1stStride}'};
slaI=ExtAdaptINT;
slaS=ExtAdaptSAV




% load('netContributionPNormV8_ALLmedian.mat')
% param={'netContributionPNormV8_{ALLmedian}'};
% slaI=netContributionPNormINT;
% slaS=netContributionPNormSAV;


% load('NoRemovingAnyStridesV7.mat')

% load('spatialContributionPNormAllDataV8_ALL.mat')
% % load('StridesToRemovenetContributionPNormAllDataV8.mat')
% param={'spatialContributionPNormAllDataV8_ALL'};
% slaI=spatialContributionPNormINT;
% slaS=spatialContributionPNormSAV;

groups = 2;
charGroups = {'S','I'};
indSubs = {setdiff(1:10, []), setdiff(1:9, [])};
%  indSubs = {setdiff(1:9, []), setdiff(1:8, [])};

subs = {length(indSubs{1}) , length(indSubs{2})};
% subs ={9,8};

incrORdecr={'Increasing'};

cond_Inter=[2,5,6,4];
cond_Sav=[2,4,5,3];

NumbStridesToMidPert=nan(15,4);
MinPointAdaptCurve_Inter=nan(15,1);
% MinPointAdaptCurve_Sav=nan(10,1);
kk=9;
ss=10;
Tau_INT=nan(kk,2);
Tau_SAV=nan(ss,2);
STRIDES_1_INT=nan(kk,2);
STRIDES_5_INT=nan(kk,2);
STRIDES_SS_INT=nan(kk,2);
STRIDES_1_SAV=nan(ss,2);
STRIDES_5_SAV=nan(ss,2);
STRIDES_SS_SAV=nan(ss,2);
Washout_5_SAV=nan(ss,1);
Washout_5_INT=nan(kk,1);
Washout_ALL_SAV=nan(ss,1);
Washout_ALL_INT=nan(kk,1);
 STRIDES_Tied_INT=nan(kk,1);
 STRIDES_Tied_SAV=nan(ss,1);
minNOSToRemove=ones(13,2);

for s=1:subs{2}
    sub=indSubs{2}(s);
    %     sub=s;
    data_A1_Inter=slaI{sub,cond_Inter(1)};
    data_A1_Inter(any(isnan(data_A1_Inter), 2), :) = [];
%     if s==7
%         nos_to_mid_pert_InterA1=nan;
%         data_A1_Inter=nan(100,1);
%         
%     else
        
    [nos_to_mid_pert_InterA1,~, expFitPars_InterA1] = find_nstrides_to_mid_pert(data_A1_Inter(minNOSToRemove(sub,1):end,1),incrORdecr);
%     end
    %     MinPointAdaptCurve_Inter(sub,1)=nanmin(data_A1_Inter(minNOSToRemove(sub,1):end,1));
    
    Tau_INT(sub,1)=expFitPars_InterA1(3);
    STRIDES_1_INT(sub,1)=data_A1_Inter(minNOSToRemove(sub,1):minNOSToRemove(sub,1),1);
    STRIDES_5_INT(sub,1)=nanmean(data_A1_Inter(minNOSToRemove(sub,1):minNOSToRemove(sub,1)+4,1));
    STRIDES_SS_INT(sub,1)=nanmean(data_A1_Inter(end-40:end-5,1));
    
    data_A2_Inter=slaI{sub,cond_Inter(2)};
    data_A2_Inter(any(isnan(data_A2_Inter), 2), :) = [];
    [nos_to_mid_pert_A2_Inter,~, expFitPars_A2_Inter] = find_nstrides_to_mid_pert(data_A2_Inter(minNOSToRemove(sub,1):end,1),incrORdecr);
    
    Tau_INT(sub,2)=expFitPars_A2_Inter(3);
    STRIDES_1_INT(sub,2)=data_A2_Inter(minNOSToRemove(sub,1):minNOSToRemove(sub,1),1);
    STRIDES_5_INT(sub,2)=nanmean(data_A2_Inter(minNOSToRemove(sub,1):minNOSToRemove(sub,1)+4,1));
    STRIDES_SS_INT(sub,2)=nanmean(data_A2_Inter(end-40:end-5,1));
    
    data_A3_Inter=slaI{sub,cond_Inter(3)};
%         if sub==8 && strcmp(param,'stepLengthAsym') || sub==8 && strcmp(param,'ExtAdaptNorm2Shifted') || sub==8 && strcmp(param,'ExtAdaptNorm2')||...
%                 sub==8 && strcmp(param,'ExtAdaptPNorm')|| sub==8 && strcmp(param,'ExtAdaptPNormShifted') || sub==8 && strcmp(param,'stepLengthAsymShifted')
%             Washout_5_INT(sub,1)=nanmean(data_A3_Inter(9:14,1));
%         else
    Washout_5_INT(sub,1)=nanmean(data_A3_Inter(1:5,1));
%         end
    
        Washout_5_INT(sub,1)=nanmean(data_A3_Inter(1:5,1));
    
    Washout_ALL_INT(sub,1)=nanmean(data_A3_Inter(1:end-5,1));
    
    %conditon between A1 and second A1 
    data_A4_Inter=slaI{sub,cond_Inter(4)};
    data_A4_Inter(any(isnan(data_A4_Inter), 2), :) = [];
    STRIDES_Tied_INT(sub,1)=nanmean(data_A4_Inter(end-50:end-5,1));
    
    NumbStridesToMidPert(sub,1:2)=[nos_to_mid_pert_InterA1 nos_to_mid_pert_A2_Inter ];
end

Inter_Epoachs=[STRIDES_5_INT(:,1) STRIDES_SS_INT(:,1) STRIDES_Tied_INT(:,1) STRIDES_5_INT(:,2) STRIDES_SS_INT(:,2) Washout_5_INT Washout_ALL_INT];

for s=1:subs{1}
    sub=indSubs{1}(s);
    %     sub=s;
    
    data_A1_Sav=slaS{sub,cond_Sav(1)};
    data_A1_Sav(any(isnan(data_A1_Sav), 2), :) = [];
    [nos_to_mid_pert_A1_Sa, ~, expFitPars_A1_Sa] = find_nstrides_to_mid_pert(data_A1_Sav(minNOSToRemove(sub,2):end,1),incrORdecr);
    %     MinPointAdaptCurve_Sav(sub,1)=nanmin(data_A1_Sav(minNOSToRemove(sub,2):end,1));
    
    Tau_SAV(sub,1)=expFitPars_A1_Sa(3);
    STRIDES_1_SAV(sub,1)=data_A1_Sav(minNOSToRemove(sub,2):minNOSToRemove(sub,2),1);
    STRIDES_5_SAV(sub,1)=nanmean(data_A1_Sav(minNOSToRemove(sub,2):minNOSToRemove(sub,2)+4,1));
    STRIDES_SS_SAV(sub,1)=nanmean(data_A1_Sav(end-40:end-5,1));
    
    
    data_A2_Sav=slaS{sub,cond_Sav(2)};
    data_A2_Sav(any(isnan(data_A2_Sav), 2), :) = [];
    [nos_to_mid_pert_A2_Sa, ~, expFitPars_A2_Sa] = find_nstrides_to_mid_pert(data_A2_Sav(minNOSToRemove(sub,2):end,1),incrORdecr);
    
    
    Tau_SAV(sub,2)=expFitPars_A2_Sa(3);
    STRIDES_1_SAV(sub,2)=data_A2_Sav(minNOSToRemove(sub,2):minNOSToRemove(sub,2),1);
    STRIDES_5_SAV(sub,2)=nanmean(data_A2_Sav(minNOSToRemove(sub,2):minNOSToRemove(sub,2)+4,1));
    STRIDES_SS_SAV(sub,2)=nanmean(data_A2_Sav(end-40:end-5,1));
    
    
    data_A3_Sav=slaS{sub,cond_Sav(3)};
%     if s==5 || s==9
%     Washout_5_SAV(sub,1)=nan;
%     Washout_ALL_SAV(sub,1)=nan;
%     else
    Washout_5_SAV(sub,1)=nanmean(data_A3_Sav(1:5,1));
    Washout_ALL_SAV(sub,1)=nanmean(data_A3_Sav(1:end-5,1));
%     end
    NumbStridesToMidPert(sub,3:4)=[nos_to_mid_pert_A1_Sa nos_to_mid_pert_A2_Sa];
    
    %conditon between A1 and second A1 
    data_A4_Sav=slaS{sub,cond_Sav(4)};
    data_A4_Sav(any(isnan(data_A4_Sav), 2), :) = [];
    STRIDES_Tied_SAV(sub,1)=nanmean(data_A4_Sav(end-50:end-5,1));
    
end

Sav_Epoachs=[STRIDES_5_SAV(:,1) STRIDES_SS_SAV(:,1) STRIDES_Tied_SAV(:,1) STRIDES_5_SAV(:,2) STRIDES_SS_SAV(:,2) Washout_5_SAV Washout_ALL_SAV];


% Inter_Epoachs(any(isnan(Inter_Epoachs), 2), :) = [];
% Sav_Epoachs(any(isnan(Sav_Epoachs), 2), :) = [];

% MinPointAdaptation=nanmin([MinPointAdaptCurve_Inter; MinPointAdaptCurve_Sav]);




% save([ param{1} 'MinPointAdapt.mat'], 'MinPointAdaptation')
% save([ param{1} 'NumbStridesToMidPert.mat'], 'NumbStridesToMidPert')
% save([ param{1} 'First&SS.mat'], 'STRIDES_1_INT','STRIDES_SS_INT','STRIDES_1_SAV','STRIDES_SS_SAV')
% save([param{1} 'Epochs.mat'],'Sav_Epoachs','Inter_Epoachs')



cond=6;
Sav_Results=[];
Inter_Results=[];
for c=1:cond
    Inter_Results=[Inter_Results; Inter_Epoachs(:,c) c*ones(size(Inter_Epoachs,1),1) ones(size(Inter_Epoachs,1),1)];
    Sav_Results=[Sav_Results; Sav_Epoachs(:,c) c*ones(size(Sav_Epoachs,1),1) 2*ones(size(Sav_Epoachs,1),1)];
end
stata_5_=[Inter_Results;Sav_Results];

Sav_Results=[];
Inter_Results=[];
for c=[1 2 3 4 5 7]
    Inter_Results=[Inter_Results; Inter_Epoachs(:,c) c*ones(size(Inter_Epoachs,1),1) ones(size(Inter_Epoachs,1),1)];
    Sav_Results=[Sav_Results; Sav_Epoachs(:,c) c*ones(size(Sav_Epoachs,1),1) 2*ones(size(Sav_Epoachs,1),1)];
end
stata_all_=[Inter_Results;Sav_Results];

% save(['Stata' param{1} ],'stata_all_','stata_5_')
%


% save([ param{1} 'ResultsAllSubjects.mat'], 'NumbStridesToMidPert','STRIDES_1_INT','STRIDES_SS_INT','STRIDES_1_SAV','STRIDES_SS_SAV','Sav_Epoachs','Inter_Epoachs','stata_all_','stata_5_')



%%
%Tau Analysis

PV_INT=(Tau_INT(:,2)-Tau_INT(:,1))./Tau_INT(:,1);
PV_SAV=(Tau_SAV(:,2)-Tau_SAV(:,1))./Tau_SAV(:,1);
PV_INT(any(isnan(PV_INT), 2), :) = [];
PV_SAV(any(isnan(PV_SAV), 2), :) = [];
[h,p,ci,stats] = ttest2(PV_INT,PV_SAV);


figure

hold on

bar(1,mean(PV_INT),'facecolor','r')
bar(2,mean(PV_SAV),'facecolor','b')
% for sub=1:length(PV_INT)
%     plot(1,PV_INT(sub,1),'*','MarkerFaceColor',colorOrder(sub,:))
% end
% for sub=1:length(PV_SAV)
%     plot(2,PV_SAV(sub,1),'*','MarkerFaceColor',colorOrder(sub,:))
% end

errorbar(1,mean(PV_INT),std(PV_INT)/sqrt(length(PV_INT)),'.','LineWidth',2,'Color','k')
errorbar(2,mean(PV_SAV),std(PV_SAV)/sqrt(length(PV_SAV)),'.','LineWidth',2,'Color','k')
legend('Interference','Savings')

ylabel('PV=tau_{A2}-tau_{A1}/tau_{A1}')
title([param; 't-test p-value=' num2str(p)])



% set(gca,'Xtick',[1.5 4.5],'XTickLabel',{'A1' 'A2'},'fontSize',12)

%%
%Washout without outliers

% Inter_Epoachs(any(isnan(Inter_Epoachs), 2), :) = [];
% Sav_Epoachs(any(isnan(Sav_Epoachs), 2), :) = [];
cond=6;
g=0;
a=figure ;
set(gcf,'color','w');
subplot(2,2,1)

% 
% netContributionPNormAvg(:,746:751)=[];
% netContributionPNormAvg(:,2690:2695)=[];
% netContributionPNormAvg(:,2703:2704)=[];
% 
% 
% % SE=ExtAdaptSE;
% 
% SE(:,746:751)=[];
% SE(:,2690:2695)=[];
% SE(:,2703:2704)=[];

% 

% ExtAdaptAvg(:,746:751)=[];
% ExtAdaptAvg(:,2690:2695)=[];
% ExtAdaptAvg(:,2703:2704)=[];

% netContributionPNormAvg(:,146:161)=[];

% ExtAdaptSE= nanse(GroupData(1,:),2);
% % subplot(2,2,1)
% plot(1:length(ExtAdaptAvg(1,:)),ExtAdaptAvg(1,:),'o','markerfacecolor','r','markerEdgeColor','k','Markersize',10 ,'LineWidth',.1)
% hold on 
% plot(1:length(ExtAdaptAvg(2,:)),ExtAdaptAvg(2,:),'o','markerfacecolor','b','markerEdgeColor','k','Markersize',10, 'LineWidth',.1)

% [marker,patch]=boundedline(1:length(netContributionPNormAvg(1,:)), netContributionPNormAvg(1,:),SE(1,:),'or','alpha',1:length(netContributionPNormAvg(2,:)), netContributionPNormAvg(2,:),SE(2,:),'ob');
[marker,patch]=boundedline(1:length(ExtAdaptAvg(1,:)), ExtAdaptAvg(1,:),ExtAdaptSE(1,:),'or','alpha',1:length(ExtAdaptAvg(2,:)), ExtAdaptAvg(2,:),ExtAdaptSE(2,:),'ob');

set(marker(1),'MarkerFaceColor','r','MarkerEdgeColor','k')
set(marker(2),'MarkerFaceColor','b','MarkerEdgeColor','k')
set(patch(1),'FaceColor','r','FaceAlpha',.5)
set(patch(2),'FaceColor','blue','FaceAlpha',.5)


axis tight
ylabel(param)
subplot(2,2,3)
hold on
g=[1 3.5 6 8.5 11 13.5 16 18.5];

for c=1:cond
    
    bar(g(c),nanmean(Inter_Epoachs(:,c)),'facecolor','r')
    bar(g(c)+.8,nanmean(Sav_Epoachs(:,c)),'facecolor','b')
    errorbar(g(c),nanmean(Inter_Epoachs(:,c)),nanstd(Inter_Epoachs(:,c))/sqrt(length(Inter_Epoachs(:,c))),'.','LineWidth',2,'Color','k')
    errorbar(g(c)+.8,nanmean(Sav_Epoachs(:,c)),nanstd(Sav_Epoachs(:,c))/sqrt(length(Sav_Epoachs(:,c))),'.','LineWidth',2,'Color','k')
    
%     for sub=1:size(Inter_Epoachs,1)
%         plot(g(c),Inter_Epoachs(sub,c),'*','MarkerFaceColor',colorOrder(sub,:))
%     end
%     
%     for sub=1:size(Sav_Epoachs,1)
%         plot(g(c)+1,Sav_Epoachs(sub,c),'*','MarkerFaceColor',colorOrder(sub,:))
%         
%     end
    
end

% set(gca,'Xtick',g+.5,'XTickLabel',{'Early A1' 'SS A1','Late tied','Early A2', 'SS A2', 'Washout 5', 'Washout All'},'fontSize',12)
set(gca,'Xtick',g+.5,'XTickLabel',{'Early_{A1}' 'SS_{A1}','Late tied','Early_{A2}', 'SS_{A2}', 'Washout'},'fontSize',12)
legend('Interference','Savings')
% ylabel(param{1})


%%
%Number of strides to mid perturation
% Bar plots

AvgNOSToMidPert=nanmean(NumbStridesToMidPert,1);
SENOSToMidPer=nanstd(NumbStridesToMidPert,1)./sqrt(length(NumbStridesToMidPert));

% figure
subplot(2,2,4)
hold on
g=0;
for gr=1:3:6
    g=g+1;
    
    bar(gr,AvgNOSToMidPert(g),'facecolor','r')
    bar(gr+1,AvgNOSToMidPert(g+2),'facecolor','b')
    for sub=1:length(NumbStridesToMidPert)
        plot(gr,NumbStridesToMidPert(sub,g),'*','MarkerFaceColor',colorOrder(sub,:))
    end
    for sub=1:length(NumbStridesToMidPert)
        plot(gr+1,NumbStridesToMidPert(sub,g+2),'*','MarkerFaceColor',colorOrder(sub,:))
    end
    
    errorbar(gr,AvgNOSToMidPert(g),SENOSToMidPer(g),'.','LineWidth',2,'Color','k')
    errorbar(gr+1,AvgNOSToMidPert(g+2),SENOSToMidPer(g+2),'.','LineWidth',2,'Color','k')
    
end
legend('Interference','Savings')
ylabel('NumbStridesToMidPert')
title(param)
set(gca,'Xtick',[1.5 4.5],'XTickLabel',{'A1' 'A2'},'fontSize',12)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%% CODES STOPS HERE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

return


%%
%Number of strides to mid perturation
%Line Plots

figure
title('Interference')
hold on
SubjInter=[setdiff(1:11, [])];
for i=1:10
    Inames=['I' num2str(SubjInter(i))];
    plot(1,NumbStridesToMidPert(i,1),'ob',2,NumbStridesToMidPert(i,2),'or')
    if NumbStridesToMidPert(i,1)>NumbStridesToMidPert(i,2)
        line([1 2],[NumbStridesToMidPert(i,1) NumbStridesToMidPert(i,2)],'Color','green','LineStyle','-')
    else
        line([1 2],[NumbStridesToMidPert(i,1) NumbStridesToMidPert(i,2)],'Color','black','LineStyle','-')
    end
    text(1.001,NumbStridesToMidPert(i,1),['\leftarrow' Inames])
    
end
ylabel(param)
legend('A1','A2')


figure
title('Savings')
hold on
SubjSav=[1:13];
for i=1:10
    Snames=['S' num2str(SubjSav(i))];
    plot(1,NumbStridesToMidPert(i,3),'ob',2,NumbStridesToMidPert(i,4),'or')
    if NumbStridesToMidPert(i,3)>NumbStridesToMidPert(i,4)
        line([1 2],[NumbStridesToMidPert(i,3) NumbStridesToMidPert(i,4)],'Color','green','LineStyle','-')
    else
        line([1 2],[NumbStridesToMidPert(i,3) NumbStridesToMidPert(i,4)],'Color','black','LineStyle','-')
        
    end
    text(1.001,NumbStridesToMidPert(i,3),['\leftarrow' Snames])
    
end
legend('A1','A2')
ylabel(param)






%%
%Rates plots

% pathToData= 'C:\Users\dum5\OneDrive\_Shared Drive - Interference Project - Alessandro - Dulce_\Params Files\subjectsData';
% load('StridesToRemove.mat')
% load('SlaAvgIdv.mat')
% load('NumbStridesToMidPert.mat')

INCR_EXP=1;
SINGLE_EXP=1;
FIT_MODEL=SINGLE_EXP;
npar_fit=3;
incrORdecr={'Increasing'};
subs = {11 , 10};
cond_Inter=[2,5];
cond_Sav=[2,4];
Inames={'I1','I3','I4','I5','I6','I7','I8','I9','I10','I11','I12'};

figure()
% SubjInter=[setdiff(1:10, [])];

for sub=1:subs{2}
    %     Inames=['I' num2str(SubjInter(sub))];
    
    A1min=nanmin( data_A1_Inter);
    A1max=nanmax(data_A1_Inter);
    A2min=nanmin( data_A2_Inter);
    A2max=nanmax(data_A2_Inter);
    absmin=min([A1min A2min]);
    absmax=nanmax([A1max A2max]);
    data_A1_Inter=slaI{sub,cond_Inter(1)};
    if sub==7
        data_A1_Inter=nan(100,1);
        
    else
       data_A1_Inter=data_A1_Inter(minNOSToRemove(sub,1):end,1);
    end
 
    stride_vec_iA1=1:length(data_A1_Inter);
    subplot(4,3,sub)
    hold on
    title(['Interference  ', Inames{sub} ])
    plot(1:length(data_A1_Inter),data_A1_Inter,'or')
    
    data_A2_Inter=slaI{sub,cond_Inter(2)};
    data_A2_Inter=data_A2_Inter(minNOSToRemove(sub,1):end,1);
    stride_vec_iA2=1:length(data_A2_Inter);
    %     subplot(2,4,sub)
    plot(1:length(data_A2_Inter),data_A2_Inter,'ob')
    
    A1min=nanmin(data_A1_Inter);
    A1max=nanmax(data_A1_Inter);
    A2min=nanmin( data_A2_Inter);
    A2max=nanmax(data_A2_Inter);
    absmin=min([A1min A2min]);
    absmax=nanmax([A1max A2max]);
    line([NumbStridesToMidPert(sub,1) NumbStridesToMidPert(sub,1)],[absmin absmax],'Color','r' )
    line([NumbStridesToMidPert(sub,2) NumbStridesToMidPert(sub,2)],[absmin absmax],'Color','b')
    ylabel(param)
    axis tight
    
    
end
% legend('A1','Mid perturabtion A1','A2','Mid perturabtion A2')
legend('A1','A2')

Snames={'S1','S2','S3','S4','S5','S6','S7','S8','S9','S11','S12','S13','S14'};

figure()
% SubjSav=[1:13];
for sub=1:subs{1}
    %     Snames=['S' num2str(SubjSav(sub))];
    A1min=nanmin( data_A1_Sav);
    A1max=nanmax(data_A1_Sav);
    A2min=nanmin( data_A2_Sav);
    A2max=nanmax(data_A2_Sav);
    absmin=min([A1min A2min]);
    absmax=nanmax([A1max A2max]);
    
    subplot(3,5,sub)
    %         subplot(2,4,sub)
    hold on
    title(['Savings  ', Snames{sub} ])
    data_A1_Sav=slaS{sub,cond_Sav(1)};
    data_A1_Sav=data_A1_Sav(minNOSToRemove(sub,2):end,1);
    plot(1:length(data_A1_Sav),data_A1_Sav,'or')
    
    
    
    
    data_A2_Sav=slaS{sub,cond_Sav(2)};
    data_A2_Sav=data_A2_Sav(minNOSToRemove(sub,2):end,1);
    %     subplot(3,3,sub)
    
    plot(1:length(data_A2_Sav),data_A2_Sav,'ob')
    
    A1min=nanmin( data_A1_Sav);
    A1max=nanmax(data_A1_Sav);
    A2min=nanmin( data_A2_Sav);
    A2max=nanmax(data_A2_Sav);
    absmin=min([A1min A2min]);
    absmax=nanmax([A1max A2max]);
    line([NumbStridesToMidPert(sub,3) NumbStridesToMidPert(sub,3)],[absmin absmax],'Color','r' )
    line([NumbStridesToMidPert(sub,4) NumbStridesToMidPert(sub,4)],[absmin absmax],'Color','b' )
    ylabel(param)
    axis tight
    
end
% legend('A1','Mid perturabtion A1','A2','Mid perturabtion A2')
legend('A1','A2')



%%
%Normalized version

%Rates plots

% pathToData= 'C:\Users\dum5\OneDrive\_Shared Drive - Interference Project - Alessandro - Dulce_\Params Files\subjectsData';
% load('StridesToRemove.mat')
% load('SlaAvgIdv.mat')
% load('NumbStridesToMidPert.mat')

INCR_EXP=1;
SINGLE_EXP=1;
FIT_MODEL=SINGLE_EXP;
npar_fit=3;
incrORdecr={'Increasing'};
subs = {11 , 10};
cond_Inter=[2,5];
cond_Sav=[2,4];
Inames={'I1','I3','I4','I5','I6','I7','I8','I9','I10','I11','I12'};
STMP_Inter=nan(11,2);
SMP_inter=nan(11,2);
SMP_inter_50per=nan(13,2);


figure('Name','Adaptation Overlapping Inter Norm')
SubjInter=[setdiff(1:10, [])];
for sub=1:subs{2}
    
    
    data_A1_Inter=slaI{sub,cond_Inter(1)};
    
      if sub==7
        data_A1_Inter=nan(100,1);
        
    else
       data_A1_Inter=data_A1_Inter(minNOSToRemove(sub,1):end,1);
       data_A1_Inter(any(isnan(data_A1_Inter), 2), :) = [];
    end
   
    
    
    subplot(4,3,sub)
    hold on
    title(['Interference  ', Inames{sub} ])
    
    data_A2_Inter=slaI{sub,cond_Inter(2)};
    data_A2_Inter=data_A2_Inter(minNOSToRemove(sub,1):end,1);
    data_A2_Inter(any(isnan(data_A2_Inter), 2), :) = [];
    
    
    A1min=nanmin(data_A1_Inter);
    A1max=nanmax(data_A1_Inter);
    A1SS=nanmean(data_A1_Inter(end-45:end-5));
    A2min=nanmin(data_A2_Inter);
    A2max=nanmax(data_A2_Inter);
    A2SS=nanmean(data_A2_Inter(end-45:end-5));
    absmin=min([(A1min) (A2min)]);
    %     absmax=nanmax([A1max A2max]);
    absmax=nanmax([A1SS A2SS]);
    
    NormA1=(data_A1_Inter+abs(absmin))/(absmax+abs(absmin));
    NormA2=(data_A2_Inter+abs(absmin))/(absmax+abs(absmin));
    
%     [nos_to_mid_pert_A1] = find_nstrides_to_mid_pert(NormA1,incrORdecr);
%     [nos_to_mid_pert_A2] = find_nstrides_to_mid_pert(NormA2,incrORdecr);
    
    
     thr_val_A1=(nanmean(NormA1(1:5)) + nanmean(NormA1(end-45:end-5)))/2;
%      if sub==7
%          SMP_A1 =nan;
%      SMP_A1_50Perc =nan;
%      else
         
     SMP_A1 = find(NormA1 >= thr_val_A1, 1);
     SMP_A1_50Perc = find(NormA1 >= .5, 1);
%      end
     thr_val_A2=(nanmean(NormA2(1:5)) + nanmean(NormA2(end-45:end-5)))/2;
     SMP_A2 = find(NormA2 >= thr_val_A2, 1);
     SMP_A2_50Perc = find(NormA2 >= .5, 1);
    
    SMP_inter(sub,1:2)=[SMP_A1 SMP_A2 ];
    SMP_inter_50per(sub,1:2)=[SMP_A1_50Perc SMP_A2_50Perc ];
    
    plot(1:length(data_A1_Inter),NormA1,'or')
    plot(1:length(data_A2_Inter),NormA2,'ob')
    
%     STMP_Inter=[STMP_Inter; nos_to_mid_pert_A1 nos_to_mid_pert_A2];
%     
%     line([nos_to_mid_pert_A1 nos_to_mid_pert_A1],[0 1],'Color','r' )
%     line([nos_to_mid_pert_A2 nos_to_mid_pert_A2],[0 1],'Color','b')
    
%     line([SMP_A1 SMP_A1],[0 1],'Color','r' ,'LineStyle','--')
%     line([SMP_A2 SMP_A2],[0 1],'Color','b','LineStyle','--')
%     
    
    ylabel(param)
    axis tight
    
    
    
end
% legend('A1','Mid perturabtion A1','A2','Mid perturabtion A2')
legend('A1','A2')

Snames={'S1','S2','S3','S4','S5','S6','S7','S8','S9','S11','S12','S13','S14'};

STMP_Sav=[];
SMP_sav=[];
SMP_sav_50perc=[];

figure('Name','Adaptation Overlapping Sav Norm')
SubjSav=[1:11];
for sub=1:subs{1}
    
    subplot(2,7,sub)
    
    hold on
    title([Snames{sub} ])
    data_A1_Sav=slaS{sub,cond_Sav(1)};
    data_A1_Sav=data_A1_Sav(minNOSToRemove(sub,2):end,1);
    data_A1_Sav(any(isnan(data_A1_Sav), 2), :) = [];
    
    data_A2_Sav=slaS{sub,cond_Sav(2)};
    data_A2_Sav=data_A2_Sav(minNOSToRemove(sub,2):end,1);
    data_A2_Sav(any(isnan(data_A2_Sav), 2), :) = [];
    
    A1min=nanmin( data_A1_Sav);
    A1max=nanmax(data_A1_Sav);
    A1SS=nanmean(data_A1_Sav(end-45:end-5));
    A2min=nanmin( data_A2_Sav);
    A2max=nanmax(data_A2_Sav);
    A2SS=nanmean(data_A2_Sav(end-45:end-5));
    absmin=min([A1min A2min]);
    absmax=nanmax([A1SS A2SS]);
    %     absmax=nanmax([A1max A2max]);
    NormA1=(data_A1_Sav+abs(absmin))/(absmax+abs(absmin));
    NormA2=(data_A2_Sav+abs(absmin))/(absmax+abs(absmin));
    
%     [nos_to_mid_pert_A1] = find_nstrides_to_mid_pert(NormA1,incrORdecr);
%     [nos_to_mid_pert_A2] = find_nstrides_to_mid_pert(NormA2,incrORdecr);
    
%     STMP_Sav=[STMP_Sav; nos_to_mid_pert_A1 nos_to_mid_pert_A2];
    
     thr_val_A1=(nanmean(NormA1(1:5)) + nanmean(NormA1(end-45:end-5)))/2;
     SMP_A1 = find(NormA1 >= thr_val_A1, 1);
     SMP_A1_50Perc = find(NormA1 >= 0.5, 1);
     
     thr_val_A2=(nanmean(NormA2(1:5)) + nanmean(NormA2(end-45:end-5)))/2;
     SMP_A2 = find(NormA2 >= thr_val_A2, 1);
     SMP_A2_50Perc = find(NormA2 >= 0.5, 1);
    
    SMP_sav=[SMP_sav;SMP_A1 SMP_A2 ];
    SMP_sav_50perc=[SMP_sav_50perc;SMP_A1_50Perc SMP_A2_50Perc];
     
    plot(1:length(data_A1_Sav),NormA1,'or')
    plot(1:length(data_A2_Sav),NormA2,'ob')
    
%     line([nos_to_mid_pert_A1 nos_to_mid_pert_A1],[0 1],'Color','r' )
%     line([nos_to_mid_pert_A2 nos_to_mid_pert_A2],[0 1],'Color','b')
    
%     line([SMP_A1 SMP_A1],[0 1],'Color','r' ,'LineStyle','--')
%     line([SMP_A2 SMP_A2],[0 1],'Color','r','LineStyle','--')
    
    ylabel(param)
    axis tight
    
end
% legend('A1','Mid perturabtion A1','A2','Mid perturabtion A2')
legend('A1','A2')


%%
%Normalized Bar plots

% NumbStridesToMidPertNorm=[STMP_Inter STMP_Sav];
% AvgNOSToMidPertNorm=nanmean(NumbStridesToMidPertNorm,1);
% SENOSToMidPerNorm=nanstd(NumbStridesToMidPertNorm,1)./sqrt(length(NumbStridesToMidPertNorm));
% 
% 
% figure('Name','Fitiing an exp');
% hold on
% g=0;
% for gr=1:3:6
%     g=g+1;
%     
%     bar(gr,AvgNOSToMidPertNorm(g),'facecolor','r')
%     bar(gr+1,AvgNOSToMidPertNorm(g+2),'facecolor','b')
%     for sub=1:length(NumbStridesToMidPertNorm)
%         plot(gr,NumbStridesToMidPertNorm(sub,g),'*','MarkerFaceColor',colorOrder(sub,:))
%     end
%     for sub=1:length(NumbStridesToMidPertNorm)
%         plot(gr+1,NumbStridesToMidPertNorm(sub,g+2),'*','MarkerFaceColor',colorOrder(sub,:))
%     end
%     
%     errorbar(gr,AvgNOSToMidPertNorm(g),SENOSToMidPerNorm(g),'.','LineWidth',2,'Color','k')
%     errorbar(gr+1,AvgNOSToMidPertNorm(g+2),SENOSToMidPerNorm(g+2),'.','LineWidth',2,'Color','k')
%     
% end
% legend('Interference','Savings')
% ylabel('NumbStridesToMidPertNorm')
% title(param)
% set(gca,'Xtick',[1.5 4.5],'XTickLabel',{'A1' 'A2'},'fontSize',12)

%%
%Normalized Bar plots

NumbStridesToMidPertNorm=[SMP_inter SMP_sav];
AvgNOSToMidPertNorm=nanmean(NumbStridesToMidPertNorm,1);
SENOSToMidPerNorm=nanstd(NumbStridesToMidPertNorm,1)./sqrt(length(NumbStridesToMidPertNorm));


figure('Name','Mid delta');
hold on
g=0;
for gr=1:3:6
    g=g+1;
    
    bar(gr,AvgNOSToMidPertNorm(g),'facecolor','w','EdgeColor','r')
    bar(gr+1,AvgNOSToMidPertNorm(g+2),'facecolor','w','EdgeColor','b')
    for sub=1:length(NumbStridesToMidPertNorm)
        plot(gr,NumbStridesToMidPertNorm(sub,g),'*','MarkerFaceColor',colorOrder(sub,:))
    end
    for sub=1:length(NumbStridesToMidPertNorm)
        plot(gr+1,NumbStridesToMidPertNorm(sub,g+2),'*','MarkerFaceColor',colorOrder(sub,:))
    end
    
    errorbar(gr,AvgNOSToMidPertNorm(g),SENOSToMidPerNorm(g),'.','LineWidth',2,'Color','k')
    errorbar(gr+1,AvgNOSToMidPertNorm(g+2),SENOSToMidPerNorm(g+2),'.','LineWidth',2,'Color','k')
    
end
legend('Interference','Savings')
ylabel('NumbStridesToMidPertNorm')
title(param)
set(gca,'Xtick',[1.5 4.5],'XTickLabel',{'A1' 'A2'},'fontSize',12)

%%
%50 percent max perturbation 
NumbStridesToMidPertNorm=[SMP_inter_50per SMP_sav_50perc];
AvgNOSToMidPertNorm=nanmean(NumbStridesToMidPertNorm,1);
SENOSToMidPerNorm=nanstd(NumbStridesToMidPertNorm,1)./sqrt(length(NumbStridesToMidPertNorm));


figure('Name','50 percent');
% hold on
% subplot(2,2,4)
g=0;
for gr=1:3:6
    g=g+1;
    
    bar(gr,AvgNOSToMidPertNorm(g),'facecolor','w','EdgeColor','r')
    bar(gr+1,AvgNOSToMidPertNorm(g+2),'facecolor','w','EdgeColor','b')
    for sub=1:length(NumbStridesToMidPertNorm)
        plot(gr,NumbStridesToMidPertNorm(sub,g),'*','MarkerFaceColor',colorOrder(sub,:))
    end
    for sub=1:length(NumbStridesToMidPertNorm)
        plot(gr+1,NumbStridesToMidPertNorm(sub,g+2),'*','MarkerFaceColor',colorOrder(sub,:))
    end
    
    errorbar(gr,AvgNOSToMidPertNorm(g),SENOSToMidPerNorm(g),'.','LineWidth',2,'Color','k')
    errorbar(gr+1,AvgNOSToMidPertNorm(g+2),SENOSToMidPerNorm(g+2),'.','LineWidth',2,'Color','k')
    
end
legend('Interference','Savings')
ylabel('NumbStridesToMidPertNorm')
title(param)
set(gca,'Xtick',[1.5 4.5],'XTickLabel',{'A1' 'A2'},'fontSize',12)