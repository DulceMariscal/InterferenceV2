function [outMask, mat] = isdouble_ca(ca)

d = size(ca);
mat = zeros(d);

for i=1:d(1)
    for j=1:d(2)
        a = ca{i,j};
        if isnumeric(a)
            mat(i,j) = a;
        else
            mat(i,j) = nan;
        end
    end
end

outMask = ~isnan(mat);
