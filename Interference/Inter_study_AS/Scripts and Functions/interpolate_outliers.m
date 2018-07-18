function outSig=interpolate_outliers(sig,thr,standardValue)

%Set Nan as outlier
validData=sig(~isnan(sig));
m=mean(validData);
stdev=std(validData);
sig(sig(isnan))=m + thr*stdev;

%Find outliers (it would make more sense to find those where change in velocity is too high)
normsig=zscore(sig);
indOutliers=find(normsig<-thr | normsig>thr);
nOutliers=length(indOutliers);
disp('indOutliers=');
disp(indOutliers);


for i=1:nOutliers
   if indOutliers(i)>sampleMean %Set the value of the outlier to the average of the previous last 10 samples
       disp('i= ');
       disp(i);
       m=mean(sig(indOutliers(i)-sampleMean:(indOutliers(i)-1)));
       disp('m= ');
       disp(m);
   elseif indOutliers(i)==1 %If there is just a value
       m=standardValue;
   else %If there are only  a few values
       m=mean(sig(1:indOutliers(i)-1));
   end
   sig(indOutliers(i))=m; 
end

outSig=sig;

end