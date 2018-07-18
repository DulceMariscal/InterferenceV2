%% SAVE ALL OPENED FIGURES IN A CERTAIN DIRECTORY
function saveAllFigures(location)

figHandles = get(0,'Children');
nf=length(figHandles);

orsig={' ','.','-',':'};
newsig={'_','','_','_'};
nrep=length(orsig);

for fhand=1:nf
        cname=get(fhand,'name');
        
        for j=1:nrep
            cname=strrep(cname,orsig{j},newsig{j});
        end
        fileName=[cname '_.fig'];
        completeName=[location fileName];
        
%         set(fhand, 'Position', get(0, 'Screensize')); %To make the image
%         fullscreen (not working)
        saveas(fhand,completeName);
end

end