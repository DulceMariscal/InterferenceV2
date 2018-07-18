function     plot_average_curves(average_curves, norm_average_curves, cross_norm_average_curves,...
                                 tau, tau_norm, tau_cross_norm, PV, PVnorm, PVcrossnorm)
                             
alltau =  {tau, tau_norm, tau_cross_norm}; 
allPV =    {PV, PVnorm, PVcrossnorm};
allKinds = {average_curves, norm_average_curves, cross_norm_average_curves};
nkinds=3;

figure
for kind=1:nkinds
    %Extract current data
    ckind = allKinds{kind};
    ctau = alltau{kind};
    cPV = allPV{kind};
    
    for group=1:2
        cgroup = ckind(group,:);
        
        %Plot A1 vs A2
        index = (group-1)*nkinds + kind;
        subplot(2,3,index)
        plot(cgroup{1})
        hold on
        plot(cgroup{2})
        legend(['A1 (\tau = ' num2str(ctau(group,1),'%.2f') ' str )' ],...
               ['A2 (\tau = ' num2str(ctau(group,2),'%.2f') ' str )']);
        text(1,0,['PV = ' num2str(100*cPV(group),'%.2f') '%'],'units', 'normalized',...
            'HorizontalAlignment','right','VerticalAlignment','bottom','FontSize',20);
        if index>3
            xlabel('Strides')
        end
        if index==1
            title('Original')
            ylabel('INTERFERENCE','fontweight','bold')
        end
        if index==2
            title('Simple-Norm')
        end
        if index==3
            title('Cross-Norm')
        end
        if index ==4
            ylabel('SAVINGS','fontweight','bold')
        end
    end
end

end