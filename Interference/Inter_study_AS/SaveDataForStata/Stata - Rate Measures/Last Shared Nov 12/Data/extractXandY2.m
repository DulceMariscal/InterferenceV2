function [x, y] = extractXandY2(mat_table, var_names, xstring, ystring)

x = cell2mat(mat_table(:,my_strcmpi(var_names,xstring,1)));
y = cell2mat(mat_table(:,my_strcmpi(var_names,ystring,1)));

if strcmpi(xstring(1:3),'STD') || strcmpi(ystring(1:3),'STD')
    subjectVec = cell2mat(mat_table(:,my_strcmpi(var_names,'subject',1)));
    groupVec = cell2mat(mat_table(:,my_strcmpi(var_names,'group',1)));
    indbad = (subjectVec == 8) & (groupVec == 1);
    x(indbad) = [];
    y(indbad) = [];
    warning('Subject I008 is not eligible for this analisys')
end
%NOTE subject I008 should not be considered for the baseline measures.
%Height and other dems are ok.

end
