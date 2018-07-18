function     plot_norm_curves_all(all_curves,all_curves_norm,all_curves_crossnorm) 

grStrings={'I','S'};
dims = size(all_curves);
xlab='Strides';
ylab_ca = cell(2,2,2);
ylab_ca(1,1,:) = {'Original', 'Simple-Norm'};
ylab_ca(1,2,:) = {'Original', 'Simple-Norm'};
ylab_ca(2,1,:) = {'Origina',  'Cross-Norm'};
ylab_ca(2,2,:) = {'Original', 'Cross-Norm'};
ylim2=[0 1];

ti_or  = {'A1', 'A2', 'A1 vs A2', 'A1 vs A2 Normalized'}; %Titles
pp = [2 4];

for i=1:dims(1) %Groups
    for j=1:dims(2) %Subs
        
        %% 1. Exctract curves
        %A1
        A1 = all_curves{i,j,1};
        A1norm = all_curves_norm{i,j,1};
        A1crossnorm = all_curves_crossnorm{i,j,1};
        
        %A2
        A2 = all_curves{i,j,2};
        A2norm = all_curves_norm{i,j,2};
        A2crossnorm = all_curves_crossnorm{i,j,2};
        
        fh = figure('Name',[grStrings{i} num2str(j)], 'NumberTitle', 'off');

        %% 2. Plot Original VS normalized
        %A1 norm
        p  = [pp 1]; %Parameters for subplot
        ylim1 = [min(A1) max(A1)];
        two_axes_plot(fh, p, A1, A1norm, ylab_ca{1,1,1} , ylab_ca{1,1,2} , '' , ylim1, ylim2, ti_or{1});
        xlim([1 600])
        
        %A1 crossnorm
        p  = [pp 5]; %Parameters for subplot
        ylim1 = [min(A1) max(A1)];
        two_axes_plot(fh, p, A1, A1crossnorm, ylab_ca{2,1,1} , ylab_ca{2,1,2} , xlab , ylim1, ylim2, '');
        xlim([1 600])
        
        %A2 norm
        p  = [pp 2]; %Parameters for subplot
        ylim1 = [min(A2) max(A2)];
        two_axes_plot(fh, p, A2, A2norm, ylab_ca{1,2,1} , ylab_ca{1,2,2} , '' , ylim1, ylim2, ti_or{2});
        xlim([1 600])
        
        %A2 cross norm
        p  = [pp 6]; %Parameters for subplot
        ylim1 = [min(A2) max(A2)];
        two_axes_plot(fh, p, A2, A2crossnorm, ylab_ca{2,2,1} , ylab_ca{2,2,2} , xlab , ylim1, ylim2, '' );
        xlim([1 600])
        
        %% 3. Plot A1 vs A2
        subplot(pp(1), pp(2), 3)
        plot(A1,'o'); hold on; plot(A2,'o'); legend('A1', 'A2')
        title(ti_or{3});
        xlim([1 600])
        
        subplot(pp(1), pp(2), 4)
        plot(A1norm,'o'); hold on; plot(A2norm,'o'); legend('A1 norm', 'A2 norm')
        title(ti_or{4});
        xlim([1 600])
        
        subplot(pp(1), pp(2), 7)
        plot(A1,'o'); hold on; plot(A2,'o'); legend('A1','A2')
        xlabel('Strides')
        xlim([1 600])
        
        subplot(pp(1), pp(2), 8)
        plot(A1crossnorm,'o'); hold on; plot(A2crossnorm,'o'); legend('A1 Cross-Norm','A2 Cross-Norm')
        xlabel('Strides')
        xlim([1 600])

    end
end



end


