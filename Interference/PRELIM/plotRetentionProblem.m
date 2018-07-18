%% RETENTION PROBLEMS
clc
close all
clear all

STUDY=3;

mcol=[0    0.4470    0.7410;    0.8500    0.3250    0.0980;    0.9290    0.6940    0.1250];

figure

%Adaptation curve
nsamples=600; sp=1;
pars=[0.7 0.9 150];
[tfit, dataFit]=get_exp3(pars,[0 nsamples],nsamples,sp);
hold on
plot(tfit,dataFit*100,'LineWidth',2,'Color',mcol(1,:));

pars=[0.75 0.9 140];
[tfit, dataFit]=get_exp3(pars,[0 nsamples],nsamples,sp);
hold on
plot(tfit,dataFit*100,'LineWidth',2,'Color',mcol(2,:));

hold on
line([0 nsamples],[1 1]*100,'Color',[0.5 0.5 0.5],'LineStyle','--')


xl=xlabel('Strides');
yl=ylabel('Symmetry [%]');
l=legend('Day 1 Adaptation','Day 2 Adaptation','Complete Symmetry');
t = title('Typical day to day retention of adapted locomotor pattern');
mySetFontSize([xl yl l], 18);
mySetFontSize([t], 20);


%% SLA groups
SLA_PLOT=1;
if STUDY==1
    taus=[67, 38, 57.33, 68]; %Study 1
    names={'NAIVE','ENV','SELF','CONTROL'};
    mcol=[0.5 0.5 0.5; 0    0.4470    0.7410;    0.8500    0.3250    0.0980;    0.9290    0.6940    0.1250];
    styles={'--','-','-','-'};
    sla1=[-.31 -.20 -.25 -.32];
    
elseif STUDY==2
    taus=[67, 67, 67*0.3, 67*0.2]; %Study 2
    names={'Naive_{ENV+ENV}','Naive_{ENV+SELF}','ENV+ENV','ENV+SELF'};
    styles={'--','--','-','-'};
    mcol=[0    0.4470    0.7410; .8500    0.3250    0.0980; 0    0.4470    0.7410; 0.8500    0.3250    0.0980];
    sla1=[-.3 -.32 -.25 -.2];
elseif STUDY==3
    taus=[67, 67, 67*0.3, 67*0.2]; %Study 2
    names={'Naive_{NORM+NORM}','Naive_{NORM+SLOW}','NORM+NORM','NORM+SLOW'};
    styles={'--','--','-','-'};
%     mcol=[0    0.4470    0.7410; .8500    0.3250    0.0980; 0    0.4470    0.7410; 0.8500    0.3250    0.0980];
    mcol=[0    0.4470    0.7410; [51, 153, 51]/256; 0    0.4470    0.7410; [51, 153, 51]/256];
    sla1=[-.3 -.32 -.25 -.2];
end
sla2=0;
% names={'Naive Adaptation','ANA Adaptation','BNA Adaptation','BGNA Adaptation'};


nsamples=600;
sp=1;
figure
n=length(taus);
for i=1:n
    pars=[sla1(i), sla2, taus(i)];
    [tfit, dataFit]=get_exp3(pars,[0 nsamples],nsamples,sp);
    hold on
    plot(tfit,dataFit,'LineStyle',styles{i},'LineWidth',2,'Color',mcol(i,:));
    
end
t=title('Expected Acquisition Performance');
% t=title('Expected Retention Performance');

xl=xlabel('Strides');
yl=ylabel('StepLengthAsymmetry');
l=legend(names);
mySetFontSize([xl yl l], 18);
mySetFontSize([t], 20);

%%
fhr=figure;
T=[taus;zeros(1,4);zeros(1,4);zeros(1,4)];
STD=[10 10 10 10; zeros(1,4); zeros(1,4); zeros(1,4)]./sqrt(18);
hb1=bar([T],'hist');
addStd(fhr, hb1, 1:n, [1:n], [STD] );

for i=1:n
    set(hb1(i),'FaceColor',mcol(i,:));
    set(hb1(i),'LineStyle',styles{i});
    set(hb1(i),'LineWidth',2);
    
end

t=title('Expected Time Constants');
xl=xlabel('Group');
yl=ylabel('Strides');
l=legend(names);
mySetFontSize([xl yl l], 18);
mySetFontSize([t], 20);
xlim([0.5 1.5])
% addStd(fhr, hb1, 1:2, [1 2], [[0.5 0]' zeros(2,1)] );
% addStd(fhr, hb2, 1:2, [1 2], [[0 0.5]'] );


