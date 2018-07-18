function save_epsc_current_folder(figureName)

fh = gcf;

if isempty(extensions)
    extensions  = {'-depsc','-dpng'}; %Default extensions
end

for i = 1:length(extensions)
    
    if ~isempty(figNB) %by figure  number
        print(['-f' num2str(figNB)],figName,extensions{i});
    else %By  handle
        print(fh,figName,extensions{i});
    end
    %'-depsc' -dpng
    
end

if ALSOFIG
    if ~isempty(figNB) %by figure  number
        fh = figure(figNB);
    end
    savefig(fh, [figName '.fig'], 'compact')
    % print('-f5','TestPlot','-depsc')
    % print('-f5','TestPlot','-dpng')
end



end