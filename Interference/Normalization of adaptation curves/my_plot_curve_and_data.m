function my_plot_curve_and_data(m_curves,fitCurves,tau,PV,indSubplot,cylim,cylabel,... %These change at every iteration
    subplotPar,lstyles,mcolors,SAV,INT,A1,A2,DATA,FIT,samplingStride,margins) %Fixed

sp1 = subplotPar(1);
sp2 = subplotPar(2);

%% 8.1 A1 - Data and Fit

subplot_tight(sp1,sp2,indSubplot,margins)
hold on
[xVec, yVec] = my_subsample(m_curves{SAV,A1},samplingStride);
plot(xVec, yVec,lstyles{DATA},'Color',mcolors(SAV,:));
hold on
[xVec, yVec] = my_subsample(m_curves{INT,A1},samplingStride);
plot(xVec, yVec,lstyles{DATA},'Color',mcolors(INT,:));
hold on
plot(fitCurves{SAV,A1},lstyles{FIT},'Color',mcolors(SAV,:));
hold on
plot(fitCurves{INT,A1},lstyles{FIT},'Color',mcolors(INT,:));

ylabel(cylabel);
sav_leg = ['Sav - Fit \tau = '  num2str(tau(SAV,A1),'%.2f') ' str '];
int_leg = ['Int - Fit \tau = '  num2str(tau(INT,A1),'%.2f') ' str '];
legend('Sav-Data','Int-Data',sav_leg,int_leg)

hold on
ylim(cylim)



%% 8.2 A2 - Data and fit
subplot_tight(sp1,sp2,indSubplot+1,margins)
hold on
[xVec, yVec] = my_subsample(m_curves{SAV,A2},samplingStride);
plot(xVec,yVec,lstyles{DATA},'Color',mcolors(SAV,:));
hold on
[xVec, yVec] = my_subsample(m_curves{INT,A2},samplingStride);
plot(xVec,yVec,lstyles{DATA},'Color',mcolors(INT,:));
hold on
plot(fitCurves{SAV,A2},lstyles{FIT},'Color',mcolors(SAV,:));
hold on
plot(fitCurves{INT,A2},lstyles{FIT},'Color',mcolors(INT,:));

sav_leg = ['Sav - Fit \tau = '  num2str(tau(SAV,A2),'%.2f') ' str '];
int_leg = ['Int - Fit \tau = '  num2str(tau(INT,A2),'%.2f') ' str '];
legend('Sav-Data','Int-Data',sav_leg,int_leg)

ylim(cylim)

%% ADD PV
myText={['PV_{Int} = ' num2str(100*PV(INT),'%.2f') '%'], ['PV_{Sav} = ' num2str(100*PV(SAV),'%.2f') '%']};
text(0.3,0.2,myText,'Units','normalized','FontSize',18)


end