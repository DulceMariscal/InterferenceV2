function plot_data_and_fit_all_curves(all_curves, all_curves_after_smoothing, SMOOTHINGS, selPar, ...
                                        R2s,RMSEs)
                                    
%% TODO:
% Generalize to make it able to plot every parameter you want for each subject!

%fitMeas contains R2, R2adj, RMSE
%indFitMeas is the mask of the fitmeas to print

[ng,ns,nc] = size(all_curves); %GROUP X SUBS X COND
nsm = size(all_curves_after_smoothing,4); %GROUP X SUBS X COND
groups={'Interference','Savings'};
margins=[0.05 0.03];
SS=15;
fontSize = 12; 
myGroupColors=[0.8500    0.3250    0.0980; 0    0.4470    0.7410]; %Interference, Savings
% myColors=[0 0 0; 0 0 0]; %Interference, Savings
myStylesFit={'-','--'}; % A1 solid, A2 dashed
myStylesData={'o','*'};  % A1 circles, A2 squares
h0=0.05;
D=0.05;

for sm=1:nsm
   figure('Name',['Par:' selPar ' - Smoothing:' SMOOTHINGS{sm}],'NumberTitle','off');
   
   for gr=1:ng
      for sub=1:ns
          for cond=1:nc
            
            data = all_curves{gr,sub,cond};
            indSS = 1:SS:length(data);
            sdata = all_curves_after_smoothing{gr, sub, cond, sm};
            subplot_tight(ng, ns, sub + (gr-1)*ns,margins)
            hold on
            plot(indSS,data(indSS),[myStylesData{cond}],'Color',myGroupColors(gr,:),'LineWidth',1);
            hold on
            fitH = plot(sdata,'Color',myGroupColors(gr,:),'LineStyle',myStylesFit{cond},'LineWidth',3);
            xlim([0 600])
            uistack(fitH, 'top')
            hold on
            
            if cond==1
                text(0.15, h0+3*D,['R^2(A1) = ' num2str(R2s(gr,sub,cond,sm),'%.3f')],'Units','Normalized','FontSize',fontSize)
                text(0.15, h0+2*D,['RMSE(A1) = ' num2str(RMSEs(gr,sub,cond,sm),'%.3f')],'Units','Normalized','FontSize',fontSize)
            else
                text(0.15, h0+D,['R^2(A2) = ' num2str(R2s(gr,sub,cond,sm),'%.3f')],'Units','Normalized','FontSize',fontSize)
                text(0.15, h0,['RMSE(A2) = ' num2str(RMSEs(gr,sub,cond,sm),'%.3f')],'Units','Normalized','FontSize',fontSize)
            end
          end
          
          if sub==1 && gr==1
              legend('Data A1','Sm A1','Data A2','Sm A2')
          end
          if sub==1
              ylabel([groups{gr}]);
          end
      end
   end   
%    set(gcf,'name',);

end
    
end