function [avg_curve, se_curve, cut_curves]=average_curves(cellarr)
min_len=min(cellfun(@length,cellarr)); %Number of subjects in each group
ncurves=length(cellarr);
cut_curves=zeros(ncurves,min_len);
for i=1:ncurves
   cut_curves(i,:)=cellarr{i}(1:min_len); 
end

avg_curve=nanmean(cut_curves,1);
se_curve=nanstd(cut_curves,0,1)/sqrt(size(cut_curves,1));
end