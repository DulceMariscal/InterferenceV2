function out=output(X,target,c0,c180,sigmaC,prefDirs)
%Implements the Ingram et al. 2017 model's update equation
%Assumes the states X have preferred directions uniformly distributed in
%the [0 2*pi] range
%Update follows the rule: out=sum(prefDirVersor*c(Delta)*X);
%Where Delta  is the angle between the target and the preferred direction
%of each module/state
%INPUTS:
%X= current state/modules strength (M scalars) [Mx1]
%target = N-D vector representing the target in the trial where the error [Nx1]
%was generated
%c0,c180,sigmaC = defines  c(Delta) = a180+(a0-a180)*(exp(-.5*Delta^2/sigmaA^2)-exp(-.5*180^2/sigmaA^2))/(1-exp(-.5*180^2/sigmaA^2))
%prefDirs= M N-D vectors of norm 1 [if not normalized, they will be here] (optional) [MxN]
%TODO: generalize to consider non-gaussian context functions alpha,beta of
%the form f=(a+b<prefDir,target>)^n, which is a cosine-like function, but
%can be close to a gaussian curve, but also allows more stuff.

M=numel(X);
N=numel(target);
if nargin<10 || isempty(prefDirs)
   prefDirs=defaultPrefDirs(M);
elseif size(prefDirs,1)~=M || size(prefDirs,2)~=N
    error('')
else
    prefDirs=prefDirs./sqrt(sum(prefDirs.^2,2));
end

cosines=prefDirs*target(:);
Deltas=360*acos(cosines)/(2*pi);
c=alpha(Deltas,c0,c180,sigmaC);
out=prefDirs'*(c.*X);
end

