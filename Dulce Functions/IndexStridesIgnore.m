clc 
% close all 
clear all 

% pathToData = 'C:\Users\dum5\OneDrive\_Shared Drive - Interference Project - Alessandro - Dulce_\Params Files\subjectsData';
% groups = 2;
% subs = {8};
% charGroups = {'I','S'};
% indSubs = {setdiff(1:9, 2), 1:9};
% load('SlaAvgIdv.mat')


%With S009
% pathToData= 'C:\Users\dum5\OneDrive\_Shared Drive - Interference Project - Alessandro - Dulce_\Params Files\ForceParams';
pathToData= 'C:\Users\dum5\OneDrive\_Shared Drive - Interference Project - Alessandro - Dulce_\Params Files\subjectsData';

% load('ExtAdaptPNormAllData.mat')
% load('ExtAdaptPNormAllDataWithNANV4.mat')
load('netContributionPNormAllDataV8.mat')
param={'netContributionPNormAllDataV8'};
slaI=netContributionPNormINT;
slaS=netContributionPNormSAV;



% load('ExtAdaptNorm2AllData.mat') 
% param={'ExtAdaptNorm2'};
% slaI=ExtAdaptINT;
% slaS=ExtAdaptSAV;

%  load('stepLengthAsymShifted.mat')
% load('stepLengthAsymAllData.mat')

% slaI=stepLengthAsymINT;
% slaS=stepLengthAsymSAV;



groups = 2;
charGroups = {'S','I'};
% indSubs = {1:8, setdiff(1:9, 2)};
indSubs = {1:10, 1:10};
subs = {10, 10};

NUM_CONS=5;
INCREASING=1;
START_FROM_MINIMUM=1;
cond_Inter=[2,5];
cond_Sav=[2,4];

minNOSToRemove=nan(10,2);

for sub=1:subs{2}
    
    data_A1_Inter=slaI{sub,cond_Inter(1)};
    index_first_point_Inter(sub,1)=find_strides_to_ignore( data_A1_Inter,NUM_CONS,INCREASING,START_FROM_MINIMUM);
    
    data_A2_Inter=slaI{sub,cond_Inter(2)};
    index_first_point_Inter(sub,2)=find_strides_to_ignore( data_A2_Inter,NUM_CONS,INCREASING,START_FROM_MINIMUM);
    
  minNOSToRemove(sub,1)=[max(index_first_point_Inter(sub,1:2))];
end
    
for sub=1:subs{1}
    data_A1_Sav=slaS{sub,cond_Sav(1)};
    index_first_point_Sav(sub,1)=find_strides_to_ignore(data_A1_Sav,NUM_CONS,INCREASING,START_FROM_MINIMUM);
    
    
    data_A2_Sav=slaS{sub,cond_Sav(2)};
    index_first_point_Sav(sub,2)=find_strides_to_ignore(data_A2_Sav,NUM_CONS,INCREASING,START_FROM_MINIMUM);
    
    minNOSToRemove(sub,2)=[max(index_first_point_Sav(sub,1:2))];
end


save(['StridesToRemove' param{1}],'minNOSToRemove')
    
%     for sub=1:subs{1}
%         StridesToRemove(sub,1)=[max(index_first_point_Inter(sub,1:2))]; max(index_first_point_Sav(sub,1:2))];
%     end
    
% load('C:\Users\dum5\OneDrive\_Shared Drive - Interference Project - Alessandro - Dulce_\Alessandro Code. Shared on Jan 29\Interference\Interf_study_AS\Intermediate data\minNOSToRemove.mat')
% load('C:\Users\dum5\University of Pittsburgh\Torres, Gelsy - Alessandro\Alessandro''s Docs\CoreL\_Shared Drive - Interference Project - Alessandro - Dulce_\Alessandro''s Code. Shared on Jan 29\Interference\Interf_study_AS\Intermediate data\minNOSToRemove.mat')
% minNOSToRemove=minNOSToRemove';