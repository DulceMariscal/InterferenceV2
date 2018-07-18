function [ns, nsubs ]=computeNOS(ei)

n=length(ei);
nsubs=zeros(1,n);

for i=1:n
   nsubs(i)=ei{i}.nSubs; 
end

ns=sum(nsubs);

end