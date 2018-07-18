%To shift the data
cd('C:\Users\dum5\OneDrive\_Shared Drive - Interference Project - Alessandro - Dulce_\Params Files\subjectsData')

clc
% close all
clear all
% load('SlaAvgIdv.mat')
% load('minNOSToRemoveAle.mat')
% load('StridesToRemove.mat')
% gait_par='StepLengthAsym';
%
%for ExtAdaptaiton= SLA-SV
% load('ExtAdaptAllData.mat')
% % % load('StridesToRemoveExtAdpat.mat')
% gait_par='ExtAdaptWithHip';

%For step length asymmetry
% load('StridesToRemove.mat')
% load('NoRemovingAnyStridesV2.mat')
% load('stepLengthAsymAllData.mat')
% param={'stepLengthAsym'};
% eval(['slaI=[' param 'INT];'])
% eval(['slaS=[' param 'SAV];'])

%for ExtAdaptaiton= SLA-SV
% load('ExtAdaptNorm2AllData.mat')
% % load('StridesToRemoveExtAdpat.mat')
% param={'ExtAdaptNorm2'};

load('netContributionPNormAllDataV8_ALL.mat')
param={'netContributionPNormAllDataV8_ALL'};
slaI=netContributionPNormINT;
slaS=netContributionPNormSAV;



load('NoRemovingAnyStridesV7_Model.mat')
%No hip
% load('ExtAdaptPNormAllDataV8_ALL.mat')
% slaI=ExtAdaptINT;
% slaS=ExtAdaptSAV;

% load('ExtAdaptPNormAllDataWithNAN.mat')
% load('ExtAdaptPNormAllDataALL.mat')
% load('ExtAdaptPNormAllDataWithNANV4.mat')
% load('NoRemovingAnyStrides.mat')
% load('StridesToRemoveExtAdaptPNorm')

% param={'ExtAdaptPNorm'};
% slaI=ExtAdaptINT;
% slaS=ExtAdaptSAV;


cond_Inter=1:6;
cond_Sav=1:5;
charGroups = {'S','I'};
%
% indSubs = {setdiff(1:9, []), setdiff(1:8, [])};
% indSubs = {setdiff(1:9, [2 5]), setdiff(1:8, [1 7])};
indSubs = {setdiff(1:11,[]), setdiff(1:13, [])};
subs = {length(indSubs{1}) , length(indSubs{2})};

for i=1:subs{1}
    s=indSubs{1}(i);
    %     s=i;if 
    if i==7
        INTERFERENCE_DATA{1,i}=nan(1000,1);
    else
        data_A1_Inter=slaI{s,2};
        INTERFERENCE_DATA{1,i}=data_A1_Inter(minNOSToRemove(s,1):end,1);
    end
    
    data_A2_Inter=slaI{s,5};
    INTERFERENCE_DATA{2,i}=data_A2_Inter(minNOSToRemove(s,1):end,1);
    
    
end



for i=1:subs{2}
    s=indSubs{2}(i);
    %     s=i;
    
    
    data_A1_Sav=slaS{s,2};
    SAVINGS_DATA{1,i}=data_A1_Sav(minNOSToRemove(s,2):end,1);
    
    data_A2_Sav=slaS{s,4};
    SAVINGS_DATA{2,i}=data_A2_Sav(minNOSToRemove(s,2):end,1);
    
end


% Adaptation 1-------------------------------------------------------------
[iA1m, iA1SE] = average_curves(INTERFERENCE_DATA(1,:)); %avg_adapt_curve_int [iA1m,iA2std]
[sA1m, sA1std] = average_curves(SAVINGS_DATA(1,:)); %avg_adapt_curve_sav [sA1m,sA2std]
[iA2m, iA2std] = average_curves(INTERFERENCE_DATA(2,:)); %avg_adapt_curve_int [iA1m,iA2std]
[sA2m, sA2se] = average_curves(SAVINGS_DATA(2,:)); %avg_adapt_curve_sav [sA1m,sA2std]




INT_min=nanmin(iA1m);
SAV_min=nanmin(sA1m);
MinValAdapt=min([INT_min SAV_min]);

INTERFERENCE_DATA=[];
SAVINGS_DATA=[];
INT_max=nanmax(iA2m);
SAV_max=nanmax(sA2m);
MaxValAdapt=1;
% MaxValAdapt=max([INT_max SAV_max]);
% MaxValAdapt=max([INT_max SAV_max])-MinValAdapt;
% MaxValAdapt=1;

INTERFERENCE_DATA=cell(6,8,1);
% Int_empties = cellfun('isempty',INTERFERENCE_DATA);

% strides=[153 600 613 753 600 153];
% strides=[153 600 613 753 600 153];
stridesInt=[150 600 599 750 600 149];
for c=1:6
    for i=1:8
        INTERFERENCE_DATA(c,i,:) = {NaN(stridesInt(c),1)};
    end
end


SAVINGS_DATA=cell(5,9,1);

% SAV_empties = cellfun('isempty',SAVINGS_DATA);
% strides=[153 600 1366 600 153];
% strides=[150 600 1349 600 149];
stridesSav=[150 600 1349 600 149];
for c=1:5
    for s=1:9
        SAVINGS_DATA(c,s,:) = {NaN(stridesSav(c),1)};
    end
end

for cond=1:length(cond_Inter)
    for i=1:subs{1} %8
        s=indSubs{1}(i);
        %     s=i;
        
        data_A1_Inter=slaI{s,cond_Inter(1)};
        INTERFERENCE_DATA{1,i}(1:length(data_A1_Inter(1:stridesInt(1))))=(data_A1_Inter(1:stridesInt(1),1))./MaxValAdapt;
        
        
        if  i==7
            INTERFERENCE_DATA{2,i}=nan(1000,1);
        else
            data_A2_Inter=slaI{s,cond_Inter(2)};
            if i==1
            data_A2_Inter=[data_A2_Inter; nan(150,1)];  
            end
            %         INTERFERENCE_DATA{2,i}(1:length(data_A2_Inter(minNOSToRemove(i,1):stridesInt(2)-5)))=(data_A2_Inter(minNOSToRemove(s,1):stridesInt(2)-5,1)-MinValAdapt)./MaxValAdapt;
            INTERFERENCE_DATA{2,i}(1:length(data_A2_Inter(minNOSToRemove(i,1):stridesInt(2)-5)))=(data_A2_Inter(minNOSToRemove(s,1):stridesInt(2)-5,1))./MaxValAdapt;
            
        end
        
        data_A3_Inter=slaI{s,cond_Inter(3)};
        INTERFERENCE_DATA{3,i}(1:length(data_A3_Inter(1:stridesInt(3))))=(data_A3_Inter(1:stridesInt(3),1))./MaxValAdapt;
        %    INTERFERENCE_DATA{3,i}=(data_A3_Inter(minNOSToRemove(s,1):end,1)+MinValAdapt)./MaxValAdapt;
        
        data_A4_Inter=slaI{s,cond_Inter(4)};
        INTERFERENCE_DATA{4,i}(1:length(data_A4_Inter(1:stridesInt(4))))=(data_A4_Inter(1:stridesInt(4),1))./MaxValAdapt;
        %
        %    newp=linspace(MinValAdapt,0,600);
        %     newp=linspace(MinValAdapt,0,750);
        %    newPert=[newp zeros(1,length(data_A4_Inter(minNOSToRemove(s,1):end,1))-750)]';
        %    INTERFERENCE_DATA{4,i}(1:length(data_A4_Inter(1:stridesInt(4))))=((data_A4_Inter(1:stridesInt(4),1))+newPert)./MaxValAdapt;
        
        
        %    newp=nan(1,600);
        %    newPert=0;
        %    INTERFERENCE_DATA{4,i}=((data_A4_Inter(minNOSToRemove(i,1):end,1)+MinValAdapt))./MaxValAdapt;
        %    INTERFERENCE_DATA{4,i}=((data_A4_Inter(minNOSToRemove(s,1):end,1)+newPert))./MaxValAdapt;
        
        data_A5_Inter=slaI{s,cond_Inter(5)};
        %     INTERFERENCE_DATA{5,i}=(data_A5_Inter(minNOSToRemove(s,1):end,1));
        %    INTERFERENCE_DATA{5,i}(1:length(data_A5_Inter(minNOSToRemove(i,1):stridesInt(5)-5)))=(data_A5_Inter(minNOSToRemove(s,1):stridesInt(5)-5,1)-MinValAdapt)./MaxValAdapt;
        INTERFERENCE_DATA{5,i}(1:length(data_A5_Inter(minNOSToRemove(i,1):stridesInt(5)-5)))=(data_A5_Inter(minNOSToRemove(s,1):stridesInt(5)-5,1))./MaxValAdapt;
        
        data_A6_Inter=slaI{s,cond_Inter(6)};
        INTERFERENCE_DATA{6,i}(1:length(data_A6_Inter(1:stridesInt(6))))=(data_A6_Inter(1:stridesInt(6),1)./MaxValAdapt);
        
    end
end



for cond=1:length(cond_Sav)
    for i=1:subs{2}%9
        s=indSubs{2}(i);
        
        
        data_A1_Sav=slaS{s,cond_Sav(1)};
        SAVINGS_DATA{1,i}(1:length(data_A1_Sav(1:stridesSav(1),1)))=(data_A1_Sav(1:stridesSav(1),1))./MaxValAdapt;
        
        data_A2_Sav=slaS{s,cond_Sav(2)};
        %         SAVINGS_DATA{2,i}(1:length(data_A2_Sav(minNOSToRemove(s,2):stridesSav(2)-5)))=(data_A2_Sav(minNOSToRemove(s,2):stridesSav(2)-5,1)-MinValAdapt)./MaxValAdapt;
        SAVINGS_DATA{2,i}(1:length(data_A2_Sav(minNOSToRemove(s,2):stridesSav(2)-5)))=(data_A2_Sav(minNOSToRemove(s,2):stridesSav(2)-5,1))./MaxValAdapt;
        
        data_A3_Sav=slaS{s,cond_Sav(3)};
        SAVINGS_DATA{3,i}(1:length(data_A3_Sav(1:stridesSav(3))))=(data_A3_Sav(1:stridesSav(3),1))./MaxValAdapt;
        
        data_A4_Sav=slaS{s,cond_Sav(4)};
        %    SAVINGS_DATA{4,i}(1:length(data_A4_Sav(minNOSToRemove(s,2):stridesSav(4)-5)))=(data_A4_Sav(minNOSToRemove(s,2):stridesSav(4)-5,1)-MinValAdapt)./MaxValAdapt;
        SAVINGS_DATA{4,i}(1:length(data_A4_Sav(minNOSToRemove(s,2):stridesSav(4)-5)))=(data_A4_Sav(minNOSToRemove(s,2):stridesSav(4)-5,1))./MaxValAdapt;
        
        
        if s==5 || s==9
            SAVINGS_DATA{5,i}=nan(1000,1);
        else
            data_A5_Sav=slaS{s,cond_Sav(5)};
            SAVINGS_DATA{5,i}(1:length(data_A5_Sav(1:stridesSav(5))))=(data_A5_Sav(1:stridesSav(5),1))./MaxValAdapt;
        end
        
    end
end

cond=[6 5];
ExtAdapt_INT_shifted=[];
ExtAdapt_INT_SSEshifted=[];


for c=1:cond(1)
    [iA1m, iA1SE] = average_curves(INTERFERENCE_DATA(c,:));
    
    if c==3
        %       iA1m((isnan(iA1m), 2), :) = [];
        ExtAdapt_INT_shifted=[ExtAdapt_INT_shifted iA1m];
        ExtAdapt_INT_SSEshifted=[ExtAdapt_INT_SSEshifted iA1SE];
    else
        ExtAdapt_INT_shifted=[ExtAdapt_INT_shifted iA1m  nan(1,5)];
        ExtAdapt_INT_SSEshifted=[ExtAdapt_INT_SSEshifted iA1SE nan(1,5)];
        %     ExtAdapt_INT_shifted=[ExtAdapt_INT_shifted iA1m];
        %      ExtAdapt_INT_SSEshifted=[ExtAdapt_INT_SSEshifted iA1SE ];
    end
    
    %   ExtAdapt_INT_shifted=[ExtAdapt_INT_shifted iA1m  nan(1,5)];
    %   ExtAdapt_INT_SSEshifted=[ExtAdapt_INT_SSEshifted iA1SE nan(1,5)];
    
end

ExtAdapt_SAV_shifted=[];
ExtAdapt_SAV_SEshifted=[];

for c=1:cond(2)
    [sA1m, sA2se] = average_curves(SAVINGS_DATA(c,:));
    %    sA1m(any(isnan(sA1m), 2), :) = [];
    ExtAdapt_SAV_shifted=[ExtAdapt_SAV_shifted sA1m nan(1,5)];
    ExtAdapt_SAV_SEshifted=[ExtAdapt_SAV_SEshifted sA2se nan(1,5)];
    %   ExtAdapt_SAV_shifted=[ExtAdapt_SAV_shifted sA1m];
    %   ExtAdapt_SAV_SEshifted=[ExtAdapt_SAV_SEshifted sA2se];
    
    
end

ExtAdaptINT=INTERFERENCE_DATA';
ExtAdaptSAV=SAVINGS_DATA';

ExtAdapt_SAV_shifted(:,745:750)=[];
% ExtAdapt_SAV_shifted(:,2295)=[];
% ExtAdapt_SAV_shifted(:,2172)=[];

ExtAdapt_SAV_SEshifted(:,745:750)=[];
% ExtAdapt_SAV_SEshifted(:,2295)=[];
% ExtAdapt_SAV_SEshifted(:,2172)=[];

ExtAdapt_INT_shifted(:,745:750)=[];
% ExtAdapt_INT_shifted(:,2295)=[];
% ExtAdapt_INT_shifted(:,2172)=[];

ExtAdapt_INT_SSEshifted(:,745:750)=[];
% ExtAdapt_INT_SSEshifted(:,2295)=[];
% % ExtAdapt_INT_shifted(:,2172)=[];

% ExtAdapt_SAV_shifted(:,2141)=[];
% ExtAdapt_SAV_SEshifted(:,2141)=[];
% ExtAdapt_INT_SSEshifted(:,2141)=[];
% ExtAdapt_INT_shifted(:,2141)=[];

% Int_Velo=[zeros(1,153) (.332-MinValAdapt)*ones(1,600) -.332*ones(1,599)...
%     linspace(-.332,0,694) zeros(1,52) (.332-MinValAdapt)*ones(1,602) zeros(1,152) nan(1,5)];

% Int_Velo=[zeros(1,153) (.332-MinValAdapt)*ones(1,600) -.332*ones(1,599)...
%     linspace(-.332,0,694) zeros(1,59) (.332)*ones(1,602) zeros(1,155) nan(1,5)];

Int_Velo=[zeros(1,153) ones(1,592) -ones(1,599)...
    linspace(-1,0,694) zeros(1,59) ones(1,602) zeros(1,155) nan(1,3)];

% sav_velo=[zeros(1,153)  (.332-MinValAdapt)*ones(1,600) zeros(1,1345)...
%     (.332-MinValAdapt)*ones(1,602) zeros(1,152) nan(1,5)];

sav_velo=[zeros(1,153)  ones(1,592) zeros(1,1352)...
    ones(1,602) zeros(1,155) nan(1,3)];




figure
hold on
scatter(1:length(ExtAdapt_INT_shifted),ExtAdapt_INT_shifted,'filled')
scatter(1:length(ExtAdapt_SAV_shifted),ExtAdapt_SAV_shifted,'filled')
% plot(1:length(ExtAdapt_INT_shifted),ExtAdapt_INT_shifted,'r')
% plot(1:length(ExtAdapt_SAV_shifted),ExtAdapt_SAV_shifted,'b')
% h1=boundedline(1:length(SLA_INT_shifted),SLA_INT_shifted,SLA_INT_SSEshifted,'r',1:length(SLA_SAV_shifted),SLA_SAV_shifted,SLA_SAV_SEshifted,'b');
plot(1:length(Int_Velo),Int_Velo)
plot(1:length(sav_velo),sav_velo)
legend('INT','SAV')
axis tight
ylabel([param 'Shifted'])
grid
xlabel('strides')
title('A1 shifted')

% figure
% h1=boundedline(1:length(ExtAdapt_INT_shifted),ExtAdapt_INT_shifted,ExtAdapt_INT_SSEshifted,'r',1:length(ExtAdapt_SAV_shifted),ExtAdapt_SAV_shifted,ExtAdapt_SAV_SEshifted,'b');






adaptation=[ExtAdapt_INT_shifted  ExtAdapt_SAV_shifted]';
adaptations=[ExtAdapt_INT_shifted ; ExtAdapt_SAV_shifted];
perturbations=[Int_Velo;sav_velo];
perturbation=[perturbations(1,:) perturbations(2,:)]';
basStds=nanstd(adaptations(:,1:150),[],2);
basStd=nanstd(basStds);


% cd('C:\Users\dum5\OneDrive\_Shared Drive - Interference Project - Alessandro - Dulce_\Params Files\DataModels')
% save('ExtAdaptShiftedDataToFiV5','adaptation','adaptations','perturbation','perturbations','basStds','basStd')



% save([param{1} 'Shif_A1_B_A2NormAll'], 'ExtAdapt_INT_shifted','ExtAdapt_SAV_shifted','ExtAdapt_SAV_SEshifted','ExtAdapt_INT_SSEshifted')

% h1=boundedline(1:length(SLA_INT_shifted),SLA_INT_shifted,SLA_INT_STDshifted,'r')
% h2=boundedline(1:length(SLA_SAV_shifted),SLA_SAV_shifted,SLA_SAV_STDshifted,'b')

%,x,eval([gaitPar 'Avg(SAV,:)']),slamse(SAV,:),'b');
% plot(1:length(SLA_INT_shifted),SLA_INT_shifted,1:length(SLA_INT_shifted),SLA_INT_STDshifted)
% hold on
% plot(1:length(SLA_SAV_shifted),SLA_SAV_shifted,1:length(SLA_SAV_shifted),SLA_SAV_STDshifted)


cd('C:\Users\dum5\OneDrive\_Shared Drive - Interference Project - Alessandro - Dulce_\Params Files\DataModels')
save('ExtAdaptDataToFitV8_ALLShifted','adaptation','adaptations','perturbation','perturbations','basStds','basStd')



