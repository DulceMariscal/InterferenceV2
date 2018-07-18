function     plot_norm_curves_all_IC(all_curves,all_curves_norm,all_curves_crossnorm)
grStrings={'I','S'};
dims = size(all_curves);
xlab='Strides';
ylab_ca = cell(2,2,2);
ylab_ca(1,1,:) = {'A1 Original Curve', ' A1 Normalized Curve'};
ylab_ca(1,2,:) = {'A2 Original Curve', ' A2 Normalized Curve'};
ylab_ca(2,1,:) = {'A1 Original Curve', ' A1 Cross-Normalized Curve'};
ylab_ca(2,2,:) = {'A2 Original Curve', ' A2 Cross-Normalized Curve'};
ylim2=[0 1];

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

        %% 2. Plot curves
        %A1 norm
        p  = [2 2 1]; %Parameters for subplot
        ylim1 = [min(A1) max(A1)];
        two_axes_plot(fh, p, A1, A1norm, ylab_ca{1,1,1} , ylab_ca{1,1,2} , xlab , ylim1, ylim2);
        
        %A1 crossnorm
        p  = [2 2 3]; %Parameters for subplot
        ylim1 = [min(A1) max(A1)];
        two_axes_plot(fh, p, A1, A1crossnorm, ylab_ca{2,1,1} , ylab_ca{2,1,2} , xlab , ylim1, ylim2);
        
        %A2 norm
        p  = [2 2 2]; %Parameters for subplot
        ylim1 = [min(A2) max(A2)];
        two_axes_plot(fh, p, A2, A2norm, ylab_ca{1,2,1} , ylab_ca{1,2,2} , xlab , ylim1, ylim2);
        
        %A2 cross norm
        p  = [2 2 4]; %Parameters for subplot
        ylim1 = [min(A2) max(A2)];
        two_axes_plot(fh, p, A2, A2crossnorm, ylab_ca{2,2,1} , ylab_ca{2,2,2} , xlab , ylim1, ylim2);
        
    end
end



end