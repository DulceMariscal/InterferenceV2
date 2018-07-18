function addInddividualData(f, hb, group, ibar, data,labels_savings,labels_interf)

figure(f);


x=cell2mat(get(hb,'Xdata'));
y=cell2mat(get(hb,'Ydata'));
xcenter = 0.5*(x(2:4:end,:) +  x(3:4:end,:));
ytop = y(2:4:end,:);
xcenter=xcenter';
ytop=ytop';

nos=size(data,2); %This only works if there are the same number of subjects in the two groups. In the next version cell array + subjects labels
labels_int=cell(1,nos);
labels_sav=cell(1,nos);
for i=1:nos
    
end
for i=1:length(group)
    cgr=group(i);
    for j=1:length(ibar)
        cibar=ibar(j);
        hold on
        
        %         plot(xcenter(cgr,cibar),data(cgr,:,cibar),'o');
        if cibar==1
            text(xcenter(cgr,cibar)*ones(1,nos),data(cgr,:,cibar),labels_savings,'FontWeight','bold','BackgroundColor',[.7 .9 .7]);
        else
            text(xcenter(cgr,cibar)*ones(1,nos),data(cgr,:,cibar),labels_interf,'FontWeight','bold','BackgroundColor',[.7 .9 .7]);
        end
        %         mean(data(cgr,:,cibar))
    end
    axis tight;
    
end


end

