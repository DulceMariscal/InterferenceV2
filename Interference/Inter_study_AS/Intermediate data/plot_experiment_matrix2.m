function  plot_experiment_matrix2(iA1m, iA2m, sA1m, sA2m, fit_iA1m, fit_iA2m, fit_sA1m, fit_sA2m,fname, tau, PV)

INT = 1; SAV = 2;
DATA = 2; FIT = 1;
A1=1;  A2=2;
myStyles = {'-', 'o'; '--', '*'};
myColors2=[0.8500    0.3250    0.0980; 0    0.4470    0.7410]; %Interference, Savings
SS1 = 5; SS2 = 15; TH = 70;
nia1 = length(iA1m); nia2 = length(iA2m); nsa1 = length(sA1m); nsa2 = length(sA2m);

xia1 = my_subsample2(SS1, SS2, TH, nia1);
xia2 = my_subsample2(SS1, SS2, TH, nia2);
xsa1 = my_subsample2(SS1, SS2, TH, nsa1);
xsa2 = my_subsample2(SS1, SS2, TH, nsa2);

f=figure('NumberTitle', 'off', 'Name', [fname ' - Data & Fits ' ]);


%% 1.st Row. Groups overlapped DATA
% A1-----------------------------------------------------------------------
subplot(2,2,1) %A1 sav int
plot(xia1,iA1m(xia1),myStyles{A1,DATA},'Color',myColors2(INT,:));
hold on
plot(xsa1,sA1m(xsa1),myStyles{A1,DATA},'Color',myColors2(SAV,:));
hold on
p3=plot(xia1,fit_iA1m(xia1),myStyles{A1,FIT},'Color',myColors2(INT,:));
hold on
p4=plot(xsa1,fit_sA1m(xsa1),myStyles{A1,FIT},'Color',myColors2(SAV,:));


legend('Int Data','Sav Data','Int Fit','Sav Fit')
title('A1')
uistack(p3, 'top'); uistack(p4, 'top')

% A2-----------------------------------------------------------------------
subplot(2,2,2) 
plot(xia2,iA2m(xia2),myStyles{A2,DATA},'Color',myColors2(INT,:));
hold on
plot(xsa2,sA2m(xsa2),myStyles{A2,DATA},'Color',myColors2(SAV,:));
hold on
p3=plot(xia2,fit_iA2m(xia2),myStyles{A2,FIT},'Color',myColors2(INT,:));
hold on
p4=plot(xsa2,fit_sA2m(xsa2),myStyles{A2,FIT},'Color',myColors2(SAV,:));


legend('Int Data','Sav Data','Int Fit','Sav Fit')
title('A2')
uistack(p3, 'top'); uistack(p4, 'top');

%% 2nd Row. Conditions overlapped DATA
% INT
subplot(2,2,3) %A1 sav int
plot(xia1,iA1m(xia1),myStyles{A1,DATA},'Color',myColors2(INT,:));
hold on
p3=plot(xia1,fit_iA1m(xia1),myStyles{A1,FIT},'Color',myColors2(INT,:));
hold on
plot(xia2,iA2m(xia2),myStyles{A2,DATA},'Color',myColors2(INT,:));
hold on
p4=plot(xia2,fit_iA2m(xia2),myStyles{A2,FIT},'Color',myColors2(INT,:));
hold on

legend('A1 Data',['A1 Fit ( \tau = ' num2str(tau(INT,A1),'%.2f') ' )'] ,'A2 Data',['A2 Fit (\tau = ' num2str(tau(INT,A2),'%.2f') ' )']);
title(['Interference ( PV = ' num2str(100*PV(INT),'%.2f') ' %)'])
uistack(p3, 'top'); uistack(p4, 'top');


% SAV
subplot(2,2,4) %A1 sav int
plot(xsa1,sA1m(xsa1),myStyles{A1,DATA},'Color',myColors2(SAV,:));
hold on
p3=plot(xsa1,fit_sA1m(xsa1),myStyles{A1,FIT},'Color',myColors2(SAV,:));
hold on
plot(xsa2,sA2m(xsa2),myStyles{A2,DATA},'Color',myColors2(SAV,:));
hold on
p4=plot(xsa2,fit_sA2m(xsa2),myStyles{A2,FIT},'Color',myColors2(SAV,:));
hold on

legend('A1 Data',['A1 Fit ( \tau = ' num2str(tau(SAV,A1),'%.2f') ' )'] ,'A2 Data',['A2 Fit (\tau = ' num2str(tau(SAV,A2),'%.2f') ' )']);
title(['Savings ( PV = ' num2str(100*PV(SAV),'%.2f') ' %)'])
uistack(p3, 'top'); uistack(p4, 'top');

end