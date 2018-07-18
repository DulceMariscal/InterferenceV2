function nStridesToThr=find_nstrides_to_perc_ss(cdata,steady_state_val,ss_perc,INCREASING,NCONS)
nStridesToThr=nan;
xmax=steady_state_val;
xmin=min(cdata(1:10));

%New version
y = (cdata-xmin)/(xmax-xmin);
indComparison = y >= ss_perc;

% if INCREASING 
%     indComparison = y >= ss_perc;
% else
%     indComparison = y <= (1-ss_perc);
% end

%Old version
% if INCREASING 
%     indComparison = cdata >= ss_perc*steady_state_val;
% else
%     indComparison = cdata <= ss_perc*steady_state_val;
% end

if isempty(NCONS)
    nStridesToThr=find(indComparison,1);
else
    ns=length(cdata);
    for i=1:ns-NCONS+1
        if all(indComparison(i:i+NCONS-1));
            nStridesToThr=i;
            break;
        end
    end
end


end