function    [summary_string, model_info, model_info_adj, model_detailed_info, reg_info] = ...
    my_sw_summary(selected_pvals, b, model_pval, inmodel, outcome_var, reg_list, pval_adj,adj_pval_se, NPERMS, NREP, significant)

if significant==1
    mystr='YES';
else
    mystr='NO';
end

selected_variables={reg_list{inmodel}};
% model_pval=stats.pval;
% b=stats.B(inmodel);
% selected_pvals=stats.PVAL(inmodel);
b0=b(1); %stats.intercept;
b=b(2:end);

m=length(selected_variables);
summary_string =[outcome_var '  =  ' num2str(b0) ] ;

for i=1:m
    summary_string = [ summary_string  '  +  ' num2str(b(i)) ' * ' selected_variables{i}];
end

model_info = ['Model p-val = ' num2str(model_pval)];
reg_info=['Regressors p-vals = ' num2str(selected_pvals') ];
model_info_adj = ['Model p-val-adj. Mean: ' num2str(pval_adj) '. se = ' num2str(adj_pval_se) '. Significant = ' mystr];
model_detailed_info = ['NPERMS = ' num2str(NPERMS) '. NREP = ' num2str(NREP) ];

end