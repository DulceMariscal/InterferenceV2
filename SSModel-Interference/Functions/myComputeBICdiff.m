function [deltaBics, Ranking] = myComputeBICdiff(BICs)
nmods = length(BICs);
Ranking = zeros(1,nmods);

%Assign a rank
[sortAsc, order] = sort(BICs,'ascend'); %The more negative will be ranked first
%Compute Delta BICs
db = [0 diff(sortAsc)];


for rank = 1:nmods
    ci=BICs==sortAsc(rank);
    Ranking(ci) = rank;
    deltaBics(ci) = db(rank);
end



% %Compute Delta BICs
% [sortDesc, indVals] = sort(BICs,'descend');
% deltaBics = [0 -diff(sortDesc)];
% deltaBics = deltaBics(indVals); 

end