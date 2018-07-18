function [H,P]=test_normality(data,dim)

%dim is the dimension along which the data are distributed
ntests=size(data,dim); %Number of tests to perform
H=nan(1,ntests); P=nan(1,ntests);

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
            [H(test), P(test)]=lillietest(data(test,:));
        else
            [H(test), P(test)]=lillietest(data(:,test));
        end
    end
end

end