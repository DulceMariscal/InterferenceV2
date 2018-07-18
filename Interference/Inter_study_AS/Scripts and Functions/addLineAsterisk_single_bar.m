function addLineAsterisk_single_bar(fh,hb,H,P) %Should be fused with the other fcn

dy=0.2;
dx=0.4;
yDil=1.05;
ySh=[0.9 0.85];
figure(fh)


x=cell2mat(get(hb,'Xdata'));
y=cell2mat(get(hb,'Ydata'));
xcenter = 0.5*(x(2:4:end,:) +  x(3:4:end,:));
ytop = y(2:4:end,:); 
xcenter=xcenter';
ytop=ytop';
YLIM=ylim();
yheight=YLIM(2);

hold on


%% Add pvalues
[nr,nc]=size(P);
for r=1:nr
   for c=1:nc
       %Add p-value
       text(xcenter(r,c), yheight*ySh(c), ['pval = ' num2str(P(r,c),'%.2f\n')], 'Color','black','FontSize',12)
       if H(r,c)==1 % If we reject H0
            %Add asterisk
            plot(xcenter(r,c),yheight*(ySh(c)),'*k','MarkerSize',12);
       end
   end
end
% for test=1:n
%     indCol=
%     text(xcenter());
%     xinterval=xcenter(test,:);
%     d=diff(xinterval);    %Distance between centers
%     a=xinterval(1) - d/2; %Left extremum (?) 
%     b=xinterval(2) + d/2; %Right extremum(?)
%     
%     %Add Line
%     hold on
%     plot([a b], yheight*ones(1,2), 'k', 'LineWidth', 3);
%     plot([a a], [yheight*0.99 yheight], 'k', 'LineWidth', 3);
%     plot([b b], [yheight*0.99 yheight], 'k', 'LineWidth', 3);
%     
%     %Add pvalue if provided
%     if ~isempty(p)
% %         text(a,yheight*1.03, ['pval = ' num2str(p(test),'%10.2e\n')], 'Color','black','FontSize',12);
%         text(a+d/2,yheight*yDil, ['pval = ' num2str(p(test),'%.2f\n')], 'Color','black','FontSize',12);
%     end
%     %Add star where h==1
%     if h(test)==1
%         plot(mean(xinterval),yheight*1.05,'*k');
%     end
%     
% end



% axis tight;


end

