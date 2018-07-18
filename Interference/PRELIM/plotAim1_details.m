%% AIM1 DETAILS

clc
close all
clear all

ADAPTATION_PLOTS=1;
FILL_AREA=1;
mspace=0.05;
stopFill=200; %Do not fill last 200 samples
% colors={'b','k','r'};
kcol={'k','k','g'};
col={'r','k','g'};
m=[0.07 0.07];
ANA=[zeros(1,150), ones(1,600), zeros(1,600), ones(1,600)];
BNA=[zeros(1,150), -1*ones(1,600), linspace(-1,0,600), ones(1,600)];
BGNA=[zeros(1,150), -1*ones(1,600), zeros(1,600), ones(1,600)];
mcol=[0    0.4470    0.7410;    0.8500    0.3250    0.0980;    0.9290    0.6940    0.1250];

f2=figure;

%%
YLIM=[-1.1 1.1];

%% AIM 1
f1=figure;

%% GROUP1---------------------------------------------------------------------
subplot_tight(3,1,1,m);
ph(1)=plot(ANA,'ks');
hold on

%Adaptation curve
nsamples=600; sp=1;
pars=[1 -1 160];
[tfit, dataFit]=get_exp2(pars,[150 150+nsamples],nsamples,sp);
hold on
if ADAPTATION_PLOTS
    ph(2)=plot(tfit,dataFit,'--','LineWidth',2,'Color',[0.5 0.5 0.5]);
    if FILL_AREA
        my_fill(tfit(1:end-1),ones(1,nsamples),dataFit(1:end-1),mcol(1,:),mspace,stopFill)
    end
end
figure(f2)
plot(dataFit,'--','LineWidth',2,'Color',[0.5 0.5 0.5]);
figure(f1)
% %De-adaptation curve
% pars=[0 1 150];
% [tfit, dataFit]=get_exp2(pars,[750 750+600],600,sp);
% hold on
% plot(tfit,dataFit,'LineWidth',2,'Color',mcol(2,:));

%Re-adptation curve
nsamples=600; sp=1;
pars=[1 -1 50];
[tfit, dataFit]=get_exp2(pars,[1350 1350+600],600,sp);
hold on
if ADAPTATION_PLOTS
    ph(3)=plot(tfit,dataFit,'LineWidth',2,'Color',mcol(1,:));
end
figure(f2)
hold on
plot(dataFit,'LineWidth',2,'Color',mcol(1,:));

figure(f1)
hold on
yl(1)=ylabel('Perturbation');
grid on
axis tight
ylim(YLIM)
l(1)=legend('Perturbation','Adaptation NAIVE','Env-induced Errors','Adaptation ENV');



%% GROUP2---------------------------------------------------------------------
subplot_tight(3,1,2,m);
% my3col_plot(BGNA,col);
plot(BGNA,'ks')
yl(3)=ylabel('Perturbation');

%Error curve
pars=[-1, 0, 160];
[tfit, dataFit]=get_exp3(pars,[750 750+nsamples],nsamples,sp);
hold on
if ADAPTATION_PLOTS
    plot(tfit,dataFit,'--','LineWidth',2,'Color','k');
    if FILL_AREA
        my_fill(tfit(1:end-1),zeros(1,nsamples),dataFit(1:end-1),mcol(2,:),mspace,stopFill)
    end
end
%Re-adptation curve
nsamples=600; sp=1;
pars=[1 -1 70];
[tfit, dataFit]=get_exp2(pars,[1350 1350+600],600,sp);
hold on
if ADAPTATION_PLOTS
    plot(tfit,dataFit,'LineWidth',2,'Color',mcol(2,:));
end
l(3)=legend('Perturbation','De-adaptation SELF','Self-induced Errors','Adaptation SELF');

figure(f2)
hold on
plot(dataFit,'LineWidth',2,'Color',mcol(2,:));
figure(f1);

grid on
axis tight
ylim(YLIM)

% t(2)=title('BNA group');

%% GROUP 3---------------------------------------------------------------------
subplot_tight(3,1,3,m);
plot(BNA,'ks')
% my3col_plot(BNA,col);
yl(2)=ylabel('Perturbation');
grid on
axis tight
ylim(YLIM)
xl(1)=xlabel('Strides');

%Re-adptation curve
nsamples=600; sp=1;
pars=[1 -1 150];
[tfit, dataFit]=get_exp2(pars,[1350 1350+600],600,sp);
hold on
if ADAPTATION_PLOTS
    
    plot(tfit,dataFit,'LineWidth',2,'Color',mcol(3,:));
end
% t(2)=title('BGNA group');
l(2)=legend('Perturbation','Adaptation BGNA group');

figure(f2)
hold on
plot(dataFit,'LineWidth',2,'Color',mcol(3,:));
figure(f1);

%%
figure(f2)
ll=legend('Adaptation NAIVE','Adaptation ENV','Adaptation SELF','Adaptation CONTROL');
xll=xlabel('Strides');
yll=ylabel('Perturbation');

xl=[xl xll];
yl=[yl yll];
l=[l ll];



%% INCREASE FONT SIZE
mySetFontSize([xl, l, yl], 18);
% mySetFontSize([t], 20);





