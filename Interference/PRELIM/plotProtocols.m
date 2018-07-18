clc
close all
clear all

% colors={'b','k','r'};
col={'r','k','g'};
m=[0.07 0.07];
ANA=[zeros(1,150), ones(1,600), zeros(1,600), ones(1,600)];
BNA=[zeros(1,150), -1*ones(1,600), linspace(-1,0,600), ones(1,600)];
BGNA=[zeros(1,150), -1*ones(1,600), zeros(1,600), ones(1,600)];

%%
YLIM=[-1.1 1.1];

%% AIM 1
figure

subplot_tight(3,2,1,m);
plot(ANA,'ks')
hold on 

% %Adaptation curve
% nsamples=600; sp=1;
% pars=[1 -1 150];
% [tfit, dataFit]=get_exp2(pars,[150 150+600],600,sp);
% hold on
% plot(tfit,dataFit,'LineWidth',2);

% %Re-adptation curve
% nsamples=600; sp=1;
% pars=[1 -1 50];
% [tfit, dataFit]=get_exp2(pars,[1350 1350+600],600,sp);
% hold on
% plot(tfit,dataFit,'LineWidth',2);

my3col_plot(ANA,col);
yl(1)=ylabel('Perturbation');
t(1)=title('Paradigms Aim 1');
l(1)=legend('ANA');
grid on
axis tight
ylim(YLIM)
xl(3)=xlabel('Strides');
% l(1)=legend('Perturbation','Adaptation','Re-adaptation');


subplot_tight(3,2,3,m);
my3col_plot(BNA,col);
yl(2)=ylabel('Perturbation');
l(2)=legend('BNA');
grid on
axis tight
ylim(YLIM)

subplot_tight(3,2,5,m);
my3col_plot(BGNA,col);
yl(3)=ylabel('Perturbation');
l(3)=legend('BGNA');
grid on
axis tight
ylim(YLIM)
xl(1)=xlabel('Strides');


%% AIM 2
z150=zeros(1,150);
z300=zeros(1,300);
z900=zeros(1,900);
a300=ones(1,300);
b300=-1*ones(1,300);
g10=linspace(1,0,600);
g1m1=linspace(1,-1,1200);

AGNA=[z150 a300 g10 z900 a300 g10 z900 a300 g10]; n1=length(AGNA);
AGBA=[z150 a300 g1m1 b300 a300 g1m1 b300 a300 g10]; n2=length(AGBA);
AGBNA=[z150 a300 g1m1 b300 z300 a300 g1m1 b300 z300 a300 g10]; n3=length(AGBNA);

DAY2=[z150, a300]; n4=length(DAY2);
Break=500;
hold on
subplot_tight(3,2,2,m);
my3col_plot(AGNA,col);
t(2)=title('Paradigms Aim 2');
l(4)=legend('AGNA');
grid on
indDay2=n1+Break:n1+Break+n4;
my3col_plot(DAY2,col,indDay2)
axis tight
ylim(YLIM)

subplot_tight(3,2,4,m);
my3col_plot(AGBA,col);
l(5)=legend('AGBA');
grid on
indDay2=n2+Break:n2+Break+n4;
my3col_plot(DAY2,col,indDay2)
axis tight
ylim(YLIM)

subplot_tight(3,2,6,m);
my3col_plot(AGBNA,col);
l(6)=legend('BGNA');
grid on
indDay2=n3+Break:n3+Break+n4;
my3col_plot(DAY2,col,indDay2)
xl(2)=xlabel('Strides');
axis tight
ylim(YLIM)

mySetFontSize([xl yl], 18);
mySetFontSize([t], 20);


