str=cell(1,101);

for i=900:1000
    str{1,i-900+1}=sprintf('%c ', i);
end
%aplha = 46