%Extend of Adaptation
clear all;
close all;
clc
% cd('C:\Users\dum5\OneDrive - University of Pittsburgh\InterferenceStudy\Params Files\subjectsData')
% load('velocityContributionNorm2AllData.mat')
% load('netContributionNorm2AllData.mat')

% load('velocityContributionPNormAllDataV8_ALL.mat')
% load('netContributionPNormAllDataV8_ALL.mat')

% load('velocityContributionPNormAllDataV9.mat')
% load('netContributionPNormAllDataV9.mat')

% load('netContributionPNormV8ALL_nan.mat')
% load('velocityContributionPNormV8ALL_nan.mat')

% load('netContributionPNormV9_nan.mat')
% load('velocityContributionPNormV9_nan.mat')

% load('netContributionPNormV10.mat')
% load('velocityContributionPNormV10.mat')

load('netContributionPNormV10_WO1stStride.mat')
load('velocityContributionPNormV10_WO1stStride.mat')


% load('velocityContributionPNormV9_median.mat')
% load('netContributionPNormV9_median.mat')
load('NoRemovingAnyStridesV7_Model.mat')
% load('StridesToRemovenetContributionPNormAllDataV5')


groups = 2;
conditions = 2;
% subs = [8 9];
indSubs = {setdiff(1:9, []), setdiff(1:10, [])};
% indSubs = {setdiff(1:11,[]), setdiff(1:13, [])};
subs = [length(indSubs{1}) , length(indSubs{2})];
charGroups = {'INT','SAV'};
nconds = [6 5];
INT=1;
SAV=2;

ExtAdaptSAV=cell(subs(2), nconds(SAV));
ExtAdaptINT=cell(subs(1), nconds(INT));

params={'netContributionPNorm','velocityContributionPNorm'};
cond_Inter=1:6;
cond_Sav=1:5;


for c=1:6
    for i=1:subs(1)
        velocityContributionPNormINT{i,c}(any(isnan(velocityContributionPNormINT{i,c}), 2), :) = [];
        netContributionPNormINT{i,c}(any(isnan(netContributionPNormINT{i,c}), 2), :) = [];
        
    end
end

for c=1:5
    for s=1:subs(2)
        velocityContributionPNormSAV{i,c}(any(isnan( velocityContributionPNormSAV{i,c}), 2), :) = [];
        netContributionPNormSAV{i,c}(any(isnan(netContributionPNormSAV{i,c}), 2), :) = [];
    end
end


INTERFERENCE_DATA=cell(6,subs(1),2);
% Int_empties = cellfun('isempty',INTERFERENCE_DATA);

% strides_Inter=[150 600 600 750 600 150];
stridesInt=[145 590 595 745 595 145];
for c=1:6
    for i=1:subs(1)
        INTERFERENCE_DATA(c,i,:) = {NaN(stridesInt(c),1)};
    end
end


SAVINGS_DATA=cell(5,subs(2),2);
% SAV_empties = cellfun('isempty',SAVINGS_DATA);
% strides_Sav=[150 600 1350 600 150];
stridesSav=[145 590 1340 595 145];
for c=1:5
    for s=1:subs(2)
        SAVINGS_DATA(c,s,:) = {NaN(stridesSav(c),1)};
    end
end



for p=1:length(params)
    
    
    eval(['slaI=[' params{p} 'INT];'])
    eval(['slaS=[' params{p} 'SAV];'])
    
    
    for i=1:subs(1)
        
        %         load([params{p} 'AllData.mat'])
        
        
        data_A1_Inter=slaI{i,cond_Inter(1)};
%         INTERFERENCE_DATA{1,i,p}(1:length(data_A1_Inter(minNOSToRemove(i,1):end)))=data_A1_Inter(minNOSToRemove(i,1):stridesInt(1),1);
           INTERFERENCE_DATA{1,i,p}=data_A1_Inter(minNOSToRemove(i,1):stridesInt(1),1);
        
%         if  i==7
%             INTERFERENCE_DATA{2,i,p}=nan(1000,1);
%         else
            data_A2_Inter=slaI{i,cond_Inter(2)};
            INTERFERENCE_DATA{2,i,p}=(data_A2_Inter(minNOSToRemove(i,1):stridesInt(2)));
%         end
        
        
        
        data_A3_Inter=slaI{i,cond_Inter(3)};
        INTERFERENCE_DATA{3,i,p}=(data_A3_Inter(minNOSToRemove(i,1):stridesInt(3),1));
        
        data_A4_Inter=slaI{i,cond_Inter(4)};
        INTERFERENCE_DATA{4,i,p}=(data_A4_Inter(minNOSToRemove(i,1):stridesInt(4),1));
        
        data_A5_Inter=slaI{i,cond_Inter(5)};
        INTERFERENCE_DATA{5,i,p}=(data_A5_Inter(minNOSToRemove(i,1):stridesInt(5),1));
        
        data_A6_Inter=slaI{i,cond_Inter(6)};
        INTERFERENCE_DATA{6,i,p}=(data_A6_Inter(minNOSToRemove(i,1):stridesInt(6),1));
        
        
    end
    
    
    
    for s=1:subs(2)
        
        data_A1_Sav=slaS{s,cond_Sav(1)};
        SAVINGS_DATA{1,s,p}=(data_A1_Sav(minNOSToRemove(s,2):stridesSav(1),1));
        
        data_A2_Sav=slaS{s,cond_Sav(2)};
        SAVINGS_DATA{2,s,p}=(data_A2_Sav(minNOSToRemove(s,2):stridesSav(2),1));
        
        data_A3_Sav=slaS{s,cond_Sav(3)};
        SAVINGS_DATA{3,s,p}=(data_A3_Sav(minNOSToRemove(s,2):stridesSav(3),1));
        
        data_A4_Sav=slaS{s,cond_Sav(4)};
        SAVINGS_DATA{4,s,p}=(data_A4_Sav(minNOSToRemove(s,2):stridesSav(4),1));
        
        
%         if s==5 || s==9
%             SAVINGS_DATA{5,s,p}=nan(1000,1);
%         else
            data_A5_Sav=slaS{s,cond_Sav(5)};
            SAVINGS_DATA{5,s,p}=(data_A5_Sav(minNOSToRemove(s,2):stridesSav(5),1));
%         end
        
    end
    
end

cond=[6 5];
SLA_INT_shifted=[];
SLA_INT_SEshifted=[];
SLA_SAV_shifted=[];
SLA_SAV_SEshifted=[];
AVG_Cond_INT=[];
AVG_Cond_SAV=[];


% for p=1:length(params)
%     
%     SLA_INT_shifted=[];
%     SLA_INT_SEshifted=[];
%     SLA_SAV_shifted=[];
%     SLA_SAV_SEshifted=[];
%     
%     
%     for c=1:cond(1)
%         
%         [iA1m, iA1SE] = average_curves(INTERFERENCE_DATA(c,:,p));
%         if c==3
%             
%             SLA_INT_shifted=[SLA_INT_shifted iA1m];
%             SLA_INT_SEshifted=[SLA_INT_SEshifted iA1SE];
%             
%         else
%             SLA_INT_shifted=[SLA_INT_shifted iA1m nan(1,5)];
%             SLA_INT_SEshifted=[SLA_INT_SEshifted iA1SE nan(1,5)];
%         end
%         if p==2
%             AVG_Cond_INT=[AVG_Cond_INT nanmean(iA1m)];
%         end
%         
%         
%         
%     end
%     
%     
%     for c=1:cond(2)
%         
%         [sA1m, sA2se] = average_curves(SAVINGS_DATA(c,:,p));
%         
%         SLA_SAV_shifted=[SLA_SAV_shifted sA1m nan(1,5)];
%         SLA_SAV_SEshifted=[SLA_SAV_SEshifted sA2se nan(1,5)];
%         
%         if p==2
%             AVG_Cond_SAV=[AVG_Cond_SAV nanmean(sA1m)];
%         end
%         
%         
%     end
%     
%     
%     if p==2
%         VelocityAVG_INT= SLA_INT_shifted;
%         VelocitySE_INT= SLA_INT_SEshifted;
%         AVG_Velocity_Cond_INT=abs(AVG_Cond_INT);
%         
%         VelocityAVG_SAV= SLA_SAV_shifted;
%         VelocitySE_SAV= SLA_SAV_SEshifted;
%         AVG_Velocity_Cond_SAV=abs(AVG_Cond_SAV);
%         
%         
%     else
%         
%         NetAVG_INT=SLA_INT_shifted;
%         NetSE_INT=SLA_INT_SEshifted;
%         
%         NetAVG_SAV= SLA_SAV_shifted;
%         NetSE_SAV= SLA_SAV_SEshifted;
%     end
%     
%     
%     
% end



ExtAdaptAvg_INT=[];
ExtAdaptSE_INT=[];
ExtAdaptAvg_SAV=[];
ExtAdaptSE_SAV=[];



for gr=1:groups
    %     sub=0;
    for s=1:subs(gr)
        %         sub=indSubs{gr}(s);
        
        %     sub=s;
        for cond=1:nconds(gr)
            
            %    eval(['ExtAdapt' charGroups{gr} '{s,cond}=netContributionPNorm' charGroups{gr} '{sub,cond}-velocityContributionPNorm' charGroups{gr} '{sub,cond};'])
            if gr==1
                %                  sub=sub+1;
                ExtAdaptINT{s,cond}=INTERFERENCE_DATA{cond,s,1}-INTERFERENCE_DATA{cond,s,2};
                %                 [iA1m, iA1SE] = average_curves(ExtAdaptINT{s,cond});
                %                 ExtAdaptAvg_INT=[ExtAdaptAvg_INT iA1m];
                %                 ExtAdaptSE_INT=[ExtAdaptSE_INT iA1SE];
                
            else
                %                  sub=sub+1;
                ExtAdaptSAV{s,cond}=SAVINGS_DATA{cond,s,1}-SAVINGS_DATA{cond,s,2};
            end
            
            
            
            
        end
    end
end
for gr=1:groups
for cond=1:nconds(gr)
    
    if gr==1
   
        [iA1m, iA1SE] = average_curves(ExtAdaptINT(:,cond));
        
        if cond==3
            
            ExtAdaptAvg_INT=[ExtAdaptAvg_INT iA1m];
            ExtAdaptSE_INT=[ExtAdaptSE_INT iA1SE];
            
        else
            ExtAdaptAvg_INT=[ExtAdaptAvg_INT iA1m(1:end) nan(1,5)];
            ExtAdaptSE_INT=[ExtAdaptSE_INT iA1SE(1:end) nan(1,5)];
        end
        
        
    else

        [sA1m, sA1SE] = average_curves(ExtAdaptSAV(:,cond));
        
        
        ExtAdaptAvg_SAV=[ExtAdaptAvg_SAV sA1m(1:end) nan(1,5)];
        ExtAdaptSE_SAV=[ExtAdaptSE_SAV sA1SE(1:end) nan(1,5)];
        
        
    end
    
    
    
    
end
end

% for i=1:subs(2)
%     s=indSubs{2}(i);
%     %     s=i;
%     data_A1_Sav=ExtAdaptSAV{s,2};
%     SAVINGS_DATA{1,i}=data_A1_Sav(minNOSToRemove(s,2):end,1);
%
%     data_A2_Sav=ExtAdaptSAV{s,4};
%     SAVINGS_DATA{2,i}=data_A2_Sav(minNOSToRemove(s,2):end,1);
%
% end

% [sA1m, sA1std] = average_curves(ExtAdaptSAV{:,2}); %avg_adapt_curve_sav [sA1m,sA2std]


% ExtAdaptINT=VelocityAVG_INT-NetAVG_INT;
% ExtAdaptSAV=VelocityAVG_SAV-NetAVG_SAV;

%%
%%DMMO
%Elimination discontuities due to rest 
% ExtAdaptAvg=[];
% % ExtAdaptAvg(1,:)=NetAVG_INT-VelocityAVG_INT;
% % ExtAdaptAvg(2,:)=NetAVG_SAV-VelocityAVG_SAV;
% stop1=1040:1092;
% stop2=1340:1366;
% ExtAdaptAvg_INT(stop1)=nan;
% ExtAdaptAvg_INT(stop2)=nan;
% gap1=1021:1120;
% gap2=1329:1369;
% DataToLinear=ExtAdaptAvg_INT(gap1);
% DataToLinear2=ExtAdaptAvg_INT(gap2);
% [~, dataFit] = my_exp_fit(DataToLinear,'Increasing','Line');
% [~, dataFit2] = my_exp_fit(DataToLinear2,'Increasing','Line');
% % [expFitPars, dataFit] = my_exp_fit(DataToLinear,'Decreasing','Single');
% ExtAdaptAvg_INT(stop1)=dataFit(stop1(1)-gap1(1):stop1(1)-gap1(1)+length(stop1)-1);
% ExtAdaptAvg_INT(stop2)=dataFit2(stop2(1)-gap2(1):stop2(1)-gap2(1)+length(stop2)-1);

ExtAdaptAvg(1,:)=ExtAdaptAvg_INT;
ExtAdaptAvg(2,:)=ExtAdaptAvg_SAV;



%%
% strides_Sav=[150 600 1350 600 150];
% strides_Inter=[150 600 600 750 600 150];

% inter_velo=[zeros(1,153) ones(1,603) -1*ones(1,590) linspace(-1,0,698) zeros(1,60) ones(1,603) zeros(1,156)];
% Int_Velo=[zeros(1,150) nan(1,5) -nanmean([AVG_Cond_SAV(4);AVG_Cond_INT(5)])*ones(1,600) nan(1,5) -AVG_Cond_INT(3)*ones(1,600)...
%     linspace(-AVG_Cond_INT(3),0,600) zeros(1,150) nan(1,5)  -nanmean([AVG_Cond_SAV(4);AVG_Cond_INT(5)])*ones(1,600) nan(1,5) zeros(1,150) nan(1,5)];
% 
% sav_velo=[zeros(1,150) nan(1,5) -nanmean([AVG_Cond_SAV(4);AVG_Cond_INT(5)])*ones(1,600) nan(1,5) zeros(1,1350) nan(1,5)...
%     -nanmean([AVG_Cond_SAV(4);AVG_Cond_INT(5)])*ones(1,600) nan(1,5) zeros(1,150) nan(1,5)];

%REMOVING LAST 5 STRIDES OF EACH CONDITOON
% Int_Velo=[zeros(1,150) -nanmean([AVG_Cond_SAV(4);AVG_Cond_INT(5)])*ones(1,600) -AVG_Cond_INT(3)*ones(1,600)...
%     linspace(-AVG_Cond_INT(3),0,600) zeros(1,150) -nanmean([AVG_Cond_SAV(4);AVG_Cond_INT(5)])*ones(1,600) zeros(1,150)];
% 
% sav_velo=[zeros(1,150)  -nanmean([AVG_Cond_SAV(4);AVG_Cond_INT(5)])*ones(1,600)  zeros(1,1350) ...
%     -nanmean([AVG_Cond_SAV(4);AVG_Cond_INT(5)])*ones(1,600)  zeros(1,150)];



%%

% ExtAdaptAvg(:,746:751)=[];
% ExtAdaptAvg(:,2703:2706)=[];
% ExtAdaptAvg(:,2703:2704)=[];


ExtAdaptSE(1,:)=ExtAdaptSE_INT;
ExtAdaptSE(2,:)=ExtAdaptSE_SAV;

% ExtAdaptSE(:,746:751)=[];
% ExtAdaptSE(:,2703:2706)=[];
% ExtAdaptSE(:,2703:2704)=[];

% ExtAdaptAvg(:,151:156)=[];
% ExtAdaptSE(:,151:156)=[];
% sav_velo(:,151:156)=[];
% Int_Velo(:,151:156)=[];

% ExtAdaptAvg(:,2305)=[];



% figure
% subplot(2,1,1)
% h1=boundedline(1:length( VelocityAVG_INT), VelocityAVG_INT,VelocitySE_INT,'or',1:length(NetAVG_INT), NetAVG_INT,NetSE_INT,'ob');
% axis tight
% title('Interference')
% % ylabel(params)
% xlabel('strides')
% subplot(2,1,2)
% boundedline(1:length( VelocityAVG_SAV), VelocityAVG_SAV,VelocitySE_SAV,'or',1:length( NetAVG_SAV), NetAVG_SAV,NetSE_SAV,'ob');
% title('Savings')
% % ylabel(params)
% legend(h1,params{2},params{1})




%%
%Alessandro Code 
ShifteData=0;

adaptation=[ExtAdaptAvg(1,:) ExtAdaptAvg(2,:)]';
adaptations=[ExtAdaptAvg(1,:); ExtAdaptAvg(2,:)];
% perturbations=[Int_Velo;sav_velo];
% perturbation=[perturbations(1,:) perturbations(2,:)]';
basStds=nanstd(adaptations(:,1:150),[],2);
basStd=nanstd(basStds);

mp = max(max(abs(adaptations(:,1:700))));

%Perturbations 

pertI = [ zeros(1,150) mp*ones(1,595) (-mp)*ones(1,600),...
            linspace(-mp,0,595) zeros(1,150) mp*ones(1,600) zeros(1,150)];
pertS = [ zeros(1,150) mp*ones(1,595) zeros(1,1345) mp*ones(1,600) zeros(1,150)];

perturbations = [pertI; pertS];
perturbation = [pertI pertS];


if ShifteData==1
adaptationsShift = adaptations + perturbations;
end

%%
%plots 

figure
set(gcf,'color','w');
[marker,patch]=boundedline(1:length(ExtAdaptAvg(1,:)), ExtAdaptAvg(1,:),ExtAdaptSE(1,:),'or','alpha',1:length(ExtAdaptAvg(2,:)), ExtAdaptAvg(2,:),ExtAdaptSE(2,:),'ob');
set(marker(1),'MarkerFaceColor','r','MarkerEdgeColor','k')
set(marker(2),'MarkerFaceColor','b','MarkerEdgeColor','k')
set(patch(1),'FaceColor','r','FaceAlpha',.5)
set(patch(2),'FaceColor','blue','FaceAlpha',.5)
legend('INT','SAV')
ylabel('SLA')
axis tight
% line([1 ],[])


figure;hold on
set(gcf,'color','w');
scatter(1:length(ExtAdaptAvg(1,:)),ExtAdaptAvg(1,:),45,'filled')
scatter(1:length(ExtAdaptAvg(2,:)),ExtAdaptAvg(2,:),45,'filled')
% plot(1:length(ExtAdaptAvg(1,:)),ExtAdaptAvg(1,:))
% plot(1:length(ExtAdaptAvg(2,:)),ExtAdaptAvg(2,:))
plot(1:length(pertI),pertI)
plot(1:length(pertS),pertS)
legend('INT','SAV')
ylabel('ExtAdapt')
% ylabel('velocityContributionPNorm')
axis tight



%ALESSANDRO's plots 

% figure;hold on
% scatter(1:length(adaptationsShift(1,:)), adaptationsShift(1,:),45,'filled')
% scatter(1:length(adaptationsShift(2,:)),adaptationsShift(2,:),45,'filled')
% % plot(1:length(ExtAdaptAvg(1,:)),ExtAdaptAvg(1,:))
% % plot(1:length(ExtAdaptAvg(2,:)),ExtAdaptAvg(2,:))
% plot(1:length(pertI),pertI)
% plot(1:length(pertS),pertS)
% legend('INT','SAV')
% ylabel('SLA shifted')
% axis tight
% 
% 
% figure
% [marker,patch]=boundedline(1:length(adaptationsShift(1,:)), adaptationsShift(1,:),ExtAdaptSE(1,:),'or','alpha',1:length(adaptationsShift(2,:)), adaptationsShift(2,:),ExtAdaptSE(2,:),'ob');
% set(marker(1),'MarkerFaceColor','r','MarkerEdgeColor','k')
% set(marker(2),'MarkerFaceColor','b','MarkerEdgeColor','k')
% set(patch(1),'FaceColor','r','FaceAlpha',.5)
% set(patch(2),'FaceColor','blue','FaceAlpha',.5)
% hold on
% plot(1:length(pertI),pertI)
% plot(1:length(pertS),pertS)
% legend('INT','SAV')
% ylabel('SLA shifted')
% axis tight

save('ExtAdaptPNormV10_WO1stStride','ExtAdaptSE','ExtAdaptAvg','ExtAdaptSAV','ExtAdaptINT','ExtAdaptAvg') %12/7/2018


% save('NetContributionsV8_all','adaptation','adaptations')
%
% save('ExtAdaptPNormAllData_FittingData','ExtAdaptSE','ExtAdaptAvg','ExtAdaptSAV','ExtAdaptINT','ExtAdaptAvg','VelocityAVG_INT','VelocityAVG_SAV','AVG_Velocity_Cond_SAV','AVG_Cond_INT')
% save('ExtAdaptPNormV10','ExtAdaptSE','ExtAdaptAvg','ExtAdaptSAV','ExtAdaptINT','ExtAdaptAvg','VelocityAVG_INT','VelocityAVG_SAV','AVG_Velocity_Cond_SAV','AVG_Cond_INT')
% cd('C:\Users\dum5\OneDrive - University of Pittsburgh\InterferenceStudy\Params Files\DataModels')
% save('ExtAdaptation_V10','adaptation','adaptations','perturbation','perturbations','basStds','basStd')




