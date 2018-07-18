function        [bas1, bas2, abrupt, baselineSpeeds, abruptSpeeds] = as_preprocess(adaptData, gaitPar, baselineNames, abruptName, expName, sub, BASfirstBad, BASlastBad, ABlastBad, START_FROM_MINIMUM)

%Fixed parameters----------------------------------------------------------
NUM_COND=5;    %Number of minumum consecutive strides with increasing (decreasing)
%sla (COP_adapt,..) to start considering the data
INCREASING=1;  %This should be 0 if we are dealing with a decreasing signal
wSize=5;
INT=1;
SAV=2;
pathToIntInt='C:\Users\salat\OneDrive\Documents\MATLAB\Speeds Computation\Data\Interference_study_int\';
subID=adaptData.subData.ID;
%--------------------------------------------------------------------------

% Initializations
% baselineSpeeds=zeros(1,2); %First and second baseline speeds
% abruptSpeeds=zeros(1,2);   %Dominant and non-dominant belt speeds

%Exctract baseline data
[bas1] = adaptData.getParamInCond(gaitPar,baselineNames{1});
[~, ~, bas1Speed] = getSpeed(adaptData, baselineNames{1}); %Dspeed, NDspeed, AVGspeed
[bas1] = bas1(BASfirstBad+1:end-BASlastBad);

[bas2]=adaptData.getParamInCond(gaitPar,baselineNames{2});
[~, ~, bas2Speed] = getSpeed(adaptData, baselineNames{2}); %Dspeed, NDspeed, AVGspeed
[bas2]=bas2(BASfirstBad+1:end-BASlastBad);

%Compute baseline param as Pablo
bas_red=bas2(6:end); %The second baseline is assumed to be the one that needs to be subtracted
bas_val=nanmean(bas_red(end-40+1:end));

% Compute singleStanceSpeeds
[Dspeed, NDspeed, ~] = getSpeed(adaptData, abruptName); %Dspeed, NDspeed, AVGspeed

if strcmpi(subID,'I008')
    load([pathToIntInt 'abrupt_A1_I008.mat'])
    abrupt=abrupt_A1_I008';
elseif strcmpi(subID,'I001')
    load([pathToIntInt 'abrupt_A1_I001.mat'])
    abrupt=abrupt_A1_I001;
else
    if strcmpi(subID,'S006')
       ddd = 1+1; 
    end
    %Extraxt abrupt
    [abrupt]=adaptData.getParamInCond(gaitPar,abruptName);

    %Remove bias
    % [adaptData]=adaptData.removeBias(baselineName); %This does not work if
    % there are both OG and TM trials
    abrupt=abrupt-bas_val;
    
    %Median filter
    abrupt = medfilt1(abrupt,wSize);
    
    %Running average
    firstSamples=abrupt(1:wSize-1);
    abrupt = tsmovavg(abrupt,'s',wSize,1);
    abrupt(1:wSize-1)=firstSamples; %This is done because tsmovavg returns 'nans' for the first samples
    
    %Find # strides to remove (adaptive)
%     if isempty(regexp(expName,'Interference study', 'once'))  %If it is not the interference experiment
%         index_first_point=find_strides_to_ignore(abrupt,NUM_COND,INCREASING,START_FROM_MINIMUM);
%     else                                       %It is the interferference experiment
%         load([pathToIntInt 'minNOSToRemove.mat']); %Uploads minNOSToRemove
%         if regexp(expName,'SAV_SUBJECTS')
%             index_first_point=minNOSToRemove(SAV,sub);
%         else
%             index_first_point=minNOSToRemove(INT,sub);
%         end
%     end
    index_first_point=find_strides_to_ignore(abrupt,NUM_COND,INCREASING,START_FROM_MINIMUM);

    
    %Remove strides
    abrupt=abrupt(index_first_point:end-ABlastBad);
    
end

baselineSpeeds = [bas1Speed, bas2Speed];
abruptSpeeds   = [Dspeed, NDspeed];




end