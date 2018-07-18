function se = my_se2(v,ind)

se = std(v,ind)./sqrt(size(v,1));

end


