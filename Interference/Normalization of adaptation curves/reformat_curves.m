function      all_curves = reformat_curves(INTERFERENCE_DATA,SAVINGS_DATA) %GROUP X SUBS X COND

 MERGED_DATA=cat(3,INTERFERENCE_DATA,SAVINGS_DATA);
 all_curves = permute(MERGED_DATA,[3 2 1]); %NOw GROUP X SUBS X COND
 all_curves = fix_struct(all_curves); %Make sure that every adaptation curve is stored as a column vector


end