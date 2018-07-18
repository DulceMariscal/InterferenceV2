function my_plot_curve_and_data2(m_curves,fitCurves,tau,PV,indSubplot,cylim,cylabel,... %These change at every iteration
    subplotPar,lstyles,mcolors,SAV,INT,A1,A2,DATA,FIT,samplingStride,margins,SE) %Fixed

sp1 = subplotPar(1);
sp2 = subplotPar(2);

%% 8.1 A1 - Data and Fit

subplot_tight(sp1,sp2,indSubplot,margins)
hold on
yVec = m_curves{SAV,A1};
xVec = 1:length(yVec);
errorbar(xVec, yVec, SE{SAV,A1} ,lstyles{DATA},'Color',mcolors(SAV,:));
hold on
xlim([0 600])
yVec = m_curves{INT,A1};
xVec = 1:length(yVec);
errorbar(xVec, yVec, SE{INT,A1}, lstyles{DATA},'Color',mcolors(INT,:));
xlim([0 600])


ylabel(cylabel);
% sav_leg = ['Sav - Fit \tau = '  num2str(tau(SAV,A1),'%.2f') ' str '];
% int_leg = ['Int - Fit \tau = '  num2str(tau(INT,A1),'%.2f') ' str '];
legend('Sav-Data','Int-Data')

hold on
ylim(cylim)



%% 8.2 A2 - Data and fit
subplot_tight(sp1,sp2,indSubplot+1,margins)
hold on
yVec = m_curves{SAV,A2};
xVec = 1:length(yVec);

errorbar(xVec,yVec,SE{SAV,A2},lstyles{DATA},'Color',mcolors(SAV,:));
hold on
yVec = m_curves{INT,A2};
xVec = 1:length(yVec);
xlim([0 600])

errorbar(xVec,yVec,SE{INT,A2},lstyles{DATA},'Color',mcolors(INT,:));
% 
% 
% sav_leg = ['Sav - Fit \tau = '  num2str(tau(SAV,A2),'%.2f') ' str '];
% int_leg = ['Int - Fit \tau = '  num2str(tau(INT,A2),'%.2f') ' str '];
legend('Sav-Data','Int-Data')

ylim(cylim)
xlim([0 600])

%% ADD PV
% myText={['PV_{Int} = ' num2str(100*PV(INT),'%.2f') '%'], ['PV_{Sav} = ' num2str(100*PV(SAV),'%.2f') '%']};
% text(0.3,0.2,myText,'Units','normalized','FontSize',18)


end