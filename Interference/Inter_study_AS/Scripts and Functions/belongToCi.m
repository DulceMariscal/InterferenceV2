function     maskBel = belongToCi(PVcf,ci)

[ng, ns] = size(PVcf);
% CI is a 3 X 2
maskBel = zeros(ng,ns);

for cond=1:ng
   maskBel(cond,:) = (PVcf(cond,:) >= ci(1,cond)) & (PVcf(cond,:) <= ci(3,cond));
end

end