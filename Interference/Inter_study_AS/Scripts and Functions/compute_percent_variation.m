function [PV, mPV, sderrPV, DIFF, mDIFF, sderrDIFF] = compute_percent_variation(M,indFirstCond,indSecondCond)
[nconditions, nsubjects]= size(M);

DIFF=(M(indSecondCond,:)-M(indFirstCond,:));
PV = DIFF./abs(M(indFirstCond,:));

%Means
mPV=mean(PV); %Average accross subjects
mDIFF=mean(DIFF);

%Standard errors
sderrPV=std(PV,0,2)/sqrt(nsubjects);
sderrDIFF=std(DIFF,0,2)/sqrt(nsubjects);

end