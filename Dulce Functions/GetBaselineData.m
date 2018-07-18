clear alll;close all;clc

%  load('stepLengthAsymAllData.mat')
%  StepLengthAsymBaselineData=[];
%  param='StepLengthAsym';

%for ExtAdaptaiton= SLA-SV
load('ExtAdaptNorm2AllData.mat') 
load('StridesToRemoveExtAdapt.mat')
param={'ExtAdaptNorm2'};

%No hip 
% load('ExtAdpatPNormAllData.mat') 
% load('StridesToRemoveExtAdpatPNomr')
% param={'ExtAdpatPNorm'};
 
Subs = {setdiff(1:9, 2), 1:9};
groups=2;
charGroups = {'INT','SAV'};
cond=1;
s=0;

for gr=1:groups
for sub=1:length(Subs{gr})
     s=s+1;

    eval(['BASELINE_DATA{s,cond}=' param{1}(1:end-5) charGroups{gr} '{sub,cond};']) 
end
end 
 
save([param{1} 'BaselineData'],'BASELINE_DATA')
