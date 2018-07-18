function     summaryString = createString(names,vals,nsig)
nvals=length(names);
mstr=[];
for val=1:nvals
    mstr = [mstr names{val} ' = ' num2str(vals(val),nsig) '\n']
end
mstr = mstr(1:end-2);
summaryString = sprintf(mstr);


end