clc
close all
clear all

% colPerts=[[51, 153, 51]/256;  0.9290    0.6940    0.1250]; %Externally induced VS Sekf-induces
colPerts=[0    0.4470    0.7410;    0.8500    0.3250    0.0980];
mcol=[0    0.4470    0.7410;    0.8500    0.3250    0.0980;    0.9290    0.6940    0.1250];
mstyles={'--','-'};
% colors={'b','k','r'};
kcol={'k','k','g'};
col={'r','k','g'};
m=[0.07 0.07];
ANA=[zeros(1,150), ones(1,600), zeros(1,600), ones(1,600)];
BNA=[zeros(1,150), -1*ones(1,600), linspace(-1,0,600), ones(1,600)];
BGNA=[zeros(1,150), -1*ones(1,600), zeros(1,600), ones(1,600)];

%%
YLIM=[-1.1 1.1];

%% AIM 1
figure

subplot_tight(3,1,1,m);
plot(ANA,'ks')
hold on 

%Adaptation curve
nsamples=600; sp=1;
pars=[1 -1 150];
[tfit, dataFit]=get_exp2(pars,[150 150+600],600,sp);
hold on
plot(tfit,dataFit,'LineWidth',2,'Color',mcol(1,:));

%De-adaptation curve
pars=[0 1 150];
[tfit, dataFit]=get_exp2(pars,[750 750+600],600,sp);
hold on
plot(tfit,dataFit,'LineWidth',2,'Color',mcol(2,:));

%Re-adptation curve
nsamples=600; sp=1;
pars=[1 -1 50];
[tfit, dataFit]=get_exp2(pars,[1350 1350+600],600,sp);
hold on
plot(tfit,dataFit,'LineWidth',2,'Color',mcol(3,:));

% my3col_plot(ANA,col);
yl(1)=ylabel('Perturbation');
t(1)=title('Paradigms Aim 1');
% l(1)=legend('ANA');
grid on
axis tight
ylim(YLIM)
xl(3)=xlabel('Strides');
l(1)=legend('Perturbation','Adaptation','De-adaptation','Re-adaptation');


subplot_tight(3,1,2,m);
my3col_plot(BNA,col);
yl(2)=ylabel('Perturbation');
l(2)=legend('BNA');
grid on
axis tight
ylim(YLIM)


subplot_tight(3,1,3,m);
% my3col_plot(BGNA,col);
plot(BGNA,'ks')

yl(3)=ylabel('Perturbation');
% l(3)=legend('BGNA');

%Adaptation curve
nsamples=600; sp=1;
pars=[-1 1 150];
[tfit, dataFit]=get_exp2(pars,[150 150+600],600,sp);
hold on
plot(tfit,dataFit,'LineWidth',2,'Color',mcol(1,:));

%De-adaptation curve
pars=[0 -1 150];
[tfit, dataFit]=get_exp2(pars,[750 750+600],600,sp);
hold on
plot(tfit,dataFit,'LineWidth',2,'Color',mcol(2,:));

%Re-adptation curve
nsamples=600; sp=1;
pars=[1 -1 50];
[tfit, dataFit]=get_exp2(pars,[1350 1350+600],600,sp);
hold on
plot(tfit,dataFit,'LineWidth',2,'Color',mcol(3,:));

l(3)=legend('Perturbation','Adaptation','De-adaptation','Re-adaptation');


grid on
axis tight
ylim(YLIM)
xl(1)=xlabel('Strides');


%% AIM 2
xl=[];
figure
z150=zeros(1,150);
z300=zeros(1,300);
z900=zeros(1,900);
a300=ones(1,300);
b300=-1*ones(1,300);
g10=linspace(1,0,600);
g1m1=linspace(1,-1,1200);

AGNA=[z150 a300 g10 z150 a300 g10 z150 a300 g10 z150 a300 g10 z150 a300 g10]; n1=length(AGNA);
AGBA=[z150 a300 g1m1 b300 a300 g1m1 b300 a300 g10]; n2=length(AGBA);
AGBNA=[z150 a300 g1m1 b300 z300 a300 g1m1 b300 z300 a300 g10]; n3=length(AGBNA);

DAY2=[z150, a300]; n4=length(DAY2);
Break=1000;
hold on

%% GROUP 1----------------------------------------------------------------
subplot_tight(2,1,1,m);
pl1(1)=plot(AGNA,'ks')
% my3col_plot2(AGNA,kcol);

%Adaptation curve
nsamples=300; sp=1;
pars=[1 -1 150];
[tfit, dataFit]=get_exp2(pars,[150 150+nsamples],nsamples,sp);
hold on
pl1(2)=plot(tfit,dataFit,'LineWidth',2,'Color',mcol(1,:),'LineStyle',mstyles{1});

% t(2)=title('Paradigms Aim 2');
% l(4)=legend('AGNA');
grid on
indDay2=n1+Break:n1+Break+n4;
col={'k','k','k'};
my3col_plot(DAY2,col,indDay2)
startA2=n1+Break+150;

%Re-adptation curve
nsamples=300; sp=1;
pars=[1 -1 100];
[tfit, dataFit]=get_exp2(pars,[startA2 startA2+nsamples],nsamples,sp);
hold on
pl1(3)=plot(tfit,dataFit,'LineWidth',2,'Color',mcol(1,:),'LineStyle',mstyles{2});
% l(4)=legend(pl,'Perturbation', 'Day-1 Adaptation', 'Day-2 Adaptation');

axis tight
ylim(YLIM)
yl(4)=ylabel('Perturbation');
% xl(4)=xlabel('Strides');

% %% GROUP 2----------------------------------------------------------------
% subplot_tight(1,3,2,m);
% pl(1)=plot(AGBA,'ks');
% my3col_plot2(AGBA,kcol);
% % l(5)=legend('AGBA');
% grid on
% indDay2=n2+Break:n2+Break+n4;
% my3col_plot(DAY2,col,indDay2)
% axis tight
% ylim(YLIM)
% 
% %Adaptation curve
% nsamples=300; sp=1;
% pars=[1 -1 150];
% [tfit, dataFit]=get_exp2(pars,[150 150+nsamples],nsamples,sp);
% hold on
% pl(2)=plot(tfit,dataFit,'LineWidth',2,'Color',mcol(1,:));
% 
% %Re-adptation curve
% nsamples=300; sp=1;
% pars=[1 -1 50];
% [tfit, dataFit]=get_exp2(pars,[5300 5300+nsamples],nsamples,sp);
% hold on
% pl(3)=plot(tfit,dataFit,'LineWidth',2,'Color',mcol(3,:));
% % l(5)=legend(pl,'Perturbation', 'Day-1 Adaptation', 'Day-2 adaptation');
% % yl(5)=ylabel('Perturbation');
% xl(3)=xlabel('Strides');

%% GROUP 3----------------------------------------------------------------
subplot_tight(2,1,2,m);
pl2(1)=plot(AGBNA,'ks')
% my3col_plot2(AGBNA,kcol);
% l(6)=legend('AGBNA');
grid on
indDay2=n3+Break:n3+Break+n4;
my3col_plot(DAY2,col,indDay2)
xl(1)=xlabel('Strides');
axis tight
ylim(YLIM)

%Adaptation curve
nsamples=300; sp=1;
pars=[1 -1 150];
[tfit, dataFit]=get_exp2(pars,[150 150+nsamples],nsamples,sp);
hold on
pl2(2)=plot(tfit,dataFit,'LineWidth',2,'Color',mcol(2,:),'LineStyle',mstyles{1});

%Re-adptation curve
nsamples=300; sp=1;
pars=[1 -1 50];
[tfit, dataFit]=get_exp2(pars,[startA2 startA2+nsamples],nsamples,sp);
hold on
pl2(3)=plot(tfit,dataFit,'LineWidth',2,'Color',mcol(2,:),'LineStyle',mstyles{2});
% l(6)=legend(pl,'Perturbation', 'Day-1 Adaptation', 'Day-2 adaptation');
yl(5)=ylabel('Perturbation');




%% CHANGE COLORS
% colPerts=[[51, 153, 51]/256;  0.9290    0.6940    0.1250]; %Externally induced VS Sekf-induces

%GROUP 1
subplot_tight(2,1,1,m);
ind1=find(AGNA==1);
n1=length(AGNA);
vec=1:n1;
pl1(4)=plot(vec(ind1),AGNA(ind1),'s','Color',colPerts(1,:));
l(4)=legend(pl1,'Perturbation', 'Day-1 Adaptation', 'Day-2 Adaptation','Ext-Ind Errors');


%GROUP 2
subplot_tight(2,1,2,m);
%Find externally induced
ind1=find(AGBNA==1);
n1=length(AGBNA);
vec=1:n1;
pl2(4)=plot(vec(ind1),AGBNA(ind1),'s','Color',colPerts(1,:));


%Find sewlf-induced
ind1=find(AGBNA==0);
ind1=ind1(151:end-1);
n1=length(AGBNA);
vec=1:n1;
pl2(5)=plot(vec(ind1),AGBNA(ind1),'s','Color',colPerts(2,:));


l(5)=legend(pl2,'Perturbation', 'Day-1 Adaptation', 'Day-2 Adaptation','Env-Ind Errors','Self-Ind Errors');









%% INCREASE FONT SIZE
mySetFontSize([xl, l, yl], 18);
mySetFontSize([t], 20);


