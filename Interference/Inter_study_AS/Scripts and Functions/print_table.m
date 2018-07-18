function print_table(col_head,row_head,data,pos,print_type,dim_head,dim_cell) %Prints on current axis
[nrows,ncols]=size(data);


% nrows=2;
% ncols=2;
if isempty(pos)
    pos=[.7 .3];
end
if isempty(dim_head)
    dim_head=12;
end
if isempty(dim_cell)
    dim_cell=11;
end
posx=pos(1);
posy=pos(2);

% f=figure;
% subplot(2,1,1)
% x=1:.1:10;
% y=sin(x);
% plot(x,y);
% hold on
% xl=xlim;
% yl=ylim;
bgcolor=[.7 .9 .7];
perc_fact=0.1;
% absx=xl(1)+diff(xl)*posx;
% absy=yl(1)+diff(yl)*posy;

% col_head={'col1','col2'};
% row_head={'rh1','rh2'};
% ht=text(absx,absy,sprintf('%12s %12s\n%12c\n%12d %12.2d','string1','string2','-',10,15.55));
% ht=text(absx,absy,'dssssss')
format_string_col_head=repmat(['%' num2str(dim_head) 's'], 1, ncols);

if strcmpi(print_type,'f')
    format_string_data=repmat(['%' num2str(dim_head) '.2f'], 1, ncols);
else
    format_string_data=repmat(['%' num2str(dim_head) '.2e'], 1, ncols);
end
%Columns heading
text(posx,posy,sprintf(format_string_col_head,col_head{:}),'FontWeight','bold','Units','normalized','FontSize',dim_head,'BackgroundColor',bgcolor);
%Dashed line
text(posx,posy-0.4*perc_fact,repmat(sprintf('-'), 1, (dim_head+3)*ncols),'Units','normalized');

for row=1:nrows
    %Row headings
    text(posx-1.5*perc_fact,posy-perc_fact*row,sprintf(['%-' num2str(dim_cell-1) 's'],row_head{row}),'FontWeight','bold','Units','normalized','FontSize',dim_head,'BackgroundColor',bgcolor);
    %Numbers
    text(posx,posy-perc_fact*row,sprintf(format_string_data,data(row,:)),'FontWeight','bold','Units','normalized','FontSize',dim_cell);
end


end