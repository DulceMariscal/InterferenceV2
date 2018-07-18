function Xnew=update(X,error,target,a0,a180,sigmaA,b0,b180,sigmaB,prefDirs)
%Implements the Ingram et al. 2017 model's update equation
%Assumes the states X have preferred directions uniformly distributed in
%the [0 2*pi] range
%Update follows the rule: Xnew= a(Delta).*X+b(Delta).*<prefDirs,error>
%Where Delta  is the angle between the target and the preferred direction
%of each module/state
%INPUTS:
%X= current state/modules strength (M scalars) [Mx1]
%error= last experienced error (N-D vector) [Nx1]
%target = N-D vector representing the target in the trial where the error [Nx1]
%was generated
%a0,a180,sigmaA = defines  a(Delta) = a180+(a0-a180)*(exp(-.5*Delta^2/sigmaA^2)-exp(-.5*180^2/sigmaA^2))/(1-exp(-.5*180^2/sigmaA^2))
%b0,b180,sigmaB = defines  b(Delta) = b180+(b0-b180)*(exp(-.5*Delta^2/sigmaB^2)-exp(-.5*180^2/sigmaB^2))/(1-exp(-.5*180^2/sigmaB^2))
%prefDirs= M N-D vectors of norm 1 [if not normalized, they will be here] (optional) [MxN]
%TODO: generalize to consider non-gaussian context functions alpha,beta of
%the form f=(a+b<prefDir,target>)^n, which is a cosine-like function, but
%can be close to a gaussian curve, but also allows more stuff.

M=numel(X);
N=numel(error);
if nargin<10 || isempty(prefDirs)
   ang=2*pi*[0:M-1]'/M;
   prefDirs=[cos(ang) sin(ang)]; 
elseif size(prefDirs,1)~=M || size(prefDirs,2)~=N
    error('')
else
    prefDirs=prefDirs./sqrt(sum(prefDirs.^2,2));
end
if numel(target)~=N
    error('')
end

cosines=prefDirs*target(:);
errorProj=prefDirs*error(:);
Deltas=acos(cosines);
a=alpha(Deltas,a0,a180,sigmaA);
b=alpha(Deltas,b0,b180,sigmaB);
Xnew=a.*X + b.*errorProj;
end

