function           subjPars = stackSingleSubjectData(valSingleCurve, valCoupleCurve, gr, sub, sm, n1, n2)

A1=1; A2=2;
subjPars = zeros(1, 2*n1 + n2);

for i = 1:n1 %For each single curve parameter
   subjPars(i) = valSingleCurve{i}(gr, sub, A1, sm);
   subjPars(i + n1) = valSingleCurve{i}(gr, sub, A2, sm);
% 
%    parNames{i}      = [p1{i} '(A1): ']; 
%    parNames{i + n1} = [p1{i} '(A2): '];
end

for j = 1:n2
   subjPars(i + n1 + j) = valCoupleCurve{j}(gr, sub, sm);
end


end