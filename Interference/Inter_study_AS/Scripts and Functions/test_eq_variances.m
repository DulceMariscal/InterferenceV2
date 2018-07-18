function [Hvar,Pvar]=test_eq_variances(om1,om2,dim)
ntests=size(om1,dim);
Hvar=zeros(1,ntests);
Pvar=zeros(1,ntests);

for test=1:ntests
    if dim==1
        x1=om1(test,:);
        x2=om2(test,:);
    else
        x1=om1(:,test);
        x2=om2(:,test);
    end
    
    [Hvar(test), Pvar(test)] = vartest2(x1,x2);
    
    
end

end