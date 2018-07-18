function create_rate_table_stata(allRateMeas, RATE_STRINGS, SMOOTHING_STRINGS, storePath, selPar)

%% Numberss
[ng, ns, nc, nsm, nrates] = size(allRateMeas);

%% Fixed colums
fixed_strings = {'group', 'subject', 'condition', 'ID'};
nfixed = length(fixed_strings);
nextra = nrates*nsm;
GROUPS={'INT','SAV'};
CONDS={'A1','A2'};
rate_strings=[];

%% Create rate names
for smoothing=1:nsm
    for rate=1:nrates
        cstr{1,1} = [SMOOTHING_STRINGS{smoothing} '_' RATE_STRINGS{rate}];
        rate_strings = [rate_strings cstr(1,1)];
    end
end% TODO merge this table with all the other tables

%% Initialize struct
matTable = cell(ng*ns*nc, nfixed + nextra );

%% Fill mat cell array
indRow=1;
for gr=1:ng
    G=GROUPS{gr};
    
    for sub=1:ns
        S=[G(1) num2str(sub)];
        
        for cond=1:nc
%             C=CONDS{cond};
            
            %Group
            matTable{indRow, 1} =  gr;
            
            %Subject
            matTable{indRow, 2} =  S;
            
            %Condition
            matTable{indRow, 3} =  cond;
            
            %ID
            matTable{indRow, 4} =  sub + (gr-1)*ns;
            
            
            for smoothing=1:nsm
                for rate=1:nrates
                    crate = allRateMeas(gr, sub, cond, smoothing, rate);
                    matTable{indRow, 4 + rate + (smoothing-1)*nrates} = crate;
                end
            end
            
            indRow = indRow + 1;
        end
    end
end

colHeaders = [fixed_strings rate_strings];
colHeaders=strrep(colHeaders,'1','One');
colHeaders=strrep(colHeaders,'2','Two');

%% Convert to table
Table=cell2table(matTable,'VariableNames',colHeaders);

%% Store table
ext1='.dat'; ext2='.mat';
tableName = [selPar '_stata_rate_table'];
writetable(Table,[storePath tableName ext1]);
save([storePath tableName ext2], 'matTable');


end