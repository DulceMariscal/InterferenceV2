function     runningStd=compute_running_std(data,w)

runningStd=[];
n=length(data);
for j=1:n-w+1
    runningStd(j)=nanstd(data(j:j+w-1));
end



end