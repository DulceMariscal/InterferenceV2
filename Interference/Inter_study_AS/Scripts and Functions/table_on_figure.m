
% 
% set(f,'Position',[500 500 300 150]);
% dat =  {'        a', 1, '        units';...
%     '        b', 2, '        units';...
%     '        c', 3, '        units';...
%     '        d',  4, '        units';...
%     '        e', 5, '        units';...
%     '        f', 6, '        units';};
% columnname =   {'Parameter', 'Value', 'Units'};
% columnformat = {'char', 'numeric', 'char'};
% hold on
% t = uitable('Units','normalized','Position',...
%     [0.05 0.05 0.755 0.87], 'Data', dat,...
%     'ColumnName', columnname,...
%     'ColumnFormat', columnformat,...
%     'RowName',[]);
%%
% figure;
% h=subplot(2,2,4);
% ht=text(.5,.5,sprintf('%c %-5s %20s,%1s','A','string1','string2'));
% ht=text(.5,.5,sprintf('%c %-5s %20s,%1s','A','string1ddd','string2ddd'));

% %%
% f=figure
% sp=subplot(2,1,1)
% x=1:.1:10;
% y=sin(x);
% plot(x,y);
% hold on
% LastName = {'Smith';'Johnson';'Williams';'Jones';'Brown'};
% Age = [38;43;38;40;49];
% Height = [71;69;64;67;64];
% Weight = [176;163;131;133;119];
% T = table(Age,Height,Weight,'RowNames',LastName);
% % Get the table in string form.
% TString = evalc('disp(T)');
% % Use TeX Markup for bold formatting and underscores.
% TString = strrep(TString,'<strong>','\bf');
% TString = strrep(TString,'</strong>','\rm');
% TString = strrep(TString,'_','\_');
% % Get a fixed-width font.
% FixedWidth = get(0,'FixedWidthFontName');
% % Output the table using the annotation command.
% annotation(sp,'Textbox','String',TString,'Interpreter','Tex',...
%     'FontName',FixedWidth,'Units','Normalized','Position',[0 0 1 1]);
% 


%% 
clc
close all
clear all

data=rand(2,2);
col_head={'col1','col2'};
row_head={'rh1','rh2'};
f=figure;
subplot(2,1,1);
x=1:.1:10;
y=sin(x);
plot(x,y);
pos=[0.7 0.3];
print_table(col_head,row_head,data,pos)




% nrows=2;
% ncols=2;
% posx=[.7];
% posy=[.3];
% f=figure;
% subplot(2,1,1)
% x=1:.1:10;
% y=sin(x);
% plot(x,y);
% hold on
% xl=xlim;
% yl=ylim;
% perc_fact=0.1;
% % absx=xl(1)+diff(xl)*posx;
% % absy=yl(1)+diff(yl)*posy;
% 
% col_head={'col1','col2'};
% row_head={'rh1','rh2'};
% % ht=text(absx,absy,sprintf('%12s %12s\n%12c\n%12d %12.2d','string1','string2','-',10,15.55));
% % ht=text(absx,absy,'dssssss')
% text(posx,posy,sprintf('%12s %12s',col_head{1},col_head{2}),'FontWeight','bold','Units','normalized');
% text(posx,posy-0.4*perc_fact,repmat(sprintf('-'), 1, 35),'Units','normalized');
% data=rand(nrows,ncols);
% for row=1:nrows
%     text(posx-perc_fact,posy-perc_fact*row,sprintf('%12s|',row_head{row}),'FontWeight','bold','Units','normalized');
%     text(posx,posy-perc_fact*row,sprintf('%12.2d %12.2d',data(row,:)),'Units','normalized');
%     
% end
% text(posx-0.1,posy-0.2,sprintf('%12s|',row_head{2}),'FontWeight','bold','Units','normalized');

