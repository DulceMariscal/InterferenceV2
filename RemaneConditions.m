clc 
close all 
clear all 

% pathToData = 'C:\Users\dum5\OneDrive\_Shared Drive - Interference Project - Alessandro - Dulce_\Params Files\subjectsData';
pathToData= 'C:\Users\dum5\OneDrive\_Shared Drive - Interference Project - Alessandro - Dulce_\Params Files\ForceParams';
groups = 2;
subs = 8;
charGroups = {'I','S'};
indSubs = {setdiff(1:9, 2), 1:9};


for gr=1:groups
    for sub=1:subs

        cname = [charGroups{gr} '00' num2str(indSubs{gr}(sub)) 'kin'];

        changeCondName(cname,{'Baseline','Tied','Adaptation 2 '},{'TM base','Tied Belt','Adaptation 2'})
        
    end 
end


