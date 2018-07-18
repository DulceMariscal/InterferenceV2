load('GroupDataAllSubjectsV8.mat')

binwidth=5; %Window of the running average
trialMarkerFlag=0; %1 if you want to separete the time course by trial 0 to separece by condition
indivFlag=0; %0 to plot group mean 1 to plot indiv subjects
indivSubs=[]; %Use when you want to plot a specidfic subject in a group
colorOrder=[]; %Let the function take care of this at least you wanted in a specific set of color then by my guess and add the list here
biofeedback= 0; % At least that you are providing with biofeedback to the subject
removeBiasFlag=1; %if you want to remove bias
labels=[]; %{'Inter','Sav'}; %Groups names
filterFlag=[];
plotHandles=[];
alignEnd=0; % # strides align at the end of the trial (PLAY with it as see what happens)
alignIni=0;
% conditions={'TM base','Adaptation 1', 'Adaptation 1(2nd time)'};
conditions_inter={'TM base','Adaptation 1','Adaptation 2','Gradual and Hold','Adaptation 1(2nd time)','Washout'};
conditions_sav={'TM base','Adaptation 1','Tied Belt','Adaptation 1(2nd time)','Washout'};
params={'spatialContributionPNorm','stepTimeContributionPNorm','velocityContributionPNorm','netContributionPNorm'};

adaptDataGroups{1}=Inter;
adaptDataGroups{2}=Sav;
adaptDataInter=cellfun(@(x) x.adaptData,adaptDataGroups(1),'UniformOutput',false); %Notice that adaptDataGroups(1) decide that I only want to plot the CG group
adaptDataSav=cellfun(@(x) x.adaptData,adaptDataGroups(2),'UniformOutput',false); %Notice that adaptDataGroups(1) decide that I only want to plot the CG group


[Fh,Avg_Inter,Indv_Inter]=adaptationData.plotAvgTimeCourse(adaptDataInter,params,conditions_inter,binwidth,trialMarkerFlag,indivFlag,indivSubs,colorOrder,biofeedback,removeBiasFlag,labels,filterFlag,plotHandles,alignEnd,alignIni);
[Fh,Avg_Sav,Indv_Sav]=adaptationData.plotAvgTimeCourse(adaptDataSav,params,conditions_sav,binwidth,trialMarkerFlag,indivFlag,indivSubs,colorOrder,biofeedback,removeBiasFlag,labels,filterFlag,plotHandles,alignEnd,alignIni);


A1_Inter= Avg_Inter.netContributionPNorm.Adaptation1.trial1 ;%- Avg_Inter.velocityContributionPNorm.Adaptation1.trial1;
A1_Sav= Avg_Sav.netContributionPNorm.Adaptation1.trial1; %- Avg_Sav.velocityContributionPNorm.Adaptation1.trial1;

A1_2_Inter= Avg_Inter.netContributionPNorm.Adaptation12ndtime.trial1 ;%- Avg_Inter.velocityContributionPNorm.Adaptation12ndtime.trial1;
A1_2_Sav= Avg_Sav.netContributionPNorm.Adaptation12ndtime.trial1 ;%- Avg_Sav.velocityContributionPNorm.Adaptation12ndtime.trial1;


A1_Inter=A1_Inter(1:590);
A1_Sav=A1_Sav(1:590);
A1_2_Inter=A1_2_Inter(1:590);
A1_2_Sav= A1_2_Sav(1:590);

figure
plot(1:length(A1_Sav),A1_Sav,'o','MarkerSize',5,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[0.7 0.7 0.7]); 
hold on 
plot(1:length(A1_2_Inter),A1_2_Inter,'o','MarkerSize',5,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[0.5 0.4 0.2]); 