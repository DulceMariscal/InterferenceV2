function                 [glob_min, glob_max] = get_min_max(a1_a2_curves)
% vectc = cell2mat(squeeze(a1_a2_curves)); %Previous

%NEW
vectc=[];
lll = squeeze(a1_a2_curves);
ncells= length(lll);

for i=1:ncells
    temp = lll{i};
    dims = size(temp);
    if dims(1)>dims(2)
        temp=temp';
    end
    vectc = [vectc temp];
end
%End new

glob_min = min (vectc);
glob_max = max (vectc);
end