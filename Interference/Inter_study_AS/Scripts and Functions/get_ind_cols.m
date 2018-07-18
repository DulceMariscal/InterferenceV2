function     indCol = get_ind_cols(headers,SM, pars) %Extract the indices of needed cols
SM = strrep(SM,'1','One');
SM = strrep(SM,'2','Two');

%Find SLA
for i=1:length(pars)
    str =[pars{i} '_' SM '_nsmp_norm'];
    indCol(i) = find(strcmpi(headers,str));
end



end