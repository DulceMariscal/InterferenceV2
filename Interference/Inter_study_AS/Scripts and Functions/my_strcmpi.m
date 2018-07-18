function found=my_strcmpi(long_list,short_list,ALL_VARIABLES)

if ischar(short_list)
    short_list = {short_list};
end
if ischar(long_list)
    long_list = {long_list};
end

n=length(short_list);
found=[];


for i=1:n
    ind=find(strcmpi(long_list,short_list{i}));
    if ~isempty(ind)
        found=[found ind];
    end
end
if ALL_VARIABLES
    if length(short_list) ~= length(found)
        error('Some of the regressors you requested have not been found!')
    end
end


end