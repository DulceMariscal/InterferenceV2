function     [adj_pval, adj_pval_se, significant, test_pval] = ...
    compute_adj_pval(y,X,NPERMS,pval,NREP, alpha, catVars, STEPWISE_FIT)
n=length(y);
ordered_vec = 1:length(y);
adj_pvals=zeros(1,NREP);

for rep=1:NREP
    sig_mod_count=0;
    for i=1:NPERMS
        %Compute permutation
        perm = randperm(n);
        
        if all(perm==ordered_vec)
            %        error('Bad permutation was generated. Re-launch the program.');
            perm = randperm(n);
        end
        
        %Permute outcome variable vector
        yperm=y(perm);
        
        %Select best model with stepwise
        if STEPWISE_FIT
            [~,~,~,~,stats,~,~] = stepwisefit(X,yperm,'display','off');
            modelPval = stats.pval;
        else
            mdll=stepwiselm(X, yperm, 'CategoricalVar', catVars,'Verbose',0); %Is much slower than stepwisefit but allows considering categorical variables
            [modelPval]=extract_info_from_mdl(mdll);
        end
        %Track good model found by chance
        if modelPval <= pval
            sig_mod_count = sig_mod_count + 1;
        end
        
    end
    
    adj_pvals(rep)=sig_mod_count/NPERMS;
end

adj_pval = mean(adj_pvals);
adj_pval_se = my_se(adj_pvals);
[significant, test_pval] = ttest(adj_pvals,alpha,'Tail','Left'); %Significant is 1 if adj_pval is < alpha




end