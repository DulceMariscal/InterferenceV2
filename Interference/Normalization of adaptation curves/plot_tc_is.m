function   plot_tc_is(NOS, NOSnorm, NOScrossnorm)

all_tau = cat(4, NOS, NOSnorm, NOScrossnorm);
[ngr, nsub, ncond, nkinds] = size(all_tau);

figure

for group=1:ngr
    for cond=1:ncond
        cdata = all_tau(group, :, cond, :);
        index = cond + (group-1)*ngr ;
        subplot(2,2,index)
        my_plot_dots(squeeze(cdata))
        
        if index==1
           title('A1') 
           ylabel('INTERFERENCE','fontweight','bold');
        end
        if index==2
            title('A2')
        end
        if index==3
            ylabel('SAVINGS','fontweight','bold');
        end
            
        
    end
end




end