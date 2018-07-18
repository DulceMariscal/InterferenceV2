%Getting Height and 1st stride data for each subject to run correlation
clear all
close all
load('GroupDataAllSubjectsV7.mat')
group=2;
indsub={Inter.ID, Sav.ID};

sub=[length(indsub{1}) length(indsub{2})];
names=[Inter Sav];
% Regressors=nan(sub(1)+sub(2),5);
sex=nan(sub(1)+sub(2),1);
ind=0;
 poster_colors; 
colorOrder=[p_red; p_orange; p_fade_green; p_fade_blue; p_plum; p_green; p_blue; p_fade_red; p_lime; p_yellow; [0 0 0]];


for gr=1:group
for s=1:sub(gr)
     ind=ind+1;  
%     load([indsub{gr}{s}, 'params.mat'])
%     load([names(gr).adaptData(s)])
    adaptData= names(gr).adaptData{s};
    sex(ind, :)=strcmp(adaptData.subData.sex, 'Male');
%     RegressorsV7(ind,:)=[adaptData.subData.age, adaptData.subData.weight, adaptData.subData.height, adaptData.subData.weight/(adaptData.subData.height/100)^2,   gr];


end 
end


load('RegressorsV7.mat')


% load('netContributionPNormAllDataV7ResultsAllSubjects.mat')
% load('ExtAdaptPNormV7ResultsAllSubjects.mat')
load('spatialContributionPNormAllDataV7ResultsAllSubjects.mat')


RegressorsV7=[RegressorsV7 sex];

Strides_A1=[STRIDES_1_INT(:,1);STRIDES_1_SAV(:,2)];
Strides_A1(any(isnan(Strides_A1), 2), :) = [];

figure
compute_and_plot_regression_lineDM(Strides_A1,RegressorsV7(:,3),RegressorsV7(:,5),'SP_{A1-1}','Height')
hold on

for i=1:size(RegressorsV7,1)
    if RegressorsV7(i,6)==1
plot(Strides_A1(i),RegressorsV7(i,3),'xg')
    else
  plot(Strides_A1(i),RegressorsV7(i,3),'xm')
    end
end
legendOld= get(legend(gca),'String'); 
legend([legendOld, 'female','male'])
int=find(RegressorsV7(:,5)==1);
sav=find(RegressorsV7(:,5)==2);

[h,p,ci,stats] = ttest2(RegressorsV7(int,3),RegressorsV7(sav,3));
hold off

figure
hold on
bar(1,mean(RegressorsV7(int,3)),'r')
bar(2,mean(RegressorsV7(sav,3)),'b')
for s=1:length(RegressorsV7(int,3))
    plot(1,RegressorsV7(int(s),3),'*','MarkerFaceColor',colorOrder(s,:)) 
end
for s=1:length(RegressorsV7(sav,3))
     plot(2,RegressorsV7(sav(s),3),'*','MarkerFaceColor',colorOrder(s,:))
end
errorbar(1,mean(RegressorsV7(int,3)),std(RegressorsV7(int,3))/sqrt(length(RegressorsV7(int,3))),'.','LineWidth',2,'Color','k')
errorbar(2,mean(RegressorsV7(sav,3)),std(RegressorsV7(sav,3))/sqrt(length(RegressorsV7(sav,3))),'.','LineWidth',2,'Color','k')
set(gca,'Xtick',[1 2],'XTickLabel',{'Interferece' 'Savings'},'fontSize',12)
ylabel('Height (cm)')
title(['t-test p-value=' num2str(p)])
