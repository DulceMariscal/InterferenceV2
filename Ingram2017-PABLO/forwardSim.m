function [Y,X,E]=forwardSim(targets,trialTypes,X0,a0,a180,sigmaA,b0,b180,sigmaB,c0,c180,sigmaC,prefDirs)
[N,K]=size(targets);
M=size(X0,1);
if nargin<13 || isempty(prefDirs)
    prefDirs=defaultPrefDirs(M);
end
if numel(trialTypes)~=K
    error('')
end
   X=nan(M,K);
   X(:,1)=X0;
   Y=nan(N,K);
   E=nan(N,K);
for k=1:K-1
    Y(:,k)=output(X(:,k),targets(:,k),c0,c180,sigmaC,prefDirs);
    switch trialTypes(k)
        case 1 %Exposure
            E(:,k)=targets(:,k)-Y(:,k);
        case 0 %zero-force
            E(:,k)=-Y(:,k);
        case 2 %error clamp
            E(:,k)=0;
    end
    X(:,k+1)=updateModules(X(:,k),E(:,k),targets(:,k),a0,a180,sigmaA,b0,b180,sigmaB,prefDirs);
end
end