clc
close all
clear all

A=[0.90055 -0.008843 15.4741;
    0.93383 -0.0087527 14.3601;
    -0.031837 0.0016916 -1.1807];
models = {'SLA\_A1\_1  =  0.90055  - 0.008843 * Height  +  15.4741 * STD\_FIN';...
          'SLA\_A1\_1to5  =  0.93383 - 0.0087527 * Height  +  14.3601 * STD\_FIN';...
          'SLA\_DIFF\_L30  =  -0.031837  +  0.0016916 * Age - 1.1807 * STD\_DIFF'};
xlabels={'Height [cm]','Height [cm]','Age'};
ylabels={'STD FIN','STD FIN','STD DIFF'};
outcome_vars = {'SLA\_A1\_1', 'SLA\_A1\_1to5', 'SLA\_DIFF\_L30'} ;
nmodels=size(A,1);
RANGES = zeros(nmodels,2,2);
RANGES(1,:,:)=[150 200; .01 .03];
RANGES(2,:,:)=[150 200; .01 .03];
RANGES(3,:,:)=[18 40; -0.03 0.03];


for model=1:nmodels
    %% 3D PLOTS
    figure
    subplot(2,1,1)
    r1=RANGES(model,1,:);
    r2=RANGES(model,2,:);
    var1  = linspace(r1(1),r1(2),50);
    var2  = linspace(r2(1),r2(2),50);
    
    [VAR1,VAR2] = meshgrid(var1,var2);
    dims=size(VAR1);
    ONES = ones(dims);
    X=cat(3,ONES,VAR1, VAR2);
    SLA = A(model,1).*ONES + A(model,2).*VAR1 + A(model,3).*VAR2;
    surf(VAR1, VAR2, SLA)
    view(2)
    colorbar
    xlabel(xlabels{model})
    ylabel(ylabels{model})
    title(models{model});
    set(gca,'FontSize',20)
    axis tight
    % SLA_A1_1  =  0.90055  +  -0.008843 * Height  +  15.4741 * STD_FIN
    
    %% 2d Plots
    colors=colormap(jet);
    ncols=size(colors,1);
    subplot(2,1,2)
    std_fin_red = var2(1:5:end);
    nsel=length(std_fin_red);
    legends=cell(nsel,1);
    indcols=round(linspace(1,ncols,nsel));
    for i=1:nsel
        cs=std_fin_red(i);
        sla = A(model,1) + A(model,2)*var1 + A(model,3)*cs;
        hold on
        plot(var1,sla,'LineWidth',2,'Color',colors(indcols(i),:))
        legends{i}= [ylabels{model} ' = ' num2str(cs)];
        
    end
    ylabel({outcome_vars{model}})
    xlabel(xlabels{model})
    axis tight
    grid on
    legend(legends);
    set(gca,'FontSize',20)
end

