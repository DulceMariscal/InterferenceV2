function [ms_thr ] = compute_ms_thresholds(all_curves) %They are computed from the data

[ng,nos, nc] = size(all_curves);
nss = 30;
means = zeros(1,2);
% stds = zeros(1,2);
ms_thr = zeros(ng,nos);

for gr=1:ng
    for sub=1:nos
        for cond=1:nc
            ccurve = all_curves{gr,sub,cond};
            ls=ccurve(end - nss + 1:end);
            means(cond) = nanmean(ls);
%             stds(cond) = nanstd(ls);
            
        end
        ms_thr(gr,sub) = min(means);
    end
end