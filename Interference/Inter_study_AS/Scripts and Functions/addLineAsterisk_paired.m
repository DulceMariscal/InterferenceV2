function addLineAsterisk_paired(f,hb,h,p)

dy=0.2;
dx=0.4;

figure(f)


x=cell2mat(get(hb,'Xdata'));
y=cell2mat(get(hb,'Ydata'));
xcenter = 0.5*(x(2:4:end,:) +  x(3:4:end,:));
ytop = y(2:4:end,:); 
xcenter=xcenter';
ytop=ytop';

hold on
YLIM=ylim();
yheight=YLIM(2);
% if yheight==0
%    yheight=0.03/1.03;
% end
ntests=length(h);

for test=1:ntests
    xinterval=xcenter(test,:);
    d=diff(xinterval);    %Distance between centers
    a=xinterval(1) - d/2; %Left extremum (?) 
    b=xinterval(2) + d/2; %Right extremum(?)
    
    %Add Line
    hold on
    plot([a b], yheight*ones(1,2), 'k', 'LineWidth', 3);
    plot([a a], [yheight*0.99 yheight], 'k', 'LineWidth', 3);
    plot([b b], [yheight*0.99 yheight], 'k', 'LineWidth', 3);
    
    %Add pvalue if provided
    if ~isempty(p)
%         text(a,yheight*1.03, ['pval = ' num2str(p(test),'%10.2e\n')], 'Color','black','FontSize',12);
        text(a+d/2,yheight*1.03, ['pval = ' num2str(p(test),'%.2f\n')], 'Color','black','FontSize',12);
    end
    %Add star where h==1
    if h(test)==1
        text(a+d/2,yheight*1.03,'*','FontSize',25);
    end
    
end



% axis tight;


end

