function addStd(f, hb, group, ibar, stdval)

figure(f);


x=cell2mat(get(hb,'Xdata'));
y=cell2mat(get(hb,'Ydata'));
xcenter = 0.5*(x(2:4:end,:) +  x(3:4:end,:));
ytop = y(2:4:end,:);
xcenter=xcenter';
ytop=ytop';

for i=1:length(group)
    cgr=group(i);
    for j=1:length(ibar)
        cibar=ibar(j);
        hold on
        
        if numel(stdval)==1
            errorbar(xcenter(cgr,cibar),ytop(cgr,cibar),stdval,'k.','LineWidth',2)
        else            
            errorbar(xcenter(cgr,cibar),ytop(cgr,cibar),stdval(cgr,cibar),'k.','LineWidth',2)
        end
    end
    axis tight;
    
end