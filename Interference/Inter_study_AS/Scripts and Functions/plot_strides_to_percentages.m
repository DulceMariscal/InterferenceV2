function [fh, cP, cH]=plot_strides_to_percentages(STRIDES_TO_PERCENTAGE,percentages,colInt,colSav,labels_savings,labels_interf,nos,INTERFERENCE,SAVINGS)
margins=[0.05 0.05];
A1=1;
A2=2;
ngroups=2;
nconds=2;
fh=figure;
F=100;

report_strings=num2cell(percentages);
report_strings{end}='0.5*range';
npr=length(percentages);
avg_as=zeros(ngroups,nconds,npr); %Averages across subjects
stderr_as=zeros(ngroups,nconds,npr); %Averages across subjects
allYlim=zeros(npr,2);

for group=1:ngroups %Interf VS Savings
    avg_as(group,:,:)    = mean(STRIDES_TO_PERCENTAGE{group},3);
    stderr_as(group,:,:) = std(STRIDES_TO_PERCENTAGE{group},0,3)/sqrt(nos(group));
end

for i=1:npr %For each selected parameter
%     cpr=REPORT_PARS(i);
    subplot_tight(1,npr,i,margins)    
    
    hb=bar([[avg_as(SAVINGS,A1,i) avg_as(SAVINGS,A2,i)]' [avg_as(INTERFERENCE,A1,i) avg_as(INTERFERENCE,A2,i)]'],'hist');
    addStd(fh, hb, 1:2, [1 2],[[stderr_as(SAVINGS,A1,i) stderr_as(SAVINGS,A2,i)]' [stderr_as(INTERFERENCE,A1,i) stderr_as(INTERFERENCE,A2,i)]'] );
    
    %Extract individual data
    sav_par=squeeze(STRIDES_TO_PERCENTAGE{SAVINGS}(1:2,i,:));
    int_par=squeeze(STRIDES_TO_PERCENTAGE{INTERFERENCE}(1:2,i,:));
%     addInddividualData(fh, hb, 1:2, [1 2], cat(3,sav_par,int_par),labels_savings,labels_interf);
    
    %Test differences and add results
    [cH, cP]=test_differences(sav_par,int_par,1,'unequal');
%     addLineAsterisk_paired(fhr,hb,cH,cP)
    
    set(gca,'XTickLabel',{'A1','A2'})
    legend('Savings group','Interference group')
    grid on
    set(hb(1),'FaceColor',colSav);
    set(hb(2),'FaceColor',colInt);
    ylabel(report_strings{i});
    xlabel('Adaptation')
    allYlim(i,:)=ylim();
    title(['pv_1 =' num2str(round(F*cP(1))/F) ' pv_2 =' num2str(round(F*cP(2))/F)]);
end

maxy=max(allYlim(:,2));
miny=min(allYlim(:,2));

for i=1:npr %For each selected parameter
    subplot_tight(1,npr,i,margins)    
    ylim([miny maxy]);
end





end




