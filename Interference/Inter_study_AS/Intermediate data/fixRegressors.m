function REGRESSORS=fixRegressors(REGRESSORS)
%Luis did not input correctly height and weight of his subjects
%WEIGHT 2
%HEIGHT 3
subinds=[2,3,4,9,10,11,12];
%Interference
REGRESSORS(2,2:3)=[65.7 170]; 
REGRESSORS(3,2:3)=[94 178];
REGRESSORS(4,2:3)=[88.5 180];

%Savings
REGRESSORS(9,2:3)=[68 167];
REGRESSORS(10,2:3)=[79.8 183];
REGRESSORS(11,2:3)=[52.16 157];
REGRESSORS(12,2:3)=[68 172.5];

%Fix BMI
n=length(subinds);
for sub=1:n
   ind=subinds(sub); 
   REGRESSORS(ind,4)=getbmi(REGRESSORS(ind,2),REGRESSORS(ind,3));
end

end