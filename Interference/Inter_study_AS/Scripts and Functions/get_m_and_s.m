function [A1_sav_m, A2_sav_m, A1_int_m, A2_int_m, A1_sav_se, A2_sav_se, A1_int_se, A2_int_se, matTable] = ...
    get_m_and_s(outcome_table,INTERFERENCE,SAVINGS,A1,A2,IND_GROUP,IND_COND)

%Get indices
indInt=[outcome_table{:,IND_GROUP}]==INTERFERENCE;
indSav=[outcome_table{:,IND_GROUP}]==SAVINGS;
indA1=[outcome_table{:,IND_COND}]==A1;
indA2=[outcome_table{:,IND_COND}]==A2;

%Extract data
[~, outcome_table] = isdouble_ca(outcome_table);
A1_sav=outcome_table(indA1&indSav,:);
A2_sav=outcome_table(indA2&indSav,:);
A1_int=outcome_table(indA1&indInt,:);
A2_int=outcome_table(indA2&indInt,:);

%Compute averages
A1_sav_m=mean(A1_sav);
A2_sav_m=mean(A2_sav);
A1_int_m=mean(A1_int);
A2_int_m=mean(A2_int);

%Compute standard errors
A1_sav_se=myStderr(A1_sav);
A2_sav_se=myStderr(A2_sav);
A1_int_se=myStderr(A1_int);
A2_int_se=myStderr(A2_int);

npars = size(outcome_table,2);
matTable = zeros(2,8,2,npars); %group X sub X cond X par
matTable(2,:,1,:) = A1_sav;
matTable(2,:,2,:) = A2_sav;
matTable(1,:,1,:) = A1_int;
matTable(1,:,2,:) = A2_int;

end