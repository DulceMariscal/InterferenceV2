function [H, P]=my_signrank(data,dim)

ntests=size(data,2);
H=nan(1,ntests);
P=nan(1,ntests);

%Identify "doable" tests (without nans)
indNan=isnan(data);
if dim==1
    notDoableTests=any(indNan,2);
else
    notDoableTests=any(indNan,1);
end
doableTests=~notDoableTests;

for test=1:ntests
    if doableTests(test)
        if dim==1
            [ P(test), H(test)]=signrank(data(test,:));
        else
            [ P(test), H(test)]=signrank(data(:,test));
        end
    end
end


end