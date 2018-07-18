function parNames = buildParNames(p1, p2)

n1 = length(p1);
n2 = length(p2);
parNames = cell(1, 2*n1 + n2);

for i = 1:n1 %For each original parameter
   parNames{i}      = [p1{i} '(A1): ']; 
   parNames{i + n1} = [p1{i} '(A2): '];
end

for j = 1:n2
   parNames{i + n1 + j} = [p2{j} ': ']; 
end
    
end