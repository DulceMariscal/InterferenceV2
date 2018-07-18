%%
%Washout t-test
poster_colors;
colorOrder=[p_red; p_orange; p_fade_green; p_fade_blue; p_plum; p_green; p_blue; p_fade_red; p_lime; p_yellow; [0 0 0]];

% load('ExtAdaptNorm2Epoachs.mat')
% param={'ExtAdaptNorm2'};

% load('ExtAdaptNorm2ShiftedEpoachs.mat')
% param={'ExtAdaptNorm2Shifted'};

% load('ExtAdaptPNormEpoachs.mat')
% param={'ExtAdaptPNorm'};

% load('ExtAdaptPNormShiftedEpoachs.mat')
% param={'ExtAdaptPNormShifted'};

load('stepLengthAsymEpochs.mat')
param={'stepLengthAsym'};

% load('stepLengthAsymShiftedEpochs.mat')
% param={'stepLengthAsymShifted'};


[h,p,ci,stats] = ttest2(Inter_Epoachs(:,5),Sav_Epoachs(:,5));
figure 
hold on 

bar(1,nanmean(Inter_Epoachs(:,5)),'facecolor','r')
bar(2,nanmean(Sav_Epoachs(:,5)),'facecolor','b')
for sub=1:length(Inter_Epoachs(:,5))
     plot(1,Inter_Epoachs(sub,5),'*','MarkerFaceColor',colorOrder(sub,:))
 end
 for sub=1:length(Sav_Epoachs(:,5))
     plot(2,Sav_Epoachs(sub,5),'*','MarkerFaceColor',colorOrder(sub,:))
 end
 
errorbar(1,mean(Inter_Epoachs(:,5)),nanstd(Inter_Epoachs(:,5))/sqrt(length(Inter_Epoachs(:,5))),'.','LineWidth',2,'Color','k')
errorbar(2,mean(Sav_Epoachs(:,5)),std(Sav_Epoachs(:,5))/sqrt(length(Sav_Epoachs(:,5))),'.','LineWidth',2,'Color','k')
legend('Interference','Savings')

ylabel('Washout 5 strides')
title([param; 't-test p-value=' num2str(p)])

[h,p,ci,stats] = ttest2(Inter_Epoachs(:,6),Sav_Epoachs(:,6));
figure 
hold on 

bar(1,nanmean(Inter_Epoachs(:,6)),'facecolor','r')
bar(2,nanmean(Sav_Epoachs(:,6)),'facecolor','b')
for sub=1:length(Inter_Epoachs(:,6))
     plot(1,Inter_Epoachs(sub,6),'*','MarkerFaceColor',colorOrder(sub,:))
 end
 for sub=1:length(Sav_Epoachs(:,6))
     plot(2,Sav_Epoachs(sub,6),'*','MarkerFaceColor',colorOrder(sub,:))
 end
 
errorbar(1,mean(Inter_Epoachs(:,6)),nanstd(Inter_Epoachs(:,6))/sqrt(length(Inter_Epoachs(:,6))),'.','LineWidth',2,'Color','k')
errorbar(2,mean(Sav_Epoachs(:,6)),std(Sav_Epoachs(:,6))/sqrt(length(Sav_Epoachs(:,6))),'.','LineWidth',2,'Color','k')
legend('Interference','Savings')

ylabel('Washout all strides')
title([param; 't-test p-value=' num2str(p)])