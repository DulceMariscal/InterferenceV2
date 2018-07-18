function        [Xsw, xstrings] = generate_interactions(Xsw,xstrings)
[ndata, nregs]=size(Xsw);
newcols=nchoosek(nregs,2);
ndata_new=nregs + newcols;
Xnew=zeros(ndata,ndata_new);
indcol=1; %Where to add the column
xstrings_new=cell(1,ndata_new);

for ccol=1:nregs
    data_1 = Xsw(:,ccol);  %Data current regressor
    Xnew(:,indcol) = data_1;
    xstrings_new{indcol} = xstrings{ccol};    
    indcol=indcol+1; %One new element has been added to the matrix
    
    npairs = nregs-ccol; %Number of pairs for the current regressor
    for cpair=1:npairs
        ind_curr_col2=ccol + cpair; %Index current second column
        data_2 = Xsw(:,ind_curr_col2);
        Xnew(:,indcol)=data_1.*data_2;
        xstrings_new{indcol} = [xstrings{ccol} ' X ' xstrings{ind_curr_col2}];
        indcol=indcol+1;
    end
    
end

Xsw=Xnew;
xstrings=xstrings_new;




end