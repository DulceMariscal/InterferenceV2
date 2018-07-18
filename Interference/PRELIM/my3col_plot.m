function my3col_plot(s,col,varargin)
if isempty(varargin)
    allInds=1:length(s);
else
    allInds=varargin{1};
end

for i=1:3
    if i==1
        inds=find(s<0);
    elseif i==2
        inds=find(s==0);
    else
        inds=find(s>0);
    end
    if ~isempty(inds)
        hold on
        plot(allInds(inds),s(inds),'s','Color',col{i})
    end
end


end