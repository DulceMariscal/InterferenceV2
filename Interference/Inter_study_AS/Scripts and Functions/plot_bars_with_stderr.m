function new_fh=plot_bars_with_stderr(sp, means, standard_errors, colors)

if isempty(sp)
    new_fh=figure;
else
    subplot(sp);
    new_fh=[];
end


nbars=length(means);
hold on

hb = bar(1:nbars,means);

if ~isempty(colors)    
    for i=1:nbars
        if iscell(colors)
            ccol=colors{i};
        else
            ccol=colors(i,:);
        end
        set(hb(i),'facecolor',ccol);
    end
end

hold on
for ib = 1:numel(hb)
    % Find the centers of the bars
    xData = get(hb(ib),'XData');
    barCenters = mean(unique(xData,'rows'));
    errorbar(barCenters,means(ib,:),standard_errors(ib,:),'k.');
end