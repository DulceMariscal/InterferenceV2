function [H, P]=test_differences(om1,om2,dim,test_type,varargin)

if isempty(varargin)
    TAIL='both'; %Default value
else
    TAIL=varargin{1};
end

ntests=size(om1,dim);
H=nan(1,ntests);
P=nan(1,ntests);

%Identify "doable" tests (without nans)
indNan=isnan(om1).*isnan(om2);
if dim==1
    notDoableTests=any(indNan,2);
else
    notDoableTests=any(indNan,1);
end
doableTests=~notDoableTests;

for test=1:ntests
    if doableTests(test)
        if dim==1
            x1=om1(test,:);
            x2=om2(test,:);
        else
            x1=om1(:,test);
            x2=om2(:,test);
        end
        
        if strcmpi(test_type,'nonpar')
            [P(test), H(test)]  = ranksum(x1,x2);
        else
            [H(test), P(test)]  = ttest2(x1,x2,'Vartype',test_type,'Tail',TAIL);
        end
    end
    
    
end