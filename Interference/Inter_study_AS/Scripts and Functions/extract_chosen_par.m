function outcome_table = extract_chosen_par(outcome_table_all_contributions, selPar)

nRepPar = 9;
outcome_table = cell(32, 13);

outcome_table(:, end-3:end) = outcome_table_all_contributions(:,end-3:end);

offs = nRepPar*(selPar-1);
outcome_table(:,1:nRepPar) = outcome_table_all_contributions(:,1 + offs : nRepPar + offs);



end